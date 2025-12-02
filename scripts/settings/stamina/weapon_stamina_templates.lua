-- chunkname: @scripts/settings/stamina/weapon_stamina_templates.lua

local weapon_stamina_templates = {}
local _block_cost_default = {
	inner = {
		lerp_basic = 1.5,
		lerp_perfect = 0.5,
	},
	outer = {
		lerp_basic = 3,
		lerp_perfect = 1,
	},
}

weapon_stamina_templates.default = {
	stamina_modifier = 4,
	sprint_cost_per_second = {
		lerp_basic = 1.5,
		lerp_perfect = 0.5,
	},
	block_cost_default = _block_cost_default,
	push_cost = {
		lerp_basic = 3,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.smiter = {
	stamina_modifier = 3,
	sprint_cost_per_second = {
		lerp_basic = 1.5,
		lerp_perfect = 0.5,
	},
	block_cost_default = _block_cost_default,
	push_cost = {
		lerp_basic = 3,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.linesman = {
	stamina_modifier = 4,
	sprint_cost_per_second = {
		lerp_basic = 1.25,
		lerp_perfect = 0.75,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 1,
			lerp_perfect = 0.5,
		},
		outer = {
			lerp_basic = 3,
			lerp_perfect = 1,
		},
	},
	push_cost = {
		lerp_basic = 3,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.linesman_plus = {
	stamina_modifier = 4.5,
	sprint_cost_per_second = {
		lerp_basic = 1.25,
		lerp_perfect = 0.75,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 1,
			lerp_perfect = 0.5,
		},
		outer = {
			lerp_basic = 3,
			lerp_perfect = 1,
		},
	},
	push_cost = {
		lerp_basic = 3,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.linesman_rangedblock = {
	stamina_modifier = 4,
	sprint_cost_per_second = {
		lerp_basic = 1.25,
		lerp_perfect = 0.75,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 1,
			lerp_perfect = 0.5,
		},
		outer = {
			lerp_basic = 3,
			lerp_perfect = 1,
		},
	},
	block_cost_ranged = {
		inner = {
			lerp_basic = 0.75,
			lerp_perfect = 0.25,
		},
	},
	push_cost = {
		lerp_basic = 3,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.tank = {
	stamina_modifier = 6,
	sprint_cost_per_second = {
		lerp_basic = 2,
		lerp_perfect = 1,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 1,
			lerp_perfect = 0.5,
		},
		outer = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
	},
	push_cost = {
		lerp_basic = 2.25,
		lerp_perfect = 0.75,
	},
}
weapon_stamina_templates.ninjafencer = {
	stamina_modifier = 1,
	sprint_cost_per_second = {
		lerp_basic = 1,
		lerp_perfect = 0.5,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 0.75,
			lerp_perfect = 0.25,
		},
		outer = {
			lerp_basic = 1,
			lerp_perfect = 0.5,
		},
	},
	push_cost = {
		lerp_basic = 1.25,
		lerp_perfect = 0.75,
	},
}
weapon_stamina_templates.combat_knife_p1 = {
	stamina_modifier = 1,
	sprint_cost_per_second = {
		lerp_basic = 0.75,
		lerp_perfect = 0.25,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 0.75,
			lerp_perfect = 0.25,
		},
		outer = {
			lerp_basic = 1.5,
			lerp_perfect = 0.5,
		},
	},
	push_cost = {
		lerp_basic = 1.25,
		lerp_perfect = 0.75,
	},
}
weapon_stamina_templates.dual_shivs_p1 = {
	stamina_modifier = 1,
	sprint_cost_per_second = {
		lerp_basic = 0.85,
		lerp_perfect = 0.35,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 0.75,
			lerp_perfect = 0.25,
		},
		outer = {
			lerp_basic = 1.5,
			lerp_perfect = 0.5,
		},
	},
	push_cost = {
		lerp_basic = 2,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.luggable = {
	stamina_modifier = 2,
	sprint_cost_per_second = {
		lerp_basic = 2,
		lerp_perfect = 2,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
		outer = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
	},
	push_cost = {
		lerp_basic = 1.5,
		lerp_perfect = 0.5,
	},
}
weapon_stamina_templates.lasrifle = {
	stamina_modifier = 2,
	sprint_cost_per_second = {
		lerp_basic = 2,
		lerp_perfect = 1.5,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
		outer = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
	},
	push_cost = {
		lerp_basic = 1,
		lerp_perfect = 0.5,
	},
}
weapon_stamina_templates.thunderhammer_2h_p1_m1 = {
	stamina_modifier = 3,
	sprint_cost_per_second = {
		lerp_basic = 2,
		lerp_perfect = 1.5,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
		outer = {
			lerp_basic = 4,
			lerp_perfect = 2,
		},
	},
	push_cost = {
		lerp_basic = 3,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.forcesword_p1_m1 = {
	block_break_disorientation_type = "heavy",
	stamina_modifier = 2,
	sprint_cost_per_second = {
		lerp_basic = 1.5,
		lerp_perfect = 0.5,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 1.5,
			lerp_perfect = 0.5,
		},
		outer = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
	},
	block_cost_ranged = {
		inner = {
			lerp_basic = 0.75,
			lerp_perfect = 0.25,
		},
	},
	push_cost = {
		lerp_basic = 1.5,
		lerp_perfect = 0.5,
	},
}
weapon_stamina_templates.ogryn_powermaul_slabshield_p1_m1 = {
	stamina_modifier = 3,
	sprint_cost_per_second = {
		lerp_basic = 3.5,
		lerp_perfect = 1.5,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 0.6,
			lerp_perfect = 0.2,
		},
		outer = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
	},
	block_cost_ranged = {
		inner = {
			lerp_basic = 0.3,
			lerp_perfect = 0.1,
		},
	},
	push_cost = {
		lerp_basic = 1.5,
		lerp_perfect = 0.5,
	},
}
weapon_stamina_templates.powermaul_shield_p1_m1 = {
	stamina_modifier = 4,
	sprint_cost_per_second = {
		lerp_basic = 2.5,
		lerp_perfect = 1.5,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 0.6,
			lerp_perfect = 0.2,
		},
		outer = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
	},
	block_cost_ranged = {
		inner = {
			lerp_basic = 0.3,
			lerp_perfect = 0.1,
		},
	},
	push_cost = {
		lerp_basic = 1.5,
		lerp_perfect = 0.5,
	},
}
weapon_stamina_templates.shotpistol_shield_p1_m1 = {
	stamina_modifier = 4,
	sprint_cost_per_second = {
		lerp_basic = 2.5,
		lerp_perfect = 1.5,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 0.6,
			lerp_perfect = 0.2,
		},
		outer = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
	},
	block_cost_ranged = {
		inner = {
			lerp_basic = 0.3,
			lerp_perfect = 0.1,
		},
	},
	push_cost = {
		lerp_basic = 2,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.bot_linesman = {
	stamina_modifier = 8,
	sprint_cost_per_second = {
		lerp_basic = 1.25,
		lerp_perfect = 0.75,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 1,
			lerp_perfect = 0.5,
		},
		outer = {
			lerp_basic = 3,
			lerp_perfect = 1,
		},
	},
	push_cost = {
		lerp_basic = 3,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.powersword_p1_m2 = {
	stamina_modifier = 3,
	sprint_cost_per_second = {
		lerp_basic = 1.125,
		lerp_perfect = 0.375,
	},
	block_cost_default = _block_cost_default,
	push_cost = {
		lerp_basic = 3,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.tank_pickaxe_m1 = {
	stamina_modifier = 6,
	sprint_cost_per_second = {
		lerp_basic = 2.2,
		lerp_perfect = 1.1,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 1,
			lerp_perfect = 0.5,
		},
		outer = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
	},
	push_cost = {
		lerp_basic = 3,
		lerp_perfect = 1,
	},
}
weapon_stamina_templates.tank_pickaxe_m3 = {
	stamina_modifier = 6,
	sprint_cost_per_second = {
		lerp_basic = 1.8,
		lerp_perfect = 0.9,
	},
	block_cost_default = {
		inner = {
			lerp_basic = 1,
			lerp_perfect = 0.5,
		},
		outer = {
			lerp_basic = 2,
			lerp_perfect = 1,
		},
	},
	push_cost = {
		lerp_basic = 2,
		lerp_perfect = 0.6,
	},
}

return settings("WeaponStaminaTemplates", weapon_stamina_templates)
