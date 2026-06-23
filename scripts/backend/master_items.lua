-- chunkname: @scripts/backend/master_items.lua

local FallbackItems = require("scripts/settings/item/fallback_items")
local FALLBACK_ITEMS_BY_SLOT = FallbackItems.by_slot
local MasterItems = {}

local function assert_backend()
	return
end

MasterItems.default_inventory = function (archetype_name, game_mode_settings_or_nil)
	local inventory = {
		slot_unarmed = MasterItems.get_cached()["content/items/weapons/player/melee/unarmed"],
	}

	do
		local Archetypes = require("scripts/settings/archetype/archetypes")
		local archetype = Archetypes[archetype_name]
		local default_inventory = archetype.default_inventory

		if default_inventory then
			for slot_name, item_name in pairs(default_inventory) do
				inventory[slot_name] = MasterItems.get_cached()[item_name]
			end
		end
	end

	if game_mode_settings_or_nil then
		local default_inventory = game_mode_settings_or_nil.default_inventory
		local archetype_default_inventory = default_inventory and default_inventory[archetype_name]

		if archetype_default_inventory then
			for slot_name, item_name in pairs(archetype_default_inventory) do
				inventory[slot_name] = MasterItems.get_cached()[item_name]
			end
		end
	end

	return inventory
end

MasterItems.find_fallback_item_id = function (slot_name)
	return FALLBACK_ITEMS_BY_SLOT[slot_name]
end

MasterItems.find_fallback_item = function (slot_name)
	local fallback_id = MasterItems.find_fallback_item_id(slot_name)
	local fallback_item = MasterItems.get_item(fallback_id)

	return fallback_item
end

local function _fallback_item(gear)
	local instance_id = gear.masterDataInstance.id

	Log.error("MasterItemCache", string.format("No master data for item with id %s", instance_id))

	local slot_name = gear.slots and gear.slots[1]
	local fallback_name = FALLBACK_ITEMS_BY_SLOT[slot_name]

	if not fallback_name then
		Log.error("MasterItemCache", string.format("No fallback item found for %s in slot %s", instance_id, slot_name))

		return nil
	end

	Log.warning("MasterItemCache", string.format("Using fallback with name %s", fallback_name))

	local fallback = rawget(MasterItems.get_cached(), fallback_name)

	return fallback
end

local _merge_item_data_recursive

function _merge_item_data_recursive(dest, source)
	for key, value in pairs(source) do
		local is_table = type(value) == "table"

		if value == source then
			dest[key] = dest
		elseif is_table and type(dest[key]) == "table" then
			_merge_item_data_recursive(dest[key], value)
		else
			dest[key] = value
		end
	end

	return dest
end

local function _validate_overrides(overrides)
	local traits = overrides.traits

	if traits then
		for i = #traits, 1, -1 do
			local data = traits[i]
			local trait_id = data.id
			local trait_exists = rawget(MasterItems.get_cached(), trait_id)

			if not trait_exists then
				table.remove(traits, i)
			end
		end
	end

	local perks = overrides.perks

	if perks then
		for i = #perks, 1, -1 do
			local data = perks[i]
			local perk_id = data.id
			local perk_exists = rawget(MasterItems.get_cached(), perk_id)

			if not perk_exists then
				table.remove(perks, i)
			end
		end
	end
end

local function _update_master_data(item_instance)
	rawset(item_instance, "__master_ver", MasterItems.get_cached_version())

	local gear = rawget(item_instance, "__gear")
	local item = rawget(MasterItems.get_cached(), gear.masterDataInstance.id)

	item = item or _fallback_item(gear)

	if item then
		local clone = table.clone(item)
		local overrides = gear.masterDataInstance.overrides

		if overrides then
			_validate_overrides(overrides)
			_merge_item_data_recursive(clone, overrides)
		end

		local count = gear.count

		if count then
			clone.count = count
		end

		local temp_overrides = rawget(item_instance, "__temp_overrides")

		if temp_overrides then
			_merge_item_data_recursive(clone, temp_overrides)
		end

		rawset(item_instance, "__master_item", clone)
		rawset(item_instance, "set_temporary_overrides", function (self, new_temp_overrides)
			rawset(item_instance, "__temp_overrides", new_temp_overrides)

			return _update_master_data(item_instance)
		end)

		return true
	end

	return false
end

