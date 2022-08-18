local PartyImmateriumLocalizedErrorCodes = {}
local error_codes = table.enum("BLOCKED_INVITE", "BLOCKED_JOIN_REQUEST", "XBOX_BLOCKED_JOIN_REQUEST", "XBOX_BLOCKED_INVITE", "STEAM_BLOCKED_JOIN_REQUEST", "STEAM_BLOCKED_INVITE", "MEMBER_DECLINED_REQUEST_TO_JOIN", "REQUEST_TO_JOIN_TIMEOUT", "YOU_HAVE_PLATFORM_NOT_ALLOWED", "THEY_HAVE_PLATFORM_NOT_ALLOWED", "YOU_HAVE_ACCOUNT_ID_ON_AVOID_LIST", "THEY_HAVE_ACCOUNT_ID_ON_AVOID_LIST", "YOU_HAVE_PLATFORM_USER_ID_ON_AVOID_LIST", "THEY_HAVE_PLATFORM_USER_ID_ON_AVOID_LIST", "CROSS_PLAY_DISABLED", "CROSS_PLAY_DISABLED_JOIN_REQUEST", "PARTY_FULL", "UNKNOWN")
PartyImmateriumLocalizedErrorCodes.error_codes = error_codes
local loc_keys = {
	[error_codes.YOU_HAVE_PLATFORM_NOT_ALLOWED] = {
		join = "loc_hot_join_you_are_cross_play_blocking"
	},
	[error_codes.THEY_HAVE_PLATFORM_NOT_ALLOWED] = {
		join = "loc_hot_join_they_are_cross_play_blocking"
	},
	[error_codes.YOU_HAVE_ACCOUNT_ID_ON_AVOID_LIST] = {
		join = "loc_hot_join_you_are_blocking"
	},
	[error_codes.THEY_HAVE_ACCOUNT_ID_ON_AVOID_LIST] = {
		join = "loc_hot_join_they_are_blocking"
	},
	[error_codes.YOU_HAVE_PLATFORM_USER_ID_ON_AVOID_LIST] = {
		join = "loc_hot_join_you_are_blocking"
	},
	[error_codes.THEY_HAVE_PLATFORM_USER_ID_ON_AVOID_LIST] = {
		join = "loc_hot_join_they_are_blocking"
	},
	[error_codes.XBOX_BLOCKED_INVITE] = {
		invite = "loc_party_invite_your_party_is_blocked"
	},
	[error_codes.XBOX_BLOCKED_JOIN_REQUEST] = {
		invite = "loc_party_invite_your_party_is_blocking",
		join = "loc_party_join_you_are_blocked"
	},
	[error_codes.CROSS_PLAY_DISABLED] = {
		invite = "loc_party_invite_you_have_crossplay_disabled",
		join = "loc_party_join_you_have_crossplay_disabled"
	},
	[error_codes.CROSS_PLAY_DISABLED_JOIN_REQUEST] = {
		invite = "loc_party_invite_they_have_crossplay_disabled",
		join = "loc_party_join_they_have_crossplay_disabled"
	},
	[error_codes.STEAM_BLOCKED_INVITE] = {
		invite = "loc_party_invite_your_party_is_blocked"
	},
	[error_codes.STEAM_BLOCKED_JOIN_REQUEST] = {
		invite = "loc_party_invite_your_party_is_blocking",
		join = "loc_party_join_you_are_blocked"
	},
	[error_codes.MEMBER_DECLINED_REQUEST_TO_JOIN] = {
		join = "loc_party_request_to_join_member_declined_error"
	},
	[error_codes.REQUEST_TO_JOIN_TIMEOUT] = {
		join = "loc_party_request_to_join_member_declined_error"
	},
	[error_codes.PARTY_FULL] = {
		invite = "loc_party_invite_party_full",
		join = "loc_party_join_party_full"
	},
	[error_codes.PARTY_FULL] = {
		invite = "loc_party_invite_party_full",
		join = "loc_party_join_party_full"
	},
	[error_codes.BLOCKED_INVITE] = {
		invite = "loc_party_invite_your_party_is_blocked"
	},
	[error_codes.BLOCKED_JOIN_REQUEST] = {
		invite = "loc_party_invite_your_party_is_blocking",
		join = "loc_party_join_you_are_blocked"
	},
	[error_codes.UNKNOWN] = {
		invite = "loc_party_invite_unknown_error",
		join = "loc_party_join_unknown_error"
	}
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
