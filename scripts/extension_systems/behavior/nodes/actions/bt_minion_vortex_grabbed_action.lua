-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_minion_vortex_grabbed_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local NavQueries = require("scripts/utilities/nav_queries")
local Vo = require("scripts/utilities/vo")
local BASE_LAYER_EMPTY_EVENT = "base_layer_to_empty"
local BtMinionVortexGrabbedAction = class("BtMinionVortexGrabbedAction", "BtNode")
local VORTEX_STATES = table.enum("in_vortex_init", "ejected_from_vortex", "in_vortex", "waiting_to_land", "landed")

BtMinionVortexGrabbedAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	if behavior_component.move_state ~= "idle" then
		local events = action_data.anim_events.loop
		local event = Animation.random_event(events)
		local animation_extension = ScriptUnit.has_extension(unit, "animation_system") and ScriptUnit.extension(unit, "animation_system")

		if animation_extension then
			animation_extension:anim_event(BASE_LAYER_EMPTY_EVENT)
			animation_extension:anim_event(event)
		end

		behavior_component.move_state = "idle"
	end

	local vortex_grabbed_component = Blackboard.write_component(blackboard, "vortex_grabbed")

	scratchpad.vortex_grabbed_component = vortex_grabbed_component
	vortex_grabbed_component.in_vortex_state = VORTEX_STATES.in_vortex_init

	if ScriptUnit.has_extension(unit, "perception_system") then
		local perception_component = blackboard.perception

		scratchpad.perception_component = perception_component
		scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

		local vo_event = action_data.vo_event

		if vo_event and perception_component.aggro_state == "passive" then
			Vo.enemy_vo_event(unit, vo_event)
		end
	end

	local breed_vortex_settings = breed.vortex_settings

	scratchpad.breed_vortex_settings = breed_vortex_settings

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	navigation_extension:set_enabled(false)

	local nav_world = navigation_extension:nav_world()

	scratchpad.nav_world = nav_world

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	scratchpad.locomotion_extension = locomotion_extension

	locomotion_extension:set_movement_type("script_driven")
	locomotion_extension:set_wanted_rotation(nil)

	local death_component = Blackboard.write_component(blackboard, "death")

	death_component.force_instant_ragdoll = true

	if ScriptUnit.has_extension(unit, "shield_system") then
		local shield_extension = ScriptUnit.extension(unit, "shield_system")

		shield_extension:set_blocking(false)
	end

	vortex_grabbed_component.landing_finished = false
end

BtMinionVortexGrabbedAction.init_values = function (self, blackboard)
	return
end

BtMinionVortexGrabbedAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if not destroy then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	if HEALTH_ALIVE[unit] and not destroy then
		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

		locomotion_extension:set_movement_type("snap_to_navmesh")
		locomotion_extension:set_affected_by_gravity(false)

		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

		navigation_extension:set_enabled(true, breed.run_speed)
		navigation_extension:stop()

		if ScriptUnit.has_extension(unit, "shield_system") then
			local shield_extension = ScriptUnit.extension(unit, "shield_system")

			shield_extension:set_blocking(true)
		end

		local perception_component = scratchpad.perception_component

		if perception_component and perception_component.lock_target then
			MinionPerception.set_target_lock(unit, perception_component, false)
		end

		MinionPerception.attempt_alert(scratchpad.perception_extension, unit)

		local animation_extension = ScriptUnit.has_extension(unit, "animation_system") and ScriptUnit.extension(unit, "animation_system")

		if animation_extension then
			animation_extension:anim_event("vortex_finished")
			animation_extension:anim_event("idle")

			local behavior_component = Blackboard.write_component(blackboard, "behavior")

			behavior_component.move_state = "idle"
		end
	end

	local vortex_grabbed_component = Blackboard.write_component(blackboard, "vortex_grabbed")

	vortex_grabbed_component.in_vortex = false
	vortex_grabbed_component.in_vortex_state = ""

	local death_component = Blackboard.write_component(blackboard, "death")

	death_component.force_instant_ragdoll = false
