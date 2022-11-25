local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendInterface = require("scripts/backend/backend_interface")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local BackendManagerTestify = GameParameters.testify and require("scripts/foundation/managers/backend/backend_manager_testify")
local XboxLiveUtils = require("scripts/foundation/utilities/xbox_live")
local Interface = {
	"authenticated",
	"authentication_failed",
	"authenticate",
	"get_auth_method",
	"account_id",
	"title_request",
	"send_telemetry_events",
	"url_request",
	"get_server_time"
}
local LIMIT_RESPONSE_TIME_WARNING_MS = 2000
local TITLE_REQUEST_RETRY_COUNT = 5
local TIME_SYNC_STATES = table.enum("not_started", "running", "failed", "synced")
local TIME_SYNC_PAUSE_BETWEEN_RETRY_SECONDS = 10
local TIME_SYNC_ACCEPTABLE_LATENCY_SECONDS = 5
local DEFAULT_AUTHENTICATION_SERIVCE_URL = "https://bsp-auth-dev.fatsharkgames.se"
local DEFAULT_TITLE_SERIVCE_URL = "https://bsp-td-dev.fatsharkgames.se"
local DEFAULT_TELEMERTY_SERVICE_URL = "https://telemetry-utvxrq72na-ez.a.run.app/events"

local function retry_delay(attempt)
	local temp = math.min(10000, 500 * math.pow(2, attempt))
	local sleep = temp / 2 + math.random(0, temp / 2)

	return sleep / 1000
end

local function is_retryable_error_code(code)
	if code and (code == 429 or code == 1000 or code == 0 or math.floor(code / 100) == 5) then
		return true
	end

	return false
end

local BackendManager = class("BackendManager")

BackendManager.init = function (self, default_headers_ctr)
	self._default_headers_ctr = default_headers_ctr or function ()
		return {}
	end
	self._promises = {}
	self._initialized = false
	self._initialize_promise = nil
	self.interfaces = BackendInterface.new()
	self._inflight_title_requests = {}
	self._title_request_retry_queue = {}
	self.time_sync_state = TIME_SYNC_STATES.not_started
end

BackendManager.authenticated = function (self)
	return self._auth_cache and self._auth_cache.state == "fulfilled"
end

BackendManager.authentication_failed = function (self)
	return self._auth_cache and self._auth_cache.state == "rejected"
end

local function _check_response_time(path, value)
	local response_time = (value.response_time or 0) * 1000

	if LIMIT_RESPONSE_TIME_WARNING_MS < response_time then
		Managers.telemetry_events:record_slow_response_time(path, math.floor(response_time))
	end
end

BackendManager.update = function (self, dt, t)
	if self._initialized then
		if Backend.did_update_auth_config() then
			self._auth_cache = nil
		end

		self:sync_time(t)

		local results = Backend.update(dt, t)

		if type(results) == "table" then
			for i = 1, #results do
				local result_mapping = results[i]
				local id = result_mapping.id
				local promise = self._promises[id]

				if promise then
					if result_mapping.error then
						local inflight_request = self._inflight_title_requests[id]

						if result_mapping.error.code and is_retryable_error_code(result_mapping.error.code) and inflight_request and inflight_request.retry_count < TITLE_REQUEST_RETRY_COUNT then
							Log.warning("BackendManager", "Title request failed - will retry after pause:\n%s", BackendUtilities.ERROR_METATABLE.__tostring(result_mapping.error))

							local delay = retry_delay(inflight_request.retry_count)
							inflight_request.request_time = t + delay

							table.insert(self._title_request_retry_queue, inflight_request)

							self._inflight_title_requests[id] = nil
						else
							local error_table = result_mapping.error

							setmetatable(error_table, BackendUtilities.ERROR_METATABLE)
							promise:reject(error_table)

							self._promises[id] = nil
						end
					elseif result_mapping.value then
						promise:resolve(result_mapping.value)

						self._promises[id] = nil
					else
						promise:resolve(nil)

						self._promises[id] = nil
					end
				else
					self:sync_time_result(t, id, result_mapping)
				end
			end
		end

		local remove_indices = {}
		local title_request_retry_queue = self._title_request_retry_queue

		for i = 1, #title_request_retry_queue do
			local request = title_request_retry_queue[i]

			if request.request_time <= t then
				local previous_operation_identifier = request.operation_identifier
				local promise = self._promises[previous_operation_identifier]

				if promise then
					Log.info("BackendManager", "Retrying request title_request: %s %s", request.options and request.options.method or "GET", request.path)

					local operation_identifier, error = Backend.title_request(request.path, request.options)

					if operation_identifier then
						self._promises[previous_operation_identifier] = nil
						self._promises[operation_identifier] = promise
						request.operation_identifier = operation_identifier
						request.retry_count = request.retry_count + 1
						self._inflight_title_requests[operation_identifier] = request

						promise:next(function (_)
							self._inflight_title_requests[operation_identifier] = nil
						end):catch(function (_)
							self._inflight_title_requests[operation_identifier] = nil
						end)
					else
						error = error or "Missing backend operation identifier"

						promise:reject(BackendUtilities.create_error(BackendError.NoIdentifier, error))

						self._promises[previous_operation_identifier] = nil
					end
				end

				table.insert(remove_indices, i)
			end
		end

		for i = #remove_indices, 1, -1 do
			table.remove(title_request_retry_queue, remove_indices[i])
		end
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(BackendManagerTestify, self)
	end
