-- chunkname: @scripts/settings/pickup/pickups/consumable/large_clip_pickup.lua

local pickup_data = {
	ammunition_percentage = 0.5,
	description = "loc_pickup_consumable_large_clip_01",
	game_object_type = "pickup",
	group = "ammo",
	interaction_type = "ammunition",
	look_at_tag = "ammo",
	name = "large_clip",
	pickup_sound = "wwise/events/player/play_pick_up_ammo_02",
	smart_tag_target_type = "pickup",
	spawn_weighting = 0.5,
	unit_name = "content/pickups/consumables/ammo_02/consumable_ammo_02",
	unit_template_name = "pickup",
	ammo_amount_func = function (max_ammunition_reserve, max_ammo_clip, pickup_data)
		local modifier = pickup_data.modifier or 1
		local percentage = pickup_data.ammunition_percentage * modifier
		local amount = math.ceil(percentage * max_ammunition_reserve)

		return amount
	end,
}

return pickup_data
