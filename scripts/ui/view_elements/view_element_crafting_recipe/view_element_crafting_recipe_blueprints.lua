local ItemUtils = require("scripts/utilities/items")
local WalletSettings = require("scripts/settings/wallet_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local TextUtilities = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementCraftingRecipeBlueprints = {
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
local navigation_button_pass_template = table.merge({}, ButtonPassTemplates.terminal_list_button_with_background_and_icon)
navigation_button_pass_template[#navigation_button_pass_template + 1] = {
	pass_type = "text",
	value = Localize("loc_action_interaction_coming_soon"),
	style = {
		material = "content/ui/materials/font_gradients/slug_font_gradient_header",
		font_size = 20,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "right",
		text_color = Color.cheeseburger(255, true),
		offset = {
			-65,
			2,
			3
		}
	},
	visibility_function = function (content)
		return content.coming_soon
	end
}
navigation_button_pass_template[#navigation_button_pass_template + 1] = {
	value_id = "insufficient_funds",
	pass_type = "text",
	value = "",
	style = {
		material = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		font_size = 28,
		text_vertical_alignment = "center",
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "right",
		text_color = {
			255,
			255,
			255,
			255
		},
		offset = {
			-65,
			2,
			3
		}
	},
	visibility_function = function (content)
		return not content.coming_soon
	end
}
ViewElementCraftingRecipeBlueprints.navigation_button = {
	size = {
		430,
		64
	},
	pass_template = navigation_button_pass_template,
	init = function (parent, widget, config, callback_name)
		local recipe = config.recipe
		local content = widget.content
		content.text = Localize(recipe.display_name)
		content.icon = recipe.icon
		content.coming_soon = recipe.ui_disabled
		local hotspot = content.hotspot
		hotspot.disabled = true
		hotspot.pressed_callback = callback(parent, callback_name, widget, config)
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local content = widget.content
		local recipe = content.entry.recipe

		if recipe.ui_disabled then
			return
		end

		local validation_function = recipe.is_valid_item

		if validation_function then
			local item = parent.content.item
			content.hotspot.disabled = not validation_function(item)
		end

		content.insufficient_funds = parent.content.insufficient_funds[recipe.name] or ""
	end
}
ViewElementCraftingRecipeBlueprints.craft_button = {
	size = {
		430,
		64
	},
	pass_template = ButtonPassTemplates.terminal_button,
	init = function (parent, widget, config, callback_name)
		local content = widget.content
		content.text = Localize(config.text or "loc_confirm")
		local hotspot = content.hotspot
		hotspot.on_pressed_sound = config.sound_event
		hotspot.pressed_callback = callback(parent, callback_name, widget, config)
		hotspot.disabled = true
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		widget.content.hotspot.disabled = not parent.content.can_craft
	end
}
ViewElementCraftingRecipeBlueprints.title = {
	size = {
		430,
		30
	},
	pass_template = {
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = table.merge({
				text_horizontal_alignment = "center"
			}, UIFontSettings.terminal_header_3)
		}
	},
	init = function (parent, widget, config)
		widget.content.text = Localize(config.text)
	end
}
local description_text_style = UIFontSettings.body_small
ViewElementCraftingRecipeBlueprints.description = {
	size = {
		430,
		128
	},
	size_function = function (parent, config, ui_renderer)
		local style = description_text_style
		local base_size = ViewElementCraftingRecipeBlueprints.description.size
		local text_options = UIFonts.get_font_options_by_style(style)
		local text_localized = Localize(config.text)
		local _, text_height = UIRenderer.text_size(ui_renderer, text_localized, style.font_type, style.font_size, base_size, text_options)

		return {
			430,
			text_height + 8
		}
	end,
	pass_template = {
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "text",
			style = description_text_style
		}
	},
	init = function (parent, widget, config)
		widget.content.text = Localize(config.text)
		local override_color = config.color

		if override_color then
			widget.style.text.text_color = override_color
		end
	end
}

local function item_selection_button_change_function(content, style)
	local hotspot = content.hotspot
	local wanted_color = hotspot.is_selected and style.selected_color or style.default_color

	ColorUtilities.color_copy(wanted_color, style.color)
