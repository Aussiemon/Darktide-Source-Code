local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local MinionPerception = require("scripts/utilities/minion_perception")
local shooting_difficulty_settings = MinionDifficultySettings.shooting.cultist_assault
local FX_SOURCE_NAME = "muzzle"
local ORPHANED_POLICY = "stop"
local START_SHOOT_SOUND_EVENT = "wwise/events/weapon/play_weapon_autogun_renegade_auto_chaos"
local STOP_SHOOT_SOUND_EVENT = "wwise/events/weapon/stop_weapon_autogun_renegade_auto_chaos"
local SHOOT_VFX = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_3p"
local FIRE_RATE_PARAMETER_NAME = "wpn_fire_interval"
local resources = {
	start_shoot_sound_event = START_SHOOT_SOUND_EVENT,
	stop_shoot_sound_event = STOP_SHOOT_SOUND_EVENT,
	shoot_vfx = SHOOT_VFX
}
local effect_template = {
	name = "cultist_assault_autogun",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_item = visual_loadout_extension:slot_item("slot_ranged_weapon")
		local attachment_unit, node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, FX_SOURCE_NAME)
		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_manual_source(wwise_world, attachment_unit, node_index)

		WwiseWorld.trigger_resource_event(wwise_world, START_SHOOT_SOUND_EVENT, source_id)

		template_data.source_id = source_id
		local game_session = template_context.game_session
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		local target_unit = MinionPerception.target_unit(game_session, game_object_id)
		template_data.target_unit = target_unit
		template_data.was_camera_following_target = Effect.update_targeted_by_ranged_minion_wwise_parameters(target_unit, wwise_world, source_id, nil)
		local world = template_context.world
		local position = Vector3.zero()
		local pose = Matrix4x4.identity()
		local particle_id = World.create_particles(world, SHOOT_VFX, position)

		World.link_particles(world, particle_id, attachment_unit, node_index, pose, ORPHANED_POLICY)

		template_data.particle_id = particle_id

		Unit.animation_event(unit, "offset_rifle_standing_shoot_loop_01")

		local time_per_shot = shooting_difficulty_settings.time_per_shot
		local diff_time_per_shot = Managers.state.difficulty:get_table_entry_by_challenge(time_per_shot)
		local parameter_value = diff_time_per_shot[1]

		WwiseWorld.set_source_parameter(wwise_world, source_id, FIRE_RATE_PARAMETER_NAME, parameter_value)
	end,
	update = function (template_data, template_context, dt, t)
		local wwise_world = template_context.wwise_world
		local target_unit = template_data.target_unit
		local source_id = template_data.source_id
		local was_camera_following_target = template_data.was_camera_following_target
		local is_camera_following_target = Effect.update_targeted_by_ranged_minion_wwise_parameters(target_unit, wwise_world, source_id, was_camera_following_target)
		template_data.was_camera_following_target = is_camera_following_target
	end,
	stop = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		WwiseWorld.trigger_resource_event(wwise_world, STOP_SHOOT_SOUND_EVENT, source_id)
		WwiseWorld.destroy_manual_source(wwise_world, source_id)

		local world = template_context.world
		local particle_id = template_data.particle_id

		World.stop_spawning_particles(world, particle_id)

		local unit = template_data.unit

		Unit.animation_event(unit, "shoot_finished")
	end
}

return effect_template
