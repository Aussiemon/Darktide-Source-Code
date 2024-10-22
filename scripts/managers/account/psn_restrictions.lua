-- chunkname: @scripts/managers/account/psn_restrictions.lua

local Promise = require("scripts/foundation/utilities/promise")
local PSNRestrictions = class("PSNRestrictions")

local function _check_premium()
	local request_started = false

	return Promise.until_value_is_true(function ()
		if request_started == false then
			Playstation.check_premium_request()

			request_started = true

			return false
		end

		local result = Playstation.check_premium_result()

		if result == nil then
			return false
		end

		if result == true then
			return {
				success = true,
			}
		else
			return {
				success = false,
			}
		end
	end)
end

local function _show_premium_dialogue()
	return Promise.until_value_is_true(function ()
		local status = NpCommerceDialog.update()

		if status == NpCommerceDialog.NONE then
			NpCommerceDialog.initialize()

			return false
		end

		if status == NpCommerceDialog.INITIALIZED then
			NpCommerceDialog.open2(NpCommerceDialog.MODE_PREMIUM, PS5.initial_user_id(), NpMultiplayProperty.CROSS_PLATFORM_PLAY)

			return false
		end

		if status == NpCommerceDialog.RUNNING then
			return false
		end

		local result, authorized = NpCommerceDialog.result()

		NpCommerceDialog.terminate()

		if result == NpCommerceDialog.RESULT_PURCHASED then
			return {
				success = true,
			}
		else
			return {
				success = false,
			}
		end
	end)
end

local function _show_signin_dialogue()
	return Promise.until_value_is_true(function ()
		local status = NpSigninDialog.update()

		if status == NpSigninDialog.NONE then
			NpSigninDialog.initialize()

			return false
		end

		if status == NpSigninDialog.INITIALIZED then
			NpSigninDialog.open()

			return false
		end

		if status == NpSigninDialog.RUNNING then
			return false
		end

		NpSigninDialog.terminate()

		local result = Playstation.signed_in(PS5.initial_user_id())

		if result then
			return {
				success = true,
			}
		else
			return {
				success = false,
			}
		end
	end)
end

PSNRestrictions.psn_signin = function (self)
	if Playstation.signed_in(PS5.initial_user_id()) then
		return Promise.resolved()
	end

	return _show_signin_dialogue():next(function ()
		if Playstation.signed_in(PS5.initial_user_id()) then
			return Promise.resolved()
		else
			return Promise.rejected({})
		end
	end)
end

PSNRestrictions.verify_premium = function (self)
	return _check_premium():next(function (status)
		if status.success then
			return Promise.resolved()
		else
			return _show_premium_dialogue():next(function (status)
				if status.success then
					return Promise.resolved()
				else
					return Promise.rejected({})
				end
			end)
		end
	end)
end

PSNRestrictions.fetch_communication_restrictions = function (self, web_api, account_id)
	local user_id = PS5.initial_user_id()
	local api_group = "communicationRestrictionStatus"
	local path = string.format("/v3/users/%s/communication/restriction/status", account_id)
	local method = WebApi.GET
	local content

	return web_api:send_request(user_id, api_group, path, method, content)
end

return PSNRestrictions
