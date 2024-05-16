-- chunkname: @scripts/extension_systems/training_grounds/shooting_range_scenarios.lua

local ShootingRangeSteps = require("scripts/extension_systems/training_grounds/shooting_range_steps")
local TrainingGroundsSteps = require("scripts/extension_systems/training_grounds/training_grounds_steps")
local GenericSteps = require("scripts/extension_systems/scripted_scenario/generic_steps")
local ShootingRangeScenarios = {}

ShootingRangeScenarios.init = {
	steps = {
		ShootingRangeSteps.init,
		ShootingRangeSteps.make_player_invulnerable,
		GenericSteps.dynamic.add_unique_buff("tg_player_unperceivable"),
		GenericSteps.dynamic.start_parallel_scenario("shooting_range", "portal_loop"),
		GenericSteps.dynamic.start_parallel_scenario("shooting_range", "pickup_loop"),
		GenericSteps.dynamic.start_parallel_scenario("shooting_range", "enemies_loop"),
		GenericSteps.dynamic.start_parallel_scenario("shooting_range", "chest_loop"),
	},
	cleanup = {},
}
ShootingRangeScenarios.portal_loop = {
	steps = {
		ShootingRangeSteps.portal_loop,
	},
	cleanup = {},
}
ShootingRangeScenarios.pickup_loop = {
	steps = {
		ShootingRangeSteps.pickup_loop,
	},
	cleanup = {},
}
ShootingRangeScenarios.open_loadout = {
	steps = {
		ShootingRangeSteps.disable_loadout,
		ShootingRangeSteps.fade_to_black,
		TrainingGroundsSteps.dynamic.delay(0.5),
		ShootingRangeSteps.open_loadout,
		ShootingRangeSteps.fade_from_black,
	},
	cleanup = {},
}
ShootingRangeScenarios.enemies_loop = {
	steps = {
		ShootingRangeSteps.enemies_loop,
	},
	cleanup = {},
}
ShootingRangeScenarios.weak_enemies_loop = {
	steps = {
		ShootingRangeSteps.weak_enemies_loop,
	},
	cleanup = {},
}
ShootingRangeScenarios.medium_enemies_loop = {
	steps = {
		ShootingRangeSteps.medium_enemies_loop,
	},
	cleanup = {},
}
ShootingRangeScenarios.heavy_enemies_loop = {
	steps = {
		ShootingRangeSteps.heavy_enemies_loop,
	},
	cleanup = {},
}
ShootingRangeScenarios.chest_loop = {
	steps = {
		ShootingRangeSteps.chest_loop,
	},
	cleanup = {},
}

for name, scenario_template in pairs(ShootingRangeScenarios) do
	scenario_template.name = name
end

return ShootingRangeScenarios
