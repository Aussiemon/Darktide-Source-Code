local ArchetypeSpecializations = require("scripts/settings/ability/archetype_specializations/archetype_specializations")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_description = "loc_class_psyker_description",
	name = "psyker",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/psyker_terminal_shadow",
	string_symbol = "",
	archetype_title = "loc_class_psyker_title",
	archetype_badge = "content/ui/materials/icons/class_badges/psyker_01_01",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_psyker/class_selection_psyker",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/psyker",
	ui_selection_order = 3,
	archetype_name = "loc_class_psyker_name",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/psyker_terminal",
	archetype_icon_large = "content/ui/materials/icons/classes/psyker",
	breed = "human",
	archetype_background_large = "content/ui/materials/icons/classes/large/psyker",
	selection_sound_event = UISoundEvents.character_create_archetype_psyker,
	specializations = ArchetypeSpecializations.psyker,
	talents = ArchetypeTalents.psyker
}

return archetype_data
