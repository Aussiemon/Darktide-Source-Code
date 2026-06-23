-- chunkname: @scripts/extension_systems/unit_templates/health_station_unit_template.lua

local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "health_station"
local health_station_unit_template = {
	local_unit = function (unit_name, position, rotation, material, ...)
		unit_name = "content/environment/gameplay/health_station/health_station"

		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local unit_name = "content/environment/gameplay/health_station/health_station"
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, battery_spawning_mode)
		local is_server = template_context.is_server

		config:add("InteracteeExtension", {
			is_local_unit = false,
			interaction_contexts = PlayerCharacterConstants.player_interactions,
		})
		config:add("DialogueExtension", {
			selected_voice = "medicae_servitor",
		})
		config:add("PickupSpawnerExtension")
		config:add("PointOfInterestTargetExtension", {
			tag = "healthstation",
			view_distance = nil,
		})
		config:add("PropAnimationExtension")
		config:add("HealthStationExtension")
		config:add("SmartTagExtension", {
			auto_tag_on_spawn = false,
			target_type = "health_station",
		})
		config:add("ComponentExtension")

		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		config:add("InteracteeExtension", {
			is_local_unit = false,
			interaction_contexts = PlayerCharacterConstants.player_interactions,
		})
		config:add("DialogueExtension", {
			selected_voice = "medicae_servitor",
		})
		config:add("PickupSpawnerExtension")
		config:add("PointOfInterestTargetExtension", {
			tag = "healthstation",
			view_distance = nil,
		})
		config:add("PropAnimationExtension")
		config:add("HealthStationExtension")
		config:add("SmartTagExtension", {
			auto_tag_on_spawn = false,
			target_type = "health_station",
		})
		config:add("ComponentExtension")
	end,
}

return health_station_unit_template
