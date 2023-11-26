-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/psyker_force_field_placement_preview_effects.lua

local PsykerForceFieldPlacementPreviewEffects = class("PsykerForceFieldPlacementPreviewEffects")

PsykerForceFieldPlacementPreviewEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local wwise_world = context.wwise_world

	self._world = context.world
	self._wwise_world = wwise_world
	self._weapon_actions = weapon_template.actions
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit

	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	if self._is_local_unit then
		self._weapon_action_component = unit_data_extension:read_component("weapon_action")
		self._first_person_component = unit_data_extension:read_component("first_person")
		self._action_place_component = unit_data_extension:read_component("action_place")
	end
end

PsykerForceFieldPlacementPreviewEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

PsykerForceFieldPlacementPreviewEffects.update = function (self, unit, dt, t)
	if not self._is_local_unit then
		return
	end

	self:_update_effects(dt, t)
end

PsykerForceFieldPlacementPreviewEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

PsykerForceFieldPlacementPreviewEffects.wield = function (self)
	return
end

PsykerForceFieldPlacementPreviewEffects.unwield = function (self)
	self:_destroy_effects()
end

PsykerForceFieldPlacementPreviewEffects.destroy = function (self)
	self:_destroy_effects()
end

PsykerForceFieldPlacementPreviewEffects._update_effects = function (self, dt, t)
	local weapon_action_component = self._weapon_action_component
	local current_action_name = weapon_action_component.current_action_name
	local action_settings = self._weapon_actions[current_action_name]

	if current_action_name == "action_aim_force_field" then
		local action_place_component = self._action_place_component
		local position = action_place_component.position
		local rotation = action_place_component.rotation
		local shield_unit = self._shield_unit

		if shield_unit then
			local previous_position = self._previous_position:unbox()
			local previous_rotation = self._previous_rotation:unbox()

			position = Vector3.lerp(previous_position, position, dt * 20)
			rotation = Quaternion.lerp(previous_rotation, rotation, dt * 20)

			Unit.set_local_position(shield_unit, 1, position)
			Unit.set_local_rotation(shield_unit, 1, rotation)
		else
			local unit = action_settings.visual_unit

			self._start_t = t
			self._shield_unit = Managers.state.unit_spawner:spawn_unit(unit, position, rotation)
		end

		self._previous_position = Vector3Box(position)
		self._previous_rotation = QuaternionBox(rotation)
	else
		self:_destroy_effects()
	end
end

PsykerForceFieldPlacementPreviewEffects._destroy_effects = function (self)
	local shield_unit = self._shield_unit
	local is_unit_alive = shield_unit and Unit.alive(shield_unit)

	if is_unit_alive then
		Managers.state.unit_spawner:mark_for_deletion(shield_unit)

		self._shield_unit = nil
	end
end

return PsykerForceFieldPlacementPreviewEffects
