local weapon_stamina_templates = {}
local _block_cost_default = {
	inner = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	outer = {
		lerp_perfect = 1,
		lerp_basic = 3
	}
}
weapon_stamina_templates.default = {
	stamina_modifier = 4,
	sprint_cost_per_second = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	block_cost_default = _block_cost_default,
	push_cost = {
		lerp_perfect = 1,
		lerp_basic = 3
	}
}
weapon_stamina_templates.smiter = {
	stamina_modifier = 3,
	sprint_cost_per_second = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	block_cost_default = _block_cost_default,
	push_cost = {
		lerp_perfect = 1,
		lerp_basic = 3
	}
}
weapon_stamina_templates.linesman = {
	stamina_modifier = 4,
	sprint_cost_per_second = {
		lerp_perfect = 0.75,
		lerp_basic = 1.25
	},
	block_cost_default = {
		inner = {
			lerp_perfect = 0.5,
			lerp_basic = 1
		},
		outer = {
			lerp_perfect = 1,
			lerp_basic = 3
		}
	},
	push_cost = {
		lerp_perfect = 1,
		lerp_basic = 3
	}
}
weapon_stamina_templates.tank = {
	stamina_modifier = 6,
	sprint_cost_per_second = {
		lerp_perfect = 1,
		lerp_basic = 2
	},
	block_cost_default = {
		inner = {
			lerp_perfect = 0.5,
			lerp_basic = 1
		},
		outer = {
			lerp_perfect = 1,
			lerp_basic = 2
		}
	},
	push_cost = {
		lerp_perfect = 0.75,
		lerp_basic = 2.25
	}
}
weapon_stamina_templates.ninjafencer = {
	stamina_modifier = 1,
	sprint_cost_per_second = {
		lerp_perfect = 0.5,
		lerp_basic = 1
	},
	block_cost_default = {
		inner = {
			lerp_perfect = 0.25,
			lerp_basic = 0.75
		},
		outer = {
			lerp_perfect = 0.5,
			lerp_basic = 1
		}
	},
	push_cost = {
		lerp_perfect = 0.75,
		lerp_basic = 1.25
	}
}
weapon_stamina_templates.combat_knife_p1 = {
	stamina_modifier = 1,
	sprint_cost_per_second = {
		lerp_perfect = 0.25,
		lerp_basic = 0.75
	},
	block_cost_default = {
		inner = {
			lerp_perfect = 0.25,
			lerp_basic = 0.75
		},
		outer = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		}
	},
	push_cost = {
		lerp_perfect = 0.75,
		lerp_basic = 1.25
	}
}
weapon_stamina_templates.luggable = {
	stamina_modifier = 2,
	sprint_cost_per_second = {
		lerp_perfect = 2,
		lerp_basic = 2
	},
	block_cost_default = {
		inner = {
			lerp_perfect = 1,
			lerp_basic = 2
		},
		outer = {
			lerp_perfect = 1,
			lerp_basic = 2
		}
	},
	push_cost = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	}
}
weapon_stamina_templates.lasrifle = {
	stamina_modifier = 2,
	sprint_cost_per_second = {
		lerp_perfect = 1.5,
		lerp_basic = 2
	},
	block_cost_default = {
		inner = {
			lerp_perfect = 1,
			lerp_basic = 2
		},
		outer = {
			lerp_perfect = 1,
			lerp_basic = 2
		}
	},
	push_cost = {
		lerp_perfect = 0.5,
		lerp_basic = 1
	}
}
weapon_stamina_templates.thunderhammer_2h_p1_m1 = {
	stamina_modifier = 3,
	sprint_cost_per_second = {
		lerp_perfect = 1.5,
		lerp_basic = 2
	},
	block_cost_default = {
		inner = {
			lerp_perfect = 1,
			lerp_basic = 2
		},
		outer = {
			lerp_perfect = 2,
			lerp_basic = 4
		}
	},
	push_cost = {
		lerp_perfect = 1,
		lerp_basic = 3
	}
}
weapon_stamina_templates.forcesword_p1_m1 = {
	block_break_disorientation_type = "heavy",
	stamina_modifier = 2,
	sprint_cost_per_second = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	block_cost_default = {
		innner = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		},
		outer = {
			lerp_perfect = 1,
			lerp_basic = 2
		}
	},
	block_cost_ranged = {
		inner = {
			lerp_perfect = 0.25,
			lerp_basic = 0.75
		}
	},
	push_cost = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	}
}
weapon_stamina_templates.ogryn_powermaul_slabshield_p1_m1 = {
	stamina_modifier = 3,
	sprint_cost_per_second = {
		lerp_perfect = 1.5,
		lerp_basic = 3.5
	},
	block_cost_default = {
		inner = {
			lerp_perfect = 0.2,
			lerp_basic = 0.6
		},
		outer = {
			lerp_perfect = 1,
			lerp_basic = 2
		}
	},
	block_cost_ranged = {
		inner = {
			lerp_perfect = 0.1,
			lerp_basic = 0.3
		}
	},
	push_cost = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	}
}

return settings("WeaponStaminaTemplates", weapon_stamina_templates)
