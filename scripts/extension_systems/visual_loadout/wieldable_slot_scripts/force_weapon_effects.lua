﻿-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_effects.lua

local Component = require("scripts/utilities/component")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ForceWeaponEffects = class("ForceWeaponEffects")
local _set_start_time, _set_stop_time, _unit_components
local _sfx_external_properties = {}
local SPECIAL_ACTIVE_LOOPING_SFX_ALIAS = "weapon_special_loop"
local SPECIAL_OFF_SOUND_ALIAS = "weapon_special_end"
local INVENTORY_EVENT_POWER_OFF = "special_disabled"
local INVENTORY_EVENT_POWER_ON = "special_enabled"
local INVENTORY_EVENT_WIELD = "special_disabled"
local SOUND_PARAMETER_NAME = "power_resource"
local FX_SOURCE_NAME = "_special_active"

ForceWeaponEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit

	self._is_husk = is_husk
	self._is_local_unit = context.is_local_unit
	self._slot_name = slot.name
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._special_active_fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._warp_charge_component = unit_data_extension:read_component("warp_charge")
	self._first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self._visual_loadout_extension = context.visual_loadout_extension
	self._weapon_material_variables_1p = {}
	self._weapon_material_variables_3p = {}
	self._is_active = false
	self._looping_playing_id = nil
	self._looping_stop_event_name = nil

	_unit_components(self._weapon_material_variables_1p, slot.attachments_1p)
	_unit_components(self._weapon_material_variables_3p, slot.attachments_3p)
end

ForceWeaponEffects.destroy = function (self)
	PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_OFF)
	self:_stop_sfx_loop()
end

ForceWeaponEffects.wield = function (self)
	PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_WIELD)
end

ForceWeaponEffects.unwield = function (self)
	self:_stop_sfx_loop()

	if self._is_playing then
		self:_play_single_sfx(SPECIAL_OFF_SOUND_ALIAS, self._special_active_fx_source_name)
	end

	local t = World.time(self._world)

	_set_stop_time(t, self._weapon_material_variables_1p)
	_set_stop_time(t, self._weapon_material_variables_3p)
end

ForceWeaponEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

ForceWeaponEffects.update = function (self, unit, dt, t)
	self:_update_active()
end

ForceWeaponEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ForceWeaponEffects._play_single_sfx = function (self, sound_alias, fx_source_name)
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local resolved, event_name, has_husk_events = self._visual_loadout_extension:resolve_gear_sound(sound_alias, _sfx_external_properties)

	if resolved then
		local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

		if has_husk_events and should_play_husk_effect then
			event_name = event_name .. "_husk"
		end

		WwiseWorld.trigger_resource_event(self._wwise_world, event_name, sfx_source_id)
	end
end

ForceWeaponEffects._update_active = function (self)
	local is_active = self._is_active
	local special_active = self._inventory_slot_component.special_active
	local fx_extension = self._fx_extension
	local t = World.time(self._world)
	local current_playing_id = self._looping_playing_id
	local should_start = not current_playing_id and not is_active and special_active
	local should_stop = current_playing_id and is_active and not special_active

	if should_start then
		self:_start_sfx_loop()
		PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_ON)
		_set_start_time(t, self._weapon_material_variables_1p)
		_set_start_time(t, self._weapon_material_variables_3p)
	elseif should_stop then
		self:_stop_sfx_loop()
		self:_play_single_sfx(SPECIAL_OFF_SOUND_ALIAS, self._special_active_fx_source_name)
		PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_OFF)
		_set_stop_time(t, self._weapon_material_variables_1p)
		_set_stop_time(t, self._weapon_material_variables_3p)
	end

	if special_active then
		local warp_charge_slot_component = self._warp_charge_component
		local current_percentage = warp_charge_slot_component.current_percentage
		local source = fx_extension:sound_source(self._special_active_fx_source_name)

		WwiseWorld.set_source_parameter(self._wwise_world, source, SOUND_PARAMETER_NAME, current_percentage)
	end

	self._is_active = special_active
end

ForceWeaponEffects._start_sfx_loop = function (self)
	if self._looping_playing_id then
		return
	end

	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local visual_loadout_extension = self._visual_loadout_extension
	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()
	local resolved, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(SPECIAL_ACTIVE_LOOPING_SFX_ALIAS, should_play_husk_effect, _sfx_external_properties)

	if resolved then
		local new_playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)

		self._looping_playing_id = new_playing_id

		if resolved_stop then
			self._looping_stop_event_name = stop_event_name
		end
	end
end

ForceWeaponEffects._stop_sfx_loop = function (self)
	local current_playing_id = self._looping_playing_id

	if not current_playing_id then
		return
	end

	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local stop_event_name = self._looping_stop_event_name

	if stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, sfx_source_id)
	else
		WwiseWorld.stop_event(wwise_world, current_playing_id)
	end

	self._looping_playing_id = nil
	self._looping_stop_event_name = nil
end

function _set_start_time(t, weapon_material_variables)
	for ii = 1, #weapon_material_variables do
		local weapon_material_variable = weapon_material_variables[ii]

		weapon_material_variable.component:set_start_time(t, weapon_material_variable.unit)
	end
end

function _set_stop_time(t, weapon_material_variables)
	for ii = 1, #weapon_material_variables do
		local weapon_material_variable = weapon_material_variables[ii]

		weapon_material_variable.component:set_stop_time(t, weapon_material_variable.unit)
	end
end

function _unit_components(components, attachments)
	local num_attachments = #attachments

	for ii = 1, num_attachments do
		local attachment_unit = attachments[ii]
		local unit_components = Component.get_components_by_name(attachment_unit, "WeaponMaterialVariables")

		for _, component in ipairs(unit_components) do
			components[#components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end
end

implements(ForceWeaponEffects, WieldableSlotScriptInterface)

return ForceWeaponEffects
