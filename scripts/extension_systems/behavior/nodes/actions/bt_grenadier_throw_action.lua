require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MasterItems = require("scripts/backend/master_items")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionPerception = require("scripts/utilities/minion_perception")
local Vo = require("scripts/utilities/vo")
local BtGrenadierThrowAction = class("BtGrenadierThrowAction", "BtNode")

BtGrenadierThrowAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.move_state = "attacking"
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.perception_component = perception_component
	scratchpad.throw_grenade_component = Blackboard.write_component(blackboard, "throw_grenade")

	MinionPerception.set_target_lock(unit, perception_component, true)
	self:_start_aiming(unit, t, scratchpad, action_data)

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
	end
end

BtGrenadierThrowAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.throw_timing and scratchpad.start_drop_grenade_timing and scratchpad.start_drop_grenade_timing <= t then
		local dt = Managers.time:delta_time("gameplay")
		local throw_config = action_data.throw_config
		local unit_node = Unit.node(unit, throw_config.unit_node)
		local throw_position = Unit.world_position(unit, unit_node)
		local throw_direction = Vector3.up()
		local delta_position = Unit.delta_position(unit, unit_node)
		local node_velocity = delta_position / dt

		self:_throw_grenade(unit, scratchpad, action_data, "drop", throw_position, throw_direction, blackboard, t, node_velocity)
	end

	if scratchpad.global_effect_id then
		self:_stop_effect_template(scratchpad)
	end

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
end

BtGrenadierThrowAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.throw_timing then
		self:_update_grenade_throwing(unit, t, blackboard, scratchpad, action_data)
	end

	local done = scratchpad.action_duration < t

	if done then
		return "done"
	end

	return "running"
end

BtGrenadierThrowAction._start_aiming = function (self, unit, t, scratchpad, action_data)
	local throw_anim_event = scratchpad.throw_grenade_component.anim_event
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(throw_anim_event)

	local throw_timing = action_data.throw_timings[throw_anim_event]
	scratchpad.throw_timing = t + throw_timing
	local action_duration = action_data.action_durations[throw_anim_event]
	scratchpad.action_duration = t + action_duration

	if action_data.start_drop_grenade_timing then
		local start_drop_grenade_timing = action_data.start_drop_grenade_timing[throw_anim_event]
		scratchpad.start_drop_grenade_timing = t + start_drop_grenade_timing
	end

	local effect_template = action_data.effect_template

	if effect_template then
		local effect_template_timings = action_data.effect_template_timings
		local effect_template_timing = effect_template_timings[throw_anim_event]
		scratchpad.effect_template_timing = t + effect_template_timing
		scratchpad.fx_system = Managers.state.extension:system("fx_system")
	end
end

BtGrenadierThrowAction._update_grenade_throwing = function (self, unit, t, blackboard, scratchpad, action_data)
	self:_aim_at_target(scratchpad)

	if scratchpad.effect_template_timing and scratchpad.effect_template_timing < t then
		local global_effect_id = scratchpad.fx_system:start_template_effect(action_data.effect_template, unit)
		scratchpad.global_effect_id = global_effect_id
		scratchpad.effect_template_timing = nil
	end

	if scratchpad.throw_timing < t then
		local throw_grenade_component = scratchpad.throw_grenade_component
		local throw_position = throw_grenade_component.throw_position:unbox()
		local throw_direction = throw_grenade_component.throw_direction:unbox()

		self:_throw_grenade(unit, scratchpad, action_data, "throw", throw_position, throw_direction, blackboard, t)

		scratchpad.throw_timing = nil

		self:_stop_effect_template(scratchpad)
	end
end

BtGrenadierThrowAction._throw_grenade = function (self, unit, scratchpad, action_data, throw_type, throw_position, throw_direction, blackboard, t, optional_owner_velocity)
	local throw_config = action_data.throw_config
	local projectile_template = throw_config.projectile_template
	local locomotion_template = projectile_template.locomotion_template
	local throw_parameters = locomotion_template.throw_parameters[throw_type]
	local speed = throw_parameters.speed_initial or throw_parameters.speed

	if optional_owner_velocity then
		local velocity = speed * throw_direction
		local inherit_owner_velocity_percentage = throw_parameters.inherit_owner_velocity_percentage
		local minion_velocity_contribution = optional_owner_velocity * inherit_owner_velocity_percentage
		local throw_velocity = minion_velocity_contribution + velocity
		throw_direction = Vector3.normalize(throw_velocity)
		speed = Vector3.length(throw_velocity)
	end

	local angular_velocity = nil

	if throw_parameters.randomized_angular_velocity then
		local max = throw_parameters.randomized_angular_velocity
		angular_velocity = Vector3(math.random() * max.x, math.random() * max.y, math.random() * max.z)
	elseif throw_parameters.initial_angular_velocity then
		angular_velocity = throw_parameters.initial_angular_velocity:unbox()
	else
		angular_velocity = Vector3.zero()
	end

	local item_name = throw_config.item
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local grenade_unit_name = item.base_unit
	local locomotion_state = throw_parameters.locomotion_state
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item_or_nil, fuse_override_time_or_nil = nil
	local owner_side = side and side:name()

	Managers.state.unit_spawner:spawn_network_unit(grenade_unit_name, "item_projectile", throw_position, nil, nil, item, projectile_template, locomotion_state, throw_direction, speed, angular_velocity, unit, is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item_or_nil, fuse_override_time_or_nil, owner_side)

	local throw_grenade_component = scratchpad.throw_grenade_component
	local cooldown = Managers.state.difficulty:get_table_entry_by_challenge(action_data.cooldown or MinionDifficultySettings.cooldowns.grenadier_throw)
	throw_grenade_component.next_throw_at_t = t + cooldown
end

BtGrenadierThrowAction._aim_at_target = function (self, scratchpad)
	local wanted_rotation = scratchpad.throw_grenade_component.wanted_rotation:unbox()

	scratchpad.locomotion_extension:set_wanted_rotation(wanted_rotation)
end

BtGrenadierThrowAction._stop_effect_template = function (self, scratchpad)
	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		scratchpad.fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end
end

return BtGrenadierThrowAction
