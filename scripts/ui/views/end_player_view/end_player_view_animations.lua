-- chunkname: @scripts/ui/views/end_player_view/end_player_view_animations.lua

local ColorUtilities = require("scripts/utilities/ui/colors")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewSettings = require("scripts/ui/views/end_player_view/end_player_view_settings")
local ViewStyles = require("scripts/ui/views/end_player_view/end_player_view_styles")
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
	return t >= state_data.end_time
end

local _text_fade_in_time = ViewSettings.animation_times.text_row_fade_in_time

local function _create_icon_animation(animation_table, icons)
	local _passes_to_dim = animation_table._passes_to_dim or {}
	local _passes_to_hide = animation_table._passes_to_hide or {}
	local _icon_styles = {}

	animation_table[#animation_table + 1] = {
		end_time = 0.1,
		name = "fade_in_icons",
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
		end,
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
			end,
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
			local content = widget.content
			local content_value = content[value_name] or 0

			params.target_color = content_value > 0 and widget_style.in_focus_text_color or widget_style.dimmed_out_text_color
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
		end,
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
		end,
	}

	if not animation_table._passes_to_dim then
		animation_table._passes_to_dim = {}
	end

	animation_table._passes_to_dim[#animation_table._passes_to_dim + 1] = value_name
end

local function _create_progress_bar_animation(animation_table, start_time, end_time)
	animation_table[#animation_table + 1] = {
		end_time = 0.1,
		name = "fade_in_experience_gain_text",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			parent:update_xp_bar(0)
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "update_progress_bar",
		start_time = start_time + _text_fade_in_time,
		end_time = end_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			params.current_value = 0

			parent:play_sound(UISoundEvents.end_screen_summary_xp_bar_start)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local content = widget.content
			local target_value = content.total_xp_gained
			local eased_progress = progress < 0.5 and _math_ease_sine(progress) or _math_ease_cubic(progress)
			local value = _math_floor(target_value * eased_progress)

			parent:update_xp_bar(value)
			parent:set_sound_parameter(UISoundEvents.end_screen_summary_xp_bar_progress, eased_progress)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			params._value_text_name = nil

			local target_value = widget.content.total_xp_gained

			parent:update_xp_bar(target_value)
			parent:play_sound(UISoundEvents.end_screen_summary_xp_bar_stop)
		end,
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
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "update_belated_wallet",
		start_time = update_start_time,
		end_time = end_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			parent:play_sound(UISoundEvents.end_screen_summary_currency_summation)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local eased_progress = _math_ease_sine(progress)

			parent:update_belated_wallet(eased_progress)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			parent:update_belated_wallet(1)
		end,
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

			if not pass_style then
				return
			end

			local pass_color = pass_style.text_color or pass_style.color

			pass_params.pass_color = pass_color
			pass_params.start_color = pass_style.start_color or widget_style.start_color

			if pass_style.text_color and not pass_style.material then
				pass_params.target_color = pass_style.in_focus_text_color or widget_style.in_focus_text_color
			else
				pass_params.target_color = pass_style.in_focus_color or widget_style.in_focus_color
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

			if not params.pass_params then
				return
			end

			local pass_params = params.pass_params[style_name]

			if not pass_params then
				return
			end

			local pass_color = pass_params.pass_color
			local start_color = pass_params.start_color
			local target_color = pass_params.target_color
			local color_progress = _math_ease_sine(progress)

			color_utils_color_lerp(start_color, target_color, color_progress, pass_color)
		end,
	}

	local passes_to_dim = animation_table._passes_to_dim

	if not passes_to_dim then
		passes_to_dim = {}
		animation_table._passes_to_dim = passes_to_dim
	end

	passes_to_dim[#passes_to_dim + 1] = style_name
end

local function _create_init_weapon_animation(animation_table, start_time)
	local slots = {
		"slot_primary",
		"slot_secondary",
	}

	start_time = start_time or 0

	local function added_time(time_added)
		start_time = start_time + time_added

		return start_time
	end

	local dafault_added_time = 0.03

	for f = 1, #slots do
		local slot = slots[f]

		_create_fade_in_pass_animation(animation_table, "weapon_title_" .. slot, added_time(0))
		_create_fade_in_pass_animation(animation_table, "weapon_level_" .. slot, added_time(dafault_added_time))
		_create_fade_in_pass_animation(animation_table, "weapon_icon_" .. slot, added_time(dafault_added_time))
		_create_fade_in_pass_animation(animation_table, "weapon_background_" .. slot, added_time(0))
		_create_fade_in_pass_animation(animation_table, "weapon_background_gradient_" .. slot, added_time(0))
		_create_fade_in_pass_animation(animation_table, "weapon_button_gradient_" .. slot, added_time(0))
		_create_fade_in_pass_animation(animation_table, "weapon_frame_" .. slot, added_time(0))
		_create_fade_in_pass_animation(animation_table, "weapon_corner_" .. slot, added_time(0))
		_create_fade_in_pass_animation(animation_table, "weapon_total_exp_" .. slot, added_time(dafault_added_time))
		_create_fade_in_pass_animation(animation_table, "weapon_experience_bar_" .. slot, added_time(dafault_added_time))
		_create_fade_in_pass_animation(animation_table, "weapon_experience_bar_background_" .. slot, added_time(0))
		_create_fade_in_pass_animation(animation_table, "weapon_experience_bar_line_" .. slot, added_time(0))
		_create_fade_in_pass_animation(animation_table, "weapon_added_exp_text_" .. slot, added_time(dafault_added_time))
	end
end

local function _create_progress_weapon_animation(animation_table, start_time, end_time)
	animation_table[#animation_table + 1] = {
		name = "update_weapon_bar",
		start_time = start_time + _text_fade_in_time,
		end_time = end_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			parent:play_sound(UISoundEvents.end_screen_summary_mastery_bar_start)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local content = widget.content
			local eased_progress = progress < 0.5 and _math_ease_sine(progress) or _math_ease_cubic(progress)
			local slots = {
				"slot_primary",
				"slot_secondary",
			}

			for f = 1, #slots do
				local slot = slots[f]
				local current_mastery_level_content = widget.content["weapon_current_mastery_level_" .. slot]
				local new_exp = widget.content["weapon_current_exp_level_" .. slot]
				local current_mastery_level = widget.content["weapon_current_mastery_level_" .. slot]
				local added_exp = widget.content["weapon_added_exp_" .. slot]
				local added_exp_progress = tonumber(added_exp) * eased_progress

				parent:update_weapon_values(added_exp_progress, slot, widget)
			end

			parent:set_sound_parameter(UISoundEvents.end_screen_summary_xp_bar_progress, eased_progress)
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			params._value_text_name = nil

			local slots = {
				"slot_primary",
				"slot_secondary",
			}

			for f = 1, #slots do
				local slot = slots[f]
				local added_exp = widget.content["weapon_added_exp_" .. slot]
				local added_exp_progress = tonumber(added_exp)

				parent:update_weapon_values(added_exp_progress, slot, widget)
			end

			parent:play_sound(UISoundEvents.end_screen_summary_mastery_bar_stop)
		end,
	}
end

local function _create_dim_weapon_animation(animation_table)
	animation_table[#animation_table + 1] = {
		name = "compress_weapon_mastery",
		start_time = 0,
		end_time = ViewSettings.animation_times.card_compress_content_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			if parent._levelup_mastery_animation_id then
				parent:_complete_animation(parent._levelup_mastery_animation_id)

				parent._levelup_mastery_animation_id = nil
			end

			local slots = {
				"slot_primary",
				"slot_secondary",
			}

			for f = 1, #slots do
				local slot = slots[f]

				widget.style["weapon_total_exp_" .. slot].text_color[1] = 0
				widget.style["weapon_added_exp_text_" .. slot].text_color[1] = 0
				widget.style["weapon_experience_bar_" .. slot].color[1] = 0
				widget.style["weapon_experience_bar_background_" .. slot].color[1] = 0
				widget.style["weapon_experience_bar_line_" .. slot].color[1] = 0
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local slots = {
				"slot_primary",
				"slot_secondary",
			}
			local current_alpha = 255 - 255 * progress
			local current_alpha_icon = 255 - 128 * progress

			for f = 1, #slots do
				local slot = slots[f]

				widget.style["weapon_title_" .. slot].text_color[1] = current_alpha_icon
				widget.style["weapon_level_" .. slot].text_color[1] = current_alpha_icon
				widget.style["weapon_frame_" .. slot].color[1] = current_alpha_icon
				widget.style["weapon_corner_" .. slot].color[1] = current_alpha_icon
				widget.style["weapon_icon_" .. slot].color[1] = current_alpha_icon
				widget.style["weapon_background_" .. slot].color[1] = current_alpha_icon
				widget.style["weapon_background_gradient_" .. slot].color[1] = current_alpha_icon
				widget.style["weapon_button_gradient_" .. slot].color[1] = current_alpha_icon
				widget.style["weapon_background_" .. slot].color[1] = current_alpha_icon
			end

			local added_offset = ViewStyles.card_fully_expanded_height * 0.5
			local start_offset = 0
			local target_offset = -80
			local current_offset = math.lerp(start_offset, target_offset, progress)
			local pass_names = {
				"title",
				"level",
				"frame",
				"corner",
				"icon",
				"background",
				"background_gradient",
				"button_gradient",
				"background",
			}

			for f = 1, #pass_names do
				local pass_name = pass_names[f]
				local name = "weapon_" .. pass_name .. "_slot_secondary"

				widget.style[name].offset[2] = widget.style[name].start_offset[2] + current_offset
			end
		end,
	}
end

local function get_havoc_positions(widget)
	local ids = {
		widget.content.order_reward_state and "order",
		widget.content.highest_rank and "highest",
		widget.content.week_rank and "week",
	}
	local positions = {}

	for index, id_name in pairs(ids) do
		if id_name then
			positions[#positions + 1] = id_name
		end
	end

	return positions
end

local function get_havoc_id_by_wanted_position(widget, position)
	local positions = get_havoc_positions(widget)

	return positions[position]
end

local function get_havoc_position_by_id(widget, id)
	local positions = get_havoc_positions(widget)

	for i = 1, #positions do
		local position_id = positions[i]

		if id == position_id then
			return i
		end
	end
end

local havoc_fade_in_passes_by_id = {
	order = {
		"havoc_rank_badge",
		"previous_havoc_rank_value_1",
		"previous_havoc_rank_value_2",
		"havoc_badge_background",
		"havoc_charge_1",
		"havoc_charge_2",
		"havoc_charge_3",
		"havoc_order_text",
	},
	highest = {
		"havoc_icon",
		"highest_havoc_rank",
		"highest_havoc_description",
	},
	week = {
		"havoc_week_description",
		"havoc_reward_week_icon_glow",
		"havoc_reward_week_icon",
		"week_havoc_icon",
		"week_havoc_rank",
	},
}
local havoc_fade_out_passes_by_id = {
	order = {
		"havoc_rank_badge",
		"previous_havoc_rank_value_1",
		"previous_havoc_rank_value_2",
		"current_havoc_rank_value_1",
		"current_havoc_rank_value_2",
		"havoc_badge_background",
		"havoc_charge_1",
		"havoc_charge_2",
		"havoc_charge_3",
		"havoc_order_text",
	},
	highest = {
		"havoc_icon",
		"highest_havoc_rank",
		"highest_havoc_description",
	},
	week = {
		"havoc_week_description",
		"havoc_reward_week_icon_glow",
		"havoc_reward_week_icon",
		"week_havoc_icon",
		"week_havoc_rank",
	},
}
local havoc_concat_passes_by_id = {
	order = {
		"havoc_rank_badge",
		"current_havoc_rank_value_1",
		"current_havoc_rank_value_2",
		"previous_havoc_rank_value_1",
		"previous_havoc_rank_value_2",
		"havoc_badge_background",
		"havoc_charge_1",
		"havoc_charge_2",
		"havoc_charge_3",
		"havoc_charge_ghost_1",
		"havoc_charge_ghost_2",
		"havoc_charge_ghost_3",
		"havoc_order_text",
	},
	highest = {
		"havoc_icon",
		"highest_havoc_rank",
		"highest_havoc_description",
	},
	week = {
		"havoc_week_description",
		"havoc_reward_week_icon_glow",
		"havoc_reward_week_icon",
		"week_havoc_icon",
		"week_havoc_rank",
	},
}

local function havoc_fade_in_init_by_id(id, widget, parent, params)
	local max_positions = table.size(havoc_concat_passes_by_id)
	local positions = get_havoc_positions(widget)
	local positions_size = #positions
	local id_position = get_havoc_position_by_id(widget, id)
	local lerp_from_positions = 1 - math.ilerp(1, max_positions, positions_size)

	if id == "order" or id == "highest" or id == "week" then
		local style_names = havoc_fade_in_passes_by_id[id]

		if style_names then
			for i = 1, #style_names do
				local style_name = style_names[i]
				local pass_params = {}
				local widget_style = widget.style
				local pass_style = widget_style[style_name]

				if pass_style then
					local pass_color = pass_style.text_color or pass_style.color

					pass_params.pass_color = pass_color
					pass_params.start_color = pass_style.start_color or widget_style.start_color

					if pass_style.text_color and not pass_style.material then
						pass_params.target_color = pass_style.in_focus_text_color or widget_style.in_focus_text_color
					else
						pass_params.target_color = pass_style.in_focus_color or widget_style.in_focus_color
					end

					if not params.pass_params then
						params.pass_params = {}
					end

					params.pass_params[style_name] = pass_params

					if pass_style.sound_event_on_show then
						parent:play_sound(pass_style.sound_event_on_show)
					end
				end
			end
		end
	end
end

local function havoc_fade_in_progress_by_id(id, widget, parent, params, progress)
	local color_utils_color_lerp = _color_utils_color_lerp

	if id == "order" or id == "highest" or id == "week" then
		local style_names = havoc_fade_in_passes_by_id[id]

		if style_names then
			for i = 1, #style_names do
				local style_name = style_names[i]
				local pass_params = params.pass_params[style_name]

				if pass_params then
					local pass_color = pass_params.pass_color
					local start_color = pass_params.start_color
					local target_color = pass_params.target_color
					local color_progress = _math_ease_sine(progress)

					color_utils_color_lerp(start_color, target_color, color_progress, pass_color)
				end
			end
		end
	end
end

local function havoc_fade_in_all_progress_by_id(id, widget, parent, params, progress)
	local color_utils_color_lerp = _color_utils_color_lerp

	if id == "order" or id == "highest" or id == "week" then
		local style_names = havoc_concat_passes_by_id[id]

		if style_names then
			for i = 1, #style_names do
				local style_name = style_names[i]
				local pass_params = params.pass_params[style_name]

				if pass_params then
					local pass_color = pass_params.pass_color
					local start_color = pass_params.start_color
					local target_color = pass_params.target_color
					local color_progress = _math_ease_sine(progress)

					color_utils_color_lerp(start_color, target_color, color_progress, pass_color)
				end
			end
		end
	end
end

local function havoc_fade_out_progress_by_id(id, widget, parent, params, progress)
	local color_utils_color_lerp = _color_utils_color_lerp

	if id == "order" or id == "highest" or id == "week" then
		local style_names = havoc_fade_out_passes_by_id[id]

		if style_names then
			for i = 1, #style_names do
				local style_name = style_names[i]
				local pass_params = params.pass_params[style_name]

				if pass_params then
					local pass_color = pass_params.pass_color
					local start_color = pass_params.start_color
					local target_color = pass_params.target_color
					local color_progress = _math_ease_sine(progress)

					color_utils_color_lerp(target_color, start_color, color_progress, pass_color)
				end
			end
		end
	end
end

local function havoc_concat_init_by_id(id, widget, parent, params)
	if not params.pass_params then
		params.pass_params = {}
	end

	local max_positions = table.size(havoc_concat_passes_by_id)
	local positions = get_havoc_positions(widget)
	local positions_size = #positions
	local id_position = get_havoc_position_by_id(widget, id)
	local widget_style = widget.style

	if id == "order" then
		if positions_size > 1 then
			widget_style.havoc_charge_1.vertical_alignment = "top"
			widget_style.havoc_charge_2.vertical_alignment = "top"
			widget_style.havoc_charge_3.vertical_alignment = "top"
			widget_style.havoc_badge_background.vertical_alignment = "top"
			widget_style.havoc_rank_badge.vertical_alignment = "top"
			widget_style.previous_havoc_rank_value_1.vertical_alignment = "top"

			if widget_style.previous_havoc_rank_value_2 then
				widget_style.previous_havoc_rank_value_2.vertical_alignment = "top"
			end

			if widget_style.current_havoc_rank_value_1 then
				widget_style.current_havoc_rank_value_1.vertical_alignment = "top"
			end

			if widget_style.current_havoc_rank_value_2 then
				widget_style.current_havoc_rank_value_2.vertical_alignment = "top"
			end

			local charge_scale, badge_scale

			if positions_size == max_positions then
				local start_badge_offset = 20
				local numbers_added_offset = 40
				local charges_added_offset = 120

				widget_style.havoc_rank_badge.offset[2] = start_badge_offset
				widget_style.havoc_badge_background.offset[2] = start_badge_offset + 20
				widget_style.previous_havoc_rank_value_1.offset[2] = start_badge_offset + numbers_added_offset

				if widget_style.previous_havoc_rank_value_2 then
					widget_style.previous_havoc_rank_value_1.offset[1] = widget_style.previous_havoc_rank_value_1.offset[1] + 5
					widget_style.previous_havoc_rank_value_2.offset[1] = widget_style.previous_havoc_rank_value_2.offset[1] - 5
					widget_style.previous_havoc_rank_value_2.offset[2] = start_badge_offset + numbers_added_offset
				end

				if widget_style.current_havoc_rank_value_1 then
					widget_style.current_havoc_rank_value_1.offset[2] = start_badge_offset + numbers_added_offset
				end

				if widget_style.current_havoc_rank_value_2 then
					widget_style.current_havoc_rank_value_1.offset[1] = widget_style.current_havoc_rank_value_1.offset[1] + 5
					widget_style.current_havoc_rank_value_2.offset[1] = widget_style.current_havoc_rank_value_2.offset[1] - 5
					widget_style.current_havoc_rank_value_2.offset[2] = start_badge_offset + numbers_added_offset
				end

				widget_style.havoc_charge_1.offset[1] = -20
				widget_style.havoc_charge_2.offset[1] = 0
				widget_style.havoc_charge_3.offset[1] = 20
				widget_style.havoc_charge_1.offset[2] = start_badge_offset + charges_added_offset
				widget_style.havoc_charge_2.offset[2] = start_badge_offset + charges_added_offset
				widget_style.havoc_charge_3.offset[2] = start_badge_offset + charges_added_offset
				badge_scale = 0.8
				charge_scale = 0.4
			else
				local start_badge_offset = 40
				local numbers_added_offset = 45
				local charges_added_offset = 140

				widget_style.havoc_rank_badge.offset[2] = start_badge_offset
				widget_style.havoc_badge_background.offset[2] = start_badge_offset + 35
				widget_style.previous_havoc_rank_value_1.offset[2] = start_badge_offset + numbers_added_offset

				if widget_style.previous_havoc_rank_value_2 then
					widget_style.previous_havoc_rank_value_1.offset[1] = widget_style.previous_havoc_rank_value_1.offset[1] + 2
					widget_style.previous_havoc_rank_value_2.offset[1] = widget_style.previous_havoc_rank_value_2.offset[1] - 2
					widget_style.previous_havoc_rank_value_2.offset[2] = start_badge_offset + numbers_added_offset
				end

				if widget_style.current_havoc_rank_value_1 then
					widget_style.current_havoc_rank_value_1.offset[2] = start_badge_offset + numbers_added_offset
				end

				if widget_style.current_havoc_rank_value_2 then
					widget_style.current_havoc_rank_value_1.offset[1] = widget_style.current_havoc_rank_value_1.offset[1] + 2
					widget_style.current_havoc_rank_value_2.offset[1] = widget_style.current_havoc_rank_value_2.offset[1] - 2
					widget_style.current_havoc_rank_value_2.offset[2] = start_badge_offset + numbers_added_offset
				end

				widget_style.havoc_charge_1.offset[1] = -40
				widget_style.havoc_charge_2.offset[1] = 0
				widget_style.havoc_charge_3.offset[1] = 40
				widget_style.havoc_charge_1.offset[2] = start_badge_offset + charges_added_offset
				widget_style.havoc_charge_2.offset[2] = start_badge_offset + charges_added_offset
				widget_style.havoc_charge_3.offset[2] = start_badge_offset + charges_added_offset
				badge_scale = 0.9
				charge_scale = 0.6
			end

			widget_style.havoc_charge_1.size = {
				widget_style.havoc_charge_1.size[1] * charge_scale,
				widget_style.havoc_charge_1.size[2] * charge_scale,
			}
			widget_style.havoc_charge_2.size = {
				widget_style.havoc_charge_2.size[1] * charge_scale,
				widget_style.havoc_charge_2.size[2] * charge_scale,
			}
			widget_style.havoc_charge_3.size = {
				widget_style.havoc_charge_3.size[1] * charge_scale,
				widget_style.havoc_charge_3.size[2] * charge_scale,
			}
			widget_style.havoc_badge_background.size = {
				widget_style.havoc_badge_background.size[1] * badge_scale,
				widget_style.havoc_badge_background.size[2] * badge_scale,
			}
			widget_style.havoc_rank_badge.size = {
				widget_style.havoc_rank_badge.size[1] * badge_scale,
				widget_style.havoc_rank_badge.size[2] * badge_scale,
			}
			widget_style.previous_havoc_rank_value_1.size = {
				widget_style.previous_havoc_rank_value_1.size[1] * badge_scale,
				widget_style.previous_havoc_rank_value_1.size[2] * badge_scale,
			}

			if widget_style.previous_havoc_rank_value_2 then
				widget_style.previous_havoc_rank_value_2.size = {
					widget_style.previous_havoc_rank_value_2.size[1] * badge_scale,
					widget_style.previous_havoc_rank_value_2.size[2] * badge_scale,
				}
			end

			if widget_style.current_havoc_rank_value_1 then
				widget_style.current_havoc_rank_value_1.size = {
					widget_style.current_havoc_rank_value_1.size[1] * badge_scale,
					widget_style.current_havoc_rank_value_1.size[2] * badge_scale,
				}
			end

			if widget_style.current_havoc_rank_value_2 then
				widget_style.current_havoc_rank_value_2.size = {
					widget_style.current_havoc_rank_value_2.size[1] * badge_scale,
					widget_style.current_havoc_rank_value_2.size[2] * badge_scale,
				}
			end
		end
	elseif id == "highest" then
		if positions_size > 1 then
			local added_offset = 0

			if positions_size == 2 and id_position < positions_size then
				widget_style.highest_havoc_description.vertical_alignment = "top"
				widget_style.highest_havoc_rank.vertical_alignment = "top"
				widget_style.havoc_icon.vertical_alignment = "top"

				local start_offset = 80

				widget_style.highest_havoc_description.offset[2] = start_offset
				widget_style.highest_havoc_rank.offset[2] = start_offset + 30
				widget_style.havoc_icon.offset[2] = start_offset + 30
			elseif positions_size == 2 and id_position == positions_size then
				widget_style.highest_havoc_description.vertical_alignment = "bottom"
				widget_style.highest_havoc_rank.vertical_alignment = "bottom"
				widget_style.havoc_icon.vertical_alignment = "bottom"

				local start_offset = -80

				widget_style.highest_havoc_description.offset[2] = start_offset - 50
				widget_style.highest_havoc_rank.offset[2] = start_offset
				widget_style.havoc_icon.offset[2] = start_offset
			else
				local start_offset = -20

				widget_style.highest_havoc_description.offset[2] = start_offset
				widget_style.highest_havoc_rank.offset[2] = start_offset + 40
				widget_style.havoc_icon.offset[2] = start_offset + 40
			end

			widget_style.havoc_icon.font_size = 48
			widget_style.highest_havoc_rank.font_size = 36
			widget_style.havoc_icon.offset[1] = -20
			widget_style.highest_havoc_rank.offset[1] = 20
		end
	elseif id == "week" and positions_size > 1 then
		widget_style.havoc_reward_week_icon_glow.color[1] = 0
		widget_style.havoc_reward_week_icon.color[1] = 0
		widget_style.havoc_reward_week_icon_glow.in_focus_color[1] = 0
		widget_style.havoc_reward_week_icon.in_focus_color[1] = 0
		widget_style.week_havoc_icon.vertical_alignment = "bottom"
		widget_style.week_havoc_rank.vertical_alignment = "bottom"
		widget_style.havoc_week_description.vertical_alignment = "bottom"

		local start_offset

		start_offset = positions_size == 2 and -70 or -40
		widget_style.havoc_week_description.offset[2] = start_offset - 50
		widget_style.week_havoc_rank.offset[2] = start_offset
		widget_style.week_havoc_icon.offset[2] = start_offset
		widget_style.week_havoc_icon.offset[1] = widget_style.havoc_icon.offset[1]
		widget_style.week_havoc_rank.offset[1] = widget_style.highest_havoc_rank.offset[1]
		widget_style.week_havoc_icon.font_size = 48
		widget_style.week_havoc_rank.font_size = 36
		widget_style.week_havoc_icon.offset[1] = -20
		widget_style.week_havoc_rank.offset[1] = 20
	end
end

local function _create_progress_havoc_animation(animation_table, start_time)
	local start_anim_time = start_time + _text_fade_in_time
	local info_time = 3
	local reward_1_start_time = start_anim_time + 0.3
	local reward_1_progress_time = reward_1_start_time + (info_time - 1)
	local reward_1_end_time = reward_1_start_time + info_time
	local reward_2_start_time = reward_1_end_time + 0.3
	local reward_2_progress_time = reward_2_start_time + 0.5
	local reward_2_end_time = reward_2_start_time + info_time
	local reward_3_start_time = reward_2_end_time + 0.3
	local reward_3_progress_time = reward_3_start_time + 0.5
	local reward_3_end_time = reward_3_start_time + info_time
	local reward_all_start_time = reward_3_end_time + 0.3
	local reward_all_end_time = reward_all_start_time + 0.5

	animation_table[#animation_table + 1] = {
		name = "fade_in_havoc_reward_1",
		start_time = start_anim_time,
		end_time = reward_1_start_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local start_id = get_havoc_id_by_wanted_position(widget, 1)
			local positions = get_havoc_positions(widget)

			havoc_fade_in_init_by_id(start_id, widget, parent, params)
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			if not params.pass_params then
				return
			end

			local start_id = get_havoc_id_by_wanted_position(widget, 1)

			havoc_fade_in_progress_by_id(start_id, widget, parent, params, progress)
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "change_charge",
		start_time = reward_1_start_time,
		end_time = reward_1_progress_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			if widget.content.order_reward_state then
				local content = widget.content
				local current_charges = content.current_charges
				local previous_charges = content.previous_charges

				if current_charges ~= previous_charges then
					parent:_play_sound(UISoundEvents.havoc_charge_change)
				end
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			if widget.content.order_reward_state then
				local max_charges = widget.content.max_charges
				local content = widget.content
				local style = widget.style
				local current_charges = content.current_charges
				local previous_charges = content.previous_charges

				if current_charges and previous_charges then
					local decrease_charges = current_charges < previous_charges
					local increase_charges = previous_charges < current_charges
					local anim_charge_progress = math.easeInCubic(progress)

					for i = 1, max_charges do
						local charge_style = style["havoc_charge_" .. i]
						local charge_ghost_style = style["havoc_charge_ghost_" .. i]

						if charge_style then
							local in_focus_color = charge_style.in_focus_color
							local charges_color = charge_style.charges_color
							local no_charges_color = charge_style.no_charges_color

							if decrease_charges and current_charges < i and i <= previous_charges then
								ColorUtilities.color_lerp(charges_color, no_charges_color, anim_charge_progress, charge_style.color)

								if charge_ghost_style then
									charge_ghost_style.color[1] = 255 - 255 * anim_charge_progress

									local charge_size = charge_ghost_style.size
									local charge_default_size = charge_ghost_style.default_size
									local size_add = 50 * anim_charge_progress

									charge_size[1] = charge_default_size[1] + size_add
									charge_size[2] = charge_default_size[2] + size_add
								end
							elseif increase_charges and previous_charges < i and i <= current_charges then
								ColorUtilities.color_lerp(no_charges_color, charges_color, anim_charge_progress, charge_style.color)

								if charge_ghost_style then
									charge_ghost_style.color[1] = 255 * anim_charge_progress

									local charge_size = charge_ghost_style.size
									local charge_default_size = charge_ghost_style.default_size
									local size_add = 50 - 50 * anim_charge_progress

									charge_size[1] = charge_default_size[1] + size_add
									charge_size[2] = charge_default_size[2] + size_add
								end
							end
						end
					end
				end
			end
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "change_badge",
		start_time = reward_1_start_time,
		end_time = reward_1_progress_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			if widget.content.order_reward_state then
				local content = widget.content
				local style = widget.style
				local previous_rank = content.previous_rank
				local current_rank = content.current_rank
				local rank_up = current_rank ~= nil and (not previous_rank or previous_rank <= current_rank)

				style.havoc_rank_badge.material_values.RankupRankdown = rank_up and 0 or 1
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			if widget.content.order_reward_state then
				local content = widget.content
				local style = widget.style

				if style.havoc_rank_badge.material_values.afterTexture ~= style.havoc_rank_badge.material_values.beforeTexure then
					style.havoc_rank_badge.material_values.AnimationSpeedFireAmountt[1] = progress
				end
			end
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "update_previous_rank",
		start_time = reward_1_start_time,
		end_time = reward_1_progress_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			if widget.content.order_reward_state then
				local content = widget.content

				if content.order_reward_state == "rank_increase" then
					parent:play_sound(UISoundEvents.havoc_eor_rank_up)
				elseif content.order_reward_state == "rank_decrease" then
					parent:play_sound(UISoundEvents.havoc_eor_rank_down)
				end
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			if widget.content.order_reward_state then
				local content = widget.content
				local style = widget.style
				local y_anim_offset = 20
				local anim_progress = math.easeInCubic(progress)

				if content.order_reward_state == "rank_increase" then
					for i = 1, content.previous_rank_size do
						style["previous_havoc_rank_value_" .. i].color[1] = 255 - anim_progress * 255
						style["previous_havoc_rank_value_" .. i].offset[2] = style["previous_havoc_rank_value_" .. i].start_offset_y - y_anim_offset * anim_progress
					end
				elseif content.order_reward_state == "rank_decrease" then
					for i = 1, content.previous_rank_size do
						style["previous_havoc_rank_value_" .. i].color[1] = 255 - anim_progress * 255
						style["previous_havoc_rank_value_" .. i].offset[2] = style["previous_havoc_rank_value_" .. i].start_offset_y + y_anim_offset * anim_progress
					end
				end
			end
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "update_current_rank",
		start_time = reward_1_start_time,
		end_time = reward_1_progress_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			return
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			if widget.content.order_reward_state then
				local content = widget.content
				local style = widget.style
				local y_anim_offset = 20
				local anim_progress = math.easeInCubic(progress)

				if content.order_reward_state == "rank_increase" then
					for i = 1, content.current_rank_size do
						style["current_havoc_rank_value_" .. i].color[1] = anim_progress * 255
						style["current_havoc_rank_value_" .. i].offset[2] = style["current_havoc_rank_value_" .. i].start_offset_y + y_anim_offset - y_anim_offset * anim_progress
					end
				elseif content.order_reward_state == "rank_decrease" then
					for i = 1, content.current_rank_size do
						style["current_havoc_rank_value_" .. i].color[1] = anim_progress * 255
						style["current_havoc_rank_value_" .. i].offset[2] = style["current_havoc_rank_value_" .. i].start_offset_y - y_anim_offset + y_anim_offset * anim_progress
					end
				end
			end
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "fade_out_havoc_reward_1",
		start_time = reward_1_end_time,
		end_time = reward_2_start_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local widget_style = widget.style
			local start_id = get_havoc_id_by_wanted_position(widget, 1)
			local positions = get_havoc_positions(widget)
			local positions_size = #positions

			if start_id == "order" then
				widget_style.havoc_charge_ghost_1.color[1] = 0
				widget_style.havoc_charge_ghost_2.color[1] = 0
				widget_style.havoc_charge_ghost_3.color[1] = 0
				widget_style.havoc_charge_1.in_focus_color = table.clone(widget_style.havoc_charge_1.color)
				widget_style.havoc_charge_2.in_focus_color = table.clone(widget_style.havoc_charge_2.color)
				widget_style.havoc_charge_3.in_focus_color = table.clone(widget_style.havoc_charge_3.color)
				widget_style.havoc_charge_1.start_color = table.clone(widget_style.havoc_charge_1.color)
				widget_style.havoc_charge_2.start_color = table.clone(widget_style.havoc_charge_2.color)
				widget_style.havoc_charge_3.start_color = table.clone(widget_style.havoc_charge_3.color)
				widget_style.havoc_charge_1.start_color[1] = 0
				widget_style.havoc_charge_2.start_color[1] = 0
				widget_style.havoc_charge_3.start_color[1] = 0
				params.pass_params.havoc_charge_1 = params.pass_params.havoc_charge_1 or {}
				params.pass_params.havoc_charge_1.pass_color = widget_style.havoc_charge_1.color
				params.pass_params.havoc_charge_1.start_color = widget_style.havoc_charge_1.start_color
				params.pass_params.havoc_charge_1.target_color = widget_style.havoc_charge_1.in_focus_color
				params.pass_params.havoc_charge_2 = params.pass_params.havoc_charge_2 or {}
				params.pass_params.havoc_charge_2.pass_color = widget_style.havoc_charge_2.color
				params.pass_params.havoc_charge_2.start_color = widget_style.havoc_charge_2.start_color
				params.pass_params.havoc_charge_2.target_color = widget_style.havoc_charge_2.in_focus_color
				params.pass_params.havoc_charge_3 = params.pass_params.havoc_charge_3 or {}
				params.pass_params.havoc_charge_3.pass_color = widget_style.havoc_charge_3.color
				params.pass_params.havoc_charge_3.start_color = widget_style.havoc_charge_3.start_color
				params.pass_params.havoc_charge_3.target_color = widget_style.havoc_charge_3.in_focus_color

				if widget_style.current_havoc_rank_value_1 then
					params.pass_params.current_havoc_rank_value_1 = params.pass_params.current_havoc_rank_value_1 or {}
					params.pass_params.current_havoc_rank_value_1.pass_color = widget_style.current_havoc_rank_value_1.color
					params.pass_params.current_havoc_rank_value_1.start_color = widget_style.current_havoc_rank_value_1.start_color
					params.pass_params.current_havoc_rank_value_1.target_color = widget_style.current_havoc_rank_value_1.in_focus_color
					params.pass_params.previous_havoc_rank_value_1.pass_color = widget_style.previous_havoc_rank_value_1.color
					params.pass_params.previous_havoc_rank_value_1.start_color = widget_style.previous_havoc_rank_value_1.start_color
					params.pass_params.previous_havoc_rank_value_1.target_color = widget_style.previous_havoc_rank_value_1.start_color

					if widget_style.previous_havoc_rank_value_2 then
						params.pass_params.previous_havoc_rank_value_2.pass_color = widget_style.previous_havoc_rank_value_2.color
						params.pass_params.previous_havoc_rank_value_2.start_color = widget_style.previous_havoc_rank_value_1.start_color
						params.pass_params.previous_havoc_rank_value_2.target_color = widget_style.previous_havoc_rank_value_1.start_color
					end
				end

				if widget_style.current_havoc_rank_value_2 then
					params.pass_params.current_havoc_rank_value_2 = params.pass_params.current_havoc_rank_value_2 or {}
					params.pass_params.current_havoc_rank_value_2.pass_color = widget_style.current_havoc_rank_value_2.color
					params.pass_params.current_havoc_rank_value_2.start_color = widget_style.current_havoc_rank_value_2.start_color
					params.pass_params.current_havoc_rank_value_2.target_color = widget_style.current_havoc_rank_value_2.in_focus_color
				end

				if widget_style.havoc_order_text and positions_size > 1 then
					widget_style.havoc_order_text.text_color = Color.black(0, true)
					params.pass_params.havoc_order_text.pass_color = Color.black(0, true)
					params.pass_params.havoc_order_text.start_color = Color.black(0, true)
					params.pass_params.havoc_order_text.target_color = Color.black(0, true)
				end
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local start_id = get_havoc_id_by_wanted_position(widget, 1)
			local next_id = get_havoc_id_by_wanted_position(widget, 2)

			if next_id then
				havoc_fade_out_progress_by_id(start_id, widget, parent, params, progress)
			end
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "fade_in_havoc_reward_2",
		start_time = reward_2_start_time,
		end_time = reward_2_progress_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local start_id = get_havoc_id_by_wanted_position(widget, 2)

			havoc_fade_in_init_by_id(start_id, widget, parent, params)

			if start_id then
				parent:play_sound(UISoundEvents.havoc_eor_card_short)
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			if not params.pass_params then
				return
			end

			local start_id = get_havoc_id_by_wanted_position(widget, 2)

			havoc_fade_in_progress_by_id(start_id, widget, parent, params, progress)
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "fade_out_havoc_reward_2",
		start_time = reward_2_end_time,
		end_time = reward_3_start_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			return
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local start_id = get_havoc_id_by_wanted_position(widget, 2)
			local next_id = get_havoc_id_by_wanted_position(widget, 3)

			if next_id then
				havoc_fade_out_progress_by_id(start_id, widget, parent, params, progress)
			end
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "fade_in_havoc_reward_3",
		start_time = reward_3_start_time,
		end_time = reward_3_progress_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local start_id = get_havoc_id_by_wanted_position(widget, 3)

			havoc_fade_in_init_by_id(start_id, widget, parent, params)

			if start_id then
				parent:play_sound(UISoundEvents.havoc_eor_card_short)
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			if not params.pass_params then
				return
			end

			local start_id = get_havoc_id_by_wanted_position(widget, 3)

			havoc_fade_in_progress_by_id(start_id, widget, parent, params, progress)
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "fade_out_havoc_reward_3",
		start_time = reward_3_end_time,
		end_time = reward_all_start_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			return
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local start_id = get_havoc_id_by_wanted_position(widget, 3)

			if start_id then
				havoc_fade_out_progress_by_id(start_id, widget, parent, params, progress)
			end
		end,
	}
	animation_table[#animation_table + 1] = {
		name = "havoc_reward_show_all",
		start_time = reward_all_start_time,
		end_time = reward_all_end_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local positions = get_havoc_positions(widget)

			if #positions == 1 then
				return
			end

			parent:play_sound(UISoundEvents.havoc_eor_card_full)

			for i = 1, #positions do
				local id = get_havoc_id_by_wanted_position(widget, i)

				havoc_concat_init_by_id(id, widget, parent, params)
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local positions = get_havoc_positions(widget)

			if #positions == 1 then
				return
			end

			for i = 1, #positions do
				local id = get_havoc_id_by_wanted_position(widget, i)

				havoc_fade_in_all_progress_by_id(id, widget, parent, params, progress)
			end
		end,
	}
end

local function _create_dim_havoc_animation(animation_table)
	animation_table[#animation_table + 1] = {
		name = "compress_havoc",
		start_time = 0,
		end_time = ViewSettings.animation_times.card_compress_content_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			params.pass_params = params.pass_params or {}

			local widget_style = widget.style
			local positions = get_havoc_positions(widget)
			local max_positions = table.size(havoc_concat_passes_by_id)
			local positions_size = #positions

			for i = 1, positions_size do
				local position = positions[i]

				for f = 1, #havoc_concat_passes_by_id[position] do
					local style_name = havoc_concat_passes_by_id[position][f]

					if widget_style[style_name] then
						params.pass_params[style_name] = params.pass_params[style_name] or {}
						params.pass_params[style_name].pass_color = widget_style[style_name].text_color or widget_style[style_name].color
						params.pass_params[style_name].target_color = table.clone(params.pass_params[style_name].pass_color)
						params.pass_params[style_name].start_color = table.clone(params.pass_params[style_name].pass_color)
						params.pass_params[style_name].start_color[1] = params.pass_params[style_name].start_color[1] > 0 and 127 or 0
					end
				end
			end

			if widget_style.havoc_charge_1 then
				if positions_size == max_positions then
					local charge_styles = {
						"havoc_charge_1",
						"havoc_charge_2",
						"havoc_charge_3",
					}

					for i = 1, #charge_styles do
						local charge_style = charge_styles[i]

						params.pass_params[charge_style].pass_color = widget_style[charge_style].color
						params.pass_params[charge_style].start_color = widget_style[charge_style].start_color
						params.pass_params[charge_style].target_color = widget_style[charge_style].in_focus_color
					end

					params.pass_params.havoc_charge_3.target_color = widget_style.havoc_charge_3.in_focus_color
				end

				local ghost_styles = {
					"havoc_charge_ghost_1",
					"havoc_charge_ghost_2",
					"havoc_charge_ghost_3",
				}

				for i = 1, #ghost_styles do
					local ghost_style = ghost_styles[i]

					widget_style[ghost_style].color = Color.black(0, true)
					params.pass_params[ghost_style].pass_color = Color.black(0, true)
					params.pass_params[ghost_style].start_color = Color.black(0, true)
					params.pass_params[ghost_style].target_color = Color.black(0, true)
				end
			end

			if widget_style.havoc_order_text and positions_size == 1 and positions[1] == "order" then
				widget_style.havoc_order_text.text_color = Color.black(0, true)
				params.pass_params.havoc_order_text.pass_color = widget_style.havoc_order_text.text_color
				params.pass_params.havoc_order_text.target_color = table.clone(params.pass_params.havoc_order_text.pass_color)
				params.pass_params.havoc_order_text.start_color = table.clone(params.pass_params.havoc_order_text.pass_color)
				params.pass_params.havoc_order_text.start_color[1] = 0
			end
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local positions = get_havoc_positions(widget)
			local widget_style = widget.style
			local color_utils_color_lerp = _color_utils_color_lerp

			for i = 1, #positions do
				local position = positions[i]

				for f = 1, #havoc_concat_passes_by_id[position] do
					local style_name = havoc_concat_passes_by_id[position][f]
					local pass_style = widget_style[style_name]
					local pass_params = params.pass_params and params.pass_params[style_name]

					if pass_style and pass_params then
						local pass_color = pass_params.pass_color
						local start_color = pass_params.start_color
						local target_color = pass_params.target_color
						local color_progress = _math_ease_sine(progress)

						color_utils_color_lerp(target_color, start_color, color_progress, pass_color)
					end
				end
			end
		end,
	}
end

local function _create_fade_in_level_up_label_animation(animation_table, start_time)
	_create_fade_in_pass_animation(animation_table, "level_up_label", start_time)
	_create_fade_in_pass_animation(animation_table, "level_up_label_divider", start_time + 0.05)
end

local function _create_show_reward_item_animation(animation_table, start_time)
	_create_fade_in_pass_animation(animation_table, "item_display_name", start_time)
	_create_fade_in_pass_animation(animation_table, "item_icon", start_time + _text_fade_in_time)
	_create_fade_in_pass_animation(animation_table, "item_sub_display_name", start_time + 2 * _text_fade_in_time)
end

local function _create_show_unlocked_weapon_animation(animation_table, start_time)
	_create_fade_in_level_up_label_animation(animation_table, start_time)

	start_time = start_time + _text_fade_in_time

	_create_fade_in_pass_animation(animation_table, "item_icon_background", start_time)
	_create_fade_in_pass_animation(animation_table, "item_icon_frame", start_time)

	start_time = start_time + _text_fade_in_time * 0.5

	_create_fade_in_pass_animation(animation_table, "item_icon", start_time)

	start_time = start_time + _text_fade_in_time

	_create_fade_in_pass_animation(animation_table, "item_display_name", start_time)

	start_time = start_time + _text_fade_in_time

	_create_fade_in_pass_animation(animation_table, "weapon_unlocked_text", start_time)
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
			local custom_icon_colors = {}
			local text_colors = {}
			local custom_text_colors = {}
			local gradiented_text_color = {}
			local text_color_index = 0
			local icon_color_index = 0

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

					local text_color = pass_style.text_color

					text_colors[text_color_index] = text_color
					custom_text_colors[2 * text_color_index - 1] = pass_style.in_focus_text_color
					custom_text_colors[2 * text_color_index] = pass_style.dimmed_out_text_color
				else
					icon_color_index = icon_color_index + 1
					icon_colors[icon_color_index] = pass_style.color
					custom_icon_colors[2 * icon_color_index - 1] = pass_style.in_focus_color
					custom_icon_colors[2 * icon_color_index] = pass_style.dimmed_out_color
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
			params.custom_text_colors = custom_text_colors
			params.gradiented_text_color = gradiented_text_color
			params.icon_colors = icon_colors
			params.custom_icon_colors = custom_icon_colors
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
			local custom_text_colors = params.custom_text_colors

			for i = 1, #text_colors do
				local ignore_alpha = true
				local start_color = custom_text_colors[2 * i - 1] or in_focus_text_color
				local target_color = custom_text_colors[2 * i] or dimmed_out_text_color

				color_utils_color_lerp(start_color, target_color, eased_progress, text_colors[i], ignore_alpha)
			end

			local gradiented_text_color = params.gradiented_text_color

			for i = 1, #gradiented_text_color do
				local ignore_alpha = true

				color_utils_color_lerp(in_focus_color, dimmed_out_gradiented_text_color, eased_progress, gradiented_text_color[i], ignore_alpha)
			end

			local icon_colors = params.icon_colors
			local custom_icon_colors = params.custom_icon_colors
			local num_icons = #icon_colors

			for i = 1, num_icons do
				local start_color = custom_icon_colors[2 * i - 1] or in_focus_color
				local target_color = custom_icon_colors[2 * i] or dimmed_out_color

				color_utils_color_lerp(start_color, target_color, eased_progress, icon_colors[i])
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
		end,
	}
end

local function _create_compress_content_animation(animation_table)
	animation_table[#animation_table + 1] = {
		name = "compress_icons",
		start_time = 0,
		end_time = ViewSettings.animation_times.card_compress_content_time,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local widget_style = widget.style
			local styles_to_compress = {}
			local original_icon_sizes = {}
			local styles_to_move = {}
			local compress_index = 0
			local move_index = 0

			for style_id, style in pairs(widget_style) do
				if type(style) == "table" then
					if style.can_compress then
						compress_index = compress_index + 1

						local size = style.size

						styles_to_compress[compress_index] = style
						original_icon_sizes[compress_index * 2 - 1] = size[1]
						original_icon_sizes[compress_index * 2] = size[2]
					end

					if style.offset_compressed then
						move_index = move_index + 1
						styles_to_move[move_index] = style
					end
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
				local icon_start_width = original_icon_sizes[i * 2 - 1]
				local icon_start_height = original_icon_sizes[i * 2]
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
		end,
	}
end

animations.experience_card_show_content = {}
animations.experience_card_dim_out_content = {}

_create_icon_animation(animations.experience_card_show_content, {
	"experience",
	0.25,
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
	5.25,
})
_create_count_up_animation(animations.salary_card_show_content, "credits", "credits", 0.25, 2)
_create_count_up_animation(animations.salary_card_show_content, "side_mission_credits", "credits", 2.25, 3)
_create_count_up_animation(animations.salary_card_show_content, "circumstance_credits", "credits", 3.25, 4)
_create_count_up_animation(animations.salary_card_show_content, "plasteel", "plasteel", 4.25, 5)
_create_count_up_animation(animations.salary_card_show_content, "diamantine", "diamantine", 5.25, 6)
_create_consolidate_wallet_animation(animations.salary_card_show_content, 6, 6.25, 7.25)
_create_dim_out_animation(animations.salary_card_dim_out_content, animations.salary_card_show_content)

animations.level_up_show_content = {}
animations.level_up_dim_out_content = {}

_create_show_reward_item_animation(animations.level_up_show_content, 0.25 + _text_fade_in_time)
_create_dim_out_animation(animations.level_up_dim_out_content, animations.level_up_show_content)

animations.unlocked_weapon_show_content = {}
animations.unlocked_weapon_dim_out_content = {}

_create_show_unlocked_weapon_animation(animations.unlocked_weapon_show_content, 0.25)
_create_compress_content_animation(animations.unlocked_weapon_dim_out_content)
_create_dim_out_animation(animations.unlocked_weapon_dim_out_content, animations.unlocked_weapon_show_content)

animations.item_reward_show_content = {}
animations.item_reward_dim_out_content = {}

_create_show_reward_item_animation(animations.item_reward_show_content, 0.25)
_create_fade_in_pass_animation(animations.item_reward_show_content, "item_level", 0.25 + 3 * _text_fade_in_time)
_create_fade_in_pass_animation(animations.item_reward_show_content, "added_to_inventory_text", 0.25 + 4 * _text_fade_in_time)
_create_compress_content_animation(animations.item_reward_dim_out_content)
_create_dim_out_animation(animations.item_reward_dim_out_content, animations.item_reward_show_content)

animations.test = {
	{
		end_time = 1,
		name = "test",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			return
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, progress, params)
			return
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets_by_name, params)
			return
		end,
	},
}
animations.weapon_card_show_content = {}
animations.weapon_card_dim_out_content = {}

