local Action = require("scripts/utilities/weapon/action")
local Ammo = require("scripts/utilities/ammo")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local Suppression = require("scripts/utilities/attack/suppression")
local Sway = require("scripts/utilities/sway")
local TalentSettings = require("scripts/settings/talent/talent_settings_new")
local Toughness = require("scripts/utilities/toughness/toughness")
local attack_types = AttackSettings.attack_types
local attack_results = AttackSettings.attack_results
local damage_types = DamageSettings.damage_types
local buff_categories = BuffSettings.buff_categories
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local slot_configuration = PlayerCharacterConstants.slot_configuration
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings_2 = TalentSettings.veteran_2
local talent_settings_3 = TalentSettings.veteran_3
local _can_show_outline, _start_outlines, _update_outlines, _end_outlines, _is_in_weapon_alternate_fire_with_stamina = nil

local function _volley_fire_penance_start(template_data, template_context)
	local player = template_context.player

	Managers.stats:record_private("hook_volley_fire_start", player)

	template_data.volley_fire_total_time = 0
end

local function _volley_fire_penance_update(dt, t, template_data, template_context)
	local volley_fire_total_time = template_data.volley_fire_total_time

	if volley_fire_total_time then
		template_data.volley_fire_total_time = volley_fire_total_time + dt
	end
end

local function _volley_fire_penance_stop(template_data, template_context)
	local player = template_context.player

	Managers.stats:record_private("hook_volley_fire_stop", player, template_data.volley_fire_total_time)

	template_data.volley_fire_total_time = nil
end

local function _volley_fire_penance_proc(template_data, template_context)
	local player = template_context.player

	Managers.stats:record_private("hook_veteran_kill_volley_fire_target", player)
end

local templates = {
	veteran_combat_ability_stance_master = {
		buff_id = "veteran_combat_ability_stance_master",
		predicted = false,
		allow_proc_while_active = true,
		hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_ability_volley_fire",
		hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
		class_name = "proc_buff",
		refresh_duration_on_stack = true,
		duration = talent_settings_2.combat_ability.duration,
		max_stacks = talent_settings_2.combat_ability.max_stacks,
		keywords = {
			keywords.stun_immune,
			keywords.slowdown_immune,
			keywords.suppression_immune,
			keywords.ranged_alternate_fire_interrupt_immune,
			keywords.uninterruptible,
			keywords.deterministic_recoil,
			keywords.veteran_combat_ability_stance
		},
		stat_buffs = {
			[stat_buffs.fov_multiplier] = talent_settings_2.combat_ability.fov_multiplier,
			[stat_buffs.spread_modifier] = talent_settings_2.combat_ability.spread_modifier,
			[stat_buffs.recoil_modifier] = talent_settings_2.combat_ability.recoil_modifier,
			[stat_buffs.sway_modifier] = talent_settings_2.combat_ability.sway_modifier
		},
		proc_events = {
			[proc_events.on_hit] = 1
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local specialization_extension = ScriptUnit.has_extension(unit, "specialization_system")
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
			template_data.apply_outlines = true
			template_data.unit_data_extension = unit_data_extension
			template_data.inventory_component = inventory_component
			template_data.starting_slot_name = inventory_component.wielded_slot
			template_data.disabled_character_state_component = disabled_character_state_component
			template_data.buff_extension = buff_extension

			if specialization_extension then
				template_data.coherency_outlines = specialization_extension:has_special_rule(special_rules.veteran_combat_ability_coherency_outlines)
				template_data.outlined_kills_extends_duration = specialization_extension:has_special_rule(special_rules.veteran_combat_ability_outlined_kills_extends_duration)
				template_data.show_elite_and_special_outlines = specialization_extension:has_special_rule(special_rules.veteran_combat_ability_elite_and_special_outlines)
				template_data.show_ranged_roamer_outlines = specialization_extension:has_special_rule(special_rules.veteran_combat_ability_ranged_roamer_outlines)
				template_data.show_ogryn_outlines = specialization_extension:has_special_rule(special_rules.veteran_combat_ability_ogryn_outlines)
			end

			_volley_fire_penance_start(template_data, template_context)
		end,
		proc_end_func = function (template_data, template_context)
			_volley_fire_penance_stop(template_data, template_context)
		end,
		refresh_func = function (template_data, template_context, t)
			template_data.apply_outlines = true
		end,
		proc_func = function (params, template_data, template_context, t)
			if not CheckProcFunctions.on_kill(params, template_data, template_context, t) then
				return
			end

			_volley_fire_penance_proc(template_data, template_context)

			if not template_data.outlined_kills_extends_duration then
				return
			end

			local breed_name = params.breed_name
			local breed = breed_name and Breeds[breed_name]

			if not _can_show_outline(breed, template_data) then
				return
			end

			local buff_extension = template_data.buff_extension

			if buff_extension then
				local buff_name = template_context.template.name

				buff_extension:add_internally_controlled_buff(buff_name, t)
			end
		end,
		update_func = function (template_data, template_context, dt, t)
			if template_data.apply_outlines then
				local unit = template_context.unit
				local outline_buff = "veteran_combat_ability_outlines"
				local buff_extension = template_data.buff_extension

				buff_extension:add_internally_controlled_buff(outline_buff, t, "owner_unit", unit)

				if template_context.is_server and template_data.coherency_outlines then
					local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
					local units_in_coherence = coherency_extension:in_coherence_units()
					local outline_buff_short = "veteran_combat_ability_outlines_coherency"

					for coherency_unit, _ in pairs(units_in_coherence) do
						local is_local_unit = coherency_unit == unit

						if not is_local_unit then
							local coherency_buff_extension = ScriptUnit.extension(coherency_unit, "buff_system")

							coherency_buff_extension:add_internally_controlled_buff(outline_buff_short, t, "owner_unit", unit)
						end
					end
				end

				template_data.apply_outlines = false
			end

			_volley_fire_penance_update(dt, t, template_data, template_context)
		end,
		conditional_exit_func = function (template_data, template_context)
			local disabled_character_state_component = template_data.disabled_character_state_component
			local inventory_component = template_data.inventory_component
			local is_disabled = disabled_character_state_component.is_disabled
			local wielded_slot_name = inventory_component.wielded_slot
			local correct_slot = wielded_slot_name == template_data.starting_slot_name

			return is_disabled or not correct_slot
		end,
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_veteran_killshot",
			looping_wwise_start_event = "wwise/events/player/play_player_ability_veteran_killshot_stance_on",
			looping_wwise_stop_event = "wwise/events/player/play_player_ability_veteran_killshot_stance_off",
			wwise_state = {
				group = "player_ability",
				on_state = "veteran_stance",
				off_state = "none"
			}
		}
	},
	veteran_combat_ability_outlines = {
		predicted = false,
		refresh_duration_on_stack = true,
		max_stacks = 1,
		class_name = "buff",
		duration = talent_settings_2.combat_ability.outline_duration,
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

			_start_outlines(template_data, template_context)
		end,
		refresh_func = function (template_data, template_context, t)
			if not template_data.valid_player then
				return
			end

			_start_outlines(template_data, template_context)
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
}
templates.veteran_combat_ability_outlines_coherency = table.clone(templates.veteran_combat_ability_outlines)
templates.veteran_combat_ability_outlines_coherency.duration = talent_settings_2.coop_1.outline_short_duration

templates.veteran_combat_ability_outlines_coherency.start_func = function (template_data, template_context)
	local is_local_unit = template_context.is_local_unit
	local player = template_context.player
	local is_human_controlled = player:is_human_controlled()
	local local_player = Managers.player:local_player(1)
	local camera_handler = local_player and local_player.camera_handler
	local is_observing = camera_handler and camera_handler:is_observing()
	template_data.coherency_outline_buff = true
	template_data.valid_player = is_local_unit and is_human_controlled or is_observing

	if not template_data.valid_player then
		return
	end

	_start_outlines(template_data, template_context)
end

templates.veteran_combat_ability_increased_ranged_and_weakspot_damage_base = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.ranged_weakspot_damage] = talent_settings_2.combat_ability_base.ranged_weakspot_damage,
		[stat_buffs.ranged_impact_modifier] = talent_settings_2.combat_ability_base.ranged_impact_modifier,
		[stat_buffs.ranged_damage] = talent_settings_2.combat_ability_base.ranged_damage
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	update_func = function (template_data, template_context)
		template_data.active = template_data.buff_extension:has_keyword(keywords.veteran_combat_ability_stance)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active
	end
}
templates.veteran_combat_ability_increased_ranged_and_weakspot_damage_outlines = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.ranged_weakspot_damage] = talent_settings_2.combat_ability.ranged_weakspot_damage - talent_settings_2.combat_ability_base.ranged_weakspot_damage,
		[stat_buffs.ranged_impact_modifier] = talent_settings_2.combat_ability.ranged_impact_modifier - talent_settings_2.combat_ability_base.ranged_impact_modifier,
		[stat_buffs.ranged_damage] = talent_settings_2.combat_ability.ranged_damage - talent_settings_2.combat_ability_base.ranged_damage
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	update_func = function (template_data, template_context)
		template_data.active = template_data.buff_extension:has_keyword(keywords.veteran_combat_ability_stance)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active
	end
}
templates.veteran_combat_ability_extra_charge = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.ability_extra_charges] = 1,
		[stat_buffs.combat_ability_cooldown_modifier] = 0.33
	}
}
local OUTLINE_NAME = "special_target"
local DISTANCE_LIMIT = talent_settings_2.combat_ability.outline_distance
local DISTANCE_LIMIT_SQUARED = DISTANCE_LIMIT * DISTANCE_LIMIT
local HIGHLIGHT_OFFSET = talent_settings_2.combat_ability.outline_highlight_offset
local HIGHLIGHT_OFFSET_TOTAL_MAX_TIME = talent_settings_2.combat_ability.outline_highlight_offset_total_max_time
local HIGHLIGHT_SOUND_ALIAS = "veteran_ranger_highlight"

