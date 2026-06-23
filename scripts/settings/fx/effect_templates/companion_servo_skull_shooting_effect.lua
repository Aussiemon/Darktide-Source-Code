-- chunkname: @scripts/settings/fx/effect_templates/companion_servo_skull_shooting_effect.lua

local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local SOURCE_NAME = "fx_muzzle"
local SLOT_NAME = "slot_weapon"
local SOUND_ALIAS = "companion_servo_skull_shoot"
local resources = {}
local effect_template = {
	name = "companion_servo_skull_shooting_effect",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if not fx_extension then
			return
		end

		local visual_loadout_extension = ScriptUnit.extension(template_data.unit, "visual_loadout_system")
		local lookup_fx_sources = false
		local inventory_item = visual_loadout_extension:slot_item(SLOT_NAME)
		local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, SOURCE_NAME, lookup_fx_sources)

		template_data.attachment_unit = attachment_unit
		template_data.attachment_node = node

		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_auto_source(wwise_world, attachment_unit, node)
		local playing_id = CompanionVisualLoadout.trigger_gear_sound(unit, source_id, SOUND_ALIAS)

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
