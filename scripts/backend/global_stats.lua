-- chunkname: @scripts/backend/global_stats.lua

local GlobalStats = class("GlobalStats")

GlobalStats.get_category = function (self, category_name)
	return Managers.backend:title_request(string.format("/globaldata/stats/%s/all", category_name)):next(function (response)
		return response and response.body
	end)
end

return GlobalStats
