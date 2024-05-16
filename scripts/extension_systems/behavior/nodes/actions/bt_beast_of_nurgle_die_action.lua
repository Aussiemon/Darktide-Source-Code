-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_beast_of_nurgle_die_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Explosion = require("scripts/utilities/attack/explosion")
local MinionDeath = require("scripts/utilities/minion_death")
local Vo = require("scripts/utilities/vo")
local BtBeastOfNurgleDieAction = class("BtBeastOfNurgleDieAction", "BtNode")

BtBeastOfNurgleDieAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local death_component = Blackboard.write_component(blackboard, "death")

	scratchpad.death_component = death_component

	local explosion_timing = action_data.explosion_timing

	if explosion_timing then
		scratchpad.explosion_timing = t + explosion_timing
	end

	if action_data.remove_linked_decals then
		Managers.state.decal:remove_linked_decals(unit)
	end

	local death_animations = action_data.death_animations
	local death_animation_events

	if not death_animation_events then
		local hit_zone_name = death_component.hit_zone_name
		local death_animation_identifier = hit_zone_name and death_animations[hit_zone_name] or "default"

		death_animation_events = death_animations[death_animation_identifier]
	end

	local death_animation_event = Animation.random_event(death_animation_events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(death_animation_event)

	local death_timing = action_data.death_timings[death_animation_event]

	scratchpad.death_t = t + death_timing

	local death_animation_vo = action_data.death_animation_vo and action_data.death_animation_vo[death_animation_event]

	if death_animation_vo then
		Vo.enemy_generic_vo_event(unit, death_animation_vo, breed.name)
	end
end

BtBeastOfNurgleDieAction.init_values = function (self, blackboard)
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

BtBeastOfNurgleDieAction._set_dead = function (self, unit, scratchpad, breed, action_data, blackboard)
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

	local specific_gib_settings = action_data.specific_gib_settings

	if specific_gib_settings then
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local damage_profile = specific_gib_settings.damage_profile
		local random_radius = specific_gib_settings.random_radius
		local hit_zones = specific_gib_settings.hit_zones

		for i = 1, #hit_zones do
			local x = math.random() * 2 - 1
			local y = math.random() * 2 - 1
			local random_offset = Vector3(x * random_radius, y * random_radius, 1)
			local direction = Vector3.normalize(random_offset)
			local gib_hit_zone = hit_zones[i]

			visual_loadout_extension:gib(gib_hit_zone, direction, damage_profile)
		end
	end
end

BtBeastOfNurgleDieAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local explosion_timing = scratchpad.explosion_timing

	if explosion_timing and explosion_timing <= t then
		self:_explode(unit, action_data, blackboard)

		scratchpad.explosion_timing = nil
	end

	local death_t = scratchpad.death_t

	if death_t <= t then
		self:_set_dead(unit, scratchpad, breed, action_data, blackboard)
	else
		local death_component = scratchpad.death_component
		local hit_during_death = death_component.hit_during_death

		if hit_during_death and not action_data.ignore_hit_during_death_ragdoll then
			self:_set_dead(unit, scratchpad, breed, action_data, blackboard)

			death_component.hit_during_death = false
		end
	end

	return "running"
end

BtBeastOfNurgleDieAction._explode = function (self, unit, action_data, blackboard)
	local explode_position_node = action_data.explode_position_node
	local position = Unit.world_position(unit, Unit.node(unit, explode_position_node))
	local spawn_component = blackboard.spawn
	local world, physics_world = spawn_component.world, spawn_component.physics_world
	local impact_normal, charge_level, attack_type = Vector3.up(), 1
	local power_level = action_data.explosion_template_power_level
	local explosion_template = action_data.explosion_template

	Explosion.create_explosion(world, physics_world, position, impact_normal, unit, explosion_template, power_level, charge_level, attack_type)
end

return BtBeastOfNurgleDieAction
