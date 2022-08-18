local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local gibbing_template = {
	name = "renegade",
	head = {
		default = {
			sound_event = "wwise/events/weapon/play_combat_dismember_head_off",
			gib_spawn_node = "j_neck",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/head_gib_cap",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/head_gib",
			gib_actor = "rp_head_gib",
			stump_attach_node = "j_spine1",
			unequip_inventory_slot = "slot_head",
			scale_node = "j_neck",
			gibbing_threshold = GibbingThresholds.medium
		},
		crushing = {
			sound_event = "wwise/events/weapon/play_combat_dismember_head_off",
			unequip_inventory_slot = "slot_head",
			stump_attach_node = "j_spine1",
			stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/head_gib_cap",
			scale_node = "j_neck",
			gibbing_threshold = GibbingThresholds.medium
		}
	},
	upper_left_arm = {
		default = {
			conditional = {
				{
					gib_actor = "g_left_upper_arm_gib",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_arm_gib_cap_01",
					gib_spawn_node = "j_leftarm",
					stump_attach_node = "j_spine1",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/left_upper_arm_flesh_gib_01",
					scale_node = "j_leftarm",
					gibbing_threshold = GibbingThresholds.medium,
					condition = {
						already_gibbed = "lower_left_arm"
					}
				},
				{
					gib_spawn_node = "j_leftarm",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/left_entire_arm_flesh_gib_01",
					gib_actor = "rp_left_entire_arm_flesh_gib_01",
					stump_attach_node = "j_spine1",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_arm_gib_cap_01",
					scale_node = "j_leftarm",
					extra_hit_zone_actors_to_destroy = {
						"lower_left_arm"
					},
					gibbing_threshold = GibbingThresholds.medium,
					condition = {
						always_true = true
					}
				}
			}
		}
	},
	upper_right_arm = {
		default = {
			conditional = {
				{
					gib_actor = "g_right_upper_arm_gib",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_arm_gib_cap_01",
					gib_spawn_node = "j_rightarm",
					stump_attach_node = "j_spine1",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/right_upper_arm_flesh_gib_01",
					scale_node = "j_rightarm",
					gibbing_threshold = GibbingThresholds.medium,
					condition = {
						already_gibbed = "lower_right_arm"
					}
				},
				{
					gib_spawn_node = "j_rightarm",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/right_entire_arm_flesh_gib_01",
					gib_actor = "rp_right_entire_arm_flesh_gib_01",
					stump_attach_node = "j_spine1",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_arm_gib_cap_01",
					scale_node = "j_rightarm",
					gibbing_threshold = GibbingThresholds.medium,
					extra_hit_zone_actors_to_destroy = {
						"lower_right_arm"
					},
					condition = {
						always_true = true
					}
				}
			}
		}
	},
	upper_left_leg = {
		default = {
			conditional = {
				{
					gib_actor = "g_left_upper_leg_gib",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_leg_gib_cap_01",
					gib_spawn_node = "j_leftupleg",
					stump_attach_node = "j_hips",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/left_upper_leg_flesh_gib_01",
					scale_node = "j_leftupleg",
					gibbing_threshold = GibbingThresholds.medium,
					condition = {
						already_gibbed = "lower_left_leg"
					}
				},
				{
					gib_spawn_node = "j_leftupleg",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/left_entire_leg_flesh_gib_01",
					gib_actor = "rp_left_entire_leg_flesh_gib_01",
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_leg_gib_cap_01",
					scale_node = "j_leftupleg",
					gibbing_threshold = GibbingThresholds.medium,
					extra_hit_zone_actors_to_destroy = {
						"lower_left_leg"
					},
					condition = {
						always_true = true
					}
				}
			}
		}
	},
	upper_right_leg = {
		default = {
			conditional = {
				{
					gib_actor = "g_right_upper_leg_gib",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_leg_gib_cap_01",
					gib_spawn_node = "j_rightupleg",
					stump_attach_node = "j_hips",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/right_upper_leg_flesh_gib_01",
					scale_node = "j_rightupleg",
					gibbing_threshold = GibbingThresholds.medium,
					condition = {
						already_gibbed = "lower_right_leg"
					}
				},
				{
					gib_spawn_node = "j_rightupleg",
					gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/right_entire_leg_flesh_gib_01",
					gib_actor = "rp_right_entire_leg_flesh_gib_01",
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_leg_gib_cap_01",
					scale_node = "j_rightupleg",
					gibbing_threshold = GibbingThresholds.medium,
					extra_hit_zone_actors_to_destroy = {
						"lower_right_leg"
					},
					condition = {
						always_true = true
					}
				}
			}
		}
	},
	lower_left_arm = {
		default = {
			gib_actor = "rp_left_lower_arm_flesh_gib_01",
			stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_lower_arm_gib_cap_01",
			gib_spawn_node = "j_leftforearm",
			stump_attach_node = "j_spine1",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/left_lower_arm_flesh_gib_01",
			scale_node = "j_leftforearm",
			gibbing_threshold = GibbingThresholds.medium
		}
	},
	lower_right_arm = {
		default = {
			gib_actor = "rp_right_lower_arm_flesh_gib_01",
			stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_lower_arm_gib_cap_01",
			gib_spawn_node = "j_rightforearm",
			stump_attach_node = "j_spine1",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/right_lower_arm_flesh_gib_01",
			scale_node = "j_rightforearm",
			gibbing_threshold = GibbingThresholds.medium
		}
	},
	lower_left_leg = {
		default = {
			gib_actor = "rp_left_lower_leg_flesh_gib_01",
			stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_lower_leg_gib_cap_01",
			gib_spawn_node = "j_leftleg",
			stump_attach_node = "j_hips",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/left_lower_leg_flesh_gib_01",
			scale_node = "j_leftleg",
			gibbing_threshold = GibbingThresholds.medium
		}
	},
	lower_right_leg = {
		default = {
			gib_actor = "rp_right_lower_leg_flesh_gib_01",
			stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_lower_leg_gib_cap_01",
			gib_spawn_node = "j_rightleg",
			stump_attach_node = "j_hips",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/right_lower_leg_flesh_gib_01",
			scale_node = "j_rightleg",
			gibbing_threshold = GibbingThresholds.medium
		}
	},
	torso = {
		plasma = {
			gib_actor = "rp_upper_torso_flesh_gib_01",
			gib_spawn_node = "j_hips",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/upper_torso_flesh_gib_01",
			scale_node = "j_spine1",
			gibbing_threshold = GibbingThresholds.heavy,
			extra_hit_zone_gibs = {
				"head",
				"upper_left_arm",
				"upper_right_arm"
			},
			extra_hit_zone_gib_push_forces = {
				head = 0.001,
				upper_right_arm = 0.001,
				upper_left_arm = 0.001
			},
			extra_hit_zone_actors_to_destroy = {
				"center_mass"
			}
		}
	},
	center_mass = {
		explosion = {
			extra_hit_zone_gibs = {
				"head",
				"upper_left_arm",
				"upper_right_arm",
				"upper_left_leg",
				"upper_right_leg"
			}
		},
		plasma = {
			gib_actor = "rp_upper_torso_flesh_gib_01",
			gib_spawn_node = "j_hips",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/upper_torso_flesh_gib_01",
			scale_node = "j_spine1",
			gibbing_threshold = GibbingThresholds.heavy,
			extra_hit_zone_gibs = {
				"head",
				"upper_left_arm",
				"upper_right_arm"
			},
			extra_hit_zone_gib_push_forces = {
				head = 0.001,
				upper_right_arm = 0.001,
				upper_left_arm = 0.001
			},
			extra_hit_zone_actors_to_destroy = {
				"torso"
			}
		},
		sawing = {
			gib_actor = "rp_upper_torso_flesh_gib_01",
			gib_spawn_node = "j_hips",
			gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/upper_torso_flesh_gib_01",
			scale_node = "j_spine1",
			gibbing_threshold = GibbingThresholds.heavy,
			extra_hit_zone_gibs = {
				"head",
				"upper_left_arm",
				"upper_right_arm"
			},
			extra_hit_zone_gib_push_forces = {
				head = 0.001,
				upper_right_arm = 0.001,
				upper_left_arm = 0.001
			},
			extra_hit_zone_actors_to_destroy = {
				"torso"
			}
		}
	}
}

return gibbing_template
