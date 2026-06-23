-- chunkname: @scripts/settings/fx/effect_templates/companion_servo_skull_empowered_effect.lua

local CompanionServoSkullEmpoweredEffectSettings = require("scripts/settings/companion/companion_servo_skull_empowered_effect_settings")
local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local vfx = CompanionServoSkullEmpoweredEffectSettings.vfx
local sfx = CompanionServoSkullEmpoweredEffectSettings.sfx
local resources = {
	resources_vfx = vfx,
	resources_sfx = sfx,
}
local _start_effect
local effect_template = {
	name = "companion_servo_skull_empowered_effect",
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

		local fx_source_name = vfx.fx_source_name
		local node = Unit.node(unit, fx_source_name)

		if node then
			template_data.attachment_unit = unit
			template_data.attachment_node = node

			local source_id = fx_extension:sound_source(sfx.source_name)
			local playing_id, stop_event_name = CompanionVisualLoadout.trigger_looping_gear_sound(unit, source_id, sfx.sound_alias)

			template_data.source_id = source_id
			template_data.playing_id = playing_id
			template_data.stop_event_name = stop_event_name

			_start_effect(unit, unit, node, template_data, template_context.world)
		end
	end,
	update = function (template_data, template_context, dt, t)
		local stream_effect_id = template_data.stream_effect_id

		if stream_effect_id then
			local unit = template_data.unit
			local attachment_unit = template_data.attachment_unit
			local attachment_node = template_data.attachment_node
			local from_pos = Unit.world_position(attachment_unit, attachment_node)
			local unit_rotation = Unit.world_rotation(unit, 1)
			local direction = Vector3.normalize(from_pos + Quaternion.forward(unit_rotation) - from_pos)
			local rotation = Quaternion.look(direction)
			local world = template_context.world

			World.move_particles(world, stream_effect_id, from_pos, rotation)
		end
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local stream_effect_id = template_data.stream_effect_id

		if stream_effect_id then
			World.stop_spawning_particles(world, stream_effect_id)
		else
			Log.exception("CompanionServoSkullEmpoweredEffect", "No effect ID, unless you died, it is suspicious")
		end

		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id
		local playing_id = template_data.playing_id
		local stop_event_name = template_data.stop_event_name

		if source_id and stop_event_name then
			WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, source_id)
		elseif playing_id then
			WwiseWorld.stop_event(wwise_world, playing_id)
		end

		template_data.source_id = nil
		template_data.playing_id = nil
		template_data.stop_event_name = nil
	end,
}

function _start_effect(unit, attachment_unit, node, template_data, world)
	local from_pos = Unit.world_position(attachment_unit, node)
	local unit_rotation = Unit.world_rotation(unit, 1)
	local effect_id = World.create_particles(world, vfx.effect_template_name, from_pos, unit_rotation)

	template_data.stream_effect_id = effect_id
end

return effect_template
