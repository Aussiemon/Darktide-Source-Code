-- chunkname: @scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe_blueprints.lua

local Items = require("scripts/utilities/items")
local WalletSettings = require("scripts/settings/wallet_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Colors = require("scripts/utilities/ui/colors")
local TextUtilities = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")

local function thumb_position_change_function(content, style)
	if content.parent then
		content = content.parent
	end

	local slider_horizontal_offset = content.slider_horizontal_offset or 0

	style.offset[1] = slider_horizontal_offset
end

local function highlight_color_change_function(content, style)
	local default_color = content.disabled and style.disabled_color or style.default_color
	local hover_color = content.disabled and style.disabled_color or style.hover_color
	local color = style.color or style.text_color
	local hotspot = content.hotspot
	local is_highlighted = hotspot.is_hover or hotspot.is_selected or hotspot.is_focused
	local progress = is_highlighted and content.highlight_progress or 0

	Colors.color_lerp(default_color, hover_color, progress, color)
end

local ViewElementCraftingRecipeBlueprints = {}

ViewElementCraftingRecipeBlueprints.spacing_vertical_small = {
	size = {
		430,
		5,
	},
}
ViewElementCraftingRecipeBlueprints.spacing_vertical = {
	size = {
		430,
		20,
	},
}
ViewElementCraftingRecipeBlueprints.spacing_vertical_large = {
	size = {
		430,
		50,
	},
}

local navigation_button_pass_template = table.merge({}, ButtonPassTemplates.terminal_list_button_with_background_and_icon)

navigation_button_pass_template[#navigation_button_pass_template + 1] = {
	pass_type = "text",
	value = Localize("loc_action_interaction_coming_soon"),
	style = {
		font_size = 20,
		font_type = "proxima_nova_bold",
		material = "content/ui/materials/font_gradients/slug_font_gradient_header",
		text_horizontal_alignment = "right",
		text_vertical_alignment = "center",
		text_color = Color.cheeseburger(255, true),
		offset = {
			-65,
			2,
			3,
		},
	},
	visibility_function = function (content)
		return content.coming_soon
	end,
}
navigation_button_pass_template[#navigation_button_pass_template + 1] = {
	pass_type = "text",
	value = "",
	value_id = "error_text",
	style = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "left",
		text_vertical_alignment = "bottom",
		incomplete_color = Color.light_gray(255, true),
		complete_color = Color.terminal_text_key_value(255, true),
		default_color = Color.ui_red_medium(255, true),
		text_color = Color.ui_red_medium(255, true),
		offset = {
			70,
			-5,
			3,
		},
		size_addition = {
			-80,
			0,
		},
	},
	change_function = function (content, style)
		if content.error_type == "complete" then
			style.text_color = table.clone(style.complete_color)
		elseif content.error_type == "incomplete" then
			style.text_color = table.clone(style.incomplete_color)
		else
			style.text_color = table.clone(style.default_color)
		end
	end,
}
ViewElementCraftingRecipeBlueprints.navigation_button = {
	size = {
		430,
		64,
	},
	pass_template = navigation_button_pass_template,
	init = function (parent, widget, config, callback_name)
		local recipe = config.recipe
		local content = widget.content

		content.text = recipe.unlocalized_display_name or recipe.display_name and Localize(recipe.display_name)
		content.icon = recipe.icon
		content.coming_soon = recipe.ui_disabled
		content.expertise_data = config.expertise_data

		local hotspot = content.hotspot

		hotspot.disabled = true
		hotspot.pressed_callback = callback(parent, callback_name, widget, config)
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local content = widget.content
		local style = widget.style
		local recipe = content.entry.recipe

		if recipe.ui_disabled then
			return
		end

		local validation_function = recipe.is_valid_item
		local item = parent.content.item

		if validation_function and item then
			local item = parent.content.item
			local is_valid_item, reason, error_type = validation_function(item, {
				expertise_data = content.expertise_data,
			})

			content.hotspot.disabled = not is_valid_item
			content.error_text = reason or ""
			content.error_type = error_type
			style.text.offset[2] = content.error_text ~= "" and -10 or 0
		end
	end,
}
ViewElementCraftingRecipeBlueprints.craft_button = {
	size = {
		430,
		64,
	},
	pass_template = ButtonPassTemplates.terminal_button,
	init = function (parent, widget, config, callback_name)
		local content = widget.content

		content.text = config.unlocalized_text or Localize(config.text or "loc_confirm")

		local hotspot = content.hotspot

		hotspot.on_pressed_sound = config.sound_event
		hotspot.pressed_callback = callback(parent, callback_name, widget, config)
		hotspot.disabled = true
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		widget.content.hotspot.disabled = not parent.content.can_craft
	end,
}
ViewElementCraftingRecipeBlueprints.title = {
	size = {
		430,
		30,
	},
	pass_template = {
		{
			pass_type = "text",
			value = "text",
			value_id = "text",
			style = table.merge({
				text_horizontal_alignment = "center",
			}, UIFontSettings.terminal_header_3),
		},
	},
	init = function (parent, widget, config)
		widget.content.text = config.unlocalized_text or config.text and Localize(config.text) or ""
	end,
}

local description_text_style = UIFontSettings.body_small

