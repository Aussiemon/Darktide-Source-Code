-- chunkname: @scripts/ui/views/expedition_play_view/expedition_play_view_declaration_settings.lua

local view_settings = {
	class = "ExpeditionPlayView",
	disable_game_world = true,
	package = "packages/ui/views/expedition_play_view/expedition_play_view",
	path = "scripts/ui/views/expedition_play_view/expedition_play_view",
	state_bound = true,
	testify_flags = {
		ui_views = false,
	},
}

return settings("ExpeditionPlayViewDeclarationSettings", view_settings)
