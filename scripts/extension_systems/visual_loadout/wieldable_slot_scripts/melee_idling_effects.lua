﻿-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/melee_idling_effects.lua

local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local MeleeIdlingEffects = class("MeleeIdlingEffects")
local LOOPING_SOUND_ALIAS = "melee_idling"

MeleeIdlingEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk

	self._is_husk = is_husk
	self._is_server = context.is_server
	self._slot = slot
	self._is_local_unit = context.is_local_unit
	self._weapon_template = weapon_template
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._first_person_unit = context.first_person_unit

	local owner_unit = context.owner_unit

	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local fx_source_name = fx_sources._melee_idling

	self._fx_source_name = fx_source_name

	if not is_husk then
		local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(LOOPING_SOUND_ALIAS)

		self._melee_idling_looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)
	end
end

MeleeIdlingEffects.destroy = function (self)
	if not self._is_husk and self._melee_idling_looping_sound_component.is_playing then
		self._fx_extension:stop_looping_wwise_event(LOOPING_SOUND_ALIAS)
	end
end

MeleeIdlingEffects.wield = function (self)
	if not self._is_husk and not self._melee_idling_looping_sound_component.is_playing then
		self._fx_extension:trigger_looping_wwise_event(LOOPING_SOUND_ALIAS, self._fx_source_name)
	end
end

MeleeIdlingEffects.unwield = function (self)
	if not self._is_husk and self._melee_idling_looping_sound_component.is_playing then
		self._fx_extension:stop_looping_wwise_event(LOOPING_SOUND_ALIAS)
	end
end

MeleeIdlingEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

MeleeIdlingEffects.update = function (self, unit, dt, t)
	return
end

MeleeIdlingEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

return MeleeIdlingEffects
