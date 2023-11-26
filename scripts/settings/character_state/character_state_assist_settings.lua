-- chunkname: @scripts/settings/character_state/character_state_assist_settings.lua

local character_state_assist_settings = {}

character_state_assist_settings.anim_settings = {
	hogtied = {
		start_anim_event = "captured_revived",
		abort_anim_event = "captured_revived_abort"
	},
	knocked_down = {
		abort_anim_event = "revive_abort",
		start_anim_event = "revive_start",
		start_anim_event_fast = "revive_fast_start"
	},
	ledge_hanging = {
		start_anim_event = "ledge_exit",
		abort_anim_event = "ledge_loop"
	},
	netted = {
		start_anim_event = "revive_start",
		abort_anim_event = "revive_abort"
	}
}

return settings("CharacterStateAssistSettings", character_state_assist_settings)
