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

local function scale_by_item_level(cost, item, item_crafting_costs)
	local item_level = item.baseItemLevel
	local item_level_span = item_crafting_costs.baseItemLevelSpan
	local cost_scaling_span = item_crafting_costs.costScalingSpan
	local span_multiplier = math.remap(item_level_span.min or 1, item_level_span.max or 380, cost_scaling_span.min or 1, cost_scaling_span.max or 1, item_level or 380)
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
			amount = amount
		}
	end

	return final_costs
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
				promise = Managers.data_service.crafting:upgrade_gadget_rarity(gear_id)
			else
				promise = Managers.data_service.crafting:upgrade_weapon_rarity(gear_id)
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
			item.traits = item.traits or {}
			local new_num_traits = item_rarity_settings.num_traits
			local num_traits = #item.traits

			if new_num_traits > num_traits then
				for i = num_traits + 1, new_num_traits do
					item.traits[i] = {
						value = 1,
						is_fake = true,
						id = "content/items/traits/unknown_trait"
					}
				end

				local min_new_item_level = ItemUtils.item_trait_rating(item)

				if (not item.traits[#item.traits].rarity or item.traits[#item.traits].rarity == 0) and RankSettings[0].trait_rating == 0 then
					min_new_item_level = min_new_item_level + RankSettings[1].trait_rating
				end

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

				if (not item.perks[#item.perks].rarity or item.perks[#item.perks].rarity == 0) and RankSettings[0].perk_rating == 0 then
					min_new_item_level = min_new_item_level + RankSettings[1].perk_rating
				end

				local max_new_item_level = min_new_item_level + RankSettings[4].perk_rating - RankSettings[1].perk_rating
				item.override_perk_rating_string = string.format("%d - %d", min_new_item_level, max_new_item_level)
			end

			local min_new_item_level = item.itemLevel + (new_num_traits - num_traits) * RankSettings[1].trait_rating + (new_num_perks - num_perks) * RankSettings[1].perk_rating
			item.override_item_rating_string = string.format("%d+", min_new_item_level)
			item.itemLevel = min_new_item_level

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
		ui_disabled = false,
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
			local item = ingredients.item
			local promise = Managers.data_service.crafting:extract_trait_from_weapon(item.gear_id, ingredients.existing_trait_index)

			return promise
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
		button_text = "loc_crafting_replace_option",
		modification_warning = "loc_crafting_warning_replace",
		ui_disabled = false,
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

			if not CraftingSettings.recipes.replace_trait.is_valid_item(item) then
				return false, "loc_crafting_failure"
			end

			local new_trait_item = additional_context.trait_items and additional_context.trait_items[1]

			if not ingredients.trait_ids or not ingredients.trait_ids[1] or not new_trait_item then
				return false, "loc_crafting_no_trait_selected"
			end

			local item_traits = item.traits
			local existing_trait_index = ingredients.existing_trait_index
			local trait = item_traits[existing_trait_index]

			if not trait then
				return false, "loc_crafting_no_trait_selected"
			end

			for i = 1, #item_traits do
				if i ~= existing_trait_index and item_traits[i].id == new_trait_item.name then
					return false, "loc_crafting_not_allowed_wasteful"
				end
			end

			if new_trait_item.name == trait.id and new_trait_item.rarity <= trait.rarity then
				return false, "loc_crafting_not_allowed_wasteful"
			end

			local _, has_trait_modification = ItemUtils.has_crafting_modification(item)

			if has_trait_modification and not trait.modified then
				return false, "loc_crafting_error_trait_replaced"
			end

			return true
		end,
		craft = function (ingredients)
			local item = ingredients.item
			local promise = Managers.data_service.crafting:replace_trait_in_weapon(item.gear_id, ingredients.existing_trait_index, ingredients.trait_master_ids[1], ingredients.tiers[1])

			return promise
		end
	}
}
local dummy_fuse_costs = {
	{
		can_afford = true,
		type = "credits",
		amount = 0
	},
	{
		can_afford = true,
		type = "plasteel",
		amount = 0
	},
	{
		can_afford = true,
		type = "diamantine",
		amount = 0
	}
}
CraftingSettings.recipes.reroll_perk = {
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
		local crafting_costs = Managers.backend.interfaces.crafting:crafting_costs()
		local item = ingredients.item
		local item_type = item.item_type == "GADGET" and "gadget" or "weapon"
		local item_crafting_costs = crafting_costs[item_type]
		local reroll_perk_costs = item_crafting_costs.rerollPerk
		local start_cost = reroll_perk_costs.startCost
		local cost_increase = reroll_perk_costs.costIncrease
		local reroll_count = item.reroll_count
		local rarity = tostring(ingredients.item.rarity)
		local cost_multiplier = cost_increase^(reroll_count or 0)
		local final_costs = calculate_costs(start_cost and start_cost[rarity] or {}, item, item_crafting_costs, cost_multiplier, reroll_perk_costs.clamping)

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
		local promise = Managers.data_service.crafting:reroll_perk_in_item(item.gear_id, ingredients.existing_perk_index, is_gadget)

		return promise
	end
}
CraftingSettings.recipes_ui_order = {
	CraftingSettings.recipes.upgrade_item,
	CraftingSettings.recipes.reroll_perk,
	CraftingSettings.recipes.replace_trait,
	CraftingSettings.recipes.extract_trait,
	CraftingSettings.recipes.fuse_traits
}
CraftingSettings.trait_sticker_book_enum = table.enum("invalid", "unseen", "seen")
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
local grid_height = 900
CraftingSettings.crafting_recipe_context = {
	scrollbar_width = 7,
	use_select_on_focused = true,
	reset_selection_on_navigation_change = false,
	refresh_on_grid_pressed = true,
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
