-- chunkname: @scripts/foundation/patches/table_new_builtin.lua

return function ()
	local has_table_new, table_new = pcall(require, "table.new")

	if not has_table_new then
		return
	end

	Script.new_array = function (narr)
		return table_new(narr, 0)
	end

	Script.new_map = function (nrec)
		return table_new(0, nrec)
	end

	Script.new_table = table_new
end
