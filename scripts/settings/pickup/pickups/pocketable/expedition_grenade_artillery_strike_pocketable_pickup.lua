-- chunkname: @scripts/settings/pickup/pickups/pocketable/expedition_grenade_artillery_strike_pocketable_pickup.lua

local pickup_data = {
	description = "loc_expeditions_pickup_description_artillery_strike",
	extra_description = "loc_expeditions_pickup_extra_description_expedition_artillery_strike",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/artillery_strike",
	interaction_type = "pocketable",
	inventory_item = "content/items/weapons/player/expedition_artillery_strike_grenade_smoke",
	inventory_slot_name = "slot_pocketable",
	look_at_tag = "pocketable",
	name = "expedition_grenade_artillery_strike_pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_grenade",
	smart_tag_target_type = "pickup",
	unit_name = "content/environment/gameplay/expeditions/grenades/artillery_ogryn_01",
	spawn_offset = Vector3Box(0, 0, 0.137),
}

return pickup_data
