local Device = class("Device")

Device.init = function (self, context, slot, weapon_template, fx_sources)
	if not context.is_husk then
		local owner_unit = context.owner_unit
		local item_unit_1p = slot.unit_1p
		local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
		self._owner_unit = owner_unit
		self._item_unit_1p = item_unit_1p
		self._minigame_character_state_component = unit_data_extension:read_component("minigame_character_state")
		self._interactor_extension = ScriptUnit.extension(owner_unit, "interactor_system")
	end

	self._is_local_unit = context.is_local_unit
end

Device.fixed_update = function (self, unit, dt, t, frame)
	return
end

Device.update = function (self, unit, dt, t)
	return
end

Device.update_first_person_mode = function (self, first_person_mode)
	return
end

Device.wield = function (self)
	local item_unit = self._item_unit_1p

	if item_unit and self._is_local_unit then
		local scanner_display_extension = ScriptUnit.has_extension(item_unit, "scanner_display_system")

		if scanner_display_extension then
			local is_level_unit = true
			local minigame_character_state_component = self._minigame_character_state_component
			local level_unit_id = minigame_character_state_component.interface_unit_id
			local interface_unit = nil

			if level_unit_id ~= NetworkConstants.invalid_level_unit_id then
				interface_unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)
			else
				interface_unit = self._interactor_extension:target_unit()
			end

			scanner_display_extension:activate(self._owner_unit, interface_unit)
		end
	end
end

Device.unwield = function (self)
	local item_unit = self._item_unit_1p

	if item_unit and self._is_local_unit then
		local scanner_display_extension = ScriptUnit.has_extension(item_unit, "scanner_display_system")

		if scanner_display_extension then
			scanner_display_extension:deactivate()
		end
	end
end

Device.destroy = function (self)
	return
end

return Device
