local FixedFrame = require("scripts/utilities/fixed_frame")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MasterItems = require("scripts/backend/master_items")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local UISettings = require("scripts/settings/ui/ui_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_traits/weapon_trait_templates")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local Archetypes = require("scripts/settings/archetype/archetypes")
local RankSettings = require("scripts/settings/item/rank_settings")
local unit_alive = Unit.alive
local ItemUtils = {}

local function _character_save_data()
	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager and player_manager:local_player(local_player_id)
	local character_id = player and player:character_id()
	local save_manager = Managers.save
	local character_data = character_id and save_manager and save_manager:character_data(character_id)

	return character_data
end

ItemUtils.calculate_stats_rating = function (item)
	if item.baseItemLevel then
		return item.baseItemLevel
	end

	local rating_budget = item.itemLevel or 0
	local rating_contribution = ItemUtils.item_perk_rating(item) + ItemUtils.item_trait_rating(item)

	return math.max(0, rating_budget - rating_contribution)
end

ItemUtils.mark_item_id_as_new = function (gear_id, item_type, skip_notification)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	if not character_data.new_items then
		character_data.new_items = {}
	end

	if not character_data.new_item_notifications then
		character_data.new_item_notifications = {}
	end

	local new_items = character_data.new_items
	new_items[gear_id] = true
	local new_item_notifications = character_data.new_item_notifications
	local show_notification = skip_notification and not skip_notification or true
	new_item_notifications[gear_id] = {
		show_notification = show_notification
	}

	if item_type then
		if not character_data.new_items_by_type then
			character_data.new_items_by_type = {}
		end

		local new_items_by_type = character_data.new_items_by_type

		if not new_items_by_type[item_type] then
			new_items_by_type[item_type] = {}
		end

		new_items_by_type[item_type][gear_id] = true
	end

	Managers.save:queue_save()
	Managers.event:trigger("event_resync_character_news_feed")
end

ItemUtils.unmark_item_id_as_new = function (gear_id)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	local new_items = character_data.new_items

	if new_items and new_items[gear_id] then
		new_items[gear_id] = nil
		local new_items_by_type = character_data.new_items_by_type

		if new_items_by_type then
			for item_type, items in pairs(new_items_by_type) do
				if items[gear_id] then
					items[gear_id] = nil

					break
				end
			end
		end

		Managers.save:queue_save()
	end
end

ItemUtils.unmark_all_items_as_new = function ()
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	local new_items = character_data.new_items

	if new_items then
		table.clear(new_items)
	end

	local new_items_by_type = character_data.new_items_by_type

	if new_items_by_type then
		table.clear(new_items_by_type)
	end

	Managers.save:queue_save()
end

ItemUtils.unmark_item_type_as_new = function (item_type)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	local new_items = character_data.new_items

	if new_items then
		local new_items_by_type = character_data.new_items_by_type

		if new_items_by_type then
			local items = new_items_by_type[item_type]

			if items then
				for gear_id, _ in pairs(items) do
					new_items[gear_id] = nil
					items[gear_id] = nil
				end
			end
		end

		Managers.save:queue_save()
	end
end

ItemUtils.unmark_item_notification_id_as_new = function (gear_id)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	local new_item_notifications = character_data.new_item_notifications

	if new_item_notifications and new_item_notifications[gear_id] then
		new_item_notifications[gear_id] = nil

		Managers.save:queue_save()
	end
end

ItemUtils.is_item_id_new = function (gear_id)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	local new_items = character_data.new_items

	return new_items[gear_id] or false
end

ItemUtils.has_new_items_by_type = function (item_type)
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	local new_items_by_type = character_data.new_items_by_type

	if new_items_by_type then
		local items = new_items_by_type[item_type]

		if items and not table.is_empty(items) then
			return true
		end
	end

	return false
end

ItemUtils.new_item_ids = function ()
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	local new_items = character_data.new_items

	return new_items
