-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_weapon_effects.lua

require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/melee_idling_effects")

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local _vfx_external_properties = {}
local _sfx_external_properties = {}
local ChainWeaponEffects = class("ChainWeaponEffects", "MeleeIdlingEffects")
local SPECIAL_ACTIVE_LOOPING_VFX_ALIAS = "weapon_special_loop"
local SPECIAL_OFF_SOUND_ALIAS = "weapon_special_end"
local INTENSITY_DECAY_SPEED = 1

ChainWeaponEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk

	self._is_husk = is_husk
	self._slot = slot
	self._is_server = context.is_server
	self._is_local_unit = context.is_local_unit
	self._weapon_template = weapon_template
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._first_person_unit = context.first_person_unit
	self._equipment_component = context.equipment_component
	self._weapon_actions = weapon_template.actions

	local owner_unit = context.owner_unit
	local fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	local melee_idling_fx_source_name = fx_sources._melee_idling
	local special_active_fx_source_name = fx_sources._special_active
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._visual_loadout_extension = context.visual_loadout_extension

	local chain_speed_template = weapon_template.chain_speed_template

	self._chain_speed_template = chain_speed_template
	self._fx_extension = fx_extension
	self._melee_idling_fx_source_name = melee_idling_fx_source_name
	self._special_active_fx_source_name = special_active_fx_source_name
	self._intensity = 0
	self._base_intensity = 0
	self._special_active_start_t = nil
	self._special_active_end_t = nil
	self._force_update = true

	ChainWeaponEffects.super.init(self, context, slot, weapon_template, fx_sources)
end

ChainWeaponEffects.destroy = function (self)
	local wwise_world = self._wwise_world
	local melee_idling_source = self._fx_extension:sound_source(self._melee_idling_fx_source_name)

	WwiseWorld.set_source_parameter(wwise_world, melee_idling_source, "combat_chainsword_throttle", 0)
	WwiseWorld.set_source_parameter(wwise_world, melee_idling_source, "combat_chainsword_cut", 0)
	self:_stop_vfx_loop(true)
	ChainWeaponEffects.super.destroy(self)
end

ChainWeaponEffects.wield = function (self)
	local wwise_world = self._wwise_world
	local melee_idling_source = self._fx_extension:sound_source(self._melee_idling_fx_source_name)

	WwiseWorld.set_source_parameter(wwise_world, melee_idling_source, "combat_chainsword_throttle", 0)
	WwiseWorld.set_source_parameter(wwise_world, melee_idling_source, "combat_chainsword_cut", 0)
	ChainWeaponEffects.super.wield(self)
end

ChainWeaponEffects.unwield = function (self)
	local wwise_world = self._wwise_world
	local melee_idling_source = self._fx_extension:sound_source(self._melee_idling_fx_source_name)

	WwiseWorld.set_source_parameter(wwise_world, melee_idling_source, "combat_chainsword_throttle", 0)
	WwiseWorld.set_source_parameter(wwise_world, melee_idling_source, "combat_chainsword_cut", 0)

	if self._inventory_slot_component.special_active then
		self:_play_single_sfx(SPECIAL_OFF_SOUND_ALIAS, self._special_active_fx_source_name)
	end

	self:_stop_vfx_loop(true)
	ChainWeaponEffects.super.unwield(self)
end

ChainWeaponEffects.fixed_update = function (self, unit, dt, t, frame)
	ChainWeaponEffects.super.fixed_update(self, unit, dt, t, frame)
end

ChainWeaponEffects.update = function (self, unit, dt, t)
	self:_update_active()
	self:_update_base_intensity(dt, t)
	self:_update_intensity(dt, t)
	ChainWeaponEffects.super.update(self, unit, dt, t)
end

ChainWeaponEffects.update_first_person_mode = function (self, first_person_mode)
	local wwise_world = self._wwise_world
	local melee_idling_source = self._fx_extension:sound_source(self._melee_idling_fx_source_name)

	WwiseWorld.set_source_parameter(wwise_world, melee_idling_source, "combat_chainsword_throttle", 0)
	WwiseWorld.set_source_parameter(wwise_world, melee_idling_source, "combat_chainsword_cut", 0)
	ChainWeaponEffects.super.update_first_person_mode(self, first_person_mode)
end

ChainWeaponEffects._play_single_sfx = function (self, sound_alias, fx_source_name)
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local resolved, event_name, has_husk_events = self._visual_loadout_extension:resolve_gear_sound(sound_alias, _sfx_external_properties)

	if resolved then
		local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

		if has_husk_events and should_play_husk_effect then
			event_name = event_name .. "_husk"
		end

		WwiseWorld.trigger_resource_event(self._wwise_world, event_name, sfx_source_id)
	end
end

ChainWeaponEffects._update_active = function (self)
	local special_active = self._inventory_slot_component.special_active
	local current_effect_id = self._looping_effect_id
	local should_start_vfx = not current_effect_id and special_active
	local should_stop_vfx = current_effect_id and not special_active

	if should_start_vfx then
		self:_start_vfx_loop()
	elseif should_stop_vfx then
		self:_stop_vfx_loop(false)
		self:_play_single_sfx(SPECIAL_OFF_SOUND_ALIAS, self._special_active_fx_source_name)
	end
