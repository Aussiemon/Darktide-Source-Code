require("scripts/extension_systems/interaction/interactions/assist_base_interaction")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local interaction_results = InteractionSettings.results
local proc_events = BuffSettings.proc_events
local RescueInteraction = class("RescueInteraction", "AssistBaseInteraction")

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

		self:_handle_buffs(interactor_unit, target_unit, proc_events.on_rescue)
		self:_record_stats_and_telemetry(interactor_unit, target_unit, "record_rescue_ally", "hogtied")
	end
end

return RescueInteraction
