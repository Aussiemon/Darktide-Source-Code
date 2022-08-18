local disorientation_settings = {
	disorientation_templates = {
		toughness = {
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			movement_speed_buff = "toughness_stun_movement_slow",
			hit_react_anim_3p = "hit_react",
			stun = {
				start_anim = "hit_react",
				stun_immunity_time_buff = "stun_immune_medium",
				intoxication_level = 0,
				stun_duration = 0,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		ranged = {
			sound_event = "wwise/events/player/play_player_get_hit_light_2d",
			movement_speed_buff = "ranged_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			hit_react_anim_1p = "shake_light",
			stun = {
				start_anim = "hit_stun",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_medium",
				intoxication_level = 4,
				stun_duration = 0.25,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		burninating = {
			sound_event = "wwise/events/player/play_player_get_hit_fire",
			hit_react_anim_1p = "shake_light",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			stun = {
				start_anim = "hit_stun",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_very_long",
				intoxication_level = 10,
				stun_duration = 0.15,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		ranged_sprinting = {
			sound_event = "wwise/events/player/play_player_get_hit_light_2d",
			movement_speed_buff = "ranged_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			hit_react_anim_1p = "shake_light",
			stun = {
				start_anim = "hit_stun",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_short",
				intoxication_level = 2,
				stun_duration = 0.25,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		light = {
			sound_event = "wwise/events/player/play_player_get_hit_light_2d",
			movement_speed_buff = "light_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			hit_react_anim_1p = "shake_light",
			stun = {
				start_anim = "hit_stun",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_very_long",
				intoxication_level = 6,
				stun_duration = 0.3,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		medium = {
			sound_event = "wwise/events/player/play_player_get_hit_light_2d",
			movement_speed_buff = "medium_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			hit_react_anim_1p = "shake_medium",
			stun = {
				start_anim = "hit_stun_medium",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_very_long",
				intoxication_level = 8,
				stun_duration = 0.5,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		fumbled = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "ranged_sprinting_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				start_anim = "hit_stun_medium",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_ultra_short",
				intoxication_level = 10,
				stun_duration = 1,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		heavy = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "heavy_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				start_anim = "hit_stun_medium",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_very_long",
				intoxication_level = 10,
				stun_duration = 0.75,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		shield_push = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "heavy_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				start_anim = "hit_stun_medium",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_very_long",
				intoxication_level = 30,
				stun_duration = 1,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		ogryn_executor_heavy = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "heavy_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				start_anim = "hit_stun_medium",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_very_long",
				intoxication_level = 100,
				stun_duration = 1.25,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		chaos_ogryn_gunner_bullet = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "heavy_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				start_anim = "hit_stun_medium",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_very_long",
				intoxication_level = 25,
				stun_duration = 0.75,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		grenadier = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "grenadier_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				start_anim = "hit_stun",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_very_long",
				intoxication_level = 4,
				stun_duration = 1,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		fortitude_broken = {
			sound_event = "wwise/events/player/play_player_get_hit_light_2d",
			movement_speed_buff = "fortitude_broken_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			hit_react_anim_1p = "shake_medium",
			stun = {
				start_anim = "hit_stun",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_medium",
				intoxication_level = 4,
				stun_duration = 0.75,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		sniper = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "sniper_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				start_anim = "hit_stun",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_long",
				intoxication_level = 50,
				stun_duration = 1.75,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		falling_light = {
			sound_event = "wwise/events/player/play_player_get_hit_light_2d",
			movement_speed_buff = "light_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			hit_react_anim_1p = "shake_light",
			stun = {
				start_anim = "fall_dmg_light",
				end_anim = "fall_dmg_recover",
				stun_immunity_time_buff = "stun_immune_short",
				intoxication_level = 2,
				stun_duration = 0.6,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		falling_heavy = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "light_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				start_anim = "fall_dmg_light",
				end_anim = "fall_dmg_recover",
				stun_immunity_time_buff = "stun_immune_long",
				intoxication_level = 4,
				stun_duration = 1.2,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		thunder_hammer = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "heavy_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				stun_immunity_time_buff = "stun_immune_short",
				intoxication_level = 4,
				stun_duration = 1.8,
				interrupt_delay = false,
				action_delay = 1.25
			}
		},
		shocktrooper_frag = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "heavy_stun_movement_slow",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				start_anim = "hit_stun_medium",
				end_anim = "hit_stun_recover",
				stun_immunity_time_buff = "stun_immune_very_long",
				intoxication_level = 50,
				stun_duration = 2,
				interrupt_delay = 0.2,
				action_delay = 0
			}
		},
		ogryn_toughness = {
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			movement_speed_buff = "ogryn_stun_movement_seed_up",
			hit_react_anim_3p = "hit_react",
			stun = {
				intoxication_level = 0,
				stun_duration = 0,
				action_delay = 0
			}
		},
		ogryn_light = {
			sound_event = "wwise/events/player/play_player_get_hit_light_2d",
			movement_speed_buff = "ogryn_stun_movement_seed_up",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			hit_react_anim_1p = "shake_light",
			stun = {
				intoxication_level = 0,
				stun_duration = 0,
				action_delay = 0
			}
		},
		ogryn_medium = {
			sound_event = "wwise/events/player/play_player_get_hit_light_2d",
			movement_speed_buff = "ogryn_stun_movement_seed_up",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_light",
			hit_react_anim_1p = "shake_medium",
			stun = {
				intoxication_level = 0,
				stun_duration = 0,
				action_delay = 0
			}
		},
		ogryn_heavy = {
			sound_event = "wwise/events/player/play_player_get_hit_heavy_2d",
			movement_speed_buff = "ogryn_stun_movement_seed_up",
			screen_space_effect = "content/fx/particles/screenspace/screen_stunned_heavy",
			hit_react_anim_1p = "shake_heavy",
			stun = {
				intoxication_level = 0,
				stun_duration = 0,
				action_delay = 0
			}
		}
	},
	disorientation_types = table.enum(unpack(table.keys(disorientation_settings.disorientation_templates)))
}

return settings("DisorientationSettings", disorientation_settings)
