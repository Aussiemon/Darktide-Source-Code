-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_none.lua

local ScannerDisplayViewDefinitionsBase = require("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base")
local scenegraph_definition = ScannerDisplayViewDefinitionsBase.scenegraph_definition
local widget_definitions = {
	scanner_background = ScannerDisplayViewDefinitionsBase.widget_definitions.scanner_background,
	noise_background = ScannerDisplayViewDefinitionsBase.widget_definitions.noise_background,
}

return {
	none = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition,
	},
}
