-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_die_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MinionDeath = require("scripts/utilities/minion_death")
local NavQueries = require("scripts/utilities/nav_queries")
local Vo = require("scripts/utilities/vo")
local BtDieAction = class("BtDieAction", "BtNode")

BtDieAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local death_component = Blackboard.write_component(blackboard, "death")

	scratchpad.death_component = death_component
	scratchpad.do_ragdoll_push = true

	local damage_profile_name = death_component.damage_profile_name
	local damage_profile = DamageProfileTemplates[damage_profile_name] or DamageProfileTemplates.default
	local instant_ragdoll_chance_allowed = not damage_profile.ignore_instant_ragdoll_chance
	local instant_ragdoll_chance = instant_ragdoll_chance_allowed and action_data.instant_ragdoll_chance
	local instant_ragdoll = instant_ragdoll_chance and instant_ragdoll_chance > math.random()
	local force_instant_ragdoll = death_component.force_instant_ragdoll

	if instant_ragdoll or force_instant_ragdoll or self:_check_if_need_to_ragdoll(unit) then
		scratchpad.ragdoll_timing = t
		scratchpad.instant_ragdoll = true

		return
	end

	if action_data.remove_linked_decals then
		Managers.state.decal:remove_linked_decals(unit)
	end

	local death_animation_events
	local death_animations = action_data.death_animations

	if not damage_profile.ragdoll_only and death_animations or action_data.force_death_animation then
		local killing_damage_type = death_component.killing_damage_type

		if killing_damage_type and death_animations[killing_damage_type] then
			death_animation_events = death_animations[killing_damage_type]
		end

		if not death_animation_events then
			local hit_zone_name = death_component.hit_zone_name
			local death_animation_identifier = hit_zone_name or "default"

			death_animation_events = death_animations[death_animation_identifier]
		end
	end

	if death_animation_events then
		local death_animation_event = Animation.random_event(death_animation_events)
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(death_animation_event)

		local ragdoll_timings = action_data.ragdoll_timings
		local ragdoll_timing = ragdoll_timings[death_animation_event]

		scratchpad.ragdoll_timing = t + ragdoll_timing
		scratchpad.do_ragdoll_push = false

		local death_animation_vo = action_data.death_animation_vo and action_data.death_animation_vo[death_animation_event]

		if death_animation_vo then
			Vo.enemy_generic_vo_event(unit, death_animation_vo, breed.name)
		end
	else
		scratchpad.ragdoll_timing = t
		scratchpad.instant_ragdoll = true
	end
end

BtDieAction.init_values = function (self, blackboard)
	local death_component = Blackboard.write_component(blackboard, "death")

	death_component.attack_direction:store(0, 0, 0)

	death_component.hit_zone_name = ""
	death_component.is_dead = false
	death_component.hit_during_death = false
	death_component.damage_profile_name = ""
	death_component.herding_template_name = ""
	death_component.killing_damage_type = ""
	death_component.force_instant_ragdoll = false
end

BtDieAction._set_dead = function (self, unit, scratchpad, breed, action_data, blackboard)
	local death_component = scratchpad.death_component
	local attack_direction = death_component.attack_direction:unbox()
	local hit_zone_name = death_component.hit_zone_name
	local damage_profile_name = death_component.damage_profile_name
	local herding_template_name = death_component.herding_template_name
	local do_ragdoll_push = scratchpad.do_ragdoll_push

	if hit_zone_name == "shield" then
		hit_zone_name = "torso"
	end

	MinionDeath.set_dead(unit, attack_direction, hit_zone_name, damage_profile_name, do_ragdoll_push, herding_template_name)

	if scratchpad.instant_ragdoll and breed.has_direct_ragdoll_flow_event then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_flow_event(unit, "direct_ragdoll_death")
	end
end

local SHOOTING_RANGE_GAME_MODE_NAME = "shooting_range"

BtDieAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local ragdoll_timing = scratchpad.ragdoll_timing

	if ragdoll_timing <= t then
		local game_mode_name = Managers.state.game_mode:game_mode_name()
		local game_mode_shooting_range = game_mode_name == SHOOTING_RANGE_GAME_MODE_NAME

		if game_mode_shooting_range and not scratchpad.waited_one_frame then
			scratchpad.waited_one_frame = true

			return "running"
		end

		self:_set_dead(unit, scratchpad, breed, action_data, blackboard)
	else
		local death_component = scratchpad.death_component
		local hit_during_death = death_component.hit_during_death

		if hit_during_death and not action_data.ignore_hit_during_death_ragdoll then
			scratchpad.do_ragdoll_push = true

			self:_set_dead(unit, scratchpad, breed, action_data, blackboard)

			death_component.hit_during_death = false
		end
	end

	return "running"
end

local NAV_MESH_ABOVE, NAV_MESH_BELOW = 0.1, 0.1
local CHECK_OFFSET = 1

BtDieAction._check_if_need_to_ragdoll = function (self, unit)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local nav_world = navigation_extension:nav_world()
	local position = POSITION_LOOKUP[unit]
	local rotation = Unit.local_rotation(unit, 1)
	local fwd = Quaternion.forward(rotation)
	local bwd = -fwd
	local right = Quaternion.right(rotation)
	local left = -right
	local check_position = position + bwd * CHECK_OFFSET
	local navmesh_position = NavQueries.position_on_mesh(nav_world, check_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

	if not navmesh_position then
		return true
	end

	check_position = position + left * CHECK_OFFSET
	navmesh_position = NavQueries.position_on_mesh(nav_world, check_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

	if not navmesh_position then
		return true
	end

	check_position = position + right * CHECK_OFFSET
	navmesh_position = NavQueries.position_on_mesh(nav_world, check_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

	if not navmesh_position then
		return true
	end

	check_position = position + fwd * CHECK_OFFSET
	navmesh_position = NavQueries.position_on_mesh(nav_world, check_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

	if not navmesh_position then
		return true
	end

	return false
end

return BtDieAction
