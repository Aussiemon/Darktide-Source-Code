local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local critical_health = PlayerCharacterConstants.critical_health
local HEALTH_PERCENT_LIMIT = critical_health.health_percent_limit
local TOUGHNESS_PERCENT_LIMIT = critical_health.toughness_percent_limit
local PlayerUnitStatus = {}
local DISABLED_STATES = {
	knocked_down = true,
	warp_grabbed = true,
	ledge_hanging = true,
	hogtied = true,
	catapulted = true,
	dead = true,
	netted = true,
	mutant_charged = true,
	pounced = true
}
local REQUIRES_HELP = {
	netted = true,
	hogtied = true,
	knocked_down = true,
	pounced = true,
	ledge_hanging = true
}
local REQUIRES_ALLIED_INTERACTION_HELP = {
	netted = true,
	knocked_down = true,
	hogtied = true,
	ledge_hanging = true
}
local OBJECTIVE_INTERACTION_STATES = {
	interacting = true,
	sprinting = true,
	walking = true
}
local VALID_END_ZONE_STATES = {
	warp_grabbed = true,
	walking = true,
	ledge_vaulting = true,
	falling = true,
	catapulted = true,
	dead = true,
	jumping = true,
	sprinting = true,
	mutant_charged = true,
	interacting = true,
	dodging = true,
	pounced = true
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
	local requires_help = REQUIRES_HELP[state_name]

	return requires_help
end

PlayerUnitStatus.requires_allied_interaction_help = function (character_state_component)
	local state_name = character_state_component.state_name
	local requires_allied_interaction_help = REQUIRES_ALLIED_INTERACTION_HELP[state_name]

	return requires_allied_interaction_help
end

PlayerUnitStatus.end_zone_conditions_fulfilled = function (character_state_component)
	local state_name = character_state_component.state_name
	local end_zone_conditions_fulfilled = VALID_END_ZONE_STATES[state_name]

	return end_zone_conditions_fulfilled
end

PlayerUnitStatus.is_knocked_down = function (character_state_component)
	local state_name = character_state_component.state_name
	local is_knocked_down = state_name == KNOCKED_DOWN_STATE_NAME

	return is_knocked_down
end

PlayerUnitStatus.is_hogtied = function (character_state_component)
	local state_name = character_state_component.state_name
	local is_hogtied = state_name == HOGTIED_STATE_NAME

	return is_hogtied
end

PlayerUnitStatus.is_catapulted = function (character_state_component)
	local state_name = character_state_component.state_name
	local is_catapulted = state_name == CATAPULTED_STATE_NAME

	return is_catapulted
end

PlayerUnitStatus.is_pounced = function (disabled_character_state_component)
	local is_disabled = disabled_character_state_component.is_disabled
	local is_pounced = is_disabled and disabled_character_state_component.disabling_type == "pounced"
	local pouncing_unit = disabled_character_state_component.disabling_unit

	return is_pounced, pouncing_unit
end

PlayerUnitStatus.is_netted = function (disabled_character_state_component)
	local is_disabled = disabled_character_state_component.is_disabled
	local is_netted = is_disabled and disabled_character_state_component.disabling_type == "netted"
	local netting_unit = disabled_character_state_component.disabling_unit

	return is_netted, netting_unit
end

PlayerUnitStatus.is_warp_grabbed = function (disabled_character_state_component)
	local is_disabled = disabled_character_state_component.is_disabled
	local is_warp_grabbed = is_disabled and disabled_character_state_component.disabling_type == "warp_grabbed"
	local warp_grabbing_unit = disabled_character_state_component.disabling_unit

	return is_warp_grabbed, warp_grabbing_unit
end

PlayerUnitStatus.is_mutant_charged = function (disabled_character_state_component)
	local is_disabled = disabled_character_state_component.is_disabled
	local is_mutant_charged = is_disabled and disabled_character_state_component.disabling_type == "mutant_charged"
	local mutant_charging_unit = disabled_character_state_component.disabling_unit

	return is_mutant_charged, mutant_charging_unit
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

PlayerUnitStatus.is_in_lunging_aim_or_combat_ability = function (lunge_character_state_component)
	local is_lunging = lunge_character_state_component.is_lunging
	local is_lunging_aiming = lunge_character_state_component.is_aiming

	if not is_lunging and not is_lunging_aiming then
		return false, nil
	end

	local lunge_template_name = lunge_character_state_component.lunge_template
	local lunge_template = LungeTemplates[lunge_template_name]

	return lunge_template.combat_ability, lunge_template
end

PlayerUnitStatus.can_interact_with_objective = function (character_state_component)
	local state_name = character_state_component.state_name
	local state_allowed = OBJECTIVE_INTERACTION_STATES[state_name]

	return state_allowed and not PlayerUnitStatus.is_disabled(character_state_component)
end

PlayerUnitStatus.no_toughness_left = function (toughness_extension)
	local toughness_percent = toughness_extension:current_toughness_percent()

	return toughness_percent <= 0
end

PlayerUnitStatus.have_coruption = function (health_extension)
	local permanent_damage = health_extension:permanent_damage_taken()
	local have_permanent_damage = permanent_damage > 0.01

	return have_permanent_damage
end

return PlayerUnitStatus
