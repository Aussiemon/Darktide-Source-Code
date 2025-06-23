-- chunkname: @scripts/settings/pickup/pickups/luggable/battery_01_luggable_pickup.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local pickup_data = {
	description = "loc_pickup_luggable_battery_01",
	name = "battery_01_luggable",
	look_at_tag = "luggable",
	smart_tag_target_type = "pickup",
	group = "luggable",
	game_object_type = "pickup_projectile",
	inventory_item = "content/items/luggable/battery_01_luggable",
	interaction_type = "luggable",
	pickup_sound = "wwise/events/world/play_int_battery_pick_up",
	unit_name = "content/pickups/luggables/battery_01/luggable_battery_01",
	projectile_template = ProjectileTemplates.luggable,
	spawn_offset = Vector3Box(0, 0, 0.4)
}

return pickup_data
