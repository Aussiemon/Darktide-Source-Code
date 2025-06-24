-- chunkname: @scripts/settings/fx/effect_templates/companion_dog_bark.lua

local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local SOURCE_NAME = "jaw"
local SOUND_ALIAS = "companion_bark"
local PROFILE_PROPERTIES_SWITCH = "dog_voice_profile"
local resources = {}
local effect_template = {
	name = "companion_dog_bark",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if not fx_extension then
			return
		end

		local source_id = fx_extension:sound_source(SOURCE_NAME)
		local playing_id = CompanionVisualLoadout.trigger_gear_sound(unit, source_id, SOUND_ALIAS, PROFILE_PROPERTIES_SWITCH)

		template_data.source_id = source_id
		template_data.playing_id = playing_id
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		template_data.source_id = nil
		template_data.playing_id = nil
	end,
}

return effect_template
