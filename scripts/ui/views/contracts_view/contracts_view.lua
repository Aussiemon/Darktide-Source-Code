-- chunkname: @scripts/ui/views/contracts_view/contracts_view.lua

local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewDefinitions = require("scripts/ui/views/contracts_view/contracts_view_definitions")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewSettings = require("scripts/ui/views/contracts_view/contracts_view_settings")
local ViewStyles = require("scripts/ui/views/contracts_view/contracts_view_styles")
local ContractCriteriaParser = require("scripts/utilities/contract_criteria_parser")
local ContractsView = class("ContractsView", "BaseView")

ContractsView.init = function (self, settings, context)
	local parent = context and context.parent

	self._parent = parent
	self._world_spawner = parent and parent._world_spawner

	ContractsView.super.init(self, ViewDefinitions, settings, context)
end

ContractsView.on_enter = function (self)
	if self._parent then
		self._parent:set_active_view_instance(self)
	end

	self._pass_input = true
	self._pass_draw = true
	self._backend_interfaces = Managers.backend.interfaces
	self._contract_expiry_time = nil
	self._wallet_promise = nil
	self._popup_id = nil
	self._task_grid = nil
	self._task_list = {}

	self:_update_wallets()
	self:_setup_task_grid_layout()
	self:_fetch_task_list()
	self:_hide_task_info()
	ContractsView.super.on_enter(self)
end

ContractsView.on_exit = function (self)
	if self._offscreen_renderer then
		self:_destroy_renderer()
	end

	if self._popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._popup_id)
	end

	self._backend_interfaces = nil

	ContractsView.super.on_exit(self)
end

ContractsView._on_navigation_input_changed = function (self)
	ContractsView.super._on_navigation_input_changed(self)

	local using_cursor_navigation = self._using_cursor_navigation
	local task_grid = self._task_grid

	if using_cursor_navigation then
		self._task_grid:focus_grid_index(nil)
	else
		local selected_grid_index = task_grid:selected_grid_index()
		local scroll_progress = task_grid:get_scrollbar_percentage_by_index(selected_grid_index)

		task_grid:focus_grid_index(selected_grid_index, scroll_progress, true)
	end
end

ContractsView.on_resolution_modified = function (self, scale)
	ContractsView.super.on_resolution_modified(self, scale)
	self:_update_task_grid_position()
end

ContractsView.update = function (self, dt, t, input_service)
	if self._update_tasks_list then
		self._update_tasks_list = false

		self:_set_contract_info(self._contract_data)
	end

	local synced_grid_index = self._synced_grid_index
	local task_grid = self._task_grid
	local grid_index = task_grid and task_grid:selected_grid_index() or nil
	local grid_index_changed = not synced_grid_index or grid_index and synced_grid_index ~= grid_index

	if grid_index_changed then
		if not self._using_cursor_navigation then
			task_grid:focus_grid_index(grid_index)
		end

		local task_widget = grid_index and task_grid:widget_by_index(grid_index)

		if task_widget then
			local task_info = task_widget.content.task_info

			if task_info then
				self:_display_task_info(task_widget, task_info)
			end
		end

		self._synced_grid_index = grid_index
	end

	self:_update_contract_time_left(t)

	return ContractsView.super.update(self, dt, t, input_service)
end

ContractsView._handle_input = function (self, input_service, dt, t)
	if self._using_cursor_navigation then
		return
	end

	local reroll_button = self._widgets_by_name.reroll_button
	local button_hotspot = reroll_button.content.hotspot

	if not button_hotspot.disabled and input_service:get(ViewSettings.reroll_input_action) then
		button_hotspot.pressed_callback()
	end
end

ContractsView.cb_on_close_pressed = function (self)
	local view_name = self.view_name

	Managers.ui:close_view(view_name)
end

ContractsView.cb_reroll_task_confirmed = function (self, task_id, wallet, reroll_cost)
	local last_transaction_id = wallet and wallet.lastTransactionId
	local player = self:_player()
	local character_id = player:character_id()
	local promise = Managers.data_service.contracts:reroll_task(character_id, task_id, last_transaction_id, reroll_cost)

	promise:next(function (data)
		if self._destroyed then
			return
		end

		self._parent:play_vo_events(ViewSettings.vo_event_replacing_task, "contract_vendor_a", nil, 1.4)
		self:_play_sound(UISoundEvents.mark_vendor_replace_contract)
		self:_hide_task_info()
		self:_replace_contract(task_id, data)
		self:_update_wallets()
	end):catch(function (error)
		return
	end)
