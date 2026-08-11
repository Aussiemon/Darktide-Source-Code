-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_hack_decode_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local BtHackDecodeAction = class("BtHackDecodeAction", "BtNode")

BtHackDecodeAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local target_unit = behavior_component.target_unit
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")

	scratchpad.target_unit = target_unit

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	scratchpad.locomotion_extension = locomotion_extension

	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
	local _, hacking_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(target_unit)

	GameSession.set_game_object_field(game_session, game_object_id, "hacking_unit_id", hacking_unit_id)

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system

	local targeting_rotation_node_unit_position = Unit.world_position(target_unit, Unit.node(target_unit, "targeting_rotation_node"))
	local target_unit_position = Unit.world_position(target_unit, Unit.node(target_unit, "targeting_node"))
	local unit_position_node_index = action_data.optional_unit_position_node and Unit.node(unit, action_data.optional_unit_position_node) or 1
	local unit_position = Unit.world_position(unit, unit_position_node_index)
	local target_unit_rotation = Unit.world_rotation(target_unit, 1)
	local forward_vector = Vector3.normalize(Quaternion.forward(target_unit_rotation))
	local target_position = target_unit_position + forward_vector * 0.5
	local target_rotation = Quaternion.look(targeting_rotation_node_unit_position - unit_position, Vector3.up())
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local owner_player = player_unit_spawn_manager and player_unit_spawn_manager:owner(unit)

	scratchpad.owner_player = owner_player
	scratchpad.behavior_component = behavior_component
	scratchpad.animation_extension = animation_extension
	scratchpad.interactee_extension = interactee_extension
	scratchpad.game_session = game_session
	scratchpad.game_object_id = game_object_id

	local move_effect_template = action_data.move_effect_template

	if move_effect_template then
		scratchpad.move_effect_id = self:_start_effect_template(unit, scratchpad, move_effect_template)
	end

	behavior_component.max_speed = 10
	behavior_component.has_move_to_position = true

	behavior_component.move_to_position:store(target_position)

	behavior_component.has_target_rotation = true

	behavior_component.target_rotation:store(target_rotation)

	local in_rotation_speed = action_data.in_rotation_speed

	locomotion_extension:set_rotation_speed(in_rotation_speed)
end

BtHackDecodeAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local target_unit = scratchpad.target_unit
	local interactee_extension = scratchpad.interactee_extension
	local interactee_interaction_type = interactee_extension:interaction_type()

	if not scratchpad._hack_time and not interactee_extension:can_interact(target_unit, interactee_interaction_type) then
		return "done"
	end

	local behavior_component = scratchpad.behavior_component
	local move_to_position = behavior_component.move_to_position:unbox()
	local unit_position_node_index = action_data.optional_unit_position_node and Unit.node(unit, action_data.optional_unit_position_node) or 1
	local unit_position = Unit.world_position(unit, unit_position_node_index)
	local targeting_rotation_node_unit_position = Unit.world_position(target_unit, Unit.node(target_unit, "targeting_rotation_node"))
	local target_rotation = Quaternion.look(targeting_rotation_node_unit_position - unit_position, Vector3.up())

	behavior_component.target_rotation:store(target_rotation)

	local distance_sq = Vector3.distance_squared(unit_position, move_to_position)

	if not scratchpad._hack_time and distance_sq < action_data.distance_threshold_sq then
		local hacking_start_animation = action_data.hacking_start_animation

		if hacking_start_animation then
			scratchpad.animation_extension:anim_event(hacking_start_animation)
		end

		local minigame_extension = ScriptUnit.has_extension(scratchpad.target_unit, "minigame_system")
		local minigame = minigame_extension:minigame()
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager and player_unit_spawn_manager:owner(unit)
		local minigame_type = minigame_extension:minigame_type()
		local automatic_duration = self:minigame_time(minigame_type, action_data)

		minigame:automatic_minigame_set_up(automatic_duration)
		minigame:start(player, true)

		scratchpad._distance_reached = true
		scratchpad._hack_time = t + automatic_duration
		scratchpad.minigame = minigame

		local hacking_effect_template_name = action_data.hacking_effect_template_name

		if hacking_effect_template_name then
			scratchpad.hacking_effect_id = self:_start_effect_template(unit, scratchpad, hacking_effect_template_name)
		end

		scratchpad._automatic_duration = automatic_duration
		scratchpad._start_time = t

		return "running"
	end

	local minigame = scratchpad.minigame

	if minigame then
		if minigame:automatic_minigame_complete_manually() and scratchpad._hack_time and t >= scratchpad._hack_time then
			minigame:set_state(MinigameSettings.game_states.complete)

			local is_automatic = true

			minigame:stop(is_automatic)
			minigame:automatic_minigame_on_stop()

			local owner_player = scratchpad.owner_player

			if owner_player then
				Managers.stats:record_private("hook_cryptic_servo_skull_hacking_completed", owner_player)
			end

			return "done"
		end

		if minigame:is_completed() then
			local is_automatic = true

			minigame:stop(is_automatic)
			minigame:automatic_minigame_on_stop()

			local owner_player = scratchpad.owner_player

			if owner_player then
				Managers.stats:record_private("hook_cryptic_servo_skull_hacking_completed", owner_player)
			end

			return "done"
		end
	end

	return "running"
end

BtHackDecodeAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local move_effect_id = scratchpad.move_effect_id

	self:_stop_effect_template(unit, scratchpad, move_effect_id)

	local hacking_effect_id = scratchpad.hacking_effect_id

	self:_stop_effect_template(unit, scratchpad, hacking_effect_id)

	local out_rotation_speed = action_data.out_rotation_speed

	scratchpad.locomotion_extension:set_rotation_speed(out_rotation_speed)

	local hacking_stop_animation = action_data.hacking_stop_animation

	if hacking_stop_animation then
		scratchpad.animation_extension:anim_event(hacking_stop_animation)
	end

	local minigame = scratchpad.minigame

	if minigame and not minigame:is_completed() then
		local is_automatic = true

		minigame:stop(is_automatic)
		minigame:automatic_minigame_on_stop()
	end

	local optional_leave_function = action_data.optional_leave_function

	if optional_leave_function then
		optional_leave_function(unit)
	end

	local behavior_component = scratchpad.behavior_component

	behavior_component.max_speed = 10
	behavior_component.has_move_to_position = false
	behavior_component.has_target_rotation = false

	local game_session = scratchpad.game_session
	local game_object_id = scratchpad.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "hacking_unit_id", -1)
end

BtHackDecodeAction.minigame_time = function (self, minigame_type, action_data)
	local hacking_minigame_duration = action_data.hacking_minigame_duration
	local duration = hacking_minigame_duration[minigame_type]

	if not duration then
		return hacking_minigame_duration.default
	end

	return duration
end

BtHackDecodeAction._start_effect_template = function (self, unit, scratchpad, effect_template_name)
	local effect_template = EffectTemplates[effect_template_name]
	local fx_system = scratchpad.fx_system
	local effect_id = fx_system:start_template_effect(effect_template, unit)

	return effect_id
end

BtHackDecodeAction._stop_effect_template = function (self, unit, scratchpad, effect_id)
	if effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(effect_id)
	end
end

return BtHackDecodeAction
