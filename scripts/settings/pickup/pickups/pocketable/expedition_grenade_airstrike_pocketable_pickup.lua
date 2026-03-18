-- chunkname: @scripts/settings/pickup/pickups/pocketable/expedition_grenade_airstrike_pocketable_pickup.lua

local pickup_data = {
	description = "loc_expeditions_pickup_airstrike_grenade",
	extra_description = "loc_expeditions_pickup_extra_description_airstrike_grenade",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/valkyrie_payload",
	interaction_type = "pocketable",
	inventory_item = "content/items/weapons/player/expedition_airstrike_grenade_smoke",
	inventory_slot_name = "slot_pocketable",
	look_at_tag = "pocketable",
	name = "expedition_grenade_airstrike_pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_grenade",
	smart_tag_target_type = "pickup",
	unit_name = "content/weapons/player/ranged/valkyrie/valkyrie_payload_ogryn_01",
	spawn_offset = Vector3Box(0, 0, 0.18),
}

return pickup_data
