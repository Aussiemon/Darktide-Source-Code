-- chunkname: @scripts/settings/liquid_area/liquid_area_templates/debug_liquid_area_templates.lua

local debug_templates = {
	debug_paint = {
		additional_unit_vfx = "content/fx/particles/enemies/cultist_flamer/ground_flame_light",
		cell_size = 0.8,
		in_liquid_buff_template_name = "cultist_flamer_in_fire_liquid",
		leaving_liquid_buff_template_name = "leaving_liquid_fire_spread_increase",
		life_time = 9,
		max_liquid = 1,
		nav_cost_map_cost = 5,
		nav_cost_map_name = "fire",
		sfx_name_start = "wwise/events/weapon/play_aoe_liquid_fire_green_loop",
		sfx_name_stop = "wwise/events/weapon/stop_aoe_liquid_fire_green_loop",
		sfx_source_z_offset = 1,
		spawn_brush_size = 1,
		vfx_name_filled = "content/fx/particles/weapons/grenades/flame_grenade_hostile_fire_lingering_green",
	},
}

return debug_templates
