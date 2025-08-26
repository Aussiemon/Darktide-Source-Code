-- chunkname: @scripts/ui/views/havoc_play_view/havoc_play_view_declaration_settings.lua

local view_settings = {
	class = "HavocPlayView",
	disable_game_world = true,
	package = "packages/ui/views/havoc_play_view/havoc_play_view",
	path = "scripts/ui/views/havoc_play_view/havoc_play_view",
	preload_in_hub = "not_ps5_nor_lockhart",
	state_bound = true,
	testify_flags = {
		ui_views = false,
	},
}

return settings("HavocPlayViewDeclarationSettings", view_settings)
