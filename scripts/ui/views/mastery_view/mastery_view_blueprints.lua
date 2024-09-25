-- chunkname: @scripts/ui/views/mastery_view/mastery_view_blueprints.lua

local blueprints = {}
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local MasteryUtils = require("scripts/utilities/mastery")
local weapon_item_size = UISettings.weapon_item_size
local item_display_name_text_style = table.clone(UIFontSettings.header_3)

item_display_name_text_style.text_horizontal_alignment = "left"
item_display_name_text_style.text_vertical_alignment = "top"
item_display_name_text_style.horizontal_alignment = "right"
item_display_name_text_style.vertical_alignment = "top"
item_display_name_text_style.offset = {
	-20,
	10,
	5,
}
item_display_name_text_style.font_size = 24
item_display_name_text_style.size = {
	weapon_item_size[1] - 40,
	40,
}
item_display_name_text_style.text_color = Color.terminal_text_header(255, true)
item_display_name_text_style.completed_color = Color.terminal_completed(255, true)
item_display_name_text_style.default_color = Color.terminal_text_header(255, true)
item_display_name_text_style.unlock_color = Color.terminal_text_key_value(255, true)
item_display_name_text_style.locked_color = Color.terminal_text_header(100, true)

local mark_display_name_text_style = table.clone(item_display_name_text_style)

mark_display_name_text_style.text_vertical_alignment = "top"
mark_display_name_text_style.vertical_alignment = "top"
mark_display_name_text_style.horizontal_alignment = "center"
mark_display_name_text_style.text_horizontal_alignment = "center"
mark_display_name_text_style.size = {
	nil,
	40,
}
mark_display_name_text_style.size_addition = {
	-20,
}
mark_display_name_text_style.offset = {
	10,
	0,
	6,
}

local text_icon_style = table.clone(UIFontSettings.header_2)

text_icon_style.text_horizontal_alignment = "center"
text_icon_style.text_vertical_alignment = "center"
text_icon_style.horizontal_alignment = "center"
text_icon_style.vertical_alignment = "center"
text_icon_style.text_color = Color.terminal_text_header(255, true)
text_icon_style.completed_color = Color.terminal_completed(255, true)
text_icon_style.default_color = Color.terminal_text_header(255, true)
text_icon_style.unlock_color = Color.terminal_text_key_value(255, true)
text_icon_style.locked_color = Color.terminal_text_header(100, true)

local unlocked_level_text_style = table.clone(mark_display_name_text_style)

