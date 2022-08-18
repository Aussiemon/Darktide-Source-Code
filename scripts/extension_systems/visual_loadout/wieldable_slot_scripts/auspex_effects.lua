local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local AuspexEffects = class("AuspexEffects")
local LOOPING_SOUND_ALIAS = "sfx_minigame_loop"
local FX_SOURCE_NAME = "_speaker"
local WWISE_PARAMETER_NAME = "auspex_scanner_speed"
local PARAMETER_VALUE = 2

AuspexEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit
	self._wwise_world = context.wwise_world
	self._fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._is_husk = is_husk
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	if not is_husk then
		local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(LOOPING_SOUND_ALIAS)
		self._looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)
	end
end

AuspexEffects.destroy = function (self)
	if self._is_husk then
		return
	end

	if self._looping_sound_component.is_playing then
		self._fx_extension:stop_looping_wwise_event(LOOPING_SOUND_ALIAS)
	end
end

AuspexEffects.wield = function (self)
	if self._is_husk then
		return
	end

	local fx_extension = self._fx_extension
	local fx_source_name = self._fx_source_name
	local fx_source = self._fx_extension:sound_source(fx_source_name)

	if not self._looping_sound_component.is_playing then
		fx_extension:trigger_looping_wwise_event(LOOPING_SOUND_ALIAS, fx_source_name)
		WwiseWorld.set_source_parameter(self._wwise_world, fx_source, WWISE_PARAMETER_NAME, PARAMETER_VALUE)
	end
end

AuspexEffects.unwield = function (self)
	if self._is_husk then
		return
	end

	if self._looping_sound_component.is_playing then
		self._fx_extension:stop_looping_wwise_event(LOOPING_SOUND_ALIAS)
	end
end

AuspexEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

AuspexEffects.update = function (self, unit, dt, t)
	return
end

AuspexEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

return AuspexEffects
