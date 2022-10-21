local EACError = require("scripts/managers/error/errors/eac_error")
local XboxLive = require("scripts/foundation/utilities/xbox_live")

local function _info(...)
	Log.info("EACClientManager", ...)
end

EACClientManager = class("EACClientManager")
local EAC_STATES = table.enum("none", "retrieving_app_ticket", "authenticating_eos", "ready", "in_session", "error")
local TIMEOUT = 15

EACClientManager.init = function (self)
	_info("init")

	self._state = EAC_STATES.none
	self._authenticated = false
	self._has_eac = self:has_eac()

	if not self._has_eac then
		_info("loc_eac_error_not_running_eac")
		Managers.error:report_error(EACError:new("loc_eac_error_not_running_eac"))

		return
	end

	EOS.set_server(false)
	_info("EOS.set_server(false)")
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

		self._state = EAC_STATES.retrieving_app_ticket

		_info("retrieving app_ticket")

		self._authenticated = false
		self._timeout_at = Managers.time:time("main") + TIMEOUT
	elseif IS_GDK then
		XboxLive.user_id():next(function (user_id)
			local auth_job_id = EOS.authenticate_with_xbox(user_id)
			self._auth_job_id = auth_job_id
			self._state = EAC_STATES.authenticating_eos

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

	local state = self._state
	local user_id = self._user_id
	local mode = "ClientServer"
	local server_name = Managers.connection:server_name()

	EOS.begin_session(user_id, mode, server_name)

	self._state = EAC_STATES.in_session

	_info("begin_session")

	local server_peer_id = Managers.connection:host_channel()

	EOS.set_server_peer_id(server_peer_id)
	_info("set_server_peer_id server_peer_id:%s", server_peer_id)
end

EACClientManager.end_session = function (self)
	if not self._authenticated then
		_info("cant end_session when not authenticated")

		return
	end

	local state = self._state

	EOS.end_session()

	self._state = EAC_STATES.ready

	_info("end_session")
end

EACClientManager.in_session = function (self)
	return self._state == EAC_STATES.in_session
end

EACClientManager.update = function (self, dt, t)
	local state = self._state

	if state == EAC_STATES.retrieving_app_ticket then
		local app_ticket, app_ticket_size = Steam.poll_encrypted_app_ticket_raw()

		if app_ticket then
			local auth_job_id = EOS.authenticate_with_steam(app_ticket, app_ticket_size)
			self._auth_job_id = auth_job_id
			self._state = EAC_STATES.authenticating_eos

			_info("recieved app_ticket trying to authenticate with eos")
		end

		if self._timeout_at < t then
			Managers.error:report_error(EACError:new("loc_eac_error_timeout_auth_eac"))
			_info("authentication timed out")

			self._state = EAC_STATES.error
		end
	elseif state == EAC_STATES.authenticating_eos then
		local job_id = self._auth_job_id
		local job_status = EOS.job_status(job_id)

		if job_status == EOS.FINISHED then
			local job_result = EOS.job_result(job_id)

			if job_result == EOS.Success then
				self._state = EAC_STATES.ready
				self._authenticated = true
				local user_id = EOS.job_payload_user_id(job_id)
				self._user_id = user_id

				_info("got user id from EOS")
			else
				Managers.error:report_error(EACError:new("loc_eac_error_auth_eac_failed"))
				_info("authentication failed")

				self._state = EAC_STATES.error
			end

			EOS.erase_job(job_id)

			self._auth_job_id = nil
		end

		if self._timeout_at < t then
			Managers.error:report_error(EACError:new("loc_eac_error_timeout_auth_eac"))
			_info("authentication timed out")

			self._state = EAC_STATES.error
		end
	elseif state == EAC_STATES.in_session then
		-- Nothing
	elseif state == EAC_STATES.error then
		-- Nothing
	end
end

return EACClientManager
