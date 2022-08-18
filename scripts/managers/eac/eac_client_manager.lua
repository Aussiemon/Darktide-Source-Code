-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local EACError = require("scripts/managers/error/errors/eac_error")
local XboxLive = require("scripts/foundation/utilities/xbox_live")
EACClientManager = class("EACClientManager")
local EAC_STATES = table.enum("none", "retrieving_app_ticket", "authenticating_eos", "ready", "in_session", "error")
local TIMEOUT = 15

EACClientManager.init = function (self)
	self._state = EAC_STATES.none
	self._authenticated = false
	self._has_eac = self:has_eac()

	if not self._has_eac then
		Managers.error:report_error(EACError:new("loc_eac_error_not_running_eac"))
	end

	EOS.set_server(false)
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
		self._authenticated = false
		self._timeout_at = Managers.time:time("main") + TIMEOUT
	elseif IS_GDK then
		XboxLive.user_id():next(function (user_id)
			local auth_job_id = EOS.authenticate_with_xbox(user_id)
			self._auth_job_id = auth_job_id
			self._state = EAC_STATES.authenticating_eos
		end):catch(function (error)
			Managers.error:report_error(EACError:new("Error fetching xbox live user_id: %s", {
				error_code = error
			}))
		end)
	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 48-57, warpins: 1 ---
		Managers.error:report_error(EACError:new("loc_eac_error_not_running_steam"))
		--- END OF BLOCK #0 ---



	end
end

EACClientManager.authenticated = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return self._authenticated
	--- END OF BLOCK #0 ---



end

EACClientManager.begin_session = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if not self._authenticated then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-4, warpins: 1 ---
		return
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 5-10, warpins: 2 ---
	local state = self._state

	fassert(state == EAC_STATES.ready, "Trying to begin a EAC session without being authenticated. [In state %s]", state)

	local user_id = self._user_id
	local mode = "ClientServer"
	local server_name = Managers.connection:server_name()

	EOS.begin_session(user_id, mode, server_name)

	self._state = EAC_STATES.in_session
	local server_peer_id = Managers.connection:host_channel()

	EOS.set_server_peer_id(server_peer_id)

	return
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 14-42, warpins: 2 ---
	--- END OF BLOCK #2 ---



end

EACClientManager.end_session = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if not self._authenticated then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-4, warpins: 1 ---
		return
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 5-10, warpins: 2 ---
	local state = self._state

	fassert(state == EAC_STATES.in_session, "Trying to end a EAC session without being in a session. [In state %s]", state)
	EOS.end_session()

	self._state = EAC_STATES.ready

	return
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 14-23, warpins: 2 ---
	--- END OF BLOCK #2 ---



end

EACClientManager.in_session = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	return self._state == EAC_STATES.in_session
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 9-9, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

EACClientManager.update = function (self, dt, t)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	local state = self._state

	if state == EAC_STATES.retrieving_app_ticket then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 6-10, warpins: 1 ---
		local app_ticket, app_ticket_size = Steam.poll_encrypted_app_ticket_raw()

		if app_ticket then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 11-19, warpins: 1 ---
			local auth_job_id = EOS.authenticate_with_steam(app_ticket, app_ticket_size)
			self._auth_job_id = auth_job_id
			self._state = EAC_STATES.authenticating_eos
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 20-22, warpins: 2 ---
		if self._timeout_at < t then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 23-36, warpins: 1 ---
			Managers.error:report_error(EACError:new("loc_eac_error_timeout_auth_eac"))

			self._state = EAC_STATES.error
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #1 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 37-40, warpins: 1 ---
		if state == EAC_STATES.authenticating_eos then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 41-49, warpins: 1 ---
			local job_id = self._auth_job_id
			local job_status = EOS.job_status(job_id)

			if job_status == EOS.FINISHED then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 50-57, warpins: 1 ---
				local job_result = EOS.job_result(job_id)

				if job_result == EOS.Success then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 58-68, warpins: 1 ---
					self._state = EAC_STATES.ready
					self._authenticated = true
					local user_id = EOS.job_payload_user_id(job_id)
					self._user_id = user_id
					--- END OF BLOCK #0 ---



				else

					-- Decompilation error in this vicinity:
					--- BLOCK #0 69-81, warpins: 1 ---
					Managers.error:report_error(EACError:new("loc_eac_error_auth_eac_failed"))

					self._state = EAC_STATES.error
					--- END OF BLOCK #0 ---



				end

				--- END OF BLOCK #0 ---

				FLOW; TARGET BLOCK #1



				-- Decompilation error in this vicinity:
				--- BLOCK #1 82-87, warpins: 2 ---
				EOS.erase_job(job_id)

				self._auth_job_id = nil
				--- END OF BLOCK #1 ---



			end

			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 88-90, warpins: 2 ---
			if self._timeout_at < t then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 91-104, warpins: 1 ---
				Managers.error:report_error(EACError:new("loc_eac_error_timeout_auth_eac"))

				self._state = EAC_STATES.error
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #1 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 105-108, warpins: 1 ---
			if state == EAC_STATES.in_session then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 109-109, warpins: 1 ---
				--- END OF BLOCK #0 ---



			else

				-- Decompilation error in this vicinity:
				--- BLOCK #0 110-113, warpins: 1 ---
				if state == EAC_STATES.error then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 114-114, warpins: 1 ---
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 114-114, warpins: 7 ---
	return
	--- END OF BLOCK #1 ---



end

return EACClientManager
