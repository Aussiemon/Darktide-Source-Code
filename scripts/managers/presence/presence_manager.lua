-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
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

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	local entry_remove = false

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-26, warpins: 0 ---
	for id, presence in pairs(self._presences_by_account_id) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 6-7, warpins: 1 ---
		if presence and (not presence:reset_alive_queried() or not presence:has_operation()) then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 18-24, warpins: 2 ---
			presence:destroy()

			entry_remove = true
			self._presences_by_account_id[id] = nil
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 25-26, warpins: 4 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 27-28, warpins: 1 ---
	if entry_remove then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 29-32, warpins: 1 ---
		self._presences_by_account_id = remove_empty_values(self._presences_by_account_id)
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 33-36, warpins: 2 ---
	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 37-70, warpins: 0 ---
	for platform, platform_table in pairs(self._presences_by_platform_id) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 37-41, warpins: 1 ---
		entry_remove = false

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 42-61, warpins: 0 ---
		for id, presence in pairs(platform_table) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 42-43, warpins: 1 ---
			if presence and (not presence:reset_alive_queried() or not presence:has_operation()) then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 54-59, warpins: 2 ---
				presence:destroy()

				entry_remove = true
				platform_table[id] = nil
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 60-61, warpins: 4 ---
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 62-63, warpins: 1 ---
		if entry_remove then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 64-68, warpins: 1 ---
			self._presences_by_platform_id[platform] = remove_empty_values(platform_table)
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #2 ---

		FLOW; TARGET BLOCK #3



		-- Decompilation error in this vicinity:
		--- BLOCK #3 69-70, warpins: 3 ---
		--- END OF BLOCK #3 ---



	end

	--- END OF BLOCK #4 ---

	FLOW; TARGET BLOCK #5



	-- Decompilation error in this vicinity:
	--- BLOCK #5 71-73, warpins: 1 ---
	self._update_interval = PRESENCE_UPDATE_INTERVAL

	return
	--- END OF BLOCK #5 ---



end

PresenceManager._update_my_presence = function (self, ...)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if self._immaterium_presence_operation_id then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-14, warpins: 1 ---
		Managers.grpc:update_presence(self._immaterium_presence_operation_id, self._myself:create_key_values(...))
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 15-15, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

PresenceManager._run_update_on_entries = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 5-9, warpins: 0 ---
	for id, presence in pairs(self._presences_by_account_id) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 5-7, warpins: 1 ---
		presence:update()
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 8-9, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 10-13, warpins: 1 ---
	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 14-24, warpins: 0 ---
	for platform, platform_table in pairs(self._presences_by_platform_id) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 14-17, warpins: 1 ---
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 18-22, warpins: 0 ---
		for id, presence in pairs(platform_table) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 18-20, warpins: 1 ---
			presence:update()
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 21-22, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end
		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 23-24, warpins: 2 ---
		--- END OF BLOCK #2 ---



	end

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 25-25, warpins: 1 ---
	return
	--- END OF BLOCK #4 ---



end

PresenceManager.update = function (self, dt, t)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	self._character_name_update_interval = self._character_name_update_interval - dt

	if self._character_name_update_interval <= 0 then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 8-20, warpins: 1 ---
		local profile = Managers.player:local_player_backend_profile()
		self._character_name_update_interval = 1
		local prev_character_profile = self._myself:character_profile()

		if profile and (not prev_character_profile or prev_character_profile ~= profile) then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 25-28, warpins: 2 ---
			self:set_character_profile(profile)
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 29-35, warpins: 4 ---
	self._update_interval = self._update_interval - dt

	if self._update_interval <= 0 then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 36-38, warpins: 1 ---
		self:_update_immaterium()
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 39-44, warpins: 2 ---
	self:_run_update_on_entries()

	if self._immaterium_presence_operation_id then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 45-52, warpins: 1 ---
		local push_messages = Managers.grpc:get_push_messages(self._immaterium_presence_operation_id)

		if push_messages then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 53-56, warpins: 1 ---
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 57-85, warpins: 0 ---
			for i, push_message in ipairs(push_messages) do

				-- Decompilation error in this vicinity:
				--- BLOCK #0 57-68, warpins: 1 ---
				_info("received push message=" .. table.tostring(push_message, 3))

				if push_message.type == "event_trigger" then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 69-83, warpins: 1 ---
					local payload = cjson.decode(push_message.payload)

					Managers.event:trigger("backend_" .. payload.event_name, unpack(payload.args))
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---

				FLOW; TARGET BLOCK #1



				-- Decompilation error in this vicinity:
				--- BLOCK #1 84-85, warpins: 3 ---
				--- END OF BLOCK #1 ---



			end
			--- END OF BLOCK #1 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 86-86, warpins: 3 ---
	return
	--- END OF BLOCK #3 ---



end

implements(PresenceManager, PresenceManagerInterface)

return PresenceManager