ViewElementCraftingRecipeBlueprints.description = {
	size = {
		430,
		128,
	},
	size_function = function (parent, config, ui_renderer)
		local style = description_text_style
		local base_size = ViewElementCraftingRecipeBlueprints.description.size
		local text_options = UIFonts.get_font_options_by_style(style)
		local text = config.unlocalized_text or config.text and Localize(config.text) or "AWWWW"
		local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, base_size, text_options)

		return {
			430,
			text_height + 8,
		}
	end,
	pass_template = {
		{
			pass_type = "text",
			style_id = "text",
			value = "text",
			value_id = "text",
			style = description_text_style,
		},
	},
	init = function (parent, widget, config)
		widget.content.text = config.unlocalized_text or config.text and Localize(config.text) or ""

		local override_color = config.color

		if override_color then
			widget.style.text.text_color = override_color
		end
	end,
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
	local color

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
		Colors.color_copy(color, style.color)
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
	10,
}
weapon_perk_style.size_addition = {
	-105,
	0,
}
weapon_perk_style.font_size = 18
weapon_perk_style.text_horizontal_alignment = "left"
weapon_perk_style.text_vertical_alignment = "center"
weapon_perk_style.text_color = {
	255,
	216,
	229,
	207,
}
weapon_perk_style.default_color = {
	255,
	216,
	229,
	207,
}
weapon_perk_style.hover_color = Color.white(255, true)
weapon_perk_style.disabled_color = {
	255,
	60,
	60,
	60,
}
ViewElementCraftingRecipeBlueprints.perk_button = {
	size = {
		340,
		54,
	},
	size_function = function (parent, config, ui_renderer)
		local style = weapon_perk_style
		local text = Items.trait_description(config.item, config.rarity, config.value)
		local text_options = UIFonts.get_font_options_by_style(style)
		local size = ViewElementCraftingRecipeBlueprints.perk_button.size
		local size_addition = style.size_addition
		local actual_text_size = {
			430 + (size_addition[1] or 0),
			size[2] + (size_addition[2] or 0),
		}
		local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, actual_text_size, text_options)

		return {
			430,
			20 + math.max(20, text_height),
		}
	end,
	pass_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select,
			},
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(100, true),
				size_addition = {
					20,
					20,
				},
				offset = {
					0,
					0,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/line_thin_dashed_animated",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					0,
					0,
					8,
				},
				color = Color.terminal_corner_selected(nil, true),
				default_color = Color.terminal_corner_selected(0, true),
				selected_color = Color.terminal_corner_selected(nil, true),
			},
			visibility_function = function (content, style)
				return content.marked
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				default_color = Color.terminal_background(nil, true),
				selected_color = Color.terminal_background_selected(nil, true),
			},
			change_function = item_selection_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2,
				},
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
			},
			change_function = function (content, style)
				item_selection_button_change_function(content, style)
				item_selection_button_hover_change_function(content, style)
			end,
		},
		{
			pass_type = "texture",
			style_id = "button_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					0,
					0,
					3,
				},
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
			},
			change_function = item_selection_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "button_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					0,
					0,
					4,
				},
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
			},
			change_function = item_selection_button_change_function,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/perks/perk_level_01",
			value_id = "rank",
			style = {
				vertical_alignment = "center",
				size = {
					20,
					20,
				},
				offset = {
					14,
					0,
					10,
				},
				color = Color.terminal_icon(255, true),
			},
		},
		{
			pass_type = "text",
			value = "n/a",
			value_id = "description",
			style = weapon_perk_style,
			change_function = function (content, style)
				local hotspot = content.hotspot
				local default_color = hotspot.disabled and style.disabled_color or style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

				Colors.color_lerp(default_color, hover_color, progress, text_color)
			end,
		},
	},
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local content = widget.content
		local item = config.item
		local rarity = config.rarity

		content.description = Items.trait_description(item, rarity, config.value)
		content.rank = Items.perk_textures(item, rarity)
		content.hotspot.pressed_callback = callback(parent, secondary_callback_name, widget, config)
	end,
}

local weapon_traits_style = table.clone(UIFontSettings.header_3)

weapon_traits_style.offset = {
	98,
	10,
	10,
}
weapon_traits_style.size = {
	324,
}
weapon_traits_style.font_size = 18
weapon_traits_style.text_horizontal_alignment = "left"
weapon_traits_style.text_vertical_alignment = "top"
weapon_traits_style.text_color = {
	255,
	216,
	229,
	207,
}
weapon_traits_style.default_color = {
	255,
	216,
	229,
	207,
}
weapon_traits_style.hover_color = Color.white(255, true)
weapon_traits_style.disabled_color = {
	255,
	60,
	60,
	60,
}

local weapon_traits_description_style = table.clone(UIFontSettings.body)

weapon_traits_description_style.offset = {
	98,
	30,
	11,
}
weapon_traits_description_style.size = {
	274,
	500,
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
	60,
}
ViewElementCraftingRecipeBlueprints.trait_button = {
	size_function = function (parent, config, ui_renderer)
		local style = weapon_traits_description_style
		local text = Items.trait_description(config.item, config.rarity, config.value)
		local text_options = UIFonts.get_font_options_by_style(style)
		local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, style.size, text_options)

		return {
			430,
			20 + math.max(68, text_height + 25),
		}
	end,
	pass_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select,
			},
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(100, true),
				size_addition = {
					20,
					20,
				},
				offset = {
					0,
					0,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/line_thin_dashed_animated",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					0,
					0,
					8,
				},
				color = Color.terminal_corner_selected(nil, true),
				default_color = Color.terminal_corner_selected(0, true),
				selected_color = Color.terminal_corner_selected(nil, true),
			},
			visibility_function = function (content, style)
				return content.marked
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				default_color = Color.terminal_background(nil, true),
				selected_color = Color.terminal_background_selected(nil, true),
			},
			change_function = item_selection_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2,
				},
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = Color.ui_grey_medium(255, true),
			},
			change_function = function (content, style)
				item_selection_button_change_function(content, style)
				item_selection_button_hover_change_function(content, style)
			end,
		},
		{
			pass_type = "texture",
			style_id = "button_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					0,
					0,
					3,
				},
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
			},
			change_function = item_selection_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "button_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "right",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					0,
					0,
					4,
				},
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
			},
			change_function = item_selection_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/traits/traits_container",
			style = {
				material_values = {},
				size = {
					64,
					64,
				},
				offset = {
					20,
					10,
					10,
				},
				color = Color.terminal_icon(255, true),
			},
		},
		{
			pass_type = "text",
			value = "n/a",
			value_id = "display_name",
			style = weapon_traits_style,
		},
		{
			pass_type = "text",
			style_id = "description",
			value = "n/a",
			value_id = "description",
			style = weapon_traits_description_style,
			change_function = function (content, style)
				local hotspot = content.hotspot
				local default_color = hotspot.disabled and style.disabled_color or style.default_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

				Colors.color_lerp(default_color, hover_color, progress, text_color)
			end,
		},
	},
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local content = widget.content
		local style = widget.style

		content.hotspot.pressed_callback = callback(parent, secondary_callback_name, widget, config)

		local rarity = config.rarity
		local item = config.item

		content.display_name = Localize(item.display_name)
		content.description = Items.trait_description(item, rarity, config.value)

		local icon_material_values = style.icon.material_values

		icon_material_values.icon, icon_material_values.frame = Items.trait_textures(item, rarity)
	end,
}

