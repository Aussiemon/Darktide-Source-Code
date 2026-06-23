-- chunkname: @scripts/settings/archetype/archetypes/ogryn_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UiSoundEvents = require("scripts/settings/ui/ui_sound_events")
local archetype_data = {
	archetype_background_large = "content/ui/materials/icons/classes/large/ogryn",
	archetype_badge = "content/ui/materials/icons/class_badges/ogryn_01",
	archetype_description = "loc_class_ogryn_description",
	archetype_icon_large = "content/ui/materials/icons/classes/ogryn",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/ogryn_terminal",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/ogryn_terminal_shadow",
	archetype_name = "loc_class_ogryn_name",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/ogryn",
	archetype_selection_highlight_icon = "content/ui/textures/frames/class_selection/windows/ogryn/class_selection_top_ogryn",
	archetype_selection_icon = "content/ui/textures/frames/class_selection/windows/ogryn/class_selection_top_ogryn_unselected",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_ogryn/class_selection_ogryn",
	archetype_title = "loc_class_ogryn_title",
	archetype_video = "content/videos/class_selection/ogryn",
	base_critical_strike_chance = 0.025,
	breed = "ogryn",
	character_appearance_state_machine = "content/characters/player/ogryn/third_person/animations/menu/state_machines/character_customization/character_customization_ogryn",
	character_creation_state_machine = "content/characters/player/ogryn/third_person/animations/menu/state_machines/character_customization/character_customization_ogryn",
	companion_breed = nil,
	companion_name_input = nil,
	deluxe_dlc = nil,
	end_of_round_state_machine = "content/characters/player/ogryn/third_person/animations/menu/state_machines/end_of_round/end_of_round_ogryn",
	health = 300,
	inventory_state_machine = "content/characters/player/ogryn/third_person/animations/menu/state_machines/inventory/inventory_ogryn",
	knocked_down_health = 1000,
	main_menu_state_machine = "content/characters/player/ogryn/third_person/animations/menu/state_machines/character_customization/character_customization_ogryn",
	mission_intro_state_machine = "content/characters/player/ogryn/third_person/animations/menu/state_machines/mission_briefing/mission_briefing_ogryn",
	num_companions = 0,
	portrait_state_machine = "content/characters/player/ogryn/third_person/animations/menu/state_machines/portrait/portrait_ogryn",
	requires_dlc = nil,
	requires_dlc_reconciliation = nil,
	spawn_companions_from_talent_func = nil,
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/ogryn_tree",
	talents_package_path = "packages/ui/views/talent_builder_view/ogryn",
	toughness = ArchetypeToughnessTemplates.ogryn,
	dodge = ArchetypeDodgeTemplates.ogryn,
	sprint = ArchetypeSprintTemplates.ogryn,
	stamina = ArchetypeStaminaTemplates.ogryn,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	talents = ArchetypeTalents.ogryn,
	base_talents = {
		ogryn_base_tank_passive = 1,
		ogryn_charge = 1,
		ogryn_dodge_stagger = 1,
		ogryn_grenade_box = 1,
		ogryn_helping_hand = 1,
		ogryn_melee_damage_coherency = 1,
	},
	main_menu_camera_offsets = {
		x = 0,
		z = 0.4,
		y = {
			-2.6,
			-2.9,
		},
	},
	selection_sound_event = UiSoundEvents.character_create_archetype_ogryn,
	name_input = {
		error_loc_key = "loc_character_create_name_validation_failed_message",
		max_length = 18,
	},
	defining_weapons = {
		{
			display_name = "loc_weapon_family_ogryn_powermaul_slabshield_p1_m1",
			item = "content/items/weapons/player/melee/ogryn_powermaul_slabshield_p1_m1",
		},
		{
			display_name = "loc_weapon_family_ogryn_club_p2_m3",
			item = "content/items/weapons/player/melee/ogryn_club_p2_m3",
		},
		{
			display_name = "loc_weapon_family_ogryn_gauntlet_p1_m1",
			item = "content/items/weapons/player/ranged/ogryn_gauntlet_p1_m1",
		},
		{
			display_name = "loc_weapon_family_ogryn_heavystubber_p1_m2",
			item = "content/items/weapons/player/ranged/ogryn_heavystubber_p1_m2",
		},
		{
			display_name = "loc_weapon_family_ogryn_rippergun_p1_m2",
			item = "content/items/weapons/player/ranged/ogryn_rippergun_p1_m2",
		},
	},
}

return archetype_data
