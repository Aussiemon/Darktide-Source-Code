-- chunkname: @scripts/extension_systems/behavior/utilities/conditions/bt_bot_conditions.lua

local Ammo = require("scripts/utilities/ammo")
local Overheat = require("scripts/utilities/overheat")
local conditions = {}

conditions._can_activate_zealot_relic = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local max_distance_sq = 100
	local challenge_threshold = 1.75
	local targeting_multiplier = 1.25
	local self_position = POSITION_LOOKUP[unit]
	local can_activate = false
	local perception_extension = ScriptUnit.extension(unit, "perception_system")
	local enemies_in_proximity, num_proximite_enemies = perception_extension:enemies_in_proximity()
	local total_challenge_rating = 0

	for i = 1, num_proximite_enemies do
		local enemy_unit = enemies_in_proximity[i]
		local enemy_position = POSITION_LOOKUP[enemy_unit]

		if max_distance_sq >= Vector3.distance_squared(self_position, enemy_position) then
			local enemy_unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
			local enemy_breed = enemy_unit_data_extension:breed()
			local enemy_blackboard = BLACKBOARDS[enemy_unit]
			local enemy_perception_component = enemy_blackboard.perception
			local is_targeting_bot = enemy_perception_component.target_unit == unit
			local challenge_rating = enemy_breed.challenge_rating * (is_targeting_bot and targeting_multiplier or 1)

			total_challenge_rating = total_challenge_rating + challenge_rating

			if challenge_threshold <= total_challenge_rating then
				can_activate = true

				break
			end
		end
	end

	return can_activate
end

conditions._can_activate_veteran_ranger_ability = function (unit, blackboard, scratchpad, conditions_args, action_data, is_running)
	local perception_component = blackboard.perception
	local enemy_unit = perception_component.target_enemy

	if enemy_unit then
		local unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local tags = breed.tags

		if tags.special or tags.elite then
			return true
		end
	end

	return false
end

conditions.can_activate_ability = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local ability_component_name = action_data.ability_component_name

	if ability_component_name == scratchpad.ability_component_name then
		return true
	end

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local ability_component = unit_data_extension:read_component(ability_component_name)
	local ability_template_name = ability_component.template_name

	if ability_template_name == "none" then
		return false
	end

	local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
	local ability_template = AbilityTemplates[ability_template_name]
	local ability_meta_data = ability_template.ability_meta_data

	if ability_meta_data == nil then
		return false
	end

	local activation_data = ability_meta_data.activation
	local action_input, used_input = activation_data.action_input
	local FixedFrame = require("scripts/utilities/fixed_frame")
	local fixed_t = FixedFrame.get_latest_fixed_time()
	local ability_extension = ScriptUnit.extension(unit, "ability_system")
	local action_input_is_valid = ability_extension:action_input_is_currently_valid(ability_component_name, action_input, used_input, fixed_t)

	if not action_input_is_valid then
		return false
	end

	if ability_template_name == "zealot_relic" then
		return conditions._can_activate_zealot_relic(unit, blackboard, scratchpad, condition_args, action_data, is_running)
	elseif ability_template_name == "veteran_combat_ability" then
		return conditions._can_activate_veteran_ranger_ability(unit, blackboard, scratchpad, condition_args, action_data, is_running)
	else
		return false
	end
end

conditions.is_disabled = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
	local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

	return is_disabled
end

conditions._is_there_threat_to_aid = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local force_aid = perception_component.force_aid
	local perception_extension = ScriptUnit.extension(unit, "perception_system")
	local enemies_in_proximity, num_enemies_in_proximity = perception_extension:enemies_in_proximity()
	local enemy_found = false

	for i = 1, num_enemies_in_proximity do
		local enemy_unit = enemies_in_proximity[i]
		local enemy_blackboard = BLACKBOARDS[enemy_unit]

		if enemy_blackboard then
			local enemy_unit_data_extension = ALIVE[enemy_unit] and ScriptUnit.extension(enemy_unit, "unit_data_system")
			local enemy_breed = enemy_unit_data_extension and enemy_unit_data_extension:breed()
			local enemy_perception_component = enemy_blackboard.perception

			if enemy_perception_component.target_unit == unit and (not force_aid or enemy_breed.is_bot_aid_threat) then
				enemy_found = true

				break
			end
		end
	end

	return enemy_found
