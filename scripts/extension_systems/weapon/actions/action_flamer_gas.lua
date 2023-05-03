require("scripts/extension_systems/weapon/actions/action_shoot")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FriendlyFire = require("scripts/utilities/attack/friendly_fire")
local HitScan = require("scripts/utilities/attack/hit_scan")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local RangedAction = require("scripts/utilities/action/ranged_action")
local Spread = require("scripts/utilities/spread")
local Suppression = require("scripts/utilities/attack/suppression")
local damage_types = DamageSettings.damage_types
local proc_events = BuffSettings.proc_events
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local DEFAULT_DAMAGE_TYPE = damage_types.burning
local ActionFlamerGas = class("ActionFlamerGas", "ActionShoot")

ActionFlamerGas.init = function (self, action_context, action_params, action_settings)
	ActionFlamerGas.super.init(self, action_context, action_params, action_settings)

	self._target_indexes = {}
	self._target_damage_times = {}
	self._target_frame_counts = {}
	self._dot_targets = {}
	local unit_data_extension = action_context.unit_data_extension
	self._action_module_position_finder_component = unit_data_extension:write_component("action_module_position_finder")
	self._action_flamer_gas_component = unit_data_extension:write_component("action_flamer_gas")
	local fire_config = action_settings.fire_configuration

	if fire_config.charge_duration then
		self._action_module_charge_component = unit_data_extension:write_component("action_module_charge")
	end

	self._damage_type = fire_config and fire_config.damage_type or DEFAULT_DAMAGE_TYPE
end

ActionFlamerGas._setup_flame_data = function (self, action_settings)
	local fire_config = action_settings.fire_configuration
	local flamer_gas_template = fire_config.flamer_gas_template
	self._flamer_gas_template = flamer_gas_template
	local weapon_extension = self._weapon_extension
	local burninating_template = weapon_extension:burninating_template()
	self._dot_max_stacks = math.ceil(burninating_template.max_stacks)
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
	self._killing_blow = false
end

ActionFlamerGas.start = function (self, action_settings, t, ...)
	ActionFlamerGas.super.start(self, action_settings, t, ...)
	table.clear(self._target_indexes)
	table.clear(self._target_damage_times)
	table.clear(self._target_frame_counts)
	table.clear(self._dot_targets)

	self._killing_blow = false

	self:_setup_flame_data(action_settings)
end

local INDEX_POSITION = 1
local INDEX_NORMAL = 3
local INDEX_ACTOR = 4

ActionFlamerGas.fixed_update = function (self, dt, t, time_in_action)
	ActionFlamerGas.super.fixed_update(self, dt, t, time_in_action)

	if not self._flamer_gas_template then
		self:_setup_flame_data(self._action_settings)
	end

	self:_acquire_targets(t)

	if self._is_server then
		self:_damage_targets(dt, t)
		self:_burn_targets(dt, t)
	end
end

ActionFlamerGas._is_unit_blocking = function (self, unit, player_pos)
	local shield_extension = ScriptUnit.has_extension(unit, "shield_system")

	if shield_extension then
		return shield_extension:can_block_from_position(player_pos)
	end
end

ActionFlamerGas._process_hit = function (self, hit, player_unit, player_pos, side_system, t, hit_units_this_frame, is_server)
	local hit_pos = hit[INDEX_POSITION]
	local hit_actor = hit[INDEX_ACTOR]
	local hit_normal = hit[INDEX_NORMAL]
	local hit_unit = Actor.unit(hit_actor)
	local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
	local hit_afro = hit_zone_name_or_nil == HitZone.hit_zone_names.afro

	if hit_units_this_frame[hit_unit] then
		return false
	end

	if hit_afro then
		return false
	end

	if hit_unit == player_unit then
		return false
	end

	local health_extension = ScriptUnit.has_extension(hit_unit, "health_system")
	local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")
	local is_unit_blocking = self:_is_unit_blocking(hit_unit, player_pos)

	if is_unit_blocking or not health_extension and not buff_extension then
		return true, hit_pos, hit_normal
	end

	if side_system:is_ally(player_unit, hit_unit) and not FriendlyFire.is_enabled(player_unit, hit_unit) then
		return false
	end

	if is_server and health_extension then
		self:_hit_target(hit_unit, hit_pos)
	end

	if is_server and buff_extension then
		self._dot_targets[hit_unit] = true
	end

	hit_units_this_frame[hit_unit] = true
end

ActionFlamerGas._do_raycast = function (self, i, position, rotation, max_range, num_rays_this_frame, spread_angle, player_unit, player_pos, side_system, t, hit_units_this_frame, is_server)
	local ray_rotation = rotation

	if i > 1 then
		ray_rotation = Spread.uniform_circle(rotation, spread_angle, math.random_seed())
	end

	local direction = Quaternion.forward(ray_rotation)
	local rewind_ms = self:_rewind_ms(self._is_local_unit, self._player, position, direction, max_range)
	local hits = HitScan.raycast(self._physics_world, position, direction, max_range, nil, "filter_player_character_shooting_raycast", rewind_ms)
	local stop, stop_position, stop_normal = nil

	if hits then
		local num_hit_results = #hits

		for j = 1, num_hit_results do
			repeat
				local hit = hits[j]
				stop, stop_position, stop_normal = self:_process_hit(hit, player_unit, player_pos, side_system, t, hit_units_this_frame, is_server)
			until true

			if stop then
				break
			end
		end
	end

	return stop, stop_position, stop_normal
