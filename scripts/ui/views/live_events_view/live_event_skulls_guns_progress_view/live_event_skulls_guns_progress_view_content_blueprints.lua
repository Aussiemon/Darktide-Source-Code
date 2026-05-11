-- chunkname: @scripts/ui/views/live_events_view/live_event_skulls_guns_progress_view/live_event_skulls_guns_progress_view_content_blueprints.lua

local ColorUtilities = require("scripts/utilities/ui/colors")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local WalletSettings = require("scripts/settings/wallet_settings")
local TextUtils = require("scripts/utilities/ui/text")
local _size_multiplier = 0.525
local _button_size = {
	432 * _size_multiplier,
	728 * _size_multiplier,
}
local _preview_size = {
	432 * _size_multiplier,
	728 * _size_multiplier,
}
local button_background_glow = {
	pass_type = "texture",
	style_id = "glow",
	value = "content/ui/materials/base/ui_default_base",
	value_id = "glow",
	style = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		material_values = {
			texture_map = "content/ui/textures/live_events/skulls_guns/live_event_skulls_guns_button_frame_glow",
		},
		default_color = Color.terminal_corner_selected(0, true),
		hover_color = Color.terminal_corner_selected(128, true),
		color = Color.terminal_corner_selected(0, true),
		size = _button_size,
		size_addition = {
			5,
			5,
		},
	},
	change_function = function (content, style)
		local hotspot = content.hotspot

		if not hotspot.anim_focus_progress then
			return
		end

		local progress = math.max(math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress), hotspot.anim_input_progress), hotspot.anim_select_progress)

		ColorUtilities.color_lerp(style.default_color, style.hover_color, progress, style.color)
	end,
}
local button_background_pass = {
	pass_type = "texture",
	style_id = "background",
	value = "content/ui/materials/buttons/mastery_tree/pattern_trait_node_container_v2",
	value_id = "background",
	style = {
		horizontal_alignment = "center",
		scale_to_material = true,
		vertical_alignment = "center",
		material_values = {
			bg_intensity = 1,
			frame_intensity = 1,
			frame_tier = "content/ui/textures/live_events/skulls_guns/live_event_skulls_guns_metal_frame_locked",
			icon = nil,
			icon_texture = "content/ui/textures/live_events/skulls_guns/live_event_skulls_guns_metal_frame",
		},
		size = _button_size,
	},
	change_function = function (content, style)
		local hotspot = content.hotspot
		local default_frame_intensity = 1
		local hover_intensity = 1.5

		if content.element.data_entry.locked then
			style.material_values.bg_intensity = 0.5
			default_frame_intensity = 0.5
			hover_intensity = 0.75
		end

		local progress = math.max(math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress), hotspot.anim_input_progress), hotspot.anim_select_progress)

		style.material_values.frame_intensity = math.lerp(default_frame_intensity, hover_intensity, progress)
	end,
}
local hotspot_pass = {
	content_id = "hotspot",
	pass_type = "hotspot",
	content = {
		on_hover_sound = UISoundEvents.default_mouse_hover,
		on_pressed_sound = UISoundEvents.default_button_pressed,
	},
}
local button_preview_image_pass = {
	pass_type = "texture_uv",
	style_id = "preview_image",
	value = "content/ui/materials/live_events/skulls_guns/live_event_skulls_guns_button_thumbnail_flipbook",
	value_id = "preview_image",
	style = {
		horizontal_alignment = "center",
		scale_to_material = false,
		vertical_alignment = "center",
		size = _button_size,
		color = Color.white(255, true),
		offset = {
			0,
			0,
			1,
		},
		material_values = {
			fps = 0,
			texture_map = nil,
		},
		uvs = {
			{
				0,
				0,
			},
			{
				1,
				1,
			},
		},
	},
	visibility_function = function (content, style)
		return not not style.material_values.texture_map
	end,
}
local loading_icon_pass = {
	pass_type = "rotated_texture",
	style_id = "loading",
	value = "content/ui/materials/loading/loading_small",
	style = {
		angle = 0,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		size = _preview_size,
		color = {
			60,
			160,
			160,
			160,
		},
		offset = {
			0,
			20,
			1,
		},
	},
	visibility_function = function (content, style)
		return not content._is_preview_image_loaded and not content.element.data_entry.locked
	end,
	change_function = function (content, style, _, dt)
		local add = -0.5 * dt

		style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
		style.angle = style.rotation_progress * math.pi * 2
	end,
}
local unread_entry_pass = {
	pass_type = "rotated_texture",
	style_id = "claim_glow",
	value = "content/ui/materials/effects/premium_store/circular_glow",
	style = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		offset = {
			0,
			-10,
			3,
		},
		color = {
			218,
			255,
			218,
			137,
		},
		size = {
			500,
			500,
		},
	},
	change_function = function (content, style, _, dt)
		local add = -0.5 * dt

		style.rotation_progress = ((style.rotation_progress or 0) + add) % 1
		style.angle = style.rotation_progress * math.pi * 2
	end,
	visibility_function = function (content, style)
		return content._is_preview_image_loaded and (not content.element.data_entry.mail_read or not content.element.data_entry.reward_claimed)
	end,
}
local _progress_bar_size = {
	_button_size[1] * 0.825,
	20,
}
local _progress_bar_offset = {
	20,
	-65,
}

