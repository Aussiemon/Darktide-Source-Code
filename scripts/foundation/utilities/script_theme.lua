-- chunkname: @scripts/foundation/utilities/script_theme.lua

local ScriptTheme = {}

ScriptTheme.object_sets_to_hide = function (themes)
	local object_sets_to_hide = {}

	for ii = 1, #themes do
		local theme = themes[ii]
		local object_sets = Theme.get_hide_sets(theme)

		table.set(object_sets, object_sets_to_hide)
	end

	local object_sets_to_hide_array = {}

	for object_set, _ in pairs(object_sets_to_hide) do
		object_sets_to_hide_array[#object_sets_to_hide_array + 1] = object_set
	end

	if #object_sets_to_hide_array >= 1 then
		return object_sets_to_hide_array
	end

	return nil
end

return ScriptTheme
