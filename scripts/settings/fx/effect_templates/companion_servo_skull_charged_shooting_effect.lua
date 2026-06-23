-- chunkname: @scripts/settings/fx/effect_templates/companion_servo_skull_charged_shooting_effect.lua

local CompanionServoSkullChargedShootingSettings = require("scripts/settings/companion/companion_servo_skull_charged_shooting_effect_settings")
local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local vfx = CompanionServoSkullChargedShootingSettings.vfx
local sfx = CompanionServoSkullChargedShootingSettings.sfx
local slot_name = "slot_weapon"
local resources = {
	resources_vfx = vfx,
	resources_sfx = sfx,
}
local effect_template = {
	name = "companion_servo_skull_charged_shooting",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local fx_system = Managers.state.extension:system("fx_system")
		local visual_loadout_extension = ScriptUnit.extension(template_data.unit, "visual_loadout_system")

		template_data.fx_system = fx_system
		template_data.visual_loadout_extension = visual_loadout_extension

		local fx_source_name = vfx.source_name
		local lookup_fx_sources = false
		local inventory_item = visual_loadout_extension:slot_item(slot_name)
		local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, fx_source_name, lookup_fx_sources)

		template_data.attachment_unit = attachment_unit
		template_data.attachment_node = node

		local world = template_context.world
		local from_pos = Unit.world_position(attachment_unit, node)
		local unit_rotation = Unit.world_rotation(unit, 1)
		local direction = Vector3.normalize(from_pos + Quaternion.forward(unit_rotation) - from_pos)
		local rotation = Quaternion.look(direction)
		local effect_id = World.create_particles(world, vfx.charge_up, from_pos, rotation, nil, template_data.particle_group)

		template_data.stream_effect_id = effect_id

		World.link_particles(world, effect_id, attachment_unit, node, Matrix4x4.identity(), "stop")

		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		template_data._game_session = game_session
		template_data._game_object_id = game_object_id

		local game_object_exists = game_object_id and GameSession.game_object_exists(game_session, game_object_id)

		if not game_object_exists then
			return
		end

		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_auto_source(wwise_world, attachment_unit, node)
		local playing_id = CompanionVisualLoadout.trigger_gear_sound(unit, source_id, sfx.sound_alias)

		template_data.source_id = source_id
		template_data.playing_id = playing_id

		local shooting_cooldown_percent = GameSession.game_object_field(game_session, game_object_id, "shooting_cooldown_percent")
		local current_percentage = vfx.max_value * shooting_cooldown_percent
		local variable_index = World.find_particles_variable(world, vfx.charge_up, vfx.charge_variable_name)

		World.set_particles_variable(world, template_data.stream_effect_id, variable_index, Vector3(current_percentage, current_percentage, current_percentage))
	end,
	update = function (template_data, template_context, dt, t)
		local world = template_context.world
		local game_session = template_data._game_session
		local game_object_id = template_data._game_object_id
		local game_object_exists = game_object_id and GameSession.game_object_exists(game_session, game_object_id)

		if not game_object_exists then
			return
		end

		local shooting_cooldown_percent = GameSession.game_object_field(game_session, game_object_id, "shooting_cooldown_percent")
		local current_percentage = vfx.max_value * shooting_cooldown_percent
		local variable_index = World.find_particles_variable(world, vfx.charge_up, vfx.charge_variable_name)

		World.set_particles_variable(world, template_data.stream_effect_id, variable_index, Vector3(current_percentage, current_percentage, current_percentage))
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local stream_effect_id = template_data.stream_effect_id

		if stream_effect_id then
			World.stop_spawning_particles(world, stream_effect_id)
		else
			Log.exception("CompanionServoSkullFlamer", "No effect ID, unless you died, it is suspicious")
		end

		local wwise_world = template_context.wwise_world
		local playing_id = template_data.playing_id

		if playing_id then
			WwiseWorld.stop_event(wwise_world, playing_id)
		end
	end,
}

return effect_template
