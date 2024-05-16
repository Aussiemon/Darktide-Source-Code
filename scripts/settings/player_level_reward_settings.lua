-- chunkname: @scripts/settings/player_level_reward_settings.lua

local MasterItems = require("scripts/backend/master_items")
local display_duration = 0.8
local defined_level_rewards = {
	{
		level = 5,
		text = "New Talent Point",
		type = "acquired",
		duration = display_duration,
	},
	{
		level = 10,
		text = "New Talent Point",
		type = "acquired",
		duration = display_duration,
	},
	{
		level = 15,
		text = "New Talent Point",
		type = "acquired",
		duration = display_duration,
	},
	{
		level = 20,
		text = "New Talent Point",
		type = "acquired",
		duration = display_duration,
	},
	{
		level = 25,
		text = "New Talent Point",
		type = "acquired",
		duration = display_duration,
	},
	{
		level = 30,
		text = "New Talent Point",
		type = "acquired",
		duration = display_duration,
	},
	{
		level = 2,
		text = "Vendors Now Available",
		type = "unlock",
		duration = display_duration,
	},
	{
		level = 8,
		text = "Career Path Now Available",
		type = "unlock",
		duration = display_duration,
	},
	{
		level = 14,
		text = "Gadgets",
		type = "unlock",
		duration = display_duration,
	},
	{
		level = 19,
		text = "Crafting Station Now Available",
		type = "unlock",
		duration = display_duration,
	},
	{
		level = 23,
		text = "Contracts Now Available",
		type = "unlock",
		duration = display_duration,
	},
}
local rewards = table.clone(defined_level_rewards)
local weapon_items_array = {}
local item_definitions = MasterItems.get_cached()

for item_key, item in pairs(item_definitions) do
	local slots = item.slots

	if slots and (table.contains(slots, "slot_primary") or table.contains(slots, "slot_secondary")) then
		weapon_items_array[#weapon_items_array + 1] = item
	end
end

for i = 1, 30 do
	local random_item_index = math.random(1, #weapon_items_array)
	local item = weapon_items_array[random_item_index]

	rewards[#rewards + 1] = {
		text = "testing testing",
		type = "item",
		level = i,
		item = item,
		duration = display_duration,
	}
end

local player_level_reward_settings = {
	rewards = rewards,
	duration_per_reward = display_duration,
}

return player_level_reward_settings
