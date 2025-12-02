-- chunkname: @scripts/utilities/ammo.lua

local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local Ammo = {}

Ammo.ammo_is_full = function (unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve
		local max_ammo_clip = Ammo.max_ammo_in_clips(inventory_slot_component)
		local ammo_reserve = inventory_slot_component.current_ammunition_reserve
		local ammo_clip = Ammo.current_ammo_in_clips(inventory_slot_component)

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
		local ammo_clip = Ammo.current_ammo_in_clips(inventory_slot_component)
		local max_ammo_clip = Ammo.max_ammo_in_clips(inventory_slot_component)

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

Ammo.uses_ammo = function (unit, optional_slot_name)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

	if optional_slot_name then
		local inventory_slot_component = unit_data_extension:read_component(optional_slot_name)

		return weapon_slot_configuration[optional_slot_name] and Ammo.max_ammo_in_clips(inventory_slot_component) > 0
	end

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local max_ammo_clip = Ammo.max_ammo_in_clips(inventory_slot_component)

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
		local ammo_clip = Ammo.current_ammo_in_clips(inventory_slot_component)
		local max_ammo_clip = Ammo.max_ammo_in_clips(inventory_slot_component)

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
		local ammo_clip = Ammo.current_ammo_in_clips(inventory_slot_component)
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
		local max_ammo_clip = Ammo.max_ammo_in_clips(inventory_slot_component)

		return max_ammo_clip
	else
		return 0
	end
end

Ammo.clip_in_use = function (inventory_slot_component, clip_index)
	local current_clips_in_use = inventory_slot_component.current_ammunition_clips_in_use

	return current_clips_in_use[clip_index] or false
end

Ammo.clips_in_use = function (inventory_slot_component, out_clips)
	local any_clip_in_use = false
	local clips_in_use = inventory_slot_component.current_ammunition_clips_in_use

	for i = 1, NetworkConstants.clips_in_use.max_size do
		if clips_in_use[i] then
			any_clip_in_use = true
			out_clips[i] = true
		else
			out_clips[i] = false
		end
	end

	return any_clip_in_use
end

Ammo.missing_ammo_in_clips = function (inventory_slot_component, optional_clip_index)
	local current_ammo_in_clip = Ammo.current_ammo_in_clips(inventory_slot_component, optional_clip_index)
	local max_ammo_in_clip = Ammo.max_ammo_in_clips(inventory_slot_component, optional_clip_index)
	local missing_ammo_in_clip = max_ammo_in_clip - current_ammo_in_clip

	return missing_ammo_in_clip
end

Ammo.current_ammo_in_clips = function (inventory_slot_component, optional_clip_index)
	if optional_clip_index then
		return inventory_slot_component.current_ammunition_clip[optional_clip_index] or 0
	end

	local current_ammo_in_clips = 0
	local max_num_clips = NetworkConstants.ammunition_clip_array.max_size

	for i = 1, max_num_clips do
		if Ammo.clip_in_use(inventory_slot_component, i) then
			current_ammo_in_clips = current_ammo_in_clips + inventory_slot_component.current_ammunition_clip[i]
		end
	end

	return current_ammo_in_clips
end

Ammo.max_ammo_in_clips = function (inventory_slot_component, optional_clip_index)
	if optional_clip_index then
		return inventory_slot_component.max_ammunition_clip[optional_clip_index] or 0
	end

	local max_ammo_in_clips = 0
	local max_num_clips = NetworkConstants.ammunition_clip_array.max_size

	for i = 1, max_num_clips do
		if Ammo.clip_in_use(inventory_slot_component, i) then
			max_ammo_in_clips = max_ammo_in_clips + inventory_slot_component.max_ammunition_clip[i]
		end
	end

	return max_ammo_in_clips
end

Ammo.set_max_ammo_in_clips = function (inventory_slot_component, amount, optional_clip_index)
	local max_num_clips = NetworkConstants.ammunition_clip_array.max_size

	for i = optional_clip_index or 1, optional_clip_index or max_num_clips do
		inventory_slot_component.max_ammunition_clip[i] = amount
	end
end

Ammo.current_ammo_in_reserve = function (inventory_slot_component)
	return inventory_slot_component.current_ammunition_reserve
end

Ammo.max_ammo_in_reserve = function (inventory_slot_component)
	return inventory_slot_component.max_ammunition_reserve
end

local _set_clip_fields_scratch = {}
local _set_clip_current_scratch = {}
local _set_clip_max_scratch = {}
local _set_clip_percentage_scratch = {}
local _set_clip_epsilon = 1e-09

local function _set_clip_sort_percentages_add(a, b)
	return _set_clip_percentage_scratch[a] < _set_clip_percentage_scratch[b]
end

local function _set_clip_sort_percentage_remove(a, b)
	return _set_clip_percentage_scratch[a] > _set_clip_percentage_scratch[b]
end

Ammo.set_current_ammo_in_clips = function (inventory_slot_component, amount, optional_clip_index)
	if optional_clip_index then
		inventory_slot_component.current_ammunition_clip[optional_clip_index] = amount
	else
		table.clear(_set_clip_fields_scratch)

		local max_num_clips = NetworkConstants.ammunition_clip_array.max_size
		local current_total = 0
		local n_fields = 0

		for i = 1, max_num_clips do
			if Ammo.clip_in_use(inventory_slot_component, i) then
				n_fields = n_fields + 1
				_set_clip_fields_scratch[n_fields] = i
				_set_clip_current_scratch[i] = Ammo.current_ammo_in_clips(inventory_slot_component, i)
				_set_clip_max_scratch[i] = Ammo.max_ammo_in_clips(inventory_slot_component, i)
				_set_clip_percentage_scratch[i] = _set_clip_current_scratch[i] / _set_clip_max_scratch[i]
				current_total = current_total + _set_clip_current_scratch[i]
			end
		end

		local diff = amount - current_total
		local adding = diff > 0

		while diff ~= 0 do
			local diff_before = diff

			table.sort(_set_clip_fields_scratch, adding and _set_clip_sort_percentages_add or _set_clip_sort_percentage_remove)

			local to_percentage_i = 1
			local previous_percentage = _set_clip_percentage_scratch[_set_clip_fields_scratch[1]]
			local target_percentage = adding and 1 or 0

			for i = 2, n_fields do
				local field_i = _set_clip_fields_scratch[i]
				local percentage = _set_clip_percentage_scratch[field_i]

				if math.abs(previous_percentage - percentage) < _set_clip_epsilon then
					to_percentage_i = i
				else
					target_percentage = _set_clip_percentage_scratch[field_i]

					break
				end
			end

			local total_room = 0

			for i = 1, to_percentage_i do
				local field_i = _set_clip_fields_scratch[i]
				local field_max = _set_clip_max_scratch[field_i]
				local field_current = _set_clip_current_scratch[field_i]
				local target_amount = math.min(math.ceil(field_max * target_percentage), field_max)
				local to_add = target_amount - field_current

				total_room = total_room + to_add
			end

			if total_room == 0 then
				return
			end

			local add_multiplier = math.min(math.abs(diff / total_room), 1)

			for i = 1, to_percentage_i do
				local field_i = _set_clip_fields_scratch[i]
				local field_max = _set_clip_max_scratch[field_i]
				local field_current = _set_clip_current_scratch[field_i]
				local target_amount = math.min(math.ceil(field_max * target_percentage), field_max)
				local to_add = math.sign(diff) * math.min(math.ceil(math.abs(target_amount - field_current) * add_multiplier), math.abs(diff))

				if to_add == 0 then
					return
				end

				local new_amount = field_current + to_add

				inventory_slot_component.current_ammunition_clip[field_i] = new_amount
				_set_clip_current_scratch[field_i] = new_amount
				_set_clip_percentage_scratch[field_i] = new_amount / field_max
				diff = diff - to_add
			end

			if diff == diff_before then
				ferror("Uncaught inability to add ammo. This was unexpected.\nAmmo component:\n%s", table.tostring(inventory_slot_component))
			end
		end
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

		return Ammo.missing_ammo_in_clips(inventory_slot_component)
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
		local ammo_clip = Ammo.current_ammo_in_clips(inventory_slot_component)
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

Ammo.add_to_clip = function (inventory_slot_component, ammunition_to_add, optional_clip_index)
	local max_ammo_in_clip = Ammo.max_ammo_in_clips(inventory_slot_component, optional_clip_index)
	local current_ammo_in_clip = Ammo.current_ammo_in_clips(inventory_slot_component, optional_clip_index)
	local new_ammo_clip_size = math.clamp(math.min(ammunition_to_add + current_ammo_in_clip, max_ammo_in_clip), 0, max_ammo_in_clip)

	Ammo.set_current_ammo_in_clips(inventory_slot_component, new_ammo_clip_size, optional_clip_index)

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

Ammo.transfer_from_reserve_to_clip = function (inventory_slot_component, ammunition_to_transfer, optional_clip_index)
	if Managers.state.game_mode:infinite_ammo_reserve() then
		inventory_slot_component.current_ammunition_reserve = inventory_slot_component.max_ammunition_reserve + Ammo.max_ammo_in_clips(inventory_slot_component)
	end

	local free_transfer = inventory_slot_component.free_ammunition_transfer
	local current_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve
	local actual_ammo_to_transfer = free_transfer and ammunition_to_transfer or math.min(ammunition_to_transfer, current_ammo_in_reserve)
	local actual_ammo_added = Ammo.add_to_clip(inventory_slot_component, actual_ammo_to_transfer, optional_clip_index)

	if not free_transfer then
		inventory_slot_component.current_ammunition_reserve = current_ammo_in_reserve - actual_ammo_added
	end
end

Ammo.remove_from_reserve = function (inventory_slot_component, ammunition_to_remove)
	local current_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve
	local actual_ammunition_to_remove = math.min(ammunition_to_remove, current_ammo_in_reserve)

	inventory_slot_component.current_ammunition_reserve = current_ammo_in_reserve - actual_ammunition_to_remove

	if Managers.state.game_mode:infinite_ammo_reserve() then
		inventory_slot_component.current_ammunition_reserve = inventory_slot_component.max_ammunition_reserve
	end

	return actual_ammunition_to_remove
end

Ammo.move_clip_to_reserve = function (inventory_slot_component)
	local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve
	local current_ammunition_clip = Ammo.current_ammo_in_clips(inventory_slot_component)
	local new_ammunition_reserve = current_ammunition_reserve + current_ammunition_clip

	if Managers.state.game_mode:infinite_ammo_reserve() then
		new_ammunition_reserve = inventory_slot_component.max_ammunition_reserve
	end

	inventory_slot_component.current_ammunition_reserve = new_ammunition_reserve

	Ammo.set_current_ammo_in_clips(inventory_slot_component, 0)
end

Ammo.add_to_all_slots = function (unit, percent)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.has_extension(unit, "visual_loadout_system")
	local ammo_gained = 0

	if visual_loadout_extension and visual_loadout_extension.slot_configuration_by_type then
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
		local weapon_system = Managers.state.extension:system("weapon_system")
		local give_ammo_carryover_percentages = weapon_system:give_ammo_carryover_percentages(unit, weapon_slot_configuration)

		for slot_name, config in pairs(weapon_slot_configuration) do
			local inventory_slot_component = unit_data_extension:write_component(slot_name)

			if inventory_slot_component.max_ammunition_reserve > 0 then
				local ammo_reserve = inventory_slot_component.current_ammunition_reserve
				local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve
				local ammo_clip = Ammo.current_ammo_in_clips(inventory_slot_component)
				local max_ammo_clip = Ammo.max_ammo_in_clips(inventory_slot_component)
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
	end

	return ammo_gained
end

Ammo.add_ammo_using_pickup_data = function (unit, pickup_data, skip_proc)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.has_extension(unit, "visual_loadout_system")

	if not visual_loadout_extension or not visual_loadout_extension.slot_configuration_by_type then
		return 0
	end

	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
	local total_ammo_restored = 0

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_ext:write_component(slot_name)

		if inventory_slot_component.max_ammunition_reserve > 0 then
			local ammo_reserve = inventory_slot_component.current_ammunition_reserve
			local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve
			local ammo_clip = Ammo.current_ammo_in_clips(inventory_slot_component)
			local max_ammo_clip = Ammo.max_ammo_in_clips(inventory_slot_component)
			local pickup_amount = pickup_data.ammo_amount_func(max_ammo_reserve, max_ammo_clip, pickup_data)
			local missing_clip = max_ammo_clip - ammo_clip
			local new_ammo_amount = math.min(ammo_reserve + pickup_amount, max_ammo_reserve + missing_clip)

			inventory_slot_component.current_ammunition_reserve = new_ammo_amount
			total_ammo_restored = total_ammo_restored + (new_ammo_amount - ammo_reserve)

			if not skip_proc then
				local missing_player_ammo = max_ammo_reserve - ammo_reserve

				if missing_player_ammo < pickup_amount * DialogueSettings.ammo_hog_pickup_share and not pickup_data.ammo_crate then
					local Vo = require("scripts/utilities/vo")

					Vo.ammo_hog_event(unit, inventory_slot_component, pickup_data)
				end

				local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

				if buff_extension then
					local param_table = buff_extension:request_proc_event_param_table()

					if param_table then
						local BuffSettings = require("scripts/settings/buff/buff_settings")
						local buff_proc_events = BuffSettings.proc_events

						param_table.pickup_amount = pickup_amount
						param_table.pickup_name = pickup_data.name
						param_table.new_ammo_amount = new_ammo_amount

						buff_extension:add_proc_event(buff_proc_events.on_ammo_pickup, param_table)
					end
				end
			end
		end
	end

	return total_ammo_restored
end

return Ammo
