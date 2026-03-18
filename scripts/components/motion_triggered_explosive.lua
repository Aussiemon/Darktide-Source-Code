-- chunkname: @scripts/components/motion_triggered_explosive.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local MasterItems = require("scripts/backend/master_items")
local MotionTriggeredExplosivesSettings = require("scripts/settings/motion_triggered_explosives/motion_triggered_explosives_settings")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local LevelPropsBroadphase = require("scripts/utilities/level_props/level_props_broadphase")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local locomotion_states = ProjectileLocomotionSettings.states
local MotionTriggeredExplosive = component("MotionTriggeredExplosive")

MotionTriggeredExplosive.init = function (self, unit, is_server, nav_world, init_data)
	self._is_server = is_server
	self._unit = unit
	self._owner_unit = init_data.owner_unit
	self._power_level = self:get_data(unit, "power_level")
	self._charge_level = self:get_data(unit, "charge_level")

	local setting_name = self:get_data(unit, "setting_name")
	local settings = MotionTriggeredExplosivesSettings[setting_name]

	self._detection_radius = settings.detection_radius or self:get_data(unit, "detection_radius")
	self._required_enemy_tag = settings.required_enemy_tag or self:get_data(unit, "required_enemy_tag")
	self._activation_delay = settings.activation_delay or self:get_data(unit, "activation_delay")
	self._fuse_time = settings.fuse_time or self:get_data(unit, "fuse_time")
	self._invert_fuse = settings.invert_fuse or self:get_data(unit, "invert_fuse")
	self._total_charges = settings.charges or self:get_data(unit, "charges")
	self._current_charges = self._total_charges
	self._life_time = settings.life_time or self:get_data(unit, "life_time")
	self._fuse_timer = nil
	self._exploded = false
	self._explosion_template = ExplosionTemplates[settings.explosion_template_name]
	self._liquid_area_template = LiquidAreaTemplates[settings.liquid_area_template_name]
	self._cluster_settings = settings.cluster_settings
	self._on_destroy_explosion_template = nil

	if settings.on_destroy_explosion_template_name then
		self._on_destroy_explosion_template = ExplosionTemplates[settings.on_destroy_explosion_template_name]
	end

	local world = Managers.world:world("level_world")

	self._world = world

	local physics_world = World.physics_world(world)

	self._physics_world = physics_world
	self._nav_world = nav_world

	local wwise_world = Managers.world:wwise_world(world)

	self._wwise_world = wwise_world

	local manual_source = WwiseWorld.make_manual_source(wwise_world, unit, 1)

	self._source_id = manual_source

	local start_sound_event = settings.start_sound_event

	if start_sound_event then
		self:_play_sfx(start_sound_event)
	end

	local stop_sound_event_time = settings.stop_sound_event_time

	self._stop_sound_event_time = stop_sound_event_time

	local stop_sound_event = settings.stop_sound_event

	self._stop_sound_event = stop_sound_event

	local start_flow_event = settings.start_flow_event

	if start_flow_event then
		Unit.flow_event(unit, start_flow_event)
	end

	self._armed_flow_event = settings.armed_flow_event
	self._triggered_flow_event = settings.triggered_flow_event

	local run_update = true

	return run_update
end

MotionTriggeredExplosive.editor_init = function (self, unit)
	return
end

MotionTriggeredExplosive.editor_validate = function (self, unit)
	return true, ""
end

MotionTriggeredExplosive._play_sfx = function (self, event)
	local wwise_world = self._wwise_world

	WwiseWorld.trigger_resource_event(wwise_world, event, self._source_id)
end

MotionTriggeredExplosive._start_timer = function (self)
	self._fuse_timer = self._fuse_time

	if self._triggered_flow_event then
		local unit = self._unit

		Unit.flow_event(unit, self._triggered_flow_event)
	end
end

MotionTriggeredExplosive._stop_timer = function (self)
	self._fuse_timer = nil
end

MotionTriggeredExplosive._update_timer = function (self, dt)
	local fuse_timer = self._fuse_timer

	fuse_timer = fuse_timer - dt
	self._fuse_timer = math.max(fuse_timer, 0)
end

MotionTriggeredExplosive._is_timer_started = function (self)
	return self._fuse_timer ~= nil
end

MotionTriggeredExplosive._update_life_time = function (self, dt)
	local life_time = self._life_time

	life_time = life_time - dt
	self._life_time = math.max(life_time, 0)
