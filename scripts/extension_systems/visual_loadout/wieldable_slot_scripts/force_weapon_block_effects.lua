-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_block_effects.lua

local Action = require("scripts/utilities/weapon/action")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ForceWeaponBlockEffects = class("ForceWeaponBlockEffects")
local FX_SOURCE_NAME = "fx_left_hand_offset_fwd"
local LOOPING_SFX_ALIAS = "force_weapon_block_loop"
local LOOPING_VFX_ALIAS = "force_weapon_block"
local _sfx_external_properties = {}
local _vfx_external_properties = {}

ForceWeaponBlockEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._weapon_actions = weapon_template.actions
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit

	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension
	self._looping_playing_id = nil
	self._looping_stop_event_name = nil
	self._looping_effect_id = nil
end

ForceWeaponBlockEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

ForceWeaponBlockEffects.update = function (self, unit, dt, t)
	self:_update_sfx()
	self:_update_vfx()
end

ForceWeaponBlockEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ForceWeaponBlockEffects.wield = function (self)
	return
end

ForceWeaponBlockEffects.unwield = function (self)
	self:_stop_sfx()
	self:_destroy_vfx()
end

ForceWeaponBlockEffects.destroy = function (self)
	self:_stop_sfx()
	self:_destroy_vfx()
end

ForceWeaponBlockEffects._update_sfx = function (self)
	local visual_loadout_extension = self._visual_loadout_extension
	local wwise_world = self._wwise_world
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind
	local blocking = action_kind == "block"

	if blocking and not self._looping_playing_id then
		local should_play_husk_effect = self._fx_extension:should_play_husk_effect()
		local resolved, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(LOOPING_SFX_ALIAS, should_play_husk_effect, _sfx_external_properties)

		if resolved then
			local sfx_source_id = self._fx_extension:sound_source(FX_SOURCE_NAME)
			local playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)

			self._looping_playing_id = playing_id

			if resolved_stop then
				self._looping_stop_event_name = stop_event_name
			end
		end
	elseif not blocking and self._looping_playing_id then
		self:_stop_sfx()
	end
end

ForceWeaponBlockEffects._update_vfx = function (self)
	local world = self._world
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind
	local blocking = action_kind == "block"

	if blocking and not self._looping_effect_id then
		local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(LOOPING_VFX_ALIAS, _vfx_external_properties)

		if resolved then
			local effect_id = World.create_particles(world, effect_name, Vector3.zero())
			local vfx_unit, vfx_node = self._fx_extension:vfx_spawner_unit_and_node(FX_SOURCE_NAME)

			World.link_particles(world, effect_id, vfx_unit, vfx_node, Matrix4x4.identity(), "stop")

			self._looping_effect_id = effect_id
		end
	elseif not blocking and self._looping_effect_id then
		self:_destroy_vfx()
	end
end

ForceWeaponBlockEffects._destroy_vfx = function (self)
	local block_effect_id = self._looping_effect_id

	if block_effect_id then
		local world = self._world

		World.destroy_particles(world, block_effect_id)

		self._looping_effect_id = nil
	end
end

ForceWeaponBlockEffects._stop_sfx = function (self)
	local looping_playing_id = self._looping_playing_id
	local looping_stop_event_name = self._looping_stop_event_name
	local sfx_source_id = self._fx_extension:sound_source(FX_SOURCE_NAME)

	if looping_stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(self._wwise_world, looping_stop_event_name, sfx_source_id)
	else
		WwiseWorld.stop_event(self._wwise_world, looping_playing_id)
	end

	self._looping_playing_id = nil
	self._looping_stop_event_name = nil
end

implements(ForceWeaponBlockEffects, WieldableSlotScriptInterface)

return ForceWeaponBlockEffects
