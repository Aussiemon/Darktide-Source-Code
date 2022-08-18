local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionPerception = require("scripts/utilities/minion_perception")
local START_CHARGE_SOUND_EVENT = "wwise/events/minions/play_enemy_mutant_charger_charge_growl"
local STOP_CHARGE_SOUND_EVENT = "wwise/events/minions/stop_enemy_mutant_charger_charge_growl"
local TARGET_NODE_NAME = "ap_voice"
local VFX_FOLEY_NAME = "content/fx/particles/enemies/mutant_charger/mutant_charger_rushing_streaks"
local VFX_FOLEY_NODE_NAME = "j_camera_attach"
local resources = {
	start_charge_sound_event = START_CHARGE_SOUND_EVENT,
	stop_shoot_sound_event = STOP_CHARGE_SOUND_EVENT,
	vfx_foley_name = VFX_FOLEY_NAME
}
local TRIGGER_DISTANCE = 35
local effect_template = {
	name = "cultist_mutant_charge_foley",
	resources = resources,
	start = function (template_data, template_context)
		if VFX_FOLEY_NAME then
			local unit = template_data.unit
			local world = template_context.world
			local node = Unit.node(unit, VFX_FOLEY_NODE_NAME)
			local node_pos = Unit.world_position(unit, node)
			local particle_id = World.create_particles(world, VFX_FOLEY_NAME, node_pos)

			World.link_particles(world, particle_id, unit, node, Matrix4x4.identity(), "stop")

			template_data.particle_id = particle_id
		end
	end,
	update = function (template_data, template_context, dt, t)
		local unit = template_data.unit
		local game_session = template_context.game_session
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		local target_unit = MinionPerception.target_unit(game_session, game_object_id)

		if not ALIVE[target_unit] then
			return
		end

		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		if not source_id then
			local target_position = POSITION_LOOKUP[target_unit]
			local unit_position = POSITION_LOOKUP[unit]
			local distance_to_target_unit = Vector3.distance(unit_position, target_position)

			if distance_to_target_unit <= TRIGGER_DISTANCE then
				local node_index = Unit.node(unit, TARGET_NODE_NAME)
				source_id = WwiseWorld.make_manual_source(wwise_world, unit, node_index)

				WwiseWorld.trigger_resource_event(wwise_world, START_CHARGE_SOUND_EVENT, source_id)

				template_data.source_id = source_id
			end
		else
			local was_camera_following_target = template_data.was_camera_following_target
			local is_camera_following_target = Effect.update_targeted_by_special_wwise_parameters(target_unit, wwise_world, source_id, was_camera_following_target, unit)
			template_data.was_camera_following_target = is_camera_following_target
		end
	end,
	stop = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		if source_id then
			WwiseWorld.trigger_resource_event(wwise_world, STOP_CHARGE_SOUND_EVENT, source_id)
		end

		if template_data.particle_id then
			local world = template_context.world
			local particle_id = template_data.particle_id

			World.stop_spawning_particles(world, particle_id)
		end
	end
}

return effect_template
