local view_settings = {
	display_name = "loc_crafting_view_display_name",
	state_bound = true,
	path = "scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view",
	package = "packages/ui/views/crafting_modify_options_view/crafting_modify_options_view",
	class = "CraftingModifyView",
	disable_game_world = true,
	load_in_hub = true,
	levels = {
		"content/levels/ui/crafting_view/crafting_view"
	},
	testify_flags = {
		ui_views = false
	}
}

return settings("CraftingModifyOptionsViewDeclarationSettings", view_settings)
