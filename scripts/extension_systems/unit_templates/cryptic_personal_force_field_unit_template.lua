-- chunkname: @scripts/extension_systems/unit_templates/cryptic_personal_force_field_unit_template.lua

local NetworkLookup = require("scripts/network_lookup/network_lookup")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "cryptic_personal_force_field"
local cryptic_personal_force_field_unit_template = {
	local_unit = function (unit_name, position, rotation, ...)
		local yaw_rotation = Quaternion.from_yaw_pitch_roll(Quaternion.yaw(rotation), 0, 0)

		return unit_name, position, yaw_rotation
	end,
	husk_unit = function (session, object_id)
		local unit_name_id = GameSession.game_object_field(session, object_id, "unit_name_id")
		local unit_name = NetworkLookup.force_field_unit_names[unit_name_id]
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, husk_unit_name, owner_unit, max_duration)
		local is_server = template_context.is_server

		config:add("CrypticPersonalForceFieldUnitExtension", {
			owner_unit = owner_unit,
			max_duration = max_duration,
		})
		config:add("CrypticPersonalForceFieldUnitHealthExtension", {
			owner_unit = owner_unit,
		})

		game_object_data.unit_name_id = NetworkLookup.force_field_unit_names[husk_unit_name]
		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.max_duration = max_duration
		game_object_data.remaining_duration = max_duration

		if owner_unit then
			local _, owner_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(owner_unit)

			game_object_data.owner_unit_id = owner_unit_id
		else
			game_object_data.owner_unit_id = NetworkConstants.invalid_game_object_id
		end
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local owner_unit_id = GameSession.game_object_field(game_session, game_object_id, "owner_unit_id")
		local owner_unit

		if owner_unit_id ~= NetworkConstants.invalid_game_object_id then
			owner_unit = Managers.state.unit_spawner:unit(owner_unit_id)
		end

		local max_duration = GameSession.game_object_field(game_session, game_object_id, "max_duration")

		config:add("CrypticPersonalForceFieldUnitExtension", {
			owner_unit = owner_unit,
			max_duration = max_duration,
		})
		config:add("CrypticPersonalForceFieldHuskHealthExtension", {})
	end,
}

return cryptic_personal_force_field_unit_template
