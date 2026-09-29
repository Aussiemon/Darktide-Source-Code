-- chunkname: @scripts/extension_systems/unit_templates/predicted_unit_unit_template.lua

local NetworkLookup = require("scripts/network_lookup/network_lookup")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local predictable_units = {}

table.sort(predictable_units)
table.mirror_array_inplace(predictable_units)

local predicted_unit_unit_template = {
	local_unit = function (unit_name, position, rotation, material, peer_id, local_player_id, action_component_name)
		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local unit_name_id = GameSession.game_object_field(session, object_id, "unit_name_id")
		local unit_name = predictable_units[unit_name_id]
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function (prop_settings)
		return "predicted_unit"
	end,
	local_init = function (unit, config, template_context, game_object_data, unit_name, peer_id, local_player_id, action_component_name, action_component_context_id)
		config:add("PredictedUnitExtension", {
			owner_peer_id = peer_id,
			owner_local_player_id = local_player_id,
			action_component_name = action_component_name,
			action_component_context_id = action_component_context_id,
		})

		local action_component_id = NetworkLookup.action_handler_component_names[action_component_name]

		game_object_data.action_component_id = action_component_id
		game_object_data.action_component_context_id = action_component_context_id
		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)
		game_object_data.owner_peer_id = peer_id
		game_object_data.owner_local_player_id = local_player_id
		game_object_data.unit_name_id = predictable_units[unit_name]
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local peer_id = GameSession.game_object_field(game_session, game_object_id, "owner_peer_id")
		local local_player_id = GameSession.game_object_field(game_session, game_object_id, "owner_local_player_id")
		local action_component_id = GameSession.game_object_field(game_session, game_object_id, "action_component_id")
		local action_component_name = NetworkLookup.action_handler_component_names[action_component_id]
		local action_component_context_id = GameSession.game_object_field(game_session, game_object_id, "action_component_context_id")

		config:add("PredictedUnitExtension", {
			owner_peer_id = peer_id,
			owner_local_player_id = local_player_id,
			action_component_name = action_component_name,
			action_component_context_id = action_component_context_id,
		})
	end,
}

return predicted_unit_unit_template
