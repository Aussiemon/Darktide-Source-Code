-- chunkname: @scripts/ui/pass_templates/weapon_details_pass_templates.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WeaponDetailsPassTemplates = {}
local stat_text_style = table.clone(UIFontSettings.body)

stat_text_style.text_horizontal_alignment = "left"
stat_text_style.text_vertical_alignment = "center"
stat_text_style.font_size = 18
stat_text_style.text_horizontal_alignment = "left"
stat_text_style.text_vertical_alignment = "top"
stat_text_style.horizontal_alignment = "left"
stat_text_style.vertical_alignment = "top"
WeaponDetailsPassTemplates.stat_meter = {
	{
		pass_type = "text",
		style_id = "stats_text",
		value = "<n/a>",
		value_id = "stats_text",
		style = stat_text_style,
	},
}

local num_bars = 10
local bar_spacing = 2
local bar_width = 12
local bar_height = 4
local total_bar_length = bar_width * num_bars
local total_bar_spacing = bar_spacing * (num_bars - 1)
local total_length = total_bar_spacing + total_bar_length

for i = 1, num_bars do
	local bar_value_id = "bar_value_" .. i
	local bar_background_id = "bar_background_" .. i
	local x_offset = (i - 1) * bar_width + bar_spacing * (i - 1)

	WeaponDetailsPassTemplates.stat_meter[#WeaponDetailsPassTemplates.stat_meter + 1] = {
		pass_type = "texture",
		value = "content/ui/materials/backgrounds/default_square",
		style_id = bar_value_id,
		style = {
			hdr = true,
			vertical_alignment = "top",
			size = {
				bar_width,
				bar_height,
			},
			offset = {
				x_offset,
				30,
				3,
			},
			color = Color.ui_terminal(255, true),
		},
		visibility_function = function (content)
			local value = content.value

			if value then
				return value >= i
			end

			return true
		end,
	}
	WeaponDetailsPassTemplates.stat_meter[#WeaponDetailsPassTemplates.stat_meter + 1] = {
		pass_type = "texture",
		value = "content/ui/materials/backgrounds/default_square",
		style_id = bar_background_id,
		style = {
			vertical_alignment = "top",
			size = {
				bar_width,
				bar_height,
			},
			offset = {
				x_offset,
				30,
				2,
			},
			color = stat_text_style.text_color,
		},
	}
end

local trait_text_style = table.clone(UIFontSettings.body)

trait_text_style.text_horizontal_alignment = "left"
trait_text_style.text_vertical_alignment = "center"
trait_text_style.horizontal_alignment = "left"
trait_text_style.vertical_alignment = "center"
trait_text_style.offset = {
	80,
	0,
	2,
}
trait_text_style.font_size = 18

local default_button_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_select,
}

WeaponDetailsPassTemplates.seal_slot = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		content = default_button_content,
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/buffs/frames/background",
		value_id = "background",
		style = {
			color = Color.ui_grey_medium(153, true),
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "texture",
		value = "content/ui/materials/icons/buffs/frames/inner_line_thin",
		value_id = "frame",
		style = {
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				2,
			},
		},
	},
	{
		pass_type = "rect",
		style = {
			color = {
				200,
				40,
				40,
				40,
			},
			offset = {
				0,
				0,
				0,
			},
		},
		change_function = function (content, style)
			style.color[1] = math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress) * 100
		end,
	},
}
WeaponDetailsPassTemplates.trait_slot_size = {
	60,
	60,
}
WeaponDetailsPassTemplates.trait_slot = {
	{
		content_id = "hotspot",
		pass_type = "hotspot",
		style_id = "hotspot",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "trait_empty",
		value = "content/ui/materials/icons/traits/empty",
		value_id = "trait_empty",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
		},
		visibility_function = function (content)
			return content.trait == nil
		end,
	},
	{
		pass_type = "texture",
		style_id = "trait_used",
		value = "content/ui/materials/icons/traits/container",
		value_id = "trait_used",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				80,
				80,
			},
		},
		visibility_function = function (content)
			return content.trait ~= nil
		end,
	},
	{
		pass_type = "texture",
		style_id = "trait_locked",
		value = "content/ui/materials/icons/traits/frames/addon_lock",
		value_id = "trait_locked",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			offset = {
				0,
				0,
				3,
			},
			size = {
				80,
				80,
			},
		},
		visibility_function = function (content)
			return content.trait and content.trait.locked
		end,
	},
}

return WeaponDetailsPassTemplates
