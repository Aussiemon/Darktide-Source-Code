-- chunkname: @scripts/extension_systems/behavior/nodes/generated/bt_renegade_plasma_gunner_selector_node.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BtRenegadePlasmaGunnerSelectorNode = class("BtRenegadePlasmaGunnerSelectorNode", "BtNode")

BtRenegadePlasmaGunnerSelectorNode.init = function (self, ...)
	BtRenegadePlasmaGunnerSelectorNode.super.init(self, ...)

	self._children = {}
end

BtRenegadePlasmaGunnerSelectorNode.init_values = function (self, blackboard, action_data, node_data)
	BtRenegadePlasmaGunnerSelectorNode.super.init_values(self, blackboard, action_data, node_data)

	local children = self._children

	for i = 1, #children do
		local child_node = children[i]
		local child_tree_node = child_node.tree_node
		local child_action_data = child_tree_node.action_data

		child_node:init_values(blackboard, child_action_data, node_data)
	end
end

BtRenegadePlasmaGunnerSelectorNode.add_child = function (self, node)
	self._children[#self._children + 1] = node
end

BtRenegadePlasmaGunnerSelectorNode.evaluate = function (self, unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)
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
		local node_disable = children[2]
		local disable_component = blackboard.disable
		local condition_result = disable_component.is_disabled

		if condition_result then
			new_running_child_nodes[node_identifier] = node_disable

			return node_disable
		end
	end

	do
		local node_exit_spawner = children[3]
		local spawn_component = blackboard.spawn
		local condition_result = spawn_component.is_exiting_spawner

		if condition_result then
			new_running_child_nodes[node_identifier] = node_exit_spawner

			return node_exit_spawner
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
		local node_use_special_action = children[5]
		local condition_result

		repeat
			local perception_component = blackboard.perception
			local has_line_of_sight = perception_component.has_line_of_sight
			local stim_component = blackboard.stim
			local can_use_stim = stim_component.can_use_stim
			local t_til_use = stim_component.t_til_use
			local t = Managers.time:time("gameplay")
			local behavior_component = blackboard.behavior
			local combat_range = behavior_component.combat_range

			if has_line_of_sight and can_use_stim and t_til_use < t and (combat_range == "far" or combat_range == "close" or combat_range == "melee") then
				condition_result = true

				do break end
				break
			end

			condition_result = false and condition_result
		until true

		if condition_result then
			local leaf_node = node_use_special_action:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_use_special_action

				return leaf_node
			end
		end
	end

	do
		local node_stagger = children[6]
		local stagger_component = blackboard.stagger
		local is_staggered = stagger_component.num_triggered_staggers > 0
		local condition_result = is_staggered

		if condition_result then
			new_running_child_nodes[node_identifier] = node_stagger

			return node_stagger
		end
	end

	do
		local node_blocked = children[7]
		local blocked_component = blackboard.blocked
		local is_blocked = blocked_component.is_blocked
		local condition_result = is_blocked

		if condition_result then
			new_running_child_nodes[node_identifier] = node_blocked

			return node_blocked
		end
	end

	do
		local node_switch_weapon = children[8]
		local condition_result

		repeat
			local weapon_switch_component = blackboard.weapon_switch
			local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
			local wanted_weapon_slot = weapon_switch_component.wanted_weapon_slot
			local wielded_slot_name = visual_loadout_extension:wielded_slot_name()
			local stim_component = blackboard.stim

			if stim_component then
				local currently_using_stim = stim_component.currently_using_stim

				if currently_using_stim then
					condition_result = false

					break
				end
			end

			condition_result = (scratchpad.is_switching_weapons or wanted_weapon_slot ~= "unarmed" and wanted_weapon_slot ~= wielded_slot_name) and true or condition_result
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_switch_weapon

			return node_switch_weapon
		end
	end

	do
		local node_melee_combat = children[9]
		local tree_node = node_melee_combat.tree_node
		local condition_args = tree_node.condition_args
		local is_running = last_leaf_node_running and last_running_node == node_melee_combat
		local condition_result

		repeat
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

			if not is_aggroed then
				condition_result = false

				break
			end

			local behavior_component = blackboard.behavior
			local combat_range = behavior_component.combat_range
			local condition_combat_ranges = condition_args.combat_ranges

			condition_result = condition_combat_ranges[combat_range]
		until true

		if condition_result then
			local leaf_node = node_melee_combat:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_melee_combat

				return leaf_node
			end
		end
	end

	do
		local node_close_combat = children[10]
		local is_running = last_leaf_node_running and last_running_node == node_close_combat
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

		if condition_result then
			local leaf_node = node_close_combat:evaluate(unit, blackboard, scratchpad, dt, t, evaluate_utility, node_data, old_running_child_nodes, new_running_child_nodes, last_leaf_node_running)

			if leaf_node then
				new_running_child_nodes[node_identifier] = node_close_combat

				return leaf_node
			end
		end
	end

	do
		local node_alerted = children[11]
		local is_running = last_leaf_node_running and last_running_node == node_alerted
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
			local is_alerted_aggro_state = perception_component.aggro_state == "alerted"

			condition_result = is_alerted_aggro_state
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_alerted

			return node_alerted
		end
	end

	do
		local node_patrol = children[12]
		local is_running = last_leaf_node_running and last_running_node == node_patrol
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

			if has_target_unit then
				condition_result = false

				break
			end

			local patrol_component = blackboard.patrol
			local should_patrol = patrol_component.should_patrol
			local perception_component = blackboard.perception
			local aggro_state = perception_component.aggro_state
			local is_passive = aggro_state == "passive"

			condition_result = is_passive and should_patrol
		until true

		if condition_result then
			new_running_child_nodes[node_identifier] = node_patrol

			return node_patrol
		end
	end

	local node_idle = children[13]

	new_running_child_nodes[node_identifier] = node_idle

	return node_idle
end

BtRenegadePlasmaGunnerSelectorNode.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, running_child_nodes)
	local node_identifier = self.identifier
	local running_node = running_child_nodes[node_identifier]
	local running_tree_node = running_node.tree_node
	local running_action_data = running_tree_node.action_data
	local result, evaluate_utility_next_frame = running_node:run(unit, breed, blackboard, scratchpad, running_action_data, dt, t, node_data, running_child_nodes)

	return result, evaluate_utility_next_frame
end

return BtRenegadePlasmaGunnerSelectorNode
