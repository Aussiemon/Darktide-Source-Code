local ArchetypeSpecializations = require("scripts/settings/ability/archetype_specializations/archetype_specializations")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_description = "loc_class_veteran_description",
	name = "veteran",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/veteran_terminal_shadow",
	ui_selection_order = 1,
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/veteran",
	archetype_name = "loc_class_veteran_name",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/veteran_terminal",
	archetype_icon_large = "content/ui/materials/icons/classes/veteran",
	archetype_title = "loc_class_veteran_title",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_veteran/class_selection_veteran",
	archetype_badge = "content/ui/materials/icons/class_badges/veteran_01_01",
	breed = "human",
	archetype_background_large = "content/ui/materials/icons/classes/large/veteran",
	selection_sound_event = UISoundEvents.character_create_archetype_veteran,
	specializations = ArchetypeSpecializations.veteran,
	talents = ArchetypeTalents.veteran
}

return archetype_data
