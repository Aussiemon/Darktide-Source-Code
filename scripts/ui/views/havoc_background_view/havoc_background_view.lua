-- chunkname: @scripts/ui/views/havoc_background_view/havoc_background_view.lua

local Definitions = require("scripts/ui/views/havoc_background_view/havoc_background_view_definitions")
local HavocRewardPresentationViewSettings = require("scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view_settings")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local Promise = require("scripts/foundation/utilities/promise")
local HavocBackgroundView = class("HavocBackgroundView", "VendorInteractionViewBase")

HavocBackgroundView.init = function (self, settings, context)
	HavocBackgroundView.super.init(self, Definitions, settings, context)

	local promotion_info = Managers.data_service.havoc:show_promotion_info()

	if promotion_info then
		local havoc_info = Managers.data_service.havoc:get_settings()
		local min_rank = 1
		local max_rank = havoc_info.max_rank
		local max_charges = havoc_info.max_charges
		local current_rank = promotion_info.current and promotion_info.current.rank
		local previous_rank = promotion_info.previous and promotion_info.previous.rank
		local current_charges = promotion_info.current and promotion_info.current.charges
		local previous_charges = promotion_info.previous and promotion_info.previous.charges
		local should_present_reward = current_rank and current_rank ~= previous_rank or current_charges and current_rank and current_rank ~= min_rank and current_charges ~= previous_charges

		if should_present_reward then
			self._rewards = table.clone(promotion_info)
			self._rewards.type = self._rewards.type or "promotion"
		end

		Managers.data_service.havoc:set_show_promotion_info()
	end

	self:_register_event("event_havoc_background_on_end_time_met")
	self:_register_event("event_revoke_havoc_mission", "revoke_mission")
end

HavocBackgroundView.revoke_mission = function (self)
	local charges_left = self.havoc_order.charges

	self._rewards = {
		type = "promotion",
		current = {},
		previous = {
			rank = self.havoc_order.data.rank,
			charges = self.havoc_order.charges,
		},
	}

	self:_close_active_view()

	local function next_function(data)
		if self._destroyed then
			return
		end

		local on_complete_callback = callback(function ()
			self._rewards.current.charges = self.havoc_order.charges
			self._rewards.current.rank = self.havoc_order.data and self.havoc_order.data.rank

			if not self._rewards.current.rank or not self._rewards.current.charges or self._rewards.previous.charges == self._rewards.current.charges and self._rewards.previous.rank == self._rewards.current.rank then
				self._rewards = nil
			end

			if self._current_state == "key" then
				local starting_option_index = self._rewards and 3 or self._base_definitions.starting_option_index

				if starting_option_index then
					local button_options_definitions = self._base_definitions.button_options_definitions[self._current_state]
					local option = button_options_definitions[starting_option_index]

					if option then
						self:on_option_button_pressed(starting_option_index, option)
					end
				end
			end
		end)

		self:_initialize_havoc_state(on_complete_callback)
	end

	local function catch_function(data)
		if self._destroyed then
			return
		end

		self._rewards = nil

		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_popup_description_backend_error"),
		})

		local starting_option_index = self._base_definitions.starting_option_index

		if starting_option_index then
			local button_options_definitions = self._base_definitions.button_options_definitions[self._current_state]
			local option = button_options_definitions[starting_option_index]

			if option then
				self:on_option_button_pressed(starting_option_index, option)
			end
		end
	end

	local ongoing_mission_id = self.havoc_order.ongoing_mission_id
	local order_id = self.havoc_order.id

	if ongoing_mission_id and charges_left > 1 then
		Managers.data_service.havoc:delete_personal_mission(ongoing_mission_id):next(next_function):catch(catch_function)
	elseif order_id then
		Managers.data_service.havoc:reject_order(order_id):next(next_function):catch(catch_function)
	end
end

HavocBackgroundView.event_havoc_background_on_end_time_met = function (self)
	self._rewards = nil

	local on_complete_callback = callback(function ()
		if self._current_state == "key" then
			local starting_option_index = self._rewards and 3 or self._base_definitions.starting_option_index

			if starting_option_index then
				local button_options_definitions = self._base_definitions.button_options_definitions[self._current_state]
				local option = button_options_definitions[starting_option_index]

				if option then
					self:_close_active_view()
					self:on_option_button_pressed(starting_option_index, option)
				end
			end
		end
	end)

	self:_initialize_havoc_state(on_complete_callback)
end