local warning_text_style = table.clone(UIFontSettings.body_small)

warning_text_style.incomplete_color = Color.light_gray(255, true)
warning_text_style.complete_color = Color.terminal_text_key_value(255, true)
warning_text_style.default_color = Color.ui_red_medium(255, true)
ViewElementCraftingRecipeBlueprints.warning = {
	size = {
		430,
		30,
	},
	size_function = function (parent, config, ui_renderer)
		local style = description_text_style
		local base_size = ViewElementCraftingRecipeBlueprints.warning.size
		local text_options = UIFonts.get_font_options_by_style(style)
		local text = config.unlocalized_text or config.text or "AWWWW"
		local _, text_height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, base_size, text_options)

		return {
			430,
			text_height + 8,
		}
	end,
	pass_template = {
		{
			pass_type = "text",
			style_id = "text",
			value = "text",
			value_id = "text",
			style = warning_text_style,
		},
	},
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local parent_content = parent.content
		local can_craft = parent_content.can_craft
		local fail_reason = parent_content.fail_reason
		local error_type = parent_content.error_type

		widget.style.text.visible = not can_craft and fail_reason

		if not can_craft then
			widget.content.text = fail_reason or Localize("loc_crafting_failure")

			if error_type == "complete" then
				widget.style.text.text_color = table.clone(widget.style.text.complete_color)
			elseif error_type == "incomplete" then
				widget.style.text.text_color = table.clone(widget.style.text.incomplete_color)
			else
				widget.style.text.text_color = table.clone(widget.style.text.default_color)
			end
		end
	end,
}
ViewElementCraftingRecipeBlueprints.recipe_costs = {
	size = {
		430,
		32,
	},
	pass_template_function = function (self, config, ui_renderer)
		local passes = {}

		passes[#passes + 1] = {
			pass_type = "text",
			value = Localize("loc_price"),
			style = UIFontSettings.body,
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
				10,
			}
			price_style.default_material = wallet_settings.font_gradient_material
			price_style.insufficient_material = wallet_settings.font_gradient_material_insufficient_funds
			price_style.material = price_style.default_material
			price_style.text_color = {
				255,
				255,
				255,
				255,
			}
			passes[#passes + 1] = {
				pass_type = "text",
				value_id = cost_type,
				value = amount_label,
				style_id = cost_type,
				style = price_style,
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
						20,
					},
					offset = {
						x_offset,
						5,
						0,
					},
				},
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
	end,
}

local TEMP_TABLE = {}

