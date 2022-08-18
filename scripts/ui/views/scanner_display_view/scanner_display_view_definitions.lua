local scanner_display_view_definitions = {}

local function _extract_scanner_display_view_definitions(path)
	local definitions = require(path)

	for name, definition_data in pairs(definitions) do
		fassert(scanner_display_view_definitions[name] == nil, "Found display view definitions with the same name %q", name)

		scanner_display_view_definitions[name] = definition_data
	end
end

_extract_scanner_display_view_definitions("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_none")
_extract_scanner_display_view_definitions("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_decode")
_extract_scanner_display_view_definitions("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_decode_symbols")
_extract_scanner_display_view_definitions("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_scan")

for name, definition_data in pairs(scanner_display_view_definitions) do
	definition_data.name = name
end

return settings("ScannerDisplayViewDefinitions", scanner_display_view_definitions)
