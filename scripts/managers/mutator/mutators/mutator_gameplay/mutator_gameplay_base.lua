-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_base.lua

local MutatorGameplayBase = class("MutatorGameplayBase")

MutatorGameplayBase.init = function (self, owner, settings, triggered_by_level)
	self._owner = owner
	self._settings = settings
	self._level = triggered_by_level
	self._is_server = owner._is_server
	self._network_event_delegate = owner._network_event_delegate

	if not self._is_server then
		self:_client_setup()
	end
end

MutatorGameplayBase.update = function (self, dt, t)
	return
end

MutatorGameplayBase.destroy = function (self)
	if not self._is_server then
		self:_client_destroy()
	end

	self._level = nil
	self._owner = nil
	self._network_event_delegate = nil
end

MutatorGameplayBase._client_setup = function (self)
	return
end

MutatorGameplayBase._client_destroy = function (self)
	return
end

MutatorGameplayBase.hot_join_sync = function (self, sender, channel)
	if self.module_hot_join_sync then
		self.module_hot_join_sync(self._owner, sender, channel)
	end
end

MutatorGameplayBase.show_objective_popup_notification = function (self, key)
	if not self._is_server then
		return
	end

	if not self._settings.notifications then
		return
	end

	if not self._settings.notifications[key] then
		return
	end

	Managers.state.game_session:send_rpc_clients("rpc_show_objective_popup_notification", key)
end

return MutatorGameplayBase
