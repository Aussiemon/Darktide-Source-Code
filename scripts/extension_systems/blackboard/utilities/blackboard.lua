-- chunkname: @scripts/extension_systems/blackboard/utilities/blackboard.lua

local Blackboard = {}

Blackboard.create = function (component_config)
	local read_only_blackboard
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
end

Blackboard.validate = function (blackboard)
	local component_config = blackboard.__config
	local unit_alive = Unit.alive

	for component_name, fields in pairs(component_config) do
		local component = blackboard[component_name]

		for field_name, field_type in pairs(fields) do
			local value = component[field_name]

			if field_type == "Vector3Box" then
				-- Nothing
			elseif field_type == "QuaternionBox" then
				-- Nothing
			elseif field_type == "Unit" then
				-- Nothing
			end

			if false then
				-- Nothing
			end
		end
	end
end

Blackboard.write_component = function (blackboard, component_name)
	return blackboard[component_name]
end

Blackboard.component_config = function (blackboard)
	return blackboard.__config
end

Blackboard.has_component = function (blackboard, component_name)
	return blackboard.__config[component_name] ~= nil
end

return Blackboard
