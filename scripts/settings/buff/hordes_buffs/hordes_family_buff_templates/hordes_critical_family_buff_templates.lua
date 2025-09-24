-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_family_buff_templates/hordes_critical_family_buff_templates.lua

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
local GRENADE_IMPACT_DAMAGE_TEMPLATES = {
	fire_grenade_impact = true,
	frag_grenade_impact = true,
	krak_grenade_impact = true,
	ogryn_grenade_box_cluster_impact = true,
	ogryn_grenade_box_impact = true,
	ogryn_grenade_impact = true,
}
local GRENADE_EXPLOSION_DAMAGE_TYPES = {
	[damage_types.grenade_frag] = true,
	[damage_types.electrocution] = true,
	[damage_types.plasma] = true,
	[damage_types.physical] = true,
	[damage_types.laser] = true,
}
local SFX_NAMES = HordesBuffsUtilities.SFX_NAMES
local VFX_NAMES = HordesBuffsUtilities.VFX_NAMES
local BROADPHASE_RESULTS = {}
local range_melee = DamageSettings.in_melee_range
local range_close = DamageSettings.ranged_close
local range_far = DamageSettings.ranged_far
local templates = {}

table.make_unique(templates)

local percent_weakspot_damage_increase = HordesBuffsData.hordes_buff_weakspot_damage_increase.buff_stats.damage.value

templates.hordes_buff_weakspot_damage_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.weakspot_damage] = percent_weakspot_damage_increase,
	},
}

local percent_increase_melee_crit_damage = HordesBuffsData.hordes_buff_melee_critical_damage_increase.buff_stats.crit_damage.value

templates.hordes_buff_melee_critical_damage_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.melee_critical_strike_damage] = percent_increase_melee_crit_damage,
	},
}

local percent_increase_super_armor_impact_on_crit = HordesBuffsData.hordes_buff_increase_super_armor_impact_on_crit.buff_stats.impact.value

templates.hordes_buff_increase_super_armor_impact_on_crit = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.super_armor_impact_on_crit] = percent_increase_super_armor_impact_on_crit,
	},
}

local percent_crit_chance_on_dodge = HordesBuffsData.hordes_buff_critical_chance_on_dodge.buff_stats.crit_chance.value
local crit_chance_on_dodge_duration = HordesBuffsData.hordes_buff_critical_chance_on_dodge.buff_stats.time.value

templates.hordes_buff_critical_chance_on_dodge = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	active_duration = crit_chance_on_dodge_duration,
	proc_effects = {
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_critical_dodge",
		},
	},
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = percent_crit_chance_on_dodge,
	},
}

local percent_rending_on_ranged_critical_hit = HordesBuffsData.hordes_buff_rending_on_ranged_critical_hit.buff_stats.rending.value
local rending_on_ranged_critical_hit_duration = HordesBuffsData.hordes_buff_rending_on_ranged_critical_hit.buff_stats.time.value

templates.hordes_buff_rending_on_ranged_critical_hit = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	active_duration = rending_on_ranged_critical_hit_duration,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.rending_multiplier] = percent_rending_on_ranged_critical_hit,
	},
	check_proc_func = CheckProcFunctions.on_crit_ranged,
}
templates.hordes_buff_critical_melee_hit_infinite_cleave = {
	class_name = "server_only_proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.critical_melee_hit_infinite_cleave,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit_melee,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server or not DEDICATED_SERVER then
			local wwise_world = template_context.wwise_world

			WwiseWorld.trigger_resource_event(wwise_world, SFX_NAMES.infinite_cleave_hit, template_context.unit)
		end
	end,
}

local percent_melee_damage_on_melee_critical_hit = HordesBuffsData.hordes_buff_melee_damage_on_melee_critical_hit.buff_stats.damage.value

templates.hordes_buff_melee_damage_on_melee_critical_hit = {
	class_name = "server_only_proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		template_data.melee_damage_boost_active = false
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context, t)
		template_data.melee_damage_boost_active = CheckProcFunctions.on_crit_melee(params, template_data, template_context, t)
	end,
	conditional_stat_buffs = {
		[stat_buffs.melee_damage] = percent_melee_damage_on_melee_critical_hit,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.melee_damage_boost_active
	end,
}

local percent_crit_damage_per_critical_hit = HordesBuffsData.hordes_buff_stacking_crit_damage_on_critical_hit.buff_stats.crit_damage.value
local max_crit_damage_stacked_from_critical_hit = HordesBuffsData.hordes_buff_stacking_crit_damage_on_critical_hit.buff_stats.max_crit_damage.value

