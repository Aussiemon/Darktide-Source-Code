-- chunkname: @scripts/ui/views/account_profile_overview_view/account_profile_overview_view.lua

local BackendInterface = require("scripts/backend/backend_interface")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewStyles = require("scripts/ui/views/account_profile_overview_view/account_profile_overview_view_styles")
local Definitions = require("scripts/ui/views/account_profile_overview_view/account_profile_overview_view_definitions")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local Boons = {
	boon_one = {
		icon = "content/ui/materials/icons/abilities/combat/default",
		label = "loc_boons_reduce_damage",
	},
}
local MIN_LIST_ITEMS = 20
local AccountProfileOverwiewView = class("AccountProfileOverwiewView", "BaseView")
local BOONS_LIST = "boons"
local COMMENDATIONS_LIST = "commendations"
local CONTRACTS_LIST = "contracts"
local ACCOUNT_PROFILE_POPUP_VIEW = "account_profile_popup_view"
local NUM_COMMENDATIONS_TO_SHOW = 5

AccountProfileOverwiewView.init = function (self, settings, context)
	AccountProfileOverwiewView.super.init(self, Definitions, settings, context)

	self._pass_input = true
	self._parent = context and context.parent

	if self._parent then
		self._parent:set_active_view_instance(self)
	end
end

AccountProfileOverwiewView.on_enter = function (self)
	AccountProfileOverwiewView.super.on_enter(self)
	self:_fetch_data()

	self._column_grids = {}
	self._column_grids_array = {}

	self:_setup_column(BOONS_LIST)
	self:_setup_column(COMMENDATIONS_LIST)
	self:_setup_column(CONTRACTS_LIST)
	self:_create_offscreen_renderer()

	local player = self:_player()
	local player_name_widget = self._widgets_by_name.player_name

	player_name_widget.content.text = player:name()

	local all_commendations_button = self._widgets_by_name.all_commendations_button

	all_commendations_button.content.hotspot.pressed_callback = callback(self, "cb_all_commendations_button")
end

AccountProfileOverwiewView.on_exit = function (self)
	local ui_manager = Managers.ui

	if self._active_popup_view then
		self._active_popup_view:close_view()
	elseif ui_manager:view_active(ACCOUNT_PROFILE_POPUP_VIEW) then
		ui_manager:close_view(ACCOUNT_PROFILE_POPUP_VIEW)
	end

	self:_destroy_renderer()
	AccountProfileOverwiewView.super.on_exit(self)
end

AccountProfileOverwiewView.update = function (self, dt, t, input_service)
	local grids = self._column_grids_array

	for i = 1, #grids do
		grids[i].grid_widget:update(dt, t, input_service)
	end

	return AccountProfileOverwiewView.super.update(self, dt, t, input_service)
end

AccountProfileOverwiewView.draw = function (self, dt, t, input_service, layer)
	local offscreen_renderer = self._offscreen_renderer
	local render_settings = self._render_settings

	if offscreen_renderer then
		UIRenderer.begin_pass(offscreen_renderer, self._ui_scenegraph, input_service, dt, render_settings)

		local grids = self._column_grids_array

		for i = 1, #grids do
			self:_draw_list_widgets(grids[i], input_service, offscreen_renderer)
		end

		UIRenderer.end_pass(offscreen_renderer)
	end

	return AccountProfileOverwiewView.super.draw(self, dt, t, input_service, layer)
end

AccountProfileOverwiewView.cb_received_overview_data = function (self, data)
	self:_set_account_overview_data(data)
end

AccountProfileOverwiewView.cb_received_boons_data = function (self, data)
	self:_set_boons_data(data)
end

AccountProfileOverwiewView.cb_received_commendations_data = function (self, data)
	self:_set_commendations_data(data)
end

AccountProfileOverwiewView.cb_received_current_contract_data = function (self, data)
	self:_set_current_contracts_data(data)
end

AccountProfileOverwiewView.cb_show_popup = function (self, item_data)
	self:_show_popup(item_data)
end

AccountProfileOverwiewView.cb_set_active_popup_instance = function (self, popup_view)
	self._active_popup_view = popup_view
end

