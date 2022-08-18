local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local WeaponTweaks = require("scripts/utilities/weapon_tweaks")
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states
local still = weapon_movement_states.still
local moving = weapon_movement_states.moving
local crouch_still = weapon_movement_states.crouch_still
local crouch_moving = weapon_movement_states.crouch_moving
local spread_templates = {}
local loaded_template_files = {}

WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autopistols/settings_templates/autopistol_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/flamers/settings_templates/flamer_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/force_staffs/settings_templates/force_staff_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_spread_templates", spread_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/stub_rifles/settings_templates/stub_rifle_spread_templates", spread_templates, loaded_template_files)

spread_templates.no_spread = {
	[still] = {
		max_spread = {
			yaw = 0,
			pitch = 0
		},
		decay = {
			from_shooting_grace_time = 0,
			shooting = {
				yaw = 0,
				pitch = 0
			},
			idle = {
				yaw = 0,
				pitch = 0
			}
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		},
		immediate_spread = {
			num_shots_clear_time = 0,
			suppression_hit = {
				{
					yaw = 0,
					pitch = 0
				}
			},
			damage_hit = {
				{
					yaw = 0,
					pitch = 0
				}
			},
			shooting = {
				{
					yaw = 0,
					pitch = 0
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"no_spread",
			still
		}
	},
	[crouch_still] = {
		inherits = {
			"no_spread",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"no_spread",
			still
		}
	}
}
spread_templates.plasma_rifle = {
	charge_scale = {
		max_yaw = 0.2,
		max_pitch = 0.2
	},
	[still] = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 1,
				pitch = 1
			},
			idle = {
				yaw = 2,
				pitch = 2
			}
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.15,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 2.5,
					pitch = 2.5
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.4,
					pitch = 0.4
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"plasma_rifle",
			still
		}
	},
	[crouch_still] = {
		inherits = {
			"plasma_rifle",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"plasma_rifle",
			still
		}
	}
}
spread_templates.plasma_rifle_charged = {
	charge_scale = {
		max_yaw = 0.25,
		max_pitch = 0.25
	},
	[still] = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 2.5,
			min_pitch = 2.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 2.5,
					pitch = 2.5
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"plasma_rifle_charged",
			still
		}
	},
	[crouch_still] = {
		inherits = {
			"plasma_rifle_charged",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"plasma_rifle_charged",
			still
		}
	}
}
spread_templates.lasgun = {
	[still] = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 1,
				pitch = 1
			},
			idle = {
				yaw = 4,
				pitch = 4
			}
		},
		continuous_spread = {
			min_yaw = 1,
			min_pitch = 1
		},
		immediate_spread = {
			num_shots_clear_time = 0.15,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.4,
					pitch = 0.4
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"lasgun",
			still
		},
		continuous_spread = {
			min_yaw = 1.2,
			min_pitch = 1.2
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"lasgun",
			still
		}
	}
}
spread_templates.lasgun_assault = {
	[still] = {
		max_spread = {
			yaw = 5,
			pitch = 4
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.25,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 3,
			min_pitch = 3
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"lasgun_assault",
			still
		},
		continuous_spread = {
			min_yaw = 3.5,
			min_pitch = 3.5
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun_assault",
			still
		},
		continuous_spread = {
			min_yaw = 1.15,
			min_pitch = 1.15
		}
	},
	[crouch_moving] = {
		inherits = {
			"lasgun_assault",
			still
		},
		continuous_spread = {
			min_yaw = 2,
			min_pitch = 2
		}
	}
}
spread_templates.lasgun_reload = {
	[still] = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.25,
				pitch = 1.25
			}
		},
		continuous_spread = {
			min_yaw = 1.25,
			min_pitch = 1.25
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.35,
					pitch = 0.35
				},
				{
					yaw = 0.4,
					pitch = 0.4
				},
				{
					yaw = 0.45,
					pitch = 0.42
				},
				{
					yaw = 0.5,
					pitch = 0.44
				},
				{
					yaw = 0.55,
					pitch = 0.46
				}
			}
		},
		visual_spread_settings = {
			intensity = 0.5,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 3,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	[moving] = {
		inherits = {
			"lasgun_assault",
			still
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun_assault",
			still
		},
		continuous_spread = {
			min_yaw = 0.75,
			min_pitch = 0.75
		}
	},
	[crouch_moving] = {
		inherits = {
			"lasgun_assault",
			still
		},
		continuous_spread = {
			min_yaw = 1.2,
			min_pitch = 1.2
		}
	}
}
spread_templates.autogun_assault = {
	[still] = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.25,
				pitch = 1.25
			}
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.55,
					pitch = 0.55
				},
				{
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 0.25,
					pitch = 0.25
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"autogun_assault",
			still
		},
		continuous_spread = {
			min_yaw = 1.75,
			min_pitch = 1.75
		}
	},
	[crouch_still] = {
		inherits = {
			"autogun_assault",
			still
		},
		continuous_spread = {
			min_yaw = 1.3,
			min_pitch = 1.3
		}
	},
	[crouch_moving] = {
		inherits = {
			"autogun_assault",
			still
		},
		continuous_spread = {
			min_yaw = 1.6,
			min_pitch = 1.6
		}
	}
}
spread_templates.autogun_killshot = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.25,
				pitch = 1.25
			}
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 1.5,
					pitch = 1.5
				},
				{
					yaw = 1.25,
					pitch = 1.25
				},
				{
					yaw = 1,
					pitch = 1
				}
			}
		}
	},
	moving = {
		inherits = {
			"autogun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.75,
			min_pitch = 1.75
		}
	},
	crouch_still = {
		inherits = {
			"autogun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.3,
			min_pitch = 1.3
		}
	},
	crouch_moving = {
		inherits = {
			"autogun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.6,
			min_pitch = 1.6
		}
	}
}
spread_templates.autogun_zoomed = {
	still = {
		max_spread = {
			yaw = 2.5,
			pitch = 2.5
		},
		decay = {
			from_shooting_grace_time = 0.15,
			enter_alternate_fire_grace_time = 0.5,
			crouch_transition_grace_time = 0.5,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			},
			player_event = {
				yaw = 4,
				pitch = 4
			}
		},
		continuous_spread = {
			min_yaw = 0.01,
			min_pitch = 0.01
		},
		immediate_spread = {
			num_shots_clear_time = 0.4,
			alternate_fire_start = {
				{
					yaw = 2,
					pitch = 2
				}
			},
			crouching_transition = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			suppression_hit = {
				{
					yaw = 1,
					pitch = 1
				}
			},
			damage_hit = {
				{
					yaw = 1,
					pitch = 1
				}
			},
			shooting = {
				{
					yaw = 0.05,
					pitch = 0.05
				},
				{
					yaw = 0.1,
					pitch = 0.1
				}
			}
		},
		visual_spread_settings = {
			intensity = 0.4,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 1,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	moving = {
		inherits = {
			"autogun_zoomed",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.15,
			min_pitch = 0.15
		},
		decay = {
			from_shooting_grace_time = 0.15,
			enter_alternate_fire_grace_time = 0.5,
			crouch_transition_grace_time = 0.5,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			},
			player_event = {
				yaw = 3,
				pitch = 3
			}
		},
		visual_spread_settings = {
			intensity = 0.5,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 2,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	crouch_still = {
		inherits = {
			"autogun_zoomed",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.25,
			min_pitch = 0.25
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.75,
				pitch = 1.75
			}
		}
	},
	crouch_moving = {
		continuous_spread = {
			min_yaw = 0.65,
			min_pitch = 0.65
		},
		inherits = {
			"autogun_zoomed",
			"still"
		}
	}
}
spread_templates.autopistol = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.25,
				pitch = 1.25
			}
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.3,
					pitch = 0.3
				},
				{
					yaw = 0.4,
					pitch = 0.4
				},
				{
					yaw = 0.5,
					pitch = 0.5
				}
			}
		}
	},
	moving = {
		inherits = {
			"autopistol",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.75,
			min_pitch = 1.75
		}
	},
	crouch_still = {
		inherits = {
			"autopistol",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.3,
			min_pitch = 1.3
		}
	},
	crouch_moving = {
		inherits = {
			"autopistol",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.6,
			min_pitch = 1.6
		}
	}
}
spread_templates.shotgun_hip_assault = {
	[still] = {
		max_spread = {
			yaw = 3.5,
			pitch = 3.5
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 1.25,
			min_pitch = 1.25
		},
		start_spread = {
			start_yaw = 2.75,
			start_pitch = 2.75
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 1.5,
					pitch = 1.5
				}
			},
			shooting = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"shotgun_hip_assault",
			still
		}
	},
	[crouch_still] = {
		inherits = {
			"shotgun_hip_assault",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"shotgun_hip_assault",
			still
		}
	}
}
spread_templates.rippergun_hip_assault = {
	[still] = {
		max_spread = {
			yaw = 6.5,
			pitch = 6.5
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 0.25,
			min_pitch = 0.25
		},
		start_spread = {
			start_yaw = 0.25,
			start_pitch = 0.25
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 1.5,
					pitch = 1.5
				}
			},
			shooting = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"rippergun_hip_assault",
			still
		}
	},
	[crouch_still] = {
		inherits = {
			"rippergun_hip_assault",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"rippergun_hip_assault",
			still
		}
	}
}
spread_templates.lasgun_hip_killshot = {
	[still] = {
		max_spread = {
			yaw = 3.75,
			pitch = 3.25
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 0.75,
			min_pitch = 0.75
		},
		start_spread = {
			start_yaw = 1,
			start_pitch = 1
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 1.5,
					pitch = 1.5
				}
			},
			shooting = {
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.4,
					pitch = 0.4
				},
				{
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 0.55,
					pitch = 0.5
				},
				{
					yaw = 0.6,
					pitch = 0.5
				},
				{
					yaw = 0.65,
					pitch = 0.5
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"lasgun_hip_killshot",
			still
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 1.5,
					pitch = 1.5
				}
			},
			shooting = {
				{
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 0.65,
					pitch = 0.65
				},
				{
					yaw = 0.85,
					pitch = 0.75
				}
			}
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun_hip_killshot",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"lasgun_hip_killshot",
			still
		}
	}
}
spread_templates.lasgun_hip_killshot_medium = {
	[still] = {
		max_spread = {
			yaw = 3.75,
			pitch = 3.75
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 1,
			min_pitch = 1
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 1.5,
					pitch = 1.5
				}
			},
			shooting = {
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.4,
					pitch = 0.4
				},
				{
					yaw = 1.5,
					pitch = 1.5
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"lasgun_hip_killshot_medium",
			still
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 1.5,
					pitch = 1.5
				}
			},
			shooting = {
				{
					yaw = 0.4,
					pitch = 0.4
				},
				{
					yaw = 0.7,
					pitch = 0.7
				},
				{
					yaw = 1.5,
					pitch = 1.5
				}
			}
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun_hip_killshot_medium",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"lasgun_hip_killshot_medium",
			still
		}
	}
}
spread_templates.shotgun = {
	[still] = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 2,
			min_pitch = 2
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 1.5,
					pitch = 1.5
				}
			},
			shooting = {
				{
					yaw = 1.25,
					pitch = 1
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"shotgun",
			still
		}
	},
	[crouch_still] = {
		inherits = {
			"shotgun",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"shotgun",
			still
		}
	}
}
spread_templates.laspistol_assault = {
	[still] = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 1,
				pitch = 1
			},
			idle = {
				yaw = 2.5,
				pitch = 2.5
			}
		},
		continuous_spread = {
			min_yaw = 0.4,
			min_pitch = 0.4
		},
		immediate_spread = {
			num_shots_clear_time = 0.4,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 5,
					pitch = 5
				}
			},
			shooting = {
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.4,
					pitch = 0.4
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 1.25,
					pitch = 1
				},
				{
					yaw = 1.75,
					pitch = 1.5
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"laspistol_assault",
			still
		},
		continuous_spread = {
			min_yaw = 0.6,
			min_pitch = 0.6
		}
	},
	[crouch_still] = {
		inherits = {
			"laspistol_assault",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"laspistol_assault",
			still
		}
	}
}
local pitch_spread = 0.8
local yaw_spread = pitch_spread * 1
spread_templates.lasgun_brace = {
	[still] = {
		max_spread = {
			yaw = 13,
			pitch = 10
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 2,
			min_pitch = 2
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4
				},
				{
					pitch = pitch_spread * 0.45,
					yaw = yaw_spread * 0.45
				},
				{
					pitch = pitch_spread * 0.5,
					yaw = yaw_spread * 0.5
				},
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4
				},
				{
					pitch = pitch_spread * 0.3,
					yaw = yaw_spread * 0.3
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"lasgun_brace",
			still
		},
		continuous_spread = {
			min_yaw = 2.1,
			min_pitch = 2.1
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					pitch = pitch_spread * 1,
					yaw = yaw_spread * 1
				},
				{
					pitch = pitch_spread * 0.75,
					yaw = yaw_spread * 0.75
				},
				{
					pitch = pitch_spread * 0.5,
					yaw = yaw_spread * 0.5
				},
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4
				},
				{
					pitch = pitch_spread * 0.3,
					yaw = yaw_spread * 0.3
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				}
			}
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun_brace",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"lasgun_brace",
			still
		}
	}
}
pitch_spread = 0.5
yaw_spread = pitch_spread * 1.25
spread_templates.lasgun_brace_light = {
	randomized_spread = {
		first_shot_min_ratio = 0.25,
		max_yaw_delta = 1.5,
		first_shot_random_ratio = 0.4,
		random_ratio = 0.75,
		max_pitch_delta = 2,
		min_ratio = 0.25
	},
	[still] = {
		max_spread = {
			yaw = 5,
			pitch = 5
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				yaw = 0.1,
				pitch = 0.1
			},
			idle = {
				yaw = 0.75,
				pitch = 0.75
			}
		},
		continuous_spread = {
			min_yaw = 0.8,
			min_pitch = 0.65
		},
		start_spread = {
			start_yaw = 1.25,
			start_pitch = 1
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					pitch = pitch_spread * 0.75,
					yaw = yaw_spread * 0.75
				},
				{
					pitch = pitch_spread * 0.85,
					yaw = yaw_spread * 0.85
				},
				{
					pitch = pitch_spread * 0.65,
					yaw = yaw_spread * 0.65
				},
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4
				},
				{
					pitch = pitch_spread * 0.3,
					yaw = yaw_spread * 0.3
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"lasgun_brace_light",
			still
		},
		continuous_spread = {
			min_yaw = 1,
			min_pitch = 0.8
		},
		start_spread = {
			start_yaw = 1.2,
			start_pitch = 1
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					pitch = pitch_spread * 0.75,
					yaw = yaw_spread * 0.75
				},
				{
					pitch = pitch_spread * 0.85,
					yaw = yaw_spread * 0.85
				},
				{
					pitch = pitch_spread * 0.65,
					yaw = yaw_spread * 0.65
				},
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4
				},
				{
					pitch = pitch_spread * 0.3,
					yaw = yaw_spread * 0.3
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				}
			}
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun_brace_light",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"lasgun_brace_light",
			still
		}
	}
}
spread_templates.lasgun_zoomed = {
	[still] = {
		max_spread = {
			yaw = 2.5,
			pitch = 2.5
		},
		decay = {
			from_shooting_grace_time = 0.15,
			enter_alternate_fire_grace_time = 0.5,
			crouch_transition_grace_time = 0.5,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			},
			player_event = {
				yaw = 4,
				pitch = 4
			}
		},
		continuous_spread = {
			min_yaw = 0.01,
			min_pitch = 0.01
		},
		immediate_spread = {
			num_shots_clear_time = 0.6,
			alternate_fire_start = {
				{
					yaw = 2,
					pitch = 2
				}
			},
			crouching_transition = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 1,
					pitch = 1
				}
			},
			shooting = {
				{
					yaw = 0.05,
					pitch = 0.05
				},
				{
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.125,
					pitch = 0.125
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.175,
					pitch = 0.175
				}
			}
		},
		visual_spread_settings = {
			intensity = 0.4,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 1,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	[moving] = {
		inherits = {
			"lasgun_zoomed",
			still
		},
		continuous_spread = {
			min_yaw = 0.15,
			min_pitch = 0.15
		},
		decay = {
			from_shooting_grace_time = 0.15,
			enter_alternate_fire_grace_time = 0.5,
			crouch_transition_grace_time = 0.5,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			},
			player_event = {
				yaw = 3,
				pitch = 3
			}
		},
		visual_spread_settings = {
			intensity = 0.5,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 2,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun_zoomed",
			still
		},
		continuous_spread = {
			min_yaw = 0.25,
			min_pitch = 0.25
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.75,
				pitch = 1.75
			}
		}
	},
	[crouch_moving] = {
		continuous_spread = {
			min_yaw = 0.65,
			min_pitch = 0.65
		},
		inherits = {
			"lasgun_zoomed",
			still
		}
	}
}
spread_templates.lasgun_zoomed_2 = table.clone(spread_templates.lasgun_zoomed)
spread_templates.lasgun_zoomed_2.still.continuous_spread = {
	min_yaw = 0,
	min_pitch = 0
}
spread_templates.lasgun_zoomed_2.moving.continuous_spread = {
	min_yaw = 0,
	min_pitch = 0
}
spread_templates.lasgun_zoomed_2.still.shooting = {
	{
		yaw = 0.05,
		pitch = 0.05
	},
	{
		yaw = 0.16000000000000003,
		pitch = 0.16000000000000003
	},
	{
		yaw = 0.2,
		pitch = 0.2
	},
	{
		yaw = 0.24,
		pitch = 0.24
	},
	{
		yaw = 0.27999999999999997,
		pitch = 0.27999999999999997
	}
}
spread_templates.lasgun_zoomed_2.moving.shooting = {
	{
		yaw = 0.16000000000000003,
		pitch = 0.16000000000000003
	},
	{
		yaw = 0.2,
		pitch = 0.2
	},
	{
		yaw = 0.24,
		pitch = 0.24
	},
	{
		yaw = 0.27999999999999997,
		pitch = 0.27999999999999997
	}
}
spread_templates.lasgun_zoomed_1 = table.clone(spread_templates.lasgun_zoomed)
spread_templates.lasgun_zoomed_1.still.num_shots_clear_time = 0.45
spread_templates.lasgun_zoomed_1.still.decay = {
	from_shooting_grace_time = 0.15,
	shooting = {
		yaw = 0.5,
		pitch = 0.5
	},
	idle = {
		yaw = 2.5,
		pitch = 2.5
	}
}
spread_templates.lasgun_zoomed_medium = {
	[still] = {
		inherits = {
			"lasgun_zoomed",
			still
		},
		continuous_spread = {
			min_yaw = 0.05,
			min_pitch = 0.05
		},
		visual_spread_settings = {
			intensity = 0.2,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 3,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	[moving] = {
		inherits = {
			"lasgun_zoomed",
			still
		},
		continuous_spread = {
			min_yaw = 0.05,
			min_pitch = 0.05
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 3,
				pitch = 3
			}
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.3,
					pitch = 0.3
				}
			},
			damage_hit = {
				{
					yaw = 0.75,
					pitch = 0.75
				}
			},
			shooting = {
				{
					yaw = 0.2,
					pitch = 0.2
				},
				{
					yaw = 0.4,
					pitch = 0.4
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.7,
					pitch = 0.7
				},
				{
					yaw = 0.725,
					pitch = 0.725
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.775,
					pitch = 0.775
				},
				{
					yaw = 0.7999999999999999,
					pitch = 0.7999999999999999
				}
			}
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun_zoomed",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"lasgun_zoomed",
			still
		}
	}
}
spread_templates.lasgun_pistol_zoomed = {
	[still] = {
		max_spread = {
			yaw = 6,
			pitch = 6
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 2,
				pitch = 2
			}
		},
		continuous_spread = {
			min_yaw = 0.25,
			min_pitch = 0.25
		},
		immediate_spread = {
			num_shots_clear_time = 0.4,
			suppression_hit = {
				{
					yaw = 0.2,
					pitch = 0.2
				}
			},
			damage_hit = {
				{
					yaw = 1.2,
					pitch = 1.2
				}
			},
			shooting = {
				{
					yaw = 0.35,
					pitch = 0.35
				},
				{
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 1,
					pitch = 1
				},
				{
					yaw = 1,
					pitch = 1
				},
				{
					yaw = 1.5,
					pitch = 1.5
				}
			}
		},
		visual_spread_settings = {
			intensity = 0.5,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 4,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	[moving] = {
		inherits = {
			"lasgun_pistol_zoomed",
			still
		},
		continuous_spread = {
			min_yaw = 0.6,
			min_pitch = 0.6
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun_pistol_zoomed",
			still
		},
		continuous_spread = {
			min_yaw = 0.2,
			min_pitch = 0.2
		}
	},
	[crouch_moving] = {
		inherits = {
			"lasgun_pistol_zoomed",
			still
		},
		continuous_spread = {
			min_yaw = 0.5,
			min_pitch = 0.5
		}
	}
}
spread_templates.lasgun_bfg_charge = {
	charge_scale = {
		max_yaw = 0.2,
		max_pitch = 0.2
	},
	[still] = {
		max_spread = {
			yaw = 15,
			pitch = 15
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				yaw = 0.75,
				pitch = 0.75
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 1,
			min_pitch = 1
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 2.5,
					pitch = 2.5
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"lasgun_bfg_charge",
			still
		},
		continuous_spread = {
			min_yaw = 2.5,
			min_pitch = 2.5
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 3,
				pitch = 3
			}
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.3,
					pitch = 0.3
				}
			},
			damage_hit = {
				{
					yaw = 0.75,
					pitch = 0.75
				}
			},
			shooting = {
				{
					yaw = 0.2,
					pitch = 0.2
				},
				{
					yaw = 0.4,
					pitch = 0.4
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.7,
					pitch = 0.7
				},
				{
					yaw = 0.725,
					pitch = 0.725
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.775,
					pitch = 0.775
				},
				{
					yaw = 0.7999999999999999,
					pitch = 0.7999999999999999
				}
			}
		}
	},
	[crouch_still] = {
		inherits = {
			"lasgun_bfg_charge",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"lasgun_bfg_charge",
			still
		}
	}
}
spread_templates.boltgun_hip_spray_n_pray = {
	[still] = {
		max_spread = {
			yaw = 10,
			pitch = 10
		},
		decay = {
			from_shooting_grace_time = 0.02,
			shooting = {
				yaw = 2,
				pitch = 2
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 2,
			min_pitch = 2
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 1.6,
					pitch = 1.6
				},
				{
					yaw = 1.8,
					pitch = 1.8
				},
				{
					yaw = 2,
					pitch = 2
				},
				{
					yaw = 2,
					pitch = 2
				},
				{
					yaw = 1.8,
					pitch = 1.8
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"boltgun_hip_spray_n_pray",
			still
		},
		continuous_spread = {
			min_yaw = 2.5,
			min_pitch = 2.5
		}
	},
	[crouch_still] = {
		inherits = {
			"boltgun_hip_spray_n_pray",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"boltgun_hip_spray_n_pray",
			still
		}
	}
}
spread_templates.psyker_smite = {
	[still] = {
		max_spread = {
			yaw = 10,
			pitch = 10
		},
		decay = {
			from_shooting_grace_time = 0,
			shooting = {
				yaw = 0,
				pitch = 0
			},
			idle = {
				yaw = 0,
				pitch = 0
			}
		},
		continuous_spread = {
			min_yaw = 5,
			min_pitch = 5
		},
		immediate_spread = {
			num_shots_clear_time = 0.4,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 5,
					pitch = 5
				}
			},
			shooting = {
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.4,
					pitch = 0.4
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 1.25,
					pitch = 1
				},
				{
					yaw = 1.75,
					pitch = 1.5
				}
			}
		}
	},
	[moving] = {
		inherits = {
			"laspistol_assault",
			still
		},
		continuous_spread = {
			min_yaw = 0.6,
			min_pitch = 0.6
		}
	},
	[crouch_still] = {
		inherits = {
			"laspistol_assault",
			still
		}
	},
	[crouch_moving] = {
		inherits = {
			"laspistol_assault",
			still
		}
	}
}
local _immediate_spread_types = {
	"suppression_hit",
	"damage_hit",
	"shooting",
	"alternate_fire_start",
	"crouching_transition"
}

