-- chunkname: @scripts/settings/liquid_area/liquid_area_templates/minion_liquid_area_templates.lua

local LiquidSpread = require("scripts/extension_systems/liquid_area/utilities/liquid_spread")
local templates = {
	cultist_flamer_liquid_paint = {
		spawn_brush_size = 1,
		sfx_name_stop = "wwise/events/weapon/stop_aoe_liquid_fire_green_loop",
		sfx_source_z_offset = 0.5,
		additional_unit_vfx = "content/fx/particles/enemies/cultist_flamer/ground_flame_light",
		max_liquid = 1,
		cell_size = 0.8,
		leaving_liquid_buff_template_name = "cultist_flamer_leaving_liquid_fire_spread_increase",
		life_time = 11,
		vfx_name_filled = "content/fx/particles/weapons/grenades/flame_grenade_hostile_fire_lingering_green",
		sfx_name_start = "wwise/events/weapon/play_aoe_liquid_fire_green_loop",
		in_liquid_buff_template_name = "cultist_flamer_in_fire_liquid"
	},
	renegade_flamer_liquid_paint = {
		spawn_brush_size = 1,
		sfx_name_stop = "wwise/events/weapon/stop_aoe_liquid_fire_loop",
		sfx_source_z_offset = 0.5,
		additional_unit_vfx = "content/fx/particles/enemies/renegade_flamer/renegade_flamer_ground_flame_light",
		max_liquid = 1,
		cell_size = 0.8,
		leaving_liquid_buff_template_name = "renegade_flamer_leaving_liquid_fire_spread_increase",
		life_time = 11,
		vfx_name_filled = "content/fx/particles/enemies/renegade_flamer/renegade_flamer_fire_lingering",
		sfx_name_start = "wwise/events/weapon/play_aoe_liquid_fire_loop",
		in_liquid_buff_template_name = "renegade_flamer_in_fire_liquid"
	},
	beast_of_nurgle_slime = {
		vfx_name_filled = "content/fx/particles/liquid_area/beast_of_nurgle_slime",
		in_liquid_buff_template_name = "beast_of_nurgle_in_slime",
		ignore_bot_threat = true,
		max_liquid = 1,
		cell_size = 1,
		life_time = 20,
		spawn_brush_size = 1,
		sfx_name_start = "wwise/events/minions/play_beast_of_nurgle_vomit_aoe",
		sfx_name_stop = "wwise/events/minions/stop_beast_of_nurgle_vomit_aoe"
	},
	toxic_gas = {
		z_cell_size = 5,
		end_pressure = 30,
		forbidden_keyword = "in_toxic_gas",
		leaving_liquid_buff_template_name = "left_toxic_gas",
		sfx_name_stop = "wwise/events/weapon/stop_aoe_gas_loop",
		max_liquid = 250,
		cell_size = 1,
		disable_covers_within_radius = 3,
		linearized_flow = false,
		life_time = 99999,
		vfx_name_filled = "content/fx/particles/weapons/grenades/gas_grenade_gas",
		sfx_name_start = "wwise/events/weapon/play_aoe_gas_loop",
		in_liquid_buff_template_name = "in_toxic_gas",
		start_pressure = 40,
		spread_function = LiquidSpread.pour
	},
	renegade_grenadier_fire_grenade = {
		vfx_name_rim = "content/fx/particles/weapons/grenades/flame_grenade_hostile_fire_edge",
		end_pressure = 10,
		linearized_flow = false,
		start_pressure = 40,
		sfx_name_stop = "wwise/events/weapon/stop_aoe_liquid_fire_loop",
		max_liquid = 100,
		cell_size = 0.75,
		leaving_liquid_buff_template_name = "renegade_grenadier_leaving_liquid_fire_spread_increase",
		life_time = 8,
		vfx_name_filled = "content/fx/particles/weapons/grenades/flame_grenade_hostile_fire_lingering",
		sfx_name_start = "wwise/events/weapon/play_aoe_liquid_fire_loop",
		in_liquid_buff_template_name = "renegade_grenadier_in_fire_liquid",
		spread_function = LiquidSpread.pour
	}
}

return templates
