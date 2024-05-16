-- chunkname: @scripts/ui/pass_templates/bar_pass_templates.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local BarPassTemplates = {}

local function bar_style_content_change_function(content, style)
	style.material_values.progression = content.progress or 0
end

BarPassTemplates.experience_bar = {
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/bars/heavy/frame_back",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size_addition = {
				48,
				30,
			},
			offset = {
				0,
				0,
				0,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
	},
	{
		pass_type = "texture_uv",
		style_id = "bar",
		value = "content/ui/materials/bars/heavy/fill_electric",
		style = {
			horizontal_alignment = "left",
			size = {},
			material_values = {
				progression = 0,
			},
			uvs = {
				{
					0,
					0,
				},
				{
					1,
					1,
				},
			},
			offset = {
				0,
				0,
				1,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
		change_function = function (content, style)
			local progress = content.progress or 0
			local bar_length = content.bar_length or 0

			style.material_values.progression = progress
			style.uvs[2][1] = progress
			style.size[1] = bar_length * progress
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/bars/heavy/frame_top",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size_addition = {
				48,
				30,
			},
			offset = {
				0,
				0,
				2,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "frame_smoke",
		value = "content/ui/materials/bars/heavy/frame_effect_smoke",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size_addition = {
				122,
				110,
			},
			offset = {
				0,
				0,
				3,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "frame_effect",
		value = "content/ui/materials/bars/heavy/frame_effect_electric",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size_addition = {
				122,
				110,
			},
			offset = {
				0,
				0,
				4,
			},
			color = {
				255,
				255,
				255,
				255,
			},
			material_values = {
				progression = 0,
			},
		},
		change_function = bar_style_content_change_function,
	},
	{
		pass_type = "texture",
		style_id = "end",
		value = "content/ui/materials/bars/heavy/fill_end",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			size_addition = {
				0,
				30,
			},
			size = {
				96,
			},
			offset = {
				0,
				0,
				6,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
		change_function = function (content, style)
			local progress = content.progress or 0
			local bar_length = content.bar_length or 0

			style.offset[1] = bar_length * progress - 49

			local alpha_multiplier = math.clamp(progress / 0.2, 0, 1)

			style.color[1] = 255 * alpha_multiplier
		end,
	},
}

local weapon_bar_text_style = table.clone(UIFontSettings.body_small)

weapon_bar_text_style.text_horizontal_alignment = "left"
weapon_bar_text_style.text_vertical_alignment = "center"

local weapon_stats_bar_length = 200
local weapon_stats_bar_background_margin = 4

BarPassTemplates.weapon_stats_bar = {
	{
		pass_type = "text",
		value = "text",
		value_id = "text",
		style = weapon_bar_text_style,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/bars/simple/frame",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				weapon_stats_bar_length,
			},
			size_addition = {
				weapon_stats_bar_background_margin * 2,
				weapon_stats_bar_background_margin * 2,
			},
			offset = {
				0,
				0,
				0,
			},
			color = Color.white(255, true),
		},
	},
	{
		pass_type = "texture",
		style_id = "bar",
		value = "content/ui/materials/bars/simple/fill",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				weapon_stats_bar_length,
			},
			offset = {
				-weapon_stats_bar_background_margin,
				0,
				1,
			},
			color = Color.white(255, true),
		},
		change_function = function (content, style)
			local progress = content.progress or 0
			local new_bar_length = weapon_stats_bar_length * progress

			style.size[1] = new_bar_length
			style.offset[1] = -weapon_stats_bar_background_margin - (weapon_stats_bar_length - new_bar_length)
		end,
	},
	{
		pass_type = "texture",
		style_id = "end",
		value = "content/ui/materials/bars/simple/end",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				12,
				16,
			},
			offset = {
				0,
				0,
				2,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
		change_function = function (content, style)
			local progress = content.progress or 0

			style.offset[1] = -(weapon_stats_bar_length - weapon_stats_bar_length * progress + weapon_stats_bar_background_margin) + 6

			local alpha_multiplier = math.clamp(progress / 0.2, 0, 1)

			style.color[1] = 255 * alpha_multiplier
		end,
	},
}

local character_menu_experience_bar_background_margin = 2

BarPassTemplates.character_menu_experience_bar = {
	{
		pass_type = "texture",
		style_id = "bar",
		value = "content/ui/materials/bars/exp_fill",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			size = {
				0,
			},
			offset = {
				0,
				0,
				1,
			},
			color = {
				255,
				75,
				169,
				208,
			},
		},
		change_function = function (content, style)
			local progress = content.progress or 0
			local bar_length = (content.bar_length or 0) - character_menu_experience_bar_background_margin * 2

			style.size[1] = bar_length * progress
		end,
	},
	{
		pass_type = "texture",
		style_id = "end",
		value = "content/ui/materials/bars/simple/end",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "center",
			size = {
				12,
			},
			size_addition = {
				0,
				24,
			},
			offset = {
				0,
				0,
				2,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
		change_function = function (content, style)
			local progress = content.progress or 0
			local bar_length = content.bar_length or 0

			style.offset[1] = bar_length * progress - 8

			local alpha_multiplier = math.clamp(progress / 0.2, 0, 1)

			style.color[1] = 255 * alpha_multiplier
		end,
	},
}

return BarPassTemplates
