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
	unknown_error = {
		code = 9999
	}
}
local ErrorCodes = {
	get_error_code_string_from_reason = function (error_string)
		local error_string_lower = string.lower(error_string)
		local error_data = ErrorCodesLookup[error_string_lower]
		error_data = error_data or ErrorCodesLookup.unknown_error
		local error_code = error_data.code
		local error_code_string = Localize("loc_error_code_with_line_break", nil, {
			error_code = error_code
		})

		return error_code_string
	end
}

return ErrorCodes
