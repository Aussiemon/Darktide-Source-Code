-- chunkname: @scripts/managers/minion/minion_gibbing_templates/renegade_captain_gibbing_template.lua

local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local gibbing_template = {
	name = "renegade_captain_gibbing",
	head = {
		default = {
			gib_actor = "rp_head_gib",
			gib_spawn_node = "j_neck",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/head_gib",
			scale_node = "j_neck",
			sound_event = "wwise/events/weapon/play_combat_dismember_head_off",
			stump_attach_node = "j_spine1",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/head_gib_cap",
			unequip_inventory_slot = "slot_head",
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_head",
			},
		},
		crushing = {
			scale_node = "j_neck",
			sound_event = "wwise/events/weapon/play_combat_dismember_head_off",
			stump_attach_node = "j_spine1",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/head_gib_cap_crushed",
			unequip_inventory_slot = "slot_head",
			gibbing_threshold = GibbingThresholds.light,
			material_overrides = {
				"slot_head",
			},
		},
		sawing = {
			gib_actor = "rp_head_gib",
			gib_spawn_node = "j_neck",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/head_gib",
			scale_node = "j_neck",
			sound_event = "wwise/events/weapon/play_combat_dismember_head_off",
			stump_attach_node = "j_spine1",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/head_gib_cap_sawed",
			unequip_inventory_slot = "slot_head",
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_head",
			},
		},
	},
	upper_left_arm = {
		default = {
			conditional = {
				{
					gib_actor = "rp_left_upper_arm_gib",
					gib_spawn_node = "j_leftarm",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/captain/left_upper_arm_gib",
					scale_node = "j_leftarm",
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/left_upper_arm_gib_cap",
					gibbing_threshold = GibbingThresholds.medium,
					material_overrides = {
						"slot_upperbody",
					},
					condition = {
						already_gibbed = "lower_left_arm",
					},
				},
				{
					gib_actor = "rp_left_fullarm_gib",
					gib_spawn_node = "j_leftarm",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/captain/left_fullarm_gib",
					scale_node = "j_leftarm",
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/left_upper_arm_gib_cap",
					extra_hit_zone_actors_to_destroy = {
						"lower_left_arm",
					},
					gibbing_threshold = GibbingThresholds.medium,
					material_overrides = {
						"slot_upperbody",
					},
					condition = {
						always_true = true,
					},
				},
			},
		},
	},
	upper_right_arm = {
		default = {
			conditional = {
				{
					gib_actor = "rp_right_upper_arm_gib",
					gib_spawn_node = "j_rightarm",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/captain/right_upper_arm_gib",
					scale_node = "j_rightarm",
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/right_upper_arm_gib_cap",
					gibbing_threshold = GibbingThresholds.medium,
					material_overrides = {
						"slot_upperbody",
					},
					condition = {
						already_gibbed = "lower_right_arm",
					},
				},
				{
					gib_actor = "rp_right_fullarm_gib",
					gib_spawn_node = "j_rightarm",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/captain/right_fullarm_gib",
					scale_node = "j_rightarm",
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/right_upper_arm_gib_cap",
					gibbing_threshold = GibbingThresholds.medium,
					material_overrides = {
						"slot_upperbody",
					},
					extra_hit_zone_actors_to_destroy = {
						"lower_right_arm",
					},
					condition = {
						always_true = true,
					},
				},
			},
		},
	},
	upper_left_leg = {
		default = {
			conditional = {
				{
					gib_actor = "rp_left_upper_leg_gib",
					gib_spawn_node = "j_leftupleg",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/left_upper_leg_gib",
					scale_node = "j_leftupleg",
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/left_upper_leg_gib_cap",
					gibbing_threshold = GibbingThresholds.medium,
					material_overrides = {
						"slot_lowerbody",
					},
					condition = {
						already_gibbed = "lower_left_leg",
					},
				},
				{
					gib_actor = "rp_left_fullleg_gib",
					gib_spawn_node = "j_leftupleg",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/left_fullleg_gib",
					scale_node = "j_leftupleg",
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/left_upper_leg_gib_cap",
					gibbing_threshold = GibbingThresholds.medium,
					material_overrides = {
						"slot_lowerbody",
					},
					extra_hit_zone_actors_to_destroy = {
						"lower_left_leg",
					},
					condition = {
						always_true = true,
					},
				},
			},
		},
	},
	upper_right_leg = {
		default = {
			conditional = {
				{
					gib_actor = "rp_right_upper_leg_gib",
					gib_spawn_node = "j_rightupleg",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/right_upper_leg_gib",
					scale_node = "j_rightupleg",
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/right_upper_leg_gib_cap",
					gibbing_threshold = GibbingThresholds.medium,
					material_overrides = {
						"slot_lowerbody",
					},
					condition = {
						already_gibbed = "lower_right_leg",
					},
				},
				{
					gib_actor = "rp_right_fullleg_gib",
					gib_spawn_node = "j_rightupleg",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/right_fullleg_gib",
					scale_node = "j_rightupleg",
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/right_upper_leg_gib_cap",
					gibbing_threshold = GibbingThresholds.medium,
					extra_hit_zone_actors_to_destroy = {
						"lower_right_leg",
					},
					material_overrides = {
						"slot_lowerbody",
					},
					condition = {
						always_true = true,
					},
				},
			},
		},
	},
	lower_left_arm = {
		default = {
			gib_actor = "rp_left_lower_arm_gib",
			gib_spawn_node = "j_leftforearm",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/captain/left_lower_arm_gib",
			scale_node = "j_leftforearm",
			stump_attach_node = "j_leftarm",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/left_lower_arm_gib_cap",
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_upperbody",
			},
		},
	},
	lower_right_arm = {
		default = {
			gib_actor = "rp_right_lower_arm_gib",
			gib_spawn_node = "j_rightforearm",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/captain/right_lower_arm_gib",
			scale_node = "j_rightforearm",
			stump_attach_node = "j_spine1",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/right_lower_arm_gib_cap",
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_upperbody",
			},
		},
	},
	lower_left_leg = {
		default = {
			gib_actor = "rp_left_lower_leg_gib",
			gib_spawn_node = "j_leftleg",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/left_lower_leg_gib",
			scale_node = "j_leftleg",
			stump_attach_node = "j_leftupleg",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/left_lower_leg_gib_cap",
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_lowerbody",
			},
		},
	},
	lower_right_leg = {
		default = {
			gib_actor = "rp_right_lower_leg_gib",
			gib_spawn_node = "j_rightleg",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/right_lower_leg_gib",
			scale_node = "j_rightleg",
			stump_attach_node = "j_rightupleg",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/right_lower_leg_gib_cap",
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_lowerbody",
			},
		},
	},
	torso = {
		plasma = {
			gib_actor = "rp_upper_torso_gib",
			gib_spawn_node = "j_hips",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/captain/upper_torso_gib",
			scale_node = "j_spine1",
			stump_attach_node = "j_hips",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/uppertorso_gib_cap",
			gibbing_threshold = GibbingThresholds.heavy,
			material_overrides = {
				"slot_upperbody",
				"slot_variation_gear",
			},
			extra_hit_zone_gibs = {
				"head",
				"upper_left_arm",
				"upper_right_arm",
			},
			extra_hit_zone_gib_push_forces = {
				head = 0.001,
				upper_left_arm = 0.001,
				upper_right_arm = 0.001,
			},
			extra_hit_zone_actors_to_destroy = {
				"center_mass",
			},
		},
	},
	center_mass = {
		explosion = {
			extra_hit_zone_gibs = {
				"head",
				"upper_left_arm",
				"upper_right_arm",
				"upper_left_leg",
				"upper_right_leg",
			},
		},
		plasma = {
			gib_actor = "rp_upper_torso_gib",
			gib_spawn_node = "j_hips",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/captain/upper_torso_gib",
			scale_node = "j_spine1",
			stump_attach_node = "j_hips",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/uppertorso_gib_cap",
			gibbing_threshold = GibbingThresholds.heavy,
			material_overrides = {
				"slot_upperbody",
			},
			extra_hit_zone_gibs = {
				"head",
				"upper_left_arm",
				"upper_right_arm",
			},
			extra_hit_zone_gib_push_forces = {
				head = 0.001,
				upper_left_arm = 0.001,
				upper_right_arm = 0.001,
			},
			extra_hit_zone_actors_to_destroy = {
				"torso",
			},
		},
		sawing = {
			gib_actor = "rp_upper_torso_gib",
			gib_spawn_node = "j_hips",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/captain/upper_torso_gib",
			scale_node = "j_spine1",
			stump_attach_node = "j_hips",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/uppertorso_gib_cap",
			gibbing_threshold = GibbingThresholds.heavy,
			material_overrides = {
				"slot_upperbody",
				"slot_variation_gear",
			},
			extra_hit_zone_gibs = {
				"head",
				"upper_left_arm",
				"upper_right_arm",
			},
			extra_hit_zone_gib_push_forces = {
				head = 0.001,
				upper_left_arm = 0.001,
				upper_right_arm = 0.001,
			},
			extra_hit_zone_actors_to_destroy = {
				"torso",
			},
		},
	},
}

return gibbing_template
