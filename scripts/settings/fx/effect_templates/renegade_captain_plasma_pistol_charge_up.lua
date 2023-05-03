local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local START_SOUND_EVENT = "wwise/events/weapon/play_minion_plasmapistol_charge"
local STOP_SOUND_EVENT = "wwise/events/weapon/stop_minion_plasmapistol_charge"
local MUZZLE_VFX = "content/fx/particles/enemies/renegade_captain/enemy_plasma_scope_flash"
local FX_SOURCE_NAME = "muzzle"
local resources = {
	start_sound_event = START_SOUND_EVENT,
	stop_sound_event = STOP_SOUND_EVENT,
	muzzle_vfx = MUZZLE_VFX
}
local effect_template = {
	name = "renegade_captain_plasma_pistol_charge_up",
	resources = resources,
	start = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_unit = visual_loadout_extension:slot_unit("slot_plasma_pistol")
		local source_id = WwiseWorld.make_manual_source(wwise_world, inventory_unit)

		WwiseWorld.trigger_resource_event(wwise_world, START_SOUND_EVENT, source_id)

		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		WwiseWorld.set_source_parameter(wwise_world, source_id, "charge_level", 0.5)

		template_data.source_id = source_id
		template_data.game_object_id = game_object_id
		template_data.game_session = game_session
		local world = template_context.world
		local inventory_item = visual_loadout_extension:slot_item("slot_plasma_pistol")
		local attachment_unit, node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, FX_SOURCE_NAME)
		local position = Unit.world_position(attachment_unit, node_index)
		local vfx_particle_id = World.create_particles(world, MUZZLE_VFX, position, Quaternion.identity())

		World.link_particles(world, vfx_particle_id, attachment_unit, node_index, Matrix4x4.identity(), "stop")

		template_data.vfx_particle_id = vfx_particle_id
	end,
	update = function (template_data, template_context, dt, t)
		local game_session = template_data.game_session
		local game_object_id = template_data.game_object_id
		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id
		local target_unit = MinionPerception.target_unit(game_session, game_object_id)
		local was_camera_following_target = template_data.was_camera_following_target
		local is_camera_following_target = Effect.update_targeted_in_melee_wwise_parameters(target_unit, wwise_world, source_id, was_camera_following_target)
		template_data.was_camera_following_target = is_camera_following_target
	end,
	stop = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		WwiseWorld.trigger_resource_event(wwise_world, STOP_SOUND_EVENT, source_id)
		WwiseWorld.destroy_manual_source(wwise_world, source_id)

		local world = template_context.world
		local vfx_particle_id = template_data.vfx_particle_id

		World.stop_spawning_particles(world, vfx_particle_id)
	end
}

return effect_template
