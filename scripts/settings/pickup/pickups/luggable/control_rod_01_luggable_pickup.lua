-- chunkname: @scripts/settings/pickup/pickups/luggable/control_rod_01_luggable_pickup.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local pickup_data = {
	description = "loc_pickup_luggable_control_rod_01",
	game_object_type = "pickup_projectile",
	group = "luggable",
	interaction_type = "luggable",
	inventory_item = "content/items/luggable/control_rod_01_luggable",
	look_at_tag = "luggable",
	name = "control_rod_01_luggable",
	pickup_sound = "wwise/events/world/play_int_battery_pick_up",
	smart_tag_target_type = "pickup",
	spawn_weighting = 1,
	unit_name = "content/pickups/luggables/control_rod_01/luggable_control_rod_01",
	unit_template_name = "pickup",
	projectile_template = ProjectileTemplates.luggable,
	spawn_offset = Vector3Box(0, 0, 0.4),
}

return pickup_data
