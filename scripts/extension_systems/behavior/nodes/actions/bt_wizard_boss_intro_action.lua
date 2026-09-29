-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_wizard_boss_intro_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Vo = require("scripts/utilities/vo")
local BtWizardBossIntroAction = class("BtWizardBossIntroAction", "BtNode")

BtWizardBossIntroAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	local events = action_data.anim_events
	local event = Animation.random_event(events)
	local intro_duration = action_data.anim_duration[event]

	scratchpad.intro_duration = intro_duration + t

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(event)
end

BtWizardBossIntroAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local abilites_component = Blackboard.write_component(blackboard, "abilites")

	abilites_component.current_ability = ""

	local boss_extension = ScriptUnit.extension(unit, "boss_system")

	boss_extension:start_boss_encounter()

	local spawn_component = blackboard.spawn
	local game_object_id = spawn_component.game_object_id

	Managers.state.game_session:send_rpc_clients("rpc_start_boss_encounter", game_object_id)
end

BtWizardBossIntroAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	self:_rotate_towards_target(unit, breed, blackboard, scratchpad, action_data, dt, t)

	if t > scratchpad.intro_duration then
		return "done"
	end

	return "running"
end

BtWizardBossIntroAction._rotate_towards_target = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local flat_rotation
	local look_at_position = blackboard.abilites.default_look_at_position:unbox()

	if look_at_position then
		local position = POSITION_LOOKUP[unit]
		local to_last_los_position = Vector3.normalize(Vector3.flat(look_at_position - position))

		flat_rotation = Quaternion.look(to_last_los_position)
	end

	if flat_rotation then
		local locomotion_extension = scratchpad.locomotion_extension

		locomotion_extension:set_wanted_rotation(flat_rotation)
	end
end

return BtWizardBossIntroAction
