-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/auspex_device_map_interface.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local AuspexDeviceMapInterface = class("AuspexDeviceMapInterface")
local HOLO_SCREEN_VISIBILITY_GROUP = "display_solid"

AuspexDeviceMapInterface.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local item_unit_1p = slot.unit_1p
	local item_unit_3p = slot.unit_3p

	self._item_unit_1p = item_unit_1p
	self._item_unit_3p = item_unit_3p

	if not context.is_husk then
		local owner_unit = context.owner_unit

		self._owner_unit = owner_unit
	end

	self._is_local_unit = context.is_local_unit
	self._activate_display = false
end

AuspexDeviceMapInterface._trigger_anim_event = function (self, event)
	local anim_ext = ScriptUnit.extension(self._owner_unit, "animation_system")
	local action_time_offset = 0
	local time_scale = 1

	anim_ext:anim_event_with_variable_floats_1p(event, "attack_speed", time_scale, "action_time_offset", action_time_offset)
end

AuspexDeviceMapInterface.fixed_update = function (self, unit, dt, t, frame)
	local owner_unit = self._owner_unit

	if self._activate_display then
		local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
		local minigame_character_state_component = unit_data_extension:write_component("minigame_character_state")

		minigame_character_state_component.pocketable_device_active = true

		self:_trigger_anim_event("auspex_start_focus")

		self._activate_display = false

		if self._item_unit_1p and self._is_local_unit then
			local scanner_display = ScriptUnit.has_extension(self._item_unit_1p, "scanner_display_system")

			if scanner_display then
				scanner_display:activate(owner_unit)
			end
		end
	end
end

AuspexDeviceMapInterface.update = function (self, unit, dt, t)
	return
end

AuspexDeviceMapInterface.update_first_person_mode = function (self, first_person_mode)
	return
end

AuspexDeviceMapInterface.wield = function (self)
	self._activate_display = true

	if not self._is_local_unit then
		if Unit.has_visibility_group(self._item_unit_1p, HOLO_SCREEN_VISIBILITY_GROUP) then
			Unit.set_visibility(self._item_unit_1p, HOLO_SCREEN_VISIBILITY_GROUP, true)
		end

		if Unit.has_visibility_group(self._item_unit_3p, HOLO_SCREEN_VISIBILITY_GROUP) then
			Unit.set_visibility(self._item_unit_3p, HOLO_SCREEN_VISIBILITY_GROUP, true)
		end
	end
end

AuspexDeviceMapInterface.unwield = function (self)
	local item_unit = self._item_unit_1p

	if item_unit and self._is_local_unit then
		local scanner_display_extension = ScriptUnit.has_extension(item_unit, "scanner_display_system")

		if scanner_display_extension then
			scanner_display_extension:deactivate()
		end
	end
end

AuspexDeviceMapInterface.destroy = function (self)
	return
end

implements(AuspexDeviceMapInterface, WieldableSlotScriptInterface)

return AuspexDeviceMapInterface
