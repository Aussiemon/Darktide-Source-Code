-- chunkname: @scripts/settings/equipment/weapon_tweak_stats_ui_data.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local armor_types = ArmorSettings.types
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states
local attack_armor_damage_modifiers = {
	[armor_types.unarmored] = {
		display_name = "loc_weapon_stats_display_dmg_vs_unarmored",
		display_type = "percentage",
		display_units = "%",
	},
	[armor_types.disgustingly_resilient] = {
		display_name = "loc_weapon_stats_display_dmg_vs_disgustingly_resilient",
		display_type = "percentage",
		display_units = "%",
	},
	[armor_types.armored] = {
		display_name = "loc_weapon_stats_display_dmg_vs_armored",
		display_type = "percentage",
		display_units = "%",
	},
	[armor_types.super_armor] = {
		display_name = "loc_weapon_stats_display_dmg_vs_super_armor",
		display_type = "percentage",
		display_units = "%",
	},
	[armor_types.resistant] = {
		display_name = "loc_weapon_stats_display_dmg_vs_resistant",
		display_type = "percentage",
		display_units = "%",
	},
	[armor_types.berserker] = {
		display_name = "loc_weapon_stats_display_dmg_vs_berzerker",
		display_type = "percentage",
		display_units = "%",
	},
}
local impact_armor_damage_modifiers = {
	[armor_types.unarmored] = {
		display_name = "loc_weapon_stats_display_stagger_vs_unarmored",
		display_type = "percentage",
		display_units = "%",
	},
	[armor_types.disgustingly_resilient] = {
		display_name = "loc_weapon_stats_display_stagger_vs_disgustingly_resilient",
		display_type = "percentage",
		display_units = "%",
	},
	[armor_types.armored] = {
		display_name = "loc_weapon_stats_display_stagger_vs_armored",
		display_type = "percentage",
		display_units = "%",
	},
	[armor_types.super_armor] = {
		display_name = "loc_weapon_stats_display_stagger_vs_super_armor",
		display_type = "percentage",
		display_units = "%",
	},
	[armor_types.resistant] = {
		display_name = "loc_weapon_stats_display_stagger_vs_resistant",
		display_type = "percentage",
		display_units = "%",
	},
	[armor_types.berserker] = {
		display_name = "loc_weapon_stats_display_stagger_vs_berzerker",
		display_type = "percentage",
		display_units = "%",
	},
}
local stat_descriptions = {
	charge = {
		overheat_percent = {
			display_name = "loc_weapon_stats_display_heat_resistance",
			display_type = "default",
		},
		extra_overheat_percent = {
			display_name = "loc_weapon_stats_display_charged_heat_generation",
			display_type = "default",
		},
		charge_duration = {
			display_name = "loc_weapon_stats_display_charge_speed",
			display_type = "default",
			display_units = "s",
		},
		warp_charge_percent = {
			display_name = "loc_weapon_stats_display_peril_cost",
			display_type = "percentage",
			display_units = "%",
		},
	},
	warp_charge = {
		vent_duration_modifier = {
			display_name = "loc_weapon_stats_display_quell_speed",
			display_type = "inverse_percentage",
			display_units = "%",
			signed = true,
		},
		auto_vent_duration_modifier = {
			display_name = "loc_weapon_stats_display_peril_decay",
			display_type = "inverse_percentage",
			display_units = "%",
			signed = true,
		},
	},
	stagger_duration_modifier = {
		modifier = {
			display_name = "loc_weapon_stats_display_stagger_duration",
			display_type = "default",
		},
	},
	damage = {
		crit_mod = {
			attack = {
				[armor_types.unarmored] = {
					display_name = "loc_weapon_stats_display_crit_vs_unarmored",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
				[armor_types.disgustingly_resilient] = {
					display_name = "loc_weapon_stats_display_crit_vs_disgustingly_resilient",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
				[armor_types.armored] = {
					display_name = "loc_weapon_stats_display_crit_vs_armored",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
				[armor_types.super_armor] = {
					display_name = "loc_weapon_stats_display_crit_vs_super_armor",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
				[armor_types.resistant] = {
					display_name = "loc_weapon_stats_display_crit_vs_resistant",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
				[armor_types.berserker] = {
					display_name = "loc_weapon_stats_display_crit_vs_berzerker",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
			},
			impact = {
				[armor_types.unarmored] = {
					display_name = "loc_weapon_stats_display_crit_vs_unarmored",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
				[armor_types.disgustingly_resilient] = {
					display_name = "loc_weapon_stats_display_crit_vs_disgustingly_resilient",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
				[armor_types.armored] = {
					display_name = "loc_weapon_stats_display_crit_vs_armored",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
				[armor_types.super_armor] = {
					display_name = "loc_weapon_stats_display_crit_vs_super_armor",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
				[armor_types.resistant] = {
					display_name = "loc_weapon_stats_display_crit_vs_resistant",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
				[armor_types.berserker] = {
					display_name = "loc_weapon_stats_display_crit_vs_berzerker",
					display_type = "percentage",
					display_units = "%",
					signed = true,
				},
			},
		},
		armor_damage_modifier_ranged = {
			near = {
				attack = {
					[armor_types.unarmored] = {
						display_name = "loc_weapon_stats_display_near_vs_unarmored",
						display_type = "percentage",
						display_units = "%",
					},
					[armor_types.disgustingly_resilient] = {
						display_name = "loc_weapon_stats_display_near_vs_disgustingly_resilient",
						display_type = "percentage",
						display_units = "%",
					},
					[armor_types.armored] = {
						display_name = "loc_weapon_stats_display_near_vs_armored",
						display_type = "percentage",
						display_units = "%",
					},
					[armor_types.super_armor] = {
						display_name = "loc_weapon_stats_display_near_vs_super_armor",
						display_type = "percentage",
						display_units = "%",
					},
					[armor_types.resistant] = {
						display_name = "loc_weapon_stats_display_near_vs_resistent",
						display_type = "percentage",
						display_units = "%",
					},
					[armor_types.berserker] = {
						display_name = "loc_weapon_stats_display_near_vs_berzerker",
						display_type = "percentage",
						display_units = "%",
					},
				},
				impact = {
					[armor_types.unarmored] = {
						display_name = "loc_weapon_stats_display_stagger_vs_unarmored",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_near",
					},
					[armor_types.disgustingly_resilient] = {
						display_name = "loc_weapon_stats_display_stagger_vs_disgustingly_resilient",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_near",
					},
					[armor_types.armored] = {
						display_name = "loc_weapon_stats_display_stagger_vs_armored",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_near",
					},
					[armor_types.super_armor] = {
						display_name = "loc_weapon_stats_display_stagger_vs_super_armor",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_near",
					},
					[armor_types.resistant] = {
						display_name = "loc_weapon_stats_display_stagger_vs_resistant",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_near",
					},
					[armor_types.berserker] = {
						display_name = "loc_weapon_stats_display_stagger_vs_berzerker",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_near",
					},
				},
			},
			far = {
				attack = {
					[armor_types.unarmored] = {
						display_name = "loc_weapon_stats_display_far_vs_unarmored",
						display_type = "percentage",
						display_units = "%",
					},
					[armor_types.disgustingly_resilient] = {
						display_name = "loc_weapon_stats_display_far_vs_disgustingly_resilient",
						display_type = "percentage",
						display_units = "%",
					},
					[armor_types.armored] = {
						display_name = "loc_weapon_stats_display_far_vs_armored",
						display_type = "percentage",
						display_units = "%",
					},
					[armor_types.super_armor] = {
						display_name = "loc_weapon_stats_display_far_vs_super_armor",
						display_type = "percentage",
						display_units = "%",
					},
					[armor_types.resistant] = {
						display_name = "loc_weapon_stats_display_far_vs_resistent",
						display_type = "percentage",
						display_units = "%",
					},
					[armor_types.berserker] = {
						display_name = "loc_weapon_stats_display_far_vs_berzerker",
						display_type = "percentage",
						display_units = "%",
					},
				},
				impact = {
					[armor_types.unarmored] = {
						display_name = "loc_weapon_stats_display_stagger_vs_unarmored",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_far",
					},
					[armor_types.disgustingly_resilient] = {
						display_name = "loc_weapon_stats_display_stagger_vs_disgustingly_resilient",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_far",
					},
					[armor_types.armored] = {
						display_name = "loc_weapon_stats_display_stagger_vs_armored",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_far",
					},
					[armor_types.super_armor] = {
						display_name = "loc_weapon_stats_display_stagger_vs_super_armor",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_far",
					},
					[armor_types.resistant] = {
						display_name = "loc_weapon_stats_display_stagger_vs_resistant",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_far",
					},
					[armor_types.berserker] = {
						display_name = "loc_weapon_stats_display_stagger_vs_berzerker",
						display_type = "percentage",
						display_units = "%",
						suffix = "loc_weapon_stats_display_far",
					},
				},
			},
		},
		armor_damage_modifier = {
			attack = attack_armor_damage_modifiers,
			impact = impact_armor_damage_modifiers,
		},
		power_distribution = {
			attack = {
				display_name = "loc_weapon_stats_display_base_damage",
				display_type = "default",
			},
			impact = {
				display_name = "loc_weapon_stats_display_stagger",
				display_type = "default",
			},
		},
		power_distribution_ranged = {
			near = {
				attack = {
					display_name = "loc_weapon_stats_display_base_damage",
					display_type = "default",
					suffix = "loc_weapon_stats_display_near",
				},
				impact = {
					display_name = "loc_weapon_stats_display_stagger",
					display_type = "default",
					suffix = "loc_weapon_stats_display_near",
				},
			},
			far = {
				attack = {
					display_name = "loc_weapon_stats_display_base_damage",
					display_type = "default",
					suffix = "loc_weapon_stats_display_far",
				},
				impact = {
					display_name = "loc_weapon_stats_display_stagger",
					display_type = "default",
					suffix = "loc_weapon_stats_display_far",
				},
			},
		},
		ranges = {
			min = {
				display_name = "loc_weapon_stats_display_effective_range",
				display_type = "default",
				display_units = " m",
				suffix = "loc_weapon_stats_display_near",
			},
			max = {
				display_name = "loc_weapon_stats_display_effective_range",
				display_type = "default",
				display_units = " m",
				suffix = "loc_weapon_stats_display_far",
			},
		},
		targets = {
			{
				power_distribution = {
					attack = {
						display_name = "loc_weapon_stats_display_first_target_damage",
						display_type = "default",
					},
					impact = {
						display_name = "loc_weapon_stats_display_first_target_stagger",
						display_type = "default",
					},
				},
				power_level_multiplier = {
					display_name = "loc_weapon_stats_display_first_target_power",
					display_type = "default",
					prefix_display_units = "x",
				},
				boost_curve_multiplier_finesse = {
					display_name = "loc_weapon_stats_display_finesse_power",
					display_type = "default",
					prefix_display_units = "x",
				},
				armor_damage_modifier = {
					attack = attack_armor_damage_modifiers,
					impact = impact_armor_damage_modifiers,
				},
				stagger_duration_modifier = {
					display_name = "loc_weapon_stats_display_stagger_duration",
					display_type = "default",
				},
			},
			default_target = {
				power_distribution = {
					attack = {
						display_name = "loc_weapon_stats_display_base_damage",
						display_type = "default",
					},
					impact = {
						display_name = "loc_weapon_stats_display_stagger",
						display_type = "default",
					},
				},
				power_level_multiplier = {
					display_name = "loc_weapon_stats_display_base_damage",
					display_type = "default",
					prefix_display_units = "x",
				},
				boost_curve_multiplier_finesse = {
					display_name = "loc_weapon_stats_display_finesse_power",
					display_type = "default",
					prefix_display_units = "x",
				},
				armor_damage_modifier = {
					attack = attack_armor_damage_modifiers,
					impact = impact_armor_damage_modifiers,
				},
			},
		},
		suppression_value = {
			display_name = "loc_weapon_stats_display_suppression",
			display_type = "default",
		},
		on_kill_area_suppression = {
			suppression_value = {
				display_name = "loc_weapon_stats_display_suppression_on_kill",
				display_type = "default",
			},
			distance = {
				display_name = "loc_weapon_stats_display_suppression_on_kill_size",
				display_type = "default",
			},
		},
		block_cost_multiplier = {
			display_name = "loc_weapon_stats_display_block_efficiency",
			display_type = "default",
		},
		stagger_duration_modifier = {
			display_name = "loc_weapon_stats_display_stagger_duration",
			display_type = "default",
		},
		cleave_distribution = {
			attack = {
				display_name = "loc_weapon_stats_display_cleave_mass_damage",
				display_type = "default",
			},
			impact = {
				display_name = "loc_weapon_stats_display_cleave_mass_stagger",
				display_type = "default",
			},
		},
		accumulative_stagger_strength_multiplier = {
			display_name = "loc_weapon_stats_display_accumulative_stagger",
			display_type = "default",
		},
	},
	explosion = {
		radius = {
			display_name = "loc_weapon_stats_display_blast_radius",
			display_type = "default",
		},
		close_radius = {
			display_name = "loc_weapon_stats_display_inner_blast_radius",
			display_type = "default",
		},
		static_power_level = {
			display_name = "loc_weapon_stats_display_power",
			display_type = "default",
		},
		explosion_area_suppression = {
			distance = {
				display_name = "loc_weapon_stats_display_area_suppression_size",
				display_type = "default",
			},
			suppression_value = {
				display_name = "loc_weapon_stats_display_area_suppression",
				display_type = "default",
			},
		},
	},
	sprint = {
		sprint_speed_mod = {
			display_name = "loc_weapon_stats_display_sprint_speed",
			display_type = "default",
			signed = true,
		},
	},
	stamina = {
		stamina_modifier = {
			display_name = "loc_weapon_stats_display_stamina",
			display_type = "default",
			signed = true,
		},
		sprint_cost_per_second = {
			display_name = "loc_weapon_stats_display_sprint_cost",
			display_type = "default",
			display_units = "/s",
		},
		push_cost = {
			display_name = "loc_weapon_stats_display_push_cost",
			display_type = "default",
		},
	},
	dodge = {
		distance_scale = {
			display_name = "loc_weapon_stats_display_dodge_distance",
			display_type = "multiplier",
			display_units = "%",
			signed = true,
		},
		speed_modifier = {
			display_name = "loc_weapon_stats_display_dodge_speed",
			display_type = "multiplier",
			display_units = "%",
			signed = true,
		},
		diminishing_return_start = {
			display_name = "loc_weapon_stats_display_effective_dodges",
			display_type = "default",
			rounding = math.ceil,
		},
	},
	spread = {
		[weapon_movement_states.still] = {
			immediate_spread = {
				shooting = {
					_array_range = {
						1,
						math.huge,
						pitch = {
							stat_group_key = "spread_pitch",
							stat_group_rule = "average",
						},
						yaw = {
							stat_group_key = "spread_yaw",
							stat_group_rule = "average",
						},
					},
				},
			},
			continuous_spread = {
				min_pitch = {
					stat_group_key = "still_min_spread_pitch",
					stat_group_rule = "average",
				},
				min_yaw = {
					stat_group_key = "still_min_spread_pitch",
					stat_group_rule = "average",
				},
			},
		},
		[weapon_movement_states.moving] = {
			immediate_spread = {
				shooting = {
					_array_range = {
						1,
						math.huge,
						pitch = {
							stat_group_key = "moving_spread_pitch",
							stat_group_rule = "average",
						},
						yaw = {
							stat_group_key = "moving_spread_yaw",
							stat_group_rule = "average",
						},
					},
				},
			},
			continuous_spread = {
				min_pitch = {
					stat_group_key = "moving_min_spread_pitch",
					stat_group_rule = "average",
				},
				min_yaw = {
					stat_group_key = "moving_min_spread_pitch",
					stat_group_rule = "average",
				},
			},
		},
	},
	recoil = {
		still = {
			rise = {
				_array_range = {
					1,
					math.huge,
					stat_group_key = "recoil_rise",
					stat_group_rule = "average",
				},
			},
			offset = {
				_array_range = {
					1,
					math.huge,
					pitch = {
						stat_group_key = "recoil_pitch",
						stat_group_rule = "average",
					},
					yaw = {
						stat_group_key = "recoil_yaw",
						stat_group_rule = "average",
					},
				},
			},
			offset_range = {
				_array_range = {
					1,
					math.huge,
					pitch = {
						{
							stat_group_key = "recoil_pitch_range_min",
							stat_group_rule = "average",
						},
						{
							stat_group_key = "recoil_pitch_range_max",
							stat_group_rule = "average",
						},
					},
					yaw = {
						{
							stat_group_key = "recoil_yaw_range_min",
							stat_group_rule = "average",
						},
						{
							stat_group_key = "recoil_yaw_range_max",
							stat_group_rule = "average",
						},
					},
				},
			},
			new_influence_percent = {
				stat_group_key = "recoil_influence",
				stat_group_rule = "average",
			},
		},
		moving = {
			rise = {
				_array_range = {
					1,
					math.huge,
					stat_group_key = "moving_recoil_rise",
					stat_group_rule = "average",
				},
			},
			offset = {
				_array_range = {
					1,
					math.huge,
					pitch = {
						stat_group_key = "moving_recoil_pitch",
						stat_group_rule = "average",
					},
					yaw = {
						stat_group_key = "moving_recoil_yaw",
						stat_group_rule = "average",
					},
				},
			},
			offset_range = {
				_array_range = {
					1,
					math.huge,
					pitch = {
						{
							stat_group_key = "moving_recoil_pitch_range_min",
							stat_group_rule = "average",
						},
						{
							stat_group_key = "moving_recoil_pitch_range_max",
							stat_group_rule = "average",
						},
					},
					yaw = {
						{
							stat_group_key = "moving_recoil_yaw_range_min",
							stat_group_rule = "average",
						},
						{
							stat_group_key = "moving_recoil_yaw_range_max",
							stat_group_rule = "average",
						},
					},
				},
			},
			new_influence_percent = {
				stat_group_key = "moving_recoil_influence",
				stat_group_rule = "average",
			},
		},
	},
	sway = {
		still = {
			continuous_sway = {
				pitch = {
					stat_group_key = "sway_pitch",
					stat_group_rule = "average",
				},
				yaw = {
					stat_group_key = "sway_yaw",
					stat_group_rule = "average",
				},
			},
			intensity = {
				stat_group_key = "sway_intensity",
				stat_group_rule = "average",
			},
		},
	},
	ammo = {
		ammunition_clip = {
			display_name = "loc_weapon_stats_display_clip_size",
			display_type = "default",
			rounding = math.floor,
		},
		ammunition_reserve = {
			display_name = "loc_weapon_stats_display_reserve_ammo",
			display_type = "default",
			rounding = math.floor,
		},
	},
	weapon_handling = {
		critical_strike = {
			chance_modifier = {
				display_name = "loc_weapon_stats_display_crit_chance_melee",
				display_type = "percentage",
				display_units = "%",
				signed = true,
			},
		},
		time_scale = {
			display_name = "loc_weapon_stats_display_attack_speed",
			display_type = "multiplier",
			display_units = "%",
			normalize = true,
			signed = true,
		},
		flamer_ramp_up_times = {
			_array_range = {
				1,
				math.huge,
				stat_group_key = "flamer_ramp_up_times",
				stat_group_rule = "average",
			},
		},
	},
	burninating = {
		max_stacks = {
			display_name = "loc_weapon_stats_display_max_burn_stacks",
			display_type = "default",
			rounding = math.ceil,
		},
		stack_application_rate = {
			display_name = "loc_weapon_stats_display_burn_apply_rate",
			display_type = "default",
		},
	},
	size_of_flame = {
		range = {
			display_name = "loc_weapon_stats_display_effective_range",
			display_type = "default",
		},
		spread_angle = {
			display_name = "loc_weapon_stats_display_radius",
			display_type = "default",
		},
		suppression_cone_radius = {
			display_name = "loc_weapon_stats_display_area_suppression_size",
			display_type = "default",
		},
	},
}
local STAT_GROUP_ZERO = {
	current = 0,
	max = 0,
	min = 0,
}
local STAT_GROUP_ONE = {
	current = 1,
	max = 1,
	min = 1,
}
local group_descriptions = {
	flamer_ramp_up_times = {
		type_data = {
			display_name = "loc_weapon_stats_display_ramp",
			display_type = "default",
		},
		extra_dependancies = {
			flamer_ramp_up_times = {
				"flamer_ramp_up_times",
				{
					1,
					math.huge,
				},
			},
		},
		func = function (stat_groups)
			local flamer_ramp_up_times = stat_groups.flamer_ramp_up_times or STAT_GROUP_ZERO

			return flamer_ramp_up_times.min, flamer_ramp_up_times.max, flamer_ramp_up_times.current
		end,
	},
	still_min_spread = {
		type_data = {
			display_name = "loc_weapon_stats_display_spread",
			display_type = "default",
		},
		extra_dependancies = {
			still_min_spread_pitch = {
				"still",
				"continuous_spread",
				"min_pitch",
			},
			still_min_spread_yaw = {
				"still",
				"continuous_spread",
				"min_yaw",
			},
			spread_pitch = {
				"immediate_spread",
				"still",
				{
					1,
					math.huge,
				},
				"pitch",
			},
			spread_yaw = {
				"immediate_spread",
				"still",
				{
					1,
					math.huge,
				},
				"yaw",
			},
		},
		func = function (stat_groups)
			local pitch = stat_groups.still_min_spread_pitch
			local yaw = stat_groups.still_min_spread_yaw
			local immediate_spread_pitch = stat_groups.spread_pitch or STAT_GROUP_ZERO
			local immediate_spread_yaw = stat_groups.spread_yaw or STAT_GROUP_ZERO
			local pitch_min = pitch.min + immediate_spread_pitch.min / 2
			local pitch_max = pitch.max + immediate_spread_pitch.max / 2
			local pitch_current = pitch.current + immediate_spread_pitch.current / 2
			local yaw_min = yaw.min + immediate_spread_yaw.min / 2
			local yaw_max = yaw.max + immediate_spread_yaw.max / 2
			local yaw_current = yaw.current + immediate_spread_yaw.current / 2
			local min = math.sqrt(pitch_min * pitch_min + yaw_min * yaw_min) * 10
			local max = math.sqrt(pitch_max * pitch_max + yaw_max * yaw_max) * 10
			local current = math.sqrt(pitch_current * pitch_current + yaw_current * yaw_current) * 10

			return min, max, current
		end,
	},
	moving_min_spread = {
		type_data = {
			display_name = "loc_weapon_stats_display_movement_spread",
			display_type = "default",
		},
		extra_dependancies = {
			moving_min_spread_pitch = {
				"moving",
				"continuous_spread",
				"min_pitch",
			},
			moving_min_spread_yaw = {
				"moving",
				"continuous_spread",
				"min_yaw",
			},
			moving_spread_pitch = {
				"immediate_spread",
				"shooting",
				{
					1,
					math.huge,
				},
				"pitch",
			},
			moving_spread_yaw = {
				"immediate_spread",
				"shooting",
				{
					1,
					math.huge,
				},
				"yaw",
			},
		},
		func = function (stat_groups)
			local pitch = stat_groups.moving_min_spread_pitch or STAT_GROUP_ZERO
			local yaw = stat_groups.moving_min_spread_yaw or STAT_GROUP_ZERO
			local immediate_spread_pitch = stat_groups.moving_spread_pitch or STAT_GROUP_ZERO
			local immediate_spread_yaw = stat_groups.moving_spread_yaw or STAT_GROUP_ZERO
			local pitch_min = pitch.min + immediate_spread_pitch.min / 2
			local pitch_max = pitch.max + immediate_spread_pitch.max / 2
			local pitch_current = pitch.current + immediate_spread_pitch.current / 2
			local yaw_min = yaw.min + immediate_spread_yaw.min / 2
			local yaw_max = yaw.max + immediate_spread_yaw.max / 2
			local yaw_current = yaw.current + immediate_spread_yaw.current / 2
			local min = math.sqrt(pitch_min * pitch_min + yaw_min * yaw_min) * 10
			local max = math.sqrt(pitch_max * pitch_max + yaw_max * yaw_max) * 10
			local current = math.sqrt(pitch_current * pitch_current + yaw_current * yaw_current) * 10

			return min, max, current
		end,
	},
	recoil_still = {
		type_data = {
			display_name = "loc_weapon_stats_display_recoil",
			display_type = "default",
		},
		extra_dependancies = {
			recoil_rise = {
				"still",
				"rise",
				{
					1,
					math.huge,
				},
			},
			recoil_pitch = {
				"still",
				"offset",
				{
					1,
					math.huge,
				},
				"pitch",
			},
			recoil_yaw = {
				"still",
				"offset",
				{
					1,
					math.huge,
				},
				"yaw",
			},
			recoil_pitch_range_min = {
				"still",
				"offset_range",
				{
					1,
					math.huge,
				},
				"pitch",
				1,
			},
			recoil_pitch_range_max = {
				"still",
				"offset_range",
				{
					1,
					math.huge,
				},
				"pitch",
				2,
			},
			recoil_yaw_range_min = {
				"still",
				"offset_range",
				{
					1,
					math.huge,
				},
				"yaw",
				1,
			},
			recoil_yaw_range_max = {
				"still",
				"offset_range",
				{
					1,
					math.huge,
				},
				"yaw",
				2,
			},
			recoil_influence = {
				"still",
				"new_influence_percent",
			},
		},
		func = function (stat_groups)
			local recoil_rise = stat_groups.recoil_rise
			local recoil_pitch = stat_groups.recoil_pitch
			local recoil_yaw = stat_groups.recoil_yaw
			local influence = stat_groups.recoil_influence or STAT_GROUP_ONE
			local pitch_min, pitch_max, pitch_current

			if recoil_pitch then
				pitch_min, pitch_max, pitch_current = recoil_pitch.min, recoil_pitch.max, recoil_pitch.current
			else
				pitch_min = (stat_groups.recoil_pitch_range_min.min + stat_groups.recoil_pitch_range_max.min) / 2
				pitch_max = (stat_groups.recoil_pitch_range_min.max + stat_groups.recoil_pitch_range_max.max) / 2
				pitch_current = (stat_groups.recoil_pitch_range_min.current + stat_groups.recoil_pitch_range_max.current) / 2
			end

			pitch_min = pitch_min * influence.min
			pitch_max = pitch_max * influence.max
			pitch_current = pitch_current * influence.current

			local yaw_min, yaw_max, yaw_current

			if recoil_yaw then
				yaw_min, yaw_max, yaw_current = recoil_yaw.min, recoil_yaw.max, recoil_yaw.current
			else
				yaw_min = (stat_groups.recoil_yaw_range_min.min + stat_groups.recoil_yaw_range_max.min) / 2
				yaw_max = (stat_groups.recoil_yaw_range_min.max + stat_groups.recoil_yaw_range_max.max) / 2
				yaw_current = (stat_groups.recoil_yaw_range_min.current + stat_groups.recoil_yaw_range_max.current) / 2
			end

			yaw_min = yaw_min * influence.min
			yaw_max = yaw_max * influence.max
			yaw_current = yaw_current * influence.current

			local min = math.sqrt(pitch_min * pitch_min + yaw_min * yaw_min) * recoil_rise.min * 1000
			local max = math.sqrt(pitch_max * pitch_max + yaw_max * yaw_max) * recoil_rise.max * 1000
			local current = math.sqrt(pitch_current * pitch_current + yaw_current * yaw_current) * recoil_rise.current * 1000

			return min, max, current
		end,
	},
	recoil_moving = {
		type_data = {
			display_name = "loc_weapon_stats_display_mobility_recoil",
			display_type = "default",
		},
		extra_dependancies = {
			moving_recoil_rise = {
				"moving",
				"rise",
				{
					1,
					math.huge,
				},
			},
			moving_recoil_pitch = {
				"moving",
				"offset",
				{
					1,
					math.huge,
				},
				"pitch",
			},
			moving_recoil_yaw = {
				"moving",
				"offset",
				{
					1,
					math.huge,
				},
				"yaw",
			},
			moving_recoil_pitch_range_min = {
				"moving",
				"offset_range",
				{
					1,
					math.huge,
				},
				"pitch",
				1,
			},
			moving_recoil_pitch_range_max = {
				"moving",
				"offset_range",
				{
					1,
					math.huge,
				},
				"pitch",
				2,
			},
			moving_recoil_yaw_range_min = {
				"moving",
				"offset_range",
				{
					1,
					math.huge,
				},
				"yaw",
				1,
			},
			moving_recoil_yaw_range_max = {
				"moving",
				"offset_range",
				{
					1,
					math.huge,
				},
				"yaw",
				2,
			},
			moving_recoil_influence = {
				"moving",
				"new_influence_percent",
			},
		},
		func = function (stat_groups)
			local moving_recoil_rise = stat_groups.moving_recoil_rise
			local moving_recoil_pitch = stat_groups.moving_recoil_pitch
			local moving_recoil_yaw = stat_groups.moving_recoil_yaw
			local influence = stat_groups.moving_recoil_influence or STAT_GROUP_ONE
			local pitch_min, pitch_max, pitch_current

			if moving_recoil_pitch then
				pitch_min, pitch_max, pitch_current = moving_recoil_pitch.min, moving_recoil_pitch.max, moving_recoil_pitch.current
			else
				pitch_min = (stat_groups.moving_recoil_pitch_range_min.min + stat_groups.moving_recoil_pitch_range_max.min) / 2
				pitch_max = (stat_groups.moving_recoil_pitch_range_min.max + stat_groups.moving_recoil_pitch_range_max.max) / 2
				pitch_current = (stat_groups.moving_recoil_pitch_range_min.current + stat_groups.moving_recoil_pitch_range_max.current) / 2
			end

			pitch_min = pitch_min * influence.min
			pitch_max = pitch_max * influence.max
			pitch_current = pitch_current * influence.current

			local yaw_min, yaw_max, yaw_current

			if moving_recoil_yaw then
				yaw_min, yaw_max, yaw_current = moving_recoil_yaw.min, moving_recoil_yaw.max, moving_recoil_yaw.current
			else
				yaw_min = (stat_groups.moving_recoil_yaw_range_min.min + stat_groups.moving_recoil_yaw_range_max.min) / 2
				yaw_max = (stat_groups.moving_recoil_yaw_range_min.max + stat_groups.moving_recoil_yaw_range_max.max) / 2
				yaw_current = (stat_groups.moving_recoil_yaw_range_min.current + stat_groups.moving_recoil_yaw_range_max.current) / 2
			end

			yaw_min = yaw_min * influence.min
			yaw_max = yaw_max * influence.max
			yaw_current = yaw_current * influence.current

			local min = math.sqrt(pitch_min * pitch_min + yaw_min * yaw_min) * moving_recoil_rise.min * 1000
			local max = math.sqrt(pitch_max * pitch_max + yaw_max * yaw_max) * moving_recoil_rise.max * 1000
			local current = math.sqrt(pitch_current * pitch_current + yaw_current * yaw_current) * moving_recoil_rise.current * 1000

			return min, max, current
		end,
	},
	continuous_sway = {
		type_data = {
			display_name = "loc_weapon_stats_display_sway_number",
			display_type = "default",
		},
		extra_dependancies = {
			sway_pitch = {
				"still",
				"continuous_sway",
				"pitch",
			},
			sway_yaw = {
				"still",
				"continuous_sway",
				"yaw",
			},
			sway_intensity = {
				"still",
				"intensity",
			},
		},
		func = function (stat_groups)
			local pitch = stat_groups.sway_pitch
			local yaw = stat_groups.sway_yaw
			local intensity = stat_groups.sway_intensity or STAT_GROUP_ONE
			local min = math.sqrt(pitch.min * pitch.min + yaw.min * yaw.min) * intensity.min * 100
			local max = math.sqrt(pitch.max * pitch.max + yaw.max * yaw.max) * intensity.max * 100
			local current = math.sqrt(pitch.current * pitch.current + yaw.current * yaw.current) * intensity.current * 100

			return min, max, current
		end,
	},
	looped_reload = {
		type_data = {
			display_name = "loc_weapon_stats_display_reload_speed",
			display_type = "percentage",
			display_units = "%",
			signed = true,
		},
		extra_dependancies = {},
		func = function (stat_groups, weapon_stats)
			local reload_start_time_scale = stat_groups.reload_start
			local reload_loop_time_scale = stat_groups.reload_loop
			local base_reload_start_time = weapon_stats.base_reload_start_time
			local base_reload_loop_time = weapon_stats.base_reload_loop_time
			local reload_start_ammo_refill = weapon_stats.reload_start_ammo_refill
			local reload_loop_ammo_refill = weapon_stats.reload_loop_ammo_refill
			local ammo_clip_size = weapon_stats.ammo
			local ammo_to_refill = math.ceil((ammo_clip_size - reload_start_ammo_refill) / reload_loop_ammo_refill)
			local min_reload_time = base_reload_start_time / reload_start_time_scale.min + base_reload_loop_time / reload_loop_time_scale.min * ammo_to_refill
			local max_reload_time = base_reload_start_time / reload_start_time_scale.max + base_reload_loop_time / reload_loop_time_scale.max * ammo_to_refill
			local current_reload_time = base_reload_start_time / reload_start_time_scale.current + base_reload_loop_time / reload_loop_time_scale.current * ammo_to_refill
			local min = 0
			local max = 1 - max_reload_time / min_reload_time
			local current = 1 - current_reload_time / min_reload_time

			return min, max, current
		end,
	},
}
local WeaponTweakStatsUIData = {
	stats = stat_descriptions,
	groups = group_descriptions,
}

return WeaponTweakStatsUIData
