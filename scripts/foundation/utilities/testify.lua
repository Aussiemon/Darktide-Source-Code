-- chunkname: @scripts/foundation/utilities/testify.lua

local TestifyExpect = require("scripts/tests/testify_expect")
local SIGNALS = {
	current_request = "current_request",
	request = "request",
	reply = "reply",
	ready = "ready",
	end_suite = "end_suite"
}
local SERVER_RPCS = {
	"rpc_testify_wait_for_response"
}
local CLIENT_RPCS = {
	"rpc_testify_make_request"
}

Testify = {
	_are_rpcs_registered = false,
	_requests = {},
	_responses = {},
	_peers = {},
	_cache = {},
	RETRY = newproxy(false),
	expect = TestifyExpect:new()
}

local __raw_print = print
local cjson_decode = cjson.decode
local cjson_encode = cjson.encode
local coroutine_resume = coroutine.resume
local coroutine_yield = coroutine.yield
local string_format = string.format
local table_dump = table.dump
local table_keys = table.keys
local table_merge_varargs = table.merge_varargs
local table_pack = table.pack
local table_size = table.size
local tostring = tostring
local unpack = unpack

Testify.init = function (self)
	self._requests = {}
	self._responses = {}
end

Testify.ready = function (self)
	Log.info("Testify", "Ready!")
	self:_signal(SIGNALS.ready)
end

Testify.ready_signal_received = function (self)
	self._ready_signal_received = true
end

Testify.reply = function (self, message)
	self:_signal(SIGNALS.reply, message)
end

Testify.run_case = function (self, test_case)
	self:init()

	self._test_case = coroutine.create(test_case)
end

Testify.update = function (self, dt, t)
	if GameParameters.testify and not self._ready_signal_received then
		self:_signal(SIGNALS.ready, nil, false)
	end

	if GameParameters.testify_time_scale and not self._time_scaled then
		self:_set_time_scale()
	end

	if self._test_case then
		self.expect:update()

		local success, result, end_suite = coroutine_resume(self._test_case, dt, t)

		if not success then
			ferror(debug.traceback(self._test_case, result))
		elseif coroutine.status(self._test_case) == "dead" then
			self._test_case = nil

			if end_suite == true then
				self:_signal(SIGNALS.end_suite)
			end

			self:_signal(SIGNALS.reply, result)
		end
	end
end

Testify.make_request = function (self, request_name, ...)
	local request_parameters, num_parameters = table_pack(...)

	request_parameters.length = num_parameters

	self:_print("Requesting %s", request_name)

	self._requests[request_name] = request_parameters
	self._responses[request_name] = nil

	return self:_wait_for_response(request_name)
end

Testify.make_request_to_runner = function (self, request_name, ...)
	local request_parameters = table_pack(...)

	self:_print("Requesting %s to the Testify Runner", request_name)

	self._requests[request_name] = request_parameters
	self._responses[request_name] = nil

	local request = {
		name = request_name,
		parameters = request_parameters
	}

	self:_signal(SIGNALS.request, cjson_encode(request))

	return self:_wait_for_response(request_name)
end

Testify._wait_for_response = function (self, request_name)
	self:_print("Waiting for response %s", request_name)

	while true do
		coroutine_yield()

		local response = self._responses[request_name]

		if response then
			local response_length = response.length

			return unpack(response, 1, response_length)
		end
	end
end

Testify.poll_requests_through_handler = function (self, callback_table, ...)
	local RETRY = Testify.RETRY

	for request, callback in pairs(callback_table) do
		local request_args, num_request_args = self:poll_request(request)

		if request_args then
			local poll_args, num_poll_args = table_pack(...)
			local merged_args, num_merged_args = table_merge_varargs(poll_args, num_poll_args, unpack(request_args))
			local responses, num_responses = table_pack(callback(unpack(merged_args, 1, num_merged_args)))

			if responses[1] ~= RETRY then
				self:respond_to_request(request, responses, num_responses)
			end

			return
		end
	end
end

Testify.poll_request = function (self, request_name)
	local request_arguments = self._requests[request_name]

	if request_arguments then
		local num_request_arguments = request_arguments.length

		return request_arguments, num_request_arguments
	end
end

Testify.respond_to_request = function (self, request_name, responses, num_responses)
	responses.length = num_responses

	self:_print("Responding to %s", request_name)

	self._requests[request_name] = nil
	self._responses[request_name] = responses