end

MotionTriggeredExplosive.update = function (self, unit, dt, t)
	local is_active = Unit.alive(unit)

	if is_active and self._activation_delay and self._activation_delay > 0 then
		is_active = false
		self._activation_delay = self._activation_delay - dt

		if self._activation_delay <= 0 then
			if self._armed_flow_event then
				Unit.flow_event(unit, self._armed_flow_event)
			end

			self._activation_delay = nil
		end
	end

	local any_valid_unit_nearby = false

	if is_active then
		local unit_position = POSITION_LOOKUP[unit]
		local side_name = "villains"
		local detection_radius = self._detection_radius
		local units_nearby, num_units_nearby = LevelPropsBroadphase.check_units_nearby(unit_position, detection_radius, side_name)

		if units_nearby then
			local required_enemy_tag = self._required_enemy_tag

			for i = 1, num_units_nearby do
				local target_unit = units_nearby[i]
				local unit_data = ScriptUnit.has_extension(target_unit, "unit_data_system")
				local target_breed = unit_data and unit_data:breed()

				if not required_enemy_tag then
					any_valid_unit_nearby = true
				else
					for j in pairs(target_breed.tags) do
						if required_enemy_tag[j] then
							any_valid_unit_nearby = true

							break
						end
					end
				end

				if any_valid_unit_nearby then
					break
				end
			end
		end
	end

	if not self._fuse_timer and any_valid_unit_nearby then
		self:_start_timer()
	end

	local stop_sound_event_time = self._stop_sound_event_time

	if stop_sound_event_time then
		stop_sound_event_time = stop_sound_event_time - dt

		if stop_sound_event_time <= 0 then
			self:_play_sfx(self._stop_sound_event)

			self._stop_sound_event_time = nil
			self._source_id = nil
		else
			self._stop_sound_event_time = stop_sound_event_time
		end
	end

	if self:_is_timer_started() then
		self:_update_timer(dt)

		if self._is_server then
			if self._exploded == false then
				if self._total_charges == 1 then
					self._exploded = true

					self:_create_explosion()
					self:_self_destruct()
				elseif self._current_charges > 1 then
					self._exploded = true

					self:_create_explosion()
					self:_spend_charges()
				else
					self:_self_destruct()
				end
			end

			if self._fuse_timer <= 0 then
				self._exploded = false

				self:_stop_timer()
			end
		end
	else
		self:_update_life_time(dt)

		if self._life_time <= 0 then
			self:_self_destruct()
		end
	end

	return true
end

MotionTriggeredExplosive.events.add_damage = function (self, damage, hit_actor, attack_direction)
	if not self:_is_timer_started() then
		self:_start_timer()
	end
end

MotionTriggeredExplosive._create_explosion = function (self)
	local attack_type = AttackSettings.attack_types.explosion
	local unit = self._unit
	local explosion_position = Unit.local_position(unit, 1)
	local power_level = self._power_level
	local charge_level = self._charge_level
	local optional_attacking_unit_owner_unit = self._owner_unit

	if self._explosion_template then
		local explosion_template = self._explosion_template

		Explosion.create_explosion(self._world, self._physics_world, explosion_position, Quaternion.forward(Unit.local_rotation(unit, 1)), unit, explosion_template, power_level, charge_level, attack_type, nil, nil, nil, nil, nil, optional_attacking_unit_owner_unit)
	end

	if self._liquid_area_template then
		LiquidArea.try_create(explosion_position, Vector3(0, 0, 1), self._nav_world, self._liquid_area_template, self._owner_unit, nil, nil, nil, "heroes")
	end

	if self._cluster_settings then
		self:_spawn_cluster(self._cluster_settings)
	end
end

MotionTriggeredExplosive._self_destruct = function (self)
	local attack_type = AttackSettings.attack_types.explosion
	local unit = self._unit
	local explosion_position = Unit.local_position(unit, 1)
	local power_level = self._power_level
	local charge_level = self._charge_level
	local optional_attacking_unit_owner_unit = self._owner_unit

	if self._on_destroy_explosion_template then
		local explosion_template = self._on_destroy_explosion_template

		Explosion.create_explosion(self._world, self._physics_world, explosion_position, Quaternion.forward(Unit.local_rotation(unit, 1)), unit, explosion_template, power_level, charge_level, attack_type, nil, nil, nil, nil, nil, optional_attacking_unit_owner_unit)
	end

	self:_destroy_unit(unit)
