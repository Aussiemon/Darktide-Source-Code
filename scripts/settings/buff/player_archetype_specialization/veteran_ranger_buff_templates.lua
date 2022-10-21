local Action = require("scripts/utilities/weapon/action")
local Ammo = require("scripts/utilities/ammo")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local FixedFrame = require("scripts/utilities/fixed_frame")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local Sway = require("scripts/utilities/sway")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.veteran_2
local templates = {
	veteran_ranger_ranged_stance = {
		class_name = "proc_buff",
		buff_id = "veteran_ranger_combat_ability",
		predicted = false,
		refresh_duration_on_stack = true,
		duration = talent_settings.combat_ability.duration,
		max_stacks = talent_settings.combat_ability.max_stacks,
		keywords = {
			keywords.stun_immune,
			keywords.slowdown_immune,
			keywords.suppression_immune,
			keywords.ranged_alternate_fire_interrupt_immune,
			keywords.uninterruptible,
			keywords.deterministic_recoil,
			keywords.veteran_ranger_combat_ability
		},
		stat_buffs = {
			[stat_buffs.push_speed_modifier] = talent_settings.combat_ability.push_speed_modifier,
			[stat_buffs.movement_speed] = talent_settings.movement_speed,
			[stat_buffs.ranged_weakspot_damage] = talent_settings.combat_ability.ranged_weakspot_damage,
			[stat_buffs.ranged_impact_modifier] = talent_settings.combat_ability.ranged_impact_modifier,
			[stat_buffs.ranged_damage] = talent_settings.combat_ability.ranged_damage,
			[stat_buffs.fov_multiplier] = talent_settings.combat_ability.fov_multiplier
		},
		conditional_stat_buffs = {
			[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.defensive_1.toughness_damage_taken_multiplier
		},
		proc_events = {
			[proc_events.on_hit] = talent_settings.combat_ability.on_hit_proc_chance
		},
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_veteran_killshot",
			looping_wwise_start_event = "wwise/events/player/play_player_ability_veteran_killshot_stance_on",
			looping_wwise_stop_event = "wwise/events/player/play_player_ability_veteran_killshot_stance_off",
			wwise_state = {
				group = "player_ability",
				on_state = "veteran_stance",
				off_state = "none"
			}
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local specialization_extension = ScriptUnit.extension(template_context.unit, "specialization_system")
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			template_data.unit_data_extension = unit_data_extension
			template_data.inventory_component = unit_data_extension:read_component("inventory")
			template_data.disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
			template_data.starting_slot_name = template_data.inventory_component.wielded_slot
			template_data.outlines_for_coherency = specialization_extension:has_special_rule(special_rules.veteran_ranger_combat_ability_outlines_for_coherency)
			template_data.refresh_on_kill = specialization_extension:has_special_rule(special_rules.veteran_ranger_combat_ability_kills_refresh)
			template_data.toughness_damage_reduction = specialization_extension:has_special_rule(special_rules.veteran_ranger_combat_ability_toughness_damage_reduction)
			local reload_weapon = specialization_extension:has_special_rule(special_rules.veteran_ranger_combat_ability_reloads_weapon)

			if reload_weapon then
				local inventory_slot_component = unit_data_extension:write_component("slot_secondary")
				local max_ammo_in_clip = inventory_slot_component.max_ammunition_clip
				local current_ammo_in_clip = inventory_slot_component.current_ammunition_clip
				local missing_ammo_in_clip = max_ammo_in_clip - current_ammo_in_clip

				Ammo.transfer_from_reserve_to_clip(inventory_slot_component, missing_ammo_in_clip)
			end

			template_data.first_update = true

			if Managers.stats.can_record_stats() then
				local player = template_context.player

				Managers.stats:record_volley_fire_start(player)
			end
		end,
		stop_func = function (template_data, template_context)
			if Managers.stats.can_record_stats() then
				local player = template_context.player

				Managers.stats:record_volley_fire_stop(player)
			end
		end,
		refresh_func = function (template_data, template_context, t)
			template_data.first_update = true
		end,
		proc_func = function (params, template_data, template_context)
			if not template_data.refresh_on_kill then
				return
			end

			local on_kill = CheckProcFunctions.on_kill(params)

			if not on_kill then
				return
			end

			local tags = params.tags

			if not tags or tags.ogryn then
				return
			end

			if not tags.elite and not tags.special then
				return
			end

			local t = FixedFrame.get_latest_fixed_time()
			local unit = template_context.unit
			local buff_extension = ScriptUnit.extension(unit, "buff_system")

			buff_extension:add_internally_controlled_buff("veteran_ranger_ranged_stance", t)
		end,
		update_func = function (template_data, template_context, dt, t)
			if template_data.first_update then
				local unit = template_context.unit
				local outline_buff = "veteran_ranger_ranged_stance_outline_units"
				local buff_extension = ScriptUnit.extension(unit, "buff_system")

				buff_extension:add_internally_controlled_buff(outline_buff, t)

				if template_context.is_server and template_data.outlines_for_coherency then
					local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
					local units_in_coherence = coherency_extension:in_coherence_units()
					local outline_buff_short = "veteran_ranger_ranged_stance_outline_units_short"

					for coherency_unit, _ in pairs(units_in_coherence) do
						local is_local_unit = coherency_unit == unit

						if not is_local_unit then
							local coherency_buff_extension = ScriptUnit.extension(coherency_unit, "buff_system")

							coherency_buff_extension:add_internally_controlled_buff(outline_buff_short, t)
						end
					end
				end

				template_data.first_update = false
			end
		end,
		conditional_stat_buffs_func = function (template_data, template_context)
			return template_data.toughness_damage_reduction
		end,
		conditional_exit_func = function (template_data, template_context)
			local is_disabled = template_data.disabled_character_state_component.is_disabled
			local inventory_component = template_data.inventory_component
			local wielded_slot_name = inventory_component.wielded_slot
			local correct_slot = wielded_slot_name == template_data.starting_slot_name

			return is_disabled or not correct_slot
		end
	}
}
local OUTLINE_NAME = "special_target"
local DISTANCE_LIMIT = talent_settings.combat_ability.outline_distance
local ANGLE_LIMIT = math.pi * talent_settings.combat_ability.outline_angle
local DISTANCE_LIMIT_SQUARED = DISTANCE_LIMIT * DISTANCE_LIMIT
local HIGHLIGHT_OFFSET = talent_settings.combat_ability.outline_highlight_offset
local HIGHLIGHT_OFFSET_TOTAL_MAX_TIME = talent_settings.combat_ability.outline_highlight_offset_total_max_time
local HIGHLIGHT_SOUND_ALIAS = "veteran_ranger_highlight"

local function _start_outline(template_data, template_context)
	local unit = template_context.unit
	local fx_extension = ScriptUnit.has_extension(unit, "fx_system")
	template_data.fx_extension = fx_extension
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system and side_system.side_by_unit[unit]
	local enemy_units = side and side.enemy_units_lookup or {}
	local player_position = POSITION_LOOKUP[unit]
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local first_person_component = unit_data_extension:read_component("first_person")
	local rotation = first_person_component.rotation
	local player_forward = Vector3.normalize(Vector3.cross(Vector3.up(), Quaternion.right(rotation)))
	local alive_specials = {}
	local sort_value = {}

	for enemy_unit, _ in pairs(enemy_units) do
		local enemy_unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
		local breed = enemy_unit_data_extension and enemy_unit_data_extension:breed()

		if breed and breed.volley_fire_target then
			local special_position = POSITION_LOOKUP[enemy_unit]
			local from_player = special_position - player_position
			local from_player_flatten = Vector3.normalize(Vector3.flat(from_player))
			local distance_squared = Vector3.length_squared(from_player_flatten)
			local angle = distance_squared > 0 and Vector3.angle(from_player_flatten, player_forward) or 0
			local angle_score = angle / ANGLE_LIMIT
			distance_squared = Vector3.length_squared(from_player)
			local distance_score = distance_squared / DISTANCE_LIMIT_SQUARED
			local is_score_low_enough = angle_score < 1 and distance_score < 1

			if is_score_low_enough then
				alive_specials[#alive_specials + 1] = enemy_unit
				sort_value[enemy_unit] = angle_score + distance_score
			end
		end
	end

	table.sort(alive_specials, function (unit1, unit2)
		local angle1 = sort_value[unit1]
		local angle2 = sort_value[unit2]

		return angle1 < angle2
	end)

	template_data.alive_specials = alive_specials
	template_data.outlined_units = {}
	template_data.time_in_buff = 0
end

local function _update_outlines(template_data, template_context, dt, t)
	local time_in_buff = template_data.time_in_buff + dt
	template_data.time_in_buff = time_in_buff
	local alive_specials = template_data.alive_specials
	local fx_extension = template_data.fx_extension
	local has_outline_system = Managers.state.extension:has_system("outline_system")

	if has_outline_system and alive_specials then
		local outline_system = Managers.state.extension:system("outline_system")
		local outlined_units = template_data.outlined_units
		local number_of_active_specials = #alive_specials
		local activation_time = math.min(HIGHLIGHT_OFFSET, HIGHLIGHT_OFFSET_TOTAL_MAX_TIME / number_of_active_specials)

		for i = 1, number_of_active_specials do
			local special_unit = alive_specials[i]

			if not outlined_units[special_unit] and time_in_buff > i * activation_time then
				outline_system:add_outline(special_unit, OUTLINE_NAME)

				outlined_units[special_unit] = true
				local except_sender = true

				fx_extension:trigger_gear_wwise_event(HIGHLIGHT_SOUND_ALIAS, except_sender)
			end
		end
	end
end

local function _end_outlines(template_data, template_context)
	local has_outline_system = Managers.state.extension:has_system("outline_system")

	if has_outline_system then
		local outline_system = Managers.state.extension:system("outline_system")
		local outlined_units = template_data.outlined_units

		for unit, _ in pairs(outlined_units) do
			outline_system:remove_outline(unit, OUTLINE_NAME)
		end
	end

	template_data.outlined_units = nil
	template_data.alive_specials = nil
end

templates.veteran_ranger_ranged_stance_outline_units = {
	predicted = true,
	refresh_duration_on_stack = true,
	max_stacks = 1,
	class_name = "buff",
	duration = talent_settings.combat_ability.outline_duration,
	start_func = function (template_data, template_context)
		local is_local_unit = template_context.is_local_unit
		local player = template_context.player
		local is_human_controlled = player:is_human_controlled()
		local local_player = Managers.player:local_player(1)
		local camera_handler = local_player and local_player.camera_handler
		local is_observing = camera_handler and camera_handler:is_observing()
		template_data.valid_player = is_local_unit and is_human_controlled or is_observing

		if not template_data.valid_player then
			return
		end

		_start_outline(template_data, template_context)
	end,
	refresh_func = function (template_data, template_context, t)
		if not template_data.valid_player then
			return
		end

		_start_outline(template_data, template_context)
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_data.valid_player then
			return
		end

		_update_outlines(template_data, template_context, dt, t)
	end,
	stop_func = function (template_data, template_context)
		if not template_data.valid_player then
			return
		end

		_end_outlines(template_data, template_context)
	end
}
templates.veteran_ranger_ranged_stance_outline_units_short = table.clone(templates.veteran_ranger_ranged_stance_outline_units)
templates.veteran_ranger_ranged_stance_outline_units_short.duration = talent_settings.coop_1.outline_short_duration
templates.veteran_ranger_increase_weakspot_damage = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.weakspot_damage] = talent_settings.passive_1.weakspot_damage
	}
}
templates.veteran_ranger_increased_ammo_reserve = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.ammo_reserve_capacity] = talent_settings.passive_2.ammo_reserve_capacity
	}
}
templates.veteran_ranger_toughness_on_elite_kill = {
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	proc_func = function (params, template_data, template_context, t)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		buff_extension:add_internally_controlled_buff("veteran_ranger_toughness_on_elite_kill_buff", t)
		Toughness.replenish_percentage(template_context.unit, talent_settings.toughness_1.instant_toughness, false, "talent_toughness_1")
	end
}
templates.veteran_ranger_toughness_on_elite_kill_buff = {
	predicted = false,
	class_name = "buff",
	duration = talent_settings.toughness_1.duration,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		Toughness.replenish_percentage(template_context.unit, talent_settings.toughness_1.toughness * dt, false, "talent_toughness_1")

		template_data.next_regen_t = nil
	end
}
local range = talent_settings.toughness_3.range
templates.veteran_ranger_toughness_regen_out_of_melee = {
	predicted = false,
	class_name = "buff",
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		template_data.broadphase = broadphase
		template_data.broadphase_results = {}
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		template_data.enemy_side_names = enemy_side_names
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_context.is_server then
			return
		end

		local next_regen_t = template_data.next_regen_t

		if not next_regen_t then
			template_data.next_regen_t = t + talent_settings.toughness_3.time

			return
		end

		if next_regen_t < t then
			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local broadphase_results = template_data.broadphase_results

			table.clear(broadphase_results)

			local num_hits = broadphase:query(player_position, range, broadphase_results, enemy_side_names)

			if num_hits == 0 then
				Toughness.replenish_percentage(template_context.unit, talent_settings.toughness_3.toughness, false, "talent_toughness_3")

				template_data.next_regen_t = t + talent_settings.toughness_3.time
			end
		end
	end
}
templates.veteran_ranger_ranged_weakspot_toughness_recovery = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_weakspot_kills,
	proc_func = function (params, template_data, template_context)
		Toughness.replenish_percentage(template_context.unit, talent_settings.toughness_2.toughness, false, "talent_toughness_2")
	end
}
templates.veteran_ranger_increase_ranged_far_damage = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_far] = talent_settings.offensive_1_1.damage_far
	}
}
templates.veteran_ranger_tactical_reload_speed = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.offensive_1_2.reload_speed
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot
		local ammo_percentage = Ammo.current_slot_clip_percentage(unit, wielded_slot)

		return ammo_percentage > 0
	end
}
local grenade_replenishment_cooldown = talent_settings.offensive_1_3.grenade_replenishment_cooldown
local ABILITY_TYPE = "grenade_ability"
local grenades_restored = talent_settings.offensive_1_3.grenade_restored
templates.veteran_ranger_grenade_replenishment = {
	predicted = false,
	class_name = "buff",
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_data.ability_extension then
			local unit = template_context.unit
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension

		if not ability_extension or not ability_extension:has_ability_type(ABILITY_TYPE) then
			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges(ABILITY_TYPE)

		if missing_charges == 0 then
			return
		end

		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			template_data.next_grenade_t = t + grenade_replenishment_cooldown

			return
		end

		if next_grenade_t < t then
			local position = POSITION_LOOKUP[template_context.unit]

			template_data.fx_extension:trigger_exclusive_wwise_event("wwise/events/player/play_pick_up_ammo_01", position)
			ability_extension:restore_ability_charge(ABILITY_TYPE, grenades_restored)

			template_data.next_grenade_t = nil
		end
	end
}
templates.veteran_ranger_elites_replenish_ammo = {
	coherency_id = "veteran_ranger_coherency_aura",
	predicted = false,
	coherency_priority = 2,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local units_in_coherence = template_data.coherency_extension:in_coherence_units()

		for coherency_unit, _ in pairs(units_in_coherence) do
			local ammo_percent = talent_settings.coherency.ammo_replenishment_percent

			Ammo.add_to_all_slots(coherency_unit, ammo_percent)
		end
	end
}
templates.veteran_ranger_elites_replenish_grenades = {
	coherency_id = "veteran_ranger_coherency_aura_grenades",
	predicted = false,
	coherency_priority = 2,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = talent_settings.coop_2.proc_chance
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local units_in_coherence = template_data.coherency_extension:in_coherence_units()

		for coherency_unit, _ in pairs(units_in_coherence) do
			local fx_extension = ScriptUnit.has_extension(coherency_unit, "fx_system")

			if fx_extension then
				local position = POSITION_LOOKUP[coherency_unit]

				fx_extension:trigger_exclusive_wwise_event("wwise/events/player/play_pick_up_ammo_01", position)
			end

			local ability_extension = ScriptUnit.has_extension(coherency_unit, "ability_system")

			if ability_extension then
				ability_extension:restore_ability_charge(ABILITY_TYPE, grenades_restored)
			end
		end
	end
}
templates.veteran_ranger_replenish_toughness_of_ally_close_to_victim = {
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	start_func = function (template_data, template_context)
		local side_system = Managers.state.extension:system("side_system")
		local unit = template_context.unit
		template_data.side = side_system.side_by_unit[unit]
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit

		if not HEALTH_ALIVE[victim_unit] then
			return
		end

		local player_units = template_data.side.valid_player_units
		local local_unit = template_context.unit
		local victim_pos = POSITION_LOOKUP[victim_unit]
		local chosen_ally_unit = nil
		local range = talent_settings.coop_3.range

		for i = 1, #player_units do
			local player_unit = player_units[i]

			if player_unit ~= local_unit then
				local player_pos = POSITION_LOOKUP[player_unit]
				local dist = Vector3.distance_squared(victim_pos, player_pos)

				if dist < range * range then
					range = dist
					chosen_ally_unit = player_unit
				end
			end
		end

		if chosen_ally_unit then
			Toughness.replenish_percentage(chosen_ally_unit, talent_settings.coop_3.toughness_percent, false, "ranger_coop_talent")
		end
	end
}
templates.veteran_ranger_stamina_on_ranged_dodges = {
	cooldown_duration = 0.5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_ranged_dodge] = 1
	},
	proc_func = function (params, template_data, template_context)
		Stamina.add_stamina_percent(template_context.unit, talent_settings.defensive_2.stamina_percent)
	end
}
local STANDING_STILL_EPSILON = 0.001
templates.veteran_ranger_reduced_threat_gain = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.threat_weight_multiplier] = talent_settings.defensive_3.threat_weight_multiplier
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.locomotion_component = unit_data_extension:read_component("locomotion")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local velocity_magnitude = Vector3.length_squared(template_data.locomotion_component.velocity_current)
		local standing_still = velocity_magnitude < STANDING_STILL_EPSILON

		return standing_still
	end
}
templates.veteran_ranger_frag_grenade_bleed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_non_kill,
	proc_func = function (params, template_data, template_context, t)
		local damage_type = params.damage_type

		if not damage_type or damage_type ~= "frag" then
			return
		end

		local hit_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

		if buff_extension then
			local num_stacks = talent_settings.offensive_2_1.stacks

			for i = 1, num_stacks do
				buff_extension:add_internally_controlled_buff("bleed", t)
			end
		end
	end
}
templates.veteran_ranger_ads_stamina_boost = {
	predicted = true,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_shoot] = 1
	},
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.offensive_2_2.critical_strike_chance,
		[stat_buffs.sway_modifier] = talent_settings.offensive_2_2.sway_modifier
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.alternate_fire_component = unit_data_extension:read_component("alternate_fire")
		template_data.stamina_component = unit_data_extension:read_component("stamina")
		template_data.sway_component = unit_data_extension:write_component("sway_control")
		local specialization = unit_data_extension:specialization()
		local specialization_stamina_template = specialization.stamina
		local current_value, max_value = Stamina.current_and_max_value(template_context.unit, template_data.stamina_component, specialization_stamina_template)
		template_data.to_remove = talent_settings.offensive_2_2.stamina * max_value
		template_data.shoot_to_remove = talent_settings.offensive_2_2.shot_stamina_percent * max_value
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local has_stamina = template_data.stamina_component.current_fraction > 0

		if not has_stamina then
			return false
		end

		return template_data.alternate_fire_component.is_active
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_data.alternate_fire_component.is_active then
			template_data.applied_end_sway = nil

			return
		end

		local cost_per_second = template_data.to_remove
		local remaining_stamina = Stamina.drain(template_context.unit, cost_per_second * dt, t)

		if remaining_stamina == 0 and not template_data.applied_end_sway then
			template_data.applied_end_sway = true

			Sway.add_fixed_immediate_sway(template_data.sway_component, 1, 1)
		end
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_data.alternate_fire_component.is_active then
			template_data.applied_end_sway = nil

			return
		end

		local shoot_cost = template_data.shoot_to_remove

		Stamina.drain(template_context.unit, shoot_cost, t)
	end
}
templates.veteran_ranger_elite_kills_reload_speed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	proc_stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.offensive_2_3.reload_speed
	},
	proc_func = function (params, template_data, template_context, t)
		local buff_extension = ScriptUnit.has_extension(template_context.unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff("veteran_ranger_next_reload_buff", t)
		end
	end
}
templates.veteran_ranger_next_reload_buff = {
	predicted = false,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_reload_start] = 1
	},
	stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.offensive_2_3.reload_speed
	},
	proc_func = function (params, template_data, template_context, t)
		local buff_extension = ScriptUnit.has_extension(template_context.unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff("veteran_ranger_reload_speed_buff", t)
		end

		template_data.finish = true
	end,
	conditional_exit_func = function (template_data)
		return template_data.finish
	end
}
templates.veteran_ranger_reload_speed_buff = {
	predicted = false,
	duration = 3,
	max_stacks = 1,
	refresh_duration_on_stack = true,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.offensive_2_3.reload_speed
	}
}
templates.veteran_ranger_ranged_stance_rending = table.clone(templates.veteran_ranger_ranged_stance)
templates.veteran_ranger_ranged_stance_rending.stat_buffs[stat_buffs.rending_multiplier] = talent_settings.combat_ability_1.rending
templates.veteran_ranger_ranged_stance_weapon_handling_improved = table.clone(templates.veteran_ranger_ranged_stance)
templates.veteran_ranger_ranged_stance_weapon_handling_improved.stat_buffs[stat_buffs.spread_modifier] = talent_settings.combat_ability_3.spread_modifier
templates.veteran_ranger_ranged_stance_weapon_handling_improved.stat_buffs[stat_buffs.recoil_modifier] = talent_settings.combat_ability_3.recoil_modifier
templates.veteran_ranger_ranged_stance_weapon_handling_improved.stat_buffs[stat_buffs.sway_modifier] = talent_settings.combat_ability_3.sway_modifier

return templates