ViewElementCraftingRecipeBlueprints.trait_background = {
	size = {
		440,
		120,
	},
	pass_template = {
		{
			pass_type = "texture",
			style_id = "trait_background",
			value = "content/ui/materials/frames/trait_merge_overlay",
			value_id = "trait_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_frame(255, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/line_thin_detailed_02",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					-110,
					-5,
					3,
				},
				size = {
					110,
					110,
				},
				color = Color.terminal_frame(255, true),
			},
		},
		{
			content_id = "hotspot_1",
			pass_type = "hotspot",
			style_id = "hotspot_1",
			content = {
				hover_progress = 0,
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select,
			},
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					-110,
					-5,
					3,
				},
				size = {
					110,
					110,
				},
			},
			change_function = function (content, style, animations, dt)
				local lerp_direction = content.is_hover and 1 or -1
				local speed = 5

				content.hover_progress = math.clamp(content.hover_progress + dt * lerp_direction * speed, 0, 1)
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/line_thin_detailed_01",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					-110,
					-5,
					3,
				},
				size = {
					102,
					102,
				},
				color = Color.terminal_grid_background(255, true),
			},
			change_function = function (content, style, animations, dt)
				local has_ingredient = content.ingredients.trait_ids[1]

				if not has_ingredient then
					style.color[1] = 158 + math.sin(Application.time_since_launch() * 4) * 97
				else
					local value = math.easeOutCubic(content.hotspot_1.hover_progress)

					style.color[1] = 255 * value
				end
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					-151.4,
					-37,
					3,
				},
				size = {
					108,
					72,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/line_thin_detailed_02",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					-5,
					3,
				},
				size = {
					110,
					110,
				},
				color = Color.terminal_frame(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "icon_1",
			value = "content/ui/materials/icons/traits/traits_container",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				material_values = {},
				size = {
					64,
					64,
				},
				offset = {
					-110,
					0,
					5,
				},
				color = Color.terminal_grid_background(255, true),
				unfilled_color = Color.terminal_grid_background(255, true),
				filled_color = Color.white(255, true),
			},
			change_function = function (content, style, animations, dt)
				local ingredients = content.ingredients
				local has_ingredient = ingredients.trait_ids[1]

				style.color = has_ingredient and style.filled_color or style.unfilled_color
			end,
		},
		{
			pass_type = "text",
			style_id = "percentage_1",
			value = "",
			value_id = "percentage_1",
			style = {
				font_size = 15,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				text_color = Color.ui_hud_green_super_light(255, true),
				disabled_color = Color.terminal_frame(255, true),
				enabled_color = Color.ui_hud_green_super_light(255, true),
				offset = {
					62,
					-13,
					10,
				},
			},
			visibility_function = function (content)
				local ingredients = content.ingredients

				return table.size(ingredients.trait_ids) == 3
			end,
		},
		{
			content_id = "hotspot_2",
			pass_type = "hotspot",
			style_id = "hotspot_2",
			content = {
				hover_progress = 0,
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select,
			},
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					-5,
					3,
				},
				size = {
					110,
					110,
				},
			},
			change_function = function (content, style, animations, dt)
				local lerp_direction = content.is_hover and 1 or -1
				local speed = 3

				content.hover_progress = math.clamp(content.hover_progress + dt * lerp_direction * speed, 0, 1)
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/line_thin_detailed_01",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					-5,
					3,
				},
				size = {
					102,
					102,
				},
				color = Color.terminal_grid_background(255, true),
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
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					-41.4,
					-37,
					3,
				},
				size = {
					108,
					72,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					-31.4,
					-37,
					3,
				},
				size = {
					108,
					72,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/line_thin_detailed_02",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					110,
					-5,
					3,
				},
				size = {
					110,
					110,
				},
				color = Color.terminal_frame(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "icon_2",
			value = "content/ui/materials/icons/traits/traits_container",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				material_values = {},
				size = {
					64,
					64,
				},
				offset = {
					0,
					0,
					5,
				},
				color = Color.terminal_grid_background(255, true),
				unfilled_color = Color.terminal_grid_background(255, true),
				filled_color = Color.white(255, true),
			},
			change_function = function (content, style, animations, dt)
				local ingredients = content.ingredients
				local has_ingredient = ingredients.trait_ids[2]

				style.color = has_ingredient and style.filled_color or style.unfilled_color
			end,
		},
		{
			pass_type = "text",
			style_id = "percentage_2",
			value = "",
			value_id = "percentage_2",
			style = {
				font_size = 15,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				text_color = Color.ui_hud_green_super_light(255, true),
				disabled_color = Color.terminal_frame(255, true),
				enabled_color = Color.ui_hud_green_super_light(255, true),
				offset = {
					172,
					-13,
					10,
				},
			},
			visibility_function = function (content)
				local ingredients = content.ingredients

				return table.size(ingredients.trait_ids) == 3
			end,
		},
		{
			content_id = "hotspot_3",
			pass_type = "hotspot",
			style_id = "hotspot_3",
			content = {
				hover_progress = 0,
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select,
			},
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					110,
					-5,
					3,
				},
				size = {
					110,
					110,
				},
			},
			change_function = function (content, style, animations, dt)
				local lerp_direction = content.is_hover and 1 or -1
				local speed = 3

				content.hover_progress = math.clamp(content.hover_progress + dt * lerp_direction * speed, 0, 1)
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/line_thin_detailed_01",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					110,
					-5,
					3,
				},
				size = {
					102,
					102,
				},
				color = Color.terminal_grid_background(255, true),
			},
			change_function = function (content, style, animations, dt)
				local has_ingredient = content.ingredients.trait_ids[3]

				if not has_ingredient then
					style.color[1] = 158 + math.sin(Application.time_since_launch() * 4) * 97
				else
					local value = math.easeOutCubic(content.hotspot_3.hover_progress)

					style.color[1] = 255 * value
				end
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					68.6,
					-37,
					3,
				},
				size = {
					108,
					72,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					78.6,
					-37,
					3,
				},
				size = {
					108,
					72,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/appearances/roman_numerals/roman_one",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					88.6,
					-37,
					3,
				},
				size = {
					108,
					72,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "icon_3",
			value = "content/ui/materials/icons/traits/traits_container",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				material_values = {},
				size = {
					64,
					64,
				},
				offset = {
					110,
					0,
					5,
				},
				color = Color.terminal_grid_background(255, true),
				unfilled_color = Color.terminal_grid_background(255, true),
				filled_color = Color.white(255, true),
			},
			change_function = function (content, style, animations, dt)
				local ingredients = content.ingredients
				local trait_ids = ingredients.trait_ids
				local has_ingredient = ingredients.trait_ids[3]

				style.color = has_ingredient and style.filled_color or style.unfilled_color
			end,
		},
		{
			pass_type = "text",
			style_id = "percentage_3",
			value = "",
			value_id = "percentage_3",
			style = {
				font_size = 15,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				text_color = Color.ui_hud_green_super_light(255, true),
				disabled_color = Color.terminal_frame(255, true),
				enabled_color = Color.ui_hud_green_super_light(255, true),
				offset = {
					282,
					-13,
					10,
				},
			},
			visibility_function = function (content)
				local ingredients = content.ingredients

				return table.size(ingredients.trait_ids) == 3
			end,
		},
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
				local texture_icon, texture_frame = Items.trait_textures(trait_item, rarity)

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
	end,
}

local counter_size = {
	430,
	90,
}

