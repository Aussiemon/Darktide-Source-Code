local Flamer = require("scripts/utilities/flamer")
local FX_SOURCE_NAME = "j_spine"
local beam_particle_name = "content/fx/particles/enemies/linked_beam"
local beam_sound_event = "wwise/events/minions/play_minion_twins_void_shield_link"
local beam_stop_sound_event = "wwise/events/minions/stop_minion_twins_void_shield_link"
local recharge_particle_name = "content/fx/particles/enemies/twins/twins_shield_recharge"
local RADIUS = 2
local RANGE = 20
local resources = {
	beam_particle_name = beam_particle_name,
	beam_sound_event = beam_sound_event,
	beam_stop_sound_event = beam_stop_sound_event,
	recharge_particle_name = recharge_particle_name
}
local vfx = {
	flamer_velocity_variable_name = "velocity",
	flamer_particle = "content/fx/particles/enemies/linked_beam",
	num_parabola_control_points = 4
}
local sfx = {
	looping_sfx_start_event = "wwise/events/minions/play_minion_twins_void_shield_link",
	looping_sfx_stop_event = "wwise/events/minions/stop_minion_twins_void_shield_link"
}

local function _get_positions(unit, local_player_unit, template_data, game_session, game_object_id)
	local node_index = Unit.node(unit, FX_SOURCE_NAME)
	local source_pos = Unit.world_position(unit, node_index)
	local linked_object_id = GameSession.game_object_field(game_session, game_object_id, "linked_object_id")
	local linked_unit = Managers.state.unit_spawner:unit(linked_object_id)

	if not linked_unit then
		return
	end

	local linked_node_index = Unit.node(linked_unit, FX_SOURCE_NAME)
	local linked_beam_position = Unit.world_position(linked_unit, linked_node_index)
	local local_player_position = local_player_unit and Unit.local_position(local_player_unit, 1) or Vector3(0, 0, 0)
	local closest_point = Geometry.closest_point_on_line(local_player_position, source_pos, linked_beam_position)

	return closest_point, source_pos, linked_beam_position, linked_unit
end

local effect_template = {
	name = "linked_beam",
	resources = resources,
	start = function (template_data, template_context)
		local local_player = Managers.player:local_player(1)
		local local_player_unit = local_player and local_player.player_unit

		if DEDICATED_SERVER then
			return
		end

		local world = template_context.world
		local physics_world = World.physics_world(world)
		template_data.physics_world = physics_world
		local wwise_world = template_context.wwise_world
		local unit = template_data.unit
		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		template_data.game_object_id = game_object_id
		template_data.game_session = game_session
		local closest_point, source_pos, linked_beam_position, linked_unit = _get_positions(unit, local_player_unit, template_data, game_session, game_object_id)

		if not linked_unit then
			return
		end

		local from_node = Unit.node(unit, FX_SOURCE_NAME)
		template_data.data = {
			from_unit = linked_unit,
			from_node = from_node,
			radius = RADIUS,
			range = RANGE
		}
		local t = Managers.time:time("gameplay")

		Flamer.start_shooting_fx(t, unit, vfx, sfx, wwise_world, world, template_data.data)

		local recharge_particle_id = World.create_particles(world, recharge_particle_name, source_pos)
		template_data.recharge_particle_id = recharge_particle_id
	end,
	update = function (template_data, template_context, dt, t)
		local local_player = Managers.player:local_player(1)
		local local_player_unit = local_player and local_player.player_unit

		if not local_player_unit then
			return
		end

		local unit = template_data.unit
		local game_session = template_data.game_session
		local game_object_id = template_data.game_object_id
		local closest_point, source_pos, linked_beam_position, linked_unit = _get_positions(unit, local_player_unit, template_data, game_session, game_object_id)

		if not closest_point then
			return
		end

		local data = template_data.data
		local wwise_world = template_context.wwise_world
		local world = template_context.world

		if not data then
			local from_node = Unit.node(unit, FX_SOURCE_NAME)
			data = {
				from_unit = linked_unit,
				from_node = from_node,
				radius = RADIUS,
				range = RANGE
			}
			template_data.data = data

			Flamer.start_shooting_fx(t, unit, vfx, sfx, wwise_world, world, data)
		end

		if not template_data.recharge_particle_id then
			local recharge_particle_id = World.create_particles(world, recharge_particle_name, linked_beam_position)
			template_data.recharge_particle_id = recharge_particle_id
		end

		local physics_world = template_data.physics_world

		World.move_particles(world, template_data.recharge_particle_id, source_pos, Quaternion.identity())

		local control_point_1 = source_pos

		Flamer.update_shooting_fx(t, unit, vfx, sfx, wwise_world, world, physics_world, linked_beam_position, control_point_1, source_pos, data)
	end,
	stop = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local data = template_data.data

		if not data or not data.muzzle_source_id then
			return
		end

		local world = template_context.world
		local unit = template_data.unit

		Flamer.stop_fx(unit, vfx, sfx, wwise_world, world, data)

		if template_data.recharge_particle_id then
			World.stop_spawning_particles(world, template_data.recharge_particle_id)
		end
	end
}

return effect_template
