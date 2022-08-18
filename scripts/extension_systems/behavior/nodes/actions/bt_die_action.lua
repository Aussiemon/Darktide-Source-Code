require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MinionDeath = require("scripts/utilities/minion_death")
local Vo = require("scripts/utilities/vo")
local BtDieAction = class("BtDieAction", "BtNode")

BtDieAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local death_component = Blackboard.write_component(blackboard, "death")
	scratchpad.death_component = death_component
	scratchpad.do_ragdoll_push = true
	local damage_profile_name = death_component.damage_profile_name
	local damage_profile = DamageProfileTemplates[damage_profile_name]
	local instant_ragdoll_chance_allowed = not damage_profile.ignore_instant_ragdoll_chance
	local instant_ragdoll_chance = instant_ragdoll_chance_allowed and action_data.instant_ragdoll_chance
	local instant_ragdoll = instant_ragdoll_chance and math.random() < instant_ragdoll_chance
	local force_instant_ragdoll = death_component.force_instant_ragdoll

	if instant_ragdoll or force_instant_ragdoll then
		scratchpad.ragdoll_timing = t
		scratchpad.instant_ragdoll = true

		return
	end

	if action_data.remove_linked_decals then
		Managers.state.decal:remove_linked_decals(unit)
	end

	local death_animation_events = nil
	local death_animations = action_data.death_animations

	if not damage_profile.ragdoll_only and death_animations then
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
		local death_animations_with_vo = action_data.death_animations_with_vo

		if death_animations_with_vo and death_animations_with_vo[death_animation_event] then
			Vo.enemy_generic_vo_event(unit, action_data.vo_event, breed.name)
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

BtDieAction._set_dead = function (self, unit, scratchpad, breed)
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

BtDieAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local ragdoll_timing = scratchpad.ragdoll_timing

	if ragdoll_timing <= t then
		self:_set_dead(unit, scratchpad, breed)
	else
		local death_component = scratchpad.death_component
		local hit_during_death = death_component.hit_during_death

		if hit_during_death then
			scratchpad.do_ragdoll_push = true

			self:_set_dead(unit, scratchpad, breed)

			death_component.hit_during_death = false
		end
	end

	return "running"
end

return BtDieAction
