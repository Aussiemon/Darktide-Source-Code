-- chunkname: @scripts/settings/pickup/pickups/luggable/container_03_luggable_pickup.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local pickup_data = {
	description = "loc_interactable_luggable_ammo",
	name = "container_03_luggable",
	look_at_tag = "luggable",
	smart_tag_target_type = "pickup",
	group = "luggable",
	interaction_type = "luggable",
	spawn_weighting = 1,
	game_object_type = "pickup_projectile",
	unit_name = "content/pickups/luggables/container_01/luggable_container_01",
	inventory_item = "content/items/luggable/container_01_luggable",
	unit_template_name = "pickup",
	pickup_sound = "wwise/events/world/play_int_battery_pick_up",
	projectile_template = ProjectileTemplates.luggable,
	spawn_offset = Vector3Box(0, 0, 0.4)
}

return pickup_data
