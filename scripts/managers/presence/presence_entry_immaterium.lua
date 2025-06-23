-- chunkname: @scripts/managers/presence/presence_entry_immaterium.lua

local PresenceEntryInterface = require("scripts/managers/presence/presence_entry")
local PresenceSettings = require("scripts/settings/presence/presence_settings")
local Promise = require("scripts/foundation/utilities/promise")
local ProfileUtils = require("scripts/utilities/profile_utils")
local PresenceEntryImmaterium = class("PresenceEntryImmaterium")

PresenceEntryImmaterium.init = function (self, my_own_platform, platform, platform_user_id)
	self._my_own_platform = my_own_platform

	local immaterium_entry = {
		account_name = "",
		platform = "",
		platform_user_id = "",
		status = "OFFLINE",
		last_update = -1,
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

	self._immaterium_entry = immaterium_entry
	self._alive_queried = true
	self._alive = true
	self._stream_first_update_promises = {}
	self._parsed_character_profile = nil
	self._started = false
	self._request_platform = nil
	self._request_id = nil
end

PresenceEntryImmaterium.destroy = function (self)
	Managers.presence:_abort_batched_presence(self)

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
	if self._started and not Managers.account:user_detached() then
		local new_immaterium_entry = Managers.presence:_get_batched_presence(self, self._request_platform, self._request_platform_user_id)

		if new_immaterium_entry then
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
	if self._account_id then
		self._request_platform = ""
		self._request_platform_user_id = self._account_id
	else
		self._request_platform = self._platform
		self._request_platform_user_id = self:_convert_platform_user_id_for_immaterium(self._platform, self._platform_user_id)
	end

	self._started = true
end

PresenceEntryImmaterium.update_with = function (self, new_entry)
	if not self._immaterium_entry or new_entry.last_update > self._immaterium_entry.last_update then
		self._immaterium_entry = self:_process_platform_id_convert(new_entry)
		self._immaterium_entry = self:_process_character_profile_convert(new_entry)

		self:_update_from_platform()

		local account_id = self:account_id()

		self._account_and_platform_composite_id = account_id .. ":" .. self:platform() .. ":" .. self:platform_user_id()

		if account_id ~= "" then
			local social_service = Managers.data_service.social

			if social_service then
				local player_info = social_service:get_player_info_by_account_id(account_id)

				if player_info then
					player_info:set_platform(self:platform())
					player_info:set_platform_user_id(self:platform_user_id())
				end
			end
		end

		Managers.event:trigger("event_new_immaterium_entry", new_entry)
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
	local hud_localization = PresenceSettings.settings[self:activity_id()].hud_localization

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

PresenceEntryImmaterium.platform_icon = function (self, in_platform)
	local platform = self._immaterium_entry.platform

	platform = platform ~= "" and platform or in_platform or ""

	local is_on_my_platform = self._my_own_platform == platform

	if is_on_my_platform then
		if platform == "steam" then
			return ""
		elseif platform == "xbox" then
			return ""
		elseif platform == "psn" then
			return "{#color(255,255,255)}{#reset()}", true
		end
	else
		return ""
	end
end

PresenceEntryImmaterium.platform_user_id = function (self)
	return self._immaterium_entry.platform_user_id
end

PresenceEntryImmaterium.is_online = function (self)
	return self._immaterium_entry.status == "ONLINE"
end

PresenceEntryImmaterium.platform_persona_name_or_account_name = function (self, in_platform, in_platform_id)
	local user_has_restrictions = Managers.account:user_has_restriction()
	local my_own_platform = self._my_own_platform
	local platform = self:platform()

	platform = platform ~= "" and platform or in_platform or ""

	if user_has_restrictions and platform ~= my_own_platform then
		return Localize("loc_cross_network_player")
	end

	local platform_user_id = self:platform_user_id()

	platform_user_id = platform_user_id ~= "" and platform_user_id or in_platform_id or ""

	if platform and platform_user_id then
		local platform_username = Managers.presence:get_requested_platform_username(platform, platform_user_id)

		if platform_username then
			return platform_username
		end
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

PresenceEntryImmaterium.cross_play_disabled = function (self)
	return self:_key_value_string("cross_play_disabled") == "true"
end

PresenceEntryImmaterium.cross_play_disabled_in_party = function (self)
	return self:_key_value_string("cross_play_disabled_in_party") == "true"
end

PresenceEntryImmaterium.is_cross_playing = function (self)
	return self:_key_value_string("is_cross_playing") == "true"
end

PresenceEntryImmaterium.psn_session_id = function (self)
	local session_id = self:_key_value_string("psn_session_id")

	return session_id ~= "none" and session_id or nil
end

PresenceEntryImmaterium.havoc_status = function (self)
	return self:_key_value_string("havoc_status") or "none"
end

PresenceEntryImmaterium.havoc_rank_cadence_high = function (self)
	local rank = self:_key_value_string("havoc_rank_cadence_high")

	return rank ~= "none" and tonumber(rank) or nil
end

PresenceEntryImmaterium.havoc_rank_all_time_high = function (self)
	local rank = self:_key_value_string("havoc_rank_all_time_high")

	return rank ~= "none" and tonumber(rank) or nil
end

PresenceEntryImmaterium.is_alive = function (self)
	if self._alive then
		self._alive_queried = true
	end

	return self._alive
end

PresenceEntryImmaterium.reset_alive_queried = function (self)
	local alive_queried = self._alive_queried

	self._alive_queried = false

	return alive_queried
end

PresenceEntryImmaterium._process_platform_id_convert = function (self, new_entry)
	if new_entry.platform == "steam" or new_entry.platform == "xbox" then
		new_entry.platform_user_id = Application.dec64_to_hex(new_entry.platform_user_id)
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

			if parsed_character_profile then
				parsed_character_profile.hash = character_profile.hash

				local user_has_restrictions = Managers.account:user_has_restriction()

				if user_has_restrictions then
					parsed_character_profile.name = Localize(parsed_character_profile.archetype.archetype_name)
				end

				self._parsed_character_profile = parsed_character_profile

				Managers.event:trigger("event_player_profile_updated", nil, nil, parsed_character_profile)
			end
		end
	else
		self._parsed_character_profile = nil
	end

	return new_entry
end

PresenceEntryImmaterium._update_from_platform = function (self)
	local platform = self:platform()
	local platform_user_id = self:platform_user_id()

	if platform ~= "" and platform_user_id ~= "" then
		Managers.presence:request_platform_username_async(platform, platform_user_id)
	end
end

PresenceEntryImmaterium._convert_platform_user_id_for_immaterium = function (self, platform, platform_user_id)
	if (platform == "steam" or platform == "xbox") and platform_user_id then
		return Application.hex64_to_dec(platform_user_id)
	end

	return platform_user_id
end

PresenceEntryImmaterium._key_value_string = function (self, key)
	return self._immaterium_entry.key_values[key] and self._immaterium_entry.key_values[key].value or nil
end

implements(PresenceEntryImmaterium, PresenceEntryInterface)

return PresenceEntryImmaterium
