-- chunkname: @scripts/managers/ui/ui_fonts.lua

local font_vertical_base = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
local font_height_base = "A"
local font_heights = {}
local UIFonts = {}

UIFonts.scaled_size = function (font_size, scale)
	local scaled_size = math.max(font_size * scale, 1)

	return scaled_size
end

UIFonts.data_by_type = function (font_type)
	return Managers.font:data_by_type(font_type)
end

UIFonts.font_height = function (gui, font_type, font_size)
	font_size = math.ceil(font_size)
	font_heights[font_type] = font_heights[font_type] or {}

	local height_data = font_heights[font_type][font_size]

	if height_data then
		return height_data[1], height_data[2], height_data[3]
	end

	local font_data = UIFonts.data_by_type(font_type)
	local font = font_data.path
	local min, max, caret = Gui.slug_text_extents(gui, font_vertical_base, font, font_size)
	local base_min, base_max, caret = Gui.slug_text_extents(gui, font_height_base, font, font_size)
	local height = base_max[3] - base_min[3]

	font_heights[font_type][font_size] = {
		height,
		min.y,
		max.y,
	}

	return height, min.y, max.y
end

local text_horizontal_alignment_lookup = {
	left = Gui.HorizontalAlignLeft,
	center = Gui.HorizontalAlignCenter,
	right = Gui.HorizontalAlignRight,
}
local text_vertical_alignment_lookup = {
	top = Gui.VerticalAlignTop,
	center = Gui.VerticalAlignCenter,
	bottom = Gui.VerticalAlignBottom,
}

UIFonts.get_font_options_by_style = function (style, destination)
	destination = destination or {}
	destination.line_spacing = style.line_spacing
	destination.character_spacing = style.character_spacing
	destination.horizontal_alignment = text_horizontal_alignment_lookup[style.text_horizontal_alignment]
	destination.vertical_alignment = text_vertical_alignment_lookup[style.text_vertical_alignment]
	destination.shadow = style.drop_shadow

	return destination
end

return UIFonts
