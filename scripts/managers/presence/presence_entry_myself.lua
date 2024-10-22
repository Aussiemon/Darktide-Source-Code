-- chunkname: @scripts/managers/presence/presence_entry_myself.lua

local PresenceEntryInterface = require("scripts/managers/presence/presence_entry")
local PresenceSettings = require("scripts/settings/presence/presence_settings")
local Promise = require("scripts/foundation/utilities/promise")
local PresenceEntryMyself = class("PresenceEntryMyself")

PresenceEntryMyself.get_platform = function ()
	local platform
	local authenticate_method = Managers.backend:get_auth_method()

	if authenticate_method == Managers.backend.AUTH_METHOD_STEAM and HAS_STEAM then
		platform = "steam"
	elseif authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and PLATFORM == "win32" then
		platform = "xbox"
	elseif authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and Application.xbox_live and Application.xbox_live() == true then
		platform = "xbox"
	else
		Log.warning("PresenceEntryMyself", "Could not resolve a platform for authenticate_method: " .. tostring(authenticate_method))

		platform = "unknown"
	end

	return platform
end

PresenceEntryMyself.init = function (self)
	local platform = self.get_platform()

	self._platform = platform
	self._profile_version_counter = 1

	self:set_activity_id("splash_screen")
end

PresenceEntryMyself.reset = function (self)
	self._character_profile = nil
	self._party_id = nil
	self._num_party_members = nil
	self._num_mission_members = nil
	self._cross_play_disabled = nil
	self._cross_play_disabled_in_party = nil
	self._is_cross_playing = nil
	self._psn_session_id = nil
end

PresenceEntryMyself.account_id = function (self)
	return gRPC.get_account_id()
end

PresenceEntryMyself.account_name = function (self)
	return Managers.account:user_display_name()
end

PresenceEntryMyself.activity_id = function (self)
	return self._activity_id
end

PresenceEntryMyself.activity_localized = function (self)
	local hud_localization = PresenceSettings.settings[self:activity_id()].hud_localization

	return Managers.localization:localize(hud_localization)
end

PresenceEntryMyself.set_activity_id = function (self, activity_id)
	self._activity_id = activity_id
end

PresenceEntryMyself.character_id = function (self)
	return self:character_profile() and self:character_profile().character_id or ""
end

PresenceEntryMyself.character_name = function (self)
	return self:character_profile() and self:character_profile().name or ""
end

PresenceEntryMyself.character_profile = function (self)
	return self._character_profile
end

PresenceEntryMyself.account_and_platform_composite_id = function (self)
	return "myself"
end

PresenceEntryMyself.first_update_promise = function (self)
	return Promise.resolved(self)
end

PresenceEntryMyself.set_character_profile = function (self, character_profile)
	local profile_version_counter = self._profile_version_counter + 1

	self._profile_version_counter = profile_version_counter
	character_profile.hash = profile_version_counter
	self._character_profile = character_profile
end

PresenceEntryMyself.platform = function (self)
	return self._platform
end

PresenceEntryMyself.platform_icon = function (self)
	local platform = self._platform

	if platform == "steam" then
		return ""
	elseif platform == "xbox" then
		return ""
	elseif platform == "psn" then
		return "{#color(255,255,255)}{#reset()}", true
	end

	return nil
end

PresenceEntryMyself.platform_user_id = function (self)
	return Managers.account:platform_user_id()
end

PresenceEntryMyself.is_myself = function (self)
	return true
end

PresenceEntryMyself.is_online = function (self)
	return true
end

PresenceEntryMyself.platform_persona_name_or_account_name = function (self)
	return self:account_name()
end

PresenceEntryMyself.num_party_members = function (self)
	return tonumber(self._num_party_members) or 0
end

PresenceEntryMyself.set_num_party_members = function (self, num_party_members)
	self._num_party_members = tostring(num_party_members)
end

PresenceEntryMyself.num_mission_members = function (self)
	return tonumber(self._num_mission_members) or 0
end

PresenceEntryMyself.set_num_mission_members = function (self, num_mission_members)
	self._num_mission_members = tostring(num_mission_members)
end

PresenceEntryMyself.party_id = function (self)
	return self._party_id
end

PresenceEntryMyself.set_party_id = function (self, party_id)
	self._party_id = party_id
end

PresenceEntryMyself.cross_play_disabled = function (self)
	return self._cross_play_disabled == "true"
end

PresenceEntryMyself.set_cross_play_disabled = function (self, disabled)
	self._cross_play_disabled = disabled and "true" or "false"
end

PresenceEntryMyself.cross_play_disabled_in_party = function (self)
	return self._cross_play_disabled_in_party == "true"
end

PresenceEntryMyself.set_cross_play_disabled_in_party = function (self, disabled)
	self._cross_play_disabled_in_party = disabled and "true" or "false"
end

PresenceEntryMyself.is_cross_playing = function (self)
	return self._is_cross_playing == "true"
end

PresenceEntryMyself.set_is_cross_playing = function (self, value)
	self._is_cross_playing = value and "true" or "false"
end

PresenceEntryMyself.psn_session_id = function (self)
	local session_id = self._psn_session_id

	return session_id ~= "none" and session_id or nil
end

PresenceEntryMyself.set_psn_session_id = function (self, value)
	self._psn_session_id = value or "none"
end

PresenceEntryMyself.is_alive = function (self)
	return true
end

local key_values = {}

PresenceEntryMyself.create_key_values = function (self, white_list)
	table.clear(key_values)

	if (not white_list or white_list.character_profile) and self._character_profile then
		key_values.character_id = self._character_profile.character_id
	end

	if not white_list or white_list.activity_id then
		key_values.activity_id = self._activity_id
	end

	if not white_list or white_list.party_id then
		key_values.party_id = self._party_id
	end

	if not white_list or white_list.num_party_members then
		key_values.num_party_members = self._num_party_members
	end

	if not white_list or white_list.num_mission_members then
		key_values.num_mission_members = self._num_mission_members
	end

	if not white_list or white_list.cross_play_disabled then
		key_values.cross_play_disabled = self._cross_play_disabled
	end

	if not white_list or white_list.cross_play_disabled_in_party then
		key_values.cross_play_disabled_in_party = self._cross_play_disabled_in_party
	end

	if not white_list or white_list.is_cross_playing then
		key_values.is_cross_playing = self._is_cross_playing
	end

	if not white_list or white_list.psn_session_id then
		key_values.psn_session_id = self._psn_session_id
	end

	return key_values
end

implements(PresenceEntryMyself, PresenceEntryInterface)

return PresenceEntryMyself
