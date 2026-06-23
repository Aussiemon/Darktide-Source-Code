-- chunkname: @scripts/settings/fx/effect_templates/companion_servo_skull_moving_effect.lua

local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local SOURCE_NAME = "base"
local SOUND_ALIAS = "companion_cryptic_servitor_loop"
local PROFILE_PROPERTIES_SWITCH = ""
local resources = {}
local effect_template = {
	name = "companion_servo_skull_moving_effect",
	resources = resources,
	start = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local unit = template_data.unit

		if not ALIVE[unit] then
			return
		end

		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if not fx_extension then
			return
		end

		local world = Unit.world(unit)

		if not world then
			return
		end

		local wwise_world = World.get_data(world, "wwise_world")

		if not wwise_world then
			return
		end

		local source_id = fx_extension:sound_source(SOURCE_NAME)
		local playing_id = CompanionVisualLoadout.trigger_gear_sound(unit, source_id, SOUND_ALIAS, PROFILE_PROPERTIES_SWITCH)

		template_data.playing_id = playing_id
		template_data.source_id = source_id
		template_data.wwise_world = wwise_world
		template_data.flying_companion_movement_extension = ScriptUnit.extension(unit, "flying_companion_movement_system")
	end,
	update = function (template_data, template_context, dt, t)
		if DEDICATED_SERVER then
			return
		end

		local flying_companion_movement_extension = template_data.flying_companion_movement_extension
		local velocity = flying_companion_movement_extension:current_velocity()
		local speed = Vector3.length(velocity:unbox())

		WwiseWorld.set_source_parameter(template_data.wwise_world, template_data.source_id, "servitor_speed", speed)

		local angle = flying_companion_movement_extension:angle_between_velocity_and_player_forward()

		WwiseWorld.set_source_parameter(template_data.wwise_world, template_data.source_id, "servitor_direction", angle)
	end,
	stop = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local wwise_world = template_context.wwise_world
		local playing_id = template_data.playing_id

		if playing_id then
			WwiseWorld.stop_event(wwise_world, playing_id)
		end

		template_data.source_id = nil
		template_data.playing_id = nil
		template_data.stop_event_name = nil
	end,
}

return effect_template
