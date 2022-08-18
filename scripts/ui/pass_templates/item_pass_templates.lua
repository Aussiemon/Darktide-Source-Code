local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WalletSettings = require("scripts/settings/wallet_settings")
local ItemPassTemplates = {
	item_size = {
		600,
		128
	},
	icon_size = {
		192,
		128
	},
	ui_item_size = {
		128,
		128
	},
	ui_icon_size = {
		60,
		70
	},
	gear_icon_size = {
		128,
		192
	}
}
ItemPassTemplates.gadget_size = {
	ItemPassTemplates.icon_size[1],
	ItemPassTemplates.icon_size[2] + 50
}
local item_size = ItemPassTemplates.item_size
local icon_size = ItemPassTemplates.icon_size
local item_display_name_text_style = table.clone(UIFontSettings.header_3)
item_display_name_text_style.text_horizontal_alignment = "left"
item_display_name_text_style.text_vertical_alignment = "bottom"
item_display_name_text_style.horizontal_alignment = "right"
item_display_name_text_style.vertical_alignment = "top"
item_display_name_text_style.offset = {
	-20,
	20,
	5
}
item_display_name_text_style.font_size = 20
item_display_name_text_style.size = {
	item_size[1] - icon_size[1] - 40,
	50
}
item_display_name_text_style.text_color = Color.ui_brown_light(255, true)
item_display_name_text_style.default_color = Color.ui_brown_light(255, true)
item_display_name_text_style.hover_color = Color.ui_brown_super_light(255, true)
local item_sub_display_name_text_style = table.clone(UIFontSettings.body_small)
item_sub_display_name_text_style.text_horizontal_alignment = "left"
item_sub_display_name_text_style.text_vertical_alignment = "top"
item_sub_display_name_text_style.horizontal_alignment = "right"
item_sub_display_name_text_style.vertical_alignment = "top"
item_sub_display_name_text_style.font_size = 18
item_sub_display_name_text_style.offset = {
	-20,
	70,
	5
}
item_sub_display_name_text_style.size = {
	item_size[1] - icon_size[1] - 40,
	50
}
item_sub_display_name_text_style.text_color = Color.ui_grey_light(255, true)
item_sub_display_name_text_style.default_color = Color.ui_grey_light(255, true)
item_sub_display_name_text_style.hover_color = Color.ui_brown_super_light(255, true)
local gear_item_slot_title_text_style = table.clone(UIFontSettings.header_3)
gear_item_slot_title_text_style.text_horizontal_alignment = "center"
gear_item_slot_title_text_style.text_vertical_alignment = "bottom"
gear_item_slot_title_text_style.horizontal_alignment = "center"
gear_item_slot_title_text_style.vertical_alignment = "top"
gear_item_slot_title_text_style.vertical_alignment = "top"
gear_item_slot_title_text_style.font_size = 18
gear_item_slot_title_text_style.offset = {
	0,
	-(ItemPassTemplates.gear_icon_size[2] + 20),
	5
}
gear_item_slot_title_text_style.text_color = Color.ui_brown_light(255, true)
gear_item_slot_title_text_style.default_color = Color.ui_brown_light(255, true)
gear_item_slot_title_text_style.hover_color = Color.ui_brown_super_light(255, true)
local ui_item_slot_title_text_style = table.clone(UIFontSettings.header_3)
ui_item_slot_title_text_style.text_horizontal_alignment = "center"
ui_item_slot_title_text_style.text_vertical_alignment = "bottom"
ui_item_slot_title_text_style.horizontal_alignment = "center"
ui_item_slot_title_text_style.vertical_alignment = "top"
ui_item_slot_title_text_style.vertical_alignment = "top"
ui_item_slot_title_text_style.font_size = 18
ui_item_slot_title_text_style.offset = {
	0,
	-(ItemPassTemplates.ui_item_size[2] + 10),
	5
}
ui_item_slot_title_text_style.text_color = Color.ui_brown_light(255, true)
ui_item_slot_title_text_style.default_color = Color.ui_brown_light(255, true)
ui_item_slot_title_text_style.hover_color = Color.ui_brown_super_light(255, true)
ItemPassTemplates.gear_item = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.weapons_enter
		}
	},
	{
		pass_type = "texture",
		style_id = "item_highlight",
		value = "content/ui/materials/frames/item_highlight",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size_addition = {
				0,
				0
			},
			offset = {
				0,
				0,
				8
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_focus_progress)
			style.color[1] = anim_progress * 255
		end
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 20 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/containers/item_container_portrait_rarity_1",
		style = {
			material_values = {
				use_placeholder_texture = 1
			},
			offset = {
				0,
				0,
				2
			}
		}
	}
}
ItemPassTemplates.gear_item_slot = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.weapons_enter
		}
	},
	{
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				150,
				0,
				0,
				0
			},
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				0
			}
		}
	},
	{
		value = "content/ui/materials/frames/dropshadow_medium",
		style_id = "shadow_frame",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			color = {
				150,
				0,
				0,
				0
			},
			size_addition = {
				40,
				40
			},
			offset = {
				0,
				0,
				0
			}
		}
	},
	{
		style_id = "shadow_frame2",
		pass_type = "texture",
		value = "content/ui/materials/frames/inner_shadow_medium",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			color = {
				200,
				0,
				0,
				0
			},
			size_addition = {
				-10,
				-10
			},
			offset = {
				0,
				0,
				1
			}
		},
		visibility_function = function (content, style)
			return not content.item
		end
	},
	{
		value = "content/ui/materials/dividers/horizontal_dynamic_lower",
		style_id = "divider_top",
		pass_type = "texture_uv",
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			size_addition = {
				30,
				0
			},
			size = {
				nil,
				10
			},
			offset = {
				0,
				-14,
				1
			},
			uvs = {
				{
					0,
					1
				},
				{
					1,
					0
				}
			}
		}
	},
	{
		value = "content/ui/materials/dividers/horizontal_dynamic_lower",
		style_id = "divider_bottom",
		pass_type = "texture",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			size_addition = {
				30,
				0
			},
			size = {
				nil,
				10
			},
			offset = {
				0,
				14,
				1
			}
		}
	},
	{
		pass_type = "texture",
		style_id = "frame_highlight",
		value = "content/ui/materials/frames/dropshadow_medium",
		style = {
			vertical_alignment = "center",
			scale_to_material = true,
			horizontal_alignment = "center",
			color = Color.ui_terminal(255, true),
			size_addition = {
				10,
				10
			},
			offset = {
				0,
				0,
				1
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress)
			style.color[1] = anim_progress * 255
		end
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size_addition = {
				40,
				40
			},
			offset = {
				0,
				0,
				5
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 54 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		style_id = "slot_title",
		pass_type = "text",
		value = "n/a",
		value_id = "slot_title",
		style = gear_item_slot_title_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/containers/item_container_portrait_rarity_1",
		style = {
			material_values = {
				use_placeholder_texture = 1
			},
			offset = {
				0,
				0,
				2
			}
		},
		visibility_function = function (content, style)
			return content.item
		end
	}
}
ItemPassTemplates.ui_item = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.weapons_enter
		}
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 20 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/containers/item_container_square_rarity_1",
		style = {
			material_values = {},
			offset = {
				0,
				0,
				2
			}
		},
		visibility_function = function (content, style)
			local parent_style = style.parent

			return parent_style.icon.material_values.use_placeholder_texture == 0
		end
	}
}
ItemPassTemplates.ui_item_slot = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.weapons_enter
		}
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 20 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		style_id = "slot_title",
		pass_type = "text",
		value = "n/a",
		value_id = "slot_title",
		style = ui_item_slot_title_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/containers/item_container_square_rarity_1",
		style = {
			material_values = {},
			offset = {
				0,
				0,
				2
			}
		},
		visibility_function = function (content, style)
			local parent_style = style.parent

			return parent_style.icon.material_values.use_placeholder_texture == 0
		end
	},
	{
		value = "content/ui/materials/icons/items/empty",
		pass_type = "texture",
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		visibility_function = function (content, style)
			return not content.item
		end
	}
}
ItemPassTemplates.item_slot = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.weapons_enter
		}
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress), content.hotspot.anim_focus_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 20 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		style_id = "display_name",
		pass_type = "text",
		value = "n/a",
		value_id = "display_name",
		style = item_display_name_text_style,
		visibility_function = function (content, style)
			return content.item
		end,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end
	},
	{
		style_id = "sub_display_name",
		pass_type = "text",
		value = "n/a",
		value_id = "sub_display_name",
		style = item_sub_display_name_text_style,
		visibility_function = function (content, style)
			return content.item
		end,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/containers/item_container_landscape_rarity_1",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			hdr = false,
			material_values = {
				texture_frame = "content/ui/textures/icons/items/frames/default",
				use_placeholder_texture = 1
			},
			size = icon_size,
			offset = {
				0,
				0,
				2
			}
		},
		visibility_function = function (content, style)
			return content.item
		end
	},
	{
		style_id = "rarity_side_texture",
		pass_type = "texture",
		value = "content/ui/materials/buttons/background_selected_faded",
		value_id = "rarity_side_texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				item_size[1] - icon_size[1]
			},
			size_addition = {
				0,
				-10
			},
			offset = {
				0,
				0,
				2
			},
			color = Color.ui_terminal(255, true)
		},
		visibility_function = function (content, style)
			return content.item
		end,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)
			style.color[1] = 50 + progress * 105
		end
	},
	{
		value = "content/ui/materials/icons/items/empty",
		pass_type = "texture",
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		visibility_function = function (content, style)
			return not content.item
		end
	}
}
local item_price_style = table.clone(UIFontSettings.body)
item_price_style.text_horizontal_alignment = "right"
item_price_style.text_vertical_alignment = "bottom"
item_price_style.horizontal_alignment = "left"
item_price_style.vertical_alignment = "center"
item_price_style.offset = {
	-20,
	0,
	7
}
item_price_style.size_addition = {
	0,
	-36
}
item_price_style.size = icon_size
item_price_style.text_color = Color.white(255, true)
item_price_style.default_color = Color.white(255, true)
item_price_style.hover_color = Color.white(255, true)
ItemPassTemplates.item = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.weapons_enter
		}
	},
	{
		pass_type = "texture",
		style_id = "item_highlight",
		value = "content/ui/materials/frames/item_highlight",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size = icon_size,
			size_addition = {
				0,
				0
			},
			offset = {
				0,
				0,
				8
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_focus_progress)
			style.color[1] = anim_progress * 255
		end
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 20 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		style_id = "salvage_circle",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/salvage_circle",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			material_values = {
				progress = 0
			},
			size = {
				100,
				100
			},
			offset = {
				icon_size[1] * 0.5 - 50,
				0,
				6
			}
		},
		visibility_function = function (content, style)
			return style.material_values.progress > 0
		end
	},
	{
		style_id = "salvage_icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/salvage_middle",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			size = {
				54,
				54
			},
			offset = {
				icon_size[1] * 0.5 - 27,
				0,
				5
			}
		},
		visibility_function = function (content, style)
			return style.parent.salvage_circle.material_values.progress > 0
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/containers/item_container_landscape_rarity_1",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			hdr = false,
			material_values = {},
			size = icon_size,
			offset = {
				0,
				0,
				2
			}
		}
	},
	{
		style_id = "salvage_icon_right",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/salvage_middle",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				25,
				25
			},
			offset = {
				-25,
				0,
				5
			}
		},
		visibility_function = function (content, style)
			return content.is_equipped
		end
	},
	{
		style_id = "price_background",
		pass_type = "texture",
		value = "content/ui/materials/backgrounds/pricetag",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			size = {
				icon_size[1],
				25
			},
			additional_size = {
				-20,
				0
			},
			offset = {
				-10,
				-20,
				6
			},
			color = {
				255,
				0,
				0,
				0
			}
		},
		visibility_function = function (content, style)
			return content.has_price_tag
		end
	},
	{
		value_id = "wallet_icon",
		style_id = "wallet_icon",
		pass_type = "texture",
		value = "content/ui/materials/base/ui_default_base",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			size = {
				25,
				25
			},
			offset = {
				0,
				-20,
				7
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		visibility_function = function (content, style)
			return content.has_price_tag
		end
	},
	{
		value_id = "price_text",
		style_id = "price_text",
		pass_type = "text",
		value = "n/a",
		style = item_price_style,
		visibility_function = function (content, style)
			return content.has_price_tag
		end
	},
	{
		style_id = "display_name",
		pass_type = "text",
		value = "n/a",
		value_id = "display_name",
		style = item_display_name_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end
	},
	{
		style_id = "sub_display_name",
		pass_type = "text",
		value = "n/a",
		value_id = "sub_display_name",
		style = item_sub_display_name_text_style,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end
	},
	{
		style_id = "rarity_side_texture",
		pass_type = "texture",
		value = "content/ui/materials/buttons/background_selected_faded",
		value_id = "rarity_side_texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				item_size[1] - icon_size[1]
			},
			size_addition = {
				0,
				-10
			},
			offset = {
				0,
				0,
				2
			},
			color = Color.ui_terminal(255, true)
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)
			style.color[1] = 50 + progress * 105
		end
	}
}
ItemPassTemplates.item_icon = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.weapons_enter
		}
	},
	{
		pass_type = "texture",
		style_id = "item_highlight",
		value = "content/ui/materials/frames/item_highlight",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size = icon_size,
			size_addition = {
				0,
				0
			},
			offset = {
				0,
				0,
				8
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_focus_progress)
			style.color[1] = anim_progress * 255
		end
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = true,
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 20 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		style_id = "salvage_circle",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/salvage_circle",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			material_values = {
				progress = 0
			},
			size = {
				100,
				100
			},
			offset = {
				icon_size[1] * 0.5 - 50,
				0,
				6
			}
		},
		visibility_function = function (content, style)
			return style.material_values.progress > 0
		end
	},
	{
		style_id = "salvage_icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/salvage_middle",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			size = {
				54,
				54
			},
			offset = {
				icon_size[1] * 0.5 - 27,
				0,
				5
			}
		},
		visibility_function = function (content, style)
			return style.parent.salvage_circle.material_values.progress > 0
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/containers/item_container_landscape_rarity_1",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			hdr = false,
			material_values = {},
			size = icon_size,
			offset = {
				0,
				0,
				2
			}
		}
	},
	{
		style_id = "salvage_icon_right",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/salvage_middle",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				25,
				25
			},
			offset = {
				-25,
				0,
				5
			}
		},
		visibility_function = function (content, style)
			return content.is_equipped
		end
	},
	{
		style_id = "price_background",
		pass_type = "texture",
		value = "content/ui/materials/backgrounds/pricetag",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			size = {
				icon_size[1],
				25
			},
			additional_size = {
				-20,
				0
			},
			offset = {
				-10,
				-20,
				6
			},
			color = {
				255,
				0,
				0,
				0
			}
		},
		visibility_function = function (content, style)
			return content.has_price_tag
		end
	},
	{
		value_id = "wallet_icon",
		style_id = "wallet_icon",
		pass_type = "texture",
		value = "content/ui/materials/base/ui_default_base",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			size = {
				25,
				25
			},
			offset = {
				0,
				-20,
				7
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		visibility_function = function (content, style)
			return content.has_price_tag
		end
	},
	{
		value_id = "price_text",
		style_id = "price_text",
		pass_type = "text",
		value = "n/a",
		style = item_price_style,
		visibility_function = function (content, style)
			return content.has_price_tag
		end
	}
}
local emote_item_slot_title_style = table.clone(UIFontSettings.body)
emote_item_slot_title_style.text_horizontal_alignment = "left"
emote_item_slot_title_style.text_vertical_alignment = "center"
emote_item_slot_title_style.horizontal_alignment = "left"
emote_item_slot_title_style.vertical_alignment = "center"
emote_item_slot_title_style.offset = {
	70,
	0,
	5
}
emote_item_slot_title_style.text_color = Color.ui_brown_super_light(255, true)
emote_item_slot_title_style.default_color = Color.ui_brown_super_light(255, true)
emote_item_slot_title_style.hover_color = Color.ui_brown_super_light(255, true)
local emote_item_slot_name_style = table.clone(UIFontSettings.body)
emote_item_slot_name_style.text_horizontal_alignment = "right"
emote_item_slot_name_style.text_vertical_alignment = "center"
emote_item_slot_name_style.horizontal_alignment = "right"
emote_item_slot_name_style.vertical_alignment = "center"
emote_item_slot_name_style.offset = {
	-90,
	0,
	5
}
emote_item_slot_name_style.text_color = Color.ui_brown_light(255, true)
emote_item_slot_name_style.default_color = Color.ui_brown_light(255, true)
emote_item_slot_name_style.hover_color = Color.ui_brown_super_light(255, true)
ItemPassTemplates.emote_item_slot = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.apparel_enter
		}
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress), content.hotspot.anim_focus_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 10 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		value_id = "title_text",
		style_id = "title_text",
		pass_type = "text",
		value = "n/a",
		style = emote_item_slot_title_style
	},
	{
		value_id = "name_text",
		style_id = "name_text",
		pass_type = "text",
		value = "n/a",
		style = emote_item_slot_name_style
	},
	{
		value_id = "slot_icon",
		style_id = "slot_icon",
		pass_type = "rotated_texture",
		value = "content/ui/materials/icons/items/emotes/emote_wheel_icon",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			angle = 0,
			color = Color.white(255, true),
			size = {
				42,
				42
			},
			offset = {
				10,
				0,
				1
			}
		},
		visibility_function = function (content, style)
			return true
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/cosmetics/categories/upper_body",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			color = Color.white(255, true),
			size = {
				50,
				50
			},
			offset = {
				-30,
				0,
				1
			}
		},
		visibility_function = function (content, style)
			return true
		end
	},
	{
		style_id = "arrow",
		pass_type = "texture",
		value = "content/ui/materials/buttons/arrow_01",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			color = Color.white(255, true),
			size = {
				12,
				18
			},
			offset = {
				-10,
				0,
				1
			}
		},
		visibility_function = function (content, style)
			return true
		end
	}
}
local animation_item_slot_title_style = table.clone(UIFontSettings.body)
animation_item_slot_title_style.text_horizontal_alignment = "left"
animation_item_slot_title_style.text_vertical_alignment = "center"
animation_item_slot_title_style.horizontal_alignment = "left"
animation_item_slot_title_style.vertical_alignment = "center"
animation_item_slot_title_style.offset = {
	70,
	0,
	5
}
animation_item_slot_title_style.text_color = Color.ui_brown_super_light(255, true)
animation_item_slot_title_style.default_color = Color.ui_brown_super_light(255, true)
animation_item_slot_title_style.hover_color = Color.ui_brown_super_light(255, true)
local animation_item_slot_name_style = table.clone(UIFontSettings.body)
animation_item_slot_name_style.text_horizontal_alignment = "right"
animation_item_slot_name_style.text_vertical_alignment = "center"
animation_item_slot_name_style.horizontal_alignment = "right"
animation_item_slot_name_style.vertical_alignment = "center"
animation_item_slot_name_style.offset = {
	-40,
	0,
	5
}
animation_item_slot_name_style.text_color = Color.ui_brown_light(255, true)
animation_item_slot_name_style.default_color = Color.ui_brown_light(255, true)
animation_item_slot_name_style.hover_color = Color.ui_brown_super_light(255, true)
ItemPassTemplates.animation_item_slot = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.apparel_enter
		}
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				0,
				0
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress), content.hotspot.anim_focus_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 10 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		value_id = "title_text",
		style_id = "title_text",
		pass_type = "text",
		value = "n/a",
		style = animation_item_slot_title_style
	},
	{
		value_id = "name_text",
		style_id = "name_text",
		pass_type = "text",
		value = "n/a",
		style = animation_item_slot_name_style
	},
	{
		value_id = "slot_icon",
		style_id = "slot_icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/cosmetics/categories/upper_body",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			color = Color.white(255, true),
			size = {
				50,
				50
			},
			offset = {
				10,
				0,
				1
			}
		}
	},
	{
		value = "content/ui/materials/buttons/arrow_01",
		style_id = "arrow",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			color = Color.white(255, true),
			size = {
				12,
				18
			},
			offset = {
				-10,
				0,
				1
			}
		}
	}
}
local gadget_size = ItemPassTemplates.gadget_size
local gadget_display_name_text_style = table.clone(UIFontSettings.header_3)
gadget_display_name_text_style.text_horizontal_alignment = "center"
gadget_display_name_text_style.text_vertical_alignment = "center"
gadget_display_name_text_style.horizontal_alignment = "center"
gadget_display_name_text_style.vertical_alignment = "top"
gadget_display_name_text_style.offset = {
	0,
	icon_size[2] + 10,
	5
}
gadget_display_name_text_style.size = {
	gadget_size[1] - 20,
	gadget_size[2] - icon_size[2]
}
gadget_display_name_text_style.text_color = Color.ui_brown_light(255, true)
gadget_display_name_text_style.default_color = Color.ui_brown_light(255, true)
gadget_display_name_text_style.hover_color = Color.ui_brown_super_light(255, true)
local gadget_empty_text_style = table.clone(gadget_display_name_text_style)
gadget_empty_text_style.text_color = Color.ui_grey_light(255, true)
gadget_empty_text_style.default_color = Color.ui_grey_light(255, true)
gadget_empty_text_style.hover_color = Color.ui_brown_super_light(255, true)
gadget_empty_text_style.offset[2] = gadget_empty_text_style.offset[2] - 10
ItemPassTemplates.gadget_item_slot = {
	{
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.gadget_enter
		}
	},
	{
		value = "content/ui/materials/frames/hover",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			hdr = false,
			color = Color.ui_terminal(255, true),
			size = icon_size,
			size_addition = {
				20,
				20
			},
			offset = {
				0,
				-(gadget_size[2] - icon_size[2]) * 0.5,
				0
			}
		},
		change_function = function (content, style)
			local anim_progress = math.max(math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress), content.hotspot.anim_focus_progress)
			style.color[1] = anim_progress * 255
			local size_addition = style.size_addition
			local size_padding = 20 - math.easeInCubic(anim_progress) * 10
			size_addition[1] = size_padding
			size_addition[2] = size_padding
		end
	},
	{
		style_id = "display_name",
		pass_type = "text",
		value = "n/a",
		value_id = "display_name",
		style = gadget_display_name_text_style,
		visibility_function = function (content, style)
			return content.item
		end,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end
	},
	{
		pass_type = "text",
		value = Localize("loc_item_slot_empty"),
		style = gadget_empty_text_style,
		visibility_function = function (content, style)
			return not content.item
		end,
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_text_color = style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

			ColorUtilities.color_lerp(default_text_color, hover_color, progress, text_color)
		end
	},
	{
		value = "content/ui/materials/icons/items/empty",
		pass_type = "texture",
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			size = icon_size,
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		visibility_function = function (content, style)
			return not content.item
		end
	},
	{
		value_id = "icon",
		style_id = "icon",
		pass_type = "texture",
		value = "content/ui/materials/icons/items/containers/item_container_landscape_rarity_1",
		style = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			hdr = false,
			material_values = {
				texture_frame = "content/ui/textures/icons/items/frames/default",
				use_placeholder_texture = 1
			},
			size = icon_size,
			offset = {
				0,
				0,
				2
			}
		},
		visibility_function = function (content, style)
			return content.item
		end
	}
}

return settings("ItemPassTemplates", ItemPassTemplates)
