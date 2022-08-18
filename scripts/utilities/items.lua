local FixedFrame = require("scripts/utilities/fixed_frame")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local UISettings = require("scripts/settings/ui/ui_settings")
local unit_alive = Unit.alive
local ItemUtils = {
	mark_item_id_as_new = function (gear_id)
		local account_data = Managers.save:account_data()

		if not account_data.new_items then
			account_data.new_items = {}
		end

		local new_items = account_data.new_items
		new_items[#new_items + 1] = gear_id

		Managers.save:queue_save()
		Managers.event:trigger("event_resync_character_news_feed")
	end,
	unmark_item_id_as_new = function (gear_id)
		local account_data = Managers.save:account_data()
		local new_items = account_data.new_items
		local table_index = new_items and table.index_of(new_items, gear_id)

		if table_index then
			table.remove(new_items, table_index)
			Managers.save:queue_save()
		end
	end,
	new_item_ids = function ()
		local account_data = Managers.save:account_data()
		local new_items = account_data.new_items

		return new_items
	end
}
local temp_item_name_localization_context = {}

ItemUtils.display_name = function (item)
	if not item then
		return "n/a"
	end

	local pattern = item.pattern
	local variant = item.variant
	local display_name = item.display_name
	local localization_function = Localize
	local pattern_localization_key = UISettings.item_pattern_localization_lookup[pattern]
	local pattern_display_name_localized = pattern_localization_key and localization_function(pattern_localization_key) or "-"
	local variant_localization_key = UISettings.item_variant_localization_lookup[variant]
	local variant_display_name_localized = variant_localization_key and localization_function(variant_localization_key) or "-"
	local display_name_localized = display_name and localization_function(display_name) or "-"
	temp_item_name_localization_context.pattern = pattern_display_name_localized
	temp_item_name_localization_context.variant = variant_display_name_localized
	temp_item_name_localization_context.item_display_name = display_name_localized
	local no_cache = true

	return display_name_localized
end

local temp_item_sub_display_name_localization_context = {
	rarity_color_b = 0,
	item_type = "n/a",
	rarity_name = "n/a",
	rarity_color_g = 0,
	rarity_color_r = 0
}

ItemUtils.sub_display_name = function (item)
	local item_type_display_name_localized = ItemUtils.type_display_name(item)

	if item.rarity then
		local rarity_display_name_localized = ItemUtils.rarity_display_name(item)
		local rarity_color = ItemUtils.rarity_color(item)
		temp_item_sub_display_name_localization_context.rarity_color_r = rarity_color[2]
		temp_item_sub_display_name_localization_context.rarity_color_g = rarity_color[3]
		temp_item_sub_display_name_localization_context.rarity_color_b = rarity_color[4]
		temp_item_sub_display_name_localization_context.rarity_name = rarity_display_name_localized
		temp_item_sub_display_name_localization_context.item_type = item_type_display_name_localized
		local no_cache = true
		item_type_display_name_localized = Localize("loc_item_display_rarity_type_format_key", no_cache, temp_item_sub_display_name_localization_context)
	end

	return item_type_display_name_localized
end

ItemUtils.type_display_name = function (item)
	local item_type = item.item_type
	local item_type_localization_key = UISettings.item_type_localization_lookup[item_type]
	local item_type_display_name_localized = item_type_localization_key and Localize(item_type_localization_key) or "<undefined item_type>"

	return item_type_display_name_localized
end

ItemUtils.type_texture = function (item)
	local item_type = item.item_type
	local item_type_texture_path = UISettings.item_type_texture_lookup[item_type] or "content/ui/textures/icons/item_types/beveled/weapons"

	return item_type_texture_path
end

ItemUtils.variant_display_name = function (item)
	local variant = item.variant
	local variant_localization_key = UISettings.item_variant_localization_lookup[variant]
	local variant_display_name_localized = variant_localization_key and Localize(variant_localization_key) or "<undefined item_variant>"

	return variant_display_name_localized
end

ItemUtils.pattern_display_name = function (item)
	local pattern = item.pattern
	local pattern_localization_key = UISettings.item_pattern_localization_lookup[pattern]
	local pattern_display_name_localized = pattern_localization_key and Localize(pattern_localization_key) or "<undefined item_pattern>"

	return pattern_display_name_localized
end

ItemUtils.rarity_display_name = function (item)
	local rarity = item.rarity
	local rarity_localization_key = UISettings.item_rarity_localization_lookup[rarity]
	local rarity_display_name_localized = rarity_localization_key and Localize(rarity_localization_key) or "<undefined item_rarity>"

	return rarity_display_name_localized
end

ItemUtils.rarity_textures = function (item)
	local rarity = item and item.rarity
	local side_texture = UISettings.item_rarity_side_texture_lookup[rarity] or "content/ui/materials/icons/items/backgrounds/side_default"
	local frame_texture = UISettings.item_rarity_frame_texture_lookup[rarity] or "content/ui/textures/icons/items/frames/default"

	return frame_texture, side_texture
end

ItemUtils.rarity_color = function (item)
	local rarity = item.rarity
	local rarity_color = rarity and UISettings.item_rarity_color_lookup[rarity] or {
		255,
		255,
		0,
		0
	}

	return rarity_color
end

local temp_item_rank_localization_context = {
	rank = 0
}

ItemUtils.rank_display_text = function (item)
	local weapon_rank = Managers.progression:get_item_rank(item)
	temp_item_rank_localization_context.rank = weapon_rank
	local no_cache = true

	return Localize("loc_item_display_rank_format_key", no_cache, temp_item_rank_localization_context)
end

ItemUtils.equip_item_in_slot = function (slot_name, item)
	local peer_id = Network.peer_id()
	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager:player(peer_id, local_player_id)
	local player_unit = player.player_unit
	local is_server = Managers.state.game_session and Managers.state.game_session:is_server()
	local profile = player:profile()
	local archetype = profile.archetype
	local breed_name = archetype.breed
	local breeds = item and item.breeds
	local breed_valid = not breeds or table.contains(breeds, breed_name)

	if not breed_valid then
		return
	end

	local character_id = player:character_id()

	if item then
		Managers.backend.interfaces.characters:equip_item_slot(character_id, slot_name, item.gear_id):next(function (v)
			Log.debug("ItemUtils", "Equipped!")

			if is_server then
				local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

				profile_synchronizer_host:profile_changed(peer_id, local_player_id)
			else
				Managers.connection:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
			end
		end):catch(function (errors)
			Log.error("ItemUtils", "Equipping %s (ID: %s) to %s failed. User should be shown some error message! %s", item.name, item.gear_id, slot_name, errors)
		end)
	end
end

ItemUtils.sort_items_by_name_low_first = function (a, b)
	if b.display_name == a.display_name then
		return (a.rarity or 0) < (b.rarity or 0)
	end

	return a.display_name < b.display_name
end

ItemUtils.sort_items_by_name_high_first = function (a, b)
	if b.display_name == a.display_name then
		return (a.rarity or 0) < (b.rarity or 0)
	end

	return b.display_name < a.display_name
end

ItemUtils.sort_items_by_rarity_low_first = function (a, b)
	if (b.rarity or 0) == (a.rarity or 0) then
		return b.display_name < a.display_name
	end

	return (a.rarity or 0) < (b.rarity or 0)
end

ItemUtils.sort_items_by_rarity_high_first = function (a, b)
	if (b.rarity or 0) == (a.rarity or 0) then
		return b.display_name < a.display_name
	end

	return (a.rarity or 0) > (b.rarity or 0)
end

return ItemUtils
