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
local Suppression = require("scripts/utilities/attack/suppression")
local Spread = require("scripts/utilities/spread")
local proc_events = BuffSettings.proc_events
local damage_types = DamageSettings.damage_types
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local DEFAULT_DAMAGE_TYPE = damage_types.burning
local ActionFlamerGasBurst = class("ActionFlamerGasBurst", "ActionShoot")

ActionFlamerGasBurst.init = function (self, action_context, action_params, action_settings)
	ActionFlamerGasBurst.super.init(self, action_context, action_params, action_settings)

	self._targets = {}
	self._dot_targets = {}
	self._killing_blow = false
	self._action_module_position_finder_component = action_context.unit_data_extension:write_component("action_module_position_finder")
	self._action_flamer_gas_component = action_context.unit_data_extension:write_component("action_flamer_gas")
	local fire_config = action_settings.fire_configuration
	self._damage_type = fire_config and fire_config.damage_type or DEFAULT_DAMAGE_TYPE
end

ActionFlamerGasBurst._setup_flame_data = function (self, action_settings)
	local fire_config = action_settings.fire_configuration
	local flamer_gas_template = fire_config.flamer_gas_template
	self._flamer_gas_template = flamer_gas_template
	local weapon_extension = self._weapon_extension
	local burninating_template = weapon_extension:burninating_template()
	self._dot_max_stacks = math.ceil(burninating_template.max_stacks)
	local size_of_flame_template = weapon_extension:size_of_flame_template()
	self._spread_angle = size_of_flame_template.spread_angle
	self._suppression_cone_radius = size_of_flame_template.suppression_cone_radius
	local range = size_of_flame_template.range
	self._range = range
	self._action_flamer_gas_component.range = range
end

ActionFlamerGasBurst.start = function (self, action_settings, t, ...)
	ActionFlamerGasBurst.super.start(self, action_settings, t, ...)
	table.clear(self._targets)
	table.clear(self._dot_targets)

	self._killing_blow = false

	self:_setup_flame_data(action_settings)
end

ActionFlamerGasBurst.fixed_update = function (self, dt, t, time_in_action)
	if not self._flamer_gas_template then
		self:_setup_flame_data(self._action_settings)
	end

	ActionFlamerGasBurst.super.fixed_update(self, dt, t, time_in_action)

	if not self._is_server then
		return
	end

	self:_damage_and_burn_targets(t, false)
end

ActionFlamerGasBurst._shoot = function (self, position, rotation, power_level, charge_level, t)
	local player_unit = self._player_unit

	self:_acquire_targets(t)

	if self._is_server then
		local damage_config = self._flamer_gas_template.damage
		local damage_profile = damage_config.impact.damage_profile
		local units = self:_acquire_suppressed_units(t)

		for hit_unit, _ in pairs(units) do
			Suppression.apply_suppression(hit_unit, player_unit, damage_profile, POSITION_LOOKUP[player_unit])
		end

		local killing_blow = self._killing_blow
		local has_targets = killing_blow or not table.is_empty(self._targets) or not table.is_empty(self._dot_targets)
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

local INDEX_POSITION = 1
local INDEX_NORMAL = 3
local INDEX_ACTOR = 4

ActionFlamerGasBurst._is_unit_blocking = function (self, unit, player_pos)
	local shield_extension = ScriptUnit.has_extension(unit, "shield_system")

	if shield_extension then
		return shield_extension:can_block_from_position(player_pos)
	end
end

ActionFlamerGasBurst._process_hit = function (self, hit, targets, player_unit, player_pos, side_system, dot_targets, t, is_server)
	local hit_pos = hit[INDEX_POSITION]
	local hit_actor = hit[INDEX_ACTOR]
	local hit_normal = hit[INDEX_NORMAL]
	local hit_unit = Actor.unit(hit_actor)
	local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
	local hit_afro = hit_zone_name_or_nil == HitZone.hit_zone_names.afro

	if targets[hit_unit] then
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

	local distance = Vector3.distance(POSITION_LOOKUP[player_unit], POSITION_LOOKUP[hit_unit])
	local distance_scalar = distance / self._range
	local t_offset = distance_scalar * 0.5

	if is_server and health_extension then
		targets[hit_unit] = t + t_offset
	end

	if is_server and buff_extension then
		dot_targets[hit_unit] = t + t_offset
	end

	return false
end

