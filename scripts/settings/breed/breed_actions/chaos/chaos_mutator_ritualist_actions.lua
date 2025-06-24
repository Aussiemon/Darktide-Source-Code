-- chunkname: @scripts/settings/breed/breed_actions/chaos/chaos_mutator_ritualist_actions.lua

local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "chaos_mutator_ritualist",
	chanting = {
		ignore_rotate_towards_target = true,
		vo_event = "passive_idle",
		anim_events = {
			"chanting_01",
			"chanting_02",
			"chanting_03",
		},
		effect_template_variant_lookup = {
			chanting_01 = 1,
			chanting_02 = 2,
			chanting_03 = 3,
		},
		effect_template = EffectTemplates.chaos_mutator_ritualist_chanting,
	},
	death = {
		instant_ragdoll_chance = 0.5,
		death_animations = {
			[hit_zone_names.head] = {
				"death_shot_head_front",
				"death_shot_head_fwd",
				"death_shot_head_left",
				"death_shot_head_right",
				"death_shot_head_bwd",
				"death_decapitate_3",
			},
			[hit_zone_names.torso] = {
				"death_stab_chest_front",
				"death_stab_chest_back",
				"death_slash_left",
				"death_slash_right",
				"death_strike_chest_front",
				"death_strike_chest_back",
				"death_strike_chest_left",
				"death_strike_chest_right",
			},
			[hit_zone_names.upper_left_arm] = {
				"death_arm_left",
				"death_arm_left_2",
				"death_arm_left_3",
			},
			[hit_zone_names.lower_left_arm] = {
				"death_arm_left",
				"death_arm_left_2",
				"death_arm_left_3",
			},
			[hit_zone_names.upper_right_arm] = {
				"death_arm_right",
				"death_arm_right_2",
				"death_arm_right_3",
			},
			[hit_zone_names.lower_right_arm] = {
				"death_arm_right",
				"death_arm_right_2",
				"death_arm_right_3",
			},
			[hit_zone_names.upper_left_leg] = {
				"death_leg_left",
			},
			[hit_zone_names.lower_left_leg] = {
				"death_leg_left",
			},
			[hit_zone_names.upper_right_leg] = {
				"death_leg_right",
			},
			[hit_zone_names.lower_right_leg] = {
				"death_leg_right",
			},
		},
		ragdoll_timings = {
			death_arm_left = 3.033333333333333,
			death_arm_left_2 = 4,
			death_arm_left_3 = 3.9,
			death_arm_right = 5.1,
			death_arm_right_2 = 4.233333333333333,
			death_arm_right_3 = 2.566666666666667,
			death_decapitate_3 = 1.4,
			death_leg_left = 3.066666666666667,
			death_leg_right = 4.5,
			death_shot_head_bwd = 3.3333333333333335,
			death_shot_head_front = 1.4666666666666666,
			death_shot_head_fwd = 2.3666666666666667,
			death_shot_head_left = 2.1,
			death_shot_head_right = 4.566666666666666,
			death_slash_left = 3.2666666666666666,
			death_slash_right = 2.6666666666666665,
			death_stab_chest_back = 2.5,
			death_stab_chest_front = 3.6333333333333333,
			death_strike_chest_back = 3.1666666666666665,
			death_strike_chest_front = 1.6666666666666667,
			death_strike_chest_left = 3.2,
			death_strike_chest_right = 1.2666666666666666,
		},
	},
	disable = {
		disable_anims = {
			pounced = {
				fwd = {
					"dog_leap_pinned",
				},
				bwd = {
					"dog_leap_pinned",
				},
				left = {
					"dog_leap_pinned",
				},
				right = {
					"dog_leap_pinned",
				},
			},
		},
		stand_anim = {
			duration = 4,
			name = "dog_leap_pinned_stand",
		},
	},
	stagger = {
		stagger_duration_mods = {
			stagger_explosion_front_2 = 0.8,
		},
		stagger_anims = {
			light = {
				fwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				bwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
			medium = {
				fwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				bwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
			heavy = {
				fwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				bwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
			light_ranged = {
				fwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				bwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
			explosion = {
				fwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				bwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
			killshot = {
				fwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				bwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
			sticky = {
				bwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				fwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
			electrocuted = {
				bwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				fwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
			blinding = {
				fwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				bwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
		},
	},
}

return action_data
