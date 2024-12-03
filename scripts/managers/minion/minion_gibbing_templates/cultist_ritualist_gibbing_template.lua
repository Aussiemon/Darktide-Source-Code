-- chunkname: @scripts/managers/minion/minion_gibbing_templates/cultist_ritualist_gibbing_template.lua

local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local SharedGibbingTemplates = require("scripts/managers/minion/minion_gibbing_templates/shared_gibbing_templates")
local gib_units = {
	head = {
		default = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_01/head_gib",
		face_02 = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_02/head_gib",
		face_03 = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_03/head_gib",
	},
	left_arm = {
		default = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_fullarm_gib",
		torso_02 = "content/characters/enemy/chaos_cultists/gibbing/base_b/left_fullarm_gib",
	},
	upper_left_arm = {
		default = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_arm_gib",
		torso_02 = "content/characters/enemy/chaos_cultists/gibbing/base_b/left_upper_arm_gib",
	},
	lower_left_arm = {
		default = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_lower_arm_gib",
		torso_02 = "content/characters/enemy/chaos_cultists/gibbing/base_b/left_lower_arm_gib",
	},
	right_arm = {
		default = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_fullarm_gib",
		torso_02 = "content/characters/enemy/chaos_cultists/gibbing/base_b/right_fullarm_gib",
	},
	upper_right_arm = {
		default = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_arm_gib",
		torso_02 = "content/characters/enemy/chaos_cultists/gibbing/base_b/right_upper_arm_gib",
	},
	lower_right_arm = {
		default = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_arm_gib",
		torso_02 = "content/characters/enemy/chaos_cultists/gibbing/base_b/right_lower_arm_gib",
	},
	torso_sever = {
		default = "content/characters/enemy/chaos_cultists/gibbing/base_a/torso_gib_full",
		torso_02 = "content/characters/enemy/chaos_cultists/gibbing/base_b/torso_gib_full",
	},
	torso_full = {
		default = "content/characters/enemy/chaos_cultists/gibbing/base_a/torso_gib",
		torso_02 = "content/characters/enemy/chaos_cultists/gibbing/base_b/torso_gib",
	},
}
local stump_units = {
	upper_left_arm = {
		default = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_arm_gib_cap",
		torso_02 = "content/characters/enemy/chaos_cultists/gibbing/base_b/left_upper_arm_gib_cap",
	},
	upper_right_arm = {
		default = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_arm_gib_cap",
		torso_02 = "content/characters/enemy/chaos_cultists/gibbing/base_b/right_upper_arm_gib_cap",
	},
}
local name = "cultist_ritualist"
local size = GibbingSettings.character_size.small
local gib_push_head = 35
local gib_push_upper_arm = 75
local gib_push_lower_arm = 75
local gib_push_arm = gib_push_upper_arm + gib_push_lower_arm
local gib_push_upper_leg = 350
local gib_push_lower_leg = 350
local gib_push_torso = 1350
local head_sever = table.clone(SharedGibbingTemplates.head)

head_sever.gib_settings.override_push_force = {
	gib_push_head,
	gib_push_head * 1.25,
}
head_sever.gib_settings.gib_unit = gib_units.head
head_sever.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_head_gib"
head_sever.gib_settings.gib_spawn_node = "j_neck"
head_sever.gib_settings.gib_actor = "rp_head_gib"
head_sever.gib_settings.attach_inventory_slots_to_gib = {
	"slot_head",
}
head_sever.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
head_sever.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_head_off
head_sever.gib_settings.sfx.node_name = "g_head_gib"
head_sever.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/head_gib_cap"
head_sever.stump_settings.stump_attach_node = "j_spine1"
head_sever.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
head_sever.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
head_sever.scale_node = "j_neck"
head_sever.gibbing_threshold = GibbingThresholds.always + size
head_sever.material_overrides = {
	"slot_head",
	"envrionmental_override",
	"skin_color_override",
}

local head_warp_channel = table.clone(head_sever)

head_warp_channel.gib_settings = nil
head_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
head_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump_head
head_warp_channel.gibbing_threshold = GibbingThresholds.always + size

local limb_segment = table.clone(SharedGibbingTemplates.limb_segment)

limb_segment.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
limb_segment.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_limb_off
limb_segment.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
limb_segment.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
limb_segment.gibbing_threshold = GibbingThresholds.light + size

local limb_full = table.clone(SharedGibbingTemplates.limb_full)

limb_full.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
limb_full.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_limb_off
limb_full.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
limb_full.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
limb_full.gibbing_threshold = SharedGibbingTemplates.limb_full.gibbing_threshold + size

