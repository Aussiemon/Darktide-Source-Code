-- chunkname: @scripts/utilities/background_mute.lua

local BackgroundMute = class("BackgroundMute")

BackgroundMute.init = function (self)
	if DEDICATED_SERVER or not IS_WINDOWS then
		return
	end

	self._had_focus = Window.has_focus()

	self:_update_setting()
end

BackgroundMute.update = function (self, dt, t)
	if DEDICATED_SERVER or not IS_WINDOWS then
		return
	end

	local has_focus = Window.has_focus()

	if self._had_focus ~= has_focus then
		self:_update_setting()

		local should_mute = not has_focus and self._option_enabled

		Wwise.set_state("options_mute_all", should_mute and "true" or "false")

		self._had_focus = has_focus
	end
end

BackgroundMute._update_setting = function (self)
	local sound_settings = Application.user_setting and Application.user_setting("sound_settings")
	local option_enabled = not not sound_settings and not not sound_settings.mute_in_background_enabled

	if self._option_enabled and not option_enabled then
		Wwise.set_state("options_mute_all", "false")
	end

	self._option_enabled = option_enabled
end

return BackgroundMute
