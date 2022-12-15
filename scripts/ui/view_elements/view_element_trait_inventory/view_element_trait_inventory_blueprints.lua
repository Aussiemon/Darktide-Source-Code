local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local amount_style = table.clone(UIFontSettings.body_small)
amount_style.text_color = Color.terminal_icon(nil, true)
amount_style.offset = {
	0,
	-1,
	3
}
amount_style.text_horizontal_alignment = "center"
amount_style.text_vertical_alignment = "bottom"
local unknown_style = table.clone(amount_style)
unknown_style.offset = {
	0,
	-10,
	3
}
unknown_style.font_size = 10
unknown_style.text_color[1] = 127
local ViewElementTraitInventoryBlueprints = {
	spacing_vertical_small = {
		size = {
			430,
			5
		}
	},
	spacing_vertical = {
		size = {
			430,
			20
		}
	}
}
ViewElementTraitInventoryBlueprints.trait = {
	size = {
		110,
		110
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select
			}
		},
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					1
				},
				color = Color.terminal_frame(50, true)
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "button_frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				offset = {
					0,
					0,
					2
				},
				color = Color.terminal_frame(nil, true)
			}
		},
		{
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "button_corner",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				offset = {
					0,
					0,
					3
				},
				color = Color.terminal_corner(nil, true)
			}
		},
		{
			value = "content/ui/materials/icons/traits/traits_container",
			style_id = "icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {},
				size = {
					64,
					64
				},
				offset = {
					0,
					0,
					5
				},
				color = Color.terminal_icon(255, true)
			}
		},
		{
			style_id = "amount",
			value_id = "amount",
			pass_type = "text",
			value = "1x",
			style = amount_style
		}
	},
	init = function (parent, widget, config, callback_name)
		local content = widget.content
		local style = widget.style
		local trait_item = config.trait_item
		local trait_rarity = config.trait_rarity
		local trait_amount = config.trait_amount
		local texture_icon, texture_frame = ItemUtils.trait_textures(trait_item, trait_rarity)
		local icon_material_values = style.icon.material_values
		icon_material_values.icon = texture_icon
		icon_material_values.frame = texture_frame
		content.amount = string.format("x%d", trait_amount)
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, config)
	end
}
ViewElementTraitInventoryBlueprints.unknown_trait = {
	size = {
		110,
		110
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				disabled = true,
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select
			}
		},
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					1
				},
				color = Color.terminal_frame(50, true)
			}
		},
		{
			value = "content/ui/materials/frames/frame_tile_2px",
			style_id = "button_frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				offset = {
					0,
					0,
					2
				},
				color = Color.terminal_frame(nil, true)
			}
		},
		{
			value = "content/ui/materials/frames/frame_corner_2px",
			style_id = "button_corner",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				offset = {
					0,
					0,
					3
				},
				color = Color.terminal_corner(nil, true)
			}
		},
		{
			value = "content/ui/materials/icons/traits/traits_container",
			style_id = "icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					icon = "content/ui/textures/icons/traits/weapon_trait_unknown"
				},
				size = {
					48,
					48
				},
				offset = {
					0,
					0,
					5
				},
				color = Color.terminal_icon(127, true)
			}
		},
		{
			style_id = "unknown",
			pass_type = "text",
			style = unknown_style,
			value = Localize("loc_item_weapon_description_manufacture_002")
		}
	}
}

return ViewElementTraitInventoryBlueprints
