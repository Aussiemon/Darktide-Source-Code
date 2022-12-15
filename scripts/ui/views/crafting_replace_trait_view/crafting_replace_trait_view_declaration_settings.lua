local view_settings = {
	package = "packages/ui/views/crafting_replace_trait_view/crafting_replace_trait_view",
	display_name = "loc_crafting_view_display_name",
	class = "CraftingReplaceTraitView",
	disable_game_world = true,
	state_bound = true,
	path = "scripts/ui/views/crafting_replace_trait_view/crafting_replace_trait_view",
	levels = {
		"content/levels/ui/crafting_view/crafting_view"
	},
	testify_flags = {
		ui_views = false
	}
}

return settings("CraftingReplaceTraitViewDeclarationSettings", view_settings)
