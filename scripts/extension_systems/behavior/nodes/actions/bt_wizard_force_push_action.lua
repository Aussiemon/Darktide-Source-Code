-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_wizard_force_push_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local BossPhaseUtilities = require("scripts/utilities/phases/boss_phase_utilities")
local BtWizardForcePushAction = class("BtWizardForcePushAction", "BtNode")
local Vo = require("scripts/utilities/vo")
local _reset_wave_data, _update_shockwave

BtWizardForcePushAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local boss_extension = ScriptUnit.extension(unit, "boss_system")

	scratchpad.wave_data = {
		wave_id = 0,
	}
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.boss_position = Vector3Box(Unit.world_position(unit, 1))
	scratchpad.boss_handler = boss_extension:get_boss_handler()

	_reset_wave_data(t, scratchpad.wave_data, action_data)
end

BtWizardForcePushAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	return
end

BtWizardForcePushAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	_update_shockwave(t, scratchpad, scratchpad.boss_handler, scratchpad.wave_data, action_data, scratchpad.animation_extension, scratchpad.boss_position, unit, breed)

	return "running"
end

local name = "renegade_wizard_hazard_indicator_warp"
local INDICATOR_DURATION_FIELD = "indicator_duration"

function _update_shockwave(t, scratchpad, boss_handler, wave_data, action_data, animation_extension, boss_position, unit, breed)
	local wave_ended = t > wave_data.end_t
	local anim_should_start = t > wave_data.anim_start_t
	local vo_should_start = t > wave_data.vo_start_t

	if not wave_data.anim_started and anim_should_start then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(action_data.wwise_event, boss_position)
		animation_extension:anim_event(wave_data.anim_event)

		local indicator_duration = wave_data.end_t - t
		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		if game_object_id and GameSession.game_object_exists(game_session, game_object_id) then
			GameSession.set_game_object_field(game_session, game_object_id, INDICATOR_DURATION_FIELD, indicator_duration)
		end

		BossPhaseUtilities.setup_hazard_indicator_vfx(scratchpad, name, wave_data.end_t, unit, t)

		wave_data.anim_started = true
	end

	if not wave_data.vo_started and vo_should_start then
		local vo_event = action_data.vo_event

		if vo_event and action_data.vo_event_chance > math.random() then
			Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
		end

		wave_data.vo_started = true
	end

	if t > wave_data.start_t and not wave_data.wave_started then
		local args_table = boss_handler:get_phase_event_args_table()

		args_table.wave_id = wave_data.wave_id

		boss_handler:on_phase_event_triggered("start_shockwave", args_table)

		wave_data.wave_started = true
	end

	local stop_vfx

	if wave_ended then
		stop_vfx = true

		_reset_wave_data(t, wave_data, action_data)
	end

	BossPhaseUtilities.update_hazard_indicator_vfx(scratchpad, t, stop_vfx)
end

local WIND_DOWN_TIME = 0.8

function _reset_wave_data(t, wave_data, action_data)
	wave_data.wave_id = math.index_wrapper(wave_data.wave_id + 1, #action_data.wave_parameters)

	local wave_parameters = action_data.wave_parameters[wave_data.wave_id]
	local windup_time = Managers.state.difficulty:get_table_entry_by_challenge(wave_parameters.windup_time)

	wave_data.anim_start_t = t + windup_time
	wave_data.start_t = wave_data.anim_start_t + action_data.damage_timing
	wave_data.end_t = wave_data.start_t + wave_parameters.travel_time + WIND_DOWN_TIME
	wave_data.anim_event = wave_parameters.anim_event
	wave_data.vo_start_t = wave_data.anim_start_t - 1
	wave_data.anim_started = false
	wave_data.wave_started = false
	wave_data.vo_started = false
end

return BtWizardForcePushAction
