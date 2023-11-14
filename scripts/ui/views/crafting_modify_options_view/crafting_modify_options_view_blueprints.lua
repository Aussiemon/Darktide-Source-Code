local definitions = require("scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_definitions")
local CraftingModifyOptionsViewFontStyle = require("scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_font_style")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local WalletSettings = require("scripts/settings/wallet_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local grid_size = definitions.grid_settings.grid_size
local priceStyle = table.clone(CraftingModifyOptionsViewFontStyle.price_text_font_style)
priceStyle.vertical_alignment = "bottom"
priceStyle.text_vertical_alignment = "bottom"
local _temp_trait_tooltip_localization_values = {
	slot_tier = "slot_tier",
	category_icon = "category_icon",
	description_text = "description_text",
	trait_tier = "trait_tier"
}

local function adjust_currency_spacing(wallet_type, currency, widget, ui_renderer)
	local previous_width = 0
	local ordered_currency = {}

	for i = 1, #wallet_type do
		for f = 1, #currency do
			if wallet_type[i] == currency[f].type then
				ordered_currency[#ordered_currency + 1] = currency[f]
			end
		end
	end

	for i = 1, #ordered_currency do
		local replace_cost = ordered_currency[i]
		local price = replace_cost.amount
		local currency_name = replace_cost.type
		local can_afford = widget.content.cost_data.afford_by_type[currency_name]
		local wallet_settings = WalletSettings[currency_name]
		local font_gradient_material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
		local icon_texture_big = wallet_settings.icon_texture_small
		local amount = price
		local text = tostring(amount)
		local text_style = widget.style["text_price_" .. currency_name]
		local texture_style = widget.style["texture_price_" .. currency_name]
		text_style.material = font_gradient_material
		widget.content["texture_price_" .. currency_name] = icon_texture_big
		widget.content["text_price_" .. currency_name] = text
		local text_width, _ = UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size)
		local texture_width = texture_style.size[1]
		local text_offset = text_style.offset
		local texture_offset = texture_style.offset
		local text_margin = 5
		local price_margin = i < #ordered_currency and 30 or 0
		texture_offset[1] = texture_offset[1] + previous_width
		text_offset[1] = text_offset[1] + text_margin + texture_width + previous_width
		previous_width = text_width + texture_width + text_margin + previous_width + price_margin
	end

	local start_point = (widget.content.size[1] - previous_width) * 0.5

	for i = 1, #ordered_currency do
		local replace_cost = ordered_currency[i]
		local currency_name = replace_cost.type
		widget.style["text_price_" .. currency_name].offset[1] = widget.style["text_price_" .. currency_name].offset[1] + start_point
		widget.style["texture_price_" .. currency_name].offset[1] = widget.style["texture_price_" .. currency_name].offset[1] + start_point
	end
end

local function _apply_color_to_text(text, color)
	return "{#color(" .. color[2] .. "," .. color[3] .. "," .. color[4] .. ")}" .. text .. "{#reset()}"
end

local function _generate_price_pass(pass_template, costs)
	if not costs then
		return
	end

	for i = 1, #costs do
		local cost = costs[i]
		local currency_name = cost.type
		pass_template[#pass_template + 1] = {
			pass_type = "texture",
			value = "content/ui/materials/icons/currencies/marks_small",
			value_id = "texture_price_" .. currency_name,
			style_id = "texture_price_" .. currency_name,
			style = {
				vertical_alignment = "bottom",
				size = {
					42,
					24
				},
				offset = {
					0,
					-10,
					1
				}
			},
			visibility_function = function (content, style)
				return content.hotspot.is_focused and not content.disabled
			end
		}
		pass_template[#pass_template + 1] = {
			pass_type = "text",
			value = "",
			value_id = "text_price_" .. currency_name,
			style_id = "text_price_" .. currency_name,
			style = priceStyle,
			visibility_function = function (content, style)
				return content.hotspot.is_focused and not content.disabled
			end
		}
	end
end

local function _generate_price_pass_tooltip(pass_template, costs)
	if not costs then
		return
	end

	for i = 1, #costs do
		local cost = costs[i]
		local currency_name = cost.type
		pass_template[#pass_template + 1] = {
			pass_type = "texture",
			value = "content/ui/materials/icons/currencies/marks_small",
			value_id = "texture_price_" .. currency_name,
			style_id = "texture_price_" .. currency_name,
			style = {
				vertical_alignment = "bottom",
				size = {
					42,
					30
				},
				offset = {
					0,
					-10,
					1
				}
			}
		}
		pass_template[#pass_template + 1] = {
			pass_type = "text",
			value = "",
			value_id = "text_price_" .. currency_name,
			style_id = "text_price_" .. currency_name,
			style = priceStyle
		}
	end
end

local trait_list = {
	size = {
		grid_size[1],
		50
	},
	pass_template_function = function (self, element)
		local pass_templates = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					use_is_focused = true
				}
			}
		}
		pass_templates[2] = {
			pass_type = "texture",
			style_id = "background_selected",
			value = "content/ui/materials/buttons/background_selected",
			style = {
				color = Color.ui_terminal(0, true),
				offset = {
					0,
					0,
					0
				}
			},
			change_function = function (content, style)
				style.color[1] = 255 * content.hotspot.anim_focus_progress
			end,
			visibility_function = function (content, style)
				local hotspot = content.hotspot

				return hotspot.is_hover or hotspot.is_selected or hotspot.is_focused
			end
		}
		pass_templates[3] = {
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					2
				},
				size_addition = {
					0,
					0
				}
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local progress = hotspot.anim_focus_progress
				style.color[1] = 255 * math.easeOutCubic(progress)
				local list_button_highlight_size_addition = 10
				local size_addition = list_button_highlight_size_addition * math.easeInCubic(1 - progress)
				local style_size_additon = style.size_addition
				style_size_additon[1] = size_addition * 2
				style.size_addition[2] = size_addition * 2
				local offset = style.offset
				offset[1] = -size_addition
				offset[2] = -size_addition
			end
		}
		pass_templates[4] = {
			style_id = "trait_used",
			value_id = "trait_used",
			pass_type = "texture",
			value = "content/ui/materials/icons/traits/container",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = {
					60,
					60
				}
			}
		}
		pass_templates[5] = {
			value_id = "select",
			style_id = "select",
			pass_type = "text",
			value = Localize("loc_crafting_replace"),
			style = CraftingModifyOptionsViewFontStyle.fuse_action_font_style,
			visibility_function = function (content, style)
				return content.hotspot.is_focused and content.cost_data and content.cost_data.can_afford and not content.disabled
			end
		}
		pass_templates[6] = {
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = CraftingModifyOptionsViewFontStyle.fuse_description_font_style
		}
		pass_templates[7] = {
			value_id = "count_text",
			style_id = "count_text",
			pass_type = "text",
			value = "",
			style = CraftingModifyOptionsViewFontStyle.count_font_style,
			visibility_function = function (content, style)
				return content.count > 1
			end
		}

		if element.costs then
			local currency = {}

			for i = 1, #element.costs do
				local replace_cost = element.costs[i]
				local price = replace_cost.amount

				if price and price > 0 then
					currency[#currency + 1] = replace_cost
				end
			end

			_generate_price_pass(pass_templates, currency)
		end

		return pass_templates
	end
}

