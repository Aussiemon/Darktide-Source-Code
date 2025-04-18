-- chunkname: @scripts/extension_systems/behavior/trees/behavior_tree.lua

require("scripts/extension_systems/behavior/nodes/bt_node")
require("scripts/extension_systems/behavior/nodes/bt_random_node")
require("scripts/extension_systems/behavior/nodes/bt_selector_node")
require("scripts/extension_systems/behavior/nodes/bt_sequence_node")
require("scripts/extension_systems/behavior/nodes/bt_random_utility_node")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_mutator_ritualist_chanting_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_cultist_ritualist_chanting_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_alerted_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_beast_of_nurgle_align_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_beast_of_nurgle_consume_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_beast_of_nurgle_consume_minion_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_beast_of_nurgle_die_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_beast_of_nurgle_movement_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_beast_of_nurgle_spit_out_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_blocked_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_change_target_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_daemonhost_die_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_daemonhost_passive_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_daemonhost_warp_grab_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_daemonhost_warp_sweep_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_hound_approach_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_hound_leap_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_hound_roam_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_hound_skulk_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_hound_target_pounced_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_mutator_daemonhost_passive_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_poxwalker_explode_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_chaos_spawn_grab_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_charge_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_climb_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_combat_idle_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_dash_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_die_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_disable_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_erratic_follow_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_exit_spawner_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_flamer_approach_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_flamer_check_backpack_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_grenadier_follow_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_grenadier_throw_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_idle_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_in_cover_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_jump_across_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_leap_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_melee_attack_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_melee_follow_target_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_move_to_combat_vector_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_move_to_cover_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_move_to_position_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_mutant_charger_charge_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_open_door_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_patrol_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_poxwalker_bomber_approach_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_quick_grenade_throw_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_ranged_follow_target_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_reload_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_renegade_flamer_patrol_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_renegade_netgunner_approach_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_renegade_twin_captain_disappear_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_renegade_twin_captain_shield_down_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_run_away")
require("scripts/extension_systems/behavior/nodes/actions/bt_run_stop_and_shoot_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_shoot_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_shoot_liquid_beam_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_shoot_net_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_shoot_pattern_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_shoot_position_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_shout_buff_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_smash_obstacle_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_sniper_movement_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_sniper_shoot_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_stagger_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_step_shoot_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_strafe_shoot_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_summon_minions_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_suppressed_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_switch_weapon_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_teleport_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_twin_captain_disappear_idle_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_twin_captain_intro_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_void_shield_explosion_action")
require("scripts/extension_systems/behavior/nodes/actions/bt_warp_teleport_action")
require("scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_activate_ability_action")
require("scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_follow_action")
require("scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_idle_action")
require("scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_interact_action")
require("scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_inventory_switch_action")
require("scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_melee_action")
require("scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_reload_action")
require("scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_shoot_action")
require("scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_teleport_to_ally_action")
require("scripts/extension_systems/behavior/nodes/generated/bt_bot_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_armored_infected_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_beast_of_nurgle_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_daemonhost_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_hound_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_lesser_mutated_poxwalker_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_mutated_poxwalker_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_mutator_daemonhost_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_mutator_ritualist_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_newly_infected_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_ogryn_bulwark_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_ogryn_executor_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_ogryn_gunner_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_plague_ogryn_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_poxwalker_bomber_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_poxwalker_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_chaos_spawn_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_cultist_assault_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_cultist_berzerker_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_cultist_captain_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_cultist_flamer_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_cultist_grenadier_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_cultist_gunner_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_cultist_melee_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_cultist_mutant_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_cultist_ritualist_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_cultist_shocktrooper_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_assault_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_berzerker_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_captain_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_executor_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_flamer_mutator_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_flamer_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_grenadier_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_gunner_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_gunner_tg_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_melee_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_netgunner_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_radio_operator_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_rifleman_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_rifleman_tg_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_shocktrooper_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_sniper_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_twin_captain_selector_node")
require("scripts/extension_systems/behavior/nodes/generated/bt_renegade_twin_captain_two_selector_node")

local BehaviorTree = class("BehaviorTree")

BehaviorTree.init = function (self, lua_tree_node, name)
	self._root = nil
	self._name = name
	self._action_data = {}

	self:parse_lua_tree(lua_tree_node)
end

BehaviorTree.action_data = function (self)
	return self._action_data
end

BehaviorTree.root = function (self)
	return self._root
end

BehaviorTree.name = function (self)
	return self._name
end

local CLASS_NAME_INDEX = 1

local function _create_btnode_from_lua_node(lua_node, parent_btnode)
	local class_name = lua_node[CLASS_NAME_INDEX]
	local identifier = lua_node.name
	local condition_name = lua_node.condition or "always_true"
	local enter_hook_name = lua_node.enter_hook
	local leave_hook_name = lua_node.leave_hook
	local run_hook = lua_node.run_hook
	local action_data = lua_node.action_data
	local class_type = CLASSES[class_name]

	if class_type then
		return class_type:new(identifier, parent_btnode, condition_name, enter_hook_name, leave_hook_name, run_hook, lua_node), action_data
	else
		ferror("[BehaviorTree] No class registered named %q.", class_name)
	end
end

BehaviorTree.parse_lua_tree = function (self, lua_root_node)
	self._root = _create_btnode_from_lua_node(lua_root_node)

	self:parse_lua_node(lua_root_node, self._root)
end

BehaviorTree.parse_lua_node = function (self, lua_node, parent)
	local num_children = #lua_node
	local tree_action_data = self._action_data

	for i = 2, num_children do
		local child = lua_node[i]
		local bt_node, action_data = _create_btnode_from_lua_node(child, parent)

		if action_data then
			tree_action_data[action_data.name] = action_data
		end

		if parent then
			parent:add_child(bt_node)
		end

		self:parse_lua_node(child, bt_node)
	end

	if parent.ready then
		parent:ready(lua_node)
	end
end

return BehaviorTree
