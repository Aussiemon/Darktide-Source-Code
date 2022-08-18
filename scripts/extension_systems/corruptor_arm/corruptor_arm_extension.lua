local Component = require("scripts/utilities/component")
local CorruptorPustule = require("scripts/settings/level_prop/props/corruptor_pustule")
local CorruptorSettings = require("scripts/settings/corruptor/corruptor_settings")
local CorruptorArmExtension = class("CorruptorArmExtension")
local SFX_ARM_EXTENDING_START = "wwise/events/world/play_corruptor_arm_extension_loop"
local SFX_ARM_EXTENDING_STOP = "wwise/events/world/stop_corruptor_arm_extension_loop"
local ARM_EXTENDING_PARTICLE_NAME = "content/fx/particles/enemies/corruptor/corruptor_arm_tip"

CorruptorArmExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._is_activated = false
	self._target_units = {}
	self._activation_delay = 0
	self._activation_delay_timer = 0
	self._animation_pos = 0
	self._animation_target = 0
	self._animation_speed = 0
	self._animation_speed_multiplier_type = nil
	self._arm_length = 0
	self._has_lost_pustules = false
	self._is_extending = false
	self._world = extension_init_context.world
	self._wwise_world = extension_init_context.wwise_world
end

CorruptorArmExtension.extensions_ready = function (self, world, unit)
	self._mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")
end

CorruptorArmExtension.setup_from_component = function (self, activation_delay, arm_length, corruptor_arm_component)
	self._arm_length = arm_length
	self._activation_delay = activation_delay
	self._corruptor_arm_component = corruptor_arm_component
end

CorruptorArmExtension.on_gameplay_post_init = function (self, level)
	Component.event(self._unit, "set_animation_pos", self._animation_pos)
end

CorruptorArmExtension.hot_join_sync = function (self, unit, sender, channel_id)
	local animation_target = self._animation_target

	if animation_target ~= 0 then
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local speed_multiplier_type_id = NetworkLookup.corruptor_arm_animation_speed_types[self._animation_speed_multiplier_type]

		RPC.rpc_set_animation_target(channel_id, unit_level_index, animation_target, speed_multiplier_type_id, self._animation_pos)
	end
end

CorruptorArmExtension.destroy = function (self)
	if self._is_server then
		local unit_spawner_manager = Managers.state.unit_spawner
		local target_units = self._target_units

		for i = 1, #target_units, 1 do
			local target_unit = target_units[i]

			unit_spawner_manager:mark_for_deletion(target_unit)
		end
	end

	if self._is_extending then
		self:_stop_extending()
	end
end

CorruptorArmExtension.activate = function (self)
	fassert(not self._is_activated, "[CorruptorArmExtension] Trying to activate twice!")

	if self._activation_delay > 0 then
		self._activation_delay_timer = self._activation_delay
	else
		self:set_animation_target(1, "spawn")
	end

	self._is_activated = true
end

CorruptorArmExtension.deactivate = function (self)
	fassert(self._is_activated, "[CorruptorArmExtension] Trying to deactivate twice!")

	if not self._has_lost_pustules then
		local unit_spawner_manager = Managers.state.unit_spawner
		local target_units = self._target_units

		for i = 1, #target_units, 1 do
			local target_unit = target_units[i]

			unit_spawner_manager:mark_for_deletion(target_unit)

			target_units[i] = nil
		end

		self._has_lost_pustules = true
	end

	self:set_animation_target(0, "retract")

	self._is_activated = false
end

CorruptorArmExtension.update = function (self, unit, dt, t)
	local target_units = self._target_units
	local num_target_units = #target_units

	if self._is_server and self._is_activated and num_target_units > 0 then
		local has_pustules = false
		local unit_spawner_manager = Managers.state.unit_spawner

		for i = num_target_units, 1, -1 do
			local target_unit = target_units[i]

			if HEALTH_ALIVE[target_unit] then
				has_pustules = true

				break
			end

			unit_spawner_manager:mark_for_deletion(target_unit)
			table.swap_delete(target_units, i)
		end

		if not has_pustules then
			Unit.flow_event(unit, "lua_pustules_dead")
			self._mission_objective_target_extension:remove_unit_marker()
			self:set_animation_target(0, "retract")

			self._has_lost_pustules = true
		end
	end

	self:_animation_update(unit, dt)
end

