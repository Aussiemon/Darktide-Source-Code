-- chunkname: @scripts/extension_systems/weapon/actions/action_weapon_shout.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Attack = require("scripts/utilities/attack/attack")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Stagger = require("scripts/utilities/attack/stagger")
local Suppression = require("scripts/utilities/attack/suppression")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local CLOSE_RANGE = 9
local ActionWeaponShout = class("ActionWeaponShout", "ActionWeaponBase")
local broadphase_results = {}

ActionWeaponShout.init = function (self, action_context, action_params, action_settings)
	ActionWeaponShout.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._block_component = unit_data_extension:write_component("block")
	self._unit_data_extension = unit_data_extension
	self._action_settings = action_settings
	self._target_units = {}
	self._suppression_distance_traveled = 0
	self._speed = 1
	self._attack_position = Vector3Box(Vector3.zero())
	self._attack_direction = Vector3Box(Vector3.zero())

	local weapon_template = self._weapon_template
	local weapon_special_tweak_data = weapon_template and weapon_template.weapon_special_tweak_data

	self._weapon_special_tweak_data = weapon_special_tweak_data

	local weapon = action_params.weapon

	self._fx_source_name = weapon.fx_sources._weapon_shout

	local fx = self._action_settings.fx

	if fx then
		self._effect_name = fx.weapon_shout_effect
	end
end

ActionWeaponShout.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionWeaponShout.super.start(self, action_settings, t, time_scale, action_start_params)

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component

	weapon_tweak_templates_component.weapon_shout_template_name = action_settings.weapon_shout_template or self._weapon_template.weapon_shout_template or "none"
	self._suppression_distance_traveled = 0

	local shout_template = self._weapon_extension:weapon_shout_template()
	local shout_time = action_settings.shout_time or action_settings.total_time

	self._speed = shout_template.range / shout_time * 4
	self._num_hits = 0
	self._target_index = 0

	table.clear(self._target_units)

	self._has_collected_targest = false
end

ActionWeaponShout.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local block_duration = action_settings.block_duration

	if self._block_component.is_blocking and (not block_duration or time_in_action >= action_settings.block_duration) then
		self._block_component.is_blocking = false
	end

	if not self._is_server then
		return
	end

	local shout_at_time = action_settings.shout_at_time

	if time_in_action < shout_at_time then
		return
	end

	if not self._has_collected_targest then
		self:_start_shout(t)

		self._has_collected_targest = true
	end

	self:_update_shout(dt)
end

ActionWeaponShout.finish = function (self, reason, data, t, time_in_action, action_settings)
	ActionWeaponShout.super.finish(self, reason, data, t, time_in_action)

	local block_duration = action_settings.block_duration

	if block_duration and self._block_component.is_blocking then
		self._block_component.is_blocking = false
	end

	self._num_hits = 0
	self._target_index = 0

	table.clear(self._target_units)

	self._has_collected_targest = false
end

ActionWeaponShout._start_shout = function (self, t)
	local action_settings = self._action_settings
	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local player_position = locomotion_position
	local player_unit = self._player_unit
	local rotation = self._first_person_component.rotation
	local reverse_direction = action_settings.reverse_direction
	local attack_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))

	attack_direction = reverse_direction and -attack_direction or attack_direction
	self._attack_position = Vector3Box(player_position)
	self._attack_direction = Vector3Box(attack_direction)

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]

	self:_collect_targets(t, action_settings, side, attack_direction)

	local weapon_special_tweak_data = self._weapon_special_tweak_data
	local num_charges_to_consume_on_activation = weapon_special_tweak_data and weapon_special_tweak_data.num_charges_to_consume_on_activation

	if num_charges_to_consume_on_activation then
		local inventory_slot_component = self._inventory_slot_component
		local num_special_charges = inventory_slot_component.num_special_charges

		inventory_slot_component.num_special_charges = math.max(num_special_charges - num_charges_to_consume_on_activation, 0)
	end

	self:_play_fx()
end

