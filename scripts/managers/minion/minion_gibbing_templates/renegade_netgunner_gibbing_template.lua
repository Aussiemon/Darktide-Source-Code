local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local SharedGibbingTemplates = require("scripts/managers/minion/minion_gibbing_templates/shared_gibbing_templates")
local name = "renegade_netgunner_gibbing"
local size = GibbingSettings.character_size.medium
local gib_push_base_value = 6
local gib_push_head = gib_push_base_value * 0.015
local gib_push_limb = gib_push_base_value * 0.05
local head_sever = table.clone(SharedGibbingTemplates.head)
head_sever.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/longrange_a/head_gib"
head_sever.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/flesh_head_gib"
head_sever.gib_settings.gib_spawn_node = "j_neck"
head_sever.gib_settings.gib_actor = "rp_head_gib"
head_sever.gib_settings.attach_inventory_slots_to_gib = {
	"slot_head"
}
head_sever.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
head_sever.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_head_off
head_sever.gib_settings.sfx.node_name = "g_head_gib"
head_sever.gib_settings.override_push_force = {
	gib_push_head,
	gib_push_head * 1.25
}
head_sever.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/head_gib_cap"
head_sever.stump_settings.stump_attach_node = "j_spine1"
head_sever.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
head_sever.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
head_sever.scale_node = "j_neck"
head_sever.gibbing_threshold = SharedGibbingTemplates.head.gibbing_threshold + size
head_sever.material_overrides = {
	"slot_head",
	"envrionmental_override"
}
local head_full = table.clone(head_sever)
head_full.gib_settings = nil
local head_crush = table.clone(head_sever)
head_crush.gib_settings = nil
head_crush.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/head_gib_cap_crushed"
head_crush.gibbing_threshold = GibbingThresholds.always + size
local head_warp = table.clone(head_sever)
head_warp.gib_settings = nil
head_warp.stump_settings.vfx = SharedGibbingTemplates.vfx.warp_stump
head_warp.gibbing_threshold = GibbingThresholds.light
local limb_segment = table.clone(SharedGibbingTemplates.limb_segment)
limb_segment.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
limb_segment.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_limb_off
limb_segment.gib_settings.override_push_force = {
	gib_push_limb,
	gib_push_limb * 1.25
}
limb_segment.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
limb_segment.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
limb_segment.gibbing_threshold = SharedGibbingTemplates.limb_segment.gibbing_threshold + size
local limb_full = table.clone(SharedGibbingTemplates.limb_full)
limb_full.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
limb_full.gib_settings.sfx = SharedGibbingTemplates.sfx.dismember_limb_off
limb_full.gib_settings.override_push_force = {
	gib_push_limb,
	gib_push_limb * 1.25
}
limb_full.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
limb_full.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
limb_full.gibbing_threshold = SharedGibbingTemplates.limb_full.gibbing_threshold + size
local upper_left_arm = table.clone(limb_segment)
upper_left_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/netgunner/left_upper_arm_gib"
upper_left_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_left_upper_arm_gib"
upper_left_arm.gib_settings.gib_spawn_node = "j_leftarm"
upper_left_arm.gib_settings.gib_actor = "rp_left_upper_arm_gib"
upper_left_arm.gib_settings.vfx.node_name = upper_left_arm.gib_settings.gib_actor
upper_left_arm.gib_settings.sfx.node_name = "g_left_upper_arm_gib"
upper_left_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/left_upper_arm_gib_cap"
upper_left_arm.stump_settings.stump_attach_node = "j_spine"
upper_left_arm.scale_node = "j_leftarm"
upper_left_arm.condition = {
	already_gibbed = "lower_left_arm"
}
upper_left_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override"
}
local upper_right_arm = table.clone(limb_segment)
upper_right_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/netgunner/right_upper_arm_gib"
upper_right_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_right_upper_arm_gib"
upper_right_arm.gib_settings.gib_spawn_node = "j_rightarm"
upper_right_arm.gib_settings.gib_actor = "rp_right_upper_arm_gib"
upper_right_arm.gib_settings.vfx.node_name = upper_right_arm.gib_settings.gib_actor
upper_right_arm.gib_settings.sfx.node_name = "g_right_upper_arm_gib"
upper_right_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/right_upper_arm_gib_cap"
upper_right_arm.stump_settings.stump_attach_node = "j_spine"
upper_right_arm.scale_node = "j_rightarm"
upper_right_arm.condition = {
	already_gibbed = "lower_right_arm"
}
upper_right_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override"
}
local lower_left_arm = table.clone(limb_segment)
lower_left_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/netgunner/left_lower_arm_gib"
lower_left_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_left_lower_arm_gib"
lower_left_arm.gib_settings.gib_spawn_node = "j_leftforearm"
lower_left_arm.gib_settings.gib_actor = "rp_left_lower_arm_gib"
lower_left_arm.gib_settings.sfx.node_name = "g_left_lower_arm_gib"
lower_left_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/left_lower_arm_gib_cap"
lower_left_arm.stump_settings.stump_attach_node = "j_leftarm"
lower_left_arm.scale_node = "j_leftforearm"
lower_left_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override"
}
local lower_right_arm = table.clone(limb_segment)
lower_right_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/netgunner/right_lower_arm_gib"
lower_right_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_right_lower_arm_gib"
lower_right_arm.gib_settings.gib_spawn_node = "j_rightforearm"
lower_right_arm.gib_settings.gib_actor = "rp_right_lower_arm_gib"
lower_right_arm.gib_settings.sfx.node_name = "g_right_lower_arm_gib"
lower_right_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/right_lower_arm_gib_cap"
lower_right_arm.stump_settings.stump_attach_node = "j_rightarm"
lower_right_arm.scale_node = "j_rightforearm"
lower_right_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override"
}
local left_arm = table.clone(limb_full)
left_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/netgunner/left_fullarm_gib"
left_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_left_fullarm_gib"
left_arm.gib_settings.gib_spawn_node = "j_leftarm"
left_arm.gib_settings.gib_actor = "rp_left_fullarm_gib"
left_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/left_upper_arm_gib_cap"
left_arm.stump_settings.stump_attach_node = "j_spine"
left_arm.scale_node = "j_leftarm"
left_arm.extra_hit_zone_actors_to_destroy = {
	"lower_left_arm"
}
left_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override"
}
local right_arm = table.clone(limb_full)
right_arm.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/netgunner/right_fullarm_gib"
right_arm.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_right_fullarm_gib"
right_arm.gib_settings.gib_spawn_node = "j_rightarm"
right_arm.gib_settings.gib_actor = "rp_right_fullarm_gib"
right_arm.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/right_upper_arm_gib_cap"
right_arm.stump_settings.stump_attach_node = "j_spine"
right_arm.scale_node = "j_rightarm"
right_arm.extra_hit_zone_actors_to_destroy = {
	"lower_right_arm"
}
right_arm.material_overrides = {
	"slot_upperbody",
	"envrionmental_override"
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
local upper_left_leg = table.clone(limb_segment)
upper_left_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/left_upper_leg_gib"
upper_left_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_left_upper_leg_gib"
upper_left_leg.gib_settings.gib_spawn_node = "j_leftupleg"
upper_left_leg.gib_settings.gib_actor = "rp_left_upper_leg_gib"
upper_left_leg.gib_settings.vfx.node_name = upper_left_leg.gib_settings.gib_actor
upper_left_leg.gib_settings.sfx.node_name = "g_left_upper_leg_gib"
upper_left_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/left_upper_leg_gib_cap"
upper_left_leg.stump_settings.stump_attach_node = "j_hips"
upper_left_leg.scale_node = "j_leftupleg"
upper_left_leg.condition = {
	already_gibbed = "lower_left_leg"
}
upper_left_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override"
}
local upper_right_leg = table.clone(limb_segment)
upper_right_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/right_upper_leg_gib"
upper_right_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_right_upper_leg_gib"
upper_right_leg.gib_settings.gib_spawn_node = "j_rightupleg"
upper_right_leg.gib_settings.gib_actor = "rp_right_upper_leg_gib"
upper_right_leg.gib_settings.vfx.node_name = upper_right_leg.gib_settings.gib_actor
upper_right_leg.gib_settings.sfx.node_name = "g_right_upper_leg_gib"
upper_right_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/right_upper_leg_gib_cap"
upper_right_leg.stump_settings.stump_attach_node = "j_hips"
upper_right_leg.scale_node = "j_rightupleg"
upper_right_leg.condition = {
	already_gibbed = "lower_right_leg"
}
upper_right_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override"
}
local lower_left_leg = table.clone(limb_segment)
lower_left_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_elite_a/left_lower_leg_gib"
lower_left_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_left_lower_leg_gib"
lower_left_leg.gib_settings.gib_spawn_node = "j_leftleg"
lower_left_leg.gib_settings.gib_actor = "rp_left_lower_leg_gib"
lower_left_leg.gib_settings.vfx.node_name = lower_left_leg.gib_settings.gib_actor
lower_left_leg.gib_settings.sfx.node_name = "g_left_lower_leg_gib"
lower_left_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/left_lower_leg_gib_cap"
lower_left_leg.stump_settings.stump_attach_node = "j_leftupleg"
lower_left_leg.scale_node = "j_leftleg"
lower_left_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override"
}
local lower_right_leg = table.clone(limb_segment)
lower_right_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_elite_a/right_lower_leg_gib"
lower_right_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_right_lower_leg_gib"
lower_right_leg.gib_settings.gib_spawn_node = "j_rightleg"
lower_right_leg.gib_settings.gib_actor = "rp_right_lower_leg_gib"
lower_right_leg.gib_settings.vfx.node_name = lower_right_leg.gib_settings.gib_actor
lower_right_leg.gib_settings.sfx.node_name = "g_right_lower_leg_gib"
lower_right_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/right_lower_leg_gib_cap"
lower_right_leg.stump_settings.stump_attach_node = "j_rightupleg"
lower_right_leg.scale_node = "j_rightleg"
lower_right_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override"
}
local left_leg = table.clone(limb_full)
left_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/left_fullleg_gib"
left_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_left_fullleg_gib"
left_leg.gib_settings.gib_spawn_node = "j_leftupleg"
left_leg.gib_settings.gib_actor = "rp_left_fullleg_gib"
left_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/left_upper_leg_gib_cap"
left_leg.stump_settings.stump_attach_node = "j_hips"
left_leg.scale_node = "j_leftupleg"
left_leg.extra_hit_zone_actors_to_destroy = {
	"lower_left_leg"
}
left_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override"
}
local right_leg = table.clone(limb_full)
right_leg.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/midrange_elite_a/right_fullleg_gib"
right_leg.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_right_fullleg_gib"
right_leg.gib_settings.gib_spawn_node = "j_rightupleg"
right_leg.gib_settings.gib_actor = "rp_right_fullleg_gib"
right_leg.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/right_upper_leg_gib_cap"
right_leg.stump_settings.stump_attach_node = "j_hips"
right_leg.scale_node = "j_rightupleg"
right_leg.extra_hit_zone_actors_to_destroy = {
	"lower_right_leg"
}
right_leg.material_overrides = {
	"slot_lowerbody",
	"envrionmental_override"
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
local torso_sever = table.clone(SharedGibbingTemplates.torso)
torso_sever.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/netgunner/upper_torso_gib_full"
torso_sever.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_upper_torso_gib_full"
torso_sever.gib_settings.gib_spawn_node = "j_hips"
torso_sever.gib_settings.gib_actor = "rp_upper_torso_gib_full"
torso_sever.gib_settings.attach_inventory_slots_to_gib = {
	"slot_head"
}
torso_sever.gib_settings.vfx = SharedGibbingTemplates.vfx.blood_gushing
torso_sever.gib_settings.sfx = nil
torso_sever.gib_settings.override_push_force = {
	gib_push_base_value,
	gib_push_base_value * 1.25
}
torso_sever.gib_settings.push_override = SharedGibbingTemplates.gib_push_overrides.straight_up
torso_sever.stump_settings.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/uppertorso_gib_cap"
torso_sever.stump_settings.stump_attach_node = "j_hips"
torso_sever.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_fountain
torso_sever.stump_settings.sfx = SharedGibbingTemplates.sfx.blood_fountain_neck
torso_sever.scale_node = "j_spine1"
torso_sever.gibbing_threshold = SharedGibbingTemplates.torso.gibbing_threshold + size
torso_sever.material_overrides = {
	"slot_upperbody",
	"envrionmental_override"
}
local torso_full = table.clone(torso_sever)
torso_full.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/netgunner/upper_torso_gib"
torso_full.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_upper_torso_gib"
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
local center_mass_full = table.clone(torso_sever)
center_mass_full.gib_settings.gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/netgunner/upper_torso_gib"
center_mass_full.gib_settings.gib_flesh_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/flesh_upper_torso_gib"
center_mass_full.gib_settings.gib_actor = "rp_upper_torso_gib"
center_mass_full.gib_settings.attach_inventory_slots_to_gib = {
	""
}
center_mass_full.stump_settings.vfx = SharedGibbingTemplates.vfx.blood_splatter
center_mass_full.gibbing_threshold = SharedGibbingTemplates.center_mass.gibbing_threshold + size
center_mass_full.extra_hit_zone_gibs = SharedGibbingTemplates.center_mass.extra_hit_zone_gibs
center_mass_full.material_overrides = {
	"slot_upperbody",
	"envrionmental_override"
}
local center_mass_upper = table.clone(center_mass_full)
center_mass_upper.extra_hit_zone_gibs = {
	"head",
	"upper_right_arm",
	"upper_left_arm"
}
local center_mass_lower = table.clone(center_mass_full)
center_mass_lower.gib_settings = nil
center_mass_lower.stump_settings = nil
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
	"upper_right_leg",
	"lower_right_leg"
}
center_mass_left.extra_hit_zone_actors_to_destroy = {
	"upper_right_leg"
}
local center_mass_right = table.clone(center_mass_full)
center_mass_right.gib_settings = right_arm.gib_settings
center_mass_right.stump_settings = right_arm.stump_settings
center_mass_right.scale_node = right_arm.scale_node
center_mass_right.extra_hit_zone_gibs = {
	"upper_left_leg",
	"lower_left_leg"
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
local gibbing_template = {
	name = name,
	head = {
		default = head_sever,
		ballistic = {
			head_full
		},
		crushing = head_crush,
		laser = head_full,
		sawing = head_sever,
		warp = head_warp
	},
	upper_left_arm = {
		default = {
			conditional = {
				upper_left_arm,
				left_arm
			}
		},
		warp = upper_left_arm_warp
	},
	upper_right_arm = {
		default = {
			conditional = {
				upper_right_arm,
				right_arm
			}
		},
		warp = upper_right_arm_warp
	},
	upper_left_leg = {
		default = {
			conditional = {
				upper_left_leg,
				left_leg
			}
		},
		warp = upper_left_leg_warp
	},
	upper_right_leg = {
		default = {
			conditional = {
				upper_right_leg,
				right_leg
			}
		},
		warp = upper_right_leg_warp
	},
	lower_left_arm = {
		default = lower_left_arm,
		warp = lower_left_arm_warp
	},
	lower_right_arm = {
		default = lower_right_arm,
		warp = lower_right_arm_warp
	},
	lower_left_leg = {
		default = lower_left_leg,
		warp = lower_left_leg_warp
	},
	lower_right_leg = {
		default = lower_right_leg,
		warp = lower_right_leg_warp
	},
	torso = {
		default = torso_sever,
		ballistic = {
			torso_remove
		},
		explosion = torso_sever,
		boltshell = torso_remove,
		plasma = torso_remove,
		sawing = torso_sever,
		warp = {
			center_mass_upper_warp
		}
	},
	center_mass = {
		ballistic = {
			center_mass_full
		},
		explosion = {
			center_mass_full,
			center_mass_upper,
			center_mass_lower,
			center_mass_left,
			center_mass_right
		},
		boltshell = center_mass_lower,
		warp = {
			center_mass_full_warp,
			center_mass_upper_warp,
			center_mass_lower_warp,
			center_mass_left_warp,
			center_mass_right_warp
		},
		plasma = center_mass_full
	}
}

return gibbing_template
