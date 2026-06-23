-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wielded_idling_effects.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local WieldedIdlingEffects = class("WieldedIdlingEffects")
local LOOPING_SOUND_ALIAS = "equipped_item_passive_loop"
local LOOPING_PARTICLE_ALIAS = "equipped_item_passive"
local _sfx_external_properties = {}
local _vfx_external_properties = {}

WieldedIdlingEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension

	local sfx_source_name = fx_sources._wielded_idling_sfx or fx_sources._wielded_idling

	self._sfx_source_name = sfx_source_name

	local vfx_source_name = fx_sources._wielded_idling_vfx or fx_sources._wielded_idling

	self._vfx_source_name = vfx_source_name

	self:_init_looping_variables()
end

WieldedIdlingEffects._init_looping_variables = function (self)
	self._current_looping_playing_id = nil
	self._current_looping_stop_event_name = nil
	self._current_looping_effect_id = nil
end

WieldedIdlingEffects.destroy = function (self)
	self:_stop_sfx_loop(true)
	self:_stop_vfx_loop(true)
end

WieldedIdlingEffects.wield = function (self)
	self:_start_sfx_loop(LOOPING_SOUND_ALIAS)
	self:_start_vfx_loop(LOOPING_PARTICLE_ALIAS)
end

WieldedIdlingEffects.unwield = function (self)
	self:_stop_sfx_loop()
	self:_stop_vfx_loop()
end

WieldedIdlingEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

WieldedIdlingEffects.update = function (self, unit, dt, t)
	if not self:_looping_playing_id() then
		self:_start_sfx_loop(LOOPING_SOUND_ALIAS)
	end

	if not self:_looping_effect_id() then
		self:_start_vfx_loop(LOOPING_PARTICLE_ALIAS)
	end
end

WieldedIdlingEffects.update_first_person_mode = function (self, first_person_mode)
	if self._first_person_mode ~= first_person_mode then
		self:_stop_sfx_loop(true)
		self:_stop_vfx_loop(true)

		self._first_person_mode = first_person_mode
	end
end

WieldedIdlingEffects._start_sfx_loop = function (self, looping_sound_alias, optional_reference_attachment_name)
	local visual_loadout_extension = self._visual_loadout_extension
	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()
	local resolved, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(looping_sound_alias, should_play_husk_effect, _sfx_external_properties)

	if resolved and not self:_looping_playing_id(optional_reference_attachment_name) then
		local sfx_source_id = self._fx_extension:sound_source(self._sfx_source_name, optional_reference_attachment_name)
		local playing_id = WwiseWorld.trigger_resource_event(self._wwise_world, event_name, sfx_source_id)

		self:_set_looping_playing_id(playing_id, optional_reference_attachment_name)

		if resolved_stop then
			self:_set_looping_stop_event_name(stop_event_name, optional_reference_attachment_name)
		end
	end
end

WieldedIdlingEffects._stop_sfx_loop = function (self, force_stop, optional_reference_attachment_name)
	local looping_playing_id = self:_looping_playing_id(optional_reference_attachment_name)
	local looping_stop_event_name = self:_looping_stop_event_name(optional_reference_attachment_name)
	local sfx_source_id = self._fx_extension:sound_source(self._sfx_source_name, optional_reference_attachment_name)

	if not force_stop and looping_stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(self._wwise_world, looping_stop_event_name, sfx_source_id)
	elseif looping_playing_id then
		WwiseWorld.stop_event(self._wwise_world, looping_playing_id)
	end

	self:_set_looping_playing_id(nil, optional_reference_attachment_name)
	self:_set_looping_stop_event_name(nil, optional_reference_attachment_name)
end

WieldedIdlingEffects._start_vfx_loop = function (self, looping_particle_alias, optional_reference_attachment_name)
	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(looping_particle_alias, _vfx_external_properties)

	if resolved and not self:_looping_effect_id(optional_reference_attachment_name) then
		local world = self._world
		local fx_extension = self._fx_extension
		local effect_id = fx_extension:spawn_particles_local(effect_name, Vector3.zero())
		local vfx_link_unit, vfx_link_node = fx_extension:vfx_spawner_unit_and_node(self._vfx_source_name, optional_reference_attachment_name)

		World.link_particles(world, effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")
		self:_set_looping_effect_id(effect_id, optional_reference_attachment_name)
	end
end

WieldedIdlingEffects._stop_vfx_loop = function (self, force_stop, optional_reference_attachment_name)
	local looping_effect_id = self:_looping_effect_id(optional_reference_attachment_name)

	if looping_effect_id then
		if force_stop then
			World.destroy_particles(self._world, looping_effect_id)
		else
			World.stop_spawning_particles(self._world, looping_effect_id)
		end
	end

	self:_set_looping_effect_id(nil, optional_reference_attachment_name)
end

WieldedIdlingEffects._looping_playing_id = function (self, optional_reference_attachment_name)
	return self._current_looping_playing_id
end

WieldedIdlingEffects._looping_stop_event_name = function (self, optional_reference_attachment_name)
	return self._current_looping_stop_event_name
end

WieldedIdlingEffects._looping_effect_id = function (self, optional_reference_attachment_name)
	return self._current_looping_effect_id
end

WieldedIdlingEffects._set_looping_playing_id = function (self, looping_playing_id, optional_reference_attachment_name)
	self._current_looping_playing_id = looping_playing_id
end

WieldedIdlingEffects._set_looping_stop_event_name = function (self, looping_stop_event_name, optional_reference_attachment_name)
	self._current_looping_stop_event_name = looping_stop_event_name
end

WieldedIdlingEffects._set_looping_effect_id = function (self, looping_effect_id, optional_reference_attachment_name)
	self._current_looping_effect_id = looping_effect_id
end

implements(WieldedIdlingEffects, WieldableSlotScriptInterface)

return WieldedIdlingEffects
