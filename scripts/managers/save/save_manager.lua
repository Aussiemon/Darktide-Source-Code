-- chunkname: @scripts/managers/save/save_manager.lua

local Save = require("scripts/managers/save/utilities/save")
local SaveData = require("scripts/managers/save/save_data")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local SaveManager = class("SaveManager")

SaveManager.init = function (self, save_file_name, cloud_save_enabled)
	self._use_cloud = cloud_save_enabled
	self._save_file_name = save_file_name
	self._token = nil
	self._state = "idle"
	self._save_data = SaveData:new()
	self._queued_save = false
	self._save_done_cb = callback(self, "cb_save_done")
	self._load_done_cb = callback(self, "cb_load_done")
end

SaveManager.destroy = function (self)
	if self._token then
		self:abort()
	end
end

SaveManager.data = function (self)
	return self._save_data.data
end

SaveManager.state = function (self)
	return self._state
end

SaveManager.set_save_data_account_id = function (self, account_id)
	self._signed_in_account_id = account_id
end

SaveManager.save_data_account_id = function (self)
	return self._signed_in_account_id
end

SaveManager.account_data = function (self, account_id)
	account_id = account_id or self:save_data_account_id() or PlayerManager.NO_ACCOUNT_ID

	return self._save_data:account_data(account_id)
end

SaveManager.character_data = function (self, character_id)
	local account_id = self:save_data_account_id()

	return self._save_data:character_data(account_id, character_id)
end

SaveManager.abort = function (self)
	self._callback = nil
	self._state = "idle"

	Save.abort(self._token)

	self._token = nil
end

SaveManager.queue_save = function (self)
	if self._state == "idle" then
		self:save()
	else
		self._queued_save = true
	end
end

SaveManager.save = function (self, optional_callback)
	self._token = Save.auto_save(self._save_file_name, self._save_data, self._save_done_cb, self._use_cloud)
	self._callback = optional_callback
	self._state = "saving"
end

SaveManager.info = function (self)
	return self._token:info()
end

SaveManager.load = function (self, optional_callback)
	self._token = Save.auto_load(self._save_file_name, self._load_done_cb, self._use_cloud)
	self._callback = optional_callback
	self._state = "loading"
end

SaveManager.cb_save_done = function (self)
	self._token = nil
	self._state = "idle"

	local cb = self._callback

	if cb then
		cb()

		self._callback = nil
	end

	self:_handle_queued_save()
end

SaveManager.cb_load_done = function (self, token)
	self._token = nil

	self._save_data:populate(token.data)

	self._state = "idle"

	local cb = self._callback

	if cb then
		cb()

		self._callback = nil
	end

	self:_handle_queued_save()
end

SaveManager._handle_queued_save = function (self)
	if self._queued_save then
		self._queued_save = false

		self:save()
	end
end

return SaveManager
