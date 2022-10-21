local ViewSettings = require("scripts/ui/views/end_player_view/end_player_view_settings")
local ViewStyles = require("scripts/ui/views/end_player_view/end_player_view_styles")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local _math_floor = math.floor
local _math_max = math.max
local _math_ilerp = math.ilerp
local _math_lerp = math.lerp
local _math_ease_sine = math.ease_sine
local _math_ease_cubic = math.easeCubic
local _math_ease_in_cubic = math.easeInCubic
local _math_ease_out_cubic = math.easeOutCubic
local _math_ease_out_elastic = math.ease_out_elastic
local _math_ease_quad = math.ease_quad
local _color_utils_color_lerp = ColorUtilities.color_lerp
local _color_utils_color_copy = ColorUtilities.color_copy
local animations = {}

animations.carousel_state_slide_cards_to_the_left = function (parent, state_data, card_widgets, current_card, t)
	local math_ilerp = _math_ilerp
	local math_lerp = _math_lerp
	local math_ease_sine = _math_ease_sine
	local math_ease_out_cubic = _math_ease_out_cubic
	local color_utils_color_lerp = _color_utils_color_lerp
	local start_time = state_data.start_time
	local end_time = state_data.end_time
	local retract_duration = state_data.retract_duration
	local progress = math_ilerp(start_time, end_time, t)
	local color_progress = math_ease_out_cubic(progress)
	local card_distance_x = ViewStyles.card_offset_x

	if t == start_time then
		parent:play_sound(state_data.sound_event)

		if current_card > 1 then
			parent:play_sound(state_data.sound_event_on_retract)

			local previous_card_widget = card_widgets[current_card - 1]
			local animation_name = previous_card_widget.content.dim_out_animation
			state_data.animation_id = parent:start_card_animation(previous_card_widget, animation_name)
		end
	elseif state_data.animation_id and parent:is_animation_done(state_data.animation_id) then
		state_data.animation_id = nil
	end

	local card_offset_x = card_distance_x * math_ease_sine(1 - progress)

	for i = 1, #card_widgets do
		local widget = card_widgets[i]
		local widget_offset = widget.offset
		local x_offset = (i - current_card) * card_distance_x + card_offset_x
		widget_offset[1] = x_offset

		if i == current_card - 1 then
			local widget_style = widget.style
			local dimmed_out_color = widget_style.dimmed_out_color
			local dimmed_out_gradiented_text_color = widget_style.dimmed_out_gradiented_text_color
			local in_focus_color = widget_style.in_focus_color
			local frame_color = widget_style.levelup_frame_color or widget_style.frame_color

			color_utils_color_lerp(in_focus_color, dimmed_out_color, color_progress, frame_color)
			color_utils_color_lerp(in_focus_color, dimmed_out_gradiented_text_color, color_progress, widget_style.label.text_color)

			local retract_progress = math_ilerp(start_time, start_time + retract_duration, t)
			local eased_progress = math_ease_sine(retract_progress)
			local y_offset = math_lerp(ViewStyles.card_fully_expanded_offset_y, 0, eased_progress)
			widget_offset[2] = y_offset
			local height = math_lerp(ViewStyles.card_fully_expanded_height, ViewStyles.card_normal_height, eased_progress)
			widget.content.size[2] = height
		elseif i == current_card then
			widget.alpha_multiplier = color_progress
		end
	end

	return progress == 1
end

