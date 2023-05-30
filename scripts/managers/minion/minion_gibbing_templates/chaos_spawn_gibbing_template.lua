local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local SharedGibbingTemplates = require("scripts/managers/minion/minion_gibbing_templates/shared_gibbing_templates")
local name = "chaos_spawn"
local size = GibbingSettings.character_size.large
local gib_push_head = 1000
local gib_push_upper_arm = 500
local gib_push_lower_arm = 500
local gib_push_arm = gib_push_upper_arm + gib_push_lower_arm
local gib_push_upper_leg = 500
local gib_push_lower_leg = 500
local gib_push_leg = gib_push_upper_leg + gib_push_lower_leg
local head_sever = table.clone(SharedGibbingTemplates.head)
head_sever.gib_settings.override_push_force = {
	gib_push_head,
	gib_push_head * 1.25
}
head_sever.gib_settings.gib_unit = "content/characters/enemy/chaos_spawn/gibbing/head_gib"
head_sever.gib_settings.gib_flesh_unit = "content/characters/empty_item/empty_item"
head_sever.gib_settings.gib_spawn_node = "j_head"
head_sever.gib_settings.gib_actor = "rp_head_gib"
head_sever.gib_settings.attach_inventory_slots_to_gib = {
	""
}
head_sever.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
head_sever.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_head_off
head_sever.gib_settings.sfx.node_name = "g_head_gib"
head_sever.stump_settings.stump_unit = "content/characters/enemy/chaos_spawn/gibbing/head_gib_cap"
head_sever.stump_settings.stump_attach_node = "j_neck1"
head_sever.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
head_sever.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
head_sever.scale_node = "j_head"
head_sever.gibbing_threshold = SharedGibbingTemplates.head.gibbing_threshold + size
head_sever.material_overrides = {
	"envrionmental_override",
	"skin_color_override"
}
local head_full = table.clone(head_sever)
head_full.gib_settings = nil
local head_crush = table.clone(head_sever)
head_crush.gib_settings = nil
head_crush.stump_settings.stump_unit = "content/characters/enemy/chaos_spawn/gibbing/head_gib_cap"
head_crush.gibbing_threshold = GibbingThresholds.always + size
local head_warp = table.clone(head_sever)
head_warp.gib_settings = nil
head_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
head_warp.gibbing_threshold = GibbingThresholds.light
local limb_segment = table.clone(SharedGibbingTemplates.limb_segment)
limb_segment.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
limb_segment.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_limb_off
limb_segment.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
limb_segment.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
limb_segment.gibbing_threshold = SharedGibbingTemplates.limb_segment.gibbing_threshold + size
limb_segment.material_overrides = {
	"envrionmental_override",
	"skin_color_override"
}
local limb_full = table.clone(SharedGibbingTemplates.limb_full)
limb_full.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
limb_full.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_limb_off
limb_full.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
limb_full.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
limb_full.gibbing_threshold = SharedGibbingTemplates.limb_full.gibbing_threshold + size
limb_full.material_overrides = {
	"envrionmental_override",
	"skin_color_override"
}
local upper_left_arm = table.clone(limb_segment)
upper_left_arm.gib_settings.override_push_force = {
	gib_push_upper_arm,
	gib_push_upper_arm * 1.25
}
upper_left_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_spawn/gibbing/left_upperarm_gib"
upper_left_arm.gib_settings.gib_flesh_unit = "content/characters/empty_item/empty_item"
upper_left_arm.gib_settings.gib_spawn_node = "j_leftarm"
upper_left_arm.gib_settings.gib_actor = "rp_left_upperarm_gib"
upper_left_arm.gib_settings.vfx.node_name = upper_left_arm.gib_settings.gib_actor
upper_left_arm.gib_settings.sfx.node_name = "g_left_upperarm_gib"
upper_left_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_spawn/gibbing/left_upperarm_gib_cap"
upper_left_arm.stump_settings.stump_attach_node = "j_leftshoulder"
upper_left_arm.scale_node = "j_leftarm"
upper_left_arm.condition = {
	already_gibbed = "lower_left_arm"
}
local upper_left_arm_remove = table.clone(upper_left_arm)
upper_left_arm_remove.gib_settings = nil
local lower_left_arm = table.clone(limb_segment)
lower_left_arm.gib_settings.override_push_force = {
	gib_push_lower_arm,
	gib_push_lower_arm * 1.25
}
lower_left_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_spawn/gibbing/left_lowerarm_gib"
lower_left_arm.gib_settings.gib_flesh_unit = "content/characters/empty_item/empty_item"
lower_left_arm.gib_settings.gib_spawn_node = "j_leftforearm"
lower_left_arm.gib_settings.gib_actor = "rp_left_lowerarm_gib"
lower_left_arm.gib_settings.sfx.node_name = "g_left_lowerarm_gib"
lower_left_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_spawn/gibbing/left_lowerarm_gib_cap"
lower_left_arm.stump_settings.stump_attach_node = "j_leftarm"
lower_left_arm.scale_node = "j_leftforearm"
lower_left_arm.extra_hit_zone_actors_to_destroy = {
	"lower_left_arm"
}
local lower_right_arm = table.clone(limb_segment)
lower_right_arm.gib_settings.override_push_force = {
	gib_push_lower_arm,
	gib_push_lower_arm * 1.25
}
lower_right_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_spawn/gibbing/right_lowerarm_gib"
lower_right_arm.gib_settings.gib_flesh_unit = "content/characters/empty_item/empty_item"
lower_right_arm.gib_settings.gib_spawn_node = "j_rightforearm"
lower_right_arm.gib_settings.gib_actor = "rp_right_lowerarm_gib"
lower_right_arm.gib_settings.sfx.node_name = "g_right_lowerarm_gib"
lower_right_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_spawn/gibbing/right_lowerarm_gib_cap"
lower_right_arm.stump_settings.stump_attach_node = "j_rightarm"
lower_right_arm.scale_node = "j_rightforearm"
local lower_left_arm_remove = table.clone(lower_left_arm)
lower_left_arm_remove.gib_settings = nil
local lower_right_arm_remove = table.clone(lower_right_arm)
lower_right_arm_remove.gib_settings = nil
local left_arm = table.clone(limb_full)
left_arm.gib_settings.override_push_force = {
	gib_push_arm,
	gib_push_arm * 1.25
}
left_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_spawn/gibbing/left_fullarm_gib"
left_arm.gib_settings.gib_flesh_unit = "content/characters/empty_item/empty_item"
left_arm.gib_settings.gib_spawn_node = "j_leftarm"
left_arm.gib_settings.gib_actor = "rp_left_fullarm_gib"
left_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_spawn/gibbing/left_upperarm_gib_cap"
left_arm.stump_settings.stump_attach_node = "j_leftshoulder"
left_arm.scale_node = "j_leftarm"
left_arm.extra_hit_zone_actors_to_destroy = {
	"lower_left_arm"
}
local upper_left_arm_warp = table.clone(upper_left_arm)
upper_left_arm_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
upper_left_arm_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
upper_left_arm_warp.gibbing_threshold = GibbingThresholds.medium
local lower_left_arm_warp = table.clone(lower_left_arm)
lower_left_arm_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_left_arm_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
lower_left_arm_warp.gibbing_threshold = GibbingThresholds.medium
local lower_right_arm_warp = table.clone(lower_right_arm)
lower_right_arm_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_right_arm_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
lower_right_arm_warp.gibbing_threshold = GibbingThresholds.medium
local upper_left_leg = table.clone(limb_segment)
upper_left_leg.gib_settings.override_push_force = {
	gib_push_upper_leg,
	gib_push_upper_leg * 1.25
}
upper_left_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_spawn/gibbing/left_upperleg_gib"
upper_left_leg.gib_settings.gib_flesh_unit = "content/characters/empty_item/empty_item"
upper_left_leg.gib_settings.gib_spawn_node = "j_leftupleg"
upper_left_leg.gib_settings.gib_actor = "rp_left_upperleg_gib"
upper_left_leg.gib_settings.vfx.node_name = upper_left_leg.gib_settings.gib_actor
upper_left_leg.gib_settings.sfx.node_name = "g_left_upperleg_gib"
upper_left_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_spawn/gibbing/left_upperleg_gib_cap"
upper_left_leg.stump_settings.stump_attach_node = "j_hips"
upper_left_leg.scale_node = "j_leftupleg"
upper_left_leg.condition = {
	already_gibbed = "lower_left_leg"
}
local upper_left_leg_remove = table.clone(upper_left_leg)
upper_left_leg_remove.gib_settings = nil
local lower_left_leg = table.clone(limb_segment)
lower_left_leg.gib_settings.override_push_force = {
	gib_push_lower_leg,
	gib_push_lower_leg * 1.25
}
lower_left_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_spawn/gibbing/left_lowerleg_gib"
lower_left_leg.gib_settings.gib_flesh_unit = "content/characters/empty_item/empty_item"
lower_left_leg.gib_settings.gib_spawn_node = "j_leftleg"
lower_left_leg.gib_settings.gib_actor = "rp_left_lowerleg_gib"
lower_left_leg.gib_settings.vfx.node_name = lower_left_leg.gib_settings.gib_actor
lower_left_leg.gib_settings.sfx.node_name = "g_left_lowerleg_gib"
lower_left_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_spawn/gibbing/left_lowerleg_gib_cap"
lower_left_leg.stump_settings.stump_attach_node = "j_leftupleg"
lower_left_leg.scale_node = "j_leftleg"
local lower_right_leg = table.clone(limb_segment)
lower_right_leg.gib_settings.override_push_force = {
	gib_push_lower_leg,
	gib_push_lower_leg * 1.25
}
lower_right_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_spawn/gibbing/right_lowerleg_gib"
lower_right_leg.gib_settings.gib_flesh_unit = "content/characters/empty_item/empty_item"
lower_right_leg.gib_settings.gib_spawn_node = "j_rightleg"
lower_right_leg.gib_settings.gib_actor = "rp_right_lowerleg_gib"
lower_right_leg.gib_settings.vfx.node_name = lower_right_leg.gib_settings.gib_actor
lower_right_leg.gib_settings.sfx.node_name = "g_right_lowerleg_gib"
lower_right_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_spawn/gibbing/right_lowerleg_gib_cap"
lower_right_leg.stump_settings.stump_attach_node = "j_rightupleg"
lower_right_leg.scale_node = "j_rightleg"
local lower_left_leg_remove = table.clone(lower_left_leg)
lower_left_leg_remove.gib_settings = nil
local lower_right_leg_remove = table.clone(lower_right_leg)
lower_right_leg_remove.gib_settings = nil
local left_leg = table.clone(limb_full)
left_leg.gib_settings.override_push_force = {
	gib_push_leg,
	gib_push_leg * 1.25
}
left_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_spawn/gibbing/left_fullleg_gib"
left_leg.gib_settings.gib_flesh_unit = "content/characters/empty_item/empty_item"
left_leg.gib_settings.gib_spawn_node = "j_leftupleg"
left_leg.gib_settings.gib_actor = "rp_left_fullleg_gib"
left_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_spawn/gibbing/left_upperleg_gib_cap"
left_leg.stump_settings.stump_attach_node = "j_hips"
left_leg.scale_node = "j_leftupleg"
left_leg.extra_hit_zone_actors_to_destroy = {
	"lower_left_leg"
}
local upper_left_leg_warp = table.clone(upper_left_leg)
upper_left_leg_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
upper_left_leg_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
upper_left_leg_warp.gibbing_threshold = GibbingThresholds.medium
local lower_left_leg_warp = table.clone(lower_left_leg)
lower_left_leg_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_left_leg_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
lower_left_leg_warp.gibbing_threshold = GibbingThresholds.medium
local lower_right_leg_warp = table.clone(lower_right_leg)
lower_right_leg_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_right_leg_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
lower_right_leg_warp.gibbing_threshold = GibbingThresholds.medium
local gibbing_template = {
	name = name,
	head = {
		default = head_sever,
		ballistic = head_full,
		boltshell = head_full,
		crushing = head_crush,
		laser = head_full,
		sawing = head_sever,
		plasma = head_full,
		warp = head_warp
	},
	upper_left_arm = {
		default = {
			conditional = {
				upper_left_arm,
				left_arm
			}
		},
		ballistic = {
			conditional = {
				upper_left_arm_remove,
				left_arm
			}
		},
		boltshell = {
			conditional = {
				upper_left_arm_remove,
				left_arm
			}
		},
		plasma = {
			conditional = {
				upper_left_arm_remove,
				left_arm
			}
		},
		warp = upper_left_arm_warp
	},
	upper_left_leg = {
		default = {
			conditional = {
				upper_left_leg,
				left_leg
			}
		},
		ballistic = {
			conditional = {
				upper_left_leg_remove,
				left_leg
			}
		},
		boltshell = {
			conditional = {
				upper_left_leg_remove,
				left_leg
			}
		},
		plasma = {
			conditional = {
				upper_left_leg_remove,
				left_leg
			}
		},
		warp = upper_left_leg_warp
	},
	lower_left_arm = {
		default = lower_left_arm,
		ballistic = {
			lower_left_arm,
			lower_left_arm_remove
		},
		boltshell = {
			lower_left_arm,
			lower_left_arm_remove
		},
		plasma = lower_left_arm_remove,
		warp = lower_left_arm_warp
	},
	lower_right_arm = {
		default = lower_right_arm,
		ballistic = {
			lower_right_arm,
			lower_right_arm_remove
		},
		boltshell = {
			lower_right_arm,
			lower_right_arm_remove
		},
		plasma = lower_right_arm_remove,
		warp = lower_right_arm_warp
	},
	lower_left_leg = {
		default = lower_left_leg,
		ballistic = {
			lower_left_leg,
			lower_left_leg_remove
		},
		boltshell = {
			lower_left_leg,
			lower_left_leg_remove
		},
		plasma = lower_left_leg_remove,
		warp = lower_left_leg_warp
	},
	lower_right_leg = {
		default = lower_right_leg,
		ballistic = {
			lower_right_leg,
			lower_right_leg_remove
		},
		boltshell = {
			lower_right_leg,
			lower_right_leg_remove
		},
		plasma = lower_right_leg_remove,
		warp = lower_right_leg_warp
	}
}

return gibbing_template
