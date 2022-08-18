local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local gibbing_template = {
	name = "chaos_poxwalker",
	head = {
		default = {
			scale_node = "j_neck",
			gib_settings = {
				gib_actor = "rp_head_flesh_gib_01",
				gib_spawn_node = "j_neck",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_head_gib",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/head_flesh_gib_01",
				attach_inventory_slots_to_gib = {
					"slot_head"
				},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_head_flesh_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_spine2",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/head_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					node_name = "fx_blood",
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_body",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		},
		ballistic = {
			{
				scale_node = "j_neck",
				gib_settings = {
					gib_actor = "rp_head_flesh_gib_01",
					gib_spawn_node = "j_neck",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_head_gib",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/head_flesh_gib_01",
					attach_inventory_slots_to_gib = {
						"slot_head"
					},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_gushing_01",
						linked = true
					},
					sfx = {
						node_name = "g_head_flesh_gib",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine2",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/head_gib_cap_01",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						node_name = "fx_blood",
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				gibbing_threshold = GibbingThresholds.medium,
				material_overrides = {
					"slot_body",
					"envrionmental_override"
				},
				prevents_other_gibs = {
					"torso",
					"center_mass"
				}
			},
			{
				scale_node = "j_neck",
				stump_settings = {
					stump_attach_node = "j_spine2",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/head_gib_cap_01",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						node_name = "fx_blood",
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				gibbing_threshold = GibbingThresholds.medium,
				material_overrides = {
					"slot_body",
					"envrionmental_override"
				},
				prevents_other_gibs = {
					"torso",
					"center_mass"
				}
			}
		},
		crushing = {
			scale_node = "j_neck",
			stump_settings = {
				stump_attach_node = "j_spine2",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/head_gib_cap_crushed_01",
				attach_inventory_slots_to_gib = {
					"slot_head"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			gibbing_threshold = GibbingThresholds.light,
			material_overrides = {
				"slot_body",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		},
		laser = {
			scale_node = "j_neck",
			stump_settings = {
				stump_attach_node = "j_spine2",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/head_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_laser_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					node_name = "fx_blood",
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_body",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		},
		sawing = {
			scale_node = "j_neck",
			gib_settings = {
				gib_actor = "rp_head_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/head_flesh_gib_01",
				gib_spawn_node = "j_neck",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_head_gib",
				attach_inventory_slots_to_gib = {
					"slot_head"
				},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_head_flesh_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/head_gib_cap_sawed_01",
				stump_attach_node = "j_spine2"
			},
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_body",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		},
		warp = {
			scale_node = "j_neck",
			stump_settings = {
				stump_attach_node = "j_spine2",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/head_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					node_name = "fx_blood",
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.light,
			material_overrides = {
				"slot_body",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		}
	},
	upper_left_arm = {
		default = {
			conditional = {
				{
					scale_node = "j_leftarm",
					gib_settings = {
						gib_actor = "rp_left_upper_arm_flesh_gib_01",
						gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_arm_flesh_gib_01",
						gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_upper_arm_gib",
						gib_spawn_node = "j_leftarm",
						attach_inventory_slots_to_gib = {
							"slot_horn"
						},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true,
							node_name = "rp_left_upper_arm_flesh_gib_01"
						},
						sfx = {
							node_name = "g_left_upper_arm_flesh_gib_01",
							sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_leftshoulder",
						stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_arm_gib_cap_01",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					material_overrides = {
						"slot_body",
						"slot_upper_body",
						"envrionmental_override"
					},
					condition = {
						already_gibbed = "lower_left_arm"
					},
					gibbing_threshold = GibbingThresholds.medium,
					prevents_other_gibs = {
						"torso",
						"center_mass"
					}
				},
				{
					scale_node = "j_leftarm",
					gib_settings = {
						gib_actor = "rp_left_entire_arm_flesh_gib_01",
						gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_entire_arm_flesh_gib_01",
						gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_entire_arm_gib",
						gib_spawn_node = "j_leftarm"
					},
					stump_settings = {
						stump_attach_node = "j_leftshoulder",
						stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_arm_gib_cap_01",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					condition = {
						always_true = true
					},
					gibbing_threshold = GibbingThresholds.heavy,
					extra_hit_zone_actors_to_destroy = {
						"lower_left_arm"
					},
					material_overrides = {
						"slot_body",
						"slot_upper_body",
						"envrionmental_override"
					},
					prevents_other_gibs = {
						"torso",
						"center_mass"
					}
				}
			}
		},
		warp = {
			scale_node = "j_leftarm",
			gib_settings = {
				gib_actor = "rp_left_upper_arm_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_arm_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_upper_arm_gib",
				gib_spawn_node = "j_leftarm",
				attach_inventory_slots_to_gib = {
					"slot_horn"
				},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "rp_left_upper_arm_flesh_gib_01"
				},
				sfx = {
					node_name = "g_left_upper_arm_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftshoulder",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_arm_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			condition = {
				already_gibbed = "lower_left_arm"
			},
			gibbing_threshold = GibbingThresholds.medium,
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		}
	},
	upper_right_arm = {
		default = {
			conditional = {
				{
					scale_node = "j_rightarm",
					gib_settings = {
						gib_actor = "rp_right_upper_arm_flesh_gib_01",
						gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_arm_flesh_gib_01",
						gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_upper_arm_gib",
						gib_spawn_node = "j_rightarm",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true,
							node_name = "rp_right_upper_arm_flesh_gib_01"
						},
						sfx = {
							node_name = "g_right_upper_arm_flesh_gib_01",
							sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_rightshoulder",
						stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_arm_gib_cap_01",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					condition = {
						already_gibbed = "lower_right_arm"
					},
					material_overrides = {
						"slot_body",
						"slot_upper_body",
						"envrionmental_override"
					},
					gibbing_threshold = GibbingThresholds.medium,
					prevents_other_gibs = {
						"torso",
						"center_mass"
					}
				},
				{
					scale_node = "j_rightarm",
					gib_settings = {
						gib_actor = "rp_right_entire_arm_flesh_gib_01",
						gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_entire_arm_flesh_gib_01",
						gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_entire_arm_gib",
						gib_spawn_node = "j_rightarm"
					},
					stump_settings = {
						stump_attach_node = "j_rightshoulder",
						stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_arm_gib_cap_01",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					condition = {
						always_true = true
					},
					material_overrides = {
						"slot_body",
						"slot_upper_body",
						"envrionmental_override"
					},
					gibbing_threshold = GibbingThresholds.heavy,
					extra_hit_zone_actors_to_destroy = {
						"lower_right_arm"
					},
					prevents_other_gibs = {
						"torso",
						"center_mass"
					}
				}
			}
		},
		warp = {
			scale_node = "j_rightarm",
			gib_settings = {
				gib_actor = "rp_right_upper_arm_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_arm_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_upper_arm_gib",
				gib_spawn_node = "j_rightarm",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "rp_right_upper_arm_flesh_gib_01"
				},
				sfx = {
					node_name = "g_right_upper_arm_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightshoulder",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_arm_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			condition = {
				already_gibbed = "lower_right_arm"
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			gibbing_threshold = GibbingThresholds.medium,
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		}
	},
	upper_left_leg = {
		default = {
			conditional = {
				{
					scale_node = "j_leftupleg",
					gib_settings = {
						gib_actor = "rp_left_upper_leg_flesh_gib_01",
						gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_leg_flesh_gib_01",
						gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_upper_leg_gib",
						gib_spawn_node = "j_leftupleg",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true,
							node_name = "rp_left_upper_leg_flesh_gib_01"
						},
						sfx = {
							node_name = "g_left_upper_leg_flesh_gib_01",
							sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_hips",
						stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_leg_gib_cap_01",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					condition = {
						already_gibbed = "lower_left_leg"
					},
					material_overrides = {
						"slot_body",
						"slot_lower_body",
						"envrionmental_override"
					},
					gibbing_threshold = GibbingThresholds.medium
				},
				{
					scale_node = "j_leftupleg",
					gib_settings = {
						gib_actor = "rp_left_entire_leg_flesh_gib_01",
						gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_entire_leg_flesh_gib_01",
						gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_entire_leg_gib",
						gib_spawn_node = "j_leftupleg"
					},
					stump_settings = {
						stump_attach_node = "j_hips",
						stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_leg_gib_cap_01",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					extra_hit_zone_actors_to_destroy = {
						"lower_left_leg"
					},
					condition = {
						always_true = true
					},
					material_overrides = {
						"slot_body",
						"slot_lower_body",
						"envrionmental_override"
					},
					gibbing_threshold = GibbingThresholds.heavy
				}
			}
		},
		warp = {
			scale_node = "j_leftupleg",
			gib_settings = {
				gib_actor = "rp_left_upper_leg_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_leg_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_upper_leg_gib",
				gib_spawn_node = "j_leftupleg",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "rp_left_upper_leg_flesh_gib_01"
				},
				sfx = {
					node_name = "g_left_upper_leg_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_leg_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			condition = {
				already_gibbed = "lower_left_leg"
			},
			material_overrides = {
				"slot_body",
				"slot_lower_body",
				"envrionmental_override"
			},
			gibbing_threshold = GibbingThresholds.medium
		}
	},
	upper_right_leg = {
		default = {
			conditional = {
				{
					scale_node = "j_rightupleg",
					gib_settings = {
						gib_actor = "rp_right_upper_leg_flesh_gib_01",
						gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_leg_flesh_gib_01",
						gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_upper_leg_gib",
						gib_spawn_node = "j_rightupleg",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true,
							node_name = "j_rightleg"
						},
						sfx = {
							sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_hips",
						stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_leg_gib_cap_01",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					material_overrides = {
						"slot_body",
						"slot_lower_body",
						"envrionmental_override"
					},
					condition = {
						already_gibbed = "lower_right_leg"
					},
					gibbing_threshold = GibbingThresholds.medium
				},
				{
					scale_node = "j_rightupleg",
					gib_settings = {
						gib_actor = "rp_right_entire_leg_flesh_gib_01",
						gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_entire_leg_flesh_gib_01",
						gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_entire_leg_gib",
						gib_spawn_node = "j_rightupleg"
					},
					stump_settings = {
						stump_attach_node = "j_hips",
						stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_leg_gib_cap_01",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
						}
					},
					material_overrides = {
						"slot_body",
						"slot_lower_body",
						"envrionmental_override"
					},
					extra_hit_zone_actors_to_destroy = {
						"lower_right_leg"
					},
					condition = {
						always_true = true
					},
					gibbing_threshold = GibbingThresholds.heavy
				}
			}
		},
		warp = {
			scale_node = "j_rightupleg",
			gib_settings = {
				gib_actor = "rp_right_upper_leg_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_leg_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_upper_leg_gib",
				gib_spawn_node = "j_rightupleg",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "j_rightleg"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_leg_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			material_overrides = {
				"slot_body",
				"slot_lower_body",
				"envrionmental_override"
			},
			condition = {
				already_gibbed = "lower_right_leg"
			},
			gibbing_threshold = GibbingThresholds.medium
		}
	},
	lower_left_arm = {
		default = {
			scale_node = "j_leftforearm",
			gib_settings = {
				gib_actor = "rp_left_lower_arm_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_lower_arm_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_lower_arm_gib",
				gib_spawn_node = "j_leftforearm",
				sfx = {
					node_name = "g_left_lower_arm_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftarm",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_lower_arm_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			gibbing_threshold = GibbingThresholds.medium,
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		},
		warp = {
			scale_node = "j_leftforearm",
			gib_settings = {
				gib_actor = "rp_left_lower_arm_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_lower_arm_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_lower_arm_gib",
				gib_spawn_node = "j_leftforearm",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_lower_arm_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftarm",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_lower_arm_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			gibbing_threshold = GibbingThresholds.medium,
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		}
	},
	lower_right_arm = {
		default = {
			scale_node = "j_rightforearm",
			gib_settings = {
				gib_actor = "rp_right_lower_arm_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_lower_arm_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_lower_arm_gib",
				gib_spawn_node = "j_rightforearm",
				sfx = {
					node_name = "g_right_lower_arm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightarm",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_lower_arm_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			gibbing_threshold = GibbingThresholds.medium,
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		},
		warp = {
			scale_node = "j_rightforearm",
			gib_settings = {
				gib_actor = "rp_right_lower_arm_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_lower_arm_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_lower_arm_gib",
				gib_spawn_node = "j_rightforearm",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_lower_arm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightarm",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_lower_arm_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			gibbing_threshold = GibbingThresholds.medium,
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		}
	},
	lower_left_leg = {
		default = {
			scale_node = "j_leftleg",
			gib_settings = {
				gib_actor = "rp_left_lower_leg_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_lower_leg_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_lower_leg_gib",
				gib_spawn_node = "j_leftleg",
				sfx = {
					node_name = "g_left_lower_leg_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftupleg",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_lower_leg_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			material_overrides = {
				"slot_body",
				"slot_lower_body",
				"envrionmental_override"
			},
			gibbing_threshold = GibbingThresholds.medium
		},
		warp = {
			scale_node = "j_leftleg",
			gib_settings = {
				gib_actor = "rp_left_lower_leg_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_lower_leg_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_lower_leg_gib",
				gib_spawn_node = "j_leftleg",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_lower_leg_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftupleg",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_lower_leg_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			material_overrides = {
				"slot_body",
				"slot_lower_body",
				"envrionmental_override"
			},
			gibbing_threshold = GibbingThresholds.medium
		}
	},
	lower_right_leg = {
		default = {
			scale_node = "j_rightleg",
			gib_settings = {
				gib_actor = "rp_right_lower_leg_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_lower_leg_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_lower_leg_gib",
				gib_spawn_node = "j_rightleg",
				sfx = {
					node_name = "g_right_lower_leg_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightupleg",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_lower_leg_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			material_overrides = {
				"slot_body",
				"slot_lower_body",
				"envrionmental_override"
			},
			gibbing_threshold = GibbingThresholds.medium
		},
		warp = {
			scale_node = "j_rightleg",
			gib_settings = {
				gib_actor = "rp_right_lower_leg_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_lower_leg_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_lower_leg_gib",
				gib_spawn_node = "j_rightleg",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_lower_leg_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightupleg",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_lower_leg_gib_cap_01",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			material_overrides = {
				"slot_body",
				"slot_lower_body",
				"envrionmental_override"
			},
			gibbing_threshold = GibbingThresholds.medium
		}
	},
	torso = {
		default = {
			root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_full",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib_full",
				gib_spawn_node = "j_spine1",
				attach_inventory_slots_to_gib = {
					"slot_head",
					"slot_horn",
					"slot_upper_body_horn",
					"zone_decal"
				},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				}
			},
			stump_settings = {
				stump_attach_node = "j_spine",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.heavy,
			extra_hit_zone_actors_to_destroy = {
				"torso"
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"center_mass",
				"head",
				"upper_left_arm",
				"upper_right_arm",
				"lower_left_arm",
				"lower_right_arm"
			}
		},
		ballistic = {
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				scale_node = "j_spine1",
				gib_settings = {
					gib_actor = "rp_upper_torso_flesh_gib_01",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_flesh_gib_01",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib",
					gib_spawn_node = "j_spine1",
					override_push_force = 25,
					attach_inventory_slots_to_gib = {
						"slot_head",
						"slot_horn",
						"slot_upper_body_horn",
						"zone_decal"
					},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
						linked = true
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"head",
					"upper_right_arm",
					"upper_left_arm"
				},
				extra_hit_zone_gib_push_forces = {
					head = 50,
					upper_right_arm = 0.1,
					upper_left_arm = 0.1
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				prevents_other_gibs = {
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			}
		},
		explosion = {
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				scale_node = "j_spine1",
				stump_settings = {
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"head",
					"upper_right_arm",
					"upper_left_arm"
				},
				extra_hit_zone_gib_push_forces = {
					head = 0.1,
					upper_right_arm = 0.05,
					upper_left_arm = 0.05
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				prevents_other_gibs = {
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			}
		},
		plasma = {
			root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib",
				gib_spawn_node = "j_spine1",
				attach_inventory_slots_to_gib = {
					"slot_head",
					"slot_horn",
					"slot_upper_body_horn",
					"zone_decal"
				},
				sfx = {
					node_name = "g_upper_torso_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_spine",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
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
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"center_mass",
				"head",
				"upper_left_arm",
				"upper_right_arm",
				"lower_left_arm",
				"lower_right_arm"
			}
		},
		sawing = {
			root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_full",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib_full",
				gib_spawn_node = "j_spine1",
				attach_inventory_slots_to_gib = {
					"slot_head",
					"slot_horn",
					"slot_upper_body_horn",
					"zone_decal"
				}
			},
			stump_settings = {
				stump_attach_node = "j_spine",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.heavy,
			extra_hit_zone_actors_to_destroy = {
				"center_mass"
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"center_mass",
				"head",
				"upper_left_arm",
				"upper_right_arm",
				"lower_left_arm",
				"lower_right_arm"
			}
		},
		warp = {
			root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_full",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib_full",
				gib_spawn_node = "j_spine1",
				attach_inventory_slots_to_gib = {
					"slot_head",
					"slot_horn",
					"slot_upper_body_horn",
					"zone_decal"
				},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				}
			},
			stump_settings = {
				stump_attach_node = "j_spine",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.heavy,
			extra_hit_zone_actors_to_destroy = {
				"torso"
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"center_mass",
				"head",
				"upper_left_arm",
				"upper_right_arm",
				"lower_left_arm",
				"lower_right_arm"
			}
		}
	},
	center_mass = {
		ballistic = {
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				scale_node = "j_spine1",
				gib_settings = {
					gib_actor = "rp_upper_torso_flesh_gib_01",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_flesh_gib_01",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib",
					gib_spawn_node = "j_spine1",
					override_push_force = 5,
					attach_inventory_slots_to_gib = {
						"slot_head",
						"slot_horn",
						"slot_upper_body_horn",
						"zone_decal"
					},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
						linked = true
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"head",
					"upper_right_arm",
					"upper_left_arm",
					"upper_right_leg",
					"upper_left_leg"
				},
				extra_hit_zone_gib_push_forces = {
					head = 50,
					upper_right_arm = 0.1,
					upper_left_leg = 0.1,
					upper_left_arm = 0.1,
					upper_right_leg = 0.1
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				prevents_other_gibs = {
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			}
		},
		explosion = {
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				scale_node = "j_spine1",
				gib_settings = {
					gib_actor = "rp_upper_torso_gib_full",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_full",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib_full",
					gib_spawn_node = "j_spine1",
					attach_inventory_slots_to_gib = {
						"slot_head",
						"slot_horn",
						"slot_upper_body_horn",
						"zone_decal"
					},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
						linked = true
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gib_push_forces = {
					head = 1,
					upper_right_arm = 1,
					upper_left_arm = 1
				},
				extra_hit_zone_actors_to_destroy = {
					"torso"
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				prevents_other_gibs = {
					"torso",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm",
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			},
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				scale_node = "j_spine1",
				gib_settings = {
					gib_actor = "rp_upper_torso_flesh_gib_01",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_flesh_gib_01",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib",
					gib_spawn_node = "j_spine1",
					attach_inventory_slots_to_gib = {
						"slot_head",
						"slot_horn",
						"slot_upper_body_horn"
					},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
						linked = true
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"head",
					"upper_right_arm",
					"upper_left_arm"
				},
				extra_hit_zone_gib_push_forces = {
					head = 1,
					upper_right_arm = 1,
					upper_left_arm = 1
				},
				extra_hit_zone_actors_to_destroy = {
					"torso"
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				prevents_other_gibs = {
					"torso",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm",
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			},
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"upper_right_leg",
					"upper_left_leg"
				},
				extra_hit_zone_gib_push_forces = {
					upper_left_leg = 1,
					upper_right_leg = 1
				},
				prevents_other_gibs = {
					"torso",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm",
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			},
			{
				scale_node = "j_leftarm",
				gib_settings = {
					gib_actor = "rp_left_entire_arm_flesh_gib_01",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_entire_arm_flesh_gib_01",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_entire_arm_gib",
					gib_spawn_node = "j_leftarm"
				},
				stump_settings = {
					stump_attach_node = "j_leftshoulder",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_arm_gib_cap_01",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				condition = {
					already_gibbed = "lower_left_arm"
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"head",
					"upper_right_leg"
				},
				extra_hit_zone_gib_push_forces = {
					head = 1,
					upper_right_leg = 1
				},
				extra_hit_zone_actors_to_destroy = {
					"center_mass"
				},
				prevents_other_gibs = {
					"torso",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm",
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			},
			{
				scale_node = "j_rightarm",
				gib_settings = {
					gib_actor = "rp_right_entire_arm_flesh_gib_01",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_entire_arm_flesh_gib_01",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_entire_arm_gib",
					gib_spawn_node = "j_rightarm"
				},
				stump_settings = {
					stump_attach_node = "j_rightshoulder",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_arm_gib_cap_01",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				condition = {
					already_gibbed = "lower_right_arm"
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"head",
					"upper_left_leg"
				},
				extra_hit_zone_gib_push_forces = {
					head = 1,
					upper_right_leg = 1
				},
				extra_hit_zone_actors_to_destroy = {
					"center_mass"
				},
				prevents_other_gibs = {
					"torso",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm",
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			}
		},
		warp = {
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				scale_node = "j_spine1",
				gib_settings = {
					gib_actor = "rp_upper_torso_gib_full",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_full",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib_full",
					gib_spawn_node = "j_spine1",
					attach_inventory_slots_to_gib = {
						"slot_head",
						"slot_horn",
						"slot_upper_body_horn",
						"zone_decal"
					},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
						linked = true
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gib_push_forces = {
					head = 1,
					upper_right_arm = 1,
					upper_left_arm = 1
				},
				extra_hit_zone_actors_to_destroy = {
					"torso"
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				prevents_other_gibs = {
					"torso",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm",
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			},
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				scale_node = "j_spine1",
				gib_settings = {
					gib_actor = "rp_upper_torso_flesh_gib_01",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_flesh_gib_01",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib",
					gib_spawn_node = "j_spine1",
					attach_inventory_slots_to_gib = {
						"slot_head",
						"slot_horn",
						"slot_upper_body_horn"
					},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
						linked = true
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"head",
					"upper_right_arm",
					"upper_left_arm"
				},
				extra_hit_zone_gib_push_forces = {
					head = 1,
					upper_right_arm = 1,
					upper_left_arm = 1
				},
				extra_hit_zone_actors_to_destroy = {
					"torso"
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				prevents_other_gibs = {
					"torso",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm",
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			},
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"upper_right_leg",
					"upper_left_leg"
				},
				extra_hit_zone_gib_push_forces = {
					upper_left_leg = 1,
					upper_right_leg = 1
				},
				material_overrides = {
					"slot_body",
					"slot_lower_body",
					"envrionmental_override"
				},
				prevents_other_gibs = {
					"torso",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm",
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			},
			{
				scale_node = "j_leftarm",
				gib_settings = {
					gib_actor = "rp_left_entire_arm_flesh_gib_01",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_entire_arm_flesh_gib_01",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_left_entire_arm_gib",
					gib_spawn_node = "j_leftarm"
				},
				stump_settings = {
					stump_attach_node = "j_leftshoulder",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/left_upper_arm_gib_cap_01",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				condition = {
					already_gibbed = "lower_left_arm"
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"head",
					"upper_right_leg"
				},
				extra_hit_zone_gib_push_forces = {
					head = 1,
					upper_right_leg = 1
				},
				extra_hit_zone_actors_to_destroy = {
					"center_mass"
				},
				prevents_other_gibs = {
					"torso",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm",
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			},
			{
				scale_node = "j_rightarm",
				gib_settings = {
					gib_actor = "rp_right_entire_arm_flesh_gib_01",
					gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_entire_arm_flesh_gib_01",
					gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_right_entire_arm_gib",
					gib_spawn_node = "j_rightarm"
				},
				stump_settings = {
					stump_attach_node = "j_rightshoulder",
					stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/right_upper_arm_gib_cap_01",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
					}
				},
				material_overrides = {
					"slot_body",
					"slot_upper_body",
					"envrionmental_override"
				},
				condition = {
					already_gibbed = "lower_right_arm"
				},
				gibbing_threshold = GibbingThresholds.heavy,
				extra_hit_zone_gibs = {
					"head",
					"upper_left_leg"
				},
				extra_hit_zone_gib_push_forces = {
					head = 1,
					upper_right_leg = 1
				},
				extra_hit_zone_actors_to_destroy = {
					"center_mass"
				},
				prevents_other_gibs = {
					"torso",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm",
					"upper_left_leg",
					"upper_right_leg",
					"lower_left_leg",
					"lower_right_leg"
				}
			}
		},
		plasma = {
			root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_flesh_gib_01",
				gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_flesh_gib_01",
				gib_flesh_unit = "content/characters/enemy/chaos_poxwalker/gibbing/flesh_upper_torso_gib",
				gib_spawn_node = "j_spine1",
				attach_inventory_slots_to_gib = {
					"slot_head",
					"slot_horn",
					"slot_upper_body_horn",
					"zone_decal"
				},
				sfx = {
					node_name = "g_upper_torso_flesh_gib_01",
					sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_spine",
				stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
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
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"torso",
				"head",
				"upper_left_arm",
				"upper_right_arm",
				"lower_left_arm",
				"lower_right_arm"
			}
		}
	}
}

return gibbing_template
