-- chunkname: @scripts/multiplayer/connection/local_states/local_dlc_verification_state.lua

local PromiseContainer = require("scripts/utilities/ui/promise_container")
local Promise = require("scripts/foundation/utilities/promise")
local LocalDLCVerificationState = class("LocalDLCVerificationState")
local RPCS = {
	"rpc_dlc_verification_host_response",
}

LocalDLCVerificationState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._promise_container = PromiseContainer:new()
	self._backend_interface = Managers.backend.interfaces.dlc_license
	self._platform = Managers.backend.interfaces.external_payment:get_payment_platform()
	self._time = 0

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

LocalDLCVerificationState.enter = function (self)
	local profile = Managers.player:local_player_backend_profile()

	if profile.archetype.dlc_settings == nil then
		RPC.rpc_dlc_verification_client_done(self._shared_state.channel_id, self._platform)

		return
	end

	self._promise_container:cancel_on_destroy(Managers.backend:authenticate():next(function (account)
		self._account_id = account.sub

		self._backend_interface.licensed_products_get(self._account_id, profile):next(callback(self, "_cb_on_quick_license_check")):catch(callback(self, "_cb_on_quick_license_check_error"))
	end))
end

LocalDLCVerificationState.destroy = function (self)
	self._promise_container:delete()
	self._shared_state.event_delegate:unregister_channel_events(self._shared_state.channel_id, unpack(RPCS))
end

LocalDLCVerificationState.update = function (self, dt)
	local channel_state, reason = Network.channel_state(self._shared_state.channel_id)

	if channel_state == "disconnecting" or channel_state == "disconnected" then
		return "disconnected", {
			engine_reason = reason,
		}
	end

	if self._license_check_error then
		local error = self._license_check_error[1] and self._license_check_error[1] or self._license_check_error
		local error_code = error.error_code and error.error_code or "failed_dlc_license_check"

		return "error", {
			game_reason = error_code,
		}
	end

	if self._done then
		return "done"
	end

	self._time = self._time + dt

	if self._time > self._shared_state.timeout then
		Log.info("LocalDLCVerificationState", "Timeout waiting for dlc ownership check")

		return "timeout", {
			game_reason = "timeout",
		}
	end
end

LocalDLCVerificationState._cb_on_quick_license_check = function (self, response)
	local products = response.products
	local promises = {}

	for _, product in ipairs(products) do
		if not table.contains(self._backend_interface.CLIENT_GET_DLC_STATUS_WHITELIST, product.status) then
			local promise = self._promise_container:cancel_on_destroy(self._backend_interface.licensed_products_update(self._account_id, product.fulfillingIds, product.challenge))

			table.insert(promises, promise)
		end
	end

	if #promises == 0 then
		RPC.rpc_dlc_verification_client_done(self._shared_state.channel_id, self._platform)

		return
	end

	Promise.all(unpack(promises)):next(callback(self, "_cb_on_post_license_response")):catch(callback(self, "_cb_on_post_license_error"))
end

LocalDLCVerificationState._cb_on_quick_license_check_error = function (self, error)
	self._license_check_error = error
end

LocalDLCVerificationState._cb_on_post_license_response = function (self, responses)
	for _, response in ipairs(responses) do
		for _, product in ipairs(response.products) do
			if not table.contains(self._backend_interface.CLIENT_POST_DLC_STATUS_WHITELIST, product.status) then
				self._license_check_error = {
					error_code = "failed_dlc_license_check",
				}

				return
			end
		end
	end

	RPC.rpc_dlc_verification_client_done(self._shared_state.channel_id, self._platform)
end

LocalDLCVerificationState._cb_on_post_license_error = function (self, errors)
	self._license_check_error = errors
end

LocalDLCVerificationState.rpc_dlc_verification_host_response = function (self, channel_id, error_code)
	self._done = true

	if error_code then
		self._license_check_error = {
			error_code = error_code,
		}
	end
end

return LocalDLCVerificationState
