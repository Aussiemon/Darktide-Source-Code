local FunctionCommandQueue = class("FunctionCommandQueue")

FunctionCommandQueue.init = function (self, max_num_args)
	self.command_queue = {}
	self.command_index = 0
	self.command_stride = max_num_args + 1
end

FunctionCommandQueue.run_commands = function (self)
	local command_queue = self.command_queue
	local stride = self.command_stride

	for index = 0, self.command_index - 1, 1 do
		local base_index = index * stride
		local function_call = command_queue[base_index + 1]

		function_call(unpack_index[stride - 1](command_queue, base_index + 2))

		for j = 1, stride, 1 do
			command_queue[base_index + j] = nil
		end
	end

	self.command_index = 0
end

FunctionCommandQueue.cleanup_destroyed_unit = function (self, unit)
	local command_queue = self.command_queue
	local stride = self.command_stride
	local unit_animation_event = Unit.animation_event
	local list_size = self.command_index
	local i = 1

	while list_size >= i do
		local base_index = (i - 1) * stride
		local function_call = command_queue[base_index + 1]

		if function_call == unit_animation_event then
			local target_unit = command_queue[base_index + 2]

			if target_unit == unit then
				local base_list_size = (list_size - 1) * stride

				for j = 1, stride, 1 do
					local copy_index = base_list_size + j
					command_queue[base_index + j] = command_queue[copy_index]
					command_queue[copy_index] = nil
				end

				list_size = list_size - 1
			else
				i = i + 1
			end
		else
			i = i + 1
		end
	end

	self.command_index = list_size
end

FunctionCommandQueue.queue_function_command = function (self, function_call, ...)
	local index = self.command_index
	local command_queue = self.command_queue
	local base_index = index * self.command_stride
	command_queue[base_index + 1] = function_call
	local select = select
	local num_args = select("#", ...)

	fassert(num_args < self.command_stride, "Trying to make a call with too many function args. Please increase in constructor.")

	for i = 1, num_args, 1 do
		command_queue[base_index + i + 1] = select(i, ...)
	end

	self.command_index = index + 1
end

return FunctionCommandQueue
