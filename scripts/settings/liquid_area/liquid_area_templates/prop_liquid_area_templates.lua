-- chunkname: @scripts/settings/liquid_area/liquid_area_templates/prop_liquid_area_templates.lua

local LiquidSpread = require("scripts/extension_systems/liquid_area/utilities/liquid_spread")
local templates = {
	prop_fire = {
		vfx_name_rim = "content/fx/particles/liquid_area/fire_lingering_edge",
		end_pressure = 10,
		leaving_liquid_buff_template_name = "leaving_liquid_fire_spread_increase",
		start_pressure = 40,
		sfx_name_stop = "wwise/events/weapon/stop_aoe_liquid_fire_loop",
		max_liquid = 85,
		cell_size = 0.75,
		nav_cost_map_cost = 5,
		linearized_flow = false,
		life_time = 15,
		vfx_name_filled = "content/fx/particles/liquid_area/fire_lingering",
		sfx_name_start = "wwise/events/weapon/play_aoe_liquid_fire_loop",
		in_liquid_buff_template_name = "prop_in_liquid_fire_burning_movement_slow",
		nav_cost_map_name = "fire",
		spread_function = LiquidSpread.pour
	},
	prop_corruptor = {
		start_pressure = 15,
		end_pressure = 5,
		max_liquid = 60,
		cell_size = 0.65,
		linearized_flow = true,
		life_time = 8,
		vfx_name_filled = "content/fx/particles/liquid_area/corruptor_nurgle_goo",
		in_liquid_buff_template_name = "prop_in_corruptor_liquid_corruption",
		spread_function = LiquidSpread.pour
	},
	prop_filtration_tank = {
		start_pressure = 20,
		end_pressure = 5,
		vfx_name_filled = "content/fx/particles/liquid_area/druglab_tank_goo",
		max_liquid = 40,
		cell_size = 0.4,
		linearized_flow = false,
		life_time = 32,
		spawn_brush_size = 1,
		in_liquid_buff_template_name = "prop_in_druglab_tank_goo",
		spread_function = LiquidSpread.pour
	},
	prop_druglab_tank = {
		start_pressure = 45,
		end_pressure = 10,
		vfx_name_filled = "content/fx/particles/liquid_area/druglab_tank_goo",
		max_liquid = 75,
		cell_size = 0.8,
		linearized_flow = false,
		life_time = 32,
		spawn_brush_size = 1,
		in_liquid_buff_template_name = "prop_in_druglab_tank_goo",
		spread_function = LiquidSpread.pour
	}
}

return templates
