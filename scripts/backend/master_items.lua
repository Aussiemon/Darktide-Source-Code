local MasterItems = {}

local function assert_backend()
	return
end

MasterItems.default_inventory = function (archetype_name, game_mode_settings_or_nil)
	if game_mode_settings_or_nil then
		local default_inventory = game_mode_settings_or_nil.default_inventory
		local archetype_default_inventory = default_inventory and default_inventory[archetype_name]

		if archetype_default_inventory then
			local inventory = {}

			for slot_name, item_name in pairs(archetype_default_inventory) do
				inventory[slot_name] = MasterItems.get_cached()[item_name]
			end

			return inventory
		end
	end

	return {
		slot_unarmed = MasterItems.get_cached()["content/items/weapons/player/melee/unarmed"]
	}
end

local FALLBACK_ITEMS_BY_SLOT = {
	slot_body_hair = "content/items/characters/player/human/attachments_default/slot_body_hair",
	slot_animation_emote_5 = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_body_tattoo = "content/items/characters/player/human/attachments_default/slot_body_torso",
	slot_gear_extra_cosmetic = "content/items/characters/player/human/attachments_default/slot_attachment",
	slot_animation_emote_3 = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_body_skin_color = "content/items/characters/player/skin_colors/skin_color_pale_01",
	slot_pocketable = "content/items/pocketable/empty_pocketable",
	slot_attachment_1 = "content/items/characters/player/human/attachments_default/slot_attachment",
	slot_body_face_scar = "content/items/characters/player/human/attachments_default/slot_body_face",
	slot_attachment_2 = "content/items/characters/player/human/attachments_default/slot_attachment",
	slot_trinket_1 = "content/items/weapons/player/trinkets/empty_trinket",
	slot_attachment_3 = "content/items/characters/player/human/attachments_default/slot_attachment",
	slot_body_face_implant = "content/items/characters/player/human/attachments_default/slot_body_face",
	slot_gear_upperbody = "content/items/characters/player/human/attachments_default/slot_gear_torso",
	slot_body_face_hair = "content/items/characters/player/human/attachments_default/slot_body_face",
	slot_body_legs = "content/items/characters/player/human/attachments_default/slot_body_legs",
	slot_secondary = "content/items/weapons/player/melee/unarmed",
	slot_body_face = "content/items/characters/player/human/attachments_default/slot_body_face",
	slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_blue_01",
	slot_weapon_skin = "content/items/weapons/player/skins/lasgun/lasgun_p1_m001",
	slot_gear_lowerbody = "content/items/characters/player/human/attachments_default/slot_gear_legs",
	slot_portrait_frame = "content/items/2d/portrait_frames/portrait_frame_default",
	slot_body_face_tattoo = "content/items/characters/player/human/attachments_default/slot_body_face",
	slot_insignia = "content/items/2d/insignias/insignia_default",
	slot_body_torso = "content/items/characters/player/human/attachments_default/slot_body_torso",
	slot_primary = "content/items/weapons/player/melee/unarmed",
	slot_unarmed = "content/items/weapons/player/melee/unarmed",
	slot_device = "content/items/devices/empty_device",
	slot_animation_end_of_round = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_animation_emote_4 = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_animation_emote_1 = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_gear_head = "content/items/characters/player/human/attachments_default/slot_gear_head",
	slot_body_arms = "content/items/characters/player/human/attachments_default/slot_body_arms",
	slot_skin_set = "content/items/characters/player/sets/empty_set",
	slot_animation_emote_2 = "content/items/animations/emotes/emote_human_greeting_001_wave_01",
	slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_01"
}

if BUILD == "release" then
	FALLBACK_ITEMS_BY_SLOT.slot_body_face_tattoo = "content/items/characters/player/human/face_tattoo/empty_face_tattoo"
	FALLBACK_ITEMS_BY_SLOT.slot_body_face_scar = "content/items/characters/player/human/face_scars/empty_face_scar"
	FALLBACK_ITEMS_BY_SLOT.slot_body_face_hair = "content/items/characters/player/human/face_hair/empty_face_hair"
	FALLBACK_ITEMS_BY_SLOT.slot_body_hair = "content/items/characters/player/human/hair/empty_hair"
	FALLBACK_ITEMS_BY_SLOT.slot_body_tattoo = "content/items/characters/player/human/body_tattoo/empty_body_tattoo"
	FALLBACK_ITEMS_BY_SLOT.slot_body_eye_color = "content/items/characters/player/eye_colors/eye_color_blue_01"
	FALLBACK_ITEMS_BY_SLOT.slot_body_hair_color = "content/items/characters/player/hair_colors/hair_color_brown_01"
	FALLBACK_ITEMS_BY_SLOT.slot_gear_extra_cosmetic = "items/characters/player/human/backpacks/empty_backpack"
	FALLBACK_ITEMS_BY_SLOT.slot_gear_head = "content/items/characters/player/human/gear_head/empty_headgear"
	FALLBACK_ITEMS_BY_SLOT.slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/empty_lowerbody"
	FALLBACK_ITEMS_BY_SLOT.slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/empty_upperbody"
end

MasterItems.find_fallback_item_id = function (slot)
	local fallback_name = slot and FALLBACK_ITEMS_BY_SLOT[slot]

	return fallback_name
end

MasterItems.find_fallback_item = function (slot)
	local fallback_id = MasterItems.find_fallback_item_id(slot)
	local fallback_item = MasterItems.get_item(fallback_id)

	return fallback_item
end

local function _fallback_item(gear)
	local instance_id = gear.masterDataInstance.id

	Log.error("MasterItemCache", string.format("No master data for item with id %s", instance_id))

	local slot = gear.slots and gear.slots[1]
	local fallback_name = slot and FALLBACK_ITEMS_BY_SLOT[slot]

	Log.warning("MasterItemCache", string.format("Using fallback with name %s", fallback_name))

	local fallback = rawget(MasterItems.get_cached(), fallback_name)

	return fallback
end

local _merge_item_data_recursive = nil

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

		local temp_overrides = rawget(item_instance, "__temp_overrides")

		if temp_overrides then
			_merge_item_data_recursive(clone, temp_overrides)
		end

		rawset(item_instance, "__master_item", clone)
		rawset(item_instance, "set_temporary_overrides", function (self, temp_overrides)
			rawset(item_instance, "__temp_overrides", temp_overrides)
			_update_master_data(item_instance)
		end)

		return true
	end

	return false
end

local function _item_plus_overrides(gear, gear_id, is_preview_item)
	local item_instance = {
		__gear = gear,
		__gear_id = is_preview_item and gear_id .. math.uuid() or gear_id,
		__is_preview_item = is_preview_item and true or false
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

			return master_item[field_name]
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
		end
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
				overrides = data.overrides
			}
		},
		__gear_id = data.gear_id
	}
	local overrides = item_instance.__gear.masterDataInstance.overrides

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

			return master_item[field_name]
		end,
		__newindex = function (t, field_name, value)
			ferror("Not allowed to modify inventory items - %s[%s]", rawget(item_instance, "__gear_id"), field_name)
		end,
		__tostring = function (t)
			local master_item = rawget(item_instance, "__master_item")

			return string.format("master_item: [%s] gear_id: [%s]", tostring(master_item and master_item.name), tostring(rawget(item_instance, "__gear_id")))
		end
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

	return Managers.backend.interfaces.master_data:items_cache():refresh()
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
