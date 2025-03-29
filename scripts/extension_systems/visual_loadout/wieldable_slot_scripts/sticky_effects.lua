-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/sticky_effects.lua

local Action = require("scripts/utilities/action/action")
local Armor = require("scripts/utilities/attack/armor")
local HitZone = require("scripts/utilities/attack/hit_zone")
local SweepStickyness = require("scripts/utilities/action/sweep_stickyness")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local StickyEffects = class("StickyEffects")
local STICKYNESS_SFX_LOOP_ALIAS = "melee_sticky_loop"
local STICKYNESS_VFX_LOOP_ALIAS = "melee_sticky_loop"
local _sticky_armor_type
local STICKY_FX_SOURCE_NAME = "_sticky"

StickyEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._weapon_actions = weapon_template.actions

	local unit_data_extension = context.unit_data_extension
	local fx_extension = context.fx_extension
	local visual_loadout_extension = context.visual_loadout_extension

	self._fx_extension = fx_extension
	self._visual_loadout_extension = visual_loadout_extension
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")

	local sticky_fx_source_name = fx_sources[STICKY_FX_SOURCE_NAME]

	self._sticky_fx_source_name = sticky_fx_source_name
	self._vfx_link_unit, self._vfx_link_node = fx_extension:vfx_spawner_unit_and_node(sticky_fx_source_name)
	self._looping_playing_id = nil
	self._stop_event_name = nil
	self._looping_effect_id = nil
	self._was_sticky = false
	self._current_sticky_armor_type = nil
end

StickyEffects.destroy = function (self)
	self:_stop_stickyness()
end

StickyEffects.wield = function (self)
	return
end

StickyEffects.unwield = function (self)
	self:_stop_stickyness()
end

StickyEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

StickyEffects.update = function (self, unit, dt, t)
	local action_sweep_component = self._action_sweep_component
	local is_sticky = action_sweep_component.is_sticky
	local was_sticky = self._was_sticky

	if is_sticky and not was_sticky then
		self:_start_stickyness()
	elseif was_sticky and not is_sticky then
		self:_stop_stickyness()
	elseif was_sticky and is_sticky then
		self:_update_stickyness()
	end

	self._was_sticky = self._looping_playing_id and self._looping_effect_id
end

StickyEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

local _external_properties = {
	armor_type = "n/a",
}

StickyEffects._start_stickyness = function (self, t)
	local weapon_action_component = self._weapon_action_component
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local special_active_at_start = weapon_action_component.special_active_at_start
	local hit_stickyness_settings = special_active_at_start and action_settings.hit_stickyness_settings_special_active or action_settings.hit_stickyness_settings

	if not hit_stickyness_settings then
		return
	end

	local action_sweep_component = self._action_sweep_component
	local sticky_armor_type = _sticky_armor_type(action_sweep_component)

	if sticky_armor_type and self._sticky_armor_type ~= sticky_armor_type then
		local visual_loadout_extension = self._visual_loadout_extension
		local fx_extension = self._fx_extension
		local should_play_husk_effect = fx_extension:should_play_husk_effect()
		local resolved_sfx, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(STICKYNESS_SFX_LOOP_ALIAS, should_play_husk_effect, _external_properties)

		if resolved_sfx then
			local wwise_world = self._wwise_world
			local sticky_fx_source_name = self._sticky_fx_source_name
			local source_id = fx_extension:sound_source(sticky_fx_source_name)

			WwiseWorld.set_switch(wwise_world, "armor_types", sticky_armor_type, source_id)

			local playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)

			self._looping_playing_id = playing_id

			if resolved_stop then
				self._stop_event_name = stop_event_name
			end
		end

		_external_properties.armor_type = _sticky_armor_type(action_sweep_component)

		local resolved_vfx, effect_name = visual_loadout_extension:resolve_gear_particle(STICKYNESS_VFX_LOOP_ALIAS, _external_properties)

		if resolved_vfx then
			local world = self._world
			local vfx_link_unit, vfx_link_node = self._vfx_link_unit, self._vfx_link_node
			local effect_id = World.create_particles(world, effect_name, Vector3.zero())

			World.link_particles(world, effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

			self._looping_effect_id = effect_id
		end
	end

	self._current_sticky_armor_type = sticky_armor_type
end

StickyEffects._update_stickyness = function (self)
	local action_sweep_component = self._action_sweep_component
	local sticky_armor_type = _sticky_armor_type(action_sweep_component)

	if sticky_armor_type and sticky_armor_type ~= self._current_sticky_armor_type then
		self._current_sticky_armor_type = sticky_armor_type

		local source_id = self._fx_extension:sound_source(self._sticky_fx_source_name)

		WwiseWorld.set_switch(self._wwise_world, "armor_types", sticky_armor_type, source_id)
	end
end

StickyEffects._stop_stickyness = function (self)
	local looping_playing_id = self._looping_playing_id

	if looping_playing_id then
		local stop_event_name = self._stop_event_name

		if stop_event_name then
			local source_id = self._fx_extension:sound_source(self._sticky_fx_source_name)

			WwiseWorld.trigger_resource_event(self._wwise_world, stop_event_name, source_id)
		else
			WwiseWorld.stop_event(self._wwise_world, looping_playing_id)
		end

		self._looping_playing_id = nil
		self._stop_event_name = nil
	end

	if self._looping_effect_id then
		World.stop_spawning_particles(self._world, self._looping_effect_id)

		self._looping_effect_id = nil
	end

	self._was_sticky = false
	self._current_sticky_armor_type = nil
end

function _sticky_armor_type(action_sweep_component)
	local stick_to_unit, stick_to_actor = SweepStickyness.unit_which_aborted_sweep(action_sweep_component)

	if stick_to_unit and stick_to_actor then
		local hit_zone_name = stick_to_actor and HitZone.get_name(stick_to_unit, stick_to_actor)
		local unit_data_extension = hit_zone_name and ScriptUnit.extension(stick_to_unit, "unit_data_system")
		local breed = unit_data_extension and unit_data_extension:breed()
		local sticky_armor_type = breed and (breed.hit_effect_armor_override or Armor.armor_type(stick_to_unit, breed, hit_zone_name))

		return sticky_armor_type
	end
end

implements(StickyEffects, WieldableSlotScriptInterface)

return StickyEffects
