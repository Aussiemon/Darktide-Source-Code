local definitions = require("scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_definitions")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local TextUtilities = require("scripts/utilities/ui/text")
local CraftingFuseViewFontStyle = require("scripts/ui/views/crafting_fuse_view/crafting_fuse_view_font_style")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local grid_size = definitions.grid_settings.grid_size
local _temp_trait_tooltip_localization_values = {
	slot_tier = "slot_tier",
	category_icon = "category_icon",
	description_text = "description_text",
	trait_tier = "trait_tier"
}

local function generate_arrow_passes(total_arrows, start_position, end_position)
	local angle = math.angle(start_position[1], start_position[2], end_position[1], end_position[2])
	local distance = math.distance_2d(end_position[1], start_position[2], end_position[1], end_position[2])
	local line_angle = angle
	local arrow_angle = math.pi - angle
	local passes = {}
	local start_distance = distance * 0.33

	for i = 1, total_arrows do
		local distance_muiltiplier = i - 1
		local add_distance = 30
		local x = (start_distance + add_distance * distance_muiltiplier) * math.cos(line_angle)
		local y = (start_distance + add_distance * distance_muiltiplier) * math.sin(line_angle)
		passes[#passes + 1] = {
			value = "content/ui/materials/icons/traits/crafting_insert",
			pass_type = "rotated_texture",
			style_id = "arrow_style_" .. i,
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = arrow_angle,
				offset = {
					x,
					y,
					0
				},
				size = {
					27,
					32
				},
				color = Color.ui_terminal(255, true)
			}
		}
	end

	return passes
end

local function _apply_color_to_text(text, color)
	return "{#color(" .. color[2] .. "," .. color[3] .. "," .. color[4] .. ")}" .. text .. "{#reset()}"
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
			value = Localize("loc_crafting_choose"),
			style = CraftingFuseViewFontStyle.fuse_action_font_style,
			visibility_function = function (content, style)
				return content.hotspot.is_focused and not content.disabled
			end
		}
		pass_templates[6] = {
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = CraftingFuseViewFontStyle.trait_text_style
		}
		pass_templates[7] = {
			value_id = "count_text",
			style_id = "count_text",
			pass_type = "text",
			value = "",
			style = CraftingFuseViewFontStyle.count_font_style,
			visibility_function = function (content, style)
				return content.count > 1
			end
		}

		return pass_templates
	end,
	init = function (parent, widget, element, callback_name, secondary_callback, ui_renderer)
		local content = widget.content
		content.trait = element.trait
		content.disabled = element.disabled
		content.count = element.count
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
		local localized_text = Localize("loc_trait_inventory_format_key", true, _temp_trait_tooltip_localization_values)
		content.text = localized_text
		local text_style = widget.style.text
		local text_options = UIFonts.get_font_options_by_style(text_style)
		local size = {
			content.size[1] - widget.style.text.offset[1],
			math.huge
		}
		local width, height = UIRenderer.text_size(parent._ui_resource_renderer, localized_text, text_style.font_type, text_style.font_size, size, text_options)
		local margin_height = 10
		content.size[2] = math.max(content.size[2], height + margin_height * 2)
		content.original_size = {
			content.size[1],
			content.size[2]
		}
		widget.style.text.size = {
			size[1],
			height
		}
		widget.alpha_multiplier = content.disabled and 0.7 or 1
		content.count_text = string.format("%s: %d", Localize("loc_inventory_count"), element.count)
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
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
	end,
	update_size = function (parent, widget)
		if widget.content.hotspot.is_selected then
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
}
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
			style_id = "trait_used",
			value_id = "trait_used",
			pass_type = "texture",
			value = "content/ui/materials/icons/traits/container",
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
				local progress = hotspot.anim_hover_progress
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
				if content.interactable then
					local hotspot = content.hotspot

					return hotspot.is_hover or hotspot.is_selected or hotspot.is_focused
				else
					return false
				end
			end
		}
	},
	init = function (parent, widget, element, callback_function)
		local trait_rarity_color = RaritySettings[element.trait.rarity].color
		local slot_rarity_color = RaritySettings[element.trait.slot_rarity].color
		widget.style.trait_used.material_values = {
			texture_category = "content/ui/textures/icons/traits/categories/default",
			texture_glow = "content/ui/textures/icons/traits/effects/default",
			texture_frame = "content/ui/textures/icons/traits/frames/slot_type_passive",
			texture_background = "content/ui/textures/icons/traits/frames/slot_type_passive_background",
			texture_effect = "content/ui/textures/icons/traits/effects/default",
			trait_rarity_color = trait_rarity_color,
			slot_rarity_color = slot_rarity_color
		}
		local content = widget.content
		local text = element.trait.description
		content.text = text
		content.trait = element.trait

		if element.interactable and callback_function then
			content.hotspot.pressed_callback = function ()
				callback_function()
			end
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
				style = CraftingFuseViewFontStyle.trait_tooltip_text_style
			},
			{
				value_id = "action",
				style_id = "action",
				pass_type = "text",
				value = "",
				style = CraftingFuseViewFontStyle.trait_action_style
			}
		}

		return pass_templates
	end
}

tooltip.init = function (parent, widget, element, ui_renderer)
	local content = widget.content
	content.trait = element
	local trait_rarity = element.rarity
	local trait_rarity_color = RaritySettings[trait_rarity].color
	local slot_categories_text = ""
	local value_text = element.description
	local description_text_color = Color.ui_grey_light(255, true)
	_temp_trait_tooltip_localization_values.description_text = _apply_color_to_text(value_text, description_text_color)
	_temp_trait_tooltip_localization_values.trait_tier = _apply_color_to_text(TextUtilities.convert_to_roman_numerals(trait_rarity), trait_rarity_color)

	if element.trait_categories then
		for i = 1, #element.trait_categories do
			local category = element.trait_categories[i]
			local category_icon = UISettings.trait_category_icon[category] or ""
			slot_categories_text = slot_categories_text == "" and category_icon or slot_categories_text .. " / " .. category_icon
		end
	end

	_temp_trait_tooltip_localization_values.category_icon = _apply_color_to_text(slot_categories_text, description_text_color)
	local localized_text = Localize("loc_trait_inventory_format_key", true, _temp_trait_tooltip_localization_values)
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
	content.size[2] = math.max(content.size[2], height + price_height + action_height + margin_height * 2)
end

local arrow = {
	pass_template_function = function (parent, element)
		local pass_templates = {}
		local scenegraph_start = element.start
		local scenegraph_end = element.finish
		local amount = element.amount
		local start_position = parent:_scenegraph_world_position(scenegraph_start)
		local end_position = parent:_scenegraph_world_position(scenegraph_end)
		pass_templates = generate_arrow_passes(amount, start_position, end_position)

		return pass_templates
	end,
	init = function (parent, widget, element)
		widget.element = element

		for i = 1, element.amount do
			local style_name = "arrow_style_" .. i
			widget.style[style_name].color[1] = i == 1 and 255 or 0
		end
	end,
	update = function (parent, widget, dt, current_progress)
		local progress = current_progress + dt
		local full_animation_time = 1
		local delay_between = 2
		local start_delay = 0.5

		for i = 1, widget.element.amount do
			local pass_name = "arrow_style_" .. i
			local wave = 255 * 0.5 * (1 + math.sin(-(start_delay * (i - 1)) + 2 * math.pi * full_animation_time * progress))
			widget.style[pass_name].color[1] = wave
		end
	end
}
local ContentBlueprints = {
	trait_list = trait_list,
	trait = trait,
	tooltip = tooltip,
	arrow = arrow
}

return ContentBlueprints
