-- chunkname: @scripts/settings/pickup/pickups/pocketable/expedition_grenade_valkyrie_hover_pocketable_pickup.lua

local pickup_data = {
	description = "loc_expeditions_pickup_valkyrie_hover_grenade",
	extra_description = "loc_expeditions_pickup_extra_description_valkyrie_hover_grenade",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/valkyrie_hover",
	interaction_type = "pocketable",
	inventory_item = "content/items/weapons/player/expedition_valkyrie_hover_grenade_smoke",
	inventory_slot_name = "slot_pocketable",
	look_at_tag = "pocketable",
	name = "expedition_grenade_valkyrie_hover_pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_grenade",
	smart_tag_target_type = "pickup",
	unit_name = "content/weapons/player/ranged/valkyrie/valkyrie_hover_ogryn_01",
	spawn_offset = Vector3Box(0, 0, 0.18),
}

return pickup_data