end

BackendManager.on_reload = function (self, refreshed_resources)
	self.interfaces.master_data:on_reload(refreshed_resources)
end

BackendManager.logout = function (self)
	if self._initialized then
		self._auth_cache = nil

		Backend.logout()
	end
end

BackendManager.authenticate = function (self)
	local debug_log = false

	if not self._initialize_promise or self._initialize_promise:is_rejected() then
		self._initialize_promise = Promise:new()

		if Backend.get_auth_method() == BackendManager.AUTH_METHOD_XBOXLIVE then
			local default_result = {
				authentication_service_url = DEFAULT_AUTHENTICATION_SERIVCE_URL,
				title_service_url = DEFAULT_TITLE_SERIVCE_URL,
				telemetry_service_url = DEFAULT_TELEMERTY_SERVICE_URL
			}

			XboxLiveUtils.title_storage_download("backend_config.json", "binary", "global_storage", 10000):next(function (file_content)
				Log.info("BackendManager", "Got backend_config.json from title storage: %s", file_content)

				local parsed_file_content = cjson.decode(file_content)

				for key, value in pairs(parsed_file_content) do
					default_result[key] = value
				end

				return default_result
			end):catch(function (error_data)
				local error_code = error_data.error_code or error_data[1]

				if error_code == -2145844844 then
					Log.info("BackendManager", "Got no backend_config.json from title storage")

					return Promise.resolved(default_result)
				end

				self._initialize_promise:reject(error_data)

				return Promise.rejected(error_data)
			end):next(function (result)
				local success, error_code = Backend.initialize(debug_log, result.authentication_service_url, result.title_service_url, result.telemetry_service_url)
				self._initialized = true

				self._initialize_promise:resolve()
			end)
		else
			local success, error_code = Backend.initialize(debug_log, DEFAULT_AUTHENTICATION_SERIVCE_URL, DEFAULT_TITLE_SERIVCE_URL, DEFAULT_TELEMERTY_SERVICE_URL)
			self._initialized = true

			self._initialize_promise:resolve()
		end
	end

	return self._initialize_promise:next(function ()
		if self._auth_cache and not self._auth_cache:is_rejected() then
			return self._auth_cache
		end

		local auth_promise = Promise:new()
		local user_id = Managers.account:user_id()
		local operation_identifier, error_code = Backend.authenticate(user_id)

		if operation_identifier then
			self._promises[operation_identifier] = auth_promise
			self._auth_cache = auth_promise
		else
			error_code = error_code or "Missing backend operation identifier"

			auth_promise:reject(BackendUtilities.create_error(BackendError.NoIdentifier, error_code))
		end

		auth_promise:next(function (account)
			Managers.telemetry_events:player_authenticated(account)
			Crashify.print_property("account_id", string.value_or_nil(account.sub))

			if Managers.event then
				Managers.event:trigger("event_player_authenticated")
			end

			if not DEDICATED_SERVER then
				local account_id = self:account_id()

				Managers.telemetry_events:system_settings(account_id)
			end
		end)

		return auth_promise
	end)
end

BackendManager.AUTH_METHOD_XBOXLIVE = Backend.AUTH_METHOD_XBOXLIVE
BackendManager.AUTH_METHOD_STEAM = Backend.AUTH_METHOD_STEAM

BackendManager.get_auth_method = function (self)
	return Backend.get_auth_method()
end

BackendManager.account_id = function (self)
	if self._auth_cache and self._auth_cache.value and self._auth_cache.value.sub then
		return self._auth_cache.value.sub
	end

	return nil
end

