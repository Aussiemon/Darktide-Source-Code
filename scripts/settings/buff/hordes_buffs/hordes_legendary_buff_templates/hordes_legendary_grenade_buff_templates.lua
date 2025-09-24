-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_legendary_buff_templates/hordes_legendary_grenade_buff_templates.lua

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

templates.hordes_buff_grenade_replenishment_over_time_passive = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		template_data.missing_charges = 0
		template_data.grenade_replenishment_cooldown = 180
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not template_data.ability_extension then
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension

		if not ability_extension:has_ability_type("grenade_ability") then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges("grenade_ability")

		if missing_charges == 0 then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		template_data.missing_charges = missing_charges

		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			template_data.next_grenade_t = t + template_data.grenade_replenishment_cooldown

			return
		end

		if next_grenade_t < t then
			if ability_extension and ability_extension:has_ability_type("grenade_ability") then
				ability_extension:restore_ability_charge("grenade_ability", 1)

				local player_fx_extension = ScriptUnit.has_extension(unit, "fx_system")

				if player_fx_extension then
					player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, unit)
				end
			end

			template_data.next_grenade_t = nil
		end
	end,
}

local percent_chance_extra_grenade_throw = HordesBuffsData.hordes_buff_extra_grenade_throw_chance.buff_stats.chance.value

templates.hordes_buff_extra_grenade_throw_chance = {
	class_name = "buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.extra_grenade_throw_chance] = percent_chance_extra_grenade_throw,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		HordesBuffsUtilities.give_passive_grenade_replenishment_buff(template_context.unit)
	end,
}

local percent_chance_grenade_duplication_on_explosion = HordesBuffsData.hordes_buff_grenade_duplication_on_explosion.buff_stats.chance.value

templates.hordes_buff_grenade_duplication_on_explosion = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		HordesBuffsUtilities.give_passive_grenade_replenishment_buff(template_context.unit)
	end,
	proc_events = {
		[proc_events.on_player_grenade_exploded] = percent_chance_grenade_duplication_on_explosion,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local owner_unit = params.owner_unit
		local owner_side = "heroes"
		local item_name = params.item_name
		local projectile_template = params.projectile_template
		local position = params.position:unbox()

		SharedBuffFunctions.spawn_grenade_at_position(owner_unit, owner_side, item_name, projectile_template, position, Vector3.up(), 1)

		local player_fx_extension = ScriptUnit.has_extension(owner_unit, "fx_system")

		if player_fx_extension then
			player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.duplication, nil, owner_unit)
		end
	end,
}

local percent_max_health_regen_on_grenade_explosion = HordesBuffsData.hordes_buff_grenade_heals_on_explosion.buff_stats.health.value

templates.hordes_buff_grenade_heals_on_explosion = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		HordesBuffsUtilities.give_passive_grenade_replenishment_buff(template_context.unit)
	end,
	proc_events = {
		[proc_events.on_player_grenade_exploded] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local owner_unit = params.owner_unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[owner_unit]
		local side_name = side:name()
		local position = params.position:unbox()
		local broadphase = template_data.broadphase
		local num_hits = broadphase.query(broadphase, position, range_close, BROADPHASE_RESULTS, side_name)

		for i = 1, num_hits do
			local ally_unit = BROADPHASE_RESULTS[i]
			local health_extension = ScriptUnit.extension(ally_unit, "health_system")

			if health_extension then
				local max_health = health_extension:max_health()
				local heal_amount = max_health * percent_max_health_regen_on_grenade_explosion

				health_extension:add_heal(heal_amount, DamageSettings.heal_types.buff)

				local player_fx_extension = ScriptUnit.has_extension(ally_unit, "fx_system")

				if player_fx_extension then
					player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.healing, nil, ally_unit)

					local vfx_position = position + Vector3(0, 0, 0)

					player_fx_extension:spawn_particles(VFX_NAMES.healing_explosion, vfx_position, nil, nil, nil, nil, true)
				end
			end
		end
	end,
}

local percent_damage_taken_increase_for_elemental_weakness = HordesBuffsData.hordes_buff_grenade_explosion_applies_elemental_weakness.buff_stats.damage.value
local elemental_weakness_duration = HordesBuffsData.hordes_buff_grenade_explosion_applies_elemental_weakness.buff_stats.time.value

templates.hordes_buff_grenade_explosion_applies_elemental_weakness = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		HordesBuffsUtilities.give_passive_grenade_replenishment_buff(template_context.unit)
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type == attack_types.explosion and GRENADE_EXPLOSION_DAMAGE_TYPES[params.damage_type]
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("hordes_buff_elemental_weakness", t, "owner_unit", player_unit)
		end
	end,
}
templates.hordes_buff_elemental_weakness = {
	class_name = "buff",
	max_stacks = 6,
	max_stacks_cap = 6,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	duration = elemental_weakness_duration,
	stat_buffs = {
		[stat_buffs.damage_taken_from_burning] = percent_damage_taken_increase_for_elemental_weakness,
		[stat_buffs.damage_taken_from_bleeding] = percent_damage_taken_increase_for_elemental_weakness,
		[stat_buffs.damage_taken_from_electrocution] = percent_damage_taken_increase_for_elemental_weakness,
	},
}

