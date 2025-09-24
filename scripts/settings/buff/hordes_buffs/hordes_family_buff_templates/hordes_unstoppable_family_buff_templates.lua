-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_family_buff_templates/hordes_unstoppable_family_buff_templates.lua

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
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
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
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
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

local function compute_staggering_hits_during_movement(template_data, template_context, broadphase, enemy_side_name, stagger_zone_radius, stagger_strength_multiplier, movement_direction, allow_hit_while_staggered)
	local unit = template_context.unit
	local multiplier = stagger_strength_multiplier
	local max_distance = 4
	local position = POSITION_LOOKUP[unit]
	local check_position = position + movement_direction
	local num_hits = broadphase.query(broadphase, check_position, stagger_zone_radius, BROADPHASE_RESULTS, enemy_side_name)
	local hit_enemy_units = template_data.hit_enemy_units

	for i = 1, num_hits do
		local hit_unit = BROADPHASE_RESULTS[i]

		if HEALTH_ALIVE[hit_unit] then
			local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
			local breed = unit_data_extension and unit_data_extension:breed()
			local invalid = not breed or not breed.tags or breed.tags.ogryn or breed.tags.special or breed.tags.monster
			local allow_hit = allow_hit_while_staggered and not hit_enemy_units[hit_unit] or not MinionState.is_staggered(hit_unit)

			if not invalid and allow_hit then
				local hit_position = POSITION_LOOKUP[hit_unit]
				local hit_distance = Vector3.distance(hit_position, position)
				local hit_direction = Vector3.normalize(Vector3.flat(hit_position - position))
				local distance_multiplier = max_distance - hit_distance
				local hit_world_position = hit_position
				local damage_profile = DamageProfileTemplates.ogryn_dodge_impact
				local LUNGE_ATTACK_POWER_LEVEL = 500 * multiplier * distance_multiplier
				local damage_type = damage_types.ogryn_physical

				Attack.execute(hit_unit, damage_profile, "power_level", LUNGE_ATTACK_POWER_LEVEL, "hit_world_position", hit_world_position, "attack_direction", hit_direction, "attack_type", AttackSettings.attack_types.melee, "attacking_unit", unit, "damage_type", damage_type)

				if allow_hit_while_staggered then
					hit_enemy_units[hit_unit] = true
				end
			end
		end
	end
end

templates.hordes_buff_dodge_staggers = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.disable_horde_minions_collision_during_dodge,
		buff_keywords.disable_elite_minions_collision_during_dodge,
	},
	proc_events = {
		[proc_events.on_dodge_start] = 1,
		[proc_events.on_dodge_end] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local physics_world = World.physics_world(template_context.world)
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.physics_world = physics_world
		template_data.side_system = side_system
		template_data.enemy_side_names = enemy_side_names

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local archetype_name = unit_data_extension:archetype_name()

		template_data.archetype_name = archetype_name
		template_data.stagger_zone_radius = archetype_name == "ogryn" and 1.5 or 0.75
	end,
	check_proc_func = function (params, template_data, template_context)
		return template_data.archetype_name ~= "ogryn"
	end,
	specific_proc_func = {
		on_dodge_start = function (params, template_data, template_context)
			template_data.hit_enemy_units = {}
			template_data.active = true
			template_data.dodge_direction = params.dodge_direction

			local consecutive_dodges = Dodge.consecutive_dodges(template_context.unit)

			template_data.consecutive_dodges = consecutive_dodges
			template_data.stagger_strength_multiplier = 1 / (template_data.consecutive_dodges * 2 - 1)

			compute_staggering_hits_during_movement(template_data, template_context, template_data.broadphase, template_data.enemy_side_names, template_data.stagger_zone_radius, template_data.stagger_strength_multiplier, template_data.dodge_direction:unbox())
		end,
		on_dodge_end = function (params, template_data, template_context)
			template_data.active = false
		end,
	},
	update_func = function (template_data, template_context)
		if not template_data.active then
			return
		end

		compute_staggering_hits_during_movement(template_data, template_context, template_data.broadphase, template_data.enemy_side_names, template_data.stagger_zone_radius, template_data.stagger_strength_multiplier, template_data.dodge_direction:unbox())
	end,
}
templates.hordes_buff_sprinting_staggers = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.disable_horde_minions_collision_during_sprint,
		buff_keywords.disable_elite_minions_collision_during_sprint,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.hit_enemy_units = {}

		local physics_world = World.physics_world(template_context.world)

		template_data.physics_world = physics_world

		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.side_system = side_system
		template_data.enemy_side_names = enemy_side_names

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local archetype = unit_data_extension:archetype()
		local archetype_name = unit_data_extension:archetype_name()

		template_data.base_stamina_template = archetype.stamina
		template_data.stamina_component = unit_data_extension:read_component("stamina")
		template_data.locomotion_component = unit_data_extension:read_component("locomotion")
		template_data.sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
		template_data.stagger_zone_radius = archetype_name == "ogryn" and 1.5 or 0.75
	end,
	update_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local current_stamina, _ = Stamina.current_and_max_value(unit, template_data.stamina_component, template_data.base_stamina_template)
		local is_sprinting = Sprint.is_sprinting(template_data.sprint_character_state_component)

		if is_sprinting and current_stamina > 0 then
			local velocity_current = template_data.locomotion_component.velocity_current
			local movement_direction = Vector3.normalize(velocity_current)

			compute_staggering_hits_during_movement(template_data, template_context, template_data.broadphase, template_data.enemy_side_names, template_data.stagger_zone_radius, 1, movement_direction)
		end
	end,
}
templates.hordes_buff_uninterruptible_while_aiming_and_shooting = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_keywords = {
		buff_keywords.uninterruptible,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data.alternate_fire_component = unit_data_extension:read_component("alternate_fire")
		template_data.shooting_status_component = unit_data_extension:read_component("shooting_status")
	end,
	conditional_keywords_func = function (template_data, template_context)
		local alternate_fire_component = template_data.alternate_fire_component
		local is_aiming = alternate_fire_component.is_active

		if is_aiming then
			return true
		end

		local shooting_status_component = template_data.shooting_status_component
		local fixed_t = FixedFrame.get_latest_fixed_time()
		local is_shooting = shooting_status_component.shooting or not shooting_status_component.shooting and fixed_t <= shooting_status_component.shooting_end_time + 0.5

		if is_shooting then
			return true
		end

		return false
	end,
}

