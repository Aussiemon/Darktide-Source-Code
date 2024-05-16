-- chunkname: @scripts/managers/party_immaterium/party_immaterium_localized_error_codes.lua

local PartyImmateriumLocalizedErrorCodes = {}
local error_codes = table.enum("BLOCKED_INVITE", "BLOCKED_JOIN_REQUEST", "XBOX_BLOCKED_JOIN_REQUEST", "XBOX_BLOCKED_INVITE", "STEAM_BLOCKED_JOIN_REQUEST", "STEAM_BLOCKED_INVITE", "MEMBER_DECLINED_REQUEST_TO_JOIN", "REQUEST_TO_JOIN_TIMEOUT", "YOU_HAVE_PLATFORM_NOT_ALLOWED", "THEY_HAVE_PLATFORM_NOT_ALLOWED", "YOU_HAVE_ACCOUNT_ID_ON_AVOID_LIST", "THEY_HAVE_ACCOUNT_ID_ON_AVOID_LIST", "YOU_HAVE_PLATFORM_USER_ID_ON_AVOID_LIST", "THEY_HAVE_PLATFORM_USER_ID_ON_AVOID_LIST", "CROSS_PLAY_DISABLED", "CROSS_PLAY_DISABLED_JOIN_REQUEST", "COMMUNICATION_BLOCKED_JOIN_REQUEST", "PARTY_FULL", "JOIN_REQUEST_RATE_LIMIT", "YOU_ARE_IN_MISSION", "YOU_ARE_IN_MATCHMAKING", "YOU_ARE_IN_ONBOARDING", "YOU_ARE_IN_SPLASH_SCREEN", "YOU_ARE_IN_TITLE_SCREEN", "YOU_ARE_IN_LOADING", "YOU_ARE_IN_CINEMATIC", "PERMISSION_CHECK_FAILED", "IS_IN_SINGLE_PLAYER_GAME", "INVITE_DOES_NOT_EXIST", "INVALID_INVITE_CODE", "PARTY_NOT_CLIENT_COMPATIBLE_WITH_YOU", "PRIVATE_SESSION_NOT_FRIEND", "NOT_JOINABLE", "CROSS_PLAY_DISABLED_GLOBALLY", "FAILED_KICKED_FROM_GAME_SESSION", "UNKNOWN")

PartyImmateriumLocalizedErrorCodes.error_codes = error_codes

