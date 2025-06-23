-- chunkname: @scripts/managers/minion/minion_gibbing_templates/cultist_assault_gibbing_template.lua

local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local SharedGibbingTemplates = require("scripts/managers/minion/minion_gibbing_templates/shared_gibbing_templates")
local gib_units = {
	head = {
		default = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_02/head_gib",
		face_03 = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_03/head_gib"
	}
}
local name = "cultist_assault"
local size = GibbingSettings.character_size.small
local gib_push_head = 35
local gib_push_upper_arm = 75
local gib_push_lower_arm = 75
local gib_push_arm = gib_push_upper_arm + gib_push_lower_arm
local gib_push_upper_leg = 350
local gib_push_lower_leg = 350
local gib_push_leg = gib_push_upper_leg + gib_push_lower_leg
local gib_push_torso = 6000
local head_sever = table.clone(SharedGibbingTemplates.head)

head_sever.gib_settings.override_push_force = {
	gib_push_head,
	gib_push_head * 1.25
}
head_sever.gib_settings.gib_unit = gib_units.head
head_sever.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_head_gib"
head_sever.gib_settings.gib_spawn_node = "j_neck"
head_sever.gib_settings.gib_actor = "rp_head_gib"
head_sever.gib_settings.attach_inventory_slots_to_gib = {
	"slot_head",
	"slot_beard"
}
head_sever.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
head_sever.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_head_off
head_sever.gib_settings.sfx.node_name = "g_head_gib"
head_sever.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/head_gib_cap"
head_sever.stump_settings.stump_attach_node = "j_spine1"
head_sever.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
head_sever.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
head_sever.scale_node = "j_neck"
head_sever.gibbing_threshold = SharedGibbingTemplates.head.gibbing_threshold + size
head_sever.material_overrides = {
	"slot_head",
	"slot_beard",
	"envrionmental_override",
	"skin_color_override"
}

local head_full = table.clone(head_sever)

head_full.gib_settings = nil

local head_crush = table.clone(head_sever)

head_crush.gib_settings = nil
head_crush.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/head_gib_cap_crushed"
head_crush.gibbing_threshold = GibbingThresholds.always + size

local head_warp = table.clone(head_sever)

head_warp.gib_settings = nil
head_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
head_warp.gibbing_threshold = GibbingThresholds.light

local head_warp_lightning = table.clone(head_warp)

head_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning

local head_warp_shard = table.clone(head_warp)

head_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_shard

local limb_segment = table.clone(SharedGibbingTemplates.limb_segment)

limb_segment.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
limb_segment.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_limb_off
limb_segment.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
limb_segment.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
limb_segment.gibbing_threshold = SharedGibbingTemplates.limb_segment.gibbing_threshold + size

local limb_full = table.clone(SharedGibbingTemplates.limb_full)

limb_full.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
limb_full.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_limb_off
limb_full.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
limb_full.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
limb_full.gibbing_threshold = SharedGibbingTemplates.limb_full.gibbing_threshold + size

local upper_left_arm = table.clone(limb_segment)

upper_left_arm.gib_settings.override_push_force = {
	gib_push_upper_arm,
	gib_push_upper_arm * 1.25
}
upper_left_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_arm_gib"
upper_left_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_upper_arm_gib"
upper_left_arm.gib_settings.gib_spawn_node = "j_leftarm"
upper_left_arm.gib_settings.gib_actor = "rp_left_upper_arm_gib"
upper_left_arm.gib_settings.vfx.node_name = upper_left_arm.gib_settings.gib_actor
upper_left_arm.gib_settings.sfx.node_name = "g_left_upper_arm_gib"
upper_left_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_arm_gib_cap"
upper_left_arm.stump_settings.stump_attach_node = "j_spine"
upper_left_arm.scale_node = "j_leftarm"
upper_left_arm.condition = {
	already_gibbed = "lower_left_arm"
}
upper_left_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override"
}

local upper_right_arm = table.clone(limb_segment)

upper_right_arm.gib_settings.override_push_force = {
	gib_push_upper_arm,
	gib_push_upper_arm * 1.25
}
upper_right_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_arm_gib"
upper_right_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_upper_arm_gib"
upper_right_arm.gib_settings.gib_spawn_node = "j_rightarm"
upper_right_arm.gib_settings.gib_actor = "rp_right_upper_arm_gib"
upper_right_arm.gib_settings.vfx.node_name = upper_right_arm.gib_settings.gib_actor
upper_right_arm.gib_settings.sfx.node_name = "g_right_upper_arm_gib"
upper_right_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_arm_gib_cap"
upper_right_arm.stump_settings.stump_attach_node = "j_spine"
upper_right_arm.scale_node = "j_rightarm"
upper_right_arm.condition = {
	already_gibbed = "lower_right_arm"
}
upper_right_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override"
}

