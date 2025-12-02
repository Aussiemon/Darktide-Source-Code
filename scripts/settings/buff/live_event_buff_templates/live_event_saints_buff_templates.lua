-- chunkname: @scripts/settings/buff/live_event_buff_templates/live_event_saints_buff_templates.lua

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

templates.live_event_saints_buff_revive = {
	always_show_in_hud = false,
	class_name = "buff",
	duration = 5,
	show = false,
	buff_category = buff_categories.live_event,
	effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/player_buffs/saints_revive_01",
					stop_type = "destroy",
				},
			},
		},
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/player_buffs/player_screen_saints_revive",
	},
}
templates.live_event_saints_buff_saint_red = {
	always_show_in_hud = true,
	class_name = "buff",
	description = "The Red Saint has rewarded your devotion",
	display_description = "loc_live_event_saints_buff_saint_red_description",
	display_title = "loc_live_event_saints_buff_saint_red",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_on_melee_hit",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 30,
	max_stacks_cap = 30,
	predicted = false,
	title = "Blessing Of The Red Saint",
	buff_category = buff_categories.live_event,
	stat_buffs = {
		[stat_buffs.attack_speed] = 0.01,
		[stat_buffs.burning_damage] = 0.01,
		[stat_buffs.burning_duration] = 0.01,
		[stat_buffs.toughness_bonus] = 0.01,
	},
	keywords = {
		keywords.burning,
		keywords.melee_infinite_cleave,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
}
templates.live_event_saints_buff_saint_blue = {
	always_show_in_hud = true,
	class_name = "buff",
	description = "The Blue Saint has rewarded your devotion",
	display_description = "loc_live_event_saints_buff_saint_blue_description",
	display_title = "loc_live_event_saints_buff_saint_blue",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_increase_electric",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 30,
	max_stacks_cap = 30,
	predicted = false,
	title = "Blessing Of The Blue Saint",
	buff_category = buff_categories.live_event,
	stat_buffs = {
		[stat_buffs.reload_speed] = 0.01,
		[stat_buffs.damage_vs_electrocuted] = 0.01,
		[stat_buffs.toughness_bonus] = 0.01,
	},
	keywords = {
		keywords.electrocuted,
		keywords.reduced_ammo_consumption,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
}

local corruption_self_damage_power_level = 3
local corruption_damage_tick_rate = 0.33
local percent_max_hp_damaged_by_corruption = 1
local hp_lost_per_tick = 1

templates.live_event_saints_out_of_area_debuff = {
	always_show_in_hud = true,
	class_name = "interval_buff",
	description = "The Saints find your lack of faith disturbing!",
	display_description = "loc_live_event_saints_out_of_area_debuff_description",
	display_title = "loc_live_event_saints_out_of_area_debuff",
	hud_icon = "content/ui/textures/icons/buffs/hud/states_nurgle_eaten_buff_hud",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	title = "Curse of the Craven",
	buff_category = buff_categories.live_event,
	interval = corruption_damage_tick_rate,
	keywords = {
		keywords.prevent_healing_corruption,
		keywords.prevent_healing_health,
		keywords.corrupted,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local health_extension = ScriptUnit.extension(player_unit, "health_system")

		template_data.health_extension = health_extension

		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		template_data.character_state_component = character_state_component
		template_data.corruption_damage_profile = DamageProfileTemplates.live_event_saints_out_of_area_debuff_damage_template
	end,
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local character_state_component = template_data.character_state_component
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)

		if not HEALTH_ALIVE[player_unit] or requires_help then
			return
		end

		local health_extension = template_data.health_extension

		if health_extension then
			local permanent_damage_taken_percent = health_extension:permanent_damage_taken_percent()

			if permanent_damage_taken_percent <= percent_max_hp_damaged_by_corruption then
				health_extension:add_damage(hp_lost_per_tick, hp_lost_per_tick)

				local damage_profile = template_data.corruption_damage_profile

				Attack.execute(player_unit, damage_profile, "power_level", corruption_self_damage_power_level, "is_critical_strike", false, "attack_type", attack_types.buff, "damage_type", DamageSettings.damage_types.corruption)
			end
		end
	end,
}
templates.live_event_saints_in_area_buff = {
	always_show_in_hud = true,
	class_name = "buff",
	description = "Observing the blessed shrine fills you with power!",
	display_description = "loc_live_event_saints_in_area_buff_description",
	display_title = "loc_live_event_saints_in_area_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/zealot/zealot_ability_bolstering_prayer",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	title = "Zeal Of The Faithful",
	buff_category = buff_categories.live_event,
	stat_buffs = {
		[stat_buffs.melee_damage] = 1,
		[stat_buffs.ranged_damage] = 1,
		[stat_buffs.toughness_bonus] = 0.15,
		[stat_buffs.attack_speed] = 0.25,
		[stat_buffs.reload_speed] = 0.15,
		[stat_buffs.dodge_speed_multiplier] = 1.1,
		[stat_buffs.dodge_distance_modifier] = 0.2,
		[stat_buffs.stamina_modifier] = 1,
	},
}

return templates
