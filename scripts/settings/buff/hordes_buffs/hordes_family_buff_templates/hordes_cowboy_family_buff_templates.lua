-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_family_buff_templates/hordes_cowboy_family_buff_templates.lua

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local Armor = require("scripts/utilities/attack/armor")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local HordesBuffsUtilities = require("scripts/settings/buff/hordes_buffs/hordes_buffs_utilities")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local MinionState = require("scripts/utilities/minion_state")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Stamina = require("scripts/utilities/attack/stamina")
local Suppression = require("scripts/utilities/attack/suppression")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local PI = math.pi
local PI_2 = PI * 2
local buff_categories = BuffSettings.buff_categories
local buff_keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local stagger_impact_comparison = StaggerSettings.stagger_impact_comparison
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local SFX_NAMES = HordesBuffsUtilities.SFX_NAMES
local VFX_NAMES = HordesBuffsUtilities.VFX_NAMES
local BROADPHASE_RESULTS = {}
local range_melee = DamageSettings.in_melee_range
local range_close = DamageSettings.ranged_close
local range_far = DamageSettings.ranged_far
local templates = {}

table.make_unique(templates)

templates.hordes_buff_no_ammo_consumption_on_crits = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_keywords = {
		buff_keywords.no_ammo_consumption_on_crits,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_component = unit_data_extension:read_component("slot_secondary")
	end,
	conditional_stat_buffs_func = function (template_data, template_context, t)
		local inventory_slot_component = template_data.inventory_slot_component

		if inventory_slot_component and Ammo.current_ammo_in_clips(inventory_slot_component) < 1 then
			return false
		end

		return true
	end,
}

local basic_damage_increase = HordesBuffsData.hordes_buff_damage_increase.buff_stats.damage.value

templates.hordes_buff_damage_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.damage] = basic_damage_increase,
	},
}

local percent_wield_speed_increase = HordesBuffsData.hordes_buff_reduce_swap_time.buff_stats.swap_time.value

templates.hordes_buff_reduce_swap_time = {
	class_name = "buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.wield_speed] = percent_wield_speed_increase,
	},
}

local percent_toughness_regen_on_ranged_kill = HordesBuffsData.hordes_buff_toughness_on_ranged_kill.buff_stats.thoughness_regen.value

templates.hordes_buff_toughness_on_ranged_kill = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_func = function (params, template_data, template_context)
		Toughness.replenish_percentage(template_context.unit, percent_toughness_regen_on_ranged_kill, false)
	end,
}

local percent_ranged_damage_increase_after_reload = HordesBuffsData.hordes_buff_increased_damage_after_reload.buff_stats.range.value
local duration_ranged_damage_increase_after_reload = HordesBuffsData.hordes_buff_increased_damage_after_reload.buff_stats.time.value

templates.hordes_buff_increased_damage_after_reload = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	active_duration = duration_ranged_damage_increase_after_reload,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_damage] = percent_ranged_damage_increase_after_reload,
	},
}

local max_stacks_improved_weapon_reload_on_melee_kill = HordesBuffsData.hordes_buff_improved_weapon_reload_on_melee_kill.buff_stats.time.value
local percent_improved_weapon_reload_on_melee_kill = HordesBuffsData.hordes_buff_improved_weapon_reload_on_melee_kill.buff_stats.reload_speed.value

templates.hordes_buff_improved_weapon_reload_on_melee_kill = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.buff_extension:add_internally_controlled_buff("hordes_buff_improved_weapon_reload_on_melee_kill_effect", t)
	end,
}
templates.hordes_buff_improved_weapon_reload_on_melee_kill_effect = {
	class_name = "server_only_proc_buff",
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	max_stacks = max_stacks_improved_weapon_reload_on_melee_kill,
	max_stacks_cap = max_stacks_improved_weapon_reload_on_melee_kill,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	stat_buffs = {
		[stat_buffs.reload_speed] = percent_improved_weapon_reload_on_melee_kill,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.done = true
	end,
	conditional_exit_func = function (template_data, template_context)
		local inventory_component = template_data.inventory_component
		local visual_loadout_extension = template_data.visual_loadout_extension
		local wielded_slot_id = inventory_component.wielded_slot
		local weapon_template = visual_loadout_extension:weapon_template_from_slot(wielded_slot_id)
		local _, current_action = Action.current_action(template_data.weapon_action_component, weapon_template)
		local action_kind = current_action and current_action.kind
		local is_reloading = action_kind and (action_kind == "reload_shotgun" or action_kind == "reload_state" or action_kind == "ranged_load_special")

		return template_data.done and not is_reloading
	end,
}

local percent_ammo_gets_increased_crit_chance_after_reload = HordesBuffsData.hordes_buff_bonus_crit_chance_on_ammo.buff_stats.ammo.value
local percent_crit_chance_increase_after_reload = HordesBuffsData.hordes_buff_bonus_crit_chance_on_ammo.buff_stats.crit_chance.value

templates.hordes_buff_bonus_crit_chance_on_ammo = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = percent_crit_chance_increase_after_reload,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.slot_component = unit_data_extension:read_component("slot_secondary")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		if template_data.inventory_component.wielded_slot ~= "slot_secondary" then
			return false
		end

		local slot_component = template_data.slot_component
		local current_animation_clip, max_ammunition_clip = Ammo.current_ammo_in_clips(slot_component), Ammo.max_ammo_in_clips(slot_component)
		local current_animation_percentage = current_animation_clip / max_ammunition_clip
		local ammunition_percentage = 1 - percent_ammo_gets_increased_crit_chance_after_reload

		return ammunition_percentage <= current_animation_percentage
	end,
}

