-- chunkname: @scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info.lua

local Definitions = require("scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info_definitions")
local ExpeditionService = require("scripts/managers/data_service/services/expedition_service")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Settings = require("scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info_settings")
local Styles = require("scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info_styles")
local MinorModifiers = require("scripts/settings/expeditions/expedition_mission_flags")
local Circumstances = require("scripts/settings/circumstance/circumstance_templates")
local Mutators = require("scripts/settings/mutator/mutator_templates")
local UNLOCK_STATUS = ExpeditionService.UNLOCK_STATUS
local ViewElementExpeditionViewMissionInfo = class("ViewElementExpeditionViewMissionInfo", "ViewElementBase")

ViewElementExpeditionViewMissionInfo.init = function (self, parent, draw_layer, start_scale, context)
	ViewElementExpeditionViewMissionInfo.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._node = context and context.node or nil
	self._mission = context and context.mission or nil
	self._all_nodes = context and context.all_nodes or nil
	self._ui_renderer = parent._ui_renderer
	self._mission_info_tabs = {}
	self._mission_info_pages = {}
	self._mission_info_pages_heights = {}
	self._selected_mission_info_page = 1

	if context and context.node and context.mission and context.all_nodes then
		self:_create_unlock_requirements_tab()
		self:_create_minor_modifiers_tab(self._mission)
		self:_create_major_modifier_tabs(self._mission)
		self:_create_mission_info_stats(self._node)
		self:_update_mission_info_tabs()
		self:_update_mission_info_pages()
		self:_update_mission_info_stats()
	else
		self:_create_quickplay_page()
	end
end

