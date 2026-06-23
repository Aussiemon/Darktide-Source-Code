-- chunkname: @scripts/utilities/companion/companion_servo_skull_ability.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Vo = require("scripts/utilities/vo")
local special_rules = SpecialRulesSettings.special_rules
local servo_skull_states = CompanionServoSkullSettings.STATES
local servo_skull_flamethrower_types = CompanionServoSkullSettings.FLAMETHROWER_TYPES
local servo_skull_buff_settings = CompanionServoSkullSettings.buffs
local talent_settings = TalentSettings.cryptic
local _set_servo_skull_state, _get_servo_skull_state, _play_servo_skull_order_vo
local CompanionServoSkullAbility = {}

CompanionServoSkullAbility.start_order_ability_base = function (target_finder_component, position_finder_component, player_unit, is_server)
	local companion_spawner_extension = ScriptUnit.extension(player_unit, "companion_spawner_system")
	local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_hack)
	local companion_buff_extension = companion_unit and ScriptUnit.extension(companion_unit, "buff_system")
	local buff_name
	local t = Managers.time:time("gameplay")

	if companion_buff_extension then
		buff_name = CompanionServoSkullSettings.buffs.base_order_ability_buff_name

		companion_buff_extension:add_internally_controlled_buff(buff_name, t, "owner_unit", player_unit)
	end

	local player_buff_extension = ScriptUnit.extension(player_unit, "buff_system")

	buff_name = CompanionServoSkullSettings.buffs.base_order_ability_buff_name_player_dummy

	player_buff_extension:add_internally_controlled_buff(buff_name, t)
	_play_servo_skull_order_vo(player_unit)
end

CompanionServoSkullAbility.start_order_ability = function (target_finder_component, position_finder_component, player_unit, is_server)
	local target_ally = target_finder_component.target_unit_1
	local position_valid = position_finder_component.position_valid
	local talent_extension = ScriptUnit.extension(player_unit, "talent_system")
	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local companion_spawner_extension = ScriptUnit.extension(player_unit, "companion_spawner_system")
	local ability_extension = ScriptUnit.extension(player_unit, "ability_system")

	if talent_extension:has_special_rule(special_rules.cryptic_servo_skull_inject_ally) then
		local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_inject_ally)

		if CompanionServoSkullAbility.validate_target_func_inject_ally_ability(target_ally, ability_extension, companion_unit) then
			CompanionServoSkullAbility.start_inject_ally_ability(companion_unit, target_finder_component, position_finder_component, ability_extension, is_server)

			target_finder_component.target_unit_1 = nil
			position_finder_component.position = Vector3.zero()

			_play_servo_skull_order_vo(player_unit)

			return
		end
	end

	if talent_extension:has_special_rule(special_rules.cryptic_servo_skull_flamethrower) then
		local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_flamethrower)

		if CompanionServoSkullAbility.validate_target_func_flamethrower_ability(position_valid, ability_extension, companion_unit) then
			CompanionServoSkullAbility.start_flamethrower_ability(companion_unit, position_finder_component, ability_extension, buff_extension, is_server)

			target_finder_component.target_unit_1 = nil
			position_finder_component.position = Vector3.zero()

			_play_servo_skull_order_vo(player_unit)

			return
		end
	end

	target_finder_component.target_unit_1 = nil
	position_finder_component.position = Vector3.zero()
end

CompanionServoSkullAbility.can_aim_on_ground = function (unit_data_extension, ability_extension, companion_spawner_extension, input_extension, talent_extension)
	local has_input = input_extension:get("grenade_ability_hold")

	if not has_input then
		local no_outline = true

		return false, no_outline
	end

	if talent_extension:has_special_rule(special_rules.cryptic_servo_skull_flamethrower) then
		local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_flamethrower)

		return CompanionServoSkullAbility.validate_target_func_flamethrower_ability(true, ability_extension, companion_unit)
	end

	return false
end

