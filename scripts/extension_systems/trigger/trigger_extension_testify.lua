local TriggerExtensionTestify = {
	has_trigger_been_triggered = function (unit, trigger_extension, extension_unit)
		if unit == extension_unit then
			return trigger_extension:is_triggered()
		end

		return Testify.RETRY
	end,
	trigger_action_data = function (unit, trigger_extension, extension_unit)
		if unit == extension_unit then
			local action = trigger_extension:trigger_action()
			local action_target = action:target()
			local action_targets = NetworkLookup.trigger_action_targets

			return {
				is_triggered_on_server = action:action_on_server(),
				is_on_player_side = action_target == action_targets.player_side
			}
		end

		return Testify.RETRY
	end,
	trigger_condition_name = function (unit, trigger_extension, extension_unit)
		if unit == extension_unit then
			local condition = trigger_extension:trigger_condition()

			return condition:condition_name()
		end

		return Testify.RETRY
	end
}

return TriggerExtensionTestify
