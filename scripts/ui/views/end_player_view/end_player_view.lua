local ColorUtilities = require("scripts/utilities/ui/colors")
local Definitions = require("scripts/ui/views/end_player_view/end_player_view_definitions")
local MasterItems = require("scripts/backend/master_items")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewSettings = require("scripts/ui/views/end_player_view/end_player_view_settings")
local ViewStyles = require("scripts/ui/views/end_player_view/end_player_view_styles")
local CARD_CAROUSEL_SCENEGRAPH_ID = "card_carousel"
local REWARD_TYPES = table.enum("xp", "levelUp", "salary", "weaponDrop")
local item_type_group_lookup = UISettings.item_type_group_lookup
local EndPlayerView = class("EndPlayerView", "BaseView")

EndPlayerView.init = function (self, settings, context)
	self._card_widgets = {}
	self._wallet_widgets = {}
	self._currency_gain_widgets = {}
	self._current_card = nil
	self._current_carousel_state = nil
	self._current_carousel_state_func = nil
	self._carousel_state_data = {}
	self._skip_to_next_animation_state = false
	self._carousel_left_border = 0
	self._carousel_right_border = 0
	self._session_report = context.session_report
	self._starting_experience = 0
	self._current_experience = 0
	self._current_level = 0
	self._experience_for_current_level = 0
	self._experience_for_next_level = 0
	self._max_level = 0
	self._max_level_experience = 0
	self._experience_table = nil
	self._current_credits = 0
	self._current_marks = 0
	self._current_plasteel = 0
	self._current_diamantine = 0
	self._timed_visibility_widgets = {}

	EndPlayerView.super.init(self, Definitions, settings)

	self._pass_draw = true
	self._pass_input = true
	self._can_exit = context and context.can_exit
end

EndPlayerView.on_enter = function (self)
	EndPlayerView.super.on_enter(self)
	Managers.event:trigger("end_of_round_blur_background_world", 0.5)
	self:_register_event("event_trigger_current_end_presentation_skip")
	self:_setup_progress_bar()

	local player = self:_player()
	local profile = player:profile()
	local load_callback = callback(self, "_create_cards")
	self._talent_icons_package_id = Managers.data_service.talents:load_icons_for_profile(profile, "EndPlayerView", load_callback, true)

	table.clear(self._timed_visibility_widgets)
end

EndPlayerView.on_exit = function (self)
	local ui_renderer = self._ui_renderer
	local card_widgets = self._card_widgets

	for i = 1, #card_widgets do
		local widget = card_widgets[i]

		if widget.content.icon_load_id then
			local blueprint_name = widget.content.blueprint_name
			local blueprints = self._definitions.blueprints
			local widget_blueprint = blueprints[blueprint_name]

			if widget_blueprint and widget_blueprint.unload_icon then
				widget_blueprint.unload_icon(self, widget, nil, ui_renderer)
			end
		end
	end

	Managers.event:trigger("end_of_round_blur_background_world", 0)
	EndPlayerView.super.on_exit(self)
	Managers.data_service.talents:release_icons(self._talent_icons_package_id)
end

EndPlayerView.can_exit = function (self)
	return self._can_exit
end

EndPlayerView.trigger_on_exit_animation = function (self)
	local current_state_data = self._carousel_state_data
	local animation_id = current_state_data.animation_id

	if animation_id and not self:is_animation_done(animation_id) then
		self:_complete_animation(animation_id)
	end

	EndPlayerView.super.trigger_on_exit_animation(self)
end

EndPlayerView.on_exit_animation_done = function (self)
	local current_state_data = self._carousel_state_data
	local animation_id = current_state_data.animation_id

	if animation_id then
		if not self:is_animation_done(animation_id) then
			return false
		else
			current_state_data.animation_id = nil
		end
	end

	return EndPlayerView.super.on_exit_animation_done(self)
end

EndPlayerView.on_resolution_modified = function (self, scale)
	local screen_width = RESOLUTION_LOOKUP.width
	local screen_border = (screen_width + ViewStyles.card_width) / 2
	self._carousel_left_border = -screen_border
	self._carousel_right_border = screen_border
end

EndPlayerView.update = function (self, dt, t, input_service)
	local on_enter_animation_done = EndPlayerView.super.on_enter_animation_done(self)

	if on_enter_animation_done and not self._continue_called then
		self:_update_carousel(dt, t, input_service)
	end

	self:_update_timed_visibility_widgets(dt)

	return EndPlayerView.super.update(self, dt, t, input_service)
end

