require("scripts/extension_systems/weapon/actions/action_shoot")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FriendlyFire = require("scripts/utilities/attack/friendly_fire")
local HitScan = require("scripts/utilities/attack/hit_scan")
local HitZone = require("scripts/utilities/attack/hit_zone")
local RangedAction = require("scripts/utilities/action/ranged_action")
local Suppression = require("scripts/utilities/attack/suppression")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local proc_events = BuffSettings.proc_events
local template_types = WeaponTweakTemplateSettings.template_types
local damage_types = DamageSettings.damage_types
local ActionFlamerGas = class("ActionFlamerGas", "ActionShoot")

ActionFlamerGas.init = function (self, action_context, action_params, action_settings)
	ActionFlamerGas.super.init(self, action_context, action_params, action_settings)

	self._target_indexes = {}
	self._target_damage_times = {}
	self._target_frame_counts = {}
	self._dot_targets = {}
	self._action_module_position_finder_component = action_context.unit_data_extension:write_component("action_module_position_finder")
	self._action_flamer_gas_component = action_context.unit_data_extension:write_component("action_flamer_gas")
end

ActionFlamerGas.start = function (self, action_settings, t, ...)
	ActionFlamerGas.super.start(self, action_settings, t, ...)
	table.clear(self._target_indexes)
	table.clear(self._target_damage_times)
	table.clear(self._target_frame_counts)
	table.clear(self._dot_targets)

	local fire_config = action_settings.fire_configuration
	local flamer_gas_template = fire_config.flamer_gas_template
	self._flamer_gas_template = flamer_gas_template
	local weapon_extension = self._weapon_extension
	local burninating_template = weapon_extension:burninating_template()
	self._dot_max_stacks = burninating_template.max_stacks
	self._dot_stack_application_rate = burninating_template.stack_application_rate
	local size_of_flame_template = weapon_extension:size_of_flame_template()
	self._spread_angle = size_of_flame_template.spread_angle
	self._suppression_cone_radius = size_of_flame_template.suppression_cone_radius
	local weapon_handling_template = weapon_extension:weapon_handling_template()
	self._damage_times = weapon_handling_template.flamer_ramp_up_times or {
		weapon_handling_template.fire_rate.fire_time
	}
	local damage_config = flamer_gas_template.damage
	local damage_profile = damage_config.impact.damage_profile
	local num_targets = table.size(damage_profile.targets)
	self._max_target_index = math.max(#self._damage_times, num_targets)
	local initial_burn_delay = burninating_template.initial_burn_delay or 0.25
	self._burn_time = self._dot_stack_application_rate + initial_burn_delay
	local range = size_of_flame_template.range
	self._range = range
	self._action_flamer_gas_component.range = range
end

local INDEX_POSITION = 1
local INDEX_NORMAL = 3
local INDEX_ACTOR = 4

ActionFlamerGas.fixed_update = function (self, dt, t, time_in_action)
	ActionFlamerGas.super.fixed_update(self, dt, t, time_in_action)

	if not self._is_server then
		return
	end

	self:_acquire_targets(t)
	self:_damage_targets(dt, t)
	self:_burn_targets(dt, t)
end

local hit_units_this_frame = {}

ActionFlamerGas._is_unit_blocking = function (self, unit, player_pos)
	local shield_extension = ScriptUnit.has_extension(unit, "shield_system")

	if shield_extension then
		return shield_extension:can_block_from_position(player_pos)
	end
end

ActionFlamerGas._acquire_targets = function (self, t)
	table.clear(hit_units_this_frame)

	local player_unit = self._player_unit
	local player_pos = POSITION_LOOKUP[player_unit]
	local spread_angle = self._spread_angle
	local max_range = self._range
	local position = self._first_person_component.position
	local rotation = self._first_person_component.rotation
	local position_finder_component = self._action_module_position_finder_component
	position_finder_component.position_valid = false
	local weapon_spread_extension = self._weapon_spread_extension
	local num_rays_this_frame = 8

	for i = 1, num_rays_this_frame do
		local bullseye = true
		local ray_rotation = weapon_spread_extension:target_style_spread(rotation, i, num_rays_this_frame, 2, bullseye, spread_angle, spread_angle)
		local direction = Quaternion.forward(ray_rotation)
		local rewind_ms = self:_rewind_ms(self._is_local_unit, self._player, position, direction, max_range)
		local hits = HitScan.raycast(self._physics_world, position, direction, max_range, nil, "filter_player_character_shooting", rewind_ms)
		local stop = false
		local side_system = Managers.state.extension:system("side_system")

		if hits then
			local num_hit_results = #hits

			for j = 1, num_hit_results do
				repeat
					local hit = hits[j]
					local hit_pos = hit[INDEX_POSITION]
					local hit_actor = hit[INDEX_ACTOR]
					local hit_normal = hit[INDEX_NORMAL]
					local hit_unit = Actor.unit(hit_actor)
					local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
					local hit_afro = hit_zone_name_or_nil == HitZone.hit_zone_names.afro

					if hit_units_this_frame[hit_unit] then
						break
					end

					if hit_afro then
						break
					end

					if hit_unit == player_unit then
						break
					end

					local health_extension = ScriptUnit.has_extension(hit_unit, "health_system")
					local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")
					local is_unit_blocking = self:_is_unit_blocking(hit_unit, player_pos)

					if is_unit_blocking or not health_extension and not buff_extension then
						stop = true

						if i == 1 then
							position_finder_component.position = hit_pos
							position_finder_component.normal = hit_normal
							position_finder_component.position_valid = true
						end
					else
						if side_system:is_ally(player_unit, hit_unit) and not FriendlyFire.is_enabled(player_unit, hit_unit) then
							break
						end

						if health_extension then
							self:_hit_target(hit_unit, hit_pos)
						end

						if buff_extension then
							self._dot_targets[hit_unit] = true
						end

						hit_units_this_frame[hit_unit] = true
					end
				until true

				if stop then
					break
				end
			end
		end
	end
end

ActionFlamerGas._hit_target = function (self, hit_unit, hit_pos)
	local damage_time = self._target_damage_times[hit_unit]
	local frame_count = self._target_frame_counts[hit_unit]
	local index = self._target_indexes[hit_unit]

	if not index then
		local player_pos = POSITION_LOOKUP[self._player_unit]
		local distance = Vector3.distance(hit_pos, player_pos)
		index = 1
		damage_time = self._damage_times[index] + distance / self._range * 0.4
		frame_count = 1
	else
		frame_count = frame_count + 1
	end

	self._target_damage_times[hit_unit] = damage_time
	self._target_frame_counts[hit_unit] = frame_count
	self._target_indexes[hit_unit] = index
end

ActionFlamerGas._damage_targets = function (self, dt, t)
	local damage_times = self._damage_times
	local target_damage_times = self._target_damage_times
	local target_frame_counts = self._target_frame_counts
	local target_indexes = self._target_indexes
	local ALIVE = ALIVE

	for target_unit, current_index in pairs(target_indexes) do
		repeat
			local current_damage_time = target_damage_times[target_unit]
			local frame_count = target_frame_counts[target_unit]

			if not ALIVE[target_unit] or not ScriptUnit.has_extension(target_unit, "health_system") then
				target_damage_times[target_unit] = nil
				target_frame_counts[target_unit] = nil
				target_indexes[target_unit] = nil
			elseif current_damage_time <= 0 then
				local damage_time_index = math.min(current_index, #damage_times)
				local damage_time = damage_times[damage_time_index]
				local aim_at_percent = frame_count / (damage_time / GameParameters.fixed_time_step)
				local new_damage_time, new_frame_count, new_target_index = nil

				if aim_at_percent > 0.33 then
					self:_damage_target(target_unit)

					local new_damage_time_index = math.min(current_index + 1, #damage_times)
					new_damage_time = damage_times[new_damage_time_index]
					new_frame_count = 0
					new_target_index = math.min(self._max_target_index, current_index + 1)
				elseif current_index > 1 then
					local new_damage_time_index = math.min(current_index - 1, #damage_times)
					new_damage_time = damage_times[new_damage_time_index]
					new_frame_count = 0
					new_target_index = current_index - 1
				else
					new_damage_time, new_frame_count, new_target_index = nil
				end

				target_damage_times[target_unit] = new_damage_time
				target_frame_counts[target_unit] = new_frame_count
				target_indexes[target_unit] = new_target_index
			else
				target_damage_times[target_unit] = current_damage_time - dt
			end
		until true
	end
end

ActionFlamerGas._damage_target = function (self, target_unit)
	local player_unit = self._player_unit
	local damage_config = self._flamer_gas_template.damage
	local damage_profile = damage_config.impact.damage_profile
	local player_pos = POSITION_LOOKUP[player_unit]
	local target_pos = POSITION_LOOKUP[target_unit]
	local target_index = self._target_indexes[target_unit]
	local actor, hit_position = nil
	local hit_distance = Vector3.distance(target_pos, player_pos)
	local direction = Vector3.normalize(target_pos - player_pos)
	local hit_normal, hit_zone_name = nil
	local penetrated = false
	local instakill = false
	local damage_type = damage_types.burning
	local is_critical_strike = false
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, player_unit, target_index)
	local power_level = 500
	local charge_level = 1
	local weapon_item = self._weapon.item

	RangedAction.execute_attack(target_index, player_unit, target_unit, actor, hit_position, hit_distance, direction, hit_normal, hit_zone_name, damage_profile, damage_profile_lerp_values, power_level, charge_level, penetrated, damage_config, instakill, damage_type, is_critical_strike, weapon_item)
end

ActionFlamerGas._burn_targets = function (self, dt, t)
	local player_unit = self._player_unit
	local weapon_item = self._weapon.item
	local burn_time = self._burn_time - dt

	if burn_time <= 0 then
		local targets = self._dot_targets
		local dot_buff_name = self._flamer_gas_template.dot_buff_name

		if self._is_server then
			local ALIVE = ALIVE

			for hit_unit, _ in pairs(targets) do
				if ALIVE[hit_unit] then
					local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

					if buff_extension then
						local current_stacks = buff_extension:current_stacks(dot_buff_name)
						local start_time_with_offset = t + math.random() * 0.3

						if current_stacks < self._dot_max_stacks then
							buff_extension:add_internally_controlled_buff(dot_buff_name, start_time_with_offset, "owner_unit", player_unit, "source_item", weapon_item)
						elseif current_stacks == self._dot_max_stacks then
							buff_extension:refresh_duration_of_stacking_buff(dot_buff_name, start_time_with_offset)
						end
					end
				end
			end
		end

		table.clear(targets)

		burn_time = self._dot_stack_application_rate
	end

	self._burn_time = burn_time
end

ActionFlamerGas._shoot = function (self, position, rotation, power_level, charge_level, t)
	local player_unit = self._player_unit
	local damage_config = self._flamer_gas_template.damage
	local damage_profile = damage_config.impact.damage_profile

	if self._is_server then
		local units = self:_acquire_suppressed_units(t)

		for hit_unit, _ in pairs(units) do
			Suppression.apply_suppression(hit_unit, player_unit, damage_profile, POSITION_LOOKUP[player_unit])
		end
	end

	local attacker_buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local param_table = attacker_buff_extension:request_proc_event_param_table()
	param_table.attacking_unit = player_unit

	attacker_buff_extension:add_proc_event(proc_events.on_shoot, param_table)
end

local broadphase_results = {}
local suppressed_units = {}

ActionFlamerGas._acquire_suppressed_units = function (self, t)
	table.clear(broadphase_results)
	table.clear(suppressed_units)

	local flamer_gas_template = self._flamer_gas_template
	local suppression_radius = flamer_gas_template.suppression_radius
	local suppression_radius_squared = suppression_radius * suppression_radius
	local suppression_cone_radius = self._suppression_cone_radius
	local suppression_cone_dot = flamer_gas_template.suppression_cone_dot
	local player_unit = self._player_unit
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local player_position = POSITION_LOOKUP[self._player_unit]
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local num_hits = broadphase:query(player_position, suppression_cone_radius, broadphase_results, enemy_side_names)
	local rotation = self._first_person_component.rotation
	local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))

	for i = 1, num_hits do
		local enemy_unit = broadphase_results[i]
		local enemy_unit_position = POSITION_LOOKUP[enemy_unit]
		local flat_direction = Vector3.flat(enemy_unit_position - player_position)
		local direction = Vector3.normalize(flat_direction)
		local dot = Vector3.dot(forward, direction)

		if suppression_cone_dot < dot then
			suppressed_units[enemy_unit] = true
		else
			local distance_squared = Vector3.length_squared(flat_direction)

			if distance_squared < suppression_radius_squared then
				suppressed_units[enemy_unit] = true
			end
		end
	end

	return suppressed_units
end

ActionFlamerGas.finish = function (self, reason, data, t, time_in_action)
	ActionFlamerGas.super.finish(self, reason, data, t, time_in_action)

	local position_finder_component = self._action_module_position_finder_component
	position_finder_component.position = Vector3.zero()
	position_finder_component.position_valid = false
end

ActionFlamerGas.running_action_state = function (self, t, time_in_action)
	local inventory_slot_component = self._inventory_slot_component
	local current_ammo_clip = inventory_slot_component.current_ammunition_clip
	local current_ammo_reserve = inventory_slot_component.current_ammunition_clip

	if current_ammo_clip == 0 then
		if current_ammo_reserve > 0 then
			return "clip_empty"
		else
			return "reserve_empty"
		end
	end

	return nil
end

return ActionFlamerGas
