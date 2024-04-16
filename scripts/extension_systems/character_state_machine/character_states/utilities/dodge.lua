local Action = require("scripts/utilities/weapon/action")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DodgeSettings = require("scripts/settings/dodge/dodge_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local dodge_types = DodgeSettings.dodge_types
local proc_events = BuffSettings.proc_events
local Dodge = {
	check = function (t, unit_data_extension, base_dodge_template, input_source)
		local sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")

		if Sprint.is_sprinting(sprint_character_state_component) then
			return false
		end

		local dodge_character_state_component = unit_data_extension:read_component("dodge_character_state")

		if t < dodge_character_state_component.cooldown then
			return false
		end

		local manual_dodge = input_source:get("dodge")
		local dodge_input = manual_dodge

		if not dodge_input then
			return false
		end

		local sweep_component = unit_data_extension:read_component("action_sweep")
		local is_sticky = sweep_component.is_sticky

		if is_sticky then
			local weapon_action_component = unit_data_extension:read_component("weapon_action")
			local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
			local _, current_action = Action.current_action(weapon_action_component, weapon_template)
			local special_active_at_start = weapon_action_component.special_active_at_start
			local sticky_settings = special_active_at_start and current_action.hit_stickyness_settings_special_active or current_action.hit_stickyness_settings

			if sticky_settings and sticky_settings.disallow_dodging then
				return false
			end
		end

		local move = input_source:get("move")
		local allow_stationary_dodge = input_source:get("stationary_dodge")
		local allow_diagonal_forward_dodge = input_source:get("diagonal_forward_dodge")
		local move_length = Vector3.length(move)

		if not allow_stationary_dodge and move_length < base_dodge_template.minimum_dodge_input then
			return false
		end

		local moving_forward = move.y > 0
		local allow_dodge_while_moving_forward = allow_diagonal_forward_dodge
		local allow_always_dodge = input_source:get("always_dodge")
		allow_dodge_while_moving_forward = allow_dodge_while_moving_forward or allow_always_dodge

		if not allow_dodge_while_moving_forward and moving_forward then
			return false
		end

		local dodge_direction = nil

		if move_length == 0 then
			dodge_direction = -Vector3.forward()
		else
			local normalized_move = move / move_length
			local x = normalized_move.x
			local y = normalized_move.y
			local abs_x = math.abs(x)
			local forward_ok = y <= 0 or manual_dodge and abs_x > 0.707

			if forward_ok then
				if y > 0 then
					dodge_direction = Vector3(math.sign(x), 0, 0)
				else
					dodge_direction = normalized_move
				end
			elseif allow_always_dodge then
				dodge_direction = -Vector3.forward()
			end
		end

		if not dodge_direction then
			return false
		end

		return true, dodge_direction
	end,
	is_dodging = function (unit, attack_type)
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

		if not unit_data_extension then
			return false, nil
		end

		local breed = unit_data_extension:breed()

		if not Breed.is_player(breed) then
			return false, nil
		end

		local is_melee = attack_type == attack_types.melee
		local is_ranged = attack_type == attack_types.ranged
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension and (buff_extension:has_keyword(buff_keywords.count_as_dodge_vs_all) or is_melee and buff_extension:has_keyword(buff_keywords.count_as_dodge_vs_melee) or is_ranged and buff_extension:has_keyword(buff_keywords.count_as_dodge_vs_ranged)) then
			return true, dodge_types.buff
		end

		local movement_state_component = unit_data_extension:read_component("movement_state")
		local is_sliding = movement_state_component.method == "sliding"
		local dodge_type = is_sliding and dodge_types.slide or dodge_types.dodge
		local slide_vs_melee = is_sliding and is_melee
		local is_dodging = movement_state_component.is_dodging and not slide_vs_melee

		if is_dodging then
			return true, dodge_type
		end

		local t = Managers.time:time("gameplay")
		local dodge_character_state_component = unit_data_extension:read_component("dodge_character_state")
		local dodge_time = dodge_character_state_component.dodge_time
		local archetype = unit_data_extension:archetype()
		local base_dodge_template = archetype.dodge
		local stat_buffs = buff_extension and buff_extension:stat_buffs()
		local dodge_linger_time_modifier_base = stat_buffs and stat_buffs.dodge_linger_time_modifier or 1
		local dodge_linger_time_melee_modifier = is_melee and stat_buffs and stat_buffs.dodge_linger_time_melee_modifier or 1
		local dodge_linger_time_ranged_modifier = is_ranged and stat_buffs and stat_buffs.dodge_linger_time_ranged_modifier or 1
		local dodge_linger_time_modifier = dodge_linger_time_modifier_base + dodge_linger_time_melee_modifier + dodge_linger_time_ranged_modifier - 2
		local dodge_linger_time_base = base_dodge_template.dodge_linger_time
		local dodge_linger_time = dodge_linger_time_base * dodge_linger_time_modifier
		local dodge_linger_end_time = dodge_time + dodge_linger_time

		if is_melee and t < dodge_linger_end_time then
			return true, dodge_types.linger
		end

		return false, nil
	end
}
local _sucessful_dodge_parameters = {}

Dodge.sucessful_dodge = function (dodging_unit, attacking_unit, attack_type, dodge_type, attacking_breed)
	local dodging_unit_fx_extension = ScriptUnit.has_extension(dodging_unit, "fx_system")

	if dodging_unit_fx_extension then
		local optional_position = nil
		local optional_except_sender = false

		table.clear(_sucessful_dodge_parameters)

		_sucessful_dodge_parameters.enemy_type = Breed.enemy_type(attacking_breed)

		dodging_unit_fx_extension:trigger_exclusive_gear_wwise_event("dodge_success_melee", _sucessful_dodge_parameters, optional_position, optional_except_sender)
	end

	if not attack_type then
		return
	end

	local dodging_unit_buff_extension = ScriptUnit.has_extension(dodging_unit, "buff_system")

	if dodging_unit_buff_extension then
		local param_table = dodging_unit_buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.dodging_unit = dodging_unit
			param_table.attacking_unit = attacking_unit
			param_table.attack_type = attack_type

			dodging_unit_buff_extension:add_proc_event(proc_events.on_successful_dodge, param_table)
		end
	end

	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local dodging_player = player_unit_spawn_manager:owner(dodging_unit)

	if dodging_player then
		local breed_name = attacking_breed.name
		local behaviour_extension = ScriptUnit.has_extension(attacking_unit, "behavior_system")
		local attack_action = behaviour_extension and behaviour_extension:running_action()
		local previously_dodged = behaviour_extension and behaviour_extension.dodged_before and behaviour_extension:dodged_before(dodging_unit)

		Managers.stats:record_private("hook_dodged_attack", dodging_player, breed_name, attack_type, dodge_type, attack_action, previously_dodged)
	end
end

return Dodge
