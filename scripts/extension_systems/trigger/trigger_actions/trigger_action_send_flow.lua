require("scripts/extension_systems/trigger/trigger_actions/trigger_action_base")

local TriggerActionSendFlow = class("TriggerActionSendFlow", "TriggerActionBase")

TriggerActionSendFlow.local_on_activate = function (self, unit)
	TriggerActionSendFlow.super.local_on_activate(self, unit)
	Unit.flow_event(self._volume_unit, "lua_trigger_activated")
end

TriggerActionSendFlow.local_on_deactivate = function (self, unit)
	TriggerActionSendFlow.super.local_on_deactivate(self, unit)
	Unit.flow_event(self._volume_unit, "lua_trigger_deactivated")
end

return TriggerActionSendFlow
