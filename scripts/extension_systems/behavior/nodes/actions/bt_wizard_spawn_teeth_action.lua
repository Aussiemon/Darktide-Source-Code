-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_wizard_spawn_teeth_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BossPhaseUtilities = require("scripts/utilities/phases/boss_phase_utilities")
local Vo = require("scripts/utilities/vo")
local BtWizardSpawnTeethAction = class("BtWizardSpawnTeethAction", "BtNode")
local TEMP = {}
local name = "renegade_wizard_hazard_indicator"

BtWizardSpawnTeethAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local num_shot = action_data.num_shot

	scratchpad.num_shot = num_shot

	local delay = action_data.delay_between_shots

	scratchpad.delay_t_shot = delay + t
	scratchpad.num_spawned = 0

	local boss_extension = ScriptUnit.extension(unit, "boss_system")
	local boss_handler = boss_extension:get_boss_handler()

	scratchpad.boss_handler = boss_handler

	local channeling_animation = action_data.channeling_animation
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(channeling_animation)
	BossPhaseUtilities.setup_hazard_indicator_vfx(scratchpad, name, t + 99, unit, t)

	local position = blackboard.abilites.ability_position:unbox()
	local offset_positions = BossPhaseUtilities.get_valid_positions_around_target(unit, position, 8, 12, 9)

	for i = 1, #offset_positions do
		TEMP[#TEMP + 1] = Vector3Box(offset_positions[i])
	end

	scratchpad.offset_positions = TEMP

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
	end
end

BtWizardSpawnTeethAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local abilites_component = Blackboard.write_component(blackboard, "abilites")

	abilites_component.current_ability = ""

	abilites_component.ability_position:store(0, 0, 0)
	BossPhaseUtilities.update_hazard_indicator_vfx(scratchpad, t, true)
	scratchpad.boss_handler:on_phase_event_triggered("all_teeth_spawned")
end

BtWizardSpawnTeethAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	BossPhaseUtilities.update_hazard_indicator_vfx(scratchpad, t)

	if t > scratchpad.delay_t_shot and scratchpad.num_spawned < action_data.num_shot then
		scratchpad.num_spawned = scratchpad.num_spawned + 1
		scratchpad.delay_t_shot = action_data.delay_between_shots + t

		local boss_handler = scratchpad.boss_handler
		local args_table = boss_handler:get_phase_event_args_table()

		args_table.tooth_position = scratchpad.offset_positions[scratchpad.num_spawned]:unbox()

		boss_handler:on_phase_event_triggered("spawn_tooth", args_table)
	end

	if scratchpad.num_spawned >= scratchpad.num_shot then
		if not scratchpad.anim_duration then
			local exit_animation = action_data.exit_channeling_animation
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:anim_event(exit_animation)

			scratchpad.anim_duration = action_data.anim_duration + t
		end

		if t > scratchpad.anim_duration then
			return "done"
		end
	end

	return "running"
end

return BtWizardSpawnTeethAction