end

local function item_selection_button_hover_change_function(content, style)
	local hotspot = content.hotspot
	style.color[1] = 100 + math.max(hotspot.anim_hover_progress, content.hotspot.anim_select_progress) * 155
end

local weapon_perk_style = table.clone(UIFontSettings.body)
weapon_perk_style.offset = {
	45,
	0,
	10
}
weapon_perk_style.size_addition = {
	-90
}
weapon_perk_style.font_size = 18
weapon_perk_style.text_horizontal_alignment = "left"
weapon_perk_style.text_vertical_alignment = "center"
weapon_perk_style.text_color = Color.terminal_text_body(255, true)
ViewElementCraftingRecipeBlueprints.perk_button = {
	size = {
		340,
		54
	},
	size_function = function (parent, config, ui_renderer)
		local style = weapon_perk_style
		local text = ItemUtils.trait_description(config.item, config.rarity, config.value)
		local text_options = UIFonts.get_font_options_by_style(style)
		local size = ViewElementCraftingRecipeBlueprints.perk_button.size
		local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, size, text_options)

		return {
			430,
			20 + math.max(20, text_height)
		}
	end,
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
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					1
				},
				default_color = Color.terminal_background(nil, true),
				selected_color = Color.terminal_background_selected(nil, true)
			},
			change_function = item_selection_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					2
				},
				color = Color.terminal_background_gradient(nil, true)
			},
			change_function = item_selection_button_hover_change_function
		},
		{
			pass_type = "texture",
			style_id = "button_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					3
				},
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true)
			},
			change_function = item_selection_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "button_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					4
				},
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true)
			},
			change_function = item_selection_button_change_function
		},
		{
			value = "content/ui/materials/icons/perks/perk_level_01",
			value_id = "rank",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				size = {
					20,
					20
				},
				offset = {
					14,
					0,
					10
				},
				color = Color.terminal_icon(255, true)
			}
		},
		{
			value = "n/a",
			pass_type = "text",
			value_id = "description",
			style = weapon_perk_style
		}
	},
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local content = widget.content
		content.description = ItemUtils.perk_description(config.item, config.rarity, config.value)
		content.rank = ItemUtils.perk_textures(config.item, config.rarity)
		content.hotspot.pressed_callback = callback(parent, secondary_callback_name, widget, config)
	end
}
local weapon_traits_style = table.clone(UIFontSettings.header_3)
weapon_traits_style.offset = {
	98,
	10,
	10
}
weapon_traits_style.size = {
	324
}
weapon_traits_style.font_size = 18
weapon_traits_style.text_horizontal_alignment = "left"
weapon_traits_style.text_vertical_alignment = "top"
weapon_traits_style.text_color = Color.terminal_text_header(255, true)
local weapon_traits_description_style = table.clone(UIFontSettings.body)
weapon_traits_description_style.offset = {
	98,
	30,
	11
}
weapon_traits_description_style.size = {
	324,
	500
}
weapon_traits_description_style.font_size = 18
weapon_traits_description_style.text_horizontal_alignment = "left"
weapon_traits_description_style.text_vertical_alignment = "top"
weapon_traits_description_style.text_color = Color.terminal_text_body(255, true)
ViewElementCraftingRecipeBlueprints.trait_button = {
	size_function = function (parent, config, ui_renderer)
		local style = weapon_traits_description_style
		local text = ItemUtils.trait_description(config.item, config.rarity, config.value)
		local text_options = UIFonts.get_font_options_by_style(style)
		local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, style.size, text_options)

		return {
			430,
			20 + math.max(68, text_height + 25)
		}
	end,
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
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					1
				},
				default_color = Color.terminal_background(nil, true),
				selected_color = Color.terminal_background_selected(nil, true)
			},
			change_function = item_selection_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					2
				},
				color = Color.terminal_background_gradient(nil, true)
			},
			change_function = item_selection_button_hover_change_function
		},
		{
			pass_type = "texture",
			style_id = "button_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					3
				},
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true)
			},
			change_function = item_selection_button_change_function
		},
		{
			pass_type = "texture",
			style_id = "button_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					4
				},
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true)
			},
			change_function = item_selection_button_change_function
		},
		{
			value = "content/ui/materials/icons/traits/traits_container",
			style_id = "icon",
			pass_type = "texture",
			style = {
				material_values = {},
				size = {
					64,
					64
				},
				offset = {
					20,
					10,
					10
				},
				color = Color.terminal_icon(255, true)
			}
		},
		{
			value = "n/a",
			pass_type = "text",
			value_id = "display_name",
			style = weapon_traits_style
		},
		{
			style_id = "description",
			value_id = "description",
			pass_type = "text",
			value = "n/a",
			style = weapon_traits_description_style
		}
	},
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local content = widget.content
		local style = widget.style
		content.hotspot.pressed_callback = callback(parent, secondary_callback_name, widget, config)
		local rarity = config.rarity
		local item = config.item
		content.display_name = Localize(item.display_name)
		content.description = ItemUtils.trait_description(item, rarity, config.value)
		local icon_material_values = style.icon.material_values
		icon_material_values.icon, icon_material_values.frame = ItemUtils.trait_textures(item, rarity)
	end
}
local warning_text_style = table.clone(UIFontSettings.body_small)
warning_text_style.text_color = Color.ui_red_light(nil, true)
ViewElementCraftingRecipeBlueprints.warning = {
	size = {
		430,
		30
	},
	size_function = function (parent, config, ui_renderer)
		local style = description_text_style
		local base_size = ViewElementCraftingRecipeBlueprints.warning.size
		local text_options = UIFonts.get_font_options_by_style(style)
		local text = config.text or "AAAWWW"
		local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, base_size, text_options)

		return {
			430,
			text_height + 8
		}
	end,
	pass_template = {
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "text",
			style = warning_text_style
		}
	},
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local parent_content = parent.content
		local can_craft = parent_content.can_craft
		local fail_reason = parent_content.fail_reason
		widget.style.text.visible = not can_craft and fail_reason

		if not can_craft then
			widget.content.text = fail_reason or Localize("loc_crafting_failure")
		end
	end
}
ViewElementCraftingRecipeBlueprints.recipe_costs = {
	size = {
		430,
		32
	},
	pass_template_function = function (self, config, ui_renderer)
		local passes = {
			[#passes + 1] = {
				pass_type = "text",
				value = Localize("loc_price"),
				style = UIFontSettings.body
			}
		}
		local x_offset = 0
		local costs = config.costs

		for i = 1, #costs do
			local cost = costs[i]
			local cost_type = cost.type
			local wallet_settings = WalletSettings[cost_type]
			local amount_label = TextUtilities.format_currency(cost.amount)
			local price_style = table.clone(UIFontSettings.body)
			price_style.text_horizontal_alignment = "right"
			price_style.offset = {
				x_offset,
				0,
				10
			}
			price_style.default_material = wallet_settings.font_gradient_material
			price_style.insufficient_material = wallet_settings.font_gradient_material_insufficient_funds
			price_style.material = price_style.default_material
			price_style.text_color = {
				255,
				255,
				255,
				255
			}
			passes[#passes + 1] = {
				pass_type = "text",
				value_id = cost_type,
				value = amount_label,
				style_id = cost_type,
				style = price_style
			}
			local price_text_size = UIRenderer.text_size(ui_renderer, amount_label, price_style.font_type, price_style.font_size)
			x_offset = x_offset - price_text_size - 5
			passes[#passes + 1] = {
				pass_type = "texture",
				value = wallet_settings.icon_texture_small,
				style = {
					horizontal_alignment = "right",
					size = {
						28,
						20
					},
					offset = {
						x_offset,
						5,
						0
					}
				}
			}
			x_offset = x_offset - 28 - 12
		end

		return passes
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local style = widget.style
		local costs = widget.content.entry.costs

		for _, cost in pairs(costs) do
			local cost_style = style[cost.type]
			cost_style.material = cost.can_afford and cost_style.default_material or cost_style.insufficient_material
		end
	end
}

return ViewElementCraftingRecipeBlueprints