end

MotionTriggeredExplosive._spawn_cluster = function (self, cluster_settings)
	local unit = self._unit
	local owner_unit = self._owner_unit
	local position = Unit.local_position(unit, 1) + Vector3.up()
	local projectile_template = ProjectileTemplates[cluster_settings.projectile_template_name]
	local amount = cluster_settings.amount
	local direction = Vector3.up()
	local check_vector = Vector3.dot(direction, Vector3.right()) < 1 and Vector3.right() or Vector3.forward()
	local start_axis = Vector3.cross(direction, check_vector)
	local angle_distrbution = math.pi
	local random_start_rotation = math.pi * 2 * math.random_array_entry({
		0,
		0.25,
		0.5,
		0.75,
	})
	local material
	local item_name = cluster_settings.item
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local starting_state = locomotion_states.manual_physics
	local max = math.pi / 10
	local angular_velocity = Vector3(math.random() * max, math.random() * max, math.random() * max)
	local is_critical_strike = false

	for i = 1, amount do
		local angle = angle_distrbution * i + random_start_rotation + math.lerp(-angle_distrbution * 0.5, angle_distrbution * 0.5, math.random())
		local random_rotation = Quaternion.axis_angle(direction, angle)
		local flat_direction = Quaternion.rotate(random_rotation, start_axis)
		local random_alpha = math.random_range(0.35, 1)
		local current_direction = Vector3.lerp(flat_direction, direction, random_alpha)
		local start_speed = cluster_settings.start_speed
		local speed = math.lerp(start_speed.min, start_speed.max, math.random())
		local unit_template_name = projectile_template.unit_template_name or "item_projectile"

		Managers.state.unit_spawner:spawn_network_unit(nil, unit_template_name, position, random_rotation, material, item, projectile_template, starting_state, current_direction, speed, angular_velocity, owner_unit, is_critical_strike, nil, nil, nil, nil, nil, nil, self._owner_side_or_nil)
	end
end

MotionTriggeredExplosive._spend_charges = function (self)
	self._current_charges = self._current_charges - 1
end

MotionTriggeredExplosive._destroy_unit = function (self, unit)
	local destructible_extension = ScriptUnit.has_extension(unit, "destructible_system")

	if destructible_extension == nil then
		local unit_spawner = Managers.state.unit_spawner

		if unit_spawner:is_husk(unit) then
			if self._is_server then
				unit_spawner:mark_for_deletion(unit)
			end
		else
			unit_spawner:mark_for_deletion(unit)
		end
	end
end

MotionTriggeredExplosive.enable = function (self, unit)
	return
end

MotionTriggeredExplosive.disable = function (self, unit)
	return
end

MotionTriggeredExplosive.destroy = function (self, unit)
	local source_id = self._source_id

	if source_id then
		WwiseWorld.destroy_manual_source(self._wwise_world, source_id)
	end
end

MotionTriggeredExplosive.start_timer = function (self)
	self:_start_timer()
end

MotionTriggeredExplosive.component_data = {
	start_timer_on_spawn = {
		ui_name = "Start timer on Spawn",
		ui_type = "check_box",
		value = true,
	},
	setting_name = {
		ui_name = "Setting Name",
		ui_type = "combo_box",
		value = "explosive_trap",
		options_keys = {
			"explosive_trap",
			"fire_trap",
			"shock_trap",
		},
		options_values = {
			"explosive_trap",
			"fire_trap",
			"shock_trap",
		},
	},
	power_level = {
		decimals = 0,
		step = 1,
		ui_name = "Power Level",
		ui_type = "number",
		value = 1000,
	},
	charge_level = {
		decimals = 0,
		step = 1,
		ui_name = "Charge Level",
		ui_type = "number",
		value = 1,
	},
	detection_radius = {
		decimals = 1,
		step = 0.1,
		ui_name = "Detonation detection radius (in meters.)",
		ui_type = "number",
		value = 1,
	},
	fuse_time = {
		decimals = 1,
		step = 0.1,
		ui_name = "Fuse Time (in sec.)",
		ui_type = "number",
		value = 5,
	},
	inputs = {
		start_timer = {
			accessibility = "public",
			type = "event",
		},
	},
}

return MotionTriggeredExplosive
