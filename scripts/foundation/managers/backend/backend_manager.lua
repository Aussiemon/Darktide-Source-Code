-- chunkname: @scripts/foundation/managers/backend/backend_manager.lua

local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendInterface = require("scripts/backend/backend_interface")
local BackendManagerTestify = GameParameters.testify and require("scripts/foundation/managers/backend/backend_manager_testify")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local DefaultBackendSettings = require("scripts/settings/backend/default_backend_settings")
local PriorityQueue = require("scripts/foundation/utilities/priority_queue")
local Promise = require("scripts/foundation/utilities/promise")
local XboxLiveUtils = require("scripts/foundation/utilities/xbox_live_utils")
local Interface = {
	"authenticated",
	"authenticate",
	"get_auth_method",
	"account_id",
	"title_request",
	"send_telemetry_events",
	"url_request",
	"get_server_time",
}
local SLOW_INTERNET_DELAY_NOTIFICATION_S = 300
local SLOW_INTERNET_SPAN_S = 90
local SLOW_INTERNET_TIME_MS = 2000
local SLOW_INTERNET_COUNT = 3
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
	self._slow_internet_notification_delay = 0
	self._slow_internet_ticks = PriorityQueue:new()
	self._inflight_title_requests = {}
	self._title_request_retry_queue = {}
	self.time_sync_state = TIME_SYNC_STATES.not_started
end

BackendManager.authenticated = function (self)
	return Backend.is_authenticated()
end

local function _check_response_time(path, value)
	local response_time = (value.response_time or 0) * 1000

	if response_time > LIMIT_RESPONSE_TIME_WARNING_MS then
		Managers.telemetry_events:record_slow_response_time(path, math.floor(response_time))
	end
end

BackendManager.update = function (self, dt, t)
	local initialized = self._initialized

	if initialized then
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

		local title_request_retry_queue = self._title_request_retry_queue
		local title_request_retry_queue_size = #title_request_retry_queue

		for i = title_request_retry_queue_size, 1, -1 do
			local request = title_request_retry_queue[i]

			if t >= request.request_time then
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

				title_request_retry_queue[i] = title_request_retry_queue[title_request_retry_queue_size]
				title_request_retry_queue[title_request_retry_queue_size] = nil
				title_request_retry_queue_size = title_request_retry_queue_size - 1
			end
		end
	end

	local authenticated = initialized and self:authenticated()
	local settings_need_update = not self._settings_promise and not self._backend_settings

	if authenticated and settings_need_update then
		self:_download_settings()
	end

	local was_slow_frame = dt >= 0.5

	if not DEDICATED_SERVER and not was_slow_frame then
		local slow_internet_ticks = self._slow_internet_ticks

		self._slow_internet_notification_delay = math.max(self._slow_internet_notification_delay - dt, 0)

		local current_time = Managers.time:time("main")

		if self._slow_internet_notification_delay == 0 then
			for _, inflight_request in pairs(self._inflight_title_requests) do
				local time_in_flight = 1000 * (current_time - inflight_request.start_time)

				if time_in_flight > SLOW_INTERNET_TIME_MS and not inflight_request._triggered_slow_internet then
					slow_internet_ticks:push(current_time + SLOW_INTERNET_SPAN_S)

					inflight_request._triggered_slow_internet = true
				end
			end
		end

		while not slow_internet_ticks:empty() and current_time > slow_internet_ticks:peek() do
			slow_internet_ticks:pop()
		end

		if slow_internet_ticks:size() > SLOW_INTERNET_COUNT then
			Managers.event:trigger("event_add_notification_message", "alert", {
				text = Localize("loc_popup_description_slow_internet"),
			})

			self._slow_internet_notification_delay = SLOW_INTERNET_DELAY_NOTIFICATION_S

			slow_internet_ticks:clear()
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
	Promise.reset()

	if self._initialized then
		for _, promise in pairs(self._promises) do
			promise:cancel()
		end

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
				telemetry_service_url = DEFAULT_TELEMERTY_SERVICE_URL,
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
		if Managers.account:user_detached() then
			return Promise.rejected(BackendUtilities.create_error(BackendError.NoIdentifier, Localize("loc_popup_header_signed_out_error")))
		end

		local auth_promise = Promise:new()
		local user_id = Managers.account:user_id()
		local operation_identifier, error_code = Backend.authenticate(user_id)

		if operation_identifier then
			local already_existing_promise = self._promises[operation_identifier]

			if already_existing_promise then
				return already_existing_promise
			end

			self._promises[operation_identifier] = auth_promise
		else
			error_code = error_code or "Missing backend operation identifier"

			auth_promise:reject(BackendUtilities.create_error(BackendError.NoIdentifier, error_code))
		end

		if not Backend.is_authenticated() then
			auth_promise:next(function (account)
				self:_set_backend_env(Backend.get_title_url())
				Managers.telemetry_events:player_authenticated(account)
				Crashify.print_property("account_id", string.value_or_nil(account.sub))

				if Managers.event then
					Managers.event:trigger("event_player_authenticated")
				end

				if not DEDICATED_SERVER then
					local account_id = self:account_id()

					Managers.telemetry_events:system_settings(account_id)
				end

				self._should_signinerror_at_not_authenticated = true
			end)
		end

		return auth_promise:catch(function (error)
			return Promise.rejected(error)
		end)
	end)