local upper_left_arm_remove = table.clone(upper_left_arm)

upper_left_arm_remove.gib_settings = nil

local upper_right_arm_remove = table.clone(upper_right_arm)

upper_right_arm_remove.gib_settings = nil

local lower_left_arm = table.clone(limb_segment)

lower_left_arm.gib_settings.override_push_force = {
	gib_push_lower_arm,
	gib_push_lower_arm * 1.25
}
lower_left_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_lower_arm_gib"
lower_left_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_lower_arm_gib"
lower_left_arm.gib_settings.gib_spawn_node = "j_leftforearm"
lower_left_arm.gib_settings.gib_actor = "rp_left_lower_arm_gib"
lower_left_arm.gib_settings.sfx.node_name = "g_left_lower_arm_gib"
lower_left_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_lower_arm_gib_cap"
lower_left_arm.stump_settings.stump_attach_node = "j_leftarm"
lower_left_arm.scale_node = "j_leftforearm"
lower_left_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override"
}

local lower_right_arm = table.clone(limb_segment)

lower_right_arm.gib_settings.override_push_force = {
	gib_push_lower_arm,
	gib_push_lower_arm * 1.25
}
lower_right_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_arm_gib"
lower_right_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_lower_arm_gib"
lower_right_arm.gib_settings.gib_spawn_node = "j_rightforearm"
lower_right_arm.gib_settings.gib_actor = "rp_right_lower_arm_gib"
lower_right_arm.gib_settings.sfx.node_name = "g_right_lower_arm_gib"
lower_right_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_arm_gib_cap"
lower_right_arm.stump_settings.stump_attach_node = "j_rightarm"
lower_right_arm.scale_node = "j_rightforearm"
lower_right_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override"
}

local lower_left_arm_remove = table.clone(lower_left_arm)

lower_left_arm_remove.gib_settings = nil

local lower_right_arm_remove = table.clone(lower_right_arm)

lower_right_arm_remove.gib_settings = nil

local left_arm = table.clone(limb_full)

left_arm.gib_settings.override_push_force = {
	gib_push_arm,
	gib_push_arm * 1.25
}
left_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_fullarm_gib"
left_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_entire_arm_gib"
left_arm.gib_settings.gib_spawn_node = "j_leftarm"
left_arm.gib_settings.gib_actor = "rp_left_fullarm_gib"
left_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_arm_gib_cap"
left_arm.stump_settings.stump_attach_node = "j_spine"
left_arm.scale_node = "j_leftarm"
left_arm.extra_hit_zone_actors_to_destroy = {
	"lower_left_arm"
}
left_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override"
}

local right_arm = table.clone(limb_full)

right_arm.gib_settings.override_push_force = {
	gib_push_arm,
	gib_push_arm * 1.25
}
right_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_arm_gib"
right_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_upper_arm_gib"
right_arm.gib_settings.gib_spawn_node = "j_rightarm"
right_arm.gib_settings.gib_actor = "rp_right_upper_arm_gib"
right_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_arm_gib_cap"
right_arm.stump_settings.stump_attach_node = "j_spine"
right_arm.scale_node = "j_rightarm"
right_arm.extra_hit_zone_actors_to_destroy = {
	"lower_right_arm"
}
right_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override"
}

local upper_left_arm_warp = table.clone(upper_left_arm)

upper_left_arm_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
upper_left_arm_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
upper_left_arm_warp.gibbing_threshold = GibbingThresholds.medium

local upper_right_arm_warp = table.clone(upper_right_arm)

upper_right_arm_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
upper_right_arm_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
upper_right_arm_warp.gibbing_threshold = GibbingThresholds.medium

local lower_left_arm_warp = table.clone(lower_left_arm)

lower_left_arm_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_left_arm_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
lower_left_arm_warp.gibbing_threshold = GibbingThresholds.medium

local lower_right_arm_warp = table.clone(lower_right_arm)

lower_right_arm_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_right_arm_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
lower_right_arm_warp.gibbing_threshold = GibbingThresholds.medium

