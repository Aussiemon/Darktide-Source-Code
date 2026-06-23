-- chunkname: @scripts/extension_systems/unit_templates/expedition_airstrike_supply_unit_template.lua

local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "expedition_airstrike_supply"
local expedition_airstrike_supply_unit_template = {
	local_unit = function (unit_name, position, rotation, material, prop_settings, placed_on_unit, spawn_interaction_cooldown)
		unit_name = unit_name or prop_settings.unit_name

		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local unit_name = "content/environment/artsets/imperial/expeditions/airstrike/supply_drop/stock_pallet_crates_supply_drop_01"
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, force_direction_boxed)
		local interaction_type = "chest"
		local description = "airstrike_supply_drop"
		local interaction_icon = "content/ui/materials/hud/interactions/icons/environment_generic"
		local optional_spawn_interaction_cooldown
		local start_inactive = true

		config:add("InteracteeExtension", {
			interaction_type = interaction_type,
			spawn_interaction_cooldown = optional_spawn_interaction_cooldown,
			start_inactive = start_inactive,
			override_context = {
				description = description,
				interaction_icon = interaction_icon,
			},
		})
		config:add("ChestExtension")
		config:add("ComponentExtension")
		config:parse_unit(unit)

		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)

		local force_direction = force_direction_boxed:unbox()

		game_object_data.force_direction = force_direction
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local interaction_type = "chest"
		local description = "airstrike_supply_drop"
		local interaction_icon = "content/ui/materials/hud/interactions/icons/environment_generic"
		local optional_spawn_interaction_cooldown
		local start_inactive = true

		config:add("InteracteeExtension", {
			interaction_type = interaction_type,
			spawn_interaction_cooldown = optional_spawn_interaction_cooldown,
			start_inactive = start_inactive,
			override_context = {
				description = description,
				interaction_icon = interaction_icon,
			},
		})
		config:add("ComponentExtension")
		config:parse_unit(unit)
	end,
}

return expedition_airstrike_supply_unit_template
