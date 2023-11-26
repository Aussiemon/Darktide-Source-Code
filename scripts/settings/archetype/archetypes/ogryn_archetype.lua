-- chunkname: @scripts/settings/archetype/archetypes/ogryn_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSpecializations = require("scripts/settings/ability/archetype_specializations/archetype_specializations")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_description = "loc_class_ogryn_description",
	name = "ogryn",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/ogryn_terminal_shadow",
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/ogryn_tree",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_ogryn/class_selection_ogryn",
	archetype_class_selection_icon = "content/ui/materials/frames/class_selection_top_ogryn",
	archetype_title = "loc_class_ogryn_title",
	base_critical_strike_chance = 0.025,
	archetype_badge = "content/ui/materials/icons/class_badges/ogryn_01_01",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/ogryn",
	ui_selection_order = 4,
	talents_package_path = "packages/ui/views/talents_view/ogryn",
	string_symbol = "",
	archetype_name = "loc_class_ogryn_name",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/ogryn_terminal",
	archetype_icon_large = "content/ui/materials/icons/classes/ogryn",
	health = 300,
	breed = "ogryn",
	archetype_background_large = "content/ui/materials/icons/classes/large/ogryn",
	knocked_down_health = 1000,
	toughness = ArchetypeToughnessTemplates.ogryn,
	dodge = ArchetypeDodgeTemplates.ogryn,
	sprint = ArchetypeSprintTemplates.ogryn,
	stamina = ArchetypeStaminaTemplates.ogryn,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	selection_sound_event = UISoundEvents.character_create_archetype_ogryn,
	specializations = ArchetypeSpecializations.ogryn,
	talents = ArchetypeTalents.ogryn,
	base_talents = {
		ogryn_melee_damage_coherency = 1,
		ogryn_charge = 1,
		ogryn_grenade_box = 1,
		ogryn_helping_hand = 1,
		ogryn_base_tank_passive = 1
	}
}

return archetype_data
