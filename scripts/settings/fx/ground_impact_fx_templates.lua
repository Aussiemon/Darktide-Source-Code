local templates = {
	renegade_executor_cleave = {
		default = "concrete",
		range = 1.5,
		fx_source_name = "fx_impact_01",
		evaluation_height_offset = 0.25,
		inventory_slot_name = "slot_melee_weapon",
		materials = {
			default = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			concrete = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_solid = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_sheet = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_catwalk = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			wood = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			glass = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_sand = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_gravel = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_soil = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_trash = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			vegetation = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			flesh = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			water = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_mud = {
				sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			}
		}
	},
	chaos_ogryn_executor_cleave = {
		default = "concrete",
		range = 2,
		fx_source_name = "fx_impact_01",
		evaluation_height_offset = 0.25,
		inventory_slot_name = "slot_melee_weapon",
		materials = {
			default = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			concrete = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_solid = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_sheet = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_metal",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_catwalk = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_metal",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			wood = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			glass = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_sand = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_gravel = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_soil = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_trash = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			vegetation = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			flesh = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			water = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_mud = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			}
		}
	},
	chaos_plague_ogryn_plague_stomp = {
		default = "concrete",
		range = 0.65,
		evaluation_height_offset = 1.5,
		fx_source_name = "j_leftfoot",
		materials = {
			default = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_default",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			concrete = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_default",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			metal_solid = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_default",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			metal_sheet = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_metal",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			metal_catwalk = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_metal",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			wood = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			glass = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			dirt_sand = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			dirt_gravel = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			dirt_soil = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			dirt_trash = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			vegetation = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			flesh = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_wet",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			water = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_wet",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			},
			dirt_mud = {
				sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_wet",
				vfx = "content/fx/particles/enemies/plague_ogryn/stomp"
			}
		}
	},
	chaos_plague_ogryn_slam = {
		default = "concrete",
		range = 0.65,
		evaluation_height_offset = 1.5,
		fx_source_name = "j_lefthand",
		materials = {
			default = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			concrete = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_solid = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_sheet = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_metal",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_catwalk = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_metal",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			wood = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			glass = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_sand = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_gravel = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_soil = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_trash = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			vegetation = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			flesh = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			water = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_mud = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			}
		}
	},
	renegade_captain_powermaul_melee_cleave = {
		default = "concrete",
		range = 0.65,
		fx_source_name = "fx_impact_01",
		evaluation_height_offset = 0.25,
		inventory_slot_name = "slot_powermaul",
		materials = {
			default = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			concrete = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_solid = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_sheet = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_metal",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_catwalk = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_metal",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			wood = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			glass = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_sand = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_gravel = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_soil = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_trash = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			vegetation = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			flesh = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			water = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_mud = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			}
		}
	},
	renegade_captain_powermaul_melee_ground_slam = {
		default = "concrete",
		range = 0.65,
		fx_source_name = "fx_impact_01",
		evaluation_height_offset = 0.25,
		inventory_slot_name = "slot_powermaul",
		materials = {
			default = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			concrete = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_solid = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_sheet = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_metal",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			metal_catwalk = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_metal",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			wood = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			glass = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_sand = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_gravel = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_soil = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_trash = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			vegetation = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			flesh = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			water = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			},
			dirt_mud = {
				sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
				vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact"
			}
		}
	}
}

return templates
