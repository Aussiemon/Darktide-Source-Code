-- chunkname: @scripts/settings/item/crafting_mechanicus_settings.lua

local Items = require("scripts/utilities/items")
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
			amount = amount
		}
	end

	return final_costs
end

CraftingSettings.recipes = {}
CraftingSettings.recipes.upgrade_item = {
	view_name = "crafting_mechanicus_upgrade_item_view",
	display_name = "loc_crafting_upgrade_option",
	name = "crafting_mechanicus_upgrade_item",
	button_text = "loc_crafting_upgrade_button",
	overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_04",
	icon = "content/ui/materials/icons/crafting/upgrade_item",
	description_text = "loc_crafting_upgrade_description",
	sound_event = UISoundEvents.crafting_view_on_upgrade_item,
	validation_function = function (item)
		return item and is_valid_crafting_item(item)
	end,
	is_valid_item = function (item)
		local is_valid = false
		local reason = ""
		local error_type

		if item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED" or item.item_type == "GADGET" then
			local rarity = item.rarity

			if not rarity then
				reason = Localize("loc_crafting_error_no_upgrade")
			end

			if RaritySettings[rarity + 2] then
				is_valid = true
			else
				reason = Localize("loc_crafting_error_no_consecrate")
				error_type = "complete"
			end
		end

		return is_valid, reason, error_type
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

		return CraftingSettings.recipes.upgrade_item.is_valid_item(item)
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
					value = 1,
					is_fake = true,
					id = "content/items/traits/unknown_trait"
				}
			end

			local min_new_item_level = Items.item_trait_rating(item)

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
					rarity = 1,
					is_fake = true
				}
			end

			local min_new_item_level = Items.item_perk_rating(item)

			if (not item.perks[#item.perks].rarity or item.perks[#item.perks].rarity == 0) and RankSettings[0].perk_rating[rank_item_type_name] == 0 then
				min_new_item_level = min_new_item_level + RankSettings[1].perk_rating[rank_item_type_name]
			end

			local max_new_item_level = min_new_item_level + (RankSettings[4].perk_rating[rank_item_type_name] - RankSettings[1].perk_rating[rank_item_type_name])

			item.override_perk_rating_string = string.format("%d - %d", min_new_item_level, max_new_item_level)
		end

		return item
	end
}
CraftingSettings.recipes.upgrade_expertise = {
	view_name = "crafting_mechanicus_upgrade_expertise_view",
	display_name = "loc_expertise_crafting_title",
	name = "upgrade_expertise",
	button_text = "loc_expertise_crafting_button_upgrade",
	overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_06",
	icon = "content/ui/materials/icons/crafting/enhance_item",
	description_text = "loc_expertise_crafting_description",
	success_text = "loc_crafting_increase_expertise_success",
	sound_event = UISoundEvents.mastery_empower_weapon,
	sound_event_max = UISoundEvents.mastery_empower_weapon_max,
	validation_function = function (item)
		return item and is_valid_crafting_item(item) and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED")
	end,
	is_valid_item = function (item, additional_data)
		local is_valid = false
		local reason = ""
		local error_type

		if (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED") and additional_data and additional_data.expertise_data then
			local start = additional_data.expertise_data.start
			local max_available = additional_data.expertise_data.max_available
			local max = additional_data.expertise_data.max

			if max <= start then
				reason = Localize("loc_crafting_error_max_power")
				error_type = "complete"
			elseif max_available <= start then
				reason = Localize("loc_crafting_empower_error_mastery")
				error_type = "incomplete"
			else
				is_valid = true
			end
		end

		return is_valid, reason, error_type
	end,
	get_costs = function (ingredients, additional_data)
		local crafting_costs = Managers.backend.interfaces.crafting:crafting_costs()

		if additional_data then
			local start_expertise = additional_data.expertise_data.start / Items.get_expertise_multiplier()
			local current_expertise = additional_data.expertise_data.current > 0 and additional_data.expertise_data.current / Items.get_expertise_multiplier() or start_expertise
			local current_max = additional_data.expertise_data.max_available / Items.get_expertise_multiplier()
			local can_craft = start_expertise < current_max
			local operation_costs = crafting_costs.weapon and crafting_costs.weapon.addExpertise and crafting_costs.weapon.addExpertise.startCost

			if not can_craft or not operation_costs or table.is_empty(operation_costs) then
				return {}
			end

			local costs_count = {}
			local costs = {}

			for level = start_expertise + 1, current_expertise do
				local levels_cost = math.floor(level / 10) * 10

				if levels_cost <= 0 then
					levels_cost = 1
				end

				local cost_per_level = operation_costs[tostring(levels_cost)]

				if cost_per_level then
					for i = 1, #cost_per_level do
						local cost = cost_per_level[i]

						costs_count[cost.type] = (costs_count[cost.type] or 0) + cost.amount
					end
				end
			end

			for type, cost in pairs(costs_count) do
				costs[#costs + 1] = {
					type = type,
					amount = cost
				}
			end

			return costs
		end
	end,
	can_craft = function (ingredients, additional_data)
		local item = ingredients.item

		if additional_data then
			local is_valid, reason, error_type = CraftingSettings.recipes.upgrade_expertise.is_valid_item(item, additional_data)

			if not is_valid then
				return is_valid, reason, error_type
			else
				return additional_data.expertise_data.current > 0 and additional_data.expertise_data.current > additional_data.expertise_data.start
			end
		end

		return false
	end,
	craft = function (ingredients, additional_data)
		local item = ingredients.item
		local added_expertise = additional_data.expertise_data.current / Items.get_expertise_multiplier()
		local costs = CraftingSettings.recipes.upgrade_expertise.get_costs(ingredients, additional_data)
		local promise = Managers.data_service.crafting:add_weapon_expertise(item.gear_id, added_expertise, costs)

		return promise
	end,
	get_bogus_result = function (ingredients)
		return true
	end
}
CraftingSettings.recipes.replace_trait = {
	name = "replace_trait",
	display_name = "loc_crafting_replace_option",
	requires_trait_selection = true,
	view_name = "crafting_mechanicus_replace_trait_view",
	overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_02",
	icon = "content/ui/materials/icons/crafting/replace_trait",
	description_text = "loc_crafting_replace_description",
	success_text = "loc_crafting_replace_success",
	ui_hidden = false,
	button_text = "loc_crafting_replace_option",
	modification_warning = "loc_crafting_warning_replace",
	ui_disabled = false,
	sound_event = UISoundEvents.crafting_view_on_replace_trait,
	validation_function = function (item)
		return item and is_valid_crafting_item(item) and (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED")
	end,
	is_valid_item = function (item)
		local is_valid = (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED") and item.traits and #item.traits > 0
		local reason = ""

		if item.item_type ~= "WEAPON_MELEE" and item.item_type ~= "WEAPON_RANGED" or not item.traits or item.traits and #item.traits == 0 then
			reason = Localize("loc_crafting_error_no_blessings")
		end

		return is_valid, reason
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

		if not CraftingSettings.recipes.replace_trait.is_valid_item(item) then
			return false, "loc_crafting_failure"
		end

		local new_trait_item = additional_context.trait_items and additional_context.trait_items[1]

		if not ingredients.trait_ids or not ingredients.trait_ids[1] or not new_trait_item then
			return false, ""
		end

		local existing_trait_index = ingredients.existing_trait_index
		local trait = item_traits[existing_trait_index]

		if not trait then
			return false, ""
		end

		for i = 1, #item_traits do
			if i ~= existing_trait_index and item_traits[i].id == new_trait_item.name then
				return false, Localize("loc_crafting_not_allowed_wasteful")
			end
		end

		if new_trait_item.name == trait.id and new_trait_item.rarity <= trait.rarity then
			return false, Localize("loc_crafting_not_allowed_wasteful")
		end

		local trait_category = Items.trait_category(item)
		local seen_traits = Managers.data_service.crafting:cached_trait_sticker_book(trait_category)
		local seen = true
		local trait_id = new_trait_item.name
		local trait_rarity = new_trait_item.rarity

		for seen_trait_name, status in pairs(seen_traits) do
			if seen_trait_name == trait_id and status ~= nil then
				local trait_status = status[trait_rarity]

				if trait_status == "unseen" then
					seen = false
				end

				break
			end
		end

		if not seen then
			return false, Localize("loc_crafting_not_seen")
		end

		return true
	end,
	craft = function (ingredients)
		local costs = CraftingSettings.recipes.replace_trait.get_costs(ingredients)
		local item = ingredients.item
		local promise = Managers.data_service.crafting:replace_trait_in_weapon(item.gear_id, ingredients.existing_trait_index, ingredients.trait_master_ids[1], ingredients.tiers[1], costs)

		return promise
	end
}
CraftingSettings.recipes.replace_perk = {
	name = "replace_perk",
	display_name = "loc_crafting_reroll_perk_option",
	view_name = "crafting_mechanicus_replace_perk_view",
	requires_perk_selection = true,
	overlay_texture = "content/ui/textures/effects/crafting/recipe_background_overlay_03",
	icon = "content/ui/materials/icons/crafting/reroll_perk",
	description_text = "loc_crafting_replace_perk_description",
	success_text = "loc_crafting_reroll_success",
	ui_hidden = false,
	button_text = "loc_crafting_reroll_perk_button",
	ui_disabled = false,
	sound_event = UISoundEvents.crafting_view_on_reroll_perk,
	validation_function = function (item)
		return item and is_valid_crafting_item(item)
	end,
	is_valid_item = function (item)
		local is_valid = (item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED" or item.item_type == "GADGET") and item.perks and #item.perks > 0
		local reason = not is_valid and Localize("loc_crafting_error_no_perks") or ""

		return is_valid, reason
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

		if not CraftingSettings.recipes.replace_perk.is_valid_item(item) then
			return false, Localize("loc_crafting_failure")
		end

		local new_perk_item = additional_context.perk_items and additional_context.perk_items[1]

		if not ingredients.perk_ids or not ingredients.perk_ids[1] or not new_perk_item then
			return false, ""
		end

		local item_perks = item.perks
		local existing_perk_index = ingredients.existing_perk_index
		local perk = item_perks[existing_perk_index]

		if not perk then
			return false, ""
		end

		for i = 1, #item_perks do
			if i ~= existing_perk_index and item_perks[i].id == new_perk_item.name or i == existing_perk_index and item_perks[i].id == new_perk_item.name and item_perks[i].rarity >= new_perk_item.rarity then
				return false, Localize("loc_crafting_replace_perk_not_allowed_wasteful")
			end
		end

		if additional_context.max_rank and new_perk_item.rarity > additional_context.max_rank then
			return false, Localize("loc_crafting_level_locked", true, {
				required_level = new_perk_item.rarity,
				current_level = additional_context.max_rank
			})
		end

		return true
	end,
	craft = function (ingredients)
		local costs = CraftingSettings.recipes.replace_perk.get_costs(ingredients)
		local item = ingredients.item
		local promise = Managers.data_service.crafting:replace_perk_in_weapon(item.gear_id, ingredients.existing_perk_index, ingredients.perk_master_ids[1], costs, ingredients.tiers[1])

		return promise
	end
}
CraftingSettings.type = "crafting_mechanicus"
CraftingSettings.recipes_ui_order = {
	CraftingSettings.recipes.upgrade_item,
	CraftingSettings.recipes.upgrade_expertise,
	CraftingSettings.recipes.replace_perk,
	CraftingSettings.recipes.replace_trait
}
CraftingSettings.trait_sticker_book_enum = table.enum("invalid", "unseen", "seen")

do
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
end

do
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
end

return settings("CraftingMechanicusSettings", CraftingSettings)
