-- chunkname: @scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	state_bound = true,
	use_transition_ui = false,
	path = "scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view",
	package = "packages/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view",
	class = "HavocRewardPresentationView",
	disable_game_world = false,
	load_in_hub = true,
	game_world_blur = 1.1,
	testify_flags = {
		ui_views = false
	},
	wwise_states = {
		music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.loadout
	}
}

return settings("HavocRewardPresentationViewDeclarationSettings", view_settings)
