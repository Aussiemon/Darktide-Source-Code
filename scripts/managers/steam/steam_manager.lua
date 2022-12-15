local SteamManager = class("SteamManager")

SteamManager.init = function (self)
	self._overlay_active = false
	self.callbacks = {}
	self.micro_txn_data = {}
end

SteamManager.update = function (self, t, dt)
	if HAS_STEAM then
		Steam.run_callbacks(self)
	end
end

SteamManager.on_overlay_activated = function (self, enabled)
	Log.info("SteamManager", "on_overlay_activated %s", enabled)

	self._overlay_active = enabled
end

SteamManager.is_overlay_active = function (self)
	return self._overlay_active
end

SteamManager.on_micro_txn = function (self, authorized, order_id)
	Log.info("SteamManager", "on_micro_txn %s %s", authorized, order_id)

	local callback = self.callbacks[order_id]

	if callback then
		callback(authorized, order_id)

		self.callbacks[order_id] = nil
	else
		self.micro_txn_data[order_id] = {
			authorized = authorized
		}
	end
end

SteamManager.register_micro_txn_callback = function (self, order_id, callback)
	if self.micro_txn_data[order_id] then
		callback(self.micro_txn_data[order_id].authorized, order_id)

		self.micro_txn_data[order_id] = nil
	else
		self.callbacks[order_id] = callback
	end
end

return SteamManager