local percent_stamina_gained_per_hit = HordesBuffsData.hordes_buff_replenish_stamina_from_ranged_or_melee_hit.buff_stats.stamina.value

templates.hordes_buff_replenish_stamina_from_ranged_or_melee_hit = {
	class_name = "server_only_proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_damage_dealt] = 1,
	},
	check_proc_func = CheckProcFunctions.any(CheckProcFunctions.on_melee_hit, CheckProcFunctions.on_ranged_hit),
	proc_func = function (params, template_data, template_context)
		local damage_dealt = params.damage
		local percent_stamina_gained = math.round(damage_dealt) / 100 * percent_stamina_gained_per_hit

		Stamina.add_stamina_percent(template_context.unit, percent_stamina_gained)
	end,
}

local percent_toughness_coherency_regen_increase = HordesBuffsData.hordes_buff_toughness_coherency_regen_increase.buff_stats.toughness.value

templates.hordes_buff_toughness_coherency_regen_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.toughness_coherency_regen_rate_multiplier] = percent_toughness_coherency_regen_increase,
	},
}
templates.hordes_buff_no_movement_speed_reduction_on_aim_and_windup = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0,
		[stat_buffs.windup_action_movespeed_reduction_multiplier] = 0,
	},
}
templates.hordes_buff_increase_impact_on_push_attacks = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.push_impact_modifier] = 2,
	},
	proc_events = {
		[proc_events.on_push_finish] = 1,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
		local first_person_component = unit_data_ext:read_component("first_person")

		template_data.first_person_component = first_person_component
		template_data.fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")
	end,
	proc_func = function (params, template_data, template_context)
		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local vfx_pos = player_position
		local player_rotation = template_data.first_person_component.rotation
		local forward_direction = Quaternion.forward(player_rotation)
		local flat_forward_direction = Vector3.flat(forward_direction)
		local rotation = Quaternion.look(flat_forward_direction, Vector3.up())

		template_data.fx_extension:spawn_particles(VFX_NAMES.push_wave, vfx_pos, rotation, nil, nil, nil, true)
	end,
}

local percent_toughness_regen_on_melee_kill = HordesBuffsData.hordes_buff_toughness_on_melee_kills.buff_stats.toughness.value

