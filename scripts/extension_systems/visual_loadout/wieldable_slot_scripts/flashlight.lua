-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flashlight.lua

local Component = require("scripts/utilities/component")
local FlashlightTemplates = require("scripts/settings/equipment/flashlight_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionPerception = require("scripts/utilities/minion_perception")
local PerlinNoise = require("scripts/utilities/perlin_noise")
local Flashlight = class("Flashlight")
local _get_components, _disable_light, _enable_light, _set_template, _set_intensity, _falloff_position_rotation, _trigger_wwise_event, _trigger_aggro
local AGGRO_CHECK_INTERVAL = 0.5
local DEFAULT_TEST_AGAINST = "both"
local DEFAULT_COLLISION_FILTER = "filter_player_character_shooting_raycast"
local REWIND_MS = 0
local MAX_HITS = 100
local INDEX_POSITION = 1
local INDEX_DISTANCE = 2
local INDEX_ACTOR = 4
local HANDLED_UNITS = {}
local ALERT_PERCENTAGE = 0.4
local AGGRO_PERCENTAGE = 0.3

Flashlight.init = function (self, context, slot, weapon_template, fx_sources)
	self._world = context.world
	self._physics_world = context.physics_world
	self._is_server = context.is_server
	self._is_local_unit = context.is_local_unit
	self._is_husk = context.is_husk
	self._is_server = context.is_server

	local owner_unit = context.owner_unit

	self._owner_unit = owner_unit
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local slot_name = slot.name

	self._inventory_slot_component = unit_data_extension:read_component(slot_name)
	self._seed = math.random_seed()
	self._first_person_mode = false
	self._enabled = false
	self._next_check_at_t = 0

	local flashlight_template = weapon_template.flashlight_template or FlashlightTemplates.default

	self._light_settings = flashlight_template.light
	self._flicker_settings = flashlight_template.flicker
	self._flashlights_1p = {}
	self._flashlights_3p = {}
	self._last_aggro_time = 0

	_get_components(self._flashlights_1p, slot.attachments_1p)
	_get_components(self._flashlights_3p, slot.attachments_3p)
	_disable_light(self._flashlights_1p)
	_disable_light(self._flashlights_3p)
	_set_template(self._flashlights_1p, flashlight_template.light.first_person)
	_set_template(self._flashlights_3p, flashlight_template.light.third_person)
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

	local time_since_aggro = t - self._last_aggro_time
	local owner_unit = self._owner_unit

	if self._is_server and HEALTH_ALIVE[owner_unit] and self._enabled and time_since_aggro > AGGRO_CHECK_INTERVAL then
		_trigger_aggro(self._light_settings.first_person, self._flashlights_1p, self._physics_world, owner_unit)

		self._last_aggro_time = t
	end
end

Flashlight._update_flicker = function (self, t)
	local settings = self._flicker_settings

	if not self._flickering and t >= self._next_check_at_t then
		local chance = settings.chance
		local roll = math.random()

		if roll <= chance then
			self._flickering = true
			self._flicker_start_t = t

			if self._is_local_unit then
				_trigger_wwise_event("wwise/events/player/play_foley_gear_flashlight_flicker", self._flashlights_1p, self._fx_extension)
			end

			local duration = settings.duration
			local min = duration.min
			local max = duration.max

			self._flicker_duration = math.random() * (max - min) + min
			self._seed = math.random_seed()
		else
			local interval = settings.interval
			local min = interval.min
			local max = interval.max

			self._next_check_at_t = t + math.random(min, max)

			return
		end
	end

	if self._flickering then
		local flicker_duration = self._flicker_duration
		local current_flicker_time = t - self._flicker_start_t
		local flicker_end_time = self._flicker_start_t + self._flicker_duration
		local progress = current_flicker_time / flicker_duration
		local intensity_scale

		if progress >= 1 then
			self._flickering = false

			local interval = settings.interval
			local min = interval.min
			local max = interval.max

			self._next_check_at_t = t + math.random(min, max)
			intensity_scale = 1
		else
			local fade_out = settings.fade_out
			local min_octave_percentage = settings.min_octave_percentage
			local fade_progress = fade_out and math.max(1 - progress, min_octave_percentage) or 1
			local frequence_multiplier = settings.frequence_multiplier
			local persistance = settings.persistance
			local octaves = settings.octaves

			intensity_scale = 1 - PerlinNoise.calculate_perlin_value((flicker_end_time - t) * frequence_multiplier, persistance, octaves * fade_progress, self._seed)
		end

		_set_intensity(self._flashlights_1p, self._light_settings.first_person, intensity_scale)
		_set_intensity(self._flashlights_3p, self._light_settings.third_person, intensity_scale)
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

	for i = 1, num_attachments do
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

function _disable_light(flashlights)
	for i = 1, #flashlights do
		local flashlight = flashlights[i]

		flashlight.component:disable(flashlight.unit)
	end
end

function _enable_light(flashlights)
	for i = 1, #flashlights do
		local flashlight = flashlights[i]

		flashlight.component:enable(flashlight.unit)
	end
end

function _set_template(flashlights, template)
	for i = 1, #flashlights do
		local flashlight = flashlights[i]

		flashlight.component:set_template(flashlight.unit, template)
	end
end

function _set_intensity(flashlights, template, scale)
	for i = 1, #flashlights do
		local flashlight = flashlights[i]

		flashlight.component:set_intensity(flashlight.unit, template, scale)
	end
end

function _trigger_wwise_event(wwise_resource, flashlights, fx_extension)
	for i = 1, #flashlights do
		local flashlight = flashlights[i]

		fx_extension:trigger_wwise_event(wwise_resource, false, flashlight.unit, 1)
	end
end

function _falloff_position_rotation(template_1p, flashlights_1p)
	if #flashlights_1p > 0 then
		local flashlight = flashlights_1p[1]
		local distance = template_1p.falloff.far
		local position = Unit.world_position(flashlight.unit, 1)
		local rotation = Unit.world_rotation(flashlight.unit, 1)

		return distance, position, rotation
	end
end

local FLASHLIGHT_AGGRO_MUTATORS = {
	"mutator_darkness_los",
	"mutator_ventilation_purge_los"
}

function _trigger_aggro(template_1p, flashlights_1p, physics_world, owner_unit)
	local mutator_manager = Managers.state.mutator
	local has_flashlight_aggro = false

	for i = 1, #FLASHLIGHT_AGGRO_MUTATORS do
		if mutator_manager:mutator(FLASHLIGHT_AGGRO_MUTATORS[i]) then
			has_flashlight_aggro = true

			break
		end
	end

	if not has_flashlight_aggro then
		return
	end

	local falloff, position, rotation = _falloff_position_rotation(template_1p, flashlights_1p)

	if not falloff then
		return
	end

	local alerted_distance = falloff * ALERT_PERCENTAGE
	local aggro_distance = falloff * AGGRO_PERCENTAGE
	local check_rotation = rotation
	local check_direction = Quaternion.forward(check_rotation)
	local hits = PhysicsWorld.raycast(physics_world, position, check_direction, falloff, "all", "types", DEFAULT_TEST_AGAINST, "max_hits", MAX_HITS, "collision_filter", DEFAULT_COLLISION_FILTER, "rewind_ms", REWIND_MS)

	if not hits or #hits == 0 then
		return
	end

	local num_hits = #hits

	table.clear(HANDLED_UNITS)

	for index = 1, num_hits do
		repeat
			local hit = hits[index]
			local hit_distance = hit.distance or hit[INDEX_DISTANCE]
			local hit_actor = hit.actor or hit[INDEX_ACTOR]
			local hit_position = hit.position or hit[INDEX_POSITION]

			if alerted_distance < hit_distance then
				break
			end

			if not hit_actor then
				break
			end

			local hit_unit = Actor.unit(hit_actor)

			if hit_unit == owner_unit then
				break
			end

			if HANDLED_UNITS[hit_unit] then
				break
			end

			HANDLED_UNITS[hit_unit] = true

			if not HEALTH_ALIVE[hit_unit] then
				do break end
				break
			end

			local side_system = Managers.state.extension:system("side_system")
			local is_enemy = side_system:is_enemy(owner_unit, hit_unit)

			if is_enemy then
				local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
				local hit_afro = hit_zone_name_or_nil == HitZone.hit_zone_names.afro
				local perception_extension = ScriptUnit.extension(hit_unit, "perception_system")
				local aggro_state = perception_extension:aggro_state()
				local within_aggro_distance = hit_distance < aggro_distance

				if hit_afro and aggro_state ~= "alerted" then
					MinionPerception.attempt_alert(perception_extension, owner_unit)
				elseif within_aggro_distance and aggro_state ~= "aggroed" then
					MinionPerception.attempt_alert(perception_extension, owner_unit)
					MinionPerception.attempt_aggro(perception_extension)
				elseif aggro_state == "passive" then
					MinionPerception.attempt_alert(perception_extension, owner_unit)
				end

				local target_position = Unit.world_position(owner_unit, Unit.node(owner_unit, "enemy_aim_target_03"))

				perception_extension:set_last_los_position(owner_unit, target_position)
			end
		until true
	end
end

return Flashlight