end

BtMinionVortexGrabbedAction.land = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	return
end

BtMinionVortexGrabbedAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local vortex_grabbed_component = scratchpad.vortex_grabbed_component
	local state = vortex_grabbed_component.in_vortex_state
	local breed_vortex_settings = scratchpad.breed_vortex_settings

	if not action_data.ignore_rotate_towards_target then
		MinionMovement.rotate_towards_target_unit(unit, scratchpad)
	end

	if state == VORTEX_STATES.waiting_to_land and scratchpad.waited_frame and not scratchpad.t_until_exit then
		scratchpad.t_until_exit = t + scratchpad.landing_animation_duration
	end

	if state == VORTEX_STATES.in_vortex_init then
		local landing_anims = action_data.anim_events.loop
		local anim_event = Animation.random_event(landing_anims)

		animation_extension:anim_event(anim_event)

		vortex_grabbed_component.in_vortex_state = VORTEX_STATES.in_vortex
	elseif state == VORTEX_STATES.ejected_from_vortex then
		local velocity = vortex_grabbed_component.ejected_from_vortex:unbox()

		velocity = velocity - Vector3(0, 0, 9.82) * dt

		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

		locomotion_extension:set_wanted_velocity(velocity)
		locomotion_extension:set_affected_by_gravity(true, velocity.z)
		vortex_grabbed_component.ejected_from_vortex:store(velocity)

		local mover = Unit.mover(unit)
		local mover_collides_down = Mover.collides_down(mover)

		if mover_collides_down then
			velocity = velocity - Vector3.normalize(velocity) * dt

			vortex_grabbed_component.ejected_from_vortex:store(velocity)

			local nav_world = scratchpad.nav_world
			local position = POSITION_LOOKUP[unit]
			local nav_position = NavQueries.position_on_mesh(nav_world, position, 1, 1)

			if nav_position == nil then
				local vertical_range = 1
				local horizontal_tolerance = 1
				local distance_from_obstacle = 1.5

				nav_position = GwNavQueries.inside_position_from_outside_position(nav_world, position, vertical_range, vertical_range, horizontal_tolerance, distance_from_obstacle)

				if nav_position == nil then
					local damage_profile = DamageProfileTemplates.default

					Attack.execute(unit, damage_profile, "instakill", true, "hit_world_position", Unit.world_position(unit, 1))

					return "failed"
				end
			end

			Unit.set_local_position(unit, 1, nav_position)

			local landing_anims = action_data.anim_events.landing
			local anim_event = Animation.random_event(landing_anims)

			if not breed_vortex_settings.die_on_vortex_land then
				animation_extension:anim_event(anim_event)
			end

			scratchpad.landing_animation_duration = action_data.anim_durations[anim_event]
			vortex_grabbed_component.in_vortex_state = VORTEX_STATES.waiting_to_land
			vortex_grabbed_component.landing_finished = true

			MinionMovement.set_anim_driven(scratchpad, true)

			scratchpad.waited_frame = true
		end
	elseif state == VORTEX_STATES.waiting_to_land then
		local t_until_exit = scratchpad.t_until_exit

		if not breed_vortex_settings.die_on_vortex_land and vortex_grabbed_component.landing_finished and t_until_exit and t < t_until_exit then
			local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

			locomotion_extension:set_wanted_velocity(Vector3.zero())

			vortex_grabbed_component.in_vortex_state = VORTEX_STATES.landed
			vortex_grabbed_component.landing_finished = true

			return "done"
		elseif breed_vortex_settings.die_on_vortex_land then
			local damage_profile = DamageProfileTemplates.default

			Attack.execute(unit, damage_profile, "instakill", true, "hit_world_position", Unit.world_position(unit, 1))
		end
	end

	return "running"
end

return BtMinionVortexGrabbedAction
