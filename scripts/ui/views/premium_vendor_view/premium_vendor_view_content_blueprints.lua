local DefaultPassTemplates = require("scripts/ui/pass_templates/default_pass_templates")
local GridPassTemplates = require("scripts/ui/pass_templates/grid_pass_templates")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local PremiumVendorViewSettings = require("scripts/ui/views/premium_vendor_view/premium_vendor_view_settings")
local grid_size = PremiumVendorViewSettings.grid_size
local grid_width = grid_size[1]
local button_font_style = table.clone(UIFontSettings.header_3)
button_font_style.offset = {
	10,
	0,
	3
}
button_font_style.text_horizontal_alignment = "left"
button_font_style.text_vertical_alignment = "center"
button_font_style.hover_text_color = Color.ui_brown_super_light(255, true)
local button_value_font_style = table.clone(UIFontSettings.header_3)
button_value_font_style.offset = {
	-10,
	0,
	3
}
button_value_font_style.text_horizontal_alignment = "right"
button_value_font_style.text_vertical_alignment = "center"
button_value_font_style.default_text_color = Color.ui_grey_medium(255, true)
button_value_font_style.hover_text_color = Color.ui_grey_light(255, true)
local blueprints = {
	spacing_vertical = {
		size = {
			grid_width,
			20
		}
	},
	spacing_vertical_large = {
		size = {
			grid_width,
			60
		}
	},
	rect = {
		size = {
			90,
			90
		},
		pass_template = GridPassTemplates.grid_rect,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
		end
	},
	texture = {
		size = {
			90,
			90
		},
		pass_template = GridPassTemplates.grid_texture,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
		end
	},
	divider = {
		size = {
			grid_width,
			30
		},
		pass_template = GridPassTemplates.grid_divider
	},
	header_2_text = {
		size = {
			grid_width,
			45
		},
		pass_template = DefaultPassTemplates.header_2_text,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			content.text = element.text
		end
	},
	item = {
		size = ItemPassTemplates.item_size,
		pass_template = ItemPassTemplates.item,
		init = function (parent, widget, element, callback_name, secondary_callback_name)
			local content = widget.content
			local style = widget.style
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.hotspot.right_pressed_callback = callback(parent, secondary_callback_name, widget, element)
			content.element = element
			local item = element.item
			content.item = item
			local display_name = item and item.display_name

			if display_name then
				content.display_name = ItemUtils.display_name(item)
				content.sub_display_name = ItemUtils.sub_display_name(item)
			end

			local rarity_frame_texture, rarity_side_texture = ItemUtils.rarity_textures(item)
			content.rarity_side_texture = rarity_side_texture
			style.icon.material_values.texture_frame = rarity_frame_texture
		end,
		update = function (parent, widget, input_service, dt, t)
			local content = widget.content
			local element = content.element
		end
	}
}

return blueprints
