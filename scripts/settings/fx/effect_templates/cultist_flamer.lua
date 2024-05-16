-- chunkname: @scripts/settings/fx/effect_templates/cultist_flamer.lua

local CultistFlamerSettings = require("scripts/settings/specials/cultist_flamer_settings")
local Flamer = require("scripts/utilities/flamer")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local STATES = CultistFlamerSettings.states
local vfx = CultistFlamerSettings.vfx
local sfx = CultistFlamerSettings.sfx
local _switch_state, _get_state_and_aim_position, _get_control_positions, _get_attachment_unit_and_node_index
local resources = {
	resources_vfx = vfx,
	resources_sfx = sfx,
}
local effect_template = {
	name = "cultist_flamer",
	resources = resources,
	start = function (template_data, template_context)
		local world = template_context.world
		local physics_world = World.physics_world(world)

		template_data.physics_world = physics_world

		local unit = template_data.unit
		local game_session, game_object_id = Managers.state.game_session:game_session(), Managers.state.unit_spawner:game_object_id(unit)

		template_data.game_session, template_data.game_object_id = game_session, game_object_id

		local state, _ = _get_state_and_aim_position(game_session, game_object_id)
		local inventory_slot = CultistFlamerSettings.inventory_slot
		local fx_source_name = CultistFlamerSettings.fx_source_name
		local attachment_unit, source_node_index = _get_attachment_unit_and_node_index(unit, inventory_slot, fx_source_name)

		template_data.flamer_data = {
			from_unit = attachment_unit,
			from_node = source_node_index,
			radius = CultistFlamerSettings.radius,
			range = CultistFlamerSettings.range,
			set_muzzle_as_control_point_1 = CultistFlamerSettings.set_muzzle_as_control_point_1,
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
			local flamer_data = template_data.flamer_data

			Flamer.update_shooting_fx(t, unit, vfx, sfx, wwise_world, world, physics_world, aim_position, control_point_1, control_point_2, flamer_data)
		end
	end,
	stop = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local flamer_data = template_data.flamer_data
		local world = template_context.world
		local unit = template_data.unit

		Flamer.stop_fx(unit, vfx, sfx, wwise_world, world, flamer_data)
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

function _get_attachment_unit_and_node_index(unit, slot_name, fx_node_name)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local inventory_item = visual_loadout_extension:slot_item(slot_name)
	local attachment_unit, source_node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, fx_node_name)

	return attachment_unit, source_node_index
end

function _switch_state(previous_state, new_state, template_data, template_context)
	local wwise_world = template_context.wwise_world
	local world = template_context.world
	local unit = template_data.unit

	if previous_state == STATES.shooting then
		Flamer.stop_fx(unit, vfx, sfx, wwise_world, world, template_data.flamer_data)
	end

	if new_state == STATES.aiming then
		local t = Managers.time:time("gameplay")

		Flamer.start_aiming_fx(t, unit, vfx, sfx, wwise_world, world, template_data.flamer_data)
	elseif new_state == STATES.shooting then
		local t = Managers.time:time("gameplay")

		Flamer.start_shooting_fx(t, unit, vfx, sfx, wwise_world, world, template_data.flamer_data)
	end

	template_data.state = new_state
end

return effect_template
