require("scripts/managers/camera/cameras/base_camera")

local BlendCamera = class("BlendCamera", "BaseCamera")

BlendCamera.init = function (self, root_node)
	BlendCamera.super.init(self, root_node)

	self._offset_position = Vector3(0, 0, 0)
	self._blend_setups = {}
	self._blend_functions = {
		match_2d = function (blend_definition, data)
			local blend_x = data[blend_definition.blend_parameter_x]
			local blend_y = data[blend_definition.blend_parameter_y]
			local match_x = blend_definition.match_value_x
			local match_y = blend_definition.match_value_y

			return (1 - math.min(math.abs(blend_x - match_x), 1)) * (1 - math.min(math.abs(blend_y - match_y), 1))
		end,
		match = function (blend_definition, data)
			local blend = data[blend_definition.blend_parameter]
			local match = blend_definition.match_value

			return 1 - math.min(math.abs(blend - match), 1)
		end
	}
end

BlendCamera.parse_parameters = function (self, camera_settings, parent_node)
	BlendCamera.super.parse_parameters(self, camera_settings, parent_node)

	self._child_node_definitions = camera_settings.child_node_blend_definitions
end

BlendCamera.add_child_node = function (self, node)
	BlendCamera.super.add_child_node(self, node)

	local child_index = #self._blend_setups + 1
	local def = self._child_node_definitions[child_index]
	self._blend_setups[child_index] = {
		node = node,
		weight_function = self._blend_functions[def.blend_function],
		definition = def
	}
end

BlendCamera.update = function (self, dt, position, rotation, data)
	if self._active_children > 0 then
		BlendCamera.super.update(self, dt, position, rotation, data)

		return
	end

	local total_weight = 0
	local total_offset = Vector3(0, 0, 0)

	for child_index, blend_setup in ipairs(self._blend_setups) do
		local node = blend_setup.node

		node:update(dt, position, rotation, data)

		local offset = node:position() - position
		local weight = blend_setup.weight_function(blend_setup.definition, data)
		total_weight = total_weight + weight
		total_offset = total_offset + offset * weight
	end

	local new_position = position + total_offset / total_weight

	BlendCamera.super.update(self, dt, new_position, rotation, data)
end

return BlendCamera
