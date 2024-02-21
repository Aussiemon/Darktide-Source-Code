local AttackSettings = require("scripts/settings/damage/attack_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local shapes = WoundsSettings.shapes
local hit_zone_names = HitZone.hit_zone_names
local attack_results = AttackSettings.attack_results
local wounds_templates = {}
local laser_red = {
	1,
	0.09
}
local standard_ranged = {
	0.06,
	1
}
local standard_melee = {
	0.06,
	0
}
local force_teal = {
	0.53,
	0.7
}
local plasma_blue = {
	0.6,
	1
}
local energy_blue = {
	0.6,
	0.5
}
local electric_blue = {
	0.55,
	0.5
}
local smoldering_red = {
	0.02,
	0.8
}
local flash_quick = {
	0.35,
	0.35
}
local flash_slow = {
	0.5,
	0.6
}
local linger_light = {
	2.5,
	2.75
}
local linger_medium = {
	3.5,
	4
}
local linger_heavy = {
	5,
	6
}
wounds_templates.laser = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.lasgun,
			[shapes.lasgun] = {
				shape_scaling = false,
				radius = {
					0,
					5
				},
				color_brightness = laser_red,
				duration = linger_light
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.lasgun,
			[shapes.lasgun] = {
				shape_scaling = false,
				radius = {
					5,
					5.25
				},
				color_brightness = laser_red,
				duration = linger_medium
			}
		}
	}
}
wounds_templates.ballistic = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.lasgun,
			[shapes.lasgun] = {
				shape_scaling = false,
				radius = {
					2.25,
					2.5
				},
				color_brightness = standard_ranged,
				duration = flash_quick
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.lasgun,
			[shapes.lasgun] = {
				shape_scaling = false,
				radius = {
					2.25,
					2.5
				},
				color_brightness = standard_ranged,
				duration = flash_quick
			}
		}
	}
}
wounds_templates.stubber = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.lasgun,
			[shapes.lasgun] = {
				shape_scaling = false,
				radius = {
					2.25,
					2.5
				},
				color_brightness = standard_ranged,
				duration = flash_slow
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.lasgun,
			[shapes.lasgun] = {
				shape_scaling = false,
				radius = {
					2.25,
					5
				},
				color_brightness = standard_ranged,
				duration = flash_slow
			}
		}
	}
}
wounds_templates.plasma = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					3,
					5
				},
				color_brightness = plasma_blue,
				duration = linger_heavy
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					3,
					5
				},
				color_brightness = plasma_blue,
				duration = linger_heavy
			}
		}
	}
}
wounds_templates.pickaxe = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.sphere,
			[shapes.default] = {
				shape_scaling = true,
				radius = {
					1.5,
					2.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.sphere] = {
				shape_scaling = true,
				radius = {
					2,
					2.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = true,
				radius = {
					2,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.sphere] = {
				shape_scaling = true,
				radius = {
					5,
					5
				},
				color_brightness = standard_melee,
				duration = linger_heavy
			}
		}
	}
}
wounds_templates.force_projectile = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.sphere,
			[shapes.sphere] = {
				shape_scaling = false,
				radius = {
					3,
					5
				},
				color_brightness = force_teal,
				duration = linger_light
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.sphere,
			[shapes.sphere] = {
				shape_scaling = false,
				radius = {
					3,
					5
				},
				color_brightness = force_teal,
				duration = linger_light
			}
		}
	}
}
wounds_templates.chain_light = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					2.25,
					2.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					2.25,
					2.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					3.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					3.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash_coarse] = {
				shape_scaling = false,
				radius = {
					3.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash_coarse] = {
				shape_scaling = false,
				radius = {
					3.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	}
}
wounds_templates.chain_heavy = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					2.25,
					2.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					3.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					3.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash_coarse] = {
				shape_scaling = false,
				radius = {
					3.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash_coarse] = {
				shape_scaling = false,
				radius = {
					3.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					2.25,
					2.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					4.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					4.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash_coarse] = {
				shape_scaling = false,
				radius = {
					4.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash_coarse] = {
				shape_scaling = false,
				radius = {
					4.5,
					5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	}
}
wounds_templates.blunt = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					2.25,
					2.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					2.25,
					2.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	}
}
wounds_templates.shock_blunt = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					2,
					2
				},
				color_brightness = electric_blue,
				duration = flash_slow
			},
			[shapes.left_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2,
					2
				},
				color_brightness = electric_blue,
				duration = flash_slow
			},
			[shapes.right_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2,
					2
				},
				color_brightness = electric_blue,
				duration = flash_slow
			},
			[shapes.horizontal_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2,
					2
				},
				color_brightness = electric_blue,
				duration = flash_slow
			},
			[shapes.vertical_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2,
					2
				},
				color_brightness = electric_blue,
				duration = flash_slow
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					2,
					2
				},
				color_brightness = electric_blue,
				duration = flash_slow
			},
			[shapes.left_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2,
					2
				},
				color_brightness = electric_blue,
				duration = flash_slow
			},
			[shapes.right_45_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2,
					2
				},
				color_brightness = electric_blue,
				duration = flash_slow
			},
			[shapes.horizontal_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2,
					2
				},
				color_brightness = electric_blue,
				duration = flash_slow
			},
			[shapes.vertical_slash_coarse] = {
				shape_scaling = false,
				radius = {
					2,
					2
				},
				color_brightness = electric_blue,
				duration = flash_slow
			}
		}
	}
}
wounds_templates.slash = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					1.5,
					1.95
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash] = {
				shape_scaling = false,
				radius = {
					2.5,
					2.95
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash] = {
				shape_scaling = false,
				radius = {
					2.5,
					2.95
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash] = {
				shape_scaling = false,
				radius = {
					2.5,
					2.95
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash] = {
				shape_scaling = false,
				radius = {
					2.5,
					2.95
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash_clean] = {
				shape_scaling = false,
				radius = {
					2.5,
					2.95
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash_clean] = {
				shape_scaling = false,
				radius = {
					2.5,
					2.95
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash_clean] = {
				shape_scaling = false,
				radius = {
					2.5,
					2.95
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash_clean] = {
				shape_scaling = false,
				radius = {
					2.5,
					2.95
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					1,
					1.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash_clean] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash_clean] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash_clean] = {
				shape_scaling = false,
				radius = {
					2.5,
					2.75
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash_clean] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	}
}
wounds_templates.slash_large = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					2,
					2.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					2,
					2.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.left_45_slash] = {
				shape_scaling = false,
				radius = {
					4,
					4.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.right_45_slash] = {
				shape_scaling = false,
				radius = {
					4,
					4.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.horizontal_slash] = {
				shape_scaling = false,
				radius = {
					4,
					4.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			},
			[shapes.vertical_slash] = {
				shape_scaling = false,
				radius = {
					4,
					4.5
				},
				color_brightness = standard_melee,
				duration = flash_quick
			}
		}
	}
}
wounds_templates.energy_blunt = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = true,
				radius = {
					4,
					5
				},
				color_brightness = energy_blue,
				duration = linger_light
			},
			[shapes.left_45_slash_coarse] = {
				shape_scaling = true,
				radius = {
					4,
					5
				},
				color_brightness = energy_blue,
				duration = linger_light
			},
			[shapes.right_45_slash_coarse] = {
				shape_scaling = true,
				radius = {
					4,
					5
				},
				color_brightness = energy_blue,
				duration = linger_light
			},
			[shapes.horizontal_slash_coarse] = {
				shape_scaling = true,
				radius = {
					4,
					5
				},
				color_brightness = energy_blue,
				duration = linger_light
			},
			[shapes.vertical_slash_coarse] = {
				shape_scaling = true,
				radius = {
					4,
					5
				},
				color_brightness = energy_blue,
				duration = linger_light
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = true,
				radius = {
					4,
					5
				},
				color_brightness = energy_blue,
				duration = linger_light
			},
			[shapes.left_45_slash_coarse] = {
				shape_scaling = true,
				radius = {
					4,
					5
				},
				color_brightness = energy_blue,
				duration = linger_light
			},
			[shapes.right_45_slash_coarse] = {
				shape_scaling = true,
				radius = {
					4,
					5
				},
				color_brightness = energy_blue,
				duration = linger_light
			},
			[shapes.horizontal_slash_coarse] = {
				shape_scaling = true,
				radius = {
					4,
					5
				},
				color_brightness = energy_blue,
				duration = linger_light
			},
			[shapes.vertical_slash_coarse] = {
				shape_scaling = true,
				radius = {
					4,
					5
				},
				color_brightness = energy_blue,
				duration = linger_light
			}
		}
	}
}
wounds_templates.energy_slash = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					1,
					1.5
				},
				color_brightness = energy_blue,
				duration = flash_slow
			},
			[shapes.left_45_slash] = {
				shape_scaling = false,
				radius = {
					2,
					2.5
				},
				color_brightness = energy_blue,
				duration = flash_slow
			},
			[shapes.right_45_slash] = {
				shape_scaling = false,
				radius = {
					2,
					2.5
				},
				color_brightness = energy_blue,
				duration = flash_slow
			},
			[shapes.horizontal_slash] = {
				shape_scaling = false,
				radius = {
					2,
					2.5
				},
				color_brightness = energy_blue,
				duration = flash_slow
			},
			[shapes.vertical_slash] = {
				shape_scaling = false,
				radius = {
					2,
					2.5
				},
				color_brightness = energy_blue,
				duration = flash_slow
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					1,
					1.5
				},
				color_brightness = energy_blue,
				duration = flash_slow
			},
			[shapes.left_45_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = energy_blue,
				duration = flash_slow
			},
			[shapes.right_45_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = energy_blue,
				duration = flash_slow
			},
			[shapes.horizontal_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = energy_blue,
				duration = flash_slow
			},
			[shapes.vertical_slash] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = energy_blue,
				duration = flash_slow
			}
		}
	}
}
wounds_templates.slash_force = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					5,
					5.5
				},
				color_brightness = force_teal,
				duration = linger_heavy
			},
			[shapes.left_45_slash_clean] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = force_teal,
				duration = linger_heavy
			},
			[shapes.right_45_slash_clean] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = force_teal,
				duration = linger_heavy
			},
			[shapes.horizontal_slash_clean] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = force_teal,
				duration = linger_heavy
			},
			[shapes.vertical_slash_clean] = {
				shape_scaling = false,
				radius = {
					3,
					3.5
				},
				color_brightness = force_teal,
				duration = linger_heavy
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					5,
					5.5
				},
				color_brightness = force_teal,
				duration = linger_heavy
			},
			[shapes.left_45_slash_clean] = {
				shape_scaling = false,
				radius = {
					4,
					4.5
				},
				color_brightness = force_teal,
				duration = linger_heavy
			},
			[shapes.right_45_slash_clean] = {
				shape_scaling = false,
				radius = {
					4,
					4.5
				},
				color_brightness = force_teal,
				duration = linger_heavy
			},
			[shapes.horizontal_slash_clean] = {
				shape_scaling = false,
				radius = {
					4,
					4.5
				},
				color_brightness = force_teal,
				duration = linger_heavy
			},
			[shapes.vertical_slash_clean] = {
				shape_scaling = false,
				radius = {
					4,
					4.5
				},
				color_brightness = force_teal,
				duration = linger_heavy
			}
		}
	}
}
wounds_templates.shotgun_large = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.shotgun,
			[shapes.shotgun] = {
				shape_scaling = true,
				radius = {
					3,
					3.25
				},
				color_brightness = standard_ranged,
				duration = flash_slow
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.shotgun,
			[shapes.shotgun] = {
				shape_scaling = true,
				radius = {
					4.5,
					4.75
				},
				color_brightness = standard_ranged,
				duration = flash_slow
			}
		}
	}
}
wounds_templates.shotgun_small = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.shotgun,
			[shapes.shotgun] = {
				shape_scaling = true,
				radius = {
					2.5,
					3
				},
				color_brightness = standard_ranged,
				duration = flash_slow
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.shotgun,
			[shapes.shotgun] = {
				shape_scaling = true,
				radius = {
					3.75,
					4
				},
				color_brightness = standard_ranged,
				duration = flash_slow
			}
		}
	}
}
wounds_templates.boltshell = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.lasgun,
			[shapes.lasgun] = {
				shape_scaling = true,
				radius = {
					4,
					4
				},
				color_brightness = smoldering_red,
				duration = flash_slow
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.lasgun,
			[shapes.lasgun] = {
				shape_scaling = true,
				radius = {
					5,
					5
				},
				color_brightness = smoldering_red,
				duration = flash_slow
			}
		}
	}
}
wounds_templates.lasgun = table.clone(wounds_templates.laser)
wounds_templates.laspistol = table.clone(wounds_templates.laser)
wounds_templates.autogun = table.clone(wounds_templates.ballistic)
wounds_templates.autopistol = table.clone(wounds_templates.ballistic)
wounds_templates.stubrevolver = table.clone(wounds_templates.stubber)
wounds_templates.plasma_rifle = table.clone(wounds_templates.plasma)
wounds_templates.psyker_ball = table.clone(wounds_templates.force_projectile)
wounds_templates.chainsword_2h = table.clone(wounds_templates.chain_heavy)
wounds_templates.chainsword_sawing_2h = table.clone(wounds_templates.chain_heavy)
wounds_templates.chainsword = table.clone(wounds_templates.chain_light)
wounds_templates.chainsword_sawing = table.clone(wounds_templates.chain_light)
wounds_templates.chainaxe = table.clone(wounds_templates.chain_light)
wounds_templates.chainaxe_sawing = table.clone(wounds_templates.chain_light)
wounds_templates.thunder_hammer = table.clone(wounds_templates.blunt)
wounds_templates.thunder_hammer_active = table.clone(wounds_templates.energy_blunt)
wounds_templates.power_maul = table.clone(wounds_templates.shock_blunt)
wounds_templates.ogryn_power_maul = table.clone(wounds_templates.blunt)
wounds_templates.ogryn_power_maul_activated = table.clone(wounds_templates.energy_blunt)
wounds_templates.combat_sword = table.clone(wounds_templates.slash)
wounds_templates.power_sword = table.clone(wounds_templates.slash)
wounds_templates.power_sword_active = table.clone(wounds_templates.energy_slash)
wounds_templates.force_sword = table.clone(wounds_templates.slash)
wounds_templates.force_sword_active = table.clone(wounds_templates.slash_force)
wounds_templates.combat_knife = table.clone(wounds_templates.slash)
wounds_templates.combat_axe = table.clone(wounds_templates.slash)
wounds_templates.combat_blade = table.clone(wounds_templates.slash_large)
wounds_templates.rippergun = table.clone(wounds_templates.shotgun_large)
wounds_templates.shotgun = table.clone(wounds_templates.shotgun_small)
wounds_templates.bolter = table.clone(wounds_templates.boltshell)
wounds_templates.bayonet = table.clone(wounds_templates.slash)
wounds_templates.thumper_shotgun = table.clone(wounds_templates.shotgun_large)
wounds_templates.gauntlet_melee = table.clone(wounds_templates.blunt)
wounds_templates.ogryn_shovel = table.clone(wounds_templates.blunt)
wounds_templates.ogryn_club = table.clone(wounds_templates.blunt)
wounds_templates.heavy_stubber = table.clone(wounds_templates.stubber)
wounds_templates.shovel = table.clone(wounds_templates.blunt)

for template_name, template in pairs(wounds_templates) do
	template.name = template_name
end

return settings("WoundsTemplates", wounds_templates)