local percent_melee_damage_increase_on_ranged_kill = HordesBuffsData.hordes_buff_other_slot_damage_increase_on_kill.buff_stats.dammage.value
local percent_range_damage_increase_on_melee_kill = HordesBuffsData.hordes_buff_other_slot_damage_increase_on_kill.buff_stats.range.value

templates.hordes_buff_other_slot_damage_increase_on_kill = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local current_time = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
		local _, buff_index, component_index = buff_extension:add_externally_controlled_buff("hordes_buff_melee_kills_grant_range_damage", current_time)

		template_data.melee_kills_buff = {
			buff_index = buff_index,
			component_index = component_index,
		}
		_, buff_index, component_index = buff_extension:add_externally_controlled_buff("hordes_buff_ranged_kills_grant_melee_damage", current_time)
		template_data.range_kills_buff = {
			buff_index = buff_index,
			component_index = component_index,
		}
		template_data.buff_extension = buff_extension
	end,
}
templates.hordes_buff_melee_kills_grant_range_damage = {
	active_duration = 5,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	proc_stat_buffs = {
		[stat_buffs.ranged_damage] = percent_range_damage_increase_on_melee_kill,
	},
}
templates.hordes_buff_ranged_kills_grant_melee_damage = {
	active_duration = 5,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_stat_buffs = {
		[stat_buffs.melee_damage] = percent_melee_damage_increase_on_ranged_kill,
	},
}

local percent_decrease_range_hit_mass_consumption = HordesBuffsData.hordes_buff_ranged_attacks_hit_mass_penetration_increased.buff_stats.increase_hitmass.value

templates.hordes_buff_ranged_attacks_hit_mass_penetration_increased = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.consumed_hit_mass_modifier_on_ranged_hit] = 1 / (1 + percent_decrease_range_hit_mass_consumption),
	},
}

local percent_damage_increase_per_missing_ammo_in_clip = HordesBuffsData.hordes_buff_melee_damage_missing_ammo_in_clip.buff_stats.dammage.value

templates.hordes_buff_melee_damage_missing_ammo_in_clip = {
	class_name = "server_only_proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_ammo_consumed] = 1,
		[proc_events.on_reload] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.ammo_missing = 0
		template_data.lerp_t = 0
	end,
	specific_proc_func = {
		[proc_events.on_ammo_consumed] = function (params, template_data, template_context)
			local unit = template_context.unit
			local ammo_missing = Ammo.missing_slot_clip_amount(unit, "slot_secondary")

			template_data.ammo_missing = ammo_missing
			template_data.lerp_t = ammo_missing * percent_damage_increase_per_missing_ammo_in_clip
		end,
		[proc_events.on_reload] = function (params, template_data, template_context)
			template_data.ammo_missing = 0
			template_data.lerp_t = 0
		end,
	},
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			max = 1,
			min = 0,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return template_data.lerp_t
	end,
}

local num_weakspot_hit_streak_needed_for_infinite_ammo = HordesBuffsData.hordes_buff_weakspot_ranged_hit_gives_infinite_ammo.buff_stats.headshot.value
local duration_infinite_ammo_on_weakspot_hit_streak = HordesBuffsData.hordes_buff_weakspot_ranged_hit_gives_infinite_ammo.buff_stats.time.value
local cooldown_infinite_ammo_on_weakspot_hit_streak = HordesBuffsData.hordes_buff_weakspot_ranged_hit_gives_infinite_ammo.buff_stats.cooldown.value

templates.hordes_buff_weakspot_ranged_hit_gives_infinite_ammo = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	active_duration = duration_infinite_ammo_on_weakspot_hit_streak,
	cooldown_duration = cooldown_infinite_ammo_on_weakspot_hit_streak,
	proc_effects = {
		player_effects = {
			looping_wwise_start_event = SFX_NAMES.infinite_ammo_start,
			looping_wwise_stop_event = SFX_NAMES.infinite_ammo_stop,
			wwise_state = {
				group = "player_ability",
				off_state = "none",
				on_state = "ogryn_stance",
			},
		},
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_keywords = {
		buff_keywords.no_ammo_consumption,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.hits_in_a_row = 0
	end,
	check_proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return false
		end

		local hit_weakspot = params.hit_weakspot
		local is_ranged_hit = CheckProcFunctions.on_ranged_hit(params, template_data, template_context, t)

		if not hit_weakspot or not is_ranged_hit then
			template_data.hits_in_a_row = 0

			return false
		end

		template_data.hits_in_a_row = template_data.hits_in_a_row + 1

		return template_data.hits_in_a_row >= num_weakspot_hit_streak_needed_for_infinite_ammo
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.hits_in_a_row = 0
	end,
}

return templates
