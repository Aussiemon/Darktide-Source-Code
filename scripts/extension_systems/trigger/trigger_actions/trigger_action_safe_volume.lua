require("scripts/extension_systems/trigger/trigger_actions/trigger_action_base")

local TriggerActionSafeVolume = class("TriggerActionSafeVolume", "TriggerActionBase")

TriggerActionSafeVolume.local_on_unit_enter = function (self, exiting_unit)
	TriggerActionSafeVolume.super.local_on_unit_enter(self, exiting_unit)
	Managers.event:trigger("in_safe_volume", true)
end

TriggerActionSafeVolume.local_on_unit_exit = function (self, exiting_unit)
	TriggerActionSafeVolume.super.local_on_unit_exit(self, exiting_unit)
	Managers.event:trigger("in_safe_volume", nil)

	local trigger_extension = ScriptUnit.extension(self._volume_unit, "trigger_system")

	trigger_extension:set_active(false)
end

return TriggerActionSafeVolume
