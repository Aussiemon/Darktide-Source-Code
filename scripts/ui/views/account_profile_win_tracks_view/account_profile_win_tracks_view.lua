local Definitions = require("scripts/ui/views/account_profile_win_tracks_view/account_profile_win_tracks_view_definitions")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local AccountProfileWinTracksView = class("AccountProfileWinTracksView", "BaseView")

AccountProfileWinTracksView.init = function (self, settings, context)
	AccountProfileWinTracksView.super.init(self, Definitions, settings)

	self._pass_input = true
	self._parent = context and context.parent

	if self._parent then
		self._parent:set_active_view_instance(self)
	end
end

AccountProfileWinTracksView.on_enter = function (self)
	AccountProfileWinTracksView.super.on_enter(self)
end

return AccountProfileWinTracksView
