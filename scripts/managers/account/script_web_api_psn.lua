-- chunkname: @scripts/managers/account/script_web_api_psn.lua

local Promise = require("scripts/foundation/utilities/promise")
local ScriptWebApiPsn = class("ScriptWebApiPsn")
local web_api = WebApi
local debug_psn = false
local method_to_string = {
	[web_api.GET] = "GET",
	[web_api.PUT] = "PUT",
	[web_api.POST] = "POST",
	[web_api.DELETE] = "DELETE",
}

ScriptWebApiPsn.init = function (self)
	self._requests = {}
end

ScriptWebApiPsn.destroy = function (self)
	local requests = self._requests

	for i = #requests, 1, -1 do
		local r = requests[i]

		web_api.free(r.id)
	end

	self._requests = nil
end

ScriptWebApiPsn.update = function (self, dt)
	local requests = self._requests

	for i = #requests, 1, -1 do
		local r = requests[i]
		local id = r.id
		local status = web_api.status(id)

		if status == web_api.COMPLETED then
			self:_handle_request_response(i, true)
		elseif status == web_api.ERROR then
			self:_handle_request_response(i, false)
		end
	end
end

ScriptWebApiPsn._handle_request_response = function (self, request_index, success)
	local request = self._requests[request_index]
	local id = request.id
	local response_promise = request.response_promise
	local response_format = request.response_format or web_api.TABLE

	if success then
		if debug_psn then
			Log.info("[ScriptWebApiPsn]", "Completed Request: %s", request.debug_text or "n/a")
		end

		local response = web_api.request_result(id, response_format)

		response_promise:resolve(response)
	else
		if debug_psn then
			Log.info("[ScriptWebApiPsn]", "Failed Request: %s", request.debug_text or "n/a")
		end

		response_promise:reject({})
	end

	web_api.free(id)
	table.remove(self._requests, request_index)
end

ScriptWebApiPsn.send_request = function (self, user_id, api_group, path, method, content, response_format)
	if user_id == nil then
		return
	end

	local id = web_api.send_request(user_id, api_group, path, method, content)
	local response_promise = Promise.new()

	self._requests[#self._requests + 1] = {
		id = id,
		response_promise = response_promise,
		response_format = response_format,
		debug_text = string.format("%s %s", method_to_string[method], path),
	}

	return response_promise
end

ScriptWebApiPsn.send_request_create_session = function (self, user_id, session_parameters, session_image, session_data, changable_session_data)
	local id = web_api.send_request_create_session(user_id, session_parameters, session_image, session_data, changable_session_data)
	local response_promise = Promise.new()

	self._requests[#self._requests + 1] = {
		debug_text = "POST /v1/sessions",
		id = id,
		response_promise = response_promise,
	}

	return response_promise
end

ScriptWebApiPsn.send_request_session_invitation = function (self, user_id, params, session_id)
	local id = web_api.send_request_session_invitation(user_id, params, session_id)

	self._requests[#self._requests + 1] = {
		id = id,
		debug_text = string.format("POST /v1/sessions/%s/invitations", session_id),
	}
end

return ScriptWebApiPsn