local function _progress_bar_visibility_function(content, style)
	if not content.element.data_entry.locked then
		return false
	end

	if content.element.data_entry.first_locked_idx ~= content.element.data_entry.idx then
		return false
	end

	return true
end

local button_progress_passes = {
	{
		pass_type = "texture",
		style_id = "bar_background",
		value = "content/ui/materials/backgrounds/default_square",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = {
				_progress_bar_size[1],
				_progress_bar_size[2],
			},
			offset = {
				_progress_bar_offset[1],
				_progress_bar_offset[2],
				3,
			},
			color = Color.terminal_background_dark(255, true),
		},
		visibility_function = _progress_bar_visibility_function,
	},
	{
		pass_type = "texture",
		style_id = "bar_frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = {
				_progress_bar_size[1],
				_progress_bar_size[2],
			},
			offset = {
				_progress_bar_offset[1],
				_progress_bar_offset[2],
				5,
			},
			color = Color.terminal_frame(nil, true),
			default_color = Color.terminal_frame(nil, true),
			selected_color = Color.terminal_frame_selected(nil, true),
			disabled_color = Color.ui_grey_medium(255, true),
			hover_color = Color.terminal_frame_hover(nil, true),
		},
		visibility_function = _progress_bar_visibility_function,
		change_function = ButtonPassTemplates.terminal_button_change_function,
	},
	{
		pass_type = "texture",
		style_id = "bar",
		value = "content/ui/materials/live_events/skulls_guns/live_event_skulls_guns_progress_bar_fill",
		style = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = {
				_progress_bar_size[1] * 0.33,
				_progress_bar_size[2],
			},
			default_size = {
				_progress_bar_size[1],
				_progress_bar_size[2],
			},
			offset = {
				_progress_bar_offset[1],
				_progress_bar_offset[2],
				4,
			},
			color = Color.terminal_text_body(255, true),
		},
		visibility_function = _progress_bar_visibility_function,
	},
	{
		pass_type = "text",
		style_id = "bar_values_text",
		value = "M MMM MMM / M MMM MMM",
		value_id = "bar_values_text",
		style = {
			drop_shadow = true,
			font_size = 14,
			font_type = "mono_tide_medium",
			horizontal_alignment = "left",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "bottom",
			vertical_alignment = "bottom",
			offset = {
				_progress_bar_offset[1] - 57,
				_progress_bar_offset[2] + 30,
				3,
			},
			size = {
				300,
				24,
			},
			text_color = Color.terminal_text_body(255, true),
		},
		visibility_function = _progress_bar_visibility_function,
	},
}

local function _currency_visibility_function(content, style)
	local is_next = content.element.data_entry.first_locked_idx == content.element.data_entry.idx

	if content.element.data_entry.locked then
		if is_next then
			return true
		end

		return false
	end

	if content.element.data_entry.reward_claimed then
		return false
	end

	return true
end

