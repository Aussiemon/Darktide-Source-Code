local Hooks = require("scripts/managers/stats/groups/hook_stats")
local Factory = require("scripts/managers/stats/utility/stat_factory")
local Flags = require("scripts/settings/stats/stat_flags")
local Activations = require("scripts/managers/stats/utility/activation_functions")
local Parameters = require("scripts/managers/stats/utility/parameter_functions")
local Conditions = require("scripts/managers/stats/utility/conditional_functions")
local TeamStats = Factory.create_group()

Factory.add_to_group(TeamStats, Factory.create_simple("team_kill", Hooks.definitions.hook_team_kill, Activations.sum))
Factory.add_to_group(TeamStats, Factory.create_simple("team_damage_taken", Hooks.definitions.hook_team_damage_taken, Activations.sum))
Factory.add_to_group(TeamStats, Factory.create_simple("team_death", Hooks.definitions.hook_team_death, Activations.sum))
Factory.add_to_group(TeamStats, Factory.create_simple("team_knock_down", Hooks.definitions.hook_knock_down, Activations.sum))

return TeamStats
