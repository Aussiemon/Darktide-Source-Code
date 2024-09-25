-- chunkname: @scripts/ui/views/crafting_mechanicus_replace_trait_view/crafting_mechanicus_replace_trait_view_declaration_settings.lua

local view_settings = {
	class = "CraftingReplaceTraitView",
	disable_game_world = true,
	display_name = "loc_crafting_view_display_name",
	load_in_hub = true,
	package = "packages/ui/views/crafting_mechanicus_replace_trait_view/crafting_mechanicus_replace_trait_view",
	path = "scripts/ui/views/crafting_mechanicus_replace_trait_view/crafting_mechanicus_replace_trait_view",
	state_bound = true,
	levels = {
		"content/levels/ui/crafting_view_itemization/crafting_view_itemization",
	},
	testify_flags = {
		ui_views = false,
	},
}

return settings("CraftingMechanicusReplaceTraitViewDeclarationSettings", view_settings)
