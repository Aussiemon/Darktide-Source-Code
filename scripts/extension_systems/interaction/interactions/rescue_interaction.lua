require("scripts/extension_systems/interaction/interactions/base_interaction")

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Vo = require("scripts/utilities/vo")
local RescueInteraction = class("RescueInteraction", "BaseInteraction")
local interaction_results = InteractionSettings.results

RescueInteraction.start = function (self, world, interactor_unit, unit_data_component, t, is_server)
	RescueInteraction.super.start(self, world, interactor_unit, unit_data_component, t, is_server)

	local target_unit = unit_data_component.target_unit
	local vo_event = self._template.vo_event

	Vo.player_interaction_vo_event(interactor_unit, target_unit, vo_event)
end

RescueInteraction.interactee_condition_func = function (self, interactee_unit)
	local unit_data_extension = ScriptUnit.extension(interactee_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local is_hogtied = PlayerUnitStatus.is_hogtied(character_state_component)

	return is_hogtied
end

RescueInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server and result == interaction_results.success then
		local target_unit = unit_data_component.target_unit
		local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
		local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")
		assisted_state_input_component.success = true
		local hogtied_state_input = unit_data_extension:write_component("hogtied_state_input")
		hogtied_state_input.hogtie = false
		local interactor_player = Managers.state.player_unit_spawn:owner(interactor_unit)
		local target_player = Managers.state.player_unit_spawn:owner(target_unit)

		if Managers.stats.can_record_stats() and interactor_player and target_player then
			local is_human_player = interactor_player:is_human_controlled()

			if is_human_player then
				Managers.stats:record_rescue_ally(interactor_player, target_player)
			end
		end

		local reviver_position = POSITION_LOOKUP[interactor_unit]
		local revivee_position = POSITION_LOOKUP[target_unit]
		local state_name = "hogtied"

		Managers.telemetry_events:player_revived_ally(interactor_player, target_player, reviver_position, revivee_position, state_name)
	end
end

return RescueInteraction