end

conditions._has_reached_ally_aid_destination = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local destination = navigation_extension:destination()
	local behavior_component = blackboard.behavior
	local target_ally_aid_destination = behavior_component.target_ally_aid_destination:unbox()
	local has_target_ally_aid_destination = Vector3.equal(destination, target_ally_aid_destination)

	if has_target_ally_aid_destination then
		return navigation_extension:destination_reached()
	else
		local self_position = POSITION_LOOKUP[unit]

		if navigation_extension:destination_reached() then
			local behavior_extension = ScriptUnit.extension(unit, "behavior_system")
			local is_near = not behavior_extension:new_destination_distance_check(self_position, destination, target_ally_aid_destination, navigation_extension)

			return is_near
		else
			local BotSettings = require("scripts/settings/bot/bot_settings")
			local flat_move_to_epsilon_sq = BotSettings.flat_move_to_epsilon^2
			local z_move_to_epsilon = BotSettings.z_move_to_epsilon
			local offset = target_ally_aid_destination - self_position

			return z_move_to_epsilon >= math.abs(offset.z) and flat_move_to_epsilon_sq >= Vector3.length_squared(Vector3.flat(offset))
		end
	end
end

conditions._has_reached_level_unit_destination = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local destination = navigation_extension:destination()
	local behavior_component = blackboard.behavior
	local target_level_unit_destination = behavior_component.target_level_unit_destination:unbox()
	local has_target_level_unit_destination = Vector3.equal(destination, target_level_unit_destination)

	if has_target_level_unit_destination then
		return navigation_extension:destination_reached()
	else
		local self_position = POSITION_LOOKUP[unit]

		if navigation_extension:destination_reached() then
			local behavior_extension = ScriptUnit.extension(unit, "behavior_system")
			local is_near = not behavior_extension:new_destination_distance_check(self_position, destination, target_level_unit_destination, navigation_extension)

			return is_near
		else
			local BotSettings = require("scripts/settings/bot/bot_settings")
			local flat_move_to_epsilon_sq = BotSettings.flat_move_to_epsilon^2
			local z_move_to_epsilon = BotSettings.z_move_to_epsilon
			local offset = target_level_unit_destination - self_position

			return z_move_to_epsilon >= math.abs(offset.z) and flat_move_to_epsilon_sq >= Vector3.length_squared(Vector3.flat(offset))
		end
	end
end

