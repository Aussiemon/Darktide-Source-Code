local CraftingRerollPerkViewDeclarationSettings = {
	state_bound = true,
	display_name = "loc_crafting_view_display_name",
	path = "scripts/ui/views/crafting_reroll_perk_view/crafting_reroll_perk_view",
	package = "packages/ui/views/crafting_reroll_perk_view/crafting_reroll_perk_view",
	class = "CraftingRerollPerkView",
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

return settings("CraftingRerollPerkViewDeclarationSettings", CraftingRerollPerkViewDeclarationSettings)