local upper_left_arm_warp_lightning = table.clone(upper_left_arm)

upper_left_arm_warp_lightning.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib_lightning
upper_left_arm_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning

local upper_right_arm_warp_lightning = table.clone(upper_right_arm)

upper_right_arm_warp_lightning.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib_lightning
upper_right_arm_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning

local lower_left_arm_warp_lightning = table.clone(lower_left_arm)

lower_left_arm_warp_lightning.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib_lightning
lower_left_arm_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning

local lower_right_arm_warp_lightning = table.clone(lower_right_arm)

lower_right_arm_warp_lightning.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib_lightning
lower_right_arm_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning

local upper_left_arm_warp_shard = table.clone(upper_left_arm)

upper_left_arm_warp_shard.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
upper_left_arm_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump

local upper_right_arm_warp_shard = table.clone(upper_right_arm)

upper_right_arm_warp_shard.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
upper_right_arm_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump

local lower_left_arm_warp_shard = table.clone(lower_left_arm)

lower_left_arm_warp_shard.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_left_arm_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump

local lower_right_arm_warp_shard = table.clone(lower_right_arm)

lower_right_arm_warp_shard.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_right_arm_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump

local upper_left_leg = table.clone(limb_segment)

upper_left_leg.gib_settings.override_push_force = {
	gib_push_upper_leg,
	gib_push_upper_leg * 1.25
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
	already_gibbed = "lower_left_leg"
}
upper_left_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override",
	"skin_color_override"
}

local upper_right_leg = table.clone(limb_segment)

upper_right_leg.gib_settings.override_push_force = {
	gib_push_upper_leg,
	gib_push_upper_leg * 1.25
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
	already_gibbed = "lower_right_leg"
}
upper_right_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override",
	"skin_color_override"
}

local upper_left_leg_remove = table.clone(upper_left_leg)

upper_left_leg_remove.gib_settings = nil

local upper_right_leg_remove = table.clone(upper_right_leg)

upper_right_leg_remove.gib_settings = nil

local lower_left_leg = table.clone(limb_segment)

lower_left_leg.gib_settings.override_push_force = {
	gib_push_lower_leg,
	gib_push_lower_leg * 1.25
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
	"skin_color_override"
}

local lower_right_leg = table.clone(limb_segment)

lower_right_leg.gib_settings.override_push_force = {
	gib_push_lower_leg,
	gib_push_lower_leg * 1.25
}
lower_right_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_leg_gib"
lower_right_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_lower_leg_gib"
lower_right_leg.gib_settings.gib_spawn_node = "j_rightleg"
lower_right_leg.gib_settings.gib_actor = "rp_right_lower_leg_gib"
lower_right_leg.gib_settings.vfx.node_name = lower_right_leg.gib_settings.gib_actor
lower_right_leg.gib_settings.sfx.node_name = "g_right_lower_leg_gib"
lower_right_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_lower_leg_gib_cap"
lower_right_leg.stump_settings.stump_attach_node = "j_rightupleg"
lower_right_leg.scale_node = "j_rightleg"
lower_right_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override",
	"skin_color_override"
}

local lower_left_leg_remove = table.clone(lower_left_leg)

lower_left_leg_remove.gib_settings = nil

local lower_right_leg_remove = table.clone(lower_right_leg)

lower_right_leg_remove.gib_settings = nil

local left_leg = table.clone(limb_full)

left_leg.gib_settings.override_push_force = {
	gib_push_leg,
	gib_push_leg * 1.25
}
left_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_fullleg_gib"
left_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_left_entire_leg_gib"
left_leg.gib_settings.gib_spawn_node = "j_leftupleg"
left_leg.gib_settings.gib_actor = "rp_left_fullleg_gib"
left_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/left_upper_leg_gib_cap"
left_leg.stump_settings.stump_attach_node = "j_hips"
left_leg.scale_node = "j_leftupleg"
left_leg.extra_hit_zone_actors_to_destroy = {
	"lower_left_leg"
}
left_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override",
	"skin_color_override"
}

local right_leg = table.clone(limb_full)

