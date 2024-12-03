-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_flamer_check_backpack_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Explosion = require("scripts/utilities/attack/explosion")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local BtFlamerCheckBackpackAction = class("BtFlamerCheckBackpackAction", "BtNode")
local _override_gib

BtFlamerCheckBackpackAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local statistics_component = Blackboard.write_component(blackboard, "statistics")
	local position = POSITION_LOOKUP[unit]
	local spawn_component = blackboard.spawn
	local world, physics_world = spawn_component.world, spawn_component.physics_world
	local impact_normal, charge_level = Vector3.up(), 1
	local explosion_attack_type = AttackSettings.attack_types.explosion
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local nav_world = navigation_extension:nav_world()

	if statistics_component.flamer_backpack_impacts > 0 and statistics_component.flamer_backpack_impacts < 4 then
		_override_gib(blackboard)

		local explosion_template = action_data.interrupted_explosion_template

		Explosion.create_explosion(world, physics_world, position, impact_normal, unit, explosion_template, 100, charge_level, explosion_attack_type, false, false, false, false)
		LiquidArea.try_create(position, Vector3.down(), nav_world, LiquidAreaTemplates[action_data.interrupted_liquid_area])
	elseif statistics_component.flamer_backpack_impacts >= 4 then
		_override_gib(blackboard)

		local explosion_template = action_data.explosion_template

		Explosion.create_explosion(world, physics_world, position, impact_normal, unit, explosion_template, 100, charge_level, explosion_attack_type, false, false, false, false)
		LiquidArea.try_create(position, Vector3.down(), nav_world, LiquidAreaTemplates[action_data.liquid_area])
	end
end

BtFlamerCheckBackpackAction.init_values = function (self, blackboard, action_data, node_data)
	local statistics_component = Blackboard.write_component(blackboard, "statistics")

	statistics_component.flamer_backpack_impacts = 0
end

BtFlamerCheckBackpackAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	return "done"
end

function _override_gib(blackboard)
	local gib_override_component = Blackboard.write_component(blackboard, "gib_override")

	gib_override_component.should_override = true
	gib_override_component.target_template = "flamer_backpack_explosion"
	gib_override_component.override_hit_zone_name = "center_mass"
end

return BtFlamerCheckBackpackAction