local function _inherit(move_state_settings, inheritance_settings)
	local new_move_state_settings = table.clone(spread_templates[inheritance_settings[1]][inheritance_settings[2]])

	if new_move_state_settings.inherits then
		new_move_state_settings = _inherit(new_move_state_settings, new_move_state_settings.inherits)
	end

	for key, override_data in pairs(move_state_settings) do
		new_move_state_settings[key] = override_data
	end

	new_move_state_settings.inherits = nil

	return new_move_state_settings
end

for name, template in pairs(spread_templates) do
	for _, movement_state in pairs(weapon_movement_states) do
		local move_state_settings = template[movement_state]

		fassert(move_state_settings, "Missing movement state [\"%s\"] for spread template [\"%s\"] and movement state [\"%s\"]!", movement_state, name, movement_state)

		local inheritance_settings = move_state_settings.inherits

		if inheritance_settings then
			fassert(inheritance_settings[1], "Inheritance wanted for spread template [\"%s\"], but no parent template to inherit from defined!", name)
			fassert(spread_templates[inheritance_settings[1]], "Trying to inherit non-existent template [\"%s\"] in spread template [\"%s\"]!", inheritance_settings[1], name)
			fassert(inheritance_settings[2], "Inheritance wanted for spread template [\"%s\"], but no movement state to inherit from defined!", name)
			fassert(template[inheritance_settings[2]], "Trying to inherit non-existent movement state [\"%s\"] in spread template [\"%s\"]!", inheritance_settings[2], name)
			fassert(name ~= inheritance_settings[1] or movement_state ~= inheritance_settings[2], "Trying to inherit from same template name and movement state")

			local new_move_state_settings = _inherit(move_state_settings, inheritance_settings)
			spread_templates[name][movement_state] = new_move_state_settings
		end
	end
end

for name, template in pairs(spread_templates) do
	for _, movement_state in pairs(weapon_movement_states) do
		local move_state_settings = template[movement_state]

		for _, immediate_spread_type in ipairs(_immediate_spread_types) do
			local immediate_spread_settings = move_state_settings.immediate_spread[immediate_spread_type]

			if immediate_spread_settings then
				for i, entry in ipairs(immediate_spread_settings) do
					move_state_settings.immediate_spread[immediate_spread_type].num_spreads = #move_state_settings.immediate_spread[immediate_spread_type]
				end
			end
		end
	end
end

return settings("SpreadTemplates", spread_templates)
