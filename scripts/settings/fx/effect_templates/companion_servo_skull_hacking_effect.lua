-- chunkname: @scripts/settings/fx/effect_templates/companion_servo_skull_hacking_effect.lua

local CompanionServoSkullHackingEffectSettings = require("scripts/settings/companion/companion_servo_skull_hacking_effect_settings")
local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local vfx = CompanionServoSkullHackingEffectSettings.vfx
local sfx = CompanionServoSkullHackingEffectSettings.sfx
local resources = {
	resources_vfx = CompanionServoSkullHackingEffectSettings.vfx,
	resources_sfx = CompanionServoSkullHackingEffectSettings.sfx,
}
local _start_effect
local effect_template = {
	name = "companion_servo_skull_hacking_effect",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if not fx_extension then
			return
		end

		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		local hacking_unit_id = GameSession.game_object_field(game_session, game_object_id, "hacking_unit_id")
		local hacking_unit = Managers.state.unit_spawner:unit(hacking_unit_id, true)

		template_data.hacking_unit = hacking_unit

		local fx_system = Managers.state.extension:system("fx_system")
		local visual_loadout_extension = ScriptUnit.extension(template_data.unit, "visual_loadout_system")

		template_data.fx_system = fx_system
		template_data.visual_loadout_extension = visual_loadout_extension

		local fx_source_name = sfx.source_name
		local node = Unit.node(unit, fx_source_name)

		if node then
			template_data.attachment_unit = unit
			template_data.attachment_node = node

			local wwise_world = template_context.wwise_world
			local source_id = WwiseWorld.make_manual_source(wwise_world, unit, node)
			local playing_id, stop_event_name = CompanionVisualLoadout.trigger_looping_gear_sound(unit, source_id, sfx.sound_alias, sfx.profile_properties_switch)

			template_data.source_id = source_id
			template_data.playing_id = playing_id
			template_data.stop_event_name = stop_event_name

			_start_effect(unit, unit, node, template_data, template_context.world)
		end
	end,
	update = function (template_data, template_context, dt, t)
		local unit = template_data.unit
		local world = template_context.world
		local effect_id = template_data.stream_effect_id
		local attachment_unit = template_data.attachment_unit
		local hacking_unit = template_data.hacking_unit
		local fx_source_name = sfx.source_name
		local node = Unit.node(unit, fx_source_name)
		local from_pos = Unit.world_position(attachment_unit, node)
		local to_pos = Unit.world_position(hacking_unit, Unit.node(hacking_unit, "targeting_rotation_node"))
		local rotation = Quaternion.look(to_pos - from_pos)

		World.move_particles(world, effect_id, from_pos, rotation)
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local wwise_world = template_context.wwise_world
		local stream_effect_id = template_data.stream_effect_id

		if stream_effect_id then
			World.destroy_particles(world, stream_effect_id)
		else
			Log.exception("CompanionServoSkullHackingEffect", "No effect ID, unless you died, it is suspicious")
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

function _start_effect(unit, attachment_unit, node, template_data, world)
	local hacking_unit = template_data.hacking_unit
	local from_pos = Unit.world_position(attachment_unit, node)
	local to_pos = Unit.world_position(hacking_unit, Unit.node(hacking_unit, "targeting_rotation_node"))
	local rotation = Quaternion.look(to_pos - from_pos)
	local effect_id = World.create_particles(world, vfx.flamer_particle, from_pos, rotation)

	template_data.stream_effect_id = effect_id
end

return effect_template