end

ItemUtils.new_item_notification_ids = function ()
	local character_data = _character_save_data()

	if not character_data then
		return
	end

	local new_item_notifications = character_data.new_item_notifications

	return new_item_notifications
end

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

ItemUtils.sub_display_name = function (item, required_level, no_color)
	local item_type_display_name_localized = ItemUtils.type_display_name(item)
	local level_display_name_localized = ItemUtils.level_display_name(item)
	local text = ""

	if item.rarity then
		local rarity_display_name_localized = ItemUtils.rarity_display_name(item)
		local rarity_color = ItemUtils.rarity_color(item)
		temp_item_sub_display_name_localization_context.rarity_color_r = rarity_color[2]
		temp_item_sub_display_name_localization_context.rarity_color_g = rarity_color[3]
		temp_item_sub_display_name_localization_context.rarity_color_b = rarity_color[4]
		temp_item_sub_display_name_localization_context.rarity_name = rarity_display_name_localized
		temp_item_sub_display_name_localization_context.item_type = item_type_display_name_localized
		text = rarity_display_name_localized
	else
		return item_type_display_name_localized
	end

	if required_level then
		local no_cache = true
		text = text .. " · {#color(120,120,120)}" .. Localize("loc_requires_level", no_cache, {
			level = required_level
		})
	end

	return text
end

ItemUtils.trait_textures = function (trait_item, rarity)
	local icon = trait_item.icon ~= "" and trait_item.icon
	local texture_icon = icon or "content/ui/textures/icons/traits/weapon_trait_default"
	local texture_frame = RankSettings[rarity or 0].trait_frame_texture

	return texture_icon, texture_frame
end

ItemUtils.perk_textures = function (perk_item, rarity)
	return RankSettings[rarity or 0].perk_icon
end

ItemUtils.character_level = function (item)
	local character_level = item.characterLevel or 0

	return character_level
end

local find_link_attachment_item_slot_path = nil

function find_link_attachment_item_slot_path(target_table, slot_id, item, link_item, optional_path)
	local unused_trinket_name = "content/items/weapons/player/trinkets/unused_trinket"
	local path = optional_path or nil

	for k, t in pairs(target_table) do
		if type(t) == "table" then
			if k == slot_id then
				if not t.item or t.item ~= unused_trinket_name then
					path = path and path .. "." .. k or k

					if link_item then
						t.item = item
					end

					return path, t.item
				else
					return nil
				end
			else
				local previous_path = path
				path = path and path .. "." .. k or k
				local alternative_path, path_item = find_link_attachment_item_slot_path(t, slot_id, item, link_item, path)

				if alternative_path then
					return alternative_path, path_item
				else
					path = previous_path
				end
			end
		end
	end
end

local trinket_slot_order = {
	"slot_trinket_1",
	"slot_trinket_2"
}

ItemUtils.weapon_trinket_preview_item = function (item, optional_preview_item)
	local preview_item_name = optional_preview_item or "content/items/weapons/player/trinkets/preview_trinket"
	local preview_item = preview_item_name and MasterItems.get_item(preview_item_name)
	local visual_item = nil

	if preview_item then
		visual_item = table.clone_instance(preview_item)
	end

	if visual_item then
		visual_item.gear_id = item.gear_id

		for i = 1, #trinket_slot_order do
			local slot_id = trinket_slot_order[i]

			if find_link_attachment_item_slot_path(visual_item, slot_id, item, true) then
				break
			end
		end
	end

	return visual_item
end

ItemUtils.add_weapon_trinket_on_preview_item = function (weapon_trinket_item, weapon_item)
	for i = 1, #trinket_slot_order do
		local slot_id = trinket_slot_order[i]

		if find_link_attachment_item_slot_path(weapon_item, slot_id, weapon_trinket_item, true) then
			break
		end
	end
end

