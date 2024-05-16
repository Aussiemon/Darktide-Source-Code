-- chunkname: @scripts/ui/views/marks_vendor_view/marks_vendor_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local scenegraph_definition = {}
local widget_definitions = {
	purchase_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "purchase_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_vendor_purchase_button")),
		purchase_sound = UISoundEvents.credits_vendor_on_purchase,
		hotspot = {
			on_pressed_sound = UISoundEvents.default_click,
		},
	}),
}
local animations = {}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
