local Action = require("scripts/utilities/weapon/action")
local ForceWeaponBlockEffects = class("ForceWeaponBlockEffects")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local BLOCK_FX_SOURCE_NAME = "_block"
local BLOCK_LOOP_SOUND_ALIAS = "block_loop"

ForceWeaponBlockEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	self._world = context.world
	self._weapon_actions = weapon_template.actions
	self._is_husk = is_husk
	local owner_unit = context.owner_unit
	local first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self._first_person_unit = first_person_extension:first_person_unit()
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._block_component = unit_data_extension:read_component("block")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")

	if not is_husk then
		local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(BLOCK_LOOP_SOUND_ALIAS)
		self._looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)
	end

	self._block_fx_source_name = fx_sources[BLOCK_FX_SOURCE_NAME]
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._block_effect_id = nil
end

ForceWeaponBlockEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

ForceWeaponBlockEffects.update = function (self, unit, dt, t)
	if not self._is_husk then
		self:_update_sound_effects()
	end

	self:_update_block_effects(dt)
end

ForceWeaponBlockEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ForceWeaponBlockEffects.wield = function (self)
	return
end

ForceWeaponBlockEffects.unwield = function (self)
	if not self._is_husk then
		local looping_sound_component = self._looping_sound_component
		local fx_extension = self._fx_extension

		if looping_sound_component and looping_sound_component.is_playing then
			fx_extension:stop_looping_wwise_event(BLOCK_LOOP_SOUND_ALIAS)
		end
	end

	self:_destroy_effects()
end

ForceWeaponBlockEffects.destroy = function (self)
	self:_destroy_effects()
end

ForceWeaponBlockEffects._update_sound_effects = function (self)
	local block_component = self._block_component
	local looping_sound_component = self._looping_sound_component
	local fx_extension = self._fx_extension

	if not looping_sound_component.is_playing and block_component.is_blocking then
		fx_extension:trigger_looping_wwise_event(BLOCK_LOOP_SOUND_ALIAS, self._block_fx_source_name)
	elseif looping_sound_component.is_playing and not block_component.is_blocking then
		fx_extension:stop_looping_wwise_event(BLOCK_LOOP_SOUND_ALIAS)
	end
end

ForceWeaponBlockEffects._update_block_effects = function (self, dt)
	local world = self._world
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local block_vfx_name = action_settings and action_settings.block_vfx_name
	local first_person_unit = self._first_person_unit
	local rotation = Unit.local_rotation(first_person_unit, 1)
	local position = Unit.local_position(first_person_unit, 1)
	local forward = Quaternion.forward(rotation)
	local target_position = position + forward

	if not block_vfx_name then
		self:_destroy_effects()

		return
	end

	if block_vfx_name and not self._block_effect_id then
		local effect_id = World.create_particles(world, block_vfx_name, target_position)
		self._block_effect_id = effect_id
	elseif not block_vfx_name and self._block_effect_id then
		self:_destroy_effects()
	end

	if self._block_effect_id then
		World.move_particles(world, self._block_effect_id, target_position)
	end
end

ForceWeaponBlockEffects._destroy_effects = function (self)
	local effect_id = self._block_effect_id

	if effect_id then
		local world = self._world

		World.destroy_particles(world, effect_id)

		self._block_effect_id = nil
	end
end

return ForceWeaponBlockEffects