unlocked_level_text_style.vertical_alignment = "bottom"
blueprints.milestone = {
	size = {
		300,
		200,
	},
	pass_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				unlock_color = Color.terminal_text_key_value(255, true),
				locked_color = Color.white(100, true),
				default_color = Color.white(255, true),
				color = Color.white(255, true),
				offset = {
					0,
					0,
					5,
				},
			},
			visibility_function = function (content, style)
				return not not content.icon
			end,
		},
		{
			pass_type = "text",
			style_id = "text_icon",
			value = "",
			value_id = "text_icon",
			style = text_icon_style,
			change_function = function (content, style)
				if content.claimed then
					style.text_color = table.clone(style.completed_color)
				else
					style.text_color = table.clone(style.default_color)
				end
			end,
		},
		{
			pass_type = "text",
			style_id = "display_name",
			value = "",
			value_id = "display_name",
			style = mark_display_name_text_style,
		},
		{
			pass_type = "text",
			style_id = "unlock_level",
			value = "",
			value_id = "unlock_level",
			style = unlocked_level_text_style,
			change_function = function (content, style)
				if content.claimed then
					style.text_color = table.clone(style.completed_color)
				else
					style.text_color = table.clone(style.default_color)
				end
			end,
		},
	},
	init = function (parent, widget, element)
		local content = widget.content
		local style = widget.style

		content.element = element
		content.display_name = element.display_name
		content.unlock_level = Localize("loc_mastery_unlocked_level", true, {
			level = element.unlock_level or 0,
		})

		if element.icon then
			content.icon = element.icon

			if element.icon_material_values then
				style.icon.material_values = element.icon_material_values
			end

			if element.icon_color then
				style.icon.color = table.clone(element.icon_color)
			end

			if element.icon_size then
				style.icon.size = table.clone(element.icon_size)
			end
		else
			content.icon = nil
		end

		if element.text then
			content.text_icon = element.text
		end

		if element.text and element.icon then
			style.icon.offset[2] = -20
			style.text_icon.offset[2] = 30
			style.text_icon.font_size = 24
		end

		local unlocked = element.unlocked
		local can_unlock = element.can_unlock

		style.icon.color = can_unlock and not unlocked and style.icon.unlock_color or not unlocked and style.icon.locked_color or style.icon.default_color
		style.text_icon.text_color = can_unlock and not unlocked and style.text_icon.unlock_color or not unlocked and style.text_icon.locked_color or style.text_icon.default_color
		style.display_name.text_color = can_unlock and not unlocked and style.display_name.unlock_color or not unlocked and style.display_name.locked_color or style.display_name.default_color
	end,
}
blueprints.wintrack = {
	size_function = function (parent, config)
		return config.size
	end,
	pass_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				unlock_color = Color.terminal_completed(255, true),
				locked_color = Color.terminal_text_header(255, true),
				default_color = Color.terminal_text_header(255, true),
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					5,
				},
			},
			visibility_function = function (content, style)
				return not not content.icon
			end,
			change_function = function (content, style)
				if content.claimed then
					style.color = table.clone(style.unlock_color)
				else
					style.color = table.clone(style.locked_color)
				end
			end,
		},
		{
			pass_type = "text",
			style_id = "text_icon",
			value = "",
			value_id = "text_icon",
			style = table.merge_recursive(table.clone(text_icon_style), {
				font_size = 30,
			}),
			change_function = function (content, style)
				if content.claimed then
					style.text_color = table.clone(style.completed_color)
				else
					style.text_color = table.clone(style.default_color)
				end
			end,
		},
		{
			pass_type = "text",
			style_id = "display_name",
			value = "",
			value_id = "display_name",
			style = table.merge_recursive(table.clone(mark_display_name_text_style), {
				font_size = 14,
				offset = {
					0,
					10,
					6,
				},
			}),
			change_function = function (content, style)
				if content.claimed then
					style.text_color = table.clone(style.completed_color)
				else
					style.text_color = table.clone(style.default_color)
				end
			end,
		},
	},
	init = function (parent, widget, element)
		local content = widget.content
		local style = widget.style

		content.element = element

		if element.icon then
			content.icon = element.icon

			if element.icon_material_values then
				style.icon.material_values = element.icon_material_values
			end

			if element.icon_color then
				style.icon.color = table.clone(element.icon_color)
			end

			if element.icon_size then
				local original_size = table.clone(element.icon_size)
				local larger_side_index = original_size[1] >= original_size[2] and 1 or 2
				local margin = 10
				local widget_icon_max_size = element.size[larger_side_index] - margin
				local icon_size = original_size[larger_side_index]

				if widget_icon_max_size < icon_size then
					local adjusted_size_ratio = widget_icon_max_size / icon_size
					local adjusted_size = {
						original_size[1] * adjusted_size_ratio,
						original_size[2] * adjusted_size_ratio,
					}

					style.icon.size = adjusted_size
				else
					style.icon.size = original_size
				end
			end
		else
			content.icon = nil
		end

		if element.text then
			content.text_icon = element.text
		end
	end,
}
blueprints.overlay = {
	size_function = function (parent, config)
		return config.size
	end,
	pass_template = {
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "frame_top",
			value = "content/ui/materials/frames/item_info_upper",
			value_id = "frame_top",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					nil,
					36,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame_bottom",
			value = "content/ui/materials/frames/item_info_lower",
			value_id = "frame_bottom",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					36,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				unlock_color = Color.terminal_text_key_value(255, true),
				locked_color = Color.white(255, true),
				default_color = Color.white(255, true),
				color = Color.white(255, true),
				offset = {
					0,
					0,
					5,
				},
			},
			visibility_function = function (content, style)
				return not not content.icon
			end,
		},
		{
			pass_type = "text",
			style_id = "text_icon",
			value = "",
			value_id = "text_icon",
			style = table.merge_recursive(table.clone(text_icon_style), {
				font_size = 60,
			}),
		},
		{
			pass_type = "text",
			style_id = "display_name",
			value = "",
			value_id = "display_name",
			style = table.merge_recursive(table.clone(mark_display_name_text_style), {
				font_size = 40,
				offset = {
					0,
					50,
					6,
				},
			}),
		},
	},
	init = function (parent, widget, element)
		local content = widget.content
		local style = widget.style

		content.element = element
		content.display_name = element.display_name or ""

		if element.icon then
			content.icon = element.icon

			if element.icon_material_values then
				style.icon.material_values = element.icon_material_values
			end

			if element.icon_color then
				style.icon.color = table.clone(element.icon_color)
			end
		else
			content.icon = nil
		end

		if element.text then
			content.text_icon = element.text
		end

		if element.icon_size then
			local original_size = table.clone(element.icon_size)
			local larger_side_index = original_size[1] >= original_size[2] and 1 or 2
			local margin = 10
			local widget_icon_max_size = math.min(original_size[larger_side_index] * 2, element.size[larger_side_index] - margin)
			local icon_size = original_size[larger_side_index]
			local adjusted_size_ratio

			if widget_icon_max_size < icon_size then
				adjusted_size_ratio = widget_icon_max_size / icon_size
			else
				adjusted_size_ratio = widget_icon_max_size / icon_size
			end

			local adjusted_size = {
				original_size[1] * adjusted_size_ratio,
				original_size[2] * adjusted_size_ratio,
			}

			style.icon.size = adjusted_size
		end
	end,
}
blueprints.trait_new_empty = {
	size = {
		184,
		230,
	},
	pass_template = {
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/buttons/mastery_tree/pattern_trait_node_container_v2",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				material_values = {
					frame_tier = "content/ui/textures/buttons/mastery_tree/trait_node_empty",
				},
			},
		},
	},
}
blueprints.trait_new = {
	size = {
		184,
		230,
	},
	pass_template_function = function (parent, element)
		local passes = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				style_id = "hotspot",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.mastery_trait_unlocked,
				},
			},
			{
				pass_type = "texture",
				style_id = "icon",
				value = "content/ui/materials/buttons/mastery_tree/pattern_trait_node_container_v2",
				value_id = "icon",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					material_values = {},
				},
				change_function = function (content, style)
					local next_rarity = content.next_rarity
					local reached_max_rarity = content.rarity == next_rarity
					local can_be_acquired = parent._can_trait_be_acquired(parent, content.element)
					local available = can_be_acquired or not reached_max_rarity

					style.material_values.frame_intensity = available and 2 or 0.7
					style.material_values.bg_intensity = available and 1 or 0.7

					local on_pressed_sound

					if can_be_acquired then
						if next_rarity >= 4 then
							on_pressed_sound = UISoundEvents.mastery_trait_unlocked_rank_4
						elseif next_rarity >= 3 then
							on_pressed_sound = UISoundEvents.mastery_trait_unlocked_rank_3
						elseif next_rarity >= 2 then
							on_pressed_sound = UISoundEvents.mastery_trait_unlocked_rank_2
						else
							on_pressed_sound = UISoundEvents.mastery_trait_unlocked
						end
					else
						on_pressed_sound = UISoundEvents.mastery_trait_unlock_blocked
					end

					style.parent.hotspot.on_pressed_sound = on_pressed_sound

					local hotspot = content.hotspot
					local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)
					local speed = 3
					local min = 0.92
					local max = 1
					local t = Application.time_since_launch()
					local current_pulse_value = (max - min) * math.sin(t * speed) + min
					local is_selected = hotspot.is_hover or hotspot._is_focused or hotspot._is_selected

					style.material_values.frame_intensity = available and not is_selected and current_pulse_value or reached_max_rarity and 1 or style.material_values.frame_intensity + progress
					style.material_values.bg_intensity = available and not is_selected and current_pulse_value or reached_max_rarity and 1 or style.material_values.bg_intensity + progress * 0.2
				end,
			},
			{
				pass_type = "texture",
				style_id = "pattern_trait_glow",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "pattern_trait_glow",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					material_values = {
						texture_map = "content/ui/textures/buttons/mastery_tree/trait_node_glow",
					},
					default_color = Color.terminal_corner_selected(0, true),
					hover_color = Color.terminal_corner_selected(255, true),
					color = Color.terminal_corner_selected(0, true),
					size_addition = {
						5,
						5,
					},
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

					ColorUtilities.color_lerp(style.default_color, style.hover_color, progress, style.color)
				end,
			},
		}
		local traits = element.traits
		local position_by_rarity = {
			{
				19,
				-12,
				1,
			},
			{
				54,
				-12,
				1,
			},
			{
				89,
				-12,
				1,
			},
			{
				124,
				-12,
				1,
			},
		}

		for i = 1, #traits do
			local trait = traits[i]
			local rarity = trait.rarity

			passes[#passes + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "tier_locked_" .. rarity,
				style_id = "tier_locked_" .. rarity,
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					size = {
						42,
						68,
					},
					material_values = {
						texture_map = "content/ui/textures/buttons/mastery_tree/trait_node_tier_glow",
					},
					offset = table.merge(table.clone(position_by_rarity[rarity]), {
						[3] = position_by_rarity[rarity][3] + 1,
					}),
					default_color = Color.white(0, true),
					hover_color = Color.white(255, true),
					color = Color.white(0, true),
				},
				change_function = function (content, style)
					local available_glow = "content/ui/textures/buttons/mastery_tree/trait_node_tier_glow"
					local locked_glow = "content/ui/textures/buttons/mastery_tree/trait_node_tier_blocked"
					local can_be_acquired = parent._can_trait_be_acquired(parent, content.element)
					local unlocked_rarity = MasteryUtils.get_max_blessing_rarity_unlocked_level_by_points_spent(parent._traits) >= i
					local available = content.next_rarity == i and can_be_acquired

					if not can_be_acquired or not unlocked_rarity then
						style.material_values.texture_map = locked_glow
					elseif available then
						style.material_values.texture_map = available_glow
					else
						style.material_values.texture_map = nil
					end

					local hotspot = content.hotspot
					local progress = math.max(math.max(hotspot.anim_hover_progress, hotspot.anim_select_progress), hotspot.anim_focus_progress)

					ColorUtilities.color_lerp(style.default_color, style.hover_color, progress, style.color)
				end,
				visibility_function = function (content, style)
					local unlocked = content["rarity_" .. i .. "_unlocked"]

					return content.next_rarity == i and not unlocked
				end,
			}
			passes[#passes + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "tier_animation_" .. rarity,
				style_id = "tier_animation_" .. rarity,
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					size = {
						42,
						68,
					},
					material_values = {
						texture_map = "content/ui/textures/buttons/mastery_tree/trait_node_tier_highlight",
					},
					offset = table.merge(table.clone(position_by_rarity[rarity]), {
						[3] = position_by_rarity[rarity][3] + 1,
					}),
					color = Color.terminal_corner_selected(0, true),
				},
			}
		end

		return passes
	end,
	init = function (parent, widget, element)
		local content = widget.content
		local style = widget.style

		content.element = element

		local texture_icon = element.texture_icon
		local icon_material_values = style.icon.material_values

		if texture_icon then
			local string_start = "weapon_trait_"
			local weapon_trait_icon_position = string.find(texture_icon, string_start)

			if weapon_trait_icon_position then
				local weapon_trait_icon_name = string.sub(texture_icon, weapon_trait_icon_position)
				local weapon_trait_icon_index = string.sub(weapon_trait_icon_name, string.len(string_start) + 1)
				local index_to_number = tonumber(weapon_trait_icon_index)

				if not index_to_number or index_to_number > 236 then
					weapon_trait_icon_name = "weapon_trait_default"
				end

				icon_material_values.icon = "content/ui/textures/icons/traits/mastery_tree/" .. weapon_trait_icon_name
			end
		end

		local valid_rarity = element.rarity and element.rarity > 0 and element.rarity <= 4
		local rarity = valid_rarity and element.rarity or 0

		icon_material_values.frame_tier = "content/ui/textures/buttons/mastery_tree/trait_node_tier_" .. rarity

		local traits = element.traits

		for i = 1, #traits do
			local trait = traits[i]
			local rarity = trait.rarity

			content["rarity_" .. rarity .. "_unlocked"] = trait.unlocked
			content["rarity_" .. rarity .. "_available"] = trait.available
		end

		content.rarity = element.rarity
		content.next_rarity = element.next_rarity
	end,
}

return blueprints
