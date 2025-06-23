-- chunkname: @scripts/settings/pickup/pickups/consumable/small_grenade_pickup.lua

local pickup_data = {
	description = "loc_pickup_consumable_small_grenade_01",
	name = "small_grenade",
	look_at_tag = "grenade",
	smart_tag_target_type = "pickup",
	pickup_sound = "wwise/events/player/play_pick_up_grenade",
	interaction_type = "grenade",
	group = "ability",
	unit_name = "content/pickups/consumables/refill_01/consumable_refill_01",
	charges_restored = 100
}

return pickup_data
