-- chunkname: @scripts/extension_systems/weapon/actions/action_shoot_hit_scan.lua

require("scripts/extension_systems/weapon/actions/action_shoot")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningAction = require("scripts/extension_systems/weapon/actions/utilities/chain_lightning_action")
local Health = require("scripts/utilities/health")
local HitScan = require("scripts/utilities/attack/hit_scan")
local MinionState = require("scripts/utilities/minion_state")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local RangedAction = require("scripts/utilities/action/ranged_action")
local BROADPHASE_RESULTS = {}
local _on_chain_node_add_func, _on_chain_node_remove_func
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local attack_results = AttackSettings.attack_results
local proc_events = BuffSettings.proc_events
local buff_keywords = BuffSettings.keywords
local buff_group_keywords = BuffSettings.group_keywords
local ActionShootHitScan = class("ActionShootHitScan", "ActionShoot")
local IMPACT_FX_DATA = {
	will_be_predicted = true,
}
local ALL_HITS = {}
local INDEX_DISTANCE = 2
local _hit_sort_function, _find_line_effect

ActionShootHitScan.init = function (self, action_context, action_params, action_settings)
	ActionShootHitScan.super.init(self, action_context, action_params, action_settings)

	if action_settings.weapon_chain_lightning_template then
		local weapon_tweak_templates_component = self._weapon_tweak_templates_component

		weapon_tweak_templates_component.weapon_chain_lightning_template_name = action_settings.weapon_chain_lightning_template

		local chain_lightning_action_data = {}
		local weapon_chain_lightning_template = self._weapon_extension:weapon_chain_lightning_template()

		ChainLightningAction.init_chain_lightning(chain_lightning_action_data, self._weapon, self._weapon_template, action_context, action_settings, weapon_chain_lightning_template, _on_chain_node_add_func, _on_chain_node_remove_func, "target_alive_and_electrocuted_or_previous_electrocuted")

		self._chain_lightning_action_data = chain_lightning_action_data
		self._do_chain_lightning_on_shoot = true
	end
end

ActionShootHitScan.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionShootHitScan.super.start(self, action_settings, t, time_scale, action_start_params)

	if self._is_server and self._do_chain_lightning_on_shoot then
		ChainLightningAction.action_start(self._chain_lightning_action_data)
	end
end

ActionShootHitScan._try_make_chain_from_shoot = function (self, hit_results_per_unit, t)
	local root_unit_for_chain, last_hit_minion = self:_try_find_furthest_alive_minion_hit(hit_results_per_unit)

	if not root_unit_for_chain and last_hit_minion then
		root_unit_for_chain = self:_try_find_closest_enemy_to_furthest_dead_enemy_hit(last_hit_minion, t)

		if self._is_server and root_unit_for_chain then
			Managers.stats:record_private("hook_weapon_chain_lightning_jump_triggered", self._player)
		end
	end

	if root_unit_for_chain then
		ChainLightningAction.make_chain_from_target(self._chain_lightning_action_data, root_unit_for_chain, t)
	end
end

ActionShootHitScan._try_find_furthest_alive_minion_hit = function (self, hit_results_per_unit)
	local root_unit_for_chain, last_hit_minion

	for hit_index = #hit_results_per_unit, 1, -1 do
		local hit_unit = hit_results_per_unit[hit_index].hit_unit
		local hit_result = hit_results_per_unit[hit_index].hit_result
		local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
		local target_breed = unit_data_extension and unit_data_extension:breed()
		local is_minion = target_breed and Breed.is_minion(target_breed) and hit_result ~= attack_results.friendly_fire and not Health.is_ragdolled(hit_unit) or false
		local is_valid_attack_result = hit_result == attack_results.damaged or hit_result == attack_results.blocked or hit_result == attack_results.shield_blocked or hit_result == attack_results.toughness_absorbed or hit_result == attack_results.shield_absorbed

		if is_minion and HEALTH_ALIVE[hit_unit] and is_valid_attack_result then
			root_unit_for_chain = hit_unit

			break
		elseif not last_hit_minion and is_minion then
			last_hit_minion = hit_unit
		end
	end

	return root_unit_for_chain, last_hit_minion
end

ActionShootHitScan._try_find_closest_enemy_to_furthest_dead_enemy_hit = function (self, last_hit_minion, t)
	local player_unit = self._player_unit
	local action_settings = self._action_settings
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local valid_target_unit

	table.clear(BROADPHASE_RESULTS)

	local stat_buffs = self._buff_extension:stat_buffs()
	local chain_settings = action_settings.chain_settings
	local time_in_action = t - self._weapon_action_component.start_t
	local _, _, _, _, _, radius, _ = ChainLightning.targeting_parameters(time_in_action, chain_settings, stat_buffs)
	local broadphase_position = POSITION_LOOKUP[last_hit_minion] or Unit.world_position(last_hit_minion, 1)
	local num_results = broadphase.query(broadphase, broadphase_position, radius, BROADPHASE_RESULTS, enemy_side_names)

	for i = 1, num_results do
		local target_unit = BROADPHASE_RESULTS[i]

		if target_unit ~= last_hit_minion and HEALTH_ALIVE[target_unit] then
			local target_unit_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
			local is_electrocuted = MinionState.is_electrocuted(target_unit_buff_extension, buff_group_keywords.electrocuted)

			if is_electrocuted then
				valid_target_unit = target_unit

				break
			else
				valid_target_unit = valid_target_unit or target_unit
			end
		end
	end

	return valid_target_unit
end

