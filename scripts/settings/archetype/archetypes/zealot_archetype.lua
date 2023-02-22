local ArchetypeSpecializations = require("scripts/settings/ability/archetype_specializations/archetype_specializations")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_description = "loc_class_zealot_description",
	name = "zealot",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/zealot_terminal_shadow",
	archetype_title = "loc_class_zealot_title",
	archetype_badge = "content/ui/materials/icons/class_badges/zealot_01_01",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_zealot/class_selection_zealot",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/zealot",
	ui_selection_order = 2,
	string_symbol = "",
	archetype_name = "loc_class_zealot_name",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/zealot_terminal",
	archetype_icon_large = "content/ui/materials/icons/classes/zealot",
	breed = "human",
	archetype_background_large = "content/ui/materials/icons/classes/large/zealot",
	archetype_class_selection_icon = "content/ui/materials/frames/class_selection_top_zealot",
	selection_sound_event = UISoundEvents.character_create_archetype_zealot,
	specializations = ArchetypeSpecializations.zealot,
	talents = ArchetypeTalents.zealot
}

return archetype_data
