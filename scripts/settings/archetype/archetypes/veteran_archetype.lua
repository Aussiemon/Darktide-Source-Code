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
	archetype_badge = "content/ui/materials/icons/class_badges/veteran_01",
	archetype_description = "loc_class_veteran_description",
	archetype_icon_large = "content/ui/materials/icons/classes/veteran",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/veteran_terminal",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/veteran_terminal_shadow",
	archetype_name = "loc_class_veteran_name",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/veteran",
	archetype_selection_highlight_icon = "content/ui/textures/frames/class_selection/windows/veteran/class_selection_top_veteran",
	archetype_selection_icon = "content/ui/textures/frames/class_selection/windows/veteran/class_selection_top_veteran_unselected",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_veteran/class_selection_veteran",
	archetype_title = "loc_class_veteran_title",
	archetype_video = "content/videos/class_selection/veteran",
	base_critical_strike_chance = 0.1,
	breed = "human",
	character_appearance_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_veteran",
	character_creation_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_veteran",
	companion_breed = nil,
	companion_name_input = nil,
	deluxe_dlc = nil,
	end_of_round_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/end_of_round/end_of_round_veteran",
	health = 150,
	inventory_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/inventory/inventory_veteran",
	knocked_down_health = 1000,
	main_menu_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/character_customization/character_customization_veteran",
	mission_intro_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/mission_briefing/mission_briefing_veteran",
	num_companions = 0,
	portrait_state_machine = "content/characters/player/human/third_person/animations/menu/state_machines/portrait/portrait_veteran",
	requires_dlc = nil,
	requires_dlc_reconciliation = nil,
	spawn_companions_from_talent_func = nil,
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/veteran_tree",
	talents_package_path = "packages/ui/views/talent_builder_view/veteran",
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
		veteran_supression_immunity = 1,
	},
	main_menu_camera_offsets = {
		x = 0,
		z = -0.05,
		y = {
			0.2,
			-0.3,
		},
	},
	selection_sound_event = UiSoundEvents.character_create_archetype_veteran,
	name_input = {
		error_loc_key = "loc_character_create_name_validation_failed_message",
		max_length = 18,
	},
	defining_weapons = {
		{
			display_name = "loc_weapon_family_combataxe_p3_m1",
			item = "content/items/weapons/player/melee/combataxe_p3_m1",
		},
		{
			display_name = "loc_weapon_family_chainsword_p1_m1",
			item = "content/items/weapons/player/melee/chainsword_p1_m1",
		},
		{
			display_name = "loc_weapon_family_lasgun_p1_m1",
			item = "content/items/weapons/player/ranged/lasgun_p1_m1",
		},
		{
			display_name = "loc_weapon_family_lasgun_p2_m2",
			item = "content/items/weapons/player/ranged/lasgun_p2_m2",
		},
		{
			display_name = "loc_weapon_family_plasmagun_p1_m1",
			item = "content/items/weapons/player/ranged/plasmagun_p1_m1",
		},
	},
}

return archetype_data