animations.carousel_state_expand_current_card = function (parent, state_data, card_widgets, current_card, t)
	local color_utils_color_lerp = _color_utils_color_lerp
	local math_ease_in_cubic = _math_ease_in_cubic
	local math_lerp = _math_lerp
	local card_widget = card_widgets[current_card]
	local progress = _math_ease_sine(math.ilerp(state_data.start_time, state_data.end_time, t))
	card_widget.offset[2] = ViewStyles.card_fully_expanded_offset_y * progress
	local widget_size = card_widget.content.size
	local widget_style = card_widget.style
	widget_size[2] = math_lerp(widget_style.card_folded_height, widget_style.card_fully_expanded_height, progress)
	local start_color = widget_style.start_color
	local dimmed_out_color = widget_style.dimmed_out_color
	local in_focus_color = widget_style.in_focus_color
	local color_progress = math_ease_in_cubic(progress)

	color_utils_color_lerp(dimmed_out_color, in_focus_color, color_progress, widget_style.frame_color)
	color_utils_color_lerp(start_color, in_focus_color, color_progress, widget_style.label.text_color)

	local levelup_frame_color = widget_style.levelup_frame_color

	if levelup_frame_color then
		color_utils_color_lerp(start_color, in_focus_color, progress, levelup_frame_color)
		color_utils_color_lerp(start_color, in_focus_color, color_progress, widget_style.frame_levelup_effect.color)

		local spires_style = widget_style.spires
		spires_style.offset[2] = math_lerp(spires_style.start_offset_y, spires_style.target_offset_y, color_progress)
		local frame_detail_progress = _math_ease_sine(2 * progress)
		local frame_detail_layer = progress < 0.5 and 2 or 5
		local frame_detail_style = widget_style.frame_detail
		local frame_detail_offset = frame_detail_style.offset
		frame_detail_offset[2] = math_lerp(frame_detail_style.start_offset_y, frame_detail_style.target_offset_y, frame_detail_progress)
		frame_detail_offset[3] = frame_detail_layer
	end

	if t == state_data.start_time then
		local sound_event = widget_style.expand_sound

		parent:play_sound(sound_event)

		state_data.sound_event = sound_event
	end

	return progress == 1
end

animations.carousel_state_fade_in_card_content = function (parent, state_data, card_widgets, current_card, t)
	local card_widget = card_widgets[current_card]
	local animation_id = state_data.animation_id
	local is_done = animation_id and parent:is_animation_done(animation_id) or state_data.animation_done

	if not animation_id and not is_done then
		local animation_name = card_widget.content.content_animation
		state_data.animation_id = parent:start_card_animation(card_widget, animation_name)
	elseif is_done then
		state_data.animation_id = nil
		state_data.animation_done = true
	end

	return is_done
end

animations.carousel_state_show_card_content = function (parent, state_data, card_widgets, current_card, t)
	return state_data.end_time <= t
end

local _text_fade_in_time = ViewSettings.animation_times.text_row_fade_in_time

