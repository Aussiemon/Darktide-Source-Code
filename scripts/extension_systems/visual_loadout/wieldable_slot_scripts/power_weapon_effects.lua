local Component = require("scripts/utilities/component")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerWeaponEffects = class("PowerWeaponEffects")
local _set_start_time, _set_stop_time, _unit_components = nil
local SPECIAL_ACTIVE_LOOP_SOUND_ALIAS = "weapon_special_loop"
local SPECIAL_OFF_SOUND_ALIAS = "weapon_special_end"
local INVENTORY_EVENT_POWER_OFF = "special_disabled"
local INVENTORY_EVENT_POWER_ON = "special_enabled"
local INVENTORY_EVENT_WIELD = "special_disabled"
local SOUND_PARAMETER_NAME = "power_resource"
local FX_SOURCE_NAME = "_special_active"

PowerWeaponEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit
	self._is_husk = is_husk
	self._slot_name = slot.name
	self._wwise_world = context.wwise_world
	self._special_active_fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	if not is_husk then
		local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(SPECIAL_ACTIVE_LOOP_SOUND_ALIAS)
		self._looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)
		self._inventory_slot_component = unit_data_extension:read_component(slot.name)
		self._first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
		self._visual_loadout_extension = context.visual_loadout_extension
	end

	self._weapon_material_variables_1p = {}
	self._weapon_material_variables_3p = {}

	_unit_components(self._weapon_material_variables_1p, slot.attachments_1p)
	_unit_components(self._weapon_material_variables_3p, slot.attachments_3p)
end

PowerWeaponEffects.destroy = function (self)
	if self._is_husk then
		return
	end

	if self._looping_sound_component.is_playing then
		local fx_extension = self._fx_extension

		fx_extension:stop_looping_wwise_event(SPECIAL_ACTIVE_LOOP_SOUND_ALIAS)
		PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_OFF)
		fx_extension:trigger_gear_wwise_event_with_source(SPECIAL_OFF_SOUND_ALIAS, nil, self._special_active_fx_source_name, true)
	end
end

PowerWeaponEffects.wield = function (self)
	if self._is_husk then
		return
	end

	PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_WIELD)
end

PowerWeaponEffects.unwield = function (self)
	if self._is_husk then
		return
	end

	local fx_extension = self._fx_extension

	if self._looping_sound_component.is_playing then
		fx_extension:stop_looping_wwise_event(SPECIAL_ACTIVE_LOOP_SOUND_ALIAS)
	end
end

PowerWeaponEffects.fixed_update = function (self, unit, dt, t, frame)
	if self._is_husk then
		return
	end

	self:_update_active(t)
end

PowerWeaponEffects.update = function (self, unit, dt, t)
	return
end

PowerWeaponEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

PowerWeaponEffects._update_active = function (self, t)
	local is_playing = self._looping_sound_component.is_playing
	local special_active = self._inventory_slot_component.special_active
	local fx_extension = self._fx_extension

	if not is_playing and special_active then
		fx_extension:trigger_looping_wwise_event(SPECIAL_ACTIVE_LOOP_SOUND_ALIAS, self._special_active_fx_source_name)
		PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_ON)
		_set_start_time(t, self._weapon_material_variables_1p)
		_set_start_time(t, self._weapon_material_variables_3p)
	elseif is_playing and not special_active then
		fx_extension:stop_looping_wwise_event(SPECIAL_ACTIVE_LOOP_SOUND_ALIAS)
		PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_OFF)
		fx_extension:trigger_gear_wwise_event_with_source(SPECIAL_OFF_SOUND_ALIAS, nil, self._special_active_fx_source_name, true)
		_set_stop_time(t, self._weapon_material_variables_1p)
		_set_stop_time(t, self._weapon_material_variables_3p)
	end

	if is_playing and special_active then
		local source = self._fx_extension:sound_source(self._special_active_fx_source_name)

		WwiseWorld.set_source_parameter(self._wwise_world, source, SOUND_PARAMETER_NAME, 20)
	end
end

function _set_start_time(t, weapon_material_varaibles)
	for i = 1, #weapon_material_varaibles do
		local weapon_material_varaible = weapon_material_varaibles[i]

		weapon_material_varaible.component:set_start_time(t, weapon_material_varaible.unit)
	end
end

function _set_stop_time(t, weapon_material_varaibles)
	for i = 1, #weapon_material_varaibles do
		local weapon_material_varaible = weapon_material_varaibles[i]

		weapon_material_varaible.component:set_stop_time(t, weapon_material_varaible.unit)
	end
end

function _unit_components(components, attachments)
	local num_attachments = #attachments

	for i = 1, num_attachments do
		local attachment_unit = attachments[i]
		local unit_components = Component.get_components_by_name(attachment_unit, "WeaponMaterialVariables")

		for _, component in ipairs(unit_components) do
			components[#components + 1] = {
				unit = attachment_unit,
				component = component
			}
		end
	end
end

return PowerWeaponEffects
