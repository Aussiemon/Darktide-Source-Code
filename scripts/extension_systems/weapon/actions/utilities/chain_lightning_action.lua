-- chunkname: @scripts/extension_systems/weapon/actions/utilities/chain_lightning_action.lua

local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTarget = require("scripts/utilities/action/chain_lightning_target")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ChainLightningAction = {}
local ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS = {
	"target_unit_1",
	"target_unit_2",
	"target_unit_3",
}
local BREADTH_FIRST_VALIDATION = ChainLightning.breadth_first_validation_functions
local DEPTH_FIRST_VALIDATION = ChainLightning.depth_first_validation_functions
local JUMP_VALIDATION = ChainLightning.jump_validation_functions
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local DEFAULT_POWER_LEVEL_RANDOM_RANGE = {
	max = 1.25,
	min = 0.75,
}
local Vector3_flat = Vector3.flat
local Vector3_normalize = Vector3.normalize
local _create_chain_root_node, _reset_chain_lightning, _clear_initial_targets, _add_root_target, _find_new_targets, _find_new_chain_targets, _deal_chain_lightning_damage

ChainLightningAction.init_chain_lightning = function (chain_lightning_action_data, weapon, weapon_template, action_context, action_settings, weapon_chain_lightning_template, on_chain_node_add_func, on_chain_node_remove_func, optional_chain_jump_validation_function_name)
	chain_lightning_action_data.action_context = action_context
	chain_lightning_action_data.action_settings = action_settings
	chain_lightning_action_data.weapon_chain_lightning_template = weapon_chain_lightning_template
	chain_lightning_action_data.is_server = action_context.is_server
	chain_lightning_action_data.physics_world = action_context.physics_world
	chain_lightning_action_data.player = action_context.player
	chain_lightning_action_data.player_unit = action_context.player_unit
	chain_lightning_action_data.weapon_chain_settings = weapon_template.chain_settings
	chain_lightning_action_data.world = action_context.world
	chain_lightning_action_data.chain_jump_validation_function_or_nil = optional_chain_jump_validation_function_name and JUMP_VALIDATION[optional_chain_jump_validation_function_name] or nil
	chain_lightning_action_data.on_chain_node_add_func = on_chain_node_add_func
	chain_lightning_action_data.on_chain_node_remove_func = on_chain_node_remove_func

	local unit_data_extension = action_context.unit_data_extension
	local targeting_module_component = unit_data_extension:write_component("action_module_target_finder")

	chain_lightning_action_data.critical_strike_component = action_context.critical_strike_component
	chain_lightning_action_data.first_person_component = action_context.first_person_component
	chain_lightning_action_data.targeting_module_component = targeting_module_component
	chain_lightning_action_data.weapon_action_component = action_context.weapon_action_component

	local player_unit = action_context.player_unit
	local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")
	local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

	chain_lightning_action_data.func_context = {
		action_settings = action_settings,
		buff_extension = buff_extension,
		hit_units = chain_lightning_action_data.chain_lightning_hit_units,
		player_unit = player_unit,
		talent_extension = talent_extension,
		source_item = weapon and weapon.item,
	}

	if action_context.is_server then
		chain_lightning_action_data.chain_root_node = nil
		chain_lightning_action_data.chain_lightning_hit_units = {}
		chain_lightning_action_data.chain_lightning_temp_targets = {}
		chain_lightning_action_data.func_context.hit_units = chain_lightning_action_data.chain_lightning_hit_units

		chain_lightning_action_data.chain_jump_on_add_func = function (node, func_context)
			on_chain_node_add_func(node, func_context)
		end

		_create_chain_root_node(chain_lightning_action_data)
	end
end

ChainLightningAction.action_start = function (chain_lightning_action_data)
	_reset_chain_lightning(chain_lightning_action_data)
end

ChainLightningAction.make_chain_from_target = function (chain_lightning_action_data, root_target_unit, t)
	_reset_chain_lightning(chain_lightning_action_data)

	if chain_lightning_action_data.is_server then
		_add_root_target(chain_lightning_action_data, t, nil, root_target_unit)
		_find_new_targets(chain_lightning_action_data, t)

		local source_item = chain_lightning_action_data.func_context.source_item

		_deal_chain_lightning_damage(chain_lightning_action_data, t, source_item)
	else
		local target_component_index = 1
		local key = ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS[target_component_index]

		chain_lightning_action_data.targeting_module_component[key] = root_target_unit
	end

	local buff_extension = chain_lightning_action_data.func_context.buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		buff_extension:add_proc_event("on_weapon_chain_lightning_triggered", param_table)
	end