CompanionServoSkullAbility.select_animation_event = function (player_unit, old_animation_event, current_weapon_template, animation_extension, target_finder_component, position_finder_component, companion_spawner_extension, input_extension)
	if not current_weapon_template or current_weapon_template.name ~= "cryptic_servo_skull_order_point" then
		return old_animation_event
	end

	local has_input = input_extension:get("grenade_ability_hold")

	if not has_input then
		return old_animation_event
	end

	local companion_unit_flame = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_flamethrower)
	local companion_unit_inject_ally = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_inject_ally)
	local flame_skull_state
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(companion_unit_flame)
	local game_object_exists = game_object_id and GameSession.game_object_exists(game_session, game_object_id)

	if game_object_exists then
		flame_skull_state = GameSession.game_object_field(game_session, game_object_id, "state")
	end

	local is_in_flame_state = flame_skull_state and (flame_skull_state == servo_skull_states.flamethrower or flame_skull_state == servo_skull_states.flamethrower_shooting)

	if is_in_flame_state or companion_unit_inject_ally and target_finder_component.target_unit_1 then
		if old_animation_event ~= "ally_mode" then
			animation_extension:anim_event_1p("switch_to_ally_mode")

			return "ally_mode"
		end
	elseif companion_unit_flame and position_finder_component.position_valid then
		local current_flamethrower_type = GameSession.game_object_field(game_session, game_object_id, "flamethrower_type")

		if current_flamethrower_type == servo_skull_flamethrower_types.circle then
			if old_animation_event ~= "circle_mode" then
				animation_extension:anim_event_1p("switch_to_circle_mode")

				return "circle_mode"
			end
		elseif old_animation_event ~= "cone_mode" then
			animation_extension:anim_event_1p("switch_to_cone_mode")

			return "cone_mode"
		end
	end

	return old_animation_event
end

CompanionServoSkullAbility.on_input_action_func = function (unit_data_extension, ability_extension, companion_spawner_extension, is_server, input_extension, talent_extension)
	if not is_server then
		return
	end

	if CompanionServoSkullAbility.can_aim_on_ground(unit_data_extension, ability_extension, companion_spawner_extension, input_extension, talent_extension) then
		local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_flamethrower)

		if companion_unit then
			local game_session = Managers.state.game_session:game_session()
			local game_object_id = Managers.state.unit_spawner:game_object_id(companion_unit)
			local game_object_exists = GameSession.game_object_exists(game_session, game_object_id)

			if not game_object_exists then
				return
			end

			local current_flamethrower_type = GameSession.game_object_field(game_session, game_object_id, "flamethrower_type")
			local new_flamethrower_type

			if current_flamethrower_type == servo_skull_flamethrower_types.circle then
				new_flamethrower_type = servo_skull_flamethrower_types.cone
			else
				new_flamethrower_type = servo_skull_flamethrower_types.circle
			end

			GameSession.set_game_object_field(game_session, game_object_id, "flamethrower_type", new_flamethrower_type)
		end
	end
end

CompanionServoSkullAbility.select_aim_on_ground_effect = function (unit_data_extension, companion_spawner_extension, talent_extension)
	if not talent_extension:has_special_rule(special_rules.cryptic_servo_skull_flamethrower) then
		return nil
	end

	local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_flamethrower)

	if not companion_unit then
		return
	end

	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(companion_unit)
	local current_flamethrower_type = GameSession.game_object_field(game_session, game_object_id, "flamethrower_type")

	if talent_extension:has_special_rule(special_rules.cryptic_servo_skull_flamethrower) and current_flamethrower_type == servo_skull_flamethrower_types.circle then
		return "content/fx/particles/pocketables/cryptic_servoskull_flamer_circle"
	elseif talent_extension:has_special_rule(special_rules.cryptic_servo_skull_flamethrower) and current_flamethrower_type == servo_skull_flamethrower_types.cone then
		return "content/fx/particles/pocketables/cryptic_servoskull_flamer_cone_decal"
	end
end

CompanionServoSkullAbility.select_target_outline_func = function (unit_data_extension, target_unit, is_valid, talent_extension)
	if talent_extension:has_special_rule(special_rules.cryptic_servo_skull_inject_ally) and Breed.is_player(Breed.unit_breed_or_nil(target_unit)) then
		return nil
	end

	return nil
end