local left_arm = table.clone(limb_full)

left_arm.gib_settings.override_push_force = {
	gib_push_arm,
	gib_push_arm * 1.25,
}
left_arm.gib_settings.gib_unit = gib_units.left_arm
left_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_entire_arm_gib"
left_arm.gib_settings.gib_spawn_node = "j_leftarm"
left_arm.gib_settings.gib_actor = "rp_left_fullarm_gib"
left_arm.stump_settings.stump_unit = stump_units.upper_left_arm
left_arm.stump_settings.stump_attach_node = "j_spine"
left_arm.scale_node = "j_leftarm"
left_arm.extra_hit_zone_actors_to_destroy = {
	"lower_left_arm",
}
left_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override",
}

local right_arm = table.clone(limb_full)

right_arm.gib_settings.override_push_force = {
	gib_push_arm,
	gib_push_arm * 1.25,
}
right_arm.gib_settings.gib_unit = gib_units.right_arm
right_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_entire_arm_gib"
right_arm.gib_settings.gib_spawn_node = "j_rightarm"
right_arm.gib_settings.gib_actor = "rp_right_fullarm_gib"
right_arm.stump_settings.stump_unit = stump_units.upper_right_arm
right_arm.stump_settings.stump_attach_node = "j_spine"
right_arm.scale_node = "j_rightarm"
right_arm.extra_hit_zone_actors_to_destroy = {
	"lower_right_arm",
}
right_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override",
}

local upper_left_arm = table.clone(limb_segment)

upper_left_arm.gib_settings.override_push_force = {
	gib_push_upper_arm,
	gib_push_upper_arm * 1.25,
}
upper_left_arm.gib_settings.gib_unit = gib_units.upper_left_arm
upper_left_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_upper_arm_gib"
upper_left_arm.gib_settings.gib_spawn_node = "j_leftarm"
upper_left_arm.gib_settings.gib_actor = "rp_left_upper_arm_gib"
upper_left_arm.gib_settings.vfx.node_name = upper_left_arm.gib_settings.gib_actor
upper_left_arm.gib_settings.sfx.node_name = "rp_left_upper_arm_gib"
upper_left_arm.stump_settings.stump_unit = stump_units.upper_left_arm
upper_left_arm.stump_settings.stump_attach_node = "j_spine"
upper_left_arm.scale_node = "j_leftarm"
upper_left_arm.condition = {
	already_gibbed = "lower_left_arm",
}
upper_left_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override",
}

local upper_right_arm = table.clone(limb_segment)

upper_right_arm.gib_settings.override_push_force = {
	gib_push_upper_arm,
	gib_push_upper_arm * 1.25,
}
upper_right_arm.gib_settings.gib_unit = gib_units.upper_right_arm
upper_right_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_upper_arm_gib"
upper_right_arm.gib_settings.gib_spawn_node = "j_rightarm"
upper_right_arm.gib_settings.gib_actor = "rp_right_upper_arm_gib"
upper_right_arm.gib_settings.vfx.node_name = upper_right_arm.gib_settings.gib_actor
upper_right_arm.gib_settings.sfx.node_name = "rp_right_upper_arm_gib"
upper_right_arm.stump_settings.stump_unit = stump_units.upper_right_arm
upper_right_arm.stump_settings.stump_attach_node = "j_spine"
upper_right_arm.scale_node = "j_rightarm"
upper_right_arm.condition = {
	already_gibbed = "lower_right_arm",
}
upper_right_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override",
}

local lower_left_arm = table.clone(limb_segment)

lower_left_arm.gib_settings.override_push_force = {
	gib_push_lower_arm,
	gib_push_lower_arm * 1.25,
}
lower_left_arm.gib_settings.gib_unit = gib_units.lower_left_arm
lower_left_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_lower_arm_gib"
lower_left_arm.gib_settings.gib_spawn_node = "j_leftforearm"
lower_left_arm.gib_settings.gib_actor = "rp_left_lower_arm_gib"
lower_left_arm.gib_settings.sfx.node_name = "g_left_lower_arm_gib"
lower_left_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/left_lower_arm_gib_cap"
lower_left_arm.stump_settings.stump_attach_node = "j_leftarm"
lower_left_arm.scale_node = "j_leftforearm"
lower_left_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override",
}

local lower_right_arm = table.clone(limb_segment)

