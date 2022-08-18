local InputManagerTestify = {
	input_service = function (service_type, input_manager)
		local input_service = input_manager:get_input_service(service_type)

		return input_service
	end
}

return InputManagerTestify
