local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSpecializations = require("scripts/settings/ability/archetype_specializations/archetype_specializations")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_description = "loc_class_ogryn_description",
	name = "ogryn",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/ogryn_terminal_shadow",
	archetype_title = "loc_class_ogryn_title",
	base_critical_strike_chance = 0.05,
	archetype_badge = "content/ui/materials/icons/class_badges/ogryn_01_01",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_ogryn/class_selection_ogryn",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/ogryn",
	ui_selection_order = 4,
	archetype_name = "loc_class_ogryn_name",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/ogryn_terminal",
	archetype_icon_large = "content/ui/materials/icons/classes/ogryn",
	health = 300,
	breed = "ogryn",
	archetype_background_large = "content/ui/materials/icons/classes/large/ogryn",
	knocked_down_health = 1000,
	toughness = ArchetypeToughnessTemplates.ogryn,
	archetype_unique_weapons = {
		"content/items/weapons/player/ranged/ogryn_rippergun_p1_m1",
		"content/items/weapons/player/ranged/ogryn_thumper_p1_m1",
		"content/items/weapons/player/ranged/stubrifle_p1_m1",
		"content/items/weapons/player/ranged/ogryn_gauntlet_p1_m1",
		"content/items/weapons/player/melee/ogryn_club_p1_m1",
		"content/items/weapons/player/melee/ogryn_club_p2_m1",
		"content/items/weapons/player/melee/ogryn_powermaul_slabshield_p1_m1",
		"content/items/weapons/player/melee/ogryn_combatblade_p1_m1",
		"content/items/weapons/player/melee/ogryn_powermaul_p1_m1"
	},
	selection_sound_event = UISoundEvents.character_create_archetype_ogryn,
	specializations = ArchetypeSpecializations.ogryn,
	talents = ArchetypeTalents.ogryn,
	dodge = ArchetypeDodgeTemplates.ogryn,
	sprint = ArchetypeSprintTemplates.ogryn,
	stamina = ArchetypeStaminaTemplates.ogryn,
	warp_charge = ArchetypeWarpChargeTemplates.default
}

return archetype_data
