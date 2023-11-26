-- chunkname: @scripts/components/mission_objective_zone.lua

local MissionObjectiveZoneUtilites = require("scripts/extension_systems/mission_objective/utilities/mission_objective_zone")
local MissionObjectiveZone = component("MissionObjectiveZone")
local ZONE_TYPES = MissionObjectiveZoneUtilites.ZONE_TYPES

MissionObjectiveZone.init = function (self, unit)
	local mission_objective_zone_extension = ScriptUnit.fetch_component_extension(unit, "mission_objective_zone_system")

	if mission_objective_zone_extension then
		local zone_type = self:get_data(unit, "zone_type")

		if zone_type == ZONE_TYPES.capture then
			local num_player_in_zone = self:get_data(unit, "num_player_in_zone")
			local time_in_zone = self:get_data(unit, "time_in_zone")

			mission_objective_zone_extension:setup_from_component(num_player_in_zone, time_in_zone, ZONE_TYPES.capture)
		elseif zone_type == ZONE_TYPES.scan then
			local num_scannable_objects = self:get_data(unit, "num_scannable_objects")
			local max_scannable_objects_per_player = self:get_data(unit, "max_scannable_objects_per_player")
			local item_to_equip = self:get_data(unit, "item_to_equip")

			mission_objective_zone_extension:setup_from_component(num_scannable_objects, max_scannable_objects_per_player, ZONE_TYPES.scan, item_to_equip)
		end

		if false then
			-- Nothing
		end
	end
end

MissionObjectiveZone.editor_init = function (self, unit)
	return
end

MissionObjectiveZone.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_volume(unit, "g_mission_objective_zone_volume") then
		success = false
		error_message = error_message .. "\nMissing volume 'g_mission_objective_zone_volume'"
	end

	if self:get_data(unit, "zone_type") == "default" then
		success = false
		error_message = error_message .. "\nNeed to choose a zone type for Unit"
	end

	return success, error_message
end

MissionObjectiveZone.enable = function (self, unit)
	return
end

MissionObjectiveZone.disable = function (self, unit)
	return
end

MissionObjectiveZone.destroy = function (self, unit)
	return
end

MissionObjectiveZone.component_data = {
	zone_type = {
		value = "default",
		ui_type = "combo_box",
		ui_name = "Zone type",
		options_keys = {
			"Default",
			"Capture",
			"Scan"
		},
		options_values = {
			"default",
			"capture",
			"scan"
		}
	},
	num_player_in_zone = {
		ui_type = "number",
		value = 1,
		ui_name = "Players in zone",
		category = "Capture"
	},
	time_in_zone = {
		ui_type = "number",
		value = 5,
		ui_name = "Time in zone",
		category = "Capture"
	},
	num_scannable_objects = {
		value = 3,
		ui_type = "number",
		category = "Scan",
		decimals = 0,
		ui_name = "Amount of scannable objects"
	},
	max_scannable_objects_per_player = {
		ui_type = "number",
		min = 2,
		decimals = 0,
		category = "Scan",
		value = 5,
		ui_name = "Max amount scannable objects per player",
		max = 5
	},
	item_to_equip = {
		ui_type = "resource",
		value = "",
		ui_name = "Item to Equip (scanner, decoder...)",
		filter = "item"
	},
	extensions = {
		"MissionObjectiveZoneBaseExtension"
	}
}

return MissionObjectiveZone
