local LiquidSpread = require("scripts/extension_systems/liquid_area/utilities/liquid_spread")
local templates = {
	fire_grenade = {
		vfx_name_rim = "content/fx/particles/liquid_area/fire_lingering_edge",
		end_pressure = 10,
		nav_cost_map_volume_uses_broadphase_radius = true,
		leaving_liquid_buff_template_name = "fire_burninating",
		start_pressure = 40,
		max_liquid = 125,
		cell_size = 0.75,
		nav_cost_map_cost = 5,
		linearized_flow = false,
		life_time = 8,
		sfx_name_stop = "wwise/events/weapon/stop_aoe_liquid_fire_loop",
		vfx_name_filled = "content/fx/particles/liquid_area/fire_lingering",
		sfx_name_start = "wwise/events/weapon/play_aoe_liquid_fire_loop",
		in_liquid_buff_template_name = "in_liquid_fire_burning_movement_slow",
		nav_cost_map_name = "fire",
		spread_function = LiquidSpread.pour
	}
}

return templates
