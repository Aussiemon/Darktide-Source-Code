-- chunkname: @scripts/extension_systems/interaction/interactions/scripted_scenario_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local ScriptedScenarioInteraction = class("ScriptedScenarioInteraction", "BaseInteraction")

ScriptedScenarioInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(interactor_unit)
	local is_local_player = not player.remote

	if is_local_player then
		local target_unit = unit_data_component.target_unit
		local scripted_scenario_system = Managers.state.extension:system("scripted_scenario_system")
		local alias = Unit.get_data(target_unit, "scenario_alias")
		local scenario_name = Unit.get_data(target_unit, "scenario_name")
		local t = FixedFrame.get_latest_fixed_time()

		scripted_scenario_system:start_scenario(alias, scenario_name, t)
	end
end

return ScriptedScenarioInteraction