lower_right_arm.gib_settings.override_push_force = {
	gib_push_lower_arm,
	gib_push_lower_arm * 1.25,
}
lower_right_arm.gib_settings.gib_unit = gib_units.lower_right_arm
lower_right_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_lower_arm_gib"
lower_right_arm.gib_settings.gib_spawn_node = "j_rightforearm"
lower_right_arm.gib_settings.gib_actor = "rp_right_lower_arm_gib"
lower_right_arm.gib_settings.sfx.node_name = "g_right_lower_arm_gib"
lower_right_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/right_lower_arm_gib_cap"
lower_right_arm.stump_settings.stump_attach_node = "j_rightarm"
lower_right_arm.scale_node = "j_rightforearm"
lower_right_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override",
}

local left_arm_warp_channel = table.clone(left_arm)

left_arm_warp_channel.gib_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_gib
left_arm_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
left_arm_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
left_arm_warp_channel.gibbing_threshold = GibbingThresholds.light
left_arm_warp_channel.extra_hit_zone_gibs = {
	"head",
}

local right_arm_warp_channel = table.clone(right_arm)

right_arm_warp_channel.gib_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_gib
right_arm_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
right_arm_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
right_arm_warp_channel.gibbing_threshold = GibbingThresholds.light
right_arm_warp_channel.extra_hit_zone_gibs = {
	"head",
}

local upper_left_arm_warp_channel = table.clone(upper_left_arm)

upper_left_arm_warp_channel.gib_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_gib
upper_left_arm_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
upper_left_arm_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
upper_left_arm_warp_channel.gibbing_threshold = GibbingThresholds.light + size
upper_left_arm_warp_channel.extra_hit_zone_gibs = {
	"head",
}

local upper_right_arm_warp_channel = table.clone(upper_right_arm)

upper_right_arm_warp_channel.gib_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_gib
upper_right_arm_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
upper_right_arm_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
upper_right_arm_warp_channel.gibbing_threshold = GibbingThresholds.light + size
upper_right_arm_warp_channel.extra_hit_zone_gibs = {
	"head",
}

local lower_left_arm_warp_channel = table.clone(lower_left_arm)

lower_left_arm_warp_channel.gib_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_gib
lower_left_arm_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
lower_left_arm_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
lower_left_arm_warp_channel.gibbing_threshold = GibbingThresholds.light + size
lower_left_arm_warp_channel.extra_hit_zone_gibs = {
	"head",
}

local lower_right_arm_warp_channel = table.clone(lower_right_arm)

lower_right_arm_warp_channel.gib_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_gib
lower_right_arm_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
lower_right_arm_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
lower_right_arm_warp_channel.gibbing_threshold = GibbingThresholds.light + size
lower_right_arm_warp_channel.extra_hit_zone_gibs = {
	"head",
}

local upper_left_leg = table.clone(limb_segment)

upper_left_leg.gib_settings.override_push_force = {
	gib_push_upper_leg,
	gib_push_upper_leg * 1.25,
}
upper_left_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_leg_gib"
upper_left_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_upper_leg_gib"
upper_left_leg.gib_settings.gib_spawn_node = "j_leftupleg"
upper_left_leg.gib_settings.gib_actor = "rp_left_upper_leg_gib"
upper_left_leg.gib_settings.vfx.node_name = upper_left_leg.gib_settings.gib_actor
upper_left_leg.gib_settings.sfx.node_name = "g_left_upper_leg_gib"
upper_left_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_leg_gib_cap"
upper_left_leg.stump_settings.stump_attach_node = "j_hips"
upper_left_leg.scale_node = "j_leftupleg"
upper_left_leg.condition = {
	already_gibbed = "lower_left_leg",
}
upper_left_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override",
	"skin_color_override",
}

local upper_right_leg = table.clone(limb_segment)

upper_right_leg.gib_settings.override_push_force = {
	gib_push_upper_leg,
	gib_push_upper_leg * 1.25,
}
upper_right_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_leg_gib"
upper_right_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_upper_leg_gib"
upper_right_leg.gib_settings.gib_spawn_node = "j_rightupleg"
upper_right_leg.gib_settings.gib_actor = "rp_right_upper_leg_gib"
upper_right_leg.gib_settings.vfx.node_name = upper_right_leg.gib_settings.gib_actor
upper_right_leg.gib_settings.sfx.node_name = "g_right_upper_leg_gib"
upper_right_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_leg_gib_cap"
upper_right_leg.stump_settings.stump_attach_node = "j_hips"
upper_right_leg.scale_node = "j_rightupleg"
upper_right_leg.condition = {
	already_gibbed = "lower_right_leg",
}
upper_right_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override",
	"skin_color_override",
}

local lower_left_leg = table.clone(limb_segment)

