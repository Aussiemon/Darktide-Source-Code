-- chunkname: @scripts/managers/circumstance/circumstance_manager.lua

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local CircumstanceManager = class("CircumstanceManager")

CircumstanceManager.DEBUG_TAG = "Circumstance"

CircumstanceManager.init = function (self, circumstance_name)
	local template = CircumstanceTemplates[circumstance_name]

	self._circumstance_name = circumstance_name
end

CircumstanceManager.destroy = function (self)
	return
end

CircumstanceManager.active_theme_tag = function (self)
	return CircumstanceTemplates[self._circumstance_name].theme_tag
end

CircumstanceManager.circumstance_name = function (self)
	return self._circumstance_name
end

CircumstanceManager.template = function (self)
	return CircumstanceTemplates[self._circumstance_name]
end

return CircumstanceManager
