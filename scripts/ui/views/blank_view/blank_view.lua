local definition_path = "scripts/ui/views/blank_view/blank_view_definitions"
local BlankView = class("BlankView", "BaseView")

BlankView.init = function (self, settings)
	local definitions = require(definition_path)

	BlankView.super.init(self, definitions, settings)

	self._pass_draw = false
end

return BlankView
