-- chunkname: @scripts/ui/constant_elements/elements/notification_feed/constant_element_notification_feed_definitions.lua

local ConstantElementNotificationFeedSettings = require("scripts/ui/constant_elements/elements/notification_feed/constant_element_notification_feed_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISettings = require("scripts/settings/ui/ui_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local Text = require("scripts/utilities/ui/text")
local header_size = ConstantElementNotificationFeedSettings.header_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-10,
			450,
			990,
		},
	},
}

local function _convert_to_material_color(color)
	if not color then
		return nil
	end

	local material_color = {
		color[2] / 255,
		color[3] / 255,
		color[4] / 255,
		color[1] / 255,
	}

	return material_color
end

local create_notification_message = {
	pass_template_function = function ()
		local text_compensation = 4
		local icon_size = {
			50,
			50,
		}
		local text_font_style = table.clone(UIFontSettings.body)

		text_font_style.text_horizontal_alignment = "right"
		text_font_style.text_vertical_alignment = "top"
		text_font_style.horizontal_alignment = "right"
		text_font_style.vertical_alignment = "top"
		text_font_style.offset = {
			0,
			0,
			2,
		}
		text_font_style.size = {
			header_size[1] * 2,
			header_size[2] * 2,
		}
		text_font_style.text_color = table.clone(Color.terminal_text_header(255, true))
		text_font_style.font_size = 20
		text_font_style.line_spacing = 1

		return {
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/terminal_notification",
				value_id = "background",
				style = {
					horizontal_alignment = "right",
					scale_to_material = true,
					vertical_alignment = "top",
					size_addition = {
						0,
						20,
					},
					offset = {
						0,
						text_compensation,
						0,
					},
					material_values = {},
				},
			},
			{
				pass_type = "texture",
				style_id = "shine",
				value = "content/ui/materials/base/ui_default_base",
				value_id = "shine",
				style = {
					horizontal_alignment = "right",
					scale_to_material = true,
					vertical_alignment = "top",
					size = {
						50,
					},
					size_addition = {
						0,
						16,
					},
					offset = {
						0,
						text_compensation - 8,
						3,
					},
					color = Color.white(0, true),
					material_values = {
						texture_map = "content/ui/textures/masks/notification_shine",
					},
				},
				visibility_function = function (content)
					return content.show_shine
				end,
			},
			{
				pass_type = "texture",
				style_id = "icon",
				value = "",
				value_id = "icon",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "center",
					size = icon_size,
					offset = {
						0,
						4,
						1,
					},
					color = Color.white(255, true),
					material_values = {},
				},
				visibility_function = function (content)
					return content.icon
				end,
			},
			{
				pass_type = "text",
				style_id = "text_1",
				value = "",
				value_id = "text_1",
				style = text_font_style,
				visibility_function = function (content)
					return content.text_1
				end,
			},
			{
				pass_type = "text",
				style_id = "text_2",
				value = "",
				value_id = "text_2",
				style = text_font_style,
				visibility_function = function (content)
					return content.text_2
				end,
			},
			{
				pass_type = "text",
				style_id = "text_3",
				value = "",
				value_id = "text_3",
				style = text_font_style,
				visibility_function = function (content)
					return content.text_3
				end,
			},
		}
	end,
	init = function (parent, widget, element)
		local total_text_size = 0
		local icon_size = {
			0,
			0,
		}
		local text_offset = 30
		local max_text_width = 400
		local widget_width = 600
		local notification_vertical_margin = 20
		local text_margin = 5
		local notification_horizontal_start_offset = 15
		local icon_max_height_overflow = 10

		if element.icon then
			if element.icon_size == "large_weapon" then
				icon_size = UISettings.weapon_icon_size
				text_offset = 210
			elseif element.icon_size == "large_cosmetic" then
				icon_size = UISettings.cosmetics_item_size
				text_offset = 210
			elseif element.icon_size == "weapon_skin" then
				icon_size = UISettings.cosmetics_item_size
				text_offset = 210
			elseif element.icon_size == "large_gadget" then
				icon_size = UISettings.gadget_icon_size
				text_offset = 210
			elseif element.icon_size == "large_item" then
				icon_size = UISettings.ui_item_size
				text_offset = 210
			elseif element.icon_size == "large" then
				icon_size = {
					128,
					128,
				}
				text_offset = 210
			elseif element.icon_size == "medium" then
				icon_size = {
					80,
					80,
				}
				text_offset = 130
			elseif element.icon_size == "portrait_frame" then
				icon_size = ItemSlotSettings.slot_portrait_frame and ItemSlotSettings.slot_portrait_frame.item_icon_size or {
					90,
					100,
				}
				text_offset = 210
			elseif element.icon_size == "insignia" then
				icon_size = ItemSlotSettings.slot_insignia and ItemSlotSettings.slot_insignia.item_icon_size or {
					40,
					90,
				}
				text_offset = 210
			elseif element.icon_size == "currency" then
				icon_size = {
					104,
					88,
				}
				text_offset = 130
			else
				icon_size = {
					40,
					40,
				}
				text_offset = 80
			end
		end

		for i = 1, #element.texts do
			local text = element.texts[i]

			if text.display_name and text.display_name ~= "" then
				local pass_name = string.format("text_%d", i)
				local text_style = widget.style[pass_name]

				text_style.font_size = text.font_size or i == 1 and 22 or text_style.font_size

				local width, height = Text.text_size(parent._parent:ui_renderer(), text.display_name, text_style, {
					max_text_width,
					1080,
				})

				text_style.offset[2] = total_text_size
				text_style.size = {
					max_text_width,
					height,
				}
				total_text_size = total_text_size + height + text_margin
				widget.content[pass_name] = text.display_name

				if text.color then
					widget.style[pass_name].text_color = table.clone(text.color)
				end
			end
		end

		widget.content.icon = element.icon
		widget.style.icon.material_values = element.icon_material_values or {}
		element.color = element.color or Color.terminal_background(255 * ConstantElementNotificationFeedSettings.default_alpha_value, true)
		widget.style.background.material_values.background_color = _convert_to_material_color(element.color)
		widget.style.background.material_values.line_color = _convert_to_material_color(element.line_color)
		widget.style.background.material_values.background_glow_opacity = element.glow_opacity or 0
		widget.style.icon.color = element.icon_color and table.clone(element.icon_color) or table.clone(widget.style.icon.color)

		local height = total_text_size + notification_vertical_margin * 2 - text_margin

		if icon_size[2] > height + icon_max_height_overflow then
			local scale_ratio = (height + icon_max_height_overflow) / icon_size[2]

			icon_size = {
				scale_ratio * icon_size[1],
				scale_ratio * icon_size[2],
			}
		end

		widget.style.icon.size = icon_size

		local widget_height = math.max(height, icon_size[2] - notification_vertical_margin * 2)
		local background_compensation_top = widget.style.background.size_addition[2] * 0.5

		widget.size = {
			widget_width,
			widget_height,
		}
		widget.style.background.size = {
			widget_width,
			height,
		}
		widget.style.shine.size[2] = height - background_compensation_top
		widget.content.show_shine = element.show_shine

		local offset_content_compensation = (widget_height - height) * 0.5

		widget.style.shine.offset[2] = widget.style.shine.offset[2] + offset_content_compensation + background_compensation_top * 0.5
		widget.style.background.offset[2] = widget.style.background.offset[2] + offset_content_compensation - background_compensation_top
		widget.style.icon.offset = {
			-text_offset * 0.5 - notification_horizontal_start_offset,
			widget.style.icon.offset[2] + widget_height * 0.5,
			widget.style.icon.offset[3],
		}

		for i = 1, #element.texts do
			local pass_name = string.format("text_%d", i)
			local text_style = widget.style[pass_name]

			text_style.offset = {
				-text_offset - notification_horizontal_start_offset,
				text_style.offset[2] + offset_content_compensation + notification_vertical_margin,
				text_style.offset[3],
			}
		end

		widget.style.background.color[1] = 0
		widget.style.icon.color[1] = 0
		widget.style.shine.color[1] = 0
		widget.style.text_1.text_color[1] = 0
		widget.style.text_2.text_color[1] = 0
		widget.style.text_3.text_color[1] = 0
	end,
}
local counter_font_style = table.clone(UIFontSettings.body)