ActionWeaponShout._update_shout = function (self, dt)
	local suppression_distance_traveled = self._suppression_distance_traveled
	local target_units = self._target_units
	local damage_profile = self._damage_profile
	local player_unit = self._player_unit
	local power_level = self._power_level
	local damage_type = self._damage_type
	local attack_type = self._attack_type
	local attack_direction = self._attack_direction:unbox()
	local distance_traveled_squared = suppression_distance_traveled * suppression_distance_traveled

	for target_unit, target_distance_squared in pairs(target_units) do
		if not HEALTH_ALIVE[target_unit] then
			target_units[target_unit] = nil
		elseif target_distance_squared <= distance_traveled_squared then
			local actual_distance = math.sqrt(target_distance_squared)
			local scaled_power_level = power_level
			local target_index = self._target_index + 1

			self._target_index = target_index

			local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, player_unit, target_index)
			local dropoff_scalar = DamageProfile.dropoff_scalar(actual_distance, damage_profile, damage_profile_lerp_values)

			Attack.execute(target_unit, damage_profile, "attack_direction", attack_direction, "power_level", scaled_power_level, "hit_zone_name", "torso", "damage_type", damage_type, "attack_type", attack_type, "attacking_unit", player_unit, "dropoff_scalar", dropoff_scalar)

			local player_position = POSITION_LOOKUP[player_unit]

			Suppression.apply_suppression(target_unit, player_unit, damage_profile, player_position)

			target_units[target_unit] = nil
		end
	end

	self._suppression_distance_traveled = suppression_distance_traveled + self._speed * dt
end

ActionWeaponShout._collect_targets = function (self, t, action_settings, side, attack_direction)
	local enemy_side_names = side:relation_side_names("enemy")
	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local player_position = locomotion_position
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local damage_type = action_settings.damage_type
	local attack_type = action_settings.attack_type
	local power_level = action_settings.power_level or DEFAULT_POWER_LEVEL
	local damage_profile = action_settings.damage_profile

	self._damage_profile = damage_profile
	self._player_position = player_position
	self._power_level = power_level
	self._damage_type = damage_type
	self._attack_type = attack_type

	local shout_template = self._weapon_extension:weapon_shout_template()
	local shout_shape = shout_template.shape

	if shout_shape and shout_shape == "cone" then
		local shout_dot = shout_template.dot
		local shout_range = shout_template.range
		local shout_range_squared = shout_range * shout_range
		local initial_overlap_radius = shout_template.close_radius
		local end_overlap_radius = shout_range * math.tan(shout_dot)
		local overlap_radius = end_overlap_radius
		local overlap_distance = shout_range
		local distance_moved = 0
		local target_units = self._target_units
		local done
		local total_num_hits = 0

		repeat
			local radius_to_use = overlap_radius * 1.1
			local broadphase_pos = player_position + attack_direction * overlap_distance

			table.clear(broadphase_results)

			local num_hits = broadphase.query(broadphase, broadphase_pos, radius_to_use, broadphase_results, enemy_side_names)

			total_num_hits = total_num_hits + num_hits

			for ii = 1, num_hits do
				local enemy_unit = broadphase_results[ii]
				local enemy_unit_position = POSITION_LOOKUP[enemy_unit]
				local to_target_distance_squared = Vector3.distance_squared(enemy_unit_position, player_position)
				local to_target = Vector3.normalize(Vector3.flat(enemy_unit_position - player_position))

				if Vector3.length_squared(to_target) == 0 then
					local player_rotation = locomotion_component.rotation

					to_target = Quaternion.forward(player_rotation)
				end

				local dot = Vector3.dot(attack_direction, to_target)
				local within_angle = shout_dot >= math.acos(dot)
				local within_range = to_target_distance_squared <= shout_range_squared
				local within_close_range = to_target_distance_squared <= CLOSE_RANGE

				if action_settings.close_range_dot_product and dot < action_settings.close_range_dot_product then
					within_close_range = false
				end

				if not target_units[enemy_unit] and (within_angle and within_range or not within_angle and within_close_range) then
					self._num_hits = self._num_hits + 1
					target_units[enemy_unit] = to_target_distance_squared
				end
			end

			overlap_distance = overlap_distance - overlap_radius
			distance_moved = distance_moved + overlap_radius
			overlap_radius = overlap_radius * 0.8
			done = shout_range <= distance_moved + initial_overlap_radius
		until done
	end
end

ActionWeaponShout._play_fx = function (self)
	if self._unit_data_extension.is_resimulating then
		return
	end

	if not self._effect_name or not self._fx_source_name then
		return
	end

	local fx_extension = self._fx_extension
	local link = true
	local orphaned_policy = "stop"
	local position_offset, rotation_offset, scale, all_clients, create_network_index
	local particle_id = fx_extension:spawn_unit_particles(self._effect_name, self._fx_source_name, link, orphaned_policy, position_offset, rotation_offset, scale, all_clients, create_network_index)
end

return ActionWeaponShout
