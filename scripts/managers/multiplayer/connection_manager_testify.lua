-- chunkname: @scripts/managers/multiplayer/connection_manager_testify.lua

local function _is_host(connection_manager)
	return connection_manager:is_host()
end

local ConnectionManagerTestify = {
	is_host = function (connection_manager)
		return _is_host(connection_manager)
	end,
	register_testify_connection_events = function (connection_manager)
		local event_delegate = connection_manager:network_event_delegate()

		if _is_host(connection_manager) then
			event_delegate:register_connection_events(Testify, unpack(Testify:server_rpcs()))
		else
			event_delegate:register_connection_events(Testify, unpack(Testify:client_rpcs()))
		end

		Testify:set_rpcs_registered_value(true)
	end,
	unregister_testify_connection_events = function (connection_manager)
		if not Testify:are_rpcs_registered() then
			return
		end

		local event_delegate = connection_manager:network_event_delegate()

		if _is_host(connection_manager) then
			event_delegate:unregister_events(unpack(Testify:server_rpcs()))
		else
			event_delegate:unregister_events(unpack(Testify:client_rpcs()))
		end

		Testify:set_rpcs_registered_value(false)
	end,
}

return ConnectionManagerTestify
