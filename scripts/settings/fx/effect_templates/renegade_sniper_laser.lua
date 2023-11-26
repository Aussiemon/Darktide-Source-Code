-- chunkname: @scripts/settings/fx/effect_templates/renegade_sniper_laser.lua

local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local FX_SOURCE_NAME = "muzzle"
local LASER_Y_OFFSET = 1
local LASER_X, LASER_Z = 0.05, 0.5
local LASER_PARTICLE_NAME = "content/fx/particles/enemies/sniper_laser_sight"
local LASER_LENGTH_VARIABLE_NAME = "hit_distance"
local LASER_SOUND_EVENT = "wwise/events/weapon/play_combat_weapon_las_sniper_target_beam"
local LASER_STOP_SOUND_EVENT = "wwise/events/weapon/stop_combat_weapon_las_sniper_target_beam"
local resources = {
	laser_particle_name = LASER_PARTICLE_NAME,
	laser_sound_event = LASER_SOUND_EVENT,
	laser_stop_sound_event = LASER_STOP_SOUND_EVENT
}

local function _get_positions(local_player_unit, template_data, game_session, game_object_id)
	local visual_loadout_extension = ScriptUnit.extension(template_data.unit, "visual_loadout_system")
	local inventory_item = visual_loadout_extension:slot_item("slot_ranged_weapon")
	local attachment_unit, node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, FX_SOURCE_NAME)
	local muzzle_pos = Unit.world_position(attachment_unit, node_index)
	local laser_aim_position = GameSession.game_object_field(game_session, game_object_id, "laser_aim_position")
	local local_player_position = local_player_unit and Unit.local_position(local_player_unit, 1) or Vector3(0, 0, 0)
	local closest_point = Geometry.closest_point_on_line(local_player_position, muzzle_pos, laser_aim_position)

	return closest_point, muzzle_pos, laser_aim_position, attachment_unit, node_index
end

local SIGHT_DURATION_VARAIBLE_NAME = "sniper_aim_time"
local effect_template = {
	name = "renegade_sniper_laser",
	resources = resources,
	start = function (template_data, template_context)
		local local_player = Managers.player:local_player(1)
		local local_player_unit = local_player and local_player.player_unit

		if DEDICATED_SERVER then
			return
		end

		local wwise_world = template_context.wwise_world
		local unit = template_data.unit
		local game_session, game_object_id = Managers.state.game_session:game_session(), Managers.state.unit_spawner:game_object_id(unit)

		template_data.game_session, template_data.game_object_id = game_session, game_object_id

		local closest_point, muzzle_pos = _get_positions(local_player_unit, template_data, game_session, game_object_id)
		local source_id = WwiseWorld.make_manual_source(wwise_world, closest_point, Quaternion.identity())

		WwiseWorld.trigger_resource_event(wwise_world, LASER_SOUND_EVENT, source_id)

		template_data.source_id = source_id

		local world = template_context.world
		local particle_id = World.create_particles(world, LASER_PARTICLE_NAME, muzzle_pos)

		template_data.particle_id = particle_id

		local variable_index = World.find_particles_variable(world, LASER_PARTICLE_NAME, LASER_LENGTH_VARIABLE_NAME)

		template_data.variable_index = variable_index
	end,
	update = function (template_data, template_context, dt, t)
		local local_player = Managers.player:local_player(1)
		local local_player_unit = local_player and local_player.player_unit

		if not local_player_unit then
			return
		end

		local game_session, game_object_id = template_data.game_session, template_data.game_object_id
		local closest_point, muzzle_pos, laser_aim_position = _get_positions(local_player_unit, template_data, game_session, game_object_id)
		local wwise_world = template_context.wwise_world

		WwiseWorld.set_source_position(wwise_world, template_data.source_id, closest_point)

		local in_sight_duration = GameSession.game_object_field(game_session, game_object_id, "in_sight_duration")

		WwiseWorld.set_source_parameter(wwise_world, template_data.source_id, SIGHT_DURATION_VARAIBLE_NAME, in_sight_duration)

		local particle_id = template_data.particle_id
		local variable_index = template_data.variable_index
		local world = template_context.world
		local rotation = Quaternion.look(Vector3.normalize(laser_aim_position - muzzle_pos))

		World.move_particles(world, particle_id, muzzle_pos, rotation)

		local distance = Vector3.distance(muzzle_pos, laser_aim_position)

		World.set_particles_variable(world, particle_id, variable_index, Vector3(LASER_X, distance + LASER_Y_OFFSET, LASER_Z))
	end,
	stop = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		if source_id then
			WwiseWorld.trigger_resource_event(wwise_world, LASER_STOP_SOUND_EVENT, source_id)
			WwiseWorld.destroy_manual_source(wwise_world, source_id)
		end

		local particle_id = template_data.particle_id

		if particle_id then
			local world = template_context.world

			World.destroy_particles(world, particle_id)
		end
	end
}

return effect_template
