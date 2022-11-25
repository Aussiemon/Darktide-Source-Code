local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local CraftingSettings = {
	MAX_UPGRADE_RARITY_TIER = 5,
	rating_per_perk_rank = {
		10,
		15,
		20,
		25
	},
	rating_per_trait_rank = {
		25,
		35,
		45,
		55
	}
}

local function is_valid_crafting_item(item)
	return not item.no_crafting and RaritySettings[item.rarity]
end

CraftingSettings.recipes = {
	upgrade_item = {
		view_name = "crafting_upgrade_item_view",
		display_name = "loc_crafting_upgrade_option",
		name = "upgrade_item",
		overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_04",
		icon = "content/ui/materials/icons/crafting/upgrade_item",
		description_text = "loc_crafting_upgrade_description",
		sound_event = UISoundEvents.crafting_view_on_upgrade_item,
		is_valid_item = is_valid_crafting_item,
		can_craft = function (ingredients)
			local item = ingredients.item

			return is_valid_crafting_item(item) and item.rarity < CraftingSettings.MAX_UPGRADE_RARITY_TIER
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
			local is_gadget = ingredients.item.item_type == "GADGET"
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
						value = 1
					}
				end
			end

			item.perks = item.perks or {}
			local num_perks = #item.perks
			local new_num_perks = item_rarity_settings.num_perks

			if num_perks < new_num_perks then
				for i = num_perks + 1, new_num_perks do
					item.perks[i] = {
						id = "content/items/perks/unknown_perk",
						rarity = 1
					}
				end
			end

			local current_item_level = tonumber(item.itemLevel) or 0
			local min_new_item_level = current_item_level + (new_num_traits - num_traits) * CraftingSettings.rating_per_trait_rank[1] + (new_num_perks - num_perks) * CraftingSettings.rating_per_perk_rank[1]
			local max_new_item_level = current_item_level + (new_num_traits - num_traits) * CraftingSettings.rating_per_trait_rank[4] + (new_num_perks - num_perks) * CraftingSettings.rating_per_perk_rank[4]
			item.itemLevel = string.format("%d - %d", min_new_item_level, max_new_item_level)

			return item
		end
	},
	extract_trait = {
		name = "extract_trait",
		display_name = "loc_crafting_extract_option",
		ui_hidden = false,
		view_name = "crafting_modify_options_view",
		overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_01",
		icon = "content/ui/materials/icons/crafting/extract_trait",
		description_text = "loc_crafting_extract_description",
		ui_disabled = true,
		sound_event = UISoundEvents.crafting_view_on_extract_trait,
		is_valid_item = function (item)
			return is_valid_crafting_item(item) and item.item_type ~= "GADGET" and item.traits and #item.traits > 0
		end,
		can_craft = function (ingredients)
			local item = ingredients.item

			return CraftingSettings.recipes.extract_trait.is_valid_item(item) and item.traits[ingredients.trait_index]
		end,
		craft = function (ingredients)
			local item = ingredients.item

			return Managers.backend.interfaces.crafting:extract_trait_from_weapon(item.gear_id, ingredients.trait_index)
		end
	},
	replace_trait = {
		name = "replace_trait",
		display_name = "loc_crafting_replace_option",
		ui_hidden = false,
		view_name = "crafting_modify_options_view",
		overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_02",
		icon = "content/ui/materials/icons/crafting/replace_trait",
		description_text = "loc_crafting_replace_description",
		ui_disabled = true,
		sound_event = UISoundEvents.crafting_view_on_replace_trait,
		is_valid_item = function (item)
			return is_valid_crafting_item(item) and item.item_type ~= "GADGET" and item.traits and #item.traits > 0
		end,
		can_craft = function (ingredients)
			return CraftingSettings.recipes.replace_trait.is_valid_item(ingredients.item)
		end,
		craft = function (ingredients)
			local item = ingredients.item

			return Managers.backend.interfaces.crafting:replace_trait_in_weapon(item.gear_id, ingredients.existing_trait_index, ingredients.new_trait_id)
		end
	},
	fuse_traits = {
		name = "fuse_traits",
		display_name = "loc_crafting_view_option_fuse",
		ui_show_in_vendor_view = true,
		ui_hidden = false,
		view_name = "crafting_fuse_view",
		overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_05",
		icon = "content/ui/materials/icons/crafting/fuse_traits",
		description_text = "loc_crafting_fuse_description",
		ui_disabled = true,
		sound_event = UISoundEvents.crafting_view_on_fuse_traits,
		can_craft = function (ingredients)
			return false
		end,
		craft = function (ingredients)
			return Promise.rejected({
				error = "nyi "
			})
		end
	},
	reroll_perk = {
		view_name = "crafting_reroll_perk_view",
		display_name = "loc_crafting_reroll_perk_option",
		name = "reroll_perk",
		ui_hidden = false,
		requires_perk_selection = true,
		overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_03",
		icon = "content/ui/materials/icons/crafting/reroll_perk",
		description_text = "loc_crafting_reroll_perk_description",
		ui_disabled = true,
		sound_event = UISoundEvents.crafting_view_on_reroll_perk,
		is_valid_item = is_valid_crafting_item,
		can_craft = function (ingredients)
			local item = ingredients.item

			return is_valid_crafting_item(item) and item.perks and #item.perks > 0 and item.perks[ingredients.existing_perk_index] ~= nil
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
	CraftingSettings.recipes.extract_trait,
	CraftingSettings.recipes.replace_trait,
	CraftingSettings.recipes.fuse_traits
}

return settings("CraftingSettings", CraftingSettings)
