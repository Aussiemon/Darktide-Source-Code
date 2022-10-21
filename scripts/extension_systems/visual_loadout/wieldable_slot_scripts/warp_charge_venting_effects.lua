local Action = require("scripts/utilities/weapon/action")
local WieldableSlotScriptsUtilities = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/utilities/wieldable_slot_scripts_utilities")
local WarpChargeVentingEffects = class("WarpChargeVentingEffects")
local _start_vfx, _stop_vfx = nil

WarpChargeVentingEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit
	self._is_husk = is_husk
	self._slot_name = slot.name
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._weapon_actions = weapon_template.actions
	self._vent_particle_id = nil
	self._additional_vent_particle_id = nil
	self._wwise_playing_id = nil
	self._is_in_first_person = nil
	self._is_playing_in_first_person = nil
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._unit_data_extension = unit_data_extension
	self._warp_charge_component = unit_data_extension:read_component("warp_charge")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	local specialization = unit_data_extension:specialization()
	local effects = specialization.warp_charge and specialization.warp_charge.fx
	self._looping_venting_wwise_start_event = effects and effects.looping_venting_wwise_start_event
	self._looping_venting_wwise_stop_event = effects and effects.looping_venting_wwise_stop_event
	self._looping_wwise_parameter_name = effects and effects.looping_wwise_parameter_name
end

WarpChargeVentingEffects.destroy = function (self)
	self:_destroy_effects()
end

WarpChargeVentingEffects.wield = function (self)
	self:_update_venting_effects()
end

WarpChargeVentingEffects.unwield = function (self)
	self:_destroy_effects()
end

WarpChargeVentingEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

WarpChargeVentingEffects.update = function (self, unit, dt, t)
	self:_update_venting_effects()
end

WarpChargeVentingEffects.update_first_person_mode = function (self, first_person_mode)
	self._is_in_first_person = first_person_mode
end

WarpChargeVentingEffects._update_venting_effects = function (self)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local is_venting = action_settings and action_settings.kind == "vent_warp_charge"

	self:_update_sfx(is_venting, action_settings)
	self:_update_vfx(is_venting, action_settings)
end

WarpChargeVentingEffects._update_sfx = function (self, is_venting, action_settings)
	local wwise_world = self._wwise_world
	local playing_id = self._wwise_playing_id
	local vent_source_name = action_settings and action_settings.vent_source_name
	local source_id = vent_source_name and self._fx_extension:sound_source(vent_source_name)
	local start_event = self._looping_venting_wwise_start_event
	local stop_event = self._looping_venting_wwise_stop_event
	local parameter_name = self._looping_wwise_parameter_name
	local is_in_first_person = self._is_in_first_person

	if start_event and is_venting and is_in_first_person and not playing_id then
		local new_playing_id = WwiseWorld.trigger_resource_event(wwise_world, start_event, source_id)
		self._wwise_playing_id = new_playing_id
	elseif (not is_venting or not is_in_first_person) and playing_id then
		if source_id and stop_event then
			WwiseWorld.trigger_resource_event(wwise_world, stop_event, source_id)
		else
			WwiseWorld.stop_event(wwise_world, playing_id)
		end

		self._wwise_playing_id = nil
	end

	if parameter_name and is_venting and playing_id then
		local warp_charge_percentage = self._warp_charge_component.current_percentage

		WwiseWorld.set_source_parameter(wwise_world, source_id, parameter_name, warp_charge_percentage)
	end
end

WarpChargeVentingEffects._update_vfx = function (self, is_venting, action_settings)
	local fx_extension = self._fx_extension
	local world = self._world
	local is_in_first_person = self._is_in_first_person

	if is_venting and action_settings then
		local particle_name = action_settings.vent_vfx
		local additional_particle_name = action_settings.additional_vent_vfx or particle_name
		local vent_source_name = action_settings.vent_source_name
		local additional_vent_source_name = action_settings.additional_vent_source_name

		if self._is_playing_in_first_person ~= is_in_first_person then
			_stop_vfx(world, self._vent_particle_id)
			_stop_vfx(world, self._additional_vent_particle_id)

			self._vent_particle_id = nil
			self._additional_vent_particle_id = nil
		end

		self._vent_particle_id = _start_vfx(world, fx_extension, self._vent_particle_id, particle_name, vent_source_name, is_in_first_person)
		self._additional_vent_particle_id = _start_vfx(world, fx_extension, self._additional_vent_particle_id, additional_particle_name, additional_vent_source_name, is_in_first_person)
		self._is_playing_in_first_person = is_in_first_person
	else
		_stop_vfx(world, self._vent_particle_id)
		_stop_vfx(world, self._additional_vent_particle_id)

		self._vent_particle_id = nil
		self._additional_vent_particle_id = nil
	end
end

WarpChargeVentingEffects._destroy_effects = function (self, is_venting, vent_source_name, additional_vent_source)
	local playing_id = self._wwise_playing_id

	if playing_id then
		WwiseWorld.stop_event(self._wwise_world, playing_id)
	end

	local world = self._world

	_stop_vfx(world, self._vent_particle_id)
	_stop_vfx(world, self._additional_vent_particle_id)

	self._vent_particle_id = nil
	self._additional_vent_particle_id = nil
	self._wwise_playing_id = nil
end

function _start_vfx(world, fx_extension, existing_particle_id, effect_name, source_name, in_first_person)
	if not existing_particle_id and effect_name and source_name then
		local new_particle_id = WieldableSlotScriptsUtilities.spawn_particle(world, fx_extension, effect_name, source_name, in_first_person)

		return new_particle_id
	else
		return existing_particle_id
	end
end

function _stop_vfx(world, existing_particle_id)
	if existing_particle_id then
		WieldableSlotScriptsUtilities.destory_particle(world, existing_particle_id)
	end
end

return WarpChargeVentingEffects
