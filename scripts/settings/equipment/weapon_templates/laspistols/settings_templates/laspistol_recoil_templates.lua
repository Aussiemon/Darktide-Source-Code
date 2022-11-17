local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_laspistol_assault = {
	still = {
		camera_recoil_percentage = 0.25,
		decay_grace = 0.125,
		rise_duration = 0.075,
		rise = {
			{
				lerp_perfect = 0.5,
				lerp_basic = 0.75
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = 0.75,
			idle = 2.25
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.005,
					lerp_basic = 0.01
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.005,
					lerp_basic = 0.01
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
					lerp_basic = 0.005
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.01
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.006
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.02
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.00625
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.03
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0065
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.045
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0065
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.055
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0065
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.065
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0065
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.075
				}
			}
		},
		offset_limit = {
			yaw = 0.25,
			pitch = 0.25
		},
		visual_recoil_settings = {
			intensity = 3,
			lerp_scalar = 1,
			yaw_intensity = 10
		},
		new_influence_percent = {
			lerp_perfect = 0.05,
			lerp_basic = 0.2
		}
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.06,
			lerp_basic = 0.12
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.05,
			lerp_basic = 0.1
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.075,
			lerp_basic = 0.125
		}
	}
}
local multi = 0.5
recoil_templates.default_laspistol_killshot = {
	still = {
		camera_recoil_percentage = 0.15,
		decay_grace = 0.05,
		new_influence_percent = 0.3,
		rise_duration = 0.1,
		rise = {
			{
				lerp_perfect = 0.27,
				lerp_basic = 0.75
			},
			{
				lerp_perfect = 0.25,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.23,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.3
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 1,
				lerp_basic = 0.25
			},
			idle = {
				lerp_perfect = 3,
				lerp_basic = 1.8
			}
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.07 * multi,
					lerp_perfect = 0.03 * multi
				},
				yaw = {
					lerp_basic = 0.03 * multi,
					lerp_perfect = 0.01 * multi
				}
			},
			{
				pitch = {
					lerp_basic = 0.05 * multi,
					lerp_perfect = 0.025 * multi
				},
				yaw = {
					lerp_basic = 0.03 * multi,
					lerp_perfect = 0.01 * multi
				}
			},
			{
				pitch = {
					lerp_basic = 0.03 * multi,
					lerp_perfect = 0.015 * multi
				},
				yaw = {
					lerp_basic = 0.03 * multi,
					lerp_perfect = 0.01 * multi
				}
			},
			{
				pitch = {
					lerp_basic = 0.02 * multi,
					lerp_perfect = 0.01 * multi
				},
				yaw = {
					lerp_basic = 0.02 * multi,
					lerp_perfect = 0.005 * multi
				}
			},
			{
				pitch = {
					lerp_basic = 0.015 * multi,
					lerp_perfect = 0.01 * multi
				},
				yaw = {
					lerp_basic = 0.01 * multi,
					lerp_perfect = 0 * multi
				}
			},
			{
				pitch = {
					lerp_basic = 0.01 * multi,
					lerp_perfect = 0.0075 * multi
				},
				yaw = {
					lerp_basic = 0.005 * multi,
					lerp_perfect = 0 * multi
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.02
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.025
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.03
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.035
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.035
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.04
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.04
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.03
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
			intensity = 3.3,
			lerp_scalar = 0.8,
			yaw_intensity = 3.1
		}
	},
	moving = {
		new_influence_percent = 0.3,
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.26,
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.35,
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	}
}
local multi_2 = 1.5
recoil_templates.default_laspistol_bfg = {
	still = {
		camera_recoil_percentage = 0.15,
		decay_grace = 0.05,
		new_influence_percent = 0.3,
		rise_duration = 0.05,
		rise = {
			{
				lerp_perfect = 0.27,
				lerp_basic = 0.95
			},
			{
				lerp_perfect = 0.25,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.23,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.3
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 1,
				lerp_basic = 0.25
			},
			idle = {
				lerp_perfect = 3,
				lerp_basic = 1.8
			}
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.07 * multi_2,
					lerp_perfect = 0.03 * multi_2
				},
				yaw = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.01 * multi_2
				}
			},
			{
				pitch = {
					lerp_basic = 0.05 * multi_2,
					lerp_perfect = 0.025 * multi_2
				},
				yaw = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.01 * multi_2
				}
			},
			{
				pitch = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.015 * multi_2
				},
				yaw = {
					lerp_basic = 0.03 * multi_2,
					lerp_perfect = 0.01 * multi_2
				}
			},
			{
				pitch = {
					lerp_basic = 0.02 * multi_2,
					lerp_perfect = 0.01 * multi_2
				},
				yaw = {
					lerp_basic = 0.02 * multi_2,
					lerp_perfect = 0.005 * multi_2
				}
			},
			{
				pitch = {
					lerp_basic = 0.015 * multi_2,
					lerp_perfect = 0.01 * multi_2
				},
				yaw = {
					lerp_basic = 0.01 * multi_2,
					lerp_perfect = 0 * multi_2
				}
			},
			{
				pitch = {
					lerp_basic = 0.01 * multi_2,
					lerp_perfect = 0.0075 * multi_2
				},
				yaw = {
					lerp_basic = 0.005 * multi,
					lerp_perfect = 0 * multi
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.02
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.025
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.03
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.035
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.035
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.04
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.04
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.03
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
			intensity = 4.1,
			lerp_scalar = 0.8,
			yaw_intensity = 3.9
		}
	},
	moving = {
		new_influence_percent = 0.2,
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.26,
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.35,
		inherits = {
			"default_laspistol_killshot",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
