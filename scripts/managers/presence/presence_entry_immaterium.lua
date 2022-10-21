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
	if not self._immaterium_entry or self._immaterium_entry.last_update < new_entry.last_update then
		self._immaterium_entry = self:_process_platform_id_convert(new_entry)
		self._immaterium_entry = self:_process_character_profile_convert(new_entry)

		self:_update_from_platform()

		self._account_and_platform_composite_id = self:account_id() .. ":" .. self:platform() .. ":" .. self:platform_user_id()
	end
end

PresenceEntryImmaterium.is_myself = function (self)
	return false
end

PresenceEntryImmaterium.account_id = function (self)
	return self._immaterium_entry.account_id
end

PresenceEntryImmaterium.account_and_platform_composite_id = function (self)
	return self._account_and_platform_composite_id
end

PresenceEntryImmaterium.account_name = function (self)
	return self._immaterium_entry.account_name
end

PresenceEntryImmaterium.activity_id = function (self)
	return self:_key_value_string("activity_id") or "splash_screen"
end

PresenceEntryImmaterium.activity_localized = function (self)
	local hud_localization = PresenceSettings[self:activity_id()].hud_localization

	return Managers.localization:localize(hud_localization)
end

PresenceEntryImmaterium.character_id = function (self)
	return self:character_profile() and self:character_profile().character_id or ""
end

PresenceEntryImmaterium.character_name = function (self)
	return self:character_profile() and self:character_profile().name or ""
end

PresenceEntryImmaterium.character_profile = function (self)
	return self._parsed_character_profile
end

PresenceEntryImmaterium.platform = function (self)
	return self._immaterium_entry.platform
end

PresenceEntryImmaterium.platform_icon = function (self)
	local platform = self._immaterium_entry.platform
	local is_on_my_platform = self._my_own_platform == platform

	if is_on_my_platform then
		if platform == "steam" then
			return ""
		elseif platform == "xbox" then
			return ""
		end
	end

	return nil
end

PresenceEntryImmaterium.platform_user_id = function (self)
	return self._immaterium_entry.platform_user_id
end

PresenceEntryImmaterium.is_online = function (self)
	return self._immaterium_entry.status == "ONLINE"
end

PresenceEntryImmaterium.platform_persona_name_or_account_name = function (self)
	if HAS_STEAM and self:platform_user_id() and self:platform() == "steam" then
		return Steam.user_name(self:platform_user_id())
	end

	if self._immaterium_entry.account_name ~= "" then
		return self._immaterium_entry.account_name
	end

	return nil
end

PresenceEntryImmaterium.num_party_members = function (self)
	return tonumber(self:_key_value_string("num_party_members")) or 0
end

PresenceEntryImmaterium.num_mission_members = function (self)
	return tonumber(self:_key_value_string("num_mission_members")) or 0
end

PresenceEntryImmaterium.party_id = function (self)
	return self:_key_value_string("party_id")
end

PresenceEntryImmaterium.is_alive = function (self)
	if self._alive then
		self._alive_queried = true
	end

	return self._alive
end

PresenceEntryImmaterium.has_operation = function (self)
	return self._stream_operation_id ~= nil
end

PresenceEntryImmaterium.reset_alive_queried = function (self)
	local alive_queried = self._alive_queried
	self._alive_queried = false

	return alive_queried
end

PresenceEntryImmaterium._log_id = function (self)
	if self._account_id then
		return "[" .. self._account_id .. "]"
	else
		return "[" .. self._platform .. ":" .. self._platform_user_id .. "]"
	end
end

PresenceEntryImmaterium._info = function (self, message)
	Log.info("PresenceEntryImmaterium" .. self:_log_id(), message)
end

PresenceEntryImmaterium._error = function (self, message)
	Log.info("PresenceEntryImmaterium" .. self:_log_id(), message)
end

PresenceEntryImmaterium._process_platform_id_convert = function (self, new_entry)
	if HAS_STEAM and new_entry.platform == "steam" then
		new_entry.platform_user_id = Steam.id_dec_to_hex(new_entry.platform_user_id)
	elseif new_entry.platform == "xbox" then
		new_entry.platform_user_id = XboxLive.xuid_dec_to_hex(new_entry.platform_user_id)
	end

	return new_entry
end

PresenceEntryImmaterium._process_character_profile_convert = function (self, new_entry)
	local character_profile = new_entry.key_values.character_profile

	if character_profile then
		local parsed_character_profile = self._parsed_character_profile

		if character_profile.value == nil or character_profile.value == "" then
			self._parsed_character_profile = nil
		elseif not parsed_character_profile or parsed_character_profile.hash ~= character_profile.hash then
			parsed_character_profile = ProfileUtils.backend_profile_data_to_profile(ProfileUtils.process_backend_body(cjson.decode(character_profile.value)))
			parsed_character_profile.hash = character_profile.hash
			self._parsed_character_profile = parsed_character_profile

			Managers.event:trigger("event_player_profile_updated", nil, nil, parsed_character_profile)
		end
	else
		self._parsed_character_profile = nil
	end

	return new_entry
end

PresenceEntryImmaterium._update_from_platform = function (self)
	if self._has_done_platform_request ~= "steam" then
		if HAS_STEAM and self:platform() == "steam" and self:platform_user_id() then
			Steam.request_user_name_async(self:platform_user_id())
		end

		self._has_done_platform_request = "steam"
	end
end

PresenceEntryImmaterium._convert_platform_user_id_for_immaterium = function (self, platform, platform_user_id)
	if HAS_STEAM and platform == "steam" and platform_user_id then
		return Steam.id_hex_to_dec(platform_user_id)
	elseif platform == "xbox" then
		return XboxLive.xuid_hex_to_dec(platform_user_id)
	end

	return platform_user_id
end

PresenceEntryImmaterium._key_value_string = function (self, key)
	return self._immaterium_entry.key_values[key] and self._immaterium_entry.key_values[key].value or nil
end

implements(PresenceEntryImmaterium, PresenceEntryInterface)

return PresenceEntryImmaterium
