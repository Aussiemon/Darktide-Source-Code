-- chunkname: @scripts/ui/views/crafting_mechanicus_upgrade_expertise_view/crafting_mechanicus_upgrade_expertise_view_declaration_settings.lua

local view_settings = {
	class = "CraftingMechanicusUpgradeExpertiseView",
	disable_game_world = true,
	display_name = "loc_crafting_view_display_name",
	load_in_hub = true,
	package = "packages/ui/views/crafting_mechanicus_upgrade_expertise_view/crafting_mechanicus_upgrade_expertise_view",
	path = "scripts/ui/views/crafting_mechanicus_upgrade_expertise_view/crafting_mechanicus_upgrade_expertise_view",
	state_bound = true,
	levels = {
		"content/levels/ui/crafting_view_itemization/crafting_view_itemization",
	},
	testify_flags = {
		ui_views = false,
	},
}

return settings("CraftingMechanicusUpgradeExpertiseViewDeclarationSettings", view_settings)
