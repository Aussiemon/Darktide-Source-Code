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
	local is_selected = hotspot.is_selected
	local is_focused = hotspot.is_focused
	local is_hover = hotspot.is_hover
	local disabled = hotspot.disabled
	local default_color = style.default_color
	local hover_color = style.hover_color
	local selected_color = style.selected_color
	local disabled_color = style.disabled_color
	local color = nil

	if disabled and disabled_color then
		color = disabled_color
	elseif is_selected and selected_color then
		color = selected_color
	elseif is_hover and hover_color then
		color = hover_color
	elseif default_color then
		color = default_color
	end

	if color then
		ColorUtilities.color_copy(color, style.color)
	end
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
	-55,
	0
}
weapon_perk_style.font_size = 18
weapon_perk_style.text_horizontal_alignment = "left"
weapon_perk_style.text_vertical_alignment = "center"
weapon_perk_style.text_color = {
	255,
	216,
	229,
	207
}
weapon_perk_style.default_color = {
	255,
	216,
	229,
	207
}
weapon_perk_style.hover_color = Color.white(255, true)
weapon_perk_style.disabled_color = {
	255,
	60,
	60,
	60
}
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
		local size_addition = style.size_addition
		local actual_text_size = {
			430 + (size_addition[1] or 0),
			size[2] + (size_addition[2] or 0)
		}
		local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, actual_text_size, text_options)

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
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(100, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			value = "content/ui/materials/frames/line_thin_dashed_animated",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					8
				},
				color = Color.terminal_corner_selected(nil, true),
				default_color = Color.terminal_corner_selected(0, true),
				selected_color = Color.terminal_corner_selected(nil, true)
			},
			visibility_function = function (content, style)
				return content.marked
			end
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
					0
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
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true)
			},
			change_function = function (content, style)
				item_selection_button_change_function(content, style)
				item_selection_button_hover_change_function(content, style)
			end
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
			value_id = "description",
			pass_type = "text",
			value = "n/a",
			style = weapon_perk_style,
			change_function = function (content, style)
				local hotspot = content.hotspot
				local default_color = hotspot.disabled and style.disabled_color or style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

				ColorUtilities.color_lerp(default_color, hover_color, progress, text_color)
			end
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
weapon_traits_style.text_color = {
	255,
	216,
	229,
	207
}
weapon_traits_style.default_color = {
	255,
	216,
	229,
	207
}
weapon_traits_style.hover_color = Color.white(255, true)
weapon_traits_style.disabled_color = {
	255,
	60,
	60,
	60
}
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
weapon_traits_description_style.default_color = Color.terminal_text_body(255, true)
weapon_traits_description_style.hover_color = Color.terminal_text_header(255, true)
weapon_traits_description_style.disabled_color = {
	255,
	60,
	60,
	60
}
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
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(100, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		{
			value = "content/ui/materials/frames/line_thin_dashed_animated",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					8
				},
				color = Color.terminal_corner_selected(nil, true),
				default_color = Color.terminal_corner_selected(0, true),
				selected_color = Color.terminal_corner_selected(nil, true)
			},
			visibility_function = function (content, style)
				return content.marked
			end
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
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = Color.ui_grey_medium(255, true)
			},
			change_function = function (content, style)
				item_selection_button_change_function(content, style)
				item_selection_button_hover_change_function(content, style)
			end
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
			value_id = "description",
			pass_type = "text",
			value = "n/a",
			style_id = "description",
			style = weapon_traits_description_style,
			change_function = function (content, style)
				local hotspot = content.hotspot
				local default_color = hotspot.disabled and style.disabled_color or style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

				ColorUtilities.color_lerp(default_color, hover_color, progress, text_color)
			end
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
		local costs = config.data.costs

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
				style_id = "icon_" .. i,
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
	init = function (parent, widget, config, callback_name)
		local content = widget.content
		content.data = config.data
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local style = widget.style
		local content = widget.content
		local costs = content.data.costs

		for _, cost in pairs(costs) do
			local cost_type = cost.type
			local cost_style = style[cost_type]
			cost_style.material = cost.can_afford and cost_style.default_material or cost_style.insufficient_material
		end

		local x_offset = 0

		for i = 1, #costs do
			local cost = costs[i]
			local has_cost = cost.amount > 0
			local cost_type = cost.type
			local wallet_settings = WalletSettings[cost_type]
			local amount_label = TextUtilities.format_currency(cost.amount)
			content[cost_type] = amount_label
			local price_style = style[cost_type]
			price_style.offset[1] = x_offset

			if has_cost then
				local price_text_size = UIRenderer.text_size(ui_renderer, amount_label, price_style.font_type, price_style.font_size)
				x_offset = x_offset - price_text_size - 5
				style["icon_" .. i].offset[1] = x_offset
				x_offset = x_offset - 28 - 12
			end

			style[cost_type].visible = has_cost
			style["icon_" .. i].visible = has_cost
		end
	end
}
local TEMP_TABLE = {}
ViewElementCraftingRecipeBlueprints.trait_background = {
	size = {
		440,
		120
	},
	pass_template = {
		{
			value_id = "trait_background",
			style_id = "trait_background",
			pass_type = "texture",
			value = "content/ui/materials/frames/trait_merge_overlay",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_frame(255, true)
			}
		},
		{
			value = "content/ui/materials/frames/line_thin_detailed_02",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					-110,
					-5,
					3
				},
				size = {
					110,
					110
				},
				color = Color.terminal_frame(255, true)
			}
		},
		{
			style_id = "hotspot_1",
			pass_type = "hotspot",
			content_id = "hotspot_1",
			content = {
				hover_progress = 0,
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select
			},
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					-110,
					-5,
					3
				},
				size = {
					110,
					110
				}
			},
			change_function = function (content, style, animations, dt)
				local lerp_direction = content.is_hover and 1 or -1
				local speed = 5
				content.hover_progress = math.clamp(content.hover_progress + dt * lerp_direction * speed, 0, 1)
			end
		},
		{
			value = "content/ui/materials/frames/line_thin_detailed_01",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					-110,
					-5,
					3
				},
				size = {
					102,
					102
				},
				color = Color.terminal_grid_background(255, true)
			},
			change_function = function (content, style, animations, dt)
				local has_ingredient = content.ingredients.trait_ids[1]

				if not has_ingredient then
					style.color[1] = 158 + math.sin(Application.time_since_launch() * 4) * 97
				else
					local value = math.easeOutCubic(content.hotspot_1.hover_progress)
					style.color[1] = 255 * value
				end
			end
		},
		{
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					-151.4,
					-37,
					3
				},
				size = {
					108,
					72
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			value = "content/ui/materials/frames/line_thin_detailed_02",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					-5,
					3
				},
				size = {
					110,
					110
				},
				color = Color.terminal_frame(255, true)
			}
		},
		{
			pass_type = "texture",
			style_id = "icon_1",
			value = "content/ui/materials/icons/traits/traits_container",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {},
				size = {
					64,
					64
				},
				offset = {
					-110,
					0,
					5
				},
				color = Color.terminal_grid_background(255, true),
				unfilled_color = Color.terminal_grid_background(255, true),
				filled_color = Color.white(255, true)
			},
			change_function = function (content, style, animations, dt)
				local ingredients = content.ingredients
				local has_ingredient = ingredients.trait_ids[1]
				style.color = has_ingredient and style.filled_color or style.unfilled_color
			end
		},
		{
			value_id = "percentage_1",
			style_id = "percentage_1",
			pass_type = "text",
			value = "",
			style = {
				font_size = 15,
				text_vertical_alignment = "bottom",
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_color = Color.ui_hud_green_super_light(255, true),
				disabled_color = Color.terminal_frame(255, true),
				enabled_color = Color.ui_hud_green_super_light(255, true),
				offset = {
					62,
					-13,
					10
				}
			},
			visibility_function = function (content)
				local ingredients = content.ingredients

				return table.size(ingredients.trait_ids) == 3
			end
		},
		{
			style_id = "hotspot_2",
			pass_type = "hotspot",
			content_id = "hotspot_2",
			content = {
				hover_progress = 0,
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select
			},
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					-5,
					3
				},
				size = {
					110,
					110
				}
			},
			change_function = function (content, style, animations, dt)
				local lerp_direction = content.is_hover and 1 or -1
				local speed = 3
				content.hover_progress = math.clamp(content.hover_progress + dt * lerp_direction * speed, 0, 1)
			end
		},
		{
			value = "content/ui/materials/frames/line_thin_detailed_01",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					-5,
					3
				},
				size = {
					102,
					102
				},
				color = Color.terminal_grid_background(255, true)
			},
			change_function = function (content, style, animations, dt)
				local ingredients = content.ingredients
				local has_ingredient = ingredients.trait_ids[2]

				if not has_ingredient then
					style.color[1] = 158 + math.sin(Application.time_since_launch() * 4) * 97
				else
					local value = math.easeOutCubic(content.hotspot_2.hover_progress)
					style.color[1] = 255 * value
				end
			end
		},
		{
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					-41.4,
					-37,
					3
				},
				size = {
					108,
					72
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					-31.4,
					-37,
					3
				},
				size = {
					108,
					72
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			value = "content/ui/materials/frames/line_thin_detailed_02",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					110,
					-5,
					3
				},
				size = {
					110,
					110
				},
				color = Color.terminal_frame(255, true)
			}
		},
		{
			pass_type = "texture",
			style_id = "icon_2",
			value = "content/ui/materials/icons/traits/traits_container",
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
				color = Color.terminal_grid_background(255, true),
				unfilled_color = Color.terminal_grid_background(255, true),
				filled_color = Color.white(255, true)
			},
			change_function = function (content, style, animations, dt)
				local ingredients = content.ingredients
				local has_ingredient = ingredients.trait_ids[2]
				style.color = has_ingredient and style.filled_color or style.unfilled_color
			end
		},
		{
			value_id = "percentage_2",
			style_id = "percentage_2",
			pass_type = "text",
			value = "",
			style = {
				font_size = 15,
				text_vertical_alignment = "bottom",
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_color = Color.ui_hud_green_super_light(255, true),
				disabled_color = Color.terminal_frame(255, true),
				enabled_color = Color.ui_hud_green_super_light(255, true),
				offset = {
					172,
					-13,
					10
				}
			},
			visibility_function = function (content)
				local ingredients = content.ingredients

				return table.size(ingredients.trait_ids) == 3
			end
		},
		{
			style_id = "hotspot_3",
			pass_type = "hotspot",
			content_id = "hotspot_3",
			content = {
				hover_progress = 0,
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select
			},
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					110,
					-5,
					3
				},
				size = {
					110,
					110
				}
			},
			change_function = function (content, style, animations, dt)
				local lerp_direction = content.is_hover and 1 or -1
				local speed = 3
				content.hover_progress = math.clamp(content.hover_progress + dt * lerp_direction * speed, 0, 1)
			end
		},
		{
			value = "content/ui/materials/frames/line_thin_detailed_01",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					110,
					-5,
					3
				},
				size = {
					102,
					102
				},
				color = Color.terminal_grid_background(255, true)
			},
			change_function = function (content, style, animations, dt)
				local has_ingredient = content.ingredients.trait_ids[3]

				if not has_ingredient then
					style.color[1] = 158 + math.sin(Application.time_since_launch() * 4) * 97
				else
					local value = math.easeOutCubic(content.hotspot_3.hover_progress)
					style.color[1] = 255 * value
				end
			end
		},
		{
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					68.6,
					-37,
					3
				},
				size = {
					108,
					72
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					78.6,
					-37,
					3
				},
				size = {
					108,
					72
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					88.6,
					-37,
					3
				},
				size = {
					108,
					72
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			pass_type = "texture",
			style_id = "icon_3",
			value = "content/ui/materials/icons/traits/traits_container",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {},
				size = {
					64,
					64
				},
				offset = {
					110,
					0,
					5
				},
				color = Color.terminal_grid_background(255, true),
				unfilled_color = Color.terminal_grid_background(255, true),
				filled_color = Color.white(255, true)
			},
			change_function = function (content, style, animations, dt)
				local ingredients = content.ingredients
				local trait_ids = ingredients.trait_ids
				local has_ingredient = ingredients.trait_ids[3]
				style.color = has_ingredient and style.filled_color or style.unfilled_color
			end
		},
		{
			value_id = "percentage_3",
			style_id = "percentage_3",
			pass_type = "text",
			value = "",
			style = {
				font_size = 15,
				text_vertical_alignment = "bottom",
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_color = Color.ui_hud_green_super_light(255, true),
				disabled_color = Color.terminal_frame(255, true),
				enabled_color = Color.ui_hud_green_super_light(255, true),
				offset = {
					282,
					-13,
					10
				}
			},
			visibility_function = function (content)
				local ingredients = content.ingredients

				return table.size(ingredients.trait_ids) == 3
			end
		}
	},
	init = function (parent, widget, config, callback_name)
		local content = widget.content
		local style = widget.style
		local icon_material_values = style.icon_1.material_values
		icon_material_values.icon = ""
		local icon_material_values = style.icon_2.material_values
		icon_material_values.icon = ""
		local icon_material_values = style.icon_3.material_values
		icon_material_values.icon = ""
		content.ingredients = config.ingredients
		content.additional_data = config.additional_data
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local content = widget.content
		local style = widget.style
		local ingredients = content.ingredients
		local trait_ids = ingredients.trait_ids
		local additional_data = content.additional_data
		local sticker_book = additional_data.sticker_book

		for i = 1, 3 do
			local hotspot = content["hotspot_" .. i]

			if hotspot.on_pressed then
				parent:remove_ingredient(i)
			end
		end

		table.clear(TEMP_TABLE)

		local lowest_rarity = math.huge
		local wildcard_texture = "content/ui/textures/icons/traits/empty"

		for i = 1, 3 do
			local trait_id = trait_ids[i]
			local trait_item = parent:parent():get_trait_item_from_id(trait_id)
			local icon_material_values = style["icon_" .. i].material_values

			if trait_item then
				local trait_name = trait_item.name
				local rarity = trait_item.rarity
				local trait_collection = sticker_book and sticker_book[trait_name]
				local is_wildcard = trait_collection and (not trait_collection[rarity + 1] or sticker_book[trait_name][rarity + 1] == "invalid")
				local texture_icon, texture_frame = ItemUtils.trait_textures(trait_item, rarity)
				icon_material_values.icon = is_wildcard and wildcard_texture or texture_icon
				icon_material_values.frame = texture_frame

				if not is_wildcard then
					if rarity < lowest_rarity then
						table.clear(TEMP_TABLE)

						TEMP_TABLE[i] = true
						lowest_rarity = rarity
					elseif rarity == lowest_rarity then
						TEMP_TABLE[i] = true
					end
				end
			else
				icon_material_values.icon = ""
				icon_material_values.frame = "content/ui/textures/icons/traits/trait_icon_frame_00_large"
			end
		end

		local num_viable_traits = table.size(TEMP_TABLE)
		local percentage = 1 / num_viable_traits * 100
		local is_fraction = percentage ~= math.floor(percentage)

		for i = 1, 3 do
			local id = "percentage_" .. i

			if TEMP_TABLE[i] then
				if is_fraction then
					content[id] = string.format("%.1f%%", percentage)
				else
					content[id] = string.format("%d%%", percentage)
				end

				style[id].text_color = style[id].enabled_color
			else
				content[id] = "0%"
				style[id].text_color = style[id].disabled_color
			end
		end
	end
}
local counter_size = {
	430,
	90
}
ViewElementCraftingRecipeBlueprints.modifications_counter = {
	size = counter_size,
	pass_template = {
		{
			pass_type = "rect",
			style = {
				color = Color.terminal_frame(255, true)
			}
		},
		{
			value_id = "counter",
			style_id = "counter",
			pass_type = "text",
			value = "",
			style = {
				font_size = 28,
				text_vertical_alignment = "top",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "proxima_nova_bold",
				text_color = Color.ui_hud_green_super_light(255, true),
				disabled_color = Color.terminal_frame(255, true),
				enabled_color = Color.ui_hud_green_super_light(255, true),
				size = {
					counter_size[1] - 30,
					counter_size[2] - 30
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			value_id = "description",
			style_id = "description",
			pass_type = "text",
			value = Localize("loc_crafting_item_modifications_text"),
			style = {
				font_size = 18,
				text_vertical_alignment = "bottom",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "proxima_nova_bold",
				text_color = Color.terminal_text_body(255, true),
				size = {
					counter_size[1] - 30,
					counter_size[2] - 30
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	},
	init = function (parent, widget, config, callback_name)
		local item = config.item or parent.content.item

		if item then
			local num_modifications, max_modifications = ItemUtils.modifications_by_rarity(item)
			widget.content.counter = string.format(" %d/%d", num_modifications, max_modifications)
			widget.content.item = item
		end
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local item = parent.content.item

		if item ~= widget.content.item then
			local num_modifications, max_modifications = ItemUtils.modifications_by_rarity(item)
			widget.content.counter = string.format(" %d/%d", num_modifications, max_modifications)
			widget.content.item = item
		end
	end
}

return ViewElementCraftingRecipeBlueprints
