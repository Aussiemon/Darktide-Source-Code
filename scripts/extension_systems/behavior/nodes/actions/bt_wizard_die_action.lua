-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_wizard_die_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local MinionDeath = require("scripts/utilities/minion_death")
local NavQueries = require("scripts/utilities/nav_queries")
local Vo = require("scripts/utilities/vo")
local BtWizardDieAction = class("BtWizardDieAction", "BtNode")

BtWizardDieAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local death_component = Blackboard.write_component(blackboard, "death")

	scratchpad.death_component = death_component
	scratchpad.do_ragdoll_push = true
end

BtWizardDieAction.init_values = function (self, blackboard)
	local death_component = Blackboard.write_component(blackboard, "death")

	death_component.attack_direction:store(0, 0, 0)

	death_component.hit_zone_name = ""
	death_component.is_dead = false
	death_component.hit_during_death = false
	death_component.damage_profile_name = ""
	death_component.herding_template_name = ""
	death_component.killing_damage_type = ""
	death_component.force_instant_ragdoll = false

	local has_gib_override = Blackboard.has_component(blackboard, "gib_override")

	if has_gib_override then
		local gib_override_component = Blackboard.write_component(blackboard, "gib_override")

		gib_override_component.should_override = false
		gib_override_component.target_template = ""
		gib_override_component.override_hit_zone_name = ""
	end
end

BtWizardDieAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	return "running"
end

return BtWizardDieAction
