-- chunkname: @scripts/ui/loading_reason.lua

local UIResolution = require("scripts/managers/ui/ui_resolution")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local LoadingReason = class("LoadingReason")

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

LoadingReason.init = function (self)
	return
end

LoadingReason.render = function (self, gui, wait_description, wait_time, text_opacity)
	local resolution_width, resolution_height, resolution_scale = get_resolution()
	local anchor_x, anchor_y = self:_calculate_anchor_point(resolution_width, resolution_height, resolution_scale)

	self:_render_icon(gui, anchor_x, anchor_y, resolution_scale)

	if wait_description then
		self:_render_text(gui, anchor_x, anchor_y, resolution_scale, wait_description, text_opacity)
	end
end

LoadingReason._calculate_anchor_point = function (self, resolution_width, resolution_height, resolution_scale)
	local anchor_x = resolution_width - 25 * resolution_scale
	local anchor_y = resolution_height - 25 * resolution_scale

	return anchor_x, anchor_y
end

LoadingReason._render_icon = function (self, gui, anchor_x, anchor_y, resolution_scale)
	local icon_width = 256 * resolution_scale
	local icon_height = 256 * resolution_scale
	local offset_x = 0
	local offset_y = -25 * resolution_scale
	local position = Vector3(anchor_x + offset_x - icon_width, anchor_y + offset_y - icon_height, 999)
	local icon_size = Vector2(icon_width, icon_height)

	Gui.bitmap(gui, "content/ui/materials/loading/loading_icon", position, icon_size, Color(255, 255, 255, 255))
end

local font_options = {
	shadow = true,
}

LoadingReason._render_text = function (self, gui, anchor_x, anchor_y, resolution_scale, text, text_opacity)
	local font_data = Managers.font:data_by_type("machine_medium")
	local font_type = font_data.path
	local font_size = 24 * resolution_scale
	local text_min, text_max, _ = Gui2.slug_text_extents(gui, text, font_type, font_size, font_options)
	local text_width = text_max.x - text_min.x
	local offset_x = -75 * resolution_scale
	local offset_y = -60 * resolution_scale
	local position = Vector3(anchor_x + offset_x - text_width, anchor_y + offset_y - font_size, 999)

	font_options.color = Color(text_opacity, 255, 235, 150)

	Gui2.slug_text(gui, text, font_type, font_size, position, Vector2(math.huge, math.huge), font_options)
end

return LoadingReason
