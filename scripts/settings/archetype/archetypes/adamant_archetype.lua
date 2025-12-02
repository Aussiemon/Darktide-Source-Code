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
	archetype_badge = "content/ui/materials/icons/class_badges/adamant_01_01",
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
	companion_breed = "companion_dog",
	deluxe_dlc = "adamant_deluxe",
	health = 200,
	knocked_down_health = 1000,
	onboarding_intro_video_template_name = "adamant_intro",
	requires_dlc = "adamant",
	requires_dlc_reconciliation = nil,
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
		adamant_command_tog_with_tag = 1,
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
	selection_sound_event = UiSoundEvents.character_create_archetype_adamant,
	unique_weapons = {},
}

return archetype_data
