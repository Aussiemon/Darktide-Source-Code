require("scripts/extension_systems/behavior/nodes/bt_node")

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Explosion = require("scripts/utilities/attack/explosion")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local PlayerAssistNotifications = require("scripts/utilities/player_assist_notifications")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local BtChaosHoundTargetPouncedAction = class("BtChaosHoundTargetPouncedAction", "BtNode")

BtChaosHoundTargetPouncedAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.move_state = "attacking"
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.animation_extension = animation_extension
	scratchpad.locomotion_extension = locomotion_extension
	local pounce_component = Blackboard.write_component(blackboard, "pounce")
	scratchpad.pounce_component = pounce_component
	local pounce_target = pounce_component.pounce_target
	scratchpad.pounce_target = pounce_target
	local override_velocity_z = 0

	locomotion_extension:set_affected_by_gravity(false, override_velocity_z)

	scratchpad.start_position_boxed = Vector3Box(POSITION_LOOKUP[unit])
	scratchpad.lerp_position_duration = t + action_data.lerp_position_time
	local hit_unit_data_extension = ScriptUnit.extension(pounce_target, "unit_data_system")
	local hit_unit_breed_name = hit_unit_data_extension:breed().name
	local pounce_anim_event = action_data.pounce_anim_event[hit_unit_breed_name]

	animation_extension:anim_event(pounce_anim_event)

	local target_unit_data_extension = ScriptUnit.extension(pounce_target, "unit_data_system")
	local disabled_state_input = target_unit_data_extension:write_component("disabled_state_input")
	disabled_state_input.wants_disable = true
	disabled_state_input.disabling_unit = unit
	disabled_state_input.disabling_type = "pounced"
	scratchpad.attempting_pounce = true
	scratchpad.disabled_character_state_component = target_unit_data_extension:read_component("disabled_character_state")
	scratchpad.disabled_state_input_component = disabled_state_input
	local record_state_component = Blackboard.write_component(blackboard, "record_state")
	scratchpad.record_state_component = record_state_component

	self:_damage_target(scratchpad, unit, action_data, action_data.impact_power_level)

	local explosion_template = action_data.enter_explosion_template

	if explosion_template then
		local explosion_power_level = action_data.explosion_power_level
		local power_level = explosion_power_level
		local charge_level = 1
		local explosion_attack_type = AttackSettings.attack_types.explosion
		local up = Quaternion.up(Unit.local_rotation(unit, 1))
		local explosion_position = POSITION_LOOKUP[unit] + up * 0.1
		local spawn_component = blackboard.spawn
		local physics_world = spawn_component.physics_world
		local world = spawn_component.world

		Explosion.create_explosion(world, physics_world, explosion_position, up, unit, explosion_template, power_level, charge_level, explosion_attack_type)
	end
end

BtChaosHoundTargetPouncedAction._pounce_achieved = function (self, scratchpad, action_data, t)
	local pounce_target = scratchpad.pounce_target
	scratchpad.next_damage_t = t + action_data.damage_start_time

	Managers.state.pacing:add_tension_type("pounced", pounce_target)

	local record_state_component = scratchpad.record_state_component
	local is_player_unit = Managers.state.player_unit_spawn:is_player_unit(pounce_target)

	if is_player_unit then
		record_state_component.has_disabled_player = true
	end
end

BtChaosHoundTargetPouncedAction.init_values = function (self, blackboard)
	local pounce_component = Blackboard.write_component(blackboard, "pounce")
	pounce_component.pounce_target = nil
	pounce_component.pounce_cooldown = 0
	pounce_component.started_leap = false
	local record_state_component = Blackboard.write_component(blackboard, "record_state")
	record_state_component.has_disabled_player = false
end

BtChaosHoundTargetPouncedAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local pounce_component = scratchpad.pounce_component

	if ALIVE[pounce_component.pounce_target] then
		scratchpad.disabled_state_input_component.disabling_unit = nil
	end

	pounce_component.pounce_target = nil
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_gravity(nil)
	locomotion_extension:set_check_falling(true)

	local cooldown = Managers.state.difficulty:get_table_entry_by_challenge(MinionDifficultySettings.cooldowns.chaos_hound_pounce)
	pounce_component.pounce_cooldown = t + cooldown
end

BtChaosHoundTargetPouncedAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.attempting_pounce then
		local disabled_character_state_component = scratchpad.disabled_character_state_component
		local is_pounced, pouncing_unit = PlayerUnitStatus.is_pounced(disabled_character_state_component)
		local success = is_pounced and pouncing_unit == unit

		if success then
			scratchpad.attempting_pounce = false

			self:_pounce_achieved(scratchpad, action_data, t)
		else
			local disabled_state_input_component = scratchpad.disabled_state_input_component
			local attempting_pounce = disabled_state_input_component.wants_disable
			local pouncing_unit_is_me = unit == disabled_state_input_component.disabling_unit
			local failed = not attempting_pounce or not pouncing_unit_is_me

			if failed then
				return "failed"
			else
				return "running"
			end
		end
	end

	if scratchpad.next_damage_t < t then
		self:_damage_target(scratchpad, unit, action_data, action_data.power_level)

		scratchpad.next_damage_t = t + action_data.damage_frequency
	end

	local mover = Unit.mover(unit)

	if mover then
		if t < scratchpad.lerp_position_duration then
			local lerp_position_time = action_data.lerp_position_time
			local pounce_target_position = POSITION_LOOKUP[scratchpad.pounce_target]
			local start_position = scratchpad.start_position_boxed:unbox()
			local time_left = scratchpad.lerp_position_duration - t
			local percentage = 1 - time_left / lerp_position_time
			local new_position = Vector3.lerp(start_position, pounce_target_position, percentage)

			Mover.set_position(mover, new_position)
		else
			local pounce_target_position = POSITION_LOOKUP[scratchpad.pounce_target]

			Mover.set_position(mover, pounce_target_position)
		end
	end

	scratchpad.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))

	if self:_target_incapacitated(scratchpad) then
		return "done"
	end

	return "running"
end

BtChaosHoundTargetPouncedAction._target_incapacitated = function (self, scratchpad)
	local pounce_target = scratchpad.pounce_target
	local unit_data_extension = ScriptUnit.extension(pounce_target, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local target_state = character_state_component.state_name

	return target_state == "dead" or target_state == "knocked_down"
end

BtChaosHoundTargetPouncedAction._damage_target = function (self, scratchpad, unit, action_data, power_level_table)
	local pounce_target = scratchpad.pounce_target
	local damage_profile = action_data.damage_profile
	local damage_type = action_data.damage_type
	local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table)
	local attack_type = AttackSettings.attack_types.melee
	local jaw_node = Unit.node(unit, action_data.hit_position_node)
	local hit_position = Unit.world_position(unit, jaw_node)

	Attack.execute(pounce_target, damage_profile, "power_level", power_level, "hit_world_position", hit_position, "attack_type", attack_type, "attacking_unit", unit, "damage_type", damage_type)
end

return BtChaosHoundTargetPouncedAction
