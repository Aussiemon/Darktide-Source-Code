-- chunkname: @scripts/components/broadphase.lua

local Broadphase = component("Broadphase")

Broadphase.init = function (self, unit)
	self:enable(unit)

	local broadphase_extension = ScriptUnit.fetch_component_extension(unit, "broadphase_system")

	if broadphase_extension then
		local broadphase_category = self:get_data(unit, "broadphase_category")
		local broadphase_radius = self:get_data(unit, "broadphase_radius")
		local broadphase_node_name = self:get_data(unit, "broadphase_node_name")

		if broadphase_node_name == "" then
			broadphase_node_name = nil
		end

		broadphase_extension:setup_from_component(broadphase_category, broadphase_radius, broadphase_node_name)
	end
end

Broadphase.editor_init = function (self, unit)
	self:enable(unit)
end

Broadphase.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

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
	broadphase_category = {
		ui_name = "Broadphase Category",
		ui_type = "combo_box",
		value = "doors",
		options_keys = {
			"doors",
		},
		options_values = {
			"doors",
		},
	},
	broadphase_radius = {
		decimals = 2,
		ui_name = "Broadphase Radius",
		ui_type = "number",
		value = 1,
	},
	broadphase_node_name = {
		ui_name = "Broadphase Node Name",
		ui_type = "text_box",
		value = "",
	},
	extensions = {
		"BroadphaseExtension",
	},
}

return Broadphase
