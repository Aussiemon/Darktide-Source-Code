-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/weapon_shout_effects.lua

local Action = require("scripts/utilities/action/action")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local SPECIAL_ACTIVATE_SFX_ALIAS = "weapon_special_custom"
local SPECIAL_ACTIVATE_VFX_ALIAS = "weapon_special_custom"
local SOURCE_FROM_NAME = "_shout_special_active"
local _sfx_external_properties = {}
local _vfx_external_properties = {}
local WeaponShoutEffects = class("WeaponShoutEffects")

WeaponShoutEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	self._is_husk = context.is_husk
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._weapon_actions = weapon_template.actions
	self._slot = slot
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit

	if GameParameters.destroy_unmanaged_particles then
		self._particle_group_id = context.player_particle_group_id
	end

	local unit_data_extension = context.unit_data_extension
	local fx_extension = context.fx_extension
	local visual_loadout_extension = context.visual_loadout_extension

	self._fx_extension = fx_extension
	self._visual_loadout_extension = visual_loadout_extension
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
	self._fx_source_from_name = fx_sources[SOURCE_FROM_NAME]
	self._waiting_for_activation_fx = false
	self._has_triggered_activation_fx = false
end

WeaponShoutEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

WeaponShoutEffects.update = function (self, unit, dt, t)
	local weapon_action_component = self._weapon_action_component
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local start_t = weapon_action_component.start_t
	local time_in_action = t - start_t

	self:_update_activation(dt, t, action_settings, time_in_action)
end

WeaponShoutEffects.update_first_person_mode = function (self, first_person_mode)
	if self._first_person_mode ~= first_person_mode then
		self._first_person_mode = first_person_mode
	end
end

WeaponShoutEffects.wield = function (self)
	return
end

WeaponShoutEffects.unwield = function (self)
	return
end

WeaponShoutEffects.destroy = function (self)
	return
end

WeaponShoutEffects._update_activation = function (self, dt, t, action_settings, time_in_action)
	if not action_settings then
		return
	end

	local action_kind = action_settings.kind
	local is_weapon_shout = action_kind == "weapon_shout"
	local is_push = action_kind == "push"

	if is_push then
		self._has_triggered_activation_fx = false
	end

	local shout_at_time = action_settings.shout_at_time
	local waiting_for_shout = is_weapon_shout and time_in_action < shout_at_time

	if waiting_for_shout and self._has_triggered_activation_fx then
		return
	end

	local ready_for_shout = is_weapon_shout and shout_at_time < time_in_action

	if ready_for_shout and not self._has_triggered_activation_fx then
		self._has_triggered_activation_fx = true

		self:_trigger_activation_sfx()
		self:_trigger_activation_vfx()
	end
end

WeaponShoutEffects._trigger_activation_sfx = function (self)
	local resolved, event_name, has_husk_events = self._visual_loadout_extension:resolve_gear_sound(SPECIAL_ACTIVATE_SFX_ALIAS, _sfx_external_properties)

	if resolved then
		local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

		if has_husk_events and should_play_husk_effect then
			event_name = event_name .. "_husk"
		end

		local sfx_source_id = self._fx_extension:sound_source(self._fx_source_from_name)

		WwiseWorld.trigger_resource_event(self._wwise_world, event_name, sfx_source_id)
	end
end

WeaponShoutEffects._trigger_activation_vfx = function (self)
	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(SPECIAL_ACTIVATE_VFX_ALIAS, _vfx_external_properties)

	if resolved then
		local world = self._world
		local rotation = self._first_person_component.rotation
		local spawn_rot = Quaternion.look(Vector3.normalize(Vector3.flat(Quaternion.forward(rotation))))
		local from_unit, from_node = self._fx_extension:vfx_spawner_unit_and_node(self._fx_source_from_name)
		local spawn_pos = Unit.world_position(from_unit, from_node)
		local new_effect_id = World.create_particles(world, effect_name, spawn_pos, spawn_rot, nil, self._particle_group_id)
	end
end

implements(WeaponShoutEffects, WieldableSlotScriptInterface)

return WeaponShoutEffects
