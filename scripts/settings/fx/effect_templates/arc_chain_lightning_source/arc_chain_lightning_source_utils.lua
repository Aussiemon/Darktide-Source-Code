-- chunkname: @scripts/settings/fx/effect_templates/arc_chain_lightning_source/arc_chain_lightning_source_utils.lua

local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTarget = require("scripts/utilities/action/chain_lightning_target")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local DEFAULT_POWER_LEVEL_RANDOM_RANGE = {
	max = 1.25,
	min = 0.75,
}
local BREADTH_FIRST_VALIDATION = ChainLightning.breadth_first_validation_functions
local DEPTH_FIRST_VALIDATION = ChainLightning.depth_first_validation_functions
local Quaternion_look = Quaternion.look
local Vector3_direction_length = Vector3.direction_length
local Vector3_flat = Vector3.flat
local Vector3_normalize = Vector3.normalize
local ChainLightningSourceUtils = {}

ChainLightningSourceUtils.FX_SOURCE_NAME = "j_spine"
ChainLightningSourceUtils.PARTICLE_VARIABLE_NAME = "length"
ChainLightningSourceUtils.SOURCE_TARGET_KEY = "chain_source_unit"

ChainLightningSourceUtils.get_chain_target_position = function (chain_target_unit)
	local node_index = Unit.node(chain_target_unit, ChainLightningSourceUtils.FX_SOURCE_NAME)
	local chain_target_unit_position = Unit.world_position(chain_target_unit, node_index)

	return chain_target_unit_position
end

ChainLightningSourceUtils.get_positions = function (root_target_unit, template_data)
	local node_index = Unit.node(root_target_unit, ChainLightningSourceUtils.FX_SOURCE_NAME)
	local root_target_unit_position = Unit.world_position(root_target_unit, node_index)
	local attack_origin_pos = template_data.attack_origin_pos:unbox()

	return attack_origin_pos, root_target_unit_position
end

ChainLightningSourceUtils.add_root_target = function (chain_lightning_data, t, target_unit)
	local hit_units = chain_lightning_data.chain_lightning_hit_units
	local chain_root_node = chain_lightning_data.chain_root_node
	local context = chain_lightning_data.func_context
	local child_node = chain_root_node:add_child(chain_lightning_data.on_chain_node_add_func, context, "unit", target_unit, "start_t", t)

	chain_root_node:set_value(ChainLightningSourceUtils.SOURCE_TARGET_KEY, child_node)

	chain_lightning_data[ChainLightningSourceUtils.SOURCE_TARGET_KEY] = target_unit
	hit_units[target_unit] = true
end

ChainLightningSourceUtils.find_new_chain_targets = function (chain_lightning_data, t, broadphase, enemy_side_names, max_angle, close_max_angle, vertical_max_angle, max_z_diff, max_jumps, radius, source_node, initial_travel_direction, chain_lightning_jump_function_name, jump_validation_function, jump_target_priority_validation_functions)
	local temp_targets = chain_lightning_data.chain_lightning_temp_targets
	local hit_units = chain_lightning_data.chain_lightning_hit_units
	local func_context = chain_lightning_data.func_context
	local physics_world = chain_lightning_data.physics_world

	for j = 1, max_jumps do
		table.clear(temp_targets)
		ChainLightningTarget.traverse_breadth_first(t, source_node, temp_targets, BREADTH_FIRST_VALIDATION.node_available_within_depth_and_target_alive, max_jumps)

		local found_new_target = false

		for ii = 1, #temp_targets do
			local source = temp_targets[ii]
			local found_valid_jump = ChainLightning[chain_lightning_jump_function_name](t, physics_world, source, hit_units, broadphase, enemy_side_names, initial_travel_direction, radius, max_angle, close_max_angle, vertical_max_angle, max_z_diff, chain_lightning_data.chain_jump_on_add_func, func_context, jump_validation_function, jump_target_priority_validation_functions)

			found_new_target = found_new_target or found_valid_jump

			if chain_lightning_data.is_server and found_valid_jump then
				Managers.stats:record_private("hook_arc_grenade_chain_lightning_jump_triggered", chain_lightning_data.player)
			end
		end

		if not found_new_target then
			break
		end
	end
end

ChainLightningSourceUtils.find_new_targets = function (chain_lightning_data, attack_origin_pos, attack_direction, chain_lightning_jump_function_name, jump_validation_function, jump_target_priority_validation_functions, t)
	local player_unit = chain_lightning_data.player_unit
	local chain_root_node = chain_lightning_data.chain_root_node
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local stat_buffs = chain_lightning_data.func_context.buff_extension:stat_buffs()
	local chain_settings = chain_lightning_data.chain_settings
	local time_in_action = 0
	local max_angle, close_max_angle, max_z_diff, vertical_max_angle, max_jumps, radius, jump_time = ChainLightning.targeting_parameters(time_in_action, chain_settings, stat_buffs)

	for child_node, _ in pairs(chain_root_node:children()) do
		local travel_direction = Vector3_normalize(Vector3_flat(attack_direction))

		ChainLightningSourceUtils.find_new_chain_targets(chain_lightning_data, t, broadphase, enemy_side_names, max_angle, close_max_angle, vertical_max_angle, max_z_diff, max_jumps, radius, child_node, travel_direction, chain_lightning_jump_function_name, jump_validation_function, jump_target_priority_validation_functions)
	end
