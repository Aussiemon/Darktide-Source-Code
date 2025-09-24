-- chunkname: @scripts/ui/views/penance_overview_view/penance_overview_view_blueprints.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ItemUtils = require("scripts/utilities/items")
local PenanceOverviewViewSettings = require("scripts/ui/views/penance_overview_view/penance_overview_view_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local InputUtilities = require("scripts/managers/input/input_utils")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local AchievementCategories = require("scripts/settings/achievements/achievement_categories")
local carousel_penance_size = PenanceOverviewViewSettings.carousel_penance_size
local penance_pixel_size = PenanceOverviewViewSettings.penance_pixel_size
local penance_size = PenanceOverviewViewSettings.penance_size
local penance_size_large = PenanceOverviewViewSettings.penance_size_large
local penance_grid_size = PenanceOverviewViewSettings.penance_grid_size
local tooltip_grid_size = PenanceOverviewViewSettings.tooltip_grid_size
local tooltip_entries_width = PenanceOverviewViewSettings.tooltip_entries_width
local tooltip_blueprint_size = {
	tooltip_entries_width,
	tooltip_grid_size[2],
}
local reward_icon_large = {
	164,
	164,
}
local reward_glow_large = {
	328,
	328,
}
local reward_icon_medium = {
	112,
	112,
}
local reward_glow_medium = {
	224,
	224,
}
local reward_icon_small = {
	94,
	94,
}
local reward_glow_small = {
	188,
	188,
}
local default_button_content = {
	on_hover_sound = UISoundEvents.default_mouse_hover,
	on_pressed_sound = UISoundEvents.default_click,
}

local function _apply_package_item_icon_cb_func(widget, item)
	local icon_style = widget.style.icon
	local widget_content = widget.content

	widget_content.icon = "content/ui/materials/icons/items/containers/item_container_square"

	local material_values = icon_style.material_values

	if item.icon_material and item.icon_material ~= "" then
		widget.content.icon = item.icon_material
		material_values.use_placeholder_texture = 0
		material_values.use_render_target = 0
	else
		if widget.style.icon_original_size then
			icon_style.size = widget.style.icon_original_size
			widget.style.icon_original_size = nil
		end

		material_values.texture_icon = item.icon
	end

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 0
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _remove_package_item_icon_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)
	UIWidget.set_visible(widget, ui_renderer, true)

	local material_values = widget.style.icon.material_values

	material_values.texture_icon = nil
	material_values.use_placeholder_texture = 1

	local icon_style = widget.style.icon

	icon_style.size = widget.style.icon_original_size or icon_style.size
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture

	if widget.style.icon_original_size then
		icon_style.size = widget.style.icon_original_size
		widget.style.icon_original_size = nil
	end
