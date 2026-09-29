-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_wizard_boss_circle_dance_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BossPhaseUtilities = require("scripts/utilities/phases/boss_phase_utilities")
local Vo = require("scripts/utilities/vo")
local BtWizardBossCircleDanceAction = class("BtWizardBossCircleDanceAction", "BtNode")

BtWizardBossCircleDanceAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local boss_extension = ScriptUnit.extension(unit, "boss_system")
	local boss_handler = boss_extension:get_boss_handler()

	scratchpad.boss_handler = boss_handler

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]

	scratchpad.side = side
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")

	self:_queue_animation(action_data, scratchpad, unit, t)
	boss_handler:on_phase_event_triggered("init_floor_zones")
	boss_handler:on_phase_event_triggered("set_new_zone")
	boss_handler:on_phase_event_triggered("spawn_dance_walls")
end

BtWizardBossCircleDanceAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	BossPhaseUtilities.update_hazard_indicator_vfx(scratchpad, t, true)
end

BtWizardBossCircleDanceAction.init_values = function (self, blackboard, action_data, node_data)
	local abilites_component = Blackboard.write_component(blackboard, "abilites")

	abilites_component.current_ability = ""

	abilites_component.ability_position:store(0, 0, 0)
	abilites_component.default_look_at_position:store(0, 0, 0)
end

local name = "renegade_wizard_hazard_indicator"

BtWizardBossCircleDanceAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if t > scratchpad.delay and not scratchpad.anim_started then
		scratchpad.animation_extension:anim_event(scratchpad.event)

		local wwise_event = action_data.wwise_event
		local wwise_position = HEALTH_ALIVE[unit] and POSITION_LOOKUP[unit]

		if wwise_event and wwise_position then
			scratchpad.fx_system:trigger_wwise_event(wwise_event, wwise_position)
		end

		scratchpad.anim_started = true

		local vo_event = action_data.vo_event

		if vo_event then
			Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
		end
	end

	if t > scratchpad.anim_duration then
		self:_queue_animation(action_data, scratchpad, unit, t)
	end

	BossPhaseUtilities.update_hazard_indicator_vfx(scratchpad, t)

	return "running"
end

BtWizardBossCircleDanceAction._queue_animation = function (self, action_data, scratchpad, unit, t)
	scratchpad.delay, scratchpad.attack_timing, scratchpad.attack_duration, scratchpad.anim_duration, scratchpad.event = BossPhaseUtilities.get_spillway_psyker_dance_variables(action_data, t)
	scratchpad.anim_started = false

	BossPhaseUtilities.setup_hazard_indicator_vfx(scratchpad, name, scratchpad.attack_timing, unit, t)
end

return BtWizardBossCircleDanceAction
