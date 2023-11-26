-- chunkname: @scripts/foundation/utilities/callback.lua

local MAX_ARGS = 5

function callback(...)
	local arg1 = select(1, ...)

	if type(arg1) == "table" then
		local object = arg1
		local func_name = select(2, ...)
		local num_args = select("#", ...) - 2

		if num_args == 0 then
			return function (...)
				return object[func_name](object, ...)
			end
		elseif num_args == 1 then
			local arg1 = select(3, ...)

			return function (...)
				return object[func_name](object, arg1, ...)
			end
		elseif num_args == 2 then
			local arg1, arg2 = select(3, ...)

			return function (...)
				return object[func_name](object, arg1, arg2, ...)
			end
		elseif num_args == 3 then
			local arg1, arg2, arg3 = select(3, ...)

			return function (...)
				return object[func_name](object, arg1, arg2, arg3, ...)
			end
		elseif num_args == 4 then
			local arg1, arg2, arg3, arg4 = select(3, ...)

			return function (...)
				return object[func_name](object, arg1, arg2, arg3, arg4, ...)
			end
		elseif num_args == 5 then
			local arg1, arg2, arg3, arg4, arg5 = select(3, ...)

			return function (...)
				return object[func_name](object, arg1, arg2, arg3, arg4, arg5, ...)
			end
		end
	elseif type(arg1) == "function" then
		local func = arg1
		local num_args = select("#", ...) - 1

		if num_args == 0 then
			return function (...)
				return func(...)
			end
		elseif num_args == 1 then
			local arg1 = select(2, ...)

			return function (...)
				return func(arg1, ...)
			end
		elseif num_args == 2 then
			local arg1, arg2 = select(2, ...)

			return function (...)
				return func(arg1, arg2, ...)
			end
		elseif num_args == 3 then
			local arg1, arg2, arg3 = select(2, ...)

			return function (...)
				return func(arg1, arg2, arg3, ...)
			end
		elseif num_args == 4 then
			local arg1, arg2, arg3, arg4 = select(2, ...)

			return function (...)
				return func(arg1, arg2, arg3, arg4, ...)
			end
		elseif num_args == 5 then
			local arg1, arg2, arg3, arg4, arg5 = select(2, ...)

			return function (...)
				return func(arg1, arg2, arg3, arg4, arg5, ...)
			end
		end
	else
		ferror("callback(...) incorrectly called")
	end
end