end

Testify.respond_to_runner_request = function (self, request_name, responses, num_responses)
	self:respond_to_request(request_name, {
		responses
	}, num_responses)
end

Testify.store_cache = function (self, key, value)
	self._cache[key] = value
end

Testify.retrieve_cache = function (self, key, value)
	return self._cache[key]
end

Testify.print_test_case_marker = function (self)
	__raw_print("<<testify>>test case<</testify>>")
end

Testify.inspect = function (self)
	self:_print("Test case running? %s", self._thread ~= nil)
	table_dump(self._requests, "[Testify] Requests", 2)
	table_dump(self._responses, "[Testify] Responses", 2)
end

Testify._set_time_scale = function (self)
	local time_manager = Managers.time

	if not time_manager or not time_manager._timers.gameplay then
		return
	end

	local scale = GameParameters.testify_time_scale

	time_manager:set_local_scale("gameplay", tonumber(scale))
end

Testify._signal = function (self, signal, message, print_signal)
	if print_signal ~= false then
		self:_print("Replying to signal %s %s", signal, message)
	end

	if Application.console_send == nil then
		return
	end

	Application.console_send({
		system = "Testify",
		type = "signal",
		signal = signal,
		message = tostring(message)
	})
end

Testify._print = function (self, ...)
	if GameParameters.debug_testify then
		Log.info("Testify", "%s", string_format(...))
	end
end

Testify.print = function (self, ...)
	self:_print(...)
end

Testify.current_request_name = function (self)
	local requests = self._requests
	local request_name, _ = next(requests)

	self:_print("Current request name: %s", request_name)
	self:_signal(SIGNALS.current_request, request_name)
end

Testify.make_request_on_client = function (self, peer_id, request_name, wait_for_response, ...)
	wait_for_response = wait_for_response == true or false

	local request_parameters, num_parameters = table_pack(...)

	self:_print("Requesting %s on peer %s", request_name, peer_id)

	self._responses[request_name] = nil
	request_parameters = cjson_encode(request_parameters)

	local channel_id = self._peers[peer_id]

	if not channel_id then
		-- Nothing
	end

	RPC.rpc_testify_make_request(channel_id, peer_id, request_name, wait_for_response, request_parameters, num_parameters)

	if wait_for_response then
		return self:_wait_for_response(request_name)
	end
end

Testify.rpc_testify_make_request = function (self, channel_id, peer_id, request_name, wait_for_response, request_parameters, num_parameters)
	self:_print("Request received from server %s", request_name)

	local parameters = cjson_decode(request_parameters)

	self:run_case(function (dt, t)
		self:make_request(request_name, unpack(parameters, 1, num_parameters))

		local responses, num_responses = table_pack(self:_wait_for_response(request_name))

		if wait_for_response then
			self:_print("Responding to the server for request %s on channel %s", request_name, channel_id)

			responses = cjson_encode(responses)

			RPC.rpc_testify_wait_for_response(channel_id, request_name, responses, num_responses)
		end
	end)
end

Testify.rpc_testify_wait_for_response = function (self, channel_id, request_name, responses, num_responses)
	responses = cjson_decode(responses)

	self:_print("Request %s response received from the peer on channel %s", request_name, channel_id)
	self:respond_to_request(request_name, responses, num_responses)
end

Testify.server_rpcs = function (self)
	return SERVER_RPCS
end

Testify.client_rpcs = function (self)
	return CLIENT_RPCS
end

Testify.add_peer = function (self, peer_id, channel_id)
	self:_print("Adding peer %s on channel %s", peer_id, channel_id)

	self._peers[peer_id] = channel_id
end

Testify.remove_peer = function (self, peer_id, channel_id)
	self:_print("Removing peer %s on channel %s", peer_id, channel_id)

	self._peers[peer_id] = nil
end

Testify.peers = function (self)
	local peers = self._peers

	return table_keys(peers)
end

Testify.num_peers = function (self)
	local peers = self._peers
	local num_peers = table_size(peers)

	return num_peers
end

Testify.are_rpcs_registered = function (self)
	return self._are_rpcs_registered
end

Testify.set_rpcs_registered_value = function (self, is_registered)
	self._are_rpcs_registered = is_registered
end
