-- chunkname: @scripts/settings/liquid_area/liquid_area_templates/prop_liquid_area_templates.lua

local LiquidSpread = require("scripts/extension_systems/liquid_area/utilities/liquid_spread")
local templates = {
	prop_fire = {
		cell_size = 0.75,
		end_pressure = 10,
		in_liquid_buff_template_name = "prop_in_liquid_fire_burning_movement_slow",
		leaving_liquid_buff_template_name = "leaving_liquid_fire_spread_increase",
		life_time = 15,
		linearized_flow = false,
		max_liquid = 85,
		nav_cost_map_cost = 5,
		nav_cost_map_name = "fire",
		sfx_name_start = "wwise/events/weapon/play_aoe_liquid_fire_loop",
		sfx_name_stop = "wwise/events/weapon/stop_aoe_liquid_fire_loop",
		start_pressure = 40,
		vfx_name_filled = "content/fx/particles/liquid_area/fire_lingering",
		vfx_name_rim = "content/fx/particles/liquid_area/fire_lingering_edge",
		spread_function = LiquidSpread.pour,
	},
	prop_corruptor = {
		cell_size = 0.65,
		end_pressure = 5,
		in_liquid_buff_template_name = "prop_in_corruptor_liquid_corruption",
		life_time = 8,
		linearized_flow = true,
		max_liquid = 60,
		start_pressure = 15,
		vfx_name_filled = "content/fx/particles/liquid_area/corruptor_nurgle_goo",
		spread_function = LiquidSpread.pour,
	},
	prop_filtration_tank = {
		cell_size = 0.4,
		end_pressure = 5,
		in_liquid_buff_template_name = "prop_in_druglab_tank_goo",
		life_time = 32,
		linearized_flow = false,
		max_liquid = 40,
		spawn_brush_size = 1,
		start_pressure = 20,
		vfx_name_filled = "content/fx/particles/liquid_area/druglab_tank_goo",
		spread_function = LiquidSpread.pour,
	},
	prop_druglab_tank = {
		cell_size = 0.8,
		end_pressure = 10,
		in_liquid_buff_template_name = "prop_in_druglab_tank_goo",
		life_time = 32,
		linearized_flow = false,
		max_liquid = 75,
		spawn_brush_size = 1,
		start_pressure = 45,
		vfx_name_filled = "content/fx/particles/liquid_area/druglab_tank_goo",
		spread_function = LiquidSpread.pour,
	},
}

return templates
