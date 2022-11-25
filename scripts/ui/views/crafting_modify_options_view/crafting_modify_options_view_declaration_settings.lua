local view_settings = {
	package = "packages/ui/views/crafting_modify_options_view/crafting_modify_options_view",
	display_name = "loc_crafting_view_display_name",
	class = "CraftingModifyView",
	disable_game_world = true,
	state_bound = true,
	path = "scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view",
	levels = {
		"content/levels/ui/crafting_view/crafting_view"
	},
	testify_flags = {
		ui_views = false
	}
}

return settings("CraftingModifyOptionsViewDeclarationSettings", view_settings)
