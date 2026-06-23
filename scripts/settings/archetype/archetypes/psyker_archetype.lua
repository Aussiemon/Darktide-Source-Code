-- chunkname: @scripts/settings/archetype/archetypes/psyker_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UiSoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_background_large = "content/ui/materials/icons/classes/large/psyker",
	archetype_badge = "content/ui/materials/icons/class_badges/psyker_01",
	archetype_description = "loc_class_psyker_description",
	archetype_icon_large = "content/ui/materials/icons/classes/psyker",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/psyker_terminal",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/psyker_terminal_shadow",
	archetype_name = "loc_class_psyker_name",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/psyker",
	archetype_selection_highlight_icon = "content/ui/textures/frames/class_selection/windows/psyker/class_selection_top_psyker",
	archetype_selection_icon = "content/ui/textures/frames/class_selection/windows/psyker/class_selection_top_psyker_unselected",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_psyker/class_selection_psyker",
	archetype_title = "loc_class_psyker_title",
	archetype_video = "content/videos/class_selection/psyker",
	base_critical_strike_chance = 0.075,
	breed = "human",
	character_appearance_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_psyker",
	character_creation_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_psyker",
	companion_breed = nil,
	companion_name_input = nil,
	deluxe_dlc = nil,
	end_of_round_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/end_of_round/end_of_round_psyker",
	health = 150,
	inventory_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/inventory/inventory_psyker",
	knocked_down_health = 1000,
	main_menu_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_psyker",
	mission_intro_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/mission_briefing/mission_briefing_psyker",
	num_companions = 0,
	portrait_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/portrait/portrait_psyker",
	requires_dlc = nil,
	requires_dlc_reconciliation = nil,
	spawn_companions_from_talent_func = nil,
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/psyker_tree",
	talents_package_path = "packages/ui/views/talent_builder_view/psyker",
	toughness = ArchetypeToughnessTemplates.psyker,
	dodge = ArchetypeDodgeTemplates.psyker,
	sprint = ArchetypeSprintTemplates.psyker,
	stamina = ArchetypeStaminaTemplates.psyker,
	warp_charge = ArchetypeWarpChargeTemplates.psyker,
	talents = ArchetypeTalents.psyker,
	base_talents = {
		psyker_aura_ability_cooldown = 1,
		psyker_combat_ability_shout = 1,
		psyker_grenade_smite = 1,
	},
	main_menu_camera_offsets = {
		x = 0,
		z = -0.05,
		y = {
			0.2,
			-0.3,
		},
	},
	selection_sound_event = UiSoundEvents.character_create_archetype_psyker,
	name_input = {
		error_loc_key = "loc_character_create_name_validation_failed_message",
		max_length = 18,
	},
	defining_weapons = {
		{
			display_name = "loc_weapon_family_forcesword_p1_m1",
			item = "content/items/weapons/player/melee/forcesword_p1_m1",
		},
		{
			display_name = "loc_weapon_family_combatsword_p3_m2",
			item = "content/items/weapons/player/melee/combatsword_p3_m2",
		},
		{
			display_name = "loc_weapon_family_forcestaff_p1_m1",
			item = "content/items/weapons/player/ranged/forcestaff_p1_m1",
		},
		{
			display_name = "loc_weapon_family_forcestaff_p3_m1",
			item = "content/items/weapons/player/ranged/forcestaff_p3_m1",
		},
		{
			display_name = "loc_weapon_family_stubrevolver_p1_m2",
			item = "content/items/weapons/player/ranged/stubrevolver_p1_m2",
		},
	},
}

return archetype_data