ItemUtils.weapon_skin_preview_item = function (item, include_skin_item_info)
	local preview_item_name = item.preview_item
	local preview_item = preview_item_name and MasterItems.get_item(preview_item_name)
	local visual_item = nil

	if preview_item then
		visual_item = table.clone_instance(preview_item)
	end

	if visual_item then
		visual_item.gear_id = item.gear_id
		visual_item.slot_weapon_skin = item
	end

	if include_skin_item_info then
		visual_item.display_name = item.display_name
		visual_item.description = item.description
		visual_item.item_type = item.item_type
		visual_item.weapon_template_restriction = item.weapon_template_restriction
	end

	return visual_item
end

ItemUtils.item_level = function (item)
	local item_level = item.itemLevel
	local power = item_level or 0

	return " " .. tostring(power), item_level ~= nil
end

ItemUtils.is_weapon_template_ranged = function (item)
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local keywords = weapon_template and weapon_template.keywords
	local search_result = keywords and table.find(keywords, "ranged")

	return search_result and search_result > 0
end

ItemUtils.type_display_name = function (item)
	local item_type = item.item_type
	local item_type_localization_key = UISettings.item_type_localization_lookup[item_type]
	local item_type_display_name_localized = item_type_localization_key and Localize(item_type_localization_key) or "<undefined item_type>"

	return item_type_display_name_localized
end

ItemUtils.level_display_name = function (item)
	local item_level = ItemUtils.item_level(item)
	local item_level_display_name_localized = Localize("loc_item_display_level_format_key", true, {
		level = item_level
	})

	return item_level_display_name_localized
end

ItemUtils.type_texture = function (item)
	local item_type = item.item_type
	local item_type_texture_path = UISettings.item_type_texture_lookup[item_type] or "content/ui/textures/icons/item_types/weapons"

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
	local rarity_settings = RaritySettings[item.rarity]
	local loc_key = rarity_settings and rarity_settings.display_name

	return loc_key and Localize(loc_key) or "<undefined item_rarity>"
end

ItemUtils.rarity_color = function (item)
	local rarity_settings = RaritySettings[item and item.rarity] or RaritySettings[0]

	return rarity_settings.color, rarity_settings.color_dark
end

ItemUtils.keywords_text = function (item)
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local displayed_keywords = weapon_template.displayed_keywords
	local text = ""

	if displayed_keywords then
		for i = 1, #displayed_keywords do
			local keyword = displayed_keywords[i]
			local display_name = keyword.display_name
			text = text .. Localize(display_name)

			if i ~= #displayed_keywords then
				text = text .. " • "
			end
		end
	end

	return text
end

ItemUtils.weapon_skin_requirement_text = function (item)
	local weapon_template_restriction = item.weapon_template_restriction
	local text = ""

	if not weapon_template_restriction or table.is_empty(weapon_template_restriction) then
		return text, false
	end

	local weapon_template_display_settings = UISettings.weapon_template_display_settings

	if not weapon_template_display_settings then
		return text, false
	end

	for i = 1, #weapon_template_restriction do
		local weapon_template_name = weapon_template_restriction[i]
		local template_display_settings = weapon_template_name and weapon_template_display_settings[weapon_template_name]
		local template_display_name = template_display_settings and template_display_settings.display_name
		local template_display_name_localized = template_display_name and Localize(template_display_name)

		if template_display_name_localized then
			text = text .. "• " .. template_display_name_localized

			if i < #weapon_template_restriction then
				text = text .. "\n"
			end
		end
	end

	return text, true
end

local _temp_archetype_restriction_list = {}

