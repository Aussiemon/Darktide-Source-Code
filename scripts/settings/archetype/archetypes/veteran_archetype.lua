-- chunkname: @scripts/settings/archetype/archetypes/veteran_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UiSoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_background_large = "content/ui/materials/icons/classes/large/veteran",
	archetype_badge = "content/ui/materials/icons/class_badges/veteran_01_01",
	archetype_description = "loc_class_veteran_description",
	archetype_icon_large = "content/ui/materials/icons/classes/veteran",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/veteran_terminal",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/veteran_terminal_shadow",
	archetype_name = "loc_class_veteran_name",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/veteran",
	archetype_selection_icon = "content/ui/materials/frames/class_selection_top_veteran",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_veteran/class_selection_veteran",
	archetype_title = "loc_class_veteran_title",
	archetype_video = "content/videos/class_selection/veteran_2",
	base_critical_strike_chance = 0.05,
	breed = "human",
	health = 150,
	knocked_down_health = 1000,
	name = "veteran",
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/veteran_tree",
	talents_package_path = "packages/ui/views/talent_builder_view/veteran",
	ui_selection_order = 1,
	toughness = ArchetypeToughnessTemplates.veteran,
	dodge = ArchetypeDodgeTemplates.default,
	sprint = ArchetypeSprintTemplates.default,
	stamina = ArchetypeStaminaTemplates.veteran,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	talents = ArchetypeTalents.veteran,
	base_talents = {
		veteran_aura_gain_ammo_on_elite_kill = 1,
		veteran_combat_ability_stance = 1,
		veteran_cover_peeking = 1,
		veteran_frag_grenade = 1,
	},
	selection_sound_event = UiSoundEvents.character_create_archetype_veteran,
	unique_weapons = {
		{
			display_name = "loc_class_selection_unique_weapon_veteran_melee_1",
			item = "content/items/weapons/player/melee/combataxe_p3_m1",
		},
		{
			display_name = "loc_class_selection_unique_weapon_veteran_ranged_1",
			item = "content/items/weapons/player/ranged/plasmagun_p1_m1",
		},
	},
}

return archetype_data
