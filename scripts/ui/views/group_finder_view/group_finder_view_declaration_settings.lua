-- chunkname: @scripts/ui/views/group_finder_view/group_finder_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "GroupFinderView",
	disable_game_world = true,
	display_name = "loc_crafting_view_display_name",
	killswitch = "show_group_finder",
	killswitch_unavailable_description = "loc_popup_unavailable_view_group_finder_description",
	killswitch_unavailable_header = "loc_action_interaction_unavailable",
	package = "packages/ui/views/group_finder_view/group_finder_view",
	path = "scripts/ui/views/group_finder_view/group_finder_view",
	state_bound = true,
	use_transition_ui = true,
	levels = {
		"content/levels/ui/group_finder/group_finder",
	},
	enter_sound_events = {
		UISoundEvents.group_finder_enter,
	},
	exit_sound_events = {
		UISoundEvents.group_finder_exit,
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
	},
}

return settings("GroupFinderViewDeclarationSettings", view_settings)
