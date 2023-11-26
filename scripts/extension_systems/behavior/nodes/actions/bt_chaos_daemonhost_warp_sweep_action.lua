-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_chaos_daemonhost_warp_sweep_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local Suppression = require("scripts/utilities/attack/suppression")
local BtChaosDaemonhostWarpSweepAction = class("BtChaosDaemonhostWarpSweepAction", "BtNode")

BtChaosDaemonhostWarpSweepAction.init_values = function (self, blackboard, action_data, node_data)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.warp_sweep_cooldown = 0
end

BtChaosDaemonhostWarpSweepAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	navigation_extension:set_enabled(true, breed.run_speed)

	scratchpad.navigation_extension = navigation_extension

	local spawn_component = blackboard.spawn

	scratchpad.spawn_component = spawn_component
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.broadphase_config = breed.nearby_units_broadphase_config

	local effect_template = action_data.effect_template
	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.global_effect_id = fx_system:start_template_effect(effect_template, unit)
	scratchpad.fx_system = fx_system

	self:_start_attacking(scratchpad, action_data, t)
end

BtChaosDaemonhostWarpSweepAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_enabled(false)
	scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)

	local cooldown_duration = action_data.cooldown_duration

	if type(cooldown_duration) == "table" then
		cooldown_duration = math.random_range(cooldown_duration[1], cooldown_duration[2])
	end

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.warp_sweep_cooldown = t + cooldown_duration
end

BtChaosDaemonhostWarpSweepAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if state == "attacking" then
		self:_update_attacking(unit, action_data, scratchpad, t)
	elseif state == "done" then
		return "done"
	end

	return "running"
end

BtChaosDaemonhostWarpSweepAction._start_attacking = function (self, scratchpad, action_data, t)
	local animation_extension = scratchpad.animation_extension
	local attack_anim_events = action_data.attack_anim_events
	local anim_event = Animation.random_event(attack_anim_events)

	animation_extension:anim_event(anim_event)

	local attack_anim_durations = action_data.attack_anim_durations
	local anim_duration = attack_anim_durations[anim_event]

	scratchpad.attack_duration_t = t + anim_duration

	local attack_anim_damage_timings = action_data.attack_anim_damage_timings
	local anim_damage_timing = attack_anim_damage_timings[anim_event]

	scratchpad.attack_damage_t = t + anim_damage_timing

	local attack_move_speed = action_data.attack_move_speed
	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_max_speed(attack_move_speed)

	local behavior_component = scratchpad.behavior_component

	behavior_component.move_state = "attacking"
	scratchpad.state = "attacking"
end

BtChaosDaemonhostWarpSweepAction._update_attacking = function (self, unit, action_data, scratchpad, t)
	local has_dealt_damage = scratchpad.has_dealt_damage

	if not has_dealt_damage and t > scratchpad.attack_damage_t then
		self:_deal_damage(unit, action_data, scratchpad)
	end

	local attack_duration_t = scratchpad.attack_duration_t

	if attack_duration_t < t then
		scratchpad.state = "done"
	end
end

local BROADPHASE_RESULTS = {}

BtChaosDaemonhostWarpSweepAction._deal_damage = function (self, unit, action_data, scratchpad)
	scratchpad.has_dealt_damage = true

	local broadphase_config = scratchpad.broadphase_config
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local broadphase_relation = broadphase_config.relation
	local target_side_names = side:relation_side_names(broadphase_relation)
	local radius = broadphase_config.radius
	local from = POSITION_LOOKUP[unit]
	local num_results = broadphase.query(broadphase, from, radius, BROADPHASE_RESULTS, target_side_names)

	if num_results < 1 then
		return
	end

	local angle = broadphase_config.angle
	local rotation = Unit.world_rotation(unit, 1)
	local forward = Quaternion.forward(rotation)
	local hit_zone_name = action_data.hit_zone_name
	local power_level = action_data.power_level
	local damage_profile = action_data.damage_profile
	local damage_type = action_data.damage_type

	for i = 1, num_results do
		local hit_unit = BROADPHASE_RESULTS[i]

		if hit_unit ~= unit then
			local to = POSITION_LOOKUP[hit_unit]
			local direction = Vector3.normalize(to - from)
			local length_sq = Vector3.length_squared(direction)

			if length_sq ~= 0 then
				local angle_to_target = Vector3.angle(direction, forward)

				if angle_to_target < angle then
					local unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
					local breed = unit_data_extension:breed()

					if Breed.is_minion(breed) then
						local tags = breed.tags

						if not tags.monster then
							local damage, result, damage_efficiency = Attack.execute(hit_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_direction", direction, "hit_zone_name", hit_zone_name, "damage_type", damage_type)

							ImpactEffect.play(hit_unit, nil, damage, damage_type, nil, result, to, nil, direction, unit, nil, nil, nil, damage_efficiency, damage_profile)
						end
					end
				end
			end
		end
	end

	local suppression = action_data.suppression

	if suppression then
		local relation = "allied"

		Suppression.apply_area_minion_suppression(unit, suppression, from, relation)
	end
end

return BtChaosDaemonhostWarpSweepAction
