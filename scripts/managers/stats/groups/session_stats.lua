local Hooks = require("scripts/managers/stats/groups/hook_stats")
local Factory = require("scripts/managers/stats/utility/stat_factory")
local Flags = require("scripts/settings/stats/stat_flags")
local Activations = require("scripts/managers/stats/utility/activation_functions")
local Comparators = require("scripts/managers/stats/utility/comparator_functions")
local Conditions = require("scripts/managers/stats/utility/conditional_functions")
local Parameters = require("scripts/managers/stats/utility/parameter_functions")
local Values = require("scripts/managers/stats/utility/value_functions")
local SessionStats = Factory.create_group()

Factory.add_to_group(SessionStats, Factory.create_dynamic_reducer("mission", Hooks.definitions.hook_mission, {
	"mission_name",
	"main_objective_type",
	"difficulty",
	"win",
	"side_objective_complete",
	"side_objective_name"
}, Activations.sum, {
	"name",
	"type",
	"difficulty",
	"win",
	"side_objective_complete",
	"side_objective_name"
}, {
	Flags.save_to_backend
}))
Factory.add_to_group(SessionStats, Factory.create_simple("complete_mission_no_death", Hooks.definitions.hook_mission, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "team_deaths", 0), Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true)), Activations.sum), {
	Flags.save_to_backend,
	Flags.ephemeral
}))
Factory.add_to_group(SessionStats, Factory.create_smart_reducer("collect_pickup", Hooks.definitions.hook_mission, {
	"side_objective_name"
}, {
	Parameters.transformers.side_objective_to_type
}, {
	"type"
}, Activations.on_condition(Conditions.all(Conditions.param_has_value(Hooks.definitions.hook_mission, "win", true), Conditions.any(Conditions.param_has_value(Hooks.definitions.hook_mission, "side_objective_name", "side_mission_grimoire"), Conditions.param_has_value(Hooks.definitions.hook_mission, "side_objective_name", "side_mission_tome"), Conditions.param_has_value(Hooks.definitions.hook_mission, "side_objective_name", "side_mission_consumable"))), Activations.replace_trigger_value(Activations.sum, Values.param(Hooks.definitions.hook_mission, "side_objective_count"))), {
	Flags.save_to_backend,
	Flags.ephemeral
}))
Factory.add_to_group(SessionStats, Factory.create_simple("team_kills", Hooks.definitions.hook_mission, Activations.use_parameter_value(Hooks.definitions.hook_mission, "team_kills"), {
	Flags.save_to_backend
}))
Factory.add_to_group(SessionStats, Factory.create_simple("team_deaths", Hooks.definitions.hook_mission, Activations.use_parameter_value(Hooks.definitions.hook_mission, "team_deaths"), {
	Flags.save_to_backend
}))
Factory.add_to_group(SessionStats, Factory.create_dynamic_reducer("collect_resource", Hooks.definitions.hook_collect_material, {
	"type"
}, Activations.sum, nil, {
	Flags.save_to_backend,
	Flags.ephemeral
}))
Factory.add_to_group(SessionStats, Factory.create_simple("blocked_damage", Hooks.definitions.hook_blocked_damage, Activations.sum, {
	Flags.save_to_backend,
	Flags.ephemeral
}))
Factory.add_to_group(SessionStats, Factory.create_smart_reducer("kill_minion", Hooks.definitions.hook_kill, {
	"weapon_attack_type",
	"breed_name"
}, {
	[2] = Parameters.transformers.faction_of_breed
}, {
	"type",
	"name"
}, Activations.on_condition(Conditions.inverse(Conditions.breed_is_boss(Hooks.definitions.hook_kill)), Activations.sum), {
	Flags.save_to_backend
}))
Factory.add_to_group(SessionStats, Factory.create_simple("kill_boss", Hooks.definitions.hook_boss_kill, Activations.increment, {
	Flags.save_to_backend
}))
Factory.add_to_group(SessionStats, Factory.create_smart_reducer("contract_team_kills", Hooks.definitions.hook_team_kill, {
	"weapon_attack_type",
	"breed_name"
}, {
	[2] = Parameters.transformers.faction_of_breed
}, {
	"type",
	"name"
}, Activations.on_condition(Conditions.inverse(Conditions.breed_is_boss(Hooks.definitions.hook_kill)), Activations.increment), {
	Flags.save_to_backend,
	Flags.ephemeral
}))
Factory.add_to_group(SessionStats, Factory.create_simple("contract_team_blocked_damage", Hooks.definitions.hook_team_blocked_damage, Activations.sum, {
	Flags.save_to_backend,
	Flags.ephemeral
}))

return SessionStats