templates.hordes_buff_toughness_on_melee_kills = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	proc_func = function (params, template_data, template_context)
		Toughness.replenish_percentage(template_context.unit, percent_toughness_regen_on_melee_kill, false)
	end,
}

local percent_stamina_regen_on_toughness_broken = HordesBuffsData.hordes_buff_movement_bonuses_on_toughness_broken.buff_stats.stamina.value
local time_slow_and_stun_immunity_on_toughness_broken = HordesBuffsData.hordes_buff_movement_bonuses_on_toughness_broken.buff_stats.time.value

templates.hordes_buff_movement_bonuses_on_toughness_broken = {
	class_name = "proc_buff",
	cooldown_duration = 30,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	active_duration = time_slow_and_stun_immunity_on_toughness_broken,
	proc_events = {
		[proc_events.on_player_toughness_broken] = 1,
	},
	keywords = {
		buff_keywords.stun_immune_toughness_broken,
	},
	proc_keywords = {
		buff_keywords.stun_immune,
		buff_keywords.slowdown_immune,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return template_context.unit == params.unit
	end,
	proc_func = function (params, template_data, template_context)
		Stamina.add_stamina_percent(template_context.unit, percent_stamina_regen_on_toughness_broken)
	end,
}
templates.hordes_buff_suppression_immunity = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.suppression_immune,
	},
}
templates.hordes_buff_windup_is_uninterruptible = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_keywords = {
		buff_keywords.uninterruptible,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
	end,
	conditional_keywords_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
		local is_windup = action_settings and action_settings.kind == "windup"

		return is_windup
	end,
}

local cooldown_time_dodge_incapacitating_attacks = HordesBuffsData.hordes_buff_dodge_incapacitating_attacks.buff_stats.cooldown.value

templates.hordes_buff_dodge_incapacitating_attacks = {
	active_duration = 3,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_effects = {
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_buff_unstoppable_shield_01",
		},
	},
	conditional_keywords = {
		buff_keywords.count_as_dodge_vs_netgunner,
		buff_keywords.count_as_dodge_vs_chaos_hound_pounce,
	},
	start_func = function (template_data, template_context)
		template_data.is_active = true
		template_data.last_activation_time = 0
	end,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return false
		end

		return template_data.is_active and params.dodge_type == "buff"
	end,
	proc_func = function (params, template_data, template_context)
		template_data.is_active = false
		template_data.last_activation_time = FixedFrame.get_latest_fixed_time() + 2

		local player_unit = template_context.unit
		local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

		if player_fx_extension then
			player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.avoid_hit_triggered, nil, player_unit)
		end
	end,
	conditional_keywords_func = function (template_data, template_context)
		if not template_context.is_server then
			return false
		end

		if template_data.is_active then
			return true
		end

		local fixed_t = FixedFrame.get_latest_fixed_time()
		local is_in_buffer_time = fixed_t <= template_data.last_activation_time

		if is_in_buffer_time then
			return true
		end

		if fixed_t > template_data.last_activation_time + cooldown_time_dodge_incapacitating_attacks then
			template_data.is_active = true

			local player_unit = template_context.unit
			local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

			if player_fx_extension then
				player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.avoid_hit_cooldown_finished, nil, player_unit)
			end

			return true
		end

		return false
	end,
}

local extra_stamina_for_damage_gained_per_full_stamina_bar = HordesBuffsData.hordes_buff_damage_per_full_stamina_bar.buff_stats.stamina.value
local damage_gained_per_full_stamina_bar = HordesBuffsData.hordes_buff_damage_per_full_stamina_bar.buff_stats.damage.value
local max_num_bars_for_damage_gained_per_full_stamina_bar = 15

templates.hordes_buff_damage_per_full_stamina_bar = {
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
	stat_buffs = {
		[stat_buffs.stamina_modifier] = extra_stamina_for_damage_gained_per_full_stamina_bar,
	},
	lerped_stat_buffs = {
		[stat_buffs.damage] = {
			min = 0,
			max = damage_gained_per_full_stamina_bar * max_num_bars_for_damage_gained_per_full_stamina_bar,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local unit = template_context.unit
		local current_stamina, _ = Stamina.current_and_max_value(unit, template_data.stamina_component, template_data.base_stamina_template)
		local full_stamina_bars = math.floor(current_stamina)
		local lerp_t = math.min(full_stamina_bars / max_num_bars_for_damage_gained_per_full_stamina_bar, 1)

		return lerp_t
	end,
}

return templates