lower_left_leg.gib_settings.override_push_force = {
	gib_push_lower_leg,
	gib_push_lower_leg * 1.25,
}
lower_left_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_lower_leg_gib"
lower_left_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_lower_leg_gib"
lower_left_leg.gib_settings.gib_spawn_node = "j_leftleg"
lower_left_leg.gib_settings.gib_actor = "rp_left_lower_leg_gib"
lower_left_leg.gib_settings.vfx.node_name = lower_left_leg.gib_settings.gib_actor
lower_left_leg.gib_settings.sfx.node_name = "g_left_lower_leg_gib"
lower_left_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_lower_leg_gib_cap"
lower_left_leg.stump_settings.stump_attach_node = "j_leftupleg"
lower_left_leg.scale_node = "j_leftleg"
lower_left_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override",
	"skin_color_override",
}

local lower_right_leg = table.clone(limb_segment)

lower_right_leg.gib_settings.override_push_force = {
	gib_push_lower_leg,
	gib_push_lower_leg * 1.25,
}
lower_right_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_leg_gib"
lower_right_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_lower_leg_gib"
lower_right_leg.gib_settings.gib_spawn_node = "j_rightleg"
lower_right_leg.gib_settings.gib_actor = "rp_right_lower_leg_gib"
lower_right_leg.gib_settings.vfx.node_name = lower_right_leg.gib_settings.gib_actor
lower_right_leg.gib_settings.sfx.node_name = "rp_right_lower_leg_gib"
lower_right_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_leg_gib_cap"
lower_right_leg.stump_settings.stump_attach_node = "j_rightupleg"
lower_right_leg.scale_node = "j_rightleg"
lower_right_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override",
	"skin_color_override",
}

local upper_left_leg_warp_channel = table.clone(upper_left_leg)

upper_left_leg_warp_channel.gib_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_gib
upper_left_leg_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
upper_left_leg_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
upper_left_leg_warp_channel.gibbing_threshold = GibbingThresholds.light + size
upper_left_leg_warp_channel.extra_hit_zone_gibs = {
	"head",
}

local upper_right_leg_warp_channel = table.clone(upper_right_leg)

upper_right_leg_warp_channel.gib_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_gib
upper_right_leg_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
upper_right_leg_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
upper_right_leg_warp_channel.gibbing_threshold = GibbingThresholds.light + size
upper_right_leg_warp_channel.extra_hit_zone_gibs = {
	"head",
}

local lower_left_leg_warp_channel = table.clone(lower_left_leg)

lower_left_leg_warp_channel.gib_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_gib
lower_left_leg_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
lower_left_leg_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
lower_left_leg_warp_channel.gibbing_threshold = GibbingThresholds.light + size
lower_left_leg_warp_channel.extra_hit_zone_gibs = {
	"head",
}

local lower_right_leg_warp_channel = table.clone(lower_right_leg)

lower_right_leg_warp_channel.gib_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_gib
lower_right_leg_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
lower_right_leg_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
lower_right_leg_warp_channel.gibbing_threshold = GibbingThresholds.light + size
lower_right_leg_warp_channel.extra_hit_zone_gibs = {
	"head",
}

local torso_sever = table.clone(SharedGibbingTemplates.torso)

torso_sever.gib_settings.override_push_force = {
	gib_push_torso,
	gib_push_torso * 1.25,
}
torso_sever.gib_settings.gib_unit = gib_units.torso_sever
torso_sever.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib_full"
torso_sever.gib_settings.gib_spawn_node = "j_hips"
torso_sever.gib_settings.gib_actor = "rp_torso_gib_full"
torso_sever.gib_settings.attach_inventory_slots_to_gib = {
	"slot_head",
	"slot_face",
}
torso_sever.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
torso_sever.gib_settings.sfx = nil
torso_sever.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/upper_torso_gib_cap"
torso_sever.stump_settings.stump_attach_node = "j_hips"
torso_sever.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
torso_sever.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
torso_sever.scale_node = "j_spine1"
torso_sever.gibbing_threshold = GibbingThresholds.medium + size
torso_sever.extra_hit_zone_gibs = {
	"head",
}
torso_sever.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override",
}

local torso_full = table.clone(torso_sever)

torso_full.gib_settings.gib_unit = gib_units.torso_full
torso_full.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib"
torso_full.gib_settings.gib_actor = "rp_torso_gib"
torso_full.gib_settings.attach_inventory_slots_to_gib = {
	"",
}
torso_full.extra_hit_zone_gibs = {
	"head",
	"upper_right_arm",
	"upper_left_arm",
}
torso_full.material_overrides = {
	"slot_body",
	"slot_upperbody",
}

