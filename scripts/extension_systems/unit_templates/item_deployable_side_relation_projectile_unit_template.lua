-- chunkname: @scripts/extension_systems/unit_templates/item_deployable_side_relation_projectile_unit_template.lua

local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "item_deployable_side_relation_projectile"
local item_deployable_side_relation_projectile_unit_template = {
	local_unit = function (unit_name, position, rotation, material, item)
		unit_name = unit_name or Items.base_unit(item)

		return unit_name, position, rotation
	end,
	husk_unit = function (session, object_id)
		local item_definitions = MasterItems.get_cached()
		local item_id = GameSession.game_object_field(session, object_id, "item_id")
		local item_name = NetworkLookup.player_item_names[item_id]
		local item = item_definitions[item_name]
		local unit_name = Items.base_unit(item)
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, item, projectile_template, starting_state, direction, speed, momentum_or_angular_velocity, owner_unit, is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item_or_nil, fuse_override_time_or_nil, owner_side_or_nil)
		local is_server = template_context.is_server
		local side_system = Managers.state.extension:system("side_system")
		local side = owner_side_or_nil and side_system:get_side_from_name(owner_side_or_nil)
		local side_id = side and side.side_id

		if owner_unit then
			local side_extension = ScriptUnit.has_extension(owner_unit, "side_system")

			if side_extension then
				config:add("SideExtension", {
					side_id = side_id,
				})
			end

			local owner = Managers.state.player_unit_spawn:owner(owner_unit)

			if owner then
				Managers.state.player_unit_spawn:assign_unit_ownership(unit, owner)
			end

			local owner_game_object_id = owner_unit and Managers.state.unit_spawner:game_object_id(owner_unit) or NetworkConstants.invalid_game_object_id

			game_object_data.owner_unit_id = owner_game_object_id

			local owner_weapon_extension = ScriptUnit.has_extension(owner_unit, "weapon_system")

			if owner_weapon_extension then
				local damage_profile_lerp_values = owner_weapon_extension:damage_profile_lerp_values()
				local explosion_template_lerp_values = owner_weapon_extension:explosion_template_lerp_values()

				config:add("ProjectileUnitWeaponExtension", {
					damage_profile_lerp_values = damage_profile_lerp_values,
					explosion_template_lerp_values = explosion_template_lerp_values,
				})
			end

			local owner_buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

			if owner_buff_extension then
				local stat_buffs = owner_buff_extension:stat_buffs()
				local keywords = owner_buff_extension:keywords()

				config:add("ProjectileUnitBuffExtension", {
					stat_buffs = table.shallow_copy(stat_buffs),
					keywords = table.shallow_copy(keywords),
				})
			end
		end

		config:add("ProjectileDamageExtension", {
			projectile_template = projectile_template,
			owner_unit = owner_unit,
			charge_level = charge_level,
			is_critical_strike = is_critical_strike,
			origin_item_slot = origin_item_slot,
			weapon_item_or_nil = weapon_item_or_nil or item,
			fuse_override_time_or_nil = fuse_override_time_or_nil,
			owner_side_or_nil = owner_side_or_nil,
		})

		local item_name = item.name
		local item_id = NetworkLookup.player_item_names[item_name]
		local projectile_template_name = projectile_template.name
		local projectile_template_name_id = NetworkLookup.projectile_template_names[projectile_template_name]

		config:add("ProjectileFxExtension", {
			projectile_template_name = projectile_template_name,
			charge_level = charge_level,
			is_critical_strike = is_critical_strike,
			owner_unit = owner_unit,
		})
		config:add("ProjectileUnitLocomotionExtension", {
			handle_oob_despawning = true,
			starting_state = starting_state,
			projectile_template_name = projectile_template_name,
			direction = direction,
			speed = speed,
			momentum_or_angular_velocity = momentum_or_angular_velocity,
			owner_unit = owner_unit,
			target_unit = target_unit,
			target_position = target_position,
			optional_item = item,
		})

		local relation_init_data = projectile_template.deployable.relation_init_data

		if relation_init_data then
			local broadphase_system = Managers.state.extension:system("broadphase_system")
			local broadphase = broadphase_system.broadphase

			config:add("SideRelationProximityExtension", {
				owner_unit_or_nil = owner_unit,
				broadphase = broadphase,
				relation_init_data = relation_init_data,
			})
		end

		if projectile_template.uses_script_components then
			config:add("ComponentExtension")
		end

		game_object_data.item_id = item_id
		game_object_data.projectile_template_id = projectile_template_name_id
		game_object_data.charge_level = charge_level
		game_object_data.is_critical_strike = is_critical_strike
		game_object_data.side_id = side_id

		local spawn_flow_event = projectile_template.spawn_flow_event

		if spawn_flow_event then
			Unit.flow_event(unit, spawn_flow_event)
		end
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local go_field = GameSession.game_object_field
		local projectile_template_name_id = go_field(game_session, game_object_id, "projectile_template_id")
		local projectile_template_name = NetworkLookup.projectile_template_names[projectile_template_name_id]
		local owner_unit_id = go_field(game_session, game_object_id, "owner_unit_id")
		local owner_unit

		if owner_unit_id ~= NetworkConstants.invalid_game_object_id then
			owner_unit = Managers.state.unit_spawner:unit(owner_unit_id)
		end

		local owner = owner_unit and Managers.state.player_unit_spawn:owner(owner_unit)

		if owner then
			Managers.state.player_unit_spawn:assign_unit_ownership(unit, owner)
		end

		local item_definitions = MasterItems.get_cached()
		local item_id = go_field(game_session, game_object_id, "item_id")
		local item_name = NetworkLookup.player_item_names[item_id]
		local item = item_definitions[item_name]
		local charge_level = go_field(game_session, game_object_id, "charge_level")
		local is_critical_strike = go_field(game_session, game_object_id, "is_critical_strike")

		config:add("ProjectileFxExtension", {
			projectile_template_name = projectile_template_name,
			charge_level = charge_level,
			is_critical_strike = is_critical_strike,
			owner_unit = owner_unit,
		})
		config:add("ProjectileHuskLocomotionExtension", {
			hide_until_initial_interpolation_start = true,
			projectile_template_name = projectile_template_name,
			optional_item = item,
		})

		local projectile_template = ProjectileTemplates[projectile_template_name]

		if projectile_template.uses_script_components then
			config:add("ComponentExtension")
		end

		local spawn_flow_event = projectile_template.spawn_flow_event

		if spawn_flow_event then
			Unit.flow_event(unit, spawn_flow_event)
		end
	end,
	local_unit_spawned = function (unit, template_context, game_object_data, item, projectile_template, starting_state, direction, speed, momentum_or_angular_velocity, owner_unit, is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item_or_nil, fuse_override_time_or_nil, owner_side_or_nil)
		Unit.flow_event(unit, "lua_extensions_ready")
	end,
	husk_unit_spawned = function (unit, template_context, game_session, game_object_id, owner_id)
		Unit.flow_event(unit, "lua_extensions_ready")
	end,
	pre_unit_destroyed = function (unit)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local has_owner = player_unit_spawn_manager:owner(unit) ~= nil

		if has_owner then
			player_unit_spawn_manager:relinquish_unit_ownership(unit)
		end
	end,
}

return item_deployable_side_relation_projectile_unit_template
