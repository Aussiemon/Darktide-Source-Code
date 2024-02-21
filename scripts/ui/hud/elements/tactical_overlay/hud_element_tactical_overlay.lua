local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local Definitions = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_definitions")
local InputDevice = require("scripts/managers/input/input_device")
local MissionTypes = require("scripts/settings/mission/mission_types")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local HudElementTacticalOverlay = class("HudElementTacticalOverlay", "HudElementBase")
local default_mission_type_icon = "content/ui/materials/icons/mission_types/mission_type_08"
local default_mission_type_name = "loc_mission_type_default"

HudElementTacticalOverlay.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementTacticalOverlay.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._difficulty_manager = Managers.state.difficulty
	self._mission_manager = Managers.state.mission
	self._circumstance_manager = Managers.state.circumstance

	self:_setup_left_panel_widgets()
	self:on_resolution_modified()

	self._right_panel_entries = {}
end

HudElementTacticalOverlay.destroy = function (self, ui_renderer)
	local contracts_promise = self._contracts_promise

	if contracts_promise and contracts_promise:is_pending() then
		contracts_promise:cancel()
	end

	HudElementTacticalOverlay.super.destroy(self, ui_renderer)
end

HudElementTacticalOverlay.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local ignore_hud_input = true
	local is_input_blocked = Managers.ui:using_input(ignore_hud_input)

	HudElementTacticalOverlay.super.update(self, dt, t, ui_renderer, render_settings, is_input_blocked and input_service:null_service() or input_service)

	local service_type = "Ingame"
	input_service = is_input_blocked and input_service:null_service() or Managers.input:get_input_service(service_type)
	local active = false

	if not input_service:is_null_service() and input_service:get("tactical_overlay_hold") then
		active = true
	end

	if active and not self._active then
		Managers.event:trigger("event_set_tactical_overlay_state", true)
		self:_sync_mission_info()
		self:_sync_circumstance_info()
		self:_update_left_panel_elements(ui_renderer)
		self:_start_animation("enter", self._left_panel_widgets)
	elseif self._active and not active then
		Managers.event:trigger("event_set_tactical_overlay_state", false)
		self:_start_animation("exit", self._left_panel_widgets)
	end

	if self._active then
		self:_update_materials_collected()
	end

	self._active = active

	self:_update_visibility(dt)
end

HudElementTacticalOverlay._update_left_panel_elements = function (self, ui_renderer)
	local total_size = 0
	local margin = 20
	local scenegraph = self._ui_scenegraph
	total_size = total_size + scenegraph.mission_info_panel.size[2]
	local circumstance_info_widget = self._widgets_by_name.circumstance_info

	if circumstance_info_widget.visible == true then
		local title_margin = 20
		total_size = total_size + margin + title_margin

		self:set_scenegraph_position("circumstance_info_panel", nil, total_size)

		local circumstance_info_content = circumstance_info_widget.content
		local circumstance_name_style = circumstance_info_widget.style.circumstance_name
		local circumstance_name_font_options = UIFonts.get_font_options_by_style(circumstance_name_style)
		local _, circumstance_name_height = UIRenderer.text_size(ui_renderer, circumstance_info_content.circumstance_name, circumstance_name_style.font_type, circumstance_name_style.font_size, {
			circumstance_name_style.size[1],
			1000
		}, circumstance_name_font_options)
		local description_margin = 5
		local min_height = circumstance_info_widget.style.icon.size[2]
		local title_height = math.max(min_height, circumstance_name_height)
		circumstance_name_style.size[2] = title_height
		local circumstance_description_style = circumstance_info_widget.style.circumstance_description
		local circumstance_description_font_options = UIFonts.get_font_options_by_style(circumstance_description_style)
		local _, circumstance_description_height = UIRenderer.text_size(ui_renderer, circumstance_info_content.circumstance_description, circumstance_description_style.font_type, circumstance_description_style.font_size, {
			circumstance_description_style.size[1],
			1000
		}, circumstance_description_font_options)
		circumstance_description_style.offset[2] = title_height + circumstance_name_style.offset[2] + description_margin
		circumstance_description_style.size[2] = circumstance_description_height
		local circumstance_height = circumstance_description_style.offset[2] + circumstance_description_style.size[2] + circumstance_info_widget.style.icon.offset[2]

		self:_set_scenegraph_size("circumstance_info_panel", nil, circumstance_height)

		total_size = total_size + circumstance_height
	end

	total_size = total_size + margin

	self:set_scenegraph_position("crafting_pickup_pivot", nil, total_size)

	local diamantine_pos = scenegraph.plasteel_info_panel.size[2] + 5

	self:set_scenegraph_position("diamantine_info_panel", nil, diamantine_pos)

	total_size = total_size + diamantine_pos
	total_size = total_size + scenegraph.diamantine_info_panel.size[2]

	self:_set_scenegraph_size("left_panel", nil, total_size)
end

