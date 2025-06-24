-- chunkname: @scripts/settings/archetype/archetypes/adamant_archetype.lua

local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local UiSoundEvents = require("scripts/settings/ui/ui_sound_events")
local Promise = require("scripts/foundation/utilities/promise")
local DLCSettings = require("scripts/settings/archetype/archetypes/adamant_archetype_dlc_settings")
local archetype_data = {
	archetype_background_large = "content/ui/materials/icons/classes/large/adamant",
	archetype_badge = "content/ui/materials/icons/class_badges/adamant_01_01",
	archetype_description = "loc_class_adamant_description",
	archetype_icon_large = "content/ui/materials/icons/classes/adamant",
	archetype_icon_selection_large = "content/ui/materials/icons/classes/adamant_terminal",
	archetype_icon_selection_large_unselected = "content/ui/materials/icons/classes/adamant_terminal_shadow",
	archetype_name = "loc_class_adamant_name",
	archetype_selection_background = "content/ui/materials/backgrounds/info_panels/adamant",
	archetype_selection_highlight_icon = "content/ui/textures/frames/class_selection/windows/class_selection_top_adamant",
	archetype_selection_icon = "content/ui/textures/frames/class_selection/windows/class_selection_top_adamant_unselected",
	archetype_selection_level = "content/levels/ui/class_selection/class_selection_adamant/class_selection_adamant",
	archetype_title = "loc_class_adamant_title",
	archetype_video = "content/videos/class_selection/arbites2",
	base_critical_strike_chance = 0.075,
	breed = "human",
	companion_breed = "companion_dog",
	health = 200,
	knocked_down_health = 1000,
	onboarding_intro_video_template_name = "adamant_intro",
	talent_layout_file_path = "scripts/ui/views/talent_builder_view/layouts/adamant_tree",
	talents_package_path = "packages/ui/views/talent_builder_view/adamant",
	ui_selection_order = 5,
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
	dlc_settings = DLCSettings,
	is_available = function (archetype_ref)
		local availability_promise = Promise.new()
		local dlc_check_promise = Managers.dlc:is_owner_of(DLCSettings:get_ids_for_auth_method(Backend:get_auth_method()))

		dlc_check_promise:next(function (ok)
			availability_promise:resolve({
				archetype = archetype_ref,
				available = ok,
			})
		end)
		dlc_check_promise:catch(function (err)
			availability_promise:reject({
				archetype = archetype_ref,
				error = err,
			})
		end)

		return availability_promise
	end,
	acquire_callback = function (archetype_ref, on_flow_finished_callback)
		return Managers.dlc:open_dlc_view(DLCSettings, on_flow_finished_callback)
	end,
}

return archetype_data
