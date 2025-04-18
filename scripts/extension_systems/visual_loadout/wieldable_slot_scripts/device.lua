-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/device.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local Device = class("Device")
local HOLO_SCREEN_VISIBILITY_GROUP = "display_solid"

Device.init = function (self, context, slot, weapon_template, fx_sources)
	local item_unit_1p = slot.unit_1p
	local item_unit_3p = slot.unit_3p

	self._item_unit_1p = item_unit_1p
	self._item_unit_3p = item_unit_3p

	if not context.is_husk then
		local owner_unit = context.owner_unit

		self._owner_unit = owner_unit

		local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

		self._minigame_character_state_component = unit_data_extension:read_component("minigame_character_state")
		self._interactor_extension = ScriptUnit.extension(owner_unit, "interactor_system")
	end

	self._is_local_unit = context.is_local_unit
	self._activate_game = false
end

Device.fixed_update = function (self, unit, dt, t, frame)
	if not self._activate_game then
		return
	end

	local state = self._minigame_character_state_component
	local is_unit_synced = state.interface_level_unit_id ~= NetworkConstants.invalid_level_unit_id or state.interface_game_object_id ~= NetworkConstants.invalid_game_object_id

	if not is_unit_synced then
		return
	end

	self._activate_game = false

	if not self._item_unit_1p or not self._is_local_unit then
		return
	end

	local scanner_display = ScriptUnit.has_extension(self._item_unit_1p, "scanner_display_system")

	if not scanner_display then
		return
	end

	local is_level_unit = state.interface_is_level_unit
	local unit_id = is_level_unit and state.interface_level_unit_id or state.interface_game_object_id
	local interface_unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit) or self._interactor_extension:target_unit()

	scanner_display:activate(self._owner_unit, interface_unit)
end

Device.update = function (self, unit, dt, t)
	return
end

Device.update_first_person_mode = function (self, first_person_mode)
	return
end

Device.wield = function (self)
	self._activate_game = true

	if not self._is_local_unit then
		if Unit.has_visibility_group(self._item_unit_1p, HOLO_SCREEN_VISIBILITY_GROUP) then
			Unit.set_visibility(self._item_unit_1p, HOLO_SCREEN_VISIBILITY_GROUP, true)
		end

		if Unit.has_visibility_group(self._item_unit_3p, HOLO_SCREEN_VISIBILITY_GROUP) then
			Unit.set_visibility(self._item_unit_3p, HOLO_SCREEN_VISIBILITY_GROUP, true)
		end
	end

	Unit.flow_event(self._item_unit_1p, "lua_device_wield")
end

Device.unwield = function (self)
	local item_unit = self._item_unit_1p

	if item_unit and self._is_local_unit then
		local scanner_display_extension = ScriptUnit.has_extension(item_unit, "scanner_display_system")

		if scanner_display_extension then
			scanner_display_extension:deactivate()
		end
	end

	Unit.flow_event(self._item_unit_1p, "lua_device_unwield")
end

Device.destroy = function (self)
	return
end

implements(Device, WieldableSlotScriptInterface)

return Device
