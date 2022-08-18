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
local PresenceEntryInterface = require("scripts/managers/presence/presence_entry")
local PresenceSettings = require("scripts/settings/presence/presence_settings")
local Promise = require("scripts/foundation/utilities/promise")
local ProfileUtils = require("scripts/utilities/profile_utils")
local PresenceEntryImmaterium = class("PresenceEntryImmaterium")

PresenceEntryImmaterium.init = function (self, my_own_platform, platform, platform_user_id)
	assert(platform, "platform is not set")
	assert(platform_user_id, "platform_user_id is not set")

	self._my_own_platform = my_own_platform
	local immaterium_entry = {
		account_name = "",
		platform = "",
		platform_user_id = "",
		status = "OFFLINE",
		last_update = 0,
		account_id = "",
		key_values = {}
	}

	if platform == "" then
		self._account_id = platform_user_id
		immaterium_entry.account_id = platform_user_id
	else
		self._platform = platform
		self._platform_user_id = platform_user_id
		immaterium_entry.platform = platform
		immaterium_entry.platform_user_id = platform_user_id
	end

	self._has_done_platform_request = false
	self._immaterium_entry = immaterium_entry
	self._alive_queried = false
	self._alive = true
	self._stream_operation_id = nil
	self._stream_first_update_promises = {}
	self._parsed_character_profile = nil
end

PresenceEntryImmaterium.destroy = function (self)
	if self._stream_operation_id then
		Managers.grpc:abort_operation(self._stream_operation_id)

		self._stream_operation_id = nil
	end

	if self._stream_first_update_promises then
		local error = {
			aborted = true
		}

		for _, promise in ipairs(self._stream_first_update_promises) do
			promise:reject(error)
		end

		self._stream_first_update_promises = nil
	end

	self._alive = false
end

PresenceEntryImmaterium.update = function (self)
	if self._stream_operation_id then
		local new_immaterium_entry = Managers.grpc:get_latest_presence_from_stream(self._stream_operation_id)

		if new_immaterium_entry then
			self:_info("Got presence entry " .. table.tostring(new_immaterium_entry, 5))
			self:update_with(new_immaterium_entry)

			if self._stream_first_update_promises then
				for _, promise in ipairs(self._stream_first_update_promises) do
					promise:resolve(self)
				end

				self._stream_first_update_promises = nil
			end
		end
	end
end

PresenceEntryImmaterium.first_update_promise = function (self)
	if self._stream_first_update_promises then
		local promise = Promise:new()

		table.insert(self._stream_first_update_promises, promise)

		return promise
	end

	return Promise.resolved(self)
end

PresenceEntryImmaterium.start_stream = function (self)
	assert(not self._stream_operation_id, "a stream is already active")

	local promise, id = nil

	if self._account_id then
		promise, id = Managers.grpc:get_presence_stream("", self._account_id)
	else
		promise, id = Managers.grpc:get_presence_stream(self._platform, self:_convert_platform_user_id_for_immaterium(self._platform, self._platform_user_id))
	end

	self:_info("created stream with id " .. id)

	self._stream_operation_id = id

	promise:next(function ()
		self._stream_operation_id = nil

		self:start_stream()
	end):catch(function (error)
		self._stream_operation_id = nil

		if self._stream_open_promise then
			self._stream_open_promise:reject(error)

			self._stream_open_promise = nil
		end

		if error.aborted then
			self:_info("aborted stream")
		else
			self:_error("get_presence_stream returned error " .. table.tostring(error, 3))
		end
	end)
end

PresenceEntryImmaterium.update_with = function (self, new_entry)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if not self._immaterium_entry or self._immaterium_entry.last_update < new_entry.last_update then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-34, warpins: 2 ---
		self._immaterium_entry = self:_process_platform_id_convert(new_entry)
		self._immaterium_entry = self:_process_character_profile_convert(new_entry)

		self:_update_from_platform()

		self._account_and_platform_composite_id = self:account_id() .. ":" .. self:platform() .. ":" .. self:platform_user_id()
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 35-35, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium.is_myself = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return false
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium.account_id = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return self._immaterium_entry.account_id
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium.account_and_platform_composite_id = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._account_and_platform_composite_id
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium.account_name = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return self._immaterium_entry.account_name
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium.activity_id = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	return self:_key_value_string("activity_id") or "splash_screen"
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 8-8, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium.activity_localized = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-12, warpins: 1 ---
	local hud_localization = PresenceSettings[self:activity_id()].hud_localization

	return Managers.localization:localize(hud_localization)
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium.character_id = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	return (self:character_profile() and self:character_profile().character_id) or ""
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 13-13, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium.character_name = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	return (self:character_profile() and self:character_profile().name) or ""
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 13-13, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium.character_profile = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._parsed_character_profile
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium.platform = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return self._immaterium_entry.platform
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium.platform_icon = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	local platform = self._immaterium_entry.platform
	local is_on_my_platform = self._my_own_platform == platform

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 9-10, warpins: 2 ---
	if is_on_my_platform then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 11-12, warpins: 1 ---
		if platform == "steam" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 13-15, warpins: 1 ---
			return "\ue06b"
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 16-17, warpins: 1 ---
			if platform == "xbox" then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 18-19, warpins: 1 ---
				return "\ue06c"
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 20-21, warpins: 4 ---
	return nil
	--- END OF BLOCK #2 ---



