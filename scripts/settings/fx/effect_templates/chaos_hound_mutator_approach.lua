-- chunkname: @scripts/settings/fx/effect_templates/chaos_hound_mutator_approach.lua

local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionPerception = require("scripts/utilities/minion_perception")
local APPROACH_SOUND_EVENT = "wwise/events/minions/play_chaos_hound_mutator_vce_bark"
local TARGET_NODE_NAME = "ap_voice"
local TRIGGER_DISTANCE = 25
local RESTART_TRIGGER_DISTANCE = 28
local TIME_BETWEEN_TRIGGERS = 10
local PARTICLE_NAME = "content/fx/particles/enemies/chaos_hound/chaos_hound_mutator_idle"
local PARTICLE_NODE = "j_hips"
local PARTICLE_2_NAME = "content/fx/particles/enemies/chaos_hound/chaos_hound_mutator_eyes"
local PARTICLE_2_NODE = "j_lefteye"
local PARTICLE_3_NAME = "content/fx/particles/enemies/chaos_hound/chaos_hound_mutator_eyes"
local PARTICLE_3_NODE = "j_righteye"
local resources = {
	approach_sound_event = APPROACH_SOUND_EVENT,
	approach_vfx = PARTICLE_NAME,
	eye_vfx = PARTICLE_2_NAME,
}
local _trigger_sound
local effect_template = {
	name = "chaos_hound_mutator_approach",
	resources = resources,
	start = function (template_data, template_context)
		template_data.next_trigger_t = 0

		local world = template_context.world
		local unit = template_data.unit
		local unit_position = POSITION_LOOKUP[unit]
		local particle_id = World.create_particles(world, PARTICLE_NAME, unit_position, nil, nil, template_data.particle_group)

		template_data.particle_id = particle_id

		local orphaned_policy = "stop"
		local node_1 = Unit.node(unit, PARTICLE_NODE)

		World.link_particles(world, particle_id, unit, node_1, Matrix4x4.identity(), orphaned_policy)

		local particle_2_id = World.create_particles(world, PARTICLE_2_NAME, unit_position, nil, nil, template_data.particle_group)

		template_data.particle_2_id = particle_2_id

		local node_2 = Unit.node(unit, PARTICLE_2_NODE)

		World.link_particles(world, particle_2_id, unit, node_2, Matrix4x4.identity(), orphaned_policy)

		local particle_3_id = World.create_particles(world, PARTICLE_3_NAME, unit_position, nil, nil, template_data.particle_group)

		template_data.particle_3_id = particle_3_id

		local node_3 = Unit.node(unit, PARTICLE_3_NODE)

		World.link_particles(world, particle_3_id, unit, node_3, Matrix4x4.identity(), orphaned_policy)
	end,
	update = function (template_data, template_context, dt, t)
		local unit = template_data.unit
		local game_session, game_object_id = template_context.game_session, Managers.state.unit_spawner:game_object_id(unit)
		local target_unit = MinionPerception.target_unit(game_session, game_object_id)

		if not ALIVE[target_unit] then
			return
		end

		local target_position = POSITION_LOOKUP[target_unit]
		local unit_position = POSITION_LOOKUP[unit]
		local distance_to_target_unit = Vector3.distance(unit_position, target_position)

		if not template_data.triggered then
			local can_trigger = t > template_data.next_trigger_t and distance_to_target_unit <= TRIGGER_DISTANCE

			if can_trigger then
				_trigger_sound(unit, target_unit, template_data, template_context, t)
			end
		elseif distance_to_target_unit >= RESTART_TRIGGER_DISTANCE then
			template_data.triggered = false
		end
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local vfx_particle_id = template_data.particle_id

		World.stop_spawning_particles(world, vfx_particle_id)

		local vfx_particle_2_id = template_data.particle_2_id

		World.stop_spawning_particles(world, vfx_particle_2_id)

		local vfx_particle_3_id = template_data.particle_3_id

		World.stop_spawning_particles(world, vfx_particle_3_id)
	end,
}

function _trigger_sound(unit, target_unit, template_data, template_context, t)
	local wwise_world = template_context.wwise_world
	local node_index = Unit.node(unit, TARGET_NODE_NAME)
	local auto_source_id = WwiseWorld.make_auto_source(wwise_world, unit, node_index)
	local was_camera_follow_target = false

	Effect.update_targeted_by_special_wwise_parameters(target_unit, wwise_world, auto_source_id, was_camera_follow_target, unit)
	WwiseWorld.trigger_resource_event(wwise_world, APPROACH_SOUND_EVENT, auto_source_id)

	template_data.triggered = true
	template_data.next_trigger_t = t + TIME_BETWEEN_TRIGGERS
end

return effect_template
