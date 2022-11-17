require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local ForceTranslation = require("scripts/extension_systems/locomotion/utilities/force_translation")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Ladder = require("scripts/extension_systems/character_state_machine/character_states/utilities/ladder")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local LADDER_TOP_NODE = "node_top"
local LADDER_BOTTOM_NODE = "node_bottom"
local LADDER_LEAVE_NODE = "node_leave"
local PlayerCharacterStateLadderTopLeaving = class("PlayerCharacterStateLadderTopLeaving", "PlayerCharacterStateBase")

PlayerCharacterStateLadderTopLeaving.on_enter = function (self, unit, dt, t, previous_state, params)
	local locomotion_steering = self._locomotion_steering_component
	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = false
	local ladder_unit = params.ladder_unit
	self._ladder_unit = ladder_unit
	local animation_time = self._constants.ladder_top_leaving_animation_time
	local duration = self._constants.ladder_top_leaving_time
	local ladder_character_state_component = self._ladder_character_state_component
	local start_pos = self._locomotion_component.position
	local exit_pos = Unit.world_position(ladder_unit, Unit.node(ladder_unit, "node_leave"))
	ladder_character_state_component.top_enter_leave_timer = t + duration
	ladder_character_state_component.end_position = exit_pos
	ladder_character_state_component.start_position = start_pos
	local animation_extension = self._animation_extension
	local animation_speed = animation_time / duration

	animation_extension:anim_event_with_variable_float("climb_top_exit_ladder", "climb_enter_exit_speed", animation_speed)

	local locomotion_force_translation_component = self._locomotion_force_translation_component
	local locomotion_steering_component = self._locomotion_steering_component

	ForceTranslation.start(locomotion_force_translation_component, locomotion_steering_component, exit_pos, start_pos, t, duration)
end

PlayerCharacterStateLadderTopLeaving.on_exit = function (self, unit, t, next_state)
	ForceRotation.stop(self._locomotion_force_rotation_component)
	ForceTranslation.stop(self._locomotion_force_translation_component)

	if next_state then
		self._animation_extension:anim_event("climb_end_ladder")
	end

	local ladder_character_state_component = self._ladder_character_state_component
	local game_session = Managers.state.game_session:game_session()
	local ladder_cooldown = self._constants.ladder_cooldown

	Ladder.stopped_climbing(ladder_character_state_component, ladder_cooldown, self._is_server, game_session, self._game_object_id, self._player, unit)

	local inventory_component = self._inventory_component

	if inventory_component.wielded_slot == "slot_unarmed" then
		PlayerUnitVisualLoadout.wield_previous_slot(inventory_component, unit, t)
	end

	PlayerMovement.teleport_fixed_update(unit, self._ladder_character_state_component.end_position)
end

PlayerCharacterStateLadderTopLeaving.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local ladder_character_state_component = self._ladder_character_state_component
	local first_person_position = self._first_person_component.position
	local current_position = self._locomotion_component.position
	local leave_position = ladder_character_state_component.end_position
	local start_position = ladder_character_state_component.start_position
	local start_to_leave = leave_position - start_position
	local current_to_leave = leave_position - current_position
	local direction = Vector3.normalize(start_to_leave)
	local duration = self._constants.ladder_top_leaving_time
	local length = Vector3.length(current_to_leave)
	local wanted_speed = length / duration
	local wanted_velocity = direction * wanted_speed
	self._locomotion_steering_component.velocity_wanted = wanted_velocity

	return self:_check_transition(t, next_state_params)
end

PlayerCharacterStateLadderTopLeaving._check_transition = function (self, t, next_state_params)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	if self._ladder_character_state_component.top_enter_leave_timer <= t then
		return "walking"
	end
end

return PlayerCharacterStateLadderTopLeaving