end

ChainWeaponEffects._update_base_intensity = function (self, dt, t)
	local weapon_action_component = self._weapon_action_component
	local current_action_name = weapon_action_component.current_action_name
	local action_settings = self._weapon_actions[current_action_name]
	local powered_weapon_intensity = action_settings and action_settings.powered_weapon_intensity
	local intensity

	if powered_weapon_intensity then
		local start_t = weapon_action_component.start_t
		local action_t = t - start_t
		local start_mod = powered_weapon_intensity.start_intensity
		local p1, p2 = start_mod, 1
		local segment_progress = 0

		for i = 1, #powered_weapon_intensity do
			local segment = powered_weapon_intensity[i]
			local segment_t = segment.t

			if action_t <= segment_t then
				p2 = segment.intensity
				segment_progress = segment_t == 0 and 1 or action_t / segment_t

				break
			else
				local segment_intensity = segment.intensity

				p1 = segment_intensity
				p2 = segment_intensity
			end
		end

		intensity = math.lerp(p1, p2, segment_progress)
	else
		local current_intensity = self._base_intensity

		intensity = math.max(current_intensity - INTENSITY_DECAY_SPEED * dt, 0)
	end

	self._base_intensity = intensity
end

ChainWeaponEffects._update_intensity = function (self, dt, t)
	local melee_idling_source, wwise_world = self._fx_extension:sound_source(self._melee_idling_fx_source_name), self._wwise_world
	local inventory_slot_component = self._inventory_slot_component
	local first_person_unit = self._first_person_unit
	local action_sweep_component = self._action_sweep_component
	local speed_settings = self._chain_speed_template
	local max_intensity = speed_settings.max_intensity
	local intensity_variation = speed_settings.intensity_variation
	local is_sawing = action_sweep_component.is_sticky
	local special_active = inventory_slot_component.special_active
	local base_intensity = self._base_intensity or 0

	if base_intensity > 0 then
		local variation = special_active and intensity_variation.activated or intensity_variation.idle

		base_intensity = math.max(base_intensity, math.random() * variation)
	end

	local intensity

	if is_sawing then
		local max, variation

		if special_active then
			max = max_intensity.activated_sawing
			variation = intensity_variation.activated_sawing
		else
			max = max_intensity.sawing
			variation = intensity_variation.sawing
		end

		intensity = max - math.random() * variation
	elseif special_active then
		self._special_active_end_t = nil

		local special_active_start_t = self._special_active_start_t

		if not special_active_start_t then
			self._special_active_start_t = t
			special_active_start_t = t
		end

		local time_until_max_throttle = speed_settings.time_until_max_throttle
		local time_since_start = t - special_active_start_t
		local special_active_t = math.min(time_since_start, time_until_max_throttle) / time_until_max_throttle

		intensity = math.lerp(base_intensity, 1, special_active_t)
		intensity = intensity * max_intensity.activated
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

	intensity = math.clamp01(intensity)

	local intensity_epsilon = speed_settings.intensity_epsilon
	local intensity_delta = math.abs(self._intensity - intensity)

	if intensity_epsilon < intensity_delta or self._force_update then
		self._intensity = intensity

		WwiseWorld.set_source_parameter(wwise_world, melee_idling_source, "combat_chainsword_throttle", intensity)

		local anim_variable = Unit.animation_find_variable(first_person_unit, "throttle")

		if anim_variable then
			Unit.animation_set_variable(first_person_unit, anim_variable, intensity)
		end

		local animation = speed_settings.animation
		local anim_min, anim_max = animation.min, animation.max
		local anim_speed = math.lerp(anim_min, anim_max, intensity)

		self._equipment_component.send_component_event(self._slot, "set_speed", anim_speed)

		self._force_update = false
	end

	if IS_PLAYSTATION and self._is_local_unit then
		local vibration_intensity = speed_settings.haptic_vibration_intensity
		local frequency = math.lerp(vibration_intensity.min, vibration_intensity.max, intensity)

		Managers.input.haptic_trigger_effects:trigger_vibration(frequency)
	end

	local resistance = is_sawing and 1 - math.random() * 0.1 or 0

	WwiseWorld.set_source_parameter(wwise_world, melee_idling_source, "combat_chainsword_cut", resistance)
end

ChainWeaponEffects._start_vfx_loop = function (self)
	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(SPECIAL_ACTIVE_LOOPING_VFX_ALIAS, _vfx_external_properties)

	if resolved then
		local world = self._world
		local new_effect_id = World.create_particles(world, effect_name, Vector3.zero())
		local vfx_link_unit, vfx_link_node = self._fx_extension:vfx_spawner_unit_and_node(self._melee_idling_fx_source_name)

		World.link_particles(world, new_effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

		self._looping_effect_id = new_effect_id
	end
end

ChainWeaponEffects._stop_vfx_loop = function (self, destroy)
	local current_effect_id = self._looping_effect_id

	if current_effect_id then
		if destroy then
			World.destroy_particles(self._world, current_effect_id)
		else
			World.stop_spawning_particles(self._world, current_effect_id)
		end
	end

	self._looping_effect_id = nil
end

implements(ChainWeaponEffects, WieldableSlotScriptInterface)

return ChainWeaponEffects
