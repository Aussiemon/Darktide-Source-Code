-- chunkname: @scripts/extension_systems/action_input/action_input_tests.lua

local _hierarchy_test, _action_input_tests

local function action_input_tests(action_templates)
	for name, template in pairs(action_templates) do
		local success, error_msg = _hierarchy_test(template)

		success, error_msg = _action_input_tests(template)
	end
end

function _hierarchy_test(template)
	local success = true
	local error_msg = ""
	local hierarchy = template.action_input_hierarchy

	if not hierarchy then
		error_msg = string.format("%sMissing action_input_hierarchy.", error_msg)
		success = false
	end

	return success, error_msg
end

function _action_input_tests(template)
	local success = true
	local error_msg = ""
	local action_inputs = template.action_inputs

	if action_inputs then
		for action_input, config in pairs(action_inputs) do
			local input_sequence = config.input_sequence

			if input_sequence then
				local num_elements = #input_sequence

				if num_elements > 0 then
					for i = 1, num_elements do
						local element = input_sequence[i]
						local inputs = element.inputs

						if element.input then
							local value = element.value

							if type(value) == "nil" then
								success = false
								error_msg = string.format("%saction_input %q failed. element %i in input_sequence needs to have a value defined.\n", error_msg, action_input, i)
							end
						elseif inputs then
							if type(inputs) == "table" then
								local num_inputs = #inputs

								if num_inputs > 0 then
									for j = 1, #inputs do
										local input_config = inputs[j]
										local input, value = input_config.input, input_config.value

										if type(input) == "nil" then
											success = false
											error_msg = string.format("%saction_input %q failed. element %i in input_sequence has inputs table that is faulty, index %i is missing input.\n", error_msg, action_input, i, j)
										end

										if type(value) == "nil" then
											success = false
											error_msg = string.format("%saction_input %q failed. element %i in input_sequence has inputs table that is faulty, index %i is missing value.\n", error_msg, action_input, i, j)
										end
									end
								else
									success = false
									error_msg = string.format("%saction_input %q failed. element %i in input_sequence has an empty inputs table defined, or it's not an array.\n", error_msg, action_input, i)
								end
							else
								success = false
								error_msg = string.format("%saction_input %q failed. element %i in input_sequence has inputs defined, but is not a table.\n")
							end
						else
							success = false
							error_msg = string.format("%saction_input %q failed. neither input nor inputs is defined for element index %i.\n", error_msg, action_input, i)
						end
					end
				else
					success = false
					error_msg = string.format("%saction_input %q failed. no elements defined in input_sequence, or input_sequence is not an array.\n", error_msg, action_input)
				end
			end
		end
	else
		success = false
		error_msg = string.format("%SMission action_inputs,", error_msg)
	end

	return success, error_msg
end

return action_input_tests
