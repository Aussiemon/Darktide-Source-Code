-- chunkname: @scripts/settings/buff/live_event_buff_templates/live_event_broker_stimms_buff_templates.lua

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

local live_event_broker_stimms_toxic_gas_resistance_max_stacks = 10

templates.live_event_broker_stimms_toxic_gas_resistance = {
	always_show_in_hud = true,
	class_name = "buff",
	description = "The syringes of The Brokers have made your body super awesome",
	display_description = "loc_live_event_broker_stimms_toxic_gas_resistance_buff_description",
	display_title = "loc_live_event_broker_stimms_toxic_gas_resistance_buff_title",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_increase",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	predicted = false,
	title = "Broker Stimms Buff",
	buff_category = buff_categories.live_event,
	max_stacks = live_event_broker_stimms_toxic_gas_resistance_max_stacks,
	max_stacks_cap = live_event_broker_stimms_toxic_gas_resistance_max_stacks,
	stack_hud_data_formatter = function (buff_instance_data, stack_count, template, text_style)
		local percent = math.clamp((stack_count or 0) / template.max_stacks, 0, 1) * 100

		return string.format("%.0f%%", percent), percent >= 100 and 15 or 18
	end,
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_from_toxic_gas_multiplier] = 0.95,
		[stat_buffs.attack_speed] = 0.2 / live_event_broker_stimms_toxic_gas_resistance_max_stacks,
		[stat_buffs.melee_damage] = 0.25 / live_event_broker_stimms_toxic_gas_resistance_max_stacks,
		[stat_buffs.movement_speed] = 0.3 / live_event_broker_stimms_toxic_gas_resistance_max_stacks,
		[stat_buffs.ranged_damage] = 0.25 / live_event_broker_stimms_toxic_gas_resistance_max_stacks,
		[stat_buffs.reload_speed] = 0.3 / live_event_broker_stimms_toxic_gas_resistance_max_stacks,
	},
	stat_buffs = {
		[stat_buffs.syringe_duration] = 5 / live_event_broker_stimms_toxic_gas_resistance_max_stacks,
	},
	update_func = function (template_data, template_context, dt, t, template)
		template_data.is_active = template_context.buff_extension:has_keyword(keywords.in_toxic_gas)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
}
templates.live_event_broker_stimms_perma_buff = {
	always_show_in_hud = false,
	class_name = "buff",
	description = "The cartel has increased the potency of all your syringes.",
	display_description = "loc_live_event_broker_stimms_perma_buff_description",
	display_title = "loc_live_event_broker_stimms_perma_buff_title",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_stimm_buff",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	show = false,
	title = "Broker Stimms Buff",
	buff_category = buff_categories.live_event,
	stat_buffs = {
		[stat_buffs.syringe_duration] = 5,
	},
}

return templates
