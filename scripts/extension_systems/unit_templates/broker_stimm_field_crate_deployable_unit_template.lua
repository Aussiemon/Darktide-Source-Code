-- chunkname: @scripts/extension_systems/unit_templates/broker_stimm_field_crate_deployable_unit_template.lua

local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "broker_stimm_field_crate_deployable"
local broker_stimm_field_crate_deployable_unit_template = {
	local_unit = function (unit_name, position, rotation, material, ...)
		unit_name = "content/pickups/pocketables/broker_medical_crate/broker_deployable_medical_crate"

		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local unit_name = "content/pickups/pocketables/broker_medical_crate/broker_deployable_medical_crate"
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, side_id, deployable, placed_on_unit, owner_unit)
		local is_server = template_context.is_server

		Unit.set_data(unit, "deployable_type", "medical_crate")

		local radius, categories = 1, {
			"deployable",
		}

		config:add("BroadphaseExtension", {
			moving = false,
			radius = radius,
			categories = categories,
		})
		config:add("SideExtension", {
			side_id = side_id,
		})

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local relation_init_data = {
			allied = {
				proximity_radius = deployable.proximity_radius,
				stickiness_limit = deployable.stickiness_limit,
				stickiness_time = deployable.stickiness_time,
				logic = {
					{
						class_name = "ProximityBrokerStimmField",
						use_as_job = true,
						init_data = deployable.proximity_init_data,
					},
				},
			},
		}

		config:add("SideRelationProximityExtension", {
			owner_unit_or_nil = owner_unit,
			broadphase = broadphase,
			relation_init_data = relation_init_data,
		})
		config:add("PointOfInterestTargetExtension", {
			tag = "healthstation",
			view_distance = nil,
		})
		config:add("ComponentExtension")
		config:add("SmartTagExtension", {
			auto_tag_on_spawn = false,
			target_type = "medical_crate_deployable",
		})
		config:add("DeployableUnitLocomotionExtension", {
			placed_on_unit = placed_on_unit,
		})

		game_object_data.side_id = side_id
		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)

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

		Unit.flow_event(unit, "lua_deploy")
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local go_field = GameSession.game_object_field
		local side_id = go_field(game_session, game_object_id, "side_id")
		local owner_unit_id = GameSession.game_object_field(game_session, game_object_id, "owner_unit_id")

		if owner_unit_id ~= NetworkConstants.invalid_game_object_id then
			local owner_unit = Managers.state.unit_spawner:unit(owner_unit_id)
			local player_unit_spawn_manager = Managers.state.player_unit_spawn
			local owner = player_unit_spawn_manager:owner(owner_unit)

			if owner then
				player_unit_spawn_manager:assign_unit_ownership(unit, owner)
			end
		end

		config:add("SideExtension", {
			side_id = side_id,
		})
		config:add("ComponentExtension")
		config:add("HuskCoherencyExtension")
		config:add("SmartTagExtension", {
			target_type = "medical_crate_deployable",
		})
		config:add("DeployableHuskLocomotionExtension", {})
		Unit.flow_event(unit, "lua_deploy")
	end,
	local_unit_spawned = function (unit, template_context, game_object_data, side_id, deployable, placed_on_unit, owner_unit_or_nil)
		local job_class = ScriptUnit.extension(unit, "proximity_system")

		Managers.state.unit_job:register_job(unit, job_class, true)
	end,
	pre_unit_destroyed = function (unit)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local has_owner = player_unit_spawn_manager:owner(unit) ~= nil

		if has_owner then
			player_unit_spawn_manager:relinquish_unit_ownership(unit)
		end
	end,
}

return broker_stimm_field_crate_deployable_unit_template
