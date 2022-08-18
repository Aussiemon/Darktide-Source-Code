local Pocketable = class("Pocketable")

Pocketable.init = function (self, context, slot, weapon_template, fx_sources)
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit

	if self._is_local_unit then
		local unit_data_extension = ScriptUnit.extension(context.owner_unit, "unit_data_system")
		self._action_component = unit_data_extension:read_component("action_place")
		self._slot = slot
		self._preview_unit_name = slot.item.preview_unit
	end
end

Pocketable.destroy = function (self)
	self:_despawn_preview_unit_if_needed()
end

Pocketable.wield = function (self)
	return
end

Pocketable.unwield = function (self)
	self:_despawn_preview_unit_if_needed()
end

Pocketable.fixed_update = function (self, unit, dt, t, frame)
	return
end

Pocketable.update = function (self, unit, dt, t)
	if not self._is_local_unit then
		return
	end

	local action_component = self._action_component
	local position = action_component.position
	local rotation = action_component.rotation
	local can_place = action_component.can_place
	local aiming_place = action_component.aiming_place

	if aiming_place then
		if can_place then
			self:_spawn_preview_unit_if_needed(position, rotation)

			local delta = dt * 15
			local current_position = Unit.world_position(self._preview_unit, 1)
			local new_position = Vector3.lerp(current_position, position, delta)
			local current_rotation = Unit.world_rotation(self._preview_unit, 1)
			local new_rotation = Quaternion.lerp(current_rotation, rotation, delta)

			Unit.set_local_position(self._preview_unit, 1, new_position)
			Unit.set_local_rotation(self._preview_unit, 1, new_rotation)
		elseif ALIVE[self._preview_unit] then
			Managers.state.unit_spawner:mark_for_deletion(self._preview_unit)
		end
	else
		self:_despawn_preview_unit_if_needed()
	end
end

Pocketable._spawn_preview_unit_if_needed = function (self, position, rotation)
	local is_unit_alive = self._preview_unit and Unit.alive(self._preview_unit)

	if not is_unit_alive then
		self._preview_unit = Managers.state.unit_spawner:spawn_unit(self._preview_unit_name, position, rotation)
	end
end

Pocketable._despawn_preview_unit_if_needed = function (self)
	local is_unit_alive = self._preview_unit and Unit.alive(self._preview_unit)

	if is_unit_alive then
		Managers.state.unit_spawner:mark_for_deletion(self._preview_unit)

		self._preview_unit = nil
	end
end

Pocketable.update_first_person_mode = function (self, first_person_mode)
	return
end

return Pocketable
