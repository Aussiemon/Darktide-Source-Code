local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local gibbing_template = {
	name = "chaos_mutant_charger",
	head = {
		default = {
			scale_node = "j_head",
			gib_settings = {
				gib_actor = "rp_head_gib",
				gib_spawn_node = "j_head",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_head_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/head_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_head_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_neck",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/head_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
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
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		},
		ballistic = {
			{
				gibbing_threshold = GibbingThresholds.impossible,
				material_overrides = {
					"slot_head"
				},
				prevents_other_gibs = {
					"torso",
					"center_mass",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm"
				}
			}
		},
		laser = {
			{
				gibbing_threshold = GibbingThresholds.impossible,
				material_overrides = {
					"slot_head"
				},
				prevents_other_gibs = {
					"torso",
					"center_mass",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm"
				}
			}
		},
		sawing = {
			scale_node = "j_head",
			gib_settings = {
				gib_actor = "rp_head_gib",
				gib_spawn_node = "j_head",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_head_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/head_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_head_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_neck",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/head_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					node_name = "fx_blood",
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.heavy,
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		},
		crushing = {
			scale_node = "j_head",
			stump_settings = {
				stump_attach_node = "j_neck",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/head_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					node_name = "fx_blood",
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.light,
			prevents_other_gibs = {
				"torso",
				"center_mass"
			},
			material_overrides = {
				"envrionmental_override"
			}
		},
		warp = {
			scale_node = "j_head",
			stump_settings = {
				stump_attach_node = "j_neck",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/head_gib_cap",
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
			gibbing_threshold = GibbingThresholds.heavy,
			material_overrides = {
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
						gib_actor = "rp_left_upperarm_gib",
						gib_spawn_node = "j_leftarm",
						gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_upperarm_gib",
						gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upperarm_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_left_upperarm_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_spine2",
						stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upper_arm_gib_cap",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							node_name = "fx_blood",
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					gibbing_threshold = GibbingThresholds.medium,
					prevents_other_gibs = {
						"torso",
						"center_mass"
					},
					material_overrides = {
						"envrionmental_override"
					},
					condition = {
						already_gibbed = "lower_left_arm"
					}
				},
				{
					scale_node = "j_leftarm",
					gib_settings = {
						gib_actor = "rp_left_fullarm_gib",
						gib_spawn_node = "j_leftarm",
						gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_fullarm_gib",
						gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_fullarm_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_left_fullarm_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_spine2",
						stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upper_arm_gib_cap",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							node_name = "fx_blood",
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					gibbing_threshold = GibbingThresholds.medium,
					prevents_other_gibs = {
						"torso",
						"center_mass"
					},
					material_overrides = {
						"envrionmental_override"
					},
					condition = {
						always_true = true
					}
				}
			}
		},
		warp = {
			scale_node = "j_leftarm",
			gib_settings = {
				gib_actor = "rp_left_upperarm_gib",
				gib_spawn_node = "j_leftarm",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_upperarm_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upperarm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_upperarm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_spine2",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upper_arm_gib_cap",
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
			gibbing_threshold = GibbingThresholds.heavy,
			prevents_other_gibs = {
				"torso",
				"center_mass"
			},
			material_overrides = {
				"envrionmental_override"
			},
			condition = {
				already_gibbed = "lower_left_arm"
			}
		}
	},
	upper_right_arm = {
		default = {
			conditional = {
				{
					scale_node = "j_rightarm",
					gib_settings = {
						gib_actor = "rp_right_upperarm_gib",
						gib_spawn_node = "j_rightarm",
						gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_upperarm_gib",
						gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upperarm_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_right_upperarm_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_spine2",
						stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upper_arm_gib_cap",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							node_name = "fx_blood",
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					gibbing_threshold = GibbingThresholds.medium,
					prevents_other_gibs = {
						"torso",
						"center_mass"
					},
					condition = {
						already_gibbed = "lower_right_arm"
					}
				},
				{
					scale_node = "j_rightarm",
					gib_settings = {
						gib_actor = "rp_right_fullarm_gib",
						gib_spawn_node = "j_rightarm",
						gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_fullarm_gib",
						gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_fullarm_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_right_fullarm_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_spine2",
						stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upper_arm_gib_cap",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							node_name = "fx_blood",
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					gibbing_threshold = GibbingThresholds.medium,
					prevents_other_gibs = {
						"torso",
						"center_mass"
					},
					material_overrides = {
						"envrionmental_override"
					},
					condition = {
						always_true = true
					}
				}
			}
		},
		warp = {
			scale_node = "j_rightarm",
			gib_settings = {
				gib_actor = "rp_right_upperarm_gib",
				gib_spawn_node = "j_rightarm",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_upperarm_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upperarm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_upperarm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_spine2",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upper_arm_gib_cap",
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
			gibbing_threshold = GibbingThresholds.heavy,
			prevents_other_gibs = {
				"torso",
				"center_mass"
			},
			condition = {
				already_gibbed = "lower_right_arm"
			}
		}
	},
	upper_left_leg = {
		default = {
			conditional = {
				{
					scale_node = "j_leftupleg",
					gib_settings = {
						gib_actor = "rp_left_upperleg_gib",
						gib_spawn_node = "j_leftupleg",
						gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_upperleg_gib",
						gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upperleg_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_left_upperleg_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_hips",
						stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upper_leg_gib_cap",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
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
						"envrionmental_override"
					},
					condition = {
						already_gibbed = "lower_left_leg"
					}
				},
				{
					scale_node = "j_leftupleg",
					gib_settings = {
						gib_actor = "rp_left_fullleg_gib",
						gib_spawn_node = "j_leftupleg",
						gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_fullleg_gib",
						gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_fullleg_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_left_fullleg_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_hips",
						stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upper_leg_gib_cap",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
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
						"envrionmental_override"
					},
					condition = {
						always_true = true
					}
				}
			}
		},
		warp = {
			scale_node = "j_leftupleg",
			gib_settings = {
				gib_actor = "rp_left_upperleg_gib",
				gib_spawn_node = "j_leftupleg",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_upperleg_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upperleg_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_upperleg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upper_leg_gib_cap",
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
			gibbing_threshold = GibbingThresholds.heavy,
			material_overrides = {
				"envrionmental_override"
			},
			condition = {
				already_gibbed = "lower_left_leg"
			}
		}
	},
	upper_right_leg = {
		default = {
			conditional = {
				{
					scale_node = "j_rightupleg",
					gib_settings = {
						gib_actor = "rp_right_upperleg_gib",
						gib_spawn_node = "j_rightupleg",
						gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_upperleg_gib",
						gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upperleg_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_right_upperleg_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_hips",
						stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upper_leg_gib_cap",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
							linked = true,
							node_name = "fx_blood"
						},
						sfx = {
							node_name = "fx_blood",
							sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
						}
					},
					gibbing_threshold = GibbingThresholds.medium,
					condition = {
						already_gibbed = "lower_right_leg"
					}
				},
				{
					scale_node = "j_rightupleg",
					gib_settings = {
						gib_actor = "rp_right_fullleg_gib",
						gib_spawn_node = "j_rightupleg",
						gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_fullleg_gib",
						gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_fullleg_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_right_fullleg_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_hips",
						stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upper_leg_gib_cap",
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
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
						"envrionmental_override"
					},
					condition = {
						always_true = true
					}
				}
			}
		},
		warp = {
			scale_node = "j_rightupleg",
			gib_settings = {
				gib_actor = "rp_right_upperleg_gib",
				gib_spawn_node = "j_rightupleg",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_upperleg_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upperleg_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_upperleg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upper_leg_gib_cap",
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
			gibbing_threshold = GibbingThresholds.heavy,
			condition = {
				already_gibbed = "lower_right_leg"
			}
		}
	},
	lower_left_arm = {
		default = {
			scale_node = "j_leftforearm",
			gib_settings = {
				gib_actor = "rp_left_lowerarm_gib",
				gib_spawn_node = "j_leftforearm",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_lowerarm_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_lowerarm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_lowerarm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftarm",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_lower_arm_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
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
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		},
		warp = {
			scale_node = "j_leftforearm",
			gib_settings = {
				gib_actor = "rp_left_lowerarm_gib",
				gib_spawn_node = "j_leftforearm",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_lowerarm_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_lowerarm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_lowerarm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftarm",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_lower_arm_gib_cap",
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
			gibbing_threshold = GibbingThresholds.heavy,
			material_overrides = {
				"envrionmental_override"
			},
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
				gib_actor = "rp_right_lowerarm_gib",
				gib_spawn_node = "j_rightforearm",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_lowerarm_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_lowerarm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_lowerarm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightarm",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_lower_arm_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
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
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		},
		warp = {
			scale_node = "j_rightforearm",
			gib_settings = {
				gib_actor = "rp_right_lowerarm_gib",
				gib_spawn_node = "j_rightforearm",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_lowerarm_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_lowerarm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_lowerarm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightarm",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_lower_arm_gib_cap",
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
			gibbing_threshold = GibbingThresholds.heavy,
			material_overrides = {
				"envrionmental_override"
			},
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
				gib_actor = "rp_left_lowerleg_gib",
				gib_spawn_node = "j_leftleg",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_lowerleg_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_lowerleg_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_lowerleg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftupleg",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_lower_leg_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
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
				"envrionmental_override"
			}
		},
		warp = {
			scale_node = "j_leftleg",
			gib_settings = {
				gib_actor = "rp_left_lowerleg_gib",
				gib_spawn_node = "j_leftleg",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_lowerleg_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_lowerleg_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_lowerleg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftupleg",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_lower_leg_gib_cap",
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
			gibbing_threshold = GibbingThresholds.heavy,
			material_overrides = {
				"envrionmental_override"
			}
		}
	},
	lower_right_leg = {
		default = {
			scale_node = "j_rightleg",
			gib_settings = {
				gib_actor = "rp_right_lowerleg_gib",
				gib_spawn_node = "j_rightleg",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_lowerleg_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_lowerleg_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_lowerleg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightupleg",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_lower_leg_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
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
				"envrionmental_override"
			}
		},
		warp = {
			scale_node = "j_rightleg",
			gib_settings = {
				gib_actor = "rp_right_lowerleg_gib",
				gib_spawn_node = "j_rightleg",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_lowerleg_gib",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_lowerleg_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_lowerleg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightupleg",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_lower_leg_gib_cap",
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
			gibbing_threshold = GibbingThresholds.heavy,
			material_overrides = {
				"envrionmental_override"
			}
		}
	},
	torso = {
		default = {
			scale_node = "j_spine2",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_spawn_node = "j_spine2",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/upper_torso_gib_full",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_upper_torso_gib_full",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					node_name = "fx_blood",
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.heavy,
			extra_hit_zone_actors_to_destroy = {
				"center_mass"
			},
			material_overrides = {
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
				gibbing_threshold = GibbingThresholds.impossible,
				prevents_other_gibs = {
					"torso",
					"center_mass",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm"
				}
			}
		},
		plasma = {
			scale_node = "j_spine2",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_spawn_node = "j_spine2",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/upper_torso_gib_full",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_upper_torso_gib_full",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					node_name = "fx_blood",
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.heavy,
			extra_hit_zone_actors_to_destroy = {
				"center_mass"
			},
			material_overrides = {
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
		explosion = {
			{
				gibbing_threshold = GibbingThresholds.impossible,
				prevents_other_gibs = {
					"torso",
					"center_mass",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm"
				}
			}
		},
		sawing = {
			{
				gibbing_threshold = GibbingThresholds.impossible,
				prevents_other_gibs = {
					"torso",
					"center_mass",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm"
				}
			}
		},
		warp = {
			scale_node = "j_spine2",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_spawn_node = "j_spine2",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/upper_torso_gib_full",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_upper_torso_gib_full",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib_cap",
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
			gibbing_threshold = GibbingThresholds.impossible,
			extra_hit_zone_actors_to_destroy = {
				"center_mass"
			},
			material_overrides = {
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
				gibbing_threshold = GibbingThresholds.impossible,
				prevents_other_gibs = {
					"torso",
					"center_mass",
					"head",
					"upper_left_arm",
					"upper_right_arm",
					"lower_left_arm",
					"lower_right_arm"
				}
			}
		},
		explosion = {
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				scale_node = "j_spine2",
				gib_settings = {
					gib_actor = "rp_upper_torso_gib_full",
					gib_spawn_node = "j_spine2",
					gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_upper_torso_gib_full",
					gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/upper_torso_gib_full",
					attach_inventory_slots_to_gib = {},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
						linked = true
					},
					sfx = {
						node_name = "g_upper_torso_gib_full",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						node_name = "fx_blood",
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
				scale_node = "j_spine2",
				gib_settings = {
					gib_actor = "rp_uppertorso_gib",
					gib_spawn_node = "j_spine2",
					gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_uppertorso_gib",
					gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
						linked = true
					},
					sfx = {
						node_name = "g_uppertorso_gib",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						node_name = "fx_blood",
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
				scale_node = "j_leftarm",
				gib_settings = {
					gib_actor = "rp_left_fullarm_gib",
					gib_spawn_node = "j_leftarm",
					gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_fullarm_gib",
					gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_fullarm_gib",
					attach_inventory_slots_to_gib = {},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
						linked = true
					},
					sfx = {
						node_name = "g_left_fullarm_gib",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine2",
					stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upper_arm_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						node_name = "fx_blood",
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
					gib_actor = "rp_right_fullarm_gib",
					gib_spawn_node = "j_rightarm",
					gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_fullarm_gib",
					gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_fullarm_gib",
					attach_inventory_slots_to_gib = {},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
						linked = true
					},
					sfx = {
						node_name = "g_right_fullarm_gib",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine2",
					stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upper_arm_gib_cap",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
						linked = true,
						node_name = "fx_blood"
					},
					sfx = {
						node_name = "fx_blood",
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
				scale_node = "j_spine2",
				gib_settings = {
					gib_actor = "rp_upper_torso_gib_full",
					gib_spawn_node = "j_spine2",
					gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_upper_torso_gib_full",
					gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/upper_torso_gib_full",
					attach_inventory_slots_to_gib = {},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
						linked = true
					},
					sfx = {
						node_name = "g_upper_torso_gib_full",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib_cap",
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
				scale_node = "j_spine2",
				gib_settings = {
					gib_actor = "rp_uppertorso_gib",
					gib_spawn_node = "j_spine2",
					gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_uppertorso_gib",
					gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
						linked = true
					},
					sfx = {
						node_name = "g_uppertorso_gib",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib_cap",
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
				scale_node = "j_leftarm",
				gib_settings = {
					gib_actor = "rp_left_fullarm_gib",
					gib_spawn_node = "j_leftarm",
					gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_left_fullarm_gib",
					gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_fullarm_gib",
					attach_inventory_slots_to_gib = {},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
						linked = true
					},
					sfx = {
						node_name = "g_left_fullarm_gib",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine2",
					stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/left_upper_arm_gib_cap",
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
					gib_actor = "rp_right_fullarm_gib",
					gib_spawn_node = "j_rightarm",
					gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_right_fullarm_gib",
					gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_fullarm_gib",
					attach_inventory_slots_to_gib = {},
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
						linked = true
					},
					sfx = {
						node_name = "g_right_fullarm_gib",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_spine2",
					stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/right_upper_arm_gib_cap",
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
			scale_node = "j_spine2",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_spawn_node = "j_spine2",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/upper_torso_gib_full",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_upper_torso_gib_full",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					node_name = "fx_blood",
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
				"torso",
				"head",
				"upper_left_arm",
				"upper_right_arm",
				"lower_left_arm",
				"lower_right_arm"
			}
		},
		sawng = {
			scale_node = "j_spine2",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_spawn_node = "j_spine2",
				gib_flesh_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/flesh_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/upper_torso_gib_full",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_upper_torso_gib_full",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_mutant_charger/gibbing/uppertorso_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					node_name = "fx_blood",
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
