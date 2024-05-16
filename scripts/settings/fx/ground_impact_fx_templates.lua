﻿-- chunkname: @scripts/settings/fx/ground_impact_fx_templates.lua

local templates = {}

templates.renegade_executor_cleave = {
	default = "concrete",
	evaluation_height_offset = 0.25,
	fx_source_name = "fx_impact_01",
	inventory_slot_name = "slot_melee_weapon",
	range = 1.5,
	materials = {
		default = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		brick = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		concrete = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_solid = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_sheet = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_catwalk = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		wood = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		glass = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_sand = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_gravel = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_soil = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_trash = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		vegetation = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		flesh = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		water = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_mud = {
			sfx = "wwise/events/weapon/play_traitor_guard_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
	},
}
templates.chaos_ogryn_executor_cleave = {
	default = "concrete",
	evaluation_height_offset = 0.25,
	fx_source_name = "fx_impact_01",
	inventory_slot_name = "slot_melee_weapon",
	range = 2,
	materials = {
		default = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		brick = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		concrete = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_solid = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_sheet = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_metal",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_catwalk = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_metal",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		wood = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		glass = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_sand = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_gravel = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_soil = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_trash = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		vegetation = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_debris",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		flesh = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		water = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_mud = {
			sfx = "wwise/events/weapon/play_chaos_ogryn_executor_ground_impact_wet",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
	},
}
templates.chaos_plague_ogryn_plague_stomp = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "j_leftfoot",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		brick = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		concrete = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_metal",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_metal",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		wood = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		glass = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_debris",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		flesh = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_wet",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		water = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_wet",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_stomp_wet",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
	},
}
templates.chaos_plague_ogryn_slam = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "j_lefthand",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		brick = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		concrete = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		wood = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		glass = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		flesh = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		water = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
	},
}
templates.chaos_plague_ogryn_combo_end = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "j_righthand",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		brick = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		concrete = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		wood = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		glass = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		flesh = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		water = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_claw_slam",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
	},
}
templates.renegade_captain_powermaul_melee_cleave = {
	default = "concrete",
	evaluation_height_offset = 0.25,
	fx_source_name = "fx_impact_01",
	inventory_slot_name = "slot_powermaul",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		brick = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		concrete = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_solid = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_sheet = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_catwalk = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		wood = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		glass = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_sand = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_gravel = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_soil = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_trash = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		vegetation = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		flesh = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		water = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_mud = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
	},
}
templates.renegade_captain_powermaul_melee_ground_slam = {
	default = "concrete",
	evaluation_height_offset = 0.25,
	fx_source_name = "fx_impact_01",
	inventory_slot_name = "slot_powermaul",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		brick = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		concrete = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_solid = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_sheet = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_catwalk = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		wood = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		glass = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_sand = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_gravel = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_soil = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_trash = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		vegetation = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		flesh = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		water = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_mud = {
			sfx = "wwise/events/weapon/play_captain_ground_impact_gen",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
	},
}
templates.beast_of_nurgle_tail_whip = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "j_tail_anim_05",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		brick = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		concrete = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		wood = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		glass = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		flesh = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		water = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
	},
}
templates.beast_of_nurgle_slam_right = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "j_righthand",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		brick = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		concrete = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		wood = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		glass = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		flesh = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		water = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
	},
}
templates.beast_of_nurgle_slam_left = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "j_lefthand",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		brick = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		concrete = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		wood = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		glass = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		flesh = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		water = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/impacts/generic_ground_impact_large_01",
		},
	},
}
templates.beast_of_nurgle_body_slam_aoe = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "root_point",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		brick = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		concrete = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		wood = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		glass = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		flesh = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		water = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_beast_of_nurgle_ground_impact",
			vfx = "content/fx/particles/enemies/beast_of_nurgle/bon_bodyslam_aoe",
		},
	},
}
templates.chaos_spawn_claw = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "j_righthand",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		brick = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		concrete = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		wood = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		glass = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		flesh = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		water = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_small_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
	},
}
templates.chaos_spawn_tentacle = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "j_leftfinger3_jnt",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		brick = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		concrete = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		wood = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		glass = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		flesh = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		water = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/weapons/hammer_ground_impact",
		},
	},
}
templates.chaos_spawn_leap = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "rp_base",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		brick = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		concrete = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		wood = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		glass = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		flesh = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		water = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/enemies/chaos_spawn/chaos_spawn_jump_landing",
		},
	},
}
templates.chaos_hound_leap_land = {
	default = "concrete",
	evaluation_height_offset = 1.5,
	fx_source_name = "root_point",
	range = 0.65,
	materials = {
		default = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		brick = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		concrete = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		metal_solid = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		metal_sheet = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		metal_catwalk = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		wood = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		glass = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		dirt_sand = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		dirt_gravel = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		dirt_soil = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		dirt_trash = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		vegetation = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		flesh = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		water = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
		dirt_mud = {
			sfx = "wwise/events/minions/play_chaos_spawn_ground_impact_large_default",
			vfx = "content/fx/particles/impacts/generic_dust_swirl_medium_01",
		},
	},
}

return templates
