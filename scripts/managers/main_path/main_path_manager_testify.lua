local MainPathQueries = require("scripts/utilities/main_path_queries")
local MainPathManagerTestify = {
	main_path_position_from_distance = function (distance, main_path_manager)
		local position = MainPathQueries.position_from_distance(distance)

		return Vector3Box(position)
	end,
	total_main_path_distance = function ()
		if not MainPathQueries.is_main_path_registered() then
			return Testify.RETRY
		end

		return MainPathQueries.total_path_distance()
	end
}

return MainPathManagerTestify
