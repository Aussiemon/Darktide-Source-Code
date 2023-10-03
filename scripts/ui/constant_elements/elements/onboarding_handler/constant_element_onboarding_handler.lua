local OnboardingTemplates = require("scripts/ui/constant_elements/elements/onboarding_handler/onboarding_templates")
local ConstantElementOnboardingHandler = class("ConstantElementOnboardingHandler")

ConstantElementOnboardingHandler.init = function (self, parent, draw_layer, start_scale)
	self:_initialize_settings()

	self._current_state_name = nil
	self._once_per_state_tracker = {}
end

ConstantElementOnboardingHandler._initialize_settings = function (self)
	local tutorial_settings = {}

	for i = 1, #OnboardingTemplates do
		local settings = table.clone(OnboardingTemplates[i])
		settings.active = false
		tutorial_settings[#tutorial_settings + 1] = settings
	end

	local tutorial_settings_by_state = {}

	for i = 1, #tutorial_settings do
		local setting = tutorial_settings[i]
		local valid_states = setting.valid_states

		for j = 1, #valid_states do
			local state = valid_states[j]
			local settings = tutorial_settings_by_state[state]

			if not settings then
				settings = {}
				tutorial_settings_by_state[state] = settings
			end

			settings[#settings + 1] = setting
		end
	end

	self._tutorial_settings = tutorial_settings
	self._tutorial_settings_by_state = tutorial_settings_by_state
end

ConstantElementOnboardingHandler.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local current_sub_state_name = Managers.ui:get_current_sub_state_name()
	local current_state_name = current_sub_state_name == "" and Managers.ui:get_current_state_name() or current_sub_state_name

	if current_state_name ~= self._current_state_name then
		self:_on_state_changed(current_state_name)
	end

	self:_sync_state_settings()
end

ConstantElementOnboardingHandler._on_state_changed = function (self, new_state_name)
	local tutorial_settings_by_state = self._tutorial_settings_by_state
	local current_tutorial_settings = self._current_state_tutorial_settings
	local new_tutorial_settings = tutorial_settings_by_state[new_state_name]

	Log.info("ConstantElementOnboardingHandler", "State changed %s -> %s", self._current_state_name, new_state_name)

	self._current_state_name = new_state_name
	self._current_state_tutorial_settings = new_tutorial_settings

	table.clear(self._once_per_state_tracker)
end

ConstantElementOnboardingHandler._sync_state_settings = function (self, on_destroy)
	local once_per_state_tracker = self._once_per_state_tracker
	local current_state_tutorial_settings = self._current_state_tutorial_settings

	if current_state_tutorial_settings then
		for i = 1, #current_state_tutorial_settings do
			local settings = current_state_tutorial_settings[i]

			if settings:validation_func() then
				local settings_name = settings.name

				if not settings.active and not once_per_state_tracker[settings_name] then
					settings.should_activate = true
				end

				settings.synced = true
			end
		end
	end

	local tutorial_settings = self._tutorial_settings

	for i = 1, #tutorial_settings do
		local settings = tutorial_settings[i]

		if settings.active then
			local close_condition = on_destroy or settings.close_condition and settings:close_condition()

			if close_condition then
				settings:on_deactivation()

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

			settings:on_deactivation()

			settings.active = false
		end

		settings.synced = nil
	end

	if current_state_tutorial_settings then
		for i = 1, #current_state_tutorial_settings do
			local settings = current_state_tutorial_settings[i]

			if settings.should_activate then
				settings.should_activate = nil

				settings:on_activation()

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
	return true
end

ConstantElementOnboardingHandler.should_draw = function (self)
	return false
end

ConstantElementOnboardingHandler.destroy = function (self)
	self:_on_state_changed("")
	self:_sync_state_settings(true)
end

return ConstantElementOnboardingHandler