end

ContractsView._cb_reroll_task_pressed = function (self, task_info)
	local task_id = task_info.id
	local reroll_cost = self._contract_data.rerollCost
	local promise = self:_fetch_wallet(reroll_cost.type)

	promise:next(callback(self, "_display_confirmation_popup", task_id))
end

local _text_extra_options = {}

ContractsView._display_task_info = function (self, task_widget, task_info)
	local task_info_widget = self._widgets_by_name.task_info
	local task_info_content = task_info_widget.content
	local task_info_style = task_info_widget.style

	task_info_content.visible = true

	local content = task_widget.content
	local height_addition = 0
	local task_is_fulfilled = task_info.fulfilled

	task_info_content.task_is_fulfilled = task_is_fulfilled

	local icon_style = task_info_style.icon
	local task_widget_icon_style = task_widget.style.icon

	icon_style.material_values.contract_type = task_widget_icon_style.material_values.contract_type

	local label = content.task_name

	task_info_content.label = label

	local label_style = task_info_style.label
	local label_default_size = task_is_fulfilled and label_style.fulfilled_size or label_style.default_size
	local text_extra_options = _text_extra_options

	table.clear(text_extra_options)

	local _, label_height = self:_text_size_for_style(label, label_style, label_default_size)
	local label_size = label_style.size

	label_size[1] = label_default_size[1]

	if label_height > label_default_size[2] then
		height_addition = label_height - label_default_size[2]
		label_size[2] = label_height
	end

	local reward_text = string.format(ViewSettings.task_info_reward_string_format, task_info.reward.amount)

	task_info_content.reward_text = reward_text
	task_info_content.completion_text = string.format("%d/%d", task_info.criteria.value, content.task_target)

	local complexity = task_info.criteria.complexity

	if complexity == "easy" then
		task_info_content.complexity_icon = ViewSettings.task_complexity_easy_icon
		task_info_content.complexity_text = Localize(ViewSettings.task_complexity_easy)
	elseif complexity == "hard" then
		task_info_content.complexity_icon = ViewSettings.task_complexity_hard_icon
		task_info_content.complexity_text = Localize(ViewSettings.task_complexity_hard)
	elseif complexity == "tutorial" then
		task_info_content.complexity_icon = ViewSettings.task_complexity_tutorial_icon
		task_info_content.complexity_text = Localize(ViewSettings.task_complexity_tutorial)
	else
		task_info_content.complexity_icon = ViewSettings.task_complexity_medium_icon
		task_info_content.complexity_text = Localize(ViewSettings.task_complexity_medium)
	end

	local button = self._widgets_by_name.reroll_button
	local button_content = button.content

	button_content.visible = true

	local button_hotspot = button_content.hotspot

	button_hotspot.disabled = task_is_fulfilled
	button_content.visible = not task_is_fulfilled
	button_hotspot.pressed_callback = not task_is_fulfilled and callback(self, "_cb_reroll_task_pressed", task_info)

	local total_height = task_info_style.size[2] + height_addition

	self:_set_scenegraph_size("task_info_plate", nil, total_height)
end

ContractsView._hide_task_info = function (self)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.task_info.content.visible = false

	local reroll_button = widgets_by_name.reroll_button
	local reroll_button_content = reroll_button.content

	reroll_button_content.visible = false
	reroll_button_content.hotspot.disabled = true
	reroll_button_content.hotspot.is_selected = nil
end

ContractsView._destroy_renderer = function (self)
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