AccountProfileOverwiewView.cb_all_commendations_button = function (self)
	return
end

AccountProfileOverwiewView._add_list_item = function (self, list, item_data)
	local grid = self._column_grids[list]
	local item_icon = item_data.icon
	local blueprints = self._definitions.blueprints
	local blueprint = item_icon and blueprints.item_blueprint_with_icon or blueprints.item_blueprint
	local popup_callback = callback(self, "cb_show_popup", item_data)
	local widget_definition = UIWidget.create_definition(blueprint.passes, grid.grid_scenegraph_id, {
		hotspot = {
			pressed_callback = popup_callback,
		},
	}, blueprint.size, blueprint.style)
	local widget_index = #grid.widgets + 1
	local alignment_index = #grid.alignment_list
	local name = list .. "_" .. widget_index
	local new_widget = self:_create_widget(name, widget_definition)
	local content = new_widget.content

	if item_data.icon then
		content.icon = item_data.icon
	end

	content.label = self:_localize(item_data.label)
	content.value = item_data.value or ""
	grid.widgets[widget_index] = new_widget
	grid.alignment_list[alignment_index] = new_widget
	grid.alignment_list[alignment_index + 1] = grid.grid_spacing_widget
	grid.alignment_list[alignment_index + 2] = grid.grid_mask_clearing_widget

	grid.grid_widget:force_update_list_size()
end

AccountProfileOverwiewView._create_offscreen_renderer = function (self)
	local view_name = self.view_name
	local world_layer = 10
	local world_name = self.__class_name .. "_ui_offscreen_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil, view_name)
	local viewport_name = "offscreen_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "offscreen_renderer"

	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name,
	}
end

AccountProfileOverwiewView._destroy_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		self._offscreen_world = nil
	end
end

AccountProfileOverwiewView._draw_list_widgets = function (self, list, input_service, ui_renderer)
	local margin = ViewStyles.grid_mask_expansion
	local widgets = list.widgets
	local grid = list.grid_widget

	for i = 1, #widgets do
		local widget = widgets[i]

		if grid:is_widget_visible(widget, margin) then
			UIWidget.draw(widget, ui_renderer)
		end
	end
end

AccountProfileOverwiewView._fetch_data = function (self)
	self._backend_interface = BackendInterface:new()

	local overview_promise = self._backend_interface.progression:get_account_progression()

	overview_promise:next(callback(self, "cb_received_overview_data"))

	local boons_promise = self._backend_interface.account:get_boon_inventory()

	boons_promise:next(callback(self, "cb_received_boons_data"))
end

AccountProfileOverwiewView._set_account_overview_data = function (self, data)
	local account_rank_widget = self._widgets_by_name.account_rank
	local content = account_rank_widget.content
	local style = account_rank_widget.style

	content.rank_text = self:_localize("loc_account_profile_account_rank", true, {
		account_rank = data.currentLevel,
	})

	local normalized_progress = data.currentXpInLevel / data.neededXpForNextLevel
	local progress_bar_width = self:_scenegraph_size("progress_bar")

	style.progress_bar.size[1] = math.floor(progress_bar_width * normalized_progress)
end

AccountProfileOverwiewView._set_boons_data = function (self, data)
	local boons_data = data.boons
	local boons_grid = self._column_grids[BOONS_LIST]

	boons_grid.data = boons_data

	for i = 1, #boons_data do
		local boon_data = boons_data[i]
		local boon = Boons[boon_data.name]
		local popup_data = {
			{
				blueprint = "subtitle",
				params = {
					text = "loc_boon_types_team_boon",
				},
			},
			{
				blueprint = "info_text",
				params = {
					text = "loc_placeholder_boon_description",
				},
			},
		}
		local item_data = {
			icon = boon.icon,
			label = boon.label,
			value = boon_data.count .. "x",
			popup_data = popup_data,
		}

		self:_add_list_item(BOONS_LIST, item_data)
	end
end

