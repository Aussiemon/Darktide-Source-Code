﻿-- chunkname: @scripts/settings/item/crafting_settings.lua

local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local RankSettings = require("scripts/settings/item/rank_settings")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local CraftingSettings = {}

CraftingSettings.MAX_UPGRADE_RARITY_TIER = 5

local function is_valid_crafting_item(item)
	return item and not item.no_crafting and RaritySettings[item.rarity]
end

local function scale_by_item_level(cost, item, item_crafting_costs)
	local item_level = item.baseItemLevel
	local item_level_span = item_crafting_costs.baseItemLevelSpan
	local cost_scaling_span = item_crafting_costs.costScalingSpan
	local scale = item_level_span.scale or 1
	local span_multiplier = math.remap(item_level_span.minInt or item_level_span.min or 1 * scale, item_level_span.maxInt or item_level_span.max or 380 * scale, cost_scaling_span.minInt or cost_scaling_span.min or 1 * scale, cost_scaling_span.maxInt or cost_scaling_span.max or 1 * scale, (item_level or 380) * scale) / scale
	local amount = math.round(cost * span_multiplier)

	return amount
end

local function calculate_costs(start_costs, item, item_crafting_costs, cost_multiplier, clamping)
	local final_costs = {}

	for i, cost in ipairs(start_costs) do
		local amount = scale_by_item_level(cost.amount, item, item_crafting_costs)

		if cost_multiplier then
			local calculated_cost = math.round(amount * cost_multiplier)

			if clamping then
				local clamp_min = clamping.min
				local clamp_max = clamping.max
				local min_val = math.ceil(amount * clamp_min)

				if calculated_cost < min_val then
					calculated_cost = min_val
				end

				local max_val = math.floor(amount * clamp_max)

				if max_val < calculated_cost then
					calculated_cost = max_val
				end
			end

			amount = calculated_cost
		end

		final_costs[i] = {
			type = cost.type,
			amount = amount,
		}
	end

	return final_costs
end

