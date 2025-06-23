-- chunkname: @scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_recoil_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_rippergun_assault = {
	still = {
		camera_recoil_percentage = 0.45,
		new_influence_percent = 0.35,
		rise_duration = 0.18,
		rise = {
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 0.3,
				lerp_basic = 0.2
			},
			idle = {
				lerp_perfect = 1,
				lerp_basic = 0.5
			}
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.4,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.22499999999999998,
					lerp_basic = 0.07500000000000001
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.15,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.1
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.04
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.1
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.1
				}
			}
		},
		offset_limit = {
			yaw = 1,
			pitch = 2
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 2,
			lerp_scalar = 0.5
		}
	},
	moving = {
		new_influence_percent = 0.4,
		inherits = {
			"default_rippergun_assault",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.4,
		inherits = {
			"default_rippergun_assault",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.4,
		inherits = {
			"default_rippergun_assault",
			"still"
		}
	}
}
recoil_templates.default_rippergun_spraynpray = {
	still = {
		camera_recoil_percentage = 0.25,
		new_influence_percent = 0.35,
		rise_duration = 0.175,
		rise = {
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.7
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.7
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.7
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.7
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.45
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.45
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.375
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.325
			},
			{
				lerp_perfect = 0.075,
				lerp_basic = 0.3
			},
			{
				lerp_perfect = 0.05,
				lerp_basic = 0.25
			},
			{
				lerp_perfect = 0.025,
				lerp_basic = 0.175
			}
		},
		decay = {
			shooting = 1,
			idle = 1.75
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.04
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0.001,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.05
				}
			},
			{
				pitch = {
					lerp_perfect = 0.001,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.05
				}
			},
			{
				pitch = {
					lerp_perfect = 0.001,
					lerp_basic = 0.015
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.05
				}
			},
			{
				pitch = {
					lerp_perfect = 0.001,
					lerp_basic = 0.01
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.05
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 2.25,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.35,
		inherits = {
			"default_rippergun_spraynpray",
			"still"
		},
		rise = {
			0.5,
			0.35,
			0.275,
			0.2
		}
	},
	crouch_still = {
		new_influence_percent = 0.3,
		inherits = {
			"default_rippergun_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.35,
		inherits = {
			"default_rippergun_spraynpray",
			"still"
		}
	}
}
recoil_templates.rippergun_p1_m2_assault = {
	still = {
		camera_recoil_percentage = 0.5,
		new_influence_percent = 0.75,
		rise_duration = 0.18,
		rise = {
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.3
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 0.3,
				lerp_basic = 0.2
			},
			idle = {
				lerp_perfect = 1,
				lerp_basic = 0.5
			}
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.4,
					lerp_basic = 0.15
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.22499999999999998,
					lerp_basic = 0.1275
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.15,
					lerp_basic = 0.11249999999999999
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.1
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.04
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.1
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.1
				}
			}
		},
		offset_limit = {
			yaw = 1,
			pitch = 2
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 0.5
		}
	},
	moving = {
		new_influence_percent = 0.75,
		inherits = {
			"rippergun_p1_m2_assault",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.75,
		inherits = {
			"rippergun_p1_m2_assault",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.75,
		inherits = {
			"rippergun_p1_m2_assault",
			"still"
		}
	}
}
recoil_templates.rippergun_p1_m2_spraynpray = {
	still = {
		camera_recoil_percentage = 0.5,
		new_influence_percent = 0.5,
		rise_duration = 0.175,
		rise = {
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.7
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.7
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.7
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.7
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.45
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.45
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.375
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.325
			},
			{
				lerp_perfect = 0.075,
				lerp_basic = 0.3
			},
			{
				lerp_perfect = 0.05,
				lerp_basic = 0.25
			},
			{
				lerp_perfect = 0.025,
				lerp_basic = 0.175
			}
		},
		decay = {
			shooting = 1,
			idle = 1.75
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.15
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.14
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.075
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0.001,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.05
				}
			},
			{
				pitch = {
					lerp_perfect = 0.001,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0.01,
					lerp_basic = 0.06
				}
			},
			{
				pitch = {
					lerp_perfect = 0.001,
					lerp_basic = 0.015
				},
				yaw = {
					lerp_perfect = 0.02,
					lerp_basic = 0.07
				}
			},
			{
				pitch = {
					lerp_perfect = 0.001,
					lerp_basic = 0.01
				},
				yaw = {
					lerp_perfect = 0.03,
					lerp_basic = 0.08
				}
			},
			{
				pitch = {
					lerp_perfect = 0.001,
					lerp_basic = 0.01
				},
				yaw = {
					lerp_perfect = 0.04,
					lerp_basic = 0.09
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 3.25,
			lerp_scalar = 0.5
		}
	},
	moving = {
		new_influence_percent = 0.5,
		inherits = {
			"rippergun_p1_m2_spraynpray",
			"still"
		},
		rise = {
			0.5,
			0.35,
			0.275,
			0.2
		}
	},
	crouch_still = {
		new_influence_percent = 0.5,
		inherits = {
			"rippergun_p1_m2_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.5,
		inherits = {
			"rippergun_p1_m2_spraynpray",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
