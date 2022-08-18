local definition_path = "scripts/ui/hud/elements/spectator/hud_element_spectator_text_definitions"
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local HudElementSpectatorText = class("HudElementSpectatorText", "HudElementBase")

HudElementSpectatorText.init = function (self, parent, draw_layer, start_scale, definitions)
	local definitions = require(definition_path)

	HudElementSpectatorText.super.init(self, parent, draw_layer, start_scale, definitions)
end

HudElementSpectatorText.update = function (self)
	local name = self._parent:player():name()
	self._widgets_by_name.target_text.content.text = name
end

return HudElementSpectatorText
