-- chunkname: @scripts/settings/fx/effect_templates/companion_servo_skull_flamer.lua

local CompanionServoSkullFlamerSettings = require("scripts/settings/companion/companion_servo_skull_flamer_settings")
local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local vfx = CompanionServoSkullFlamerSettings.vfx
local sfx = CompanionServoSkullFlamerSettings.sfx
local resources = {
	resources_vfx = vfx,
	resources_sfx = sfx,
}
local effect_template = {
	name = "companion_servo_skull_flamer",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if not fx_extension then
			return
		end

		local fx_system = Managers.state.extension:system("fx_system")
		local visual_loadout_extension = ScriptUnit.extension(template_data.unit, "visual_loadout_system")

		template_data.fx_system = fx_system
		template_data.visual_loadout_extension = visual_loadout_extension

		local slot_name = CompanionServoSkullFlamerSettings.inventory_slot
		local fx_source_name = sfx.source_name
		local lookup_fx_sources = false
		local inventory_item = visual_loadout_extension:slot_item(slot_name)
		local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, fx_source_name, lookup_fx_sources)

		template_data.attachment_unit = attachment_unit
		template_data.attachment_node = node

		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_manual_source(wwise_world, attachment_unit, node)
		local playing_id, stop_event_name = CompanionVisualLoadout.trigger_looping_gear_sound(unit, source_id, sfx.sound_alias, sfx.profile_properties_switch)

		template_data.source_id = source_id
		template_data.playing_id = playing_id
		template_data.stop_event_name = stop_event_name

		local game_session, game_object_id = Managers.state.game_session:game_session(), Managers.state.unit_spawner:game_object_id(unit)

		template_data.game_session = game_session
		template_data.game_object_id = game_object_id
	end,
	update = function (template_data, template_context, dt, t)
		local unit = template_data.unit
		local attachment_unit = template_data.attachment_unit
		local attachment_node = template_data.attachment_node
		local from_pos = Unit.world_position(attachment_unit, attachment_node)
		local game_session, game_object_id = template_data.game_session, template_data.game_object_id
		local to_pos = GameSession.game_object_field(game_session, game_object_id, "fx_impact_position")
		local position_valid = GameSession.game_object_field(game_session, game_object_id, "fx_position_valid")
		local stream_effect_id = template_data.stream_effect_id
		local max_length = vfx.max_range
		local unit_rotation = Unit.world_rotation(unit, 1)
		local direction = Vector3.normalize(from_pos + Vector3.multiply(Quaternion.forward(unit_rotation), max_length) - from_pos)
		local rotation = Quaternion.look(direction)
		local distance = max_length

		if position_valid then
			local direction_vector = to_pos - from_pos

			distance = Vector3.length(direction_vector)
		end

		if not stream_effect_id then
			local world = template_context.world
			local effect_id = World.create_particles(world, vfx.flamer_particle, from_pos, rotation, nil, template_data.particle_group)

			template_data.stream_effect_id = effect_id
		else
			local world = template_context.world

			World.move_particles(world, stream_effect_id, from_pos, rotation)
		end

		local world = template_context.world
		local speed = vfx.speed
		local life = distance / speed
		local variable_index = World.find_particles_variable(world, vfx.flamer_particle, "life")

		World.set_particles_variable(world, template_data.stream_effect_id, variable_index, Vector3(life, life, life))
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local wwise_world = template_context.wwise_world
		local stream_effect_id = template_data.stream_effect_id

		if stream_effect_id then
			World.stop_spawning_particles(world, stream_effect_id)
		else
			Log.exception("CompanionServoSkullFlamer", "No effect ID, unless you died, it is suspicious")
		end

		local source_id = template_data.source_id
		local playing_id = template_data.playing_id
		local stop_event_name = template_data.stop_event_name

		if source_id and stop_event_name then
			WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, source_id)
		elseif playing_id then
			WwiseWorld.stop_event(wwise_world, playing_id)
		end

		if source_id then
			WwiseWorld.destroy_manual_source(wwise_world, source_id)
		end

		template_data.source_id = nil
		template_data.playing_id = nil
		template_data.stop_event_name = nil
	end,
}

return effect_template
