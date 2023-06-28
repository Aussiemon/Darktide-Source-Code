require("scripts/extension_systems/weapon/actions/action_ability_base")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local AlternateFire = require("scripts/utilities/alternate_fire")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local MasterItems = require("scripts/backend/master_items")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buff_types = BuffSettings.stat_buffs
local projectile_locomotion_states = ProjectileLocomotionSettings.states
local EXTERNAL_PROPERTIES = nil
local SYNC_TO_CLIENTS = true
local ActionSpawnProjectile = class("ActionSpawnProjectile", "ActionWeaponBase")

ActionSpawnProjectile.init = function (self, action_context, action_params, action_settings)
	ActionSpawnProjectile.super.init(self, action_context, action_params, action_settings)

	local ability = action_params.ability or {}
	self._ability_template_tweak_data = ability.ability_template_tweak_data or {}
	self._ability_extension = action_context.ability_extension
	self._weapon_extension = action_context.weapon_extension
	local player_unit = self._player_unit
	local physics_world = self._physics_world
	local unit_data_extension = action_context.unit_data_extension
	self._item_definitions = MasterItems.get_cached()
	self._action_component = unit_data_extension:write_component("action_shoot")
	self._charge_component = unit_data_extension:write_component("action_module_charge")
	self._shooting_status_component = unit_data_extension:write_component("shooting_status")
	local weapon = action_params.weapon
	self._fx_sources = weapon.fx_sources
	self._muzzle_fx_source_name = self._fx_sources._muzzle

	if action_settings.use_target then
		local targeting_component = unit_data_extension:write_component("action_module_targeting")
		self._targeting_component = targeting_component
		local target_finder_module_class_name = action_settings.target_finder_module_class_name
		self._targeting_module = ActionModules[target_finder_module_class_name]:new(physics_world, player_unit, targeting_component, action_settings)
	end
end

ActionSpawnProjectile.start = function (self, action_settings, t, ...)
	ActionSpawnProjectile.super.start(self, action_settings, t, ...)
	self:_check_for_critical_strike(false, true)

	if self._targeting_module then
		self._targeting_module:start(t)
	end

	local use_ability_charge = action_settings.use_ability_charge

	if use_ability_charge then
		local ability_type = action_settings.ability_type
		local ability_extension = self._ability_extension
		local remaining_charges = ability_extension:remaining_ability_charges(ability_type)
		local anim_noammo_event = action_settings.anim_noammo_event
		local is_going_to_run_out = remaining_charges <= 1

		if is_going_to_run_out and anim_noammo_event then
			local anim_noammo_event_3p = action_settings.anim_noammo_event_3p or anim_noammo_event

			self:trigger_anim_event(anim_noammo_event, anim_noammo_event_3p)
		end
	end

	local vfx_name = action_settings.vfx_effect_name

	if vfx_name then
		local vfx_effect_source_name = action_settings.vfx_effect_source_name
		local source_name = self._fx_sources[vfx_effect_source_name] or vfx_effect_source_name
		self._particle_id = self._fx_extension:spawn_unit_particles(vfx_name, source_name, true, "stop", nil, nil, nil, false)
	end

	if self._is_server then
		local is_critical_strike = self._critical_strike_component.is_active or self._buff_extension:has_keyword(keywords.guaranteed_smite_critical_strike)
		self._projectile_fired = false
		self._projectile_fired_2 = false
		self._projectile_payed_for = false
		local projectile_unit = self:_spawn_projectile_unit(is_critical_strike)
		self._projectile_unit = projectile_unit
		self._projectile_locomotion_extension = ScriptUnit.extension(projectile_unit, "locomotion_system")
		local buff_extension = self._buff_extension
		local spawn_second_projectile = is_critical_strike and buff_extension:has_keyword("critical_hit_second_projectile")

		if spawn_second_projectile then
			local projectile_unit_2 = self:_spawn_projectile_unit(false)
			self._projectile_unit_2 = projectile_unit_2
			self._projectile_locomotion_extension_2 = ScriptUnit.extension(projectile_unit_2, "locomotion_system")
		else
			self._projectile_unit_2 = nil
			self._projectile_locomotion_extension_2 = nil
		end
	end
end