end

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	local widget_style = widget.style
	local widget_content = widget.content

	widget_content.icon = "content/ui/materials/icons/items/containers/item_container_landscape"

	local icon_style = widget_style.icon
	local material_values = icon_style.material_values

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 1
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.render_target = render_target
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _remove_live_item_icon_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)
	UIWidget.set_visible(widget, ui_renderer, true)

	local material_values = widget.style.icon.material_values

	material_values.use_placeholder_texture = 1
	material_values.render_target = nil
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _setup_blueprint_penance_tracked(input_size, edge_padding)
	return {
		size = {
			input_size[1],
			20,
		},
		pass_template = {
			{
				pass_type = "texture",
				value = "content/ui/materials/icons/generic/bookmark",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					color = Color.terminal_corner_selected(255, true),
					default_color = Color.terminal_frame(180, true),
					selected_color = Color.terminal_frame_selected(180, true),
					disabled_color = Color.ui_grey_medium(180, true),
					hover_color = Color.terminal_frame_hover(180, true),
					size = {
						40,
						40,
					},
					offset = {
						-10,
						-5,
						1,
					},
				},
				visibility_function = function (content, style)
					return content.tracked
				end,
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local content = widget.content

			content.element = element
			content.tracked = element.tracked
		end,
	}
end

local function _setup_blueprint_penance_icon(input_size, edge_padding)
	return {
		size = {
			input_size[1],
			120,
		},
		pass_template = {
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/icons/achievements/achievement_icon_container_v2",
				style = {
					horizontal_alignment = "center",
					size = {
						120,
						120,
					},
					material_values = {
						icon = "content/ui/textures/icons/achievements/achievement_icon_0010",
					},
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "outer_shadow",
				value = "content/ui/materials/icons/achievements/frames/achievements_dropshadow_medium",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					size = {
						136,
						136,
					},
					color = Color.black(200, true),
					size_addition = {
						0,
					},
					offset = {
						0,
						0,
						0,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local texture = element.texture

			if texture then
				style.texture.material_values.icon = texture
			end

			content.completed = element.completed
			content.can_claim = element.can_claim

			local family_index = element.family_index

			if family_index then
				local number_texture = PenanceOverviewViewSettings.roman_numeral_texture_array[family_index]

				if texture and number_texture then
					style.texture.material_values.icon_number = number_texture
				end
			end
		end,
	}
end

local function _setup_blueprint_penance_icon_small(input_size, edge_padding)
	return {
		size = {
			50,
			50,
		},
		pass_template = {
			{
				pass_type = "rect",
				style_id = "background",
				style = {
					color = {
						0,
						0,
						0,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/icons/achievements/achievement_icon_container_v2",
				style = {
					material_values = {
						icon = "content/ui/textures/icons/achievements/achievement_icon_0010",
					},
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						1,
					},
				},
				change_function = function (content, style)
					local completed = content.completed
					local color_value = completed and 120 or 255

					style.color[2] = color_value
					style.color[3] = color_value
					style.color[4] = color_value
				end,
			},
			{
				pass_type = "texture",
				style_id = "outer_shadow",
				value = "content/ui/materials/icons/achievements/frames/achievements_dropshadow_medium",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					size = {
						57,
						57,
					},
					color = Color.black(200, true),
					size_addition = {
						0,
						0,
					},
					offset = {
						0,
						0,
						0,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "complete_sign",
				value = "",
				style = {
					drop_shadow = true,
					font_size = 48,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.ui_terminal(255, true),
					offset = {
						0,
						0,
						2,
					},
				},
				visibility_function = function (content, style)
					return content.completed
				end,
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local texture = element.texture

			if texture then
				style.texture.material_values.icon = texture
			end

			local family_index = element.family_index

			if family_index then
				local number_texture = PenanceOverviewViewSettings.roman_numeral_texture_array[family_index]

				if texture and number_texture then
					style.texture.material_values.icon_number = number_texture
				end
			end

			content.completed = element.completed
		end,
	}
end

local function _setup_blueprint_penance_header(input_size, edge_padding)
	edge_padding = edge_padding or 0

	return {
		size = {
			input_size[1],
			50,
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1] or input_size[1],
				size[2] or 50,
			} or {
				input_size[1],
				50,
			}
		end,
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 24,
					font_type = "proxima_nova_bold",
					horizontal_alignment = "center",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_header(255, true),
					offset = {
						0,
						0,
						3,
					},
					size_addition = {
						-(20 + edge_padding),
						0,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local new_indicator_width_offset = element.new_indicator_width_offset

			if new_indicator_width_offset then
				local offset = style.new_indicator.offset

				offset[1] = new_indicator_width_offset[1]
				offset[2] = new_indicator_width_offset[2]
				offset[3] = new_indicator_width_offset[3]
			end

			content.element = element
			content.text = text
		end,
	}
end

local function _setup_blueprint_penance_body(input_size, edge_padding)
	edge_padding = edge_padding or 0

	return {
		size = {
			input_size[1],
			100,
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1] or input_size[1],
				size[2] or 100,
			} or {
				input_size[1],
				100,
			}
		end,
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 18,
					font_type = "proxima_nova_bold",
					horizontal_alignment = "center",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					size_addition = {
						-(0 + edge_padding),
						0,
					},
					text_color = Color.terminal_text_header(255, true),
					offset = {
						0,
						0,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local optional_text_color = element.text_color

			if optional_text_color then
				ColorUtilities.color_copy(optional_text_color, style.text.text_color)
			end

			content.element = element
			content.text = text

			local strict_size = element.strict_size

			if not strict_size then
				local size = content.size
				local text_style = style.text
				local text_options = UIFonts.get_font_options_by_style(text_style)
				local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

				size[2] = math.max(height, size[2])
			end
		end,
	}
end

local function _setup_blueprint_penance_score_and_reward(input_size, edge_padding)
	return {
		size = {
			input_size[1],
			130,
		},
		pass_template = {
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					color = Color.terminal_background_dark(nil, true),
				},
			},
			{
				pass_type = "texture",
				style_id = "icon_background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = {
						100,
						100,
					},
					offset = {
						-80,
						0,
						1,
					},
					color = Color.terminal_background_dark(nil, true),
				},
			},
			{
				pass_type = "texture",
				style_id = "icon_background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = {
						100,
						100,
					},
					color = Color.terminal_grid_background_gradient(nil, true),
					offset = {
						-80,
						0,
						2,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "icon",
				value = "content/ui/materials/icons/items/containers/item_container_square",
				value_id = "icon",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = {
						100,
						100,
					},
					material_values = {},
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						-80,
						0,
						4,
					},
				},
				visibility_function = function (content, style)
					local use_placeholder_texture = content.use_placeholder_texture

					if use_placeholder_texture and use_placeholder_texture == 0 then
						return true
					end

					return false
				end,
			},
			{
				pass_type = "texture",
				style_id = "outer_shadow",
				value = "content/ui/materials/frames/dropshadow_heavy",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					size = {
						100,
						100,
					},
					color = Color.black(180, true),
					size_addition = {
						20,
						20,
					},
					offset = {
						-80,
						0,
						4,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = {
						100,
						100,
					},
					color = Color.terminal_frame(nil, true),
					offset = {
						-80,
						0,
						7,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "reward_emblem",
				value = "",
				style = {
					drop_shadow = false,
					font_size = 70,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						80,
						-20,
						3,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "reward_score",
				value = "999",
				value_id = "reward_score",
				style = {
					drop_shadow = false,
					font_size = 36,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						80,
						35,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content

			content.element = element

			local texture = element.texture

			if texture then
				style.texture.material_values.texture_map = texture
			end

			local bar_progress = element.bar_progress

			content.bar_progress = bar_progress
			content.completed = element.completed
			content.can_claim = element.can_claim
			content.reward_score = "+" .. element.score

			local item = element.item
			local step = element.step

			if step then
				content.label = Localize("loc_achievements_view_family_reward_label", true, {
					step = step,
				})
			end

			local reward_display_name = ItemUtils.display_name(item)

			content.display_name = reward_display_name

			local rarity = item.rarity
			local item_type = ItemUtils.type_display_name(item)

			if rarity then
				local rarity_color, dark_rarity_color = ItemUtils.rarity_color(item)

				style.icon_background_gradient.color = table.clone(dark_rarity_color)

				local rarity_display_name = ItemUtils.rarity_display_name(item)

				content.sub_display_name = string.format("{#color(%d, %d, %d)}%s{#reset()} • %s", rarity_color[2], rarity_color[3], rarity_color[4], rarity_display_name, item_type)
			else
				content.sub_display_name = item_type
			end

			if bar_progress then
				style.bar.size[1] = bar_progress * penance_pixel_size
			end

			local slot = ItemUtils.item_slot(item)
			local item_icon_size = slot.item_icon_size

			if item_icon_size then
				local icon_width = item_icon_size[1] * (100 / ItemPassTemplates.ui_item_size[1])
				local icon_height = item_icon_size[2] * (100 / ItemPassTemplates.ui_item_size[2])

				item_icon_size = {
					icon_width,
					icon_height,
				}
				style.icon.material_values.icon_size = item_icon_size
			end

			local texture_color = element.color

			if texture_color then
				local color = style.texture.color

				color[1] = texture_color[1]
				color[2] = texture_color[2]
				color[3] = texture_color[3]
				color[4] = texture_color[4]
			end
		end,
		load_icon = function (parent, widget, element, ui_renderer, dummy_profile, prioritize)
			local content = widget.content
			local item = element.item
			local item_group = element.item_group

			if not content.icon_load_id and item then
				local slot_name = ItemUtils.slot_name(item)
				local item_state_machine = item.state_machine
				local item_animation_event = item.animation_event
				local item_companion_state_machine = item.companion_state_machine ~= nil and item.companion_state_machine ~= "" and item.companion_state_machine or nil
				local item_companion_animation_event = item.companion_animation_event ~= nil and item.companion_animation_event ~= "" and item.companion_animation_event or nil
				local render_context = {
					camera_focus_slot_name = slot_name,
					state_machine = item_state_machine,
					animation_event = item_animation_event,
					companion_state_machine = item_companion_state_machine,
					companion_animation_event = item_companion_animation_event,
				}
				local cb, unload_cb

				if item_group == "nameplates" or item_group == "emotes" or item_group == "titles" then
					cb = callback(_apply_package_item_icon_cb_func, widget, item)
					unload_cb = callback(_remove_package_item_icon_cb_func, widget, ui_renderer)
				elseif item_group == "weapon_skin" then
					cb = callback(_apply_live_item_icon_cb_func, widget)
					unload_cb = callback(_remove_live_item_icon_cb_func, widget, ui_renderer)
				else
					cb = callback(_apply_live_item_icon_cb_func, widget)
					unload_cb = callback(_remove_live_item_icon_cb_func, widget, ui_renderer)
				end

				content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, nil, nil, unload_cb)
			end
		end,
		unload_icon = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
		update_item_icon_priority = function (parent, widget, element, ui_renderer, dummy_profile)
			local content = widget.content

			if content.icon_load_id then
				Managers.ui:update_item_icon_priority(content.icon_load_id)
			end
		end,
	}
end

local function _setup_blueprint_penance_score(input_size, edge_padding)
	return {
		size = {
			input_size[1],
			130,
		},
		pass_template = {
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					color = {
						120,
						0,
						0,
						0,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "reward_emblem",
				value = "",
				style = {
					drop_shadow = false,
					font_size = 70,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						0,
						-20,
						3,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "reward_score",
				value = "999",
				value_id = "reward_score",
				style = {
					drop_shadow = false,
					font_size = 36,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						0,
						35,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local content = widget.content

			content.element = element
			content.reward_score = "+" .. element.score
		end,
	}
end

local function _setup_blueprint_penance_progress_bar(input_size, edge_padding)
	edge_padding = edge_padding or 0

	return {
		size = {
			input_size[1],
			37,
		},
		pass_template = {
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "top",
					color = Color.terminal_background_dark(255, true),
					size = {
						input_size[1] - (40 + edge_padding),
						12,
					},
					offset = {
						20 + edge_padding * 0.5,
						0,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "top",
					size = {
						input_size[1] - (40 + edge_padding),
						12,
					},
					color = Color.terminal_frame(nil, true),
					offset = {
						20 + edge_padding * 0.5,
						0,
						4,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "progress_bar",
				value = "content/ui/materials/bars/simple/fill",
				style = {
					vertical_alignment = "top",
					color = {
						255,
						255,
						255,
						255,
					},
					size = {
						input_size[1] - (40 + edge_padding),
						12,
					},
					offset = {
						20 + edge_padding * 0.5,
						0,
						1,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 20,
					font_type = "proxima_nova_bold",
					horizontal_alignment = "center",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "bottom",
					text_color = Color.terminal_text_body(255, true),
					size = {
						input_size[1] - (40 + edge_padding),
					},
					offset = {
						0,
						0,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local optional_text_color = element.text_color

			if optional_text_color then
				ColorUtilities.color_copy(optional_text_color, style.text.text_color)
			end

			local progress = element.progress or 0

			style.progress_bar.size[1] = style.background.size[1] * progress
			content.element = element
			content.text = text
		end,
	}
end

local function _setup_blueprint_penance_stat(input_size, edge_padding)
	edge_padding = edge_padding or 0

	return {
		size = {
			input_size[1],
			25,
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1] or input_size[1] * 0.5,
				size[2] or 25,
			} or {
				input_size[1] * 0.5,
				25,
			}
		end,
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 16,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "top",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						10 + edge_padding * 0.5,
						0,
						3,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "value",
				value = "n/a",
				value_id = "value",
				style = {
					font_size = 16,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "right",
					text_vertical_alignment = "top",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						-(10 + edge_padding * 0.5),
						0,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local value = element.value
			local optional_text_color = element.text_color

			if optional_text_color then
				ColorUtilities.color_copy(optional_text_color, style.text.text_color)
			end

			local size = content.size
			local text_style = style.text
			local max_width = size[1] - (40 + math.abs(text_style.offset[1]))
			local croped_text = UIRenderer.crop_text_width(ui_renderer, text, text_style.font_type, text_style.font_size, max_width)

			content.element = element
			content.text = croped_text
			content.value = value
		end,
	}
end

local function _setup_blueprint_penance_icon_and_name(input_size, edge_padding)
	edge_padding = edge_padding or 0

	return {
		size = {
			input_size[1],
			50,
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1] or input_size[1],
				size[2] or 50,
			} or {
				input_size[1],
				50,
			}
		end,
		pass_template = {
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/icons/achievements/achievement_icon_container_v2",
				style = {
					horizontal_alignment = "left",
					size = {
						50,
						50,
					},
					material_values = {
						icon = "content/ui/textures/icons/achievements/achievement_icon_0010",
					},
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						edge_padding * 0.5,
						0,
						1,
					},
				},
				change_function = function (content, style)
					local completed = content.completed
					local color_value = completed and 120 or 255

					style.color[2] = color_value
					style.color[3] = color_value
					style.color[4] = color_value
				end,
			},
			{
				pass_type = "texture",
				style_id = "outer_shadow",
				value = "content/ui/materials/icons/achievements/frames/achievements_dropshadow_medium",
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					size = {
						56,
						56,
					},
					color = Color.black(200, true),
					size_addition = {
						0,
						0,
					},
					offset = {
						12,
						-3,
						7,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "complete_sign",
				value = "",
				style = {
					drop_shadow = true,
					font_size = 48,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					size = {
						50,
						50,
					},
					text_color = Color.ui_terminal(255, true),
					offset = {
						edge_padding * 0.5,
						0,
						2,
					},
				},
				visibility_function = function (content, style)
					return content.completed
				end,
			},
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 16,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						edge_padding * 0.5 + 50 + 10,
						0,
						3,
					},
					size_addition = {
						-(50 + edge_padding + 10),
						0,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local optional_text_color = element.text_color

			if optional_text_color then
				ColorUtilities.color_copy(optional_text_color, style.text.text_color)
			end

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local max_width = (size[1] - (20 + math.abs(text_style.size_addition[1]))) * 1.2
			local croped_text = UIRenderer.crop_text_width(ui_renderer, text, text_style.font_type, text_style.font_size, max_width, nil, text_options)

			content.element = element
			content.text = croped_text
			content.completed = element.completed

			local texture = element.texture

			if texture then
				style.texture.material_values.icon = texture
			end

			local family_index = element.family_index

			if family_index then
				local number_texture = PenanceOverviewViewSettings.roman_numeral_texture_array[family_index]

				if texture and number_texture then
					style.texture.material_values.icon_number = number_texture
				end
			end
		end,
	}
end

local function _setup_blueprint_penance_completed(input_size, edge_padding)
	return {
		size = {
			input_size[1],
			0,
		},
		pass_template = {
			{
				pass_type = "texture",
				value = "content/ui/materials/icons/generic/top_right_triangle",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					size = {
						62.400000000000006,
						62.400000000000006,
					},
					color = Color.terminal_frame_hover(180, true),
					offset = {
						0,
						-20,
						8,
					},
				},
				visibility_function = function (content, style)
					return content.completed
				end,
			},
			{
				pass_type = "text",
				style_id = "complete_sign",
				value = "",
				style = {
					drop_shadow = true,
					font_size = 28.6,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "right",
					text_vertical_alignment = "top",
					text_color = Color.ui_terminal(255, true),
					offset = {
						-6,
						-16,
						10,
					},
				},
				visibility_function = function (content, style)
					return content.completed
				end,
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local content = widget.content

			content.completed = element.completed
		end,
	}
end

local function _setup_blueprint_penance_category(input_size, edge_padding)
	return {
		size = {
			input_size[1],
			0,
		},
		pass_template = {
			{
				pass_type = "texture",
				style_id = "icon",
				value_id = "icon",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "top",
					color = Color.terminal_text_body(255, true),
					default_color = Color.terminal_frame(180, true),
					selected_color = Color.terminal_frame_selected(180, true),
					disabled_color = Color.ui_grey_medium(180, true),
					hover_color = Color.terminal_frame_hover(180, true),
					size = {
						70,
						50,
					},
					offset = {
						0,
						-10,
						1,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local content = widget.content

			content.element = element

			local achievement = element.achievement
			local achivement_category = achievement.category
			local category

			if AchievementCategories[achivement_category] then
				local category_config = AchievementCategories[achivement_category]
				local parent_name = category_config.parent_name

				category = parent_name or achivement_category
			end

			content.icon = PenanceOverviewViewSettings.category_icons[category] or "content/ui/materials/icons/item_types/upper_bodies"
		end,
	}
end

local grid_blueprints = {
	carousel_penance_tracked = _setup_blueprint_penance_tracked(carousel_penance_size),
	carousel_penance_icon = _setup_blueprint_penance_icon(carousel_penance_size),
	carousel_penance_icon_small = _setup_blueprint_penance_icon_small(carousel_penance_size),
	carousel_penance_header = _setup_blueprint_penance_header(carousel_penance_size),
	carousel_penance_body = _setup_blueprint_penance_body(carousel_penance_size),
	carousel_penance_score_and_reward = _setup_blueprint_penance_score_and_reward(carousel_penance_size),
	carousel_penance_reward = _setup_blueprint_penance_score(carousel_penance_size),
	carousel_penance_progress_bar = _setup_blueprint_penance_progress_bar(carousel_penance_size),
	carousel_penance_stat = _setup_blueprint_penance_stat(carousel_penance_size),
	carousel_penance_icon_and_name = _setup_blueprint_penance_icon_and_name(carousel_penance_size),
	carousel_penance_completed = _setup_blueprint_penance_completed(carousel_penance_size),
	carousel_penance_category = _setup_blueprint_penance_category(carousel_penance_size),
	tooltip_penance_tracked = _setup_blueprint_penance_tracked(tooltip_blueprint_size, 30),
	tooltip_penance_icon = _setup_blueprint_penance_icon(tooltip_blueprint_size, 30),
	tooltip_penance_icon_small = _setup_blueprint_penance_icon_small(tooltip_blueprint_size, 30),
	tooltip_penance_header = _setup_blueprint_penance_header(tooltip_blueprint_size, 30),
	tooltip_penance_body = _setup_blueprint_penance_body(tooltip_blueprint_size, 30),
	tooltip_penance_score_and_reward = _setup_blueprint_penance_score_and_reward(tooltip_blueprint_size, 30),
	tooltip_penance_reward = _setup_blueprint_penance_score(tooltip_blueprint_size, 30),
	tooltip_penance_progress_bar = _setup_blueprint_penance_progress_bar(tooltip_blueprint_size, 30),
	tooltip_penance_stat = _setup_blueprint_penance_stat(tooltip_blueprint_size, 30),
	tooltip_penance_icon_and_name = _setup_blueprint_penance_icon_and_name(tooltip_blueprint_size, 30),
	tooltip_penance_completed = _setup_blueprint_penance_completed(tooltip_blueprint_size, 30),
	tooltip_penance_category = _setup_blueprint_penance_category(tooltip_blueprint_size, 30),
	claim_overlay = {
		size = {
			carousel_penance_size[1],
			0,
		},
		pass_template = {
			{
				pass_type = "texture",
				style_id = "overlay",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					size = {
						0,
						0,
					},
					color = {
						160,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						10,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "icon",
				value = "content/ui/materials/frames/achievements/penance_reward_symbol",
				style = {
					size = reward_icon_large,
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						12,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "glow",
				value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_background_glow",
				style = {
					scale_to_material = true,
					color = Color.ui_terminal(255, true),
					offset = {
						0,
						0,
						11,
					},
					size = reward_glow_large,
				},
			},
			{
				pass_type = "text",
				style_id = "title",
				value_id = "title",
				style = {
					font_size = 30,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_key_value(255, true),
					offset = {
						20,
						100,
						13,
					},
					size = {
						0,
						0,
					},
					size_addition = {
						-40,
						0,
					},
				},
				value = Localize("loc_penance_menu_completed_title"),
			},
			{
				pass_type = "text",
				style_id = "description",
				value_id = "description",
				style = {
					font_size = 24,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_header(255, true),
					offset = {
						20,
						135,
						13,
					},
					size = {
						0,
						0,
					},
					size_addition = {
						-40,
						0,
					},
				},
				value = Localize("loc_penance_menu_claim_button"),
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local size = element.size
			local style = widget.style

			if size then
				local title_style = style.title

				if title_style then
					local title_size = title_style.size

					title_size[1] = size[1]
					title_size[2] = size[2]
				end

				local description_style = style.description

				if description_style then
					local description_size = description_style.size

					description_size[1] = size[1]
					description_size[2] = size[2]
				end

				local overlay_style = style.overlay

				if overlay_style then
					local texture_size = overlay_style.size

					texture_size[1] = size[1]
					texture_size[2] = size[2]
				end

				local icon_style = style.icon

				if icon_style then
					local texture_size = icon_style.size
					local offset = icon_style.offset

					offset[1] = (size[1] - texture_size[1]) * 0.5
					offset[2] = (size[2] - texture_size[2]) * 0.5
				end

				local glow_style = style.glow

				if glow_style then
					local texture_size = glow_style.size
					local offset = glow_style.offset

					offset[1] = (size[1] - texture_size[1]) * 0.5
					offset[2] = (size[2] - texture_size[2]) * 0.5
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			if parent._using_cursor_navigation then
				widget.content.description = Localize("loc_penance_menu_claim_button")
			elseif widget.content.hovered or widget.content.hovered then
				local action = "confirm_pressed"
				local service_type = "View"
				local alias_key = Managers.ui:get_input_alias_key(action, service_type)
				local input_text = InputUtilities.input_text_for_current_input_device(service_type, alias_key)

				widget.content.description = string.format("%s %s", input_text, Localize("loc_penance_menu_claim_button"))
			else
				widget.content.description = ""
			end
		end,
	},
	texture = {
		size = {
			64,
			64,
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or {
				64,
				64,
			}
		end,
		pass_template = {
			{
				pass_type = "texture",
				style_id = "texture",
				value_id = "texture",
				style = {
					color = {
						255,
						255,
						255,
						255,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local texture = element.texture

			if texture then
				content.texture = texture
			end

			local texture_color = element.color

			if texture_color then
				local color = style.texture.color

				color[1] = texture_color[1]
				color[2] = texture_color[2]
				color[3] = texture_color[3]
				color[4] = texture_color[4]
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
	header = {
		size = {
			penance_grid_size[1],
			100,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 24,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_header(255, true),
					offset = {
						0,
						0,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local new_indicator_width_offset = element.new_indicator_width_offset

			if new_indicator_width_offset then
				local offset = style.new_indicator.offset

				offset[1] = new_indicator_width_offset[1]
				offset[2] = new_indicator_width_offset[2]
				offset[3] = new_indicator_width_offset[3]
			end

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

			size[2] = height + 0
		end,
	},
	body = {
		size = {
			penance_grid_size[1],
			100,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 20,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "center",
					text_color = Color.text_default(255, true),
					offset = {
						0,
						0,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local optional_text_color = element.text_color

			if optional_text_color then
				ColorUtilities.color_copy(optional_text_color, style.text.text_color)
			end

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

			size[2] = height + 0
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
		end,
	},
	body_centered = {
		size = {
			penance_grid_size[1],
			100,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value = "n/a",
				value_id = "text",
				style = {
					font_size = 20,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.text_default(255, true),
					offset = {
						0,
						0,
						3,
					},
				},
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content
			local text = element.text
			local optional_text_color = element.text_color

			if optional_text_color then
				ColorUtilities.color_copy(optional_text_color, style.text.text_color)
			end

			content.element = element
			content.text = text

			local size = content.size
			local text_style = style.text
			local text_options = UIFonts.get_font_options_by_style(text_style)
			local height = UIRenderer.text_height(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

			size[2] = height + 0
		end,
	},
	dynamic_spacing = {
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or {
				225,
				20,
			}
		end,
	},
	penance = {
		size = penance_size,
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or penance_size
		end,
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = default_button_content,
			},
			{
				pass_type = "texture",
				style_id = "outer_shadow",
				value = "content/ui/materials/frames/dropshadow_heavy",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					color = Color.black(200, true),
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
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					offset = {
						0,
						0,
						1,
					},
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/icons/generic/bookmark",
				style = {
					horizontal_alignment = "right",
					scale_to_material = true,
					vertical_alignment = "top",
					color = Color.terminal_corner_selected(255, true),
					size = {
						20,
						20,
					},
					offset = {
						-2,
						-2,
						7,
					},
				},
				visibility_function = function (content, style)
					return content.tracked
				end,
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						8,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					disabled_color = Color.ui_grey_light(255, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						9,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/icons/achievements/achievement_icon_container_v2",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size_addition = {
						-20,
						-20,
					},
					material_values = {
						icon = "content/ui/textures/icons/achievements/achievement_icon_0010",
					},
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						3,
					},
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local anim_hover_progress = hotspot.anim_hover_progress or 0
					local anim_select_progress = hotspot.anim_select_progress or 0
					local anim_focus_progress = hotspot.anim_focus_progres or 0
					local completed = content.completed or content.can_claim
					local complete_multiplier = completed and 1 or 0.5
					local default_color = 255 * complete_multiplier
					local hover_color = anim_hover_progress * 55
					local select_color = math.max(anim_select_progress, anim_focus_progress) * 50
					local color_value = math.clamp(default_color + select_color + hover_color, 0, 255)

					style.color[2] = color_value
					style.color[3] = color_value
					style.color[4] = color_value
				end,
			},
			{
				pass_type = "texture",
				style_id = "icon_outer_shadow",
				value = "content/ui/materials/icons/achievements/frames/achievements_dropshadow_medium",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					color = Color.black(200, true),
					size_addition = {
						-10,
						-10,
					},
					offset = {
						0,
						0,
						5,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "claim_icon",
				value = "content/ui/materials/frames/achievements/penance_reward_symbol_small",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = reward_icon_small,
					size_addition = {
						-20,
						-20,
					},
					color = Color.white(255, true),
					offset = {
						0,
						0,
						9,
					},
				},
				visibility_function = function (content, style)
					return content.can_claim and not content.completed
				end,
			},
			{
				pass_type = "texture",
				style_id = "claim_icon_glow",
				value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_background_glow",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = reward_glow_small,
					color = Color.ui_terminal(255, true),
					offset = {
						0,
						0,
						8,
					},
				},
				visibility_function = function (content, style)
					return content.can_claim and not content.completed
				end,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					color = {
						220,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						3,
					},
				},
				visibility_function = function (content, style)
					return content.can_claim
				end,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					color = {
						100,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						2,
					},
				},
				visibility_function = function (content, style)
					return not content.completed and not content.can_claim
				end,
			},
			{
				pass_type = "text",
				style_id = "claim_description",
				value = "",
				value_id = "claim_description",
				style = {
					drop_shadow = true,
					font_size = 24,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_header(255, true),
					offset = {
						0,
						0,
						9,
					},
				},
				visibility_function = function (content, style)
					return content.can_claim and not content.completed and (content.hotspot.is_hover or content.hotspot.is_selected)
				end,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/icons/generic/top_right_triangle",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					size = {
						penance_size[1] / 100 * 40,
						penance_size[2] / 100 * 40,
					},
					default_color = Color.terminal_frame(180, true),
					selected_color = Color.terminal_frame_selected(180, true),
					disabled_color = Color.ui_grey_medium(180, true),
					hover_color = Color.terminal_frame_hover(180, true),
					offset = {
						0,
						0,
						8,
					},
				},
				visibility_function = function (content, style)
					return content.completed and not content.can_claim
				end,
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "text",
				style_id = "complete_sign",
				value = "",
				style = {
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "right",
					text_vertical_alignment = "top",
					font_size = penance_size[1] / 100 * 22,
					text_color = Color.black(255, true),
					default_color = Color.ui_terminal(nil, true),
					selected_color = Color.white(nil, true),
					disabled_color = Color.ui_grey_light(255, true),
					hover_color = Color.ui_terminal(nil, true),
					offset = {
						-4,
						-1,
						9,
					},
				},
				visibility_function = function (content, style)
					return content.completed and not content.can_claim
				end,
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content

			content.element = element

			local texture = element.texture

			if texture then
				style.texture.material_values.icon = texture
			end

			local family_index = element.family_index

			if family_index then
				local number_texture = PenanceOverviewViewSettings.roman_numeral_texture_array[family_index]

				if texture and number_texture then
					style.texture.material_values.icon_number = number_texture
				end
			end

			local can_claim = element.can_claim
			local bar_progress = not can_claim and element.bar_progress or nil

			content.bar_progress = bar_progress
			content.completed = element.completed
			content.can_claim = can_claim

			local tracked = element.tracked

			content.tracked = tracked
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.hotspot.right_pressed_callback = callback(parent, secondary_callback_name, widget, element)

			local texture_color = element.color

			if texture_color then
				local color = style.texture.color

				color[1] = texture_color[1]
				color[2] = texture_color[2]
				color[3] = texture_color[3]
				color[4] = texture_color[4]
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			if parent._using_cursor_navigation then
				widget.content.claim_description = ""
			else
				local action = "confirm_pressed"
				local service_type = "View"
				local alias_key = Managers.ui:get_input_alias_key(action, service_type)
				local input_text = InputUtilities.input_text_for_current_input_device(service_type, alias_key)

				widget.content.claim_description = input_text
			end
		end,
	},
	penance_large = {
		size = penance_size_large,
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or penance_size_large
		end,
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				content = default_button_content,
			},
			{
				pass_type = "texture",
				style_id = "outer_shadow",
				value = "content/ui/materials/frames/dropshadow_heavy",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					color = Color.black(200, true),
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
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					offset = {
						0,
						0,
						1,
					},
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/icons/generic/bookmark",
				style = {
					horizontal_alignment = "right",
					scale_to_material = true,
					vertical_alignment = "top",
					color = Color.terminal_corner_selected(255, true),
					size = {
						20,
						20,
					},
					offset = {
						-2,
						-2,
						9,
					},
				},
				visibility_function = function (content, style)
					return content.tracked
				end,
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					hover_color = Color.terminal_frame_hover(nil, true),
					offset = {
						0,
						0,
						10,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					disabled_color = Color.ui_grey_light(255, true),
					hover_color = Color.terminal_corner_hover(nil, true),
					offset = {
						0,
						0,
						11,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "texture",
				value = "content/ui/materials/icons/achievements/achievement_icon_container_v2",
				style = {
					size = {
						70,
						70,
					},
					material_values = {
						icon = "content/ui/textures/icons/achievements/achievement_icon_0010",
					},
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						10,
						10,
						6,
					},
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local anim_hover_progress = hotspot.anim_hover_progress or 0
					local anim_select_progress = hotspot.anim_select_progress or 0
					local anim_focus_progress = hotspot.anim_focus_progress or 0
					local complete_multiplier = 1
					local default_color = 155 * complete_multiplier
					local hover_color = anim_hover_progress * 100 * complete_multiplier
					local select_color = math.max(anim_select_progress, anim_focus_progress) * 50 * complete_multiplier
					local color_value = math.clamp(default_color + select_color + hover_color, 0, 255)

					style.color[2] = color_value
					style.color[3] = color_value
					style.color[4] = color_value
				end,
			},
			{
				pass_type = "texture",
				style_id = "icon_outer_shadow",
				value = "content/ui/materials/icons/achievements/frames/achievements_dropshadow_medium",
				style = {
					horizontal_alignment = "left",
					scale_to_material = true,
					vertical_alignment = "top",
					size = {
						79,
						79,
					},
					color = Color.black(200, true),
					size_addition = {
						0,
						0,
					},
					offset = {
						5,
						5,
						5,
					},
				},
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					color = {
						120,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						2,
					},
				},
				visibility_function = function (content, style)
					return not content.completed and not content.hotspot.is_selected
				end,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/icons/generic/top_right_triangle",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					size = {
						penance_size[1] / 100 * 40,
						penance_size[2] / 100 * 40,
					},
					default_color = Color.terminal_frame(180, true),
					selected_color = Color.terminal_frame_selected(180, true),
					disabled_color = Color.ui_grey_medium(180, true),
					hover_color = Color.terminal_frame_hover(180, true),
					offset = {
						0,
						0,
						8,
					},
				},
				visibility_function = function (content, style)
					return content.completed and not content.can_claim
				end,
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "text",
				style_id = "complete_sign",
				value = "",
				style = {
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "right",
					text_vertical_alignment = "top",
					font_size = penance_size[1] / 100 * 22,
					text_color = Color.black(255, true),
					default_color = Color.ui_terminal(nil, true),
					selected_color = Color.white(nil, true),
					disabled_color = Color.ui_grey_light(255, true),
					hover_color = Color.ui_terminal(nil, true),
					offset = {
						-4,
						-1,
						9,
					},
				},
				visibility_function = function (content, style)
					return content.completed and not content.can_claim
				end,
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "text",
				style_id = "title",
				value = "n/a",
				value_id = "title",
				style = {
					font_size = 24,
					font_type = "proxima_nova_bold",
					horizontal_alignment = "left",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "top",
					text_color = Color.terminal_text_header(255, true),
					offset = {
						90,
						10,
						3,
					},
					size_addition = {
						-170,
						0,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "description",
				value = "n/a",
				value_id = "description",
				style = {
					font_size = 18,
					font_type = "proxima_nova_bold",
					horizontal_alignment = "left",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "top",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						90,
						40,
						3,
					},
					size_addition = {
						-170,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "bar_background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "top",
					size = {
						penance_size_large[1] - 230,
						12,
					},
					offset = {
						90,
						45,
						4,
					},
					color = Color.terminal_background_dark(255, true),
				},
				visibility_function = function (content, style)
					return not content.completed and content.bar_progress
				end,
			},
			{
				pass_type = "texture",
				style_id = "bar_frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "top",
					size = {
						penance_size_large[1] - 230,
						12,
					},
					offset = {
						90,
						45,
						6,
					},
					color = Color.terminal_frame(nil, true),
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					hover_color = Color.terminal_frame_hover(nil, true),
				},
				visibility_function = function (content, style)
					return not content.completed and content.bar_progress
				end,
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "bar",
				value = "content/ui/materials/bars/simple/fill",
				style = {
					vertical_alignment = "top",
					size = {
						penance_size_large[1] - 230,
						12,
					},
					default_size = {
						penance_size_large[1] - 230,
						12,
					},
					offset = {
						90,
						45,
						5,
					},
					color = {
						255,
						255,
						255,
						255,
					},
				},
				visibility_function = function (content, style)
					return not content.completed and content.bar_progress
				end,
			},
			{
				pass_type = "text",
				style_id = "bar_values_text",
				value = "n/a",
				value_id = "bar_values_text",
				style = {
					font_size = 16,
					font_type = "proxima_nova_bold",
					horizontal_alignment = "right",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					offset = {
						-70,
						45,
						3,
					},
					size = {
						70,
						12,
					},
					text_color = Color.terminal_text_body(255, true),
				},
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					horizontal_alignment = "right",
					size = {
						70,
					},
					color = {
						200,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						2,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "reward_icon",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "reward_icon",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					size = {
						40,
						40,
					},
					material_values = {},
					color = Color.terminal_text_body(255, true),
					offset = {
						-15,
						10,
						3,
					},
				},
				visibility_function = function (content, style)
					return style.material_values.texture_map
				end,
			},
			{
				pass_type = "text",
				style_id = "reward_emblem",
				value = "",
				style = {
					drop_shadow = false,
					font_size = 64,
					font_type = "proxima_nova_bold",
					horizontal_alignment = "right",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					size = {
						70,
					},
					text_color = Color.terminal_text_body(255, true),
					offset = {
						0,
						25,
						3,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "reward_score",
				value = "n/a",
				value_id = "reward_score",
				style = {
					drop_shadow = false,
					font_size = 14,
					font_type = "proxima_nova_bold",
					horizontal_alignment = "right",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "center",
					size = {
						70,
					},
					text_color = Color.terminal_text_body(255, true),
					offset = {
						0,
						25,
						4,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "claim_icon",
				value = "content/ui/materials/frames/achievements/penance_reward_symbol_medium",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = reward_icon_medium,
					size_addition = {
						-20,
						-20,
					},
					color = Color.white(255, true),
					offset = {
						0,
						-20,
						9,
					},
				},
				visibility_function = function (content, style)
					return content.can_claim and not content.completed
				end,
			},
			{
				pass_type = "texture",
				style_id = "claim_icon_glow",
				value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_background_glow",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = reward_glow_medium,
					color = Color.ui_terminal(255, true),
					offset = {
						0,
						-20,
						8,
					},
				},
				visibility_function = function (content, style)
					return content.can_claim and not content.completed
				end,
			},
			{
				pass_type = "text",
				style_id = "claim_title",
				value = "Completed ",
				value_id = "claim_title",
				style = {
					font_size = 22,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "bottom",
					text_color = Color.terminal_text_key_value(255, true),
					offset = {
						0,
						-20,
						9,
					},
				},
				visibility_function = function (content, style)
					return content.can_claim and not content.completed
				end,
			},
			{
				pass_type = "text",
				style_id = "claim_description",
				value_id = "claim_description",
				style = {
					font_size = 16,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "bottom",
					text_color = Color.terminal_text_header(255, true),
					offset = {
						0,
						-5,
						9,
					},
				},
				value = Localize("loc_penance_menu_claim_button"),
				visibility_function = function (content, style)
					return content.can_claim and not content.completed
				end,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					color = {
						220,
						0,
						0,
						0,
					},
					offset = {
						0,
						0,
						7,
					},
				},
				visibility_function = function (content, style)
					return content.can_claim
				end,
			},
		},
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local style = widget.style
			local content = widget.content

			content.element = element

			local texture = element.texture

			if texture then
				style.texture.material_values.icon = texture
			end

			local family_index = element.family_index

			if family_index then
				local number_texture = PenanceOverviewViewSettings.roman_numeral_texture_array[family_index]

				if texture and number_texture then
					style.texture.material_values.icon_number = number_texture
				end
			end

			local can_claim = element.can_claim

			content.can_claim = can_claim

			local bar_progress = element.bar_progress

			content.bar_progress = bar_progress

			local completed = element.completed

			content.completed = completed

			local tracked = element.tracked

			content.tracked = tracked

			local reward_icon = element.reward_icon

			if reward_icon then
				local reward_icon_style = style.reward_icon
				local material_values = reward_icon_style.material_values

				material_values.texture_map = reward_icon
			else
				style.reward_emblem.offset[2] = 0
				style.reward_score.offset[2] = 0
			end

			local title_text = element.title or "n/a"

			if title_text then
				local title_text_style = style.title
				local size = content.size
				local text_max_width = size[1] + title_text_style.size_addition[1] - 30
				local text_options = UIFonts.get_font_options_by_style(title_text_style)
				local title_text_croped = UIRenderer.crop_text_width(ui_renderer, title_text, title_text_style.font_type, title_text_style.font_size, text_max_width, nil, text_options)

				content.title = title_text_croped
			end

			local description_text = not can_claim and completed and TextUtilities.apply_color_to_text(Localize("loc_notification_desc_achievement_completed"), Color.terminal_text_key_value(255, true)) or element.description or "n/a"

			if description_text then
				local description_text_style = style.description
				local size = content.size
				local num_rows = bar_progress and 3 or 4
				local text_max_width = (size[1] + description_text_style.size_addition[1] - 60) * num_rows
				local text_options = UIFonts.get_font_options_by_style(description_text_style)
				local description_text_croped = UIRenderer.crop_text_width(ui_renderer, description_text, description_text_style.font_type, description_text_style.font_size, text_max_width, nil, text_options)

				content.description = description_text_croped
			end

			content.bar_values_text = not can_claim and element.bar_values_text or ""
			content.reward_score = element.achievement_score and "+" .. element.achievement_score or ""

			if bar_progress then
				style.description.offset[2] = style.description.offset[2] + 25
			end

			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.hotspot.right_pressed_callback = callback(parent, secondary_callback_name, widget, element)

			if bar_progress then
				style.bar.size[1] = style.bar.default_size[1] * bar_progress
			end

			local texture_color = element.color

			if texture_color then
				local color = style.texture.color

				color[1] = texture_color[1]
				color[2] = texture_color[2]
				color[3] = texture_color[3]
				color[4] = texture_color[4]
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			if not parent._using_cursor_navigation then
				local action = "confirm_pressed"
				local service_type = "View"
				local alias_key = Managers.ui:get_input_alias_key(action, service_type)
				local input_text = InputUtilities.input_text_for_current_input_device(service_type, alias_key)

				widget.content.claim_description = string.format("%s %s", input_text, Localize("loc_penance_menu_claim_button"))
			else
				widget.content.claim_description = Localize("loc_penance_menu_claim_button")
			end
		end,
	},
	category_button = {
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				style_id = "hotspot",
				content = {
					on_pressed_sound = UISoundEvents.tab_secondary_button_pressed,
					on_hover_sound = UISoundEvents.default_mouse_hover,
				},
				style = {
					anim_focus_speed = 8,
					anim_hover_speed = 8,
					anim_input_speed = 8,
					anim_select_speed = 8,
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.tab_secondary_button_pressed,
				},
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					default_color = Color.terminal_background(nil, true),
					selected_color = Color.terminal_background_selected(nil, true),
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.terminal_background_gradient(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					offset = {
						0,
						0,
						1,
					},
				},
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style)
				end,
			},
			{
				pass_type = "texture",
				style_id = "outer_shadow",
				value = "content/ui/materials/frames/dropshadow_medium",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					color = Color.black(200, true),
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
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					default_color = Color.terminal_frame(nil, true),
					selected_color = Color.terminal_frame_selected(nil, true),
					disabled_color = Color.ui_grey_medium(255, true),
					offset = {
						0,
						0,
						2,
					},
				},
				change_function = ButtonPassTemplates.terminal_button_change_function,
			},
			{
				pass_type = "texture",
				style_id = "text_bg",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					color = Color.black(150, true),
					size = {
						68,
						18,
					},
					offset = {
						0,
						-1,
						8,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "text_counter",
				value = "0/0",
				value_id = "text_counter",
				style = {
					font_size = 16,
					font_type = "proxima_nova_bold",
					text_horizontal_alignment = "center",
					text_vertical_alignment = "bottom",
					text_color = Color.terminal_text_header(255, true),
					offset = {
						0,
						0,
						9,
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
					default_color = Color.terminal_text_header(255, true),
					disabled_color = Color.gray(255, true),
					color = Color.terminal_text_header(255, true),
					hover_color = Color.terminal_text_header_selected(255, true),
					size = {
						72,
						52,
					},
					original_size_addition = {
						-10,
						-10,
					},
					size_addition = {
						0,
						0,
					},
					offset = {
						0,
						-6,
						6,
					},
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
					local size_addition = 2 * math.easeInCubic(progress)
					local style_size_addition = style.size_addition
					local original_size_addition = style.original_size_addition

					style_size_addition[1] = original_size_addition[1] + size_addition * 2
					style_size_addition[2] = original_size_addition[1] + size_addition * 2

					ButtonPassTemplates.list_button_label_change_function(content, style)
				end,
			},
			{
				pass_type = "texture",
				style_id = "new_indicator",
				value = "content/ui/materials/symbols/new_item_indicator",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					size = {
						90,
						90,
					},
					offset = {
						23,
						-5,
						4,
					},
					color = Color.terminal_corner_selected(255, true),
				},
				visibility_function = function (content, style)
					return content.has_unclaimed_penances
				end,
			},
			{
				pass_type = "texture",
				style_id = "bookmark",
				value = "content/ui/materials/icons/generic/bookmark",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "top",
					size = {
						20,
						20,
					},
					offset = {
						-2,
						-2,
						4,
					},
					color = Color.terminal_corner_selected(255, true),
				},
				visibility_function = function (content, style)
					return content.has_favorite_penances and not content.has_unclaimed_penances
				end,
			},
		},
	},
}

return grid_blueprints
