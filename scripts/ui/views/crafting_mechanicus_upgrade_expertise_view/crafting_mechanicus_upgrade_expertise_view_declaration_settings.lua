-- chunkname: @scripts/ui/views/crafting_mechanicus_upgrade_expertise_view/crafting_mechanicus_upgrade_expertise_view_declaration_settings.lua

local view_settings = {
	display_name = "loc_crafting_view_display_name",
	state_bound = true,
	path = "scripts/ui/views/crafting_mechanicus_upgrade_expertise_view/crafting_mechanicus_upgrade_expertise_view",
	package = "packages/ui/views/crafting_mechanicus_upgrade_expertise_view/crafting_mechanicus_upgrade_expertise_view",
	class = "CraftingMechanicusUpgradeExpertiseView",
	disable_game_world = true,
	load_in_hub = true,
	levels = {
		"content/levels/ui/crafting_view_itemization/crafting_view_itemization"
	},
	testify_flags = {
		ui_views = false
	}
}

return settings("CraftingMechanicusUpgradeExpertiseViewDeclarationSettings", view_settings)
