local WarpCharge = require("scripts/utilities/warp_charge")
local mood_settings = {}
local types = table.enum("last_wound", "critical_health", "knocked_down", "toughness_broken", "no_toughness", "suppression_ongoing", "suppression_low", "suppression_high", "damage_taken", "toughness_absorbed", "toughness_absorbed_melee", "corruption_taken", "corruption", "sprinting", "sprinting_overtime", "stealth", "zealot_maniac_combat_ability", "ogryn_bonebreaker_combat_ability", "veteran_ranger_combat_ability", "psyker_biomancer_combat_ability", "corruptor_proximity", "warped", "warped_low_to_high", "warped_high_to_critical", "warped_critical")
local status = table.enum("active", "inactive", "removing")
mood_settings.mood_types = types
mood_settings.status = status
mood_settings.priority = {
	types.stealth,
	types.last_wound,
	types.critical_health,
	types.knocked_down,
	types.no_toughness,
	types.suppression_ongoing,
	types.suppression_low,
	types.suppression_high,
	types.damage_taken,
	types.toughness_absorbed,
	types.toughness_absorbed_melee,
	types.corruption_taken,
	types.corruption,
	types.sprinting,
	types.sprinting_overtime,
	types.warped,
	types.warped_low_to_high,
	types.warped_high_to_critical,
	types.warped_critical,
	types.zealot_maniac_combat_ability,
	types.veteran_ranger_combat_ability,
	types.psyker_biomancer_combat_ability,
	types.corruptor_proximity
}
mood_settings.moods = {
	[types.stealth] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		shading_environment = "content/shading_environments/moods/last_wound_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_zealot_stealth"
		},
		looping_sound_start_events = {
			"wwise/events/player/play_zealot_ability_invisible_on"
		},
		looping_sound_stop_events = {
			"wwise/events/player/play_zealot_ability_invisible_off"
		}
	},
	[types.last_wound] = {
		shading_environment = "content/shading_environments/moods/last_wound_mood",
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.knocked_down] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		shading_environment = "content/shading_environments/moods/knocked_down_mood",
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/player_damage"
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		looping_sound_start_events = {
			"wwise/events/player/play_player_experience_heart_beat"
		},
		looping_sound_stop_events = {
			"wwise/events/player/stop_player_experience_heart_beat"
		}
	},
	[types.toughness_broken] = {
		blend_in_time = 0.15,
		blend_out_time = 0.36,
		active_time = 0.5,
		sound_start_event = "wwise/events/debug/play_toughness_break",
		shading_environment = "content/shading_environments/moods/thoughness_broken_mood",
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/toughness_break"
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.no_toughness] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		sound_stop_event = "wwise/events/player/play_toughness_regen",
		shading_environment = "content/shading_environments/moods/no_toughness_mood",
		particle_effects_on_exit = {
			"content/fx/particles/screenspace/toughness_restored"
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		sound_stop_event_func = function (unit)
			local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
			local current_toughness = toughness_extension and toughness_extension:current_toughness_percent() or 0

			return current_toughness > 0
		end
	},
	[types.suppression_ongoing] = {
		shading_environment = "content/shading_environments/moods/suppression_mood",
		blend_in_time = 0.1,
		blend_out_time = 1.2,
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.suppression_low] = {
		blend_in_time = 0.025,
		blend_out_time = 0.05,
		active_time = 0.05,
		shading_environment = "content/shading_environments/moods/suppression_low_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.suppression_high] = {
		blend_in_time = 0.025,
		blend_out_time = 0.05,
		active_time = 0.05,
		shading_environment = "content/shading_environments/moods/suppression_high_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.critical_health] = {
		blend_in_time = 0.025,
		blend_out_time = 0.5,
		shading_environment = "content/shading_environments/moods/critical_health_mood",
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/player_damage_critical"
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		looping_sound_start_events = {
			"wwise/events/player/play_player_experience_heart_beat"
		},
		looping_sound_stop_events = {
			"wwise/events/player/stop_player_experience_heart_beat"
		}
	},
	[types.damage_taken] = {
		blend_in_time = 0.01,
		blend_out_time = 0.2,
		active_time = 0.05,
		shading_environment = "content/shading_environments/moods/damage_hit_mood",
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/player_damage"
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.toughness_absorbed] = {
		active_time = 0.1,
		blend_in_time = 0.1,
		blend_out_time = 0.1,
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/toughness"
		}
	},
	[types.toughness_absorbed_melee] = {
		active_time = 0.1,
		blend_in_time = 0.1,
		blend_out_time = 0.1,
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/toughness"
		}
	},
	[types.corruption_taken] = {
		active_time = 0.05,
		blend_in_time = 0.01,
		blend_out_time = 0.01,
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/screen_corruption_hit"
		}
	},
	[types.corruption] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_corruption_persistant"
		}
	},
	[types.sprinting] = {
		blend_out_time = 0.2,
		blend_in_time = 0.1
	},
	[types.sprinting_overtime] = {
		blend_in_time = 0.1,
		blend_out_time = 0.1
	},
	[types.zealot_maniac_combat_ability] = {
		shading_environment = "content/shading_environments/moods/zealot_combat_ability_mood",
		blend_in_time = 0.1,
		blend_out_time = 0.2,
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.ogryn_bonebreaker_combat_ability] = {
		shading_environment = "content/shading_environments/moods/zealot_combat_ability_mood",
		blend_in_time = 0.1,
		blend_out_time = 0.2,
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.veteran_ranger_combat_ability] = {
		shading_environment = "content/shading_environments/moods/veteran_combat_ability_mood",
		blend_in_time = 0.1,
		blend_out_time = 0.2,
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.psyker_biomancer_combat_ability] = {
		blend_in_time = 0.03,
		blend_out_time = 0.15,
		shading_environment = "content/shading_environments/moods/psyker_shout_mood",
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/screen_psyker_shout"
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.corruptor_proximity] = {
		shading_environment = "content/shading_environments/moods/corruptor_proximity_mood",
		blend_in_time = 0.15,
		blend_out_time = 0.15,
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES
	},
	[types.warped] = {
		blend_in_time = 0.03,
		blend_out_time = 0.03,
		looping_sound_start_events = {
			"wwise/events/player/play_warp_charge_build_up_loop"
		},
		looping_sound_stop_events = {
			"wwise/events/player/stop_warp_charge_build_up_loop"
		},
		source_parameters = {
			"psyker_overload"
		},
		source_parameter_func = function (player)
			local camera_handler = player.camera_handler
			local is_observing = camera_handler and camera_handler:is_observing()

			if is_observing then
				local observed_unit = camera_handler:camera_follow_unit()
				player = Managers.state.player_unit_spawn:owner(observed_unit)
			end

			local unit_data_extension = ScriptUnit.has_extension(player.player_unit, "unit_data_system")

			if unit_data_extension then
				local warp_charge_component = unit_data_extension:read_component("warp_charge")

				return warp_charge_component.current_percentage
			end

			return 0
		end
	},
	[types.warped_low_to_high] = {
		blend_in_time = 0.03,
		blend_out_time = 0.03,
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_psyker_overheat"
		},
		particles_material_scalars = {
			{
				on_screen_cloud_name = "warp",
				on_screen_variable_name = "chaos_blend",
				scalar_func = function (player, last_value)
					local camera_handler = player.camera_handler
					local is_observing = camera_handler:is_observing()

					if is_observing then
						local observed_unit = camera_handler:camera_follow_unit()
						player = Managers.state.player_unit_spawn:owner(observed_unit)
					end

					local unit_data_extension = ScriptUnit.has_extension(player.player_unit, "unit_data_system")

					if unit_data_extension then
						local specialization_warp_charge_template = WarpCharge.specialization_warp_charge_template(player)
						local weapon_warp_charge_template = WarpCharge.weapon_warp_charge_template(player.player_unit)
						local dt = Managers.time:delta_time("gameplay")
						local warp_charge_component = unit_data_extension:read_component("warp_charge")
						local current_percent = warp_charge_component.current_percentage
						local base_low_threshold = specialization_warp_charge_template.low_threshold
						local low_threshold_modifier = weapon_warp_charge_template.low_threshold_modifier or 1
						local low_threshold = base_low_threshold * low_threshold_modifier
						local wanted_value = math.normalize_01(current_percent, low_threshold, 1)
						local current_value = last_value or 0
						local delta = wanted_value - current_value
						local length = math.min(math.abs(delta), dt)
						local dir = math.sign(delta)
						current_value = current_value + dir * length

						return current_value
					end

					return 0
				end
			}
		}
	},
	[types.warped_high_to_critical] = {
		blend_in_time = 0.03,
		sound_start_event = "wwise/events/player/play_warp_charge_build_up_warning",
		blend_out_time = 0.03
	},
	[types.warped_critical] = {
		blend_in_time = 0.03,
		sound_start_event = "wwise/events/player/play_warp_charge_build_up_critical",
		blend_out_time = 0.03,
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_psyker_overheat_critical"
		}
	}
}
local num_moods = 0

for name, settings in pairs(mood_settings.moods) do
	settings.name = name
	num_moods = num_moods + 1
end

mood_settings.num_moods = num_moods

return settings("MoodSettings", mood_settings)
