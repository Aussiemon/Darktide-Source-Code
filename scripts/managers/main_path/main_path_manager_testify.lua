-- chunkname: @scripts/managers/main_path/main_path_manager_testify.lua

local MainPathQueries = require("scripts/utilities/main_path_queries")
local MainPathManagerTestify = {
	generate_unified_main_path = function (main_path_manager)
		local main_path_segments = main_path_manager:main_path_segments()

		return MainPathQueries.generate_unified_main_path(main_path_segments)
	end,
	main_path_position_from_distance = function (_, distance)
		local position = MainPathQueries.position_from_distance(distance)

		return Vector3Box(position)
	end,
	total_main_path_distance = function ()
		if not MainPathQueries.is_main_path_registered() then
			return Testify.RETRY
		end

		return MainPathQueries.total_path_distance()
	end,
	check_isolated_islands = function (main_path_manager)
		if not MainPathQueries.is_main_path_registered() then
			return Testify.RETRY
		end

		local isolated_islands = main_path_manager:find_isolated_islands()

		return table.is_empty(isolated_islands)
	end,
}

return MainPathManagerTestify