local function _create_icon_animation(animation_table, icons)
	local _passes_to_dim = animation_table._passes_to_dim or {}
	local _passes_to_hide = animation_table._passes_to_hide or {}
	local _icon_styles = {}
	animation_table[#animation_table + 1] = {
		name = "fade_in_icons",
		end_time = 0.1,
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local widget_style = widget.style
			local icon_styles = _icon_styles

			for i = 1, #icons, 2 do
				local icon_id = icons[i] .. "_icon"
				local icon_style = widget_style[icon_id]
				icon_styles[#icon_styles + 1] = icon_style
			end

			params.icon_styles = icon_styles
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local widget_style = widget.style
			local start_color = widget_style.start_color
			local dimmed_out_color = widget_style.default_frame_dimmed_out_color
			local icon_styles = params.icon_styles
			local eased_progress = _math_ease_out_cubic(progress)

			for i = 1, #icon_styles do
				local icon_style = icon_styles[i]

				_color_utils_color_lerp(start_color, dimmed_out_color, eased_progress, icon_style.color)
			end
		end
	}

	for i = 1, #icons, 2 do
		local icon_id = icons[i] .. "_icon"
		local background_id = icon_id .. "_background"
		local start_time = icons[i + 1]
		animation_table[#animation_table + 1] = {
			start_time = start_time,
			end_time = start_time + _text_fade_in_time,
			name = "highlight_" .. icon_id,
			init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
				parent:play_sound(UISoundEvents.end_screen_summary_currency_icon_in)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
				local color_utils_color_lerp = _color_utils_color_lerp
				local math_lerp = _math_lerp
				local math_ease_out_elastic = _math_ease_out_elastic
				local math_ease_sine = _math_ease_sine
				local widget_style = widget.style
				local icon_style = widget_style[icon_id]
				local icon_bg_style = widget_style[background_id]
				local icon_bg_target_width = icon_bg_style.target_width
				local eased_progress = math_ease_out_elastic(progress)
				local background_width = math_lerp(icon_bg_style.start_width, icon_bg_target_width, eased_progress)
				local icon_bg_size = icon_bg_style.size
				icon_bg_size[1] = background_width
				icon_bg_size[2] = background_width
				local icon_offset = (icon_bg_target_width - background_width) / 2
				local icon_bg_offset = icon_bg_style.offset
				icon_bg_offset[2] = icon_offset
				local color_progress = math_ease_sine(progress)
				local dimmed_out_color = widget_style.dimmed_out_color
				local in_focus_color = widget_style.in_focus_color

				color_utils_color_lerp(dimmed_out_color, in_focus_color, color_progress, icon_style.color)
				color_utils_color_lerp(dimmed_out_color, in_focus_color, color_progress, icon_bg_style.color)

				if i > 2 then
					local previous_background_id = icons[i - 2] .. "_icon_background"
					local prev_icon_bg_style = widget_style[previous_background_id]

					color_utils_color_lerp(in_focus_color, dimmed_out_color, color_progress, prev_icon_bg_style.color)
				end
			end
		}
		_passes_to_dim[#_passes_to_dim + 1] = icon_id
		_passes_to_hide[#_passes_to_hide + 1] = background_id
	end

	animation_table._passes_to_dim = _passes_to_dim
	animation_table._passes_to_hide = _passes_to_hide
end

local function _create_count_up_animation(animation_table, value_name, value_group, start_time, end_time)
	local sound_events = ViewSettings.currency_sounds[value_group]
	animation_table[#animation_table + 1] = {
		start_time = start_time,
		end_time = start_time + _text_fade_in_time,
		name = "fade_in_" .. value_name,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			params.value_name = value_name
			local widget_style = widget.style
			params.target_color = widget.content[value_name] > 0 and widget_style.in_focus_text_color or widget_style.dimmed_out_text_color
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local color_utils_color_lerp = _color_utils_color_lerp
			local label_name = params._label_name
			local value_name = params.value_name

			if not label_name then
				label_name = value_name .. "_label"
				params._label_name = label_name
			end

			local widget_style = widget.style
			local start_color = widget_style.start_color
			local target_color = params.target_color
			local color_progress = _math_ease_sine(progress)

			color_utils_color_lerp(start_color, target_color, color_progress, widget_style[label_name].text_color)
			color_utils_color_lerp(start_color, target_color, color_progress, widget_style[value_name].text_color)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			params._label_name = nil
		end
	}
	animation_table[#animation_table + 1] = {
		start_time = animation_table[#animation_table].end_time,
		end_time = end_time,
		name = "count-up_side_" .. value_name,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			params.current_value = 0
			params.value_name = value_name
			params.value_text_name = value_name .. "_text"
			local previous_stat_name = value_name .. "_previous_value"
			local previous_stat_value = widget.content[previous_stat_name]
			params.previous_value = previous_stat_value

			if widget.content[value_name] > 0 then
				parent:play_sound(sound_events.start)
			else
				parent:play_sound(sound_events.zero)
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local eased_progress = progress < 0.5 and _math_ease_sine(progress) or _math_ease_cubic(progress)
			local value_name = params.value_name
			local value_text_name = params.value_text_name
			local content = widget.content
			local target_value = content[value_name]

			if target_value == 0 then
				return
			end

			local value = _math_floor(target_value * eased_progress)
			content[value_text_name] = value
			local update_progress_func = content.update_progress_func

			if update_progress_func then
				update_progress_func(value + params.previous_value, value_group)
			end

			parent:set_sound_parameter(sound_events.progress, eased_progress)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			params._value_text_name = nil
			local target_value = widget.content[value_name]

			if target_value > 0 then
				local update_progress_func = widget.content.update_progress_func

				if update_progress_func then
					update_progress_func(target_value + params.previous_value, value_group)
				end

				parent:play_sound(sound_events.stop)
			end
		end
	}

	if not animation_table._passes_to_dim then
		animation_table._passes_to_dim = {}
	end

	animation_table._passes_to_dim[#animation_table._passes_to_dim + 1] = value_name
end

local function _create_progress_bar_animation(animation_table, start_time, end_time)
	animation_table[#animation_table + 1] = {
		name = "fade_in_experience_gain_text",
		end_time = 0.1,
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			parent:update_xp_bar(0)
		end
	}
	animation_table[#animation_table + 1] = {
		name = "update_progress_bar",
		start_time = start_time + _text_fade_in_time,
		end_time = end_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			params.current_value = 0
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local content = widget.content
			local target_value = content.total_xp_gained
			local eased_progress = progress < 0.5 and _math_ease_sine(progress) or _math_ease_cubic(progress)
			local value = _math_floor(target_value * eased_progress)

			parent:update_xp_bar(value)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			params._value_text_name = nil
			local target_value = widget.content.total_xp_gained

			parent:update_xp_bar(target_value)
		end
	}
end

local function _create_consolidate_wallet_animation(animation_table, retract_start_time, update_start_time, end_time)
	animation_table[#animation_table + 1] = {
		name = "retract_currency_gain_widgets",
		start_time = retract_start_time,
		end_time = end_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			parent:trigger_currency_gain_widgets_timeout()
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local eased_progress = _math_ease_in_cubic(progress)

			parent:retract_currency_gain_widgets(eased_progress)
		end
	}
	animation_table[#animation_table + 1] = {
		name = "update_belated_wallet",
		start_time = update_start_time,
		end_time = end_time,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local eased_progress = _math_ease_sine(progress)

			parent:update_belated_wallet(eased_progress)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			parent:update_belated_wallet(1)
		end
	}
end

local function _create_fade_in_pass_animation(animation_table, style_name, start_time)
	animation_table[#animation_table + 1] = {
		start_time = start_time,
		end_time = start_time + _text_fade_in_time,
		name = "fade_in_" .. style_name,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local pass_params = {}
			local widget_style = widget.style
			local pass_style = widget_style[style_name]
			local pass_color = pass_style.text_color or pass_style.color
			pass_params.pass_color = pass_color
			pass_params.start_color = widget_style.start_color

			if pass_style.text_color and not pass_style.material then
				pass_params.target_color = widget_style.in_focus_text_color
			else
				pass_params.target_color = widget_style.in_focus_color
			end

			if not params.pass_params then
				params.pass_params = {}
			end

			params.pass_params[style_name] = pass_params

			if pass_style.sound_event_on_show then
				parent:play_sound(pass_style.sound_event_on_show)
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local color_utils_color_lerp = _color_utils_color_lerp
			local pass_params = params.pass_params[style_name]
			local pass_color = pass_params.pass_color
			local start_color = pass_params.start_color
			local target_color = pass_params.target_color
			local color_progress = _math_ease_sine(progress)

			color_utils_color_lerp(start_color, target_color, color_progress, pass_color)
		end
	}
	local passes_to_dim = animation_table._passes_to_dim

	if not passes_to_dim then
		passes_to_dim = {}
		animation_table._passes_to_dim = passes_to_dim
	end

	passes_to_dim[#passes_to_dim + 1] = style_name
end

local function _create_show_reward_item_animation(animation_table, start_time)
	_create_fade_in_pass_animation(animation_table, "item_display_name", start_time)
	_create_fade_in_pass_animation(animation_table, "item_icon", start_time + _text_fade_in_time)
	_create_fade_in_pass_animation(animation_table, "item_sub_display_name", start_time + 2 * _text_fade_in_time)
end

local function _create_show_talents_animation(animation_table, start_time)
	_create_fade_in_pass_animation(animation_table, "unlocked_talents_label", start_time)

	for i = 1, 3 do
		local alignment = i == 1 and "left" or i == 2 and "center" or "right"

		_create_fade_in_pass_animation(animation_table, "talent_icon_" .. alignment, start_time + 2 * _text_fade_in_time)
	end
end

local function _create_dim_out_animation(animation_table, show_content_animation_table)
	local passes_to_dim = show_content_animation_table._passes_to_dim or {}
	show_content_animation_table._passes_to_dim = nil
	local passes_to_hide = show_content_animation_table._passes_to_hide or {}
	show_content_animation_table._passes_to_hide = nil
	animation_table[#animation_table + 1] = {
		name = "fade_out",
		start_time = 0,
		end_time = ViewSettings.animation_times.card_fade_out_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local widget_content = widget.content
			local widget_style = widget.style
			local icon_backgrounds = {}
			local icon_colors = {}
			local text_colors = {}
			local gradiented_text_color = {}
			local text_color_index = 0

			for i = 1, #passes_to_dim do
				local value_id = passes_to_dim[i]
				local content_value = widget_content[value_id]
				local pass_style = widget_style[value_id]

				if type(content_value) == "number" then
					if content_value > 0 then
						text_colors[text_color_index + 1] = pass_style.text_color
						text_colors[text_color_index + 2] = widget_style[value_id .. "_label"].text_color
						text_color_index = text_color_index + 2
					end
				elseif pass_style.text_color and pass_style.material then
					gradiented_text_color[#gradiented_text_color + 1] = pass_style.text_color
				elseif pass_style.text_color then
					text_color_index = text_color_index + 1
					text_colors[text_color_index] = pass_style.text_color
				else
					icon_colors[#icon_colors + 1] = pass_style.color or pass_style.text_color
				end
			end

			for i = 1, #passes_to_hide do
				local value_id = passes_to_hide[i]
				icon_backgrounds[#icon_backgrounds + 1] = widget_style[value_id]
			end

			if #passes_to_hide > 0 then
				parent:play_sound(UISoundEvents.end_screen_summary_currency_icon_out)
			end

			params.text_colors = text_colors
			params.gradiented_text_color = gradiented_text_color
			params.icon_colors = icon_colors
			params.icon_backgrounds = icon_backgrounds
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local color_utils_color_lerp = _color_utils_color_lerp
			local widget_style = widget.style
			local in_focus_color = widget_style.in_focus_color
			local in_focus_text_color = widget_style.in_focus_text_color
			local dimmed_out_color = widget_style.dimmed_out_color
			local dimmed_out_text_color = widget_style.dimmed_out_text_color
			local dimmed_out_gradiented_text_color = widget_style.dimmed_out_gradiented_text_color
			local bg_target_color = widget_style.start_color
			local eased_progress = _math_ease_sine(progress)
			local text_colors = params.text_colors

			for i = 1, #text_colors do
				local ignore_alpha = true

				color_utils_color_lerp(in_focus_text_color, dimmed_out_text_color, eased_progress, text_colors[i], ignore_alpha)
			end

			local gradiented_text_color = params.gradiented_text_color

			for i = 1, #gradiented_text_color do
				local ignore_alpha = true

				color_utils_color_lerp(in_focus_color, dimmed_out_gradiented_text_color, eased_progress, gradiented_text_color[i], ignore_alpha)
			end

			local icon_colors = params.icon_colors
			local num_icons = #icon_colors

			for i = 1, num_icons do
				color_utils_color_lerp(in_focus_color, dimmed_out_color, eased_progress, icon_colors[i])
			end

			local icon_backgrounds = params.icon_backgrounds
			local num_bg_icons = #icon_backgrounds

			for i = 1, num_bg_icons do
				local icon_bg_style = icon_backgrounds[i]
				local icon_bg_target_width = icon_bg_style.target_width
				local background_width = _math_lerp(icon_bg_target_width, icon_bg_style.start_width, eased_progress)
				local icon_bg_size = icon_bg_style.size
				icon_bg_size[1] = background_width
				icon_bg_size[2] = background_width
				local icon_offset = (icon_bg_target_width - background_width) / 2
				local icon_bg_offset = icon_bg_style.offset
				icon_bg_offset[2] = icon_offset
				local bg_start_color = i == num_icons and in_focus_color or dimmed_out_color

				color_utils_color_lerp(bg_start_color, bg_target_color, eased_progress, icon_bg_style.color)
			end
		end
	}
end

local function _create_compress_content_animation(animation_table, include_talents)
	animation_table[#animation_table + 1] = {
		name = "compress_icons",
		start_time = 0,
		end_time = ViewSettings.animation_times.card_compress_content_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local widget_style = widget.style
			local item_icon_style = widget_style.item_icon
			local item_sub_display_name = widget_style.item_sub_display_name
			local unlocked_talents_label = widget_style.unlocked_talents_label
			local talent_icon_left_style = widget_style.talent_icon_left
			local talent_icon_center_style = widget_style.talent_icon_center
			local talent_icon_right_style = widget_style.talent_icon_right
			local styles_to_compress, original_icon_sizes = nil

			if include_talents then
				styles_to_compress = {
					item_icon_style,
					talent_icon_left_style,
					talent_icon_center_style,
					talent_icon_right_style
				}
				original_icon_sizes = {
					item_icon_style.size[1],
					item_icon_style.size[2],
					talent_icon_left_style.size[1],
					talent_icon_left_style.size[2],
					talent_icon_center_style.size[1],
					talent_icon_center_style.size[2],
					talent_icon_right_style.size[1],
					talent_icon_right_style.size[2]
				}
			else
				styles_to_compress = {
					item_icon_style
				}
				original_icon_sizes = {
					item_icon_style.size[1],
					item_icon_style.size[2]
				}
			end

			local styles_to_move = {}
			local index = 0

			for style_id, style in pairs(widget.style) do
				if type(style) == "table" and style.offset_compressed then
					index = index + 1
					styles_to_move[index] = style
				end
			end

			params.styles_to_compress = styles_to_compress
			params.original_icon_sizes = original_icon_sizes
			params.styles_to_move = styles_to_move
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local math_floor = _math_floor
			local math_lerp = _math_lerp
			local eased_progress = _math_ease_sine(progress)
			local styles_to_compress = params.styles_to_compress
			local original_icon_sizes = params.original_icon_sizes

			for i = 1, #styles_to_compress do
				local style = styles_to_compress[i]
				local icon_size = style.size
				local icon_start_width = original_icon_sizes[(i - 1) * 2 + 1]
				local icon_start_height = original_icon_sizes[(i - 1) * 2 + 2]
				local icon_target_width = math_floor(icon_start_width / 2)
				local icon_target_height = math_floor(icon_start_height / 2)
				icon_size[1] = math_lerp(icon_start_width, icon_target_width, eased_progress)
				icon_size[2] = math_lerp(icon_start_height, icon_target_height, eased_progress)
			end

			local styles_to_move = params.styles_to_move

			for i = 1, #styles_to_move do
				local style = styles_to_move[i]
				local offset_original = style.offset_original
				local offset_compressed = style.offset_compressed
				style.offset[1] = math_lerp(offset_original[1], offset_compressed[1], eased_progress)
				style.offset[2] = math_lerp(offset_original[2], offset_compressed[2], eased_progress)
			end
		end
	}
end

animations.experience_card_show_content = {}
animations.experience_card_dim_out_content = {}

_create_icon_animation(animations.experience_card_show_content, {
	"experience",
	0.25
})
_create_count_up_animation(animations.experience_card_show_content, "base_xp", "experience", 0.25, 3)
_create_count_up_animation(animations.experience_card_show_content, "side_mission_xp", "experience", 3.25, 4)
_create_count_up_animation(animations.experience_card_show_content, "circumstance_xp", "experience", 4.25, 5)
_create_count_up_animation(animations.experience_card_show_content, "side_mission_bonus_xp", "experience", 5.25, 6)
_create_count_up_animation(animations.experience_card_show_content, "total_bonus_xp", "experience", 6.25, 7)
_create_progress_bar_animation(animations.experience_card_show_content, 0.25, 7)
_create_dim_out_animation(animations.experience_card_dim_out_content, animations.experience_card_show_content)

animations.salary_card_show_content = {}
animations.salary_card_dim_out_content = {}

_create_icon_animation(animations.salary_card_show_content, {
	"credits",
	0.25,
	"plasteel",
	4.25,
	"diamantine",
	5.25
})
_create_count_up_animation(animations.salary_card_show_content, "credits", "credits", 0.25, 2)
_create_count_up_animation(animations.salary_card_show_content, "side_mission_credits", "credits", 2.25, 3)
_create_count_up_animation(animations.salary_card_show_content, "circumstance_credits", "credits", 3.25, 4)
_create_count_up_animation(animations.salary_card_show_content, "plasteel", "plasteel", 4.25, 5)
_create_count_up_animation(animations.salary_card_show_content, "diamantine", "diamantine", 5.25, 6)
_create_count_up_animation(animations.salary_card_show_content, "diamantine", "diamantine", 5.25, 6)
_create_consolidate_wallet_animation(animations.salary_card_show_content, 6, 6.25, 7.25)
_create_dim_out_animation(animations.salary_card_dim_out_content, animations.salary_card_show_content)

animations.level_up_show_content = {}
animations.level_up_dim_out_content = {}

_create_show_reward_item_animation(animations.level_up_show_content, 0.25)
_create_dim_out_animation(animations.level_up_dim_out_content, animations.level_up_show_content)

animations.level_up_show_content_with_talents = {}
animations.level_up_dim_out_content_with_talents = {}

_create_show_reward_item_animation(animations.level_up_show_content_with_talents, 0.25)
_create_show_talents_animation(animations.level_up_show_content_with_talents, 0.65)
_create_compress_content_animation(animations.level_up_dim_out_content_with_talents, true)
_create_dim_out_animation(animations.level_up_dim_out_content_with_talents, animations.level_up_show_content_with_talents)

animations.item_reward_show_content = {}
animations.item_reward_dim_out_content = {}

_create_show_reward_item_animation(animations.item_reward_show_content, 0.25)
_create_compress_content_animation(animations.item_reward_dim_out_content)
_create_dim_out_animation(animations.item_reward_dim_out_content, animations.item_reward_show_content)

animations.unlocked_talents_show_content = {}
animations.unlocked_talents_dim_out_content = {}

_create_show_talents_animation(animations.unlocked_talents_show_content, 0.25)
_create_dim_out_animation(animations.unlocked_talents_dim_out_content, animations.unlocked_talents_show_content)

animations.test = {
	{
		name = "test",
		end_time = 1,
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			return
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			return
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			return
		end
	}
}

animations.wallet_change_function = function (content, style, animation, dt)
	local anim_progress = content._anim_progress

	if content.text ~= content._last_frame_text then
		anim_progress = 0
		content._last_frame_text = content.text
	end

	if anim_progress then
		anim_progress = math.min(anim_progress + dt / style.animation_time, 1)
		style.font_size = math.lerp(style.highlighted_size, style.default_size, anim_progress)

		ColorUtilities.color_lerp(style.highlighted_color, style.default_color, anim_progress, style.text_color)

		if anim_progress < 1 then
			content._anim_progress = anim_progress
		else
			content._anim_progress = nil
		end
	end
end

animations.experience_gain_change_function = function (content, style)
	local progress = content.progress
	local bar_length = content.bar_length
	local width = style.size[1]
	local internal_offset_x = style.internal_offset_x
	style.offset[1] = internal_offset_x + bar_length * progress - width
end

return settings("EndPlayerViewAnimations", animations)