function _can_show_outline(breed, template_data)
	local breed_tags = breed and breed.tags

	if not breed_tags then
		return false
	end

	local show_elite_and_special_outlines = template_data.show_elite_and_special_outlines
	local show_ranged_roamer_outlines = template_data.show_ranged_roamer_outlines
	local show_ogryn_outlines = template_data.show_ogryn_outlines
	local show_outlines = show_elite_and_special_outlines or show_ranged_roamer_outlines or show_ogryn_outlines

	if not show_outlines then
		return false
	end

	local is_ogryn = breed_tags.ogryn

	if is_ogryn and not show_ogryn_outlines then
		return false
	end

	local is_elite_or_special = breed_tags.elite or breed_tags.special
	local is_volley_fire_target = breed.volley_fire_target
	local valid_target = is_elite_or_special and show_elite_and_special_outlines or is_volley_fire_target and show_ranged_roamer_outlines or is_ogryn and show_ogryn_outlines

	if not valid_target then
		return false
	end

	return true
end

function _start_outlines(template_data, template_context)
	local outlined_units = template_data.outlined_units or {}
	template_data.outlined_units = outlined_units
	local unit = template_context.unit
	local fx_extension = ScriptUnit.has_extension(unit, "fx_system")
	template_data.fx_extension = fx_extension
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system and side_system.side_by_unit[unit]
	local enemy_units = side and side.enemy_units_lookup or {}
	local player_position = Unit.world_position(unit, 1)
	local specialization_extension = ScriptUnit.has_extension(unit, "specialization_system")

	if specialization_extension then
		template_data.show_elite_and_special_outlines = specialization_extension:has_special_rule(special_rules.veteran_combat_ability_elite_and_special_outlines) or template_data.coherency_outline_buff
		template_data.show_ranged_roamer_outlines = specialization_extension:has_special_rule(special_rules.veteran_combat_ability_ranged_roamer_outlines) and not template_data.coherency_outline_buff
		template_data.show_ogryn_outlines = specialization_extension:has_special_rule(special_rules.veteran_combat_ability_ogryn_outlines) and not template_data.coherency_outline_buff
	end

	local alive_specials = {}
	local sort_value = {}

	for enemy_unit, _ in pairs(enemy_units) do
		local enemy_unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
		local breed = enemy_unit_data_extension and enemy_unit_data_extension:breed()
		local breed_tags = breed and breed.tags
		local is_outlined = outlined_units[enemy_unit]
		local should_get_outlined = not is_outlined and _can_show_outline(breed, template_data)

		if should_get_outlined then
			local special_position = Unit.world_position(enemy_unit, 1)
			local from_player = special_position - player_position
			local distance_squared = Vector3.length_squared(from_player)
			local is_special = breed_tags.special
			local distance_limit = DISTANCE_LIMIT_SQUARED
			local distance_score = distance_squared / distance_limit
			local distance_score_low_enough = is_special or distance_score < 1

			if distance_score_low_enough then
				alive_specials[#alive_specials + 1] = enemy_unit
				sort_value[enemy_unit] = distance_score
			end
		end
	end

	table.sort(alive_specials, function (unit_1, unit_2)
		local angle_1 = sort_value[unit_1]
		local angle_2 = sort_value[unit_2]

		return angle_1 < angle_2
	end)

	template_data.alive_specials = alive_specials
	template_data.time_in_buff = 0
end

function _update_outlines(template_data, template_context, dt, t)
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

		for ii = 1, number_of_active_specials do
			local special_unit = alive_specials[ii]

			if not outlined_units[special_unit] and time_in_buff > ii * activation_time then
				outline_system:add_outline(special_unit, OUTLINE_NAME)

				outlined_units[special_unit] = true
				local except_sender = true

				fx_extension:trigger_gear_wwise_event(HIGHLIGHT_SOUND_ALIAS, except_sender)
			end
		end
	end
end

function _end_outlines(template_data, template_context)
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

templates.veteran_combat_ability_melee_and_ranged_damage_to_coherency = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_combat_ability] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		local buff_template = "veteran_combat_ability_increased_melee_and_ranged_damage"
		local units_in_coherency = template_data.coherency_extension:in_coherence_units()

		for unit, _ in pairs(units_in_coherency) do
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff(buff_template, t)
			end
		end
	end
}
templates.veteran_combat_ability_increased_melee_and_ranged_damage = {
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_combat_ability_melee_and_ranged_damage_to_coherency",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	class_name = "buff",
	buff_category = buff_categories.generic,
	duration = talent_settings_2.combat_ability.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = 0.1,
		[stat_buffs.ranged_damage] = 0.1
	}
}
templates.veteran_increased_explosion_radius = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.explosion_radius_modifier] = 0.225
	}
}
templates.veteran_bonus_crit_chance_on_ammo = {
	predicted = false,
	ammunition_percentage = 0.9,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_bonus_crit_chance_on_ammo",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = 0.1
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
		local current_animation_clip = slot_component.current_ammunition_clip
		local max_ammunition_clip = slot_component.max_ammunition_clip
		local current_animation_percentage = current_animation_clip / max_ammunition_clip
		local ammunition_percentage = template_context.template.ammunition_percentage

		return ammunition_percentage <= current_animation_percentage
	end
}
templates.veteran_no_ammo_consumption_on_lasweapon_crit = {
	class_name = "buff",
	conditional_keywords = {
		keywords.no_ammo_consumption_on_crits
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	end,
	conditional_stat_buffs_func = function (template_data, template_context, t)
		local inventory_component = template_data.inventory_component
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot ~= "slot_secondary" then
			return false
		end

		local weapon_template_or_nil = PlayerUnitVisualLoadout.wielded_weapon_template(template_data.visual_loadout_extension, inventory_component)

		if not weapon_template_or_nil then
			return false
		end

		local weapon_keywords = weapon_template_or_nil.keywords

		if not table.array_contains(weapon_keywords, "lasweapon") then
			return false
		end

		return true
	end
}
templates.veteran_movement_speed_on_toughness_broken = {
	predicted = true,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[proc_events.on_player_hit_received] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = 0.12
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_result == "toughness_broken"
	end
}
templates.veteran_movement_bonuses_on_toughness_broken = {
	cooldown_duration = 30,
	predicted = true,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_movement_speed_on_toughness_broken",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	active_duration = 6,
	proc_events = {
		[proc_events.on_player_hit_received] = 1
	},
	proc_keywords = {
		keywords.stun_immune,
		keywords.slowdown_immune
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_result == "toughness_broken"
	end,
	proc_func = function (params, template_data, template_context)
		Stamina.add_stamina_percent(template_context.unit, 0.5)
	end
}
local in_melee_range = DamageSettings.in_melee_range
local check_interval_time = 0.1
templates.veteran_ranged_power_out_of_melee = {
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_ranged_power_out_of_melee",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	always_show_in_hud = true,
	conditional_stat_buffs = {
		[stat_buffs.ranged_damage] = 0.15
	},
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
		local next_check_time = template_data.next_check_time

		if not next_check_time then
			template_data.next_check_time = t + check_interval_time

			return
		end

		if next_check_time < t then
			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local broadphase_results = template_data.broadphase_results

			table.clear(broadphase_results)

			local num_hits = broadphase:query(player_position, in_melee_range, broadphase_results, enemy_side_names)

			if num_hits == 0 then
				template_data.next_check_time = t + check_interval_time
				template_data.is_active = true
			else
				template_data.is_active = false
			end
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end
}
templates.veteran_increase_suppression = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.suppression_dealt] = 0.5
	}
}
templates.veteran_increase_crit_chance = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.1
	}
}
templates.veteran_increase_elite_damage = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_vs_elites] = 0.15
	}
}
templates.veteran_damage_after_sprinting = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.sprinting = false
		template_data.next_buff_t = 0
	end,
	update_func = function (template_data, template_context, dt, t)
		local sprint_character_state_component = template_data.sprint_character_state_component
		local is_sprinting = Sprint.is_sprinting(sprint_character_state_component)

		if is_sprinting then
			if not template_data.sprinting then
				template_data.sprinting = true
				template_data.next_buff_t = t + 1
			elseif template_data.next_buff_t <= t then
				template_data.buff_extension:add_internally_controlled_buff("veteran_damage_after_sprinting_buff", t)

				template_data.next_buff_t = template_data.next_buff_t + 1
			end
		else
			template_data.sprinting = false
		end
	end
}
templates.veteran_damage_after_sprinting_buff = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_increase_damage_after_sprinting",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 5,
	duration = 5,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage] = 0.05
	}
}
templates.veteran_big_game_hunter = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_vs_ogryn_and_monsters] = 0.2
	}
}
templates.veteran_coherency_aura_size_increase = {
	predicted = false,
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[stat_buffs.coherency_radius_modifier] = 0.5
	}
}
templates.veteran_damage_coherency = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "veteran_damage_coherency",
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage] = 0.05
	}
}
templates.veteran_movement_speed_coherency = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "veteran_movement_speed_coherency",
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.movement_speed] = 0.05
	}
}
templates.veteran_extra_grenade_throw_chance = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.extra_grenade_throw_chance] = 0.2
	}
}
templates.veteran_reduce_sprinting_cost = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.sprinting_cost_multiplier] = 0.8
	}
}
templates.veteran_melee_kills_grant_range_damage = {
	predicted = false,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_kill_grants_damage_to_other_slot",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	proc_stat_buffs = {
		[stat_buffs.ranged_damage] = 0.25
	}
}
templates.veteran_ranged_kills_grant_melee_damage = {
	predicted = false,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_kill_grants_damage_to_other_slot",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_stat_buffs = {
		[stat_buffs.melee_damage] = 0.25
	}
}
templates.veteran_hits_cause_bleed = {
	num_stacks_on_hit = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_non_kill, CheckProcFunctions.on_melee_hit),
	proc_func = function (params, template_data, template_context, t)
		local hit_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

		if HEALTH_ALIVE[hit_unit] and buff_extension then
			local unit = template_context.unit
			local num_stacks = template_context.template.num_stacks_on_hit

			buff_extension:add_internally_controlled_buff_with_stacks("bleed", num_stacks, t, "owner_unit", unit)
		end
	end
}
templates.veteran_increased_melee_crit_chance_and_melee_finesse = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = 0.1,
		[stat_buffs.melee_finesse_modifier_bonus] = 0.25
	}
}
templates.veteran_plasma_proficiency = {
	predicted = false,
	class_name = "buff",
	keywords = {
		keywords.plasma_proficiency
	}
}
templates.veteran_rending_bonus = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.rending_multiplier] = 0.1
	}
}
templates.veteran_bolter_proficiency = {
	predicted = true,
	class_name = "buff",
	keywords = {
		keywords.bolter_proficiency
	},
	conditional_stat_buffs = {
		[stat_buffs.spread_modifier] = -0.25,
		[stat_buffs.recoil_modifier] = -0.25,
		[stat_buffs.sway_modifier] = 0.5
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	end,
	conditional_stat_buffs_func = function (template_data, template_context, t)
		local visual_loadout_extension = template_data.visual_loadout_extension
		local has_bolter_keyword = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(visual_loadout_extension, "slot_secondary", "bolter")

		return has_bolter_keyword
	end
}
templates.veteran_ammo_increase = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.ammo_reserve_capacity] = 0.25
	}
}
templates.veteran_power_proficiency = {
	predicted = false,
	class_name = "buff",
	keywords = {
		keywords.power_weapon_proficiency
	},
	stat_buffs = {
		[stat_buffs.weapon_special_max_activations] = 1
	}
}
templates.veteran_attack_speed = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = 0.1
	}
}
templates.veteran_damage_bonus_leaving_invisibility = {
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_damage_bonus_leaving_invisibility",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	duration = 5,
	class_name = "veteran_stealth_bonuses_buff",
	stat_buffs = {
		[stat_buffs.damage] = 0.3
	}
}
templates.veteran_toughness_bonus_leaving_invisibility = {
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_toughness_damage_reduction_during_ability",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	duration = 10,
	class_name = "veteran_stealth_bonuses_buff",
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = 0.5
	}
}
local ALLOWED_INVISIBILITY_DAMAGE_TYPES = {
	[damage_types.bleeding] = true,
	[damage_types.burning] = true,
	[damage_types.grenade_frag] = true,
	[damage_types.plasma] = true
}
local INVISIBILITY_BROADPHASE_RESULTS = {}
templates.veteran_invisibility = {
	unique_buff_id = "veteran_invisibility",
	predicted = true,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_ability_undercover",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	duration = 8,
	class_name = "proc_buff",
	stagger_range = in_melee_range + 1,
	keywords = {
		keywords.invisible
	},
	stat_buffs = {
		[stat_buffs.movement_speed] = 0.25
	},
	proc_events = {
		[proc_events.on_shoot] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_action_start] = 1,
		[proc_events.on_revive] = 1,
		[proc_events.on_rescue] = 1,
		[proc_events.on_pull_up] = 1,
		[proc_events.on_remove_net] = 1
	},
	player_effects = {
		wwise_state = {
			group = "player_ability",
			on_state = "zealot_invisible",
			off_state = "none"
		},
		wwise_parameters = {
			player_zealot_invisible_effect = 1
		}
	},
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		if template_data.exit_grace and t < template_data.exit_grace then
			return
		end

		local damage_type = params.damage_type

		if damage_type and ALLOWED_INVISIBILITY_DAMAGE_TYPES[damage_type] then
			return
		end

		local damage = params.damage

		if damage and damage <= 0 then
			return
		end

		local action_name = params.action_name

		if action_name and action_name ~= "action_throw_grenade" then
			return
		end

		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
	start_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		template_data.exit_grace = t + 0.5
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		template_data.broadphase = broadphase
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		template_data.enemy_side_names = enemy_side_names
		local player_unit = template_context.unit
		local buff_extension = template_context.buff_extension
		local specialization_extension = ScriptUnit.has_extension(player_unit, "specialization_system")

		if specialization_extension:has_special_rule(special_rules.veteran_damage_bonus_leaving_invisibility) then
			buff_extension:add_internally_controlled_buff("veteran_damage_bonus_leaving_invisibility", t)
		end

		if specialization_extension:has_special_rule(special_rules.veteran_toughness_bonus_leaving_invisibility) then
			buff_extension:add_internally_controlled_buff("veteran_toughness_bonus_leaving_invisibility", t)
		end

		if specialization_extension:has_special_rule(special_rules.veteran_reduced_threat_after_combat_ability) then
			buff_extension:add_internally_controlled_buff("veteran_reduced_threat_generation", t)
		end

		if specialization_extension:has_special_rule(special_rules.veteran_increased_close_damage_after_combat_ability) then
			buff_extension:add_internally_controlled_buff("veteran_increased_close_damage_after_combat_ability", t)
		end

		if specialization_extension:has_special_rule(special_rules.veteran_increased_weakspot_power_after_combat_ability) then
			buff_extension:add_internally_controlled_buff("veteran_increased_weakspot_power_after_combat_ability", t)
		end
	end,
	stop_func = function (template_data, template_context, destroy)
		if not template_context.is_server then
			return
		end

		if destroy then
			return
		end

		local broadphase = template_data.broadphase
		local broadphase_results = INVISIBILITY_BROADPHASE_RESULTS
		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local enemy_side_names = template_data.enemy_side_names
		local range = template_context.template.stagger_range
		local num_hits = broadphase:query(player_position, range, broadphase_results, enemy_side_names)
		local damage_profile = DamageProfileTemplates.veteran_invisibility_suppression

		for i = 1, num_hits do
			local unit = broadphase_results[i]
			local hit_zone_name = "torso"
			local position = POSITION_LOOKUP[unit]
			local attack_direction = Vector3.normalize(Vector3.flat(position - player_position))
			local _, attack_result, _, stagger_result = Attack.execute(unit, damage_profile, "attack_direction", attack_direction, "power_level", PowerLevelSettings.default_power_level, "hit_zone_name", hit_zone_name, "attacking_unit", player_unit)

			Suppression.apply_suppression(unit, player_unit, damage_profile, player_position)
		end
	end
}
templates.veteran_invisibility_on_combat_ability = {
	force_predicted_proc = true,
	predicted = false,
	class_name = "proc_buff",
	allow_proc_while_active = true,
	proc_events = {
		[proc_events.on_combat_ability] = 1
	},
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("veteran_invisibility", t)
	end
}
templates.veteran_extra_grenade = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_grenades] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local template = template_context.template
		local buff_stat_buffs = template.stat_buffs.extra_max_amount_of_grenades
		local extra_grenades = buff_stat_buffs
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")
		template_context.initial_num_charges = grenade_ability_component.num_charges
		grenade_ability_component.num_charges = grenade_ability_component.num_charges + extra_grenades
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")
		local initial_num_charges = template_context.initial_num_charges
		grenade_ability_component.num_charges = math.min(grenade_ability_component.num_charges, initial_num_charges)
	end
}
templates.veteran_improved_grenades = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.frag_damage] = 0.25,
		[stat_buffs.explosion_radius_modifier_frag] = 0.25,
		[stat_buffs.krak_damage] = 0.5,
		[stat_buffs.smoke_fog_duration_modifier] = 1
	}
}
templates.veteran_reload_speed_on_elite_kill = {
	predicted = false,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.buff_extension:add_internally_controlled_buff("veteran_reload_speed_on_elite_kill_effect", t)
	end
}
templates.veteran_reload_speed_on_elite_kill_effect = {
	predicted = false,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_reload_speed_on_elite_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	class_name = "proc_buff",
	always_show_in_hud = true,
	proc_events = {
		[proc_events.on_reload] = 1
	},
	stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings_2.offensive_2_3.reload_speed
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
	end
}
templates.veteran_increase_ranged_far_damage = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_far] = talent_settings_2.offensive_1_1.damage_far
	}
}
templates.veteran_toughness_on_elite_kill = {
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	proc_func = function (params, template_data, template_context, t)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		buff_extension:add_internally_controlled_buff("veteran_toughness_on_elite_kill_effect", t)
		Toughness.replenish_percentage(template_context.unit, talent_settings_2.toughness_1.instant_toughness, false, "talent_toughness_1")
	end
}
templates.veteran_toughness_on_elite_kill_effect = {
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_elite_kills_replenish_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	hud_priority = 3,
	class_name = "buff",
	duration = talent_settings_2.toughness_1.duration,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		Toughness.replenish_percentage(template_context.unit, talent_settings_2.toughness_1.toughness * dt, false, "talent_toughness_1")

		template_data.next_regen_t = nil
	end
}
templates.veteran_ads_stamina_boost = {
	predicted = true,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_ads_drain_stamina",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_shoot] = 1
	},
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_2.offensive_2_2.critical_strike_chance,
		[stat_buffs.spread_modifier] = talent_settings_2.offensive_2_2.spread_modifier,
		[stat_buffs.recoil_modifier] = talent_settings_2.offensive_2_2.recoil_modifier,
		[stat_buffs.sway_modifier] = talent_settings_2.offensive_2_2.sway_modifier
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.alternate_fire_component = unit_data_extension:read_component("alternate_fire")
		template_data.stamina_component = unit_data_extension:read_component("stamina")
		template_data.sway_component = unit_data_extension:write_component("sway_control")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
		template_data.stamina_per_second = talent_settings_2.offensive_2_2.stamina_per_second
		template_data.shot_stamina = talent_settings_2.offensive_2_2.shot_stamina
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	update_func = function (template_data, template_context, dt, t)
		local is_active, is_alternate_fire_active = _is_in_weapon_alternate_fire_with_stamina(template_data, template_context)
		template_data.is_active = is_active

		if not is_alternate_fire_active then
			template_data.applied_end_sway = nil

			return
		end

		local cost_per_second = template_data.stamina_per_second
		local remaining_stamina = Stamina.drain(template_context.unit, cost_per_second * dt, t)

		if remaining_stamina == 0 and not template_data.applied_end_sway then
			template_data.applied_end_sway = true

			Sway.add_fixed_immediate_sway(template_data.sway_component, 1, 1)
		end

		template_data.remaining_stamina = remaining_stamina
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_data.alternate_fire_component.is_active then
			return
		end

		local shoot_cost = template_data.shot_stamina

		Stamina.drain(template_context.unit, shoot_cost, t)
	end,
	check_active_func = function (template_data, template_context)
		local is_alternate_fire_active = template_data.alternate_fire_component.is_active

		return is_alternate_fire_active
	end,
	duration_func = function (template_data, template_context)
		local stamina_component = template_data.stamina_component

		if stamina_component then
			return stamina_component.current_fraction
		end

		return 0.01
	end
}
templates.veteran_aura_gain_ammo_on_elite_kill = {
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_minion_death] = 1
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_minion_death,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if unit ~= params.attacking_unit then
			return
		end

		local units_in_coherence = template_data.coherency_extension:in_coherence_units()

		for coherency_unit, _ in pairs(units_in_coherence) do
			local ammo_percent = talent_settings_2.coherency.ammo_replenishment_percent
			local ammo_gained = Ammo.add_to_all_slots(coherency_unit, ammo_percent)
			local unit_data_extension = ScriptUnit.has_extension(coherency_unit, "unit_data_system")

			if unit_data_extension then
				local player = Managers.state.player_unit_spawn:owner(unit)

				if player then
					Managers.stats:record_private("hook_veteran_ammo_given", player, ammo_gained)
				end
			end
		end
	end
}
templates.veteran_aura_gain_ammo_on_elite_kill_improved = {
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_minion_death] = 1
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_minion_death,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if unit ~= params.attacking_unit then
			return
		end

		local units_in_coherence = template_data.coherency_extension:in_coherence_units()

		for coherency_unit, _ in pairs(units_in_coherence) do
			local ammo_percent = talent_settings_2.coherency.ammo_replenishment_percent_improved
			local ammo_gained = Ammo.add_to_all_slots(coherency_unit, ammo_percent)
			local unit_data_extension = ScriptUnit.has_extension(coherency_unit, "unit_data_system")

			if unit_data_extension then
				local player = Managers.state.player_unit_spawn:owner(unit)

				if player then
					Managers.stats:record_private("hook_veteran_ammo_given", player, ammo_gained)
				end
			end
		end
	end
}
templates.veteran_replenish_toughness_of_ally_close_to_victim = {
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
		local victim_pos = victim_unit and POSITION_LOOKUP[victim_unit] or params.hit_world_position:unbox()

		if not victim_pos then
			return
		end

		local player_units = template_data.side.valid_player_units
		local local_unit = template_context.unit
		local chosen_ally_unit = nil
		local range = talent_settings_2.coop_3.range

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
			Toughness.replenish_percentage(chosen_ally_unit, talent_settings_2.coop_3.toughness_percent, false, "ranger_coop_talent")

			local buff_extension = ScriptUnit.has_extension(chosen_ally_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				buff_extension:add_internally_controlled_buff("veteran_replenish_toughness_of_ally_close_to_victim_damage_buff", t)
			end
		end
	end
}
templates.veteran_replenish_toughness_of_ally_close_to_victim_damage_buff = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_replenish_toughness_and_boost_allies",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	class_name = "buff",
	buff_category = buff_categories.generic,
	duration = talent_settings_2.coop_3.duration,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings_2.coop_3.damage
	}
}
local range = talent_settings_2.toughness_3.range
templates.veteran_toughness_regen_out_of_melee = {
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_replenish_toughness_outside_melee",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	always_show_in_hud = true,
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
		local next_regen_t = template_data.next_regen_t

		if not next_regen_t then
			template_data.next_regen_t = t + talent_settings_2.toughness_3.time

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
				if template_context.is_server then
					Toughness.replenish_percentage(template_context.unit, talent_settings_2.toughness_3.toughness, false, "talent_toughness_3")
				end

				template_data.next_regen_t = t + talent_settings_2.toughness_3.time
				template_data.is_active = true
			else
				template_data.is_active = false
			end
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end
}
templates.veteran_ranged_weakspot_toughness_recovery = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_weakspot_kills,
	proc_func = function (params, template_data, template_context)
		Toughness.replenish_percentage(template_context.unit, talent_settings_2.toughness_2.toughness, false, "talent_toughness_2")

		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.has_extension(template_context.unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff("veteran_ranged_weakspot_toughenss_buff", t)
		end
	end
}
templates.veteran_ranged_weakspot_toughenss_buff = {
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_replenish_toughness_on_weakspot_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	duration = talent_settings_2.toughness_2.duration,
	max_stacks = talent_settings_2.toughness_2.max_stacks,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_2.toughness_2.toughness_damage_taken_multiplier
	}
}
templates.veteran_reload_speed_on_non_empty_clip = {
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_faster_reload_on_non_empty_clips",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings_2.offensive_1_2.reload_speed
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		template_data.inventory_component = inventory_component
	end,
	update_func = function (template_data, template_context)
		local unit = template_context.unit
		local inventory_component = template_data.inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local ammo_percentage = Ammo.current_slot_clip_percentage(unit, wielded_slot)
		local is_reloading = ConditionalFunctions.is_reloading(template_data, template_context)
		local active = ammo_percentage > 0

		if not is_reloading then
			template_data.is_active = active
		end
	end,
	check_active_func = ConditionalFunctions.is_reloading
}
templates.veteran_frag_grenade_bleed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_non_kill, CheckProcFunctions.on_explosion_hit),
	proc_func = function (params, template_data, template_context, t)
		local damage_type = params.damage_type

		if not damage_type or damage_type ~= damage_types.grenade_frag then
			return
		end

		local hit_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

		if HEALTH_ALIVE[hit_unit] and buff_extension then
			local unit = template_context.unit
			local num_stacks = talent_settings_2.offensive_2_1.stacks

			buff_extension:add_internally_controlled_buff_with_stacks("bleed", num_stacks, t, "owner_unit", unit)
		end
	end
}
local grenade_replenishment_cooldown = talent_settings_2.offensive_1_3.grenade_replenishment_cooldown
local ABILITY_TYPE = "grenade_ability"
local grenades_restored = talent_settings_2.offensive_1_3.grenade_restored
local external_properties = {}
templates.veteran_grenade_replenishment = {
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_replenish_grenades",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_blitz",
	class_name = "buff",
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		template_data.missing_charges = 0
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
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges(ABILITY_TYPE)

		if missing_charges == 0 then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		template_data.missing_charges = missing_charges
		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			template_data.next_grenade_t = t + grenade_replenishment_cooldown

			return
		end

		if next_grenade_t < t then
			if ability_extension and ability_extension:has_ability_type(ABILITY_TYPE) then
				ability_extension:restore_ability_charge(ABILITY_TYPE, grenades_restored)

				local first_person_extension = template_data.first_person_extension

				if first_person_extension and first_person_extension:is_in_first_person_mode() then
					external_properties.indicator_type = "human_grenade"

					template_data.fx_extension:trigger_gear_wwise_event("grenade_recover_indicator", external_properties)
				end
			end

			template_data.next_grenade_t = nil
		end
	end,
	check_active_func = function (template_data, template_context)
		local is_missing_charges = template_data.missing_charges > 0

		return is_missing_charges
	end,
	duration_func = function (template_data, template_context)
		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			return 1
		end

		local t = FixedFrame.get_latest_fixed_time()
		local time_until_next = next_grenade_t - t
		local percentage_left = time_until_next / grenade_replenishment_cooldown

		return 1 - percentage_left
	end
}
templates.veteran_stamina_on_ranged_dodges = {
	cooldown_duration = 3,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_ranged_dodge] = 1
	},
	proc_func = function (params, template_data, template_context)
		Stamina.add_stamina_percent(template_context.unit, talent_settings_2.defensive_2.stamina_percent)
	end
}
local STANDING_STILL_EPSILON = 0.001
templates.veteran_reduced_threat_gain = {
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_reduced_threat_when_still",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	always_show_in_hud = true,
	conditional_stat_buffs = {
		[stat_buffs.threat_weight_multiplier] = talent_settings_2.defensive_3.threat_weight_multiplier
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
templates.veteran_buffs_after_combat_ability = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_combat_ability] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.specialization_extension = ScriptUnit.extension(unit, "specialization_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		local specialization_extension = template_data.specialization_extension

		if specialization_extension:has_special_rule(special_rules.veteran_combat_ability_stealth) then
			return false
		end

		local buff_extension = template_context.buff_extension
		local reduced_threat = specialization_extension:has_special_rule(special_rules.veteran_reduced_threat_after_combat_ability)

		if reduced_threat then
			buff_extension:add_internally_controlled_buff("veteran_reduced_threat_generation", t)
		end

		local close_damage = specialization_extension:has_special_rule(special_rules.veteran_increased_close_damage_after_combat_ability)

		if close_damage then
			buff_extension:add_internally_controlled_buff("veteran_increased_close_damage_after_combat_ability", t)
		end

		local weakspot_power = specialization_extension:has_special_rule(special_rules.veteran_increased_weakspot_power_after_combat_ability)

		if weakspot_power then
			buff_extension:add_internally_controlled_buff("veteran_increased_weakspot_power_after_combat_ability", t)
		end
	end
}
templates.veteran_reduced_threat_generation = {
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_reduced_threat_when_still",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	duration = 10,
	class_name = "veteran_stealth_bonuses_buff",
	stat_buffs = {
		[stat_buffs.threat_weight_multiplier] = talent_settings_2.defensive_3.threat_weight_multiplier
	}
}
templates.veteran_increased_close_damage_after_combat_ability = {
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_increased_close_damage_after_combat_ability",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	duration = 10,
	class_name = "veteran_stealth_bonuses_buff",
	stat_buffs = {
		[stat_buffs.damage_near] = 0.15
	}
}
templates.veteran_increased_weakspot_power_after_combat_ability = {
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_increased_close_damage_after_combat_ability",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	duration = 10,
	class_name = "veteran_stealth_bonuses_buff",
	stat_buffs = {
		[stat_buffs.weakspot_power_level_modifier] = 0.2
	}
}
templates.veteran_aura_gain_grenade_on_elite_kill = {
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_minion_death] = talent_settings_2.coop_2.proc_chance
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_minion_death,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local attacking_unit = params.attacking_unit
		local units_in_coherence = template_data.coherency_extension:in_coherence_units()
		local attacking_unit_is_in_coherency = false

		for coherency_unit, _ in pairs(units_in_coherence) do
			if coherency_unit == attacking_unit then
				attacking_unit_is_in_coherency = true

				break
			end
		end

		if not attacking_unit_is_in_coherency then
			return
		end

		local unit = template_context.unit
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if fx_extension then
			local position = POSITION_LOOKUP[unit]

			fx_extension:trigger_exclusive_wwise_event("wwise/events/player/play_pick_up_ammo_01", position)
		end

		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		if ability_extension and ability_extension:has_ability_type(ABILITY_TYPE) then
			ability_extension:restore_ability_charge(ABILITY_TYPE, grenades_restored)
		end
	end
}
templates.veteran_increased_weakspot_damage = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.weakspot_damage] = talent_settings_2.passive_1.weakspot_damage
	}
}
templates.veteran_combat_ability_cooldown_reduction_on_elite_kills = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = talent_settings_3.passive_1.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctions.on_special_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.ability_extension = ability_extension
		template_data.cooldown_reduction = talent_settings_3.passive_1.cooldown_reduction
		template_data.talent_cooldown_reduction = talent_settings_3.passive_1.talent_cooldown_reduction
	end,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		local special_rule = special_rules.veteran_squad_leader_increased_cooldown_restore_on_elite_kills
		local small_reduction = template_data.cooldown_reduction
		local large_reduction = template_data.talent_cooldown_reduction
		local cooldown_reduction = specialization_extension:has_special_rule(special_rule) and large_reduction or small_reduction

		template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown_reduction)
	end
}
templates.veteran_suppression_immunity = {
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_supression_immunity",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	hud_priority = 1,
	class_name = "buff",
	keywords = {
		keywords.suppression_immune
	}
}
templates.veteran_all_kills_replenish_bonus_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_kill,
	proc_func = function (params, template_data, template_context)
		local toughness_percentage = template_context.template_override_data.toughness_percentage

		Toughness.replenish_percentage(template_context.unit, toughness_percentage, false, "talent_toughness_3")
	end,
	specialization_overrides = {
		{
			toughness_percentage = talent_settings_3.toughness_3.toughness
		},
		{
			toughness_percentage = talent_settings_3.toughness_3.toughness * 2
		}
	}
}
templates.veteran_toughness_damage_reduction_per_ally_in_coherency = {
	predicted = false,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = {
			min = talent_settings_3.toughness_1.min,
			max = talent_settings_3.toughness_1.max
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.coherency_extension = coherency_extension
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local num_units = template_data.coherency_extension:num_units_in_coherency() - 1
		local max_units = 3
		local fraction = math.clamp(num_units / max_units, 0, 1)

		return fraction
	end
}
templates.veteran_allies_kills_chance_to_trigger_increased_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_minion_death] = talent_settings_3.offensive_3.on_minion_death_proc_chance
	},
	check_proc_func = function (params, template_data, template_context)
		local current_unit = template_context.unit
		local attacking_unit = params.attacking_unit
		local is_killed_by_this_unit = current_unit == attacking_unit

		return not is_killed_by_this_unit
	end,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("veteran_allies_kills_damage_buff", t)
	end
}
templates.veteran_allies_kills_damage_buff = {
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_ally_kills_increase_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	class_name = "buff",
	duration = talent_settings_3.offensive_3.active_duration,
	stat_buffs = {
		[stat_buffs.suppression_dealt] = talent_settings_3.offensive_3.suppression_dealt,
		[stat_buffs.damage] = talent_settings_3.offensive_3.damage,
		[stat_buffs.melee_impact_modifier] = talent_settings_3.offensive_3.melee_impact_modifier
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_veteran_killshot"
	}
}