end

ChainLightningAction.action_finish = function (chain_lightning_action_data)
	_reset_chain_lightning(chain_lightning_action_data)
end

function _create_chain_root_node(chain_lightning_action_data)
	if not chain_lightning_action_data.chain_root_node then
		local player_unit = chain_lightning_action_data.player_unit
		local weapon_chain_lightning_template = chain_lightning_action_data.weapon_chain_lightning_template
		local depth, use_random = 0, false
		local num_component_targets = #ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS
		local chain_root_node = ChainLightningTarget:new(weapon_chain_lightning_template, depth, use_random, nil, "unit", player_unit)

		chain_root_node:set_max_num_children(num_component_targets)

		for ii = 1, num_component_targets do
			local key = ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS[ii]

			chain_root_node:set_value(key, false)
		end

		chain_lightning_action_data.chain_root_node = chain_root_node
	end

	_clear_initial_targets(chain_lightning_action_data)
end

function _reset_chain_lightning(chain_lightning_action_data)
	local is_server = chain_lightning_action_data.is_server

	if is_server then
		_clear_initial_targets(chain_lightning_action_data)
		ChainLightningTarget.remove_all_child_nodes(chain_lightning_action_data.chain_root_node, chain_lightning_action_data.on_chain_node_remove_func, chain_lightning_action_data.func_context)
		table.clear(chain_lightning_action_data.chain_lightning_temp_targets)
		table.clear(chain_lightning_action_data.chain_lightning_hit_units)
	else
		local target_component_index = 1
		local key = ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS[target_component_index]

		chain_lightning_action_data.targeting_module_component[key] = nil
	end
end

function _clear_initial_targets(chain_lightning_action_data)
	local chain_root_node = chain_lightning_action_data.chain_root_node

	for ii = 1, #ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS do
		local key = ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS[ii]

		chain_lightning_action_data.targeting_module_component[key] = nil

		chain_root_node:set_value(key, false)
	end
end

function _add_root_target(chain_lightning_action_data, t, time_in_action, target_unit)
	local action_settings = chain_lightning_action_data.action_settings
	local hit_units = chain_lightning_action_data.chain_lightning_hit_units
	local chain_root_node = chain_lightning_action_data.chain_root_node
	local context = chain_lightning_action_data.func_context
	local target_component_index = 1
	local key = ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS[target_component_index]

	if target_unit and not hit_units[target_unit] then
		local slot_target_node = chain_root_node:value(key)
		local slot_target_unit_alive = HEALTH_ALIVE[chain_root_node:value("target_unit")]

		if slot_target_node and not slot_target_unit_alive then
			ChainLightningTarget.remove_all_child_nodes(slot_target_node, chain_lightning_action_data.on_chain_node_remove_func, context)
			chain_root_node:remove_child(slot_target_node, chain_lightning_action_data.on_chain_node_remove_func, context)

			hit_units[target_unit] = nil
			chain_lightning_action_data.targeting_module_component[key] = nil
			slot_target_node = false
		end

		if not slot_target_node then
			local child_node = chain_root_node:add_child(chain_lightning_action_data.on_chain_node_add_func, context, "unit", target_unit, "start_t", t)

			chain_root_node:set_value(key, child_node)

			chain_lightning_action_data.targeting_module_component[key] = target_unit
			hit_units[target_unit] = true
		end
	end
end

function _find_new_targets(chain_lightning_action_data, t)
	local action_settings = chain_lightning_action_data.action_settings
	local player_unit = chain_lightning_action_data.player_unit
	local chain_root_node = chain_lightning_action_data.chain_root_node
	local player_position = POSITION_LOOKUP[player_unit]
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local stat_buffs = chain_lightning_action_data.func_context.buff_extension:stat_buffs()
	local weapon_chain_lightning_template = chain_lightning_action_data.weapon_chain_lightning_template
	local time_in_action = t - chain_lightning_action_data.weapon_action_component.start_t
	local max_angle, close_max_angle, max_z_diff, vertical_max_angle, max_jumps, radius, jump_time = ChainLightning.targeting_parameters(time_in_action, weapon_chain_lightning_template, stat_buffs)

	for child_node, _ in pairs(chain_root_node:children()) do
		local child_node_unit = child_node:value("unit")
		local child_node_unit_position = POSITION_LOOKUP[child_node_unit]
		local travel_direction = Vector3_normalize(Vector3_flat(player_position - child_node_unit_position))

		_find_new_chain_targets(chain_lightning_action_data, t, broadphase, enemy_side_names, max_angle, close_max_angle, vertical_max_angle, max_z_diff, max_jumps, radius, child_node, travel_direction)
	end
