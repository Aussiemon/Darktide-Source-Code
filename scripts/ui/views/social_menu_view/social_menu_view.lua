local TabbedMenuViewBase = require("scripts/ui/views/tabbed_menu_view_base")
local Definitions = require("scripts/ui/views/social_menu_view/social_menu_view_definitions")
local SocialMenuView = class("SocialMenuView", "TabbedMenuViewBase")

SocialMenuView.init = function (self, settings, context)
	SocialMenuView.super.init(self, Definitions, settings, context)

	self._pass_draw = false
end

SocialMenuView.on_enter = function (self)
	SocialMenuView.super.on_enter(self)
end

SocialMenuView.on_exit = function (self)
	SocialMenuView.super.on_exit(self)
end

return SocialMenuView