ActionShootHitScan.finish = function (self, reason, data, t, time_in_action, action_settings, next_action_params)
	if self._do_chain_lightning_on_shoot then
		ChainLightningAction.action_finish(self._chain_lightning_action_data)
	end

	ActionShootHitScan.super.finish(self, reason, data, t, time_in_action)
end

ActionShootHitScan._shoot = function (self, position, rotation, power_level, charge_level, t, fire_config)
	local debug_drawer = self._debug_drawer
	local is_local_unit = self._is_local_unit
	local is_server = self._is_server
	local physics_world = self._physics_world
	local player = self._player
	local player_unit = self._player_unit
	local world = self._world
	local weapon_item = self._weapon.item
	local wielded_slot = self._inventory_component.wielded_slot
	local action_settings = self._action_settings
	local hit_scan_template = fire_config.hit_scan_template
	local max_distance = hit_scan_template.range
	local is_critical_strike = self._critical_strike_component.is_active
	local direction = Quaternion.forward(rotation)
	local instakill = false
	local end_position, hit_elite, hit_weakspot, killing_blow, hit_minion, num_hit_units, hit_scan_result, hit_results_per_unit
	local rewind_ms = self:_rewind_ms(is_local_unit, player, position, direction, max_distance)

	power_level = hit_scan_template.power_level or power_level or DEFAULT_POWER_LEVEL

	local collision_tests = hit_scan_template.collision_tests

	if collision_tests then
		table.clear(ALL_HITS)

		for i = 1, #collision_tests do
			local config = collision_tests[i]
			local test = config.test
			local against = config.against
			local collision_filter = config.collision_filter
			local radius = config.radius

			if test == "ray" then
				local hits = HitScan.raycast(physics_world, position, direction, max_distance, against, collision_filter, rewind_ms, is_local_unit, player, is_server)

				if hits then
					table.append(ALL_HITS, hits)
				end
			elseif test == "sphere" then
				local hits = HitScan.sphere_sweep(physics_world, position, direction, max_distance, against, collision_filter, rewind_ms, radius)

				if hits then
					table.append(ALL_HITS, hits)
				end
			end
		end

		table.sort(ALL_HITS, _hit_sort_function)

		end_position, hit_elite, hit_weakspot, killing_blow, hit_minion, num_hit_units, hit_scan_result, hit_results_per_unit = HitScan.process_hits(is_server, world, physics_world, player_unit, fire_config, ALL_HITS, position, direction, power_level, charge_level, IMPACT_FX_DATA, max_distance, debug_drawer, is_local_unit, player, instakill, is_critical_strike, weapon_item, wielded_slot, true)
	else
		local hits = HitScan.raycast(physics_world, position, direction, max_distance, nil, nil, rewind_ms, is_local_unit, player, is_server)

		end_position, hit_elite, hit_weakspot, killing_blow, hit_minion, num_hit_units, hit_scan_result, hit_results_per_unit = HitScan.process_hits(is_server, world, physics_world, player_unit, fire_config, hits, position, direction, power_level, charge_level, IMPACT_FX_DATA, max_distance, debug_drawer, is_local_unit, player, instakill, is_critical_strike, weapon_item, wielded_slot, true)
	end

	if self._do_chain_lightning_on_shoot and #hit_results_per_unit > 0 then
		self:_try_make_chain_from_shoot(hit_results_per_unit, t)
	end

	local action_component = self._action_component
	local attacker_buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local param_table = attacker_buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.attacking_unit = player_unit
		param_table.num_shots_fired = action_component.num_shots_fired
		param_table.combo_count = self._combo_count
		param_table.hit_elite = hit_elite
		param_table.hit_weakspot = hit_weakspot
		param_table.num_hit_units = num_hit_units
		param_table.is_critical_strike = is_critical_strike

		attacker_buff_extension:add_proc_event(proc_events.on_shoot, param_table)
	end

	end_position = end_position or position + direction * max_distance

	local fx_settings = action_settings.fx
	local line_effect = _find_line_effect(fx_settings, charge_level)

	self:_play_line_fx(line_effect, position, end_position, self:_reference_attachment_id(fire_config))

	local shot_result = self._shot_result

	shot_result.data_valid = true
	shot_result.hit_minion = hit_minion
	shot_result.hit_weakspot = hit_weakspot
	shot_result.killing_blow = killing_blow
end

function _hit_sort_function(entry_1, entry_2)
	local distance_1 = entry_1.distance or entry_1[INDEX_DISTANCE]
	local distance_2 = entry_2.distance or entry_2[INDEX_DISTANCE]

	return distance_1 < distance_2
end

function _find_line_effect(fx_settings, charge_level)
	if not fx_settings then
		return nil
	end

	local line_effect_to_play = fx_settings.line_effect
	local is_charge_dependant = fx_settings.is_charge_dependant

	if is_charge_dependant then
		local line_effect_table = line_effect_to_play

		line_effect_to_play = nil

		for i = 1, #line_effect_table do
			local entry = line_effect_table[i]
			local required_charge = entry.charge_level
			local line_effect = entry.line_effect

			if required_charge <= charge_level then
				line_effect_to_play = line_effect
			end
		end
	end

	return line_effect_to_play
end

function _on_chain_node_add_func(node, context)
	local target_unit = node:value("unit")
	local start_t = node:value("start_t") or 0

	context.hit_units[target_unit] = true

	local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if target_buff_extension then
		local target_buff = "arc_spread_target"

		target_buff_extension:add_internally_controlled_buff(target_buff, start_t, "owner_unit", context.player_unit, "source_item", context.source_item)
	end
end

function _on_chain_node_remove_func(node, context)
	local target_unit = node:value("unit")

	context.hit_units[target_unit] = nil
end

return ActionShootHitScan
