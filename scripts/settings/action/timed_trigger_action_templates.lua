-- chunkname: @scripts/settings/action/timed_trigger_action_templates.lua

local TimedTriggerActionTemplates = {}

TimedTriggerActionTemplates.expedition_time_syringe = {
	execution_type = "trigger",
	trigger_time = nil,
	trigger_function = function (is_server)
		if not is_server then
			return
		end

		Managers.event:trigger("event_add_expedition_time_bonus", 300)
	end,
}

return TimedTriggerActionTemplates
