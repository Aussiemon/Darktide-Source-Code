-- chunkname: @scripts/extension_systems/weapon/actions/action_flamer_gas_burst.lua

require("scripts/extension_systems/weapon/actions/action_shoot")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FlamerAction = require("scripts/utilities/action/flamer_action")
local FriendlyFire = require("scripts/utilities/attack/friendly_fire")
local HazardProp = require("scripts/utilities/level_props/hazard_prop")
local HitMass = require("scripts/utilities/attack/hit_mass")
local HitScan = require("scripts/utilities/attack/hit_scan")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Spread = require("scripts/utilities/spread")
local damage_types = DamageSettings.damage_types
local proc_events = BuffSettings.proc_events
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local DEFAULT_DAMAGE_TYPE = damage_types.burning
local NUM_RAYS_PER_FRAME = 8
local ATTACK_TYPE = AttackSettings.attack_types.ranged
local ActionFlamerGasBurst = class("ActionFlamerGasBurst", "ActionShoot")

ActionFlamerGasBurst.init = function (self, action_context, action_params, action_settings)
	ActionFlamerGasBurst.super.init(self, action_context, action_params, action_settings)

	self._target_damage_times = {}
	self._target_hit_mass_lerp_t = {}
	self._target_actors = {}
	self._target_dot_stacks = {}
	self._target_dot_damage_times = {}
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

	self._size_of_flame_template = size_of_flame_template
	self._action_flamer_gas_component.range = size_of_flame_template.range
end

ActionFlamerGasBurst.start = function (self, action_settings, t, ...)
	ActionFlamerGasBurst.super.start(self, action_settings, t, ...)
	table.clear(self._target_damage_times)
	table.clear(self._target_hit_mass_lerp_t)
	table.clear(self._target_actors)
	table.clear(self._target_dot_stacks)
	table.clear(self._target_dot_damage_times)

	self._killing_blow = false

	self:_setup_flame_data(action_settings)
end

ActionFlamerGasBurst.fixed_update = function (self, dt, t, time_in_action, frame)
	ActionFlamerGasBurst.super.fixed_update(self, dt, t, time_in_action, frame)

	if not self._flamer_gas_template then
		self:_setup_flame_data(self._action_settings)
	end

	if self._is_server then
		self:_damage_and_burn_targets(t, false)
	end
end

ActionFlamerGasBurst._shoot = function (self, position, rotation, power_level, charge_level, t)
	local player_unit = self._player_unit

	self:_acquire_targets(t)

	if self._is_server then
		FlamerAction.suppress_targets(t, player_unit, rotation, self._flamer_gas_template, self._size_of_flame_template)

		local killing_blow = self._killing_blow
		local has_targets = killing_blow or not table.is_empty(self._target_damage_times) or not table.is_empty(self._target_dot_damage_times)
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
		param_table.is_critical_strike = self._critical_strike_component.is_active

		attacker_buff_extension:add_proc_event(proc_events.on_shoot, param_table)
	end

	self._killing_blow = false
end

local INDEX_POSITION = 1
local INDEX_NORMAL = 3
local INDEX_ACTOR = 4

