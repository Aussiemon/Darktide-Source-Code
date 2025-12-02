-- chunkname: @scripts/backend/hordes.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local Interface = {}
local Hordes = class("Hordes")

Hordes.init = function (self)
	return
end

Hordes._get_horde_settings = function (self)
	local url = BackendUtilities.url_builder("/data/horde/settings"):to_string()

	return Managers.backend:title_request(url):next(function (data)
		return data.body
	end):catch(function (err)
		Log.info("Hordes", "Error in _get_horde_settings:", err)

		return Promise.rejected(err)
	end)
end

Hordes.get_horde_setting_from_the_backend = function (self)
	return self:_get_horde_settings():next(function (result)
		if not result then
			Log.info("Hordes", "Missing 'settings' from backend.")

			return {}
		end

		if result.deactivatedBuffs and result.deactivatedBuffs.deactivatedBuffsList then
			result.deactivated_buffs = {
				deactivated_buffs_enabled = result.deactivatedBuffs.deactivatedBuffsEnabled,
				deactivated_buffs_list = result.deactivatedBuffs.deactivatedBuffsList,
			}
			result.deactivatedBuffs = nil
		end

		return result
	end):catch(function (err)
		Log.info("Hordes", "Error fetching settings:", err)

		return Promise.rejected(err)
	end)
end

return Hordes
