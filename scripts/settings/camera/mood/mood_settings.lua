-- chunkname: @scripts/settings/camera/mood/mood_settings.lua

local WarpCharge = require("scripts/utilities/warp_charge")
local mood_settings = {}
local types = table.enum("corruption_taken", "corruption", "corruptor_proximity", "critical_health", "damage_taken", "knocked_down", "last_wound", "no_toughness", "sprinting_overtime", "sprinting", "suppression_high", "suppression_low", "suppression_ongoing", "toughness_absorbed_melee", "toughness_absorbed", "toughness_broken", "warped_critical", "warped_high_to_critical", "warped_low_to_high", "warped", "ogryn_combat_ability_charge", "ogryn_combat_ability_shout", "ogryn_combat_ability_stance", "psyker_combat_ability_shout", "psyker_force_field_sphere", "stealth", "veteran_stealth", "veteran_combat_ability_stance", "veteran_stealth_and_stance", "zealot_combat_ability_dash", "syringe_ability", "syringe_power", "syringe_speed")
local status = table.enum("active", "inactive", "removing")

mood_settings.mood_types = types
mood_settings.status = status
mood_settings.priority = {
	types.stealth,
	types.veteran_stealth,
	types.veteran_stealth_and_stance,
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
	types.ogryn_combat_ability_charge,
	types.ogryn_combat_ability_shout,
	types.ogryn_combat_ability_stance,
	types.psyker_combat_ability_shout,
	types.veteran_combat_ability_stance,
	types.zealot_combat_ability_dash,
	types.corruptor_proximity,
	types.syringe_ability,
	types.syringe_power,
	types.syringe_speed,
}
mood_settings.moods = {
	[types.stealth] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		shading_environment = "content/shading_environments/moods/stealth_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_zealot_stealth",
		},
		looping_sound_start_events = {
			"wwise/events/player/play_zealot_ability_invisible_on",
		},
		looping_sound_stop_events = {
			"wwise/events/player/play_zealot_ability_invisible_off",
		},
	},
	[types.veteran_stealth] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		shading_environment = "content/shading_environments/moods/veteran_stealth_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_veteran_stealth",
		},
		looping_sound_start_events = {
			"wwise/events/player/play_veteran_ability_stealth_on",
		},
		looping_sound_stop_events = {
			"wwise/events/player/play_veteran_ability_stealth_off",
		},
	},
	[types.veteran_stealth_and_stance] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		shading_environment = "content/shading_environments/moods/stealth_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_veteran_stealth",
		},
		looping_sound_start_events = {
			"wwise/events/player/play_veteran_ability_stealth_and_stance_on",
		},
		looping_sound_stop_events = {
			"wwise/events/player/play_veteran_ability_stealth_and_stance_off",
		},
	},
	[types.last_wound] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		shading_environment = "content/shading_environments/moods/last_wound_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.knocked_down] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		shading_environment = "content/shading_environments/moods/knocked_down_mood",
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/player_damage",
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		looping_sound_start_events = {
			"wwise/events/player/play_player_experience_heart_beat",
		},
		looping_sound_stop_events = {
			"wwise/events/player/stop_player_experience_heart_beat",
		},
	},
	[types.toughness_broken] = {
		active_time = 0.5,
		blend_in_time = 0.15,
		blend_out_time = 0.36,
		shading_environment = "content/shading_environments/moods/thoughness_broken_mood",
		sound_start_event = "wwise/events/player/play_toughness_break",
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/toughness_break",
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.no_toughness] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		shading_environment = "content/shading_environments/moods/no_toughness_mood",
		sound_stop_event = "wwise/events/player/play_toughness_regen",
		particle_effects_on_exit = {
			"content/fx/particles/screenspace/toughness_restored",
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		sound_stop_event_func = function (unit)
			local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
			local current_toughness = toughness_extension and toughness_extension:current_toughness_percent() or 0

			return current_toughness > 0
		end,
	},
	[types.suppression_ongoing] = {
		blend_in_time = 0.1,
		blend_out_time = 1.2,
		shading_environment = "content/shading_environments/moods/suppression_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.suppression_low] = {
		active_time = 0.05,
		blend_in_time = 0.025,
		blend_out_time = 0.05,
		shading_environment = "content/shading_environments/moods/suppression_low_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.suppression_high] = {
		active_time = 0.05,
		blend_in_time = 0.025,
		blend_out_time = 0.05,
		shading_environment = "content/shading_environments/moods/suppression_high_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.critical_health] = {
		blend_in_time = 0.025,
		blend_out_time = 0.5,
		shading_environment = "content/shading_environments/moods/critical_health_mood",
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/player_damage_critical",
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		looping_sound_start_events = {
			"wwise/events/player/play_player_experience_heart_beat",
		},
		looping_sound_stop_events = {
			"wwise/events/player/stop_player_experience_heart_beat",
		},
	},
	[types.damage_taken] = {
		active_time = 0.05,
		blend_in_time = 0.01,
		blend_out_time = 0.2,
		shading_environment = "content/shading_environments/moods/damage_hit_mood",
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/player_damage",
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.toughness_absorbed] = {
		active_time = 0.1,
		blend_in_time = 0.1,
		blend_out_time = 0.1,
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/toughness",
		},
	},
	[types.toughness_absorbed_melee] = {
		active_time = 0.1,
		blend_in_time = 0.1,
		blend_out_time = 0.1,
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/toughness",
		},
	},
	[types.corruption_taken] = {
		active_time = 0.05,
		blend_in_time = 0.01,
		blend_out_time = 0.01,
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/screen_corruption_hit",
		},
	},
	[types.corruption] = {
		blend_in_time = 0.35,
		blend_out_time = 0.8,
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_corruption_persistant",
		},
	},
	[types.sprinting] = {
		blend_in_time = 0.1,
		blend_out_time = 0.2,
	},
	[types.sprinting_overtime] = {
		blend_in_time = 0.1,
		blend_out_time = 0.1,
	},
	[types.zealot_combat_ability_dash] = {
		blend_in_time = 0.1,
		blend_out_time = 0.2,
		shading_environment = "content/shading_environments/moods/zealot_combat_ability_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.ogryn_combat_ability_charge] = {
		blend_in_time = 0.1,
		blend_out_time = 0.2,
		shading_environment = "content/shading_environments/moods/zealot_combat_ability_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.ogryn_combat_ability_shout] = {
		blend_in_time = 0.1,
		blend_out_time = 0.2,
		shading_environment = "content/shading_environments/moods/ogryn_taunt_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.ogryn_combat_ability_stance] = {
		blend_in_time = 0.03,
		blend_out_time = 0.03,
		shading_environment = "content/shading_environments/moods/ogryn_taunt_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_ogryn_gunlugger",
		},
		looping_sound_start_events = {
			"wwise/events/player/play_ability_ogryn_speshul_ammo",
		},
		looping_sound_stop_events = {
			"wwise/events/player/stop_ability_ogryn_speshul_ammo",
		},
		wwise_state = {
			group = "player_ability",
			off_state = "none",
			on_state = "ogryn_stance",
		},
	},
	[types.veteran_combat_ability_stance] = {
		blend_in_time = 0.1,
		blend_out_time = 0.2,
		shading_environment = "content/shading_environments/moods/veteran_combat_ability_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.psyker_combat_ability_shout] = {
		blend_in_time = 0.03,
		blend_out_time = 0.15,
		shading_environment = "content/shading_environments/moods/psyker_shout_mood",
		particle_effects_on_enter = {
			"content/fx/particles/screenspace/screen_psyker_shout",
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.corruptor_proximity] = {
		blend_in_time = 0.15,
		blend_out_time = 0.15,
		shading_environment = "content/shading_environments/moods/corruptor_proximity_mood",
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
	},
	[types.warped] = {
		blend_in_time = 0.03,
		blend_out_time = 0.03,
		looping_sound_start_events = {
			"wwise/events/player/play_warp_charge_build_up_loop",
		},
		looping_sound_stop_events = {
			"wwise/events/player/stop_warp_charge_build_up_loop",
		},
		source_parameter_funcs = {
			function (wwise_world, source_id, player)
				local camera_handler = player.camera_handler
				local is_observing = camera_handler and camera_handler:is_observing()

				if is_observing then
					local observed_unit = camera_handler:camera_follow_unit()

					player = Managers.state.player_unit_spawn:owner(observed_unit)
				end

				local psyker_overload = 0
				local unit_data_extension = ScriptUnit.has_extension(player.player_unit, "unit_data_system")

				if unit_data_extension then
					local warp_charge_component = unit_data_extension:read_component("warp_charge")

					psyker_overload = warp_charge_component.current_percentage
				end

				WwiseWorld.set_source_parameter(wwise_world, source_id, "psyker_overload", psyker_overload)

				local options_peril_slider = Application.user_setting("interface_settings", "psyker_overload_intensity") or 100

				WwiseWorld.set_global_parameter(wwise_world, "options_peril_slider", options_peril_slider / 100)
			end,
		},
	},
	[types.warped_low_to_high] = {
		blend_in_time = 0.03,
		blend_out_time = 0.03,
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_psyker_overheat",
		},
		particle_material_scalar_funcs = {
			function (world, particle_id, player, previous_values)
				local camera_handler = player.camera_handler
				local is_observing = camera_handler:is_observing()

				if is_observing then
					local observed_unit = camera_handler:camera_follow_unit()

					player = Managers.state.player_unit_spawn:owner(observed_unit)
				end

				local unit_data_extension = ScriptUnit.has_extension(player.player_unit, "unit_data_system")

				if unit_data_extension then
					local base_warp_charge_template = WarpCharge.archetype_warp_charge_template(player)
					local weapon_warp_charge_template = WarpCharge.weapon_warp_charge_template(player.player_unit)
					local dt = Managers.time:delta_time("gameplay")
					local warp_charge_component = unit_data_extension:read_component("warp_charge")
					local current_percent = warp_charge_component.current_percentage
					local base_low_threshold = base_warp_charge_template.low_threshold
					local low_threshold_modifier = weapon_warp_charge_template.low_threshold_modifier or 1
					local low_threshold = base_low_threshold * low_threshold_modifier
					local wanted_value = math.normalize_01(current_percent, low_threshold, 1)
					local last_value = previous_values.chaos_blend or 0
					local delta = wanted_value - last_value
					local length = math.min(math.abs(delta), dt)
					local dir = math.sign(delta)
					local current_value = last_value + dir * length

					World.set_particles_material_scalar(world, particle_id, "warp", "chaos_blend", current_value)

					previous_values.chaos_blend = current_value

					local options_peril_slider = Application.user_setting("interface_settings", "psyker_overload_intensity") or 100

					World.set_particles_material_scalar(world, particle_id, "warp", "options_peril_slider_vfx", options_peril_slider / 100)
				end
			end,
		},
	},
	[types.warped_high_to_critical] = {
		blend_in_time = 0.03,
		blend_out_time = 0.03,
		sound_start_event = "wwise/events/player/play_warp_charge_build_up_warning",
	},
	[types.warped_critical] = {
		blend_in_time = 0.03,
		blend_out_time = 0.03,
		sound_start_event = "wwise/events/player/play_warp_charge_build_up_critical",
		particle_effects_looping = {
			"content/fx/particles/screenspace/screen_psyker_overheat_critical",
		},
	},
	[types.psyker_force_field_sphere] = {
		blend_in_time = 0,
		blend_out_time = 0.01,
		looping_sound_start_events = {
			"wwise/events/player/play_psyker_shield_dome_enter",
		},
		looping_sound_stop_events = {
			"wwise/events/player/play_psyker_shield_dome_exit",
		},
		wwise_state = {
			group = "player_state",
			off_state = "none",
			on_state = "psyker_shield",
		},
	},
	[types.syringe_ability] = {
		blend_in_time = 0.1,
		blend_out_time = 0.2,
		shading_environment = "content/shading_environments/moods/stimms_concentration_yellow_mood_01",
		looping_sound_start_events = {
			"wwise/events/player/play_syringe_ability_start",
		},
		looping_sound_stop_events = {
			"wwise/events/player/play_syringe_ability_stop",
		},
		particle_effects_looping = {
			"content/fx/particles/screenspace/player_screen_stimms_concentration_yellow_01",
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		wwise_state = {
			group = "player_ability",
			off_state = "none",
			on_state = "syringe_ability",
		},
	},
	[types.syringe_power] = {
		blend_in_time = 0.1,
		blend_out_time = 0.2,
		shading_environment = "content/shading_environments/moods/stimms_power_red_mood_01",
		looping_sound_start_events = {
			"wwise/events/player/play_syringe_power_start",
		},
		looping_sound_stop_events = {
			"wwise/events/player/play_syringe_power_stop",
		},
		particle_effects_looping = {
			"content/fx/particles/screenspace/player_screen_stimms_power_red_01",
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		wwise_state = {
			group = "player_ability",
			off_state = "none",
			on_state = "syringe_power",
		},
	},
	[types.syringe_speed] = {
		blend_in_time = 0.1,
		blend_out_time = 0.2,
		shading_environment = "content/shading_environments/moods/stimms_speed_blue_mood_01",
		looping_sound_start_events = {
			"wwise/events/player/play_syringe_speed_start",
		},
		looping_sound_stop_events = {
			"wwise/events/player/play_syringe_speed_stop",
		},
		particle_effects_looping = {
			"content/fx/particles/screenspace/player_screen_stimms_speed_blue",
		},
		blend_mask = ShadingEnvironmentBlendMask.OVERRIDES,
		wwise_state = {
			group = "player_ability",
			off_state = "none",
			on_state = "syringe_speed",
		},
	},
}

local num_moods = 0

for name, settings in pairs(mood_settings.moods) do
	settings.name = name
	num_moods = num_moods + 1
end

mood_settings.num_moods = num_moods

return settings("MoodSettings", mood_settings)
