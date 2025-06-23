-- chunkname: @scripts/ui/views/horde_play_view/horde_play_view_declaration_settings.lua

local view_settings = {
	package = "packages/ui/views/horde_play_view/horde_play_view",
	state_bound = true,
	class = "HordePlayView",
	disable_game_world = true,
	load_in_hub = true,
	path = "scripts/ui/views/horde_play_view/horde_play_view",
	testify_flags = {
		ui_views = false
	}
}

return settings("HordePlayViewDeclarationSettings", view_settings)
