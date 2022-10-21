require("scripts/extension_systems/behavior/nodes/bt_node")

local BtChaosBeastOfNurgleSelectorNode = class("BtChaosBeastOfNurgleSelectorNode", "BtNode")

BtChaosBeastOfNurgleSelectorNode.init = function (self, ...)
	BtChaosBeastOfNurgleSelectorNode.super.init(self, ...)

	self._children = {}
end

BtChaosBeastOfNurgleSelectorNode.init_values = function (self, blackboard, action_data, node_data)
	BtChaosBeastOfNurgleSelectorNode.super.init_values(self, blackboard, action_data, node_data)

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtChaosBeastOfNurgleSelectorNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtChaosBeastOfNurgleSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
	local node_identifier = self.identifier
	local last_running_node = old_running_child_nodes[node_identifier]
	local children = self._children
	local node_death = children[1]
	local death_component = blackboard.death
	local is_dead = death_component.is_dead
	local condition_result = is_dead

	if condition_result then
		new_running_child_nodes[node_identifier] = node_death

		return node_death
	end

	local node_exit_spawner = children[2]
	local spawn_component = blackboard.spawn
	local condition_result = spawn_component.is_exiting_spawner

	if condition_result then
		new_running_child_nodes[node_identifier] = node_exit_spawner

		return node_exit_spawner
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

	local node_stagger = children[4]
	local stagger_component = blackboard.stagger
	local is_staggered = stagger_component.num_triggered_staggers > 0
	local condition_result = is_staggered

	if condition_result then
		new_running_child_nodes[node_identifier] = node_stagger

		return node_stagger
	end

	local node_spit_out = children[5]
	local is_running = last_leaf_node_running and last_running_node == node_spit_out
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
		elseif is_running then
			condition_result = true
		else
			local behavior_component = blackboard.behavior
			local consumed_unit = behavior_component.consumed_unit

			if not HEALTH_ALIVE[consumed_unit] then
				condition_result = false
			elseif behavior_component.force_spit_out then
				condition_result = true
			else
				local health_extension = ScriptUnit.extension(consumed_unit, "health_system")
				local permanent_damage_taken_percent = health_extension:permanent_damage_taken_percent()
				condition_result = permanent_damage_taken_percent >= 0.5
			end
		end
	until true

	if condition_result then
		local leaf_node = node_spit_out:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_spit_out

			return leaf_node
		end
	end

	local node_dashing_and_consuming = children[6]
	local is_running = last_leaf_node_running and last_running_node == node_dashing_and_consuming
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
			local behavior_component = blackboard.behavior
			local cooldown = behavior_component.consume_cooldown
			local t = Managers.time:time("gameplay")

			if t < cooldown then
				condition_result = false
			else
				local scratchpad_consumed_unit = scratchpad.consumed_unit

				if HEALTH_ALIVE[scratchpad_consumed_unit] then
					condition_result = true
				else
					local consumed_unit = behavior_component.consumed_unit

					if HEALTH_ALIVE[consumed_unit] then
						condition_result = false
					else
						local perception_component = blackboard.perception
						local target_unit = perception_component.target_unit
						local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
						local character_state_component = target_unit_data_extension:read_component("character_state")
						local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
						local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

						if is_disabled then
							condition_result = false
						else
							local buff_extension = ScriptUnit.extension(target_unit, "buff_system")
							local vomit_buff_name = "chaos_beast_of_nurgle_hit_by_vomit"
							local current_stacks = buff_extension:current_stacks(vomit_buff_name)
							local wants_to_eat = behavior_component.wants_to_eat
							condition_result = current_stacks == 3 or wants_to_eat
						end
					end
				end
			end
		end
	until true

	if condition_result then
		local leaf_node = node_dashing_and_consuming:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_dashing_and_consuming

			return leaf_node
		end
	end

	local node_melee_push_back_attacks = children[7]
	local condition_result = nil

	repeat
		local behavior_component = blackboard.behavior
		local melee_cooldown = behavior_component.melee_cooldown
		local t = Managers.time:time("gameplay")
		condition_result = t >= melee_cooldown
	until true

	if condition_result then
		local leaf_node = node_melee_push_back_attacks:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_melee_push_back_attacks

			return leaf_node
		end
	end

	local node_target_changed_sequence = children[8]
	local perception_component = blackboard.perception
	local target_is_close = perception_component.target_distance < 5.25
	local behavior_component = blackboard.behavior
	local condition_result = behavior_component.wants_to_play_change_target and not target_is_close

	if condition_result then
		local leaf_node = node_target_changed_sequence:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_target_changed_sequence

			return leaf_node
		end
	end

	local node_run_away_sequence = children[9]
	local is_running = last_leaf_node_running and last_running_node == node_run_away_sequence
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
			local behavior_component = blackboard.behavior
			local consumed_unit = behavior_component.consumed_unit

			if not HEALTH_ALIVE[consumed_unit] then
				condition_result = false
			else
				local health_extension = ScriptUnit.extension(consumed_unit, "health_system")
				local permanent_damage_taken_percent = health_extension:permanent_damage_taken_percent()
				condition_result = permanent_damage_taken_percent < 0.5
			end
		end
	until true

	if condition_result then
		local leaf_node = node_run_away_sequence:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_run_away_sequence

			return leaf_node
		end
	end

	local node_consume_minion = children[10]
	local tree_node = node_consume_minion.tree_node
	local action_data = tree_node.action_data
	local is_running = last_leaf_node_running and last_running_node == node_consume_minion
	local condition_result = nil

	repeat
		if is_running then
			condition_result = true
		else
			local behavior_component = blackboard.behavior
			local t = Managers.time:time("gameplay")

			if t < behavior_component.consume_minion_cooldown then
				condition_result = false
			else
				local health_extension = ScriptUnit.extension(unit, "health_system")
				local current_health_percent = health_extension:current_health_percent()

				if action_data.health_percent_threshold < current_health_percent then
					condition_result = false
				else
					local num_nearby_units_threshold = action_data.num_nearby_units_threshold
					local broadphase_component = blackboard.nearby_units_broadphase
					local num_broadphase_units = broadphase_component.num_units
					condition_result = num_nearby_units_threshold <= num_broadphase_units
				end
			end
		end
	until true

	if condition_result then
		new_running_child_nodes[node_identifier] = node_consume_minion

		return node_consume_minion
	end

	local node_vomiting = children[11]
	local tree_node = node_vomiting.tree_node
	local condition_args = tree_node.condition_args
	local is_running = last_leaf_node_running and last_running_node == node_vomiting
	local condition_result = nil

	repeat
		local behavior_component = blackboard.behavior
		local vomit_cooldown = behavior_component.vomit_cooldown
		local t = Managers.time:time("gameplay")

		if t < vomit_cooldown then
			condition_result = false
		else
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
			elseif is_running then
				condition_result = true
			else
				local perception_component = blackboard.perception

				if not perception_component.has_line_of_sight then
					condition_result = false
				else
					local target_distance = perception_component.target_distance
					local wanted_distance = condition_args.wanted_distance
					condition_result = wanted_distance >= target_distance
				end
			end
		end
	until true

	if condition_result then
		local leaf_node = node_vomiting:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_vomiting

			return leaf_node
		end
	end

	local node_hunting = children[12]
	local is_running = last_leaf_node_running and last_running_node == node_hunting
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
		local has_target_unit = node_hunting
		local leaf_node = node_hunting.evaluate(has_target_unit, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

		if leaf_node then
			new_running_child_nodes[node_identifier] = node_hunting

			return leaf_node
		end
	end

	local node_idle = children[13]
	new_running_child_nodes[node_identifier] = node_idle

	return node_idle
end

BtChaosBeastOfNurgleSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame
end

return BtChaosBeastOfNurgleSelectorNode
