-- chunkname: @scripts/ui/constant_elements/elements/mission_buffs/constant_element_mission_buffs_blueprints.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Text = require("scripts/utilities/ui/text")
local card_size = {
	440,
	335,
}
local hightlight_color = {
	255,
	193,
	229,
	241,
}
local progress_color = {
	255,
	226,
	199,
	126,
}
local blueprints = {}

blueprints.buff_card = {
	size = card_size,
	pass_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.mission_buffs_buff_hover_enter,
				hold_sound = UISoundEvents.mission_buffs_buff_hold_start,
				hold_release = UISoundEvents.mission_buffs_buff_hold_stop,
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				scale_to_material = true,
				color = Color.terminal_grid_background(255, true),
				offset = {
					-12,
					-10,
					0,
				},
				size_addition = {
					24,
					20,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "progress_highlight",
			value = "content/ui/materials/frames/dropshadow_medium",
			value_id = "progress_highlight",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = table.clone(hightlight_color),
				size_addition = {
					20,
					20,
				},
				offset = {
					0,
					0,
					1,
				},
			},
			change_function = function (content, style, animations, dt)
				style.color[1] = 255 * (content.hold_progress or 0)
			end,
			visibility_function = function (content, style)
				return content.is_choice
			end,
		},
		{
			pass_type = "rect",
			style_id = "input_progress_background",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				offset = {
					0,
					0,
					1,
				},
				size = {
					0,
				},
				color = table.merge(table.clone(progress_color), {
					153,
				}),
			},
			change_function = function (content, style, animations, dt)
				style.size[1] = (content.size and content.size[1] or 0) * (content.hold_progress or 0)
			end,
			visibility_function = function (content, style)
				return content.is_choice
			end,
		},
		{
			pass_type = "text",
			style_id = "title",
			value = "",
			value_id = "title",
			style = {
				font_size = 24,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					20,
					75,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "sub_title",
			value = "",
			value_id = "sub_title",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_body_sub_header(255, true),
				offset = {
					20,
					100,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "description",
			value = "",
			value_id = "description",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					20,
					140,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				size = {
					144,
					144,
				},
				material_values = {
					frame = "content/ui/textures/frames/horde/hex_frame_horde",
					icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
					intensity = 0,
					saturation = 1,
				},
				offset = {
					0,
					-75,
					4,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "top",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "top",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					462,
					44,
				},
				offset = {
					0,
					-20,
					2,
				},
				material_values = {
					texture_map = "content/ui/textures/frames/horde/horde_buff_boon_granted",
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					470,
					52,
				},
				offset = {
					0,
					30,
					2,
				},
				material_values = {
					texture_map = "content/ui/textures/frames/horde/horde_buff_bottom",
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon_glow",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "icon_glow",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				offset = {
					0,
					-80,
					3,
				},
				size = {
					172,
					156,
				},
				color = table.clone(hightlight_color),
				material_values = {
					texture_map = "content/ui/textures/frames/horde/hex_frame_horde_glow",
				},
			},
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover
				local is_chosen_buff = content.is_chosen_buff

				return is_chosen_buff or not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
		{
			pass_type = "texture",
			style_id = "icon_selected",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "icon_selected",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				size = {
					117,
					117,
				},
				offset = {
					0,
					-60,
					5,
				},
				color = table.clone(hightlight_color),
				material_values = {
					texture_map = "content/ui/textures/frames/horde/hex_frame_horde_selected",
				},
			},
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover
				local is_chosen_buff = content.is_chosen_buff

				return is_chosen_buff or not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
		{
			pass_type = "texture",
			style_id = "divider_sub_buff",
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "divider_sub_buff",
			style = {
				horizontal_alignment = "center",
				size = {
					nil,
					22,
				},
				size_addition = {
					-60,
					0,
				},
				color = Color.terminal_text_body_dark(255, true),
				offset = {
					0,
					250,
					6,
				},
			},
			visibility_function = function (content, style)
				return content.is_family and content.has_sub_buff
			end,
		},
		{
			pass_type = "texture",
			style_id = "sub_buff_icon",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			value_id = "sub_buff_icon",
			style = {
				horizontal_alignment = "center",
				size = {
					100,
					100,
				},
				material_values = {
					frame = "content/ui/textures/frames/horde/hex_frame_horde",
					icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
					intensity = 0,
					saturation = 1,
				},
				offset = {
					0,
					280,
					4,
				},
			},
			visibility_function = function (content, style)
				return content.is_family and content.has_sub_buff
			end,
		},
		{
			pass_type = "text",
			style_id = "sub_buff_title",
			value = "",
			value_id = "sub_buff_title",
			style = {
				font_size = 22,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					20,
					375,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
			visibility_function = function (content, style)
				return content.is_family and content.has_sub_buff
			end,
		},
		{
			pass_type = "text",
			style_id = "sub_buff_sub_title",
			value = "",
			value_id = "sub_buff_sub_title",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_body_sub_header(255, true),
				offset = {
					20,
					400,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
			visibility_function = function (content, style)
				return content.is_family and content.has_sub_buff
			end,
		},
		{
			pass_type = "text",
			style_id = "sub_buff_description",
			value = "",
			value_id = "sub_buff_description",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					20,
					440,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
			visibility_function = function (content, style)
				return content.is_family and content.has_sub_buff
			end,
		},
		{
			pass_type = "text",
			style_id = "confirm_text",
			value = "",
			value_id = "confirm_text",
			style = {
				font_size = 24,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "bottom",
				text_color = Color.legend_button_text(255, true),
				offset = {
					20,
					-30,
					6,
				},
				size_addition = {
					-40,
					0,
				},
			},
			visibility_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot and hotspot.disabled
				local is_selected = hotspot and hotspot.is_selected
				local is_focused = hotspot and hotspot.is_focused
				local is_hover = hotspot and hotspot.is_hover
				local is_chosen_buff = content.is_chosen_buff

				return content.is_choice and not is_disabled and (is_selected or is_focused or is_hover)
			end,
		},
		{
			pass_type = "logic",
			value = function (pass, renderer, style, content, position, size)
				if not content.is_choice then
					return
				end

				local using_cursor_navigation = Managers.ui:using_cursor_navigation()

				if not using_cursor_navigation and not content.hotspot.is_selected then
					return
				end

				local hotspot = content.hotspot
				local input_service = renderer.input_service
				local button_pressed, button_held

				if using_cursor_navigation then
					button_pressed = hotspot.on_pressed
					button_held = input_service:get("left_hold")
				else
					button_pressed = input_service:get("confirm_pressed")
					button_held = input_service:get("confirm_hold")
				end

				local dt = renderer.dt

				content.start_delay = math.max(content.start_delay - dt, 0)

				if content.start_delay > 0 then
					button_pressed, button_held = false, false
				end

				if button_pressed then
					content.hold_active = true
				elseif not button_held then
					content.hold_active = false
				end

				if content.hold_active and not hotspot.disabled then
					local total_time = content.timer
					local current_time = content.current_timer + dt
					local progress = math.min(current_time / total_time, 1)

					if progress < 1 then
						if hotspot.hold_sound and (content.hold_progress == 0 or not content.hold_progress) then
							Managers.ui:play_2d_sound(hotspot.hold_sound)
						end

						content.current_timer = current_time
						content.hold_progress = progress

						return
					else
						content.current_timer = 0
						content.hold_progress = 0

						if not content.keep_hold_active then
							content.hold_active = false
						end

						if hotspot.on_complete_sound then
							Managers.ui:play_2d_sound(hotspot.on_complete_sound)
						end

						if content.complete_function then
							content.complete_function()
						end

						return
					end
				elseif not content.hold_active and content.current_timer and content.current_timer > 0 or hotspot.disabled then
					if hotspot.hold_release and content.hold_progress and content.hold_progress > 0 then
						Managers.ui:play_2d_sound(hotspot.hold_release)
					end

					content.current_timer = 0
					content.hold_progress = 0
				end
			end,
		},
	},
	init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
		local content = widget.content
		local style = widget.style

		if element.icon then
			content.icon.material_values.icon = element.icon
		end

		content.title = element.title or content.title
		content.sub_title = element.sub_title or content.sub_title
		content.description = element.description or content.description
		content.is_choice = element.is_choice
		content.is_family = element.is_family
		content.hotspot.disabled = not element.is_choice

		local input_action = parent._using_cursor_navigation and "left_hold" or "confirm_hold"

		content.confirm_text = Text.localize_with_button_hint(input_action, "loc_select", nil, nil, Localize("loc_input_legend_text_template"), true)

		if content.is_family then
			style.icon.material_values.frame = "content/ui/textures/frames/horde/circle_frame_horde"
			style.icon.material_values.icon_mask = "content/ui/textures/frames/horde/circle_frame_horde_mask"
			style.icon_glow.material_values.texture_map = "content/ui/textures/frames/horde/circle_frame_horde_glow"
			style.icon_glow.offset[2] = -84
			style.icon_glow.size = {
				190,
				172,
			}
			style.icon_selected.material_values.texture_map = "content/ui/textures/frames/horde/circle_frame_horde_selected"
			style.icon_selected.offset[2] = -60
			style.icon_selected.size = {
				122,
				122,
			}
			style.icon.offset[2] = -70

			if element.is_first then
				style.top.material_values.texture_map = "content/ui/textures/frames/horde/horde_buff_family_left"
				style.top.size = {
					486,
					206,
				}
				style.top.offset[1] = -5
				style.top.offset[2] = -75
			elseif element.is_last then
				style.top.material_values.texture_map = "content/ui/textures/frames/horde/horde_buff_family_right"
				style.top.size = {
					486,
					206,
				}
				style.top.offset[1] = 5
				style.top.offset[2] = -75
			else
				style.top.material_values.texture_map = "content/ui/textures/frames/horde/horde_buff_family_mid"
				style.top.size = {
					480,
					86,
				}
				style.top.offset[2] = -40
			end
		elseif element.is_choice then
			style.top.material_values.texture_map = "content/ui/textures/frames/horde/horde_buff_boon_selected"
			style.top.size = {
				480,
				60,
			}
			style.top.offset[2] = -20
		end

		if element.buff_icon_texture then
			style.icon.material_values.icon = element.buff_icon_texture
		end

		if element.buff_icon_gradient_map then
			style.icon.material_values.gradient_map = element.buff_icon_gradient_map
		end

		style.icon.material_values.use_gradient = element.buff_icon_use_gradient and 1 or 0

		if content.is_choice and not content.hotspot.disabled then
			content.start_delay = 0.1
			content.timer = 0.5
			content.current_timer = 0
			content.hold_progress = 0
			content.complete_function = callback_name and callback(parent, callback_name, widget, element)
		end

		if element.sub_buff then
			content.has_sub_buff = true
			content.sub_buff_title = element.sub_buff.title or content.sub_buff_title
			content.sub_buff_sub_title = element.sub_buff.sub_title or content.sub_buff_sub_title
			content.sub_buff_description = element.sub_buff.description or content.sub_buff_description

			if element.sub_buff.buff_icon_texture then
				style.sub_buff_icon.material_values.icon = element.sub_buff.buff_icon_texture
			end

			if element.sub_buff.buff_icon_gradient_map then
				style.sub_buff_icon.material_values.gradient_map = element.sub_buff.buff_icon_gradient_map
			end

			widget.content.size[2] = widget.content.size[2] + 250
		end
	end,
}

return blueprints