function _is_in_weapon_alternate_fire_with_stamina(template_data, template_context)
	local wielded_slot = template_data.inventory_component.wielded_slot

	if wielded_slot == "none" then
		return false, false
	end

	local wielded_slot_configuration = slot_configuration[wielded_slot]
	local slot_type = wielded_slot_configuration and wielded_slot_configuration.slot_type
	local is_weapon = slot_type == "weapon"

	if not is_weapon then
		return false, false
	end

	local is_alternate_fire_active = template_data.alternate_fire_component.is_active

	if not is_alternate_fire_active then
		return false, false
	end

	local has_stamina = template_data.stamina_component.current_fraction > 0

	if not has_stamina then
		return false, is_alternate_fire_active
	end

	return true, is_alternate_fire_active
end

templates.veteran_combat_ability_increase_toughness_to_coherency = {
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_combat_ability_increase_and_restore_toughness_to_coherency",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	duration = 15,
	class_name = "buff",
	buff_category = buff_categories.generic,
	stat_buffs = {
		[stat_buffs.toughness_bonus_flat] = 50
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end
	end
}
templates.veteran_share_toughness_gained = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_toughness_replenished] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.coherency_extension = coherency_extension
	end,
	proc_func = function (params, template_data, template_context)
		local reason = params.reason

		if reason == "squad_leader_share_toughness" then
			return
		end

		local amount = params.amount
		local percent = talent_settings_3.coop_3.percent
		local toughness_to_restore = amount * percent
		local units_in_coherency = template_data.coherency_extension:in_coherence_units()

		for unit, _ in pairs(units_in_coherency) do
			if unit ~= template_context.unit then
				Toughness.replenish_flat(unit, toughness_to_restore, false, "squad_leader_share_toughness")
			end
		end
	end
}
templates.veteran_better_deployables = {
	predicted = false,
	class_name = "buff",
	keywords = {
		keywords.improved_medical_crate,
		keywords.improved_ammo_pickups
	}
}
local dot_threshold = 0.5
local assist_interaction_types = {
	rescue = true,
	pull_up = true,
	revive = true,
	remove_net = true
}
templates.veteran_increased_move_speed_when_moving_towards_disabled_allies = {
	class_name = "proc_buff",
	always_active = true,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_movement_speed_towards_downed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	proc_events = {
		[proc_events.on_revive] = 1
	},
	stat_buffs = {
		[stat_buffs.revive_speed_modifier] = 0.2
	},
	conditional_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings_3.defensive_1.movement_speed
	},
	conditional_keywords = {
		keywords.stun_immune
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.first_person_component = unit_data_extension:read_component("first_person")
		local interactor_extension = ScriptUnit.extension(template_context.unit, "interactor_system")
		template_data.interactor_extension = interactor_extension
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local local_player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[local_player_unit]
		local player_units = side.valid_player_units
		local knocked_allies = false

		for _, unit in pairs(player_units) do
			if ALIVE[unit] and unit ~= local_player_unit then
				local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
				local character_state_component = unit_data_extension:read_component("character_state")
				local requires_help = PlayerUnitStatus.requires_help(character_state_component)

				if requires_help then
					local position = POSITION_LOOKUP[local_player_unit]
					local rotation = template_data.first_person_component.rotation
					local look_direction = Quaternion.forward(rotation)
					local ally_position = POSITION_LOOKUP[unit]
					local ally_direction = Vector3.normalize(ally_position - position)
					local dot = Vector3.dot(look_direction, ally_direction)

					if dot_threshold < dot then
						knocked_allies = true

						break
					end
				end
			end
		end

		template_data.is_active = knocked_allies

		return knocked_allies
	end,
	proc_func = function (params, template_data, template_context, t)
		local reviver_unit = params.unit

		if reviver_unit ~= template_context.unit then
			return
		end

		local target_unit = params.target_unit
		local target_unit_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

		if target_unit_buff_extension then
			target_unit_buff_extension:add_internally_controlled_buff("veteran_reduced_damage_taken", t)
		end
	end,
	check_active_func = function (template_data, template_context)
		local interactor_extension = template_data.interactor_extension
		local is_interacting = interactor_extension:is_interacting()

		if is_interacting then
			local interaction = interactor_extension:interaction()
			local interaction_type = interaction:type()
			local is_assisting = assist_interaction_types[interaction_type]

			if is_assisting then
				return true
			end
		end

		return template_data.is_active
	end
}
templates.veteran_reduced_damage_taken = {
	class_name = "buff",
	predicted = false,
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_movement_speed_towards_downed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	buff_category = buff_categories.generic,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings_3.defensive_1.damage_taken_multiplier
	},
	duration = talent_settings_3.defensive_1.duration
}
templates.veteran_combat_ability_revive_nearby_allies = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.combat_ability_cooldown_modifier] = 0.5,
		[stat_buffs.shout_radius_modifier] = -0.33
	}
}
templates.veteran_consecutive_hits_apply_rending = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_shoot] = 1,
		[proc_events.on_sweep_start] = 1
	},
	start_func = function (template_data, template_context)
		template_data.new_shot = true
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context)
			if not template_data.new_shot then
				return
			end

			local attacked_unit = params.attacked_unit

			if not HEALTH_ALIVE[attacked_unit] then
				return
			end

			if attacked_unit == template_data.current_unit then
				local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

				if buff_extension then
					local t = FixedFrame.get_latest_fixed_time()

					buff_extension:add_internally_controlled_buff("rending_debuff", t)
				end
			else
				template_data.current_unit = attacked_unit
			end

			template_data.new_shot = false
		end,
		on_shoot = function (params, template_data, template_context)
			template_data.new_shot = true
		end,
		on_sweep_start = function (params, template_data, template_context)
			template_data.new_shot = true
		end
	}
}
templates.veteran_crits_apply_rending = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_melee_crit_hit,
	proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit

		if not HEALTH_ALIVE[attacked_unit] then
			return
		end

		local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("rending_debuff_medium", t)
		end
	end
}
templates.veteran_dodging_grants_crit = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_successful_dodge] = 1
	},
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("veteran_dodging_crit_buff", t)
	end
}
templates.veteran_dodging_crit_buff = {
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_dodging_grants_crit",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 5,
	duration = 8,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05
	}
}
templates.veteran_improved_toughness_stamina = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_block] = 1,
		[proc_events.on_player_toughness_broken] = 1
	},
	specific_proc_func = {
		on_block = function (params, template_data, template_context, t)
			if not params.block_broken then
				return
			end

			local unit = template_context.unit
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				local buff_name = "veteran_improved_toughness_buff"

				buff_extension:add_internally_controlled_buff(buff_name, t)
			end
		end,
		on_player_toughness_broken = function (params, template_data, template_context, t)
			local unit = template_context.unit

			if params.unit ~= unit then
				return
			end

			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				local buff_name = "veteran_improved_stamina_buff"

				buff_extension:add_internally_controlled_buff(buff_name, t)
			end
		end
	}
}
templates.veteran_improved_toughness_buff = {
	max_stacks = 1,
	refresh_duration_on_stack = true,
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	hud_priority = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_3.defensive_3.toughness_damage_taken_multiplier or 0.5
	},
	duration = talent_settings_3.defensive_3.toughness_duration or 5
}
templates.veteran_improved_stamina_buff = {
	max_stacks = 1,
	refresh_duration_on_stack = true,
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	hud_priority = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.block_cost_multiplier] = talent_settings_3.defensive_3.block_cost_multiplier or 0.5
	},
	duration = talent_settings_3.defensive_3.stamina_duration or 5
}
templates.veteran_tdr_on_high_toughness = {
	predicted = false,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_block_break_gives_tdr",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	class_name = "buff",
	always_show_in_hud = true,
	conditional_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = 0.5
	},
	start_func = function (template_data, template_context)
		local toughness_extension = ScriptUnit.has_extension(template_context.unit, "toughness_system")
		template_data.toughness_extension = toughness_extension
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local current_toughness = template_data.toughness_extension:current_toughness_percent()

		return current_toughness > 0.75
	end
}
local snipers_focus_max_stacks = 10
local snipers_focus_max_stacks_talent = 15

