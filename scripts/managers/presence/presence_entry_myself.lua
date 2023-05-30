local PresenceEntryInterface = require("scripts/managers/presence/presence_entry")
local PresenceSettings = require("scripts/settings/presence/presence_settings")
local Promise = require("scripts/foundation/utilities/promise")
local PresenceEntryMyself = class("PresenceEntryMyself")

PresenceEntryMyself.get_platform = function ()
	local platform = nil
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

PresenceEntryMyself.account_id = function (self)
	return gRPC.get_account_id()
end

PresenceEntryMyself.account_name = function (self)
	if IS_XBS or IS_GDK then
		return Managers.account:gamertag()
	else
		return Localize("loc_immaterium_placeholder_account_name")
	end
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
	end

	return nil
end

PresenceEntryMyself.platform_user_id = function (self)
	local platform = self._platform

	if platform == "xbox" then
		return Managers.account:xuid()
	elseif platform == "steam" then
		return Steam.user_id()
	end
end

PresenceEntryMyself.is_myself = function (self)
	return true
end

PresenceEntryMyself.is_online = function (self)
	return true
end

PresenceEntryMyself.platform_persona_name_or_account_name = function (self)
	if HAS_STEAM and self:platform() == "steam" then
		return Steam.user_name()
	end

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

	return key_values
end

implements(PresenceEntryMyself, PresenceEntryInterface)

return PresenceEntryMyself