ViewElementCraftingRecipeBlueprints.modifications_counter = {
	size = counter_size,
	pass_template = {
		{
			pass_type = "rect",
			style = {
				color = Color.terminal_frame(255, true),
			},
		},
		{
			pass_type = "text",
			style_id = "counter",
			value = "",
			value_id = "counter",
			style = {
				font_size = 28,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				vertical_alignment = "center",
				text_color = Color.ui_hud_green_super_light(255, true),
				disabled_color = Color.terminal_frame(255, true),
				enabled_color = Color.ui_hud_green_super_light(255, true),
				size = {
					counter_size[1] - 30,
					counter_size[2] - 30,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "description",
			value_id = "description",
			value = Localize("loc_crafting_item_modifications_text"),
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "center",
				text_color = Color.terminal_text_body(255, true),
				size = {
					counter_size[1] - 30,
					counter_size[2] - 30,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	},
	init = function (parent, widget, config, callback_name)
		local item = config.item or parent.content.item

		if item then
			-- Nothing
		end
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local item = parent.content.item

		if item ~= widget.content.item then
			-- Nothing
		end
	end,
}

local SLIDER_TRACK_HEIGHT = 20
local SLIDER_ENDPLATE_WIDTH = 4
local SLIDER_THUMB_SIZE = 38
local THUMB_HIGHLIGHT_SIZE = 58
local LABEL_WIDTH = 80
local EXTRA_SLIDER_TRACK_SIZE = 5
local settings_area_width = 280
local highlight_size_addition = 10
local slider_offset = (counter_size[1] - settings_area_width) * 0.5
local track_thickness = SLIDER_ENDPLATE_WIDTH
local slider_area_width = settings_area_width - (SLIDER_ENDPLATE_WIDTH * 2 + SLIDER_THUMB_SIZE)
local slider_horizontal_offset = SLIDER_ENDPLATE_WIDTH + (counter_size[1] - settings_area_width) * 0.5
local thumb_highlight_expanded_size = THUMB_HIGHLIGHT_SIZE + highlight_size_addition
local value_font_style = table.clone(UIFontSettings.list_button)

value_font_style.size = {
	LABEL_WIDTH,
}
value_font_style.offset = {
	slider_horizontal_offset - (LABEL_WIDTH + 10),
	0,
	8,
}
value_font_style.text_horizontal_alignment = "right"
ViewElementCraftingRecipeBlueprints.slider = {
	size = {
		settings_area_width,
		counter_size[2],
	},
	pass_template = {
		{
			pass_type = "logic",
			value = function (pass, renderer, style, content, position, size)
				local axis = content.axis or 1
				local hotspot = content.track_hotspot
				local on_pressed = hotspot.on_pressed
				local is_disabled = content.entry and content.entry.disabled or false

				if not content.drag_active then
					if on_pressed then
						content.drag_active = not is_disabled

						if content.drag_active and IS_WINDOWS then
							Window.set_clip_cursor(true)
						end
					else
						return
					end
				end

				local input_service = renderer.input_service
				local input_action = content.input_action or "left_hold"
				local left_hold = input_service and input_service:get(input_action)

				if not left_hold then
					content.drag_active = nil
					content.input_offset = nil

					if IS_WINDOWS then
						Window.set_clip_cursor(false)
					end

					return
				else
					content.scroll_add = nil
				end

				local inverse_scale = renderer.inverse_scale
				local base_cursor = input_service:get("cursor")
				local cursor = (IS_XBS or IS_PLAYSTATION) and base_cursor or UIResolution.inverse_scale_vector(base_cursor, inverse_scale)
				local cursor_direction = cursor[axis]
				local input_coordinate = cursor_direction - (position[axis] + slider_horizontal_offset)
				local input_offset = content.input_offset

				if not input_offset then
					local current_thumb_position = content.slider_value * slider_area_width

					input_offset = input_coordinate - current_thumb_position

					if input_offset < 0 or input_offset > SLIDER_THUMB_SIZE then
						input_offset = SLIDER_THUMB_SIZE * 0.5
					end

					content.input_offset = input_offset
				end

				input_coordinate = math.clamp(input_coordinate - input_offset, 0, slider_area_width)

				local slider_value = input_coordinate / slider_area_width
				local step_size = content.step_size

				if step_size then
					slider_value = math.round(slider_value / step_size) * step_size
				end

				content.slider_value = slider_value
			end,
		},
		{
			pass_type = "logic",
			style_id = "mouse_scroll",
			visibility_function = function (content, style)
				return content.exclusive_focus or content.hotspot.is_hover
			end,
			value = function (pass, renderer, style, content, position, size)
				local is_disabled = content.entry and content.entry.disabled or false

				if content.drag_active or not content.is_gamepad_active or is_disabled then
					return
				end

				local dt = renderer.dt
				local input_service = renderer.input_service
				local left_axis = input_service:get("navigate_left_continuous_fast")
				local right_axis = input_service:get("navigate_right_continuous_fast")
				local scroll_axis = left_axis and -1 or right_axis and 1 or 0
				local step_size = content.step_size
				local scroll_amount = content.scroll_amount or 0.01

				if scroll_axis ~= 0 then
					content.scroll_axis = scroll_axis

					local previous_scroll_add = content.scroll_add or 0

					content.scroll_add = previous_scroll_add + (step_size or scroll_amount) * scroll_axis
				end

				local scroll_add = content.scroll_add

				if scroll_add then
					local step = 0

					if step_size then
						step = content.scroll_add
						content.scroll_add = nil
					else
						local speed = content.scroll_speed or 8

						step = scroll_add * (dt * speed)

						if math.abs(scroll_add) > scroll_amount / 10 then
							content.scroll_add = scroll_add - step
						else
							content.scroll_add = nil
						end
					end

					local input_slider_value = content.slider_value or 0

					content.slider_value = math.clamp(input_slider_value + step, 0, 1)
				end
			end,
		},
		{
			content_id = "track_hotspot",
			pass_type = "hotspot",
			style_id = "track_hotspot",
			style = {
				anim_focus_speed = 8,
				anim_hover_speed = 8,
				anim_input_speed = 8,
				anim_select_speed = 8,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					settings_area_width,
					SLIDER_THUMB_SIZE,
				},
				offset = {
					slider_horizontal_offset,
					0,
					3,
				},
			},
			visibility_function = function (content, style)
				return not content.parent.hotspot.disabled
			end,
			change_function = function (content, style)
				local slider_value = content.parent.slider_value or 0

				content.parent.slider_horizontal_offset = slider_horizontal_offset + slider_value * slider_area_width
			end,
		},
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style_id = "hotspot",
			content = {
				use_is_focused = true,
			},
		},
		{
			pass_type = "texture",
			style_id = "slider_track_background",
			value = "content/ui/materials/buttons/background_selected",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					settings_area_width,
					SLIDER_TRACK_HEIGHT,
				},
				color = Color.terminal_corner_hover(255, true),
				offset = {
					slider_horizontal_offset,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "slider_track_endplate_left",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					SLIDER_ENDPLATE_WIDTH,
					SLIDER_TRACK_HEIGHT,
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
				offset = {
					slider_horizontal_offset - SLIDER_ENDPLATE_WIDTH,
					0,
					2,
				},
			},
			change_function = highlight_color_change_function,
		},
		{
			pass_type = "texture",
			style_id = "slider_track_endplate_right",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					SLIDER_ENDPLATE_WIDTH,
					SLIDER_TRACK_HEIGHT,
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
				offset = {
					slider_horizontal_offset,
					0,
					2,
				},
			},
			change_function = highlight_color_change_function,
		},
		{
			pass_type = "texture",
			style_id = "slider_track_left",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					slider_area_width,
					track_thickness,
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
				offset = {
					slider_horizontal_offset,
					0,
					2,
				},
			},
			change_function = function (content, style)
				style.size[1] = content.slider_value * slider_area_width + EXTRA_SLIDER_TRACK_SIZE

				highlight_color_change_function(content, style)
			end,
		},
		{
			pass_type = "texture",
			style_id = "slider_track",
			value = "content/ui/materials/buttons/background_selected_edge",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					slider_area_width,
					track_thickness,
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
				offset = {
					slider_horizontal_offset - SLIDER_ENDPLATE_WIDTH,
					0,
					2,
				},
			},
			change_function = function (content, style)
				style.size[1] = (1 - content.slider_value) * slider_area_width + EXTRA_SLIDER_TRACK_SIZE

				highlight_color_change_function(content, style)
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/buttons/slider_handle_line",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					slider_horizontal_offset,
					0,
					7,
				},
				size = {
					SLIDER_THUMB_SIZE,
					SLIDER_THUMB_SIZE,
				},
				disabled_color = Color.terminal_text_body_dark(255, true),
				default_color = Color.terminal_corner(255, true),
				hover_color = Color.terminal_corner_hover(255, true),
			},
			change_function = function (content, style)
				thumb_position_change_function(content, style)
				highlight_color_change_function(content, style)
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/buttons/slider_handle_fill",
			style = {
				vertical_alignment = "center",
				offset = {
					slider_horizontal_offset,
					0,
					6,
				},
				size = {
					SLIDER_THUMB_SIZE,
					SLIDER_THUMB_SIZE,
				},
				color = Color.black(255, true),
			},
			change_function = function (content, style)
				thumb_position_change_function(content, style)
			end,
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/buttons/slider_handle_highlight",
			style = {
				vertical_alignment = "center",
				offset = {
					slider_horizontal_offset,
					0,
					9,
				},
				size = {
					SLIDER_THUMB_SIZE,
					SLIDER_THUMB_SIZE,
				},
				color = Color.terminal_corner_hover(255, true),
			},
			visibility_function = function (content, style)
				local highlight_progress = content.highlight_progress or 0

				return highlight_progress > 0
			end,
			change_function = function (content, style)
				thumb_position_change_function(content, style)

				local is_disabled = content.entry and content.entry.disabled or false
				local active = content.drag_active or content.focused
				local progress = is_disabled and 0 or active and 1 or content.track_hotspot.anim_hover_progress

				style.color[1] = 255 * math.easeOutCubic(progress)

				local new_size = math.lerp(thumb_highlight_expanded_size, THUMB_HIGHLIGHT_SIZE, math.easeInCubic(progress))
				local size = style.size

				size[1] = new_size
				size[2] = new_size

				local offset_addition = (new_size - SLIDER_THUMB_SIZE) * 0.5
				local axis = content.axis or 1

				style.offset[axis] = style.offset[axis] - offset_addition
			end,
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				size = {
					80,
					40,
				},
				color = Color.terminal_text_body_dark(255, true),
				offset = {
					slider_horizontal_offset,
					-30,
					1,
				},
			},
		},
		{
			pass_type = "text",
			value = "",
			value_id = "value_text",
			style = {
				font_size = 24,
				text_horizontal_alignment = "center",
				text_color = Color.white(255, true),
				offset = {
					slider_horizontal_offset,
					-23,
					1,
				},
			},
		},
		{
			pass_type = "text",
			value = "",
			value_id = "start",
			style = {
				text_horizontal_alignment = "left",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					slider_horizontal_offset - 80,
					30,
					0,
				},
			},
		},
		{
			pass_type = "text",
			value = "",
			value_id = "current_max",
			style = {
				text_horizontal_alignment = "right",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					70 + slider_horizontal_offset,
					30,
					0,
				},
			},
		},
	},
	init = function (parent, widget, entry, callback_name)
		local content = widget.content

		content.min_value = entry.additional_data.expertise_data.start
		content.max_value = math.max(content.min_value, entry.additional_data.expertise_data.max_available)
		content.entry = entry
		content.step_size = 100 / (content.max_value - content.min_value) * 0.01 * Items.get_expertise_multiplier()
		content.apply_on_drag = true

		local value_fraction = 0

		content.previous_slider_value = value_fraction
		content.slider_value = value_fraction

		local display_value = content.min_value

		if display_value then
			content.value_text = string.format(" %s", display_value or 0)
		end

		local start = entry.additional_data.expertise_data.start
		local current_max = entry.additional_data.expertise_data.max_available

		content.start = start or 0
		content.current_max = current_max or 0
	end,
	update = function (parent, widget, input_service, dt, t)
		local content = widget.content
		local entry = content.entry
		local pass_input = true
		local is_disabled = entry.disabled or false

		content.disabled = is_disabled

		local using_gamepad = not parent._using_cursor_navigation
		local min_value = content.min_value
		local max_value = content.max_value
		local previous_slider_value = content.previous_slider_value
		local value = content.slider_value
		local normalized_value = math.normalize_01(value, min_value, max_value)
		local on_activated = entry.on_activated
		local format_value_function = entry.format_value_function
		local drag_value, new_normalized_value
		local apply_on_drag = content.apply_on_drag and not is_disabled
		local drag_active = content.drag_active and not is_disabled
		local drag_previously_active = content.drag_previously_active
		local focused = content.exclusive_focus and using_gamepad and not is_disabled

		if drag_active or focused then
			local slider_value = content.slider_value

			drag_value = slider_value
		elseif not focused or drag_previously_active then
			local slider_value = content.slider_value

			if drag_previously_active then
				if previous_slider_value ~= slider_value then
					new_normalized_value = slider_value
					drag_value = slider_value
				end
			elseif normalized_value ~= slider_value then
				content.scroll_add = nil
			end
		end

		content.drag_previously_active = drag_active

		local hotspot = content.hotspot

		if hotspot.on_pressed and focused then
			new_normalized_value = content.slider_value
		end

		if apply_on_drag and drag_value and not new_normalized_value and content.slider_value ~= content.previous_slider_value then
			new_normalized_value = content.slider_value
		end

		if new_normalized_value then
			content.slider_value = new_normalized_value
			content.previous_slider_value = new_normalized_value
			content.scroll_add = nil

			local display_value = math.lerp(min_value, max_value, new_normalized_value)

			if display_value then
				content.value_text = string.format(" %s", display_value or 0)
			end

			on_activated(new_normalized_value)
		end

		return pass_input
	end,
}
ViewElementCraftingRecipeBlueprints.max_expertise_reached = {
	size = {
		counter_size[1],
		counter_size[2] - 30,
	},
	pass_template = {
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				size = {
					80,
					40,
				},
				color = Color.terminal_text_body_dark(255, true),
				offset = {
					0,
					-10,
					1,
				},
			},
		},
		{
			pass_type = "text",
			value = "",
			value_id = "value_text",
			style = {
				font_size = 24,
				text_horizontal_alignment = "center",
				text_color = Color.white(255, true),
				offset = {
					0,
					-3,
					1,
				},
			},
		},
	},
	init = function (parent, widget, entry, callback_name)
		local content = widget.content
		local display_value = entry.additional_data.expertise_data.start

		if display_value then
			content.value_text = string.format(" %s", display_value or 0)
		end

		local start = entry.additional_data.expertise_data.start
		local current_max = entry.additional_data.expertise_data.max_available

		content.start = start or 0
		content.current_max = current_max or 0
	end,
}

