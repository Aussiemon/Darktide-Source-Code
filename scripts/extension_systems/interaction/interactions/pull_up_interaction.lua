-- chunkname: @scripts/extension_systems/interaction/interactions/pull_up_interaction.lua

require("scripts/extension_systems/interaction/interactions/assist_base_interaction")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local interaction_results = InteractionSettings.results
local proc_events = BuffSettings.proc_events
local PullUpInteraction = class("PullUpInteraction", "AssistBaseInteraction")

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

		self:_handle_buffs(interactor_unit, target_unit, proc_events.on_pull_up)
		self:_record_stats_and_telemetry(interactor_unit, target_unit, "hook_assist_ally", "ledge_hanging")
	end
end

return PullUpInteraction
