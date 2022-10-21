local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewDefinitions = require("scripts/ui/views/contracts_view/contracts_view_definitions")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewSettings = require("scripts/ui/views/contracts_view/contracts_view_settings")
local ViewStyles = require("scripts/ui/views/contracts_view/contracts_view_styles")
local Vo = require("scripts/utilities/vo")
local ContractsView = class("ContractsView", "BaseView")

ContractsView.init = function (self, settings, context)
	local parent = context and context.parent
	self._parent = parent
	self._current_vo_event = nil
	self._current_vo_id = nil
	self._vo_unit = nil
	self._vo_callback = callback(self, "_cb_on_play_vo")
	self._world_spawner = parent and parent._world_spawner

	ContractsView.super.init(self, ViewDefinitions, settings)
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

	self._backend_interfaces = nil

	ContractsView.super.on_exit(self)
end

ContractsView._on_navigation_input_changed = function (self)
	ContractsView.super._on_navigation_input_changed(self)

	local using_cursor_navigation = self._using_cursor_navigation

	self:_update_reroll_button_text(not using_cursor_navigation)
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
		local task_widget = grid_index and task_grid:widget_by_index(grid_index)

		if task_widget then
			local task_info = task_widget.content.task_info

			if task_info then
				self:_cb_display_task_info(task_widget, task_info)
			end
		end

		self._synced_grid_index = grid_index
	end

	self:_update_vo(dt, t)
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

