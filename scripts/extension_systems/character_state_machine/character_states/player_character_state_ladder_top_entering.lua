-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_ladder_top_entering.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local ForceTranslation = require("scripts/extension_systems/locomotion/utilities/force_translation")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Ladder = require("scripts/extension_systems/character_state_machine/character_states/utilities/ladder")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerCharacterStateLadderTopEntering = class("PlayerCharacterStateLadderTopEntering", "PlayerCharacterStateBase")
local INVENTORY_SLOT_TO_WIELD = "slot_unarmed"
local LADDER_TOP_NODE = "node_top"
local LADDER_BOTTOM_NODE = "node_bottom"
local LADDER_LEAVE_NODE = "node_leave"
local LADDER_ENTER_END_NODE = "node_enter_end"

PlayerCharacterStateLadderTopEntering.on_enter = function (self, unit, dt, t, previous_state, params)
	local ladder_unit = params.ladder_unit
	local locomotion_steering = self._locomotion_steering_component

	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = false

	local animation_time = self._constants.ladder_top_entering_animation_time
	local duration = self._constants.ladder_top_entering_time
	local ladder_character_state_component = self._ladder_character_state_component
	local start_pos = Unit.world_position(ladder_unit, Unit.node(ladder_unit, LADDER_LEAVE_NODE))
	local enter_end_node = Unit.has_node(ladder_unit, LADDER_ENTER_END_NODE) and Unit.node(ladder_unit, LADDER_ENTER_END_NODE)
	local top_node = Unit.node(ladder_unit, LADDER_TOP_NODE)
	local exit_pos = Unit.world_position(ladder_unit, enter_end_node or top_node)
	local velocity_wanted = self:_velocity_wanted(ladder_unit, unit, duration)

	locomotion_steering.velocity_wanted = velocity_wanted
	ladder_character_state_component.top_enter_leave_timer = t + duration
	ladder_character_state_component.end_position = exit_pos
	ladder_character_state_component.start_position = start_pos

	PlayerUnitVisualLoadout.wield_slot(INVENTORY_SLOT_TO_WIELD, unit, t)

	local animation_extension = self._animation_extension
	local animation_speed = animation_time / duration

	animation_extension:anim_event_with_variable_float("climb_top_enter_ladder", "climb_enter_exit_speed", animation_speed)
	animation_extension:anim_event_1p("arms_down")

	local force_rotation = Unit.world_rotation(ladder_unit, 1)
	local start_rotation = Unit.world_rotation(unit, 1)

	ForceRotation.start(self._locomotion_force_rotation_component, locomotion_steering, force_rotation, start_rotation, t, 0)

	local locomotion_force_translation_component = self._locomotion_force_translation_component
	local locomotion_steering_component = self._locomotion_steering_component

	ForceTranslation.start(locomotion_force_translation_component, locomotion_steering_component, exit_pos, start_pos, t, duration)

	local game_session = Managers.state.game_session:game_session()

	Ladder.started_climbing(ladder_character_state_component, ladder_unit, self._is_server, game_session, self._game_object_id, self._player, unit)
end

PlayerCharacterStateLadderTopEntering._velocity_wanted = function (self, ladder_unit, unit, duration)
	local enter_end_node = Unit.has_node(ladder_unit, LADDER_ENTER_END_NODE) and Unit.node(ladder_unit, LADDER_ENTER_END_NODE)
	local top_node = Unit.node(ladder_unit, LADDER_TOP_NODE)
	local exit_pos = Unit.world_position(ladder_unit, enter_end_node or top_node)
	local ladder_bwd_dir = -Quaternion.forward(Unit.world_rotation(ladder_unit, 1))
	local mover = Unit.mover(unit)
	local radius = Mover.radius(mover)
	local final_position = exit_pos + ladder_bwd_dir * radius
	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local player_pos = locomotion_position
	local travel_vector = final_position - player_pos
	local travel_length = Vector3.length(travel_vector)
	local travel_speed = travel_length / duration

	return ladder_bwd_dir * travel_speed
end

PlayerCharacterStateLadderTopEntering.on_exit = function (self, unit, t, next_state)
	local ladder_character_state_component = self._ladder_character_state_component

	if next_state and next_state ~= "ladder_climbing" then
		ForceRotation.stop(self._locomotion_force_rotation_component)
		self._animation_extension:anim_event("climb_end_ladder")

		local game_session = Managers.state.game_session:game_session()
		local ladder_cooldown = self._constants.ladder_cooldown

		Ladder.stopped_climbing(ladder_character_state_component, ladder_cooldown, self._is_server, game_session, self._game_object_id, self._player, unit)

		local inventory_component = self._inventory_component

		if next_state ~= "dead" and inventory_component.wielded_slot == "slot_unarmed" then
			PlayerUnitVisualLoadout.wield_previous_slot(inventory_component, unit, t)
		end
	end

	ForceTranslation.stop(self._locomotion_force_translation_component)

	if next_state and next_state == "ladder_climbing" then
		local leave_position = ladder_character_state_component.end_position

		PlayerMovement.teleport_fixed_update(unit, leave_position)
	end
end

PlayerCharacterStateLadderTopEntering.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local next_state = self:_check_transition(t, next_state_params)

	return next_state
end

PlayerCharacterStateLadderTopEntering._check_transition = function (self, t, next_state_params)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	if t >= self._ladder_character_state_component.top_enter_leave_timer then
		local ladder_unit = Managers.state.unit_spawner:unit(self._ladder_character_state_component.ladder_unit_id, true)

		next_state_params.ladder_unit = ladder_unit

		return "ladder_climbing"
	end

	return nil
end

return PlayerCharacterStateLadderTopEntering
