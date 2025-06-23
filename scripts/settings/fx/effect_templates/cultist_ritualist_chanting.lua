-- chunkname: @scripts/settings/fx/effect_templates/cultist_ritualist_chanting.lua

local resources = {
	vfx = {
		target_01 = "content/fx/particles/enemies/cultist_ritualist/ritual_force_minions_heresy_target_01",
		chanting_off_right_hand = "content/fx/particles/enemies/cultist_ritualist/ritual_force_minions_heresy_off_hand",
		chanting_off_left_hand = "content/fx/particles/enemies/cultist_ritualist/ritual_force_minions_heresy_off_left_hand",
		chanting_02 = "content/fx/particles/enemies/cultist_ritualist/ritual_force_minions_heresy_02",
		chanting_01 = "content/fx/particles/enemies/cultist_ritualist/ritual_force_minions_heresy_01"
	},
	sfx = {
		chanting_01 = {
			stop_event = "wwise/events/weapon/play_heresy_minion_ritual_force_01_stop",
			start_event = "wwise/events/weapon/play_heresy_minion_ritual_force_01_start"
		},
		chanting_02 = {
			stop_event = "wwise/events/weapon/play_heresy_minion_ritual_force_02_stop",
			start_event = "wwise/events/weapon/play_heresy_minion_ritual_force_02_start"
		}
	}
}
local start_delay = 0.15
local variant_settings = {
	{
		vfx = {
			{
				node_name = "j_lefthand",
				align_to_target = true,
				length_variable_name = "length",
				effect_name = resources.vfx.chanting_01,
				target_effect_name = resources.vfx.target_01
			},
			{
				node_name = "j_righthand",
				effect_name = resources.vfx.chanting_off_right_hand
			}
		},
		sfx = {
			{
				node_name = "j_lefthand",
				looping_sound = resources.sfx.chanting_01
			}
		}
	},
	{
		vfx = {
			{
				node_name = "j_righthand",
				align_to_target = true,
				length_variable_name = "length",
				effect_name = resources.vfx.chanting_01,
				target_effect_name = resources.vfx.target_01
			},
			{
				node_name = "j_lefthand",
				effect_name = resources.vfx.chanting_off_left_hand
			}
		},
		sfx = {
			{
				node_name = "j_righthand",
				looping_sound = resources.sfx.chanting_01
			}
		}
	},
	{
		vfx = {
			{
				node_name = "j_lefthand",
				effect_name = resources.vfx.chanting_02
			}
		},
		sfx = {
			{
				node_name = "j_lefthand",
				looping_sound = resources.sfx.chanting_02
			}
		}
	}
}

local function _stop_effects(template_data, template_context)
	if not template_data.started_effects then
		return
	end

	local vfx_data = template_data.vfx_data
	local sfx_data = template_data.sfx_data

	if vfx_data then
		local world = template_context.world

		for ii = 1, #vfx_data do
			local data = vfx_data[ii]
			local particle_id = data.particle_id
			local target_particle_id = data.target_particle_id

			if particle_id then
				World.stop_spawning_particles(world, particle_id)
			end

			if target_particle_id then
				World.stop_spawning_particles(world, target_particle_id)
			end
		end
	end

	if sfx_data then
		local wwise_world = template_context.wwise_world

		for ii = 1, #sfx_data do
			local data = sfx_data[ii]
			local source_id = data.source_id
			local playing_id = data.playing_id
			local stop_event_name = data.stop_event_name

			if source_id and playing_id then
				WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, source_id)
			else
				WwiseWorld.stop_event(wwise_world, playing_id)
			end

			if source_id then
				WwiseWorld.destroy_manual_source(wwise_world, source_id)
			end
		end
	end

	template_data.started_effects = false
	template_data.target_unit = nil
end

