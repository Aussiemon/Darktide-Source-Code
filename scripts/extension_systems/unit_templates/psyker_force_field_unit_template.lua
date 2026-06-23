-- chunkname: @scripts/extension_systems/unit_templates/psyker_force_field_unit_template.lua

local Deployables = require("scripts/settings/deployables/deployables")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "psyker_force_field"
local psyker_force_field_unit_template = {
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
	local_init = function (unit, config, template_context, game_object_data, husk_unit_name, placed_on_unit, owner_unit, shape_override, ability_type, deployable_settings)
		local is_server = template_context.is_server

		if shape_override == nil then
			shape_override = "none"
		end

		config:add("DeployableUnitLocomotionExtension", {
			placed_on_unit = placed_on_unit,
		})
		config:add("PsykerForceFieldUnitExtension", {
			owner_unit = owner_unit,
			shape_override = shape_override,
			deployable_settings = deployable_settings,
		})
		config:add("PsykerForceFieldUnitHealthExtension", {
			owner_unit = owner_unit,
			ability_type = ability_type,
			deployable_settings = deployable_settings,
		})

		local rotation = Unit.local_rotation(unit, 1)

		game_object_data.unit_name_id = NetworkLookup.force_field_unit_names[husk_unit_name]
		game_object_data.shape_override = NetworkLookup.force_field_shape_overrides[shape_override]
		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.yaw = Quaternion.yaw(rotation)
		game_object_data.pitch = 0

		if placed_on_unit then
			local _, placed_on_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(placed_on_unit)

			game_object_data.placed_on_unit_id = placed_on_unit_id
		end

		if owner_unit then
			local _, owner_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(owner_unit)

			game_object_data.owner_unit_id = owner_unit_id
		else
			game_object_data.owner_unit_id = NetworkConstants.invalid_game_object_id
		end

		game_object_data.deployable_settings_id = NetworkLookup.deployable_settings[deployable_settings and deployable_settings.name or "n/a"]
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local owner_unit_id = GameSession.game_object_field(game_session, game_object_id, "owner_unit_id")
		local owner_unit

		if owner_unit_id ~= NetworkConstants.invalid_game_object_id then
			owner_unit = Managers.state.unit_spawner:unit(owner_unit_id)
		end

		local shape_override_id = GameSession.game_object_field(game_session, game_object_id, "shape_override")
		local shape_override = NetworkLookup.force_field_shape_overrides[shape_override_id]
		local deplyable_settings_id = GameSession.game_object_field(game_session, game_object_id, "deployable_settings_id")
		local deployable_settings_name = NetworkLookup.deployable_settings[deplyable_settings_id]
		local deployable_settings = deployable_settings_name ~= "n/a" and Deployables[deployable_settings_name] or nil

		config:add("DeployableHuskLocomotionExtension", {})
		config:add("PsykerForceFieldUnitExtension", {
			owner_unit = owner_unit,
			shape_override = shape_override,
			deployable_settings = deployable_settings,
		})
		config:add("PsykerForceFieldHuskHealthExtension", {})
	end,
}

return psyker_force_field_unit_template