HavocBackgroundView.on_enter = function (self)
	VendorInteractionViewBase.super.on_enter(self)

	if self._current_state == "no_key" then
		self:_setup_tab_bar({
			tabs_params = {},
		})

		local button_options_definitions = self._base_definitions.button_options_definitions[self._current_state]

		self:_setup_option_buttons(button_options_definitions)

		self._presenting_options = true
		self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)

		local intro_texts = self._base_definitions.intro_texts[self._current_state]

		self:_set_intro_texts(intro_texts)

		local narrative_manager = Managers.narrative
		local narrative_story = "unlock_havoc"
		local not_visited_chapter_name = "unlock_havoc_1"
		local current_chapter = narrative_manager:current_chapter(narrative_story)
		local current_chapter_name = current_chapter and current_chapter.name

		if current_chapter_name == not_visited_chapter_name then
			self:play_vo_events(HavocRewardPresentationViewSettings.vo_event_vendor_first_interaction, "commissar_a", nil, 0.8)
		else
			self:play_vo_events(HavocRewardPresentationViewSettings.vo_event_vendor_greeting, "commissar_a", nil, 0.8)
		end
	elseif self._current_state == "key" then
		self:_setup_tab_bar({
			tabs_params = {},
		})

		local button_options_definitions = self._base_definitions.button_options_definitions[self._current_state]

		self:_setup_option_buttons(button_options_definitions)

		self._presenting_options = true
		self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)

		local intro_texts = self._base_definitions.intro_texts

		self:_set_intro_texts(intro_texts)

		self._hide_option_buttons = self._base_definitions.hide_option_buttons

		local starting_option_index = self._rewards and 3 or self._base_definitions.starting_option_index

		if starting_option_index then
			local option = button_options_definitions[starting_option_index]

			if option then
				self:on_option_button_pressed(starting_option_index, option)
			end
		end

		if self._hide_option_buttons then
			local widgets_by_name = self._widgets_by_name

			widgets_by_name.title_text.visible = false
			widgets_by_name.description_text.visible = false
			widgets_by_name.button_divider.visible = false
		end

		if not self._rewards then
			self:play_vo_events(HavocRewardPresentationViewSettings.vo_event_vendor_greeting, "commissar_a", nil, 0.8)
		end

		self:_register_event("event_select_havoc_background_option")
	end
end

