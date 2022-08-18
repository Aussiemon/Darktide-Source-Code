local MinionPerception = {
	attempt_alert = function (perception_extension, enemy_unit)
		local use_action_controlled_alert = perception_extension:use_action_controlled_alert()

		if use_action_controlled_alert then
			return
		end

		perception_extension:alert(enemy_unit)
	end,
	attempt_aggro = function (perception_extension)
		local use_action_controlled_alert = perception_extension:use_action_controlled_alert()

		if use_action_controlled_alert then
			return
		end

		perception_extension:aggro()
	end,
	set_target_lock = function (unit, perception_component, should_lock)
		fassert(should_lock ~= perception_component.lock_target, "[MinionPerception] Tried to lock/unlock twice!")

		perception_component.lock_target = should_lock

		if not should_lock then
			local perception_system = Managers.state.extension:system("perception_system")

			perception_system:register_prioritized_unit_update(unit)
		end
	end,
	target_unit = function (game_session, game_object_id)
		local target_unit_id = GameSession.game_object_field(game_session, game_object_id, "target_unit_id")
		local target_unit = Managers.state.unit_spawner:unit(target_unit_id)

		return target_unit
	end,
	evaluate_multi_target_switch = function (unit, scratchpad, t, multi_target_config, is_target_locked)
		local duration_between_switches = multi_target_config.duration_between_switches

		if duration_between_switches then
			local last_changed_t = scratchpad.multi_target_changed_t

			if last_changed_t and t < last_changed_t + duration_between_switches then
				return
			end
		end

		local max_switches = multi_target_config.max_switches

		if max_switches then
			local num_target_switches = scratchpad.num_multi_target_switches

			if num_target_switches and max_switches <= num_target_switches then
				return
			end
		end

		if is_target_locked then
			MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
		end

		scratchpad.perception_extension:force_new_target_attempt(multi_target_config.force_new_target_attempt_config)

		scratchpad.attempting_multi_target_switch = true
	end,
	switched_multi_target_unit = function (scratchpad, t, multi_target_config)
		scratchpad.multi_target_changed_t = t
		scratchpad.num_multi_target_switches = (scratchpad.num_multi_target_switches or 0) + 1
		local rotation_speed = multi_target_config.rotation_speed

		if rotation_speed then
			scratchpad.locomotion_extension:set_rotation_speed(rotation_speed)
		end
	end,
	line_of_sight_positions = function (unit, target_unit, from_node, to_node)
		local los_node = Unit.node(unit, from_node)
		local los_to_node = Unit.node(target_unit, to_node)
		local los_from_position = Unit.world_position(unit, los_node)
		local los_to_position = Unit.world_position(target_unit, los_to_node)

		return los_from_position, los_to_position
	end
}

return MinionPerception