EndPlayerView.event_trigger_current_end_presentation_skip = function (self)
	self._skip_to_next_animation_state = true
end

EndPlayerView.start_card_animation = function (self, card_widget, animation_name)
	local animation_id = self:_start_animation(animation_name, card_widget)

	return animation_id
end

EndPlayerView.is_animation_done = function (self, animation_id)
	return not EndPlayerView.super._is_animation_active(self, animation_id)
end

EndPlayerView.update_xp_bar = function (self, new_xp_value)
	self:_update_experience_bar(new_xp_value)
end

EndPlayerView.update_wallet = function (self, new_value, wallet_type)
	self:_update_wallet(new_value, wallet_type)
end

EndPlayerView.belate_wallet_update = function (self, new_value, wallet_type)
	self:_belate_wallet_update(new_value, wallet_type)
end

EndPlayerView.update_belated_wallet = function (self, progress)
	self:_update_belated_wallets(progress)
end

EndPlayerView.retract_currency_gain_widgets = function (self, progress)
	self:_retract_currency_gain_widgets(progress)
end

EndPlayerView.trigger_currency_gain_widgets_timeout = function (self)
	self:_trigger_currency_gain_widgets_timeout()
end

EndPlayerView._handle_input = function (self, input_service, dt, t)
	EndPlayerView.super._handle_input(self, input_service, dt, t)
end

EndPlayerView.play_sound = function (self, sound_event)
	EndPlayerView.super._play_sound(self, sound_event)
end

EndPlayerView.stop_sound = function (self, sound_event)
	EndPlayerView.super._stop_sound(self, sound_event)
end

EndPlayerView.set_sound_parameter = function (self, parameter_id, value)
	EndPlayerView.super._set_sound_parameter(self, parameter_id, value)
end

EndPlayerView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	EndPlayerView.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	local card_widgets = self._card_widgets
	local carousel_left_border = self._carousel_left_border
	local carousel_right_border = self._carousel_right_border

	for i = 1, #card_widgets do
		local widget = card_widgets[i]
		local widget_offset_x = widget.offset[1]

		if carousel_left_border <= widget_offset_x and widget_offset_x <= carousel_right_border then
			UIWidget.draw(widget, ui_renderer)
		elseif widget_offset_x < carousel_left_border and widget.content.icon_load_id then
			local blueprint_name = widget.content.blueprint_name
			local blueprints = self._definitions.blueprints
			local widget_blueprint = blueprints[blueprint_name]

			if widget_blueprint and widget_blueprint.unload_icon then
				widget_blueprint.unload_icon(self, widget, nil, ui_renderer)
			end
		end
	end
end

EndPlayerView._continue = function (self)
	if self._can_exit then
		self:_close_current_presentation_view()
	else
		local event_name = "event_state_game_score_continue"

		Managers.event:trigger(event_name)
	end

	self._continue_called = true
end

EndPlayerView._finish_current_animation_state = function (self)
	local carousel_state = self._current_carousel_state

	if carousel_state then
		local state_data = self._carousel_state_data
		local content_animation_id = state_data.animation_id

		if content_animation_id then
			if not self:is_animation_done(content_animation_id) then
				self:_complete_animation(content_animation_id)
			end

			state_data.animation_id = nil
			state_data.animation_done = true
		end

		local t = state_data.end_time

		self:_current_carousel_state_func(state_data, self._card_widgets, self._current_card, t)
	end
end

EndPlayerView._setup_progress_bar = function (self)
	local session_report = self._session_report
	local experience_settings = session_report.experience_settings
	local starting_experience = session_report.starting_experience
	local max_level = experience_settings.max_level
	local experience_table = experience_settings.experience_table
	self._starting_experience = starting_experience
	self._max_level = max_level
	self._max_level_experience = experience_settings.max_level_experience
	self._experience_table = experience_table

	self:_update_experience_bar(0)

	local experience_gain_widget = self._widgets_by_name.experience_gain
	experience_gain_widget.visible = false
end

