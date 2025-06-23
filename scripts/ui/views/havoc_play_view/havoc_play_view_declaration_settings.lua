-- chunkname: @scripts/ui/views/havoc_play_view/havoc_play_view_declaration_settings.lua

local view_settings = {
	package = "packages/ui/views/havoc_play_view/havoc_play_view",
	state_bound = true,
	class = "HavocPlayView",
	disable_game_world = true,
	load_in_hub = true,
	path = "scripts/ui/views/havoc_play_view/havoc_play_view",
	testify_flags = {
		ui_views = false
	}
}

return settings("HavocPlayViewDeclarationSettings", view_settings)
