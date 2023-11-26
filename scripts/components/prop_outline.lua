-- chunkname: @scripts/components/prop_outline.lua

local PropOutline = component("PropOutline")

PropOutline.init = function (self, unit)
	return
end

PropOutline.editor_validate = function (self, unit)
	return true, ""
end

PropOutline.enable = function (self, unit)
	return
end

PropOutline.disable = function (self, unit)
	return
end

PropOutline.destroy = function (self, unit)
	return
end

PropOutline.component_data = {
	extensions = {
		"PropOutlineExtension"
	}
}

return PropOutline
