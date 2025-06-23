-- chunkname: @scripts/backend/dlc_license.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local DLCLicense = class("DLCLicense")

DLCLicense.CLIENT_GET_DLC_STATUS_WHITELIST = {
	[1] = "licensed"
}
DLCLicense.CLIENT_POST_DLC_STATUS_WHITELIST = {
	[1] = "licensed"
}

DLCLicense.licensed_products_get = function (account_id, player_profile, platform_id)
	platform_id = platform_id or Managers.backend.interfaces.external_payment:get_payment_platform()

	local builder = BackendUtilities.url_builder():path("/store/"):path(account_id):path("/licenses"):query("platform", platform_id)
	local dlc_licenses = {}

	dlc_licenses.archetypes = {
		player_profile.archetype.name
	}

	for k, v in pairs(dlc_licenses) do
		builder:query(k, v)
	end

	return Managers.backend:title_request(builder:to_string(), {
		method = "GET"
	}):next(function (response)
		return response.body
	end):catch(function (error)
		Log.error("DLCLicense", "Error getting license info '%d'", error.code)

		return Promise.rejected({
			error_code = "failed_dlc_license_check_backend",
			error = error
		})
	end)
end

DLCLicense.licensed_products_update = function (account_id, product_ids, challenge_string)
	local platform_id = Managers.backend.interfaces.external_payment:get_payment_platform()
	local builder = BackendUtilities.url_builder():path("/store/"):path(account_id):path("/licenses")
	local request_body = {}

	request_body.productIds = product_ids
	request_body.platform = platform_id

	return Managers.backend.interfaces.external_payment:get_platform_token():next(function (platform_token)
		local headers = {}

		if platform_token then
			headers["platform-token"] = platform_token
		end

		return Managers.backend.interfaces.external_payment:query_license_token(product_ids, challenge_string):next(function (license_token)
			if license_token then
				request_body.licenseToken = license_token
			end

			return Managers.backend:title_request(builder:to_string(), {
				method = "POST",
				body = request_body,
				headers = headers
			}):next(function (response)
				return response.body
			end):catch(function (error)
				Log.error("DLCLicense", "Error updating license", tostring(error))

				return Promise.rejected({
					error_code = "failed_dlc_license_check_backend",
					error = error
				})
			end)
		end):catch(function (error)
			Log.error("DLCLicense", "Error querying license token", tostring(error))

			return Promise.rejected({
				error_code = "failed_dlc_license_check_engine",
				error = error
			})
		end)
	end):catch(function (error)
		Log.error("DLCLicense", "Error querying platform token", tostring(error))

		return Promise.rejected({
			error_code = "failed_dlc_license_check_engine",
			error = error
		})
	end)
end

return DLCLicense
