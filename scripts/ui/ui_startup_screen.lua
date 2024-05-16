-- chunkname: @scripts/ui/ui_startup_screen.lua

local UIResolution = require("scripts/managers/ui/ui_resolution")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIStartupScreen = {}

local function get_resolution()
	local width, height, scale

	if rawget(_G, "RESOLUTION_LOOKUP") then
		scale = RESOLUTION_LOOKUP.scale
		width = RESOLUTION_LOOKUP.width
		height = RESOLUTION_LOOKUP.height
	else
		width, height = Application.back_buffer_size()

		local width_scale = width / UIResolution.width_fragments()
		local height_scale = height / UIResolution.height_fragments()

		scale = math.min(width_scale, height_scale)
	end

	return width, height, scale
end

UIStartupScreen.render = function (gui)
	local resolution_width, resolution_height, resolution_scale = get_resolution()
	local icon_width = 256 * resolution_scale
	local icon_height = 256 * resolution_scale
	local x_offset = -25 * resolution_scale
	local y_offset = -25 * resolution_scale
	local position = Vector3(x_offset + (resolution_width - icon_width), y_offset + (resolution_height - icon_height), 999)
	local icon_size = Vector2(icon_width, icon_height)

	Gui.bitmap(gui, "content/ui/materials/loading/loading_icon", position, icon_size)
	Gui.rect(gui, Vector3.zero(), Vector3(resolution_width, resolution_height, 0), Color(255, 0, 0, 0))
end

return UIStartupScreen
