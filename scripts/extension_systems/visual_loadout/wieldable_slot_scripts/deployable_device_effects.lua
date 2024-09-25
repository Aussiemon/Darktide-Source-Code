﻿-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/deployable_device_effects.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local DeployableDeviceEffects = class("DeployableDeviceEffects")
local FX_SOURCE_NAME = "_source"
local SFX_STOP_ALIAS = "sfx_device_stop"

DeployableDeviceEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local owner_unit = context.owner_unit

	self._wwise_world = context.wwise_world
	self._fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._visual_loadout_extension = ScriptUnit.extension(owner_unit, "visual_loadout_system")
end

DeployableDeviceEffects.destroy = function (self)
	return
end

DeployableDeviceEffects.wield = function (self)
	return
end

DeployableDeviceEffects.unwield = function (self)
	self._fx_extension:trigger_gear_wwise_event_with_source(SFX_STOP_ALIAS, true, self._fx_source_name, true)
end

DeployableDeviceEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

DeployableDeviceEffects.update = function (self, unit, dt, t)
	return
end

DeployableDeviceEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

implements(DeployableDeviceEffects, WieldableSlotScriptInterface)

return DeployableDeviceEffects
