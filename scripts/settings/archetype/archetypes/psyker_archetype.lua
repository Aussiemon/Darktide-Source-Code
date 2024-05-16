﻿-- chunkname: @scripts/settings/archetype/archetypes/psyker_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_background_large = "content/ui/materials/icons/classes/large/psyker",
	archetype_badge = "content/ui/materials/icons/class_badges/psyker_01_01",
	archetype_description = "loc_class_psyker_description",
	archetype_icon_large = "content/ui/materials/icons/classes/psyker",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/psyker_terminal",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/psyker_terminal_shadow",
	archetype_name = "loc_class_psyker_name",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/psyker",
	archetype_selection_icon = "content/ui/materials/frames/class_selection_top_psyker",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_psyker/class_selection_psyker",
	archetype_title = "loc_class_psyker_title",
	archetype_video = "content/videos/class_selection/psyker_2",
	base_critical_strike_chance = 0.075,
	breed = "human",
	health = 150,
	knocked_down_health = 1000,
	name = "psyker",
	string_symbol = "",
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/psyker_tree",
	talents_package_path = "packages/ui/views/talent_builder_view/psyker",
	ui_selection_order = 3,
	toughness = ArchetypeToughnessTemplates.psyker,
	dodge = ArchetypeDodgeTemplates.psyker,
	sprint = ArchetypeSprintTemplates.psyker,
	stamina = ArchetypeStaminaTemplates.psyker,
	warp_charge = ArchetypeWarpChargeTemplates.psyker,
	specializations = {
		psyker_2 = {
			archetype = "psyker",
			name = "psyker_2",
		},
	},
	talents = ArchetypeTalents.psyker,
	base_talents = {
		psyker_aura_ability_cooldown = 1,
		psyker_combat_ability_shout = 1,
		psyker_grenade_smite = 1,
	},
	selection_sound_event = UISoundEvents.character_create_archetype_psyker,
	unique_weapons = {
		{
			display_name = "loc_class_selection_unique_weapon_psyker_melee_1",
			item = "content/items/weapons/player/melee/forcesword_p1_m1",
		},
		{
			display_name = "loc_class_selection_unique_weapon_psyker_ranged_1",
			item = "content/items/weapons/player/ranged/forcestaff_p1_m1",
		},
	},
}

return archetype_data
