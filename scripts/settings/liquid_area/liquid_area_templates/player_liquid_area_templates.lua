-- chunkname: @scripts/settings/liquid_area/liquid_area_templates/player_liquid_area_templates.lua

local LiquidSpread = require("scripts/extension_systems/liquid_area/utilities/liquid_spread")
local templates = {
	fire_grenade = {
		buff_target_side_relation = "enemy",
		cell_size = 0.75,
		end_pressure = 10,
		in_liquid_buff_template_name = "flame_grenade_liquid_area",
		leaving_liquid_buff_template_name = "fire_burninating",
		life_time = 15,
		linearized_flow = false,
		max_liquid = 150,
		nav_cost_map_cost = 5,
		nav_cost_map_name = "fire",
		sfx_name_start = "wwise/events/weapon/play_aoe_liquid_fire_loop",
		sfx_name_stop = "wwise/events/weapon/stop_aoe_liquid_fire_loop",
		start_pressure = 40,
		vfx_name_filled = "content/fx/particles/weapons/grenades/fire_grenade/fire_grenade_player_lingering_fire",
		vfx_name_rim = "content/fx/particles/liquid_area/fire_lingering_edge",
		spread_function = LiquidSpread.pour,
	},
}

return templates
