-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_family_buff_templates/hordes_elementalist_family_buff_templates.lua

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

templates.hordes_buff_shock_on_blocking_melee_attack = {
	class_name = "proc_buff",
	cooldown_duration = 0.2,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_block] = 1,
	},
	start_func = function (template_data, template_context)
		return
	end,
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacking_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("hordes_ailment_shock", t, "owner_unit", player_unit)

			local fx_system = Managers.state.extension:system("fx_system")
			local enemy_position = POSITION_LOOKUP[victim_unit]

			fx_system:trigger_wwise_event(SFX_NAMES.shock_proc, enemy_position)
			fx_system:trigger_vfx(VFX_NAMES.single_target_shock, enemy_position)
		end
	end,
}

local percent_damage_taken_to_ability_cooldown_conversion_rate = HordesBuffsData.hordes_buff_combat_ability_cooldown_on_damage_taken.buff_stats.damage_to_cooldown.value

templates.hordes_buff_combat_ability_cooldown_on_damage_taken = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")

		template_data.health_extension = health_extension

		local ability_extension = ScriptUnit.extension(unit, "ability_system")

		template_data.ability_extension = ability_extension

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_read_component = unit_data_extension:read_component("character_state")

		template_data.character_state_read_component = character_state_read_component
	end,
	check_proc_func = function (params, template_data, template_context)
		if params.attacked_unit ~= template_context.unit then
			return false
		end

		local character_state_read_component = template_data.character_state_read_component
		local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_read_component)

		if is_knocked_down then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context)
		local ability_extension = template_data.ability_extension
		local damage_taken = params.damage_amount
		local damage_taken_to_ability_cd_percentage = percent_damage_taken_to_ability_cooldown_conversion_rate
		local cooldown_percent = damage_taken * damage_taken_to_ability_cd_percentage

		ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown_percent)
	end,
}

local max_toughness_stacks_gained_per_burning_shocked_enemy = 20
local toughness_gained_per_burning_shocked_enemy = HordesBuffsData.hordes_buff_extra_toughness_near_burning_shocked_enemies.buff_stats.extra_thoughness.value

templates.hordes_buff_extra_toughness_near_burning_shocked_enemies = {
	class_name = "buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	lerped_stat_buffs = {
		[stat_buffs.toughness_bonus_flat] = {
			min = 0,
			max = toughness_gained_per_burning_shocked_enemy * max_toughness_stacks_gained_per_burning_shocked_enemy,
		},
	},
	start_func = function (template_data, template_context)
		template_data.range = range_close

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.num_enemies_in_range = 0

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local t = FixedFrame.get_latest_fixed_time()

		template_data.next_check_t = t + 1
		template_data.enemy_side_names = enemy_side_names
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local next_check_t = template_data.next_check_t

		if next_check_t < t then
			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local num_stacks = 0
			local num_hits = broadphase.query(broadphase, player_position, template_data.range, BROADPHASE_RESULTS, enemy_side_names)

			for i = 1, num_hits do
				local enemy_unit = BROADPHASE_RESULTS[i]
				local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

				if buff_extension then
					local target_is_burning_or_electrocuted = buff_extension:has_keyword(buff_keywords.burning) or buff_extension:has_keyword(buff_keywords.electrocuted)

					if target_is_burning_or_electrocuted then
						num_stacks = num_stacks + 1

						if num_stacks >= max_toughness_stacks_gained_per_burning_shocked_enemy then
							break
						end
					end
				end
			end

			template_data.num_enemies_in_range = num_stacks
			template_data.next_check_t = t + 1
		end

		return math.clamp(template_data.num_enemies_in_range / max_toughness_stacks_gained_per_burning_shocked_enemy, 0, 1)
	end,
}

return templates
