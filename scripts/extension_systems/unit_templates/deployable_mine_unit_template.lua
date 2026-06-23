-- chunkname: @scripts/extension_systems/unit_templates/deployable_mine_unit_template.lua

local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "deployable_mine"
local deployable_mine_unit_template = {
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
	local_unit_spawned = function (unit, template_context, game_object_data, item, projectile_template, starting_state, direction, speed, momentum_or_angular_velocity, owner_unit, is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item_or_nil, fuse_override_time_or_nil, owner_side_or_nil)
		local mine_settings_id = game_object_data.mine_settings_id
		local mine_settings_name = NetworkLookup.motion_triggered_explosives_settings[mine_settings_id]
		local optional_component_data = {
			setting_name = mine_settings_name,
		}
		local component_init_data = {
			owner_unit = owner_unit,
		}
		local starts_enabled = true
		local component_ext = ScriptUnit.extension(unit, "component_system")

		component_ext:add_component("MotionTriggeredExplosive", unit, starts_enabled, optional_component_data, component_init_data)
	end,
	husk_unit_spawned = function (unit, template_context, game_session, game_object_id, owner_id)
		local mine_settings_id = GameSession.game_object_field(game_session, game_object_id, "mine_settings_id")
		local mine_settings_name = NetworkLookup.motion_triggered_explosives_settings[mine_settings_id]
		local optional_component_data = {
			setting_name = mine_settings_name,
		}
		local owner_unit_id = GameSession.game_object_field(game_session, game_object_id, "owner_unit_id")
		local owner_unit

		if owner_unit_id ~= NetworkConstants.invalid_game_object_id then
			owner_unit = Managers.state.unit_spawner:unit(owner_unit_id)
		end

		local component_init_data = {
			owner_unit = owner_unit,
		}
		local starts_enabled = true
		local component_ext = ScriptUnit.extension(unit, "component_system")

		component_ext:add_component("MotionTriggeredExplosive", unit, starts_enabled, optional_component_data, component_init_data)
	end,
	local_init = function (unit, config, template_context, game_object_data, item, owner_side_or_nil, mine_settings_name, _, _, _, owner_unit)
		config:add("ComponentExtension")

		local side_system = Managers.state.extension:system("side_system")
		local side = owner_side_or_nil and side_system:get_side_from_name(owner_side_or_nil)
		local side_id = side and side.side_id

		game_object_data.side_id = side_id
		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)

		local mine_settings_id = NetworkLookup.motion_triggered_explosives_settings[mine_settings_name]

		game_object_data.mine_settings_id = mine_settings_id

		local owner_unit_id = owner_unit and Managers.state.unit_spawner:game_object_id(owner_unit) or NetworkConstants.invalid_game_object_idend

		game_object_data.owner_unit_id = owner_unit_id

		local item_name = item.name
		local item_id = NetworkLookup.player_item_names[item_name]

		game_object_data.item_id = item_id

		config:parse_unit(unit)
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		config:add("ComponentExtension")
		config:parse_unit(unit)
	end,
}

return deployable_mine_unit_template