local loc_keys = {
	[error_codes.YOU_HAVE_PLATFORM_NOT_ALLOWED] = {
		join = "loc_hot_join_you_are_cross_play_blocking",
	},
	[error_codes.THEY_HAVE_PLATFORM_NOT_ALLOWED] = {
		join = "loc_hot_join_they_are_cross_play_blocking",
	},
	[error_codes.YOU_HAVE_ACCOUNT_ID_ON_AVOID_LIST] = {
		join = "loc_hot_join_you_are_blocking",
	},
	[error_codes.THEY_HAVE_ACCOUNT_ID_ON_AVOID_LIST] = {
		join = "loc_hot_join_they_are_blocking",
	},
	[error_codes.YOU_HAVE_PLATFORM_USER_ID_ON_AVOID_LIST] = {
		join = "loc_hot_join_you_are_blocking",
	},
	[error_codes.THEY_HAVE_PLATFORM_USER_ID_ON_AVOID_LIST] = {
		join = "loc_hot_join_they_are_blocking",
	},
	[error_codes.XBOX_BLOCKED_INVITE] = {
		invite = "loc_party_invite_your_party_is_blocked",
	},
	[error_codes.XBOX_BLOCKED_JOIN_REQUEST] = {
		invite = "loc_party_invite_your_party_is_blocking",
		join = "loc_party_join_you_are_blocked",
	},
	[error_codes.CROSS_PLAY_DISABLED] = {
		invite = "loc_party_invite_you_have_crossplay_disabled",
		join = "loc_party_join_you_have_crossplay_disabled",
	},
	[error_codes.CROSS_PLAY_DISABLED_JOIN_REQUEST] = {
		invite = "loc_party_invite_they_have_crossplay_disabled",
		join = "loc_party_join_they_have_crossplay_disabled",
	},
	[error_codes.COMMUNICATION_BLOCKED_JOIN_REQUEST] = {
		join = "loc_party_join_communication_blocked",
	},
	[error_codes.STEAM_BLOCKED_INVITE] = {
		invite = "loc_party_invite_your_party_is_blocked",
	},
	[error_codes.STEAM_BLOCKED_JOIN_REQUEST] = {
		invite = "loc_party_invite_your_party_is_blocking",
		join = "loc_party_join_you_are_blocked",
	},
	[error_codes.MEMBER_DECLINED_REQUEST_TO_JOIN] = {
		join = "loc_party_request_to_join_member_declined_error",
	},
	[error_codes.REQUEST_TO_JOIN_TIMEOUT] = {
		join = "loc_party_request_to_join_member_declined_error",
	},
	[error_codes.PARTY_FULL] = {
		invite = "loc_party_invite_party_full",
		join = "loc_party_join_party_full",
	},
	[error_codes.INVITE_DOES_NOT_EXIST] = {
		join = "loc_party_invite_has_expired",
	},
	[error_codes.BLOCKED_INVITE] = {
		invite = "loc_party_invite_your_party_is_blocked",
	},
	[error_codes.BLOCKED_JOIN_REQUEST] = {
		invite = "loc_party_invite_your_party_is_blocking",
		join = "loc_party_join_you_are_blocked",
	},
	[error_codes.JOIN_REQUEST_RATE_LIMIT] = {
		join = "loc_party_join_you_are_rate_limited",
	},
	[error_codes.YOU_ARE_IN_MISSION] = {
		join = "loc_party_join_you_are_in_mission",
	},
	[error_codes.YOU_ARE_IN_MATCHMAKING] = {
		join = "loc_party_join_you_are_in_matchmaking",
	},
	[error_codes.YOU_ARE_IN_ONBOARDING] = {
		join = "loc_party_join_you_are_in_onboarding",
	},
	[error_codes.YOU_ARE_IN_SPLASH_SCREEN] = {
		join = "loc_party_join_you_are_in_loading",
	},
	[error_codes.YOU_ARE_IN_TITLE_SCREEN] = {
		join = "loc_party_join_you_are_in_loading",
	},
	[error_codes.YOU_ARE_IN_LOADING] = {
		join = "loc_party_join_you_are_in_loading",
	},
	[error_codes.YOU_ARE_IN_CINEMATIC] = {
		join = "loc_party_join_you_are_in_cinematic",
	},
	[error_codes.UNKNOWN] = {
		invite = "loc_party_invite_unknown_error",
		join = "loc_party_join_unknown_error",
	},
	[error_codes.PERMISSION_CHECK_FAILED] = {
		invite = "loc_party_invite_unknown_error",
		join = "loc_party_request_to_join_member_declined_error",
	},
	[error_codes.PARTY_NOT_CLIENT_COMPATIBLE_WITH_YOU] = {
		join = "loc_party_join_not_compatible_with_you_error",
	},
	[error_codes.PRIVATE_SESSION_NOT_FRIEND] = {
		join = "loc_party_join_private_session_not_friend",
	},
	[error_codes.CROSS_PLAY_DISABLED_GLOBALLY] = {
		invite = "loc_cross_play_disabled_globally",
		join = "loc_cross_play_disabled_globally",
	},
	[error_codes.FAILED_KICKED_FROM_GAME_SESSION] = {
		join = "loc_kicked_from_game_session",
	},
}

PartyImmateriumLocalizedErrorCodes.loc_invite_error = function (error_code)
	local loc = loc_keys[error_code]

	if not loc or not loc.invite then
		Log.warning("PartyImmateriumLocalizedErrorCodes", "got error_code %s that is not localized", error_code)

		loc = loc_keys[error_codes.UNKNOWN]
	end

	return Localize(loc.invite)
end

PartyImmateriumLocalizedErrorCodes.loc_join_error = function (error_code)
	local loc = loc_keys[error_code]

	if not loc or not loc.join then
		Log.warning("PartyImmateriumLocalizedErrorCodes", "got error_code %s that is not localized", error_code)

		loc = loc_keys[error_codes.UNKNOWN]
	end

	return Localize(loc.join)
end

return PartyImmateriumLocalizedErrorCodes
