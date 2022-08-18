local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local EXTERNAL_PROPERTIES = {}
local LOOPING_SOUND_ALIAS = "melee_idling"
local SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS = "weapon_special_loop"
local ChainWeaponEffects = class("ChainWeaponEffects")

ChainWeaponEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	self._is_husk = is_husk
	self._slot = slot
	self._is_server = context.is_server
	self._is_local_unit = context.is_local_unit
	self._weapon_template = weapon_template
	self._wwise_world = context.wwise_world
	self._first_person_unit = context.first_person_unit
	self._equipment_component = context.equipment_component
	local owner_unit = context.owner_unit
	local fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	local engine_fx_source_name = fx_sources._engine
	local weapon_special_fx_source_name = fx_sources._special_active
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")

	if not is_husk then
		local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(LOOPING_SOUND_ALIAS)
		self._melee_idling_looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)
		self._weapon_special_effect_component = unit_data_extension:read_component(SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS)
	end

	local chain_speed_settings = weapon_template.chain_speed_settings
	self._chain_speed_settings = chain_speed_settings
	self._fx_extension = fx_extension
	self._engine_fx_source_name = engine_fx_source_name
	self._weapon_special_fx_source_name = weapon_special_fx_source_name
	self._intensity = 0
	self._special_active_start_t = nil
	self._special_active_end_t = nil
end

ChainWeaponEffects.destroy = function (self)
	if self._is_husk then
		return
	end

	if self._melee_idling_looping_sound_component.is_playing then
		self._fx_extension:stop_looping_wwise_event(LOOPING_SOUND_ALIAS)
	end

	if self._weapon_special_effect_component.is_playing then
		self._fx_extension:stop_looping_particles(SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS, false)
	end
end

ChainWeaponEffects.wield = function (self)
	if self._is_husk then
		return
	end

	if not self._melee_idling_looping_sound_component.is_playing then
		self._fx_extension:trigger_looping_wwise_event(LOOPING_SOUND_ALIAS, self._engine_fx_source_name)
	end
end

ChainWeaponEffects.unwield = function (self)
	if self._is_husk then
		return
	end

	if self._melee_idling_looping_sound_component.is_playing then
		self._fx_extension:stop_looping_wwise_event(LOOPING_SOUND_ALIAS)
	end

	if self._weapon_special_effect_component.is_playing then
		self._fx_extension:stop_looping_particles(SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS, false)
	end
end

ChainWeaponEffects.fixed_update = function (self, unit, dt, t, frame)
	local special_active = self._inventory_slot_component.special_active
	local particles_spawned = self._weapon_special_effect_component.is_playing

	if special_active and not particles_spawned then
		self._fx_extension:spawn_looping_particles(SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS, self._weapon_special_fx_source_name, EXTERNAL_PROPERTIES)
	elseif not special_active and particles_spawned then
		self._fx_extension:stop_looping_particles(SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS, false)
	end
end

ChainWeaponEffects.update = function (self, unit, dt, t)
	local engine_source = self._fx_extension:sound_source(self._engine_fx_source_name)
	local wwise_world = self._wwise_world
	local inventory_slot_component = self._inventory_slot_component
	local first_person_unit = self._first_person_unit
	local action_sweep_component = self._action_sweep_component
	local is_sawing = action_sweep_component.is_sticky
	local special_active = inventory_slot_component.special_active
	local base_intensity = inventory_slot_component.powered_weapon_intensity or 0

	if base_intensity > 0 then
		base_intensity = math.max(base_intensity, math.random() * 0.2)
	end

	local speed_settings = self._chain_speed_settings
	local intensity = nil

	if is_sawing then
		intensity = 1 - math.random() * 0.2
	elseif special_active then
		self._special_active_end_t = nil
		local special_active_start_t = self._special_active_start_t

		if not special_active_start_t then
			self._special_active_start_t = t
			self._start_intensity = self._intensity
			special_active_start_t = t
		end

		local time_until_max_throttle = speed_settings.time_until_max_throttle
		local time_since_start = t - special_active_start_t
		local special_active_t = math.min(time_since_start, time_until_max_throttle) / time_until_max_throttle
		intensity = math.lerp(base_intensity, 1, special_active_t)
	else
		self._special_active_start_t = nil
		local special_active_end_t = self._special_active_end_t

		if not special_active_end_t then
			self._special_active_end_t = t
			special_active_end_t = t
		end

		local time_until_min_throttle = speed_settings.time_until_min_throttle
		local time_since_end = t - special_active_end_t
		local special_active_t = math.min(time_since_end, time_until_min_throttle) / time_until_min_throttle
		intensity = math.lerp(self._intensity, base_intensity, special_active_t)
	end

	local intensity_epsilon = speed_settings.intensity_epsilon
	local intensity_delta = math.abs(self._intensity - intensity)

	if intensity_epsilon < intensity_delta then
		self._intensity = intensity

		WwiseWorld.set_source_parameter(wwise_world, engine_source, "combat_chainsword_throttle", intensity)

		local anim_variable = Unit.animation_find_variable(first_person_unit, "throttle")

		if anim_variable then
			Unit.animation_set_variable(first_person_unit, anim_variable, intensity)
		end

		local animation = speed_settings.animation
		local anim_min = animation.min
		local anim_max = animation.max
		local anim_speed = math.lerp(anim_min, anim_max, intensity)

		self._equipment_component.send_component_event(self._slot, "set_speed", anim_speed)
	end

	local resistance = (is_sawing and 1 - math.random() * 0.1) or 0

	WwiseWorld.set_source_parameter(wwise_world, engine_source, "combat_chainsword_cut", resistance)
end

ChainWeaponEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

return ChainWeaponEffects
