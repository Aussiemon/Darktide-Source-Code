local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSpecializations = require("scripts/settings/ability/archetype_specializations/archetype_specializations")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_description = "loc_class_veteran_description",
	name = "veteran",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/veteran_terminal_shadow",
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/veteran_tree",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_veteran/class_selection_veteran",
	archetype_class_selection_icon = "content/ui/materials/frames/class_selection_top_veteran",
	archetype_title = "loc_class_veteran_title",
	base_critical_strike_chance = 0.05,
	archetype_badge = "content/ui/materials/icons/class_badges/veteran_01_01",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/veteran",
	ui_selection_order = 1,
	talents_package_path = "packages/ui/views/talents_view/veteran",
	string_symbol = "",
	archetype_name = "loc_class_veteran_name",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/veteran_terminal",
	archetype_icon_large = "content/ui/materials/icons/classes/veteran",
	health = 150,
	breed = "human",
	archetype_background_large = "content/ui/materials/icons/classes/large/veteran",
	knocked_down_health = 1000,
	toughness = ArchetypeToughnessTemplates.veteran,
	dodge = ArchetypeDodgeTemplates.default,
	sprint = ArchetypeSprintTemplates.default,
	stamina = ArchetypeStaminaTemplates.veteran,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	selection_sound_event = UISoundEvents.character_create_archetype_veteran,
	specializations = ArchetypeSpecializations.veteran,
	talents = ArchetypeTalents.veteran,
	base_talents = {
		veteran_frag_grenade = 1,
		veteran_cover_peeking = 1,
		veteran_combat_ability_stance = 1,
		veteran_aura_gain_ammo_on_elite_kill = 1
	}
}

return archetype_data
