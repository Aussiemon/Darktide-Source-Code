local Action = require("scripts/utilities/weapon/action")
local Ammo = require("scripts/utilities/ammo")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local CheckProcFunctionTemplates = require("scripts/settings/buff/check_proc_function_templates")
local ConditionalFunctionTemplates = require("scripts/settings/buff/conditional_function_templates")
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.veteran_2
local templates = {}
local tag_list = {
	chaos_poxwalker_bomber = true,
	renegade_shocktrooper = true,
	renegade_grenadier = true,
	renegade_sniper = true,
	cultist_berzerker = true,
	renegade_netgunner = true,
	renegade_gunner = true,
	cultist_grenadier = true,
	cultist_mutant = true,
	chaos_hound = true,
	cultist_shocktrooper = true,
	cultist_gunner = true,
	renegade_executor = true,
	cultist_flamer = true
}
templates.veteran_ranger_ranged_stance = {
	buff_id = "veteran_ranger_combat_ability",
	refresh_duration_on_stack = true,
	class_name = "proc_buff",
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
		[stat_buffs.toughness_damage] = talent_settings.combat_ability.toughness_damage,
		[stat_buffs.movement_speed] = talent_settings.movement_speed,
		[stat_buffs.ranged_weakspot_damage] = talent_settings.combat_ability.ranged_weakspot_damage,
		[stat_buffs.ranged_impact_modifier] = talent_settings.combat_ability.ranged_impact_modifier,
		[stat_buffs.ranged_damage] = talent_settings.combat_ability.ranged_damage,
		[stat_buffs.spread_modifier] = talent_settings.combat_ability.spread_modifier,
		[stat_buffs.recoil_modifier] = talent_settings.combat_ability.recoil_modifier,
		[stat_buffs.sway_modifier] = talent_settings.combat_ability.sway_modifier,
		[stat_buffs.elusiveness_modifier] = talent_settings.combat_ability.elusiveness_modifier,
		[stat_buffs.fov_multiplier] = talent_settings.combat_ability.fov_multiplier
	},
	conditional_stat_buffs = {
		[stat_buffs.ranged_weakspot_damage] = talent_settings.combat_ability_1.ranged_weakspot_damage
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
		template_data.increased_weakspot_damage = specialization_extension:has_special_rule(special_rules.veteran_ranger_combat_ability_increased_weakspot_damage)
		local reload_weapon = specialization_extension:has_special_rule(special_rules.veteran_ranger_combat_ability_reloads_weapon)

		if reload_weapon then
			local inventory_slot_component = unit_data_extension:write_component("slot_secondary")
			local max_ammo_in_clip = inventory_slot_component.max_ammunition_clip
			local current_ammo_in_clip = inventory_slot_component.current_ammunition_clip
			local missing_ammo_in_clip = max_ammo_in_clip - current_ammo_in_clip

			Ammo.transfer_from_reserve_to_clip(inventory_slot_component, missing_ammo_in_clip)
		end

		template_data.first_update = true
	end,
	refresh_func = function (template_data, template_context, t)
		template_data.first_update = true
	end,
	proc_func = function (params, template_data, template_context)
		if not template_data.refresh_on_kill then
			return
		end

		local on_kill = CheckProcFunctionTemplates.on_kill(params)

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

		local t = Managers.time:time("gameplay")
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
		return template_data.increased_weakspot_damage
	end,
	conditional_exit_func = function (template_data, template_context)
		local is_disabled = template_data.disabled_character_state_component.is_disabled
		local inventory_component = template_data.inventory_component
		local wielded_slot_name = inventory_component.wielded_slot
		local correct_slot = wielded_slot_name == template_data.starting_slot_name

		return is_disabled or not correct_slot
	end
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
	local enemy_units = (side and side.enemy_units_lookup) or {}
	local player_position = POSITION_LOOKUP[unit]
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local first_person_component = unit_data_extension:read_component("first_person")
	local rotation = first_person_component.rotation
	local player_forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	local alive_specials = {}
	local sort_value = {}

	for enemy_unit, _ in pairs(enemy_units) do
		local enemy_unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
		local breed = enemy_unit_data_extension and enemy_unit_data_extension:breed()
		local breed_name = breed and breed.name

		if breed_name and tag_list[breed_name] then
			local special_position = POSITION_LOOKUP[enemy_unit]
			local from_player = special_position - player_position
			local from_player_flatten = Vector3.normalize(Vector3.flat(from_player))
			local distance_squared = Vector3.length_squared(from_player_flatten)
			local angle = (distance_squared > 0 and Vector3.angle(from_player_flatten, player_forward)) or 0
			local angle_score = angle / ANGLE_LIMIT
			local distance_squared = Vector3.length_squared(from_player)
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

		for i = 1, number_of_active_specials, 1 do
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
	max_stacks = 1,
	refresh_duration_on_stack = true,
	class_name = "buff",
	duration = talent_settings.combat_ability.outline_duration,
	start_func = function (template_data, template_context)
		local is_local_unit = template_context.is_local_unit
		local local_player = Managers.player:local_player(1)
		local camera_handler = local_player and local_player.camera_handler
		local is_observing = camera_handler and camera_handler:is_observing()
		template_data.valid_player = is_local_unit or is_observing

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
templates.veteran_ranger_increase_damage_to_unaggroed_enemies = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_vs_unaggroed] = talent_settings.mixed_1.damage_vs_unaggroed
	}
}
local grenade_replenishment_cooldown = talent_settings.mixed_2.grenade_replenishment_cooldown
local ABILITY_TYPE = "grenade_ability"
local grenades_restored = talent_settings.mixed_2.grenade_restored
templates.veteran_ranger_grenade_replenishment = {
	class_name = "buff",
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local ability_extension = template_data.ability_extension
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
			ability_extension:restore_ability_charge(ABILITY_TYPE, grenades_restored)

			template_data.next_grenade_t = nil
		end
	end
}
templates.veteran_ranger_reduced_threat_gain = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.threat_weight_multiplier] = talent_settings.mixed_3.threat_weight_multiplier
	}
}
templates.veteran_ranger_free_ammo_chance = {
	coherency_priority = 2,
	coherency_id = "veteran_ranger_coherency_aura",
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_ammo_consumed] = talent_settings.coherency.on_ammo_consumed_proc_chance
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.unit_data_extension = unit_data_extension
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local buff_to_add = "veteran_ranger_free_ammo"
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local t = Managers.time:time("gameplay")

		buff_extension:add_internally_controlled_buff(buff_to_add, t)
	end
}
templates.veteran_ranger_free_ammo_chance_improved = {
	coherency_priority = 1,
	coherency_id = "veteran_ranger_coherency_aura",
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_ammo_consumed] = talent_settings.coop_2.on_ammo_consumed_proc_chance
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.unit_data_extension = unit_data_extension
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local buff_to_add = "veteran_ranger_free_ammo"
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local t = Managers.time:time("gameplay")

		buff_extension:add_internally_controlled_buff(buff_to_add, t)
	end
}
templates.veteran_ranger_free_ammo = {
	predicted = false,
	class_name = "proc_buff",
	keywords = {
		keywords.no_ammo_consumption
	},
	proc_events = {
		[proc_events.on_ammo_consumed] = 1
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end
}
templates.veteran_ranger_toughness_regen = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness_replenish_multiplier] = talent_settings.coop_3.toughness_replenish_multiplier
	}
}
templates.veteran_ranger_increase_ranged_far_damage = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_far] = talent_settings.offensive_1.damage_far
	}
}
templates.veteran_ranger_tactical_reload_speed = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.offensive_2.reload_speed
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
templates.veteran_ranger_increase_ranged_damage = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings.offensive_3.ranged_damage
	}
}
templates.veteran_ranger_ranged_weakspot_toughness_gain = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.defensive_1.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_ranged_weakspot_kills,
	proc_func = function (params)
		Toughness.replenish(params.attacking_unit, "weakspot_proc_buff")
	end
}
templates.veteran_ranger_improved_ranged_dodge = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.dodge_linger_time_ranged_modifier] = talent_settings.defensive_2.dodge_linger_time_ranged_modifier
	}
}
templates.veteran_ranger_mobility_while_aiming_down_sights = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = talent_settings.defensive_3.alternate_fire_movement_speed_reduction_modifier
	}
}
templates.veteran_ranger_increase_weakspot_damage_improved = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.weakspot_damage] = talent_settings.spec_passive_1.weakspot_damage
	}
}
templates.veteran_ranger_armor_penetreation_on_weakspot = {
	predicted = false,
	class_name = "buff",
	keywords = {
		keywords.weakspot_hit_gains_armor_penetration
	}
}
templates.veteran_ranger_chance_of_ammo_on_weakspot = {
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = talent_settings.spec_passive_3.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_weakspot_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.unit_data_extension = unit_data_extension
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	proc_func = function (params, template_data, template_context)
		local inventory_component = template_data.inventory_component
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot ~= "slot_primary" and wielded_slot ~= "slot_secondary" then
			return
		end

		local inventory_slot_component = template_data.unit_data_extension:write_component(wielded_slot)
		local uses_ammo = inventory_slot_component.max_ammunition_clip > 0

		if not uses_ammo then
			return
		end

		local amount_rounded_up = 1

		Ammo.add_to_clip(inventory_slot_component, amount_rounded_up)
	end
}
templates.veteran_ranger_combat_ability_ranged_couts_as_weakspot = {
	predicted = false,
	class_name = "buff",
	conditional_keywords = {
		keywords.ranged_counts_as_weakspot
	},
	conditional_keywords_func = function (template_data, template_context)
		local buff_extension = template_context.buff_extension
		local has_buff = buff_extension:has_buff_id("veteran_ranger_combat_ability")

		return has_buff
	end
}
templates.veteran_ranger_combat_ability_periodicly_critical_strike_test = {
	predicted = false,
	class_name = "proc_buff",
	keywords = {
		keywords.guaranteed_ranged_critical_strike
	},
	proc_events = {
		[proc_events.on_shoot] = 1
	},
	proc_func = function (params, template_data, template_context)
		template_data.finished = true
	end,
	conditional_exit_func = function (template_data, template_context)
		local finished = template_data.finished

		return finished
	end
}
templates.veteran_ranger_combat_ability_periodicly_critical_strike = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_shoot] = 1
	},
	conditional_keywords = {
		keywords.guaranteed_ranged_critical_strike
	},
	update_func = function (template_data, template_context, dt, t, template)
		local buff_extension = template_context.buff_extension
		local has_buff = buff_extension:has_buff_id("veteran_ranger_combat_ability")

		if has_buff then
			local count_down = template_data.count_down or 0
			count_down = count_down - dt

			if count_down <= 0 then
				template_data.is_active = true
				template_data.count_down = 1
			else
				template_data.count_down = count_down
			end
		else
			template_data.count_down = nil
			template_data.is_active = false
		end
	end,
	conditional_keywords_func = function (template_data, template_context)
		local is_active = template_data.is_active

		return is_active
	end,
	proc_func = function (params, template_data, template_context)
		template_data.is_active = false
	end
}

return templates