_create_init_weapon_animation(animations.weapon_card_show_content, 0.1)
_create_progress_weapon_animation(animations.weapon_card_show_content, 0.25, 7)
_create_dim_weapon_animation(animations.weapon_card_dim_out_content)

animations.havoc_card_show_content = {}
animations.havoc_card_dim_out_content = {}

_create_progress_havoc_animation(animations.havoc_card_show_content, 0.25)
_create_dim_havoc_animation(animations.havoc_card_dim_out_content)

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

animations.weapon_level_up = {
	{
		end_time = 1,
		name = "level_up_mastery",
		start_time = 0,
		init = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			return
		end,
		update = function (parent, ui_scenegraph, scenegraph_definition, widget, progress, params)
			local slot = params.slot
			local anim_progress = math.sin(progress * math.pi)
			local text_style = widget.style["weapon_level_" .. slot]
			local bar_style = widget.style["weapon_experience_bar_" .. slot]
			local increased_font_size = text_style.default_font_size * 1.1
			local current_font_size = text_style.default_font_size + increased_font_size * anim_progress
			local text_start_color = text_style.default_text_color
			local text_target_color = Color.ui_blue_light(255, true)

			_color_utils_color_lerp(text_start_color, text_target_color, anim_progress, text_style.highlight_text_color, true)

			local bar_start_color = bar_style.default_color
			local bar_target_color = Color.ui_blue_light(255, true)

			_color_utils_color_lerp(bar_start_color, bar_target_color, anim_progress, bar_style.color, true)

			local current_mastery_level = widget.content["weapon_current_mastery_level_" .. slot]
			local slug_text = string.format("{#size(%d);color(%d, %d, %d)}%d{#reset()}", current_font_size, text_style.highlight_text_color[2], text_style.highlight_text_color[3], text_style.highlight_text_color[4], current_mastery_level)
			local animated_mastery_level = Localize("loc_mastery_level_current", true, {
				level = slug_text,
			})

			widget.content["weapon_level_" .. slot] = animated_mastery_level
		end,
		on_complete = function (parent, ui_scenegraph, scenegraph_definition, widget, params)
			local slot = params.slot
			local text_style = widget.style["weapon_level_" .. slot]
			local bar_style = widget.style["weapon_experience_bar_" .. slot]

			text_style.text_color = table.clone(text_style.default_text_color)
			bar_style.color[2] = bar_style.default_color[2]
			bar_style.color[3] = bar_style.default_color[3]
			bar_style.color[4] = bar_style.default_color[4]

			local current_mastery_level = widget.content["weapon_current_mastery_level_" .. slot]

			widget.content["weapon_level_" .. slot] = Localize("loc_mastery_level_current", true, {
				level = current_mastery_level,
			})
		end,
	},
}

return settings("EndPlayerViewAnimations", animations)