ContractsView.cb_reroll_task_confirmed = function (self, task_id, wallet)
	local last_transaction_id = wallet and wallet.lastTransactionId
	local player = self:_player()
	local character_id = player:character_id()
	local promise = self._backend_interfaces.contracts:reroll_task(character_id, task_id, last_transaction_id)

	promise:next(function (data)
		self:_play_contracts_vendor_vo(ViewSettings.vo_event_replacing_task)
		self:_hide_task_info()

		wallet.lastTransactionId = (wallet.lastTransactionId or 0) + 1

		self:_replace_contract(task_id, data)
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

_text_extra_options = {}

ContractsView._cb_display_task_info = function (self, task_widget, task_info)
	local task_info_widget = self._widgets_by_name.task_info
	local task_info_content = task_info_widget.content
	local task_info_style = task_info_widget.style
	task_info_content.visible = true
	local content = task_widget.content
	local height_addition = 0
	local label = content.task_name
	task_info_content.label = label
	local label_style = task_info_style.label
	local label_size = label_style.default_size
	local text_extra_options = _text_extra_options

	table.clear(text_extra_options)
	UIFonts.get_font_options_by_style(label_style, text_extra_options)

	local _, label_height = self:_text_size(label, label_style.font_type, label_style.font_size, label_size, text_extra_options)

	if label_size[2] < label_height then
		height_addition = label_height - label_size[2]
		label_style.size[2] = label_height
	end

	local description_style = task_info_style.description
	description_style.offset[2] = description_style.default_offset[2] + height_addition
	local description = content.task_description
	task_info_content.description = description
	local description_size = description_style.size

	table.clear(text_extra_options)
	UIFonts.get_font_options_by_style(description_style, text_extra_options)

	local _, description_height = self:_text_size(description, description_style.font_type, description_style.font_size, description_size, text_extra_options)

	if description_size[2] < description_height then
		height_addition = height_addition + description_height - description_size[2]
	end

	local task_is_fulfilled = task_info.fulfilled
	local reward_text_style = task_info_style.reward_text
	local reward_background_style = task_info_style.reward_background
	local reward_icon_style = task_info_style.reward_icon
	local reward_text = string.format(ViewSettings.task_info_reward_string_format, task_info.reward.amount)
	task_info_content.reward_text = reward_text
	local reward_text_width = self:_text_size(reward_text, reward_text_style.font_type, reward_text_style.font_size)
	reward_text_style.text_color = reward_text_style.default_color
	reward_text_style.material = reward_text_style.default_material
	reward_background_style.size[1] = reward_icon_style.size[1] + reward_text_width + 20

	if not task_is_fulfilled then
		task_info_style.completed_text.visible = false
		task_info_style.completed_overlay.visible = false
	else
		task_info_style.completed_text.visible = true
		task_info_style.completed_overlay.visible = true
	end

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

	local reroll_cost = self._contract_data.rerollCost
	local reroll_cost_wallet_type = reroll_cost.type
	local wallet_promise = self:_fetch_wallet(reroll_cost_wallet_type)
	local reroll_cost_amount = reroll_cost.amount
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

	self:_update_task_grid_position()
end

ContractsView._fetch_task_list = function (self)
	local player = self:_player()
	local character_id = player:character_id()
	local promise = self._backend_interfaces.contracts:get_current_contract(character_id)

	promise:next(function (data)
		self._contract_data = data
		self._update_tasks_list = true
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

	if not contract_data.fulfilled then
		local contract_info_widget = self._widgets_by_name.contract_info
		local reward_amount = contract_data.reward.amount
		local contract_info_widget_content = contract_info_widget.content
		local reward_text = string.format(ViewSettings.contract_reward_string_format, reward_amount)
		contract_info_widget_content.reward_text = reward_text
		contract_info_widget_content.visible = true
		local contract_info_style = contract_info_widget.style
		local reward_text_style = contract_info_style.reward_text
		local reward_icon_style = contract_info_style.reward_icon
		local reward_text_width = self:_text_size(reward_text, reward_text_style.font_type, reward_text_style.font_size)
		self._widgets_by_name.contract_info_header.content.visible = true
		local progress_widget = self._widgets_by_name.contract_progress
		local progress_content = progress_widget.content
		progress_content.visible = true
		local localization_content = {
			tasks_completed = num_tasks_completed,
			tasks_total = num_tasks
		}
		local progress_text = Localize(ViewSettings.contract_progress_localization_string_format, true, localization_content)
		progress_content.progress_text = progress_text
		local bar_progress = num_tasks_completed / num_tasks
		local progress_style = progress_widget.style
		local progress_bar_style = progress_style.progress_bar
		local progress_bar_width = math.floor(bar_progress * progress_bar_style.default_size[1])
		progress_bar_style.size[1] = progress_bar_width
		local progress_bar_edge_style = progress_style.progress_bar_edge
		progress_bar_edge_style.offset[1] = progress_bar_width + progress_bar_edge_style.offset[1]
	elseif contract_data.rewarded then
		local contract_fulfilled_widget = self._widgets_by_name.contract_fulfilled
		contract_fulfilled_widget.content.visible = true
	else
		local player = self:_player()
		local character_id = player:character_id()

		local function on_completed_callback()
			if not self._destroyed then
				local contract_fulfilled_widget = self._widgets_by_name.contract_fulfilled
				contract_fulfilled_widget.content.visible = true
			end
		end

		self._backend_interfaces.contracts:complete_contract(character_id):next(on_completed_callback, on_completed_callback)
	end
end

local function _get_mission_type_name(mission_type)
	local mission_objective_templates = MissionObjectiveTemplates.common.objectives
	local mission_type_templates = mission_objective_templates[mission_type]

	if mission_type_templates then
		return Localize(mission_type_templates.header)
	end

	return mission_type
end

local function _get_task_description_and_target(task_criteria)
	local task_type = task_criteria.taskType
	local target_value = task_criteria.count
	local params = {
		count = target_value
	}
	local title_loc, desc_loc = nil

	if task_type == "KillBosses" then
		title_loc = ViewSettings.task_label_kill_bosses
		desc_loc = ViewSettings.task_description_kill_bosses
	elseif task_type == "CollectPickup" then
		params.kind = Localize("loc_contract_task_pickup_type_" .. (task_criteria.pickupType or ""), true)
		title_loc = ViewSettings.task_label_collect_pickups
		desc_loc = ViewSettings.task_description_collect_pickups
	elseif task_type == "CollectResource" then
		params.kind = Localize("loc_currency_name_" .. (task_criteria.resourceType or ""), true)
		title_loc = ViewSettings.task_label_collect_resources
		desc_loc = ViewSettings.task_description_collect_resources
	elseif task_type == "KillMinions" then
		params.enemy_type = Localize("loc_contract_task_enemy_type_" .. (task_criteria.enemyType or ""), true)
		params.weapon_type = Localize("loc_contract_task_weapon_type_" .. (task_criteria.weaponType or ""), true)
		title_loc = ViewSettings.task_label_kill_minions
		desc_loc = ViewSettings.task_description_kill_minions
	elseif task_type == "BlockDamage" then
		title_loc = ViewSettings.task_label_block_damage
		desc_loc = ViewSettings.task_description_block_damage
	elseif task_type == "CompleteMissions" then
		title_loc = ViewSettings.task_label_complete_missions
		desc_loc = ViewSettings.task_description_complete_missions
	elseif task_type == "CompleteMissionsNoDeath" then
		title_loc = ViewSettings.task_label_complete_mission_no_death
		desc_loc = ViewSettings.task_description_complete_mission_no_death
	elseif task_type == "CompleteMissionsByName" then
		params.map = Localize("loc_mission_name_" .. (task_criteria.name or ""), true)
		title_loc = ViewSettings.task_label_complete_missions_by_name
		desc_loc = ViewSettings.task_description_complete_missions_by_name
	else
		title_loc = "loc_" .. task_type
		desc_loc = "loc_" .. task_type
	end

	local title = Localize(title_loc, true, params)
	local description = Localize(desc_loc, true, params)

	return title, description, target_value
end

ContractsView._populate_task_list = function (self, tasks)
	local task_list = {}
	local task_list_item_style = ViewStyles.task_list_item
	local task_size_normal = task_list_item_style.size
	local task_size_double = task_list_item_style.double_size
	local task_name_style = task_list_item_style.task_name
	local task_name_font_type = task_name_style.font_type
	local task_name_font_size = task_name_style.font_size
	local task_name_size = task_name_style.size
	local num_completed_tasks = 0
	local on_selected_callback = callback(self, "_cb_display_task_info")

	for i = 1, #tasks do
		local task_info = tasks[i]
		local criteria = task_info.criteria
		local label, description, target = _get_task_description_and_target(criteria)
		local _, label_height = self:_text_size(label, task_name_font_type, task_name_font_size, task_name_size)
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

ContractsView._update_vo = function (self, dt, t)
	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	else
		local world_name = "ui_contracts_world"
		local world_layer = 2
		local world_timer_name = "ui"
		self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)
	end

	local current_vo_id = self._current_vo_id

	if not current_vo_id then
		return
	end

	local unit = self._vo_unit
	local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
	local is_playing = dialogue_extension:is_playing(current_vo_id)

	if not is_playing then
		self._current_vo_id = nil
		self._current_vo_event = nil
	end
end

ContractsView._update_contract_time_left = function (self, t)
	local expiry_time = self._contract_expiry_time

	if expiry_time then
		local server_time = Managers.backend:get_server_time(t)
		local total_seconds_left = math.floor((expiry_time - server_time) / 1000)

		self._task_grid:set_expire_time(total_seconds_left)
	end
end

ContractsView._update_reroll_button_text = function (self, using_gamepad)
	local reroll_button = self._widgets_by_name.reroll_button
	local button_content = reroll_button.content

	if using_gamepad then
		local service_type = DefaultViewInputSettings.service_type
		local action = ViewSettings.reroll_input_action
		button_content.text = TextUtils.localize_with_button_hint(action, "loc_contracts_reroll_button", nil, service_type, Localize("loc_input_legend_text_template"))
		local button_hotspot = button_content.hotspot
	else
		button_content.text = Localize("loc_contracts_reroll_button")
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
	local promise = store_service:combined_wallets()
	self._wallet_promise = promise
end

ContractsView._display_confirmation_popup = function (self, task_id, wallet)
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
				text = "loc_contracts_reroll_confimation_yes",
				close_on_pressed = true,
				hotkey = "confirm_pressed",
				callback = callback(self, "cb_reroll_task_confirmed", task_id, wallet)
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

	Managers.event:trigger("event_show_ui_popup", popup_params)
end

ContractsView._update_task_grid_position = function (self)
	local position = self:_scenegraph_world_position("task_grid")

	self._task_grid:set_pivot_offset(position[1], position[2])
end

ContractsView._play_contracts_vendor_vo = function (self, event_name)
	local voice_profile = "contract_vendor_a"

	self:_play_vo_event(event_name, voice_profile)
end

ContractsView.dialogue_system = function (self)
	local world_spawner = self._world_spawner

	if not world_spawner then
		return nil
	end

	local world = world_spawner:world()
	local extension_manager = Managers.ui:world_extension_manager(world)

	if not extension_manager then
		return nil
	end

	return extension_manager:system_by_extension("DialogueActorExtension")
end

ContractsView._cb_on_play_vo = function (self, id, event_name)
	self._current_vo_event = event_name
	self._current_vo_id = id
end

local _vo_events = {}

ContractsView._play_vo_event = function (self, event_name, voice_profile, optional_route_key)
	local dialogue_system = self:dialogue_system()
	local events = _vo_events
	events[1] = event_name
	local wwise_route_key = optional_route_key or 19
	local callback = self._vo_callback
	local vo_unit = Vo.play_local_vo_events(dialogue_system, events, voice_profile, wwise_route_key, callback)
	self._vo_unit = vo_unit
end

return ContractsView
