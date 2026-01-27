-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/power_weapon_charges_effects.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local PowerWeaponChargesEffects = class("PowerWeaponChargesEffects")
local THRESHOLD_VFX_ALIAS = "weapon_special_charges"
local THRESHOLD_SFX_ALIAS = "weapon_special_charges"
local THRESHOLD_FX_SOURCE = "_special_active"
local STATE = table.enum("on_cooldown", "charges_available", "activated")
local EFFECTS_TYPES = table.enum("on_cooldown", "charges_available")
local NON_ACTIVATED_VFX_LOOP = "power_weapon_charges_loop"
local NON_ACTIVATED_SFX_LOOP = "power_weapon_charges_loop"
local _sfx_external_properties = {}
local _vfx_external_properties = {}

PowerWeaponChargesEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit

	if GameParameters.destroy_unmanaged_particles then
		self._particle_group_id = context.player_particle_group_id
	end

	local unit_data_extension = context.unit_data_extension

	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._fx_sources = fx_sources
	self._state = STATE.charges_available
	self._current_state = nil
	self._current_num_charges = self._inventory_slot_component.num_special_charges
	self._looping_effect_ids = {}
	self._looping_playing_ids = {}
	self._looping_stop_event_names = {}
end

PowerWeaponChargesEffects.destroy = function (self)
	self:_stop_looping_effect(EFFECTS_TYPES.on_cooldown, true)
	self:_stop_looping_effect(EFFECTS_TYPES.charges_available, true)
end

PowerWeaponChargesEffects.wield = function (self)
	self._current_num_charges = self._inventory_slot_component.num_special_charges
end

PowerWeaponChargesEffects.unwield = function (self)
	self._state = nil
	self._current_state = nil

	self:_stop_looping_effect(EFFECTS_TYPES.on_cooldown, false)
	self:_stop_looping_effect(EFFECTS_TYPES.charges_available, false)
end

PowerWeaponChargesEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

PowerWeaponChargesEffects.update = function (self, unit, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local num_special_charges = inventory_slot_component.num_special_charges
	local special_active = inventory_slot_component.special_active
	local state = self._state
	local current_state = self._current_state
	local current_num_charges = self._current_num_charges

	if special_active then
		state = STATE.activated
	elseif num_special_charges == 0 then
		state = STATE.on_cooldown
	elseif num_special_charges > 0 then
		state = STATE.charges_available
	end

	if not state then
		return
	end

	local state_changed = current_state ~= state

	self:_update_looping_effects(state, state_changed)
	self:_update_threshold_effects(state, state_changed, num_special_charges, current_num_charges)

	self._current_state = state
	self._current_num_charges = num_special_charges
end

PowerWeaponChargesEffects._update_looping_effects = function (self, state, state_changed)
	if not state_changed then
		return
	end

	if state == STATE.activated then
		self:_stop_looping_effect(EFFECTS_TYPES.on_cooldown, false)
		self:_stop_looping_effect(EFFECTS_TYPES.charges_available, false)
	elseif state == STATE.on_cooldown then
		self:_stop_looping_effect(EFFECTS_TYPES.charges_available, false)
		self:_start_looping_effect(EFFECTS_TYPES.on_cooldown)
	elseif state == STATE.charges_available then
		self:_stop_looping_effect(EFFECTS_TYPES.on_cooldown, false)
		self:_start_looping_effect(EFFECTS_TYPES.charges_available)
	end
end

PowerWeaponChargesEffects._update_threshold_effects = function (self, state, state_changed, num_special_charges, current_num_charges)
	local visual_loadout_extension = self._visual_loadout_extension
	local world = self._world

	if num_special_charges ~= current_num_charges and current_num_charges < num_special_charges then
		local resolved_vfx, effect_name = visual_loadout_extension:resolve_gear_particle(THRESHOLD_VFX_ALIAS, _vfx_external_properties)

		if resolved_vfx then
			local fx_source_name = self._fx_sources[THRESHOLD_FX_SOURCE]
			local vfx_link_unit, vfx_link_node = self._fx_extension:vfx_spawner_unit_and_node(fx_source_name)
			local new_effect_id = World.create_particles(world, effect_name, Vector3.zero(), nil, nil, self._particle_group_id)

			World.link_particles(world, new_effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")
		end

		local resolved_sfx, event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(THRESHOLD_SFX_ALIAS, _sfx_external_properties)

		if resolved_sfx then
			local wwise_world = self._wwise_world
			local fx_source_name = self._fx_sources[THRESHOLD_FX_SOURCE]
			local sfx_source_id = self._fx_extension:sound_source(fx_source_name)
			local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

			event_name = should_play_husk_effect and has_husk_events and event_name .. "_husk" or event_name

			WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)
		end
	end
end

PowerWeaponChargesEffects._start_looping_effect = function (self, effect_type)
	self:_start_sfx_loop(effect_type)
	self:_start_vfx_loop(effect_type)
end

PowerWeaponChargesEffects._stop_looping_effect = function (self, effect_type, force_stop)
	self:_stop_sfx_loop(effect_type)
	self:_stop_vfx_loop(effect_type, false)
end

PowerWeaponChargesEffects._start_sfx_loop = function (self, effect_type)
	local wwise_world = self._wwise_world
	local fx_source_name = self._fx_sources[THRESHOLD_FX_SOURCE]
	local sfx_source_id = self._fx_extension:sound_source(fx_source_name)
	local visual_loadout_extension = self._visual_loadout_extension
	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

	if effect_type == EFFECTS_TYPES.on_cooldown and should_play_husk_effect then
		return
	end

	_sfx_external_properties.state = effect_type

	local resolved, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(NON_ACTIVATED_SFX_LOOP, should_play_husk_effect, _sfx_external_properties)

	if resolved then
		local new_playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)

		self._looping_playing_ids[effect_type] = new_playing_id

		if resolved_stop then
			self._looping_stop_event_names[effect_type] = stop_event_name
		end
	end
