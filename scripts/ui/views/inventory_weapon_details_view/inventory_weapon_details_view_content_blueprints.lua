-- chunkname: @scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_content_blueprints.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local InventoryWeaponDetailsViewSettings = require("scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view_settings")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local grid_size = InventoryWeaponDetailsViewSettings.grid_size
local grid_content_edge_margin = InventoryWeaponDetailsViewSettings.grid_content_edge_margin
local max_width = grid_size[1] - grid_content_edge_margin * 2
local stats_size = InventoryWeaponDetailsViewSettings.stats_size
local stats_horizontal_spacing_size = {
	(grid_size[1] - stats_size[1]) * 0.5,
	InventoryWeaponDetailsViewSettings.stats_size[2]
}
local item_header_display_name_font_style = table.clone(UIFontSettings.header_3)

item_header_display_name_font_style.offset = {
	0,
	-75,
	3
}
item_header_display_name_font_style.text_horizontal_alignment = "center"
item_header_display_name_font_style.text_vertical_alignment = "bottom"

local item_header_sub_display_name_font_style = table.clone(UIFontSettings.body_small)

item_header_sub_display_name_font_style.offset = {
	0,
	-55,
	3
}
item_header_sub_display_name_font_style.text_horizontal_alignment = "center"
item_header_sub_display_name_font_style.text_vertical_alignment = "bottom"

local item_description_font_style = table.clone(UIFontSettings.body_small)

item_description_font_style.offset = {
	0,
	0,
	3
}
item_description_font_style.text_horizontal_alignment = "center"
item_description_font_style.text_vertical_alignment = "center"

local item_category_header_font_style = table.clone(UIFontSettings.header_3)

item_category_header_font_style.offset = {
	0,
	0,
	3
}
item_category_header_font_style.text_horizontal_alignment = "left"
item_category_header_font_style.text_vertical_alignment = "bottom"
item_category_header_font_style.text_color = Color.ui_grey_light(255, true)

local item_property_value_font_style = table.clone(UIFontSettings.body_small)

item_property_value_font_style.offset = {
	50,
	0,
	3
}
item_property_value_font_style.text_horizontal_alignment = "left"
item_property_value_font_style.text_vertical_alignment = "center"
item_property_value_font_style.text_color = Color.ui_grey_light(255, true)

local blueprints = {
	spacing_vertical_edge_margin = {
		size = {
			max_width,
			5
		}
	},
	spacing_vertical = {
		size = {
			max_width,
			10
		}
	},
	stats_meter_spacing_horizontal = {
		size = stats_horizontal_spacing_size
	},
	stats_meter_spacing_vertical = {
		size = {
			max_width,
			10
		}
	},
	item_description = {
		size = {
			max_width,
			100
		},
		pass_template = {
			{
				style_id = "text",
				pass_type = "text",
				value_id = "text",
				value = "n/a",
				style = item_description_font_style
			}
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style
			local text = element.text
			local localized_text = Localize(text)

			content.text = localized_text

			local text_style = style.text
			local ui_renderer = parent._ui_renderer
			local size = content.size
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local _, height = UIRenderer.text_size(ui_renderer, localized_text, text_style.font_type, text_style.font_size, size, text_options)

			widget.content.size[2] = height
		end
	},
	item_header = {
		size = {
			max_width,
			100
		},
		pass_template = {
			{
				value = "content/ui/materials/dividers/skull_rendered_center_02",
				pass_type = "texture",
				style = {
					vertical_alignment = "bottom",
					horizontal_alignment = "center",
					size = {
						306,
						48
					},
					offset = {
						0,
						0,
						2
					},
					color = Color.white(255, true)
				}
			},
			{
				value = "content/ui/materials/effects/wide_upward_glow",
				style_id = "glow",
				pass_type = "texture",
				style = {
					vertical_alignment = "bottom",
					horizontal_alignment = "center",
					size = {
						306,
						48
					},
					offset = {
						0,
						-37,
						1
					},
					color = Color.white(255, true)
				}
			},
			{
				value = "n/a",
				pass_type = "text",
				value_id = "display_name",
				style = item_header_display_name_font_style
			},
			{
				value = "n/a",
				pass_type = "text",
				value_id = "sub_display_name",
				style = item_header_sub_display_name_font_style
			}
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style
			local item = element.item
			local item_display_name = ItemUtils.display_name(item)
			local item_sub_display_name = ItemUtils.sub_display_name(item)
			local rarity_color = ItemUtils.rarity_color(item)

			content.display_name = item_display_name
			content.sub_display_name = item_sub_display_name
			content.sub_display_name = item_sub_display_name
			style.glow.color = table.clone(rarity_color)
		end
	},
	stats_meter = {
		size = InventoryWeaponDetailsViewSettings.stats_size,
		pass_template = BarPassTemplates.weapon_stats_bar,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local text = element.text
			local value = element.value

			content.text = Localize(text)
			content.progress = 0
			content.anim_time = 0
			content.target_value = value
		end,
		update = function (parent, widget, input_service, dt, t)
			local content = widget.content
			local anim_time = content.anim_time

			if anim_time then
				anim_time = anim_time + dt

				local duration = InventoryWeaponDetailsViewSettings.stats_anim_duration
				local time_progress = math.clamp(anim_time / duration, 0, 1)
				local anim_progress = math.ease_out_exp(time_progress)
				local target_value = content.target_value
				local anim_fraction = target_value * anim_progress

				content.progress = anim_fraction

				if time_progress < 1 then
					content.anim_time = anim_time
				else
					content.anim_time = nil
				end
			end
		end
	},
	item_category_header = {
		size = {
			max_width,
			30
		},
		pass_template = {
			{
				value = "n/a",
				pass_type = "text",
				value_id = "text",
				style = item_category_header_font_style
			},
			{
				value = "content/ui/materials/backgrounds/default_square",
				pass_type = "texture",
				style = {
					size = {
						nil,
						1
					},
					offset = {
						0,
						30,
						0
					},
					color = Color.ui_grey_light(255, true)
				}
			}
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style
			local text = element.text
			local localized_text = Utf8.upper(Localize(text))

			content.text = localized_text
		end
	},
	item_property_value = {
		size = {
			max_width,
			30
		},
		pass_template = {
			{
				value = "n/a",
				pass_type = "text",
				value_id = "text",
				style = item_property_value_font_style
			},
			{
				pass_type = "texture",
				style = {
					size = {
						30,
						30
					},
					offset = {
						0,
						0,
						0
					},
					color = Color.ui_grey_light(255, true)
				}
			}
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style
			local text = element.text
			local localized_text = Utf8.upper(Localize(text))

			content.text = localized_text
		end
	}
}

return blueprints
