-- chunkname: @scripts/extension_systems/unit_templates/shooting_range_locked_indicator_unit_template.lua

local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "shooting_range_locked_indicator"
local shooting_range_locked_indicator_unit_template = {
	local_unit = function (unit_name, position, rotation, material, ...)
		unit_name = "content/levels/training_grounds/fx/locked_sr_unit_indicator"

		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local unit_name = "content/levels/training_grounds/fx/locked_sr_unit_indicator"
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, battery_spawning_mode)
		local is_server = template_context.is_server

		config:add("InteracteeExtension", {})
		config:add("ComponentExtension")

		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		config:add("InteracteeExtension", {})
		config:add("ComponentExtension")
	end,
}

return shooting_range_locked_indicator_unit_template