local stat_title_size = 150
local max_value_size = 60
local stats_value_size = 50
local content_margin = 20
local stat_grid_width = counter_size[1]
local weapon_stat_text_style = table.clone(UIFontSettings.body)

weapon_stat_text_style.offset = {
	0,
	0,
	4,
}
weapon_stat_text_style.size = {
	stat_title_size,
}
weapon_stat_text_style.font_size = 18
weapon_stat_text_style.text_horizontal_alignment = "left"
weapon_stat_text_style.vertical_alignment = "center"
weapon_stat_text_style.text_vertical_alignment = "center"
weapon_stat_text_style.text_color = Color.terminal_text_body(255, true)

local weapon_stat_title_style = table.clone(UIFontSettings.body)

weapon_stat_title_style.offset = {
	0,
	0,
	4,
}
weapon_stat_title_style.size = {
	stat_title_size,
}
weapon_stat_title_style.font_size = 16
weapon_stat_title_style.text_horizontal_alignment = "left"
weapon_stat_title_style.vertical_alignment = "top"
weapon_stat_title_style.text_vertical_alignment = "left"
weapon_stat_title_style.text_color = Color.terminal_text_body(153, true)

local max_value_style = table.clone(UIFontSettings.body)

max_value_style.offset = {
	0,
	0,
	4,
}
max_value_style.size = {
	max_value_size,
}
max_value_style.font_size = 18
max_value_style.text_horizontal_alignment = "right"
max_value_style.horizontal_alignment = "right"
max_value_style.text_vertical_alignment = "center"
max_value_style.vertical_alignment = "center"
max_value_style.text_color = Color.terminal_text_body(102, true)

