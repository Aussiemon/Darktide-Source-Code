local LiquidSpread = require("scripts/extension_systems/liquid_area/utilities/liquid_spread")
local templates = {
	fire_grenade = {
		vfx_name_rim = "content/fx/particles/liquid_area/fire_lingering_edge",
		end_pressure = 10,
		leaving_liquid_buff_template_name = "fire_burninating",
		buff_target_side_relation = "enemy",
		start_pressure = 40,
		max_liquid = 150,
		cell_size = 0.75,
		nav_cost_map_cost = 5,
		linearized_flow = false,
		life_time = 15,
		sfx_name_stop = "wwise/events/weapon/stop_aoe_liquid_fire_loop",
		vfx_name_filled = "content/fx/particles/weapons/grenades/fire_grenade/fire_grenade_player_lingering_fire",
		sfx_name_start = "wwise/events/weapon/play_aoe_liquid_fire_loop",
		in_liquid_buff_template_name = "flame_grenade_liquid_area",
		nav_cost_map_name = "fire",
		spread_function = LiquidSpread.pour
	}
}

return templates
