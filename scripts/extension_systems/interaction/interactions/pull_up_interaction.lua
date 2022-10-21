require("scripts/extension_systems/interaction/interactions/base_interaction")

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local interaction_results = InteractionSettings.results
local PullUpInteraction = class("PullUpInteraction", "BaseInteraction")

PullUpInteraction.start = function (self, world, interactor_unit, unit_data_component, t, is_server)
	PullUpInteraction.super.start(self, world, interactor_unit, unit_data_component, t, is_server)
end

PullUpInteraction.interactee_condition_func = function (self, interactee_unit)
	local unit_data_extension = ScriptUnit.extension(interactee_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local ledge_hanging_character_state_component = unit_data_extension:read_component("ledge_hanging_character_state")
	local is_interactible = ledge_hanging_character_state_component.is_interactible
	local is_ledge_hanging = PlayerUnitStatus.is_ledge_hanging(character_state_component)

	return is_ledge_hanging and is_interactible
end

PullUpInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, is_server)
	if is_server and result == interaction_results.success then
		local target_unit = unit_data_component.target_unit
		local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
		local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")
		assisted_state_input_component.success = true
		local interactor_player = Managers.state.player_unit_spawn:owner(interactor_unit)
		local target_player = Managers.state.player_unit_spawn:owner(target_unit)
		local reviver_position = POSITION_LOOKUP[interactor_unit]
		local revivee_position = POSITION_LOOKUP[target_unit]
		local state_name = "ledge_hanging"

		Managers.telemetry_events:player_revived_ally(interactor_player, target_player, reviver_position, revivee_position, state_name)
	end
end

return PullUpInteraction
