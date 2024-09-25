-- chunkname: @scripts/ui/hud/elements/crosshair/templates/crosshair_template_bfg.lua

local Crosshair = require("scripts/ui/utilities/crosshair")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local template = {
	name = "bfg",
}
local SIZE = {
	8,
	10,
}
local HALF_SIZE_X = SIZE[1] * 0.5
local HALF_SIZE_Y = SIZE[2] * 0.5
local SPREAD_DISTANCE = 10
local MIN_OFFSET = HALF_SIZE_Y + 1

local function _crosshair_segment(style_id, angle)
	return table.clone({
		pass_type = "rotated_texture",
		value = "content/ui/materials/hud/crosshairs/arrow_top",
		style_id = style_id,
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			angle = angle,
			offset = {
				0,
				0,
				1,
			},
			size = {
				SIZE[1],
				SIZE[2],
			},
			color = UIHudSettings.color_tint_main_1,
		},
	})
end

template.create_widget_defintion = function (template, scenegraph_id)
	return UIWidget.create_definition({
		Crosshair.hit_indicator_segment("top_left"),
		Crosshair.hit_indicator_segment("bottom_left"),
		Crosshair.hit_indicator_segment("top_right"),
		Crosshair.hit_indicator_segment("bottom_right"),
		Crosshair.weakspot_hit_indicator_segment("top_left"),
		Crosshair.weakspot_hit_indicator_segment("bottom_left"),
		Crosshair.weakspot_hit_indicator_segment("top_right"),
		Crosshair.weakspot_hit_indicator_segment("bottom_right"),
		_crosshair_segment("top", math.rad(0)),
		_crosshair_segment("bottom", math.rad(180)),
		_crosshair_segment("left", math.rad(90)),
		_crosshair_segment("right", math.rad(-90)),
	}, scenegraph_id)
end

template.on_enter = function (widget, template, data)
	return
end

template.update_function = function (parent, ui_renderer, widget, template, crosshair_settings, dt, t, draw_hit_indicator)
	local style = widget.style
	local hit_progress, hit_color, hit_weakspot = parent:hit_indicator()
	local yaw, pitch = parent:_spread_yaw_pitch(dt)

	if yaw and pitch then
		local scalar = SPREAD_DISTANCE * (crosshair_settings.spread_scalar or 1)
		local spread_offset_y = pitch * scalar
		local spread_offset_x = yaw * scalar
		local top_style = style.top

		top_style.offset[1] = 0
		top_style.offset[2] = math.min(-spread_offset_y - HALF_SIZE_Y, -MIN_OFFSET)

		local bottom_style = style.bottom

		bottom_style.offset[1] = 0
		bottom_style.offset[2] = math.max(spread_offset_y + HALF_SIZE_Y, MIN_OFFSET)

		local left_style = style.left

		left_style.offset[1] = math.min(-spread_offset_x - HALF_SIZE_Y, -MIN_OFFSET)
		left_style.offset[2] = 0

		local right_style = style.right

		right_style.offset[1] = math.max(spread_offset_x + HALF_SIZE_Y, MIN_OFFSET)
		right_style.offset[2] = 0
	end

	Crosshair.update_hit_indicator(style, hit_progress, hit_color, hit_weakspot, draw_hit_indicator)
end

return template