local function _start_effects(template_data, template_context)
	if template_data.particle_id then
		return
	end

	local world = template_context.world
	local wwise_world = template_context.wwise_world
	local unit = template_data.unit
	local effect_template_variation_id = template_data.effect_template_variation_id
	local settings = variant_settings[effect_template_variation_id]
	local vfx = settings.vfx
	local sfx = settings.sfx

	if vfx then
		if not template_data.vfx_data then
			template_data.vfx_data = {}
		end

		for ii = 1, #vfx do
			local entry = vfx[ii]
			local data = {}
			local effect_name = entry.effect_name
			local node_name = entry.node_name
			local target_effect_name = entry.target_effect_name
			local start_position = Unit.world_position(unit, Unit.node(unit, node_name))
			local particle_id = World.create_particles(world, effect_name, start_position, Quaternion.identity())

			if not entry.align_to_target then
				World.link_particles(world, particle_id, unit, Unit.node(unit, node_name), Matrix4x4.identity(), "stop")
			end

			if target_effect_name then
				local target_particle_id = World.create_particles(world, target_effect_name, start_position, Quaternion.identity())

				data.target_particle_id = target_particle_id
			end

			data.particle_id = particle_id
			template_data.vfx_data[ii] = data
		end
	end

	if sfx then
		if not template_data.sfx_data then
			template_data.sfx_data = {}
		end

		for ii = 1, #sfx do
			local entry = sfx[ii]
			local data = {}
			local looping_sound = entry.looping_sound
			local node_name = entry.node_name
			local start_event = looping_sound.start_event
			local stop_event = looping_sound.stop_event
			local source_id = WwiseWorld.make_manual_source(wwise_world, unit, Unit.node(unit, node_name))
			local playing_id = WwiseWorld.trigger_resource_event(wwise_world, start_event, source_id)

			data.source_id = source_id
			data.playing_id = playing_id
			data.stop_event_name = stop_event
			template_data.sfx_data[ii] = data
		end
	end

	template_data.started_effects = true
end

local function _update_target(template_data, template_context)
	local world = template_context.world
	local unit = template_data.unit
	local target_unit = template_data.target_unit
	local effect_template_variation_id = template_data.effect_template_variation_id
	local vfx_data = template_data.vfx_data
	local settings = variant_settings[effect_template_variation_id]
	local vfx = settings.vfx

	if vfx and vfx_data then
		local local_scale = Unit.local_scale(target_unit, 1)
		local target_pose, half_extents = Unit.box(target_unit)
		local radius = math.max(half_extents.x, half_extents.y) * math.max(local_scale.x, local_scale.y)
		local target_position = Matrix4x4.translation(target_pose)
		local flat_target_position = Vector3.flat(target_position)

		for ii = 1, #vfx do
			local data = vfx_data[ii]
			local entry = vfx[ii]

			if entry.align_to_target then
				local particle_id = data.particle_id
				local target_particle_id = data.target_particle_id
				local position = Unit.world_position(unit, Unit.node(unit, entry.node_name))
				local flat_position = Vector3.flat(position)
				local flat_from_target = Vector3.normalize(flat_target_position - flat_position)
				local direction = Vector3.normalize(target_position - position)
				local edge_position = target_position - flat_from_target * radius
				local flat_edge_position = Vector3.flat(edge_position)
				local flat_edge_distance_sq = Vector3.distance_squared(flat_edge_position, flat_target_position)
				local flat_distance_sq = Vector3.distance_squared(flat_position, flat_target_position)

				if math.abs(flat_distance_sq) <= 0.001 then
					flat_edge_distance_sq = 1
					flat_distance_sq = 1
				end

				local distance_scale = math.sqrt(flat_edge_distance_sq / flat_distance_sq)
				local distance = Vector3.distance(target_position, position)

				distance = distance * (1 - distance_scale)

				local rotation = Quaternion.look(direction)

				World.move_particles(world, particle_id, position, rotation)

				local length_variable_name = entry.length_variable_name

				if length_variable_name then
					local particle_length = Vector3(distance, distance, distance)
					local length_variable_index = World.find_particles_variable(world, entry.effect_name, length_variable_name)

					World.set_particles_variable(world, particle_id, length_variable_index, particle_length)
				end

				if target_particle_id then
					World.move_particles(world, target_particle_id, position + direction * distance, rotation)
				end
			end
		end
	end
end

local effect_template = {
	name = "cultist_ritualist_chanting",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		template_data.game_object_id = game_object_id

		local t = Managers.time:time("gameplay")

		template_data.start_t = t
		template_data.started_effects = false
	end,
	update = function (template_data, template_context, dt, t)
		local game_session = template_context.game_session
		local game_object_id = template_data.game_object_id
		local effect_template_variation_id = GameSession.game_object_field(game_session, game_object_id, "effect_template_variation_id")
		local target_unit_id = GameSession.game_object_field(game_session, game_object_id, "level_unit_id")
		local target_unit = target_unit_id ~= NetworkConstants.invalid_level_unit_id and Managers.state.unit_spawner:unit(target_unit_id, true)
		local valid_target = target_unit and Unit.alive(target_unit)

		if not valid_target and template_data.started_effects then
			_stop_effects(template_data, template_context)
		end

		if effect_template_variation_id ~= -1 and t >= template_data.start_t + start_delay and not template_data.started_effects and valid_target then
			template_data.target_unit = target_unit
			template_data.effect_template_variation_id = effect_template_variation_id

			_start_effects(template_data, template_context)
		end

		if template_data.started_effects and valid_target then
			_update_target(template_data, template_context)
		end
	end,
	stop = function (template_data, template_context)
		_stop_effects(template_data, template_context)
	end
}

return effect_template
