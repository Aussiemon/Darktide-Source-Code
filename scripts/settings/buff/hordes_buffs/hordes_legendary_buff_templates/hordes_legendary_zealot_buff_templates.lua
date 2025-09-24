-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_legendary_buff_templates/hordes_legendary_zealot_buff_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local HordesBuffsUtilities = require("scripts/settings/buff/hordes_buffs/hordes_buffs_utilities")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
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

local zealot_aiming_pulse_burning_stacks = 1

templates.hordes_buff_zealot_fire_pulse_while_aiming_lunge = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_lunge_aim_start] = 1,
		[proc_events.on_lunge_aim_end] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[player_unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
		template_data.fire_pulse_interval = 1
		template_data.next_pulse_t = -1
		template_data.is_active = false
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_context.is_server and template_data.is_active and t >= template_data.next_pulse_t then
			HordesBuffsUtilities.compute_fire_pulse(template_context.is_server, template_context.unit, template_data.broadphase, template_data.enemy_side_names, t, zealot_aiming_pulse_burning_stacks)

			template_data.next_pulse_t = t + template_data.fire_pulse_interval
		end
	end,
	specific_proc_func = {
		[proc_events.on_lunge_aim_start] = function (params, template_data, template_context)
			if template_context.is_server then
				template_data.is_active = true
			end
		end,
		[proc_events.on_lunge_aim_end] = function (params, template_data, template_context)
			if template_context.is_server then
				template_data.is_active = false
			end
		end,
	},
}

local liquid_areas_in_position = {}
local zealot_percent_toughness_regen_inside_fire = HordesBuffsData.hordes_buff_zealot_regen_toughness_inside_fire_grenade.buff_stats.thoughness.value
local zealot_interval_regen_inside_fire = HordesBuffsData.hordes_buff_zealot_regen_toughness_inside_fire_grenade.buff_stats.time.value

templates.hordes_buff_zealot_regen_toughness_inside_fire_grenade = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	interval = zealot_interval_regen_inside_fire,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.liquid_area_system = Managers.state.extension:system("liquid_area_system")
		template_data.side_system = Managers.state.extension:system("side_system")
	end,
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local side_system = template_data.side_system
		local player_side = side_system.side_by_unit[player_unit]
		local player_side_name = player_side:name()

		table.clear_array(liquid_areas_in_position, #liquid_areas_in_position)
		template_data.liquid_area_system:find_liquid_areas_in_position(player_position, liquid_areas_in_position)

		for _, liquid_area_extension in pairs(liquid_areas_in_position) do
			local area_template_name = liquid_area_extension:area_template_name()
			local source_side_name = liquid_area_extension:source_side_name()
			local is_friendly_area = source_side_name and player_side_name == source_side_name
			local is_fire_grenade_area = area_template_name == "fire_grenade"

			if is_fire_grenade_area and is_friendly_area then
				local recovered_toughness = Toughness.replenish_percentage(player_unit, zealot_percent_toughness_regen_inside_fire, true)
				local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

				if recovered_toughness > 0 and player_fx_extension then
					player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.shield, nil, player_unit)
				end

				break
			end
		end
	end,
}
templates.hordes_buff_zealot_lunge_hit_triggers_shout = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_lunge_start] = 1,
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.locomotion_component = unit_data_extension:read_component("locomotion")
		template_data.first_person_component = unit_data_extension:read_component("first_person")
		template_data.shout_triggered = true
		template_data.shout_radius = 9
		template_data.shout_target_template = "hordes_zealot_lunge_shout"
	end,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data)
			return params.damage_profile and params.damage_profile.name == "zealot_dash_impact"
		end,
	},
	specific_proc_func = {
		[proc_events.on_lunge_start] = function (params, template_data, template_context)
			template_data.shout_triggered = false
		end,
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			if template_data.shout_triggered or not template_context.is_server then
				return
			end

			local player_unit = template_context.unit
			local rotation = template_data.first_person_component.rotation
			local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))

			ShoutAbilityImplementation.execute(template_data.shout_radius, template_data.shout_target_template, player_unit, t, template_data.locomotion_component, forward)

			local player_fx_extension = ScriptUnit.extension(player_unit, "fx_system")

			if HEALTH_ALIVE[player_unit] and player_fx_extension then
				local variable_name = "size"
				local variable_value = Vector3(8, 8, 8)
				local vfx_position = POSITION_LOOKUP[player_unit] + Vector3.up()

				player_fx_extension:spawn_particles(VFX_NAMES.veteran_shout, vfx_position, nil, nil, variable_name, variable_value, true)
			end
		end,
	},
}
templates.hordes_buff_zealot_channel_heals_corruption = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.zealot_channel_heals_corruption,
	},
}

local zealot_percent_damage_taken_increase_after_shock = HordesBuffsData.hordes_buff_zealot_shock_grenade_increase_next_hit_damage.buff_stats.damage.value

templates.hordes_buff_zealot_shock_grenade_increase_next_hit_damage = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type == attack_types.explosion and params.damage_type == damage_types.electrocution
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("hordes_buff_increase_next_hit_damage", t, "owner_unit", player_unit)
		end
	end,
}
templates.hordes_buff_increase_next_hit_damage = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	stat_buffs = {
		[stat_buffs.damage_taken_modifier] = zealot_percent_damage_taken_increase_after_shock,
	},
	proc_events = {
		[proc_events.on_minion_damage_taken] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.hit_taken = false
	end,
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type ~= attack_types.buff
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.hit_taken = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.hit_taken
	end,
}

local zealot_percent_toughness_replenished_on_bleeding_enemy_kill = HordesBuffsData.hordes_buff_zealot_knives_bleed_and_restore_thoughness_on_kill.buff_stats.thoughness.value

templates.hordes_buff_zealot_knives_bleed_and_restore_thoughness_on_kill = {
	class_name = "server_only_proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_bleeding_minion_death] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[player_unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data)
			return params.damage_type == damage_types.throwing_knife_zealot
		end,
	},
	specific_proc_func = {
		[proc_events.on_hit] = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			local victim_unit = params.attacked_unit
			local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

			if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
				local t = FixedFrame.get_latest_fixed_time()
				local player_unit = template_context.unit

				victim_buff_extension:add_internally_controlled_buff_with_stacks("bleed", 1, t, "owner_unit", player_unit)
			end
		end,
		[proc_events.on_bleeding_minion_death] = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			local player_unit = template_context.unit
			local bleed_stacks = params.bleed_stacks
			local toughness_recovered = bleed_stacks * zealot_percent_toughness_replenished_on_bleeding_enemy_kill

			Toughness.replenish_percentage(player_unit, toughness_recovered, true)
		end,
	},
}

return templates
