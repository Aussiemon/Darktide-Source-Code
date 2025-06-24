-- chunkname: @scripts/components/shock_mine.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_keywords = BuffSettings.keywords
local RESOURCES = {
	vfx = {
		idle = "content/fx/particles/weapons/grenades/shock_mine/shock_mine_idle_01",
		to_target = "content/fx/particles/weapons/grenades/shock_mine/shock_mine_link_01",
	},
	sfx = {
		on_target = "wwise/events/weapon/play_adamant_shockmine_electric_hit",
		target_loop = {
			start = "wwise/events/weapon/play_adamant_shockmine_electric_loop",
			stop = "wwise/events/weapon/stop_adamant_shockmine_electric_loop",
		},
		idle_loop = {
			start = "wwise/events/weapon/play_adamant_shockmine_idle_loop",
			stop = "wwise/events/weapon/stop_adamant_shockmine_idle_loop",
		},
		arming_loop = {
			start = "wwise/events/weapon/play_adamant_shockmine_charge_loop",
			stop = "wwise/events/weapon/stop_adamant_shockmine_charge_loop",
		},
	},
}
local WWISE_PARAMETER_MAX_TARGETS = 30
local WWISE_PARAMETER_NAME = "shockmine_targets"
local TARGET_NODE_NAME = "enemy_aim_target_02"
local PARTICLE_VARIABLE_NAME = "length"
local CENTER_NODE_NAME = "fx_center"
local TINE_NODE_NAMES = {
	"fx_tine_01",
	"fx_tine_02",
	"fx_tine_03",
}
local ShockMine = component("ShockMine")

ShockMine.init = function (self, unit)
	self._unit = unit
	self._has_setup = false

	return true
end

ShockMine.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

ShockMine.enable = function (self, unit)
	return
end

ShockMine.disable = function (self, unit)
	return
end

ShockMine.destroy = function (self, unit)
	if not self._has_setup then
		return
	end

	local source_id = self._source_id

	if self._source_id ~= nil and not WwiseWorld.has_source(self._wwise_world, source_id) then
		source_id = nil
	end

	if self._arming_playing_id then
		self:_stop_looping_sound(source_id, self._arming_playing_id, RESOURCES.sfx.arming_loop.stop)

		self._arming_playing_id = nil
	end

	if self._idle_playing_id then
		self:_stop_looping_sound(source_id, self._idle_playing_id, RESOURCES.sfx.idle_loop.stop)

		self._idle_playing_id = nil
	end

	if self._targets_loop_playing_id then
		self:_stop_looping_sound(source_id, self._targets_loop_playing_id, RESOURCES.sfx.target_loop.stop)

		self._targets_loop_playing_id = nil
	end

	if source_id then
		WwiseWorld.destroy_manual_source(self._wwise_world, source_id)

		self._source_id = nil
	end

	self:_stop_idle_vfx_loop()
end

ShockMine.update = function (self, unit, dt, t)
	if not self._is_deployed then
		return true
	end

	self:_update_target_cooldowns(dt, t)
	self:_update_target_effects(dt, t)

	return true
end

local HARD_CODED_RADIUS = 3
local HARD_CODED_COOLDOWN = 1.75
local _broadphase_results = {}

ShockMine._update_target_effects = function (self, dt, t)
	local world = self._world
	local wwise_world = self._wwise_world
	local unit = self._unit
	local enemy_side_names = self._enemy_side_names
	local broadphase = self._broadphase
	local cooldowns = self._cooldowns

	table.clear(_broadphase_results)

	local num_results = broadphase.query(broadphase, POSITION_LOOKUP[unit], HARD_CODED_RADIUS, _broadphase_results, enemy_side_names)

	for ii = 1, num_results do
		local target_unit = _broadphase_results[ii]

		if HEALTH_ALIVE[target_unit] and not cooldowns[target_unit] then
			local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if buff_extension then
				local target_is_electrocuted = buff_extension:has_keyword(buff_keywords.electrocuted)

				if target_is_electrocuted then
					self:_play_target_vfx(world, unit, target_unit)
					self:_play_target_sfx(wwise_world, target_unit)

					cooldowns[target_unit] = HARD_CODED_COOLDOWN
				end
			end
		end
	end

	local source_id = self._source_id
	local targets_loop_playing_id = self._targets_loop_playing_id

	if num_results > 0 and not targets_loop_playing_id then
		local playing_id = self:_start_looping_sound(source_id, RESOURCES.sfx.target_loop.start)

		self._targets_loop_playing_id = playing_id

		self:_update_targets_sfx_loop(source_id, num_results)
	elseif num_results <= 0 and targets_loop_playing_id then
		self:_stop_looping_sound(source_id, targets_loop_playing_id, RESOURCES.sfx.target_loop.stop)

		self._targets_loop_playing_id = nil
	elseif num_results > 0 and targets_loop_playing_id then
		self:_update_targets_sfx_loop(source_id, num_results)
	end
end

ShockMine._play_target_vfx = function (self, world, unit, target_unit)
	local effect_name = RESOURCES.vfx.to_target
	local particle_id = World.create_particles(world, effect_name, Vector3.zero())
	local source_pos = Unit.world_position(unit, Unit.node(unit, CENTER_NODE_NAME))
	local target_pos = Unit.world_position(target_unit, Unit.node(target_unit, TARGET_NODE_NAME))
	local line = target_pos - source_pos
	local direction, length = Vector3.direction_length(line)
	local rotation = Quaternion.look(direction)
	local particle_length = Vector3(length, length, length)
	local length_variable_index = World.find_particles_variable(world, effect_name, PARTICLE_VARIABLE_NAME)

	World.set_particles_variable(world, particle_id, length_variable_index, particle_length)
	World.move_particles(world, particle_id, source_pos, rotation)
