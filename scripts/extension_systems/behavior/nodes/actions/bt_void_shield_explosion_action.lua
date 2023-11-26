-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_void_shield_explosion_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Vo = require("scripts/utilities/vo")
local BtVoidShieldExplosionAction = class("BtVoidShieldExplosionAction", "BtNode")

BtVoidShieldExplosionAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_state = "attacking"
	scratchpad.fx_system = Managers.state.extension:system("fx_system")

	self:_start_attack(t, unit, scratchpad, action_data)
	Vo.enemy_generic_vo_event(unit, "taunt_combat", breed.name)
end

BtVoidShieldExplosionAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	self:_stop_effect_template(scratchpad)
end

BtVoidShieldExplosionAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if state == "attacking" then
		self:_update_attacking(t, unit, scratchpad, action_data)
	elseif state == "done" then
		return "done"
	end

	return "running"
end

BtVoidShieldExplosionAction._start_attack = function (self, t, unit, scratchpad, action_data)
	local attack_anim_events = action_data.attack_anim_events
	local attack_event = Animation.random_event(attack_anim_events)
	local attack_anim_damage_timings = action_data.attack_anim_damage_timings
	local attack_damage_timing = attack_anim_damage_timings[attack_event]
	local attack_damage_t = t + attack_damage_timing

	scratchpad.attack_damage_t = attack_damage_t

	local attack_anim_durations = action_data.attack_anim_durations
	local attack_duration = attack_anim_durations[attack_event]
	local attack_duration_t = t + attack_duration

	scratchpad.attack_duration_t = attack_duration_t

	local animation_extension = scratchpad.animation_extension

	animation_extension:anim_event(attack_event)

	scratchpad.state = "attacking"
end

BtVoidShieldExplosionAction._update_attacking = function (self, t, unit, scratchpad, action_data)
	local attack_duration_t = scratchpad.attack_duration_t

	if attack_duration_t < t then
		scratchpad.state = "done"
	elseif not scratchpad.has_dealt_damage then
		local attack_damage_t = scratchpad.attack_damage_t

		if attack_damage_t < t then
			self:_start_effect_template(unit, scratchpad, action_data)
			self:_deal_damage(t, unit, action_data)

			scratchpad.has_dealt_damage = true
		end
	end
end

BtVoidShieldExplosionAction._deal_damage = function (self, t, unit, action_data)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local relation = action_data.relation or "enemy"
	local target_side_names = side:relation_side_names(relation)
	local damage_profile = action_data.damage_profile
	local power_level = action_data.power_level
	local hit_zone_name = action_data.hit_zone_name
	local damage_type = action_data.damage_type
	local from = POSITION_LOOKUP[unit]
	local broadphase_radius = action_data.radius
	local broadphase_results = Managers.frame_table:get_table()
	local num_results = broadphase.query(broadphase, from, broadphase_radius, broadphase_results, target_side_names)
	local ALIVE = ALIVE

	for i = 1, num_results do
		local hit_unit = broadphase_results[i]

		if ALIVE[hit_unit] and hit_unit ~= unit then
			local to = POSITION_LOOKUP[hit_unit]
			local direction = Vector3.normalize(to - from)

			Attack.execute(hit_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_direction", direction, "hit_zone_name", hit_zone_name, "damage_type", damage_type)

			local fx_extension = ScriptUnit.has_extension(hit_unit, "fx_system")

			if fx_extension and fx_extension.spawn_particles then
				local hit_effect = action_data.hit_effect
				local position = Vector3(0, 0, 1)

				fx_extension:spawn_particles(hit_effect, position)
			end
		end
	end
end

BtVoidShieldExplosionAction._start_effect_template = function (self, unit, scratchpad, action_data)
	local effect_template = action_data.effect_template
	local fx_system = scratchpad.fx_system
	local global_effect_id = fx_system:start_template_effect(effect_template, unit)

	scratchpad.global_effect_id = global_effect_id
end

BtVoidShieldExplosionAction._stop_effect_template = function (self, scratchpad)
	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end
end

return BtVoidShieldExplosionAction
