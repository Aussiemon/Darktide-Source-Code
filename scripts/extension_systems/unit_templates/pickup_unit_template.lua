-- chunkname: @scripts/extension_systems/unit_templates/pickup_unit_template.lua

local Component = require("scripts/utilities/component")
local MasterItems = require("scripts/backend/master_items")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local Pickups = require("scripts/settings/pickup/pickups")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")

local function _pickup_broadphase_radius_and_categories(pickup_settings)
	local group_name = pickup_settings.group
	local radius, categories = 1, {
		"pickups",
		group_name,
	}

	return radius, categories
end

local pickup_unit_template = {
	local_unit = function (unit_name, position, rotation, material, pickup_settings, ...)
		unit_name = unit_name or pickup_settings.unit_name

		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local pickup_id = GameSession.game_object_field(session, object_id, "pickup_id")
		local pickup_name = NetworkLookup.pickup_names[pickup_id]
		local pickup_settings = Pickups.by_name[pickup_name]
		local unit_name = pickup_settings.unit_name
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function (pickup_settings)
		local game_object_type = pickup_settings.game_object_type

		return game_object_type
	end,
	local_init = function (unit, config, template_context, game_object_data, pickup_settings, optional_placed_on_unit, optional_spawn_interaction_cooldown, optional_origin_player)
		local is_server = template_context.is_server
		local pickup_name = pickup_settings.name

		Unit.set_data(unit, "pickup_type", pickup_name)
		Unit.set_data(unit, "is_pickup", true)

		local radius, categories = _pickup_broadphase_radius_and_categories(pickup_settings)

		config:add("BroadphaseExtension", {
			moving = false,
			radius = radius,
			categories = categories,
		})

		local projectile_template_name_id
		local pickup_group = pickup_settings.group

		if pickup_group == "luggable" then
			local projectile_template = pickup_settings.projectile_template
			local projectile_template_name = projectile_template.name

			projectile_template_name_id = NetworkLookup.projectile_template_names[projectile_template_name]

			local inventory_item = pickup_settings.inventory_item
			local item_definitions = MasterItems.get_cached()
			local item = item_definitions[inventory_item]

			if not item then
				Log.error("UnitTemplates", "missing inventory item: %s for luggable pickup: %s", inventory_item, pickup_name)

				item = MasterItems.find_fallback_item("slot_luggable")
			end

			config:add("MissionObjectiveTargetExtension")
			config:add("ProjectileUnitLocomotionExtension", {
				handle_oob_despawning = false,
				projectile_template_name = projectile_template_name,
				optional_item = item,
			})
			config:add("LuggableExtension")
			config:add("TriggerVolumeEventExtension")
		elseif pickup_group == "side_mission_collect" then
			config:add("MissionObjectiveTargetExtension")
			config:add("SideMissionPickupExtension")
		end

		if pickup_settings.deployable then
			config:add("DeployableUnitLocomotionExtension", {
				placed_on_unit = optional_placed_on_unit,
			})

			if optional_placed_on_unit then
				local _, placed_on_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(optional_placed_on_unit)

				game_object_data.placed_on_unit_id = placed_on_unit_id
			end
		end

		if pickup_group ~= "luggable" then
			config:add("PickupAnimationExtension")
		end

		local luggable_explosion_component_data = pickup_settings.luggable_explosion_component_data

		if luggable_explosion_component_data then
			config:add("PropHealthExtension", {
				health = luggable_explosion_component_data.max_health,
				has_health_bar = luggable_explosion_component_data.has_health_bar,
				hit_mass = luggable_explosion_component_data.hit_mass,
				is_unkillable = luggable_explosion_component_data.unkillable,
				is_invulnerable = luggable_explosion_component_data.invulnerable,
				invulnerable_when_carried = luggable_explosion_component_data.invulnerable_when_carried,
			})
		end

		config:add("InteracteeExtension", {
			interaction_type = pickup_settings.interaction_type,
			spawn_interaction_cooldown = optional_spawn_interaction_cooldown,
			override_context = {
				description = pickup_settings.description,
				extra_description = pickup_settings.extra_description,
				interaction_icon = pickup_settings.interaction_icon,
			},
		})
		config:add("PointOfInterestTargetExtension", {
			tag = pickup_settings.look_at_tag,
			view_distance = pickup_settings.look_at_distance,
		})

		if pickup_settings.smart_tag_target_type then
			config:add("SmartTagExtension", {
				target_type = pickup_settings.smart_tag_target_type,
				auto_tag_on_spawn = pickup_settings.auto_tag_on_spawn,
				origin_player = optional_origin_player,
			})
		end

		config:add("ComponentExtension")

		local pickup_id = NetworkLookup.pickup_names[pickup_name]

		game_object_data.pickup_id = pickup_id
		game_object_data.position = Unit.local_position(unit, 1)

		if pickup_group ~= "luggable" then
			local num_charges = pickup_settings.num_charges or 1

			game_object_data.charges = num_charges == math.huge and -1 or num_charges
		elseif pickup_group == "luggable" then
			game_object_data.projectile_template_id = projectile_template_name_id
		end

		local rotation = Unit.local_rotation(unit, 1)
		local game_object_type = pickup_settings.game_object_type

		if Network.object_has_field(game_object_type, "rotation") then
			game_object_data.rotation = rotation
		else
			game_object_data.yaw = Quaternion.yaw(rotation)
			game_object_data.pitch = Quaternion.pitch(rotation)
		end
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local go_field = GameSession.game_object_field
		local pickup_id = go_field(game_session, game_object_id, "pickup_id")
		local pickup_name = NetworkLookup.pickup_names[pickup_id]

		Unit.set_data(unit, "pickup_type", pickup_name)
		Unit.set_data(unit, "is_pickup", true)

		local pickup_settings = Pickups.by_name[pickup_name]
		local radius, categories = _pickup_broadphase_radius_and_categories(pickup_settings)

		config:add("BroadphaseExtension", {
			moving = false,
			radius = radius,
			categories = categories,
		})

		local pickup_group = pickup_settings.group

		if pickup_group == "luggable" then
			local projectile_template_name_id = go_field(game_session, game_object_id, "projectile_template_id")
			local projectile_template_name = NetworkLookup.projectile_template_names[projectile_template_name_id]
			local inventory_item = pickup_settings.inventory_item
			local item_definitions = MasterItems.get_cached()
			local item = item_definitions[inventory_item]

			config:add("MissionObjectiveTargetExtension")
			config:add("ProjectileHuskLocomotionExtension", {
				projectile_template_name = projectile_template_name,
				optional_item = item,
			})
			config:add("LuggableExtension")
		elseif pickup_group == "side_mission_collect" then
			config:add("MissionObjectiveTargetExtension")
			config:add("SideMissionPickupExtension")
		end

		if pickup_settings.deployable then
			config:add("DeployableHuskLocomotionExtension", {})
		end

		if pickup_group ~= "luggable" then
			config:add("PickupAnimationExtension")
		end

		local luggable_explosion_component_data = pickup_settings.luggable_explosion_component_data

		if luggable_explosion_component_data then
			config:add("PropHealthExtension", {
				has_health_bar = luggable_explosion_component_data.has_health_bar,
			})
		end

		config:add("InteracteeExtension", {
			interaction_type = pickup_settings.interaction_type,
			override_context = {
				description = pickup_settings.description,
				extra_description = pickup_settings.extra_description,
				interaction_icon = pickup_settings.interaction_icon,
			},
		})

		if pickup_settings.smart_tag_target_type then
			config:add("SmartTagExtension", {
				target_type = pickup_settings.smart_tag_target_type,
			})
		end

		config:add("ComponentExtension")
	end,
	local_unit_spawned = function (unit, template_context, game_object_data, pickup_settings, optional_placed_on_unit, optional_spawn_interaction_cooldown, optional_origin_player)
		if pickup_settings and pickup_settings.spawn_unit_component_event then
			Component.event(unit, pickup_settings.spawn_unit_component_event, pickup_settings)
		end

		if pickup_settings and pickup_settings.spawn_flow_event then
			Unit.flow_event(unit, pickup_settings.spawn_flow_event)
		end

		local luggable_explosion_component_data = pickup_settings.luggable_explosion_component_data

		if luggable_explosion_component_data then
			local starts_enabled = true
			local component_ext = ScriptUnit.extension(unit, "component_system")

			component_ext:add_component("PropHealth", unit, starts_enabled, luggable_explosion_component_data)
			component_ext:add_component("ExplosiveLuggable", unit, starts_enabled, luggable_explosion_component_data)
		end
	end,
	husk_unit_spawned = function (unit, template_context, game_session, game_object_id, owner_id)
		local pickup_name = Unit.get_data(unit, "pickup_type")
		local pickup_settings = Pickups.by_name[pickup_name]

		if pickup_settings and pickup_settings.spawn_unit_component_event then
			Component.event(unit, pickup_settings.spawn_unit_component_event, pickup_settings)
		end

		if pickup_settings and pickup_settings.spawn_flow_event then
			Unit.flow_event(unit, pickup_settings.spawn_flow_event)
		end

		local luggable_explosion_component_data = pickup_settings.luggable_explosion_component_data

		if luggable_explosion_component_data then
			local starts_enabled = true
			local component_ext = ScriptUnit.extension(unit, "component_system")

			component_ext:add_component("PropHealth", unit, starts_enabled, luggable_explosion_component_data)
			component_ext:add_component("ExplosiveLuggable", unit, starts_enabled, luggable_explosion_component_data)
		end
	end,
}

return pickup_unit_template
