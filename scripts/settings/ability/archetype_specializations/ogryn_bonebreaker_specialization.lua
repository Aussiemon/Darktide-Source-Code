local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local archetype_specialization = {
	description_short = "loc_archetype_specialization_ogryn_2_description_short",
	name = "ogryn_2",
	background_large = "content/ui/materials/placeholders/ability_backgrounds/ogryn_2",
	video = "content/videos/class_selection/ogryn_2",
	choice_banner = "content/ui/materials/backgrounds/careers/ogryn_career_2",
	title = "loc_archetype_specialization_ogryn_2",
	show_in_debug_selection = true,
	base_critical_strike_chance = 0.05,
	choice_order = 2,
	description = "loc_archetype_specialization_ogryn_2_description",
	archetype = "ogryn",
	specialization_banner = "content/ui/textures/icons/class_illustrations/bonebreaker",
	health = 300,
	knocked_down_health = 1000,
	toughness = ArchetypeToughnessTemplates.ogryn,
	dodge = ArchetypeDodgeTemplates.ogryn,
	sprint = ArchetypeSprintTemplates.ogryn,
	stamina = ArchetypeStaminaTemplates.ogryn,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	unique_weapons = {
		{
			item = "content/items/weapons/player/melee/ogryn_slabshield_p1_m1",
			display_name = "loc_class_selection_unique_weapon_ogryn_melee_1"
		},
		{
			item = "content/items/weapons/player/ranged/ogryn_gauntlet_p1_m1",
			display_name = "loc_class_selection_unique_weapon_ogryn_ranged_1"
		}
	},
	talent_groups = {
		{
			group_name = "combat",
			non_selectable_group = true,
			required_level = 1,
			talents = {
				"ogryn_2_combat_ability"
			}
		},
		{
			group_name = "tactical",
			non_selectable_group = true,
			required_level = 1,
			talents = {
				"ogryn_2_grenade"
			}
		},
		{
			group_name = "aura",
			non_selectable_group = true,
			required_level = 1,
			talents = {
				"ogryn_2_base_4"
			}
		},
		{
			group_name = "passive",
			non_selectable_group = true,
			required_level = 1,
			talents = {
				"ogryn_2_base_1",
				"ogryn_2_base_2",
				"ogryn_2_base_3"
			}
		},
		{
			non_selectable_group = true,
			invisible_in_ui = true,
			required_level = 1,
			talents = {
				"ogryn_2_charge_buff"
			}
		},
		{
			group_name = "tier_1",
			required_level = 5,
			talents = {
				"ogryn_2_tier_1_name_1",
				"ogryn_2_tier_1_name_2",
				"ogryn_2_tier_1_name_3"
			}
		},
		{
			group_name = "tier_2",
			required_level = 10,
			talents = {
				"ogryn_2_tier_2_name_1",
				"ogryn_2_tier_2_name_2",
				"ogryn_2_tier_2_name_3"
			}
		},
		{
			group_name = "tier_3",
			required_level = 15,
			talents = {
				"ogryn_2_tier_3_name_1",
				"ogryn_2_tier_3_name_2",
				"ogryn_2_tier_3_name_3"
			}
		},
		{
			group_name = "tier_4",
			required_level = 20,
			talents = {
				"ogryn_2_tier_4_name_1",
				"ogryn_2_tier_4_name_2",
				"ogryn_2_tier_4_name_3"
			}
		},
		{
			group_name = "tier_5",
			required_level = 25,
			talents = {
				"ogryn_2_tier_5_name_1",
				"ogryn_2_tier_5_name_2",
				"ogryn_2_tier_5_name_3"
			}
		},
		{
			group_name = "tier_6",
			required_level = 30,
			talents = {
				"ogryn_2_tier_6_name_1",
				"ogryn_2_tier_6_name_2",
				"ogryn_2_tier_6_name_3"
			}
		}
	}
}

return archetype_specialization
