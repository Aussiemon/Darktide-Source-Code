-- chunkname: @scripts/backend/mission_happenings.lua

local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {
	"fetch_current",
	"fetch_all_happenings",
}
local MissionHappenings = class("MissionHappenings")

MissionHappenings.init = function (self)
	return
end

MissionHappenings.fetch_current = function (self)
	return Managers.backend:title_request("/mission-event"):next(function (data)
		return data.body.event
	end)
end

MissionHappenings.fetch_all_happenings = function (self)
	return Managers.backend:title_request("/mission-events"):next(function (data)
		return data.body
	end)
end

implements(MissionHappenings, Interface)

return MissionHappenings
