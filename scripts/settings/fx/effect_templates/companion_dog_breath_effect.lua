-- chunkname: @scripts/settings/fx/effect_templates/companion_dog_breath_effect.lua

local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local SOURCE_NAME = "jaw"
local SOUND_ALIAS = "companion_breath_loop"
local PROFILE_PROPERTIES_SWITCH = "dog_voice_profile"
local resources = {}
local effect_template = {
	name = "companion_dog_breath_effect",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if not fx_extension then
			return
		end

		local source_id = fx_extension:sound_source(SOURCE_NAME)
		local playing_id, stop_event_name = CompanionVisualLoadout.trigger_looping_gear_sound(unit, source_id, SOUND_ALIAS, PROFILE_PROPERTIES_SWITCH)

		template_data.source_id = source_id
		template_data.playing_id = playing_id
		template_data.stop_event_name = stop_event_name
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
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

return effect_template
