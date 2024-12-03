-- chunkname: @scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "HavocRewardPresentationView",
	disable_game_world = false,
	game_world_blur = 1.1,
	load_in_hub = false,
	package = "packages/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view",
	path = "scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view",
	state_bound = true,
	use_transition_ui = false,
	enter_sound_events = {
		UISoundEvents.end_screen_enter,
	},
	exit_sound_events = {
		UISoundEvents.end_screen_exit,
	},
	testify_flags = {
		ui_views = false,
	},
	wwise_states = {
		music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.loadout,
	},
}

return settings("HavocRewardPresentationViewDeclarationSettings", view_settings)
