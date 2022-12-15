local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local SharedGibbingTemplates = {
	gib_push_overrides = {
		up_heavy = {
			custom_push_vector = {
				0,
				0,
				1
			}
		},
		up_medium = {
			custom_push_vector = {
				0,
				0,
				0.75
			}
		},
		up_light = {
			custom_push_vector = {
				0,
				0,
				0.5
			}
		}
	},
	vfx = {}
}
SharedGibbingTemplates.vfx.poxwalker_gushing = {
	particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_gushing_01"
}
SharedGibbingTemplates.vfx.poxwalker_fountain = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01"
}
SharedGibbingTemplates.vfx.blood_gushing = {
	particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01"
}
SharedGibbingTemplates.vfx.blood_fountain = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01"
}
SharedGibbingTemplates.vfx.warp_gib = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01"
}
SharedGibbingTemplates.vfx.warp_stump = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01"
}
SharedGibbingTemplates.vfx.blood_splatter = {
	particle_effect = "content/fx/particles/impacts/flesh/blood_splatter_gib_torso_small_01",
	linked = false
}
SharedGibbingTemplates.vfx.poxwalker_splatter = {
	particle_effect = "content/fx/particles/impacts/flesh/poxwalker_splatter_gib_torso_small_01",
	linked = false
}
SharedGibbingTemplates.sfx = {
	dismember_head_off = {
		sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
	},
	dismember_limb_off = {
		sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
	},
	blood_fountain_neck = {
		sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
	},
	root = "wwise/events/weapon/play_combat_dismember_full_body"
}
SharedGibbingTemplates.head = {
	scale_node = "",
	gib_settings = {
		gib_actor = "",
		gib_spawn_node = "",
		gib_flesh_unit = "",
		gib_unit = "",
		push_override = SharedGibbingTemplates.gib_push_overrides.up_heavy,
		attach_inventory_slots_to_gib = {},
		vfx = {
			node_name = "",
			particle_effect = ""
		},
		sfx = {
			node_name = "",
			sound_event = ""
		}
	},
	stump_settings = {
		stump_attach_node = "",
		stump_unit = "",
		vfx = {
			node_name = "",
			particle_effect = ""
		},
		sfx = {
			node_name = "",
			sound_event = ""
		}
	},
	gibbing_threshold = GibbingThresholds.light,
	prevents_other_gibs = {
		"center_mass",
		"torso"
	}
}
SharedGibbingTemplates.limb_segment = {
	scale_node = "",
	gib_settings = {
		gib_actor = "",
		gib_spawn_node = "",
		gib_flesh_unit = "",
		gib_unit = "",
		push_override = SharedGibbingTemplates.gib_push_overrides.up_light,
		attach_inventory_slots_to_gib = {},
		vfx = {
			node_name = "",
			particle_effect = ""
		},
		sfx = {
			node_name = "",
			sound_event = ""
		}
	},
	stump_settings = {
		stump_attach_node = "",
		stump_unit = "",
		vfx = {
			node_name = "",
			particle_effect = ""
		},
		sfx = {
			node_name = "",
			sound_event = ""
		}
	},
	gibbing_threshold = GibbingThresholds.light,
	condition = {
		already_gibbed = ""
	},
	prevents_other_gibs = {
		"center_mass",
		"torso"
	}
}
SharedGibbingTemplates.limb_full = {
	scale_node = "",
	gib_settings = {
		gib_actor = "",
		gib_spawn_node = "",
		gib_flesh_unit = "",
		gib_unit = "",
		push_override = SharedGibbingTemplates.gib_push_overrides.up_light,
		attach_inventory_slots_to_gib = {},
		vfx = {
			node_name = "",
			particle_effect = ""
		},
		sfx = {
			node_name = "",
			sound_event = ""
		}
	},
	stump_settings = {
		stump_attach_node = "",
		stump_unit = "",
		vfx = {
			node_name = "",
			particle_effect = ""
		},
		sfx = {
			node_name = "",
			sound_event = ""
		}
	},
	gibbing_threshold = GibbingThresholds.medium,
	condition = {
		always_true = true
	},
	prevents_other_gibs = {
		"center_mass",
		"torso"
	}
}
SharedGibbingTemplates.torso = {
	scale_node = "",
	gib_settings = {
		gib_actor = "",
		gib_spawn_node = "",
		gib_flesh_unit = "",
		gib_unit = "",
		push_override = SharedGibbingTemplates.gib_push_overrides.up_heavy,
		attach_inventory_slots_to_gib = {},
		vfx = {
			node_name = "",
			particle_effect = ""
		},
		sfx = {
			node_name = "",
			sound_event = ""
		}
	},
	stump_settings = {
		stump_attach_node = "",
		stump_unit = "",
		vfx = {
			node_name = "",
			particle_effect = ""
		},
		sfx = {
			node_name = "",
			sound_event = ""
		}
	},
	gibbing_threshold = GibbingThresholds.heavy,
	extra_hit_zone_gibs = {
		""
	},
	prevents_other_gibs = {
		"head",
		"center_mass",
		"torso"
	},
	root_sound_event = SharedGibbingTemplates.sfx.root
}
SharedGibbingTemplates.center_mass = {
	scale_node = "",
	gib_settings = {
		gib_actor = "",
		gib_spawn_node = "",
		gib_flesh_unit = "",
		gib_unit = "",
		push_override = SharedGibbingTemplates.gib_push_overrides.up_medium,
		attach_inventory_slots_to_gib = {},
		vfx = {
			node_name = "",
			particle_effect = ""
		},
		sfx = {
			node_name = "",
			sound_event = ""
		}
	},
	stump_settings = {
		stump_attach_node = "",
		stump_unit = "",
		vfx = {
			node_name = "",
			particle_effect = ""
		},
		sfx = {
			node_name = "",
			sound_event = ""
		}
	},
	gibbing_threshold = GibbingThresholds.heavy,
	extra_hit_zone_gibs = {
		"head",
		"upper_right_arm",
		"upper_left_arm",
		"upper_left_leg",
		"upper_right_leg"
	},
	prevents_other_gibs = {
		"center_mass",
		"torso"
	},
	root_sound_event = SharedGibbingTemplates.sfx.root
}

return settings("SharedGibbingTemplates", SharedGibbingTemplates)