ActionFlamerGasBurst._process_hits = function (self, t, hits, player_unit, player_pos, side_system, hit_units, hit_mass_budget_attack, hit_mass_budget_impact, is_server)
	if not hits then
		return false, nil, nil, hit_mass_budget_attack, hit_mass_budget_impact
	end

	local target_damage_times = self._target_damage_times
	local target_dot_stacks = self._target_dot_stacks
	local target_dot_damage_times = self._target_dot_damage_times
	local target_hit_mass_lerp_t = self._target_hit_mass_lerp_t
	local target_actors = self._target_actors
	local num_hits = #hits

	for ii = 1, num_hits do
		repeat
			local hit = hits[ii]
			local hit_pos = hit[INDEX_POSITION]
			local hit_actor = hit[INDEX_ACTOR]
			local hit_normal = hit[INDEX_NORMAL]
			local hit_unit = Actor.unit(hit_actor)
			local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
			local hit_afro = hit_zone_name_or_nil == HitZone.hit_zone_names.afro
			local is_critical_strike = self._critical_strike_component.is_active

			if hit_units[hit_unit] then
				break
			end

			if hit_afro then
				break
			end

			if hit_unit == player_unit then
				break
			end

			local target_health_extension = ScriptUnit.has_extension(hit_unit, "health_system")
			local target_buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

			if not target_health_extension and not target_buff_extension or FlamerAction.is_unit_blocking_flame(hit_unit, player_pos, hit_zone_name_or_nil) then
				return true, hit_pos, hit_normal, hit_mass_budget_attack, hit_mass_budget_impact
			end

			if side_system:is_ally(player_unit, hit_unit) and not FriendlyFire.is_enabled(player_unit, hit_unit) then
				break
			end

			local max_range = self._size_of_flame_template.range
			local distance = Vector3.distance(POSITION_LOOKUP[player_unit], POSITION_LOOKUP[hit_unit])
			local damage_time = distance / max_range * 0.5

			if is_server then
				local max_hit_mass_budget = self._max_hit_mass_budget
				local hit_mass_lerp_t = math.max(hit_mass_budget_attack, hit_mass_budget_impact) / max_hit_mass_budget

				if target_health_extension then
					target_damage_times[hit_unit] = t + damage_time
					target_hit_mass_lerp_t[hit_unit] = hit_mass_lerp_t
					target_actors[hit_unit] = hit_actor
				end

				if target_buff_extension then
					local flamer_gas_template = self._flamer_gas_template
					local num_stacks_base = flamer_gas_template.num_stacks_base
					local num_stacks_hit_mass_limit = flamer_gas_template.num_stacks_hit_mass_limit
					local num_extra_stacks_crit = flamer_gas_template.num_extra_stacks_crit
					local reached_hit_mass_limit = HitMass.hit_mass_limit_reached(hit_mass_budget_attack, hit_mass_budget_impact)
					local num_stacks_to_add = (not reached_hit_mass_limit and num_stacks_base or num_stacks_hit_mass_limit) + (is_critical_strike and num_extra_stacks_crit or 0)

					if num_stacks_to_add > 0 then
						target_dot_stacks[hit_unit] = num_stacks_to_add
						target_dot_damage_times[hit_unit] = t + damage_time
					end
				end

				hit_mass_budget_attack, hit_mass_budget_impact = HitMass.consume_hit_mass(player_unit, hit_unit, hit_mass_budget_attack, hit_mass_budget_impact, false, is_critical_strike, ATTACK_TYPE, nil)
			end

			hit_units[hit_unit] = true
		until true
	end

	return false, nil, nil, hit_mass_budget_attack, hit_mass_budget_impact
end

ActionFlamerGasBurst._do_raycast = function (self, t, ray_index, position, rotation, max_range, spread_angle, player_unit, player_pos, side_system, hit_units, remaining_hit_mass_budget_attack, remaining_hit_mass_budget_impact, is_server)
	local bullseye = true
	local ray_rotation = Spread.target_style_spread(rotation, ray_index, NUM_RAYS_PER_FRAME, 2, bullseye, spread_angle, spread_angle, nil, false, nil, math.random_seed())
	local direction = Quaternion.forward(ray_rotation)
	local rewind_ms = self:_rewind_ms(self._is_local_unit, self._player, position, direction, max_range)
	local hits = HitScan.raycast(self._physics_world, position, direction, max_range, nil, "filter_player_character_shooting_raycast", rewind_ms)

	return self:_process_hits(t, hits, player_unit, player_pos, side_system, hit_units, remaining_hit_mass_budget_attack, remaining_hit_mass_budget_impact, is_server)
end

local _hit_units = {}

ActionFlamerGasBurst._acquire_targets = function (self, t)
	table.clear(_hit_units)

	local is_server = self._is_server
	local player_unit = self._player_unit
	local player_pos = POSITION_LOOKUP[player_unit]
	local spread_angle = self._size_of_flame_template.spread_angle
	local max_range = self._size_of_flame_template.range
	local position = self._first_person_component.position
	local rotation = self._first_person_component.rotation
	local position_finder_component = self._action_module_position_finder_component
	local side_system = Managers.state.extension:system("side_system")
	local flamer_gas_template = self._flamer_gas_template
	local damage_config = flamer_gas_template.damage
	local damage_profile = damage_config.impact.damage_profile
	local is_critical_strike = self._critical_strike_component.is_active
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, player_unit)
	local hit_mass_budget_attack, hit_mass_budget_impact = DamageProfile.max_hit_mass(damage_profile, DEFAULT_POWER_LEVEL, 1, damage_profile_lerp_values, is_critical_strike, player_unit, ATTACK_TYPE)

	self._max_hit_mass_budget = math.max(hit_mass_budget_attack, hit_mass_budget_impact)

	local stop, stop_position, stop_normal, _
	local remaining_hit_mass_budget_attack, remaining_hit_mass_budget_impact = hit_mass_budget_attack, hit_mass_budget_impact

	stop, stop_position, stop_normal, remaining_hit_mass_budget_attack, remaining_hit_mass_budget_impact = self:_do_raycast(t, 1, position, rotation, max_range, spread_angle, player_unit, player_pos, side_system, _hit_units, remaining_hit_mass_budget_attack, remaining_hit_mass_budget_impact, is_server)

	if stop then
		position_finder_component.position = stop_position
		position_finder_component.normal = stop_normal
		position_finder_component.position_valid = true
	else
		position_finder_component.position_valid = false
	end

	if is_server then
		for ii = 2, NUM_RAYS_PER_FRAME do
			_, _, _, remaining_hit_mass_budget_attack, remaining_hit_mass_budget_impact = self:_do_raycast(t, ii, position, rotation, max_range, spread_angle, player_unit, player_pos, side_system, _hit_units, remaining_hit_mass_budget_attack, remaining_hit_mass_budget_impact, is_server)
		end
	end