ViewElementExpeditionViewMissionInfo._create_unlock_requirements_tab = function (self)
	local icon = Settings.unlock_requirements_tab_icon
	local tab_definition = Definitions.create_page_tab(icon)
	local tab_widget = UIWidget.init("mission_info_tabs_" .. #self._mission_info_tabs + 1, tab_definition)

	tab_widget.content.hotspot.pressed_callback = callback(self, "_cb_on_tab_pressed", #self._mission_info_tabs + 1)
	self._mission_info_tabs[#self._mission_info_tabs + 1] = tab_widget
	tab_widget.offset[1] = (#self._mission_info_tabs - 1) * Settings.dimensions.tab_size[1]

	local page_definition, page_height = Definitions.create_unlock_requirements_page(self._node, self._all_nodes, self._ui_renderer)
	local page_widget = UIWidget.init("mission_info_pages_" .. #self._mission_info_pages + 1, page_definition)

	self._mission_info_pages[#self._mission_info_pages + 1] = page_widget
	self._mission_info_pages_heights[#self._mission_info_pages_heights + 1] = page_height
end

ViewElementExpeditionViewMissionInfo._create_minor_modifiers_tab = function (self, mission)
	local modifiers = mission and mission.modifiers

	if not modifiers or table.is_empty(modifiers) then
		return
	end

	local function has_minor_modifiers_data(modifiers_list)
		for i = 1, #modifiers_list do
			local modifier_data = MinorModifiers[modifiers_list[i]]

			if modifier_data then
				return true
			end
		end

		return false
	end

	if has_minor_modifiers_data(modifiers) then
		local icon = Settings.default_tab_icon
		local tab_definition = Definitions.create_page_tab(icon)
		local tab_widget = UIWidget.init("mission_info_tabs_" .. #self._mission_info_tabs + 1, tab_definition)

		tab_widget.content.hotspot.pressed_callback = callback(self, "_cb_on_tab_pressed", #self._mission_info_tabs + 1)
		self._mission_info_tabs[#self._mission_info_tabs + 1] = tab_widget
		tab_widget.offset[1] = (#self._mission_info_tabs - 1) * Settings.dimensions.tab_size[1]
	end

	local page_definition, page_height = Definitions.create_minor_modifiers_page(modifiers, self._node, self._ui_renderer)

	if page_definition and page_height then
		local page_widget = UIWidget.init("mission_info_pages_" .. #self._mission_info_pages + 1, page_definition)

		self._mission_info_pages[#self._mission_info_pages + 1] = page_widget
		self._mission_info_pages_heights[#self._mission_info_pages_heights + 1] = page_height
	end
end

ViewElementExpeditionViewMissionInfo._create_major_modifier_tabs = function (self, mission)
	local modifiers = mission and mission.modifiers

	if not modifiers or table.is_empty(modifiers) then
		return
	end

	local function _get_major_modifier_data(modifier_name)
		local ui_info = Mutators[modifier_name] and Mutators[modifier_name].ui

		if ui_info and ui_info.icon and ui_info.display_name and ui_info.description then
			return Mutators[modifier_name]
		end

		ui_info = Circumstances[modifier_name] and Circumstances[modifier_name].ui

		if ui_info and ui_info.icon and ui_info.display_name and ui_info.description then
			return Circumstances[modifier_name]
		end

		return nil
	end

	for i = 1, #modifiers do
		local modifier_data = _get_major_modifier_data(modifiers[i])

		if modifier_data then
			local icon = modifier_data.ui.icon
			local tab_definition = Definitions.create_page_tab(icon)
			local tab_widget = UIWidget.init("mission_info_tabs_" .. #self._mission_info_tabs + 1, tab_definition)

			tab_widget.content.hotspot.pressed_callback = callback(self, "_cb_on_tab_pressed", #self._mission_info_tabs + 1)
			self._mission_info_tabs[#self._mission_info_tabs + 1] = tab_widget
			tab_widget.offset[1] = (#self._mission_info_tabs - 1) * Settings.dimensions.tab_size[1]
		end

		local page_definition, page_height = Definitions.create_major_modifier_page(modifiers[i], self._node, self._ui_renderer)

		if page_definition and page_height then
			local page_widget = UIWidget.init("mission_info_pages_" .. #self._mission_info_pages + 1, page_definition)

			self._mission_info_pages[#self._mission_info_pages + 1] = page_widget
			self._mission_info_pages_heights[#self._mission_info_pages_heights + 1] = page_height
		end
	end
end

ViewElementExpeditionViewMissionInfo._create_quickplay_page = function (self)
	local definition = Definitions.create_quickplay_page()

	if definition then
		local widget = UIWidget.init("mission_info_page", definition)

		self._quickplay_page = widget
	end
end

ViewElementExpeditionViewMissionInfo._create_mission_info_stats = function (self, node)
	if not node then
		return nil
	end

	local definition = Definitions.create_mission_info_stats(node)

	if definition then
		local widget = UIWidget.init("mission_info_stats", definition)

		self._mission_info_stats = widget
	end
end

ViewElementExpeditionViewMissionInfo.update = function (self, dt, t, input_service)
	ViewElementExpeditionViewMissionInfo.super.update(self, dt, t, input_service)
	self:_update_mission_info_tabs(dt)
	self:_update_mission_info_pages(dt, t, input_service)
	self:_update_mission_info_stats(dt, t, input_service)
end

ViewElementExpeditionViewMissionInfo._update_mission_info_tabs = function (self, dt)
	if not self._mission_info_tabs then
		return
	end

	local tabs = self._mission_info_tabs

	for i = 1, #tabs do
		local is_selected = i == self._selected_mission_info_page
		local tab_widget = tabs[i]
		local tab_style = tab_widget.style
		local tab_content = tab_widget.content
		local instant_anim = not dt
		local tab_size = Settings.dimensions.tab_size
		local anim_select_speed = Settings.tabs_anim_select_speed

		if anim_select_speed then
			local anim_select_progress = tab_content.anim_select_progress or 0

			if is_selected then
				anim_select_progress = instant_anim and 1 or math.min(anim_select_progress + dt * anim_select_speed, 1)
			else
				anim_select_progress = instant_anim and 0 or math.max(anim_select_progress - dt * anim_select_speed, 0)
			end

			tab_content.anim_select_progress = anim_select_progress

			local animated_extra_height = tab_size[2] * 0.5 * anim_select_progress

			tab_content.size[2] = tab_size[2] + animated_extra_height
			tab_widget.offset[2] = -animated_extra_height
			tab_style.gradient.color[1] = 255 * (1 - anim_select_progress)
			tab_style.background_bottom_edge.color[1] = 255 * anim_select_progress
		end
	end
end

ViewElementExpeditionViewMissionInfo._update_mission_info_pages = function (self, dt, t, input_service)
	if not self._mission_info_pages then
		return
	end

	local pages = self._mission_info_pages

	for i = 1, #pages do
		local is_selected = i == self._selected_mission_info_page

		if is_selected then
			local page = pages[i]

			page.visible = true

			local unlock_status_style = page.style.unlock_status

			if page.content.unlock_status and unlock_status_style then
				if self._node.unlock_status == UNLOCK_STATUS.unlocked then
					unlock_status_style.text_color = Settings.colors.unlocked_text
					page.content.unlock_status = "[ " .. Localize("loc_unlocked") .. " ]"
				elseif self._node_unlock_status == UNLOCK_STATUS.unlockable then
					unlock_status_style.text_color = Settings.colors.unlockable_text
					page.content.unlock_status = "[ " .. Localize("loc_unlockable") .. " ]"
				else
					unlock_status_style.text_color = Settings.colors.locked_text
					page.content.unlock_status = "[ " .. Localize("loc_locked") .. " ]"
				end
			end
		else
			pages[i].visible = false
		end
	end
end

ViewElementExpeditionViewMissionInfo._update_mission_info_stats = function (self, dt, t, input_service)
	local stats_widget = self._mission_info_stats

	if not stats_widget then
		return
	end

	local selected_page_height = self._mission_info_pages_heights[self._selected_mission_info_page]

	if selected_page_height then
		local downward_offset = math.clamp(selected_page_height, Settings.dimensions.page_min_size[2], Settings.dimensions.page_max_size[2])

		stats_widget.offset = {
			0,
			downward_offset,
			0,
		}
	else
		stats_widget.offset = {
			0,
			0,
			0,
		}
	end
end

ViewElementExpeditionViewMissionInfo._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementExpeditionViewMissionInfo.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	if self._mission_info_tabs then
		for i = 1, #self._mission_info_tabs do
			local widget = self._mission_info_tabs[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._mission_info_pages then
		for i = 1, #self._mission_info_pages do
			local widget = self._mission_info_pages[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._mission_info_stats then
		UIWidget.draw(self._mission_info_stats, ui_renderer)
	end

	if self._quickplay_page then
		UIWidget.draw(self._quickplay_page, ui_renderer)
	end
end

ViewElementExpeditionViewMissionInfo._cb_on_tab_pressed = function (self, new_index)
	self:switch_tab(new_index)
end

ViewElementExpeditionViewMissionInfo.switch_tab = function (self, new_index)
	local old_index = self._selected_mission_info_page

	if new_index == nil then
		new_index = old_index + 1

		if not self._mission_info_pages or table.is_empty(self._mission_info_pages) then
			return
		elseif new_index > #self._mission_info_pages then
			new_index = 1
		end
	end

	self._mission_info_pages[old_index].visible = false
	self._mission_info_pages[new_index].visible = true
	self._selected_mission_info_page = new_index
end

ViewElementExpeditionViewMissionInfo.destroy = function (self)
	ViewElementExpeditionViewMissionInfo.super.destroy(self)
end

return ViewElementExpeditionViewMissionInfo
