-- chunkname: @scripts/components/broadphase.lua

local Broadphase = component("Broadphase")

Broadphase.init = function (self, unit)
	self:enable(unit)

	local broadphase_extension = ScriptUnit.fetch_component_extension(unit, "broadphase_system")

	if broadphase_extension then
		local broadphase_categories = self:get_data(unit, "broadphase_categories")
		local broadphase_radius = self:get_data(unit, "broadphase_radius")
		local broadphase_node_name = self:get_data(unit, "broadphase_node_name")

		broadphase_extension:setup_from_component(broadphase_categories, broadphase_radius, broadphase_node_name)
	end
end

Broadphase.editor_init = function (self, unit)
	self:enable(unit)
end

Broadphase.editor_validate = function (self, unit)
	local success = true
	local error_message = ""
	local broadphase_node_name = self:get_data(unit, "broadphase_node_name")

	if broadphase_node_name == "" then
		error_message = error_message .. "\nBroadphase Node Name can't be empty"
		success = false
	elseif not Unit.has_node(unit, broadphase_node_name) then
		error_message = error_message .. "\nmissing unit node '" .. broadphase_node_name .. "'"
		success = false
	end

	return success, error_message
end

Broadphase.enable = function (self, unit)
	return
end

Broadphase.disable = function (self, unit)
	return
end

Broadphase.destroy = function (self, unit)
	return
end

Broadphase.component_data = {
	broadphase_categories = {
		value = "doors",
		ui_type = "combo_box",
		ui_name = "Broadphase Categories",
		options_keys = {
			"doors"
		},
		options_values = {
			"doors"
		}
	},
	broadphase_radius = {
		ui_type = "number",
		value = 1,
		ui_name = "Broadphase Radius",
		decimals = 2
	},
	broadphase_node_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "Broadphase Node Name"
	},
	extensions = {
		"BroadphaseExtension"
	}
}

return Broadphase