ItemUtils.set_item_class_requirement_text = function (item)
	table.clear(_temp_archetype_restriction_list)

	local text = ""
	local items = item.items

	for i = 1, #items do
		local set_piece_item = items[i]
		local archetype_restrictions = set_piece_item.archetypes

		if not archetype_restrictions or table.is_empty(archetype_restrictions) then
			return text, false
		end

		for j = 1, #archetype_restrictions do
			local archetype_name = archetype_restrictions[j]

			if not _temp_archetype_restriction_list[archetype_name] then
				local archetype = Archetypes[archetype_name]
				local display_name_localized = archetype and Localize(archetype.archetype_name)

				if display_name_localized then
					text = text .. "• " .. display_name_localized

					if i < #archetype_restrictions then
						text = text .. "\n"
					end
				end

				_temp_archetype_restriction_list[archetype_name] = true
			end
		end
	end

	return text, true
end

ItemUtils.class_requirement_text = function (item)
	local text = ""
	local item_type = item.item_type

	if item_type == "SET" then
		local items = item.items

		for i = 1, #items do
			text = text .. ItemUtils.class_requirement_text(items[i])
		end
	else
		local archetype_restrictions = item.archetypes

		if not archetype_restrictions or table.is_empty(archetype_restrictions) then
			return text, false
		end

		for i = 1, #archetype_restrictions do
			local archetype_name = archetype_restrictions[i]
			local archetype = Archetypes[archetype_name]
			local display_name_localized = archetype and Localize(archetype.archetype_name)

			if display_name_localized then
				text = text .. "• " .. display_name_localized

				if i < #archetype_restrictions then
					text = text .. "\n"
				end
			end
		end
	end

	return text, true
end

ItemUtils.retrieve_items_for_archetype = function (archetype, filtered_slots, workflow_states)
	local WORKFLOW_STATES = {
		"SHIPPABLE",
		"RELEASABLE",
		"FUNCTIONAL"
	}
	workflow_states = workflow_states and workflow_states or WORKFLOW_STATES
	local item_definitions = MasterItems.get_cached()
	local items = {}

	for item_name, item in pairs(item_definitions) do
		repeat
			local slots = item.slots
			local slot = slots and slots[1]

			if not table.contains(filtered_slots, slot) then
				break
			end

			local archetypes = item.archetypes

			if not archetypes or not table.contains(archetypes, archetype) then
				break
			end

			local is_item_stripped = true
			local strip_tags_table = Application.get_strip_tags_table()

			if table.size(item.feature_flags) == 0 then
				is_item_stripped = false
			else
				for _, feature_flag in pairs(item.feature_flags) do
					if strip_tags_table[feature_flag] == true then
						is_item_stripped = false

						break
					end
				end
			end

			if is_item_stripped then
				break
			end

			local filtered_workflow_states = table.contains(workflow_states, item.workflow_state)

			if not filtered_workflow_states then
				break
			end

			if items[slot] == nil then
				items[slot] = {}
			end

			items[slot][item_name] = item
		until true
	end

	return items
end

ItemUtils.perk_item_by_id = function (perk_id)
	return MasterItems.get_item(perk_id)
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

ItemUtils.equip_weapon_skin = function (weapon_item, skin_item)
	local weapon_gear_id = weapon_item.gear_id
	local skin_gear_id = skin_item and skin_item.gear_id
	local attach_point = "slot_weapon_skin"

	return Managers.data_service.gear:attach_item_as_override(weapon_gear_id, attach_point, skin_gear_id)
end

ItemUtils.equip_weapon_trinket = function (weapon_item, trinket_item, optional_path)
	local weapon_gear_id = weapon_item.gear_id
	local trinket_gear_id = trinket_item and trinket_item.gear_id
	local attach_point = optional_path

	if not attach_point then
		local link_attachment_item_to_slot = nil
		local unused_trinket_name = "content/items/weapons/player/trinkets/unused_trinket"

		function link_attachment_item_to_slot(target_table, slot_id, item, optional_path)
			local path = optional_path or nil

			for k, t in pairs(target_table) do
				if type(t) == "table" then
					local correct_path = k == slot_id

					if correct_path and (not t.item or t.item ~= unused_trinket_name) then
						t.item = item
						path = path and path .. "." .. k or k

						return path
					else
						local previous_path = path
						path = path and path .. "." .. k or k
						local alternative_path = link_attachment_item_to_slot(t, slot_id, item, path)

						if alternative_path then
							return alternative_path
						else
							path = previous_path
						end
					end
				end
			end
		end

		local master_item = weapon_item.__master_item
		attach_point = link_attachment_item_to_slot(master_item, "slot_trinket_1", trinket_item)
		attach_point = attach_point or link_attachment_item_to_slot(master_item, "slot_trinket_2", trinket_item)
	end

	return Managers.data_service.gear:attach_item_as_override(weapon_gear_id, attach_point .. ".item", trinket_gear_id)
