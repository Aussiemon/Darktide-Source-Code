-- chunkname: @scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view.lua

local Definitions = require("scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view_definitions")
local HavocRewardPresentationViewSettings = require("scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local HavocRewardPresentationView = class("HavocRewardPresentationView", "BaseView")

HavocRewardPresentationView.init = function (self, settings, context)
	local parent = context and context.parent

	self._parent = parent

	HavocRewardPresentationView.super.init(self, Definitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
end

HavocRewardPresentationView.on_enter = function (self)
	HavocRewardPresentationView.super.on_enter(self)

	local rewards = self._parent._rewards

	if not rewards then
		Managers.event:trigger("event_reset_havoc_background_view")
	elseif rewards.type == "week" then
		self:_generate_reward_widgets(rewards)
		self._parent:play_vo_events(HavocRewardPresentationViewSettings.vo_event_weekly_reward, "commissar_a", nil, 0.8)
	elseif rewards.type == "promotion" then
		self:_generate_promotion_widgets(rewards)
	end
end

HavocRewardPresentationView._generate_badge_widget = function (self, havoc_data, offset_y)
	local badge_definitions = self._definitions.badge_definitions
	local definitions = badge_definitions.pass_template_function(self, havoc_data)
	local widget_definition = UIWidget.create_definition(definitions, "badge", nil, badge_definitions.size)
	local widget = UIWidget.init("rank_badge", widget_definition)

	if offset_y then
		widget.offset[2] = offset_y
	end

	badge_definitions.init(self, widget, havoc_data)

	self._widgets_by_name.rank_badge = widget
	self._widgets[1 + #self._widgets] = widget
end

HavocRewardPresentationView._generate_promotion_widgets = function (self, rewards)
	local offset_y = 50

	self:_generate_badge_widget(rewards, offset_y)

	self._widgets_by_name.rank_display_name.content.visible = true

	local current_charges = rewards.current and rewards.current.charges
	local previous_charges = rewards.previous and rewards.previous.charges
	local previous_rank = rewards.previous and rewards.previous.rank
	local current_rank = rewards.current and rewards.current.rank
	local animation_name

	if current_rank and previous_rank then
		if previous_rank < current_rank then
			animation_name = "rank_increase"

			self._parent:play_vo_events(HavocRewardPresentationViewSettings.vo_event_promotion, "commissar_a", nil, 0.8)

			self._widgets_by_name.rank_display_name.content.text = Localize("loc_havoc_eor_promotion")
		elseif current_rank < previous_rank then
			animation_name = "rank_decrease"

			self._parent:play_vo_events(HavocRewardPresentationViewSettings.vo_event_demotion, "commissar_a", nil, 0.8)

			self._widgets_by_name.rank_display_name.content.text = Localize("loc_havoc_eor_demotion")
		else
			animation_name = "charge_change"

			self._parent:play_vo_events(HavocRewardPresentationViewSettings.vo_event_vendor_greeting, "commissar_a", nil, 0.8)

			self._widgets_by_name.rank_display_name.content.text = Localize("loc_havoc_eor_charge_used")
		end

		if animation_name then
			self:_start_animation(animation_name, self._widgets_by_name.rank_badge)
		end
	end
end

HavocRewardPresentationView._generate_reward_widgets = function (self, rewards)
	self:_generate_badge_widget(rewards)

	local rewards = self._parent._rewards
	local rewards_definitions = self._definitions.reward_defintions
	local x_offset = 0
	local x_margin = 50
	local reward_count = 0
	local total_width = 0
	local reward_widgets = {}

	for type, value in pairs(rewards.rewards) do
		local widget_definition = UIWidget.create_definition(rewards_definitions.passes, "rewards", nil, rewards_definitions.size)
		local widget = UIWidget.init("reward_" .. type, widget_definition)
		local config = {
			currency = type,
			value = value,
		}

		rewards_definitions.init(widget, config)

		widget.offset[1] = x_offset
		reward_count = reward_count + 1
		x_offset = x_offset + rewards_definitions.size[1] + x_margin
		total_width = x_offset
		self._widgets_by_name["reward_" .. type] = widget
		self._widgets[1 + #self._widgets] = widget
		reward_widgets[#reward_widgets + 1] = widget
	end

	self.reward_widgets = reward_widgets
	total_width = total_width - x_margin

	self:_set_scenegraph_size("rewards", total_width)

	self._widgets_by_name.rank_display_name.content.text = Localize("loc_havoc_reset_Highest_order")
	self._widgets_by_name.rank_display_name.content.visible = true
	self._widgets_by_name.reward_display_name.content.visible = true
	self._widgets_by_name.divider.content.visible = true

	self:_start_animation("weekly", self._widgets_by_name.rank_badge)
	self:_play_sound(UISoundEvents.havoc_weekly_reward)
end

HavocRewardPresentationView.cb_on_continue_pressed = function (self)
	self:_play_sound(UISoundEvents.default_click)
	Managers.event:trigger("event_reset_havoc_background_view")
end

HavocRewardPresentationView.on_back_pressed = function (self)
	if Managers.ui:view_active("havoc_background_view") then
		Managers.ui:close_view("havoc_background_view")

		return true
	end

	return false
end

HavocRewardPresentationView.on_exit = function (self)
	HavocRewardPresentationView.super.on_exit(self)
end

HavocRewardPresentationView._handle_input = function (self, input_service, dt, t)
	return
end

HavocRewardPresentationView.update = function (self, dt, t, input_service)
	return HavocRewardPresentationView.super.update(self, dt, t, input_service)
end

HavocRewardPresentationView.draw = function (self, dt, t, input_service, layer)
	HavocRewardPresentationView.super.draw(self, dt, t, input_service, layer)
end

HavocRewardPresentationView.on_resolution_modified = function (self, scale)
	HavocRewardPresentationView.super.on_resolution_modified(self, scale)
end

HavocRewardPresentationView.dialogue_system = function (self)
	local parent = self._parent

	if parent then
		return parent.dialogue_system and parent:dialogue_system()
	end
end

HavocRewardPresentationView.set_alpha_multiplier = function (self, alpha_multiplier)
	self._render_settings.alpha_multiplier = alpha_multiplier
end

return HavocRewardPresentationView