local percent_rending_debuff_on_explosion = HordesBuffsData.hordes_buff_grenade_explosion_applies_rending_debuff.buff_stats.brittle.value

templates.hordes_buff_grenade_explosion_applies_rending_debuff = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		HordesBuffsUtilities.give_passive_grenade_replenishment_buff(template_context.unit)
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type == attack_types.explosion and GRENADE_EXPLOSION_DAMAGE_TYPES[params.damage_type]
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("hordes_buff_grenade_explosion_applies_rending_debuff_effect", t, "owner_unit", player_unit)
		end
	end,
}
templates.hordes_buff_grenade_explosion_applies_rending_debuff_effect = {
	class_name = "buff",
	max_stacks = 6,
	max_stacks_cap = 6,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	stat_buffs = {
		[stat_buffs.rending_multiplier] = percent_rending_debuff_on_explosion,
	},
}

local grenade_replenishment_over_time_interval = HordesBuffsData.hordes_buff_grenade_replenishment_over_time.buff_stats.time.value

templates.hordes_buff_grenade_replenishment_over_time = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		template_data.missing_charges = 0
		template_data.grenade_replenishment_cooldown = grenade_replenishment_over_time_interval
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not template_data.ability_extension then
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension

		if not ability_extension or not ability_extension:has_ability_type("grenade_ability") then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges("grenade_ability")

		if missing_charges == 0 then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		template_data.missing_charges = missing_charges

		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			template_data.next_grenade_t = t + template_data.grenade_replenishment_cooldown

			return
		end

		if next_grenade_t < t then
			if ability_extension and ability_extension:has_ability_type("grenade_ability") then
				ability_extension:restore_ability_charge("grenade_ability", 1)

				local player_fx_extension = ScriptUnit.has_extension(unit, "fx_system")

				if player_fx_extension then
					player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, unit)
				end
			end

			template_data.next_grenade_t = nil
		end
	end,
}
templates.hordes_buff_spawn_dome_shield_on_grenade_explosion = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		HordesBuffsUtilities.give_passive_grenade_replenishment_buff(template_context.unit)
	end,
	proc_events = {
		[proc_events.on_player_grenade_exploded] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local grenade_position = params.position:unbox()
		local world = template_context.world
		local physics_world = World.physics_world(world)

		HordesBuffsUtilities.spawn_telekine_dome_at_position(physics_world, player_unit, grenade_position)
	end,
}

local percent_chance_grenade_kill_replenishes_grenade = HordesBuffsData.hordes_buff_grenade_explosion_kill_replenish_grenades.buff_stats.chance.value

templates.hordes_buff_grenade_explosion_kill_replenish_grenades = {
	class_name = "proc_buff",
	cooldown_duration = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = percent_chance_grenade_kill_replenishes_grenade,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type == attack_types.explosion and GRENADE_EXPLOSION_DAMAGE_TYPES[params.damage_type]
	end,
	proc_func = function (params, template_data, template_context)
		local player_unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(player_unit, "ability_system")

		if ability_extension and ability_extension:has_ability_type("grenade_ability") then
			ability_extension:restore_ability_charge("grenade_ability", 3)

			local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

			if player_fx_extension then
				player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, player_unit)
			end
		end
	end,
}
templates.hordes_buff_shock_on_grenade_impact = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local coherency_system = Managers.state.extension:system("coherency_system")

		coherency_system:add_external_buff(unit, "hordes_buff_coherency_shock_on_grenade_impact_effect")
	end,
}
templates.hordes_buff_coherency_shock_on_grenade_impact_effect = {
	class_name = "proc_buff",
	coherency_id = "hordes_buff_coherency_shock_on_grenade_impact_effect",
	coherency_priority = 2,
	cooldown_duration = 1,
	max_stacks = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server or params.damage_profile == nil then
			return false
		end

		local damage_profile_name = params.damage_profile.name

		return GRENADE_IMPACT_DAMAGE_TEMPLATES[damage_profile_name]
	end,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local attacked_unit = params.attacked_unit
		local shock_area_position = Unit.alive(attacked_unit) and POSITION_LOOKUP[attacked_unit] or params.hit_world_position and params.hit_world_position:unbox()
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, shock_area_position, range_melee, BROADPHASE_RESULTS, enemy_side_names)

		for i = 1, num_hits do
			local enemy_unit = BROADPHASE_RESULTS[i]
			local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff("shock_grenade_interval", t, "owner_unit", player_unit)
			end
		end

		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(SFX_NAMES.shock_aoe_big, shock_area_position)
		fx_system:trigger_vfx(VFX_NAMES.big_shock, shock_area_position)
	end,
}

return templates
