-- chunkname: @scripts/settings/pickup/pickups/luggable/container_02_luggable_pickup.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local pickup_data = {
	description = "loc_pickup_luggable_container_01",
	name = "container_02_luggable",
	look_at_tag = "luggable",
	smart_tag_target_type = "pickup",
	group = "luggable",
	game_object_type = "pickup_projectile",
	inventory_item = "content/items/luggable/container_02_luggable",
	interaction_type = "luggable",
	pickup_sound = "wwise/events/world/play_int_battery_pick_up",
	unit_name = "content/pickups/luggables/container_02/luggable_container_02",
	projectile_template = ProjectileTemplates.luggable,
	spawn_offset = Vector3Box(0, 0, 0.4)
}

return pickup_data
