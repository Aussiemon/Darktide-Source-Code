local HudHealthBarLogic = class("HudHealthBarLogic")
local settings_list = {
	"duration_health",
	"health_animation_threshold",
	"duration_health_ghost",
	"alpha_fade_delay",
	"alpha_fade_duration",
	"alpha_fade_min_value",
	"animate_on_health_increase"
}

HudHealthBarLogic.init = function (self, settings)
	self:_verify_settings(settings)

	self._settings = settings
	self._bar_animations = {}
	self._update_order = {
		"health",
		"health_ghost",
		"health_max"
	}
	self._stored_fractions = {}

	for i = 1, #self._update_order do
		local name = self._update_order[i]
		self._stored_fractions[name] = 1
	end
end

HudHealthBarLogic._verify_settings = function (self, settings)
	for i = 1, #settings_list do
		local setting_name = settings_list[i]
	end
end

HudHealthBarLogic._sync_player_health = function (self, t, bar_progress, bar_max_progress)
	bar_max_progress = bar_max_progress or 1

	if bar_progress ~= self._bar_progress or bar_max_progress ~= self._bar_max_progress then
		local delta_progress = bar_progress - (self._bar_progress or 1)
		local delta_max_progress = bar_max_progress - (self._bar_max_progress or 1)
		self._bar_progress = bar_progress
		self._bar_max_progress = bar_max_progress
		local settings = self._settings
		local health_animation_threshold = settings.health_animation_threshold * bar_max_progress
		local should_animate_delta = health_animation_threshold < math.abs(delta_progress)
		local force_update = delta_progress < 0 or not should_animate_delta or not settings.animate_on_health_increase

		self:_set_bar_fraction(t, "health", bar_progress, delta_progress, settings.duration_health, force_update, settings.health_delay, settings.refresh_delay_on_override)
		self:_set_bar_fraction(t, "health_max", bar_max_progress, delta_max_progress, settings.duration_health, true, nil, false)

		local ghost_has_animation = self._bar_animations.health_ghost
		local should_update_ghost = should_animate_delta or not ghost_has_animation and delta_progress < 0

		if should_update_ghost then
			force_update = delta_progress > 0 or not should_animate_delta
			local ghost_duration = force_update and settings.duration_health or settings.duration_health_ghost
			local ghost_delay = settings.ghost_delay

			if not ghost_has_animation then
				self._stored_fractions.health_ghost = bar_progress - delta_progress
			end

			self:_set_bar_fraction(t, "health_ghost", bar_progress, delta_progress, ghost_duration, force_update, ghost_delay, settings.refresh_delay_on_override)
		end
	end
end

HudHealthBarLogic.update = function (self, dt, t, bar_progress, bar_max_progress)
	self._health_fraction = nil
	self._health_ghost_fraction = nil

	self:_sync_player_health(t, bar_progress, bar_max_progress)
	self:_update_bar_animations(dt, t)
	self:_update_bar_alpha(dt, t)
end

HudHealthBarLogic._set_bar_fraction = function (self, t, name, target_fraction, delta_fraction, total_duration, force_update, animation_delay, refresh_delay_on_override)
	self._update_bars = true

	self:_reset_bar_alpha()

	local stored_fractions = self._stored_fractions
	local current_fraction = stored_fractions[name]
	local bar_animations = self._bar_animations
	local anim_data = bar_animations[name]
	local total_difference = math.abs(current_fraction - target_fraction)
	local duration = total_difference * total_duration

	if anim_data then
		if force_update then
			anim_data.start_value = anim_data.start_value + delta_fraction
			anim_data.end_value = anim_data.end_value + delta_fraction
		else
			local delay = animation_delay or 0
			delay = refresh_delay_on_override and delay or math.max(anim_data.start_t + delay - t, 0)
			anim_data.duration = duration
			anim_data.delay = delay
			anim_data.start_t = t
			anim_data.start_value = current_fraction
			anim_data.end_value = anim_data.end_value + delta_fraction
		end
	elseif not force_update then
		anim_data = {
			name = name,
			duration = duration,
			start_value = current_fraction,
			end_value = target_fraction,
			start_t = t,
			delay = animation_delay or 0
		}
		bar_animations[name] = anim_data
	else
		stored_fractions[name] = target_fraction
	end
end

local current_fraction_temp_table = {}

HudHealthBarLogic._update_bar_animations = function (self, dt, t)
	local bar_animations = self._bar_animations
	local update_order = self._update_order
	local stored_fractions = self._stored_fractions
	local update = false

	table.clear(current_fraction_temp_table)

	for i = 1, #update_order do
		local name = update_order[i]
		local anim_data = bar_animations[name]

		if anim_data then
			local fraction, complete = self:_update_bar_animation(anim_data, dt, t)

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
		self:_set_animated_health_fractions(unpack(current_fraction_temp_table))

		self._update_bars = nil
	elseif not self._fading and not self._fade_delay_start_time then
		self._fading = true
		self._fade_delay_start_time = t + self._settings.alpha_fade_delay
	end
end

HudHealthBarLogic._reset_bar_alpha = function (self)
	self:_set_alpha(255)

	self._fade_delay_start_time = nil
	self._alpha_fade_time = nil
	self._fading = false
end

HudHealthBarLogic._update_bar_alpha = function (self, dt, t)
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

HudHealthBarLogic._set_alpha = function (self, alpha)
	local alpha_fraction = alpha / 255
	self._alpha_multiplier = alpha_fraction
end

HudHealthBarLogic._update_bar_animation = function (self, anim_data, dt, t)
	local duration = anim_data.duration
	local delay = anim_data.delay
	local start_t = anim_data.start_t + delay
	local end_t = start_t + duration
	local progress = nil

	if math.abs(end_t - start_t) > 0.0001 then
		progress = math.ilerp(start_t, end_t, t)
	elseif start_t <= t then
		progress = 1
	else
		progress = 0
	end

	local start_value = anim_data.start_value
	local end_value = anim_data.end_value
	local fraction = math.clamp01(start_value + (end_value - start_value) * progress)
	anim_data.fraction = fraction
	local stored_fractions = self._stored_fractions
	stored_fractions[anim_data.name] = fraction
	local complete = progress == 1

	return fraction, complete
end

HudHealthBarLogic.alpha_multiplier = function (self)
	return self._alpha_multiplier
end

HudHealthBarLogic.animated_health_fractions = function (self)
	return self._health_fraction, self._health_ghost_fraction, self._health_max_fraction
end

HudHealthBarLogic._set_animated_health_fractions = function (self, health_fraction, health_ghost_fraction, health_max_fraction)
	self._health_fraction = health_fraction
	self._health_ghost_fraction = health_ghost_fraction
	self._health_max_fraction = health_max_fraction
end

return HudHealthBarLogic
