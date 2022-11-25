local MasterItems = require("scripts/backend/master_items")
local display_duration = 0.8
local defined_level_rewards = {
	{
		text = "New Talent Point",
		type = "acquired",
		level = 5,
		duration = display_duration
	},
	{
		text = "New Talent Point",
		type = "acquired",
		level = 10,
		duration = display_duration
	},
	{
		text = "New Talent Point",
		type = "acquired",
		level = 15,
		duration = display_duration
	},
	{
		text = "New Talent Point",
		type = "acquired",
		level = 20,
		duration = display_duration
	},
	{
		text = "New Talent Point",
		type = "acquired",
		level = 25,
		duration = display_duration
	},
	{
		text = "New Talent Point",
		type = "acquired",
		level = 30,
		duration = display_duration
	},
	{
		text = "Vendors Now Available",
		type = "unlock",
		level = 2,
		duration = display_duration
	},
	{
		text = "Career Path Now Available",
		type = "unlock",
		level = 8,
		duration = display_duration
	},
	{
		text = "Gadgets",
		type = "unlock",
		level = 14,
		duration = display_duration
	},
	{
		text = "Crafting Station Now Available",
		type = "unlock",
		level = 19,
		duration = display_duration
	},
	{
		text = "Contracts Now Available",
		type = "unlock",
		level = 23,
		duration = display_duration
	}
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
		duration = display_duration
	}
end

local player_level_reward_settings = {
	rewards = rewards,
	duration_per_reward = display_duration
}

return player_level_reward_settings
