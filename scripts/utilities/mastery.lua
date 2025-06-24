-- chunkname: @scripts/utilities/mastery.lua

local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local RankSettings = require("scripts/settings/item/rank_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local WeaponExperienceSettings = require("scripts/settings/weapon_experience_settings")
local WeaponUnlockSettings = require("scripts/settings/weapon_unlock_settings")
local dummy_exp_per_level = table.clone(WeaponExperienceSettings.experience_per_level_array)
local cached_pattern_id_to_category_id, cached_category_id_to_pattern_id
local Mastery = {}

Mastery.get_trait_costs = function ()
	local trait_costs = Managers.data_service.crafting:get_traits_mastery_costs() or {}

	return {
		trait_costs = trait_costs.tierCosts,
		trait_unlock_threshold = trait_costs.tierThresholds,
	}
end

Mastery.get_dummy_weapon_xp_per_level = function ()
	return dummy_exp_per_level
end

Mastery.get_weapon_xp_per_level = function (mastery_data)
	local milestones = mastery_data and mastery_data.milestones
	local exp_per_level = {}

	if not milestones then
		return exp_per_level
	end

	exp_per_level[0] = 0

	for i = 1, #milestones do
		local milestone = milestones[i]

		exp_per_level[i] = milestone.xpLimit
	end

	return exp_per_level
end

Mastery.get_max_points = function (mastery_data)
	local milestones = mastery_data and mastery_data.milestones
	local points = 0

	if not milestones then
		return points
	end

	for i = 1, #milestones do
		local milestone = milestones[i]

		if milestone.rewards then
			for id, data in pairs(milestone.rewards) do
				local reward_points = data.stats and data.stats.points

				if id == "mastery_points" and type(reward_points) == "number" then
					points = points + reward_points
				end
			end
		end
	end
end

Mastery.get_all_unlocked_points = function (mastery_data)
	local milestones = mastery_data and mastery_data.milestones
	local current_level = mastery_data and mastery_data.claimed_level and mastery_data.claimed_level + 1 or -1
	local points = 0

	if not milestones or not current_level then
		return points
	end

	for i = 1, current_level do
		local milestone = milestones[i]

		if milestone.rewards then
			for id, data in pairs(milestone.rewards) do
				local reward_points = data.stats and data.stats.points

				if id == "mastery_points" and type(reward_points) == "number" then
					local added_points = reward_points > 0 and reward_points or 0

					points = points + added_points
				end
			end
		end
	end

	return points
end

Mastery.get_max_blessing_rarity_unlocked_level = function (mastery_data)
	local milestones = mastery_data and mastery_data.milestones
	local rarity = 1

	if not milestones then
		return rarity
	end

	local current_level = mastery_data.claimed_level and mastery_data.claimed_level + 1 or -1

	for i = 1, current_level do
		local milestone = milestones[i]

		if milestone.rewards then
			for id, data in pairs(milestone.rewards) do
				if id == "trait_unlock" then
					local trait_rank = data.data and data.data.trait_rank and math.clamp(data.data.trait_rank, 0, RankSettings.max_trait_rank) or 1

					rarity = math.max(rarity, trait_rank)
				end
			end
		end
	end

	return rarity
end

Mastery.get_max_blessing_rarity_unlocked_level_by_points_spent = function (traits)
	local spent_points = Mastery.get_spent_points(traits)

	if spent_points == 0 then
		return 1
	end

	local costs = Mastery.get_trait_costs()
	local unlocked_rarity = table.size(costs.trait_unlock_threshold)

	for i = 1, table.size(costs.trait_unlock_threshold) do
		local cost = costs.trait_unlock_threshold[tostring(i)]

		if spent_points < cost then
			unlocked_rarity = i - 1

			break
		end
	end

	return unlocked_rarity
end

Mastery.get_max_perk_rarity_unlocked_level = function (mastery_data)
	local milestones = mastery_data and mastery_data.milestones
	local rarity = 1

	if not milestones then
		return rarity
	end

	local current_level = mastery_data.claimed_level and mastery_data.claimed_level + 1 or -1

	for i = 1, current_level do
		local milestone = milestones[i]

		if milestone.rewards then
			for id, data in pairs(milestone.rewards) do
				if id == "perk_unlock" then
					local perk_rank = data.data and data.data.perk_rank and math.clamp(data.data.perk_rank, 0, RankSettings.max_perk_rank) or 1

					rarity = math.max(rarity, perk_rank)
				end
			end
		end
	end

	return rarity
end

Mastery.rewards_by_level = function (mastery_data)
	local milestones = mastery_data and mastery_data.milestones
	local level_milestones = {}

	if not milestones then
		return level_milestones
	end

	for i = 1, #milestones do
		local milestone = milestones[i]

		level_milestones[milestone.level] = level_milestones[milestone.level] or {}

		table.insert(level_milestones[milestone.level], milestone.rewards or {})
	end

	return level_milestones
end

Mastery.milestones_by_level = function (mastery_data)
	local milestones = mastery_data and mastery_data.milestones
	local level_milestones = {}

	if not milestones then
		return level_milestones
	end

	for i = 1, #milestones do
		local milestone = milestones[i]

		level_milestones[milestone.level] = level_milestones[milestone.level] or {}

		table.insert(level_milestones[milestone.level], milestone)
	end

	return level_milestones
end

Mastery.get_mastery_max_level = function (mastery_data)
	local max_level = 0
	local milestones = mastery_data and mastery_data.milestones

	if not milestones then
		return max_level
	end

	for i = 1, #milestones do
		local milestone = milestones[i]

		max_level = math.max(max_level, i)
	end

	local exp_per_level = Mastery.get_weapon_xp_per_level(mastery_data)

	return math.min(max_level, #exp_per_level)
end

Mastery.get_masteries_rewards_by_id = function (masteries_data, pattern_id, reward_type_id)
	local rewards = {}

	if not masteries_data or not pattern_id or not reward_type_id then
		return rewards
	end

	if pattern_id and masteries_data[pattern_id] then
		local mastery_data = masteries_data[pattern_id]

		rewards = Mastery.get_mastery_rewards_by_id(mastery_data, reward_type_id)
	elseif not pattern_id then
		for pattern_id, mastery_data in pairs(masteries_data) do
			rewards[pattern_id] = Mastery.get_mastery_rewards_by_id(mastery_data, reward_type_id)
		end
	end

	return rewards
end

Mastery.get_mastery_rewards_by_id = function (mastery_data, reward_type_id)
	local rewards = {}
	local milestones = mastery_data and mastery_data.milestones

	if not milestones then
		return rewards
	end

	if milestones then
		for i = 1, #milestones do
			local milestone = milestones[i]

			if milestone.rewards then
				for id, reward in pairs(milestone.rewards) do
					if string.find(id, reward_type_id) then
						rewards[#rewards + 1] = {
							level = milestone.level,
							reward = reward,
						}
					end
				end
			end
		end
	end

	return rewards
end

Mastery.get_milestone_ui_data = function (milestone)
	local milestone_rewards = {}

	if not milestone then
		return milestone_rewards
	end

	if milestone.rewards then
		for id, data in pairs(milestone.rewards) do
			local reward = Mastery.get_reward_ui_data(id, data)

			if not table.is_empty(reward) then
				milestone_rewards[#milestone_rewards + 1] = reward
			end
		end
	end

	return milestone_rewards
end

Mastery.get_reward_ui_data = function (id, reward)
	local reward_data = {}

	if not reward then
		return reward_data
	end

	local reward_type = id
	local default_icon = "content/ui/materials/icons/weapons/hud/combat_blade_01"

	reward_data.type = reward_type

	if string.find(reward_type, "perk_unlock") then
		local reward_rarity = reward.data and reward.data.perk_rank and math.clamp(reward.data.perk_rank, 0, RankSettings.max_perk_rank) or 0

		reward_data.icon = RankSettings[reward_rarity].perk_icon
		reward_data.display_name = Localize("loc_mastery_reward_perk_unlock", true, {
			rarity = reward_rarity,
		})
		reward_data.icon_size = {
			32,
			32,
		}

		return reward_data
	elseif string.find(reward_type, "trait_unlock") then
		local reward_rarity = reward.data and reward.data.trait_rank and math.clamp(reward.data.trait_rank, 0, RankSettings.max_trait_rank) or 0

		reward_data.icon = "content/ui/materials/icons/traits/traits_container"
		reward_data.icon_material_values = {
			frame = RankSettings[reward_rarity].trait_frame_texture,
		}
		reward_data.display_name = Localize("loc_mastery_reward_blessing_unlock", true, {
			rarity = reward_rarity,
		})
		reward_data.icon_size = {
			100,
			100,
		}
		reward_data.icon_color = Color.terminal_text_body(255, true)

		return reward_data
	elseif string.find(reward_type, "mastery_points") then
		reward_data.display_name = Localize("loc_mastery_reward_mastery_points")

		local points = reward.stats and reward.stats.points or 0

		reward_data.text = string.format("\n+%s", points)

		return reward_data
	elseif string.find(reward_type, "expertise_point") then
		reward_data.display_name = Localize("loc_mastery_reward_expertise_cap")

		local expertise_cap = reward.data and reward.data.expertise_cap * Items.get_expertise_multiplier() or 0

		reward_data.text = string.format("\n%s", expertise_cap)

		return reward_data
	elseif string.find(reward_type, "currency") then
		local currency_data = WalletSettings[reward.type]

		reward_data.icon = currency_data.icon_texture_big
		reward_data.display_name = Localize(currency_data.display_name)
		reward_data.icon_size = {
			84,
			60,
		}
		reward_data.text = reward.value

		return reward_data
	elseif string.find(reward_type, "cosmetic") then
		reward_data.icon = default_icon
		reward_data.display_name = reward_type
		reward_data.icon_size = {
			300,
			128,
		}

		return reward_data
	elseif string.find(reward_type, "mark_unlock") then
		local item = Mastery.get_mark_item(reward)

		if item then
			local master_item = item and MasterItems.get_item(item)
			local icon = master_item and master_item.hud_icon or default_icon
			local display_name = master_item and Items.weapon_card_sub_display_name(master_item) or master_item and master_item.type

			reward_data.icon = icon
			reward_data.display_name = display_name
			reward_data.icon_size = {
				300,
				128,
			}

			return reward_data
		end

		return reward_data
	end

	return reward_data
end

Mastery.get_level_by_xp = function (mastery_data, xp)
	if not xp or not mastery_data then
		return 0
	end

	local levels = Mastery.get_weapon_xp_per_level(mastery_data)
	local max_level = Mastery.get_mastery_max_level(mastery_data)

	if table.is_empty(levels) then
		return 0
	end

	for i = 0, max_level do
		local level_xp = levels[i]

		if xp < level_xp then
			return math.max(i - 1, 0)
		end
	end

	return max_level
end

Mastery.get_current_expertise_cap = function (mastery_data)
	local default_expertise = 10 * Items.get_expertise_multiplier()

	if not mastery_data or table.is_empty(mastery_data) then
		return default_expertise
	end

	local rewards_data = Mastery.get_mastery_rewards_by_id(mastery_data, "expertise_point")
	local current_level = mastery_data.claimed_level + 1 or -1

	if table.is_empty(rewards_data) then
		return default_expertise
	end

	for i = #rewards_data, 1, -1 do
		local reward_data = rewards_data[i]

		if current_level >= reward_data.level then
			local cap_reward = rewards_data[i]
			local cap = cap_reward and cap_reward.reward and cap_reward.reward.data and cap_reward.reward.data.expertise_cap * Items.get_expertise_multiplier() or default_expertise

			return cap
		end
	end

	return default_expertise
end

Mastery.get_max_expertise_cap = function (mastery_data)
	if not mastery_data or table.is_empty(mastery_data) then
		return 0
	end

	local rewards_data = Mastery.get_mastery_rewards_by_id(mastery_data, "expertise_point")

	if table.is_empty(rewards_data) then
		return 0
	end

	local reward_data = rewards_data[#rewards_data]

	if reward_data then
		local cap = reward_data.reward and reward_data.reward.data and reward_data.reward.data.expertise_cap * Items.get_expertise_multiplier() or 0

		return cap
	end

	return 0
end

Mastery.get_mark_data = function (mark_reward)
	local mark_data = {}

	for pattern, data in pairs(UISettings.weapon_patterns) do
		local found = false

		for i = 1, #data.marks do
			local mark = data.marks[i]

			if mark.name == mark_reward.id then
				mark_data = mark
				found = true

				break
			end
		end

		if found then
			break
		end
	end

	return mark_data
end

Mastery.get_mark_item = function (mark_reward)
	local mark_data = Mastery.get_mark_data(mark_reward)

	return mark_data and mark_data.item
end

local mark_diff_texts = {
	melee = {
		"Stagger",
		"Combo",
	},
	ranged = {
		"Recoil",
		"Ammunition",
	},
	common = {
		"Damage",
		"Speed",
		"Weight",
		"Boost",
		"Chad",
	},
}
local mark_higher_text = "+ Higher"
local mark_lower_text = "- Lower"

local function generate_mark_text(mark_item)
	local slot = mark_item.slots[1]
	local options = table.clone(mark_diff_texts.common)

	if slot == "slot_primary" then
		table.merge(options, mark_diff_texts.melee)
	else
		table.merge(options, mark_diff_texts.ranged)
	end

	local random_positive_index = math.random(1, #options)
	local positive_text = string.format("%s %s", mark_higher_text, options[random_positive_index])

	table.remove(options, random_positive_index)

	local random_negative_index = math.random(1, #options)
	local negative_text = string.format("%s %s", mark_lower_text, options[random_negative_index])

	return positive_text, negative_text
end

Mastery.get_all_mastery_marks = function (mastery_data)
	local mastery_id = mastery_data and mastery_data.mastery_id

	if not mastery_id then
		return {}
	end

	local mark_milestones = Mastery.get_mastery_rewards_by_id(mastery_data, "mark_unlock")
	local marks_data = {}

	if mark_milestones then
		for i = 1, #mark_milestones do
			local mark = mark_milestones[i]
			local mark_data = Mastery.get_mark_data(mark.reward)
			local mark_item = mark_data and mark_data.item
			local master_item = mark_item and MasterItems.get_item(mark_item)

			if master_item then
				local hud_icon = master_item.hud_icon or "content/ui/materials/icons/weapons/hud/combat_blade_01"
				local mark_level = mark.level or 1
				local current_level = mastery_data.claimed_level and mastery_data.claimed_level + 1 or -1
				local positive_text, negative_text = generate_mark_text(master_item)

				marks_data[#marks_data + 1] = {
					icon = hud_icon,
					level = mark_level,
					display_name = Items.weapon_card_sub_display_name(master_item),
					unlocked = mark_level <= current_level,
					item = master_item,
					mark_attributes = {
						positive_text,
						negative_text,
					},
					comparison_text = mark_data and mark_data.comparison_text or "",
				}
			end
		end
	end

	return marks_data
end

Mastery.get_start_and_end_xp = function (mastery_data)
	local start_exp = 0
	local end_exp = 0

	if not mastery_data or not mastery_data.milestones then
		return start_exp, end_exp
	end

	local milestones = mastery_data.milestones
	local current_xp = mastery_data.current_xp

	for i = 1, #milestones do
		local milestone = milestones[i]
		local milestone_xp = milestone.xpLimit or 1
		local previous_milestone = milestones[i - 1]

		if current_xp < milestone_xp then
			start_exp = previous_milestone and previous_milestone.xpLimit or 0
			end_exp = milestone_xp

			break
		end
	end

	return start_exp, end_exp
end

Mastery.get_start_and_end_xp_by_level = function (mastery_data)
	local start_exp = 0
	local end_exp = 0

	if not mastery_data or not mastery_data.milestones then
		return start_exp, end_exp
	end

	local milestones = mastery_data.milestones
	local current_level = mastery_data.mastery_level
	local milestone = milestones[current_level]
	local milestone_xp = milestone.xpLimit or 1
	local max_level = Mastery.get_mastery_max_level(mastery_data)

	start_exp = milestone_xp

	local next_milestone = current_level == max_level and milestones[current_level] or milestones[current_level + 1]

	end_exp = next_milestone.xpLimit or 1

	return start_exp, end_exp
end

Mastery.get_trait_cost = function (trait_rarity)
	local costs = Mastery.get_trait_costs()
	local rarity = tostring(trait_rarity and math.clamp(trait_rarity, 1, table.size(costs.trait_costs)) or 1)

	return costs.trait_costs[rarity] or 0
end

Mastery.get_spent_points = function (traits)
	local points_spent = 0
	local costs = Mastery.get_trait_costs()

	for i = 1, #traits do
		local trait = traits[i]
		local trait_status = trait.trait_status
		local rarity = 1
		local unlocked = false

		for i = 1, RankSettings.max_trait_rank do
			local current_trait_status = trait_status[i]

			if current_trait_status == "seen" then
				local cost = costs.trait_costs[tostring(i)] or 0

				points_spent = points_spent + cost
			end
		end
	end

	return points_spent
end

Mastery.get_max_trait_points = function (traits)
	local points = 0
	local costs = Mastery.get_trait_costs()

	for i = 1, #traits do
		local trait = traits[i]
		local trait_status = trait.trait_status
		local rarity = 1
		local unlocked = false

		for i = 1, RankSettings.max_trait_rank do
			local current_trait_status = trait_status[i]
			local cost = costs.trait_costs[tostring(i)] or 0

			points = points + cost
		end
	end

	return points
end

Mastery.get_available_points = function (mastery_data, traits)
	local spent_points = Mastery.get_spent_points(traits)
	local max_trait_points = Mastery.get_max_trait_points(traits)
	local unlocked_points = Mastery.get_all_unlocked_points(mastery_data)
	local total_points = math.min(unlocked_points, max_trait_points)

	return math.clamp(total_points - spent_points, 0, total_points)
end

Mastery.get_trait_level_unlock_from_mastery_count = function (rarity)
	local costs = Mastery.get_trait_costs()

	return costs.trait_unlock_threshold[tostring(rarity)] or 0
end

Mastery.get_max_trait_level_unlock_from_mastery_count = function ()
	local costs = Mastery.get_trait_costs()

	return costs.trait_unlock_threshold[tostring(table.size(costs.trait_unlock_threshold))] or 0
end

Mastery.get_levels_to_claim = function (mastery_data, new_xp)
	local start_claim_level = -1
	local end_claim_level = 0

	if mastery_data then
		local claimed_level = mastery_data.claimed_level or -1
		local end_level

		if new_xp then
			end_level = Mastery.get_level_by_xp(mastery_data, new_xp) or end_claim_level
		else
			end_level = mastery_data.mastery_level or end_claim_level
		end

		start_claim_level = claimed_level + 1
		end_claim_level = end_level - 1
	end

	return start_claim_level, end_claim_level
end

Mastery.has_available_points = function (masteries_data, masteries_traits)
	local available_points = 0
	local filtered_masteries_data = Mastery.get_masteries_by_archetype(masteries_data)

	for id, mastery_data in pairs(filtered_masteries_data) do
		local is_unlocked = Mastery.is_mastery_unlocked(mastery_data)

		if is_unlocked then
			available_points = available_points + (Mastery.get_available_points(mastery_data, masteries_traits[id]) or 0)

			if available_points > 0 then
				return true
			end
		end
	end

	return false
end

Mastery.can_claim_any_reward = function (masteries_data)
	local filtered_masteries_data = Mastery.get_masteries_by_archetype(masteries_data)

	for pattern_id, mastery_data in pairs(filtered_masteries_data) do
		if Mastery.can_claim_reward(mastery_data) then
			return true
		end
	end

	return false
end

Mastery.can_claim_reward = function (mastery_data)
	local start_claim_level, end_claim_level = Mastery.get_levels_to_claim(mastery_data)
	local is_unlocked = Mastery.is_mastery_unlocked(mastery_data)

	return is_unlocked and start_claim_level <= end_claim_level
end

Mastery.get_masteries_by_archetype = function (masteries_data)
	local player_manager = Managers.player
	local player = player_manager:local_player(1)
	local profile = player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local weapon_patterns = UISettings.weapon_patterns
	local filtered_masteries = {}

	for id, data in pairs(weapon_patterns) do
		local mastery_data = masteries_data[id]
		local master_item_name = data.marks[1].item
		local master_item = MasterItems.get_item(master_item_name)

		if master_item then
			local allowed_archetypes = master_item.archetypes

			if table.contains(allowed_archetypes, archetype_name) then
				filtered_masteries[id] = mastery_data
			end
		end
	end

	return filtered_masteries
end

Mastery.is_mastery_unlocked = function (mastery_data)
	local player_manager = Managers.player
	local player = player_manager:local_player(1)
	local profile = player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local weapon_patterns = UISettings.weapon_patterns
	local archetype_weapon_unlocks = WeaponUnlockSettings[archetype_name]
	local weapon_level_requirement = 1
	local data = weapon_patterns[mastery_data.mastery_id]
	local master_item_name = data.marks[1].item

	for weapon_level, weapon_list in ipairs(archetype_weapon_unlocks) do
		if table.contains(weapon_list, master_item_name) then
			weapon_level_requirement = weapon_level

			break
		end
	end

	return weapon_level_requirement <= profile.current_level, weapon_level_requirement
end

Mastery.get_xp_for_next_level = function (mastery_data)
	local xp = 0

	if not mastery_data then
		return xp
	end

	local current_xp = mastery_data.current_xp
	local start_exp, end_exp = Mastery.get_start_and_end_xp(mastery_data)

	xp = math.max(0, end_exp - current_xp)

	return xp
end

Mastery.get_xp_for_max_level = function (mastery_data)
	local xp = 0

	if not mastery_data then
		return xp
	end

	local current_xp = mastery_data.current_xp
	local milestones = mastery_data.milestones
	local milestone = milestones[#milestones]
	local end_xp = milestone.xpLimit or 0

	xp = math.max(0, end_xp - current_xp)

	return xp
end

Mastery.get_weapon_mapping = function ()
	if not cached_pattern_id_to_category_id or not cached_category_id_to_pattern_id then
		local category_id_to_pattern_id = {}
		local pattern_id_to_category_id = {}
		local patterns = UISettings.weapon_patterns

		for id, data in pairs(patterns) do
			local item = MasterItems.get_item(data.marks[1].item)

			if item then
				local trait_category = Items.trait_category(item)

				category_id_to_pattern_id[trait_category] = id
				pattern_id_to_category_id[id] = trait_category
			end
		end

		cached_pattern_id_to_category_id = pattern_id_to_category_id
		cached_category_id_to_pattern_id = category_id_to_pattern_id
	end

	return cached_category_id_to_pattern_id, cached_pattern_id_to_category_id
end

Mastery.get_category_id_to_pattern_id = function (id)
	local category_id_to_pattern_id = Mastery.get_weapon_mapping()

	return category_id_to_pattern_id[id]
end

Mastery.get_pattern_id_to_category_id = function (id)
	local _, pattern_id_to_category_id = Mastery.get_weapon_mapping()

	return pattern_id_to_category_id[id]
end

Mastery.get_default_mark_for_mastery = function (mastery_data)
	local player_manager = Managers.player
	local player = player_manager:local_player(1)
	local profile = player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local weapon_patterns = UISettings.weapon_patterns
	local archetype_weapon_unlocks = WeaponUnlockSettings[archetype_name]
	local avaialble_weapons = {}

	for i = 1, #archetype_weapon_unlocks do
		local unlock_level = archetype_weapon_unlocks[i]

		for ii = 1, #unlock_level do
			local item = unlock_level[ii]

			avaialble_weapons[item] = true
		end
	end

	local data = weapon_patterns[mastery_data.mastery_id]

	for i = 1, #data.marks do
		local master_item = data.marks[i].item

		if avaialble_weapons[master_item] then
			return master_item
		end
	end
end

Mastery.get_unclaimed_rewards = function (mastery_data)
	local result = {}

	if not mastery_data or not mastery_data.milestones then
		return result
	end

	local claimed_level = mastery_data.claimed_level

	if claimed_level == -1 then
		return result
	end

	for i = 1, claimed_level + 1 do
		local milestone = mastery_data.milestones[i]
		local rewards = milestone.rewards

		if rewards then
			for reward_name, data in pairs(rewards) do
				if not data.claimed then
					local claim_level_from_milestone = i - 1

					result[claim_level_from_milestone] = result[claim_level_from_milestone] or {}
					result[claim_level_from_milestone][#result[claim_level_from_milestone] + 1] = reward_name
				end
			end
		end
	end

	return result
end

return Mastery
