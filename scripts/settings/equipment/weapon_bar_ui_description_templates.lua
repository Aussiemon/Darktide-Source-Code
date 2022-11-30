local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local WeaponBarUIDescriptionTemplates = {
	recoil = {
		rise = {
			_array_range = {
				1,
				math.huge
			}
		},
		offset_range = {
			_array_range = {
				1,
				math.huge
			}
		},
		offset = {
			_array_range = {
				1,
				math.huge,
				pitch = {
					_array_range = {
						1,
						2
					}
				},
				yaw = {
					_array_range = {
						1,
						2
					}
				}
			}
		},
		offset_random_range = {
			_array_range = {
				1,
				math.huge,
				pitch = {
					_array_range = {
						1,
						2
					}
				},
				yaw = {
					_array_range = {
						1,
						2
					}
				}
			}
		}
	},
	spread = {
		continuous_spread = {
			min_pitch = {},
			min_yaw = {}
		},
		immediate_spread = {
			shooting = {
				_array_range = {
					1,
					math.huge,
					pitch = {},
					yaw = {}
				}
			}
		}
	},
	sway = {
		continuous_sway = {
			pitch = {},
			yaw = {}
		},
		intensity = {}
	},
	armor_damage_modifiers = {
		[armor_types.unarmored] = {},
		[armor_types.disgustingly_resilient] = {},
		[armor_types.armored] = {},
		[armor_types.super_armor] = {},
		[armor_types.resistant] = {},
		[armor_types.berserker] = {}
	},
	all_basic_stats = {
		display_stats = {
			__all_basic_stats = true
		}
	}
}
local default_bar_stats = {
	stability_recoil = {
		display_stats = {
			still = WeaponBarUIDescriptionTemplates.recoil,
			moving = WeaponBarUIDescriptionTemplates.recoil
		},
		display_group_stats = {
			recoil_still = {},
			recoil_moving = {}
		}
	},
	stability_spread = {
		display_stats = {
			still = WeaponBarUIDescriptionTemplates.spread
		},
		display_group_stats = {
			still_min_spread = {}
		}
	},
	stability_sway = {
		display_stats = {
			still = WeaponBarUIDescriptionTemplates.sway
		},
		display_group_stats = {
			continuous_sway = {}
		}
	},
	ammo = {
		display_stats = {
			__all_basic_stats = true
		}
	},
	dps_damage = {},
	dps_damage_near_far = {
		display_stats = {
			__all_basic_stats = true
		}
	},
	power_damage = {},
	power_damage_near_far = {
		display_stats = {
			__all_basic_stats = true
		}
	},
	mobility_dodge = {
		display_stats = {
			__all_basic_stats = true
		}
	},
	mobility_recoil = {
		display_stats = {
			moving = WeaponBarUIDescriptionTemplates.recoil
		},
		display_group_stats = {
			recoil_moving = {}
		}
	},
	mobility_sprint = {
		display_stats = {
			__all_basic_stats = true
		}
	},
	mobility_curve = {
		display_stats = {
			__all_basic_stats = true
		}
	},
	mobility_spread = {
		display_stats = {
			moving = WeaponBarUIDescriptionTemplates.spread
		},
		display_group_stats = {
			moving_min_spread = {}
		}
	}
}

WeaponBarUIDescriptionTemplates.create_template = function (bar_stat_type, prefix, postfix, custom_data)
	local bar_stats = default_bar_stats[bar_stat_type]
	local target_table = bar_stats

	if prefix or postfix or custom_data or not bar_stats then
		if custom_data then
			target_table = bar_stats and table.clone(bar_stats) or {}

			table.merge_recursive(target_table, custom_data)
		else
			target_table = bar_stats and table.shallow_copy(bar_stats) or {}
		end

		target_table.prefix = prefix
		target_table.postfix = postfix
	end

	return target_table
end

return WeaponBarUIDescriptionTemplates