right_leg.gib_settings.override_push_force = {
	gib_push_leg,
	gib_push_leg * 1.25
}
right_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_fullleg_gib"
right_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_right_entire_leg_gib"
right_leg.gib_settings.gib_spawn_node = "j_rightupleg"
right_leg.gib_settings.gib_actor = "rp_right_fullleg_gib"
right_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_cultists/gibbing/base_a/right_upper_leg_gib_cap"
right_leg.stump_settings.stump_attach_node = "j_hips"
right_leg.scale_node = "j_rightupleg"
right_leg.extra_hit_zone_actors_to_destroy = {
	"lower_right_leg"
}
right_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override",
	"skin_color_override"
}

local upper_left_leg_warp = table.clone(upper_left_leg)

upper_left_leg_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
upper_left_leg_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
upper_left_leg_warp.gibbing_threshold = GibbingThresholds.medium

local upper_right_leg_warp = table.clone(upper_right_leg)

upper_right_leg_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
upper_right_leg_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
upper_right_leg_warp.gibbing_threshold = GibbingThresholds.medium

local lower_left_leg_warp = table.clone(lower_left_leg)

lower_left_leg_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_left_leg_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
lower_left_leg_warp.gibbing_threshold = GibbingThresholds.medium

local lower_right_leg_warp = table.clone(lower_right_leg)

lower_right_leg_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_right_leg_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
lower_right_leg_warp.gibbing_threshold = GibbingThresholds.medium

local upper_left_leg_warp_lightning = table.clone(upper_left_leg)

upper_left_leg_warp_lightning.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib_lightning
upper_left_leg_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning

local upper_right_leg_warp_lightning = table.clone(upper_right_leg)

upper_right_leg_warp_lightning.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib_lightning
upper_right_leg_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning

local lower_left_leg_warp_lightning = table.clone(lower_left_leg)

lower_left_leg_warp_lightning.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib_lightning
lower_left_leg_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning

local lower_right_leg_warp_lightning = table.clone(lower_right_leg)

lower_right_leg_warp_lightning.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib_lightning
lower_right_leg_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning

local upper_left_leg_warp_shard = table.clone(upper_left_leg)

upper_left_leg_warp_shard.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
upper_left_leg_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump

local upper_right_leg_warp_shard = table.clone(upper_right_leg)

upper_right_leg_warp_shard.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
upper_right_leg_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump

local lower_left_leg_warp_shard = table.clone(lower_left_leg)

lower_left_leg_warp_shard.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_left_leg_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump

local lower_right_leg_warp_shard = table.clone(lower_right_leg)

lower_right_leg_warp_shard.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
lower_right_leg_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump

local torso_sever = table.clone(SharedGibbingTemplates.torso)

torso_sever.gib_settings.override_push_force = {
	gib_push_torso,
	gib_push_torso * 1.25
}
torso_sever.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/midrange_a/upper_torso_gib_full"
torso_sever.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib_full"
torso_sever.gib_settings.gib_spawn_node = "j_hips"
torso_sever.gib_settings.gib_actor = "rp_upper_torso_gib_full"
torso_sever.gib_settings.attach_inventory_slots_to_gib = {
	"slot_head",
	"slot_beard",
	"slot_face"
}
torso_sever.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
torso_sever.gib_settings.sfx = nil
torso_sever.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/uppertorso_gib_cap"
torso_sever.stump_settings.stump_attach_node = "j_hips"
torso_sever.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
torso_sever.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
torso_sever.scale_node = "j_spine1"
torso_sever.gibbing_threshold = SharedGibbingTemplates.torso.gibbing_threshold + size
torso_sever.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override"
}

local torso_full = table.clone(torso_sever)

torso_full.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/midrange_a/upper_torso_gib"
torso_full.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib"
torso_full.gib_settings.gib_actor = "rp_upper_torso_gib"
torso_full.gib_settings.attach_inventory_slots_to_gib = {
	""
}
torso_full.extra_hit_zone_gibs = {
	"head",
	"upper_right_arm",
	"upper_left_arm"
}

local torso_remove = table.clone(torso_full)

torso_remove.gib_settings = nil
torso_remove.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_splatter

local torso_warp = table.clone(torso_sever)

torso_warp.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib
torso_warp.gib_settings.vfx.node_name = nil
torso_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
torso_warp.gibbing_threshold = GibbingThresholds.medium + size

local torso_warp_lightning = table.clone(torso_warp)

torso_warp_lightning.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib_lightning
torso_warp_lightning.gib_settings.vfx.node_name = nil
torso_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning

local torso_warp_shard = table.clone(torso_warp)

