-- chunkname: @scripts/settings/fx/effect_templates/cultist_mutant_charge_foley.lua

local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionPerception = require("scripts/utilities/minion_perception")
local START_CHARGE_SOUND_EVENT = "wwise/events/minions/play_enemy_mutant_charger_charge_growl"
local STOP_CHARGE_SOUND_EVENT = "wwise/events/minions/stop_enemy_mutant_charger_charge_growl"
local TARGET_NODE_NAME = "ap_voice"
local VFX_FOLEY_NAME = "content/fx/particles/enemies/mutant_charger/mutant_charger_rushing_streaks"
local VFX_FOLEY_NODE_NAME = "j_camera_attach"
local FLOW_START_EVENT = "charge_foley_start"
local FLOW_STOP_EVENT = "charge_foley_stop"
local resources = {
	start_charge_sound_event = START_CHARGE_SOUND_EVENT,
	stop_charge_sound_event = STOP_CHARGE_SOUND_EVENT,
	vfx_foley_name = VFX_FOLEY_NAME,
}
local _trigger_sound
local TRIGGER_DISTANCE = 20
local effect_template = {
	name = "cultist_mutant_charge_foley",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local world = template_context.world
		local node = Unit.node(unit, VFX_FOLEY_NODE_NAME)
		local node_pos = Unit.world_position(unit, node)
		local particle_id = World.create_particles(world, VFX_FOLEY_NAME, node_pos)
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		World.link_particles(world, particle_id, unit, node, Matrix4x4.identity(), "stop")

		template_data.particle_id = particle_id
		template_data.game_object_id = game_object_id

		if template_context.is_server then
			GameSession.set_game_object_field(template_context.game_session, game_object_id, "trigger_charge_sound", false)

			template_data.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
		end
	end,
	update = function (template_data, template_context, dt, t)
		local game_session, game_object_id = template_context.game_session, template_data.game_object_id
		local target_unit = MinionPerception.target_unit(game_session, game_object_id)

		if not ALIVE[target_unit] then
			return
		end

		local unit, source_id = template_data.unit, template_data.source_id
		local wwise_world, is_server = template_context.wwise_world, template_context.is_server

		if source_id then
			local was_camera_following_target = template_data.was_camera_following_target
			local is_camera_following_target = Effect.update_targeted_by_special_wwise_parameters(target_unit, wwise_world, source_id, was_camera_following_target, unit)

			template_data.was_camera_following_target = is_camera_following_target
		elseif is_server then
			local navigation_extension = template_data.navigation_extension
			local navigation_enabled, is_following_path = navigation_extension:enabled(), navigation_extension:is_following_path()

			if navigation_enabled and is_following_path then
				local has_upcoming_smart_object, _ = navigation_extension:path_distance_to_next_smart_object(TRIGGER_DISTANCE)
				local remaining_path_distance = not has_upcoming_smart_object and navigation_extension:remaining_distance_from_progress_to_end_of_path()

				if not has_upcoming_smart_object and remaining_path_distance <= TRIGGER_DISTANCE then
					template_data.source_id = _trigger_sound(unit, wwise_world, game_session, game_object_id, is_server)
				end
			elseif not navigation_enabled then
				local unit_position, target_position = POSITION_LOOKUP[unit], POSITION_LOOKUP[target_unit]
				local distance_to_target_unit = Vector3.distance(unit_position, target_position)

				if distance_to_target_unit <= TRIGGER_DISTANCE then
					template_data.source_id = _trigger_sound(unit, wwise_world, game_session, game_object_id, is_server)
				end
			end
		elseif GameSession.game_object_field(game_session, game_object_id, "trigger_charge_sound") then
			template_data.source_id = _trigger_sound(unit, wwise_world, game_session, game_object_id, is_server)
		end
	end,
	stop = function (template_data, template_context)
		local source_id = template_data.source_id

		if source_id then
			local unit = template_data.unit
			local wwise_world = template_context.wwise_world

			Unit.flow_event(unit, FLOW_STOP_EVENT)
			WwiseWorld.trigger_resource_event(wwise_world, STOP_CHARGE_SOUND_EVENT, source_id)
		end

		local world, particle_id = template_context.world, template_data.particle_id

		World.stop_spawning_particles(world, particle_id)
	end,
}

function _trigger_sound(unit, wwise_world, game_session, game_object_id, is_server)
	local node_index = Unit.node(unit, TARGET_NODE_NAME)
	local source_id = WwiseWorld.make_manual_source(wwise_world, unit, node_index)

	WwiseWorld.trigger_resource_event(wwise_world, START_CHARGE_SOUND_EVENT, source_id)
	Unit.flow_event(unit, FLOW_START_EVENT)

	if is_server then
		GameSession.set_game_object_field(game_session, game_object_id, "trigger_charge_sound", true)
	end

	return source_id
end

return effect_template
