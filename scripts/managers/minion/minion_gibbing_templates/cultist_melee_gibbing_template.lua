local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local gibbing_template = {
	name = "cultist_melee",
	head = {
		default = {
			scale_node = "j_neck",
			gib_settings = {
				gib_actor = "rp_head_gib",
				gib_spawn_node = "j_neck",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_head_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_01/head_gib",
				attach_inventory_slots_to_gib = {
					"slot_head"
				},
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
				stump_attach_node = "j_spine1",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/head_gib_cap",
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
				"slot_head",
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
					gib_actor = "rp_head_gib",
					gib_spawn_node = "j_neck",
					gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_head_gib",
					gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_01/head_gib",
					attach_inventory_slots_to_gib = {
						"slot_head"
					},
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
					stump_attach_node = "j_spine1",
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/head_gib_cap",
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
				}
			},
			{
				scale_node = "j_neck",
				stump_settings = {
					stump_attach_node = "j_spine1",
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/head_gib_cap",
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
				}
			}
		},
		laser = {
			scale_node = "j_neck",
			stump_settings = {
				stump_attach_node = "j_spine1",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/head_gib_cap",
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
		crushing = {
			default = {
				unequip_inventory_slot = "slot_head",
				scale_node = "j_neck",
				stump_settings = {
					stump_attach_node = "j_spine1",
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/head_gib_cap_crushed",
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
					"slot_head"
				},
				prevents_other_gibs = {
					"torso",
					"center_mass"
				}
			}
		},
		sawing = {
			scale_node = "j_neck",
			gib_settings = {
				gib_actor = "rp_head_gib",
				gib_spawn_node = "j_neck",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_head_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_01/head_gib",
				attach_inventory_slots_to_gib = {
					"slot_head"
				},
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
				stump_attach_node = "j_spine1",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/head_gib_cap_sawed",
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
				"slot_head",
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
				stump_attach_node = "j_spine1",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/head_gib_cap",
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
				"slot_head",
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
						gib_actor = "rp_left_upper_arm_gib",
						gib_spawn_node = "j_leftarm",
						gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_upper_arm_gib",
						gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_upper_arm_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_left_upper_arm_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_spine",
						stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_upper_arm_gib_cap",
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
						"slot_upperbody",
						"envrionmental_override"
					},
					condition = {
						already_gibbed = "lower_left_arm"
					},
					prevents_other_gibs = {
						"torso",
						"center_mass"
					}
				},
				{
					scale_node = "j_leftarm",
					gib_settings = {
						gib_actor = "rp_left_fullarm_gib",
						gib_spawn_node = "j_leftarm",
						gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_entire_arm_gib",
						gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_fullarm_gib",
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
						stump_attach_node = "j_spine",
						stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_upper_arm_gib_cap",
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
						"slot_upperbody",
						"envrionmental_override"
					},
					condition = {
						always_true = true
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
				gib_actor = "rp_left_upper_arm_gib",
				gib_spawn_node = "j_leftarm",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_upper_arm_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_upper_arm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_upper_arm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_spine",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_upper_arm_gib_cap",
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
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_upperbody",
				"envrionmental_override"
			},
			condition = {
				already_gibbed = "lower_left_arm"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		}
	},
	upper_right_arm = {
		default = {
			default = {
				conditional = {
					{
						scale_node = "j_rightarm",
						gib_settings = {
							gib_actor = "rp_right_upper_arm_gib",
							gib_spawn_node = "j_rightarm",
							gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_upper_arm_gib",
							gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_upper_arm_gib",
							attach_inventory_slots_to_gib = {},
							vfx = {
								particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
								linked = true
							},
							sfx = {
								node_name = "g_right_upper_arm_gib",
								sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
							}
						},
						stump_settings = {
							stump_attach_node = "j_spine",
							stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_upper_arm_gib_cap",
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
							already_gibbed = "lower_right_arm"
						},
						material_overrides = {
							"slot_upperbody",
							"envrionmental_override"
						},
						prevents_other_gibs = {
							"torso",
							"center_mass"
						}
					},
					{
						scale_node = "j_rightarm",
						gib_settings = {
							gib_actor = "rp_right_fullarm_gib",
							gib_spawn_node = "j_rightarm",
							gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_entire_arm_gib",
							gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_fullarm_gib",
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
							stump_attach_node = "j_spine",
							stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_upper_arm_gib_cap",
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
							always_true = true
						},
						material_overrides = {
							"slot_upperbody",
							"envrionmental_override"
						},
						prevents_other_gibs = {
							"torso",
							"center_mass"
						}
					}
				}
			}
		},
		warp = {
			scale_node = "j_rightarm",
			gib_settings = {
				gib_actor = "rp_right_upper_arm_gib",
				gib_spawn_node = "j_rightarm",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_upper_arm_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_upper_arm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_upper_arm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_spine",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_upper_arm_gib_cap",
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
			gibbing_threshold = GibbingThresholds.medium,
			condition = {
				already_gibbed = "lower_right_arm"
			},
			material_overrides = {
				"slot_upperbody",
				"envrionmental_override"
			},
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
						gib_actor = "rp_left_upper_leg_gib",
						gib_spawn_node = "j_leftupleg",
						gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_upper_leg_gib",
						gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_leg_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_left_upper_leg_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_hips",
						stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_leg_gib_cap",
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
						already_gibbed = "lower_left_leg"
					},
					material_overrides = {
						"slot_lowerbody",
						"envrionmental_override"
					},
					prevents_other_gibs = {
						"torso",
						"center_mass"
					}
				},
				{
					scale_node = "j_leftupleg",
					gib_settings = {
						gib_actor = "rp_left_fullleg_gib",
						gib_spawn_node = "j_leftupleg",
						gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_entire_leg_gib",
						gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_fullleg_gib",
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
						stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_leg_gib_cap",
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
						always_true = true
					},
					material_overrides = {
						"slot_lowerbody",
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
			scale_node = "j_leftupleg",
			gib_settings = {
				gib_actor = "rp_left_upper_leg_gib",
				gib_spawn_node = "j_leftupleg",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_upper_leg_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_leg_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_upper_leg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_leg_gib_cap",
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
			gibbing_threshold = GibbingThresholds.medium,
			condition = {
				already_gibbed = "lower_left_leg"
			},
			material_overrides = {
				"slot_lowerbody",
				"envrionmental_override"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		}
	},
	upper_right_leg = {
		default = {
			conditional = {
				{
					scale_node = "j_rightupleg",
					gib_settings = {
						gib_actor = "rp_right_upper_leg_gib",
						gib_spawn_node = "j_rightupleg",
						gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_upper_leg_gib",
						gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_leg_gib",
						attach_inventory_slots_to_gib = {},
						vfx = {
							particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
							linked = true
						},
						sfx = {
							node_name = "g_right_upper_leg_gib",
							sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
						}
					},
					stump_settings = {
						stump_attach_node = "j_hips",
						stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_leg_gib_cap",
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
					},
					prevents_other_gibs = {
						"torso",
						"center_mass"
					}
				},
				{
					scale_node = "j_rightupleg",
					gib_settings = {
						gib_actor = "rp_right_fullleg_gib",
						gib_spawn_node = "j_rightupleg",
						gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_entire_leg_gib",
						gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_fullleg_gib",
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
						stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_leg_gib_cap",
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
						always_true = true
					},
					material_overrides = {
						"slot_lowerbody",
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
			scale_node = "j_rightupleg",
			gib_settings = {
				gib_actor = "rp_right_upper_leg_gib",
				gib_spawn_node = "j_rightupleg",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_upper_leg_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_leg_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_upper_leg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_leg_gib_cap",
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
			gibbing_threshold = GibbingThresholds.medium,
			condition = {
				already_gibbed = "lower_right_leg"
			},
			prevents_other_gibs = {
				"torso",
				"center_mass"
			}
		}
	},
	lower_left_arm = {
		default = {
			scale_node = "j_leftforearm",
			gib_settings = {
				gib_actor = "rp_left_lower_arm_gib",
				gib_spawn_node = "j_leftforearm",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_lower_arm_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_lower_arm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_lower_arm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftarm",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_lower_arm_gib_cap",
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
				"slot_lowerbody",
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
				gib_actor = "rp_left_lower_arm_gib",
				gib_spawn_node = "j_leftforearm",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_lower_arm_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_lower_arm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_lower_arm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftarm",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_lower_arm_gib_cap",
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
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_lowerbody",
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
				gib_actor = "rp_right_lower_arm_gib",
				gib_spawn_node = "j_rightforearm",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_lower_arm_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_lower_arm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_lower_arm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightarm",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_lower_arm_gib_cap",
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
				"slot_lowerbody",
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
				gib_actor = "rp_right_lower_arm_gib",
				gib_spawn_node = "j_rightforearm",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_lower_arm_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_lower_arm_gib",
				attach_inventory_slots_to_gib = {},
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_lower_arm_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightarm",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_lower_arm_gib_cap",
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
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_lowerbody",
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
				gib_actor = "rp_left_lower_leg_gib",
				gib_spawn_node = "j_leftleg",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_lower_leg_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_lower_leg_gib",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_lower_leg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftupleg",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_lower_leg_gib_cap",
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
				"slot_lowerbody",
				"envrionmental_override"
			}
		},
		warp = {
			scale_node = "j_leftleg",
			gib_settings = {
				gib_actor = "rp_left_lower_leg_gib",
				gib_spawn_node = "j_leftleg",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_lower_leg_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_lower_leg_gib",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_left_lower_leg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_leftupleg",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_lower_leg_gib_cap",
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
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_lowerbody",
				"envrionmental_override"
			}
		}
	},
	lower_right_leg = {
		default = {
			scale_node = "j_rightleg",
			gib_settings = {
				gib_actor = "rp_right_lower_leg_gib",
				gib_spawn_node = "j_rightleg",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_lower_leg_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_leg_gib",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_lower_leg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightupleg",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_leg_gib_cap",
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
				"slot_lowerbody",
				"envrionmental_override"
			}
		},
		warp = {
			scale_node = "j_rightleg",
			gib_settings = {
				gib_actor = "rp_right_lower_leg_gib",
				gib_spawn_node = "j_rightleg",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_lower_leg_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_leg_gib",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
					linked = true
				},
				sfx = {
					node_name = "g_right_lower_leg_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_rightupleg",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_leg_gib_cap",
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
			gibbing_threshold = GibbingThresholds.medium,
			material_overrides = {
				"slot_lowerbody",
				"envrionmental_override"
			}
		}
	},
	torso = {
		default = {
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_spawn_node = "j_hips",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_full",
				attach_inventory_slots_to_gib = {
					"slot_head",
					"slot_face"
				},
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
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
			extra_hit_zone_actors_to_destroy = {
				"center_mass"
			},
			material_overrides = {
				"slot_upperbody",
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
			root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib",
				gib_spawn_node = "j_spine1",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib",
				override_push_force = 25,
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_upper_torso_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
				head = 50,
				upper_right_arm = 0.1,
				upper_left_arm = 0.1
			},
			material_overrides = {
				"slot_body",
				"slot_upper_body"
			},
			prevents_other_gibs = {
				"upper_left_leg",
				"upper_right_leg",
				"lower_left_leg",
				"lower_right_leg"
			}
		},
		plasma = {
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_spawn_node = "j_hips",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_full",
				attach_inventory_slots_to_gib = {
					"slot_head",
					"slot_face"
				},
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
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
			extra_hit_zone_actors_to_destroy = {
				"center_mass"
			},
			material_overrides = {
				"slot_upperbody",
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
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				scale_node = "j_spine1",
				stump_settings = {
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
		sawing = {
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_spawn_node = "j_hips",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_full",
				attach_inventory_slots_to_gib = {
					"slot_head",
					"slot_face"
				},
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
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
				"slot_upperbody",
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
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_spawn_node = "j_hips",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_full",
				attach_inventory_slots_to_gib = {
					"slot_head",
					"slot_face"
				},
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
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
			extra_hit_zone_actors_to_destroy = {
				"center_mass"
			},
			material_overrides = {
				"slot_upperbody",
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
			root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib",
				gib_spawn_node = "j_spine1",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib",
				override_push_force = 25,
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
					linked = true
				},
				sfx = {
					node_name = "g_upper_torso_gib",
					sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
				}
			},
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
				"slot_upper_body"
			}
		},
		explosion = {
			{
				root_sound_event = "wwise/events/weapon/play_combat_dismember_full_body",
				scale_node = "j_spine1",
				gib_settings = {
					gib_actor = "rp_upper_torso_gib_full",
					gib_spawn_node = "j_hips",
					gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib_full",
					gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_full",
					attach_inventory_slots_to_gib = {
						"slot_head",
						"slot_face"
					},
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
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
					"slot_upperbody",
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
					gib_actor = "rp_upper_torso_gib",
					gib_spawn_node = "j_spine1",
					gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib",
					gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01",
						linked = true
					},
					sfx = {
						node_name = "g_upper_torso_gib",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
					"slot_upperbody",
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
					"slot_upperbody",
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
					gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_entire_arm_gib",
					gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_fullarm_gib",
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
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_upper_arm_gib_cap",
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
					"slot_upperbody",
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
					gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_entire_arm_gib",
					gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_fullarm_gib",
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
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_upper_arm_gib_cap",
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
					"slot_upperbody",
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
					gib_spawn_node = "j_hips",
					gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib_full",
					gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_full",
					attach_inventory_slots_to_gib = {
						"slot_head",
						"slot_face"
					},
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
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
					"slot_upperbody",
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
					gib_actor = "rp_upper_torso_gib",
					gib_spawn_node = "j_spine1",
					gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib",
					gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib",
					vfx = {
						particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01",
						linked = true
					},
					sfx = {
						node_name = "g_upper_torso_gib",
						sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
					}
				},
				stump_settings = {
					stump_attach_node = "j_hips",
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
					"slot_upperbody",
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
					"slot_upperbody",
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
					gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_entire_arm_gib",
					gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_fullarm_gib",
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
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_upper_arm_gib_cap",
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
					"slot_upperbody",
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
					gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_entire_arm_gib",
					gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_fullarm_gib",
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
					stump_attach_node = "j_spine",
					stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_upper_arm_gib_cap",
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
					"slot_upperbody",
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
			scale_node = "j_spine1",
			gib_settings = {
				gib_actor = "rp_upper_torso_gib_full",
				gib_spawn_node = "j_hips",
				gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib_full",
				gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_full",
				attach_inventory_slots_to_gib = {
					"slot_head",
					"slot_face"
				},
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
				stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap",
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
			extra_hit_zone_actors_to_destroy = {
				"torso"
			},
			material_overrides = {
				"slot_upperbody",
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