local unclaimed_currency_passes = {
	{
		pass_type = "texture",
		style_id = "currency_icon",
		value_id = "currency_icon",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				104,
				88,
			},
			offset = {
				0,
				-30,
				3,
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
		visibility_function = _currency_visibility_function,
	},
	{
		pass_type = "text",
		style_id = "currency_amount",
		value_id = "currency_amount",
		style = {
			drop_shadow = true,
			font_size = 28,
			font_type = "mono_tide_bold",
			horizontal_alignment = "center",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			vertical_alignment = "center",
			offset = {
				0,
				30,
				3,
			},
			size = {
				300,
				24,
			},
			text_color = Color.terminal_text_body(255, true),
		},
		visibility_function = _currency_visibility_function,
	},
}
local _fake_screen_size = {
	195,
	68,
}
local _fake_screen_offset = {
	0,
	-27,
	1,
}
local button_fake_screen_passes = {
	{
		pass_type = "texture",
		value = "content/ui/materials/backgrounds/terminal_basic",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			color = Color.terminal_grid_background(255, true),
			size = _fake_screen_size,
			offset = _fake_screen_offset,
		},
		visibility_function = _progress_bar_visibility_function,
	},
	{
		pass_type = "texture",
		style_id = "missing_data_base",
		value = "content/ui/materials/live_events/skulls_guns/ui_missing_data_distorted",
		value_id = "missing_data_base",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			offset = _fake_screen_offset,
			size = _fake_screen_size,
			color = Color.ui_hud_green_light(255, true),
		},
		visibility_function = _progress_bar_visibility_function,
	},
	{
		pass_type = "texture",
		style_id = "missing_data_noise",
		value = "content/ui/materials/backgrounds/scanner/scanner_noise",
		value_id = "missing_data_noise",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			offset = _fake_screen_offset,
			size = _fake_screen_size,
			color = Color.ui_hud_green_light(63.75, true),
		},
		visibility_function = _progress_bar_visibility_function,
	},
}
local blueprints = {
	button = {
		pass_template_function = function (self, config, ui_renderer)
			local passes = {
				hotspot_pass,
				button_background_glow,
				button_background_pass,
				loading_icon_pass,
				unread_entry_pass,
				button_preview_image_pass,
			}

			table.append(passes, button_progress_passes)
			table.append(passes, unclaimed_currency_passes)
			table.append(passes, button_fake_screen_passes)

			return passes
		end,
		size = _button_size,
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local content = widget.content

			content.element = element

			content.hotspot.pressed_callback = function ()
				element.callback(widget)
			end

			content._is_preview_image_loaded = false

			if element.data_entry.preview_image then
				element.parent_view:_fetch_image_data_async(element.data_entry.preview_image):next(function (texture_data)
					local style = widget.style.preview_image

					style.material_values.texture_map = texture_data.texture
					content._is_preview_image_loaded = true
				end)
			end

			local currency_reward

			for _, reward in pairs(element.data_entry.rewards) do
				if reward.type == "currency" then
					currency_reward = {
						currency = reward.currency,
						amount = reward.amount,
					}

					break
				end
			end

			if currency_reward then
				local currency_settings = WalletSettings[currency_reward.currency]

				content.currency_icon = currency_settings and currency_settings.icon_texture_big
				content.currency_amount = currency_reward.amount
			end
		end,
		update = function (self, widget, input_service, dt, t, ui_renderer, template)
			local content = widget.content
			local element = content.element

			if element.data_entry.idx > element.column_count then
				widget.offset = {
					widget.default_offset[1] + _button_size[1] * 0.5 + 15,
					widget.default_offset[2] - 15,
					widget.default_offset[3],
				}
			else
				widget.offset = {
					widget.default_offset[1],
					widget.default_offset[2],
					widget.default_offset[3],
				}
			end

			if element.data_entry.stat_required then
				local current_interpolated_stat = element.parent_view:get_interpolated_stat(t)
				local p = current_interpolated_stat / (element.data_entry.stat_required > 0 and element.data_entry.stat_required or current_interpolated_stat)

				widget.content.bar_values_text = string.format("%s / %s", TextUtils.format_currency(current_interpolated_stat), TextUtils.format_currency(element.data_entry.stat_required))
				widget.style.bar.size[1] = math.clamp(widget.style.bar.default_size[1] * p, 0, widget.style.bar.default_size[1])
			end

			if content.hotspot.is_selected or content.hotspot.cursor_hover then
				widget.style.preview_image.material_values.fps = 4
			elseif not content.hotspot.is_selected and not content.hotspot.cursor_hover then
				widget.style.preview_image.material_values.fps = 0
			end
		end,
		destroy = function (self, widget, element, ui_renderer)
			return
		end,
	},
}

return blueprints
