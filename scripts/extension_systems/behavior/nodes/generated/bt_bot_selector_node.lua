﻿-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_bot_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BtBotSelectorNode = class("BtBotSelectorNode", "BtNode")

BtBotSelectorNode.init = function (self, ...)
	BtBotSelectorNode.super.init(self, ...)

	self._children = {}
end

BtBotSelectorNode.init_values = function (self, blackboard, action_data, node_data)
	BtBotSelectorNode.super.init_values(self, blackboard, action_data, node_data)

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtBotSelectorNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtBotSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local children = self._children

	do
		local node_disabled = children[1]
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
		local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)
		local condition_result = is_disabled

		if condition_result then
			new_running_child_nodes[node_identifier] = node_disabled

			return node_disabled
		end
	end

	do
		local node_do_revive = children[2]
		local tree_node = node_do_revive.tree_node
		local action_data = tree_node.action_data
		local condition_result

		repeat
			local perception_component = blackboard.perception
			local behavior_component = blackboard.behavior
			local target_ally = perception_component.target_ally

			if not target_ally or behavior_component.interaction_unit ~= target_ally or perception_component.target_ally_need_type ~= "knocked_down" then
				condition_result = false

				break
			end

			local interactor_extension, interaction_type = ScriptUnit.extension(unit, "interactor_system"), action_data.interaction_type
			local can_interact_with_ally = interactor_extension:can_interact(target_ally, interaction_type)
			local sub_condition_result_01

			do
				local condition_result

				repeat
					local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
					local destination = navigation_extension:destination()
					local behavior_component = blackboard.behavior
					local target_ally_aid_destination = behavior_component.target_ally_aid_destination:unbox()
					local has_target_ally_aid_destination = Vector3.equal(destination, target_ally_aid_destination)

					if has_target_ally_aid_destination then
						condition_result = navigation_extension:destination_reached()

						do break end
						break
					end

					local self_position = POSITION_LOOKUP[unit]

					if navigation_extension:destination_reached() then
						do
							local behavior_extension = ScriptUnit.extension(unit, "behavior_system")
							local is_near = not behavior_extension:new_destination_distance_check(self_position, destination, target_ally_aid_destination, navigation_extension)

							condition_result = is_near

							break
						end

						break
					end

					local BotSettings = require("scripts/settings/bot/bot_settings")
					local flat_move_to_epsilon_sq = BotSettings.flat_move_to_epsilon^2
					local z_move_to_epsilon = BotSettings.z_move_to_epsilon
					local offset = target_ally_aid_destination - self_position

					condition_result = z_move_to_epsilon >= math.abs(offset.z) and flat_move_to_epsilon_sq >= Vector3.length_squared(Vector3.flat(offset))

					break
				until true

				sub_condition_result_01 = condition_result
			end

			local ally_destination_reached = sub_condition_result_01
			local can_revive = can_interact_with_ally and ally_destination_reached

			condition_result = can_revive
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_do_revive

			return node_do_revive
		end
	end

	do
		local node_do_remove_net = children[3]
		local tree_node = node_do_remove_net.tree_node
		local action_data = tree_node.action_data
		local condition_result

		repeat
			local perception_component = blackboard.perception
			local behavior_component = blackboard.behavior
			local target_ally = perception_component.target_ally

			if not target_ally or behavior_component.interaction_unit ~= target_ally or perception_component.target_ally_need_type ~= "netted" then
				condition_result = false

				break
			end

			local interactor_extension, interaction_type = ScriptUnit.extension(unit, "interactor_system"), action_data.interaction_type
			local can_interact_with_ally = interactor_extension:can_interact(target_ally, interaction_type)
			local sub_condition_result_01

			do
				local condition_result

				repeat
					local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
					local destination = navigation_extension:destination()
					local behavior_component = blackboard.behavior
					local target_ally_aid_destination = behavior_component.target_ally_aid_destination:unbox()
					local has_target_ally_aid_destination = Vector3.equal(destination, target_ally_aid_destination)

					if has_target_ally_aid_destination then
						condition_result = navigation_extension:destination_reached()

						do break end
						break
					end

					local self_position = POSITION_LOOKUP[unit]

					if navigation_extension:destination_reached() then
						do
							local behavior_extension = ScriptUnit.extension(unit, "behavior_system")
							local is_near = not behavior_extension:new_destination_distance_check(self_position, destination, target_ally_aid_destination, navigation_extension)

							condition_result = is_near

							break
						end

						break
					end

					local BotSettings = require("scripts/settings/bot/bot_settings")
					local flat_move_to_epsilon_sq = BotSettings.flat_move_to_epsilon^2
					local z_move_to_epsilon = BotSettings.z_move_to_epsilon
					local offset = target_ally_aid_destination - self_position

					condition_result = z_move_to_epsilon >= math.abs(offset.z) and flat_move_to_epsilon_sq >= Vector3.length_squared(Vector3.flat(offset))

					break
				until true

				sub_condition_result_01 = condition_result
			end

			local ally_destination_reached = sub_condition_result_01
			local can_remove_net = can_interact_with_ally and ally_destination_reached

			condition_result = can_remove_net
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_do_remove_net

			return node_do_remove_net
		end
	end

	do
		local node_do_rescue_ledge_hanging = children[4]
		local tree_node = node_do_rescue_ledge_hanging.tree_node
		local action_data = tree_node.action_data
		local condition_result

		repeat
			local perception_component = blackboard.perception
			local behavior_component = blackboard.behavior
			local target_ally = perception_component.target_ally

			if not target_ally or behavior_component.interaction_unit ~= target_ally or perception_component.target_ally_need_type ~= "ledge" then
				condition_result = false

				break
			end

			local sub_condition_result_01

			do
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

				local condition_result = enemy_found

				sub_condition_result_01 = condition_result
			end

			if sub_condition_result_01 then
				condition_result = false

				break
			end

			local interactor_extension, interaction_type = ScriptUnit.extension(unit, "interactor_system"), action_data.interaction_type
			local can_interact_with_ally = interactor_extension:can_interact(target_ally, interaction_type)
			local sub_condition_result_02

			do
				local condition_result

				repeat
					local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
					local destination = navigation_extension:destination()
					local behavior_component = blackboard.behavior
					local target_ally_aid_destination = behavior_component.target_ally_aid_destination:unbox()
					local has_target_ally_aid_destination = Vector3.equal(destination, target_ally_aid_destination)

					if has_target_ally_aid_destination then
						condition_result = navigation_extension:destination_reached()

						do break end
						break
					end

					local self_position = POSITION_LOOKUP[unit]

					if navigation_extension:destination_reached() then
						do
							local behavior_extension = ScriptUnit.extension(unit, "behavior_system")
							local is_near = not behavior_extension:new_destination_distance_check(self_position, destination, target_ally_aid_destination, navigation_extension)

							condition_result = is_near

							break
						end

						break
					end

					local BotSettings = require("scripts/settings/bot/bot_settings")
					local flat_move_to_epsilon_sq = BotSettings.flat_move_to_epsilon^2
					local z_move_to_epsilon = BotSettings.z_move_to_epsilon
					local offset = target_ally_aid_destination - self_position

					condition_result = z_move_to_epsilon >= math.abs(offset.z) and flat_move_to_epsilon_sq >= Vector3.length_squared(Vector3.flat(offset))

					break
				until true

				sub_condition_result_02 = condition_result
			end

			local ally_destination_reached = sub_condition_result_02

			condition_result = can_interact_with_ally and ally_destination_reached
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_do_rescue_ledge_hanging

			return node_do_rescue_ledge_hanging
		end
	end

	do
		local node_do_rescue_hogtied = children[5]
		local tree_node = node_do_rescue_hogtied.tree_node
		local action_data = tree_node.action_data
		local condition_result

		repeat
			local perception_component = blackboard.perception
			local behavior_component = blackboard.behavior
			local target_ally = perception_component.target_ally

			if not target_ally or behavior_component.interaction_unit ~= target_ally or perception_component.target_ally_need_type ~= "hogtied" then
				condition_result = false

				break
			end

			local interactor_extension, interaction_type = ScriptUnit.extension(unit, "interactor_system"), action_data.interaction_type
			local can_interact_with_ally = interactor_extension:can_interact(target_ally, interaction_type)
			local sub_condition_result_01

			do
				local condition_result

				repeat
					local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
					local destination = navigation_extension:destination()
					local behavior_component = blackboard.behavior
					local target_ally_aid_destination = behavior_component.target_ally_aid_destination:unbox()
					local has_target_ally_aid_destination = Vector3.equal(destination, target_ally_aid_destination)

					if has_target_ally_aid_destination then
						condition_result = navigation_extension:destination_reached()

						do break end
						break
					end

					local self_position = POSITION_LOOKUP[unit]

					if navigation_extension:destination_reached() then
						do
							local behavior_extension = ScriptUnit.extension(unit, "behavior_system")
							local is_near = not behavior_extension:new_destination_distance_check(self_position, destination, target_ally_aid_destination, navigation_extension)

							condition_result = is_near

							break
						end

						break
					end

					local BotSettings = require("scripts/settings/bot/bot_settings")
					local flat_move_to_epsilon_sq = BotSettings.flat_move_to_epsilon^2
					local z_move_to_epsilon = BotSettings.z_move_to_epsilon
					local offset = target_ally_aid_destination - self_position

					condition_result = z_move_to_epsilon >= math.abs(offset.z) and flat_move_to_epsilon_sq >= Vector3.length_squared(Vector3.flat(offset))

					break
				until true

				sub_condition_result_01 = condition_result
			end

			local ally_destination_reached = sub_condition_result_01
			local can_rescue_hogtied = can_interact_with_ally and ally_destination_reached

			condition_result = can_rescue_hogtied
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_do_rescue_hogtied

			return node_do_rescue_hogtied
		end
	end

	do
		local node_use_healing_station = children[6]
		local condition_result

		repeat
			local perception_component = blackboard.perception
			local behavior_component = blackboard.behavior
			local target_level_unit = perception_component.target_level_unit

			if not target_level_unit or behavior_component.interaction_unit ~= target_level_unit then
				condition_result = false

				break
			end

			local sub_condition_result_01

			do
				local condition_result

				repeat
					local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
					local destination = navigation_extension:destination()
					local behavior_component = blackboard.behavior
					local target_level_unit_destination = behavior_component.target_level_unit_destination:unbox()
					local has_target_level_unit_destination = Vector3.equal(destination, target_level_unit_destination)

					if has_target_level_unit_destination then
						condition_result = navigation_extension:destination_reached()

						do break end
						break
					end

					local self_position = POSITION_LOOKUP[unit]

					if navigation_extension:destination_reached() then
						do
							local behavior_extension = ScriptUnit.extension(unit, "behavior_system")
							local is_near = not behavior_extension:new_destination_distance_check(self_position, destination, target_level_unit_destination, navigation_extension)

							condition_result = is_near

							break
						end

						break
					end

					local BotSettings = require("scripts/settings/bot/bot_settings")
					local flat_move_to_epsilon_sq = BotSettings.flat_move_to_epsilon^2
					local z_move_to_epsilon = BotSettings.z_move_to_epsilon
					local offset = target_level_unit_destination - self_position

					condition_result = z_move_to_epsilon >= math.abs(offset.z) and flat_move_to_epsilon_sq >= Vector3.length_squared(Vector3.flat(offset))

					break
				until true

				sub_condition_result_01 = condition_result
			end

			local destination_reached = sub_condition_result_01

			condition_result = destination_reached
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_use_healing_station

			return node_use_healing_station
		end
	end

	do
		local node_loot = children[7]
		local condition_result

		repeat
			local max_distance = 3.2
			local behavior_component = blackboard.behavior
			local interaction_unit = behavior_component.interaction_unit
			local is_forced_pickup = behavior_component.forced_pickup_unit == interaction_unit
			local pickup_component = blackboard.pickup
			local loot_health = pickup_component.health_deployable and pickup_component.allowed_to_take_health_pickup and pickup_component.health_deployable == interaction_unit and (is_forced_pickup or max_distance > pickup_component.health_deployable_distance)
			local loot_ammo = pickup_component.ammo_pickup and pickup_component.needs_ammo and pickup_component.ammo_pickup == interaction_unit and (is_forced_pickup or max_distance > pickup_component.ammo_pickup_distance)
			local loot_mule = pickup_component.mule_pickup and pickup_component.mule_pickup == interaction_unit and (is_forced_pickup or max_distance > pickup_component.mule_pickup_distance)

			if loot_health or loot_ammo or loot_mule then
				do
					local interactee_extension = ScriptUnit.extension(interaction_unit, "interactee_system")
					local interaction_type = interactee_extension:interaction_type()
					local interactor_extension = ScriptUnit.extension(unit, "interactor_system")
					local can_interact_with_pickup = interactor_extension:can_interact(interaction_unit, interaction_type)

					condition_result = can_interact_with_pickup

					break
				end

				break
			end

			condition_result = false and condition_result
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_loot

			return node_loot
		end
	end

	do
		local node_activate_combat_ability = children[8]
		local tree_node = node_activate_combat_ability.tree_node
		local action_data = tree_node.action_data
		local condition_result

		repeat
			local ability_component_name = action_data.ability_component_name

			if ability_component_name == scratchpad.ability_component_name then
				condition_result = true

				break
			end

			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local ability_component = unit_data_extension:read_component(ability_component_name)
			local ability_template_name = ability_component.template_name

			if ability_template_name == "none" then
				condition_result = false

				break
			end

			local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
			local ability_template = AbilityTemplates[ability_template_name]
			local ability_meta_data = ability_template.ability_meta_data

			if ability_meta_data == nil then
				condition_result = false

				break
			end

			local activation_data = ability_meta_data.activation
			local action_input, used_input = activation_data.action_input
			local FixedFrame = require("scripts/utilities/fixed_frame")
			local fixed_t = FixedFrame.get_latest_fixed_time()
			local ability_extension = ScriptUnit.extension(unit, "ability_system")
			local action_input_is_valid = ability_extension:action_input_is_currently_valid(ability_component_name, action_input, used_input, fixed_t)

			if not action_input_is_valid then
				condition_result = false

				break
			end

			if ability_template_name == "zealot_relic" then
				do
					local sub_condition_result_01

					do
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

						local condition_result = can_activate

						sub_condition_result_01 = condition_result
					end

					condition_result = sub_condition_result_01

					break
				end

				break
			end

			if ability_template_name == "veteran_combat_ability" then
				do
					local sub_condition_result_02

					do
						local condition_result

						repeat
							local perception_component = blackboard.perception
							local enemy_unit = perception_component.target_enemy

							if enemy_unit then
								local unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
								local breed = unit_data_extension:breed()
								local tags = breed.tags

								if tags.special or tags.elite then
									condition_result = true

									break
								end
							end

							condition_result = false
						until true

						sub_condition_result_02 = condition_result
					end

					condition_result = sub_condition_result_02

					break
				end

				break
			end

			condition_result = false and condition_result
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_activate_combat_ability

			return node_activate_combat_ability
		end
	end

	do
		local node_activate_grenade_ability = children[9]
		local tree_node = node_activate_grenade_ability.tree_node
		local action_data = tree_node.action_data
		local condition_result

		repeat
			local ability_component_name = action_data.ability_component_name

			if ability_component_name == scratchpad.ability_component_name then
				condition_result = true

				break
			end

			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local ability_component = unit_data_extension:read_component(ability_component_name)
			local ability_template_name = ability_component.template_name

			if ability_template_name == "none" then
				condition_result = false

				break
			end

			local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
			local ability_template = AbilityTemplates[ability_template_name]
			local ability_meta_data = ability_template.ability_meta_data

			if ability_meta_data == nil then
				condition_result = false

				break
			end

			local activation_data = ability_meta_data.activation
			local action_input, used_input = activation_data.action_input
			local FixedFrame = require("scripts/utilities/fixed_frame")
			local fixed_t = FixedFrame.get_latest_fixed_time()
			local ability_extension = ScriptUnit.extension(unit, "ability_system")
			local action_input_is_valid = ability_extension:action_input_is_currently_valid(ability_component_name, action_input, used_input, fixed_t)

			if not action_input_is_valid then
				condition_result = false

				break
			end

			if ability_template_name == "zealot_relic" then
				do
					local sub_condition_result_01

					do
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

						local condition_result = can_activate

						sub_condition_result_01 = condition_result
					end

					condition_result = sub_condition_result_01

					break
				end

				break
			end

			if ability_template_name == "veteran_combat_ability" then
				do
					local sub_condition_result_02

					do
						local condition_result

						repeat
							local perception_component = blackboard.perception
							local enemy_unit = perception_component.target_enemy

							if enemy_unit then
								local unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
								local breed = unit_data_extension:breed()
								local tags = breed.tags

								if tags.special or tags.elite then
									condition_result = true

									break
								end
							end

							condition_result = false
						until true

						sub_condition_result_02 = condition_result
					end

					condition_result = sub_condition_result_02

					break
				end

				break
			end

			condition_result = false and condition_result
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_activate_grenade_ability

			return node_activate_grenade_ability
		end
	end

	do
		local node_switch_to_proper_weapon = children[10]
		local perception_component = blackboard.perception
		local target_enemy = perception_component.target_enemy
		local condition_result = target_enemy ~= nil

		if condition_result then
			local leaf_node = node_switch_to_proper_weapon:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_switch_to_proper_weapon

				return leaf_node
			end
		end
	end

	do
		local node_attack_priority_target = children[11]
		local condition_result

		repeat
			local perception_component = blackboard.perception
			local target_enemy = perception_component.target_enemy

			if target_enemy == nil then
				condition_result = false

				break
			end

			if target_enemy ~= perception_component.priority_target_enemy and target_enemy ~= perception_component.urgent_target_enemy then
				condition_result = false

				break
			end

			local target_enemy_distance = perception_component.target_enemy_distance
			local result = target_enemy_distance < 25

			condition_result = result
		until true

		if condition_result then
			local leaf_node = node_attack_priority_target:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_attack_priority_target

				return leaf_node
			end
		end
	end

	do
		local node_teleport_out_of_range = children[12]
		local condition_result

		repeat
			local group_extension = ScriptUnit.extension(unit, "group_system")
			local bot_group_data = group_extension:bot_group_data()
			local follow_unit = bot_group_data.follow_unit
			local follow_component = blackboard.follow

			if follow_unit == nil or follow_component.has_teleported then
				condition_result = false

				break
			end

			local main_path_manager = Managers.state.main_path

			if not main_path_manager:is_main_path_ready() then
				condition_result = false

				break
			end

			local self_segment = main_path_manager:segment_index_by_unit(unit)
			local follow_segment = main_path_manager:segment_index_by_unit(follow_unit)
			local is_ahead = self_segment and follow_segment and follow_segment < self_segment

			if is_ahead then
				condition_result = false

				break
			end

			local perception_component = blackboard.perception
			local target_enemy = perception_component.target_enemy
			local has_priority_target = target_enemy and target_enemy == perception_component.priority_target_enemy

			if perception_component.target_ally_needs_aid or has_priority_target then
				condition_result = false

				break
			end

			local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
			local follow_unit_navigation_extension = ScriptUnit.extension(follow_unit, "navigation_system")
			local latest_position_on_nav_mesh = navigation_extension:latest_position_on_nav_mesh()
			local follow_unit_latest_position_on_nav_mesh = follow_unit_navigation_extension:latest_position_on_nav_mesh()

			if not latest_position_on_nav_mesh or not follow_unit_latest_position_on_nav_mesh then
				condition_result = false

				break
			end

			local distance_squared = Vector3.distance_squared(latest_position_on_nav_mesh, follow_unit_latest_position_on_nav_mesh)

			condition_result = distance_squared >= 1600
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_teleport_out_of_range

			return node_teleport_out_of_range
		end
	end

	do
		local node_in_combat = children[13]
		local leaf_node = node_in_combat:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_in_combat

			return leaf_node
		end
	end

	local node_idle = children[14]

	new_running_child_nodes[node_identifier] = node_idle

	return node_idle
end

BtBotSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame
end

return BtBotSelectorNode