CraftingSettings.recipes = {}
CraftingSettings.recipes.upgrade_item = {
	button_text = "loc_crafting_upgrade_button",
	description_text = "loc_crafting_upgrade_description",
	display_name = "loc_crafting_upgrade_option",
	icon = "content/ui/materials/icons/crafting/upgrade_item",
	name = "upgrade_item",
	overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_04",
	view_name = "crafting_upgrade_item_view",
	sound_event = UISoundEvents.crafting_view_on_upgrade_item,
	is_valid_item = function (item)
		if is_valid_crafting_item(item) and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED" or item.item_type == "GADGET") then
			local rarity = item.rarity

			if not rarity then
				return false
			end

			if RaritySettings[rarity + 2] then
				return true
			end
		end

		return false
	end,
	get_costs = function (ingredients)
		local crafting_costs = Managers.backend.interfaces.crafting:crafting_costs()
		local item = ingredients.item
		local item_type = item.item_type == "GADGET" and "gadget" or "weapon"
		local item_crafting_costs = crafting_costs[item_type]
		local start_costs = item_crafting_costs.rarityUpgrade.startCost
		local rarity = tostring(item.rarity)
		local final_costs = calculate_costs(start_costs and start_costs[rarity] or {}, item, item_crafting_costs)

		return final_costs
	end,
	can_craft = function (ingredients)
		local item = ingredients.item

		if not CraftingSettings.recipes.upgrade_item.is_valid_item(item) then
			return false, "loc_crafting_failure"
		end

		if item.rarity >= CraftingSettings.MAX_UPGRADE_RARITY_TIER then
			return false, "loc_crafting_upgrade_max"
		end

		return true
	end,
	craft = function (ingredients)
		local costs = CraftingSettings.recipes.upgrade_item.get_costs(ingredients)
		local item = ingredients.item
		local gear_id = item.gear_id
		local is_gadget = item.item_type == "GADGET"
		local promise

		if is_gadget then
			promise = Managers.data_service.crafting:upgrade_gadget_rarity(gear_id, costs)
		else
			promise = Managers.data_service.crafting:upgrade_weapon_rarity(gear_id, costs)
		end

		return promise
	end,
	get_bogus_result = function (ingredients)
		local item = MasterItems.create_preview_item_instance(ingredients.item)
		local is_gadget = item.item_type == "GADGET"
		local new_rarity = item.rarity + 1

		item.rarity = new_rarity

		local rarity_settings = RaritySettings[new_rarity]
		local item_rarity_settings = is_gadget and rarity_settings.gadget or rarity_settings.weapon
		local rank_item_type_name = is_gadget and "gadget" or "weapon"

		item.traits = item.traits or {}

		local new_num_traits = item_rarity_settings.num_traits
		local num_traits = #item.traits

		if num_traits < new_num_traits then
			for i = num_traits + 1, new_num_traits do
				item.traits[i] = {
					id = "content/items/traits/unknown_trait",
					is_fake = true,
					value = 1,
				}
			end

			local min_new_item_level = ItemUtils.item_trait_rating(item)

			if (not item.traits[#item.traits].rarity or item.traits[#item.traits].rarity == 0) and RankSettings[0].trait_rating[rank_item_type_name] == 0 then
				min_new_item_level = min_new_item_level + RankSettings[1].trait_rating[rank_item_type_name]
			end

			local max_new_item_level = min_new_item_level + (RankSettings[4].trait_rating[rank_item_type_name] - RankSettings[1].trait_rating[rank_item_type_name])

			item.override_trait_rating_string = string.format("%d - %d", min_new_item_level, max_new_item_level)
		end

		item.perks = item.perks or {}

		local num_perks = #item.perks
		local new_num_perks = item_rarity_settings.num_perks

		if num_perks < new_num_perks then
			for i = num_perks + 1, new_num_perks do
				item.perks[i] = {
					id = "content/items/perks/unknown_perk",
					is_fake = true,
					rarity = 1,
				}
			end

			local min_new_item_level = ItemUtils.item_perk_rating(item)

			if (not item.perks[#item.perks].rarity or item.perks[#item.perks].rarity == 0) and RankSettings[0].perk_rating[rank_item_type_name] == 0 then
				min_new_item_level = min_new_item_level + RankSettings[1].perk_rating[rank_item_type_name]
			end

			local max_new_item_level = min_new_item_level + (RankSettings[4].perk_rating[rank_item_type_name] - RankSettings[1].perk_rating[rank_item_type_name])

			item.override_perk_rating_string = string.format("%d - %d", min_new_item_level, max_new_item_level)
		end

		local min_new_item_level = item.itemLevel + (new_num_traits - num_traits) * RankSettings[1].trait_rating[rank_item_type_name] + (new_num_perks - num_perks) * RankSettings[1].perk_rating[rank_item_type_name]

		item.override_item_rating_string = string.format(" %d+", min_new_item_level)
		item.itemLevel = min_new_item_level

		return item
	end,
}
CraftingSettings.recipes.extract_trait = {
	button_text = "loc_crafting_extract_button",
	description_text = "loc_crafting_extract_description",
	display_name = "loc_crafting_extract_option",
	icon = "content/ui/materials/icons/crafting/extract_trait",
	name = "extract_trait",
	overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_01",
	requires_trait_selection = "all",
	show_item_granted_toast = true,
	success_text = "loc_crafting_extract_success",
	ui_disabled = false,
	ui_hidden = false,
	view_name = "crafting_extract_trait_view",
	sound_event = UISoundEvents.crafting_view_on_extract_trait,
	is_valid_item = function (item)
		return is_valid_crafting_item(item) and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED") and item.traits and #item.traits > 0
	end,
	get_costs = function (ingredients)
		local crafting_costs = Managers.backend.interfaces.crafting:crafting_costs()
		local tier = ingredients.tiers and ingredients.tiers[1]

		if not tier then
			return nil
		end

		local rarity = tostring(tier)
		local item = ingredients.item

		if not item then
			return nil
		end

		local cost_config = crafting_costs.weapon
		local start_costs = cost_config and crafting_costs.weapon.traitExtract.startCost
		local final_costs = calculate_costs(start_costs and start_costs[rarity] or {}, item, cost_config)

		return final_costs
	end,
	can_craft = function (ingredients, seen_traits)
		local item = ingredients.item

		if not CraftingSettings.recipes.extract_trait.is_valid_item(item) then
			return false, nil
		end

		local player = Managers.player:local_player(1)
		local profile = player:profile()
		local loadout = profile.loadout

		for _, slot in pairs(item.slots) do
			local slot_item = loadout[slot]

			if not slot_item then
				return false
			end

			if slot_item.gear_id == item.gear_id then
				return false, "loc_crafting_extract_equipped"
			end
		end

		local existing_trait_index = ingredients.existing_trait_index
		local trait_item = item.traits[existing_trait_index]

		if not trait_item then
			return false, "loc_crafting_no_trait_selected"
		end

		local trait_name = trait_item and trait_item.id
		local trait_rarity = trait_item and trait_item.rarity or 1

		if seen_traits then
			for seen_trait_name, status in pairs(seen_traits) do
				if seen_trait_name == trait_name and status ~= nil then
					local trait_status = status[trait_rarity]

					if trait_status == "seen" then
						return false, "loc_crafting_trait_already_extracted"
					end
				end
			end
		else
			return false
		end

		return true
	end,
	craft = function (ingredients)
		local costs = CraftingSettings.recipes.extract_trait.get_costs(ingredients)
		local item = ingredients.item
		local promise = Managers.data_service.crafting:extract_trait_from_weapon(item.gear_id, ingredients.existing_trait_index, costs)

		return promise
	end,
}
CraftingSettings.recipes.replace_trait = {
	button_text = "loc_crafting_replace_option",
	description_text = "loc_crafting_replace_description",
	display_name = "loc_crafting_replace_option",
	icon = "content/ui/materials/icons/crafting/replace_trait",
	modification_warning = "loc_crafting_warning_replace",
	name = "replace_trait",
	overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_02",
	requires_trait_selection = true,
	success_text = "loc_crafting_replace_success",
	ui_disabled = false,
	ui_hidden = false,
	view_name = "crafting_replace_trait_view",
	sound_event = UISoundEvents.crafting_view_on_replace_trait,
	is_valid_item = function (item)
		return is_valid_crafting_item(item) and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED") and item.traits and #item.traits > 0
	end,
	get_costs = function (ingredients, additional_data)
		local crafting_costs = Managers.backend.interfaces.crafting:crafting_costs()
		local tier = ingredients.tiers and ingredients.tiers[1]

		if not tier then
			return nil
		end

		local rarity = tostring(tier)
		local cost_config = crafting_costs.weapon
		local start_costs = cost_config.traitReplace.startCost
		local item = ingredients.item
		local final_costs = calculate_costs(start_costs and start_costs[rarity] or {}, item, cost_config)

		return final_costs
	end,
	can_craft = function (ingredients, additional_context)
		local item = ingredients.item
		local item_traits = item.traits
		local has_perk_modification, has_trait_modification = ItemUtils.has_crafting_modification(item)
		local num_modifications, max_modifications = ItemUtils.modifications_by_rarity(item)
		local item_locked = num_modifications == max_modifications

		if not CraftingSettings.recipes.replace_trait.is_valid_item(item) then
			return false, "loc_crafting_failure"
		end

		if item_locked and not has_trait_modification then
			return false, "loc_crafting_modification_not_available"
		end

		local new_trait_item = additional_context.trait_items and additional_context.trait_items[1]

		if not ingredients.trait_ids or not ingredients.trait_ids[1] or not new_trait_item then
			return false, false
		end

		local existing_trait_index = ingredients.existing_trait_index
		local trait = item_traits[existing_trait_index]

		if not trait then
			return false, false
		end

		for i = 1, #item_traits do
			if i ~= existing_trait_index and item_traits[i].id == new_trait_item.name then
				return false, "loc_crafting_not_allowed_wasteful"
			end
		end

		if new_trait_item.name == trait.id and new_trait_item.rarity <= trait.rarity then
			return false, "loc_crafting_not_allowed_wasteful"
		end

		if item_locked and not trait.modified then
			return false, "loc_crafting_error_trait_replaced"
		end

		return true
	end,
	craft = function (ingredients)
		local costs = CraftingSettings.recipes.replace_trait.get_costs(ingredients)
		local item = ingredients.item
		local promise = Managers.data_service.crafting:replace_trait_in_weapon(item.gear_id, ingredients.existing_trait_index, ingredients.trait_master_ids[1], ingredients.tiers[1], costs)

		return promise
	end,
}

local dummy_fuse_costs = {
	{
		amount = 0,
		can_afford = true,
		type = "credits",
	},
	{
		amount = 0,
		can_afford = true,
		type = "plasteel",
	},
	{
		amount = 0,
		can_afford = true,
		type = "diamantine",
	},
}

CraftingSettings.recipes.replace_perk = {
	button_text = "loc_crafting_reroll_perk_button",
	description_text = "loc_crafting_replace_perk_description",
	display_name = "loc_crafting_reroll_perk_option",
	icon = "content/ui/materials/icons/crafting/reroll_perk",
	name = "replace_perk",
	overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_03",
	requires_perk_selection = true,
	success_text = "loc_crafting_reroll_success",
	ui_disabled = false,
	ui_hidden = false,
	view_name = "crafting_replace_perk_view",
	sound_event = UISoundEvents.crafting_view_on_reroll_perk,
	is_valid_item = function (item)
		return is_valid_crafting_item(item) and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED" or item.item_type == "GADGET") and item.perks and #item.perks > 0
	end,
	get_costs = function (ingredients)
		local crafting_costs = Managers.backend.interfaces.crafting:crafting_costs()
		local tier = ingredients.tiers and ingredients.tiers[1]

		if not tier then
			return nil
		end

		local item = ingredients.item
		local rarity = tostring(tier)
		local item_type = item.item_type == "GADGET" and "gadget" or "weapon"
		local cost_config = crafting_costs[item_type]
		local start_costs = cost_config.perkReplace.startCost
		local final_costs = calculate_costs(start_costs and start_costs[rarity] or {}, item, cost_config)

		return final_costs
	end,
	can_craft = function (ingredients, additional_context)
		local item = ingredients.item
		local has_perk_modification, has_trait_modification = ItemUtils.has_crafting_modification(item)
		local num_modifications, max_modifications = ItemUtils.modifications_by_rarity(item)
		local item_locked = num_modifications == max_modifications

		if not CraftingSettings.recipes.replace_perk.is_valid_item(item) then
			return false, "loc_crafting_failure"
		end

		if item_locked and not has_perk_modification then
			return false, "loc_crafting_modification_not_available"
		end

		local new_perk_item = additional_context.perk_items and additional_context.perk_items[1]

		if not ingredients.perk_ids or not ingredients.perk_ids[1] or not new_perk_item then
			return false, false
		end

		local item_perks = item.perks
		local existing_perk_index = ingredients.existing_perk_index
		local perk = item_perks[existing_perk_index]

		if not perk then
			return false, false
		end

		for i = 1, #item_perks do
			if i ~= existing_perk_index and item_perks[i].id == new_perk_item.name or i == existing_perk_index and item_perks[i].id == new_perk_item.name and item_perks[i].rarity >= new_perk_item.rarity then
				return false, "loc_crafting_replace_perk_not_allowed_wasteful"
			end
		end

		if item_locked and not perk.modified then
			return false, "loc_crafting_error_perk_rerolled"
		end

		return true
	end,
	craft = function (ingredients)
		local costs = CraftingSettings.recipes.replace_perk.get_costs(ingredients)
		local item = ingredients.item
		local promise = Managers.data_service.crafting:replace_perk_in_weapon(item.gear_id, ingredients.existing_perk_index, ingredients.perk_master_ids[1], costs, ingredients.tiers[1])

		return promise
	end,
}
CraftingSettings.recipes_ui_order = {
	CraftingSettings.recipes.upgrade_item,
	CraftingSettings.recipes.replace_perk,
	CraftingSettings.recipes.replace_trait,
	CraftingSettings.recipes.extract_trait,
	CraftingSettings.recipes.fuse_traits,
}
CraftingSettings.trait_sticker_book_enum = table.enum("invalid", "unseen", "seen")

do
	local title_height = 70
	local edge_padding = 12
	local grid_width = 530
	local grid_height = 920
	local grid_size = {
		grid_width - edge_padding,
		grid_height,
	}
	local grid_spacing = {
		0,
		0,
	}
	local mask_size = {
		grid_width + 40,
		grid_height,
	}

	CraftingSettings.weapon_stats_context = {
		scrollbar_width = 7,
		grid_spacing = grid_spacing,
		grid_size = grid_size,
		mask_size = mask_size,
		title_height = title_height,
		edge_padding = edge_padding,
	}
end

do
	local edge_padding = 30
	local grid_width = 430
	local grid_height = 900

	CraftingSettings.crafting_recipe_context = {
		refresh_on_grid_pressed = true,
		reset_selection_on_navigation_change = false,
		scrollbar_width = 7,
		title_height = 0,
		use_select_on_focused = true,
		grid_spacing = {
			0,
			10,
		},
		grid_size = {
			grid_width,
			grid_height,
		},
		mask_size = {
			grid_width + edge_padding,
			grid_height,
		},
		edge_padding = edge_padding,
	}
end

return settings("CraftingSettings", CraftingSettings)