counter_font_style.text_horizontal_alignment = "left"
counter_font_style.text_vertical_alignment = "top"
counter_font_style.horizontal_alignment = "right"
counter_font_style.vertical_alignment = "top"
counter_font_style.offset = {
	-12,
	-35,
	2,
}
counter_font_style.text_color = Color.terminal_text_header(255, true)
counter_font_style.font_size = 20
counter_font_style.size = {
	550,
	20,
}

local widget_definitions = {
	queue_notification_counter = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "top",
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					-10,
					0,
				},
				size = {
					550,
					2,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "queue_counter",
			value = "",
			value_id = "queue_counter",
			style = counter_font_style,
		},
	}, "background", {
		visible = false,
	}),
}
local offset_end_position = 5
local offset_start_position = header_size[1]
local animations = {
	popup_enter = {
		{
			end_time = 0,
			name = "hide everything",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget)
				local text_start_offset = 25

				widget.alpha_multiplier = 1
				widget.style.background.offset[1] = offset_start_position
				widget.style.icon.size_addition = {
					widget.style.icon.size[1] * 0.9,
					widget.style.icon.size[2] * 0.9,
				}
				widget.style.icon.original_size_addition = {
					widget.style.icon.size_addition[1],
					widget.style.icon.size_addition[2],
				}
				widget.style.background.color[1] = 255
				widget.style.icon.color[1] = 0
				widget.style.shine.color[1] = 0
				widget.style.text_1.text_color[1] = 0
				widget.style.text_2.text_color[1] = 0
				widget.style.text_3.text_color[1] = 0
				widget.style.text_1.offset[1] = widget.style.text_1.offset[1] + text_start_offset
				widget.style.text_1.original_offset = widget.style.text_1.offset[1]
				widget.style.text_2.offset[1] = widget.style.text_2.offset[1] + text_start_offset
				widget.style.text_2.original_offset = widget.style.text_2.offset[1]
				widget.style.text_3.offset[1] = widget.style.text_3.offset[1] + text_start_offset
				widget.style.text_3.original_offset = widget.style.text_3.offset[1]
			end,
		},
		{
			end_time = 0.15,
			name = "background_resize",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(progress)
				local location_diff = offset_start_position - offset_end_position

				widget.style.background.offset[1] = offset_end_position + (location_diff - location_diff * anim_progress)
			end,
		},
		{
			end_time = 0.6,
			name = "icon_fade_in",
			start_time = 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeOutCubic(progress)

				widget.style.icon.color[1] = 255 * anim_progress

				local width = widget.style.icon.original_size_addition[1]
				local height = widget.style.icon.original_size_addition[2]

				widget.style.icon.size_addition = {
					width - width * anim_progress,
					height - height * anim_progress,
				}
			end,
		},
		{
			end_time = 0.35,
			name = "text_fade_in",
			start_time = 0.15,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeCubic(progress)

				widget.style.text_1.text_color[1] = 255 * anim_progress
				widget.style.text_1.offset[1] = widget.style.text_1.original_offset - 25 * anim_progress
				widget.style.text_2.text_color[1] = 255 * anim_progress
				widget.style.text_2.offset[1] = widget.style.text_2.original_offset - 25 * anim_progress
				widget.style.text_3.text_color[1] = 255 * anim_progress
				widget.style.text_3.offset[1] = widget.style.text_3.original_offset - 25 * anim_progress
			end,
		},
		{
			end_time = 0.9,
			name = "shine_fade_in",
			start_time = 0.6,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeCubic(progress)
				local fade_anim_progress = math.sin(math.pi * progress)

				widget.style.shine.color[1] = 255 * fade_anim_progress
				widget.style.shine.offset[1] = -(header_size[1] * 1.5) * math.sin(anim_progress)
			end,
		},
	},
	popup_leave = {
		{
			end_time = 0.15,
			name = "notification_out",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress)
				local anim_progress = math.easeInCubic(progress)

				widget.alpha_multiplier = 1 - anim_progress

				local location_diff = offset_start_position - offset_end_position

				widget.offset[1] = offset_end_position + location_diff * anim_progress
			end,
		},
	},
}

return {
	notification_message = create_notification_message,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	animations = animations,
}
