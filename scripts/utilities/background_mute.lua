local BackgroundMute = class("BackgroundMute")

BackgroundMute.init = function (self)
	if DEDICATED_SERVER or not IS_WINDOWS then
		return
	end

	self._has_focus = Window.has_focus()

	self:_update_setting()
end

BackgroundMute.update = function (self, dt, t)
	if DEDICATED_SERVER or not IS_WINDOWS then
		return
	end

	local has_focus = Window.has_focus()

	if self._has_focus ~= has_focus then
		self:_update_setting()

		if has_focus then
			Wwise.set_state("options_mute_all", "false")
		elseif self._option_enabled then
			Wwise.set_state("options_mute_all", "true")
		end

		self._has_focus = has_focus
	end
end

BackgroundMute._update_setting = function (self)
	if Application.user_setting and Application.user_setting("sound_settings") then
		local option_enabled = Application.user_setting("sound_settings").mute_in_background_enabled

		if self._option_enabled and not option_enabled then
			Wwise.set_state("options_mute_all", "false")
		end

		self._option_enabled = option_enabled
	end
end

return BackgroundMute