ActionFlamerGasBurst._do_raycast = function (self, i, position, rotation, max_range, num_rays_this_frame, spread_angle, targets, player_unit, player_pos, side_system, dot_targets, t, is_server)
	local bullseye = true
	local ray_rotation = Spread.target_style_spread(rotation, i, num_rays_this_frame, 2, bullseye, spread_angle, spread_angle, nil, false, nil, math.random_seed())
	local direction = Quaternion.forward(ray_rotation)
	local rewind_ms = self:_rewind_ms(self._is_local_unit, self._player, position, direction, max_range)
	local hits = HitScan.raycast(self._physics_world, position, direction, max_range, nil, "filter_player_character_shooting_raycast", rewind_ms)
	local stop, stop_position, stop_normal = nil

	if hits then
		local num_hit_results = #hits

		for j = 1, num_hit_results do
			repeat
				local hit = hits[j]
				stop, stop_position, stop_normal = self:_process_hit(hit, targets, player_unit, player_pos, side_system, dot_targets, t, is_server)
			until true

			if stop then
				break
			end
		end
	end

	return stop, stop_position, stop_normal
end

ActionFlamerGasBurst._acquire_targets = function (self, t)
	local is_server = self._is_server
	local targets = self._targets
	local dot_targets = self._dot_targets
	local player_unit = self._player_unit
	local player_pos = POSITION_LOOKUP[player_unit]
	local spread_angle = self._spread_angle
	local max_range = self._range
	local position = self._first_person_component.position
	local rotation = self._first_person_component.rotation
	local position_finder_component = self._action_module_position_finder_component
	local side_system = Managers.state.extension:system("side_system")
	local num_rays_this_frame = 8
	local stop, stop_position, stop_normal = self:_do_raycast(1, position, rotation, max_range, num_rays_this_frame, spread_angle, targets, player_unit, player_pos, side_system, dot_targets, t, is_server)

	if stop then
		position_finder_component.position = stop_position
		position_finder_component.normal = stop_normal
		position_finder_component.position_valid = true
	else
		position_finder_component.position_valid = false
	end

	if is_server then
		for i = 2, num_rays_this_frame do
			self:_do_raycast(i, position, rotation, max_range, num_rays_this_frame, spread_angle, targets, player_unit, player_pos, side_system, dot_targets, t, is_server)
		end
	end
end

ActionFlamerGasBurst._damage_and_burn_targets = function (self, t, force_trigger)
	local targets = self._targets
	local ALIVE = ALIVE

	for target_unit, hit_t in pairs(targets) do
		if ALIVE[target_unit] and ScriptUnit.has_extension(target_unit, "health_system") then
			if hit_t < t or force_trigger then
				self:_damage_target(target_unit)

				targets[target_unit] = nil
			end
		else
			targets[target_unit] = nil
		end
	end

	local dot_targets = self._dot_targets

	for target_unit, hit_t in pairs(dot_targets) do
		if ALIVE[target_unit] and ScriptUnit.has_extension(target_unit, "buff_system") then
			if hit_t < t or force_trigger then
				self:_burn_target(t, target_unit)

				dot_targets[target_unit] = nil
			end
		else
			dot_targets[target_unit] = nil
		end
	end
end

ActionFlamerGasBurst._damage_target = function (self, target_unit)
	local player_unit = self._player_unit
	local damage_config = self._flamer_gas_template.damage
	local damage_profile = damage_config.impact.damage_profile
	local player_pos = POSITION_LOOKUP[player_unit]
	local target_pos = POSITION_LOOKUP[target_unit]
	local target_index = 1
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

ActionFlamerGasBurst._burn_target = function (self, t, target_unit)
	local player_unit = self._player_unit
	local weapon_item = self._weapon.item
	local dot_buff_name = self._flamer_gas_template.dot_buff_name
	local buff_extension = ScriptUnit.extension(target_unit, "buff_system")
	local current_stacks = buff_extension:current_stacks(dot_buff_name)
	local start_time_with_offset = t + math.random() * 0.5
	local is_critical_strike = self._critical_strike_component.is_active
	local max_stacks = self._dot_max_stacks
	local number_of_stacks = is_critical_strike and 2 or 1

	if current_stacks < max_stacks then
		buff_extension:add_internally_controlled_buff_with_stacks(dot_buff_name, number_of_stacks, start_time_with_offset, "owner_unit", player_unit, "source_item", weapon_item)
	elseif current_stacks == max_stacks then
		buff_extension:refresh_duration_of_stacking_buff(dot_buff_name, start_time_with_offset)
	end
end

local broadphase_results = {}
local suppressed_units = {}

ActionFlamerGasBurst._acquire_suppressed_units = function (self, t)
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

ActionFlamerGasBurst.finish = function (self, reason, data, t, time_in_action)
	self:_damage_and_burn_targets(t, true)
	ActionFlamerGasBurst.super.finish(self, reason, data, t, time_in_action)

	local position_finder_component = self._action_module_position_finder_component
	position_finder_component.position = Vector3.zero()
	position_finder_component.position_valid = false
end

return ActionFlamerGasBurst