end

ItemUtils.equip_slot_items = function (items)
	local peer_id = Network.peer_id()
	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager:player(peer_id, local_player_id)
	local player_unit = player.player_unit
	local is_server = Managers.state.game_session and Managers.state.game_session:is_server()
	local profile = player:profile()
	local archetype = profile.archetype
	local breed_name = archetype.breed
	local character_id = player:character_id()

	if items then
		local item_gear_ids_by_slots = {}
		local item_gear_names_by_slots = {}

		for slot_name, item in pairs(items) do
			local breeds = item and item.breeds
			local breed_valid = not breeds or table.contains(breeds, breed_name)
			local slots = item and item.slots
			local slot_valid = not slots or table.contains(slots, slot_name)

			if breed_valid and slot_valid then
				if item.gear_id then
					item_gear_ids_by_slots[slot_name] = item.gear_id
				elseif item.name then
					item_gear_names_by_slots[slot_name] = item.name
				end
			end
		end

		return Managers.data_service.profiles:equip_items_in_slots(character_id, item_gear_ids_by_slots, item_gear_names_by_slots):next(function (v)
			Log.debug("ItemUtils", "Items equipped in loadout slots")

			if is_server then
				local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

				profile_synchronizer_host:profile_changed(peer_id, local_player_id)
			else
				Managers.connection:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
			end

			return true
		end):catch(function (errors)
			Log.error("ItemUtils", "Failed equipping items in loadout slots", errors)

			return false
		end)
	end
end

ItemUtils.equip_slot_master_items = function (items)
	local peer_id = Network.peer_id()
	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager and player_manager:player(peer_id, local_player_id)

	if not player then
		return
	end

	local is_server = Managers.state.game_session and Managers.state.game_session:is_server()
	local profile = player:profile()
	local archetype = profile.archetype
	local breed_name = archetype.breed
	local character_id = player:character_id()

	if items then
		local item_master_ids_by_slots = {}

		for slot_name, item in pairs(items) do
			local breeds = item and item.breeds
			local breed_valid = not breeds or table.contains(breeds, breed_name)
			local slots = item and item.slots
			local slot_valid = not slots or table.contains(slots, slot_name)

			if breed_valid and slot_valid then
				item_master_ids_by_slots[slot_name] = item.name
			end
		end

		Managers.data_service.profiles:equip_master_items_in_slots(character_id, item_master_ids_by_slots):next(function (v)
			Log.debug("ItemUtils", "Master items equipped in loadout slots")

			if is_server then
				local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

				profile_synchronizer_host:profile_changed(peer_id, local_player_id)
			else
				Managers.connection:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
			end

			return true
		end):catch(function (errors)
			Log.error("ItemUtils", "Failed equipping master items in loadout slots", errors)

			return false
		end)
	end
end

