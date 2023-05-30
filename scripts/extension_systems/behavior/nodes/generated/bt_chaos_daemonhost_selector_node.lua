require("scripts/extension_systems/behavior/nodes/bt_node")

local BtChaosDaemonhostSelectorNode = class("BtChaosDaemonhostSelectorNode", "BtNode")

BtChaosDaemonhostSelectorNode.init = function (self, ...)
	BtChaosDaemonhostSelectorNode.super.init(self, ...)

	self._children = {}
end

BtChaosDaemonhostSelectorNode.init_values = function (self, blackboard, action_data, node_data)
	BtChaosDaemonhostSelectorNode.super.init_values(self, blackboard, action_data, node_data)

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtChaosDaemonhostSelectorNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtChaosDaemonhostSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local last_running_node = old_running_child_nodes[node_identifier]
	local children = self._children
	local node_death_leave = children[1]
	local is_running = last_leaf_node_running and last_running_node == node_death_leave
	local condition_result = nil

	repeat
		local sub_condition_result_01, condition_result = nil

		repeat
			local sub_condition_result_01, condition_result = nil

			repeat
				local perception_component = blackboard.perception

				if not is_running and perception_component.lock_target then
					condition_result = false
				else
					local target_unit = perception_component.target_unit
					condition_result = HEALTH_ALIVE[target_unit]
				end
			until true

			sub_condition_result_01 = condition_result
			local has_target_unit = sub_condition_result_01

			if not has_target_unit then
				condition_result = false
			else
				local perception_component = blackboard.perception
				local is_aggroed = perception_component.aggro_state == "aggroed"
				condition_result = is_aggroed
			end
		until true

		sub_condition_result_01 = condition_result
		local is_aggroed = sub_condition_result_01

		if not is_aggroed then
			condition_result = false
		else
			local target_side_id = 1
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system:get_side(target_side_id)
			local target_units = side.valid_player_units
			local num_valid_target_units = #target_units
			local num_alive_targets = 0

			for i = 1, num_valid_target_units do
				local player_unit = target_units[i]

				if HEALTH_ALIVE[player_unit] then
					num_alive_targets = num_alive_targets + 1
				end
			end

			local statistics_component = blackboard.statistics

			if num_alive_targets == 1 then
				condition_result = true
			else
				local player_deaths = statistics_component.player_deaths
				local DaemonhostSettings = require("scripts/settings/specials/daemonhost_settings")
				local num_player_kills_for_despawn = Managers.state.difficulty:get_table_entry_by_challenge(DaemonhostSettings.num_player_kills_for_despawn)
				local wants_to_leave = num_player_kills_for_despawn <= player_deaths
				condition_result = wants_to_leave
			end
		end
	until true

	if condition_result then
		new_running_child_nodes[node_identifier] = node_death_leave

		return node_death_leave
	end

	local node_death = children[2]
	local death_component = blackboard.death
	local is_dead = death_component.is_dead
	local condition_result = is_dead

	if condition_result then
		new_running_child_nodes[node_identifier] = node_death

		return node_death
	end

	local node_smart_object = children[3]
	local condition_result = nil

	repeat
		local nav_smart_object_component = blackboard.nav_smart_object
		local smart_object_id = nav_smart_object_component.id
		local smart_object_is_next = smart_object_id ~= -1

		if not smart_object_is_next then
			condition_result = false
		else
			local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
			local is_smart_objecting = navigation_extension:is_using_smart_object()

			if is_smart_objecting then
				condition_result = true
			else
				local smart_object_unit = nav_smart_object_component.unit

				if not ALIVE[smart_object_unit] then
					condition_result = false
				else
					local nav_graph_extension = ScriptUnit.extension(smart_object_unit, "nav_graph_system")
					local nav_graph_added = nav_graph_extension:nav_graph_added(smart_object_id)

					if not nav_graph_added then
						condition_result = false
					else
						local behavior_component = blackboard.behavior
						local is_in_moving_state = behavior_component.move_state == "moving"
						local entrance_is_at_bot_progress_on_path = nav_smart_object_component.entrance_is_at_bot_progress_on_path
						condition_result = is_in_moving_state and entrance_is_at_bot_progress_on_path
					end
				end
			end
		end
	until true

	if condition_result then
		local leaf_node = node_smart_object:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_smart_object

			return leaf_node
		end
	end

	local node_warp_grab_teleport = children[4]
	local is_running = last_leaf_node_running and last_running_node == node_warp_grab_teleport
	local condition_result = nil

	repeat
		local sub_condition_result_01, condition_result = nil

		repeat
			local sub_condition_result_01, condition_result = nil

			repeat
				local perception_component = blackboard.perception

				if not is_running and perception_component.lock_target then
					condition_result = false
				else
					local target_unit = perception_component.target_unit
					condition_result = HEALTH_ALIVE[target_unit]
				end
			until true

			sub_condition_result_01 = condition_result
			local has_target_unit = sub_condition_result_01

			if not has_target_unit then
				condition_result = false
			else
				local perception_component = blackboard.perception
				local is_aggroed = perception_component.aggro_state == "aggroed"
				condition_result = is_aggroed
			end
		until true

		sub_condition_result_01 = condition_result
		local is_aggroed = sub_condition_result_01

		if not is_aggroed then
			break
		end

		if is_running then
			condition_result = true
		else
			local perception_component = blackboard.perception
			local target_unit = perception_component.target_unit
			local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
			local character_state_component = unit_data_extension:read_component("character_state")
			local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
			local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)
			local hit_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
			local disabled_state_input = hit_unit_data_extension:read_component("disabled_state_input")
			local is_disabled_by_this_deamonhost = disabled_state_input.disabling_unit == unit
			condition_result = is_knocked_down or is_disabled_by_this_deamonhost
		end
	until true

	if condition_result then
		local leaf_node = node_warp_grab_teleport:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_warp_grab_teleport

			return leaf_node
		end
	end

	local node_stagger = children[5]
	local stagger_component = blackboard.stagger
	local is_staggered = stagger_component.num_triggered_staggers > 0
	local condition_result = is_staggered

	if condition_result then
		new_running_child_nodes[node_identifier] = node_stagger

		return node_stagger
	end

	local node_melee_combat = children[6]
	local is_running = last_leaf_node_running and last_running_node == node_melee_combat
	local condition_result = nil

	repeat
		local sub_condition_result_01, condition_result = nil

		repeat
			local perception_component = blackboard.perception

			if not is_running and perception_component.lock_target then
				condition_result = false
			else
				local target_unit = perception_component.target_unit
				condition_result = HEALTH_ALIVE[target_unit]
			end
		until true

		sub_condition_result_01 = condition_result
		local has_target_unit = sub_condition_result_01

		if not has_target_unit then
			condition_result = false
		else
			local perception_component = blackboard.perception
			local is_aggroed = perception_component.aggro_state == "aggroed"
			condition_result = is_aggroed
		end
	until true

	if condition_result then
		local leaf_node = node_melee_combat:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_melee_combat

			return leaf_node
		end
	end

	local node_passive = children[7]
	local perception_component = blackboard.perception
	local aggro_state = perception_component.aggro_state
	local should_be_passive = aggro_state == "alerted" or aggro_state == "passive"
	local condition_result = should_be_passive

	if condition_result then
		new_running_child_nodes[node_identifier] = node_passive

		return node_passive
	end

	local node_idle = children[8]
	new_running_child_nodes[node_identifier] = node_idle

	return node_idle
end

BtChaosDaemonhostSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame
end

return BtChaosDaemonhostSelectorNode