trait_list.init = function (parent, widget, element, callback_name, secondary_callback, ui_renderer)
	local content = widget.content
	content.trait = element.trait
	content.cost_data = element.cost_data
	content.disabled = element.disabled
	local trait_rarity = element.trait.rarity
	local trait_rarity_color = RaritySettings[trait_rarity].color
	local slot_categories_text = ""
	local value_text = element.trait.description
	local description_text_color = Color.ui_grey_light(255, true)
	_temp_trait_tooltip_localization_values.description_text = _apply_color_to_text(value_text, description_text_color)
	_temp_trait_tooltip_localization_values.trait_tier = _apply_color_to_text(TextUtilities.convert_to_roman_numerals(trait_rarity), trait_rarity_color)

	if element.trait.trait_categories then
		for i = 1, #element.trait.trait_categories do
			local category = element.trait.trait_categories[i]
			local category_icon = UISettings.trait_category_icon[category] or ""
			slot_categories_text = slot_categories_text == "" and category_icon or slot_categories_text .. " / " .. category_icon
		end
	end

	_temp_trait_tooltip_localization_values.category_icon = _apply_color_to_text(slot_categories_text, description_text_color)
	local localized_text = ""
	widget.content.text = localized_text
	local text_style = widget.style.text
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local size = {
		widget.content.size[1] - widget.style.text.offset[1],
		math.huge
	}
	local width, height = UIRenderer.text_size(parent._ui_resource_renderer, localized_text, text_style.font_type, text_style.font_size, size, text_options)
	local margin_height = 10
	widget.content.size[2] = math.max(widget.content.size[2], height + margin_height * 2)
	widget.content.original_size = {
		widget.content.size[1],
		widget.content.size[2]
	}
	widget.style.text.size = {
		size[1],
		height
	}
	widget.alpha_multiplier = widget.content.disabled and 0.7 or 1
	widget.content.count = element.count
	widget.content.count_text = string.format("%s: %d", Localize("loc_inventory_count"), element.count)
	local trait_rarity_color = RaritySettings[element.trait.rarity].color
	local slot_rarity_color = RaritySettings[element.trait.slot_rarity or 0].color
	widget.style.trait_used.material_values = {
		texture_category = "content/ui/textures/icons/traits/categories/default",
		texture_glow = "content/ui/textures/icons/traits/effects/default",
		texture_frame = "content/ui/textures/icons/traits/frames/slot_type_passive",
		texture_background = "content/ui/textures/icons/traits/frames/slot_type_passive_background",
		texture_effect = "content/ui/textures/icons/traits/effects/default",
		trait_rarity_color = trait_rarity_color,
		slot_rarity_color = slot_rarity_color
	}
	widget.content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)

	if element.costs then
		local currency = {}

		for i = 1, #element.costs do
			local replace_cost = element.costs[i]
			local price = replace_cost.amount

			if price and price > 0 then
				currency[#currency + 1] = replace_cost
			end
		end

		adjust_currency_spacing(element.wallet_type, currency, widget, ui_renderer)
	end
end

trait_list.update_size = function (parent, widget)
	if widget.content.hotspot.is_focused then
		if not widget.content.disabled then
			widget.content.size[2] = widget.content.original_size[2] + 60
			widget.style.count_text.offset[2] = -65
		end
	else
		widget.content.size[2] = widget.content.original_size[2]
		widget.style.count_text.offset[2] = -5
	end

	local text_style = widget.style.text
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local size = {
		widget.content.size[1] - widget.style.text.offset[1],
		math.huge
	}
	local width, height = UIRenderer.text_size(parent._ui_resource_renderer, widget.content.text, text_style.font_type, text_style.font_size, size, text_options)
	local margin_height = 10
	widget.content.size[2] = math.max(widget.content.size[2], height + margin_height * 2)
	widget.style.text.size = {
		size[1],
		height
	}
end

local trait = {
	size = {
		180,
		180
	},
	pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				use_is_focused = true
			},
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					180,
					180
				}
			}
		},
		{
			style_id = "trait_empty",
			value_id = "trait_empty",
			pass_type = "texture",
			value = "content/ui/materials/icons/traits/empty",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					180,
					180
				}
			},
			visibility_function = function (content)
				return content.trait == nil
			end
		},
		{
			value_id = "trait_used",
			pass_type = "texture",
			value = "content/ui/materials/icons/traits/container",
			style_id = "trait_used",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					180,
					180
				}
			},
			visibility_function = function (content)
				return content.trait ~= nil
			end,
			change_function = function (content, style)
				style.color[1] = content.dim and 178.5 or 255
			end
		},
		{
			value_id = "trait_locked",
			pass_type = "texture",
			value = "content/ui/materials/icons/traits/frames/addon_lock",
			style_id = "trait_locked",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				size = {
					180,
					180
				}
			},
			visibility_function = function (content)
				return content.trait and content.trait.locked
			end,
			change_function = function (content, style)
				style.color[1] = content.dim and 178.5 or 255
			end
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					2
				},
				size_addition = {
					0,
					0
				},
				size = {
					180,
					180
				}
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local progress = hotspot.anim_focus_progress
				style.color[1] = 255 * math.easeOutCubic(progress)
				local list_button_highlight_size_addition = 10
				local size_addition = list_button_highlight_size_addition * math.easeInCubic(1 - progress)
				local style_size_additon = style.size_addition
				style_size_additon[1] = size_addition * 2
				style.size_addition[2] = size_addition * 2
				local offset = style.offset
				offset[1] = -size_addition
				offset[2] = -size_addition
			end,
			visibility_function = function (content, style)
				if content.trait and content.interactable then
					local hotspot = content.hotspot

					return hotspot.is_hover or hotspot.is_selected or hotspot.is_focused
				else
					return false
				end
			end
		},
		{
			value_id = "remove",
			style_id = "remove",
			pass_type = "texture",
			value = "content/ui/materials/icons/traits/crafting_remove",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					5,
					-5,
					4
				},
				size = {
					240,
					240
				}
			},
			visibility_function = function (content)
				return content.removed == true
			end
		}
	},
	init = function (parent, widget, element, index, callback_function)
		local content = widget.content
		content.trait = element.trait
		content.cost_data = element.cost_data
		content.disabled = element.disabled
		content.interactable = element.interactable
		local trait_rarity_color = RaritySettings[element.trait.rarity].color
		local slot_rarity_color = RaritySettings[element.trait.slot_rarity or 0].color
		widget.style.trait_used.material_values = {
			texture_category = "content/ui/textures/icons/traits/categories/default",
			texture_glow = "content/ui/textures/icons/traits/effects/default",
			texture_frame = "content/ui/textures/icons/traits/frames/slot_type_passive",
			texture_background = "content/ui/textures/icons/traits/frames/slot_type_passive_background",
			texture_effect = "content/ui/textures/icons/traits/effects/default",
			trait_rarity_color = trait_rarity_color,
			slot_rarity_color = slot_rarity_color
		}
		local text = element.trait.description
		content.text = text

		if element.interactable and callback_function then
			content.hotspot.pressed_callback = function ()
				callback_function()
			end
		end

		if index then
			local offset = widget.content.size[1] * (index - 1)
			widget.offset = {
				offset,
				0,
				1
			}
		end
	end
}
local tooltip = {
	size = {
		500,
		50
	},
	pass_template_function = function (self, element)
		local pass_templates = {
			{
				pass_type = "rect",
				style = {
					color = Color.black(160, true),
					offset = {
						0,
						0,
						0
					}
				}
			},
			{
				value_id = "text",
				style_id = "text",
				pass_type = "text",
				value = "",
				style = CraftingModifyOptionsViewFontStyle.trait_tooltip_text_style
			},
			{
				value_id = "action",
				style_id = "action",
				pass_type = "text",
				value = "",
				style = CraftingModifyOptionsViewFontStyle.trait_action_style
			}
		}

		if element.costs then
			local currency = {}

			for i = 1, #element.costs do
				local replace_cost = element.costs[i]
				local price = replace_cost.amount

				if price and price > 0 then
					currency[#currency + 1] = replace_cost
				end
			end

			_generate_price_pass_tooltip(pass_templates, currency)
		end

		return pass_templates
	end,
	init = function (parent, widget, element, ui_renderer)
		local content = widget.content
		content.trait = element.trait
		content.cost_data = element.cost_data
		local trait_rarity = element.trait.rarity
		local slot_rarity = element.trait.slot_rarity
		local trait_rarity_color = RaritySettings[trait_rarity].color
		local slot_rarity_color = RaritySettings[slot_rarity or 0].color
		local slot_categories_text = ""
		local value_text = element.trait.description
		local description_text_color = Color.ui_grey_light(255, true)
		_temp_trait_tooltip_localization_values.description_text = _apply_color_to_text(value_text, description_text_color)
		_temp_trait_tooltip_localization_values.trait_tier = _apply_color_to_text(TextUtilities.convert_to_roman_numerals(trait_rarity), trait_rarity_color)

		if element.trait.slot_categories then
			for i = 1, #element.trait.slot_categories do
				local category = element.trait.slot_categories[i]
				local category_icon = UISettings.trait_category_icon[category] or ""
				slot_categories_text = slot_categories_text == "" and category_icon or slot_categories_text .. " / " .. category_icon
			end

			_temp_trait_tooltip_localization_values.slot_tier = _apply_color_to_text(TextUtilities.convert_to_roman_numerals(slot_rarity), slot_rarity_color)
		end

		_temp_trait_tooltip_localization_values.category_icon = _apply_color_to_text(slot_categories_text, description_text_color)
		local localized_text = ""
		local text_style = widget.style.text
		local text_options = UIFonts.get_font_options_by_style(text_style)
		local size = {
			content.size[1] - widget.style.text.offset[1],
			math.huge
		}
		local width, height = UIRenderer.text_size(ui_renderer, localized_text, text_style.font_type, text_style.font_size, size, text_options)
		local margin_height = 10
		widget.style.text.size = {
			size[1],
			height
		}
		content.text = localized_text
		content.action = element.trait_tooltip_action_text or ""
		local price_height = 0
		local action_height = 0
		local price_margin_top = 10

		if element.costs then
			price_height = 33.6
		end

		if element.trait_tooltip_action_text then
			action_height = 30 + price_margin_top
			widget.style.action.offset[2] = height + price_margin_top
		end

		content.size[2] = math.max(content.size[2], height + price_height + action_height + margin_height * 2)

		if element.costs then
			local currency = {}

			for i = 1, #element.costs do
				local replace_cost = element.costs[i]
				local price = replace_cost.amount

				if price and price > 0 then
					currency[#currency + 1] = replace_cost
				end
			end

			adjust_currency_spacing(element.wallet_type, currency, widget, ui_renderer)
		end
	end
}
local ContentBlueprints = {
	trait_list = trait_list,
	trait = trait,
	tooltip = tooltip
}

return ContentBlueprints