local function _item_plus_overrides(gear, gear_id, is_preview_item)
	local item_instance = {
		__gear = gear,
		__gear_id = is_preview_item and math.uuid() or gear_id,
		__original_gear_id = is_preview_item and gear_id,
		__is_preview_item = is_preview_item and true or false,
	}

	setmetatable(item_instance, {
		__index = function (t, field_name)
			local master_ver = rawget(item_instance, "__master_ver")

			if master_ver ~= MasterItems.get_cached_version() then
				local success = _update_master_data(item_instance)

				if not success then
					Log.error("MasterItems", "[_item_plus_overrides][1] could not update master data with %s", gear.masterDataInstance.id)

					return nil
				end
			end

			if field_name == "gear_id" then
				return rawget(item_instance, "__gear_id")
			end

			if field_name == "gear" then
				return rawget(item_instance, "__gear")
			end

			local master_item = rawget(item_instance, "__master_item")

			if not master_item then
				Log.warning("MasterItemCache", string.format("No master data for item with id %s", gear.masterDataInstance.id))

				return nil
			end

			local field_value = master_item[field_name]

			if field_name == "rarity" and field_value == -1 then
				return nil
			end

			return field_value
		end,
		__newindex = function (t, field_name, value)
			if is_preview_item then
				rawset(t, field_name, value)
			else
				ferror("Not allowed to modify inventory items - %s[%s]", rawget(item_instance, "__gear_id"), field_name)
			end
		end,
		__tostring = function (t)
			local master_item = rawget(item_instance, "__master_item")

			return string.format("master_item: [%s] gear_id: [%s]", tostring(master_item and master_item.name), tostring(rawget(item_instance, "__gear_id")))
		end,
	})

	local success = _update_master_data(item_instance)

	if not success then
		Log.error("MasterItems", "[_item_plus_overrides][2] could not update master data with %s", gear.masterDataInstance.id)

		return nil
	end

	return item_instance
end

local function _store_item_plus_overrides(data)
	local item_instance = {
		__data = data,
		__gear = {
			masterDataInstance = {
				id = data.id,
				overrides = data.overrides,
			},
		},
		__gear_id = data.gear_id or data.gearId,
	}

	setmetatable(item_instance, {
		__index = function (t, field_name)
			local master_ver = rawget(item_instance, "__master_ver")

			if master_ver ~= MasterItems.get_cached_version() then
				local success = _update_master_data(item_instance)

				if not success then
					Log.error("MasterItems", "[_store_item_plus_overrides][1] could not update master data with %s; %s", data.id, data.gear_id)

					return nil
				end
			end

			if field_name == "gear_id" then
				return rawget(item_instance, "__gear_id")
			end

			if field_name == "gear" then
				return rawget(item_instance, "__gear")
			end

			local master_item = rawget(item_instance, "__master_item")

			if not master_item then
				Log.warning("MasterItemCache", string.format("No master data for item with id %s", item_instance.__asset_id))

				return nil
			end

			local field_value = master_item[field_name]

			if field_name == "rarity" and field_value == -1 then
				return nil
			end

			return field_value
		end,
		__newindex = function (t, field_name, value)
			ferror("Not allowed to modify inventory items - %s[%s]", rawget(item_instance, "__gear_id"), field_name)
		end,
		__tostring = function (t)
			local master_item = rawget(item_instance, "__master_item")

			return string.format("master_item: [%s] gear_id: [%s]", tostring(master_item and master_item.name), tostring(rawget(item_instance, "__gear_id")))
		end,
	})

	local success = _update_master_data(item_instance)

	if not success then
		Log.error("MasterItems", "[_store_item_plus_overrides][2] could not update master data with %s; %s", data.id, data.gear_id)

		return nil
	end

	return item_instance
end

MasterItems.get_item_instance = function (gear, gear_id)
	if not gear then
		Log.warning("MasterItemCache", string.format("Gear list missing gear with id %s", gear_id))

		return nil
	else
		return _item_plus_overrides(gear, gear_id)
	end
end

MasterItems.create_preview_item_instance = function (item)
	local gear = table.clone_instance(item.__gear)
	local gear_id = item.__gear_id

	if not gear then
		Log.warning("MasterItemCache", string.format("Gear list missing gear with id %s", gear_id))

		return nil
	else
		local allow_modifications = true

		return _item_plus_overrides(gear, gear_id, allow_modifications)
	end
