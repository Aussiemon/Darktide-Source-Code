-- chunkname: @scripts/settings/fx/effect_templates/chaos_beast_of_nurgle_vomit.lua

local ChaosBeastOfNurgleSettings = require("scripts/settings/monster/chaos_beast_of_nurgle_settings")
local Flamer = require("scripts/utilities/flamer")
local STATES = ChaosBeastOfNurgleSettings.states
local vfx = ChaosBeastOfNurgleSettings.vfx
local sfx = ChaosBeastOfNurgleSettings.sfx
local _switch_state, _get_state_and_aim_position, _get_control_positions
local resources = {
	resources_vfx = vfx,
	resources_sfx = sfx,
}
local effect_template = {
	name = "chaos_beast_of_nurgle_vomit",
	resources = resources,
	start = function (template_data, template_context)
		local world = template_context.world
		local physics_world = World.physics_world(world)

		template_data.physics_world = physics_world

		local unit = template_data.unit
		local game_session, game_object_id = Managers.state.game_session:game_session(), Managers.state.unit_spawner:game_object_id(unit)

		template_data.game_session, template_data.game_object_id = game_session, game_object_id

		local state, _ = _get_state_and_aim_position(game_session, game_object_id)
		local from_node = Unit.node(unit, ChaosBeastOfNurgleSettings.from_node)

		template_data.data = {
			from_unit = unit,
			from_node = from_node,
			radius = ChaosBeastOfNurgleSettings.radius,
			range = ChaosBeastOfNurgleSettings.range,
		}

		_switch_state(nil, state, template_data, template_context)
	end,
	update = function (template_data, template_context, dt, t)
		local game_session, game_object_id = template_data.game_session, template_data.game_object_id
		local wanted_state, aim_position = _get_state_and_aim_position(game_session, game_object_id)
		local control_point_1, control_point_2 = _get_control_positions(game_session, game_object_id)
		local previous_state = template_data.state

		if previous_state ~= wanted_state then
			_switch_state(previous_state, wanted_state, template_data, template_context)
		end

		local current_state = template_data.state

		if current_state == STATES.shooting then
			local wwise_world = template_context.wwise_world
			local world = template_context.world
			local unit = template_data.unit
			local physics_world = template_data.physics_world
			local data = template_data.data

			Flamer.update_shooting_fx(t, unit, vfx, sfx, wwise_world, world, physics_world, aim_position, control_point_1, control_point_2, data)
		end
	end,
	stop = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local data = template_data.data
		local world = template_context.world
		local unit = template_data.unit

		Flamer.stop_fx(unit, vfx, sfx, wwise_world, world, data)
	end,
}

function _get_state_and_aim_position(game_session, game_object_id)
	local state = GameSession.game_object_field(game_session, game_object_id, "state")
	local aim_position = GameSession.game_object_field(game_session, game_object_id, "aim_position")

	return state, aim_position
end

function _get_control_positions(game_session, game_object_id)
	local control_point_1 = GameSession.game_object_field(game_session, game_object_id, "control_point_1")
	local control_point_2 = GameSession.game_object_field(game_session, game_object_id, "control_point_2")

	return control_point_1, control_point_2
end

function _switch_state(previous_state, new_state, template_data, template_context)
	local wwise_world = template_context.wwise_world
	local world = template_context.world
	local unit = template_data.unit

	if previous_state == STATES.shooting then
		Flamer.stop_fx(unit, vfx, sfx, wwise_world, world, template_data.data)
	end

	if new_state == STATES.aiming then
		local t = Managers.time:time("gameplay")

		Flamer.start_aiming_fx(t, unit, vfx, sfx, wwise_world, world, template_data.data)
	elseif new_state == STATES.shooting then
		local t = Managers.time:time("gameplay")

		Flamer.start_shooting_fx(t, unit, vfx, sfx, wwise_world, world, template_data.data)
	end

	template_data.state = new_state
end

return effect_template