local stat_value_style = table.clone(max_value_style)

stat_value_style.text_color = Color.ui_blue_light(255, true)
stat_value_style.size = {
	stats_value_size,
}
stat_value_style.offset = {
	-(max_value_size + content_margin),
	0,
	4,
}
stat_value_style.font_size = 20

local bar_size = stat_grid_width - stat_title_size - max_value_size - stats_value_size
local bar_offset = (stat_grid_width - bar_size - content_margin * 2) * 0.5

ViewElementCraftingRecipeBlueprints.stat_title = {
	size = {
		stat_grid_width,
		20,
	},
	pass_template = {
		{
			pass_type = "text",
			style_id = "modifiers",
			value_id = "modifiers",
			value = Localize("loc_item_information_stats_title_modifiers"),
			style = weapon_stat_title_style,
		},
		{
			pass_type = "text",
			style_id = "changes",
			value_id = "changes",
			value = Localize("loc_expertise_crafting_modifiers_changes"),
			style = table.merge(table.clone(weapon_stat_title_style), {
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				offset = {
					weapon_stat_title_style.offset[1] + 70,
					weapon_stat_title_style.offset[2],
					weapon_stat_title_style.offset[3],
				},
			}),
		},
		{
			pass_type = "text",
			style_id = "max",
			value_id = "max",
			value = Localize("loc_expertise_crafting_modifiers_max"),
			style = table.merge(table.clone(weapon_stat_title_style), {
				horizontal_alignment = "right",
				text_horizontal_alignment = "right",
				offset = {
					weapon_stat_title_style.offset[1] - 10,
					weapon_stat_title_style.offset[2],
					weapon_stat_title_style.offset[3],
				},
			}),
		},
	},
}
ViewElementCraftingRecipeBlueprints.stat = {
	size = {
		stat_grid_width,
		30,
	},
	pass_template = {
		{
			pass_type = "text",
			style_id = "text",
			value = "n/a",
			value_id = "text",
			style = weapon_stat_text_style,
		},
		{
			pass_type = "text",
			style_id = "start_percentage",
			value = "0%",
			value_id = "start_percentage",
			style = table.merge(table.clone(stat_value_style), {
				offset = {
					stat_value_style.offset[1] - 90,
					stat_value_style.offset[2],
					stat_value_style.offset[3],
				},
				text_color = Color.white(255, true),
			}),
		},
		{
			pass_type = "text",
			style_id = "end_percentage",
			value = "100%",
			value_id = "end_percentage",
			style = stat_value_style,
		},
		{
			pass_type = "text",
			style_id = "max_percentage",
			value = "[100%]",
			value_id = "max_percentage",
			style = max_value_style,
		},
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_text_body_sub_header(51, true),
				size_addition = {
					20,
					10,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/animated/progression_arrows",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					38.4,
					32.4,
				},
				offset = {
					-130,
					0,
					1,
				},
			},
		},
	},
	init = function (parent, widget, element, callback_name)
		local content = widget.content
		local style = widget.style

		content.element = element

		local display_name = element.display_name
		local start_stat = element.start_stat
		local end_stat = element.end_stat
		local max_stat = element.max_stat
		local background_id = "background"
		local start_percentage_id = "start_percentage"
		local end_percentage_id = "end_percentage"
		local max_percentage_id = "max_percentage"

		widget.content.text = display_name and Localize(display_name) or ""
		content[start_percentage_id] = start_stat.value .. "%"
		content[end_percentage_id] = end_stat.value .. "%"
		content[max_percentage_id] = string.format("[%s]", max_stat.value .. "%")
	end,
}
ViewElementCraftingRecipeBlueprints.stat_title_max = {
	size = {
		stat_grid_width,
		20,
	},
	pass_template = {
		{
			pass_type = "text",
			style_id = "modifiers",
			value_id = "modifiers",
			value = Localize("loc_item_information_stats_title_modifiers"),
			style = weapon_stat_title_style,
		},
		{
			pass_type = "text",
			style_id = "max",
			value_id = "max",
			value = Localize("loc_expertise_crafting_modifiers_max"),
			style = table.merge(table.clone(weapon_stat_title_style), {
				horizontal_alignment = "right",
				text_horizontal_alignment = "right",
				offset = {
					weapon_stat_title_style.offset[1] - 10,
					weapon_stat_title_style.offset[2],
					weapon_stat_title_style.offset[3],
				},
			}),
		},
	},
}
ViewElementCraftingRecipeBlueprints.stat_max = {
	size = {
		stat_grid_width,
		30,
	},
	pass_template = {
		{
			pass_type = "text",
			style_id = "text",
			value = "n/a",
			value_id = "text",
			style = weapon_stat_text_style,
		},
		{
			pass_type = "text",
			style_id = "start_percentage",
			value = "0%",
			value_id = "start_percentage",
			style = table.merge(table.clone(stat_value_style), {
				offset = {
					stat_value_style.offset[1] - 90,
					stat_value_style.offset[2],
					stat_value_style.offset[3],
				},
				text_color = Color.white(255, true),
			}),
		},
		{
			pass_type = "text",
			style_id = "max_percentage",
			value = "[100%]",
			value_id = "max_percentage",
			style = max_value_style,
		},
	},
	init = function (parent, widget, element, callback_name)
		local content = widget.content
		local style = widget.style

		content.element = element

		local display_name = element.display_name
		local start_value = element.start_stat and element.start_stat.value or 0
		local max_value = element.max_stat and element.max_stat.value or 0
		local background_id = "background"
		local start_percentage_id = "start_percentage"
		local max_percentage_id = "max_percentage"

		widget.content.text = display_name and Localize(display_name) or ""
		content[start_percentage_id] = start_value .. "%"
		content[max_percentage_id] = string.format("[%s]", max_value .. "%")
	end,
}
ViewElementCraftingRecipeBlueprints.expertise_value = {
	size = {
		stat_grid_width,
		50,
	},
	pass_template = {
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/line_thin_sharp_edges",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2,
				},
				size = {
					stat_grid_width - 100,
					50,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "inner_frame",
			value = "content/ui/materials/frames/line_thin_sharp_edges_fill",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				size = {
					stat_grid_width - 100,
					50,
				},
				color = {
					255,
					25,
					31,
					24,
				},
			},
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					stat_grid_width + 20,
					1,
				},
				offset = {
					0,
					0,
					0,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "text",
			value = "",
			value_id = "value_text_start",
			style = {
				font_size = 30,
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.white(255, true),
				size = {
					120,
					45,
				},
				offset = {
					70,
					0,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/icons/generic/animated/progression_arrows",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					51.2,
					43.2,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "text",
			value = "",
			value_id = "value_text_current",
			style = {
				font_size = 30,
				horizontal_alignment = "right",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.ui_blue_light(255, true),
				size = {
					120,
					45,
				},
				offset = {
					-80,
					0,
					1,
				},
			},
		},
	},
	init = function (parent, widget, element, callback_name)
		local content = widget.content

		content.additional_data = element.additional_data

		if element.additional_data.expertise_data then
			local display_value_start = element.additional_data.expertise_data.start
			local display_value_current = element.additional_data.expertise_data.current

			content.value_text_start = string.format(" %s", display_value_start or 0)
			content.value_text_current = display_value_current or 0
		end
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local content = widget.content

		if content.additional_data.expertise_data then
			local display_value_start = content.additional_data.expertise_data.start
			local display_value_current = content.additional_data.expertise_data.current

			content.value_text_start = string.format(" %s", display_value_start or 0)
			content.value_text_current = display_value_current or 0
		end
	end,
}
ViewElementCraftingRecipeBlueprints.expertise_value_max = {
	size = {
		stat_grid_width,
		50,
	},
	pass_template = {
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/line_thin_sharp_edges",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2,
				},
				size = {
					stat_grid_width - 100,
					50,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "inner_frame",
			value = "content/ui/materials/frames/line_thin_sharp_edges_fill",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				size = {
					stat_grid_width - 100,
					50,
				},
				color = {
					255,
					25,
					31,
					24,
				},
			},
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					stat_grid_width + 20,
					1,
				},
				offset = {
					0,
					0,
					0,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "text",
			value = "",
			value_id = "value_text_start",
			style = {
				font_size = 30,
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.white(255, true),
				size = {
					120,
					45,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	},
	init = function (parent, widget, element, callback_name)
		local content = widget.content

		content.additional_data = element.additional_data

		if element.additional_data.expertise_data then
			local display_value_start = element.additional_data.expertise_data.start

			content.value_text_start = string.format(" %s", display_value_start or 0)
		end
	end,
}

return ViewElementCraftingRecipeBlueprints
