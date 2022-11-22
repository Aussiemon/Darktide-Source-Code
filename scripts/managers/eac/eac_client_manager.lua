local EACError = require("scripts/managers/error/errors/eac_error")
local XboxLive = require("scripts/foundation/utilities/xbox_live")

local function _info(...)
	Log.info("EACClientManager", ...)
end

EACClientManager = class("EACClientManager")
local EAC_AUTH_STATES = table.enum("none", "retrieving_app_ticket", "authenticating_eos", "ready", "error")
local EAC_SESSION_STATES = table.enum("no_session", "in_session", "end_session_requested")
local TIMEOUT = 15

EACClientManager.init = function (self)
	_info("init")

	self._auth_state = EAC_AUTH_STATES.none
	self._session_state = EAC_SESSION_STATES.no_session
	self._authenticated = false
	self._has_eac = self:has_eac()

	if not self._has_eac then
		_info("loc_eac_error_not_running_eac")
		Managers.error:report_error(EACError:new("loc_eac_error_not_running_eac"))

		return
	end
end

EACClientManager.has_eac = function (self)
	local has_eac = EOS.has_eac_client()

	return has_eac
end

EACClientManager.authenticate = function (self)
	if not self._has_eac then
		return
	end

	if self._authenticated then
		_info("already authenticated")

		return
	end

	if HAS_STEAM then
		Steam.retrieve_encrypted_app_ticket()

		self._auth_state = EAC_AUTH_STATES.retrieving_app_ticket

		_info("retrieving app_ticket")

		self._timeout_at = Managers.time:time("main") + TIMEOUT
		self._authenticated = false
	elseif IS_GDK then
		XboxLive.user_id():next(function (user_id)
			local auth_job_id = EOS.authenticate_with_xbox(user_id)
			self._auth_job_id = auth_job_id
			self._timeout_at = Managers.time:time("main") + TIMEOUT
			self._auth_state = EAC_AUTH_STATES.authenticating_eos

			_info("recieved user id from xbox live,  trying to authenticate with eos")
		end):catch(function (error)
			Managers.error:report_error(EACError:new("Error fetching xbox live user_id: %s", {
				error_code = error
			}))
		end)
	else
		Managers.error:report_error(EACError:new("loc_eac_error_not_running_steam"))
	end
end

EACClientManager.authenticated = function (self)
	return self._authenticated
end

EACClientManager.begin_session = function (self)
	if not self._authenticated then
		_info("cant begin_session when not authenticated")

		return
	end

	if self:in_session() then
		self:end_session()
	end

	local user_id = self._user_id
	local mode = "ClientServer"
	local server_name = Managers.connection:server_name()

	_info("begin_session, user_id:%s, mode:%s, server_name:%s", user_id, mode, server_name)
	EOS.begin_session(user_id, mode, server_name)

	self._session_state = EAC_SESSION_STATES.in_session
	local server_channel_id = Managers.connection:host_channel()

	EOS.set_server_channel_id(server_channel_id)
	_info("set_server_channel_id :%s", server_channel_id)
end

EACClientManager.end_session = function (self)
	if not self._authenticated then
		self._session_state = EAC_SESSION_STATES.end_session_requested

		_info("Cant end_session when not authenticated, will retry")

		return
	end

	EOS.end_session()

	self._session_state = EAC_SESSION_STATES.no_session

	_info("end_session")
end

EACClientManager.in_session = function (self)
	return self._session_state == EAC_SESSION_STATES.in_session
end

EACClientManager.user_id = function (self)
	return self._user_id
end

EACClientManager.update = function (self, dt, t)
	self:_update_authentication(dt, t)
	self:_update_session(dt, t)
end

EACClientManager._update_authentication = function (self, dt, t)
	local auth_state = self._auth_state

	if auth_state == EAC_AUTH_STATES.retrieving_app_ticket then
		local app_ticket, app_ticket_size = Steam.poll_encrypted_app_ticket_raw()

		if app_ticket then
			local auth_job_id = EOS.authenticate_with_steam(app_ticket, app_ticket_size)
			self._auth_job_id = auth_job_id
			self._auth_state = EAC_AUTH_STATES.authenticating_eos

			_info("recieved app_ticket trying to authenticate with eos")
		end

		if self._timeout_at < t then
			Managers.error:report_error(EACError:new("loc_eac_error_timeout_auth_eac"))
			_info("authentication timed out")

			self._auth_state = EAC_AUTH_STATES.error
		end
	elseif auth_state == EAC_AUTH_STATES.authenticating_eos then
		local job_id = self._auth_job_id
		local job_status = EOS.job_status(job_id)

		if job_status == EOS.FINISHED then
			local job_result = EOS.job_result(job_id)

			if job_result == EOS.Success then
				self._auth_state = EAC_AUTH_STATES.ready
				self._authenticated = true
				local user_id = EOS.job_payload_user_id(job_id)
				self._user_id = user_id

				_info("got user id from EOS %s", user_id)
			else
				Managers.error:report_error(EACError:new("loc_eac_error_auth_eac_failed"))
				_info("authentication failed")

				self._auth_state = EAC_AUTH_STATES.error
			end

			EOS.erase_job(job_id)

			self._auth_job_id = nil
		elseif job_status == EOS.FAILURE then
			local job_result = EOS.job_result(job_id)

			_info("authentication failed")
			EOS.erase_job(job_id)

			self._auth_job_id = nil
			self._auth_state = EAC_AUTH_STATES.error

			Managers.error:report_error(EACError:new("loc_eac_error_auth_eac_failed"))
		end

		if self._timeout_at < t then
			Managers.error:report_error(EACError:new("loc_eac_error_timeout_auth_eac"))
			_info("authentication timed out")

			self._auth_state = EAC_AUTH_STATES.error
		end
	elseif auth_state == EAC_AUTH_STATES.error then
		-- Nothing
	end
end

EACClientManager._update_session = function (self, dt, t)
	local session_state = self._session_state

	if session_state == EAC_SESSION_STATES.in_session then
		local user_id = self._user_id

		if user_id then
			self:_validate_user_id()
		end
	elseif session_state == EAC_SESSION_STATES.end_session_requested then
		self:end_session()
	end
end

EACClientManager._validate_user_id = function (self)
	local user_id_valid = EOS.user_id_valid()

	if not user_id_valid then
		self._user_id = nil
		self._authenticated = false

		self:authenticate()
		_info("user id invalid, re-authenticating")
	end
end

EACClientManager.reset = function (self)
	_info("Reset")

	if self:in_session() then
		self:end_session()
	end

	self._user_id = nil
	self._authenticated = false
end

return EACClientManager
