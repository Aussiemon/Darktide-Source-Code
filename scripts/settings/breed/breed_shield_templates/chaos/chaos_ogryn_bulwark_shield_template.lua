﻿-- chunkname: @scripts/settings/breed/breed_shield_templates/chaos/chaos_ogryn_bulwark_shield_template.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local attack_types = AttackSettings.attack_types
local shield_templates = {
	chaos_ogryn_bulwark = {
		open_up_threshold = 170,
		open_up_vfx = "content/fx/particles/enemies/chaos_ogryn/shield_open",
		open_up_vfx_node = "shield_mid_node",
		open_up_vfx_slot_name = "slot_shield",
		regen_hit_strength_rate = 25,
		blocking_angle = math.degrees_to_radians(70),
		attack_type_min_stagger_strength = {
			[attack_types.ranged] = 3,
			[attack_types.melee] = 10,
		},
	},
}

return shield_templates
