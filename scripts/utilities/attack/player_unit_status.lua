﻿-- chunkname: @scripts/utilities/attack/player_unit_status.lua

local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local critical_health = PlayerCharacterConstants.critical_health
local HEALTH_PERCENT_LIMIT = critical_health.health_percent_limit
local TOUGHNESS_PERCENT_LIMIT = critical_health.toughness_percent_limit
local PlayerUnitStatus = {}
local DISABLED_STATES = {
	ledge_hanging = true,
	warp_grabbed = true,
	dead = true,
	hogtied = true,
	grabbed = true,
	catapulted = true,
	knocked_down = true,
	consumed = true,
	netted = true,
	mutant_charged = true,
	pounced = true
}
local REQUIRES_HELP = {
	ledge_hanging = true,
	warp_grabbed = true,
	hogtied = true,
	grabbed = true,
	knocked_down = true,
	consumed = true,
	netted = true,
	mutant_charged = true,
	pounced = true
}
local REQUIRES_ALLIED_INTERACTION_HELP = {
	netted = true,
	knocked_down = true,
	ledge_hanging = true,
	hogtied = true
}
local OBJECTIVE_INTERACTION_STATES = {
	interacting = true,
	sprinting = true,
	walking = true
}
local VALID_END_ZONE_STATES = {
	stunned = true,
	ladder_top_leaving = true,
	ladder_top_entering = true,
	hogtied = false,
	sliding = true,
	catapulted = true,
	sprinting = true,
	consumed = true,
	jumping = true,
	lunging = true,
	ladder_climbing = true,
	mutant_charged = true,
	interacting = true,
	dodging = true,
	pounced = true,
	minigame = true,
	warp_grabbed = true,
	walking = true,
	ledge_vaulting = true,
	falling = true,
	grabbed = true,
	hub_emote = false,
	dead = true,
	ledge_hanging = false,
	netted = false,
	ledge_hanging_pull_up = true,
	knocked_down = false,
	exploding = false,
	ledge_hanging_falling = false,
	hub_jog = false
}
local MISSION_FAILURE_DEAD_STATES = {
	hogtied = true,
	dead = true
}
local MISSION_FAILURE_DISABLED_STATES = {
	netted = true,
	warp_grabbed = true,
	ledge_hanging = true,
	hogtied = true,
	knocked_down = true,
	dead = true
}
local KNOCKED_DOWN_STATE_NAME = "knocked_down"
local CATAPULTED_STATE_NAME = "catapulted"
local HOGTIED_STATE_NAME = "hogtied"

PlayerUnitStatus.is_disabled = function (character_state_component)
	local state_name = character_state_component.state_name
	local is_disabled = DISABLED_STATES[state_name]
	local requires_help = REQUIRES_HELP[state_name]

	return is_disabled, requires_help
end

PlayerUnitStatus.requires_help = function (character_state_component)
	local state_name = character_state_component.state_name

	return REQUIRES_HELP[state_name]
end

PlayerUnitStatus.requires_allied_interaction_help = function (character_state_component)
	local state_name = character_state_component.state_name

	return REQUIRES_ALLIED_INTERACTION_HELP[state_name]
end

PlayerUnitStatus.end_zone_conditions_fulfilled = function (character_state_component)
	local state_name = character_state_component.state_name

	return VALID_END_ZONE_STATES[state_name]
end

PlayerUnitStatus.is_dead_for_mission_failure = function (character_state_component)
	local state_name = character_state_component.state_name

	return MISSION_FAILURE_DEAD_STATES[state_name]
end

PlayerUnitStatus.is_disabled_for_mission_failure = function (character_state_component)
	local state_name = character_state_component.state_name

	return MISSION_FAILURE_DISABLED_STATES[state_name]
end

PlayerUnitStatus.is_knocked_down = function (character_state_component)
	local state_name = character_state_component.state_name

	return state_name == KNOCKED_DOWN_STATE_NAME
end

PlayerUnitStatus.is_hogtied = function (character_state_component)
	local state_name = character_state_component.state_name

	return state_name == HOGTIED_STATE_NAME
end

PlayerUnitStatus.is_catapulted = function (character_state_component)
	local state_name = character_state_component.state_name

	return state_name == CATAPULTED_STATE_NAME
end

PlayerUnitStatus.is_pounced = function (disabled_character_state_component)
	local is_disabled = disabled_character_state_component.is_disabled
	local is_pounced = is_disabled and disabled_character_state_component.disabling_type == "pounced"
	local disabling_unit = disabled_character_state_component.disabling_unit

	return is_pounced, disabling_unit
end

PlayerUnitStatus.is_netted = function (disabled_character_state_component)
	local is_disabled = disabled_character_state_component.is_disabled
	local is_netted = is_disabled and disabled_character_state_component.disabling_type == "netted"
	local disabling_unit = disabled_character_state_component.disabling_unit

	return is_netted, disabling_unit
