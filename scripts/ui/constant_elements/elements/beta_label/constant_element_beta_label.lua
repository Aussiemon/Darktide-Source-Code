local Definitions = require("scripts/ui/constant_elements/elements/beta_label/constant_element_beta_label_definitions")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local ConstantElementBetaLabel = class("ConstantElementBetaLabel", "ConstantElementBase")

ConstantElementBetaLabel.init = function (self, parent, draw_layer, start_scale)
	ConstantElementBetaLabel.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._description_text = GameParameters.beta_label_overlay_text
	self._widgets_by_name.label.content.text = self._description_text or ""
end

ConstantElementBetaLabel.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not GameParameters.show_beta_label_overlay then
		return
	end

	ConstantElementBetaLabel.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

return ConstantElementBetaLabel