templates.hordes_buff_stacking_crit_damage_on_critical_hit = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	force_predicted_proc = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/buffs_hud/hordes_buff_stacking_crit_damage_on_critical_hit",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	visual_stack_count = function (template_data, template_context)
		return template_data.crit_count
	end,
	start_func = function (template_data, template_context)
		template_data.lerp_t_value = 0
		template_data.crit_count = 0
	end,
	lerped_stat_buffs = {
		[stat_buffs.critical_strike_damage] = {
			min = 0,
			max = max_crit_damage_stacked_from_critical_hit,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return template_data.lerp_t_value
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit,
	proc_func = function (params, template_data, template_context, t)
		local max = max_crit_damage_stacked_from_critical_hit
		local stacks_needed_for_max = max / percent_crit_damage_per_critical_hit

		template_data.crit_count = math.min(template_data.crit_count + 1, stacks_needed_for_max)
		template_data.lerp_t_value = math.min(template_data.crit_count / stacks_needed_for_max, 1)
	end,
}

local percent_damage_reduction_on_critical_hit = HordesBuffsData.hordes_buff_damage_reduction_on_critical_hit.buff_stats.damage_reduction.value
local damage_reduction_on_critical_hit_duration = HordesBuffsData.hordes_buff_damage_reduction_on_critical_hit.buff_stats.time.value

templates.hordes_buff_damage_reduction_on_critical_hit = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	active_duration = damage_reduction_on_critical_hit_duration,
	proc_effects = {
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_buff_less_damage",
		},
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.damage_taken_modifier] = percent_damage_reduction_on_critical_hit,
	},
	check_proc_func = CheckProcFunctions.on_crit,
}

local crit_chance_gained_per_missing_stamina_bar = HordesBuffsData.hordes_buff_crit_chance_per_missing_stamina_bar.buff_stats.crit_chance.value
local crit_chance_per_missing_stamina_bar_max_num_bars = 15

templates.hordes_buff_crit_chance_per_missing_stamina_bar = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local stamina_component = unit_data_extension:read_component("stamina")

		template_data.stamina_component = stamina_component

		local archetype = unit_data_extension:archetype()
		local base_stamina_template = archetype.stamina

		template_data.base_stamina_template = base_stamina_template
	end,
	lerped_stat_buffs = {
		[stat_buffs.critical_strike_chance] = {
			min = 0,
			max = crit_chance_gained_per_missing_stamina_bar * crit_chance_per_missing_stamina_bar_max_num_bars,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local unit = template_context.unit
		local current_stamina, max_stamina = Stamina.current_and_max_value(unit, template_data.stamina_component, template_data.base_stamina_template)
		local missing_stamina_bars = math.floor(max_stamina - current_stamina)
		local lerp_t = math.min(missing_stamina_bars / crit_chance_per_missing_stamina_bar_max_num_bars, 1)

		return lerp_t
	end,
}
templates.hordes_buff_explode_enemies_on_critical_kill = {
	class_name = "server_only_proc_buff",
	cooldown_duration = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit,
	proc_func = function (params, template_data, template_context)
		local dying_unit_position = params.attacked_unit_position and params.attacked_unit_position:unbox()
		local explosion_position = dying_unit_position + Vector3.up()
		local explosion_template = ExplosionTemplates.hordes_buff_critical_kill_explosion

		Explosion.create_explosion(template_context.world, template_context.physics_world, explosion_position, Vector3.up(), template_context.unit, explosion_template, DEFAULT_POWER_LEVEL, 0.8, attack_types.explosion)
	end,
}

local melee_crit_chance_gained_after_ranged_crit_kill = HordesBuffsData.hordes_buff_increase_melee_crit_chance_on_ranged_critical_kill.buff_stats.crit_chance.value
local duration_melee_crit_chance_gained_after_ranged_crit_kill = HordesBuffsData.hordes_buff_increase_melee_crit_chance_on_ranged_critical_kill.buff_stats.time.value

templates.hordes_buff_increase_melee_crit_chance_on_ranged_critical_kill = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	active_duration = damage_reduction_on_critical_hit_duration,
	proc_effects = {
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_buff_less_damage",
		},
	},
	proc_stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = duration_melee_crit_chance_gained_after_ranged_crit_kill,
	},
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_crit_hit,
}

