-- chunkname: @scripts/ui/hud/elements/hud_bar_logic.lua

local HudBarLogic = class("HudBarLogic")
local settings_list = {
	"duration",
	"animation_threshold",
	"alpha_fade_delay",
	"alpha_fade_duration",
	"alpha_fade_min_value",
	"animate_on_fraction_increase",
}

HudBarLogic.init = function (self, settings)
	self:_verify_settings(settings)

	self._settings = settings
	self._bar_animations = {}
	self._update_order = {
		"bar",
		"bar_max",
	}
	self._stored_fractions = {}

	for i = 1, #self._update_order do
		local name = self._update_order[i]

		self._stored_fractions[name] = 1
	end
end

HudBarLogic._verify_settings = function (self, settings)
	for i = 1, #settings_list do
		local setting_name = settings_list[i]
	end
end

HudBarLogic._sync_bar_progress = function (self, bar_progress, bar_max_progress)
	bar_max_progress = bar_max_progress or 1

	if bar_progress ~= self._bar_progress or bar_max_progress ~= self._bar_max_progress then
		local settings = self._settings
		local force_update = false

		if not settings.animate_on_fraction_increase then
			force_update = bar_progress > (self._bar_progress or 1)
		end

		local current_bar_max_progress = self._bar_max_progress or 1

		self._bar_progress = bar_progress
		self._bar_max_progress = bar_max_progress
		bar_progress = bar_progress * bar_max_progress

		local update_order = self._update_order
		local animate = self:_set_bar_fraction(update_order[1], bar_progress, nil, settings.duration, settings.animation_threshold, force_update)

		self:_set_bar_fraction(update_order[2], bar_max_progress, current_bar_max_progress, settings.duration, settings.animation_threshold, animate)
	end
end

HudBarLogic.update = function (self, dt, t, bar_progress, bar_max_progress)
	self._bar_fraction = nil
	self._bar_max_fraction = nil

	self:_sync_bar_progress(bar_progress, bar_max_progress)
	self:_update_bar_animations(dt, t)
	self:_update_bar_alpha(dt, t)
end

HudBarLogic._set_bar_fraction = function (self, name, fraction, current_fraction, total_duration, animation_threshold, force_update)
	self._update_bars = true

	self:_reset_bar_alpha()

	local stored_fractions = self._stored_fractions
	local previous_fraction = stored_fractions[name]
	local bar_animations = self._bar_animations
	local anim_data = bar_animations[name]

	anim_data = anim_data or {}

	local animate = not force_update
	local duration

	current_fraction = current_fraction or anim_data.fraction or previous_fraction

	if not force_update then
		if current_fraction < fraction then
			duration = (fraction - current_fraction) * total_duration
		else
			local difference = current_fraction - fraction

			duration = difference * total_duration

			if animation_threshold then
				animate = difference <= animation_threshold
			else
				animate = true
			end
		end
	end

	if animate then
		anim_data = {
			time = 0,
			duration = duration,
			start_value = current_fraction,
			end_value = fraction,
		}
		bar_animations[name] = anim_data
	else
		bar_animations[name] = nil
	end

	stored_fractions[name] = fraction

	return animate
end

local current_fraction_temp_table = {}

HudBarLogic._update_bar_animations = function (self, dt, t)
	local bar_animations = self._bar_animations
	local update_order = self._update_order
	local stored_fractions = self._stored_fractions
	local update = false

	table.clear(current_fraction_temp_table)

	for i = 1, #update_order do
		local name = update_order[i]
		local anim_data = bar_animations[name]

		if anim_data then
			local fraction, complete = self:_update_bar_animation(anim_data, dt)

			if complete then
				bar_animations[name] = nil
			end

			current_fraction_temp_table[i] = fraction
			update = true
		else
			current_fraction_temp_table[i] = stored_fractions[name]
		end
	end

	if self._update_bars or update then
		self:_set_animated_fractions(unpack(current_fraction_temp_table))

		self._update_bars = nil
	elseif not self._fading and not self._fade_delay_start_time then
		self._fading = true
		self._fade_delay_start_time = t + self._settings.alpha_fade_delay
	end
end

HudBarLogic._reset_bar_alpha = function (self)
	self:_set_alpha(255)

	self._fade_delay_start_time = nil
	self._alpha_fade_time = nil
	self._fading = false
end

HudBarLogic._update_bar_alpha = function (self, dt, t)
	local fade_delay_start_time = self._fade_delay_start_time

	if fade_delay_start_time and fade_delay_start_time <= t then
		local settings = self._settings
		local alpha_fade_duration = settings.alpha_fade_duration
		local alpha_fade_time = self._alpha_fade_time or 0
		local fade_progress = math.clamp(alpha_fade_time / alpha_fade_duration, 0, 1)
		local complete = fade_progress >= 1

		if complete then
			self._alpha_fade_time = nil
			self._fade_delay_start_time = nil
		else
			self._alpha_fade_time = alpha_fade_time + dt
		end

		local alpha_fade_min_value = settings.alpha_fade_min_value
		local alpha = alpha_fade_min_value + (255 - alpha_fade_min_value) * (1 - fade_progress)

		self:_set_alpha(alpha)
	end
end

HudBarLogic._set_alpha = function (self, alpha)
	local alpha_fraction = alpha / 255

	self._alpha_multiplier = alpha_fraction
end

HudBarLogic._update_bar_animation = function (self, anim_data, dt)
	local time = anim_data.time
	local duration = anim_data.duration
	local progress = math.min(time / duration, 1)
	local start_value = anim_data.start_value
	local end_value = anim_data.end_value
	local fraction

	if start_value < end_value then
		fraction = start_value + (end_value - start_value) * progress
	else
		fraction = start_value - (start_value - end_value) * progress
	end

	anim_data.time = time + dt
	anim_data.fraction = fraction

	local complete = progress == 1

	return fraction, complete
end

HudBarLogic.alpha_multiplier = function (self)
	return self._alpha_multiplier
end

HudBarLogic.animated_fractions = function (self)
	return self._bar_fraction, self._bar_max_fraction
end

HudBarLogic._set_animated_fractions = function (self, bar_fraction, bar_max_fraction)
	self._bar_fraction = bar_fraction
	self._bar_max_fraction = bar_max_fraction
end

return HudBarLogic
