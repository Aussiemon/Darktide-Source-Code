-- chunkname: @scripts/settings/pickup/pickups/luggable/container_01_luggable_pickup.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local pickup_data = {
	description = "loc_luggable_name_contagion_sample_desc",
	game_object_type = "pickup_projectile",
	group = "luggable",
	interaction_type = "luggable",
	inventory_item = "content/items/luggable/container_01_luggable",
	look_at_tag = "luggable",
	name = "container_01_luggable",
	pickup_sound = "wwise/events/world/play_int_battery_pick_up",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/luggables/container_01/luggable_container_01",
	projectile_template = ProjectileTemplates.luggable,
	spawn_offset = Vector3Box(0, 0, 0.4),
}

return pickup_data