end

PowerWeaponChargesEffects._stop_sfx_loop = function (self, effect_type)
	local wwise_world = self._wwise_world
	local fx_source_name = self._fx_sources[THRESHOLD_FX_SOURCE]
	local sfx_source_id = self._fx_extension:sound_source(fx_source_name)
	local current_playing_id = self._looping_playing_ids[effect_type]
	local stop_event_name = self._looping_stop_event_names[effect_type]

	if stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, sfx_source_id)
	else
		WwiseWorld.stop_event(wwise_world, current_playing_id)
	end

	self._looping_playing_ids[effect_type] = nil
	self._looping_stop_event_names[effect_type] = nil
end

PowerWeaponChargesEffects._start_vfx_loop = function (self, effect_type)
	local visual_loadout_extension = self._visual_loadout_extension
	local fx_extension = self._fx_extension
	local looping_effect_id = self._looping_effect_ids[effect_type]

	if looping_effect_id then
		return
	end

	_vfx_external_properties.state = effect_type

	local resolved, effect_name = visual_loadout_extension:resolve_gear_particle(NON_ACTIVATED_VFX_LOOP, _vfx_external_properties)

	if resolved then
		local world = self._world
		local fx_source_name = self._fx_sources[THRESHOLD_FX_SOURCE]
		local vfx_link_unit, vfx_link_node = fx_extension:vfx_spawner_unit_and_node(fx_source_name)
		local new_effect_id = fx_extension:spawn_particles_local(effect_name, Vector3.zero())

		World.link_particles(world, new_effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

		self._looping_effect_ids[effect_type] = new_effect_id
	end
end

PowerWeaponChargesEffects._stop_vfx_loop = function (self, effect_type, force_stop)
	local looping_effect_id = self._looping_effect_ids[effect_type]

	if not looping_effect_id then
		return
	end

	if force_stop then
		World.destroy_particles(self._world, looping_effect_id)
	else
		World.stop_spawning_particles(self._world, looping_effect_id)
	end

	self._looping_effect_ids[effect_type] = nil
end

PowerWeaponChargesEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

implements(PowerWeaponChargesEffects, WieldableSlotScriptInterface)

return PowerWeaponChargesEffects
