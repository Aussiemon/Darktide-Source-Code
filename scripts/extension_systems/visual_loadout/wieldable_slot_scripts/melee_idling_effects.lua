-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/melee_idling_effects.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local MeleeIdlingEffects = class("MeleeIdlingEffects")
local LOOPING_SOUND_ALIAS = "equipped_item_passive_loop"
local LOOPING_PARTICLE_ALIAS = "equipped_item_passive"
local _sfx_external_properties = {}
local _vfx_external_properties = {}

MeleeIdlingEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension

	local fx_source_name = fx_sources._melee_idling

	self._fx_source_name = fx_source_name
	self._looping_playing_id = nil
	self._looping_stop_event_name = nil
end

MeleeIdlingEffects.destroy = function (self)
	self:_stop_sfx_loop(true)
	self:_stop_vfx_loop(true)
end

MeleeIdlingEffects.wield = function (self)
	self:_start_sfx_loop()
	self:_start_vfx_loop()
end

MeleeIdlingEffects.unwield = function (self)
	self:_stop_sfx_loop()
	self:_stop_vfx_loop()
end

MeleeIdlingEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

MeleeIdlingEffects.update = function (self, unit, dt, t)
	if not self._looping_playing_id then
		self:_start_sfx_loop()
		self:_start_vfx_loop()
	end
end

MeleeIdlingEffects.update_first_person_mode = function (self, first_person_mode)
	if self._first_person_mode ~= first_person_mode then
		self:_stop_sfx_loop(true)
		self:_stop_vfx_loop(true)

		self._first_person_mode = first_person_mode
	end
end

MeleeIdlingEffects._start_sfx_loop = function (self)
	local visual_loadout_extension = self._visual_loadout_extension
	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()
	local resolved, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(LOOPING_SOUND_ALIAS, should_play_husk_effect, _sfx_external_properties)

	if resolved and not self._looping_playing_id then
		local sfx_source_id = self._fx_extension:sound_source(self._fx_source_name)
		local playing_id = WwiseWorld.trigger_resource_event(self._wwise_world, event_name, sfx_source_id)

		self._looping_playing_id = playing_id

		if resolved_stop then
			self._looping_stop_event_name = stop_event_name
		end
	end
end

MeleeIdlingEffects._stop_sfx_loop = function (self, force_stop)
	local looping_playing_id = self._looping_playing_id
	local looping_stop_event_name = self._looping_stop_event_name
	local sfx_source_id = self._fx_extension:sound_source(self._fx_source_name)

	if not force_stop and looping_stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(self._wwise_world, looping_stop_event_name, sfx_source_id)
	elseif self._looping_playing_id then
		WwiseWorld.stop_event(self._wwise_world, looping_playing_id)
	end

	self._looping_playing_id = nil
	self._looping_stop_event_name = nil
end

MeleeIdlingEffects._start_vfx_loop = function (self)
	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(LOOPING_PARTICLE_ALIAS, _vfx_external_properties)

	if resolved then
		local world = self._world
		local effect_id = World.create_particles(world, effect_name, Vector3.zero())
		local vfx_link_unit, vfx_link_node = self._fx_extension:vfx_spawner_unit_and_node(self._fx_source_name)

		World.link_particles(world, effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

		self._looping_effect_id = effect_id
	end
end

MeleeIdlingEffects._stop_vfx_loop = function (self, force_stop)
	local current_effect_id = self._looping_effect_id

	if current_effect_id then
		if force_stop then
			World.destroy_particles(self._world, current_effect_id)
		else
			World.stop_spawning_particles(self._world, current_effect_id)
		end
	end

	self._looping_effect_id = nil
end

implements(MeleeIdlingEffects, WieldableSlotScriptInterface)

return MeleeIdlingEffects
