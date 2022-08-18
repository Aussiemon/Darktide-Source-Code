local PresenceEntryMyself = require("scripts/managers/presence/presence_entry_myself")
local PresenceEntryImmaterium = require("scripts/managers/presence/presence_entry_immaterium")
local PresenceManagerInterface = require("scripts/managers/presence/presence_manager_interface")
local LoggedInFromAnotherLocationError = require("scripts/managers/error/errors/logged_in_from_another_location_error")
local Promise = require("scripts/foundation/utilities/promise")
local XboxLiveUtilities = require("scripts/foundation/utilities/xbox_live")
local PresenceManager = class("PresenceManager")
local PRESENCE_UPDATE_INTERVAL = 30

local function _info(...)
	Log.info("PresenceManager", ...)
end

local function remove_empty_values(t)
	if table.is_empty(t) then
		return t
	end

	local result = {}

	for k, v in pairs(t) do
		if v ~= nil then
			result[k] = v
		end
	end

	return result
end

PresenceManager.init = function (self)
	self._myself = PresenceEntryMyself:new()
	self._presences_by_account_id = {}
	self._presences_by_platform_id = {}
	self._character_name_update_interval = 0
	self._update_interval = 0

	self:_init_immaterium_presence()
end

PresenceManager.destroy = function (self)
	return
end

PresenceManager.presence = function (self)
	return self._myself:activity_id()
end

PresenceManager.presence_entry_myself = function (self)
	return self._myself
end

PresenceManager.set_party = function (self, party_id, num_party_members)
	self._myself:set_party_id(party_id)
	self._myself:set_num_party_members(num_party_members)
	self:_update_my_presence({
		party_id = true,
		num_party_members = true
	})

	if HAS_STEAM then
		Presence.advertise_immaterium_party(party_id)
	end

	if XboxLiveUtilities.available() then
		local num_mission_members = self._myself:num_mission_members()

		if num_mission_members > 0 then
			XboxLiveUtilities.set_activity(party_id, num_mission_members - 1)
		else
			XboxLiveUtilities.set_activity(party_id, num_party_members - 1)
		end
	end
end

PresenceManager.set_num_mission_members = function (self, num_mission_members)
	self._myself:set_num_mission_members(num_mission_members)
	self:_update_my_presence({
		num_mission_members = true
	})

	if XboxLiveUtilities.available() then
		local party_id = self._myself:party_id()

		if party_id then
			if num_mission_members then
				XboxLiveUtilities.set_activity(party_id, num_mission_members - 1)
			else
				XboxLiveUtilities.set_activity(party_id, self._myself:num_party_members() - 1)
			end
		end
	end
end

PresenceManager.set_character_profile = function (self, character_profile)
	self._myself:set_character_profile(character_profile)
	self:_update_my_presence({
		character_profile = true
	})
end

PresenceManager.set_presence = function (self, activity_id)
	self._myself:set_activity_id(activity_id)
	self:_update_my_presence({
		activity_id = true
	})
end

PresenceManager.get_presence = function (self, account_id)
	if account_id == gRPC.get_account_id() then
		local myself = self:presence_entry_myself()

		return myself, Promise.resolved(myself)
	end

	local presence_entry = self._presences_by_account_id[account_id]

	if not presence_entry then
		presence_entry = PresenceEntryImmaterium:new(self._myself:platform(), "", account_id)
		self._presences_by_account_id[account_id] = presence_entry

		presence_entry:start_stream()
	end

	return presence_entry, presence_entry:first_update_promise()
end

PresenceManager.get_presence_by_platform = function (self, platform, platform_user_id)
	local platform_table = self._presences_by_platform_id[platform]

	if not platform_table then
		platform_table = {}
		self._presences_by_platform_id[platform] = platform_table
	end

	local presence_entry = platform_table[platform_user_id]

	if not presence_entry then
		presence_entry = PresenceEntryImmaterium:new(self._myself:platform(), platform, platform_user_id)
		platform_table[platform_user_id] = presence_entry

		presence_entry:start_stream()
	end

	return presence_entry, presence_entry:first_update_promise()
end

PresenceManager._init_immaterium_presence = function (self)
	local promise, id = Managers.grpc:start_presence(self._myself:create_key_values())
	self._immaterium_presence_operation_id = id

	promise:next(function ()
		self._immaterium_presence_operation_id = nil

		self:_init_immaterium_presence()
	end):catch(function (error)
		self._immaterium_presence_operation_id = nil

		_info("Disconnected from presence - " .. table.tostring(error, 3))

		if error.error_code == 10 then
			_info("Logged in from another location, sending fatal error...")
			Managers.error:report_error(LoggedInFromAnotherLocationError:new())
		else
			Managers.grpc:delay_with_jitter_and_backoff("my_presence_stream"):next(function ()
				self:_init_immaterium_presence()
			end)
		end
	end)
end

PresenceManager._update_immaterium = function (self)
	local entry_remove = false

	for id, presence in pairs(self._presences_by_account_id) do
		if presence and (not presence:reset_alive_queried() or not presence:has_operation()) then
			presence:destroy()

			entry_remove = true
			self._presences_by_account_id[id] = nil
		end
	end

	if entry_remove then
		self._presences_by_account_id = remove_empty_values(self._presences_by_account_id)
	end

	for platform, platform_table in pairs(self._presences_by_platform_id) do
		entry_remove = false

		for id, presence in pairs(platform_table) do
			if presence and (not presence:reset_alive_queried() or not presence:has_operation()) then
				presence:destroy()

				entry_remove = true
				platform_table[id] = nil
			end
		end

		if entry_remove then
			self._presences_by_platform_id[platform] = remove_empty_values(platform_table)
		end
	end

	self._update_interval = PRESENCE_UPDATE_INTERVAL
end

PresenceManager._update_my_presence = function (self, ...)
	if self._immaterium_presence_operation_id then
		Managers.grpc:update_presence(self._immaterium_presence_operation_id, self._myself:create_key_values(...))
	end
end

PresenceManager._run_update_on_entries = function (self)
	for id, presence in pairs(self._presences_by_account_id) do
		presence:update()
	end

	for platform, platform_table in pairs(self._presences_by_platform_id) do
		for id, presence in pairs(platform_table) do
			presence:update()
		end
	end
end

PresenceManager.update = function (self, dt, t)
	self._character_name_update_interval = self._character_name_update_interval - dt

	if self._character_name_update_interval <= 0 then
		local profile = Managers.player:local_player_backend_profile()
		self._character_name_update_interval = 1
		local prev_character_profile = self._myself:character_profile()

		if profile and (not prev_character_profile or prev_character_profile ~= profile) then
			self:set_character_profile(profile)
		end
	end

	self._update_interval = self._update_interval - dt

	if self._update_interval <= 0 then
		self:_update_immaterium()
	end

	self:_run_update_on_entries()

	if self._immaterium_presence_operation_id then
		local push_messages = Managers.grpc:get_push_messages(self._immaterium_presence_operation_id)

		if push_messages then
			for i, push_message in ipairs(push_messages) do
				_info("received push message=" .. table.tostring(push_message, 3))

				if push_message.type == "event_trigger" then
					local payload = cjson.decode(push_message.payload)

					Managers.event:trigger("backend_" .. payload.event_name, unpack(payload.args))
				end
			end
		end
	end
end

implements(PresenceManager, PresenceManagerInterface)

return PresenceManager
