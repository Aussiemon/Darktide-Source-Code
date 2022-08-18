local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local pickup_data = {
	description = "loc_luggable_reference_01",
	name = "luggable_reference_01",
	look_at_tag = "luggable",
	group = "luggable",
	interaction_type = "luggable",
	spawn_weighting = 1,
	game_object_type = "pickup_projectile",
	unit_name = "content/pickups/luggables/reference/luggable_reference_01",
	inventory_item = "content/items/luggable/luggable_reference_01",
	unit_template_name = "pickup",
	pickup_sound = "wwise/events/world/play_int_battery_pick_up",
	projectile_template = ProjectileTemplates.luggable,
	spawn_offset = Vector3Box(0, 0, 0.4)
}

return pickup_data
