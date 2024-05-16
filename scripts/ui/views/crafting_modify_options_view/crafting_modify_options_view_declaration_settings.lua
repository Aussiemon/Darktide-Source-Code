-- chunkname: @scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_declaration_settings.lua

local view_settings = {
	class = "CraftingModifyView",
	disable_game_world = true,
	display_name = "loc_crafting_view_display_name",
	load_in_hub = true,
	package = "packages/ui/views/crafting_modify_options_view/crafting_modify_options_view",
	path = "scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view",
	state_bound = true,
	levels = {
		"content/levels/ui/crafting_view/crafting_view",
	},
	testify_flags = {
		ui_views = false,
	},
}

return settings("CraftingModifyOptionsViewDeclarationSettings", view_settings)
