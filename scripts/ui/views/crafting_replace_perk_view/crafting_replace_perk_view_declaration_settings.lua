-- chunkname: @scripts/ui/views/crafting_replace_perk_view/crafting_replace_perk_view_declaration_settings.lua

local CraftingReplacePerkViewDeclarationSettings = {
	state_bound = true,
	display_name = "loc_crafting_view_display_name",
	load_in_hub = true,
	path = "scripts/ui/views/crafting_replace_perk_view/crafting_replace_perk_view",
	package = "packages/ui/views/crafting_replace_perk_view/crafting_replace_perk_view",
	class = "CraftingReplacePerkView",
	disable_game_world = true,
	levels = {
		"content/levels/ui/crafting_view/crafting_view"
	},
	enter_sound_events = {},
	exit_sound_events = {},
	testify_flags = {
		ui_views = false
	}
}

return settings("CraftingReplacePerkViewDeclarationSettings", CraftingReplacePerkViewDeclarationSettings)
