-- chunkname: @scripts/ui/view_elements/view_element_item_result_overlay_mastery/view_element_item_result_overlay_mastery.lua

local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementItemResultOverlayMasterySettings = require("scripts/ui/view_elements/view_element_item_result_overlay_mastery/view_element_item_result_overlay_mastery_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local MasteryUtils = require("scripts/utilities/mastery")
local MasteryContentBlueprints = require("scripts/ui/views/mastery_view/mastery_view_blueprints")
local ViewElementItemResultOverlay = require("scripts/ui/view_elements/view_element_item_result_overlay/view_element_item_result_overlay")
local Definitions = require("scripts/ui/view_elements/view_element_item_result_overlay_mastery/view_element_item_result_overlay_mastery_definitions")
local ViewElementItemResultOverlayMastery = class("ViewElementItemResultOverlayMastery", "ViewElementItemResultOverlay")

ViewElementItemResultOverlayMastery.init = function (self, parent, draw_layer, start_scale)
	ViewElementItemResultOverlayMastery.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._reference_name = "ViewElementItemResultOverlayMastery_" .. tostring(self)
end

ViewElementItemResultOverlayMastery.start = function (self, presentation_data)
	local widgets_by_name = self._widgets_by_name
	local reward = presentation_data.reward
	local sound_event = UISoundEvents.item_result_overlay_reward_in_rarity_1

	self:_present_mastery_reward(reward)
	self:_start_animation("on_enter", self._widgets_by_name, self)

	if sound_event then
		self:_play_sound(sound_event)
	end

	widgets_by_name.input_text.content.text = Localize("loc_item_result_overlay_input_description")

	local title_text_widget = widgets_by_name.title_text
	local ui_renderer = self._ui_default_renderer
	local content = title_text_widget.content
	local style = title_text_widget.style
	local text_style = style.text
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local title_text_width = UIRenderer.text_size(ui_renderer, content.text, text_style.font_type, text_style.font_size, text_style.size or {
		900,
		50
	}, text_options)

	self:_set_scenegraph_size("divider", math.max(title_text_width + 440, 600))
end

ViewElementItemResultOverlayMastery._present_mastery_reward = function (self, config)
	local config = table.clone(config)
	local name = "mastery_reward"
	local grid_width = 520
	local grid_height = 520
	local grid_size = {
		grid_width,
		grid_height
	}
	local template = MasteryContentBlueprints.overlay
	local mastery_item_pass_template = template and template.pass_template
	local mastery_item_size = grid_size

	config.size = mastery_item_size

	local mastery_item_widget_definition = UIWidget.create_definition(mastery_item_pass_template, "rarity_glow", nil, mastery_item_size)
	local mastery_item_widget = self:_create_widget(name, mastery_item_widget_definition)

	template.init(self, mastery_item_widget, config)

	mastery_item_widget.offset = {
		-10,
		-10,
		0
	}
	self._mastery_reward_widget = mastery_item_widget
end

ViewElementItemResultOverlayMastery.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._mastery_reward_widget then
		UIRenderer.begin_pass(ui_renderer, self._ui_scenegraph, input_service, dt, render_settings)
		UIWidget.draw(self._mastery_reward_widget, ui_renderer)
		UIRenderer.end_pass(ui_renderer)
	end

	ViewElementItemResultOverlayMastery.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

return ViewElementItemResultOverlayMastery
