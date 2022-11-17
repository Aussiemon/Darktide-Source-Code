local BuffSettings = require("scripts/settings/buff/buff_settings")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	coherency_aura_lingers = {
		predicted = false,
		class_name = "buff",
		keywords = {
			keywords.no_coherency_stickiness_limit
		},
		stat_buffs = {
			[stat_buffs.coherency_stickiness_time_value] = 5
		}
	},
	shade_invisibility = {
		unique_buff_id = "psyker_invisibility_test",
		duration = 5,
		allow_proc_while_active = true,
		class_name = "proc_buff",
		keywords = {
			keywords.invisible
		},
		stat_buffs = {
			[stat_buffs.movement_speed] = 1.2,
			[stat_buffs.melee_damage] = 1.5
		},
		proc_events = {
			[proc_events.on_hit] = 1
		},
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_zealot_stealth",
			looping_wwise_stop_event = "wwise/events/player/play_zealot_ability_invisible_off",
			looping_wwise_start_event = "wwise/events/player/play_zealot_ability_invisible_on",
			wwise_state = {
				group = "player_ability",
				on_state = "zealot_invisible",
				off_state = "none"
			},
			wwise_parameters = {
				player_zealot_invisible_effect = 1
			}
		},
		proc_func = function (params, template_data, template_context)
			template_data.finish = true
		end,
		conditional_exit_func = function (template_data, template_context)
			return template_data.finish
		end
	},
	shade_invisibility_no_damage_bonus = {
		unique_buff_id = "psyker_invisibility_test",
		allow_proc_while_active = true,
		duration = 5,
		class_name = "proc_buff",
		keywords = {
			keywords.invisible
		},
		stat_buffs = {
			[stat_buffs.movement_speed] = 1.2
		},
		proc_events = {
			[proc_events.on_hit] = 1
		},
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_zealot_stealth",
			looping_wwise_stop_event = "wwise/events/player/play_zealot_ability_invisible_off",
			looping_wwise_start_event = "wwise/events/player/play_zealot_ability_invisible_on",
			wwise_state = {
				group = "player_ability",
				on_state = "zealot_invisible",
				off_state = "none"
			},
			wwise_parameters = {
				player_zealot_invisible_effect = 1
			}
		},
		proc_func = function (params, template_data, template_context)
			template_data.finish = true
		end,
		conditional_exit_func = function (template_data, template_context)
			return template_data.finish
		end
	}
}

return templates
