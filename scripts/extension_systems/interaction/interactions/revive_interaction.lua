require("scripts/extension_systems/interaction/interactions/base_interaction")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Vo = require("scripts/utilities/vo")
local ReviveInteraction = class("ReviveInteraction", "BaseInteraction")
local interaction_results = InteractionSettings.results
local proc_events = BuffSettings.proc_events

ReviveInteraction.start = function (self, world, interactor_unit, unit_data_component, t, is_server)
	ReviveInteraction.super.start(self, world, interactor_unit, unit_data_component, t, is_server)

	local target_unit = unit_data_component.target_unit
	local vo_event = self._template.vo_event

	Vo.player_interaction_vo_event(interactor_unit, target_unit, vo_event)
end

ReviveInteraction.interactee_condition_func = function (self, interactee_unit)
	local unit_data_extension = ScriptUnit.extension(interactee_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

	return is_knocked_down
end

ReviveInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server and result == interaction_results.success then
		local target_unit = unit_data_component.target_unit
		local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
		local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")
		assisted_state_input_component.success = true
		local knocked_down_state_input = unit_data_extension:write_component("knocked_down_state_input")
		knocked_down_state_input.knock_down = false
		local buff_extension = ScriptUnit.extension(interactor_unit, "buff_system")
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = interactor_unit
			param_table.revived_unit = target_unit

			buff_extension:add_proc_event(proc_events.on_revive, param_table)
		end

		local interactor_player = Managers.state.player_unit_spawn:owner(interactor_unit)
		local target_player = Managers.state.player_unit_spawn:owner(target_unit)

		if interactor_player and target_player then
			local reviver_position = POSITION_LOOKUP[interactor_unit]
			local revivee_position = POSITION_LOOKUP[target_unit]
			local state_name = "knocked_down"

			Managers.telemetry_events:player_revived_ally(interactor_player, target_player, reviver_position, revivee_position, state_name)

			local is_human_player = interactor_player:is_human_controlled()

			if is_human_player and Managers.stats.can_record_stats() then
				Managers.stats:record_assist_ally(interactor_player, target_player, self._template.type)
			end
		end
	end
end

return ReviveInteraction