CompanionServoSkullAbility.can_target_unit = function (unit_data_extension, smart_target_unit, companion_spawner_extension, talent_extension, ability_extension)
	if talent_extension:has_special_rule(special_rules.cryptic_servo_skull_inject_ally) then
		local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_inject_ally)

		if CompanionServoSkullAbility.validate_target_func_inject_ally_ability(smart_target_unit, ability_extension, companion_unit) then
			return true
		end
	end
end

CompanionServoSkullAbility.effect_validate_target_func = function (unit_data_extension, smart_target_unit, ability_extension, companion_spawner_extension, input_extension, talent_extension)
	local has_input = input_extension:get("grenade_ability_hold")

	if not has_input then
		local no_outline = true

		return false, no_outline
	end

	if talent_extension:has_special_rule(special_rules.cryptic_servo_skull_inject_ally) and Managers.state.player_unit_spawn:is_player_unit(smart_target_unit) then
		local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_inject_ally)

		return CompanionServoSkullAbility.validate_target_func_inject_ally_ability(smart_target_unit, ability_extension, companion_unit)
	end
end

CompanionServoSkullAbility.start_flamethrower_ability = function (companion_unit, position_finder_component, ability_extension, buff_extension, is_server)
	if is_server then
		local companion_blackboard = BLACKBOARDS[companion_unit]
		local behavior_component = Blackboard.write_component(companion_blackboard, "behavior")
		local target_position = position_finder_component.position

		target_position.z = target_position.z - 1
		behavior_component.has_move_to_position = true

		behavior_component.move_to_position:store(target_position)
		_set_servo_skull_state(companion_unit, servo_skull_states.flamethrower)
	end

	local ability_type = "grenade_ability"
	local ability_charges = CompanionServoSkullSettings.ability_charges.flamethrower
	local ability_name = ability_extension:ability_name(ability_type)
	local cryptic_servo_skull_flamethrower_uses_no_charge = buff_extension:has_keyword("cryptic_servo_skull_flamethrower_uses_no_charge")
	local telemetry_ability_name = ability_name .. "_cone_flame"
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(companion_unit)
	local game_object_exists = GameSession.game_object_exists(game_session, game_object_id)

	if game_object_exists then
		local current_flamethrower_type = GameSession.game_object_field(game_session, game_object_id, "flamethrower_type")

		if current_flamethrower_type == servo_skull_flamethrower_types.circle then
			telemetry_ability_name = ability_name .. "_circle_flame"
		end

		if ability_charges > 0 and not cryptic_servo_skull_flamethrower_uses_no_charge then
			ability_extension:use_ability_charge(ability_type, ability_charges, telemetry_ability_name)
		end
	end
end

CompanionServoSkullAbility.validate_target_func_flamethrower_ability = function (position_valid, ability_extension, companion_unit)
	local ability_type = "grenade_ability"
	local ability_charges = CompanionServoSkullSettings.ability_charges.flamethrower
	local remaining_ability_charges = ability_extension:remaining_ability_charges(ability_type)

	if remaining_ability_charges < ability_charges then
		local no_outline = true

		return false, no_outline
	end

	if not ALIVE[companion_unit] then
		local no_outline = true

		return false, no_outline
	end

	local state = _get_servo_skull_state(companion_unit)

	if state and state ~= servo_skull_states.following then
		local no_outline = true

		return false, no_outline
	end

	return position_valid
end

CompanionServoSkullAbility.finish_flamethrower_ability = function (companion_unit)
	if ALIVE[companion_unit] then
		local companion_blackboard = BLACKBOARDS[companion_unit]
		local behavior_component = Blackboard.write_component(companion_blackboard, "behavior")

		behavior_component.has_move_to_position = false

		_set_servo_skull_state(companion_unit, servo_skull_states.following)
	end
end

CompanionServoSkullAbility.start_inject_ally_ability = function (companion_unit, target_finder_component, position_finder_component, ability_extension, is_server)
	if is_server then
		local companion_blackboard = BLACKBOARDS[companion_unit]
		local behavior_component = Blackboard.write_component(companion_blackboard, "behavior")
		local target_ally = target_finder_component.target_unit_1

		behavior_component.target_unit = target_ally

		_set_servo_skull_state(companion_unit, servo_skull_states.inject_ally)
	end

	local ability_type = "grenade_ability"
	local ability_charges = CompanionServoSkullSettings.ability_charges.inject_ally
	local ability_name = ability_extension:ability_name(ability_type)
	local telemetry_ability_name = ability_name .. "_heal_ally"

	if ability_charges > 0 then
		ability_extension:use_ability_charge(ability_type, ability_charges, telemetry_ability_name)
	end
