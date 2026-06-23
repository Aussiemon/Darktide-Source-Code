-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_odin.lua

require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_base")

local MutatorGameplayOdin = class("MutatorGameplayOdin", "MutatorGameplayBase")

MutatorGameplayOdin.init = function (self, owner, settings, triggered_by_level)
	MutatorGameplayOdin.super.init(self, owner, settings, triggered_by_level)

	if not self._is_server then
		return
	end

	self._odin_implementation = owner._template.gameplay_template.odin_implementation
	self._odin_state, self._odin_event_listeners = self._odin_implementation.init(self._settings)

	if self._odin_event_listeners then
		for event_name, odin_listener in pairs(self._odin_event_listeners) do
			Log.debug("MutatorGameplayOdin", "register odin event listener", event_name, odin_listener)
			Managers.event:register_with_parameters(self, event_name, "_on_event_passthrough", odin_listener)
		end
	end
end

MutatorGameplayOdin.update = function (self, dt, t)
	MutatorGameplayOdin.super.update(self, dt, t)

	if self._odin_implementation.update then
		self._odin_implementation.update(self._odin_state, dt, t)
	end
end

MutatorGameplayOdin.destroy = function (self)
	MutatorGameplayOdin.super.destroy(self)
	self._odin_implementation.destroy(self._odin_state)

	if self._odin_event_listeners then
		for event_name, _ in pairs(self._odin_event_listeners) do
			Managers.event:unregister(self, event_name)
		end
	end
end

MutatorGameplayOdin._on_event_passthrough = function (self, odin_listener, ...)
	odin_listener(self._odin_state, ...)
end

return MutatorGameplayOdin
