-- chunkname: @scripts/managers/save/save_manager_ps5.lua

local SaveData = require("scripts/managers/save/save_data")
local Save = require("scripts/managers/save/utilities/save")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local STATES = table.enum("idle", "saving", "showing_dialog", "loading")

local function _info(...)
	Log.info("SaveManager", ...)
end

local SaveManager = class("SaveManager")

SaveManager.init = function (self, file_name)
	self._file_name = "save_data.sav"
	self._folder_name = "darktide"
	self._token = nil
	self._state = STATES.idle
	self._save_data = SaveData:new()
	self._queued_save = false
	self._save_done_cb = callback(self, "cb_save_done")
	self._load_done_cb = callback(self, "cb_load_done")
end

SaveManager.data = function (self)
	return self._save_data.data
end

SaveManager.state = function (self)
	return self._state
end

SaveManager.queue_save = function (self)
	if self._state == STATES.idle then
		self:save()
	else
		self._queued_save = true
	end
end

SaveManager.save = function (self, optional_callback)
	local save_info = {
		title = "Darktide",
		name = self._folder_name,
		files = {
			{
				path = self._file_name,
				data = self._save_data,
			},
		},
	}

	_info("SAVING...")

	self._token = Save.save(save_info, self._save_done_cb)
	self._save_callback = optional_callback
	self._state = STATES.saving
end

SaveManager.abort = function (self)
	self._callback = nil
	self._state = STATES.idle

	Save.abort(self._token)

	self._token = nil
end

SaveManager.update = function (self)
	if self._state == STATES.showing_dialog then
		local status = SaveSystemDialog.update()

		if status == SaveSystemDialog.FINISHED then
			SaveSystemDialog.terminate()
			self:_trigger_save_done()
		end
	end
end

SaveManager.cb_save_done = function (self, info)
	_info("Save done")

	if info.error == "OUT_OF_SPACE" then
		self._state = STATES.showing_dialog

		SaveSystemDialog.initialize()

		local user_id = PS5.initial_user_id()

		SaveSystemDialog.open(info.space_missing, user_id)
	else
		self:_trigger_save_done()
	end

	self._token = nil
end

SaveManager._trigger_save_done = function (self)
	self._state = STATES.idle

	if self._save_callback then
		self._save_callback()

		self._save_callback = nil
	end

	self:_handle_queued_save()
end

SaveManager._handle_queued_save = function (self)
	if self._queued_save then
		self._queued_save = false

		self:save()
	end
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

SaveManager.load = function (self, optional_callback)
	_info("LOADING...")

	local load_info = {
		name = self._folder_name,
		files = {
			{
				path = self._file_name,
			},
		},
	}

	self._load_callback = optional_callback
	self._token = Save.load(load_info, self._load_done_cb)
	self._state = STATES.loading
end

SaveManager.cb_load_done = function (self, token)
	_info("Load done")

	self._token = nil

	self._save_data:populate(token.data)

	self._state = STATES.idle

	if self._load_callback then
		self._load_callback()

		self._load_callback = nil
	end

	self:_handle_queued_save()
end

return SaveManager
