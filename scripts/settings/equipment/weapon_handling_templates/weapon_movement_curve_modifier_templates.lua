-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_movement_curve_modifier_templates.lua

local weapon_movement_curve_modifier_templates = {}

weapon_movement_curve_modifier_templates.default = {
	modifier = {
		lerp_perfect = 1,
		lerp_basic = 0.5
	}
}
weapon_movement_curve_modifier_templates.lasgun_p1_m1 = {
	modifier = {
		lerp_perfect = 1,
		lerp_basic = 0.25
	}
}
weapon_movement_curve_modifier_templates.lasgun_p1_m2 = {
	modifier = {
		lerp_perfect = 1.25,
		lerp_basic = 0.5
	}
}
weapon_movement_curve_modifier_templates.lasgun_p3 = {
	modifier = {
		lerp_perfect = 1,
		lerp_basic = 0.6
	}
}
weapon_movement_curve_modifier_templates.chainsword_p1_m1 = {
	modifier = {
		lerp_perfect = 1.5,
		lerp_basic = 0.5
	}
}
weapon_movement_curve_modifier_templates.combataxe_p1_m1 = {
	modifier = {
		lerp_perfect = 1.5,
		lerp_basic = 0.5
	}
}
weapon_movement_curve_modifier_templates.forcesword_p1_m1 = {
	modifier = {
		lerp_perfect = 1.25,
		lerp_basic = 0.5
	}
}
weapon_movement_curve_modifier_templates.thumper_p1_m2 = {
	modifier = {
		lerp_perfect = 1.25,
		lerp_basic = 0.5
	}
}
weapon_movement_curve_modifier_templates.autopistol_p1_m1 = {
	modifier = {
		lerp_perfect = 1.5,
		lerp_basic = 0.5
	}
}
weapon_movement_curve_modifier_templates.ogryn_club_p1_m1 = {
	modifier = {
		lerp_perfect = 1.5,
		lerp_basic = 0.5
	}
}
weapon_movement_curve_modifier_templates.shotgun_p2 = {
	modifier = {
		lerp_perfect = 1.2,
		lerp_basic = 0.7
	}
}
weapon_movement_curve_modifier_templates.shotgun_p4 = {
	modifier = {
		lerp_perfect = 1.2,
		lerp_basic = 0.6
	}
}
weapon_movement_curve_modifier_templates.shotpistol = {
	modifier = {
		lerp_perfect = 1.1,
		lerp_basic = 0.6
	}
}
weapon_movement_curve_modifier_templates.boltpistol_p1_m1 = {
	modifier = {
		lerp_perfect = 1.25,
		lerp_basic = 0.4
	}
}
weapon_movement_curve_modifier_templates.forcesword_2h = {
	modifier = {
		lerp_perfect = 1.1,
		lerp_basic = 0.6
	}
}

return settings("WeaponCurveModifierTemplates", weapon_movement_curve_modifier_templates)
