-- chunkname: @scripts/settings/archetype/archetypes/ogryn_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UiSoundEvents = require("scripts/settings/ui/ui_sound_events")
local Promise = require("scripts/foundation/utilities/promise")
local archetype_data = {
	archetype_background_large = "content/ui/materials/icons/classes/large/ogryn",
	archetype_badge = "content/ui/materials/icons/class_badges/ogryn_01_01",
	archetype_description = "loc_class_ogryn_description",
	archetype_icon_large = "content/ui/materials/icons/classes/ogryn",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/ogryn_terminal",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/ogryn_terminal_shadow",
	archetype_name = "loc_class_ogryn_name",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/ogryn",
	archetype_selection_highlight_icon = "content/ui/textures/frames/class_selection/windows/class_selection_top_ogryn",
	archetype_selection_icon = "content/ui/textures/frames/class_selection/windows/class_selection_top_ogryn_unselected",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_ogryn/class_selection_ogryn",
	archetype_title = "loc_class_ogryn_title",
	archetype_video = "content/videos/class_selection/ogryn_2",
	base_critical_strike_chance = 0.025,
	breed = "ogryn",
	health = 300,
	knocked_down_health = 1000,
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/ogryn_tree",
	talents_package_path = "packages/ui/views/talent_builder_view/ogryn",
	ui_selection_order = 4,
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
	selection_sound_event = UiSoundEvents.character_create_archetype_ogryn,
	unique_weapons = {
		{
			display_name = "loc_class_selection_unique_weapon_ogryn_melee_1",
			item = "content/items/weapons/player/melee/ogryn_powermaul_slabshield_p1_m1",
		},
		{
			display_name = "loc_class_selection_unique_weapon_ogryn_ranged_1",
			item = "content/items/weapons/player/ranged/ogryn_gauntlet_p1_m1",
		},
	},
	is_available = function (archetype_ref)
		return Promise.resolved({
			available = true,
			archetype = archetype_ref,
		})
	end,
	acquire_callback = function (archetype_ref, on_flow_finished_callback)
		return
	end,
}

return archetype_data
