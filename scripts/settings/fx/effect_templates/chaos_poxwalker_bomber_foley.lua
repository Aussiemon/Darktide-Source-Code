local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionPerception = require("scripts/utilities/minion_perception")
local START_SOUND_EVENT = "wwise/events/minions/play_minion_poxwalker_bomber_vce_charge"
local STOP_SOUND_EVENT = "wwise/events/minions/stop_all_minion_poxwalker_bomber_vce"
local TARGET_NODE_NAME = "ap_voice"
local resources = {
	start_sound_event = START_SOUND_EVENT,
	stop_sound_event = STOP_SOUND_EVENT
}
local effect_template = {
	name = "chaos_poxwalker_bomber_foley",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		template_data.game_object_id = game_object_id
	end,
	update = function (template_data, template_context, dt, t)
		local game_session = template_context.game_session
		local game_object_id = template_data.game_object_id
		local target_unit = MinionPerception.target_unit(game_session, game_object_id)

		if not ALIVE[target_unit] then
			return
		end

		local unit = template_data.unit
		local source_id = template_data.source_id
		local wwise_world = template_context.wwise_world

		if not source_id then
			local node_index = Unit.node(unit, TARGET_NODE_NAME)
			source_id = WwiseWorld.make_manual_source(wwise_world, unit, node_index)

			WwiseWorld.trigger_resource_event(wwise_world, START_SOUND_EVENT, source_id)

			template_data.source_id = source_id
		elseif source_id then
			local was_camera_following_target = template_data.was_camera_following_target
			local is_camera_following_target = Effect.update_targeted_by_special_wwise_parameters(target_unit, wwise_world, source_id, was_camera_following_target, unit)
			template_data.was_camera_following_target = is_camera_following_target
		end
	end,
	stop = function (template_data, template_context)
		local source_id = template_data.source_id

		if source_id then
			local wwise_world = template_context.wwise_world

			WwiseWorld.trigger_resource_event(wwise_world, STOP_SOUND_EVENT, source_id)
		end
	end
}

return effect_template
