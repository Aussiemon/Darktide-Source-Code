local definition_path = "scripts/ui/views/blank_view/blank_view_definitions"
local BaseView = require("scripts/ui/views/base_view")
local BlankView = class("BlankView", "BaseView")

BlankView.init = function (self, settings)
	local definitions = require(definition_path)

	BaseView.init(self, definitions, settings)

	self._pass_draw = false
end

BlankView.draw = function (self, dt, t, input_service, layer)
	BaseView.draw(self, dt, t, input_service, layer)
	Managers.ui:render_loading_icon()
end

return BlankView
