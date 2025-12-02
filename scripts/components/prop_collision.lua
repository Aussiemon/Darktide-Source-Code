-- chunkname: @scripts/components/prop_collision.lua

local PropCollision = component("PropCollision")

PropCollision.init = function (self, unit)
	local prop_collision_extension = ScriptUnit.fetch_component_extension(unit, "prop_collision_system")

	if prop_collision_extension then
		self._prop_collision_extension = prop_collision_extension

		local shape = self:get_data(unit, "shape")
		local sphere_radius = self:get_data(unit, "sphere_radius")
		local polygon_nodes = self:get_data(unit, "polygon_nodes")

		prop_collision_extension:setup_from_component(shape, sphere_radius, polygon_nodes)
	end
end

PropCollision.editor_init = function (self, unit)
	return
end

PropCollision.enable = function (self, unit)
	return
end

PropCollision.disable = function (self, unit)
	return
end

PropCollision.destroy = function (self, unit)
	return
end

PropCollision.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

PropCollision.update_position = function (self)
	local prop_collision_extension = self._prop_collision_extension

	if prop_collision_extension then
		prop_collision_extension:update_position()
	end
end

PropCollision.component_data = {
	shape = {
		ui_name = "Shape",
		ui_type = "combo_box",
		value = "Sphere",
		options_keys = {
			"Sphere",
			"Polygon",
		},
		options_values = {
			"sphere",
			"polygon",
		},
	},
	sphere_radius = {
		category = "Sphere",
		ui_name = "Radius",
		ui_type = "number",
		value = 1,
	},
	polygon_nodes = {
		category = "Polygon",
		size = 0,
		ui_name = "Node Names",
		ui_type = "text_box_array",
	},
	inputs = {
		update_position = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"PropCollisionExtension",
	},
}

return PropCollision
