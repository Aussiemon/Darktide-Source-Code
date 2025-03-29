-- chunkname: @scripts/settings/pickup/pickups/consumable/small_grenade_pickup.lua

local pickup_data = {
	charges_restored = 100,
	description = "loc_pickup_consumable_small_grenade_01",
	group = "ability",
	interaction_type = "grenade",
	look_at_tag = "grenade",
	name = "small_grenade",
	pickup_sound = "wwise/events/player/play_pick_up_grenade",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/consumables/refill_01/consumable_refill_01",
}

return pickup_data