local center_mass_full = table.clone(torso_sever)

center_mass_full.gib_settings.gib_unit = gib_units.torso_full
center_mass_full.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib"
center_mass_full.gib_settings.gib_actor = "rp_torso_gib"
center_mass_full.gib_settings.attach_inventory_slots_to_gib = {
	"",
}
center_mass_full.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_splatter
center_mass_full.gibbing_threshold = GibbingThresholds.medium + size
center_mass_full.extra_hit_zone_gibs = SharedGibbingTemplates.center_mass.extra_hit_zone_gibs
center_mass_full.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override",
}

local center_mass_upper = table.clone(center_mass_full)

center_mass_upper.extra_hit_zone_gibs = {
	"head",
	"upper_right_arm",
	"upper_left_arm",
}

local center_mass_lower = table.clone(center_mass_full)

center_mass_lower.gib_settings = nil
center_mass_lower.scale_node = nil
center_mass_lower.extra_hit_zone_gibs = {
	"head",
	"upper_right_leg",
	"upper_left_leg",
}
center_mass_lower.prevents_other_gibs = {
	"center_mass",
	"torso",
}

local center_mass_left = table.clone(center_mass_full)

center_mass_left.gib_settings = left_arm.gib_settings
center_mass_left.stump_settings = left_arm.stump_settings
center_mass_left.scale_node = left_arm.scale_node
center_mass_left.extra_hit_zone_gibs = {
	"head",
	"upper_right_leg",
}
center_mass_left.extra_hit_zone_actors_to_destroy = {
	"upper_right_leg",
}

local center_mass_right = table.clone(center_mass_full)

center_mass_right.gib_settings = right_arm.gib_settings
center_mass_right.stump_settings = right_arm.stump_settings
center_mass_right.scale_node = right_arm.scale_node
center_mass_right.extra_hit_zone_gibs = {
	"head",
	"upper_left_leg",
}
center_mass_right.extra_hit_zone_actors_to_destroy = {
	"upper_left_leg",
}

local center_mass_full_warp_channel = table.clone(center_mass_full)

center_mass_full_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
center_mass_full_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
center_mass_full_warp_channel.gibbing_threshold = GibbingThresholds.medium + size

local center_mass_upper_warp_channel = table.clone(center_mass_upper)

center_mass_upper_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
center_mass_upper_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
center_mass_upper_warp_channel.gibbing_threshold = GibbingThresholds.medium + size

local center_mass_lower_warp_channel = table.clone(center_mass_lower)

center_mass_lower_warp_channel.gibbing_threshold = GibbingThresholds.medium + size

local center_mass_left_warp_channel = table.clone(center_mass_left)

center_mass_left_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
center_mass_left_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
center_mass_left_warp_channel.gibbing_threshold = GibbingThresholds.medium + size

local center_mass_right_warp_channel = table.clone(center_mass_right)

center_mass_right_warp_channel.stump_settings.vfx = SharedGibbingTemplates.vfx.ritualist_warp_stump
center_mass_right_warp_channel.stump_settings.sfx = SharedGibbingTemplates.sfx.ritualist_warp_stump
center_mass_right_warp_channel.gibbing_threshold = GibbingThresholds.medium + size

local gibbing_template = {
	forced_fallback_gibbing_hit_zone_name = "head",
	name = name,
	head = {
		default = head_warp_channel,
	},
	upper_left_arm = {
		default = {
			conditional = {
				upper_left_arm_warp_channel,
				left_arm_warp_channel,
			},
		},
	},
	upper_right_arm = {
		default = {
			conditional = {
				upper_right_arm_warp_channel,
				right_arm_warp_channel,
			},
		},
	},
	upper_left_leg = {
		default = upper_left_leg_warp_channel,
	},
	upper_right_leg = {
		default = upper_right_leg_warp_channel,
	},
	lower_left_arm = {
		default = {
			lower_left_arm_warp_channel,
		},
	},
	lower_right_arm = {
		default = {
			lower_right_arm_warp_channel,
		},
	},
	lower_left_leg = {
		default = {
			lower_left_leg_warp_channel,
		},
	},
	lower_right_leg = {
		default = {
			lower_right_leg_warp_channel,
		},
	},
	center_mass = {
		default = {
			center_mass_full_warp_channel,
			center_mass_upper_warp_channel,
			center_mass_lower_warp_channel,
			center_mass_left_warp_channel,
			center_mass_right_warp_channel,
		},
	},
}

return gibbing_template
