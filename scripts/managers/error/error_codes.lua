local ErrorCodesLookup = {
	kicked_on_session_report_fail = {
		code = 1001
	},
	kicked_on_session_report_timeout = {
		code = 1002
	},
	session_completed = {
		code = 1003
	},
	game_request = {
		code = 1004
	},
	timeout = {
		code = 1005
	},
	eac_local_ban = {
		code = 1006
	},
	eac_remote_ban = {
		code = 1007
	},
	eac_remote_untrusted = {
		code = 1008
	},
	eac_local_untrusted = {
		code = 1009
	},
	eac_remote_denied = {
		code = 1010
	},
	mechanism_mismatched = {
		code = 1011
	},
	slot_rejected = {
		code = 1012
	},
	slot_reserve_rejected = {
		code = 1013
	},
	afk = {
		description = "loc_popup_description_afk_kicked",
		code = 1014,
		level = "error"
	},
	vote_kick = {
		description = "loc_disconnect_by_kick",
		code = 1015,
		title = false
	},
	nonexisting_channel = {
		code = 2001
	},
	game = {
		code = 2002
	},
	lost_connection = {
		code = 2003
	},
	buffer_overflow = {
		code = 2004
	},
	remote_broken = {
		code = 2005
	},
	remote_disconnected = {
		code = 2006
	},
	internal_error = {
		code = 2007
	},
	by_destruction = {
		code = 2008
	},
	denied_access = {
		code = 2009
	},
	full = {
		code = 2010
	},
	version_mismatch = {
		code = 2011
	},
	authentication_denied = {
		code = 2012
	},
	unresponsive = {
		code = 2013
	},
	pong_timeout = {
		code = 2014
	},
	failed_joining_lobby = {
		code = 3001
	},
	failed_creating_lobby = {
		code = 3002
	},
	no_available_hub_servers = {
		code = 3003
	},
	no_available_mission_servers = {
		code = 3004
	},
	failed_fetching_mission_data = {
		code = 3005
	},
	disconnected_from_host = {
		code = 3006
	},
	failed_start_mission_voting = {
		code = 3007
	},
	mission_voting_aborted = {
		code = 3008
	},
	mission_voting_rejected = {
		code = 3009
	},
	must_be_party_host = {
		code = 3010
	},
	failed_joining_lobby_no_host_peer = {
		code = 3011
	},
	mission_not_found = {
		description = "loc_popup_description_missing_mission",
		code = 3012,
		title = "loc_popup_header_missing_mission",
		level = "warning_popup"
	},
	failed_found_no_lobby = {
		code = 3013
	},
	hot_join_party_hub_failed = {
		code = 4001
	},
	found_no_lobby = {
		code = 4002
	},
	failed_to_join_hub_server = {
		code = 4003
	},
	failed_to_join_mission_server = {
		code = 4004
	},
	empty_ticket = {
		code = 4005
	},
	failed_fetching_server_details = {
		code = 4006
	},
	server_mismatch = {
		code = 4007
	},
	failed_handshake_timeout = {
		code = 4008
	},
	failed_mission_not_healthy = {
		code = 5001
	},
	failed_no_instances_available = {
		code = 5002
	},
	failed_character_too_low_level = {
		code = 5003
	},
	unknown_error = {
		code = 9999
	}
}

local function echo(...)
	return ...
end

local ErrorCodes = {
	_config_from_error_string = function (error_string)
		local error_string_lower = string.lower(error_string)
		local error_config = ErrorCodesLookup[error_string_lower]
		error_config = error_config or ErrorCodesLookup.unknown_error

		return error_config
	end
}

ErrorCodes.get_error_code_string_from_reason = function (error_string)
	local error_config = ErrorCodes._config_from_error_string(error_string)
	local error_code = error_config.code

	return Localize("loc_error_code_with_line_break", true, {
		error_code = error_code
	})
end

ErrorCodes.get_error_code_description_from_reason = function (error_string, localized)
	local error_config = ErrorCodes._config_from_error_string(error_string)
	local loc_function = localized and Localize or echo

	if error_config.description ~= nil then
		return true, loc_function(error_config.description), error_config.format
	end

	return false
end

ErrorCodes.get_error_code_title_from_reason = function (error_string, localized)
	local error_config = ErrorCodes._config_from_error_string(error_string)
	local loc_function = localized and Localize or echo

	if error_config.title ~= nil then
		return true, loc_function(error_config.title)
	end

	return false
end

ErrorCodes.get_error_code_level_from_reason = function (error_string)
	local error_config = ErrorCodes._config_from_error_string(error_string)

	return error_config.error_level or "warning"
end

ErrorCodes.apply_backend_game_settings = function ()
	local error_codes = GameParameters.error_codes_crashifyreport

	if error_codes and type(error_codes) == "string" and error_codes ~= "" then
		local codes_array = string.split(error_codes, ",")

		for _, code in ipairs(codes_array) do
			local err = ErrorCodesLookup[code]

			if err then
				err.report_to_crashify = true

				Log.info("ErrorCodes", "Crashify exception enabled from backend for error_code: %q", code)
			end
		end
	end
end

ErrorCodes.should_report_to_crashify = function (error_string)
	local error_config = ErrorCodes._config_from_error_string(error_string)
	local report_to_crashify = not not error_config.report_to_crashify

	return report_to_crashify
end

ErrorCodes.should_leave_party = function (error_string)
	local error_config = ErrorCodes._config_from_error_string(error_string)
	local leave_party = not not error_config.leave_party

	return leave_party
end

return ErrorCodes
