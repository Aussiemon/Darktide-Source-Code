-- chunkname: @scripts/settings/burning/burning_settings.lua

local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local ailment_effects = AilmentSettings.effects
local burning_settings = {}

burning_settings.buff_effects = {
	minions = {
		fire = {
			ailment_effect = ailment_effects.burning,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						orphaned_policy = "destroy",
						particle_effect = "content/fx/particles/enemies/buff_burning",
						stop_type = "stop",
					},
					sfx = {
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire",
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
					},
				},
			},
			stack_node_effects = {
				[6] = {
					{
						node_name = "j_spine",
						vfx = {
							orphaned_policy = "destroy",
							particle_effect = "content/fx/particles/enemies/buff_burning_stack_lvl02",
							stop_type = "stop",
						},
					},
				},
				[12] = {
					{
						node_name = "j_spine",
						vfx = {
							orphaned_policy = "destroy",
							particle_effect = "content/fx/particles/enemies/buff_burning_stack_lvl03",
							stop_type = "stop",
						},
					},
				},
				[18] = {
					{
						node_name = "j_spine",
						vfx = {
							material_emission = true,
							orphaned_policy = "destroy",
							particle_effect = "content/fx/particles/enemies/buff_burning_stack_lvl04",
							stop_type = "stop",
						},
					},
				},
			},
		},
		chemfire = {
			ailment_effect = ailment_effects.chem_burning,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						orphaned_policy = "destroy",
						particle_effect = "content/fx/particles/enemies/buff_burning_green",
						stop_type = "stop",
					},
					sfx = {
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire",
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
					},
				},
			},
		},
		warpfire = {
			ailment_effect = ailment_effects.warpfire,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						orphaned_policy = "destroy",
						particle_effect = "content/fx/particles/enemies/buff_warpfire",
						stop_type = "stop",
					},
					sfx = {
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire",
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
					},
				},
			},
		},
	},
}

return settings("BurningSettings", burning_settings)
