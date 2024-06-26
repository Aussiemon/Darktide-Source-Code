﻿-- chunkname: @scripts/settings/breed/breed_actions/chaos/chaos_poxwalker_bomber_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local action_data = {
	name = "chaos_poxwalker_bomber",
	idle = {
		anim_events = "idle",
	},
	death = {
		instant_ragdoll_chance = 1,
	},
	combat_idle = {
		anim_events = "idle",
		rotate_towards_target = true,
		utility_weight = 2,
		considerations = UtilityConsiderations.melee_combat_idle,
	},
	climb = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_down_fence_land_1m = 0.13333333333333333,
			jump_down_land = 6.166666666666667,
			jump_down_land_1m = 1.1666666666666667,
			jump_down_land_3m = 1.3333333333333333,
			jump_up_1m = 1.6666666666666667,
			jump_up_3m = 4,
			jump_up_5m = 5,
			jump_up_fence_1m = 0.4666666666666667,
			jump_up_fence_3m = 1.4,
			jump_up_fence_5m = 1.2,
		},
		ending_move_states = {
			jump_down_fence_land_1m = "jumping",
			jump_down_land = "jumping",
			jump_down_land_1m = "jumping",
			jump_down_land_3m = "jumping",
			jump_down_land_5m = "jumping",
			jump_up_1m = "jumping",
			jump_up_3m = "jumping",
			jump_up_5m = "jumping",
		},
		blend_timings = {
			jump_down = 0.2,
			jump_down_1m = 0.2,
			jump_down_2 = 0,
			jump_down_fence_land_1m = 0,
			jump_down_land = 0,
			jump_down_land_1m = 0,
			jump_down_land_3m = 0,
			jump_up_1m = 0,
			jump_up_3m = 0,
			jump_up_5m = 0,
			jump_up_fence_1m = 0.2,
			jump_up_fence_3m = 0.1,
			jump_up_fence_5m = 0.1,
		},
	},
	jump_across = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_over_gap_4m = 1.2333333333333334,
			jump_over_gap_4m_2 = 1.4,
		},
		ending_move_states = {
			jump_over_gap_4m = "jumping",
			jump_over_gap_4m_2 = "jumping",
		},
	},
	approach = {
		controlled_stagger = true,
		controlled_stagger_ignored_combat_range = "melee",
		controlled_stagger_min_speed = 2,
		effect_template_start_distance = 10,
		effect_template_stop_distance = 18,
		enter_lunge_distance = 6,
		enter_walk_distance = 5,
		fuse_timer = 1.5,
		idle_anim_events = "idle",
		ignore_running_stagger_combat_range_lock = true,
		leave_walk_distance = 6.5,
		lunge_anim_event = "attack_lunge",
		lunge_duration = 1.2222222222222223,
		move_during_lunge_duration = 0.6666666666666666,
		move_to_cooldown = 0.075,
		move_to_distance = 0.05,
		push_enemies_power_level = 2000,
		run_anim_event = "move_fwd",
		stagger_duration_modifier_during_lunge = 0.175,
		use_animation_running_stagger_speed = true,
		walk_anim_event = "walk_fwd",
		effect_template = EffectTemplates.chaos_poxwalker_bomber_foley,
		stagger_type_reduction = {
			melee = -200,
			ranged = 20,
		},
		running_stagger_anim_left = {
			"run_stagger_1",
			"run_stagger_2",
			"run_stagger_3",
		},
		running_stagger_anim_right = {
			"run_stagger_1",
			"run_stagger_2",
			"run_stagger_3",
		},
		running_stagger_duration = {
			run_stagger_1 = 1.3666666666666667,
			run_stagger_2 = 1.4333333333333333,
			run_stagger_3 = 1.4333333333333333,
		},
		push_enemies_damage_profile = DamageProfileTemplates.chaos_hound_push,
	},
	explode = {
		explode_position_node = "j_spine2",
		utility_weight = 1,
		considerations = UtilityConsiderations.chaos_poxwalker_bomber_explode,
		explosion_template = ExplosionTemplates.poxwalker_bomber,
	},
	stagger = {
		ignore_extra_stagger_duration = true,
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd",
				},
				bwd = {
					"stagger_bwd",
				},
				left = {
					"stagger_left",
				},
				right = {
					"stagger_right",
				},
				dwn = {
					"stun_down",
				},
			},
			medium = {
				fwd = {
					"stagger_fwd",
				},
				bwd = {
					"stagger_bwd",
				},
				left = {
					"stagger_left",
				},
				right = {
					"stagger_right",
				},
				dwn = {
					"stun_down",
				},
			},
			heavy = {
				fwd = {
					"stagger_fwd",
				},
				bwd = {
					"stagger_bwd",
				},
				left = {
					"stagger_left",
				},
				right = {
					"stagger_right",
				},
				dwn = {
					"stun_down",
				},
			},
			light_ranged = {
				fwd = {
					"stagger_fwd",
				},
				bwd = {
					"stagger_bwd",
				},
				left = {
					"stagger_left",
				},
				right = {
					"stagger_right",
				},
				dwn = {
					"stun_down",
				},
			},
			explosion = {
				fwd = {
					"stagger_fwd",
				},
				bwd = {
					"stagger_bwd",
				},
				left = {
					"stagger_left",
				},
				right = {
					"stagger_right",
				},
			},
			killshot = {
				fwd = {
					"stagger_fwd",
				},
				bwd = {
					"stagger_bwd",
				},
				left = {
					"stagger_left",
				},
				right = {
					"stagger_right",
				},
				dwn = {
					"stun_down",
				},
			},
			sticky = {
				fwd = {
					"stagger_fwd",
				},
				bwd = {
					"stagger_bwd",
				},
				left = {
					"stagger_left",
				},
				right = {
					"stagger_right",
				},
				dwn = {
					"stun_down",
				},
			},
			electrocuted = {
				fwd = {
					"stagger_fwd",
				},
				bwd = {
					"stagger_bwd",
				},
				left = {
					"stagger_left",
				},
				right = {
					"stagger_right",
				},
				dwn = {
					"stun_down",
				},
			},
			blinding = {
				fwd = {
					"stagger_fwd",
				},
				bwd = {
					"stagger_bwd",
				},
				left = {
					"stagger_left",
				},
				right = {
					"stagger_right",
				},
				dwn = {
					"stun_down",
				},
			},
		},
	},
	smash_obstacle = {
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_01",
		},
		attack_anim_damage_timings = {
			attack_01 = 0.6,
		},
		attack_anim_durations = {
			attack_01 = 1.2,
		},
		attack_intensities = {
			melee = 0.25,
			ranged = 1,
		},
		damage_profile = DamageProfileTemplates.default,
	},
	open_door = {
		open_door_time = 2.5,
		rotation_duration = 0.1,
		stagger_immune = true,
	},
	exit_spawner = {
		run_anim_event = "move_fwd",
	},
	teleport = {
		max_wait_time = 8,
		min_wait_time = 6,
	},
}

return action_data
