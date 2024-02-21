require("scripts/extension_systems/behavior/nodes/bt_node")

local Explosion = require("scripts/utilities/attack/explosion")
local BtChaosPoxwalkerExplodeAction = class("BtChaosPoxwalkerExplodeAction", "BtNode")

BtChaosPoxwalkerExplodeAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local explode_position_node = action_data.explode_position_node
	local position = Unit.world_position(unit, Unit.node(unit, explode_position_node))
	local spawn_component = blackboard.spawn
	local world = spawn_component.world
	local physics_world = spawn_component.physics_world
	local impact_normal = Vector3.up()
	local charge_level = 1
	local attack_type = nil
	local power_level = Managers.state.difficulty:get_minion_attack_power_level(breed)
	local explosion_template = action_data.explosion_template
	local optional_attacking_unit_owner_unit = nil
	local optional_apply_owner_buffs = false
	local death_component = blackboard.death

	if death_component.staggered_during_lunge then
		local stagger_component = blackboard.stagger
		optional_attacking_unit_owner_unit = ALIVE[stagger_component.attacker_unit] and stagger_component.attacker_unit
	elseif death_component.damage_profile_name ~= nil and death_component.damage_profile_name ~= "default" then
		local health_extension = ScriptUnit.extension(unit, "health_system")
		optional_attacking_unit_owner_unit = health_extension:last_damaging_unit()
	end

	Explosion.create_explosion(world, physics_world, position, impact_normal, unit, explosion_template, power_level, charge_level, attack_type, false, nil, nil, nil, nil, optional_attacking_unit_owner_unit, optional_apply_owner_buffs)
end

BtChaosPoxwalkerExplodeAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	return "done"
end

return BtChaosPoxwalkerExplodeAction
