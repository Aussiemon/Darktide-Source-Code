-- chunkname: @scripts/backend/hordes.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local Interface = {}
local Hordes = class("Hordes")

Hordes.init = function (self)
	return
end

Hordes._get_deactivated_buffs = function (self)
	return Managers.backend:title_request(BackendUtilities.url_builder("/data/horde/buffs"):to_string()):next(function (data)
		return data.body
	end)
end

Hordes.deactivate_buffs_from_the_backend = function (self)
	return self:_get_deactivated_buffs():next(function (result)
		local deactivated_buffs = {}
		local deactivatedBuffsEnabled = result.deactivatedBuffs.deactivatedBuffsEnabled

		if deactivatedBuffsEnabled then
			deactivated_buffs = result.deactivatedBuffs.deactivatedBuffsList
		end

		return deactivated_buffs
	end):catch(function (err)
		return Promise.rejected(err)
	end)
end

return Hordes