end

BackendManager._set_backend_env = function (self, title_service_url)
	local match = string.match(title_service_url, "https://bsp%-td%-(.+)%.fatsharkgames%.se")

	if match then
		rawset(_G, "BACKEND_ENV", match)
	end

	match = string.match(title_service_url, "https://bsp%-td%-(.+)%.atoma%.cloud")

	if match then
		rawset(_G, "BACKEND_ENV", match)
	end

	local PresenceEntryMyself = require("scripts/managers/presence/presence_entry_myself")

	rawset(_G, "AUTH_PLATFORM", PresenceEntryMyself.get_platform())
	Crashify.print_property("backend_env", BACKEND_ENV)
	Crashify.print_property("auth_platform", AUTH_PLATFORM)
	Managers.telemetry_events:refresh_settings()
end

BackendManager.AUTH_METHOD_PSN = Backend.AUTH_METHOD_PSN
BackendManager.AUTH_METHOD_XBOXLIVE = Backend.AUTH_METHOD_XBOXLIVE
BackendManager.AUTH_METHOD_STEAM = Backend.AUTH_METHOD_STEAM

BackendManager.get_auth_method = function (self)
	return Backend.get_auth_method()
end

BackendManager.account_id = function (self)
	return Backend.authenticated_sub()
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
			operation_identifier = operation_identifier,
			start_time = Managers.time:time("main"),
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
		events = data,
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
		if t - self.time_sync_started_t > TIME_SYNC_PAUSE_BETWEEN_RETRY_SECONDS then
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

		if latency > TIME_SYNC_ACCEPTABLE_LATENCY_SECONDS or body.coldStart then
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

BackendManager.time_sync_restart = function (self)
	self.server_time_game_start_epoch = nil
	self.time_sync_started_t = nil
	self.time_sync_state = TIME_SYNC_STATES.not_started
end

BackendManager.failed_request = function (self)
	return Promise.delay(LIMIT_RESPONSE_TIME_WARNING_MS / 1000):next(function (_)
		return Promise.rejected(BackendUtilities.create_error(BackendError.NoIdentifier, "Requested failure"))
	end)
end

BackendManager._download_settings = function (self)
	self._settings_promise = self:title_request(BackendUtilities.url_builder("/gameplay/config/sessions"):to_string())

	return self._settings_promise:next(function (message)
		return message.body
	end):next(function (settings)
		self._backend_settings = settings
		self._settings_promise = nil
	end):catch(function (error)
		Log.warning("Failed to fetch backend settings.")

		self._backend_settings = {}
		self._settings_promise = nil

		return Promise.rejected(error)
	end)
end

BackendManager.session_setting = function (self, ...)
	local res
	local backend_settings = self._backend_settings

	if backend_settings then
		res = table.nested_get(backend_settings, ...)
	end

	if res == nil then
		res = table.nested_get(DefaultBackendSettings, ...)
	end

	return res
end

implements(BackendManager, Interface)

return BackendManager