end

function _find_new_chain_targets(chain_lightning_action_data, t, broadphase, enemy_side_names, max_angle, close_max_angle, vertical_max_angle, max_z_diff, max_jumps, radius, source_node, initial_travel_direction)
	local temp_targets = chain_lightning_action_data.chain_lightning_temp_targets
	local hit_units = chain_lightning_action_data.chain_lightning_hit_units
	local func_context = chain_lightning_action_data.func_context
	local physics_world = chain_lightning_action_data.physics_world

	for j = 1, max_jumps do
		table.clear(temp_targets)
		ChainLightningTarget.traverse_breadth_first(t, source_node, temp_targets, BREADTH_FIRST_VALIDATION.node_available_within_depth_and_target_alive, max_jumps)

		local found_new_target = false

		for ii = 1, #temp_targets do
			local source = temp_targets[ii]
			local found_valid_jump = ChainLightning.jump(t, physics_world, source, hit_units, broadphase, enemy_side_names, initial_travel_direction, radius, max_angle, close_max_angle, vertical_max_angle, max_z_diff, chain_lightning_action_data.chain_jump_on_add_func, func_context, chain_lightning_action_data.chain_jump_validation_function_or_nil)

			found_new_target = found_new_target or found_valid_jump

			if chain_lightning_action_data.is_server and found_valid_jump then
				Managers.stats:record_private("hook_weapon_chain_lightning_jump_triggered", chain_lightning_action_data.player)
			end
		end

		if not found_new_target then
			break
		end
	end
end

function _deal_chain_lightning_damage(chain_lightning_action_data, t, source_item)
	local action_settings = chain_lightning_action_data.action_settings

	if not action_settings then
		return
	end

	local chain_damage_settings = action_settings.chain_damage_settings or chain_lightning_action_data.weapon_chain_settings.chain_damage_settings
	local damage_profile = chain_damage_settings.damage_profile
	local damage_type = chain_damage_settings.damage_type
	local attack_type_or_nil = chain_damage_settings.attack_type or nil
	local player_unit = chain_lightning_action_data.player_unit
	local temp_targets = chain_lightning_action_data.chain_lightning_temp_targets

	table.clear(temp_targets)
	ChainLightningTarget.traverse_depth_first(t, chain_lightning_action_data.chain_root_node, temp_targets, DEPTH_FIRST_VALIDATION.node_target_alive_and_not_self, player_unit)

	for ii = 1, #temp_targets do
		local target = temp_targets[ii]
		local unit = target:value("unit")
		local depth = target:depth()
		local is_critical_strike = chain_lightning_action_data.critical_strike_component.is_active
		local power_level = DEFAULT_POWER_LEVEL
		local player_rotation = chain_lightning_action_data.first_person_component.rotation
		local attack_direction = Quaternion.rotate(player_rotation, Vector3.forward())

		if damage_profile.random_damage then
			local random_range = damage_profile.random_damage[depth] or DEFAULT_POWER_LEVEL_RANDOM_RANGE
			local random_mod = random_range.min + math.random() * (random_range.max - random_range.min)

			power_level = power_level * random_mod
		end

		local hit_zone_name = "center_mass"
		local actors = HitZone.get_actor_names(unit, hit_zone_name)
		local hit_actor_name = actors[1]
		local hit_actor = Unit.actor(unit, hit_actor_name)
		local actor_node = Actor.node(hit_actor)
		local hit_world_position = Unit.world_position(unit, actor_node)
		local damage_dealt, attack_result, damage_efficiency, _, _ = ChainLightning.execute_attack(unit, player_unit, power_level, nil, depth, ii, attack_direction, damage_profile, damage_type, is_critical_strike, source_item, attack_type_or_nil)

		ImpactEffect.play(unit, nil, damage_dealt, damage_type, "center_mass", attack_result, hit_world_position, nil, attack_direction, player_unit, nil, nil, nil, damage_efficiency, damage_profile)
	end
end

return ChainLightningAction