local function _snipers_focus_handle_stacks(template_data, template_context, previous_stacks, t)
	if previous_stacks < snipers_focus_max_stacks and snipers_focus_max_stacks <= template_data.stacks then
		if template_data.threat_bonus then
			template_context.buff_extension:add_internally_controlled_buff("veteran_snipers_focus_threat_buff", t)

			template_data.threat_buff_active = true
		end

		local rending_bonus = template_data.specialization_extension:has_special_rule("veteran_snipers_focus_rending_bonus")

		if rending_bonus then
			template_context.buff_extension:add_internally_controlled_buff("veteran_snipers_focus_rending_buff", t)

			template_data.rending_buff_active = true
		end

		template_context.buff_extension:add_internally_controlled_buff("veteran_snipers_focus_effect", t)
	elseif snipers_focus_max_stacks <= previous_stacks and template_data.stacks < snipers_focus_max_stacks then
		if template_data.threat_buff_active then
			template_context.buff_extension:remove_internally_controlled_buff_stack("veteran_snipers_focus_threat_buff")

			template_data.threat_buff_active = nil
		end

		if template_data.rending_buff_active then
			template_context.buff_extension:remove_internally_controlled_buff_stack("veteran_snipers_focus_rending_buff")

			template_data.rending_buff_active = nil
		end
	end