torso_warp_shard.gib_settings.vfx = SharedGibbingTemplates.vfx.warp_gib_shard
torso_warp_shard.gib_settings.vfx.node_name = nil
torso_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_shard

local torso_warp_wind_slash = table.clone(torso_warp)

torso_warp_wind_slash.stump_settings.sfx = SharedGibbingTemplates.sfx.warp_wind_slash_large
torso_warp_wind_slash.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_wind_slash_large

local center_mass_full = table.clone(torso_sever)

center_mass_full.gib_settings.gib_unit = "content/characters/enemy/chaos_cultists/gibbing/midrange_a/upper_torso_gib"
center_mass_full.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_upper_torso_gib"
center_mass_full.gib_settings.gib_actor = "rp_upper_torso_gib"
center_mass_full.gib_settings.attach_inventory_slots_to_gib = {
	""
}
center_mass_full.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_splatter
center_mass_full.gibbing_threshold = SharedGibbingTemplates.center_mass.gibbing_threshold + size
center_mass_full.extra_hit_zone_gibs = SharedGibbingTemplates.center_mass.extra_hit_zone_gibs
center_mass_full.material_overrides = {
	"slot_upperbody",
	"envrionmental_override",
	"skin_color_override"
}

local center_mass_upper = table.clone(center_mass_full)

center_mass_upper.extra_hit_zone_gibs = {
	"head",
	"upper_right_arm",
	"upper_left_arm"
}

local center_mass_lower = table.clone(center_mass_full)

center_mass_lower.gib_settings = nil
center_mass_lower.scale_node = nil
center_mass_lower.extra_hit_zone_gibs = {
	"upper_right_leg",
	"upper_left_leg"
}
center_mass_lower.prevents_other_gibs = {
	"center_mass",
	"torso"
}

local center_mass_left = table.clone(center_mass_full)

center_mass_left.gib_settings = left_arm.gib_settings
center_mass_left.stump_settings = left_arm.stump_settings
center_mass_left.scale_node = left_arm.scale_node
center_mass_left.extra_hit_zone_gibs = {
	"upper_right_leg"
}
center_mass_left.extra_hit_zone_actors_to_destroy = {
	"upper_right_leg"
}

local center_mass_right = table.clone(center_mass_full)

center_mass_right.gib_settings = right_arm.gib_settings
center_mass_right.stump_settings = right_arm.stump_settings
center_mass_right.scale_node = right_arm.scale_node
center_mass_right.extra_hit_zone_gibs = {
	"upper_left_leg"
}
center_mass_right.extra_hit_zone_actors_to_destroy = {
	"upper_left_leg"
}

local center_mass_full_warp = table.clone(center_mass_full)

center_mass_full_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
center_mass_full_warp.gibbing_threshold = GibbingThresholds.heavy

local center_mass_upper_warp = table.clone(center_mass_upper)

center_mass_upper_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
center_mass_upper_warp.gibbing_threshold = GibbingThresholds.heavy

local center_mass_lower_warp = table.clone(center_mass_lower)

center_mass_lower_warp.gibbing_threshold = GibbingThresholds.heavy

local center_mass_left_warp = table.clone(center_mass_left)

center_mass_left_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
center_mass_left_warp.gibbing_threshold = GibbingThresholds.heavy

local center_mass_right_warp = table.clone(center_mass_right)

center_mass_right_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
center_mass_right_warp.gibbing_threshold = GibbingThresholds.heavy

local center_mass_full_warp_shard = table.clone(center_mass_full_warp)

center_mass_full_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_shard

local center_mass_upper_warp_shard = table.clone(center_mass_upper_warp)

center_mass_upper_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_shard

local center_mass_lower_warp_shard = table.clone(center_mass_lower_warp)
local center_mass_left_warp_shard = table.clone(center_mass_left_warp)

center_mass_left_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_shard

local center_mass_right_warp_shard = table.clone(center_mass_right_warp)

center_mass_right_warp_shard.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_shard

local center_mass_warp_lightning = table.clone(torso_sever)

center_mass_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning
center_mass_warp_lightning.stump_settings.sfx = SharedGibbingTemplates.sfx.warp_stump_lightning

local center_mass_upper_warp_lightning = table.clone(center_mass_upper)

center_mass_upper_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning
center_mass_upper_warp_lightning.stump_settings.sfx = SharedGibbingTemplates.sfx.warp_stump_lightning
center_mass_upper_warp_lightning.gibbing_threshold = GibbingThresholds.heavy

