local HitZone = require("scripts/utilities/attack/hit_zone")
local hit_zone_names = HitZone.hit_zone_names
local stagger_overrides = table.enum("up", "down", "left", "right", "push", "pull", "lookat", "forced_lookat")
local herding_templates = {
	shot = {
		stagger = {
			override = stagger_overrides.push
		},
		push_ragdoll = {
			custom_vector = {
				0,
				0,
				1
			}
		}
	},
	shotgun = {
		stagger = {
			override = stagger_overrides.push
		},
		push_ragdoll = {
			custom_vector = {
				0.1,
				0.5,
				0.75
			}
		}
	},
	uppercut = {
		stagger = {
			override = stagger_overrides.push
		},
		push_ragdoll = {
			custom_vector = {
				0.1,
				0.25,
				1
			}
		}
	},
	force_push = {
		stagger = {
			override = stagger_overrides.forced_lookat
		},
		push_ragdoll = {
			custom_vector = {
				0.1,
				0.25,
				1
			}
		}
	},
	stab = {
		stagger = {
			override = stagger_overrides.push
		},
		push_ragdoll = {
			custom_vector = {
				0,
				1,
				0.5
			}
		}
	},
	smiter_down = {
		stagger = {
			override = stagger_overrides.down
		},
		push_ragdoll = {
			custom_vector = {
				0,
				0.5,
				-1
			}
		}
	},
	thunder_hammer_right_down_light = {
		stagger = {
			override = stagger_overrides.down
		},
		push_ragdoll = {
			custom_vector = {
				0,
				0.5,
				-1
			}
		}
	},
	thunder_hammer_left_down_light = {
		stagger = {
			override = stagger_overrides.down
		},
		push_ragdoll = {
			custom_vector = {
				0,
				0.5,
				-1
			}
		}
	},
	thunder_hammer_left_heavy = {
		stagger = {
			override = stagger_overrides.lookat
		},
		push_ragdoll = {
			custom_vector = {
				0.5,
				0.5,
				0.5
			}
		}
	},
	thunder_hammer_right_heavy = {
		stagger = {
			override = stagger_overrides.lookat
		},
		push_ragdoll = {
			custom_vector = {
				0.5,
				0.5,
				0.5
			}
		}
	},
	linesman_left_heavy = {
		stagger = {
			override = stagger_overrides.left
		},
		push_ragdoll = {
			custom_vector = {
				-0.5,
				1,
				0.5
			}
		}
	},
	linesman_right_heavy = {
		stagger = {
			override = stagger_overrides.right
		},
		push_ragdoll = {
			custom_vector = {
				0.5,
				1,
				-0.5
			}
		}
	},
	ogryn_punch = {
		stagger = {
			override = stagger_overrides.push
		},
		push_ragdoll = {
			custom_vector = {
				1,
				5,
				4
			}
		}
	},
	linesman_left_heavy_inverted = {
		stagger = {
			override = stagger_overrides.left
		},
		push_ragdoll = {
			custom_vector = {
				0,
				-1,
				0.1
			}
		}
	},
	linesman_right_heavy_inverted = {
		stagger = {
			override = stagger_overrides.right
		},
		push_ragdoll = {
			custom_vector = {
				0,
				-1,
				0.1
			}
		}
	}
}

for template_name, template in pairs(herding_templates) do
	template.name = template_name
end

return settings("HerdingTemplates", herding_templates)
