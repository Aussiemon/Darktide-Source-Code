local TriggerSettings = require("scripts/extension_systems/trigger/trigger_settings")
local ACTION_TARGETS = TriggerSettings.action_targets
local TriggerExtensionTestify = {
	has_trigger_been_triggered = function (trigger_extension, extension_unit, unit)
		if unit == extension_unit then
			return trigger_extension:_is_triggered()
		end

		return Testify.RETRY
	end,
	trigger_action_data = function (trigger_extension, extension_unit, unit)
		if unit == extension_unit then
			local action = trigger_extension._trigger_action
			local action_target = action._target

			return {
				is_triggered_on_server = action:action_on_server(),
				is_on_player_side = action_target == ACTION_TARGETS.player_side
			}
		end

		return Testify.RETRY
	end,
	trigger_condition_name = function (trigger_extension, extension_unit, unit)
		if unit == extension_unit then
			local condition = trigger_extension._trigger_condition

			return condition._condition_name
		end

		return Testify.RETRY
	end
}

return TriggerExtensionTestify
