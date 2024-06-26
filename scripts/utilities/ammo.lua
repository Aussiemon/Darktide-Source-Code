-- chunkname: @scripts/utilities/ammo.lua

local Ammo = {}

Ammo.ammo_is_full = function (unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve
		local max_ammo_clip = inventory_slot_component.max_ammunition_clip
		local ammo_reserve = inventory_slot_component.current_ammunition_reserve
		local ammo_clip = inventory_slot_component.current_ammunition_clip

		if max_ammo_reserve > 0 and max_ammo_clip > 0 then
			local missing_ammo = ammo_clip + ammo_reserve < max_ammo_clip + max_ammo_reserve

			if missing_ammo then
				return false
			end
		end
	end

	return true
end

Ammo.clip_ammo_is_full = function (unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local ammo_clip = inventory_slot_component.current_ammunition_clip
		local max_ammo_clip = inventory_slot_component.max_ammunition_clip

		if max_ammo_clip > 0 and ammo_clip < max_ammo_clip then
			return false
		end
	end

	return true
end

Ammo.reserve_ammo_is_full = function (unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local ammo_reserve = inventory_slot_component.current_ammunition_reserve
		local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve

		if max_ammo_reserve > 0 and ammo_reserve < max_ammo_reserve then
			return false
		end
	end

	return true
end

Ammo.uses_ammo = function (unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local max_ammo_clip = inventory_slot_component.max_ammunition_clip

		if max_ammo_clip > 0 then
			return true
		end
	end

	return false
end

Ammo.current_slot_percentage = function (unit, slot_name)
	if slot_name == "none" then
		return 1
	end

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
	local config = weapon_slot_configuration[slot_name]

	if config then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local ammo_reserve = inventory_slot_component.current_ammunition_reserve
		local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve

		if max_ammo_reserve <= 0 then
			return 1
		end

		local percentage = ammo_reserve / max_ammo_reserve

		return percentage
	else
		return 1
	end
end

Ammo.current_slot_clip_percentage = function (unit, slot_name)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local slot_configuration = visual_loadout_extension:slot_configuration()
	local config = slot_configuration[slot_name]

	if slot_name ~= "none" and config.slot_type == "weapon" then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local ammo_clip = inventory_slot_component.current_ammunition_clip
		local max_ammo_clip = inventory_slot_component.max_ammunition_clip

		if max_ammo_clip <= 0 then
			return 1
		end

		local percentage = ammo_clip / max_ammo_clip

		return percentage
	else
		return 1
	end
end

Ammo.current_slot_clip_amount = function (unit, slot_name)
	if slot_name == "none" then
		return 0
	end

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
	local config = weapon_slot_configuration[slot_name]

	if config then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local ammo_clip = inventory_slot_component.current_ammunition_clip
		local ammo_reserve = inventory_slot_component.current_ammunition_reserve

		return ammo_clip, ammo_reserve
	else
		return 0, 0
	end
end

Ammo.max_slot_clip_amount = function (unit, slot_name)
	if slot_name == "none" then
		return 0
	end

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
	local config = weapon_slot_configuration[slot_name]

	if config then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local max_ammo_clip = inventory_slot_component.max_ammunition_clip

		return max_ammo_clip
	else
		return 0
	end
end

Ammo.missing_slot_clip_amount = function (unit, slot_name)
	if slot_name == "none" then
		return 0
	end

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
	local config = weapon_slot_configuration[slot_name]

	if config then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local ammo_clip = inventory_slot_component.current_ammunition_clip
		local max_ammo_clip = inventory_slot_component.max_ammunition_clip

		return max_ammo_clip - ammo_clip
	else
		return 0
	end
end

Ammo.current_slot_ammo_consumption_percentage = function (unit, slot_name, ammo_consumption)
	if slot_name == "none" then
		return 1
	end

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
	local config = weapon_slot_configuration[slot_name]

	if config then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local ammo_clip = inventory_slot_component.current_ammunition_clip
		local percentage = math.min(ammo_clip / ammo_consumption, 1)

		return percentage
	else
		return 1
	end
end

Ammo.current_total_percentage = function (unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local total_ammo_reserve, total_max_ammo_reserve = 0, 0
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local ammo_reserve = inventory_slot_component.current_ammunition_reserve
		local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve

		total_ammo_reserve = total_ammo_reserve + ammo_reserve
		total_max_ammo_reserve = total_max_ammo_reserve + max_ammo_reserve
	end

	if total_max_ammo_reserve > 0 then
		local percentage = total_ammo_reserve / total_max_ammo_reserve

		return percentage
	else
		return 1
	end
end

Ammo.add_to_clip = function (inventory_slot_component, ammunition_to_add)
	local max_ammo_in_clip = inventory_slot_component.max_ammunition_clip
	local current_ammo_in_clip = inventory_slot_component.current_ammunition_clip
	local new_ammo_clip_size = math.clamp(math.min(ammunition_to_add + current_ammo_in_clip, max_ammo_in_clip), 0, max_ammo_in_clip)

	inventory_slot_component.current_ammunition_clip = new_ammo_clip_size

	local actual_ammo_added = new_ammo_clip_size - current_ammo_in_clip

	return actual_ammo_added
end

Ammo.add_to_reserve = function (inventory_slot_component, ammunition_to_add)
	local max_ammo_in_reserve = inventory_slot_component.max_ammunition_reserve
	local current_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve
	local new_ammo_reserve_size = math.clamp(math.min(ammunition_to_add + current_ammo_in_reserve, max_ammo_in_reserve), 0, max_ammo_in_reserve)

	inventory_slot_component.current_ammunition_reserve = new_ammo_reserve_size

	local actual_ammo_added = new_ammo_reserve_size - current_ammo_in_reserve

	return actual_ammo_added
end

Ammo.transfer_from_reserve_to_clip = function (inventory_slot_component, ammunition_to_transfer)
	if Managers.state.game_mode:infinite_ammo_reserve() then
		inventory_slot_component.current_ammunition_reserve = inventory_slot_component.max_ammunition_reserve + inventory_slot_component.max_ammunition_clip
	end

	local current_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve
	local actual_ammo_to_transfer = math.min(ammunition_to_transfer, current_ammo_in_reserve)
	local actual_ammo_added = Ammo.add_to_clip(inventory_slot_component, actual_ammo_to_transfer)

	inventory_slot_component.current_ammunition_reserve = current_ammo_in_reserve - actual_ammo_added
end

Ammo.remove_from_reserve = function (inventory_slot_component, ammunition_to_remove)
	if Managers.state.game_mode:infinite_ammo_reserve() then
		inventory_slot_component.current_ammunition_reserve = inventory_slot_component.max_ammunition_reserve
	end

	local current_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve
	local actual_ammunition_to_remove = math.min(ammunition_to_remove, current_ammo_in_reserve)

	inventory_slot_component.current_ammunition_reserve = current_ammo_in_reserve - actual_ammunition_to_remove

	return actual_ammunition_to_remove
end

Ammo.move_clip_to_reserve = function (inventory_slot_component)
	local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve
	local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
	local new_ammunition_reserve = current_ammunition_reserve + current_ammunition_clip

	if Managers.state.game_mode:infinite_ammo_reserve() then
		new_ammunition_reserve = inventory_slot_component.max_ammunition_reserve
	end

	inventory_slot_component.current_ammunition_reserve = new_ammunition_reserve
	inventory_slot_component.current_ammunition_clip = 0
end

Ammo.add_to_all_slots = function (unit, percent)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
	local ammo_gained = 0
	local weapon_system = Managers.state.extension:system("weapon_system")
	local give_ammo_carryover_percentages = weapon_system:give_ammo_carryover_percentages(unit, weapon_slot_configuration)

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_extension:write_component(slot_name)

		if inventory_slot_component.max_ammunition_reserve > 0 then
			local ammo_reserve = inventory_slot_component.current_ammunition_reserve
			local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve
			local ammo_clip = inventory_slot_component.current_ammunition_clip
			local max_ammo_clip = inventory_slot_component.max_ammunition_clip
			local missing_clip = max_ammo_clip - ammo_clip
			local carryover_percentage = give_ammo_carryover_percentages[slot_name]
			local amount = percent * max_ammo_reserve + carryover_percentage
			local ammo_to_gain = math.floor(amount)
			local new_carryover_percentage = amount - ammo_to_gain

			give_ammo_carryover_percentages[slot_name] = new_carryover_percentage

			local new_ammo_amount = math.min(ammo_reserve + ammo_to_gain, max_ammo_reserve + missing_clip)

			inventory_slot_component.current_ammunition_reserve = new_ammo_amount
			ammo_gained = ammo_gained + (new_ammo_amount - ammo_reserve)
		end
	end

	return ammo_gained
end

return Ammo