conditions.can_revive = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local behavior_component = blackboard.behavior
	local target_ally = perception_component.target_ally

	if not target_ally or behavior_component.interaction_unit ~= target_ally or perception_component.target_ally_need_type ~= "knocked_down" then
		return false
	end

	local interactor_extension, interaction_type = ScriptUnit.extension(unit, "interactor_system"), action_data.interaction_type
	local can_interact_with_ally = interactor_extension:can_interact(target_ally, interaction_type)
	local ally_destination_reached = conditions._has_reached_ally_aid_destination(unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local can_revive = can_interact_with_ally and ally_destination_reached

	return can_revive
end

conditions.can_remove_net = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local behavior_component = blackboard.behavior
	local target_ally = perception_component.target_ally

	if not target_ally or behavior_component.interaction_unit ~= target_ally or perception_component.target_ally_need_type ~= "netted" then
		return false
	end

	local interactor_extension, interaction_type = ScriptUnit.extension(unit, "interactor_system"), action_data.interaction_type
	local can_interact_with_ally = interactor_extension:can_interact(target_ally, interaction_type)
	local ally_destination_reached = conditions._has_reached_ally_aid_destination(unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local can_remove_net = can_interact_with_ally and ally_destination_reached

	return can_remove_net
end

conditions.can_rescue_hogtied = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local behavior_component = blackboard.behavior
	local target_ally = perception_component.target_ally

	if not target_ally or behavior_component.interaction_unit ~= target_ally or perception_component.target_ally_need_type ~= "hogtied" then
		return false
	end

	local interactor_extension, interaction_type = ScriptUnit.extension(unit, "interactor_system"), action_data.interaction_type
	local can_interact_with_ally = interactor_extension:can_interact(target_ally, interaction_type)
	local ally_destination_reached = conditions._has_reached_ally_aid_destination(unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local can_rescue_hogtied = can_interact_with_ally and ally_destination_reached

	return can_rescue_hogtied
end

conditions.can_use_health_station = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local behavior_component = blackboard.behavior
	local target_level_unit = perception_component.target_level_unit

	if not target_level_unit or behavior_component.interaction_unit ~= target_level_unit then
		return false
	end

	local destination_reached = conditions._has_reached_level_unit_destination(unit, blackboard, scratchpad, condition_args, action_data, is_running)

	return destination_reached
end

conditions.can_rescue_ledge_hanging = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local behavior_component = blackboard.behavior
	local target_ally = perception_component.target_ally

	if not target_ally or behavior_component.interaction_unit ~= target_ally or perception_component.target_ally_need_type ~= "ledge" then
		return false
	end

	if conditions._is_there_threat_to_aid(unit, blackboard, scratchpad, condition_args, action_data, is_running) then
		return false
	end

	local interactor_extension, interaction_type = ScriptUnit.extension(unit, "interactor_system"), action_data.interaction_type
	local can_interact_with_ally = interactor_extension:can_interact(target_ally, interaction_type)
	local ally_destination_reached = conditions._has_reached_ally_aid_destination(unit, blackboard, scratchpad, condition_args, action_data, is_running)

	return can_interact_with_ally and ally_destination_reached
end

conditions.can_loot = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local max_distance = 3.2
	local behavior_component = blackboard.behavior
	local interaction_unit = behavior_component.interaction_unit
	local is_forced_pickup = behavior_component.forced_pickup_unit == interaction_unit
	local pickup_component = blackboard.pickup
	local loot_health = pickup_component.health_deployable and pickup_component.allowed_to_take_health_pickup and pickup_component.health_deployable == interaction_unit and (is_forced_pickup or max_distance > pickup_component.health_deployable_distance)
	local loot_ammo = pickup_component.ammo_pickup and pickup_component.needs_ammo and pickup_component.ammo_pickup == interaction_unit and (is_forced_pickup or max_distance > pickup_component.ammo_pickup_distance)
	local loot_mule = pickup_component.mule_pickup and pickup_component.mule_pickup == interaction_unit and (is_forced_pickup or max_distance > pickup_component.mule_pickup_distance)

	if loot_health or loot_ammo or loot_mule then
		local interactee_extension = ScriptUnit.extension(interaction_unit, "interactee_system")
		local interaction_type = interactee_extension:interaction_type()
		local interactor_extension = ScriptUnit.extension(unit, "interactor_system")
		local can_interact_with_pickup = interactor_extension:can_interact(interaction_unit, interaction_type)

		return can_interact_with_pickup
	else
		return false
	end
end

conditions.is_slot_not_wielded = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot
	local wanted_slot = action_data.wanted_slot

	return wielded_slot ~= wanted_slot
end

conditions.wrong_slot_for_target_type = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local target_type = condition_args.target_type
	local perception_component = blackboard.perception
	local target_enemy_type = perception_component.target_enemy_type

	if target_type ~= target_enemy_type then
		return false
	end

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot
	local wanted_slot = action_data.wanted_slot

	return wielded_slot ~= wanted_slot
end

conditions.has_priority_or_urgent_target = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local target_enemy = perception_component.target_enemy

	if target_enemy == nil then
		return false
	end

	if target_enemy ~= perception_component.priority_target_enemy and target_enemy ~= perception_component.urgent_target_enemy then
		return false
	end

	local target_enemy_distance = perception_component.target_enemy_distance
	local result = target_enemy_distance < 25

	return result
end

conditions.bot_in_melee_range = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local target_enemy = perception_component.target_enemy

	if target_enemy == nil then
		return false
	end

	local target_enemy_type = perception_component.target_enemy_type

	if target_enemy_type ~= "melee" then
		return false
	end

	local enemy_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local enemy_breed = enemy_data_extension:breed()
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot
	local behavior_extension = ScriptUnit.extension(unit, "behavior_system")
	local is_taking_cover = behavior_extension:is_taking_cover()
	local is_urgent_or_opportunity_target = perception_component.urgent_target_enemy == target_enemy or perception_component.opportunity_target_enemy == target_enemy
	local melee_range

	if is_taking_cover or is_urgent_or_opportunity_target then
		if wielded_slot == "slot_secondary" then
			melee_range = enemy_breed.bot_opportunity_target_melee_range_while_ranged or 2
		else
			melee_range = enemy_breed.bot_opportunity_target_melee_range or 3
		end
	else
		melee_range = wielded_slot == "slot_secondary" and 10 or 12
	end

	local target_aim_position
	local override_aim_node_name = enemy_breed.bot_melee_aim_node

	if override_aim_node_name then
		local override_aim_node = Unit.node(target_enemy, override_aim_node_name)

		target_aim_position = Unit.world_position(target_enemy, override_aim_node)
	else
		target_aim_position = POSITION_LOOKUP[target_enemy]
	end

	local self_position = POSITION_LOOKUP[unit]
	local offset = target_aim_position - self_position
	local melee_range_sq = melee_range^2
	local distance_squared = Vector3.length_squared(offset)
	local in_range = distance_squared < melee_range_sq
	local z_offset = offset.z

	return in_range and z_offset > -1.5 and z_offset < 2
end

conditions.has_target = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local target_enemy = perception_component.target_enemy

	return target_enemy ~= nil
end

conditions.has_target_and_ammo_greater_than = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local target_enemy = perception_component.target_enemy

	if target_enemy == nil then
		return false
	end

	local target_enemy_type = perception_component.target_enemy_type

	if target_enemy_type ~= "ranged" then
		return false
	end

	local ranged_slot_name = "slot_secondary"
	local ammo_percentage = Ammo.current_slot_percentage(unit, ranged_slot_name)
	local ammo_ok = ammo_percentage > condition_args.ammo_percentage

	if not ammo_ok then
		return false
	end

	local overheat_limit, overheat_limit_type = condition_args.overheat_limit, condition_args.overheat_limit_type
	local overheat_percentage = Overheat.slot_percentage(unit, ranged_slot_name, overheat_limit_type)
	local overheat_ok = overheat_percentage < overheat_limit

	if not overheat_ok then
		return false
	end

	local ranged_obstructed_by_static_component = blackboard.ranged_obstructed_by_static
	local target_whilst_obstructed = ranged_obstructed_by_static_component.target_unit
	local obstructed_at_t = ranged_obstructed_by_static_component.t
	local t = Managers.time:time("gameplay")
	local obstructed = target_whilst_obstructed == target_enemy and t > obstructed_at_t + 3

	return not obstructed
end

conditions.should_reload = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local target_enemy_type = perception_component.target_enemy_type

	if target_enemy_type == "melee" then
		return false
	end

	local ranged_slot_name = "slot_secondary"
	local clip_percentage = Ammo.current_slot_clip_percentage(unit, ranged_slot_name)
	local reserve_percentage = Ammo.current_slot_percentage(unit, ranged_slot_name)
	local should_reload = clip_percentage <= 0 and reserve_percentage > 0

	return should_reload
end

conditions.should_vent_overheat = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local perception_component = blackboard.perception
	local target_enemy_type = perception_component.target_enemy_type

	if target_enemy_type == "melee" then
		return false
	end

	local ranged_slot_name = "slot_secondary"
	local overheat_limit_type = condition_args.overheat_limit_type
	local overheat_percentage = Overheat.slot_percentage(unit, ranged_slot_name, overheat_limit_type)
	local should_vent

	if scratchpad.reloading then
		should_vent = overheat_percentage >= condition_args.stop_percentage
	else
		should_vent = overheat_percentage >= condition_args.start_min_percentage and overheat_percentage <= condition_args.start_max_percentage
	end

	return should_vent
end

conditions.cant_reach_ally = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local group_extension = ScriptUnit.extension(unit, "group_system")
	local bot_group_data = group_extension:bot_group_data()
	local follow_unit = bot_group_data.follow_unit
	local follow_component = blackboard.follow
	local level_forced_teleport = follow_component.level_forced_teleport

	if level_forced_teleport then
		return true
	end

	if follow_unit == nil or follow_component.has_teleported then
		return false
	end

	local main_path_manager = Managers.state.main_path

	if not main_path_manager:is_main_path_ready() then
		return false
	end

	local self_segment = main_path_manager:segment_index_by_unit(unit)
	local ally_segment = main_path_manager:segment_index_by_unit(follow_unit)
	local is_ahead_of_ally = self_segment and ally_segment and ally_segment < self_segment

	if is_ahead_of_ally then
		return false
	end

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local ally_navigation_extension = ScriptUnit.extension(follow_unit, "navigation_system")
	local latest_position_on_nav_mesh = navigation_extension:latest_position_on_nav_mesh()
	local ally_latest_position_on_nav_mesh = ally_navigation_extension:latest_position_on_nav_mesh()

	if not latest_position_on_nav_mesh or not ally_latest_position_on_nav_mesh then
		return false
	end

	local t = Managers.time:time("gameplay")
	local fails, last_success = navigation_extension:successive_failed_paths()
	local is_behind_ally = self_segment and ally_segment and self_segment < ally_segment

	return follow_component.moving_towards_follow_position and fails > (is_behind_ally and 1 or 5) and t - last_success > 5
end

conditions.is_too_far_from_ally = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local group_extension = ScriptUnit.extension(unit, "group_system")
	local bot_group_data = group_extension:bot_group_data()
	local follow_unit = bot_group_data.follow_unit
	local follow_component = blackboard.follow

	if follow_unit == nil or follow_component.has_teleported then
		return false
	end

	local main_path_manager = Managers.state.main_path

	if not main_path_manager:is_main_path_ready() then
		return false
	end

	local self_segment = main_path_manager:segment_index_by_unit(unit)
	local follow_segment = main_path_manager:segment_index_by_unit(follow_unit)
	local is_ahead = self_segment and follow_segment and follow_segment < self_segment

	if is_ahead then
		return false
	end

	local perception_component = blackboard.perception
	local target_enemy = perception_component.target_enemy
	local has_priority_target = target_enemy and target_enemy == perception_component.priority_target_enemy

	if perception_component.target_ally_needs_aid or has_priority_target then
		return false
	end

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local follow_unit_navigation_extension = ScriptUnit.extension(follow_unit, "navigation_system")
	local latest_position_on_nav_mesh = navigation_extension:latest_position_on_nav_mesh()
	local follow_unit_latest_position_on_nav_mesh = follow_unit_navigation_extension:latest_position_on_nav_mesh()

	if not latest_position_on_nav_mesh or not follow_unit_latest_position_on_nav_mesh then
		return false
	end

	local distance_squared = Vector3.distance_squared(latest_position_on_nav_mesh, follow_unit_latest_position_on_nav_mesh)

	return distance_squared >= 1600
end

return conditions
