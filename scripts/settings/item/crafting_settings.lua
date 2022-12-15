local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local RankSettings = require("scripts/settings/item/rank_settings")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local CraftingSettings = {
	MAX_UPGRADE_RARITY_TIER = 5
}

local function is_valid_crafting_item(item)
	return item and not item.no_crafting and RaritySettings[item.rarity]
end

CraftingSettings.recipes = {
	upgrade_item = {
		view_name = "crafting_upgrade_item_view",
		display_name = "loc_crafting_upgrade_option",
		name = "upgrade_item",
		button_text = "loc_crafting_upgrade_button",
		overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_04",
		icon = "content/ui/materials/icons/crafting/upgrade_item",
		description_text = "loc_crafting_upgrade_description",
		success_text = "loc_crafting_upgrade_success",
		sound_event = UISoundEvents.crafting_view_on_upgrade_item,
		is_valid_item = function (item)
			return is_valid_crafting_item(item) and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED" or item.item_type == "GADGET")
		end,
		get_costs = function (ingredients)
			local upgrade_costs_by_type = CraftingSettings.crafting_costs.upgradeItem
			local item_type = ingredients.item.item_type
			local costs = upgrade_costs_by_type[item_type]
			local rarity = tostring(ingredients.item.rarity)

			return costs[rarity]
		end,
		can_craft = function (ingredients)
			local item = ingredients.item

			if not CraftingSettings.recipes.upgrade_item.is_valid_item(item) then
				return false, "loc_crafting_failure"
			end

			if CraftingSettings.MAX_UPGRADE_RARITY_TIER <= item.rarity then
				return false, "loc_crafting_upgrade_max"
			end

			return true
		end,
		craft = function (ingredients)
			local item = ingredients.item
			local gear_id = item.gear_id
			local is_gadget = item.item_type == "GADGET"
			local promise = nil

			if is_gadget then
				promise = Managers.backend.interfaces.crafting:upgrade_gadget_rarity(gear_id)
			else
				promise = Managers.backend.interfaces.crafting:upgrade_weapon_rarity(gear_id)
			end

			return promise:next(function (results)
				local result_item = results.items[1]

				return MasterItems.get_item_instance(result_item, result_item.uuid)
			end)
		end,
		get_bogus_result = function (ingredients)
			local item = MasterItems.create_preview_item_instance(ingredients.item)
			local is_gadget = item.item_type == "GADGET"
			local new_rarity = item.rarity + 1
			item.rarity = new_rarity
			local rarity_settings = RaritySettings[new_rarity]
			local item_rarity_settings = is_gadget and rarity_settings.gadget or rarity_settings.weapon
			item.traits = item.traits or {}
			local new_num_traits = item_rarity_settings.num_traits
			local num_traits = #item.traits

			if new_num_traits > num_traits then
				for i = num_traits + 1, new_num_traits do
					item.traits[i] = {
						id = "content/items/traits/unknown_trait",
						rarity = 1,
						value = 1,
						is_fake = true
					}
				end

				local min_new_item_level = ItemUtils.item_perk_rating(item)
				local max_new_item_level = min_new_item_level + RankSettings[4].trait_rating - RankSettings[1].trait_rating
				item.override_trait_rating_string = string.format("%d - %d", min_new_item_level, max_new_item_level)
			end

			item.perks = item.perks or {}
			local num_perks = #item.perks
			local new_num_perks = item_rarity_settings.num_perks

			if num_perks < new_num_perks then
				for i = num_perks + 1, new_num_perks do
					item.perks[i] = {
						id = "content/items/perks/unknown_perk",
						rarity = 1,
						is_fake = true
					}
				end

				local min_new_item_level = ItemUtils.item_perk_rating(item)
				local max_new_item_level = min_new_item_level + RankSettings[4].perk_rating - RankSettings[1].perk_rating
				item.override_perk_rating_string = string.format("%d - %d", min_new_item_level, max_new_item_level)
			end

			local min_new_item_level = item.itemLevel + (new_num_traits - num_traits) * RankSettings[1].trait_rating + (new_num_perks - num_perks) * RankSettings[1].perk_rating
			local max_new_item_level = item.itemLevel + (new_num_traits - num_traits) * RankSettings[4].trait_rating + (new_num_perks - num_perks) * RankSettings[4].perk_rating
			item.override_item_rating_string = string.format("%d - %d", min_new_item_level, max_new_item_level)

			return item
		end
	},
	extract_trait = {
		name = "extract_trait",
		display_name = "loc_crafting_extract_option",
		view_name = "crafting_extract_trait_view",
		requires_trait_selection = "all",
		show_item_granted_toast = true,
		overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_01",
		icon = "content/ui/materials/icons/crafting/extract_trait",
		description_text = "loc_crafting_extract_description",
		success_text = "loc_crafting_extract_success",
		ui_hidden = false,
		button_text = "loc_crafting_extract_button",
		ui_disabled = true,
		sound_event = UISoundEvents.crafting_view_on_extract_trait,
		is_valid_item = function (item)
			return is_valid_crafting_item(item) and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED") and item.traits and #item.traits > 0
		end,
		get_costs = function (ingredients)
			local item = ingredients.item

			if not item then
				return nil
			end

			local rarity = tostring(ingredients.item.rarity - 1)

			return CraftingSettings.crafting_costs.extractTrait[rarity]
		end,
		can_craft = function (ingredients)
			local item = ingredients.item

			if not CraftingSettings.recipes.extract_trait.is_valid_item(item) then
				return false, nil
			end

			local player = Managers.player:local_player(1)
			local profile = player:profile()
			local loadout = profile.loadout

			for _, slot in pairs(item.slots) do
				local slot_item = loadout[slot]

				if slot_item.gear_id == item.gear_id then
					return false, "loc_crafting_extract_equipped"
				end
			end

			if not item.traits[ingredients.existing_trait_index] then
				return false, "loc_crafting_no_trait_selected"
			end

			return true
		end,
		craft = function (ingredients)
			local item = ingredients.item
			local promise = Managers.backend.interfaces.crafting:extract_trait_from_weapon(item.gear_id, ingredients.existing_trait_index)

			return promise:next(function (result)
				local trait = result.traits[1] or result.items[1]

				return MasterItems.get_item_instance(trait, trait.uuid)
			end)
		end
	},
	replace_trait = {
		name = "replace_trait",
		display_name = "loc_crafting_replace_option",
		view_name = "crafting_replace_trait_view",
		requires_trait_selection = true,
		overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_02",
		icon = "content/ui/materials/icons/crafting/replace_trait",
		description_text = "loc_crafting_replace_description",
		success_text = "loc_crafting_replace_success",
		ui_hidden = false,
		button_text = "loc_crafting_replace_button",
		modification_warning = "loc_crafting_warning_replace",
		ui_disabled = true,
		sound_event = UISoundEvents.crafting_view_on_replace_trait,
		is_valid_item = function (item)
			return is_valid_crafting_item(item) and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED") and item.traits and #item.traits > 0
		end,
		get_costs = function (ingredients)
			local rarity = tostring(ingredients.item.rarity - 1)

			return CraftingSettings.crafting_costs.replaceTrait[rarity]
		end,
		can_craft = function (ingredients)
			local item = ingredients.item

			if not CraftingSettings.recipes.replace_trait.is_valid_item(item) then
				return false, "loc_crafting_failure"
			end

			if not ingredients.new_trait_id then
				return false, "loc_crafting_failure"
			end

			local trait = item.traits[ingredients.existing_trait_index]

			if not trait then
				return false, "loc_crafting_no_trait_selected"
			end

			local _, has_trait_modification = ItemUtils.has_crafting_modification(item)

			if has_trait_modification and not trait.modified then
				return "false", "loc_crafting_error_trait_replaced"
			end

			return true
		end,
		craft = function (ingredients)
			local item = ingredients.item

			return Managers.backend.interfaces.crafting:replace_trait_in_weapon(item.gear_id, ingredients.existing_trait_index, ingredients.new_trait_id)
		end
	},
	fuse_traits = {
		view_name = "crafting_fuse_view",
		display_name = "loc_crafting_view_option_fuse",
		ui_hidden = false,
		name = "fuse_traits",
		show_item_granted_toast = true,
		button_text = "loc_crafting_fuse_button",
		overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_05",
		success_text = "loc_crafting_fuse_success",
		ui_show_in_vendor_view = true,
		icon = "content/ui/materials/icons/crafting/fuse_traits",
		description_text = "loc_crafting_fuse_description",
		ui_disabled = true,
		sound_event = UISoundEvents.crafting_view_on_fuse_traits,
		get_costs = function (ingredients)
			return CraftingSettings.crafting_costs.fuseTraits
		end,
		can_craft = function (ingredients)
			return false, "nyi"
		end,
		craft = function (ingredients)
			local player = Managers.player:local_player(1)
			local character_id = player:character_id()

			return Managers.backend.interfaces.crafting:fuse_traits(character_id, ingredients.trait_ids)
		end
	},
	reroll_perk = {
		name = "reroll_perk",
		display_name = "loc_crafting_reroll_perk_option",
		view_name = "crafting_reroll_perk_view",
		requires_perk_selection = true,
		overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_03",
		icon = "content/ui/materials/icons/crafting/reroll_perk",
		description_text = "loc_crafting_reroll_perk_description",
		success_text = "loc_crafting_reroll_success",
		ui_hidden = false,
		button_text = "loc_crafting_reroll_perk_button",
		modification_warning = "loc_crafting_warning_reroll",
		ui_disabled = false,
		sound_event = UISoundEvents.crafting_view_on_reroll_perk,
		is_valid_item = function (item)
			return is_valid_crafting_item(item) and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED" or item.item_type == "GADGET") and item.perks and #item.perks > 0
		end,
		get_costs = function (ingredients)
			local reroll_perk_costs = CraftingSettings.crafting_costs.rerollPerk
			local start_cost = reroll_perk_costs.startCost
			local cost_increase = reroll_perk_costs.costIncrease
			local item = ingredients.item
			local reroll_count = item.reroll_count
			local rarity = tostring(ingredients.item.rarity)
			local cost_multiplier = cost_increase^(reroll_count or 0)
			local final_costs = {}

			for i, cost in ipairs(start_cost[rarity]) do
				final_costs[i] = {
					type = cost.type,
					amount = math.round(cost.amount * cost_multiplier)
				}
			end

			return final_costs
		end,
		can_craft = function (ingredients)
			local item = ingredients.item

			if not CraftingSettings.recipes.reroll_perk.is_valid_item(item) then
				return false, "loc_crafting_failure"
			end

			local perk = item.perks[ingredients.existing_perk_index]

			if not perk then
				return false, "loc_crafting_no_perk_selected"
			end

			local has_perk_modification, _ = ItemUtils.has_crafting_modification(item)

			if has_perk_modification and not perk.modified then
				return false, "loc_crafting_error_trait_replaced"
			end

			return true
		end,
		craft = function (ingredients)
			local item = ingredients.item
			local is_gadget = item.item_type == "GADGET"
			local promise = Managers.backend.interfaces.crafting:reroll_perk_in_item(item.gear_id, ingredients.existing_perk_index, is_gadget)

			return promise:next(function (results)
				local result_item = results.items[1]

				return MasterItems.get_item_instance(result_item, result_item.uuid)
			end)
		end
	}
}
CraftingSettings.recipes_ui_order = {
	CraftingSettings.recipes.upgrade_item,
	CraftingSettings.recipes.reroll_perk,
	CraftingSettings.recipes.replace_trait,
	CraftingSettings.recipes.extract_trait,
	CraftingSettings.recipes.fuse_traits
}