ContractsView._setup_task_grid_layout = function (self)
	local grid_settings = self._definitions.task_grid_settings
	local player = self:_player()
	local profile = player:profile()
	local archetype = profile.archetype
	local archetype_background_large = archetype.archetype_background_large

	grid_settings.terminal_background_icon = archetype_background_large

	local layer = 1

	self._task_grid = self:_add_element(ViewElementGrid, "task_grid", layer, grid_settings)

	self._task_grid:present_grid_layout({}, {})

	local bottom_material = "content/ui/materials/frames/contracts_bottom"
	local bottom_divider_size = {
		732,
		256
	}
	local bottom_divider_position = {
		0,
		bottom_divider_size[2] * 0.5 - 40,
		12
	}
	local grid_divider_bottom_widget = self._task_grid:widget_by_name("grid_divider_bottom")

	grid_divider_bottom_widget.content.texture = bottom_material
	grid_divider_bottom_widget.style.texture.size = bottom_divider_size
	grid_divider_bottom_widget.style.texture.offset = bottom_divider_position

	local timer_text_widget = self._task_grid:widget_by_name("timer_text")

	timer_text_widget.offset[2] = bottom_divider_size[2] * 0.5 + 30

	local timer_text_scenegraph = timer_text_widget.scenegraph_id

	self._task_grid:_set_scenegraph_size(timer_text_scenegraph, grid_settings.grid_size[1])
	self:_update_task_grid_position()
end

ContractsView._fetch_task_list = function (self)
	self._task_grid:set_loading_state(true)

	local player = self:_player()
	local character_id = player:character_id()
	local promise = self._backend_interfaces.contracts:get_current_contract(character_id, nil, true)

	promise:next(function (data)
		if not self._destroyed then
			self._contract_data = data
			self._update_tasks_list = true
		end

		self._task_grid:set_loading_state(false)
	end):catch(function (error)
		if error.code ~= 404 then
			Log.warning("ContractsView", "Failed to fetch contracts with error: %s", table.tostring(error, 5))
		end
	end)
end

ContractsView._replace_contract = function (self, task_id, data)
	self._contract_data = data
	self._update_tasks_list = true
end

ContractsView._set_contract_info = function (self, contract_data)
	local contract_tasks = contract_data.tasks
	local num_tasks_completed = self:_populate_task_list(contract_tasks)
	local num_tasks = #contract_tasks

	self._contract_expiry_time = contract_data.refreshTime

	local contract_info_widget = self._widgets_by_name.contract_info
	local reward_amount = contract_data.reward.amount
	local contract_info_widget_content = contract_info_widget.content
	local reward_text = string.format(ViewSettings.contract_reward_string_format, reward_amount)

	contract_info_widget_content.reward_text = reward_text

	local progress_widget = self._widgets_by_name.contract_progress
	local progress_content = progress_widget.content
	local localization_content = {
		tasks_completed = num_tasks_completed,
		tasks_total = num_tasks
	}
	local progress_text = Localize(ViewSettings.contract_progress_localization_string_format, true, localization_content)

	progress_content.progress_text = progress_text

	if not contract_data.fulfilled then
		local bar_progress = num_tasks_completed / num_tasks
		local progress_style = progress_widget.style
		local progress_bar_style = progress_style.progress_bar
		local progress_bar_width = math.floor(bar_progress * progress_bar_style.default_size[1])

		progress_bar_style.size[1] = progress_bar_width

		local progress_bar_edge_style = progress_style.progress_bar_edge

		progress_bar_edge_style.offset[1] = progress_bar_width + progress_bar_edge_style.offset[1]
		progress_bar_edge_style.visible = true
	elseif contract_data.rewarded then
		contract_info_widget_content.label = Localize("loc_contracts_contract_fulfilled") .. " "
	else
		local player = self:_player()
		local character_id = player:character_id()

		local function on_completed_callback()
			if self._destroyed then
				return
			end

			contract_info_widget_content.label = Localize("loc_contracts_contract_fulfilled") .. " "

			self:_update_wallets()
		end

		local promise = Managers.data_service.contracts:complete_contract(character_id)

		promise:next(on_completed_callback, on_completed_callback)
	end
end

