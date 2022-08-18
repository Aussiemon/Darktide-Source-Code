local Blackboard = {
	create = function (component_config)
		local read_only_blackboard = nil
		local num_config = table.size(component_config)
		local data_container = Script.new_map(num_config)
		data_container.__config = component_config

		for component_name, fields in pairs(component_config) do
			local component = {}

			for field_name, field_type in pairs(fields) do
				if field_type == "Vector3Box" then
					local value_box = Vector3Box(Vector3.invalid_vector())
					component[field_name] = value_box
				elseif field_type == "QuaternionBox" then
					local value_box = QuaternionBox(Quaternion.from_elements(math.huge, math.huge, math.huge, math.huge))
					component[field_name] = value_box
				elseif field_type == "table" then
					ferror("Unsupported field type %q, please create a new component instead!", field_type)
				end
			end

			data_container[component_name] = component
		end

		local blackboard = read_only_blackboard or data_container

		return blackboard
	end,
	validate = function (blackboard)
		local component_config = blackboard.__config
		local unit_alive = Unit.alive

		for component_name, fields in pairs(component_config) do
			local component = blackboard[component_name]

			for field_name, field_type in pairs(fields) do
				local value = component[field_name]

				if field_type == "Vector3Box" then
					fassert(Vector3.is_valid(value:unbox()), "Value in field %q with type %q not initialized with a valid value.", field_name, field_type)
				elseif field_type == "QuaternionBox" then
					fassert(Quaternion.is_valid(value:unbox()), "Value in field %q with type %q not initialized with a valid value.", field_name, field_type)
				elseif field_type == "Unit" then
					fassert(value == nil or unit_alive(value), "Value in field %q with type %q not initialized with a valid value.", field_name, field_type)
				else
					fassert(value ~= nil, "Value in field %q with type %q not set with a non-nil value.", field_name, field_type)
				end
			end
		end
	end,
	write_component = function (blackboard, component_name)
		return blackboard[component_name]
	end,
	component_config = function (blackboard)
		return blackboard.__config
	end,
	has_component = function (blackboard, component_name)
		return blackboard.__config[component_name] ~= nil
	end
}

return Blackboard
