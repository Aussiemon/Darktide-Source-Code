-- chunkname: @scripts/ui/views/mission_board_view_pj/mission_board_view_themes.lua

local Styles = require("scripts/ui/views/mission_board_view_pj/mission_board_view_styles")
local InputDevice = require("scripts/managers/input/input_device")
local UIWidget = require("scripts/managers/ui/ui_widget")
local MissionBoardThemes = {}
local screen_decorations_passes = {
	{
		pass_type = "rect",
		style_id = "overlay"
	},
	{
		style_id = "overlay_top",
		pass_type = "rect",
		visibility_function = function ()
			return InputDevice.gamepad_active
		end
	},
	{
		value = "content/ui/materials/frames/screen/mission_board_01_lower",
		style_id = "corner_left",
		pass_type = "texture",
		scenegraph_id = "corner_bottom_left"
	},
	{
		value = "content/ui/materials/frames/screen/mission_board_01_lower",
		style_id = "corner_right",
		pass_type = "texture_uv",
		scenegraph_id = "corner_bottom_right"
	}
}
local info_box_passes = {
	{
		pass_type = "rect",
		style_id = "background"
	},
	{
		value = "content/ui/materials/frames/frame_tile_2px",
		style_id = "frame",
		pass_type = "texture"
	},
	{
		value = "",
		value_id = "text",
		pass_type = "text",
		style_id = "text"
	}
}
local math_random = math.random

local function add_noise(x, y, min, max)
	local min = min or -20
	local max = max or 20
	local noise_x = math_random(min, max * 0.5)
	local noise_y = math_random(min, max * 2)

	return {
		x + noise_x,
		y + noise_y
	}
end

MissionBoardThemes.default = {
	widgets = {},
	slots = {
		small = {
			{
				zoom = 1,
				rotation = 28.125,
				position = add_noise(200, 80, -20, 60),
				category_priority = {
					"story"
				}
			},
			{
				zoom = 1,
				rotation = 22.5,
				position = add_noise(400, 80, -20, 60),
				category_priority = {
					"story"
				}
			},
			{
				zoom = 1,
				rotation = 16.875,
				position = add_noise(600, 80, -20, 60),
				category_priority = {
					"story"
				}
			},
			{
				zoom = 1,
				rotation = 11.25,
				position = add_noise(800, 80, -20, 60),
				category_priority = {
					"story"
				}
			},
			{
				zoom = 1,
				rotation = 5.625,
				position = add_noise(1000, 100, -20, 60)
			},
			{
				zoom = 1,
				rotation = 45,
				position = add_noise(0, 400, -20, 60)
			},
			{
				zoom = 1,
				rotation = 37.5,
				position = add_noise(200, 400, -20, 60)
			},
			{
				zoom = 1,
				rotation = 30,
				position = add_noise(400, 400, -20, 60)
			},
			{
				zoom = 1,
				rotation = 22.5,
				position = add_noise(600, 400, -20, 60)
			},
			{
				zoom = 1,
				rotation = 15,
				position = add_noise(800, 400, -20, 60)
			},
			{
				zoom = 1,
				rotation = 7.5,
				position = add_noise(1000, 400, -20, 60)
			},
			{
				zoom = 1,
				rotation = 60,
				position = add_noise(0, 680, -20, 60)
			},
			{
				zoom = 1,
				rotation = 50,
				position = add_noise(200, 680, -20, 60)
			},
			{
				zoom = 1,
				rotation = 40,
				position = add_noise(400, 680, -20, 60)
			},
			{
				zoom = 1,
				rotation = 30,
				position = add_noise(600, 680, -20, 60)
			},
			{
				zoom = 1,
				rotation = 33.75,
				position = add_noise(0, 80, -20, 60)
			}
		},
		large = {
			{
				position = {
					458,
					384
				}
			}
		},
		static = {
			{
				position = {
					800,
					690
				}
			}
		}
	},
	view_data = {
		palette_name = "default"
	}
}
MissionBoardThemes.auric = table.clone(MissionBoardThemes.default)
MissionBoardThemes.auric.view_data = {
	palette_name = "auric"
}

for _, theme in pairs(MissionBoardThemes) do
	for group, slots in pairs(theme.slots) do
		for index, slot in ipairs(slots) do
			slot.group = group
			slot.index = index
		end
	end
end

return settings("MissionBoardViewThemes", MissionBoardThemes)
