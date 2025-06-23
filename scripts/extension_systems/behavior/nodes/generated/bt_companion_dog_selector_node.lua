-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_companion_dog_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BtCompanionDogSelectorNode = class("BtCompanionDogSelectorNode", "BtNode")

BtCompanionDogSelectorNode.init = function (self, ...)
	BtCompanionDogSelectorNode.super.init(self, ...)

	self._children = {}
end

BtCompanionDogSelectorNode.init_values = function (self, blackboard, action_data, node_data)
	BtCompanionDogSelectorNode.super.init_values(self, blackboard, action_data, node_data)

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtCompanionDogSelectorNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtCompanionDogSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local last_running_node = old_running_child_nodes[node_identifier]
	local children = self._children

	do
		local node_companion_unstuck = children[1]
		local condition_result = blackboard.behavior.is_out_of_bound

		if condition_result then
			new_running_child_nodes[node_identifier] = node_companion_unstuck

			return node_companion_unstuck
		end
	end

	do
		local node_move_with_platform = children[2]
		local condition_result = blackboard.movable_platform.unit_reference ~= nil

		if condition_result then
			new_running_child_nodes[node_identifier] = node_move_with_platform

			return node_move_with_platform
		end
	end

	do
		local node_manual_teleport = children[3]
		local teleport_component = blackboard.teleport
		local condition_result = teleport_component.has_teleport_position

		if condition_result then
			new_running_child_nodes[node_identifier] = node_manual_teleport

			return node_manual_teleport
		end
	end

	do
		local node_smart_object = children[4]
		local condition_result

		repeat
			local nav_smart_object_component = blackboard.nav_smart_object
			local smart_object_id = nav_smart_object_component.id
			local smart_object_is_next = smart_object_id ~= -1

			if not smart_object_is_next then
				condition_result = false

				break
			end

			local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
			local is_smart_objecting = navigation_extension:is_using_smart_object()

			if is_smart_objecting then
				condition_result = true

				break
			end

			local smart_object_unit = nav_smart_object_component.unit

			if not ALIVE[smart_object_unit] then
				condition_result = false

				break
			end

			local nav_graph_extension = ScriptUnit.extension(smart_object_unit, "nav_graph_system")
			local nav_graph_added = nav_graph_extension:nav_graph_added(smart_object_id)

			if not nav_graph_added then
				condition_result = false

				break
			end

			local behavior_component = blackboard.behavior
			local is_in_moving_state = behavior_component.move_state == "moving"
			local entrance_is_at_bot_progress_on_path = nav_smart_object_component.entrance_is_at_bot_progress_on_path

			condition_result = is_in_moving_state and entrance_is_at_bot_progress_on_path
		until true

		if condition_result then
			local leaf_node = node_smart_object:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_smart_object

				return leaf_node
			end
		end
	end

	do
		local node_combat = children[5]
		local is_running = last_leaf_node_running and last_running_node == node_combat
		local sub_condition_result_01

		do
			local condition_result

			repeat
				local sub_condition_result_01

				do
					local condition_result

					repeat
						local perception_component = blackboard.perception

						if not is_running and perception_component.lock_target then
							condition_result = false

							break
						end

						local target_unit = perception_component.target_unit

						condition_result = HEALTH_ALIVE[target_unit]
					until true

					sub_condition_result_01 = condition_result
				end

				local has_target_unit = sub_condition_result_01

				if not has_target_unit then
					condition_result = false

					break
				end

				local perception_component = blackboard.perception
				local is_aggroed = perception_component.aggro_state == "aggroed"

				condition_result = is_aggroed
			until true

			sub_condition_result_01 = condition_result
		end

		local is_aggroed = sub_condition_result_01
		local behavior_component = blackboard.behavior
		local owner_unit = behavior_component.owner_unit
		local owner_attack_intensity_extension = ScriptUnit.has_extension(owner_unit, "attack_intensity_system")
		local in_combat = not owner_attack_intensity_extension or owner_attack_intensity_extension:in_combat_for_companion()
		local companion_whistle_target
		local smart_tag_system = Managers.state.extension:system("smart_tag_system")
		local tag_target, tag = smart_tag_system:unit_tagged_by_player_unit(owner_unit)
		local tag_template = tag and tag:template()
		local tag_type = tag_template and tag_template.marker_type

		if tag_target and tag_type == "unit_threat_adamant" then
			local unit_data_extension = ScriptUnit.has_extension(tag_target, "unit_data_system")
			local breed = unit_data_extension and unit_data_extension:breed()
			local daemonhost = breed and breed.tags.witch

			if daemonhost then
				local daemonhost_blackboard = BLACKBOARDS[tag_target]
				local daemonhost_perception_component = daemonhost_blackboard.perception
				local host_is_aggroed = daemonhost_perception_component.aggro_state == "aggroed"

				if host_is_aggroed then
					companion_whistle_target = tag_target
				end
			else
				companion_whistle_target = tag_target
			end
		end

		local force_combat = HEALTH_ALIVE[companion_whistle_target]
		local pounce_component = blackboard.pounce
		local condition_result = is_aggroed and (in_combat or force_combat) or pounce_component.started_leap or pounce_component.has_pounce_target

		if condition_result then
			local leaf_node = node_combat:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_combat

				return leaf_node
			end
		end
	end

	do
		local node_follow = children[6]
		local tree_node = node_follow.tree_node
		local action_data = tree_node.action_data
		local behavior_component = blackboard.behavior
		local owner_unit = behavior_component.owner_unit
		local owner_position = POSITION_LOOKUP[owner_unit]
		local current_state = behavior_component.current_state
		local outer_circle_distance = action_data.idle_circle_distances.outer_circle_distance
		local inner_circle_distance = action_data.idle_circle_distances.inner_circle_distance
		local companion_position = POSITION_LOOKUP[unit]
		local companion_owner_vector = Vector3.flat(companion_position - owner_position)
		local distance_from_owner = Vector3.length(companion_owner_vector)
		local sub_condition_result_01

		do
			local behavior_component = blackboard.behavior
			local owner_unit = behavior_component.owner_unit
			local owner_locomotion_extension = ScriptUnit.extension(owner_unit, "locomotion_system")
			local owner_speed = Vector3.length(Vector3.flat(owner_locomotion_extension:current_velocity()))
			local condition_result = owner_speed > 0.05

			sub_condition_result_01 = condition_result
		end

		local is_owner_moving = sub_condition_result_01
		local owner_locomotion_extension = ScriptUnit.extension(owner_unit, "locomotion_system")
		local owner_speed_normalized = Vector3.normalize(Vector3.flat(owner_locomotion_extension:current_velocity()))
		local companion_owner_vector_normalized = Vector3.normalize(companion_owner_vector)
		local cos = Vector3.dot(companion_owner_vector_normalized, owner_speed_normalized)
		local far_distance = action_data.far_distance
		local cone_cos = action_data.cone_angle and math.cos(action_data.cone_angle * 0.5) or math.huge
		local far_distance_check = not far_distance or far_distance < distance_from_owner or cos < cone_cos
		local condition_result = is_owner_moving and (current_state == "follow" or outer_circle_distance < distance_from_owner and far_distance_check)

		if condition_result then
			local leaf_node = node_follow:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_follow

				return leaf_node
			end
		end
	end

	local node_rest = children[7]
	local leaf_node = node_rest:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

	if leaf_node then
		new_running_child_nodes[node_identifier] = node_rest

		return leaf_node
	end
end

BtCompanionDogSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame
end

return BtCompanionDogSelectorNode
