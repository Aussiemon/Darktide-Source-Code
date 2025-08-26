-- chunkname: @scripts/ui/views/crafting_replace_perk_view/crafting_replace_perk_view_declaration_settings.lua

local CraftingReplacePerkViewDeclarationSettings = {
	class = "CraftingReplacePerkView",
	disable_game_world = true,
	display_name = "loc_crafting_view_display_name",
	package = "packages/ui/views/crafting_replace_perk_view/crafting_replace_perk_view",
	path = "scripts/ui/views/crafting_replace_perk_view/crafting_replace_perk_view",
	preload_in_hub = "always",
	state_bound = true,
	levels = {
		"content/levels/ui/crafting_view_itemization/crafting_view_itemization",
	},
	enter_sound_events = {},
	exit_sound_events = {},
	testify_flags = {
		ui_views = false,
	},
}

return settings("CraftingReplacePerkViewDeclarationSettings", CraftingReplacePerkViewDeclarationSettings)
