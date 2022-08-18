local Component = require("scripts/utilities/component")
local FlashlightTemplates = require("scripts/settings/equipment/flashlight_templates")
local LightFlickerTemplates = require("scripts/settings/equipment/light_flicker_templates")
local PerlinNoise = require("scripts/utilities/perlin_noise")
local Flashlight = class("Flashlight")
local _get_components, _toggle_light, _disable_light, _enable_light, _set_template, _set_intensity, _trigger_wwise_event = nil

Flashlight.init = function (self, context, slot, weapon_template, fx_sources)
	self._is_server = context.is_server
	self._is_local_unit = context.is_local_unit
	self._is_husk = context.is_husk
	local owner_unit = context.owner_unit
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local slot_name = slot.name
	self._inventory_slot_component = unit_data_extension:read_component(slot_name)
	self._seed = math.random_seed()
	self._first_person_mode = false
	self._enabled = false
	self._next_check_at_t = 0
	self._flashlight_template = FlashlightTemplates.default
	self._flicker_template = LightFlickerTemplates.default
	self._flashlights_1p = {}
	self._flashlights_3p = {}

	_get_components(self._flashlights_1p, slot.attachments_1p)
	_get_components(self._flashlights_3p, slot.attachments_3p)
	_disable_light(self._flashlights_1p)
	_disable_light(self._flashlights_3p)
	_set_template(self._flashlights_1p, self._flashlight_template)
	_set_template(self._flashlights_3p, self._flashlight_template)
end

Flashlight.fixed_update = function (self, unit, dt, t, frame)
	return
end

Flashlight.update_first_person_mode = function (self, first_person_mode)
	if self._enabled then
		if first_person_mode then
			_enable_light(self._flashlights_1p)
			_disable_light(self._flashlights_3p)
		else
			_disable_light(self._flashlights_1p)
			_enable_light(self._flashlights_3p)
		end
	else
		_disable_light(self._flashlights_1p)
		_disable_light(self._flashlights_3p)
	end

	self._first_person_mode = first_person_mode
end

Flashlight.update = function (self, unit, dt, t)
	local is_special_active = self._inventory_slot_component.special_active

	if is_special_active and not self._enabled then
		if self._first_person_mode then
			_enable_light(self._flashlights_1p)
			_disable_light(self._flashlights_3p)
		else
			_disable_light(self._flashlights_1p)
			_enable_light(self._flashlights_3p)
		end

		if self._is_local_unit then
			_trigger_wwise_event("wwise/events/player/play_foley_gear_flashlight_on", self._flashlights_1p, self._fx_extension)
		end

		self._enabled = true
	elseif not is_special_active and self._enabled then
		if self._first_person_mode then
			_disable_light(self._flashlights_1p)
			_disable_light(self._flashlights_3p)
		else
			_disable_light(self._flashlights_1p)
			_disable_light(self._flashlights_3p)
		end

		if self._is_local_unit then
			_trigger_wwise_event("wwise/events/player/play_foley_gear_flashlight_off", self._flashlights_1p, self._fx_extension)
		end

		self._enabled = false
	end

	if self._enabled then
		self:_update_flicker(t)
	end
end

Flashlight._update_flicker = function (self, t)
	local template = self._flicker_template

	if not self._flickering and self._next_check_at_t <= t then
		local chance = template.chance
		local roll = math.random()

		if roll <= chance then
			self._flickering = true
			self._flicker_start_t = t

			if self._is_local_unit then
				_trigger_wwise_event("wwise/events/player/play_foley_gear_flashlight_flicker", self._flashlights_1p, self._fx_extension)
			end

			local min = template.duration.min
			local max = template.duration.max
			self._flicker_duration = math.random() * (max - min) + min
			self._seed = math.random_seed()
		else
			local min = template.interval.min
			local max = template.interval.max
			self._next_check_at_t = t + math.random(min, max)

			return
		end
	end

	if self._flickering then
		local flicker_duration = self._flicker_duration
		local current_flicker_time = t - self._flicker_start_t
		local flicker_end_time = self._flicker_start_t + self._flicker_duration
		local progress = current_flicker_time / flicker_duration
		local intensity_scale = nil

		if progress >= 1 then
			self._flickering = false
			local min = template.interval.min
			local max = template.interval.max
			self._next_check_at_t = t + math.random(min, max)
			intensity_scale = 1
		else
			local fade_out = template.fade_out
			local min_octave_percentage = template.min_octave_percentage
			local fade_progress = (fade_out and math.max(1 - progress, min_octave_percentage)) or 1
			local frequence_multiplier = template.frequence_multiplier
			local persistance = template.persistance
			local octaves = template.octaves
			intensity_scale = 1 - PerlinNoise.calculate_perlin_value((flicker_end_time - t) * frequence_multiplier, persistance, octaves * fade_progress, self._seed)
		end

		_set_intensity(self._flashlights_1p, self._flashlight_template, intensity_scale)
		_set_intensity(self._flashlights_3p, self._flashlight_template, intensity_scale)
	end
end

Flashlight.wield = function (self)
	return
end

Flashlight.unwield = function (self)
	return
end

Flashlight.destroy = function (self)
	return
end

Flashlight.flashlight_enabled = function (self)
	return self._enabled
end

function _get_components(components, attachments)
	local num_attachments = #attachments

	for i = 1, num_attachments, 1 do
		local attachment_unit = attachments[i]
		local flash_light_components = Component.get_components_by_name(attachment_unit, "WeaponFlashlight")

		for _, flash_light_component in ipairs(flash_light_components) do
			components[#components + 1] = {
				unit = attachment_unit,
				component = flash_light_component
			}
		end
	end
end

function _toggle_light(flashlights, was_enabled)
	for i = 1, #flashlights, 1 do
		local flashlight = flashlights[i]

		flashlight.component:toggle(flashlight.unit, was_enabled)
	end
end

function _disable_light(flashlights)
	for i = 1, #flashlights, 1 do
		local flashlight = flashlights[i]

		flashlight.component:disable(flashlight.unit)
	end
end

function _enable_light(flashlights)
	for i = 1, #flashlights, 1 do
		local flashlight = flashlights[i]

		flashlight.component:enable(flashlight.unit)
	end
end

function _set_template(flashlights, template)
	for i = 1, #flashlights, 1 do
		local flashlight = flashlights[i]

		flashlight.component:set_template(flashlight.unit, template)
	end
end

function _set_intensity(flashlights, template, scale)
	for i = 1, #flashlights, 1 do
		local flashlight = flashlights[i]

		flashlight.component:set_intensity(flashlight.unit, template, scale)
	end
end

function _trigger_wwise_event(wwise_resource, flashlights, fx_extension)
	for i = 1, #flashlights, 1 do
		local flashlight = flashlights[i]

		fx_extension:trigger_wwise_event(wwise_resource, false, flashlight.unit, 1)
	end
end

return Flashlight
