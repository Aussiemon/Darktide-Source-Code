-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_flamer_check_backpack_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Explosion = require("scripts/utilities/attack/explosion")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local BtFlamerCheckBackpackAction = class("BtFlamerCheckBackpackAction", "BtNode")

BtFlamerCheckBackpackAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	return
end

BtFlamerCheckBackpackAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	return "done"
end

return BtFlamerCheckBackpackAction
