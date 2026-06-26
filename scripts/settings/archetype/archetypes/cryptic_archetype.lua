-- chunkname: @scripts/settings/archetype/archetypes/cryptic_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local SpawnCompanionsFromTalent = require("scripts/utilities/spawn_companions_from_talent")
local UiSoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_background_large = "content/ui/materials/icons/classes/large/cryptic",
	archetype_badge = "content/ui/materials/icons/class_badges/cryptic_01",
	archetype_description = "loc_class_cryptic_description",
	archetype_icon_large = "content/ui/materials/icons/classes/cryptic",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/cryptic_terminal",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/cryptic_terminal_shadow",
	archetype_name = "loc_class_cryptic_name",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/cryptic",
	archetype_selection_highlight_icon = "content/ui/textures/frames/class_selection/windows/cryptic/class_selection_top_cryptic",
	archetype_selection_icon = "content/ui/textures/frames/class_selection/windows/cryptic/class_selection_top_cryptic_unselected",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_cryptic/class_selection_cryptic",
	archetype_title = "loc_class_cryptic_title",
	archetype_video = "content/videos/class_selection/cryptic",
	backstory_snippet = "loc_character_backstory_snippet_cryptic",
	base_critical_strike_chance = 0.075,
	breed = "cryptic",
	character_appearance_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_cryptic",
	character_creation_intro_video_template_name = "cryptic_intro_part1",
	character_creation_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_cryptic",
	companion_breed = "companion_servo_skull",
	companion_name_input = nil,
	deluxe_dlc = "cryptic_deluxe",
	disable_prologue_skip = true,
	end_of_round_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/end_of_round/end_of_round_cryptic",
	health = 150,
	inventory_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/inventory/inventory_cryptic",
	knocked_down_health = 1000,
	main_menu_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_cryptic",
	mission_intro_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/mission_briefing/mission_briefing_cryptic",
	num_companions = 0,
	onboarding_hub_destination_id_after_intro_video = "expeditions",
	onboarding_intro_video_template_name = "cryptic_intro_part2",
	portrait_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/portrait/portrait_cryptic",
	requires_dlc = "cryptic",
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/cryptic_tree",
	talents_package_path = "packages/ui/views/talent_builder_view/cryptic",
	spawn_companions_from_talent_func = SpawnCompanionsFromTalent.cryptic_spawn_companions_from_talent,
	toughness = ArchetypeToughnessTemplates.cryptic,
	dodge = ArchetypeDodgeTemplates.cryptic,
	sprint = ArchetypeSprintTemplates.default,
	stamina = ArchetypeStaminaTemplates.cryptic,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	talents = ArchetypeTalents.cryptic,
	base_talents = {
		cryptic_coherency_regen_aura = 1,
		cryptic_discharge_base = 1,
		cryptic_passive_cooldown_regen = 1,
		cryptic_servo_skull_order = 1,
	},
	skip_onboarding_chapters = {
		inventory_popup = true,
		play_prologue = true,
		speak_to_morrow = true,
		training_reward = true,
		visit_chapel = true,
	},
	main_menu_camera_offsets = {
		x = 0,
		z = 0.1,
		y = {
			0.1,
			-0.4,
		},
	},
	selection_sound_event = UiSoundEvents.character_create_archetype_cryptic,
	name_input = {
		error_loc_key = "loc_character_create_name_validation_failed_message_alphanumerical",
		max_length = 18,
		error_loc_variables = {
			max_digits = 3,
		},
	},
	defining_weapons = {
		{
			display_name = "loc_weapon_family_powermaul_p3_m1",
			item = "content/items/weapons/player/melee/powermaul_p3_m1",
		},
		{
			display_name = "loc_weapon_family_powersword_p3_m1",
			item = "content/items/weapons/player/melee/powersword_p3_m1",
		},
		{
			display_name = "loc_weapon_family_transonic_sword_transonic_knife_p1_m1",
			item = "content/items/weapons/player/melee/transonic_sword_transonic_knife_p1_m1",
		},
		{
			display_name = "loc_weapon_family_arc_rifle_p1_m1",
			item = "content/items/weapons/player/ranged/arc_rifle_p1_m1",
		},
		{
			display_name = "loc_weapon_family_galvanic_rifle_p1_m1",
			item = "content/items/weapons/player/ranged/galvanic_rifle_p1_m1",
		},
		{
			display_name = "loc_weapon_family_phosphor_pistol_p1_m1",
			item = "content/items/weapons/player/ranged/phosphor_pistol_p1_m1",
		},
	},
	requires_dlc_reconciliation = {
		"cryptic_deluxe",
		"cryptic_cosmetic",
	},
}

return archetype_data
