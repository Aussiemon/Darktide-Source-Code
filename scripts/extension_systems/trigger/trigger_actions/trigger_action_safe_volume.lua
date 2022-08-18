require("scripts/extension_systems/trigger/trigger_actions/trigger_action_base")

local TriggerActionSafeVolume = class("TriggerActionSafeVolume", "TriggerActionBase")

TriggerActionSafeVolume.local_on_activate = function (self, unit)
	TriggerActionSafeVolume.super.local_on_activate(self, unit)
	Managers.event:trigger("in_safe_volume", true)
end

TriggerActionSafeVolume.local_on_deactivate = function (self, unit)
	TriggerActionSafeVolume.super.local_on_deactivate(self, unit)
	Managers.event:trigger("in_safe_volume", nil)
end

return TriggerActionSafeVolume