ContractsView._populate_task_list = function (self, tasks)
	local task_list = {}
	local task_list_item_style = ViewStyles.task_list_item
	local task_size_normal = task_list_item_style.size
	local task_name_style = task_list_item_style.task_name
	local num_completed_tasks = 0

	for i = 1, #tasks do
		local task_info = tasks[i]
		local criteria = task_info.criteria
		local label, description, target = ContractCriteriaParser.localize_criteria(criteria)
		local _, label_height = self:_text_size_for_style(label, task_name_style)
		local task_is_fulfilled = task_info.fulfilled
		local task_progress = criteria.value / (target or 1)
		local reward = task_info.reward.amount

		task_list[#task_list + 1] = {
			widget_type = "task_list_item",
			task_info = task_info,
			task_name = label,
			task_description = description,
			task_target = target,
			task_progress_normalized = task_progress,
			task_reward = reward,
			size = {
				task_size_normal[1],
				task_size_normal[2] + math.max(label_height - 10, 0)
			},
			fulfilled = task_is_fulfilled
		}

		if task_is_fulfilled then
			num_completed_tasks = num_completed_tasks + 1
		end
	end

	local function sort_function(a, b)
		local a_fulfilled = a.fulfilled or false
		local b_fulfilled = b.fulfilled or false

		return b_fulfilled and not a_fulfilled
	end

	table.sort(task_list, sort_function)

	local list_padding = {
		widget_type = "list_padding"
	}

	table.insert(task_list, 1, list_padding)

	task_list[#task_list + 1] = list_padding

	local task_grid = self._task_grid

	local function select_widget_function(widget, config)
		local task_grid = task_grid
		local grid_index = task_grid:widget_index(widget)

		task_grid:select_grid_index(grid_index)
	end

	local function on_present_callback(widget, config)
		local task_grid = task_grid
		local grid_start_index = 1

		self._synced_grid_index = nil

		task_grid:select_grid_index(grid_start_index)
	end

	task_grid:present_grid_layout(task_list, self._definitions.widget_blueprints, select_widget_function, nil, nil, nil, on_present_callback)

	return num_completed_tasks
end

ContractsView._update_contract_time_left = function (self, t)
	local expiry_time = self._contract_expiry_time

	if expiry_time then
		local server_time = Managers.backend:get_server_time(t)
		local total_seconds_left = math.floor((expiry_time - server_time) / 1000)

		self._task_grid:set_expire_time(total_seconds_left)
	end
end

ContractsView._fetch_wallet = function (self, type)
	local wallet_promise = self._wallet_promise

	return wallet_promise:next(function (data)
		return data:by_type(type)
	end)
end

ContractsView._update_wallets = function (self)
	local store_service = Managers.data_service.store

	self._wallet_promise = store_service:combined_wallets()

	if self._parent then
		self._parent:update_wallets()
	end
end

ContractsView._display_confirmation_popup = function (self, task_id, wallet)
	if self._destroyed then
		return
	end

	if self._using_cursor_navigation then
		self:_play_sound(UISoundEvents.default_click)
	end

	local reroll_cost = self._contract_data.rerollCost
	local reroll_cost_amount = reroll_cost.amount
	local balance_amount = wallet and wallet.balance.amount or 0
	local popup_params = {}

	if reroll_cost_amount <= balance_amount then
		popup_params.title_text = "loc_contracts_reroll_confimation_popup_title"
		popup_params.description_text = "loc_contracts_reroll_confimation_popup_description"
		popup_params.description_text_params = {
			cost = reroll_cost_amount,
			balance = balance_amount
		}
		popup_params.options = {
			{
				stop_exit_sound = true,
				close_on_pressed = true,
				text = "loc_contracts_reroll_confimation_yes",
				callback = callback(self, "cb_reroll_task_confirmed", task_id, wallet, reroll_cost)
			},
			{
				text = "loc_contracts_reroll_confimation_no",
				template_type = "terminal_button_small",
				close_on_pressed = true,
				hotkey = "back"
			}
		}
	else
		popup_params.title_text = "loc_contracts_reroll_insufficient_funds_popup_title"
		popup_params.description_text = "loc_contracts_reroll_insufficient_funds_popup_description"
		popup_params.description_text_params = {
			cost = reroll_cost_amount,
			balance = balance_amount
		}
		popup_params.options = {
			{
				text = "loc_contracts_reroll_insufficient_funds_close",
				close_on_pressed = true,
				hotkey = "back"
			}
		}
	end

	Managers.event:trigger("event_show_ui_popup", popup_params, function (id)
		self._popup_id = id
	end)
end

ContractsView._update_task_grid_position = function (self)
	local position = self:_scenegraph_world_position("task_grid")

	self._task_grid:set_pivot_offset(position[1], position[2])
end

ContractsView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return ContractsView