end

PlayerUnitStatus.is_warp_grabbed = function (disabled_character_state_component)
	local is_disabled = disabled_character_state_component.is_disabled
	local is_warp_grabbed = is_disabled and disabled_character_state_component.disabling_type == "warp_grabbed"
	local disabling_unit = disabled_character_state_component.disabling_unit

	return is_warp_grabbed, disabling_unit
end

PlayerUnitStatus.is_mutant_charged = function (disabled_character_state_component)
	local is_disabled = disabled_character_state_component.is_disabled
	local is_mutant_charged = is_disabled and disabled_character_state_component.disabling_type == "mutant_charged"
	local disabling_unit = disabled_character_state_component.disabling_unit

	return is_mutant_charged, disabling_unit
end

PlayerUnitStatus.is_consumed = function (disabled_character_state_component)
	local is_disabled = disabled_character_state_component.is_disabled
	local is_consumed = is_disabled and disabled_character_state_component.disabling_type == "consumed"
	local disabling_unit = disabled_character_state_component.disabling_unit

	return is_consumed, disabling_unit
end

PlayerUnitStatus.is_grabbed = function (disabled_character_state_component)
	local is_disabled = disabled_character_state_component.is_disabled
	local is_consumed = is_disabled and disabled_character_state_component.disabling_type == "grabbed"
	local disabling_unit = disabled_character_state_component.disabling_unit

	return is_consumed, disabling_unit
end

PlayerUnitStatus.is_stunned = function (character_state_component)
	local state_name = character_state_component.state_name
	local is_stunned = state_name == "stunned"

	return is_stunned
end

PlayerUnitStatus.is_ledge_hanging = function (character_state_component)
	local state_name = character_state_component.state_name
	local is_ledge_hanging = state_name == "ledge_hanging"

	return is_ledge_hanging
end

PlayerUnitStatus.is_climbing_ladder = function (character_state_component)
	local state_name = character_state_component.state_name
	local is_climbing_ladder = state_name == "ladder_climbing"

	return is_climbing_ladder
end

PlayerUnitStatus.is_in_mission_board = function (character_state_component, interacting_character_state_component)
	local state_name = character_state_component.state_name
	local is_in_mission_board = state_name == "interacting" and interacting_character_state_component.type == "mission_board"

	return is_in_mission_board
end

PlayerUnitStatus.is_assisted = function (assisted_state_input)
	local is_assisted = assisted_state_input.in_progress

	return is_assisted
end

PlayerUnitStatus.is_dead = function (character_state_component)
	local state_name = character_state_component.state_name

	return state_name == "dead"
end

PlayerUnitStatus.is_in_critical_health = function (health_extension, toughness_extension)
	local health_percent = health_extension:current_health_percent()
	local toughness_percent = toughness_extension:current_toughness_percent()
	local health_limit_met = health_percent <= HEALTH_PERCENT_LIMIT
	local toughness_limit_met = toughness_percent <= TOUGHNESS_PERCENT_LIMIT
	local is_in_critical_health = health_limit_met and toughness_limit_met

	if not is_in_critical_health then
		return is_in_critical_health, 0
	end

	local critical_health_status = 1 - math.clamp(toughness_percent / TOUGHNESS_PERCENT_LIMIT, 0, 1)

	return is_in_critical_health, critical_health_status
end

local AbilityTemplate, Action

PlayerUnitStatus.is_aiming_lunge = function (combat_ability_action_read_component)
	AbilityTemplate = AbilityTemplate or require("scripts/utilities/ability/ability_template")
	Action = Action or require("scripts/utilities/weapon/action")

	local ability_template = AbilityTemplate.current_ability_template(combat_ability_action_read_component)
	local _, current_action_settings = Action.current_action(combat_ability_action_read_component, ability_template)
	local current_action_kind = current_action_settings and current_action_settings.kind
	local correct_action_kind = current_action_kind == "targeted_dash_aim" or current_action_kind == "directional_dash_aim"

	return correct_action_kind
end

PlayerUnitStatus.can_interact_with_objective = function (player_unit)
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local state_name = character_state_component.state_name
	local state_allowed = OBJECTIVE_INTERACTION_STATES[state_name]
	local movement_state_component = unit_data_extension:read_component("movement_state")
	local crouching_in_bad_location = movement_state_component.is_crouching and not Crouch.can_exit(player_unit)

	return state_allowed and not PlayerUnitStatus.is_disabled(character_state_component) and not crouching_in_bad_location
end

PlayerUnitStatus.no_toughness_left = function (toughness_extension)
	local toughness_percent = toughness_extension:current_toughness_percent()

	return toughness_percent <= 0
end

PlayerUnitStatus.has_corruption_damage = function (health_extension)
	local permanent_damage = health_extension:permanent_damage_taken()
	local have_permanent_damage = permanent_damage > 0.01

	return have_permanent_damage
end

return PlayerUnitStatus
