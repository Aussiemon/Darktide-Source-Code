-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_attack_valkyrie_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BtAttackValkyrieSelectorNode = class("BtAttackValkyrieSelectorNode", "BtNode")

BtAttackValkyrieSelectorNode.init = function (self, ...)
	BtAttackValkyrieSelectorNode.super.init(self, ...)

	self._children = {}
end

BtAttackValkyrieSelectorNode.init_values = function (self, blackboard, action_data, node_data)
	BtAttackValkyrieSelectorNode.super.init_values(self, blackboard, action_data, node_data)

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtAttackValkyrieSelectorNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtAttackValkyrieSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local last_running_node = old_running_child_nodes[node_identifier]
	local children = self._children

	do
		local node_death = children[1]
		local death_component = blackboard.death
		local is_dead = death_component.is_dead
		local condition_result = is_dead

		if condition_result then
			new_running_child_nodes[node_identifier] = node_death

			return node_death
		end
	end

	do
		local node_stagger = children[2]
		local stagger_component = blackboard.stagger
		local is_staggered = stagger_component.num_triggered_staggers > 0
		local condition_result = is_staggered

		if condition_result then
			new_running_child_nodes[node_identifier] = node_stagger

			return node_stagger
		end
	end

	do
		local node_flee = children[3]
		local is_running = last_leaf_node_running and last_running_node == node_flee
		local condition_result

		repeat
			if is_running then
				condition_result = true

				break
			end

			local flee_component = blackboard.flee

			condition_result = flee_component.wants_flee
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_flee

			return node_flee
		end
	end

	do
		local node_rendezvous = children[4]
		local tree_node = node_rendezvous.tree_node
		local action_data = tree_node.action_data
		local is_running = last_leaf_node_running and last_running_node == node_rendezvous
		local condition_result

		repeat
			local rendezvous_component = blackboard.rendezvous

			if is_running then
				condition_result = true

				break
			end

			if not rendezvous_component.has_randezvous_position then
				condition_result = true

				break
			end

			local Utility = require("scripts/extension_systems/behavior/utilities/utility")
			local current_reference = rendezvous_component.rendezvous_reference:unbox()
			local _, rendezvous_reference = Utility.find_rendezvous_position(unit, action_data, blackboard)
			local radius = action_data.rendezvous_radius

			condition_result = rendezvous_reference and Vector3.distance_squared(current_reference, rendezvous_reference) > radius * radius
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_rendezvous

			return node_rendezvous
		end
	end

	do
		local node_shoot = children[5]
		local is_running = last_leaf_node_running and last_running_node == node_shoot
		local condition_result

		repeat
			if is_running then
				condition_result = true

				break
			end

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

			condition_result = sub_condition_result_01
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_shoot

			return node_shoot
		end
	end

	do
		local node_fallback_rendezvous = children[6]
		local tree_node = node_fallback_rendezvous.tree_node
		local action_data = tree_node.action_data
		local is_running = last_leaf_node_running and last_running_node == node_fallback_rendezvous
		local condition_result

		repeat
			local rendezvous_component = blackboard.rendezvous

			if is_running then
				condition_result = true

				break
			end

			if not rendezvous_component.has_randezvous_position then
				condition_result = true

				break
			end

			local Utility = require("scripts/extension_systems/behavior/utilities/utility")
			local current_reference = rendezvous_component.rendezvous_reference:unbox()
			local _, rendezvous_reference = Utility.find_rendezvous_position(unit, action_data, blackboard)
			local radius = action_data.rendezvous_radius

			condition_result = rendezvous_reference and Vector3.distance_squared(current_reference, rendezvous_reference) > radius * radius
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_fallback_rendezvous

			return node_fallback_rendezvous
		end
	end

	local node_idle = children[7]

	new_running_child_nodes[node_identifier] = node_idle

	return node_idle
end

BtAttackValkyrieSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame
end

return BtAttackValkyrieSelectorNode
