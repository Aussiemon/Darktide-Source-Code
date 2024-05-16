-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_scan.lua

local ScannerDisplayViewDefinitionsBase = require("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base")
local scenegraph_definition = ScannerDisplayViewDefinitionsBase.scenegraph_definition
local widget_definitions = {
	scanner_background = ScannerDisplayViewDefinitionsBase.widget_definitions.scanner_background,
	noise_background = ScannerDisplayViewDefinitionsBase.widget_definitions.noise_background,
	decoration_left_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_left_mark,
	decoration_right_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_right_mark,
	decoration_inquisition = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_inquisition,
}

return {
	scan = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition,
	},
}
