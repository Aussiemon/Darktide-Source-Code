-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_chaos_daemonhost_warp_grab_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Vo = require("scripts/utilities/vo")
local BtChaosDaemonhostWarpGrabAction = class("BtChaosDaemonhostWarpGrabAction", "BtNode")

BtChaosDaemonhostWarpGrabAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn

	scratchpad.physics_world = spawn_component.physics_world
	scratchpad.spawn_component = spawn_component

	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local perception_component = Blackboard.write_component(blackboard, "perception")

	behavior_component.move_state = "attacking"
	scratchpad.behavior_component = behavior_component
	scratchpad.perception_component = perception_component
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	MinionPerception.set_target_lock(unit, perception_component, true)

	scratchpad.aim_target_node = breed.aim_config.target_node
	scratchpad.fx_system = Managers.state.extension:system("fx_system")

	self:_start_charging_projectile(scratchpad, action_data, t)

	if action_data.vo_event then
		local breed_name = breed.name

		Vo.enemy_generic_vo_event(unit, action_data.vo_event, breed_name)
	end
end

BtChaosDaemonhostWarpGrabAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit

	if HEALTH_ALIVE[target_unit] and scratchpad.hit_unit_disabled_state_input then
		local disabled_state_input = scratchpad.hit_unit_disabled_state_input

		disabled_state_input.disabling_unit = nil

		local game_session = scratchpad.spawn_component.game_session
		local target_unit_unit_game_object_id = Managers.state.unit_spawner:game_object_id(target_unit)

		GameSession.set_game_object_field(game_session, target_unit_unit_game_object_id, "warp_grabbed_execution_time", NetworkConstants.max_fixed_frame_time)
	end

	self:_stop_effect_template(scratchpad)
	MinionPerception.set_target_lock(unit, perception_component, false)
end

BtChaosDaemonhostWarpGrabAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if state == "charging_projectile" then
		self:_update_charging_projectile(unit, t, scratchpad, action_data)
	elseif state == "channeling" then
		self:_update_channeling(unit, t, scratchpad, action_data)
	elseif state == "executing" then
		self:_update_executing(unit, t, scratchpad, action_data)
	elseif state == "done" then
		return "done"
	end

	return "running"
end

BtChaosDaemonhostWarpGrabAction._start_charging_projectile = function (self, scratchpad, action_data, t)
	local shoot_event = action_data.shoot_anim_event

	scratchpad.animation_extension:anim_event(shoot_event)

	scratchpad.state = "charging_projectile"

	local fire_timing = action_data.fire_timing

	scratchpad.fire_timing = t + fire_timing
end

BtChaosDaemonhostWarpGrabAction._update_charging_projectile = function (self, unit, t, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_wanted_rotation(flat_rotation)

	if t > scratchpad.fire_timing then
		self:_start_channeling(unit, t, scratchpad, action_data, target_unit)
	end
end

BtChaosDaemonhostWarpGrabAction._start_channeling = function (self, unit, t, scratchpad, action_data, hit_unit)
	local hit_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
	local disabled_state_input = hit_unit_data_extension:write_component("disabled_state_input")

	disabled_state_input.wants_disable = true
	disabled_state_input.disabling_unit = unit
	disabled_state_input.disabling_type = "warp_grabbed"
	scratchpad.hit_unit_disabled_state_input = disabled_state_input
	scratchpad.hit_unit = hit_unit

	local disabled_character_state_component = hit_unit_data_extension:read_component("disabled_character_state")

	scratchpad.hit_unit_disabled_character_state_component = disabled_character_state_component

	local channel_anim_event = action_data.channel_anim_event

	scratchpad.animation_extension:anim_event(channel_anim_event)

	scratchpad.start_execute_t = t + Managers.state.difficulty:get_table_entry_by_challenge(action_data.start_execute_at_t)
	scratchpad.state = "channeling"

	self:_start_effect_template(unit, scratchpad, action_data)
end

BtChaosDaemonhostWarpGrabAction._update_channeling = function (self, unit, t, scratchpad, action_data)
	local disabled_character_state_component = scratchpad.hit_unit_disabled_character_state_component
	local is_warp_grabbed, warp_grabbing_unit = PlayerUnitStatus.is_warp_grabbed(disabled_character_state_component)

	if not is_warp_grabbed then
		return
	end

	if warp_grabbing_unit ~= unit then
		scratchpad.state = "done"

		return
	end

	local start_execute_t = scratchpad.start_execute_t

	if start_execute_t and start_execute_t < t then
		self:_start_executing(t, scratchpad, action_data)

		return
	end
end

BtChaosDaemonhostWarpGrabAction._start_executing = function (self, t, scratchpad, action_data)
	local execute_anim_event = action_data.execute_anim_event

	scratchpad.animation_extension:anim_event(execute_anim_event)

	local disabled_state_input = scratchpad.hit_unit_disabled_state_input

	disabled_state_input.trigger_animation = "grabbed_execution"

	local execute_at_t = t + action_data.execute_timing

	scratchpad.state = "executing"
	scratchpad.execute_at_t = execute_at_t
	scratchpad.execute_duration = t + action_data.execute_duration

	local hit_unit = scratchpad.hit_unit
	local game_session = scratchpad.spawn_component.game_session
	local hit_unit_game_object_id = Managers.state.unit_spawner:game_object_id(hit_unit)

	GameSession.set_game_object_field(game_session, hit_unit_game_object_id, "warp_grabbed_execution_time", execute_at_t)
end

BtChaosDaemonhostWarpGrabAction._update_executing = function (self, unit, t, scratchpad, action_data)
	local execute_at_t = scratchpad.execute_at_t

	if execute_at_t and execute_at_t <= t then
		self:_execute(scratchpad, unit, action_data)

		scratchpad.execute_at_t = nil

		self:_stop_effect_template(scratchpad)
	end

	if t >= scratchpad.execute_duration then
		scratchpad.state = "done"
	end
end

BtChaosDaemonhostWarpGrabAction._execute = function (self, scratchpad, unit, action_data)
	local hit_unit = scratchpad.hit_unit
	local damage_profile = action_data.damage_profile
	local power_level = action_data.power_level
	local aim_target_node = scratchpad.aim_target_node
	local target_node = Unit.node(hit_unit, aim_target_node)
	local hit_position = Unit.world_position(hit_unit, target_node)
	local damage_type = action_data.damage_type

	Attack.execute(hit_unit, damage_profile, "power_level", power_level, "hit_world_position", hit_position, "attacking_unit", unit, "instakill", true, "damage_type", damage_type)
	Managers.state.pacing:add_tension_type("killed_by_daemonhost", hit_unit)

	local local_event_name = action_data.execute_event_name
	local husk_event_name = action_data.execute_husk_event_name
	local fx_extension = ScriptUnit.extension(hit_unit, "fx_system")

	fx_extension:trigger_wwise_events_local_and_husk(local_event_name, husk_event_name, nil, nil, nil, hit_position, nil, nil, nil, nil, nil)
end

BtChaosDaemonhostWarpGrabAction._start_effect_template = function (self, unit, scratchpad, action_data)
	local effect_template = action_data.effect_template
	local fx_system = scratchpad.fx_system
	local global_effect_id = fx_system:start_template_effect(effect_template, unit)

	scratchpad.global_effect_id = global_effect_id
end

BtChaosDaemonhostWarpGrabAction._stop_effect_template = function (self, scratchpad)
	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end
end

return BtChaosDaemonhostWarpGrabAction
