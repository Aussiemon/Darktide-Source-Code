-- chunkname: @scripts/settings/archetype/archetypes/zealot_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSpecializations = require("scripts/settings/ability/archetype_specializations/archetype_specializations")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_description = "loc_class_zealot_description",
	name = "zealot",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/zealot_terminal_shadow",
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/zealot_tree",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_zealot/class_selection_zealot",
	archetype_class_selection_icon = "content/ui/materials/frames/class_selection_top_zealot",
	archetype_title = "loc_class_zealot_title",
	base_critical_strike_chance = 0.05,
	archetype_badge = "content/ui/materials/icons/class_badges/zealot_01_01",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/zealot",
	ui_selection_order = 2,
	talents_package_path = "packages/ui/views/talents_view/zealot",
	string_symbol = "",
	archetype_name = "loc_class_zealot_name",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/zealot_terminal",
	archetype_icon_large = "content/ui/materials/icons/classes/zealot",
	health = 200,
	breed = "human",
	archetype_background_large = "content/ui/materials/icons/classes/large/zealot",
	knocked_down_health = 1000,
	toughness = ArchetypeToughnessTemplates.zealot,
	dodge = ArchetypeDodgeTemplates.zealot,
	sprint = ArchetypeSprintTemplates.default,
	stamina = ArchetypeStaminaTemplates.zealot,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	selection_sound_event = UISoundEvents.character_create_archetype_zealot,
	specializations = ArchetypeSpecializations.zealot,
	talents = ArchetypeTalents.zealot,
	base_talents = {
		zealot_shock_grenade = 1,
		zealot_dash = 1,
		zealot_toughness_damage_coherency = 1
	}
}

return archetype_data
