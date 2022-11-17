local UIResolution = require("scripts/managers/ui/ui_resolution")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local LoadingIcon = {}

local function get_resolution()
	local width, height, scale = nil

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

LoadingIcon.render = function (gui)
	local resolution_width, resolution_height, resolution_scale = get_resolution()
	local icon_width = 256 * resolution_scale
	local icon_height = 256 * resolution_scale
	local x_offset = -25 * resolution_scale
	local y_offset = -25 * resolution_scale
	local position = Vector3(x_offset + resolution_width - icon_width, y_offset + resolution_height - icon_height, 1000)
	local icon_size = Vector2(icon_width, icon_height)

	Gui.bitmap(gui, "content/ui/materials/loading/loading_icon", position, icon_size, Color(255, 255, 255, 255))
end

return LoadingIcon