end

CompanionServoSkullAbility.validate_target_func_inject_ally_ability = function (target_unit, ability_extension, companion_unit)
	if not Managers.state.player_unit_spawn:is_player_unit(target_unit) then
		local no_outline = true

		return false, no_outline
	end

	local ability_type = "grenade_ability"
	local ability_charges = CompanionServoSkullSettings.ability_charges.inject_ally
	local remaining_ability_charges = ability_extension:remaining_ability_charges(ability_type)

	if remaining_ability_charges < ability_charges then
		local no_outline = true

		return false, no_outline
	end

	if not ALIVE[companion_unit] then
		local no_outline = true

		return false, no_outline
	end

	local state = _get_servo_skull_state(companion_unit)

	if state and state ~= servo_skull_states.following then
		local no_outline = true

		return false, no_outline
	end

	if not target_unit or not companion_unit then
		return false
	end

	local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")

	if not character_state_component then
		return false
	end

	if not PlayerUnitStatus.requires_allied_interaction_help(character_state_component) then
		return false
	end

	if PlayerUnitStatus.is_ledge_hanging(character_state_component) then
		return false
	end

	local assisted_state_input_component = unit_data_extension and unit_data_extension:read_component("assisted_state_input")

	if not assisted_state_input_component then
		return false
	end

	if PlayerUnitStatus.is_assisted(assisted_state_input_component) then
		return false
	end

	return true
end

CompanionServoSkullAbility.finish_inject_ally_ability = function (companion_unit, success)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	if ALIVE[companion_unit] then
		local companion_blackboard = BLACKBOARDS[companion_unit]
		local behavior_component = Blackboard.write_component(companion_blackboard, "behavior")

		behavior_component.has_move_to_position = false

		_set_servo_skull_state(companion_unit, servo_skull_states.following)
	end

	if not success then
		local owner = Managers.state.player_unit_spawn:owner(companion_unit)
		local owner_unit = owner and owner.player_unit

		if HEALTH_ALIVE[owner_unit] then
			local ability_extension = ScriptUnit.has_extension(owner_unit, "ability_system")
			local ability_type = "grenade_ability"
			local ability_charges = CompanionServoSkullSettings.ability_charges.inject_ally

			if ability_charges > 0 and ability_extension then
				ability_extension:restore_ability_charge(ability_type, ability_charges)
			end
		end
	end
end

CompanionServoSkullAbility.start_hacking_ability = function (companion_unit, target_unit, ability_extension)
	local companion_blackboard = BLACKBOARDS[companion_unit]
	local behavior_component = Blackboard.write_component(companion_blackboard, "behavior")
	local target_ally = target_unit

	behavior_component.target_unit = target_ally

	local whistle_component = Blackboard.write_component(companion_blackboard, "whistle")

	whistle_component.current_hack_target = target_unit

	_set_servo_skull_state(companion_unit, servo_skull_states.hacking)
end

CompanionServoSkullAbility.validate_target_func_hacking_ability = function (target_unit, ability_extension, companion_unit)
	local ability_type = "grenade_ability"
	local ability_charges = CompanionServoSkullSettings.ability_charges.hacking
	local remaining_ability_charges = ability_extension:remaining_ability_charges(ability_type)

	if remaining_ability_charges < ability_charges then
		local no_outline = true

		return false, no_outline
	end

	if not ALIVE[companion_unit] then
		local no_outline = true

		return false, no_outline
	end

	local state = _get_servo_skull_state(companion_unit)

	if state and state ~= servo_skull_states.following and state ~= servo_skull_states.following_shooting and state ~= servo_skull_states.following_shooting_ability then
		local no_outline = true

		return false, no_outline
	end

	if target_unit then
		local interactee_extension = ScriptUnit.has_extension(target_unit, "interactee_system")

		if interactee_extension then
			local interactee_interaction_type = interactee_extension:interaction_type()

			if interactee_extension and interactee_interaction_type == "decoding" then
				local can_interact = interactee_extension:can_interact(target_unit, interactee_interaction_type)

				return can_interact
			end
		end
	end

	return false
