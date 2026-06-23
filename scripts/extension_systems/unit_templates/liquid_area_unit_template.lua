-- chunkname: @scripts/extension_systems/unit_templates/liquid_area_unit_template.lua

local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local GAME_OBJECT_TYPE = "liquid_area"
local liquid_area_unit_template = {
	local_unit = function (nil_unit_name, position, ...)
		local unit_name = "content/liquid_area/empty_unit/empty_unit"

		return unit_name, position
	end,
	husk_unit = function (session, object_id)
		local unit_name = "content/liquid_area/empty_unit/empty_unit"
		local position = GameSession.game_object_field(session, object_id, "position")

		return unit_name, position
	end,
	game_object_type = function (...)
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, liquid_area_template, flow_direction_or_nil, optional_source_unit, optional_max_liquid, optional_liquid_paint_id, optional_source_item, optional_source_side)
		local source_unit = optional_source_unit

		config:add("LiquidAreaExtension", {
			template = liquid_area_template,
			flow_direction_or_nil = flow_direction_or_nil,
			source_unit = source_unit,
			optional_max_liquid = optional_max_liquid,
			optional_liquid_paint_id = optional_liquid_paint_id,
			optional_source_item = optional_source_item,
			optional_source_side = optional_source_side,
		})

		local liquid_area_template_name = liquid_area_template.name

		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.liquid_area_template_id = NetworkLookup.liquid_area_template_names[liquid_area_template_name]
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local liquid_area_template_id = GameSession.game_object_field(game_session, game_object_id, "liquid_area_template_id")
		local liquid_area_template_name = NetworkLookup.liquid_area_template_names[liquid_area_template_id]
		local liquid_area_template = LiquidAreaTemplates[liquid_area_template_name]

		config:add("HuskLiquidAreaExtension", {
			template = liquid_area_template,
		})
	end,
}

return liquid_area_unit_template
