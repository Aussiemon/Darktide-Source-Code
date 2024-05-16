-- chunkname: @scripts/utilities/level_props/level_props_broadphase.lua

local LevelPropsBroadphase = {}
local DEFAULT_RADIUS = 30
local BROADPHASE_RESULTS = {}

LevelPropsBroadphase.check_units_nearby = function (position, radius, side_name)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local query_radius = radius or DEFAULT_RADIUS
	local query_position = position

	if side_name then
		table.clear(BROADPHASE_RESULTS)

		local num_results = broadphase.query(broadphase, query_position, query_radius, BROADPHASE_RESULTS, side_name)

		if num_results > 0 then
			return true
		end
	else
		local game_mode_manager = Managers.state.game_mode
		local side_compositions = game_mode_manager:side_compositions()

		for _, side in ipairs(side_compositions) do
			table.clear(BROADPHASE_RESULTS)

			local num_results = broadphase.query(broadphase, query_position, query_radius, BROADPHASE_RESULTS, side.name)

			if num_results > 0 then
				return true
			end
		end
	end

	return false
end

return LevelPropsBroadphase