ActionSpawnProjectile.fixed_update = function (self, dt, t, time_in_action)
	if self._targeting_module then
		self._targeting_module:fixed_update(dt, t)
	end

	local action_settings = self._action_settings
	local time_scale = self._weapon_action_component.time_scale
	local fire_time = action_settings.fire_time
	local fire_time_scaled = fire_time / time_scale

	if self._is_server then
		local spawn_projectile_time = fire_time
		local player = self._player

		if player.remote then
			local rewind_s = player:lag_compensation_rewind_s()
			spawn_projectile_time = math.max(spawn_projectile_time - rewind_s, 0)
		end

		if not self._projectile_fired then
			local spawn_projectile_time_scaled = spawn_projectile_time / time_scale
			local should_fire_projectile = time_in_action >= spawn_projectile_time_scaled

			if should_fire_projectile then
				local time_diff_from_payment = fire_time_scaled - spawn_projectile_time_scaled

				self:_fire_projectile(t, time_diff_from_payment, self._projectile_locomotion_extension)

				self._projectile_fired = true
			end
		end

		if not self._projectile_fired_2 and self._projectile_locomotion_extension_2 then
			local spawn_projectile_time_scaled = (spawn_projectile_time + 0.1) / time_scale
			local should_fire_projectile_2 = time_in_action >= spawn_projectile_time_scaled

			if should_fire_projectile_2 then
				local time_diff_from_payment = fire_time_scaled - spawn_projectile_time_scaled
				local offset = nil

				self:_fire_projectile(t, time_diff_from_payment, self._projectile_locomotion_extension_2, offset)

				self._projectile_fired_2 = true
			end
		end
	end

	local should_pay = ActionUtility.is_within_trigger_time(time_in_action, dt, fire_time_scaled)

	if should_pay and action_settings.psyker_smite then
		local buff_extension = self._buff_extension
		local psyker_empowered_grenade = buff_extension:has_keyword("psyker_empowered_grenade")

		if psyker_empowered_grenade then
			should_pay = false

			self:_proc_buffs()

			if self._is_server then
				self._projectile_payed_for = true
			end
		end
	end

	if should_pay then
		self:_pay_for_projectile(t)

		local shooting_status_component = self._shooting_status_component
		local num_shots = shooting_status_component.num_shots + 1
		shooting_status_component.num_shots = num_shots
		shooting_status_component.shooting_end_time = t

		if self._is_server then
			self._projectile_payed_for = true
		end

		self:_proc_buffs()
	end
end

ActionSpawnProjectile.finish = function (self, reason, data, t, time_in_action)
	ActionSpawnProjectile.super.finish(self, reason, data, t, time_in_action)

	if self._targeting_module then
		self._targeting_module:finish(reason, data, t)
	end

	if self._is_server then
		if self._projectile_fired then
			if not self._projectile_payed_for then
				self:_pay_for_projectile(t)
				self:_proc_buffs()
			end
		else
			Managers.state.unit_spawner:mark_for_deletion(self._projectile_unit)
		end
	end

	local particle_id = self._particle_id

	if particle_id then
		self._fx_extension:stop_player_particles(particle_id)
	end

	local action_settings = self._action_settings
	local fx_settings = action_settings.fx
	local use_charge_level = fx_settings and fx_settings.sfx_use_charge_level

	if use_charge_level then
		local charge_component = self._charge_component
		local parameter_name = "charge_level"
		local parameter_value = charge_component.charge_level
		local source_name = self._muzzle_fx_source_name

		self._fx_extension:set_source_parameter(parameter_name, parameter_value, source_name)
	end
end

ActionSpawnProjectile.running_action_state = function (self, t, time_in_action)
	local action_settings = self._action_settings
	local use_ability_charge = action_settings.use_ability_charge

	if use_ability_charge then
		local ability_extension = self._ability_extension
		local ability_type = action_settings.ability_type
		local remaining = ability_extension:remaining_ability_charges(ability_type)

		if remaining == 0 then
			return "out_of_charges"
		end
	end

	return nil
end

ActionSpawnProjectile._check_direction = function (self)
	local name = self._action_settings.name

	return name == "rapid_right", name == "rapid_left"
end

ActionSpawnProjectile._get_projectile_template = function (self)
	local unit = self._player_unit
	local action_settings = self._action_settings
	local projectile_template_func = action_settings.projectile_template_func
	local projectile_template = nil

	if projectile_template_func then
		projectile_template = projectile_template_func(unit, action_settings)
	end

	projectile_template = projectile_template or action_settings.projectile_template

	return projectile_template
end

ActionSpawnProjectile._pay_ability_charge_cost = function (self)
	local action_settings = self._action_settings
	local ability_type = action_settings.ability_type
	local ability_extension = self._ability_extension

	ability_extension:use_ability_charge(ability_type)
end

local COLLISION_FILTER = "filter_player_character_shooting_projectile"