CraftingSettings.refresh = function ()
	local promise = Managers.backend.interfaces.crafting:get_crafting_costs()

	return promise:next(function (crafting_costs)
		Log.info("CraftingSettings", "Refreshed crafting settings from the backend")

		crafting_costs.upgradeItem = {
			WEAPON_MELEE = crafting_costs.upgradeWeaponRarity,
			WEAPON_RANGED = crafting_costs.upgradeWeaponRarity,
			GADGET = crafting_costs.upgradeGadgetRarity
		}
		CraftingSettings.crafting_costs = crafting_costs
	end)
end

local title_height = 70
local edge_padding = 12
local grid_width = 530
local grid_height = 920
local grid_size = {
	grid_width - edge_padding,
	grid_height
}
local grid_spacing = {
	0,
	0
}
local mask_size = {
	grid_width + 40,
	grid_height
}
CraftingSettings.weapon_stats_context = {
	scrollbar_width = 7,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
local edge_padding = 30
local grid_width = 430
local grid_height = 800
CraftingSettings.crafting_recipe_context = {
	scrollbar_width = 7,
	reset_selection_on_navigation_change = true,
	title_height = 0,
	grid_spacing = {
		0,
		10
	},
	grid_size = {
		grid_width,
		grid_height
	},
	mask_size = {
		grid_width + edge_padding,
		grid_height
	},
	edge_padding = edge_padding
}

return settings("CraftingSettings", CraftingSettings)
