-- chunkname: @scripts/settings/buff/live_event_buff_templates/live_event_stolen_rations_buff_templates.lua

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local Suppression = require("scripts/utilities/attack/suppression")
local Sway = require("scripts/utilities/sway")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local attack_types = AttackSettings.attack_types
local attack_results = AttackSettings.attack_results
local damage_types = DamageSettings.damage_types
local buff_categories = BuffSettings.buff_categories
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local slot_configuration = PlayerCharacterConstants.slot_configuration
local special_rules = SpecialRulesSettings.special_rules
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.live_event_stolen_rations_destroy_ranged = {
	class_name = "buff",
	description = "The forces of Destroy have improved your ranged capabilities!",
	display_description = "loc_live_event_stolen_rations_destroy_ranged_buff_description",
	display_title = "loc_live_event_stolen_rations_destroy_ranged_buff_title",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_on_ranged_hit",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	show_in_hud_if_slot_is_wielded = false,
	title = "Stolen Rations Destroy Ranged",
	buff_category = buff_categories.live_event,
	stat_buffs = {
		[stat_buffs.ammo_reserve_capacity] = 1,
	},
	keywords = {
		keywords.ranged_attack_infinite_cleave,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
}
templates.live_event_stolen_rations_recover_syringe = {
	class_name = "buff",
	description = "The syringes of Recover have made your body super awesome",
	display_description = "loc_live_event_stolen_rations_recover_syringe_buff_description",
	display_title = "loc_live_event_stolen_rations_recover_syringe_buff_title",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_on_melee_hit",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	show_in_hud_if_slot_is_wielded = false,
	title = "Stolen Rations Recover Syringe Buff",
	buff_category = buff_categories.live_event,
	stat_buffs = {
		[stat_buffs.attack_speed] = 0.25,
		[stat_buffs.reload_speed] = 0.25,
		[stat_buffs.dodge_speed_multiplier] = 1.25,
		[stat_buffs.dodge_distance_modifier] = 0.3,
		[stat_buffs.stamina_modifier] = 2,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
}

return templates
