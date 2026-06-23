-- chunkname: @scripts/extension_systems/unit_templates/level_prop_unit_template.lua

local LevelProps = require("scripts/settings/level_prop/level_props")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local level_prop_unit_template = {
	local_unit = function (unit_name, position, rotation, material, prop_settings, placed_on_unit, spawn_interaction_cooldown)
		unit_name = unit_name or prop_settings.unit_name

		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local prop_id = GameSession.game_object_field(session, object_id, "prop_id")
		local prop_name = NetworkLookup.level_props_names[prop_id]
		local prop_settings = LevelProps[prop_name]
		local unit_name = prop_settings.unit_name
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function (prop_settings)
		local game_object_type = prop_settings.game_object_type

		return game_object_type
	end,
	local_init = function (unit, config, template_context, game_object_data, prop_settings)
		config:parse_unit(unit)

		local prop_name = prop_settings.name
		local prop_id = NetworkLookup.level_props_names[prop_name]

		game_object_data.prop_id = prop_id
		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		config:parse_unit(unit)
	end,
}

return level_prop_unit_template
