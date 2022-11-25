local WalletSettings = require("scripts/settings/wallet_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local TextUtilities = require("scripts/utilities/ui/text")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local CraftingRecipeBlueprints = {
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
		font_type = "itc_novarese_bold",
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
CraftingRecipeBlueprints.navigation_button = {
	size = {
		430,
		64
	},
	pass_template = navigation_button_pass_template,
	init = function (parent, widget, config, callback_name)
		local content = widget.content
		content.text = Localize(config.display_name)

		if config.icon then
			content.icon = config.icon
		end

		content.coming_soon = config.recipe.ui_disabled
		local hotspot = content.hotspot
		hotspot.disabled = config.recipe.ui_disabled or not not config.recipe.is_valid_item
		hotspot.pressed_callback = callback(parent, callback_name, widget, config)
	end
}
CraftingRecipeBlueprints.craft_button = {
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
		hotspot.disabled = config.disabled
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local view_instance = parent._parent

		if view_instance and view_instance.can_craft then
			widget.content.hotspot.disabled = not view_instance:can_craft()
		end
	end
}
CraftingRecipeBlueprints.title = {
	size = {
		430,
		64
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
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		widget.content.text = Localize(config.text)
	end
}
CraftingRecipeBlueprints.description = {
	size = {
		430,
		64
	},
	pass_template = {
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = UIFontSettings.body_small
		}
	},
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		widget.content.text = Localize(config.text)
	end
}
local weapon_perk_style = table.clone(UIFontSettings.body)
weapon_perk_style.offset = {
	98,
	0,
	3
}
weapon_perk_style.size = {
	324
}
weapon_perk_style.font_size = 18
weapon_perk_style.text_horizontal_alignment = "left"
weapon_perk_style.text_vertical_alignment = "center"
weapon_perk_style.text_color = Color.terminal_text_body(255, true)
CraftingRecipeBlueprints.selected_perk = {
	size = {
		430,
		54
	},
	pass_template = {
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = Color.terminal_frame(50, true)
			}
		},
		{
			value = "content/ui/materials/icons/perks/perk_level_01",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				size = {
					20,
					20
				},
				offset = {
					42,
					0,
					0
				},
				color = Color.terminal_icon(255, true)
			}
		},
		{
			value = "n/a",
			pass_type = "text",
			value_id = "text",
			style = weapon_perk_style
		}
	},
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local display_name = parent._parent._perk_display_name
		widget.content.text = display_name
		widget.visible = not not display_name
	end
}
local warning_text_style = table.clone(UIFontSettings.body_small)
warning_text_style.text_color = Color.ui_red_light(nil, true)
CraftingRecipeBlueprints.warning = {
	size = {
		430,
		20
	},
	pass_template = {
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = warning_text_style
		}
	},
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local text = config.text
		widget.visible = not not text

		if text then
			widget.content.text = Localize(text)
		end
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local view_instance = parent._parent

		if view_instance and view_instance.can_craft then
			local can_craft, reason = view_instance:can_craft()
			widget.visible = not can_craft
			widget.content.text = Localize(reason or "loc_crafting_failure")
		end
	end
}
CraftingRecipeBlueprints.recipe_costs = {
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
			local amount = cost.amount

			if amount > 0 then
				local wallet_settings = WalletSettings[cost.type]
				local amount_label = TextUtilities.format_currency(cost.amount)
				local price_style = table.clone(UIFontSettings.body)
				price_style.text_horizontal_alignment = "right"
				price_style.offset = {
					x_offset,
					0,
					10
				}
				price_style.material = cost.can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
				price_style.text_color = {
					255,
					255,
					255,
					255
				}
				passes[#passes + 1] = {
					pass_type = "text",
					value = amount_label,
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
		end

		return passes
	end
}

return CraftingRecipeBlueprints
