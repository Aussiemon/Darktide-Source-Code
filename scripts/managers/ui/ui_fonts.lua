local font_vertical_base = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
local font_height_base = "A"
local font_heights = {}
local font_definitions = require("scripts/managers/ui/ui_fonts_definitions")
local UIFonts = {
	scaled_size = function (font_size, scale)
		local scaled_size = math.max(font_size * scale, 1)

		return scaled_size
	end,
	data_by_type = function (font_type)
		return font_definitions[font_type]
	end,
	font_height = function (gui, font_type, font_size)
		font_size = math.ceil(font_size)
		font_heights[font_type] = font_heights[font_type] or {}
		local height_data = font_heights[font_type][font_size]

		if height_data then
			return height_data[1], height_data[2], height_data[3]
		end

		local font_data = font_definitions[font_type]
		local font = font_data.path
		local min, max, caret = Gui.slug_text_extents(gui, font_vertical_base, font, font_size)
		local base_min, base_max, caret = Gui.slug_text_extents(gui, font_height_base, font, font_size)
		local height = base_max[3] - base_min[3]
		font_heights[font_type][font_size] = {
			height,
			min.y,
			max.y
		}

		return height, min.y, max.y
	end
}
local text_horizontal_alignment_lookup = {
	left = "horizontal_align_left",
	center = "horizontal_align_center",
	right = "horizontal_align_right"
}
local text_vertical_alignment_lookup = {
	top = "vertical_align_top",
	bottom = "vertical_align_bottom",
	center = "vertical_align_center"
}

UIFonts.get_font_options_by_style = function (style, destination)
	destination = destination or {}
	local line_spacing = style.line_spacing

	if line_spacing then
		destination[#destination + 1] = "line_spacing"
		destination[#destination + 1] = line_spacing
	end

	local character_spacing = style.character_spacing

	if character_spacing then
		destination[#destination + 1] = "character_spacing"
		destination[#destination + 1] = character_spacing
	end

	local text_horizontal_alignment = style.text_horizontal_alignment

	if text_horizontal_alignment then
		destination[#destination + 1] = text_horizontal_alignment_lookup[text_horizontal_alignment]
	end

	local text_vertical_alignment = style.text_vertical_alignment

	if text_vertical_alignment then
		destination[#destination + 1] = text_vertical_alignment_lookup[text_vertical_alignment]
	end

	local drop_shadow = style.drop_shadow

	if drop_shadow then
		destination[#destination + 1] = "shadow"
	end

	return destination
end

return UIFonts
