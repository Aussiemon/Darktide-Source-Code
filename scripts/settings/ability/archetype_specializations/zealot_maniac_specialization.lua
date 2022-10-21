local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local archetype_specialization = {
	description_short = "loc_archetype_specialization_zealot_maniac_description_short",
	name = "zealot_2",
	background_large = "content/ui/materials/placeholders/ability_backgrounds/zealot_2",
	video = "content/videos/class_selection/zealot_2",
	choice_banner = "content/ui/materials/backgrounds/careers/zealot_career_2",
	title = "loc_archetype_specialization_zealot_maniac",
	show_in_debug_selection = true,
	base_critical_strike_chance = 0.05,
	choice_order = 2,
	description = "loc_archetype_specialization_zealot_maniac_description",
	archetype = "zealot",
	specialization_banner = "content/ui/textures/icons/class_illustrations/scourge",
	health = 200,
	knocked_down_health = 1000,
	toughness = ArchetypeToughnessTemplates.zealot,
	dodge = ArchetypeDodgeTemplates.default,
	sprint = ArchetypeSprintTemplates.default,
	stamina = ArchetypeStaminaTemplates.zealot,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	unique_weapons = {
		{
			item = "content/items/weapons/player/melee/thunderhammer_2h_p1_m1",
			display_name = "loc_class_selection_unique_weapon_zealot_melee_1"
		},
		{
			item = "content/items/weapons/player/ranged/flamer_p1_m1",
			display_name = "loc_class_selection_unique_weapon_zealot_ranged_1"
		}
	},
	talent_groups = {
		{
			group_name = "combat",
			non_selectable_group = true,
			required_level = 1,
			talents = {
				"zealot_2_combat"
			}
		},
		{
			group_name = "tactical",
			non_selectable_group = true,
			required_level = 1,
			talents = {
				"zealot_2_shock_grenade"
			}
		},
		{
			group_name = "aura",
			non_selectable_group = true,
			required_level = 1,
			talents = {
				"zealot_2_base_3"
			}
		},
		{
			group_name = "passive",
			non_selectable_group = true,
			required_level = 1,
			talents = {
				"zealot_2_base_1",
				"zealot_2_base_2",
				"zealot_2_base_4"
			}
		},
		{
			group_name = "tier_1",
			required_level = 5,
			talents = {
				"zealot_2_tier_1_name_1",
				"zealot_2_tier_1_name_2",
				"zealot_2_tier_1_name_3"
			}
		},
		{
			group_name = "tier_2",
			required_level = 10,
			talents = {
				"zealot_2_tier_2_name_1",
				"zealot_2_tier_2_name_2",
				"zealot_2_tier_2_name_3"
			}
		},
		{
			group_name = "tier_3",
			required_level = 15,
			talents = {
				"zealot_2_tier_3_name_1",
				"zealot_2_tier_3_name_2",
				"zealot_2_tier_3_name_3"
			}
		},
		{
			group_name = "tier_4",
			required_level = 20,
			talents = {
				"zealot_2_tier_4_name_1",
				"zealot_2_tier_4_name_2",
				"zealot_2_tier_4_name_3"
			}
		},
		{
			group_name = "tier_5",
			required_level = 25,
			talents = {
				"zealot_2_tier_5_name_1",
				"zealot_2_tier_5_name_2",
				"zealot_2_tier_5_name_3"
			}
		},
		{
			group_name = "tier_6",
			required_level = 30,
			talents = {
				"zealot_2_tier_6_name_1",
				"zealot_2_tier_6_name_2",
				"zealot_2_tier_6_name_3"
			}
		}
	}
}

return archetype_specialization