end

ChainLightningSourceUtils.deal_chain_lightning_damage = function (chain_lightning_data, t, attack_direction)
	local chain_settings = chain_lightning_data.chain_settings
	local chain_damage_settings = chain_lightning_data.chain_damage_settings
	local damage_profile = chain_damage_settings.damage_profile
	local damage_type = chain_damage_settings.damage_type
	local attack_type_or_nil = chain_damage_settings.attack_type or nil
	local player_unit = chain_lightning_data.player_unit
	local temp_targets = chain_lightning_data.chain_lightning_temp_targets

	table.clear(temp_targets)
	ChainLightningTarget.traverse_depth_first(t, chain_lightning_data.chain_root_node, temp_targets, DEPTH_FIRST_VALIDATION.node_target_alive_and_not_self, player_unit)

	for ii = 1, #temp_targets do
		local target = temp_targets[ii]
		local unit = target:value("unit")
		local depth = target:depth()
		local is_critical_strike = false
		local power_level = DEFAULT_POWER_LEVEL

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
		local damage_dealt, attack_result, damage_efficiency, _, _ = ChainLightning.execute_attack(unit, player_unit, power_level, nil, depth, ii, attack_direction, damage_profile, damage_type, is_critical_strike, nil, attack_type_or_nil)

		ImpactEffect.play(unit, nil, damage_dealt, damage_type, "center_mass", attack_result, hit_world_position, nil, attack_direction, player_unit, nil, nil, nil, damage_efficiency, damage_profile)
	end
end

ChainLightningSourceUtils.spawn_linking_effects = function (chain_lightning_data, vfx, template_data, template_context, t)
	local player_unit = chain_lightning_data.player_unit
	local temp_targets = chain_lightning_data.chain_lightning_temp_targets
	local world = template_context.world

	table.clear(temp_targets)
	ChainLightningTarget.traverse_depth_first(t, chain_lightning_data.chain_root_node, temp_targets, DEPTH_FIRST_VALIDATION.node_target_alive_and_not_self, player_unit)

	local fx_system = Managers.state.extension:system("fx_system")
	local attack_origin_pos = template_data.attack_origin_pos:unbox()
	local from_position, to_position = attack_origin_pos

	for ii = #temp_targets, 1, -1 do
		local target = temp_targets[ii]
		local chain_target_unit = target:value("unit")
		local depth = target:depth()

		to_position = ChainLightningSourceUtils.get_chain_target_position(chain_target_unit)

		local line = to_position - from_position
		local direction, length = Vector3_direction_length(line)
		local rotation = Quaternion_look(direction)
		local particle_length = Vector3(length, 1, 1)

		if not chain_lightning_data.link_particle_ids[chain_target_unit] then
			local link_particle_id = World.create_particles(world, vfx.link_to_source, from_position, rotation, nil)
			local length_variable_index = World.find_particles_variable(world, vfx.link_to_source, ChainLightningSourceUtils.PARTICLE_VARIABLE_NAME)

			World.set_particles_variable(world, link_particle_id, length_variable_index, particle_length)

			chain_lightning_data.link_particle_ids[chain_target_unit] = link_particle_id
		end

		from_position = to_position
	end
end

ChainLightningSourceUtils.clear_initial_targets = function (chain_lightning_action_data)
	local chain_root_node = chain_lightning_action_data.chain_root_node

	chain_root_node:set_value(ChainLightningSourceUtils.SOURCE_TARGET_KEY, false)
end

ChainLightningSourceUtils.reset_chain_lightning = function (chain_lightning_data, template_data, template_context)
	ChainLightningSourceUtils.clear_initial_targets(chain_lightning_data)
	ChainLightningTarget.remove_all_child_nodes(chain_lightning_data.chain_root_node, chain_lightning_data.on_chain_node_remove_func, chain_lightning_data.func_context)
	table.clear(chain_lightning_data.chain_lightning_temp_targets)
	table.clear(chain_lightning_data.chain_lightning_hit_units)

	chain_lightning_data[ChainLightningSourceUtils.SOURCE_TARGET_KEY] = nil
end

ChainLightningSourceUtils.start_chain_from_unit = function (chain_lightning_data, is_server, player_unit, chain_source_unit, attack_origin_pos, attack_direction, chain_settings, t)
	if is_server then
		ChainLightningSourceUtils.add_root_target(chain_lightning_data, t, chain_source_unit)
		ChainLightningSourceUtils.find_new_targets(chain_lightning_data, attack_origin_pos, attack_direction, chain_lightning_data.chain_lightning_jump_function_name, chain_lightning_data.chain_jump_validation_function_or_nil, chain_lightning_data.jump_target_priority_validation_functions_or_nil, t)
		ChainLightningSourceUtils.deal_chain_lightning_damage(chain_lightning_data, t, attack_direction)
	else
		chain_lightning_data[ChainLightningSourceUtils.SOURCE_TARGET_KEY] = chain_source_unit
	end

	local buff_extension = chain_lightning_data.func_context.buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		buff_extension:add_proc_event("on_weapon_chain_lightning_triggered", param_table)
	end
end

return ChainLightningSourceUtils