BackendManager.title_request = function (self, path, options)
	if not self._initialized then
		return self:_not_initialized()
	end

	local should_cache = not options or options.method == "GET"

	if should_cache then
		for key, value in pairs(self._inflight_title_requests) do
			if value.should_cache and value.path == path then
				for promise_key, promise in pairs(self._promises) do
					if key == promise_key then
						return promise
					end
				end
			end
		end
	end

	Log.info("BackendManager", "title_request: %s %s", options and options.method or "GET", path)

	options = options or {}
	options.headers = options.headers or {}
	local default_headers = self._default_headers_ctr()

	if default_headers then
		table.merge(options.headers, default_headers)
	end

	local promise = Promise:new()
	local operation_identifier, error = Backend.title_request(path, options)

	if operation_identifier then
		self._promises[operation_identifier] = promise
		self._inflight_title_requests[operation_identifier] = {
			retry_count = 0,
			path = path,
			options = options,
			should_cache = should_cache,
			operation_identifier = operation_identifier
		}

		promise:next(function (v)
			self._inflight_title_requests[operation_identifier] = nil

			_check_response_time(path, v)
		end):catch(function (e)
			self._inflight_title_requests[operation_identifier] = nil

			_check_response_time(path, e)
		end)
	else
		error = error or "Missing backend operation identifier"

		promise:reject(BackendUtilities.create_error(BackendError.NoIdentifier, error))
	end

	return promise
end

BackendManager.send_telemetry_events = function (self, data, headers, compress_body)
	if not self._initialized then
		return self:_not_initialized()
	end

	data = data or {}
	local promise = Promise:new()
	local operation_identifier, error = Backend.send_telemetry_events({
		events = data
	}, headers, compress_body)

	if operation_identifier then
		self._promises[operation_identifier] = promise
	else
		error = error or "Missing backend operation identifier"

		promise:reject(BackendUtilities.create_error(BackendError.NoIdentifier, error))
	end

	return promise
end

BackendManager.url_request = function (self, url, options)
	Log.info("BackendManager", "url_request: %s %s", options and options.method or "GET", url)

	if not self._initialized then
		return self:_not_initialized()
	end

	local promise = Promise:new()
	local operation_identifier, error = Backend.url_request(url, options)

	if operation_identifier then
		self._promises[operation_identifier] = promise
	else
		error = error or "Missing backend operation identifier"

		promise:reject(BackendUtilities.create_error(BackendError.NoIdentifier, error))
	end

	promise:next(function (v)
		_check_response_time(url, v)
	end):catch(function (e)
		_check_response_time(url, e)
	end)

	return promise
end

BackendManager._not_initialized = function (self)
	local p = Promise:new()

	p:reject(BackendUtilities.create_error(BackendError.NotInitialized, "Backend not initialized"))

	return p
end

BackendManager.sync_time = function (self, t)
	if self.time_sync_state == TIME_SYNC_STATES.synced then
		return
	elseif self.time_sync_state == TIME_SYNC_STATES.failed then
		if TIME_SYNC_PAUSE_BETWEEN_RETRY_SECONDS < t - self.time_sync_started_t then
			Log.debug("Backend", "Time sync ready for retry")

			self.time_sync_state = TIME_SYNC_STATES.not_started
			self.time_sync_started_t = nil
		end
	elseif self.time_sync_state == TIME_SYNC_STATES.not_started then
		if not self:authenticated() then
			return
		end

		Log.info("Backend", "Starting time sync")

		self.time_sync_started_t = t
		local operation_identifier, error = Backend.title_request("/data/time")

		if error then
			self.time_sync_state = TIME_SYNC_STATES.failed

			return
		end

		self.time_sync_state = TIME_SYNC_STATES.running
		self.time_operation_id = operation_identifier
	end
end

BackendManager.sync_time_result = function (self, t, id, mapping)
	if self.time_sync_state ~= TIME_SYNC_STATES.running or self.time_operation_id ~= id then
		return
	end

	if mapping.error then
		Log.debug("Backend", "Time sync failed")

		self.time_sync_state = TIME_SYNC_STATES.failed

		if mapping.error.status == 404 then
			self.time_sync_state = TIME_SYNC_STATES.synced
		end
	else
		local latency = t - self.time_sync_started_t
		local body = mapping.value.body

		Log.debug("Backend", "Time sync latency: %.2f", latency)

		if TIME_SYNC_ACCEPTABLE_LATENCY_SECONDS < latency or body.coldStart then
			self.time_sync_state = TIME_SYNC_STATES.failed
		else
			self.time_sync_state = TIME_SYNC_STATES.synced
		end

		self.server_time_game_start_epoch = tonumber(body.time) - t * 1000
	end
end

BackendManager.get_server_time = function (self, t)
	if self.server_time_game_start_epoch then
		return self.server_time_game_start_epoch + t * 1000
	else
		return os.time() * 1000
	end
end

BackendManager._time_sync_restart = function (self)
	self.server_time_game_start_epoch = nil
	self.time_sync_started_t = nil
	self.time_sync_state = TIME_SYNC_STATES.not_started
end

BackendManager.failed_request = function (self)
	return Promise.delay(LIMIT_RESPONSE_TIME_WARNING_MS / 1000):next(function (_)
		return Promise.rejected(BackendUtilities.create_error(BackendError.NoIdentifier, "Requested failure"))
	end)
end

implements(BackendManager, Interface)

return BackendManager