ActionSpawnProjectile._target_unit_and_position = function (self)
	local target_unit = nil
	local action_settings = self._action_settings
	local use_target = action_settings.use_target

	if use_target then
		target_unit = self._targeting_component.target_unit_1
	end

	local target_position = nil
	local use_target_position = action_settings.use_target_position

	if use_target_position and not target_unit then
		local first_person = self._first_person_component
		local from = first_person.position
		local look_rotation = first_person.rotation
		local direction = Quaternion.forward(look_rotation)
		local distance = action_settings.target_position_distance or 50
		local physics_world = self._physics_world
		local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

		if result then
			target_position = hit_position
		else
			target_position = from + direction * distance
		end
	end

	return target_unit, target_position
end

ActionSpawnProjectile._spawn_projectile_unit = function (self, is_critical_strike)
	local projectile_template = self:_get_projectile_template()
	local first_person_component = self._first_person_component
	local position = first_person_component.position
	local rotation = first_person_component.rotation
	local action_settings = self._action_settings
	local material = projectile_template.material or nil
	local inventory_item_name = action_settings.projectile_item
	local item = self._item_definitions[inventory_item_name]
	local starting_state = projectile_locomotion_states.sleep
	local buff_extension = self._buff_extension
	local stat_buffs = buff_extension:stat_buffs()
	local direction, speed, momentum = nil
	local owner_unit = self._player_unit
	local origin_item_slot = self._inventory_component.wielded_slot
	local charge_level = nil

	if action_settings.use_charge then
		charge_level = self._charge_component.charge_level
	else
		charge_level = 1
	end

	local buff_charge_level_modifier = stat_buffs.charge_level_modifier or 1
	local min = NetworkConstants.weapon_charge_level.min
	local max = NetworkConstants.weapon_charge_level.max
	charge_level = math.clamp(charge_level * buff_charge_level_modifier, min, max)
	local target_unit, target_position = nil
	local weapon_item = self._weapon.item

	return Managers.state.unit_spawner:spawn_network_unit(nil, "item_projectile", position, rotation, material, item, projectile_template, starting_state, direction, speed, momentum, owner_unit, is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item)
end

ActionSpawnProjectile._pay_for_projectile = function (self, t)
	local action_settings = self._action_settings
	local charge_component = self._charge_component
	local charge_level = action_settings.use_charge and charge_component.charge_level or 1
	local charge_template = action_settings.charge_template

	if charge_template then
		self:_pay_warp_charge_cost(t, charge_level)
	end

	local fx_settings = action_settings.fx
	local shoot_sfx_alias = fx_settings and fx_settings.shoot_sfx_alias

	if shoot_sfx_alias then
		local source_name = self._muzzle_fx_source_name

		self._fx_extension:trigger_gear_wwise_event_with_source(shoot_sfx_alias, EXTERNAL_PROPERTIES, self._muzzle_fx_source_name, SYNC_TO_CLIENTS)

		local use_charge_level = fx_settings.sfx_use_charge_level

		if use_charge_level then
			local parameter_name = "charge_level"
			local parameter_value = charge_component.charge_level

			self._fx_extension:set_source_parameter(parameter_name, parameter_value, source_name)
		end
	end

	if action_settings.use_charge then
		charge_component.charge_level = 0
	end

	local projectile_template = self:_get_projectile_template()
	local buff_extension = self._buff_extension
	local unit = self._player_unit
	local action_component = self._action_component
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.attacking_unit = unit
		param_table.projectile_template_name = projectile_template.name
		param_table.num_shots_fired = action_component.num_shots_fired
		param_table.combo_count = self._combo_count

		buff_extension:add_proc_event(proc_events.on_shoot_projectile, param_table)
	end

	self._weapon_spread_extension:randomized_spread(Quaternion.identity())
end

