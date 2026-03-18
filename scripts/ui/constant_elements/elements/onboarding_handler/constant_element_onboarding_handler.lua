-- chunkname: @scripts/ui/constant_elements/elements/onboarding_handler/constant_element_onboarding_handler.lua

local OnboardingTemplates = require("scripts/ui/constant_elements/elements/onboarding_handler/onboarding_templates")
local ConstantElementOnboardingHandler = class("ConstantElementOnboardingHandler")

ConstantElementOnboardingHandler.init = function (self, parent, draw_layer, start_scale)
	self:_initialize_settings()

	self._once_per_state_tracker = {}
	self._active = false
end

ConstantElementOnboardingHandler._initialize_settings = function (self)
	local tutorial_settings = {}

	for i = 1, #OnboardingTemplates do
		local settings = table.clone(OnboardingTemplates[i])

		settings.active = false
		tutorial_settings[#tutorial_settings + 1] = settings
	end

	self._tutorial_settings = tutorial_settings
end

ConstantElementOnboardingHandler.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local current_sub_state_name = Managers.ui:get_current_sub_state_name()
	local current_state_name = current_sub_state_name == "" and Managers.ui:get_current_state_name() or current_sub_state_name
	local valid_state = "GameplayStateRun"

	if current_state_name == valid_state then
		self:_sync_onboarding_settings()
	end
end

ConstantElementOnboardingHandler._sync_onboarding_settings = function (self, on_destroy)
	local once_per_state_tracker = self._once_per_state_tracker
	local tutorial_settings = self._tutorial_settings

	if not on_destroy then
		for i = 1, #tutorial_settings do
			local settings = tutorial_settings[i]

			if settings.validation_func(settings) then
				local settings_name = settings.name

				if not settings.active and not once_per_state_tracker[settings_name] then
					settings.should_activate = true
				end

				settings.synced = true
			end
		end
	else
		table.clear(self._once_per_state_tracker)
	end

	for i = 1, #tutorial_settings do
		local settings = tutorial_settings[i]

		if settings.active then
			local close_condition = on_destroy or settings.close_condition and settings.close_condition(settings)

			if close_condition == true then
				if settings.on_deactivation then
					local close_condition_met = not on_destroy

					settings.on_deactivation(settings, close_condition_met)
				end

				settings.active = false
				settings.synced = nil
			end
		end
	end

	for i = 1, #tutorial_settings do
		local settings = tutorial_settings[i]

		if settings.active and not settings.synced then
			local sync_on_events = settings.sync_on_events

			if sync_on_events then
				for j = 1, #sync_on_events do
					local event_name = sync_on_events[j]

					Managers.event:unregister(settings, event_name)
				end
			end

			if settings.on_deactivation then
				local close_condition_met = false

				settings.on_deactivation(settings, close_condition_met)
			end

			settings.active = false
		end

		settings.synced = nil
	end

	if not on_destroy then
		for i = 1, #tutorial_settings do
			local settings = tutorial_settings[i]

			if settings.should_activate then
				settings.should_activate = nil

				if settings.on_activation then
					settings.on_activation(settings)
				end

				settings.active = true

				if settings.once_per_state then
					once_per_state_tracker[settings.name] = true
				end

				local sync_on_events = settings.sync_on_events

				if sync_on_events then
					local on_event_triggered = settings.on_event_triggered

					for j = 1, #sync_on_events do
						local event_name = sync_on_events[j]

						if on_event_triggered then
							Managers.event:register(settings, event_name, "on_activation", event_name, "on_event_triggered")
						else
							Managers.event:register(settings, event_name, "on_activation")
						end
					end
				end
			end
		end
	end
end

ConstantElementOnboardingHandler.set_visible = function (self, visible, optional_visibility_parameters)
	return
end

ConstantElementOnboardingHandler.should_update = function (self)
	local game_mode_name = Managers.state.game_mode and Managers.state.game_mode:game_mode_name()
	local in_hub = game_mode_name == "hub" or game_mode_name == "prologue_hub"

	if self._active and not in_hub then
		self:_sync_onboarding_settings(true)
	end

	self._active = in_hub

	return in_hub
end

ConstantElementOnboardingHandler.should_draw = function (self)
	return false
end

ConstantElementOnboardingHandler.destroy = function (self)
	self:_sync_onboarding_settings(true)
end

return ConstantElementOnboardingHandler
