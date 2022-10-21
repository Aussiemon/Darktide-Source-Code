local Blackboard = nil
local TEST_FAILED_STRING = "[Blackboard] Test Failed, %s!"
local temp_args = {}

local function format_error_message(message, ...)
	local num_new_args = select("#", ...)

	for i = 1, num_new_args do
		temp_args[i] = tostring(select(i, ...))
	end

	for i = num_new_args + 1, #temp_args do
		temp_args[i] = nil
	end

	return string.format(message, unpack(temp_args))
end

local function mockup_fassert(condition, message, ...)
	if not condition then
		message = format_error_message(message, ...)
	end
end

local function mockup_ferror(message, ...)
	message = format_error_message(message, ...)

	error(message)
end

local function _test_write_component(blackboard, component_name, field_name, field_type, field_value, invalid_field_name)
	local component = Blackboard.write_component(blackboard, component_name)
	local same_component = Blackboard.write_component(blackboard, component_name)

	if field_type == "Vector3Box" then
		component[field_name]:store(field_value)
	elseif field_type == "QuaternionBox" then
		component[field_name]:store(field_value)
	else
		component[field_name] = field_value
	end
end

local function _test_read_component(blackboard, component_name, field_name, field_type, field_value, invalid_field_name)
	local component = blackboard[component_name]
	local same_component = blackboard[component_name]
	local _ = component[field_name]
end

local function _init_and_run_tests(blackboard_object)
	local original_ferror = ferror
	ferror = mockup_ferror
	Blackboard = blackboard_object
	local component_config = {
		userdata_component = {
			quaternion_a = "QuaternionBox",
			vector_a = "Vector3Box"
		},
		other_types_component_1 = {
			string_a = "string",
			boolean_a = "boolean",
			number_a = "number"
		},
		other_types_component_2 = {
			boolean_b = "boolean",
			number_b = "number",
			string_b = "string"
		}
	}
	local field_values = {
		boolean_b = false,
		string_b = "test_string_2",
		number_b = 567,
		string_a = "test_string_1",
		boolean_a = true,
		number_a = 321,
		vector_a = Vector3(3, 1, 2),
		quaternion_a = Quaternion(Vector3.normalize(Vector3(2, 1, 3)), math.pi)
	}
	local blackboard = Blackboard.create(component_config)
	local new_blackboard = Blackboard.create(component_config)
	local invalid_field_name = "invalid_field"

	for component_name, fields in pairs(component_config) do
		for field_name, field_type in pairs(fields) do
			local field_value = field_values[field_name]

			_test_read_component(blackboard, component_name, field_name, field_type, field_value, invalid_field_name)
			_test_write_component(blackboard, component_name, field_name, field_type, field_value, invalid_field_name)
		end
	end

	Blackboard.validate(blackboard)

	ferror = original_ferror
end

return _init_and_run_tests
