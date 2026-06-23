-- chunkname: @scripts/extension_systems/unit_templates/smoke_fog_unit_template.lua

local NetworkLookup = require("scripts/network_lookup/network_lookup")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "smoke_screen"
local smoke_fog_unit_template = {
	local_unit = function (unit_name, position, rotation, ...)
		local yaw_rotation = Quaternion.from_yaw_pitch_roll(Quaternion.yaw(rotation), 0, 0)

		return unit_name, position, yaw_rotation
	end,
	husk_unit = function (session, object_id)
		local unit_name_id = GameSession.game_object_field(session, object_id, "unit_name_id")
		local unit_name = NetworkLookup.smoke_fog_unit[unit_name_id]
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, husk_unit_name, placed_on_unit, owner_unit, smoke_fog_template)
		local is_server = template_context.is_server

		config:add("DeployableUnitLocomotionExtension", {
			placed_on_unit = placed_on_unit,
		})
		config:add("SmokeFogExtension", {
			owner_unit = owner_unit,
			duration = smoke_fog_template.duration,
			inner_radius = smoke_fog_template.inner_radius,
			outer_radius = smoke_fog_template.outer_radius,
			block_line_of_sight = smoke_fog_template.block_line_of_sight,
			in_fog_buff_template_name = smoke_fog_template.in_fog_buff_template_name,
			leaving_fog_buff_template_name = smoke_fog_template.leaving_fog_buff_template_name,
		})

		local rotation = Unit.local_rotation(unit, 1)

		game_object_data.unit_name_id = NetworkLookup.smoke_fog_unit[husk_unit_name]
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

			local player_unit_spawn_manager = Managers.state.player_unit_spawn
			local owner = player_unit_spawn_manager:owner(owner_unit)

			if owner then
				player_unit_spawn_manager:assign_unit_ownership(unit, owner)
			end
		else
			game_object_data.owner_unit_id = NetworkConstants.invalid_game_object_id
		end
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local owner_unit_id = GameSession.game_object_field(game_session, game_object_id, "owner_unit_id")

		if owner_unit_id ~= NetworkConstants.invalid_game_object_id then
			local owner_unit = Managers.state.unit_spawner:unit(owner_unit_id)
			local player_unit_spawn_manager = Managers.state.player_unit_spawn
			local owner = player_unit_spawn_manager:owner(owner_unit)

			if owner then
				player_unit_spawn_manager:assign_unit_ownership(unit, owner)
			end
		end

		config:add("DeployableHuskLocomotionExtension", {})
		config:add("SmokeFogHuskExtension", {})
	end,
	pre_unit_destroyed = function (unit)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local has_owner = player_unit_spawn_manager:owner(unit) ~= nil

		if has_owner then
			player_unit_spawn_manager:relinquish_unit_ownership(unit)
		end
	end,
}

return smoke_fog_unit_template