end

local _hit_units_this_frame = {}

ActionFlamerGas._acquire_targets = function (self, t)
	table.clear(_hit_units_this_frame)

	local is_server = self._is_server
	local player_unit = self._player_unit
	local player_pos = POSITION_LOOKUP[player_unit]
	local spread_angle = self._spread_angle
	local max_range = self._range
	local position = self._first_person_component.position
	local rotation = self._first_person_component.rotation
	local position_finder_component = self._action_module_position_finder_component
	local side_system = Managers.state.extension:system("side_system")
	local num_rays_this_frame = 8
	local stop, stop_position, stop_normal = self:_do_raycast(1, position, rotation, max_range, num_rays_this_frame, spread_angle, player_unit, player_pos, side_system, t, _hit_units_this_frame, is_server)

	if stop then
		position_finder_component.position = stop_position
		position_finder_component.normal = stop_normal
		position_finder_component.position_valid = true
	else
		position_finder_component.position_valid = false
	end

	if is_server then
		for i = 2, num_rays_this_frame do
			self:_do_raycast(i, position, rotation, max_range, num_rays_this_frame, spread_angle, player_unit, player_pos, side_system, t, _hit_units_this_frame, is_server)
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

ActionFlamerGas._damage_targets = function (self, dt, t, force_damage)
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
			elseif current_damage_time <= 0 or force_damage then
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
	local actor = nil
	local hit_position = target_pos
	local hit_distance = Vector3.distance(target_pos, player_pos)
	local direction = Vector3.normalize(target_pos - player_pos)
	local hit_normal, hit_zone_name = nil
	local penetrated = false
	local instakill = false
	local damage_type = self._damage_type
	local is_critical_strike = self._critical_strike_component.is_active
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, player_unit, target_index)
	local charge_level = 1
	local weapon_item = self._weapon.item
	local damage_dealt, attack_result, damage_efficiency, hit_weakspot = RangedAction.execute_attack(target_index, player_unit, target_unit, actor, hit_position, hit_distance, direction, hit_normal, hit_zone_name, damage_profile, damage_profile_lerp_values, DEFAULT_POWER_LEVEL, charge_level, penetrated, damage_config, instakill, damage_type, is_critical_strike, weapon_item)
	local killing_blow = attack_result == AttackSettings.attack_results.died
	self._killing_blow = self._killing_blow or killing_blow
end

ActionFlamerGas._burn_targets = function (self, dt, t, force_burn)
	local player_unit = self._player_unit
	local weapon_item = self._weapon.item
	local burn_time = self._burn_time - dt
	local is_critical_strike = self._critical_strike_component.is_active
	local max_stacks = self._dot_max_stacks
	local number_of_stacks = is_critical_strike and 2 or 1

	if burn_time <= 0 or force_burn then
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

						if current_stacks < max_stacks then
							buff_extension:add_internally_controlled_buff_with_stacks(dot_buff_name, number_of_stacks, start_time_with_offset, "owner_unit", player_unit, "source_item", weapon_item)
						elseif current_stacks == max_stacks then
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

		local killing_blow = self._killing_blow
		local has_targets = killing_blow or not table.is_empty(self._target_indexes) or not table.is_empty(self._dot_targets)
		local shot_result = self._shot_result
		shot_result.data_valid = true
		shot_result.hit_minion = has_targets
		shot_result.hit_weakspot = false
		shot_result.killing_blow = killing_blow
	end

	local action_component = self._action_component
	local attacker_buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local param_table = attacker_buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.attacking_unit = player_unit
		param_table.num_shots_fired = action_component.num_shots_fired
		param_table.combo_count = self._combo_count

		attacker_buff_extension:add_proc_event(proc_events.on_shoot, param_table)
	end

	self._killing_blow = false
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
	if self._is_server then
		self:_damage_targets(0, t, true)
		self:_burn_targets(0, t, true)
	end

	ActionFlamerGas.super.finish(self, reason, data, t, time_in_action)

	local position_finder_component = self._action_module_position_finder_component
	position_finder_component.position = Vector3.zero()
	position_finder_component.position_valid = false
	local action_settings = self._action_settings
	local fire_config = action_settings.fire_configuration

	if fire_config.charge_cost then
		self._action_module_charge_component.charge_level = 0
	end
end

ActionFlamerGas.running_action_state = function (self, t, time_in_action)
	local action_settings = self._action_settings
	local fire_config = action_settings.fire_configuration

	if fire_config.charge_cost then
		local charge_component = self._action_module_charge_component

		if charge_component.charge_level <= 0 then
			return "charge_depleted"
		end
	else
		local inventory_slot_component = self._inventory_slot_component
		local current_ammo_clip = inventory_slot_component.current_ammunition_clip
		local current_ammo_reserve = inventory_slot_component.current_ammunition_reserve

		if current_ammo_clip == 0 then
			if current_ammo_reserve > 0 then
				return "clip_empty"
			else
				return "reserve_empty"
			end
		end
	end

	return nil
end

return ActionFlamerGas
