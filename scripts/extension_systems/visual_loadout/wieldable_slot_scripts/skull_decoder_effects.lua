local SkullDecoderEffects = class("SkullDecoderEffects")
local FX_SOURCE_NAME = "_source"
local SFX_START_ALIAS = "sfx_device_start"
local SFX_STOP_ALIAS = "sfx_device_stop"

SkullDecoderEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local owner_unit = context.owner_unit
	self._wwise_world = context.wwise_world
	self._fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
end

SkullDecoderEffects.destroy = function (self)
	return
end

SkullDecoderEffects.wield = function (self)
	self._fx_extension:trigger_gear_wwise_event(SFX_START_ALIAS, FX_SOURCE_NAME)
end

SkullDecoderEffects.unwield = function (self)
	self._fx_extension:trigger_gear_wwise_event(SFX_STOP_ALIAS, FX_SOURCE_NAME)
end

SkullDecoderEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

SkullDecoderEffects.update = function (self, unit, dt, t)
	return
end

SkullDecoderEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

return SkullDecoderEffects
