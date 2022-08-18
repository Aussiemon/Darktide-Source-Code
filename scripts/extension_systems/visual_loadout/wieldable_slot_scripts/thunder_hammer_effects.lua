local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local ThunderHammerEffects = class("ThunderHammerEffects")
local EXTERNAL_PROPERTIES = {}
local SPECIAL_ACTIVE_LOOP_SOUND_ALIAS = "weapon_special_loop"
local SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS = "weapon_special_loop"

ThunderHammerEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit
	self._is_husk = is_husk
	self._is_server = context.is_server
	self._is_local_unit = context.is_local_unit
	self._slot = slot
	self._wwise_world = context.wwise_world
	self._equipment_component = context.equipment_component
	self._weapon_actions = weapon_template.actions
	self._special_active_fx_source_name = fx_sources._special_active
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	if not is_husk then
		self._weapon_action_component = unit_data_extension:read_component("weapon_action")
		local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(SPECIAL_ACTIVE_LOOP_SOUND_ALIAS)
		self._looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)
		self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	end
end

ThunderHammerEffects.destroy = function (self)
	if self._is_husk then
		return
	end

	if self._looping_sound_component.is_playing then
		local fx_extension = self._fx_extension

		fx_extension:stop_looping_wwise_event(SPECIAL_ACTIVE_LOOP_SOUND_ALIAS)
		fx_extension:stop_looping_particles(SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS, false)
	end
end

ThunderHammerEffects.wield = function (self)
	return
end

ThunderHammerEffects.unwield = function (self)
	if self._is_husk then
		return
	end

	if self._looping_sound_component.is_playing then
		local fx_extension = self._fx_extension

		fx_extension:stop_looping_wwise_event(SPECIAL_ACTIVE_LOOP_SOUND_ALIAS)
		fx_extension:stop_looping_particles(SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS, false)
	end
end

ThunderHammerEffects.fixed_update = function (self, unit, dt, t, frame)
	if self._is_husk then
		return
	end

	self:_update_active()
end

ThunderHammerEffects.update = function (self, unit, dt, t)
	return
end

ThunderHammerEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ThunderHammerEffects._update_active = function (self)
	local is_playing = self._looping_sound_component.is_playing
	local special_active = self._inventory_slot_component.special_active
	local fx_extension = self._fx_extension

	if not is_playing and special_active then
		fx_extension:trigger_looping_wwise_event(SPECIAL_ACTIVE_LOOP_SOUND_ALIAS, self._special_active_fx_source_name)
		fx_extension:spawn_looping_particles(SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS, self._special_active_fx_source_name, EXTERNAL_PROPERTIES)
	elseif is_playing and not special_active then
		fx_extension:stop_looping_wwise_event(SPECIAL_ACTIVE_LOOP_SOUND_ALIAS)
		fx_extension:stop_looping_particles(SPECIAL_ACTIVE_LOOP_EFFECT_ALIAS, true)
	end
end

return ThunderHammerEffects
