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
	self._wallet_widgets = nil
	self._current_card = 1
	self._current_carousel_state = 1
	self._current_carousel_state_func = nil
	self._carousel_state_data = {}
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

	EndPlayerView.super.init(self, Definitions, settings)

	self._pass_draw = true
	self._pass_input = true
	self._can_exit = context and context.can_exit
end

EndPlayerView.on_enter = function (self)
	EndPlayerView.super.on_enter(self)
	Managers.event:trigger("end_of_round_blur_background_world", 0.5)
	self:_register_event("event_trigger_current_end_presentation_done")
	self:_setup_progress_bar()
	self:_create_cards()
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

	return EndPlayerView.super.update(self, dt, t, input_service)
end

EndPlayerView.event_trigger_current_end_presentation_done = function (self)
	self._current_presentation_done = true
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
		local reward_item, item_group = self:_get_item(card_data.rewards[1])
		local player_level = card_data.level
		local talent_group_name, unlocked_talents = self:_get_unlocked_talents(player_level)
		card_data.reward_item = reward_item
		card_data.item_group = item_group
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
		card_data.reward_item, card_data.item_group = self:_get_item(card_data.rewards[1])
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
	local wallet_widgets = {
		credits = widgets_by_name.credits_wallet,
		marks = widgets_by_name.marks_wallet,
		plasteel = widgets_by_name.plasteel_wallet,
		diamantine = widgets_by_name.diamantine_wallet
	}
	self._wallet_widgets = wallet_widgets

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
	local item_type = item.item_type
	local item_group = item_type_group_lookup[item_type]

	return item, item_group
end

EndPlayerView._get_unlocked_talents = function (self, player_level)
	return nil, nil
end

EndPlayerView._set_carousel_state = function (self, state_id, t)
	local state_data = self._carousel_state_data

	if state_data.animation_id then
		self:_complete_animation(state_data.animation_id)

		state_data.animation_id = nil
	end

	if state_data.sound_event then
		self:_stop_sound(state_data.sound_event)
	end

	local state_settings = ViewSettings.carousel_initial_states[state_id]

	table.create_copy(state_data, state_settings)

	state_data.start_time = t
	local duration = state_data.duration

	if duration then
		state_data.end_time = t + duration
	end

	local func_name = state_settings.update_func_name
	self._current_carousel_state_func = self._definitions.animations[func_name]
	self._current_carousel_state = state_id

	if state_settings.sound_event then
		self:_play_sound(state_settings.sound_event)
	end
end

EndPlayerView._update_carousel = function (self, dt, t, input_service)
	local carousel_state = self._current_carousel_state

	if carousel_state then
		local state_data = self._carousel_state_data

		if not state_data.start_time then
			self:_set_carousel_state(carousel_state, t)
		end

		local is_state_done = self._current_presentation_done or self:_current_carousel_state_func(state_data, self._card_widgets, self._current_card, t)

		if is_state_done then
			local carousel_states = ViewSettings.carousel_initial_states

			if carousel_state < #carousel_states or self._current_card < #self._card_widgets then
				local next_carousel_state = carousel_state + 1

				if not carousel_states[next_carousel_state] then
					self._current_card = self._current_card + 1
					next_carousel_state = 1
				end

				self:_set_carousel_state(next_carousel_state, t)
			elseif not self._can_exit then
				self:_continue()
			else
				self._current_carousel_state = nil
			end
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
	local experience_gain_widget = widgets_by_name.experience_gain
	local experience_gain_widget_content = experience_gain_widget.content
	experience_gain_widget_content.text = string.format("+ %d", new_experience)
	experience_gain_widget_content.progress = bar_progress
	experience_gain_widget.visible = new_experience > 0
end

EndPlayerView._update_wallet = function (self, new_value, wallet_type)
	local wallet_widget = self._wallet_widgets[wallet_type]

	if wallet_widget then
		local content = wallet_widget.content
		local current_amount = math.min(new_value, content.total_amount)
		content.current_amount = current_amount
		content.text = tostring(current_amount)
	end
end

return EndPlayerView
