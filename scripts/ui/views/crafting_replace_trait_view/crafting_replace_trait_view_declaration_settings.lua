-- chunkname: @scripts/ui/views/crafting_replace_trait_view/crafting_replace_trait_view_declaration_settings.lua

local view_settings = {
	class = "CraftingReplaceTraitView",
	disable_game_world = true,
	display_name = "loc_crafting_view_display_name",
	package = "packages/ui/views/crafting_replace_trait_view/crafting_replace_trait_view",
	path = "scripts/ui/views/crafting_replace_trait_view/crafting_replace_trait_view",
	preload_in_hub = "always",
	state_bound = true,
	levels = {
		"content/levels/ui/crafting_view_itemization/crafting_view_itemization",
	},
	testify_flags = {
		ui_views = false,
	},
}

return settings("CraftingReplaceTraitViewDeclarationSettings", view_settings)
