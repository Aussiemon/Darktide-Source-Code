-- chunkname: @scripts/components/scanner_display.lua

local ScannerDisplay = component("ScannerDisplay")

ScannerDisplay.init = function (self, unit)
	local scanner_display_extension = ScriptUnit.fetch_component_extension(unit, "scanner_display_system")

	if scanner_display_extension then
		scanner_display_extension:setup_from_component()
	end
end

ScannerDisplay.editor_init = function (self, unit)
	return
end

ScannerDisplay.editor_validate = function (self, unit)
	return true, ""
end

ScannerDisplay.enable = function (self, unit)
	return
end

ScannerDisplay.disable = function (self, unit)
	return
end

ScannerDisplay.destroy = function (self, unit)
	return
end

ScannerDisplay.component_data = {
	extensions = {
		"ScannerDisplayExtension",
	},
}

return ScannerDisplay
