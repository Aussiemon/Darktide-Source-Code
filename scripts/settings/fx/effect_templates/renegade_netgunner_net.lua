-- chunkname: @scripts/settings/fx/effect_templates/renegade_netgunner_net.lua

local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local NET_PARTICLE_NAME = "content/fx/particles/enemies/netgunner_net_projectile"
local NET_SOUND_EVENT = "wwise/events/weapon/play_enemy_netgunner_net_shot"
local NET_SOUND_STOP_EVENT = "wwise/events/weapon/stop_enemy_netgunner_net_shot"
local FX_SOURCE_NAME = "muzzle"
local SLOT_ITEM_NAME = "slot_netgun"
local resources = {
	net_particle_name = NET_PARTICLE_NAME,
	net_sound_event = NET_SOUND_EVENT,
	net_sound_stop_event = NET_SOUND_STOP_EVENT
}

local function _get_net_position(template_context, template_data)
	local game_session = template_context.game_session
	local game_object_id = template_data.game_object_id
	local position = GameSession.game_object_field(game_session, game_object_id, "net_sweep_position")

	return position
end

local function _get_muzzle_position(unit)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local inventory_item = visual_loadout_extension:slot_item(SLOT_ITEM_NAME)
	local attachment_unit, node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, FX_SOURCE_NAME)
	local muzzle_pos = Unit.world_position(attachment_unit, node_index)

	return muzzle_pos
end

local LERP_SPEED = 50
local effect_template = {
	name = "renegade_netgunner_net",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit

		template_data.game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		local wwise_world = template_context.wwise_world
		local position = _get_net_position(template_context, template_data)
		local source_id = WwiseWorld.make_manual_source(wwise_world, position, Quaternion.identity())

		WwiseWorld.trigger_resource_event(wwise_world, NET_SOUND_EVENT, source_id)

		template_data.source_id = source_id

		local world = template_context.world
		local fx_node_position = _get_muzzle_position(unit)
		local rotation = Quaternion.look(Vector3.normalize(fx_node_position - position))
		local particle_id = World.create_particles(world, NET_PARTICLE_NAME, position, rotation)

		template_data.particle_id = particle_id
		template_data.projectile_start_position = Vector3Box(fx_node_position)
		template_data.projectile_old_position = Vector3Box(fx_node_position)
	end,
	update = function (template_data, template_context, dt, t)
		local old_position = template_data.projectile_old_position:unbox()
		local new_position = _get_net_position(template_context, template_data)
		local lerp_t = math.min(dt * LERP_SPEED, 1)
		local lerp_position = Vector3.lerp(old_position, new_position, lerp_t)

		template_data.projectile_old_position:store(lerp_position)

		local wwise_world = template_context.wwise_world

		WwiseWorld.set_source_position(wwise_world, template_data.source_id, lerp_position)

		local projectile_start_position = template_data.projectile_start_position:unbox()
		local rotation = Quaternion.look(Vector3.normalize(projectile_start_position - lerp_position))
		local world, particle_id = template_context.world, template_data.particle_id

		World.move_particles(world, particle_id, lerp_position, rotation)
	end,
	stop = function (template_data, template_context)
		local wwise_world, source_id = template_context.wwise_world, template_data.source_id

		WwiseWorld.trigger_resource_event(wwise_world, NET_SOUND_STOP_EVENT, source_id)
		WwiseWorld.destroy_manual_source(wwise_world, source_id)

		local world, particle_id = template_context.world, template_data.particle_id

		World.destroy_particles(world, particle_id)
	end
}

return effect_template
