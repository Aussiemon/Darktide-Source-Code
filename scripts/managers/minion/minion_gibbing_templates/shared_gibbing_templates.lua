-- chunkname: @scripts/managers/minion/minion_gibbing_templates/shared_gibbing_templates.lua

local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local shared_gibbing_templates = {}

shared_gibbing_templates.gib_push_overrides = {
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
}

local vfx_set = {
	warp_lightning = {
		"content/fx/particles/impacts/flesh/protectorate_chainlightning_gib_torso_small_01",
		"content/fx/particles/impacts/flesh/protectorate_chainlightning_gib_torso_small_02",
		"content/fx/particles/impacts/flesh/protectorate_chainlightning_gib_torso_small_03"
	},
	arc_small = {
		"content/fx/particles/impacts/flesh/gib_splatter_arc_lightning_01"
	},
	arc_large = {
		"content/fx/particles/impacts/flesh/arc_lightning_gib_torso_small_01",
		"content/fx/particles/impacts/flesh/arc_lightning_gib_torso_small_02",
		"content/fx/particles/impacts/flesh/arc_lightning_gib_torso_small_03"
	},
	phosphor = {
		"content/fx/particles/impacts/flesh/blood_gushing_01"
	}
}

shared_gibbing_templates.vfx = {}
shared_gibbing_templates.vfx.poxwalker_gushing = {
	particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_gushing_01"
}
shared_gibbing_templates.vfx.poxwalker_fountain = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/poxwalker_blood_fountain_head_01"
}
shared_gibbing_templates.vfx.blood_gushing = {
	particle_effect = "content/fx/particles/impacts/flesh/blood_gushing_01"
}
shared_gibbing_templates.vfx.blood_fountain = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01"
}
shared_gibbing_templates.vfx.warp_gib = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01"
}
shared_gibbing_templates.vfx.warp_stump = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01"
}
shared_gibbing_templates.vfx.warp_gib_lightning = {
	particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_protectorate_chainlightning_01"
}
shared_gibbing_templates.vfx.warp_stump_lightning = {
	linked = false,
	particle_effect = vfx_set.warp_lightning
}
shared_gibbing_templates.vfx.warp_gib_shard = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01"
}
shared_gibbing_templates.vfx.warp_stump_shard = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01"
}
shared_gibbing_templates.vfx.blood_splatter = {
	linked = false,
	particle_effect = "content/fx/particles/impacts/flesh/blood_splatter_gib_torso_small_01"
}
shared_gibbing_templates.vfx.poxwalker_splatter = {
	linked = false,
	particle_effect = "content/fx/particles/impacts/flesh/poxwalker_splatter_gib_torso_small_01"
}
shared_gibbing_templates.vfx.warp_wind_slash_large = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_force_01"
}
shared_gibbing_templates.vfx.ritualist_warp_gib = {
	particle_effect = "content/fx/particles/impacts/flesh/ritualist_warp_gib_02"
}
shared_gibbing_templates.vfx.ritualist_warp_stump_head = {
	particle_effect = "content/fx/particles/impacts/flesh/ritualist_warp_gib_02"
}
shared_gibbing_templates.vfx.ritualist_warp_stump = {
	node_name = "fx_blood",
	particle_effect = "content/fx/particles/impacts/flesh/ritualist_warp_gib_02"
}
shared_gibbing_templates.vfx.toxin_explosion_stump = {
	particle_effect = "content/fx/particles/impacts/flesh/blood_broker_toxin_fountain_head_01"
}
shared_gibbing_templates.vfx.toxin_gas_stump = {
	particle_effect = "content/fx/particles/impacts/flesh/gib_splatter_broker_toxin_01"
}
shared_gibbing_templates.vfx.arc_gib = {
	particle_effect = vfx_set.arc_small
}
shared_gibbing_templates.vfx.arc_stump_small = {
	linked = true,
	node_name = "fx_blood",
	particle_effect = vfx_set.arc_small
}
shared_gibbing_templates.vfx.arc_stump_large = {
	linked = false,
	node_name = "fx_blood",
	particle_effect = vfx_set.arc_large
}
shared_gibbing_templates.vfx.phosphor_gib = {
	particle_effect = vfx_set.phosphor
}
shared_gibbing_templates.vfx.phosphor_stump = {
	linked = true,
	node_name = "fx_blood",
	particle_effect = vfx_set.phosphor
}
shared_gibbing_templates.sfx = {}
shared_gibbing_templates.sfx.warp_gib_lightning = {
	sound_event = "wwise/events/weapon/play_psyker_lightning_bolt_impact_death"
}
shared_gibbing_templates.sfx.warp_stump_lightning = {
	sound_event = "wwise/events/weapon/play_psyker_lightning_bolt_impact_death"
}
shared_gibbing_templates.sfx.dismember_head_off = {
	sound_event = "wwise/events/weapon/play_combat_dismember_head_off"
}
shared_gibbing_templates.sfx.dismember_limb_off = {
	sound_event = "wwise/events/weapon/play_combat_dismember_limb_off"
}
shared_gibbing_templates.sfx.blood_fountain_neck = {
	sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
}
shared_gibbing_templates.sfx.root = "wwise/events/weapon/play_combat_dismember_full_body"
shared_gibbing_templates.sfx.warp_wind_slash_large = {
	sound_event = "wwise/events/weapon/play_melee_hits_forcesword_special_cleave"
}
shared_gibbing_templates.sfx.ritualist_warp_stump = {
	sound_event = "wwise/events/weapon/play_heresy_minion_ritualist_death_burst_body"
}
shared_gibbing_templates.sfx.ritualist_warp_stump_head = {
	sound_event = "wwise/events/weapon/play_heresy_minion_ritualist_death_burst_head"
}
shared_gibbing_templates.sfx.arc_gib = {
	sound_event = "wwise/events/weapon/play_psyker_lightning_bolt_impact_death"
}
shared_gibbing_templates.sfx.arc_stump = {
	sound_event = "wwise/events/weapon/play_psyker_lightning_bolt_impact_death"
}
shared_gibbing_templates.head = {
	extra_hit_zone_actors_to_destroy = nil,
	material_overrides = nil,
	scale_node = "",
	gib_settings = {
		gib_actor = "",
		gib_flesh_unit = "",
		gib_spawn_node = "",
		gib_unit = "",
		push_override = shared_gibbing_templates.gib_push_overrides.up_heavy,
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
shared_gibbing_templates.limb_segment = {
	extra_hit_zone_actors_to_destroy = nil,
	material_overrides = nil,
	scale_node = "",
	gib_settings = {
		gib_actor = "",
		gib_flesh_unit = "",
		gib_spawn_node = "",
		gib_unit = "",
		push_override = shared_gibbing_templates.gib_push_overrides.up_light,
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
shared_gibbing_templates.limb_full = {
	extra_hit_zone_actors_to_destroy = nil,
	material_overrides = nil,
	scale_node = "",
	gib_settings = {
		gib_actor = "",
		gib_flesh_unit = "",
		gib_spawn_node = "",
		gib_unit = "",
		push_override = shared_gibbing_templates.gib_push_overrides.up_light,
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
shared_gibbing_templates.torso = {
	extra_hit_zone_actors_to_destroy = nil,
	extra_hit_zone_gibs = nil,
	material_overrides = nil,
	scale_node = "",
	gib_settings = {
		gib_actor = "",
		gib_flesh_unit = "",
		gib_spawn_node = "",
		gib_unit = "",
		push_override = shared_gibbing_templates.gib_push_overrides.up_heavy,
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
	prevents_other_gibs = {
		"head",
		"center_mass",
		"torso"
	},
	root_sound_event = shared_gibbing_templates.sfx.root
}
shared_gibbing_templates.center_mass = {
	extra_hit_zone_actors_to_destroy = nil,
	material_overrides = nil,
	scale_node = "",
	gib_settings = {
		gib_actor = "",
		gib_flesh_unit = "",
		gib_spawn_node = "",
		gib_unit = "",
		push_override = shared_gibbing_templates.gib_push_overrides.up_medium,
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
	root_sound_event = shared_gibbing_templates.sfx.root
}

return settings("SharedGibbingTemplates", shared_gibbing_templates)
