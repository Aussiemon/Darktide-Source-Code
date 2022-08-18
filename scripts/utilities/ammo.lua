local Ammo = {
	ammo_is_full = function (unit)
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

		for slot_name, config in pairs(weapon_slot_configuration) do
			local wieldable_component = unit_data_extension:read_component(slot_name)
			local max_ammo_reserve = wieldable_component.max_ammunition_reserve
			local max_ammo_clip = wieldable_component.max_ammunition_clip
			local ammo_reserve = wieldable_component.current_ammunition_reserve
			local ammo_clip = wieldable_component.current_ammunition_clip

			if max_ammo_reserve > 0 and max_ammo_clip > 0 then
				local missing_ammo = ammo_clip + ammo_reserve < max_ammo_clip + max_ammo_reserve

				if missing_ammo then
					return false
				end
			end
		end

		return true
	end,
	clip_ammo_is_full = function (unit)
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

		for slot_name, config in pairs(weapon_slot_configuration) do
			local wieldable_component = unit_data_extension:read_component(slot_name)
			local ammo_clip = wieldable_component.current_ammunition_clip
			local max_ammo_clip = wieldable_component.max_ammunition_clip

			if max_ammo_clip > 0 and ammo_clip < max_ammo_clip then
				return false
			end
		end

		return true
	end,
	reserve_ammo_is_full = function (unit)
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

		for slot_name, config in pairs(weapon_slot_configuration) do
			local wieldable_component = unit_data_extension:read_component(slot_name)
			local ammo_reserve = wieldable_component.current_ammunition_reserve
			local max_ammo_reserve = wieldable_component.max_ammunition_reserve

			if max_ammo_reserve > 0 and ammo_reserve < max_ammo_reserve then
				return false
			end
		end

		return true
	end,
	current_slot_percentage = function (unit, slot_name)
		if slot_name == "none" then
			return 1
		end

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
		local config = weapon_slot_configuration[slot_name]

		if config then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local wieldable_component = unit_data_extension:read_component(slot_name)
			local ammo_reserve = wieldable_component.current_ammunition_reserve
			local max_ammo_reserve = wieldable_component.max_ammunition_reserve

			if max_ammo_reserve <= 0 then
				return 1
			end

			local percentage = ammo_reserve / max_ammo_reserve

			return percentage
		else
			return 1
		end
	end,
	current_slot_clip_percentage = function (unit, slot_name)
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local slot_configuration = visual_loadout_extension:slot_configuration()
		local config = slot_configuration[slot_name]

		if slot_name ~= "none" and config.slot_type == "weapon" then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local wieldable_component = unit_data_extension:read_component(slot_name)
			local ammo_clip = wieldable_component.current_ammunition_clip
			local max_ammo_clip = wieldable_component.max_ammunition_clip

			if max_ammo_clip <= 0 then
				return 1
			end

			local percentage = ammo_clip / max_ammo_clip

			return percentage
		else
			return 1
		end
	end,
	current_slot_clip_amount = function (unit, slot_name)
		if slot_name == "none" then
			return 0
		end

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
		local config = weapon_slot_configuration[slot_name]

		if config then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local wieldable_component = unit_data_extension:read_component(slot_name)
			local ammo_clip = wieldable_component.current_ammunition_clip

			return ammo_clip
		else
			return 0
		end
	end,
	max_slot_clip_amount = function (unit, slot_name)
		if slot_name == "none" then
			return 0
		end

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
		local config = weapon_slot_configuration[slot_name]

		if config then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local wieldable_component = unit_data_extension:read_component(slot_name)
			local max_ammo_clip = wieldable_component.max_ammunition_clip

			return max_ammo_clip
		else
			return 0
		end
	end,
	missing_slot_clip_amount = function (unit, slot_name)
		if slot_name == "none" then
			return 0
		end

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
		local config = weapon_slot_configuration[slot_name]

		if config then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local wieldable_component = unit_data_extension:read_component(slot_name)
			local ammo_clip = wieldable_component.current_ammunition_clip
			local max_ammo_clip = wieldable_component.max_ammunition_clip

			return max_ammo_clip - ammo_clip
		else
			return 0
		end
	end,
	current_slot_ammo_consumption_percentage = function (unit, slot_name, ammo_consumption)
		if slot_name == "none" then
			return 1
		end

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
		local config = weapon_slot_configuration[slot_name]

		if config then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local wieldable_component = unit_data_extension:read_component(slot_name)
			local ammo_clip = wieldable_component.current_ammunition_clip
			local percentage = math.min(ammo_clip / ammo_consumption, 1)

			return percentage
		else
			return 1
		end
	end,
	current_total_percentage = function (unit)
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local total_ammo_reserve = 0
		local total_max_ammo_reserve = 0
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

		for slot_name, config in pairs(weapon_slot_configuration) do
			local wieldable_component = unit_data_extension:read_component(slot_name)
			local ammo_reserve = wieldable_component.current_ammunition_reserve
			local max_ammo_reserve = wieldable_component.max_ammunition_reserve
			total_ammo_reserve = total_ammo_reserve + ammo_reserve
			total_max_ammo_reserve = total_max_ammo_reserve + max_ammo_reserve
		end

		if total_max_ammo_reserve > 0 then
			local percentage = total_ammo_reserve / total_max_ammo_reserve

			return percentage
		else
			return 1
		end
	end,
	add_to_clip = function (inventory_slot_component, ammunition_to_add)
		local max_ammo_in_clip = inventory_slot_component.max_ammunition_clip
		local current_ammo_in_clip = inventory_slot_component.current_ammunition_clip
		local new_ammo_clip_size = math.clamp(math.min(ammunition_to_add + current_ammo_in_clip, max_ammo_in_clip), 0, max_ammo_in_clip)
		inventory_slot_component.current_ammunition_clip = new_ammo_clip_size
		local actual_ammo_added = new_ammo_clip_size - current_ammo_in_clip

		return actual_ammo_added
	end,
	transfer_from_reserve_to_clip = function (inventory_slot_component, ammunition_to_transfer)
		local current_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve
		local actual_ammo_to_transfer = math.min(ammunition_to_transfer, current_ammo_in_reserve)
		local actual_ammo_added = Ammo.add_to_clip(inventory_slot_component, actual_ammo_to_transfer)

		if Managers.state.game_mode:is_locked_reserve_ammo() then
			return
		end

		inventory_slot_component.current_ammunition_reserve = current_ammo_in_reserve - actual_ammo_added
	end,
	remove_from_reserve = function (inventory_slot_component, ammunition_to_remove)
		local current_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve
		local actual_ammunition_to_remove = math.min(ammunition_to_remove, current_ammo_in_reserve)

		if Managers.state.game_mode:is_locked_reserve_ammo() then
			return
		end

		inventory_slot_component.current_ammunition_reserve = current_ammo_in_reserve - actual_ammunition_to_remove
	end,
	move_clip_to_reserve = function (inventory_slot_component)
		local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
		local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve
		inventory_slot_component.current_ammunition_reserve = current_ammunition_reserve + current_ammunition_clip
		inventory_slot_component.current_ammunition_clip = 0
	end
}

return Ammo
