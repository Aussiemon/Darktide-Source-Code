local BuffSettings = require("scripts/settings/buff/buff_settings")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local templates = {
	psyker_psychic_fortress = {
		unique_buff_id = "psyker_psychic_fortress",
		unique_buff_priority = 1,
		duration = 8,
		class_name = "buff",
		keywords = {
			keywords.psychic_fortress
		},
		stat_buffs = {
			[stat_buffs.damage_taken_multiplier] = 0.9
		},
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_veteran_killshot",
			looping_wwise_start_event = "wwise/events/player/play_player_veteran_combat_ability_enter",
			looping_wwise_stop_event = "wwise/events/player/play_player_veteran_combat_ability_exit",
			wwise_state = {
				group = "player_ability",
				on_state = "psyker_combat_ability",
				off_state = "none"
			}
		}
	},
	psyker_psychic_fortress_duration_increased = {
		unique_buff_id = "psyker_psychic_fortress",
		unique_buff_priority = 1,
		duration = 12,
		class_name = "buff",
		keywords = {
			keywords.psychic_fortress
		},
		stat_buffs = {
			[stat_buffs.damage_taken_multiplier] = 0.9
		},
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_veteran_killshot",
			looping_wwise_start_event = "wwise/events/player/play_player_veteran_combat_ability_enter",
			looping_wwise_stop_event = "wwise/events/player/play_player_veteran_combat_ability_exit",
			wwise_state = {
				group = "player_ability",
				on_state = "psyker_combat_ability",
				off_state = "none"
			}
		}
	}
}

return templates