EndPlayerView._create_cards = function (self)
	local card_widgets = self._card_widgets
	local session_report = self._session_report
	local reward_card_data = session_report.rewards
	local num_cards = #reward_card_data

	if num_cards == 0 then
		self:_continue()

		return
	end

	for i = 1, num_cards do
		local card_data = reward_card_data[i]

		if card_data.kind == "salary" then
			local rewards = card_data.rewards

			self:_setup_wallets(session_report.wallets, rewards)

			if #rewards > 0 then
				card_widgets[#card_widgets + 1] = self:_create_card_widget(i, card_data, session_report)
			end
		else
			card_widgets[#card_widgets + 1] = self:_create_card_widget(i, card_data, session_report)
		end
	end

	self._current_card = 1
end

EndPlayerView._create_card_widget = function (self, index, card_data)
	local blueprints = self._definitions.blueprints
	local scenegraph_id = CARD_CAROUSEL_SCENEGRAPH_ID
	local kind = card_data.kind
	local blueprint_name = nil

	if kind == REWARD_TYPES.xp then
		blueprint_name = "experience"
	elseif kind == REWARD_TYPES.salary then
		blueprint_name = "salary"
	elseif kind == REWARD_TYPES.levelUp then
		local reward_item, item_group, rarity = self:_get_item(card_data.rewards[1])
		local player_level = card_data.level
		local talent_group_name, unlocked_talents = self:_get_unlocked_talents(player_level)
		card_data.reward_item = reward_item
		card_data.item_group = item_group
		card_data.rarity = rarity
		card_data.unlocked_talents = unlocked_talents
		card_data.talent_group_name = talent_group_name

		if reward_item then
			blueprint_name = "level_up"
		elseif unlocked_talents then
			blueprint_name = "level_up_talents_only"
		else
			return
		end
	elseif kind == REWARD_TYPES.weaponDrop then
		blueprint_name = "item_reward"
		card_data.reward_item, card_data.item_group, card_data.rarity = self:_get_item(card_data.rewards[1])
		card_data.label = kind
	else
		blueprint_name = "empty_test_card"
		card_data.label = kind
	end

	local blueprint = blueprints[blueprint_name]
	local pass_template = blueprint.pass_template_function and blueprint.pass_template_function(self, card_data) or blueprint.pass_template
	local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id, nil, blueprint.size, blueprint.style)
	local widget_name = "card_" .. index
	local widget = UIWidget.init(widget_name, widget_definition)

	blueprint.init(self, widget, index, card_data)

	if blueprint.load_icon then
		blueprint.load_icon(self, widget)
	end

	return widget
end

EndPlayerView._setup_wallets = function (self, wallet_data, salary_rewards)
	local widgets_by_name = self._widgets_by_name
	local wallet_widgets = self._wallet_widgets
	local currency_gain_widgets = self._currency_gain_widgets
	local wallet_types = {
		"credits",
		"marks",
		"plasteel",
		"diamantine"
	}

	for _, wallet_type in ipairs(wallet_types) do
		wallet_widgets[wallet_type] = widgets_by_name[wallet_type .. "_wallet"]
		local currency_gain_widget = widgets_by_name[wallet_type .. "_gain"]

		if currency_gain_widget then
			currency_gain_widget.visible = false
			currency_gain_widget.alpha_multiplier = 0
			currency_gain_widgets[wallet_type] = currency_gain_widget
		end
	end

	for i = 1, #salary_rewards do
		local salary_reward = salary_rewards[i]
		local currency = salary_reward.currency
		local wallet_widget = wallet_widgets[currency]
		local widget_content = wallet_widget and wallet_widget.content
		local total_amount = salary_reward.current_amount
		local current_amount = total_amount - salary_reward.amount_gained
		widget_content.start_amount = current_amount
		widget_content.current_amount = current_amount
		widget_content.total_amount = total_amount
		widget_content.text = tostring(current_amount)
	end

	local wallets = wallet_data.wallets

	for i = 1, #wallets do
		local wallet = wallets[i].balance
		local currency = wallet.type
		local wallet_widget = wallet_widgets[currency]
		local widget_content = wallet_widget and wallet_widget.content

		if widget_content and not widget_content.current_amount then
			local current_amount = wallet.amount
			widget_content.start_amount = current_amount
			widget_content.current_amount = current_amount
			widget_content.total_amount = current_amount
			widget_content.text = tostring(current_amount)
		end
	end
end

EndPlayerView._get_item = function (self, card_reward)
	if not card_reward then
		return nil
	end

	local item_id = card_reward.master_id
	local item = MasterItems.get_item(item_id)

	if not item then
		return nil
	end

	local item_type = item.item_type
	local item_group = item_type_group_lookup[item_type]
	local item_overrides = card_reward.overrides
	local rarity = item_overrides and item_overrides.rarity

	return item, item_group, rarity
end

EndPlayerView._get_unlocked_talents = function (self, player_level)
	local player = self:_player()
	local profile = player:profile()
	local specialization_name = profile.specialization
	local archetype = profile.archetype
	local specialization = archetype.specializations[specialization_name]
	local talents = archetype.talents[specialization_name]
	local talent_groups = specialization.talent_groups

	for i = 1, #talent_groups do
		local talent_group = talent_groups[i]

		if talent_group.required_level == player_level then
			local talent_icons = {}
			local group_talents = talent_group.talents

			for j = 1, #group_talents do
				local talent_id = group_talents[j]
				talent_icons[j] = talents[talent_id].icon
			end

			return talent_group.group_name, talent_icons
		end
	end

	return nil, nil
end

EndPlayerView._set_carousel_state = function (self, state_id)
	local state_data = self._carousel_state_data

	if state_data.animation_id and not state_data.animation_done then
		self:_complete_animation(state_data.animation_id)

		state_data.animation_id = nil
	elseif state_data.animation_done then
		state_data.animation_id = nil
		state_data.animation_done = nil
	end

	if state_data.sound_event then
		self:_stop_sound(state_data.sound_event)
	end

	local state_settings = ViewSettings.carousel_initial_states[state_id]

	table.create_copy(state_data, state_settings)

	local func_name = state_settings.update_func_name
	self._current_carousel_state_func = self._definitions.animations[func_name]
	self._current_carousel_state = state_id

	return state_data
end

EndPlayerView._update_carousel = function (self, dt, t, input_service)
	local carousel_state = self._current_carousel_state

	if carousel_state then
		local state_data = self._carousel_state_data

		if not state_data.start_time then
			state_data.start_time = t
			local duration = state_data.duration

			if duration then
				state_data.end_time = t + duration
			end
		end

		local is_state_done = nil
		local skip_to_next_animation_state = self._skip_to_next_animation_state

		if skip_to_next_animation_state then
			self:_finish_current_animation_state()

			is_state_done = true
			self._skip_to_next_animation_state = false
		else
			is_state_done = self:_current_carousel_state_func(state_data, self._card_widgets, self._current_card, t)
		end

		if is_state_done then
			local carousel_states = ViewSettings.carousel_initial_states

			if carousel_state < #carousel_states or self._current_card < #self._card_widgets then
				local next_carousel_state = carousel_state + 1

				if not carousel_states[next_carousel_state] then
					self._current_card = self._current_card + 1
					next_carousel_state = 1
				end

				self:_set_carousel_state(next_carousel_state)
			elseif not self._can_exit then
				self:_continue()
			else
				self._current_card = nil
				self._current_carousel_state = nil
			end
		end
	elseif self._current_card then
		self:_set_carousel_state(self._current_card)
	end
end

EndPlayerView._update_timed_visibility_widgets = function (self, dt)
	local timed_visibility_widgets = self._timed_visibility_widgets

	for widget_id, widget in pairs(timed_visibility_widgets) do
		if widget.visible == false then
			widget.visible = true
			widget.alpha_multiplier = 0
		end

		local animation_times = ViewSettings.animation_times
		local fade_time = animation_times.timed_widget_fade_time
		local content = widget.content
		local timer = content.visibility_timer - dt
		local alpha_multiplier = widget.alpha_multiplier

		if timer >= 0 then
			alpha_multiplier = math.min(alpha_multiplier + dt / fade_time, 1)
		else
			alpha_multiplier = math.max(alpha_multiplier - dt / fade_time, 0)
		end

		content.visibility_timer = timer
		widget.alpha_multiplier = alpha_multiplier

		if alpha_multiplier == 0 then
			widget.visible = false
			content.visibility_timer = nil
			timed_visibility_widgets[widget_id] = nil
		end
	end
end

local _update_experience_bar_text_params = {}

EndPlayerView._update_experience_bar = function (self, new_experience)
	local widgets_by_name = self._widgets_by_name
	local starting_experience = self._starting_experience
	local max_level_experience = self._max_level_experience
	local current_experience = math.min(starting_experience + new_experience, max_level_experience)
	self._current_experience = current_experience
	local experience_for_current_level = self._experience_for_current_level
	local experience_for_next_level = self._experience_for_next_level
	local current_level = self._current_level
	local max_level = self._max_level

	if current_level < max_level and experience_for_next_level <= current_experience then
		local experience_table = self._experience_table
		local next_level = current_level

		while next_level < max_level and experience_for_next_level <= current_experience do
			next_level = next_level + 1
			experience_for_next_level = experience_table[next_level]
		end

		if current_level > 0 then
			self:_play_sound(UISoundEvents.end_screen_summary_level_up)
		end

		current_level = experience_for_next_level <= current_experience and max_level or next_level - 1
		local current_level_widget = widgets_by_name.current_level_text
		current_level_widget.content.text = tostring(math.min(current_level, max_level - 1))
		local next_level_widget = widgets_by_name.next_level_text
		next_level_widget.content.text = tostring(next_level)
		experience_for_current_level = experience_table[current_level]
		self._current_level = current_level
		self._experience_for_current_level = experience_for_current_level
		self._experience_for_next_level = experience_for_next_level
	end

	local character_progress_widget = widgets_by_name.character_progress_text
	local text_params = _update_experience_bar_text_params
	text_params.experience = current_experience
	text_params.experience_for_next_level = experience_for_next_level
	character_progress_widget.content.text = Localize("loc_eor_xp_bar_progression_text", true, text_params)
	local bar_progress = current_level == max_level and 1 or math.ilerp(experience_for_current_level, experience_for_next_level, current_experience)
	local progress_bar_widget = widgets_by_name.progress_bar
	progress_bar_widget.content.progress = bar_progress
	local gain_widget_name = "experience_gain"
	local experience_gain_widget = widgets_by_name[gain_widget_name]
	local experience_gain_widget_content = experience_gain_widget.content
	experience_gain_widget_content.text = string.format("+ %d", new_experience)
	experience_gain_widget_content.progress = bar_progress
	experience_gain_widget_content.visibility_timer = ViewSettings.animation_times.xp_gain_visibility_time
	self._timed_visibility_widgets[gain_widget_name] = experience_gain_widget
end

EndPlayerView._update_wallet = function (self, new_value, wallet_type)
	local wallet_widget = self._wallet_widgets[wallet_type]

	if wallet_widget then
		local wallet_content = wallet_widget.content
		local current_amount = math.min(new_value, wallet_content.total_amount)
		wallet_content.current_amount = current_amount
		wallet_content.text = tostring(current_amount)
		local currency_gain_widget = self._currency_gain_widgets[wallet_type]

		if currency_gain_widget then
			local currency_gain_content = currency_gain_widget.content
			currency_gain_content.text = string.format("+ %d", new_value - wallet_content.start_amount)
			currency_gain_content.visibility_timer = ViewSettings.animation_times.currency_gain_visibility_time
			self._timed_visibility_widgets[wallet_type] = currency_gain_widget
		end
	end
end

EndPlayerView._belate_wallet_update = function (self, new_value, wallet_type)
	local wallet_widget = self._wallet_widgets[wallet_type]

	if wallet_widget then
		local currency_gain_widget = self._currency_gain_widgets[wallet_type]

		if currency_gain_widget then
			local wallet_content = wallet_widget.content
			local currency_gain_content = currency_gain_widget.content
			local amount = new_value - wallet_content.start_amount
			currency_gain_content.amount = amount
			currency_gain_content.text = string.format("+ %d", amount)
			currency_gain_content.visibility_timer = ViewSettings.animation_times.currency_gain_visibility_time
			self._timed_visibility_widgets[wallet_type] = currency_gain_widget
		end
	end
end

EndPlayerView._update_belated_wallets = function (self, amount_progress)
	local currency_gain_widgets = self._currency_gain_widgets

	for wallet_type, currency_gain_widget in pairs(currency_gain_widgets) do
		local wallet_widget = self._wallet_widgets[wallet_type]
		local wallet_content = wallet_widget.content
		local currency_gain_content = currency_gain_widget.content
		local start_amount = wallet_content.start_amount
		local amount = currency_gain_content.amount

		if amount and amount > 0 then
			local total_amount = wallet_content.total_amount
			local current_amount = math.floor(math.lerp(start_amount, total_amount, amount_progress))
			wallet_content.text = tostring(current_amount)
		end
	end
end

EndPlayerView._retract_currency_gain_widgets = function (self, progress)
	local currency_gain_widgets = self._currency_gain_widgets

	for wallet_id, widget in pairs(currency_gain_widgets) do
		local content = widget.content
		widget.offset[2] = math.lerp(0, -content.size[2], progress)
		content.visibility_timer = math.max(1 - 4 * progress, 0)
	end
end

EndPlayerView._trigger_currency_gain_widgets_timeout = function (self)
	local math_min = math.min
	local currency_gain_widgets = self._currency_gain_widgets

	for wallet_id, widget in pairs(currency_gain_widgets) do
		local content = widget.content

		if content.visibility_timer then
			content.visibility_timer = math_min(content.visibility_timer, ViewSettings.animation_times.xp_gain_visibility_time)
		end
	end
end

return EndPlayerView
