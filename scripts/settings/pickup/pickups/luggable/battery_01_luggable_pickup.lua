-- chunkname: @scripts/settings/pickup/pickups/luggable/battery_01_luggable_pickup.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local pickup_data = {
	description = "loc_pickup_luggable_battery_01",
	game_object_type = "pickup_projectile",
	group = "luggable",
	interaction_type = "luggable",
	inventory_item = "content/items/luggable/battery_01_luggable",
	look_at_tag = "luggable",
	name = "battery_01_luggable",
	pickup_sound = "wwise/events/world/play_int_battery_pick_up",
	smart_tag_target_type = "pickup",
	spawn_weighting = 1,
	unit_name = "content/pickups/luggables/battery_01/luggable_battery_01",
	unit_template_name = "pickup",
	projectile_template = ProjectileTemplates.luggable,
	spawn_offset = Vector3Box(0, 0, 0.4),
}

return pickup_data
