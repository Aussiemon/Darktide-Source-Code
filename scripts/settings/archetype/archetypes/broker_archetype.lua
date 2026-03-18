-- chunkname: @scripts/settings/archetype/archetypes/broker_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UiSoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_background_large = "content/ui/materials/icons/classes/large/broker",
	archetype_badge = "content/ui/materials/icons/class_badges/broker_01",
	archetype_description = "loc_class_broker_description",
	archetype_icon_large = "content/ui/materials/icons/classes/broker",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/broker_terminal",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/broker_terminal_shadow",
	archetype_name = "loc_class_broker_name",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/broker",
	archetype_selection_highlight_icon = "content/ui/textures/frames/class_selection/windows/broker/class_selection_top_broker",
	archetype_selection_icon = "content/ui/textures/frames/class_selection/windows/broker/class_selection_top_broker_unselected",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_broker/class_selection_broker",
	archetype_title = "loc_class_broker_title",
	archetype_video = "content/videos/class_selection/broker",
	backstory_snippet = "loc_character_backstory_snippet_broker",
	base_critical_strike_chance = 0.1,
	breed = "human",
	companion_breed = nil,
	companions_number = 0,
	companions_spawn_condition_func = nil,
	deluxe_dlc = "broker_deluxe",
	health = 150,
	knocked_down_health = 1000,
	onboarding_intro_video_template_name = "broker_intro",
	onboarding_skip_intro_video = false,
	requires_dlc = "broker",
	requires_dlc_reconciliation = "broker_cosmetic",
	spawn_companions_from_talent_func = nil,
	specialization_talent_layout_file_path = "scripts/ui/views/broker_stimm_builder_view/layouts/broker_stimm_tree",
	specialization_talent_package_path = "packages/ui/views/talent_builder_view/broker",
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/broker_tree",
	talents_package_path = "packages/ui/views/talent_builder_view/broker",
	toughness = ArchetypeToughnessTemplates.broker,
	dodge = ArchetypeDodgeTemplates.broker,
	sprint = ArchetypeSprintTemplates.default,
	stamina = ArchetypeStaminaTemplates.broker,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	talents = ArchetypeTalents.broker,
	base_talents = {
		broker_ability_focus = 1,
		broker_aura_gunslinger = 1,
		broker_blitz_flash_grenade = 1,
		broker_passive_improved_sprint_dodge = 1,
		broker_passive_increased_dodges = 1,
		broker_stimm_description_talent = 1,
	},
	conditional_base_talents = {
		broker_syringe = 1,
	},
	conditional_base_talent_funcs = {
		broker_syringe = function (selected_talents)
			local TalentSettings = require("scripts/settings/talent/talent_settings")

			for talent_name in pairs(TalentSettings.broker_stimm) do
				if selected_talents[talent_name] then
					return true
				end
			end

			return false
		end,
	},
	selection_sound_event = UiSoundEvents.character_create_archetype_broker,
	skip_onboarding_chapters = {
		inventory_popup = true,
		play_prologue = true,
		speak_to_morrow = true,
		training_reward = true,
		visit_chapel = true,
	},
	defining_weapons = {
		{
			display_name = "loc_weapon_family_dual_shivs_p1_m1",
			item = "content/items/weapons/player/melee/dual_shivs_p1_m1",
		},
		{
			display_name = "loc_weapon_family_saw_p1_m1",
			item = "content/items/weapons/player/melee/saw_p1_m1",
		},
		{
			display_name = "loc_weapon_family_crowbar_p1_m1",
			item = "content/items/weapons/player/melee/crowbar_p1_m1",
		},
		{
			display_name = "loc_weapon_family_dual_autopistols_p1_m1",
			item = "content/items/weapons/player/ranged/dual_autopistols_p1_m1",
		},
		{
			display_name = "loc_weapon_family_dual_stubpistols_p1_m1",
			item = "content/items/weapons/player/ranged/dual_stubpistols_p1_m1",
		},
		{
			display_name = "loc_weapon_family_needlepistol_p1_m1",
			item = "content/items/weapons/player/ranged/needlepistol_p1_m1",
		},
	},
}

return archetype_data