AccountProfileOverwiewView._set_commendations_data = function (self, commendations_data)
	local commendations_grid = self._column_grids[COMMENDATIONS_LIST]

	commendations_grid.data = commendations_data

	local function commendation_comparator(a, b)
		local a_completed = a.complete
		local b_completed = b.complete

		if a_completed ~= b_completed then
			return b_completed
		end

		local a_percent = a.progress_current / a.progress_goal
		local b_percent = b.progress_current / b.progress_goal

		return b_percent < a_percent
	end

	table.sort(commendations_data, commendation_comparator)

	local items_to_add = math.min(NUM_COMMENDATIONS_TO_SHOW, #commendations_data)

	for i = 1, items_to_add do
		local commendation_data = commendations_data[i]
		local icon = commendation_data.icon
		local progress = self:_format_progress("percent", commendation_data.progress_current, commendation_data.progress_goal)
		local item_data = {
			icon = icon,
			label = commendation_data.label,
			value = progress,
		}

		self:_add_list_item(COMMENDATIONS_LIST, item_data)
	end
end

AccountProfileOverwiewView._set_current_contracts_data = function (self, data)
	local current_contracts_grid = self._column_grids[CONTRACTS_LIST]

	current_contracts_grid.data = data

	local tasks = data.tasks
	local contracts_widget = self._widgets_by_name.contracts
	local num_tasks = #tasks

	contracts_widget.content.num_tasks = num_tasks .. " "

	for i = 1, num_tasks do
		local task = tasks[i]
		local progress = self:_format_progress(task.taskType, task.progressCurrent, task.progressGoal)
		local item_data = {
			label = task.label,
			value = progress,
		}

		self:_add_list_item(CONTRACTS_LIST, item_data)
	end
end

AccountProfileOverwiewView._setup_column = function (self, name)
	local grid_scenegraph_id = name .. "_column_list_content"
	local interaction_scenegraph_id = name .. "_column"
	local grid_direction = "down"
	local grid_spacing = {
		size = {
			ViewStyles.column_width,
			20,
		},
	}
	local clear_mask_spacing = {
		size = {
			ViewStyles.column_width,
			10,
		},
	}
	local widgets = {}
	local alignment_list = {
		clear_mask_spacing,
	}
	local grid_widget = UIWidgetGrid:new(widgets, alignment_list, self._ui_scenegraph, grid_scenegraph_id, grid_direction)
	local scrollbar_widget = self._widgets_by_name[name .. "_scrollbar"]
	local scrollbar_content = scrollbar_widget.content

	scrollbar_content.focused = true

	if name == BOONS_LIST then
		scrollbar_content.scroll_action_negative = "navigate_up_continuous"
		scrollbar_content.scroll_action_positive = "navigate_down_continuous"
	elseif name == CONTRACTS_LIST then
		scrollbar_content.scroll_action_negative = "navigate_secondary_left_pressed"
		scrollbar_content.scroll_action_positive = "navigate_secondary_right_pressed"
	end

	grid_widget:assign_scrollbar(scrollbar_widget, grid_scenegraph_id, interaction_scenegraph_id)
	grid_widget:set_scrollbar_progress(0)

	local column_grid = {
		widgets = widgets,
		alignment_list = alignment_list,
		grid_widget = grid_widget,
		grid_spacing_widget = grid_spacing,
		grid_mask_clearing_widget = clear_mask_spacing,
		grid_scenegraph_id = grid_scenegraph_id,
		scrollbar = scrollbar_widget,
	}

	self._column_grids[name] = column_grid
	self._column_grids_array[#self._column_grids_array + 1] = column_grid
end

AccountProfileOverwiewView._show_popup = function (self, item_data)
	local context = {
		parent = self,
		icon = item_data.icon,
		headline = item_data.label,
		info_widgets = item_data.popup_data,
	}

	Managers.ui:open_view(ACCOUNT_PROFILE_POPUP_VIEW, nil, nil, nil, nil, context)
end

AccountProfileOverwiewView._format_progress = function (self, task_type, progress_current, progress_goal)
	if progress_current == progress_goal then
		return "Done"
	elseif task_type == "range" then
		return progress_current .. " / " .. progress_goal
	elseif task_type == "percent" then
		return math.floor(progress_current / progress_goal * 100) .. "%"
	else
		return nil
	end
end

return AccountProfileOverwiewView
