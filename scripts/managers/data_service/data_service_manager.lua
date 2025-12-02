-- chunkname: @scripts/managers/data_service/data_service_manager.lua

local BackendInterface = require("scripts/backend/backend_interface")
local SERVICES = {
	mission_board = require("scripts/managers/data_service/services/mission_board_service"),
	talents = require("scripts/managers/data_service/services/talents_service"),
	profiles = require("scripts/managers/data_service/services/profiles_service"),
	account = require("scripts/managers/data_service/services/account_service"),
	store = require("scripts/managers/data_service/services/store_service"),
	gear = require("scripts/managers/data_service/services/gear_service"),
	global_stats = require("scripts/managers/data_service/services/global_stats_service"),
	social = require("scripts/managers/data_service/services/social_service"),
	crafting = require("scripts/managers/data_service/services/crafting_service"),
	contracts = require("scripts/managers/data_service/services/contracts_service"),
	news = require("scripts/managers/data_service/services/news_service"),
	mastery = require("scripts/managers/data_service/services/mastery_service"),
	penance_track = require("scripts/managers/data_service/services/penance_track_service"),
	player_survey = require("scripts/managers/data_service/services/player_survey_service"),
	havoc = require("scripts/managers/data_service/services/havoc_service"),
	region_latency = require("scripts/managers/data_service/services/region_latency_service"),
	specialization_talent = require("scripts/managers/data_service/services/specialization_talent_service"),
}
local DataServiceManager = class("DataServiceManager")

DataServiceManager.init = function (self)
	local backend_interface = BackendInterface:new()

	for service_name, _class in pairs(SERVICES) do
		self[service_name] = _class:new(backend_interface)
	end
end

DataServiceManager.destroy = function (self)
	for service_name, _ in pairs(SERVICES) do
		self[service_name]:delete()

		self[service_name] = nil
	end
end

DataServiceManager.reset = function (self)
	for service_name, _ in pairs(SERVICES) do
		if self[service_name].reset then
			self[service_name]:reset()
		end
	end
end

return DataServiceManager
