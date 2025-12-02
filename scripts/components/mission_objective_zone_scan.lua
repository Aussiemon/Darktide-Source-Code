-- chunkname: @scripts/components/mission_objective_zone_scan.lua

local MissionObjectiveZoneScan = component("MissionObjectiveZoneScan")

MissionObjectiveZoneScan.init = function (self, unit)
	local mission_objective_zone_extension = ScriptUnit.fetch_component_extension(unit, "mission_objective_zone_system")

	if mission_objective_zone_extension then
		local num_scannable_objects = self:get_data(unit, "num_scannable_objects")
		local item_to_equip = self:get_data(unit, "item_to_equip")

		mission_objective_zone_extension:setup_from_component(num_scannable_objects, item_to_equip)
	end
end

MissionObjectiveZoneScan.editor_init = function (self, unit)
	return
end

MissionObjectiveZoneScan.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

MissionObjectiveZoneScan.editor_update = function (self, unit, dt)
	return
end

MissionObjectiveZoneScan.enable = function (self, unit)
	return
end

MissionObjectiveZoneScan.disable = function (self, unit)
	return
end

MissionObjectiveZoneScan.destroy = function (self, unit)
	return
end

MissionObjectiveZoneScan.component_data = {
	num_scannable_objects = {
		decimals = 0,
		ui_name = "Amount of scannable objects",
		ui_type = "number",
		value = 3,
	},
	item_to_equip = {
		filter = "item",
		ui_name = "Item to Equip (scanner, decoder...)",
		ui_type = "resource",
		value = "",
	},
	extensions = {
		"MissionObjectiveZoneScanExtension",
	},
}

return MissionObjectiveZoneScan