local ranged_crit_chance_gained_after_ranged_crit_kill = HordesBuffsData.hordes_buff_increase_ranged_crit_chance_on_melee_critical_kill.buff_stats.crit_chance.value
local duration_ranged_crit_chance_gained_after_ranged_crit_kill = HordesBuffsData.hordes_buff_increase_ranged_crit_chance_on_melee_critical_kill.buff_stats.time.value

templates.hordes_buff_increase_ranged_crit_chance_on_melee_critical_kill = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	active_duration = duration_ranged_crit_chance_gained_after_ranged_crit_kill,
	proc_effects = {
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_buff_less_damage",
		},
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = ranged_crit_chance_gained_after_ranged_crit_kill,
	},
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_crit_hit,
}
templates.hordes_buff_guaranteed_next_melee_attack_on_ranged_critical_hit = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		template_data.guaranteed_melee_crit_buff = false
	end,
	conditional_keywords = {
		buff_keywords.guaranteed_melee_critical_strike,
	},
	conditional_keywords_func = function (template_data, template_context)
		return template_data.guaranteed_melee_crit_buff
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			local is_melee_hit = CheckProcFunctions.on_melee_hit(params, template_data, template_context, t)

			if is_melee_hit and template_data.guaranteed_melee_crit_buff then
				template_data.guaranteed_melee_crit_buff = false
			end
		end,
		on_kill = function (params, template_data, template_context, t)
			local is_range_hit = CheckProcFunctions.on_ranged_hit(params, template_data, template_context, t)

			if is_range_hit and not template_data.guaranteed_melee_crit_buff then
				template_data.guaranteed_melee_crit_buff = true
			end
		end,
	},
}
templates.hordes_buff_guaranteed_next_ranged_attack_on_melee_critical_hit = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		template_data.guaranteed_range_crit_buff = false
	end,
	conditional_keywords = {
		buff_keywords.guaranteed_ranged_critical_strike,
	},
	conditional_keywords_func = function (template_data, template_context)
		return template_data.guaranteed_range_crit_buff
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			local is_range_hit = CheckProcFunctions.on_ranged_hit(params, template_data, template_context, t)

			if is_range_hit and template_data.guaranteed_range_crit_buff then
				template_data.guaranteed_range_crit_buff = false
			end
		end,
		on_kill = function (params, template_data, template_context, t)
			local is_melee_hit = CheckProcFunctions.on_melee_hit(params, template_data, template_context, t)

			if is_melee_hit and not template_data.guaranteed_range_crit_buff then
				template_data.guaranteed_range_crit_buff = true
			end
		end,
	},
}

local crit_damage_gained_per_critical_hit = HordesBuffsData.hordes_buff_critical_damage_from_consecutive_critical_hits.buff_stats.crit_damage.value
local max_crit_damage_gained_from_critical_hit = HordesBuffsData.hordes_buff_critical_damage_from_consecutive_critical_hits.buff_stats.max_crit_damage.value
local max_time_between_critical_hits = HordesBuffsData.hordes_buff_critical_damage_from_consecutive_critical_hits.buff_stats.time.value
local max_num_stacks_crit_damage = math.round(max_crit_damage_gained_from_critical_hit / crit_damage_gained_per_critical_hit)

templates.hordes_buff_critical_damage_from_consecutive_critical_hits = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		template_data.consecutive_critical_hits = 0
		template_data.reset_stacks_t = 0
		template_data.is_active = false
	end,
	lerped_stat_buffs = {
		[stat_buffs.critical_strike_damage] = {
			min = 0,
			max = max_crit_damage_gained_from_critical_hit,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local consecutive_critical_hits = template_data.consecutive_critical_hits
		local lerp_t = math.min(consecutive_critical_hits / max_num_stacks_crit_damage, 1)

		return lerp_t
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit,
	proc_func = function (params, template_data, template_context, t)
		template_data.consecutive_critical_hits = math.min(template_data.consecutive_critical_hits + 1, max_num_stacks_crit_damage)
		template_data.reset_stacks_t = FixedFrame.get_latest_fixed_time() + max_time_between_critical_hits
		template_data.is_active = true
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_data.is_active then
			return
		end

		local fixed_t = FixedFrame.get_latest_fixed_time()

		if fixed_t > template_data.reset_stacks_t then
			template_data.is_active = false
			template_data.consecutive_critical_hits = 0
		end
	end,
}

return templates