end

CompanionServoSkullAbility.finish_hacking_ability = function (companion_unit)
	if ALIVE[companion_unit] then
		local companion_blackboard = BLACKBOARDS[companion_unit]
		local whistle_component = Blackboard.write_component(companion_blackboard, "whistle")

		if whistle_component then
			whistle_component.current_hack_target = nil
		end

		_set_servo_skull_state(companion_unit, servo_skull_states.following)
	end
end

CompanionServoSkullAbility.start_shooting_ability = function (companion_unit, target_unit, ability_extension)
	local companion_blackboard = BLACKBOARDS[companion_unit]
	local whistle_component = Blackboard.write_component(companion_blackboard, "whistle")
	local target_enemy = target_unit

	whistle_component.current_target = target_enemy

	local player_unit = companion_blackboard.behavior.owner_unit
	local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")

	if not talent_extension or not talent_extension:has_special_rule(special_rules.cryptic_servo_skull_improved_tagging) then
		return
	end

	_set_servo_skull_state(companion_unit, servo_skull_states.following_shooting_ability)

	local companion_buff_extension = ScriptUnit.extension(companion_unit, "buff_system")
	local buff_name = servo_skull_buff_settings.shooting_tagging_buff_name
	local ability_percentage_consumed = talent_settings.servo_skull_shooting_tagging.capacitance
	local current_buff_duration_left_percent = companion_buff_extension:buff_duration_progress(buff_name)
	local percent_cost = 1 - current_buff_duration_left_percent

	ability_extension:increase_ability_cooldown_percentage("combat_ability", ability_percentage_consumed * percent_cost)

	local t = Managers.time:time("gameplay")

	companion_buff_extension:add_internally_controlled_buff(buff_name, t)
end

CompanionServoSkullAbility.validate_target_func_shooting_ability = function (target_unit, ability_extension, companion_unit)
	if not ALIVE[companion_unit] then
		return false
	end

	if not HEALTH_ALIVE[target_unit] then
		return false
	end

	local state = _get_servo_skull_state(companion_unit)

	if state ~= servo_skull_states.following and state ~= servo_skull_states.following_shooting and state ~= servo_skull_states.following_shooting_ability then
		return false
	end

	local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local breed = unit_data_extension and unit_data_extension:breed()
	local enemy_type = breed and Breed.enemy_type(breed)

	if enemy_type then
		local invalid_target = false
		local daemonhost = breed and breed.tags.witch

		if daemonhost then
			local daemonhost_blackboard = BLACKBOARDS[target_unit]
			local daemonhost_perception_component = daemonhost_blackboard.perception
			local is_aggroed = daemonhost_perception_component.aggro_state == "aggroed"

			invalid_target = not is_aggroed
		end

		if not invalid_target then
			return true
		end

		return false
	end

	return true
end

CompanionServoSkullAbility.finish_shooting_ability = function (companion_unit)
	if ALIVE[companion_unit] then
		local current_state = _get_servo_skull_state(companion_unit)

		if current_state == servo_skull_states.following_shooting_ability then
			_set_servo_skull_state(companion_unit, servo_skull_states.following)
		end
	end
end

function _set_servo_skull_state(companion_unit, new_state)
	local is_server = Managers.state.game_session:is_server()

	if not ALIVE[companion_unit] then
		return
	end

	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(companion_unit)
	local game_object_exists = GameSession.game_object_exists(game_session, game_object_id)

	if not game_object_exists then
		return
	end

	GameSession.set_game_object_field(game_session, game_object_id, "state", new_state)
end

function _get_servo_skull_state(companion_unit)
	if not ALIVE[companion_unit] then
		return nil
	end

	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(companion_unit)
	local game_object_exists = GameSession.game_object_exists(game_session, game_object_id)

	if not game_object_exists then
		return
	end

	return GameSession.game_object_field(game_session, game_object_id, "state")
end

function _play_servo_skull_order_vo(player_unit)
	local vo_tag = "cryptic_blitz_01_a"

	Vo.play_combat_ability_event(player_unit, vo_tag)
end

return CompanionServoSkullAbility