local center_mass_lower_warp_lightning = table.clone(center_mass_lower)

center_mass_lower_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning
center_mass_lower_warp_lightning.stump_settings.sfx = SharedGibbingTemplates.sfx.warp_stump_lightning
center_mass_lower_warp_lightning.gibbing_threshold = GibbingThresholds.heavy

local center_mass_left_warp_lightning = table.clone(center_mass_left)

center_mass_left_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning
center_mass_left_warp_lightning.stump_settings.sfx = SharedGibbingTemplates.sfx.warp_stump_lightning
center_mass_left_warp_lightning.gibbing_threshold = GibbingThresholds.heavy

local center_mass_right_warp_lightning = table.clone(center_mass_right)

center_mass_right_warp_lightning.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump_lightning
center_mass_right_warp_lightning.stump_settings.sfx = SharedGibbingTemplates.sfx.warp_stump_lightning
center_mass_right_warp_lightning.gibbing_threshold = GibbingThresholds.heavy

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
		warp = head_warp,
		warp_shard = head_warp_shard
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
		warp = upper_left_arm_warp,
		warp_shard = upper_left_arm_warp_shard
	},
	upper_right_arm = {
		default = {
			conditional = {
				upper_right_arm,
				right_arm
			}
		},
		ballistic = {
			conditional = {
				upper_right_arm_remove,
				right_arm
			}
		},
		boltshell = {
			conditional = {
				upper_right_arm_remove,
				right_arm
			}
		},
		plasma = {
			conditional = {
				upper_right_arm_remove,
				right_arm
			}
		},
		warp = upper_right_arm_warp,
		warp_shard = upper_right_arm_warp_shard
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
		warp = upper_left_leg_warp,
		warp_shard = upper_left_leg_warp_shard
	},
	upper_right_leg = {
		default = {
			conditional = {
				upper_right_leg,
				right_leg
			}
		},
		ballistic = {
			conditional = {
				upper_right_leg_remove,
				right_leg
			}
		},
		boltshell = {
			conditional = {
				upper_right_leg_remove,
				right_leg
			}
		},
		plasma = {
			conditional = {
				upper_right_leg_remove,
				right_leg
			}
		},
		warp = upper_right_leg_warp,
		warp_shard = upper_right_leg_warp_shard
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
		warp = lower_left_arm_warp,
		warp_shard = lower_left_arm_warp_shard
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
		warp = lower_right_arm_warp,
		warp_shard = lower_right_arm_warp_shard
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
		warp = lower_left_leg_warp,
		warp_shard = lower_left_leg_warp_shard
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
		warp = lower_right_leg_warp,
		warp_shard = lower_right_leg_warp_shard
	},
	torso = {
		default = torso_sever,
		ballistic = {
			torso_remove
		},
		explosion = {
			torso_sever,
			torso_remove,
			torso_full
		},
		boltshell = torso_remove,
		plasma = torso_remove,
		sawing = {
			torso_sever
		},
		warp = {
			center_mass_upper_warp
		},
		warp_shard = {
			center_mass_upper_warp_shard
		},
		warp_wind_slash_high = {
			torso_warp_wind_slash
		}
	},
	center_mass = {
		ballistic = {
			center_mass_full,
			torso_sever
		},
		explosion = {
			center_mass_full,
			center_mass_upper,
			center_mass_lower,
			center_mass_left,
			center_mass_right
		},
		boltshell = {
			center_mass_full,
			center_mass_upper,
			torso_sever
		},
		warp = {
			center_mass_full_warp,
			center_mass_upper_warp,
			center_mass_lower_warp,
			center_mass_left_warp,
			center_mass_right_warp
		},
		warp_lightning = {
			center_mass_upper_warp_lightning,
			center_mass_lower_warp_lightning,
			center_mass_left_warp_lightning,
			center_mass_right_warp_lightning
		},
		warp_shard = {
			center_mass_full_warp_shard,
			center_mass_upper_warp_shard,
			center_mass_lower_warp_shard,
			center_mass_left_warp_shard,
			center_mass_right_warp_shard
		},
		warp_wind_slash_high = {
			torso_warp_wind_slash
		},
		plasma = {
			center_mass_full,
			center_mass_upper,
			torso_sever
		}
	}
}

return gibbing_template
