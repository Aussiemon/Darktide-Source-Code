-- chunkname: @scripts/components/expedition_transition_activator.lua

local ExpeditionTransitionActivator = component("ExpeditionTransitionActivator")

ExpeditionTransitionActivator.init = function (self, unit)
	self._unit = unit

	self:enable(unit)
	Managers.event:trigger("expedition_register_transition_activator", unit)
end

ExpeditionTransitionActivator.editor_init = function (self, unit)
	self:enable(unit)

	self._should_debug_draw = false
end

ExpeditionTransitionActivator.enable = function (self, unit)
	return
end

ExpeditionTransitionActivator.disable = function (self, unit)
	return
end

ExpeditionTransitionActivator.destroy = function (self, unit)
	Managers.event:trigger("expedition_unregister_transition_activator", unit)
end

ExpeditionTransitionActivator.editor_destroy = function (self, unit)
	return
end

ExpeditionTransitionActivator.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

ExpeditionTransitionActivator.started = function (self)
	Managers.event:trigger("expedition_transition_activator_started", self._unit)
end

ExpeditionTransitionActivator.component_data = {
	inputs = {
		started = {
			accessibility = "public",
			type = "event",
		},
	},
}

return ExpeditionTransitionActivator
