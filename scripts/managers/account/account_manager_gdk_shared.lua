-- chunkname: @scripts/managers/account/account_manager_gdk_shared.lua

local Promise = require("scripts/foundation/utilities/promise")
local AccountManagerGDKShared = class("AccountManagerGDKShared")

AccountManagerGDKShared.is_owner_of = function (self, product_id)
	local async_job, error_code = XboxLive.acquire_license_for_durables_async(product_id)

	if not async_job then
		return Promise.rejected({
			message = string.format("acquire_license_for_durables_async returned error_code=0x%x", error_code),
		})
	end

	return Promise.until_value_is_true(function ()
		local result, error_code = XboxLive.acquire_license_for_durables_async_result(async_job)

		if result == nil and error_code == nil then
			return false
		end

		if result ~= nil then
			return {
				is_owner = result,
			}
		end

		Log.info("AccountManagerGDKShared", "ACQUIRE LICENSE RESULT for '%s' resulted in error '%x'", product_id, error_code)

		return {
			is_owner = false,
		}
	end)
end

return AccountManagerGDKShared