end

MasterItems.get_store_item_instance = function (description)
	return _store_item_plus_overrides(description)
end

MasterItems.get_ui_item_instance = function (item)
	local gear_override = item.gear and item.gear.masterDataInstance and item.gear.masterDataInstance.overrides
	local overrides = item.overrides or gear_override

	if overrides then
		overrides = table.clone_instance(overrides)
	else
		overrides = {}
	end

	if item.slot_weapon_skin then
		overrides.slot_weapon_skin = type(item.slot_weapon_skin) == "table" and item.slot_weapon_skin.name or item.slot_weapon_skin
	end

	local item_instance = {
		__is_preview_item = true,
		__is_ui_item_preview = true,
		__gear = {
			masterDataInstance = {
				id = item.name,
				overrides = overrides,
			},
		},
		__gear_id = item.gear_id or math.uuid(),
	}

	setmetatable(item_instance, {
		__index = function (t, field_name)
			local master_ver = rawget(item_instance, "__master_ver")

			if master_ver ~= MasterItems.get_cached_version() then
				local success = _update_master_data(item_instance)

				if not success then
					Log.error("MasterItems", "[_store_item_plus_overrides][1] could not update master data with %s; %s", item.name, item.gear_id)

					return nil
				end
			end

			if field_name == "gear_id" then
				return rawget(item_instance, "__gear_id")
			end

			if field_name == "gear" then
				return rawget(item_instance, "__gear")
			end

			local master_item = rawget(item_instance, "__master_item")

			if not master_item then
				Log.warning("MasterItemCache", string.format("UI - No master data for item with id %s", item.name))

				return nil
			end

			local field_value = master_item[field_name]

			if field_name == "rarity" and field_value == -1 then
				return nil
			end

			return field_value
		end,
		__newindex = function (t, field_name, value)
			rawset(t, field_name, value)
		end,
		__tostring = function (t)
			local master_item = rawget(item_instance, "__master_item")

			return string.format("master_item: [%s] gear_id: [%s]", tostring(master_item and master_item.name), tostring(rawget(item_instance, "__gear_id")))
		end,
	})

	local success = _update_master_data(item_instance)

	if not success then
		Log.error("MasterItems", "UI - [_store_item_plus_overrides][2] could not update master data with %s; %s", item.name, item.gear_id)

		return nil
	end

	return item_instance
end

MasterItems.add_listener = function (callback_fn)
	assert_backend()

	return Managers.backend.interfaces.master_data:items_cache():add_listener(callback_fn)
end

MasterItems.remove_listener = function (callback_fn)
	assert_backend()

	return Managers.backend.interfaces.master_data:items_cache():remove_listener(callback_fn)
end

MasterItems.get_by_url = function (version, url)
	assert_backend()

	return Managers.backend.interfaces.master_data:items_cache():refresh(version, url)
end

MasterItems.refresh = function ()
	assert_backend()

	return Managers.backend.interfaces.master_data:items_cache():refresh():next(function ()
		return true
	end)
end

MasterItems.get_cached = function ()
	assert_backend()

	return Managers.backend.interfaces.master_data:items_cache():get_cached()
end

MasterItems.get_cached_version = function ()
	assert_backend()

	return Managers.backend.interfaces.master_data:items_cache():get_version()
end

MasterItems.get_cached_metadata = function ()
	assert_backend()

	return Managers.backend.interfaces.master_data:items_cache():get_metadata()
end

MasterItems.has_data = function ()
	assert_backend()

	return Managers.backend.interfaces.master_data:items_cache():has_data()
end

MasterItems.get_item_or_fallback = function (id, slot_name, optional_item_definitions)
	if not optional_item_definitions then
		assert_backend()
	end

	local definitions = optional_item_definitions or MasterItems.get_cached()
	local item = definitions[id]

	if not item then
		local fallback_item_id = MasterItems.find_fallback_item_id(slot_name)

		if fallback_item_id then
			item = definitions[fallback_item_id]
		end
	end

	return item
end

MasterItems.get_item = function (id)
	assert_backend()

	return MasterItems.get_cached()[id]
end

MasterItems.item_exists = function (id)
	assert_backend()

	local master_items = MasterItems.get_cached()
	local raw_item = rawget(master_items, id)

	return not not raw_item
end

return MasterItems
