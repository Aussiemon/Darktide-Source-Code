local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local CircumstanceManager = class("CircumstanceManager")
CircumstanceManager.DEBUG_TAG = "Circumstance"

CircumstanceManager.init = function (self, circumstance_name)
	fassert(CircumstanceTemplates[circumstance_name], "[CircumstanceManager][init] Missing circumstance template for name(%s).", tostring(circumstance_name))

	self._circumstance_name = circumstance_name
end

CircumstanceManager.destroy = function (self)
	return
end

CircumstanceManager.circumstance_name = function (self)
	return self._circumstance_name
end

return CircumstanceManager