HudElementTacticalOverlay._set_difficulty_icons = function (self, style, difficulty_value)
	local difficulty_icon_style = style.difficulty_icon
	difficulty_icon_style.amount = difficulty_value
end

HudElementTacticalOverlay._setup_left_panel_widgets = function (self)
	local definitions = {
		widget_definitions = self._definitions.left_panel_widgets_definitions
	}
	self._left_panel_widgets = {}

	self:_create_widgets(definitions, self._left_panel_widgets, self._widgets_by_name)
end

HudElementTacticalOverlay._sync_mission_info = function (self)
	local danger_info_widget = self._widgets_by_name.danger_info
	local challenge = self._difficulty_manager:get_challenge()
	local danger_info_style = danger_info_widget.style

	self:_set_difficulty_icons(danger_info_style, challenge)

	local mission_info_widget = self._widgets_by_name.mission_info
	local mission = self._mission_manager:mission()
	local mission_name = mission.mission_name
	local type = mission.mission_type
	local mission_type = MissionTypes[type]
	local mission_info_content = mission_info_widget.content
	local mission_type_name = mission_type and mission_type.name or default_mission_type_name
	local mission_type_icon = mission_type and mission_type.icon or default_mission_type_icon
	mission_info_content.icon = mission_type_icon
	mission_info_content.mission_type = Localize(mission_type_name)
	mission_info_content.mission_name = Utf8.upper(Localize(mission_name))
end

HudElementTacticalOverlay._sync_circumstance_info = function (self)
	local circumstance_name = self._circumstance_manager:circumstance_name()
	local circumstance_info_widget = self._widgets_by_name.circumstance_info

	if circumstance_name ~= "default" then
		local circumstance_info_content = circumstance_info_widget.content
		local circumstance_template = CircumstanceTemplates[circumstance_name]

		if not circumstance_template then
			circumstance_info_widget.visible = false

			return
		end

		local circumstance_ui_settings = circumstance_template.ui

		if circumstance_ui_settings then
			local circumstance_icon = circumstance_ui_settings.icon
			local circumstance_display_name = circumstance_ui_settings.display_name
			local circumstance_description = circumstance_ui_settings.description
			circumstance_info_content.icon = circumstance_icon
			circumstance_info_content.circumstance_name = Localize(circumstance_display_name)
			circumstance_info_content.circumstance_description = Localize(circumstance_description)
			circumstance_info_widget.visible = true
		else
			circumstance_info_widget.visible = false
		end
	else
		circumstance_info_widget.visible = false
	end
end

HudElementTacticalOverlay._update_visibility = function (self, dt)
	local draw = self._active
	local alpha_speed = 4
	local alpha_multiplier = self._alpha_multiplier or 0

	if draw then
		alpha_multiplier = math.min(alpha_multiplier + dt * alpha_speed, 1)
	else
		alpha_multiplier = math.max(alpha_multiplier - dt * alpha_speed, 0)
	end

	self._alpha_multiplier = alpha_multiplier
end

HudElementTacticalOverlay._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._alpha_multiplier ~= 0 then
		local alpha_multiplier = render_settings.alpha_multiplier
		render_settings.alpha_multiplier = self._alpha_multiplier

		HudElementTacticalOverlay.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

		render_settings.alpha_multiplier = alpha_multiplier
		local left_panel_widgets = self._left_panel_widgets
		local num_left_panel_widget = #left_panel_widgets

		for i = 1, num_left_panel_widget do
			local widget = left_panel_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

HudElementTacticalOverlay._total_materials_collected = function (self, material_type)
	local pickup_system = Managers.state.extension:system("pickup_system")
	local collected_materials = pickup_system:get_collected_materials()
	local small_value = Managers.backend:session_setting("craftingMaterials", material_type, "small", "value")
	local large_value = Managers.backend:session_setting("craftingMaterials", material_type, "large", "value")
	local small_count = collected_materials[material_type] and collected_materials[material_type].small or 0
	local large_count = collected_materials[material_type] and collected_materials[material_type].large or 0

	return small_count * small_value + large_count * large_value
end

HudElementTacticalOverlay._update_materials_collected = function (self)
	local plasteel_info_widget = self._widgets_by_name.plasteel_info
	local plasteel_info_content = plasteel_info_widget.content
	plasteel_info_content.plasteel_amount_id = self:_total_materials_collected("plasteel")
	local diamantine_info_widget = self._widgets_by_name.diamantine_info
	local diamantine_info_content = diamantine_info_widget.content
	diamantine_info_content.diamantine_amount_id = self:_total_materials_collected("diamantine")
end

HudElementTacticalOverlay.on_resolution_modified = function (self)
	local w = RESOLUTION_LOOKUP.width * RESOLUTION_LOOKUP.inverse_scale
	local h = RESOLUTION_LOOKUP.height * RESOLUTION_LOOKUP.inverse_scale

	self:_set_scenegraph_size("background", w, h)
	HudElementTacticalOverlay.super.on_resolution_modified(self)
end

return HudElementTacticalOverlay
