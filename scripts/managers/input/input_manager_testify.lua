-- chunkname: @scripts/managers/input/input_manager_testify.lua

local InputManagerTestify = {
	input_service = function (input_manager, service_type)
		local input_service = input_manager:get_input_service(service_type)

		return input_service
	end,
}

return InputManagerTestify
