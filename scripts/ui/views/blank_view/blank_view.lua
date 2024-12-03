-- chunkname: @scripts/ui/views/blank_view/blank_view.lua

require("scripts/ui/views/base_view")

local definition_path = "scripts/ui/views/blank_view/blank_view_definitions"
local BlankView = class("BlankView", "BaseView")

BlankView.init = function (self, settings, context)
	local definitions = require(definition_path)

	BlankView.super.init(self, definitions, settings)

	self._pass_draw = false
	self._loading_icon = context and context.loading_icon
end

BlankView.draw = function (self, dt, t, input_service, layer)
	BlankView.super.draw(self, dt, t, input_service, layer)

	if self._loading_icon then
		Managers.ui:render_loading_info()
	end
end

local system_name = "dialogue_system"

BlankView.dialogue_system = function (self)
	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

return BlankView
