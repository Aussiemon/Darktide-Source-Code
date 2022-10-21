local ArchetypeSpecializations = require("scripts/settings/ability/archetype_specializations/archetype_specializations")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_description = "loc_class_ogryn_description",
	name = "ogryn",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/ogryn_terminal_shadow",
	ui_selection_order = 4,
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/ogryn",
	archetype_name = "loc_class_ogryn_name",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/ogryn_terminal",
	archetype_icon_large = "content/ui/materials/icons/classes/ogryn",
	archetype_title = "loc_class_ogryn_title",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_ogryn/class_selection_ogryn",
	archetype_badge = "content/ui/materials/icons/class_badges/ogryn_01_01",
	breed = "ogryn",
	archetype_background_large = "content/ui/materials/icons/classes/large/ogryn",
	selection_sound_event = UISoundEvents.character_create_archetype_ogryn,
	specializations = ArchetypeSpecializations.ogryn,
	talents = ArchetypeTalents.ogryn
}

return archetype_data
