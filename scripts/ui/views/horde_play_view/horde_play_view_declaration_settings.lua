-- chunkname: @scripts/ui/views/horde_play_view/horde_play_view_declaration_settings.lua

local view_settings = {
	class = "HordePlayView",
	disable_game_world = true,
	package = "packages/ui/views/horde_play_view/horde_play_view",
	path = "scripts/ui/views/horde_play_view/horde_play_view",
	preload_in_hub = "not_ps5",
	state_bound = true,
	testify_flags = {
		ui_views = false,
	},
}

return settings("HordePlayViewDeclarationSettings", view_settings)
