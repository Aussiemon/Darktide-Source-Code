-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/melee_idling_effects.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local MeleeIdlingEffects = class("MeleeIdlingEffects")
local LOOPING_SOUND_ALIAS = "equipped_item_passive_loop"
local _sfx_external_properties = {}

MeleeIdlingEffects.init = function (self, context, slot, weapon_template, fx_sources)
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
	self:_stop_sfx()
end

MeleeIdlingEffects.wield = function (self)
	self:_start_sfx()
end

MeleeIdlingEffects.unwield = function (self)
	self:_stop_sfx()
end

MeleeIdlingEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

MeleeIdlingEffects.update = function (self, unit, dt, t)
	if not self._looping_playing_id then
		self:_start_sfx()
	end
end

MeleeIdlingEffects.update_first_person_mode = function (self, first_person_mode)
	if self._first_person_mode ~= first_person_mode then
		self:_stop_sfx()

		self._first_person_mode = first_person_mode
	end
end

MeleeIdlingEffects._start_sfx = function (self)
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

MeleeIdlingEffects._stop_sfx = function (self)
	local looping_playing_id = self._looping_playing_id
	local looping_stop_event_name = self._looping_stop_event_name
	local sfx_source_id = self._fx_extension:sound_source(self._fx_source_name)

	if looping_stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(self._wwise_world, looping_stop_event_name, sfx_source_id)
	elseif self._looping_playing_id then
		WwiseWorld.stop_event(self._wwise_world, looping_playing_id)
	end

	self._looping_playing_id = nil
	self._looping_stop_event_name = nil
end

implements(MeleeIdlingEffects, WieldableSlotScriptInterface)

return MeleeIdlingEffects