end

PresenceEntryImmaterium.platform_user_id = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return self._immaterium_entry.platform_user_id
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium.is_online = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	return self._immaterium_entry.status == "ONLINE"
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 8-8, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium.platform_persona_name_or_account_name = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if HAS_STEAM and self:platform_user_id() and self:platform() == "steam" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 14-19, warpins: 1 ---
		return Steam.user_name(self:platform_user_id())
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 20-23, warpins: 4 ---
	if self._immaterium_entry.account_name ~= "" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 24-26, warpins: 1 ---
		return self._immaterium_entry.account_name
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 27-28, warpins: 2 ---
	return nil
	--- END OF BLOCK #2 ---



end

PresenceEntryImmaterium.num_party_members = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	return tonumber(self:_key_value_string("num_party_members")) or 0
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-10, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium.num_mission_members = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	return tonumber(self:_key_value_string("num_mission_members")) or 0
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-10, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium.party_id = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	return self:_key_value_string("party_id")
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium.is_alive = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if self._alive then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-5, warpins: 1 ---
		self._alive_queried = true
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-7, warpins: 2 ---
	return self._alive
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium.has_operation = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return self._stream_operation_id ~= nil
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 7-7, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium.reset_alive_queried = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	local alive_queried = self._alive_queried
	self._alive_queried = false

	return alive_queried
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium._log_id = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if self._account_id then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-9, warpins: 1 ---
		return "[" .. self._account_id .. "]"
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 10-16, warpins: 1 ---
		return "[" .. self._platform .. ":" .. self._platform_user_id .. "]"
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 17-17, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium._info = function (self, message)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-10, warpins: 1 ---
	Log.info("PresenceEntryImmaterium" .. self:_log_id(), message)

	return
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium._error = function (self, message)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-10, warpins: 1 ---
	Log.info("PresenceEntryImmaterium" .. self:_log_id(), message)

	return
	--- END OF BLOCK #0 ---



end

PresenceEntryImmaterium._process_platform_id_convert = function (self, new_entry)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if HAS_STEAM and new_entry.platform == "steam" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-12, warpins: 1 ---
		new_entry.platform_user_id = Steam.id_dec_to_hex(new_entry.platform_user_id)
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 13-15, warpins: 2 ---
		if new_entry.platform == "xbox" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 16-20, warpins: 1 ---
			new_entry.platform_user_id = XboxLive.xuid_dec_to_hex(new_entry.platform_user_id)
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 21-21, warpins: 3 ---
	return new_entry
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium._process_character_profile_convert = function (self, new_entry)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	local character_profile = new_entry.key_values.character_profile

	if character_profile then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 5-8, warpins: 1 ---
		local parsed_character_profile = self._parsed_character_profile

		if character_profile.value == nil or character_profile.value == "" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 12-14, warpins: 2 ---
			self._parsed_character_profile = nil
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 15-16, warpins: 1 ---
			if not parsed_character_profile or parsed_character_profile.hash ~= character_profile.hash then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 21-43, warpins: 2 ---
				parsed_character_profile = ProfileUtils.backend_profile_data_to_profile(ProfileUtils.process_backend_body(cjson.decode(character_profile.value)))
				parsed_character_profile.hash = character_profile.hash
				self._parsed_character_profile = parsed_character_profile

				Managers.event:trigger("event_player_profile_updated", nil, nil, parsed_character_profile)
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 44-45, warpins: 1 ---
		self._parsed_character_profile = nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 46-46, warpins: 4 ---
	return new_entry
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium._update_from_platform = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if self._has_done_platform_request ~= "steam" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-6, warpins: 1 ---
		if HAS_STEAM and self:platform() == "steam" and self:platform_user_id() then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 17-22, warpins: 1 ---
			Steam.request_user_name_async(self:platform_user_id())
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 23-24, warpins: 4 ---
		self._has_done_platform_request = "steam"
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 25-25, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium._convert_platform_user_id_for_immaterium = function (self, platform, platform_user_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if HAS_STEAM and platform == "steam" and platform_user_id then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 8-12, warpins: 1 ---
		return Steam.id_hex_to_dec(platform_user_id)
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 13-14, warpins: 3 ---
		if platform == "xbox" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 15-18, warpins: 1 ---
			return XboxLive.xuid_hex_to_dec(platform_user_id)
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 19-19, warpins: 3 ---
	return platform_user_id
	--- END OF BLOCK #1 ---



end

PresenceEntryImmaterium._key_value_string = function (self, key)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	return (self._immaterium_entry.key_values[key] and self._immaterium_entry.key_values[key].value) or nil
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 13-13, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

implements(PresenceEntryImmaterium, PresenceEntryInterface)

return PresenceEntryImmaterium
