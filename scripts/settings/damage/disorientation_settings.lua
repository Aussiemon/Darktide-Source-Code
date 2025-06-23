-- chunkname: @scripts/settings/damage/disorientation_settings.lua

local disorientation_settings = {}

disorientation_settings.disorientation_templates = {
	toughness = {
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_3p = "hit_react"
	},
	toughness_melee = {
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		movement_speed_buff = "light_stun_movement_slow",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun",
			intoxication_level = 6,
			start_anim = "hit_react",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "hit_stun_finished",
			end_stun_early_time = 0.15,
			stun_immunity_time_buff = "stun_immune_medium",
			stun_duration = 0.3,
			action_delay = 0.2
		}
	},
	ranged = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		hit_react_anim_1p = "shake_light",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_3p = "hit_react"
	},
	burninating = {
		sound_event = "wwise/events/player/play_player_get_hit_fire",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_light",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun",
			intoxication_level = 10,
			start_anim = "hit_react",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "hit_stun_finished",
			end_stun_early_time = 0,
			stun_immunity_time_buff = "stun_immune_very_long",
			stun_duration = 0.15,
			action_delay = 0
		}
	},
	toughness_burning = {
		sound_event = "wwise/events/player/play_player_get_hit_fire_toughness",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_3p = "hit_react",
		stun = {
			end_stun_early_time = 0,
			start_anim_3p = "hit_react",
			stun_immunity_time_buff = "stun_immune_short",
			start_anim = "hit_react",
			intoxication_level = 0,
			stun_duration = 0,
			action_delay = 0
		}
	},
	ranged_sprinting = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		hit_react_anim_1p = "shake_light",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_3p = "hit_react"
	},
	light = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		movement_speed_buff = "light_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_light",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun",
			intoxication_level = 6,
			start_anim = "hit_stun",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "hit_stun_finished",
			end_stun_early_time = 0.3,
			stun_immunity_time_buff = "stun_immune_short",
			stun_duration = 0.5,
			action_delay = 0.3
		}
	},
	medium = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		movement_speed_buff = "medium_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_medium",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun_medium",
			intoxication_level = 8,
			start_anim = "hit_stun_medium",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "hit_stun_finished",
			end_stun_early_time = 0.5,
			stun_immunity_time_buff = "stun_immune_medium",
			stun_duration = 0.7,
			action_delay = 0.3
		}
	},
	fumbled = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		hit_react_anim_1p = "shake_heavy",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_3p = "hit_react"
	},
	ogryn_fumbled = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		hit_react_anim_1p = "shake_heavy",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_3p = "hit_react"
	},
	heavy = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "heavy_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_1p = "shake_heavy",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun_heavy",
			intoxication_level = 10,
			start_anim = "hit_stun_medium",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "hit_stun_recover",
			end_stun_early_time = 0.65,
			stun_immunity_time_buff = "stun_immune_very_long",
			stun_duration = 1.25,
			action_delay = 0.85
		}
	},
	shield_push = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "heavy_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_1p = "shake_heavy",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun_medium",
			intoxication_level = 30,
			start_anim = "hit_stun_medium",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "hit_stun_recover",
			end_stun_early_time = 0.8,
			stun_immunity_time_buff = "stun_immune_very_long",
			stun_duration = 1,
			action_delay = 0.4
		}
	},
	ogryn_executor_heavy = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "heavy_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_1p = "shake_heavy",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun_heavy",
			intoxication_level = 100,
			start_anim = "hit_stun_medium",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "hit_stun_recover",
			end_stun_early_time = 0.8,
			stun_immunity_time_buff = "stun_immune_very_long",
			stun_duration = 1.25,
			action_delay = 0.6
		}
	},
	chaos_ogryn_gunner_bullet = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "heavy_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_1p = "shake_heavy",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun_medium",
			intoxication_level = 25,
			start_anim = "hit_stun_medium",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "hit_stun_recover",
			end_stun_early_time = 0.5,
			stun_immunity_time_buff = "stun_immune_very_long",
			stun_duration = 0.75,
			action_delay = 0.4
		}
	},
	grenadier = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "grenadier_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_1p = "shake_medium",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun_medium",
			intoxication_level = 1,
			start_anim = "hit_stun",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0,
			end_anim = "hit_stun_recover",
			end_stun_early_time = 0.5,
			stun_immunity_time_buff = "stun_immune_very_long",
			stun_duration = 0.5,
			action_delay = 0
		}
	},
	twin_grenade = {
		sound_event = "wwise/events/player/play_player_get_hit_corruption_2d",
		movement_speed_buff = "grenadier_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		ignore_fumbled = true,
		hit_react_anim_1p = "shake_medium",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun_medium",
			intoxication_level = 10,
			start_anim = "hit_stun",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0,
			end_anim = "hit_stun_recover",
			end_stun_early_time = 0.5,
			stun_immunity_time_buff = "stun_immune_very_long",
			stun_duration = 1.5,
			action_delay = 0
		}
	},
	fortitude_broken = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		movement_speed_buff = "fortitude_broken_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_medium",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun",
			intoxication_level = 4,
			start_anim = "hit_stun",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "hit_stun_recover",
			end_stun_early_time = 0.3,
			stun_immunity_time_buff = "stun_immune_very_long",
			stun_duration = 0.75,
			action_delay = 0.75
		}
	},
	block_broken = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		movement_speed_buff = "fortitude_broken_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_medium",
		hit_react_anim_3p = "hit_react",
		stun = {
			intoxication_level = 25,
			start_anim_3p = "hit_stun_medium",
			start_anim = "hit_stun",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = false,
			end_anim = "hit_stun_recover",
			end_stun_early_time = 0.5,
			stun_duration = 1,
			action_delay = 0.75
		}
	},
	block_broken_heavy = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "sniper_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_1p = "shake_heavy",
		hit_react_anim_3p = "hit_react",
		stun = {
			intoxication_level = 50,
			start_anim_3p = "hit_stun_heavy",
			start_anim = "hit_stun",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = false,
			end_anim = "hit_stun_recover",
			end_stun_early_time = 1,
			stun_duration = 1.75,
			action_delay = 1
		}
	},
	sniper = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "sniper_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_1p = "shake_heavy",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun_heavy",
			intoxication_level = 50,
			start_anim = "hit_stun_medium",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "hit_stun_recover",
			end_stun_early_time = 1,
			stun_immunity_time_buff = "stun_immune_long",
			stun_duration = 1.75,
			action_delay = 1
		}
	},
	falling_light = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		movement_speed_buff = "light_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_light",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "fall_dmg_light",
			intoxication_level = 2,
			start_anim = "fall_dmg_light",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "fall_dmg_recover",
			end_stun_early_time = 0.5,
			stun_immunity_time_buff = "stun_immune_short",
			stun_duration = 0.6,
			action_delay = 0.2
		}
	},
	falling_heavy = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "light_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_1p = "shake_heavy",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "fall_dmg_light",
			intoxication_level = 4,
			start_anim = "fall_dmg_light",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0.05,
			end_anim = "fall_dmg_recover",
			end_stun_early_time = 0.9,
			stun_immunity_time_buff = "stun_immune_long",
			stun_duration = 1.2,
			action_delay = 0.5
		}
	},
	thunder_hammer_light = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "heavy_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_heavy",
		stun = {
			end_stun_early_time = 0.3,
			intoxication_level = 2,
			stun_immunity_time_buff = "stun_immune_short",
			stun_duration = 0.3,
			self_stun = true,
			interrupt_delay = false,
			action_delay = 0.3
		}
	},
	thunder_hammer_heavy = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "heavy_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_heavy",
		stun = {
			end_stun_early_time = 0.45,
			intoxication_level = 4,
			stun_immunity_time_buff = "stun_immune_short",
			stun_duration = 0.5,
			self_stun = true,
			interrupt_delay = false,
			action_delay = 0.5
		}
	},
	thunder_hammer_m2_light = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "heavy_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_heavy",
		stun = {
			end_stun_early_time = 0.25,
			intoxication_level = 2,
			stun_immunity_time_buff = "stun_immune_short",
			stun_duration = 0.25,
			self_stun = true,
			interrupt_delay = false,
			action_delay = 0.25
		}
	},
	thunder_hammer_m2_heavy = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "heavy_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_heavy",
		stun = {
			end_stun_early_time = 0.35,
			intoxication_level = 3,
			stun_immunity_time_buff = "stun_immune_short",
			stun_duration = 0.4,
			self_stun = true,
			interrupt_delay = false,
			action_delay = 0.4
		}
	},
	ogryn_shovel = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "heavy_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_heavy",
		stun = {
			end_stun_early_time = 0.9,
			intoxication_level = 4,
			stun_immunity_time_buff = "stun_immune_short",
			stun_duration = 1.3,
			self_stun = true,
			interrupt_delay = false,
			action_delay = 0.5
		}
	},
	shocktrooper_frag = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "heavy_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_1p = "shake_heavy",
		hit_react_anim_3p = "hit_react",
		stun = {
			end_stun_early_time = 1.2,
			end_anim = "hit_stun_recover",
			stun_immunity_time_buff = "stun_immune_very_long",
			start_anim = "hit_stun_medium",
			intoxication_level = 50,
			stun_duration = 2,
			interrupt_delay = 0.05,
			action_delay = 1
		}
	},
	corruption = {
		sound_event = "wwise/events/player/play_player_get_hit_corruption_2d"
	},
	corruption_tick = {
		sound_event = "wwise/events/player/play_player_get_hit_corruption_2d_tick"
	},
	toughness_corruption = {
		sound_event = "wwise/events/player/play_player_get_hit_2d_corruption_tick_toughness"
	},
	ogryn_toughness = {
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		movement_speed_buff = "ogryn_stun_movement_speed_up",
		hit_react_anim_1p = "shake_light",
		hit_react_anim_3p = "hit_react",
		stun = {
			intoxication_level = 0,
			stun_duration = 0,
			stun_immunity_time_buff = "stun_immune_short",
			action_delay = 0
		}
	},
	ogryn_toughness_melee = {
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		movement_speed_buff = "ogryn_stun_movement_speed_up",
		hit_react_anim_3p = "hit_react",
		stun = {
			intoxication_level = 0,
			stun_duration = 0,
			stun_immunity_time_buff = "stun_immune_short",
			action_delay = 0
		}
	},
	ogryn_light = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		movement_speed_buff = "ogryn_stun_movement_speed_up",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_light",
		hit_react_anim_3p = "hit_react",
		stun = {
			intoxication_level = 0,
			stun_duration = 0,
			stun_immunity_time_buff = "stun_immune_short",
			action_delay = 0
		}
	},
	ogryn_medium = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		movement_speed_buff = "ogryn_stun_movement_speed_up",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_medium",
		hit_react_anim_3p = "hit_react",
		stun = {
			intoxication_level = 0,
			stun_duration = 0,
			stun_immunity_time_buff = "stun_immune_short",
			action_delay = 0
		}
	},
	ogryn_heavy = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "ogryn_stun_movement_speed_up",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
		hit_react_anim_1p = "shake_heavy",
		hit_react_anim_3p = "hit_react",
		stun = {
			end_stun_early_time = 0.4,
			intoxication_level = 4,
			stun_immunity_time_buff = "stun_immune_medium",
			stun_duration = 0.5,
			interrupt_delay = 0.05,
			action_delay = 0.2
		}
	},
	ogryn_powermaul_disorientation = {
		sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
		movement_speed_buff = "ogryn_powermaul_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_heavy",
		stun = {
			end_stun_early_time = 1.2,
			stun_immunity_time_buff = "stun_immune_short",
			intoxication_level = 4,
			stun_duration = 2,
			interrupt_delay = 0.4,
			action_delay = 1
		}
	},
	ranged_auto_light = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_3p = "hit_react"
	},
	berzerker_combo = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		movement_speed_buff = "medium_stun_movement_slow",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_medium",
		hit_react_anim_3p = "hit_react",
		stun = {
			start_anim_3p = "hit_stun_medium",
			intoxication_level = 5,
			start_anim = "hit_stun_medium",
			end_anim_3p = "hit_stun_finished",
			interrupt_delay = 0,
			end_anim = "hit_stun_finished",
			end_stun_early_time = 0.5,
			stun_immunity_time_buff = "stun_immune_medium",
			stun_duration = 0.35,
			action_delay = 0
		}
	},
	ogryn_berzerker_combo = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d",
		movement_speed_buff = "ogryn_stun_movement_speed_up",
		screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
		hit_react_anim_1p = "shake_medium",
		hit_react_anim_3p = "hit_react"
	},
	trait_bespoke_powersword_2h_p1_trade_overheat_lockout_for_damage = {
		sound_event = "wwise/events/player/play_player_get_hit_light_2d"
	}
}
disorientation_settings.disorientation_types = table.enum(unpack(table.keys(disorientation_settings.disorientation_templates)))

return settings("DisorientationSettings", disorientation_settings)
