-- chunkname: @scripts/utilities/side_color.lua

local SideColor = {}

SideColor.minion_color = function (unit)
	local game_mode_manager = Managers.state.game_mode
	local use_side_color = game_mode_manager:use_side_color()

	if not use_side_color then
		return nil
	end

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local color = side:color()

	return color
end

return SideColor
