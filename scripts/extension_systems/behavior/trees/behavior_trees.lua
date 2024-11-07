-- chunkname: @scripts/extension_systems/behavior/trees/behavior_trees.lua

require("scripts/foundation/utilities/settings")
require("scripts/foundation/utilities/table")

local behavior_trees = {}

local function _create_behavior_tree_entry(path)
	local behavior_tree = require(path)
	local behavior_tree_name = behavior_tree.name

	behavior_trees[behavior_tree_name] = behavior_tree
end

_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/bot/bot_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_armored_infected_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_mutated_poxwalker_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_lesser_mutated_poxwalker_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_beast_of_nurgle_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_daemonhost_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_hound_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_newly_infected_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_ogryn_bulwark_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_ogryn_executor_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_ogryn_gunner_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_plague_ogryn_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_poxwalker_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_poxwalker_bomber_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/chaos/chaos_spawn_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/cultist/cultist_assault_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/cultist/cultist_berzerker_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/cultist/cultist_captain_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/cultist/cultist_flamer_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/cultist/cultist_grenadier_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/cultist/cultist_gunner_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/cultist/cultist_melee_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/cultist/cultist_mutant_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/cultist/cultist_shocktrooper_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_assault_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_berzerker_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_captain_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_executor_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_flamer_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_flamer_mutator_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_grenadier_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_gunner_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_gunner_tg_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_melee_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_netgunner_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_twin_captain_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_twin_captain_two_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_rifleman_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_rifleman_tg_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_shocktrooper_behavior_tree")
_create_behavior_tree_entry("scripts/extension_systems/behavior/trees/renegade/renegade_sniper_behavior_tree")

local function _setup_generated_behavior_trees()
	for bt_name, bt_node in pairs(behavior_trees) do
		local capitalized_bt_name = bt_name:gsub("^%l", string.upper)
		local camel_case_bt_name = capitalized_bt_name:gsub("_(%l)", string.upper)

		bt_node[1] = string.format("Bt%sSelectorNode", camel_case_bt_name)
		bt_node.name = bt_name .. "_GENERATED"
	end
end

local function _setup_behavior_trees()
	_setup_generated_behavior_trees()
end

_setup_behavior_trees()

return settings("BehaviorTrees", behavior_trees)
