-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_legendary_buff_templates/hordes_legendary_veteran_buff_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local HordesBuffsUtilities = require("scripts/settings/buff/hordes_buffs/hordes_buffs_utilities")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local buff_categories = BuffSettings.buff_categories
local buff_keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local SFX_NAMES = HordesBuffsUtilities.SFX_NAMES
local VFX_NAMES = HordesBuffsUtilities.VFX_NAMES
local BROADPHASE_RESULTS = {}
local templates = {}

table.make_unique(templates)

templates.hordes_buff_veteran_shock_units_in_smoke_grenade = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_unit_enter_fog] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]

		template_data.side_system = side_system
		template_data.player_side = side
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local entring_unit = params.target_unit
		local side_system = template_data.side_system
		local player_side = template_data.player_side
		local target_unit_side = side_system.side_by_unit[entring_unit]
		local is_unit_enemy = side_system:is_enemy_by_side(player_side, target_unit_side)
		local buff_extension = ScriptUnit.has_extension(entring_unit, "buff_system")

		if is_unit_enemy and HEALTH_ALIVE[entring_unit] and buff_extension then
			buff_extension:add_internally_controlled_buff_with_stacks("hordes_ailment_shock", 1, t, "owner_unit", player_unit)

			local enemy_position = POSITION_LOOKUP[entring_unit]
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:trigger_wwise_event(SFX_NAMES.shock_proc, enemy_position)
			fx_system:trigger_vfx(VFX_NAMES.single_target_shock, enemy_position)
		end
	end,
}

local veteran_sticky_grenade_pull_radius = HordesBuffsData.hordes_buff_veteran_sticky_grenade_pulls_enemies.buff_stats.radius.value

templates.hordes_buff_veteran_sticky_grenade_pulls_enemies = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.broadphase, template_data.enemy_side_names = SharedBuffFunctions.get_broadphase_and_enemy_side_names(unit)
	end,
	proc_events = {
		[proc_events.on_projectile_stick] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local target_unit = params.target_unit
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local target_stagger_type = stagger_types.heavy

		HordesBuffsUtilities.pull_enemies_towards_target_unit(player_unit, target_unit, target_stagger_type, broadphase, enemy_side_names, veteran_sticky_grenade_pull_radius)

		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(SFX_NAMES.gravity_pull, nil, target_unit)
	end,
}
templates.hordes_buff_veteran_infinite_ammo_during_stance = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_keywords = {
		buff_keywords.no_ammo_consumption,
	},
	start_func = function (template_data, template_context)
		template_data.is_active = false
	end,
	conditional_keywords_func = function (template_data, template_context)
		return template_data.is_active
	end,
	update_func = function (template_data, template_context)
		template_data.is_active = template_context.buff_extension and template_context.buff_extension:has_keyword(buff_keywords.veteran_combat_ability_stance)
	end,
}
templates.hordes_buff_veteran_apply_infinite_bleed_on_shout = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.hit_units = {}
	end,
	check_proc_func = CheckProcFunctions.on_shout_hit,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local hit_unit = params.attacked_unit
		local hit_units = template_data.hit_units

		if HEALTH_ALIVE[hit_unit] and not hit_units[hit_unit] then
			local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff_with_stacks("hordes_ailment_infinite_minion_bleed", 20, t, "owner_unit", player_unit)
			end
		end
	end,
}

local veteran_duration_damage_increase_after_stealth = HordesBuffsData.hordes_buff_veteran_increased_damage_after_stealth.buff_stats.time.value
local veteran_percent_damage_increase_after_stealth = HordesBuffsData.hordes_buff_veteran_increased_damage_after_stealth.buff_stats.dammage.value

templates.hordes_buff_veteran_increased_damage_after_stealth = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local buff_extension = template_context.buff_extension

		buff_extension:add_internally_controlled_buff("hordes_buff_veteran_increased_damage_after_stealth_effect", t)
	end,
}
templates.hordes_buff_veteran_increased_damage_after_stealth_effect = {
	class_name = "veteran_stealth_bonuses_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	duration = veteran_duration_damage_increase_after_stealth,
	stat_buffs = {
		[stat_buffs.damage] = veteran_percent_damage_increase_after_stealth,
	},
}
templates.hordes_buff_veteran_grouped_upgraded_stealth = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.can_attack_during_invisibility,
	},
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local side_system = Managers.state.extension:system("side_system")

		template_data.side = side_system.side_by_unit[template_context.unit]
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local buff_extension = template_context.buff_extension

		buff_extension:add_internally_controlled_buff("hordes_buff_veteran_upgraded_stealth_effect", t)

		local range_squared = 64
		local ally_player_units = template_data.side.valid_player_units
		local source_player_position = POSITION_LOOKUP[template_context.unit]

		for _, ally_player_unit in pairs(ally_player_units) do
			if HEALTH_ALIVE[ally_player_unit] and ally_player_unit ~= template_context.unit then
				local unit_data_extension = ScriptUnit.extension(ally_player_unit, "unit_data_system")
				local character_state_component = unit_data_extension:read_component("character_state")
				local requires_help = PlayerUnitStatus.requires_help(character_state_component)

				if not requires_help then
					local distance_to_player_squared = Vector3.distance_squared(source_player_position, POSITION_LOOKUP[ally_player_unit])
					local player_buff_extension = ScriptUnit.has_extension(ally_player_unit, "buff_system")

					if player_buff_extension and distance_to_player_squared <= range_squared then
						player_buff_extension:add_internally_controlled_buff("hordes_buff_veteran_stealth_group_allies_effect", t)
					end
				end
			end
		end
	end,
}
templates.hordes_buff_veteran_upgraded_stealth_effect = {
	class_name = "veteran_stealth_bonuses_buff",
	duration = 0.2,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.invulnerable,
		buff_keywords.can_attack_during_invisibility,
	},
}
templates.hordes_buff_veteran_stealth_group_allies_effect = {
	class_name = "buff",
	duration = 8,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.invisible,
		buff_keywords.invulnerable,
		buff_keywords.can_attack_during_invisibility,
	},
}

return templates