ItemUtils.equip_item_in_slot = function (slot_name, item)
	local peer_id = Network.peer_id()
	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager and player_manager:player(peer_id, local_player_id)

	if not player then
		return
	end

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
		Managers.backend.interfaces.characters:equip_item_slot(character_id, slot_name, item.gear_id or item.name):next(function (v)
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

ItemUtils.refresh_equipped_items = function ()
	local peer_id = Network.peer_id()
	local local_player_id = 1
	local is_server = Managers.state.game_session and Managers.state.game_session:is_server()

	if is_server then
		local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

		profile_synchronizer_host:profile_changed(peer_id, local_player_id)
	else
		Managers.connection:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
	end
end

ItemUtils.slot_name = function (item)
	return item.slots and item.slots[1]
end

ItemUtils.item_slot = function (item)
	local slot_name = ItemUtils.slot_name(item)

	return slot_name and ItemSlotSettings[slot_name]
end

ItemUtils.sort_element_key_comparator = function (definitions)
	return function (a, b)
		for i = 1, #definitions, 3 do
			local order = definitions[i]
			local key = definitions[i + 1]
			local func = definitions[i + 2]
			local is_lt = func(key and a[key] or a, key and b[key] or b)

			if is_lt ~= nil then
				if order == "<" or order == "true" then
					return is_lt
				else
					return not is_lt
				end
			end
		end

		return nil
	end
end

ItemUtils.sort_comparator = function (definitions)
	return function (a, b)
		local a_item = a.item
		local b_item = b.item

		if a_item and b_item then
			for i = 1, #definitions, 2 do
				local order = definitions[i]
				local func = definitions[i + 1]
				local is_lt = func(a_item, b_item)

				if is_lt ~= nil then
					if order == "<" or order == "true" then
						return is_lt
					else
						return not is_lt
					end
				end
			end
		end

		return nil
	end
end

ItemUtils.compare_offer_owned = function (a_offer, b_offer)
	if a_offer and b_offer then
		local owned_key = "owned"
		local a_owned = a_offer.state and a_offer.state == owned_key
		local b_owned = b_offer.state and b_offer.state == owned_key

		if a_owned and not b_owned then
			return true
		elseif b_owned and not a_owned then
			return false
		end
	end

	return nil
end

ItemUtils.compare_offer_price = function (a_offer, b_offer)
	if a_offer and b_offer then
		local owned_key = "owned"
		local a_owned = a_offer.state and a_offer.state == owned_key
		local b_owned = b_offer.state and b_offer.state == owned_key
		local a_price_data = a_offer.price.amount
		local a_price = not a_owned and a_price_data and (a_price_data.discounted_price or a_price_data.amount)
		local b_price_data = b_offer.price.amount
		local b_price = not b_owned and b_price_data and (b_price_data.discounted_price or b_price_data.amount)

		if a_price and b_price and a_price ~= b_price then
			return a_price < b_price
		end
	end
end

ItemUtils.compare_set_item_parts_presentation_order = function (a, b)
	local a_item_type = a.item_type
	local b_item_type = b.item_type
	local a_sort_index = UISettings.set_item_parts_presentation_order[a_item_type] or 0
	local b_sort_index = UISettings.set_item_parts_presentation_order[b_item_type] or 0

	return a_sort_index < b_sort_index
end

ItemUtils.compare_item_type = function (a, b)
	local a_item_type = a.item_type or ""
	local b_type = b.item_type or ""

	if a_item_type < b_type then
		return true
	elseif b_type < a_item_type then
		return false
	end

	return nil
end

ItemUtils.compare_item_name = function (a, b)
	local a_display_name = a.display_name and Localize(a.display_name) or ""
	local b_display_name = b.display_name and Localize(b.display_name) or ""

	if a_display_name < b_display_name then
		return true
	elseif b_display_name < a_display_name then
		return false
	end

	return nil
end

ItemUtils.compare_item_rarity = function (a, b)
	local a_rarity = a.rarity or 0
	local b_rarity = b.rarity or 0

	if a_rarity < b_rarity then
		return true
	elseif b_rarity < a_rarity then
		return false
	end

	return nil
end

ItemUtils.compare_item_level = function (a, b)
	local a_itemLevel = a.itemLevel or 0
	local b_itemLevel = b.itemLevel or 0

	if a_itemLevel < b_itemLevel then
		return true
	elseif b_itemLevel < a_itemLevel then
		return false
	end

	return nil
end

local function _get_lerp_stepped_value(range, lerp_value)
	local min = 1
	local max = #range
	local lerped_value = math.lerp(min, max, lerp_value)
	local index = math.round(lerped_value)
	local value = range[index]

	return value
end

local description_values = {}

ItemUtils.perk_description = function (item, rarity, lerp_value)
	table.clear(description_values)

	local description = item.description
	local trait = item.trait

	if not trait then
		return Localize(description)
	end

	if item.description_values and next(item.description_values) then
		for i = 1, #item.description_values do
			local data = item.description_values[i]
			local description_rarity = tonumber(data.rarity)

			if description_rarity == rarity then
				local description_key = data.string_key
				local description_value = data.string_value
				description_values[description_key] = description_value
			end
		end

		local no_cache = true

		return Localize(description, no_cache, description_values)
	end

	local buff_id = trait
	local buff_template = BuffTemplates[buff_id]

	if not buff_template then
		return Localize(description)
	end

	local localization_info = buff_template.localization_info

	if not localization_info then
		return Localize(description)
	end

	local class_name = buff_template.class_name

	if class_name == "proc_buff" then
		local proc_buff_name = localization_info.proc_buff_name

		if proc_buff_name then
			buff_template = BuffTemplates[proc_buff_name]
			localization_info = buff_template.localization_info
		end
	end

	local is_meta_buff = buff_template.meta_buff
	local buff_template_stat_buffs = buff_template.stat_buffs or buff_template.meta_stat_buffs or buff_template.lerped_stat_buffs or buff_template.conditional_stat_buffs

	if buff_template_stat_buffs then
		for stat_buff_name, value in pairs(buff_template_stat_buffs) do
			if buff_template.lerped_stat_buffs then
				local min = value.min
				local max = value.max
				local lerp_value_func = value.lerp_value_func or math.lerp
				value = lerp_value_func(min, max, lerp_value)
			elseif is_meta_buff and type(value) == "table" then
				value = buff_template.lerp_function(value, lerp_value)
			elseif class_name == "stepped_range_buff" then
				value = _get_lerp_stepped_value(value, lerp_value)
			end

			local show_as = localization_info[stat_buff_name]

			if show_as and show_as == "percentage" then
				value = tostring(math.round(value * 100)) .. "%"
			end

			description_values[stat_buff_name] = value
		end
	end

	description_values.duration = buff_template.duration
	local final_description = Localize(description, true, description_values)

	Log.debug("ItemUtils", "perk_description %s", table.tostring(description_values))

	return final_description
end

ItemUtils.trait_description = function (item, rarity, lerp_value)
	return ItemUtils.perk_description(item, rarity, lerp_value)
end

ItemUtils.perk_rating = function (perk_item, perk_rarity, perk_value)
	return RankSettings[perk_rarity or 0].perk_rating
end

ItemUtils.trait_rating = function (trait_item, trait_rarity, trait_value)
	return RankSettings[trait_rarity or 0].trait_rating
end

ItemUtils.item_perk_rating = function (item)
	local rating = 0
	local perks = item.perks
	local num_perks = perks and #perks or 0

	for i = 1, num_perks do
		local perk = perks[i]
		rating = rating + RankSettings[perk.rarity or 0].perk_rating
	end

	return rating
end

ItemUtils.item_trait_rating = function (item)
	local rating = 0
	local traits = item.traits
	local num_traits = traits and #traits or 0

	if item.item_type == "GADGET" then
		for i = 1, num_traits do
			local trait = traits[i]
			rating = rating + math.round(trait.value * 100)
		end
	else
		local fake_perk_count = 0

		for i = 1, num_traits do
			local trait = traits[i]
			rating = rating + RankSettings[trait.rarity or 0].trait_rating

			if trait.is_fake then
				fake_perk_count = fake_perk_count + 1
			end
		end
	end

	return rating
end

ItemUtils.trait_category = function (item)
	local trait_category = nil

	if item.item_type == "TRAIT" then
		local trait_name = item.name
		trait_category = string.match(trait_name, "^content/items/traits/([%w_]+)/")
	elseif item.trait_category then
		trait_category = item.trait_category
	elseif item.weapon_template then
		Log.error("ItemUtils", "no trait_category found for %s, using fallback", item.name)

		trait_category = "bespoke_" .. string.gsub(item.weapon_template, "_m%d$", "")
	end

	return trait_category
end

ItemUtils.has_crafting_modification = function (item)
	local perks = item.perks
	local has_perk_modification = false

	if perks then
		for i = 1, #perks do
			if perks[i].modified then
				has_perk_modification = true

				break
			end
		end
	end

	local traits = item.traits
	local has_trait_modification = false

	if traits then
		for i = 1, #traits do
			if traits[i].modified then
				has_trait_modification = true

				break
			end
		end
	end

	return has_perk_modification, has_trait_modification
end

ItemUtils.count_crafting_modification = function (item)
	local perks = item.perks
	local count = 0

	if perks then
		for i = 1, #perks do
			if perks[i].modified then
				count = count + 1
			end
		end
	end

	local traits = item.traits

	if traits then
		for i = 1, #traits do
			if traits[i].modified then
				count = count + 1
			end
		end
	end

	return count
end

ItemUtils.modifications_by_rarity = function (item)
	local rarity_settings = RaritySettings[item.rarity]
	local count_modifications = ItemUtils.count_crafting_modification(item)
	local max_modifications = rarity_settings.max_modifications

	return count_modifications, max_modifications
end

ItemUtils.create_mannequin_profile_by_item = function (item, prefered_gender, prefered_archetype)
	local item_gender, item_breed, item_archetype = nil

	if item.genders and not table.is_empty(item.genders) then
		if prefered_gender and table.find(item.genders, prefered_gender) then
			item_gender = prefered_gender
		elseif table.find(item.genders, "male") then
			item_gender = "male"
		else
			item_gender = item.genders[1]
		end
	elseif (not item.genders or item.genders and table.is_empty(item.genders)) and prefered_gender then
		item_gender = prefered_gender
	end

	if item.archetypes and not table.is_empty(item.archetypes) then
		if prefered_archetype and table.find(item.archetypes, prefered_archetype) then
			item_archetype = type(prefered_archetype) == "string" and Archetypes[prefered_archetype] or prefered_archetype
		else
			local archetype = item.archetypes[1]
			item_archetype = type(archetype) == "string" and Archetypes[archetype] or archetype
		end
	end

	if item.breeds and not table.is_empty(item.breeds) then
		if #item.breeds > 1 and item_archetype and item_archetype.name == "ogryn" and table.find(item.breeds, "ogryn") then
			item_breed = "ogryn"
		else
			item_breed = item.breeds[1]
		end
	end

	local breed = item_breed or item.breeds and item.breeds[1] or "human"
	local archetype = breed == "ogryn" and Archetypes.ogryn or item_archetype or item.archetypes and item.archetypes[1] and Archetypes[item.archetypes[1]] or Archetypes.veteran
	local gender = breed ~= "ogryn" and (item_gender or item.genders and item.genders[1]) or "male"
	local loadout = {}
	local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_set_per_slot_by_breed_and_gender[breed]
	local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender]

	if required_gender_item_names_per_slot then
		local required_items = required_gender_item_names_per_slot

		if required_items then
			for slot_name, slot_item_name in pairs(required_items) do
				local item_definition = MasterItems.get_item(slot_item_name)

				if item_definition then
					local slot_item = table.clone(item_definition)
					loadout[slot_name] = slot_item
				end
			end
		end
	end

	return {
		loadout = loadout,
		archetype = archetype,
		breed = breed,
		gender = gender
	}
end

return ItemUtils
