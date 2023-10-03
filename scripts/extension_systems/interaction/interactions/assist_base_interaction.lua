require("scripts/extension_systems/interaction/interactions/base_interaction")

local Vo = require("scripts/utilities/vo")
local AssistBaseInteraction = class("AssistBaseInteraction", "BaseInteraction")

AssistBaseInteraction.start = function (self, world, interactor_unit, unit_data_component, t, is_server)
	AssistBaseInteraction.super.start(self, world, interactor_unit, unit_data_component, t, is_server)

	local target_unit = unit_data_component.target_unit
	local vo_event = self._template.vo_event

	if vo_event then
		Vo.player_interaction_vo_event(interactor_unit, target_unit, vo_event)
	end
end

AssistBaseInteraction._handle_buffs = function (self, interactor_unit, target_unit, proc_event)
	local buff_extension = ScriptUnit.extension(interactor_unit, "buff_system")
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = interactor_unit
		param_table.target_unit = target_unit

		buff_extension:add_proc_event(proc_event, param_table)
	end
end

AssistBaseInteraction._record_stats_and_telemetry = function (self, interactor_unit, target_unit, stats_func_name, from_state_name)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local interactor_player = player_unit_spawn_manager:owner(interactor_unit)
	local target_player = player_unit_spawn_manager:owner(target_unit)

	if interactor_player and target_player then
		local stats_manager = Managers.stats

		if stats_manager.can_record_stats() then
			local is_human_player = interactor_player:is_human_controlled()

			if is_human_player then
				stats_manager[stats_func_name](stats_manager, interactor_player, target_player, self._template.type)
			end
		end
	end

	local interactor_position = POSITION_LOOKUP[interactor_unit]
	local interactee_position = POSITION_LOOKUP[target_unit]

	Managers.telemetry_events:player_revived_ally(interactor_player, target_player, interactor_position, interactee_position, from_state_name)
end

return AssistBaseInteraction