end

ShockMine._play_target_sfx = function (self, wwise_world, target_unit)
	local event_name = RESOURCES.sfx.on_target
	local target_pos = Unit.world_position(target_unit, Unit.node(target_unit, TARGET_NODE_NAME))

	WwiseWorld.trigger_resource_event(wwise_world, event_name, target_pos)
end

ShockMine._setup = function (self)
	if self._has_setup then
		return
	end

	local unit = self._unit
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)
	local player_unit = player.player_unit
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local world = Unit.world(unit)
	local wwise_world = Wwise.wwise_world(world)

	self._world = world
	self._wwise_world = wwise_world
	self._enemy_side_names = enemy_side_names
	self._broadphase = broadphase_system.broadphase
	self._cooldowns = {}
	self._target_particle_ids = {}
	self._target_playing_ids = {}
	self._idle_particle_ids = {}
	self._idle_loop_source_id = nil
	self._idle_loop_playing_id = nil
	self._targets_loop_source_id = nil
	self._targets_loop_playing_id = nil

	local source_id = WwiseWorld.make_manual_source(wwise_world, unit, Unit.node(unit, CENTER_NODE_NAME))

	self._source_id = source_id
	self._has_setup = true
	self._is_deployed = false
end

ShockMine._start_arming = function (self)
	self:_setup()

	if not self._arming_playing_id then
		local playing_id = self:_start_looping_sound(self._source_id, RESOURCES.sfx.arming_loop.start)

		self._arming_playing_id = playing_id
	end
end

ShockMine._deploy = function (self)
	self:_setup()

	local source_id = self._source_id

	if self._arming_playing_id then
		self:_stop_looping_sound(source_id, self._arming_playing_id, RESOURCES.sfx.arming_loop.stop)

		self._arming_playing_id = nil
	end

	local playing_id = self:_start_looping_sound(source_id, RESOURCES.sfx.idle_loop.start)

	self._idle_playing_id = playing_id

	self:_start_idle_vfx_loop()

	self._is_deployed = true

	Unit.animation_event(self._unit, "activate")
end

ShockMine._start_looping_sound = function (self, source_id, event_name)
	local playing_id = WwiseWorld.trigger_resource_event(self._wwise_world, event_name, source_id)

	return playing_id
end

ShockMine._stop_looping_sound = function (self, source_id, playing_id, event_name)
	local wwise_world = self._wwise_world

	if event_name and source_id and WwiseWorld.has_source(wwise_world, source_id) then
		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	elseif playing_id then
		WwiseWorld.stop_event(wwise_world, playing_id)
	end
end

ShockMine._update_targets_sfx_loop = function (self, source_id, num_targets)
	local parameter_value = math.clamp01(math.min(num_targets, WWISE_PARAMETER_MAX_TARGETS) / WWISE_PARAMETER_MAX_TARGETS)

	WwiseWorld.set_source_parameter(self._wwise_world, source_id, WWISE_PARAMETER_NAME, parameter_value)
end

ShockMine._start_idle_vfx_loop = function (self)
	local world = self._world
	local unit = self._unit
	local idle_particle_ids = self._idle_particle_ids
	local source_pos = Unit.world_position(unit, Unit.node(unit, CENTER_NODE_NAME))
	local effect_name = RESOURCES.vfx.idle

	for ii = 1, #TINE_NODE_NAMES do
		local particle_id = World.create_particles(world, effect_name, Vector3.zero())
		local target_pos = Unit.world_position(unit, Unit.node(unit, TINE_NODE_NAMES[ii]))
		local line = target_pos - source_pos
		local direction, length = Vector3.direction_length(line)
		local rotation = Quaternion.look(direction)
		local particle_length = Vector3(length, length, length)
		local length_variable_index = World.find_particles_variable(world, effect_name, PARTICLE_VARIABLE_NAME)

		World.set_particles_variable(world, particle_id, length_variable_index, particle_length)
		World.move_particles(world, particle_id, source_pos, rotation)

		idle_particle_ids[#idle_particle_ids + 1] = particle_id
	end
end

ShockMine._stop_idle_vfx_loop = function (self)
	local world = self._world
	local idle_particle_ids = self._idle_particle_ids

	if self._idle_particle_ids then
		for ii = 1, #idle_particle_ids do
			World.destroy_particles(world, idle_particle_ids[ii])
		end

		table.clear(idle_particle_ids)
	end
end

ShockMine._update_target_cooldowns = function (self, dt, t)
	local cooldowns = self._cooldowns

	for unit, cooldown in pairs(cooldowns) do
		local new_cooldown = cooldown - dt

		if new_cooldown < 0 then
			cooldowns[unit] = nil
		else
			cooldowns[unit] = new_cooldown
		end
	end
end

ShockMine.events.shock_mine_start_arming = function (self)
	self:_start_arming()
end

ShockMine.events.shock_mine_deploy = function (self)
	self:_deploy()
end

ShockMine.component_data = {}

return ShockMine