end

ActionFlamerGasBurst._damage_and_burn_targets = function (self, t, force_trigger)
	local target_damage_times = self._target_damage_times
	local target_actors = self._target_actors
	local target_hit_mass_lerp_t = self._target_hit_mass_lerp_t
	local ALIVE = ALIVE

	for target_unit, damage_t in pairs(target_damage_times) do
		local hit_mass_lerp_t = target_hit_mass_lerp_t[target_unit]
		local hit_actor = target_actors[target_unit]
		local hit_zone_name_or_nil = HitZone.get_name(target_unit, hit_actor)
		local target_breed_or_nil = Breed.unit_breed_or_nil(target_unit)
		local target_is_hazard_prop, hazard_prop_is_active = HazardProp.status(target_unit)
		local is_breed_with_hit_zone = target_breed_or_nil and hit_zone_name_or_nil
		local should_deal_damage = target_is_hazard_prop and hazard_prop_is_active or not target_is_hazard_prop and is_breed_with_hit_zone or not target_breed_or_nil

		if ALIVE[target_unit] and ScriptUnit.has_extension(target_unit, "health_system") and should_deal_damage then
			if damage_t < t or force_trigger then
				local player_unit = self._player_unit
				local target_index = 1
				local damage_type = self._damage_type
				local is_critical_strike = self._critical_strike_component.is_active
				local flamer_gas_template = self._flamer_gas_template
				local weapon = self._weapon
				local buff_extension = self._buff_extension
				local target_died = FlamerAction.damage_target(player_unit, target_unit, target_index, hit_mass_lerp_t, damage_type, is_critical_strike, flamer_gas_template, weapon, buff_extension)

				self._killing_blow = self._killing_blow or target_died
				target_damage_times[target_unit] = nil
				target_hit_mass_lerp_t[target_unit] = nil
				target_actors[target_unit] = nil
			end
		else
			target_damage_times[target_unit] = nil
			target_hit_mass_lerp_t[target_unit] = nil
			target_actors[target_unit] = nil
		end
	end

	local target_dot_damage_times = self._target_dot_damage_times

	for target_unit, damage_t in pairs(target_dot_damage_times) do
		if ALIVE[target_unit] and ScriptUnit.has_extension(target_unit, "buff_system") then
			if damage_t < t or force_trigger then
				self:_burn_target(t, target_unit)

				target_dot_damage_times[target_unit] = nil
			end
		else
			target_dot_damage_times[target_unit] = nil
		end
	end
end

ActionFlamerGasBurst._burn_target = function (self, t, target_unit)
	local player_unit = self._player_unit
	local weapon_item = self._weapon.item
	local dot_buff_name = self._flamer_gas_template.dot_buff_name
	local buff_extension = ScriptUnit.extension(target_unit, "buff_system")
	local current_stacks = buff_extension:current_stacks(dot_buff_name)
	local start_time_with_offset = t + math.random() * 0.5
	local max_stacks = self._dot_max_stacks
	local target_dot_stacks = self._target_dot_stacks
	local num_stacks = target_dot_stacks[target_unit]

	if current_stacks < max_stacks then
		buff_extension:add_internally_controlled_buff_with_stacks(dot_buff_name, num_stacks, start_time_with_offset, "owner_unit", player_unit, "source_item", weapon_item)
	elseif current_stacks == max_stacks then
		buff_extension:refresh_duration_of_stacking_buff(dot_buff_name, start_time_with_offset)
	end
end

ActionFlamerGasBurst.finish = function (self, reason, data, t, time_in_action)
	if self._is_server then
		self:_damage_and_burn_targets(t, true)
	end

	ActionFlamerGasBurst.super.finish(self, reason, data, t, time_in_action)

	local position_finder_component = self._action_module_position_finder_component

	position_finder_component.position = Vector3.zero()
	position_finder_component.position_valid = false
end

return ActionFlamerGasBurst
