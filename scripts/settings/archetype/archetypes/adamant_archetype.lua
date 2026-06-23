-- chunkname: @scripts/settings/archetype/archetypes/adamant_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UiSoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_background_large = "content/ui/materials/icons/classes/large/adamant",
	archetype_badge = "content/ui/materials/icons/class_badges/adamant_01",
	archetype_description = "loc_class_adamant_description",
	archetype_icon_large = "content/ui/materials/icons/classes/adamant",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/adamant_terminal",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/adamant_terminal_shadow",
	archetype_name = "loc_class_adamant_name",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/adamant",
	archetype_selection_highlight_icon = "content/ui/textures/frames/class_selection/windows/adamant/class_selection_top_adamant",
	archetype_selection_icon = "content/ui/textures/frames/class_selection/windows/adamant/class_selection_top_adamant_unselected",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_adamant/class_selection_adamant",
	archetype_title = "loc_class_adamant_title",
	archetype_video = "content/videos/class_selection/adamant",
	backstory_snippet = "loc_character_backstory_snippet_adamant",
	base_critical_strike_chance = 0.075,
	breed = "human",
	character_appearance_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_adamant",
	character_creation_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_adamant",
	companion_breed = "companion_dog",
	deluxe_dlc = "adamant_deluxe",
	end_of_round_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/end_of_round/end_of_round_adamant",
	health = 200,
	inventory_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/inventory/inventory_adamant",
	knocked_down_health = 1000,
	main_menu_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_adamant",
	mission_intro_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/mission_briefing/mission_briefing_adamant",
	num_companions = 1,
	onboarding_hub_destination_id_after_intro_video = "mission_board",
	onboarding_intro_video_template_name = "adamant_intro",
	portrait_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/portrait/portrait_adamant",
	requires_dlc = "adamant",
	requires_dlc_reconciliation = nil,
	spawn_companions_from_talent_func = nil,
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/adamant_tree",
	talents_package_path = "packages/ui/views/talent_builder_view/adamant",
	toughness = ArchetypeToughnessTemplates.adamant,
	dodge = ArchetypeDodgeTemplates.adamant,
	sprint = ArchetypeSprintTemplates.default,
	stamina = ArchetypeStaminaTemplates.adamant,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	talents = ArchetypeTalents.adamant,
	base_talents = {
		adamant_area_buff_drone = 1,
		adamant_command_dog_with_tag = 1,
		adamant_companion_aura = 1,
		adamant_companion_damage_per_level = 1,
		adamant_grenade = 1,
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
		z = -0.05,
		y = {
			0.2,
			-0.3,
		},
	},
	selection_sound_event = UiSoundEvents.character_create_archetype_adamant,
	name_input = {
		error_loc_key = "loc_character_create_name_validation_failed_message",
		max_length = 18,
	},
	companion_name_input = {
		error_loc_key = "loc_character_create_name_validation_failed_message_alphanumerical",
		max_length = 15,
		error_loc_variables = {
			max_digits = 6,
		},
	},
	defining_weapons = {
		{
			display_name = "loc_weapon_family_powermaul_p2_m1",
			item = "content/items/weapons/player/melee/powermaul_p2_m1",
		},
		{
			display_name = "loc_weapon_family_powermaul_shield_p1_m1",
			item = "content/items/weapons/player/melee/powermaul_shield_p1_m1",
		},
		{
			display_name = "loc_weapon_family_shotgun_p4_m1",
			item = "content/items/weapons/player/ranged/shotgun_p4_m1",
		},
		{
			display_name = "loc_weapon_family_shotpistol_shield_p1_m1",
			item = "content/items/weapons/player/ranged/shotpistol_shield_p1_m1",
		},
	},
}

return archetype_data