HavocBackgroundView._initialize_havoc_state = function (self, on_complete_callback)
	return Managers.data_service.havoc:latest():next(function (latest_data)
		if self._destroyed then
			return
		end

		local next_promise
		local server_time = Managers.backend:get_server_time(Managers.time:time("main")) / 1000

		if not table.is_empty(latest_data) and server_time >= latest_data.end_time and not latest_data.is_rewarded then
			next_promise = Promise.all(Managers.data_service.havoc:get_rewards_if_available(), Managers.data_service.havoc:status_by_id(latest_data.id)):next(function (return_data)
				if self._destroyed then
					return
				end

				local rewards_data = return_data[1]
				local havoc_week_data = return_data[2]
				local week_rank = havoc_week_data.havoc_stats.rank.week or 0
				local all_time_rank = havoc_week_data.havoc_stats.rank.allTime or 0

				if rewards_data.rewards and not table.is_empty(rewards_data.rewards) then
					self._rewards = {
						type = "week",
						rewards = {},
						previous = {
							rank = week_rank,
						},
					}

					for i = 1, #rewards_data.rewards do
						local reward = rewards_data.rewards[i]
						local currency_type = reward.type
						local amount = reward.amount

						if amount == nil then
							Log.error("HavocBackgroundView", "Reward amount is nil value")
						elseif amount > 0 then
							self._rewards.rewards[currency_type] = amount
						end
					end
				end

				local parsed_week_data = {
					week_rank = 0,
					all_time = all_time_rank,
					rewards = {},
				}

				if havoc_week_data.rewards then
					for i = 1, #havoc_week_data.rewards do
						local reward = havoc_week_data.rewards[i]

						if reward.amount > 0 then
							parsed_week_data.rewards[#parsed_week_data.rewards + 1] = reward.type
						end
					end
				end

				self._havoc_week_data = parsed_week_data

				return Managers.data_service.havoc:latest():next(function (new_latest_data)
					if self._destroyed then
						return
					end

					self._latest = new_latest_data

					return Managers.data_service.havoc:available_orders()
				end)
			end)
		elseif not table.is_empty(latest_data) and latest_data.id then
			self._latest = latest_data
			next_promise = Managers.data_service.havoc:status_by_id(latest_data.id):next(function (havoc_week_data)
				if self._destroyed then
					return
				end

				local week_rank = havoc_week_data.havoc_stats.rank.week or 0
				local all_time_rank = havoc_week_data.havoc_stats.rank.allTime or 0
				local parsed_week_data = {
					week_rank = week_rank,
					all_time = all_time_rank,
					rewards = {},
				}

				if havoc_week_data.rewards then
					for i = 1, #havoc_week_data.rewards do
						local reward = havoc_week_data.rewards[i]

						if reward.amount > 0 then
							parsed_week_data.rewards[#parsed_week_data.rewards + 1] = reward.type
						end
					end
				end

				self._havoc_week_data = parsed_week_data

				return Managers.data_service.havoc:available_orders()
			end)
		else
			next_promise = Managers.data_service.havoc:available_orders()
		end

		return next_promise:next(function (order_data)
			if self._destroyed then
				return
			end

			local order_index = 1
			local max_rank = 0

			if order_data then
				for i = 1, #order_data do
					local order = order_data[i]

					if max_rank < order.data.rank then
						max_rank = order.data.rank
						order_index = i
					end
				end
			end

			self.havoc_order = order_data and order_data[order_index]
			self._current_state = self.havoc_order and "key" or "no_key"

			local server_time = Managers.backend:get_server_time(Managers.time:time("main")) / 1000

			self._havoc_week_end_time = self._latest and self._latest.end_time - server_time

			if self.havoc_order then
				return Managers.data_service.havoc:check_ongoing_havoc():next(function (ongoing_havoc_data)
					if self._destroyed then
						return
					end

					self._loading = nil

					local valid_ongoing_havoc_data = {}
					local current_ongoing_havoc_data = {}

					if ongoing_havoc_data then
						for i = 1, #ongoing_havoc_data do
							local havoc_data = ongoing_havoc_data[i]

							if not havoc_data.depleted then
								valid_ongoing_havoc_data[#valid_ongoing_havoc_data + 1] = havoc_data
							end
						end
					end

					if valid_ongoing_havoc_data and not table.is_empty(valid_ongoing_havoc_data) then
						self.havoc_order.charges = self.havoc_order.charges + #valid_ongoing_havoc_data
						self.havoc_order.ongoing_mission_id = ongoing_havoc_data[1].id
						self.havoc_order.participants = ongoing_havoc_data[1].eligibleParticipants
					end

					if on_complete_callback then
						on_complete_callback()
					end
				end)
			else
				self._loading = nil

				if on_complete_callback then
					on_complete_callback()
				end
			end
		end)
	end):catch(function (error)
		if self._destroyed then
			return
		end

		Managers.ui:close_view(self.view_name)
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_popup_description_backend_error"),
		})
	end)
end

HavocBackgroundView._on_view_load_complete = function (self, loaded)
	if self._destroyed then
		return
	end

	local on_complete_callback = callback(function ()
		if self:is_view_requirements_complete() then
			self:_on_view_requirements_complete()
		end
	end)

	self:_initialize_havoc_state(on_complete_callback)
end

HavocBackgroundView.event_select_havoc_background_option = function (self, index)
	local button_options_definitions = self._base_definitions.button_options_definitions[self._current_state]

	if index then
		local option = button_options_definitions[index]

		if option then
			self:on_option_button_pressed(index, option)
		end
	end
end

HavocBackgroundView.on_exit = function (self)
	Managers.event:unregister(self, "event_select_havoc_background_option")
	HavocBackgroundView.super.on_exit(self)
end

HavocBackgroundView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local render_settings_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self._alpha_multiplier or 0

	HavocBackgroundView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	render_settings.alpha_multiplier = render_settings_alpha_multiplier
end

HavocBackgroundView._set_intro_texts = function (self, intro_texts)
	local widgets_by_name = self._widgets_by_name
	local title_text = intro_texts.title_text
	local unlocalized_title_text = intro_texts.unlocalized_title_text

	if title_text then
		widgets_by_name.title_text.content.text = Localize(title_text)
	end

	if unlocalized_title_text then
		widgets_by_name.title_text.content.text = unlocalized_title_text
	end

	local description_text = intro_texts.description_text
	local unlocalized_description_text = intro_texts.unlocalized_description_text

	if description_text then
		widgets_by_name.description_text.content.text = Localize(description_text)
	end

	if unlocalized_description_text then
		widgets_by_name.description_text.content.text = unlocalized_description_text
	end

	self:_update_text_height()
end

return HavocBackgroundView