CorruptorArmExtension._animation_update = function (self, unit, dt)
	if self._activation_delay_timer > 0 then
		self._activation_delay_timer = self._activation_delay_timer - dt

		if self._activation_delay_timer <= 0 then
			self:set_animation_target(1, "spawn")

			self._activation_delay_timer = 0
		end
	end

	if math.abs(self._animation_speed) > 0 then
		if self._is_extending then
			self:_update_extending()
		end

		local animation_increment = dt * self._animation_speed

		if math.abs(self._animation_pos - self._animation_target) <= math.abs(animation_increment) then
			local animation_pos = self._animation_target
			self._animation_speed = 0
			self._animation_pos = animation_pos

			if animation_pos >= 1 then
				self:_fully_extended(unit)
			elseif animation_pos <= 0 then
				self:_fully_retracted()
			end
		else
			self._animation_pos = self._animation_pos + animation_increment
		end

		Component.event(self._unit, "set_animation_pos", self._animation_pos)
	end
end

CorruptorArmExtension.set_animation_target = function (self, target, speed_multiplier_type, optional_hot_join_animation_pos)
	local speed_multiplier = CorruptorSettings.animation_speed_multiplier[speed_multiplier_type]

	if type(speed_multiplier) == "table" then
		speed_multiplier = Managers.state.difficulty:get_table_entry_by_challenge(speed_multiplier)
	end

	self._animation_speed_multiplier_type = speed_multiplier_type
	self._animation_target = target
	self._animation_speed = (target - self._animation_pos) / math.lerp(1, self._arm_length, CorruptorSettings.animation_length_impact) * speed_multiplier
	local unit = self._unit

	if optional_hot_join_animation_pos then
		self._animation_pos = optional_hot_join_animation_pos

		Component.event(unit, "set_animation_pos", optional_hot_join_animation_pos)
	end

	if target > 0 then
		Unit.flow_event(unit, "lua_start_extending")
		self:_start_extending()
	else
		Unit.flow_event(unit, "lua_start_retracting")

		if self._is_extending then
			self:_stop_extending()
		end
	end

	if self._is_server then
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local speed_multiplier_type_id = NetworkLookup.corruptor_arm_animation_speed_types[speed_multiplier_type]

		Managers.state.game_session:send_rpc_clients("rpc_set_animation_target", unit_level_index, target, speed_multiplier_type_id)
	end
end

CorruptorArmExtension.has_lost_pustules = function (self)
	return self._has_lost_pustules
end

CorruptorArmExtension._fully_extended = function (self, unit)
	self._mission_objective_target_extension:add_unit_marker()
	Unit.flow_event(unit, "lua_fully_extended")

	if self._is_server then
		self:_spawn_targets(unit)
	end

	self:_stop_extending()
end

CorruptorArmExtension._start_extending = function (self)
	local position = self._corruptor_arm_component:last_joint_position()
	local source_id = WwiseWorld.make_manual_source(self._wwise_world, position, Quaternion.identity())

	WwiseWorld.trigger_resource_event(self._wwise_world, SFX_ARM_EXTENDING_START, source_id)

	self._source_id = source_id
	local particle_id = World.create_particles(self._world, ARM_EXTENDING_PARTICLE_NAME, position, Quaternion.identity())
	self._particle_id = particle_id
	self._is_extending = true
end

CorruptorArmExtension._stop_extending = function (self)
	WwiseWorld.trigger_resource_event(self._wwise_world, SFX_ARM_EXTENDING_STOP, self._source_id)
	WwiseWorld.destroy_manual_source(self._wwise_world, self._source_id)

	self._source_id = nil

	World.stop_spawning_particles(self._world, self._particle_id)

	self._particle_id = nil
	self._is_extending = false
end

CorruptorArmExtension._update_extending = function (self)
	local position = self._corruptor_arm_component:last_joint_position()

	WwiseWorld.set_source_position(self._wwise_world, self._source_id, position)
	World.move_particles(self._world, self._particle_id, position, Quaternion.identity())
end

CorruptorArmExtension._spawn_targets = function (self, unit)
	local unit_spawner_manager = Managers.state.unit_spawner
	local target_unit_name = CorruptorPustule.unit_name
	local target_units = self._target_units
	local destructible_count = CorruptorSettings.destructible_count
	local destructible_node_names = CorruptorSettings.destructible_node_names

	for i = 1, destructible_count, 1 do
		local node_name = destructible_node_names[i]
		local spawn_node = Unit.node(unit, node_name)
		local pustule_position = Unit.world_position(unit, spawn_node)
		local pustule_rotation = Unit.world_rotation(unit, spawn_node)
		local pustule_unit, _ = unit_spawner_manager:spawn_network_unit(target_unit_name, "level_prop", pustule_position, pustule_rotation, nil, CorruptorPustule)
		target_units[i] = pustule_unit
	end

	self._has_lost_pustules = false
end

CorruptorArmExtension._fully_retracted = function (self)
	if self._is_server and self._is_activated then
		self:set_animation_target(1, "regrowth")
	end
end

return CorruptorArmExtension