ActionSpawnProjectile._fire_projectile = function (self, t, time_difference_from_paying, projectile_locomotion_extension, offset)
	local action_settings = self._action_settings
	local unit = self._player_unit
	local target_unit, target_position = self:_target_unit_and_position()
	local projectile_template = self:_get_projectile_template()
	local projetile_locomotion_template = projectile_template.locomotion_template
	local shoot_parameters = projetile_locomotion_template.shoot_parameters
	local first_person = self._first_person_component
	local position = nil
	local spawn_node = action_settings.spawn_node

	if spawn_node then
		local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		local first_person_unit = first_person_extension:first_person_unit()
		local node = Unit.node(first_person_unit, spawn_node)
		position = Unit.world_position(first_person_unit, node)
	else
		position = first_person.position
	end

	local local_spawn_offset = shoot_parameters.spawn_offset and shoot_parameters.spawn_offset:unbox()

	if local_spawn_offset then
		local spawn_offset = Quaternion.rotate(first_person.rotation, local_spawn_offset)
		position = position + spawn_offset
	end

	local current_velocity = self._locomotion_component.velocity_current
	local velocity_offset = current_velocity * time_difference_from_paying
	position = position + velocity_offset
	local rotation = Quaternion.identity()
	local local_euler_rotation = shoot_parameters.rotation and shoot_parameters.rotation:unbox()

	if local_euler_rotation then
		local local_rotation = Quaternion.from_euler_angles_xyz(local_euler_rotation.x, local_euler_rotation.y, local_euler_rotation.z)
		rotation = Quaternion.multiply(first_person.rotation, local_rotation)
	end

	local look_rotation = first_person.rotation
	local shoot_rotation = look_rotation
	local is_right, is_left = self:_check_direction()
	local have_target = target_unit or target_position

	if have_target then
		local pitch_settings = shoot_parameters.has_target_pitch_offset
		local max_angle_pitch = math.degrees_to_radians(pitch_settings.max)
		local min_angle_pitch = math.degrees_to_radians(pitch_settings.min)
		local random_pitch = math.random() * (max_angle_pitch - min_angle_pitch) + min_angle_pitch
		local direction_right = -Vector3.cross(Vector3.up(), Quaternion.forward(look_rotation))
		local pitch_rotation = Quaternion.axis_angle(direction_right, random_pitch)
		shoot_rotation = Quaternion.multiply(pitch_rotation, shoot_rotation)
		local yaw_settings = shoot_parameters.has_target_yaw_offset
		local yaw_max = is_right and -yaw_settings.min or yaw_settings.max
		local yaw_min = is_left and yaw_settings.min or -yaw_settings.max
		local max_angle_yaw = math.degrees_to_radians(yaw_max)
		local min_angle_yaw = math.degrees_to_radians(yaw_min)
		local random_yaw = math.random() * (max_angle_yaw - min_angle_yaw) + min_angle_yaw
		local yaw_rotation = Quaternion.axis_angle(Vector3.up(), random_yaw)
		shoot_rotation = Quaternion.multiply(shoot_rotation, yaw_rotation)
	else
		local pitch_settings = shoot_parameters.pitch_offset
		local max_angle_pitch = math.degrees_to_radians(pitch_settings.max)
		local min_angle_pitch = math.degrees_to_radians(pitch_settings.min)
		local random_pitch = math.random() * (max_angle_pitch - min_angle_pitch) + min_angle_pitch
		local direction_right = -Vector3.cross(Vector3.up(), Quaternion.forward(look_rotation))
		local pitch_rotation = Quaternion.axis_angle(direction_right, random_pitch)
		shoot_rotation = Quaternion.multiply(pitch_rotation, shoot_rotation)
		local skip_update_component_data = true
		shoot_rotation = self._weapon_spread_extension:randomized_spread(shoot_rotation, skip_update_component_data)
	end

	local direction = Quaternion.forward(shoot_rotation)
	local locomotion_states = ProjectileLocomotionSettings.states
	local locomotion_template = projectile_template.locomotion_template
	local throw_parameters = locomotion_template and locomotion_template.throw_parameters and locomotion_template.throw_parameters.spawn
	local starting_state = throw_parameters and throw_parameters.locomotion_state or locomotion_states.true_flight
	local speed = shoot_parameters.initial_speed or 1
	local momentum = Vector3(0, 0, 1)

	if offset then
		position = position + Quaternion.rotate(rotation, offset)
	end

	if starting_state == projectile_locomotion_states.manual_physics then
		projectile_locomotion_extension:switch_to_manual(position, rotation, direction, speed, momentum)
	elseif starting_state == projectile_locomotion_states.engine_physics then
		projectile_locomotion_extension:switch_to_engine(position, rotation, direction * speed, momentum)
	elseif starting_state == projectile_locomotion_states.true_flight then
		projectile_locomotion_extension:switch_to_true_flight(position, rotation, direction, speed, momentum, target_unit, target_position)
	else
		ferror("unknown starting state %q", starting_state)
	end
end

ActionSpawnProjectile._proc_buffs = function (self)
	local projectile_template = self:_get_projectile_template()
	local buff_extension = self._buff_extension
	local unit = self._player_unit
	local action_component = self._action_component
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.attacking_unit = unit
		param_table.projectile_template_name = projectile_template.name
		param_table.num_shots_fired = action_component.num_shots_fired
		param_table.combo_count = self._combo_count

		buff_extension:add_proc_event(proc_events.on_shoot_projectile, param_table)
	end
end

return ActionSpawnProjectile