end

local snipers_focus_stacks_per_weakspot_kill = 3
local sf_sprint_interval = 0.5
local sf_move_interval = 1
local sf_still_interval = 0.75
templates.veteran_snipers_focus = {
	always_active = true,
	predicted = false,
	hud_priority = 1,
	use_specialization_resource = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_snipers_focus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	class_name = "proc_buff",
	always_show_in_hud = true,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_slide_start] = 1,
		[proc_events.on_slide_end] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		template_data.specialization_extension = specialization_extension
		template_data.locomotion_component = unit_data_extension:read_component("locomotion")
		template_data.sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
		template_data.movement_state_component = unit_data_extension:read_component("movement_state")
		template_data.specialization_resource_component = unit_data_extension:write_component("specialization_resource")
		template_data.specialization_resource_component.current_resource = 0
		template_data.stacks = 0
		template_data.next_t = 0
		template_data.safe_t = 0
		template_data.threat_bonus = specialization_extension:has_special_rule("veteran_snipers_focus_threat_bonus")
		template_data.toughness_bonus = specialization_extension:has_special_rule("veteran_snipers_focus_toughness_bonus")
		local increased_stacks_talent = specialization_extension:has_special_rule("veteran_snipers_focus_increased_stacks")
		template_data.max_stacks = increased_stacks_talent and snipers_focus_max_stacks_talent or snipers_focus_max_stacks
		template_data.stat_buff = "veteran_snipers_focus_stat_buff"
		template_data.toughness_buff = "veteran_snipers_focus_toughness_buff"
		local t = FixedFrame.get_latest_fixed_time()
		local _, stat_buff_id = template_context.buff_extension:add_externally_controlled_buff(template_data.stat_buff, t)
		template_data.stat_buff_id = stat_buff_id

		if template_data.toughness_bonus then
			local _, toughness_buff_id = template_context.buff_extension:add_externally_controlled_buff(template_data.toughness_buff, t)
			template_data.toughness_buff_id = toughness_buff_id
		end
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			if not template_context.is_server then
				return
			end

			if not params.hit_weakspot then
				return
			end

			if params.attack_type ~= attack_types.ranged then
				return
			end

			local previous_stacks = template_data.stacks
			local kill = params.attack_result == attack_results.died

			if kill then
				template_data.stacks = math.min(template_data.stacks + snipers_focus_stacks_per_weakspot_kill, template_data.max_stacks)
				template_data.specialization_resource_component.current_resource = template_data.stacks
			end

			_snipers_focus_handle_stacks(template_data, template_context, previous_stacks, t)

			local safe_time = kill and 3 or 1
			template_data.safe_t = math.max(t + safe_time, template_data.safe_t)
		end,
		on_slide_start = function (params, template_data, template_context, t)
			if not template_context.is_server then
				return
			end

			if template_data.safe_t < t then
				template_data.stacks = math.max(0, template_data.stacks - 1)
				template_data.specialization_resource_component.current_resource = template_data.stacks
			end

			template_data.sliding = true
		end,
		on_slide_end = function (params, template_data, template_context, t)
			if not template_context.is_server then
				return
			end

			template_data.sliding = false
		end
	},
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		if t < template_data.next_t then
			return
		end

		local player_velocity = template_data.locomotion_component.velocity_current
		local is_moving = Vector3.length(player_velocity) > 0.1
		local is_sprinting = Sprint.is_sprinting(template_data.sprint_character_state_component)
		local is_crouching = template_data.movement_state_component.is_crouching
		local previous_stacks = template_data.stacks
		local max_stacks = template_data.max_stacks
		local sliding = template_data.sliding
		local stacks_on_still = template_data.specialization_extension:has_special_rule("veteran_snipers_focus_stacks_on_still")

		if not is_crouching and is_moving and template_data.stacks > 0 then
			if template_data.safe_t < t then
				template_data.stacks = math.max(0, template_data.stacks - 1)

				if not is_sprinting then
					template_data.next_t = t + sf_move_interval
				else
					template_data.next_t = t + sf_sprint_interval
				end
			end
		elseif stacks_on_still and (not is_moving or is_crouching and not sliding) then
			template_data.stacks = math.min(template_data.stacks + 1, max_stacks)
			template_data.next_t = t + sf_still_interval
		end

		template_data.specialization_resource_component.current_resource = template_data.stacks

		_snipers_focus_handle_stacks(template_data, template_context, previous_stacks, t)
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_context.buff_extension:remove_externally_controlled_buff(template_data.stat_buff_id)

		if template_data.toughness_bonus then
			template_context.buff_extension:remove_externally_controlled_buff(template_data.toughness_buff_id)
		end

		template_data.specialization_resource_component.current_resource = 0
	end
}
templates.veteran_snipers_focus_effect = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_veteran_snipers_focus"
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.specialization_resource_component = unit_data_extension:read_component("specialization_resource")
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.specialization_resource_component.current_resource < snipers_focus_max_stacks
	end
}
templates.veteran_snipers_focus_stat_buff = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.ranged_finesse_modifier_bonus] = {
			min = 0,
			max = 0.075 * snipers_focus_max_stacks
		},
		[stat_buffs.reload_speed] = {
			min = 0,
			max = 0.01 * snipers_focus_max_stacks
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.specialization_resource_component = unit_data_extension:read_component("specialization_resource")
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return template_data.specialization_resource_component.current_resource / snipers_focus_max_stacks
	end
}
templates.veteran_snipers_focus_toughness_buff = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.toughness_replenish_multiplier] = {
			min = 0,
			max = 0.025 * snipers_focus_max_stacks
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.specialization_resource_component = unit_data_extension:read_component("specialization_resource")
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return template_data.specialization_resource_component.current_resource / snipers_focus_max_stacks
	end
}
templates.veteran_snipers_focus_threat_buff = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.threat_weight_multiplier] = 0.1
	}
}
templates.veteran_snipers_focus_rending_buff = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.rending_multiplier] = 0.1
	}
}
local max_ranged_stacks = 10
local max_melee_stacks = 1
local toughness_cd = 5
templates.veteran_weapon_switch_passive_buff = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1,
		[proc_events.on_wield_ranged] = 1,
		[proc_events.on_wield_melee] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
		template_data.specialization_resource_component = unit_data_extension:write_component("specialization_resource")
		template_data.specialization_resource_component.current_resource = 0
		template_data.ranged_stacks = 0
		template_data.melee_stacks = 0
		template_data.max_ranged_stacks = max_ranged_stacks
		template_data.max_melee_stacks = max_melee_stacks
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		template_data.restore_toughness = specialization_extension:has_special_rule("veteran_weapon_switch_replenish_toughness")
		template_data.last_ranged_toughness = 0
		template_data.last_melee_toughness = 0
	end,
	specific_proc_func = {
		on_kill = function (params, template_data, template_context, t)
			local wielded_slot_name = template_data.inventory_component.wielded_slot

			if wielded_slot_name == "slot_primary" then
				if template_data.ranged_stacks < template_data.max_ranged_stacks then
					template_data.ranged_stacks = template_data.ranged_stacks + 1
					template_data.specialization_resource_component.current_resource = template_data.ranged_stacks

					if not template_data.ranged_id then
						local _, ranged_id = template_context.buff_extension:add_externally_controlled_buff("veteran_weapon_switch_ranged_visual", t)
						template_data.ranged_id = ranged_id
					end
				end
			elseif wielded_slot_name == "slot_secondary" and template_data.melee_stacks < template_data.max_melee_stacks then
				template_data.melee_stacks = template_data.melee_stacks + 1
				template_data.specialization_resource_component.current_resource = template_data.melee_stacks

				if not template_data.melee_id then
					local _, melee_id = template_context.buff_extension:add_externally_controlled_buff("veteran_weapon_switch_melee_visual", t)
					template_data.melee_id = melee_id
				end
			end
		end,
		on_wield_ranged = function (params, template_data, template_context, t)
			template_context.buff_extension:add_internally_controlled_buff_with_stacks("veteran_weapon_switch_ranged_buff", template_data.ranged_stacks, t)

			if template_data.ranged_id then
				template_context.buff_extension:remove_externally_controlled_buff(template_data.ranged_id)

				template_data.ranged_id = nil
			end

			if template_data.restore_toughness and template_data.ranged_stacks > 0 and t > template_data.last_ranged_toughness + toughness_cd then
				template_data.last_ranged_toughness = t

				Toughness.replenish_percentage(template_context.unit, 0.2, false, "veteran_weapon_switch")
			end

			if params.previously_wielded_slot == "slot_primary" then
				template_data.specialization_resource_component.current_resource = 0
			end

			template_data.ranged_stacks = 0
		end,
		on_wield_melee = function (params, template_data, template_context, t)
			template_context.buff_extension:add_internally_controlled_buff_with_stacks("veteran_weapon_switch_melee_buff", template_data.melee_stacks, t)

			if template_data.melee_id then
				template_context.buff_extension:remove_externally_controlled_buff(template_data.melee_id)

				template_data.melee_id = nil
			end

			if template_data.restore_toughness and template_data.melee_stacks > 0 and t > template_data.last_melee_toughness + toughness_cd then
				template_data.last_melee_toughness = t

				Toughness.replenish_percentage(template_context.unit, 0.1, false, "veteran_weapon_switch")
			end

			if params.previously_wielded_slot == "slot_secondary" then
				template_data.specialization_resource_component.current_resource = 0
			end

			template_data.melee_stacks = 0
		end
	},
	stop_func = function (template_data, template_context)
		if template_data.ranged_id then
			template_context.buff_extension:remove_externally_controlled_buff(template_data.ranged_id)
		end

		if template_data.melee_id then
			template_context.buff_extension:remove_externally_controlled_buff(template_data.melee_id)
		end

		template_data.specialization_resource_component.current_resource = 0
	end
}
templates.veteran_weapon_switch_ranged_visual = {
	use_specialization_resource = true,
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_weapon_switch_crit_bonus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	class_name = "buff",
	max_stacks = max_ranged_stacks
}
templates.veteran_weapon_switch_melee_visual = {
	use_specialization_resource = true,
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_weapon_switch_cleave_bonus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	class_name = "buff",
	max_stacks = max_melee_stacks
}
local ammo_replenish_percent = 0.33
local veteran_weapon_switch_ranged_duration = 5
templates.veteran_weapon_switch_ranged_buff = {
	class_name = "proc_buff",
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_weapon_switch_crit_bonus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	max_stacks = max_ranged_stacks,
	duration = veteran_weapon_switch_ranged_duration,
	proc_events = {
		[proc_events.on_shoot] = 1
	},
	stat_buffs = {
		[stat_buffs.ranged_attack_speed] = 0.02
	},
	conditional_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = 0.33
	},
	proc_func = function (params, template_data, template_context)
		template_data.shot = true
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return not template_data.shot
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
		template_data.inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")
	end,
	update_func = function (template_data, template_context)
		if template_data.first_update_done then
			return
		end

		local unit = template_context.unit
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		local restore_ammo = specialization_extension:has_special_rule("veteran_weapon_switch_replenish_ammo")
		local add_reload_speed = specialization_extension:has_special_rule("veteran_weapon_switch_reload_speed")

		if restore_ammo then
			local inventory_slot_secondary_component = template_data.inventory_slot_secondary_component
			local max_ammo_in_clip = inventory_slot_secondary_component.max_ammunition_clip
			local current_ammo_in_clip = inventory_slot_secondary_component.current_ammunition_clip
			local missing_ammo_in_clip = max_ammo_in_clip - current_ammo_in_clip
			local amount = math.ceil(missing_ammo_in_clip * ammo_replenish_percent * template_context.stack_count / max_ranged_stacks)

			Ammo.transfer_from_reserve_to_clip(inventory_slot_secondary_component, amount)
		end

		if add_reload_speed then
			local t = FixedFrame.get_latest_fixed_time()

			template_context.buff_extension:add_internally_controlled_buff("veteran_weapon_switch_reload_speed", t)
		end

		template_data.first_update_done = true
	end,
	conditional_exit_func = function (template_data, template_context)
		local wielded_slot_name = template_data.inventory_component.wielded_slot

		return wielded_slot_name ~= "slot_secondary"
	end
}
templates.veteran_weapon_switch_reload_speed = {
	refresh_duration_on_stack = true,
	max_stacks = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_weapon_switch_faster_1",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	class_name = "buff",
	duration = veteran_weapon_switch_ranged_duration,
	stat_buffs = {
		[stat_buffs.reload_speed] = 0.2
	}
}
templates.veteran_weapon_switch_melee_buff = {
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_weapon_switch_cleave_bonus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	duration = 10,
	class_name = "buff",
	max_stacks = max_melee_stacks,
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = 0.15,
		[stat_buffs.dodge_speed_multiplier] = 1.1,
		[stat_buffs.dodge_distance_modifier] = 0.1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		local restore_stamina = specialization_extension:has_special_rule("veteran_weapon_switch_replenish_stamina")
		local stamina_reduction = specialization_extension:has_special_rule("veteran_weapon_switch_stamina_reduction")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.inventory_component = unit_data_extension:read_component("inventory")

		if restore_stamina then
			Stamina.add_stamina_percent(template_context.unit, 0.2)
		end

		if stamina_reduction then
			local t = FixedFrame.get_latest_fixed_time()

			template_context.buff_extension:add_internally_controlled_buff("veteran_weapon_switch_melee_stamina_reduction", t)
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		local wielded_slot_name = template_data.inventory_component.wielded_slot

		return wielded_slot_name ~= "slot_primary"
	end
}
local veteran_weapon_switch_melee_bonuses_duration = 3
templates.veteran_weapon_switch_melee_stamina_reduction = {
	refresh_duration_on_stack = true,
	max_stacks = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_weapon_switch_long_duration",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	class_name = "buff",
	duration = veteran_weapon_switch_melee_bonuses_duration,
	stat_buffs = {
		[stat_buffs.stamina_cost_multiplier] = 0.75
	}
}
local tag_duration = 25
local tag_time = 2
local tag_max_stacks = 5
local tag_max_stacks_talent = 8
local toughness_gain = 0.05
local stamina_gain = 0.05
templates.veteran_improved_tag = {
	predicted = false,
	hud_priority = 1,
	use_specialization_resource = true,
	always_active = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_improved_tag",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	class_name = "proc_buff",
	always_show_in_hud = true,
	proc_events = {
		[proc_events.on_tag_unit] = 1,
		[proc_events.on_minion_death] = 1
	},
	keywords = {
		keywords.veteran_tag
	},
	specific_proc_func = {
		on_tag_unit = function (params, template_data, template_context, t)
			if not template_context.is_server then
				return
			end

			if params.tagger_unit ~= template_context.unit then
				return
			end

			if params.tag_name ~= "enemy_over_here_veteran" then
				return
			end

			template_data.remove_t = t + tag_duration
			local total_stack = template_data.stacks
			local stacks_to_apply = total_stack
			local previous_unit = template_data.outlined_unit
			local outlined_unit = params.unit

			if previous_unit == outlined_unit then
				stacks_to_apply = template_data.stacks - template_data.stacks_applied

				if stacks_to_apply <= 0 then
					return
				end
			end

			if previous_unit ~= outlined_unit then
				local buff_extension = ScriptUnit.has_extension(previous_unit, "buff_system")

				if buff_extension and buff_extension:has_buff_using_buff_template("veteran_improved_tag_debuff") then
					buff_extension:remove_externally_controlled_buff(template_data.enemy_buff_id)
				end
			end

			template_data.outlined_unit = outlined_unit
			template_data.stacks_applied = total_stack
			template_data.stack_to_apply = stacks_to_apply
			template_data.stacks = 1
			template_data.specialization_resource_component.current_resource = 1

			if total_stack > 1 then
				template_data.next_t = t + tag_time
			end
		end,
		on_minion_death = function (params, template_data, template_context, t)
			if params.dying_unit ~= template_data.outlined_unit then
				return
			end

			if template_data.allied_defense_boost then
				local coherency_extension = template_data.coherency_extension
				local units_in_coherence = coherency_extension:in_coherence_units()
				local toughness = toughness_gain * template_data.stacks_applied
				local stamina = stamina_gain * template_data.stacks_applied

				for coherency_unit, _ in pairs(units_in_coherence) do
					Toughness.replenish_percentage(coherency_unit, toughness, true, "veteran_tag")
					Stamina.add_stamina_percent(coherency_unit, stamina)
				end
			end

			if template_data.allied_buff then
				local coherency_extension = template_data.coherency_extension
				local units_in_coherence = coherency_extension:in_coherence_units()

				for coherency_unit, _ in pairs(units_in_coherence) do
					local coherency_buff_extension = ScriptUnit.has_extension(coherency_unit, "buff_system")

					if coherency_buff_extension then
						coherency_buff_extension:add_internally_controlled_buff_with_stacks(template_data.allied_buff, template_data.stacks_applied, t, "owner_unit", template_context.unit)
					end
				end
			end

			template_data.stacks_applied = 0
			local new_stacks = math.max(template_data.stacks, 2)

			if template_data.stacks < new_stacks then
				template_data.stacks = new_stacks
				template_data.specialization_resource_component.current_resource = new_stacks
				template_data.next_t = t + tag_time
			end
		end
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		local more_damage_talent = specialization_extension:has_special_rule("veteran_improved_tag_more_damage")
		template_data.allied_defense_boost = specialization_extension:has_special_rule("veteran_improved_tag_dead_bonus")
		local has_allied_buff = specialization_extension:has_special_rule("veteran_improved_tag_dead_coherency_bonus")
		template_data.allied_buff = has_allied_buff and (more_damage_talent and "veteran_improved_tag_allied_buff_increased_stacks" or "veteran_improved_tag_allied_buff")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.specialization_resource_component = unit_data_extension:write_component("specialization_resource")
		template_data.max_stacks = more_damage_talent and tag_max_stacks_talent or tag_max_stacks

		if not template_context.is_server then
			return
		end

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		local t = FixedFrame.get_latest_fixed_time()
		template_data.stacks = 1
		template_data.specialization_resource_component.current_resource = template_data.stacks
		template_data.stacks_applied = 0
		template_data.stack_to_apply = 0
		template_data.next_t = t + tag_time
		template_data.enemy_buff_id = nil
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		if template_data.next_t <= t and template_data.stacks < template_data.max_stacks then
			template_data.stacks = template_data.stacks + 1
			template_data.specialization_resource_component.current_resource = template_data.stacks
			template_data.next_t = t + tag_time

			if template_data.stacks == template_data.max_stacks then
				template_context.buff_extension:add_internally_controlled_buff("veteran_improved_tag_effect", t)
			end
		end

		local outlined_unit = template_data.outlined_unit
		local remove_t = template_data.remove_t

		if remove_t and remove_t < t and outlined_unit then
			local buff_extension = ScriptUnit.has_extension(outlined_unit, "buff_system")

			if buff_extension and buff_extension:has_buff_using_buff_template("veteran_improved_tag_debuff") then
				buff_extension:remove_externally_controlled_buff(template_data.enemy_buff_id)
			end

			template_data.current_buff_id = nil
			template_data.remove_t = nil
			template_data.outlined_unit = nil
			outlined_unit = nil
		end

		local stacks_to_apply = template_data.stack_to_apply

		if stacks_to_apply > 0 and outlined_unit then
			local buff_extension = ScriptUnit.has_extension(outlined_unit, "buff_system")

			if buff_extension then
				for i = 1, stacks_to_apply do
					local _, buff_id = buff_extension:add_externally_controlled_buff("veteran_improved_tag_debuff", t)
					template_data.enemy_buff_id = buff_id
				end
			end

			template_data.stack_to_apply = 0
		end
	end,
	stop_func = function (template_data, template_context)
		template_data.specialization_resource_component.current_resource = 0
	end,
	duration_func = function (template_data, template_context)
		local current_resource = template_data.specialization_resource_component.current_resource
		local last_resource = template_data.duration_last_resource
		local t = FixedFrame.get_latest_fixed_time()

		if current_resource == template_data.max_stacks then
			return 1
		end

		if current_resource ~= last_resource then
			template_data.duration_start_t = t
		end

		template_data.duration_last_resource = current_resource
		local time_since_start = t - template_data.duration_start_t
		local percentage = time_since_start / tag_time
		local duration = math.clamp(percentage, 0.01, 1)

		return duration
	end
}
templates.veteran_improved_tag_effect = {
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_veteran_focus_target"
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.specialization_resource_component = unit_data_extension:read_component("specialization_resource")
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.specialization_resource_component.current_resource < tag_max_stacks
	end
}
templates.veteran_improved_tag_debuff = {
	class_name = "buff",
	predicted = false,
	max_stacks = 8,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = 1.04
	},
	on_remove_stack_func = function (template_data)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data)
		return template_data.finish
	end
}
templates.veteran_improved_tag_allied_buff = {
	predicted = false,
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/veteran/veteran_improved_tag_dead_bonus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	duration = 10,
	class_name = "buff",
	buff_category = buff_categories.generic,
	max_stacks = tag_max_stacks,
	stat_buffs = {
		[stat_buffs.damage] = 0.015
	}
}
templates.veteran_improved_tag_allied_buff_increased_stacks = table.clone(templates.veteran_improved_tag_allied_buff)
templates.veteran_improved_tag_allied_buff_increased_stacks.max_stacks = tag_max_stacks_talent

return templates
