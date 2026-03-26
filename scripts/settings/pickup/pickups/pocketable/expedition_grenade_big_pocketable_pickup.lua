-- chunkname: @scripts/settings/pickup/pickups/pocketable/expedition_grenade_big_pocketable_pickup.lua

local pickup_data = {
	description = "loc_expeditions_pickup_description_big_grenade",
	extra_description = "loc_expeditions_pickup_extra_description_big_grenade",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/big_fn_grenade",
	interaction_type = "pocketable",
	inventory_item = "content/items/weapons/player/grenade_expeditions_big",
	inventory_slot_name = "slot_pocketable",
	look_at_tag = "pocketable",
	name = "expedition_grenade_big_pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_grenade",
	retain_charges = true,
	smart_tag_target_type = "pickup",
	unit_name = "content/environment/gameplay/expeditions/grenades/big_fing_grenade_01",
	spawn_offset = Vector3Box(0, 0, 0.11),
}

return pickup_data
