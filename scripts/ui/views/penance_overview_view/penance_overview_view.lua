-- chunkname: @scripts/ui/views/penance_overview_view/penance_overview_view.lua

local PenanceOverviewViewDefinitions = require("scripts/ui/views/penance_overview_view/penance_overview_view_definitions")
local PenanceOverviewViewSettings = require("scripts/ui/views/penance_overview_view/penance_overview_view_settings")
local AchievementCategories = require("scripts/settings/achievements/achievement_categories")
local AchievementFlags = require("scripts/settings/achievements/achievement_flags")
local AchievementTypes = require("scripts/managers/achievements/achievement_types")
local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local InputUtils = require("scripts/managers/input/input_utils")
local ItemUtils = require("scripts/utilities/items")
local StatDefinitions = require("scripts/managers/stats/stat_definitions")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementItemResultOverlay = require("scripts/ui/view_elements/view_element_item_result_overlay/view_element_item_result_overlay")
local ViewElementWintrackItemRewardOverlay = require("scripts/ui/view_elements/view_element_wintrack_item_reward_overlay/view_element_wintrack_item_reward_overlay")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local ViewElementMenuPanel = require("scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel")
local ViewElementWintrack = require("scripts/ui/view_elements/view_element_wintrack/view_element_wintrack")
local Vo = require("scripts/utilities/vo")
local UIAnimation = require("scripts/managers/ui/ui_animation")
local TextUtilities = require("scripts/utilities/ui/text")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local MasterItems = require("scripts/backend/master_items")

local function _stats_sort_iterator(stats, stats_sorting)
	local sort_table = stats_sorting or table.keys(stats)
	local ii = 0

	return function ()
		ii = ii + 1

		return sort_table[ii], stats[sort_table[ii]]
	end
end

local _format_progress_params = {}

local function _format_progress(current_progress, goal)
	local params = _format_progress_params

	params.progress = current_progress
	params.goal = goal

	return Localize("loc_achievement_progress", true, params)
end

local RESULT_TYPES = table.enum("wintrack", "penance")
local PENANCE_TRACK_ID = "dec942ce-b6ba-439c-95e2-022c5d71394d"
local PenanceOverviewView = class("PenanceOverviewView", "BaseView")

PenanceOverviewView.init = function (self, settings, context)
	self._legend_input_ids = nil
	self._achievements = nil
	self._categories = nil
	self._has_achievements = false
	self._sub_categories = nil
	self._wintracks_focused = false
	self._add_penance_claimed_points_callback = nil
	self._layouts_by_category = {}
	self._achievements_by_category = {}
	self._widget_content_by_category = {}
	self._category_by_achievement = {}
	self._ui_animations = {}
	self._total_score = 0
	self._score_by_category = {}

	local save_manager = Managers.save

	if save_manager then
		local account_data = save_manager:account_data()
		local penance_list_setting_show_list_view = account_data.interface_settings.penance_list_setting_show_list_view

		self._use_large_penance_entries = penance_list_setting_show_list_view or false
		self._use_large_penance_entries_init_value = self._use_large_penance_entries
	end

	PenanceOverviewView.super.init(self, PenanceOverviewViewDefinitions, settings, context)

	self._pass_input = false
	self._pass_draw = false
	self._allow_close_hotkey = true
	self._current_vo_event = nil
	self._current_vo_id = nil
	self._vo_unit = nil
	self._vo_callback = callback(self, "_cb_on_play_vo")
	self._vo_world_spawner = nil
	self._hub_interaction = context and context.hub_interaction

	Managers.data_service.account:has_migrated_commendation_score():next(function (value)
		self._has_migrated_commendation_score = value
	end)
	self:_fetch_unclaimed_penance_rewards():next(function (rewards)
		self._penance_to_reward_bundle_map = {}

		for i = 1, #rewards do
			local reward = rewards[i]

			self._penance_to_reward_bundle_map[reward.penance_id] = reward.reward_bundle
		end
	end)
	self._fetch_penance_track():next(function (data)
		self._track_data = data
	end)
end

PenanceOverviewView._update_commendation_status = function (self)
	if self._has_migrated_commendation_score == nil then
		return
	end

	if self._has_migrated_commendation_score or self._fetch_account_state then
		self._fetch_penance_track_account_state():next(function (response)
			self._account_state_data = response
		end)

		self._has_migrated_commendation_score = nil
	elseif not self._init_commendation_score then
		local player = self:_player()
		local account_id = player:account_id()

		Managers.backend.interfaces.commendations:init_commendation_score(account_id):next(function (response)
			self._fetch_account_state = true
		end)

		self._init_commendation_score = true
	end
end

PenanceOverviewView.on_enter = function (self)
	PenanceOverviewView.super.on_enter(self)

	if PenanceOverviewViewSettings.background_world_params then
		self:_setup_background_world(PenanceOverviewViewSettings.background_world_params)
	end

	self:_setup_input_legend()
	self:_setup_tooltip_grid({})
	self._penance_tooltip_grid:set_visibility(false)

	self._penance_tooltip_visible = false

	local rumour_line = math.random() > 0.9

	if rumour_line then
		local vo_event_rumour = {
			"hub_interact_boon_vendor_rumour_politics_a",
		}

		self:play_vo_events(vo_event_rumour, "boon_vendor_a", nil, 0.8)
	else
		local vo_event_greeting = {
			"hub_interact_penance_greeting_a",
		}

		self:play_vo_events(vo_event_greeting, "boon_vendor_a", nil, 0.8)
	end

	self:_register_event("event_request_achievement_favorite_add", "request_achievement_favorite_add")
	self:_register_event("event_request_achievement_favorite_remove", "request_achievement_favorite_remove")
	Managers.telemetry_reporters:start_reporter("penance_view")
end

PenanceOverviewView.request_achievement_favorite_add = function (self, achievement_id)
	local added = AchievementUIHelper.add_favorite_achievement(achievement_id)

	if added then
		self._refresh_carousel_entries = true

		Managers.telemetry_reporters:reporter("penance_view"):register_tracking_event(achievement_id, true)
	end

	return added
end

PenanceOverviewView.request_achievement_favorite_remove = function (self, achievement_id)
	local removed = AchievementUIHelper.remove_favorite_achievement(achievement_id)

	if removed then
		self._refresh_carousel_entries = true

		Managers.telemetry_reporters:reporter("penance_view"):register_tracking_event(achievement_id, false)
	end

	return removed
end

PenanceOverviewView.is_favorite_achievement = function (self, achievement_id)
	return AchievementUIHelper.is_favorite_achievement(achievement_id)
end

PenanceOverviewView._setup_background_world = function (self, world_params)
	self._world_params = world_params

	if world_params.register_camera_event then
		self:_register_event(world_params.register_camera_event, "event_register_camera")
	end

	local world_name = world_params.world_name or self.view_name .. "_world"
	local world_layer = world_params.world_layer or 1
	local world_timer_name = world_params.timer_name or "ui"

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	if self._context then
		self._context.background_world_spawner = self._world_spawner
	end

	local level_name = world_params.level_name

	if level_name then
		self._world_spawner:spawn_level(level_name)
	end
end

PenanceOverviewView.event_register_camera = function (self, camera_unit)
	local world_params = self._world_params

	self:_unregister_event(world_params.register_camera_event)

	local viewport_name = world_params.viewport_name or self.view_name .. "_viewport"
	local viewport_type = world_params.viewport_type or "default"
	local viewport_layer = world_params.viewport_layer or 1
	local shading_environment = world_params.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
	self._world_spawner:set_listener(viewport_name)
end

PenanceOverviewView._set_penance_points_presentation = function (self, points)
	self._widgets_by_name.penance_points_panel.content.text = string.format("%d ", points)
end

PenanceOverviewView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 80)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment, nil, nil, nil, legend_input.suffix_function)
	end
end

PenanceOverviewView._handle_back_pressed = function (self)
	local view_name = self.view_name

	Managers.ui:close_view(view_name)
end

PenanceOverviewView.cb_on_close_pressed = function (self)
	if self:can_exit() then
		self:_handle_back_pressed()
	end
end

PenanceOverviewView.cb_on_toggle_penance_appearance = function (self)
	self._use_large_penance_entries = not self._use_large_penance_entries

	local options = self._penance_category_options
	local index = self._selected_option_button_index
	local force_selection = true

	self:on_category_button_pressed(index, options[index], force_selection)
end

PenanceOverviewView._set_title = function (self, text)
	local widget = self._widgets_by_name.page_header

	widget.content.text = Localize(text)
end

PenanceOverviewView._setup_achievements = function (self)
	local player = self:_player()

	self:_cache_sub_categories()
	self:_cache_achievements(player)

	local category_button_config = {}
	local category_ids_added = {}

	for category_id, category_config in pairs(AchievementCategories) do
		local parent_name = category_config.parent_name
		local sort_index = category_config.sort_index
		local category = parent_name or category_id
		local parent_category = parent_name and AchievementCategories[parent_name]

		if not category_ids_added[category] then
			local data = {
				sort_index = sort_index,
				category_id = category,
				parent = parent_name,
				display_name = parent_category and parent_category.display_name or category_config.display_name,
				icon = PenanceOverviewViewSettings.category_icons[category] or "content/ui/materials/icons/item_types/upper_bodies",
				child_categories = {},
			}

			category_button_config[#category_button_config + 1] = data
			category_ids_added[category] = data
		end

		if parent_name then
			local child_categories = category_ids_added[parent_name].child_categories

			child_categories[#child_categories + 1] = category_id
		end
	end

	for i = 1, #category_button_config do
		local data = category_button_config[i]
		local child_categories = data.child_categories

		if child_categories then
			table.sort(child_categories, function (a, b)
				local a_category = AchievementCategories[a]
				local b_category = AchievementCategories[b]

				return a_category.sort_index < b_category.sort_index
			end)
		end
	end

	table.sort(category_button_config, function (a, b)
		return a.sort_index < b.sort_index
	end)

	self._category_button_config = category_button_config

	self:_verify_favorite_achievements()
end

PenanceOverviewView._get_carousel_layouts = function (self, filter_out_ids, numbers_to_add)
	local player = self:_player()

	numbers_to_add = numbers_to_add or math.huge

	local max_amount = math.min(numbers_to_add, PenanceOverviewViewSettings.carousel_max_entries)
	local carousel_achievement_layouts = {}

	local function can_add_achievement(achievement_id)
		if Managers.achievements:achievement_definition(achievement_id) == nil then
			return false
		end

		for i = 1, #carousel_achievement_layouts do
			if carousel_achievement_layouts[i].achievement_id == achievement_id then
				return false
			end
		end

		if filter_out_ids then
			for i = 1, #filter_out_ids do
				if filter_out_ids[i] == achievement_id then
					return false
				end
			end
		end

		return true
	end

	local archetype_name = player:archetype_name()
	local default_highlight_penances = PenanceOverviewViewSettings.default_highlight_penances
	local default_highlight_penances_by_archetype = default_highlight_penances[archetype_name]

	if default_highlight_penances_by_archetype then
		for _, achievement_id in ipairs(default_highlight_penances_by_archetype) do
			if max_amount <= #carousel_achievement_layouts then
				break
			end

			if can_add_achievement(achievement_id) then
				local is_complete = Managers.achievements:achievement_completed(player, achievement_id)

				if not is_complete or self:_can_claim_achievement_by_id(achievement_id) then
					local layout = self:_get_achievement_card_layout(achievement_id)

					carousel_achievement_layouts[#carousel_achievement_layouts + 1] = layout
					layout.achievement_id = achievement_id
				end
			end
		end
	end

	local account_data = Managers.save:account_data()
	local favorite_achievements = account_data.favorite_achievements

	for _, achievement_list in pairs(self._achievements_by_category_unsorted) do
		for _, achievement_id in ipairs(achievement_list) do
			if max_amount <= #carousel_achievement_layouts then
				break
			end

			if can_add_achievement(achievement_id) then
				local is_tracked = table.find(favorite_achievements, achievement_id)
				local can_claim = self:_can_claim_achievement_by_id(achievement_id)

				if is_tracked and can_claim then
					local layout = self:_get_achievement_card_layout(achievement_id)

					carousel_achievement_layouts[#carousel_achievement_layouts + 1] = layout
					layout.achievement_id = achievement_id
				end
			end
		end

		if max_amount <= #carousel_achievement_layouts then
			break
		end
	end

	for _, achievement_list in pairs(self._achievements_by_category_unsorted) do
		for _, achievement_id in ipairs(achievement_list) do
			if max_amount <= #carousel_achievement_layouts then
				break
			end

			if can_add_achievement(achievement_id) then
				local can_claim = self:_can_claim_achievement_by_id(achievement_id)

				if can_claim then
					local layout = self:_get_achievement_card_layout(achievement_id)

					carousel_achievement_layouts[#carousel_achievement_layouts + 1] = layout
					layout.achievement_id = achievement_id
				end
			end
		end

		if max_amount <= #carousel_achievement_layouts then
			break
		end
	end

	if favorite_achievements then
		for _, achievement_id in ipairs(favorite_achievements) do
			if max_amount <= #carousel_achievement_layouts then
				break
			end

			if can_add_achievement(achievement_id) then
				local layout = self:_get_achievement_card_layout(achievement_id)

				carousel_achievement_layouts[#carousel_achievement_layouts + 1] = layout
				layout.achievement_id = achievement_id
				layout.tracked = true
			end
		end
	end

	local achievements_by_recency = self._achievements_by_recency

	for _, achievement_id in pairs(achievements_by_recency) do
		if max_amount <= #carousel_achievement_layouts then
			break
		end

		if can_add_achievement(achievement_id) then
			local can_claim = self:_can_claim_achievement_by_id(achievement_id)

			if can_claim then
				local layout = self:_get_achievement_card_layout(achievement_id)

				carousel_achievement_layouts[#carousel_achievement_layouts + 1] = layout
				layout.achievement_id = achievement_id
			end
		end
	end

	local achievements_by_progress = self._achievements_by_progress

	for _, achievement_id in ipairs(achievements_by_progress) do
		if max_amount <= #carousel_achievement_layouts then
			break
		end

		if can_add_achievement(achievement_id) then
			local is_complete = Managers.achievements:achievement_completed(player, achievement_id)
			local can_claim = self:_can_claim_achievement_by_id(achievement_id)
			local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
			local is_meta = achievement_definition.type == "meta"

			if can_claim or not is_complete and not is_meta then
				local layout = self:_get_achievement_card_layout(achievement_id)

				carousel_achievement_layouts[#carousel_achievement_layouts + 1] = layout
				layout.achievement_id = achievement_id
			end
		end
	end

	for _, achievement_id in ipairs(achievements_by_progress) do
		if max_amount <= #carousel_achievement_layouts then
			break
		end

		if can_add_achievement(achievement_id) then
			local is_complete = Managers.achievements:achievement_completed(player, achievement_id)
			local can_claim = self:_can_claim_achievement_by_id(achievement_id)
			local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
			local is_meta = achievement_definition.type == "meta"

			if not is_complete and is_meta then
				local layout = self:_get_achievement_card_layout(achievement_id)

				carousel_achievement_layouts[#carousel_achievement_layouts + 1] = layout
				layout.achievement_id = achievement_id
			end
		end
	end

	for _, achievement_id in pairs(achievements_by_recency) do
		if max_amount <= #carousel_achievement_layouts then
			break
		end

		if can_add_achievement(achievement_id) then
			local can_claim = self:_can_claim_achievement_by_id(achievement_id)
			local is_completed = Managers.achievements:achievement_completed(player, achievement_id)

			if not can_claim and is_completed then
				local layout = self:_get_achievement_card_layout(achievement_id)

				carousel_achievement_layouts[#carousel_achievement_layouts + 1] = layout
				layout.achievement_id = achievement_id
			end
		end
	end

	table.sort(carousel_achievement_layouts, function (a, b)
		local a_achievement_id = a.achievement_id
		local a_can_claim = self:_can_claim_achievement_by_id(a_achievement_id)
		local a_tracked = a.tracked
		local a_achievement = AchievementUIHelper.achievement_definition_by_id(a_achievement_id)
		local a_using_progress = self:_draw_progress_bar_for_achievement(a_achievement)
		local a_bar_progress = a_using_progress and self:_get_achievement_bar_progress(a_achievement) or 0
		local b_achievement_id = b.achievement_id
		local b_can_claim = self:_can_claim_achievement_by_id(b_achievement_id)
		local b_tracked = b.tracked
		local b_achievement = AchievementUIHelper.achievement_definition_by_id(b_achievement_id)
		local b_using_progress = self:_draw_progress_bar_for_achievement(b_achievement)
		local b_bar_progress = b_using_progress and self:_get_achievement_bar_progress(b_achievement) or 0

		if a_can_claim or b_can_claim then
			if a_can_claim and b_can_claim then
				return a_tracked
			else
				return a_can_claim
			end
		elseif a_tracked or b_tracked then
			if a_tracked and b_tracked then
				return b_bar_progress < a_bar_progress
			else
				return a_tracked
			end
		end

		return b_bar_progress < a_bar_progress
	end)

	return carousel_achievement_layouts
end

PenanceOverviewView._fetch_unclaimed_penance_rewards = function (self)
	local backend_interface = Managers.backend.interfaces
	local player_rewards = backend_interface.player_rewards
	local promise = player_rewards:get_penance_rewards_by_source():next(function (items)
		return items
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("PenanceOverviewView", "Error fetching reward: %s", error_string)

		return {}
	end)

	return promise:next(function (data)
		return data
	end)
end

PenanceOverviewView._fetch_penance_track = function (self)
	local promise = Managers.data_service.penance_track:get_track(PENANCE_TRACK_ID):next(function (data)
		return data
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("PenanceOverviewView", "Error fetching penance track: %s", error_string)

		return {}
	end)

	return promise:next(function (data)
		return data
	end)
end

PenanceOverviewView._fetch_penance_track_account_state = function (self)
	local backend_interface = Managers.backend.interfaces
	local penance_track = backend_interface.tracks
	local promise = penance_track:get_track_state(PENANCE_TRACK_ID):next(function (response)
		return response
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("PenanceOverviewView", "Error fetching penance track for account: %s", error_string)

		return {}
	end)

	return promise:next(function (response)
		return response
	end)
end

PenanceOverviewView._claim_track_tier = function (self, tier)
	local backend_interface = Managers.backend.interfaces
	local penance_track = backend_interface.tracks
	local promise = penance_track:claim_track_tier(PENANCE_TRACK_ID, tier):next(function (data)
		return data
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("PenanceOverviewView", "Error fetching penance track: %s", error_string)

		return {}
	end)

	return promise:next(function (data)
		return data
	end)
end

PenanceOverviewView._cache_sub_categories = function (self)
	local sub_categories = {}

	for category_id, category_config in pairs(AchievementCategories) do
		local parent_name = category_config.parent_name

		if parent_name then
			local _sub_categories = sub_categories[parent_name] or {}

			_sub_categories[#_sub_categories + 1] = category_id
			sub_categories[parent_name] = _sub_categories
		end
	end

	self._sub_categories = sub_categories
end

local layout_blueprint_names_by_grid = {
	carousel = {
		body = "carousel_penance_body",
		category = "carousel_penance_category",
		completed = "carousel_penance_completed",
		dynamic_spacing = "dynamic_spacing",
		header = "carousel_penance_header",
		penance_icon = "carousel_penance_icon",
		penance_icon_and_name = "carousel_penance_icon_and_name",
		penance_icon_small = "carousel_penance_icon_small",
		progress_bar = "carousel_penance_progress_bar",
		score = "carousel_penance_reward",
		score_and_reward = "carousel_penance_score_and_reward",
		stat = "carousel_penance_stat",
		tracked = "carousel_penance_tracked",
	},
	tooltip = {
		body = "tooltip_penance_body",
		category = "tooltip_penance_category",
		completed = "tooltip_penance_completed",
		dynamic_spacing = "dynamic_spacing",
		header = "tooltip_penance_header",
		penance_icon = "tooltip_penance_icon",
		penance_icon_and_name = "tooltip_penance_icon_and_name",
		penance_icon_small = "tooltip_penance_icon_small",
		progress_bar = "tooltip_penance_progress_bar",
		score = "tooltip_penance_reward",
		score_and_reward = "tooltip_penance_score_and_reward",
		stat = "tooltip_penance_stat",
		tracked = "tooltip_penance_tracked",
	},
}

PenanceOverviewView._get_achievement_card_layout = function (self, achievement_id, is_tooltip)
	local player = self:_player()
	local achievement = AchievementUIHelper.achievement_definition_by_id(achievement_id)
	local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
	local can_claim = not is_tooltip and self:_can_claim_achievement_by_id(achievement_id)
	local is_complete = not can_claim and Managers.achievements:achievement_completed(player, achievement_id)
	local is_favorite = AchievementUIHelper.is_favorite_achievement(achievement_id)
	local achievement_score = achievement.score or 0
	local achievement_family_order = AchievementUIHelper.get_achievement_family_order(achievement)
	local draw_progress_bar = self:_draw_progress_bar_for_achievement(achievement_definition, is_complete)
	local use_spacing = true
	local blueprint = PenanceOverviewViewDefinitions.grid_blueprints
	local layout = {}
	local layout_blueprint_names = is_tooltip and layout_blueprint_names_by_grid.tooltip or layout_blueprint_names_by_grid.carousel
	local scenegraph_id = is_tooltip and "tooltip_grid" or "carousel_card"
	local grid_size = self:_get_scenegraph_size(scenegraph_id)
	local height_used = 0

	if can_claim then
		layout[#layout + 1] = {
			widget_type = "claim_overlay",
			size = {
				grid_size[1],
				grid_size[2],
			},
		}
	end

	if not is_tooltip then
		layout[#layout + 1] = {
			widget_type = layout_blueprint_names.tracked,
			achievement_id = achievement_id,
			tracked = is_favorite,
		}
		layout[#layout + 1] = {
			widget_type = layout_blueprint_names.completed,
			achievement_id = achievement_id,
			completed = is_complete,
		}
		layout[#layout + 1] = {
			widget_type = layout_blueprint_names.category,
			achievement = achievement,
		}
	else
		layout[#layout + 1] = {
			widget_type = layout_blueprint_names.dynamic_spacing,
			size = {
				grid_size[1],
				20,
			},
		}
	end

	height_used = height_used + blueprint[layout_blueprint_names.tracked].size[2]

	if use_spacing then
		layout[#layout + 1] = {
			widget_type = layout_blueprint_names.dynamic_spacing,
			size = {
				grid_size[1],
				10,
			},
		}
		height_used = height_used + 10
	end

	layout[#layout + 1] = {
		widget_type = layout_blueprint_names.penance_icon,
		texture = achievement.icon,
		completed = is_complete,
		can_claim = can_claim,
		family_index = achievement_family_order,
	}
	height_used = height_used + blueprint[layout_blueprint_names.penance_icon].size[2]

	if use_spacing then
		layout[#layout + 1] = {
			widget_type = layout_blueprint_names.dynamic_spacing,
			size = {
				grid_size[1],
				5,
			},
		}
		height_used = height_used + 5
	end

	local title = AchievementUIHelper.localized_title(achievement_definition)

	if title then
		layout[#layout + 1] = {
			widget_type = layout_blueprint_names.header,
			text = title,
		}
		height_used = height_used + blueprint[layout_blueprint_names.header].size[2]
	end

	if draw_progress_bar and not can_claim then
		if use_spacing then
			layout[#layout + 1] = {
				widget_type = layout_blueprint_names.dynamic_spacing,
				size = {
					grid_size[1],
					10,
				},
			}
			height_used = height_used + 10
		end

		local bar_progress, progress, goal = self:_get_achievement_bar_progress(achievement_definition)
		local progress_text = progress > 0 and TextUtilities.apply_color_to_text(tostring(progress), Color.ui_achievement_icon_completed(255, true)) or tostring(progress)

		layout[#layout + 1] = {
			widget_type = layout_blueprint_names.progress_bar,
			text = progress_text .. "/" .. tostring(goal),
			progress = bar_progress,
		}
		height_used = height_used + blueprint[layout_blueprint_names.progress_bar].size[2]

		if use_spacing then
			layout[#layout + 1] = {
				widget_type = layout_blueprint_names.dynamic_spacing,
				size = {
					grid_size[1],
					10,
				},
			}
			height_used = height_used + 10
		end
	end

	local min_description_height = 10
	local description = AchievementUIHelper.localized_description(achievement_definition)
	local description_layout_entry

	if description and not can_claim then
		description_layout_entry = {
			widget_type = layout_blueprint_names.body,
			text = description,
			size = {},
		}
		layout[#layout + 1] = description_layout_entry
	end

	local reward_item, item_group = AchievementUIHelper.get_reward_item(achievement_definition)
	local reward_layouts = {}
	local reward_layouts_height = 0

	if reward_item then
		reward_layouts[#reward_layouts + 1] = {
			widget_type = layout_blueprint_names.score_and_reward,
			item = reward_item,
			item_group = item_group,
			score = achievement_score,
		}
		reward_layouts_height = reward_layouts_height + blueprint[layout_blueprint_names.score_and_reward].size[2]
	else
		reward_layouts[#reward_layouts + 1] = {
			widget_type = layout_blueprint_names.score,
			score = achievement_score,
		}
		reward_layouts_height = reward_layouts_height + blueprint[layout_blueprint_names.score].size[2]
	end

	local space_left = grid_size[2] - (height_used + reward_layouts_height)
	local stats = achievement_definition.stats
	local stats_sorting = achievement_definition.stats_sorting

	if stats and not can_claim then
		local stats_layouts = {}
		local allowed_stats_height = is_tooltip and math.huge or space_left - min_description_height
		local top_spacing = 10
		local bottom_spacing = 10

		if use_spacing then
			allowed_stats_height = allowed_stats_height - (top_spacing + bottom_spacing)
		end

		local stat_size = {
			blueprint[layout_blueprint_names.stat].size[1],
			blueprint[layout_blueprint_names.stat].size[2],
		}
		local max_amount_on_per_column = math.floor(allowed_stats_height / stat_size[2])

		if not is_tooltip then
			max_amount_on_per_column = math.min(max_amount_on_per_column, 4)
		end

		local player_id = player.remote and player.stat_id or player:local_player_id()

		for stat_name, stat_settings in _stats_sort_iterator(stats, stats_sorting) do
			local target = stat_settings.target
			local value = math.min(Managers.stats:read_user_stat(player_id, stat_name), target)
			local value_text = value > 0 and TextUtilities.apply_color_to_text(tostring(value), Color.ui_achievement_icon_completed(255, true)) or tostring(value)
			local target_text = value == target and TextUtilities.apply_color_to_text(tostring(target), Color.ui_achievement_icon_completed(255, true)) or tostring(target)
			local progress_text = value_text .. "/" .. target_text
			local loc_stat_name = string.format("• %s", Localize(StatDefinitions[stat_name].stat_name or "unknown"))

			stats_layouts[#stats_layouts + 1] = {
				widget_type = layout_blueprint_names.stat,
				text = loc_stat_name,
				value = progress_text,
				size = {
					stat_size[1],
					stat_size[2],
				},
			}
		end

		local max_stat_amount

		if max_amount_on_per_column < #stats_layouts then
			local num_columns = 2

			stat_size[1] = stat_size[1] / num_columns
			max_stat_amount = math.min(max_amount_on_per_column * num_columns, #stats_layouts)

			local biggest_column_amount = math.ceil(max_stat_amount / num_columns)

			height_used = height_used + stat_size[2] * biggest_column_amount
		else
			max_stat_amount = math.min(#stats_layouts, max_amount_on_per_column)
			height_used = height_used + stat_size[2] * max_stat_amount
		end

		if use_spacing and #stats_layouts > 0 then
			layout[#layout + 1] = {
				widget_type = layout_blueprint_names.dynamic_spacing,
				size = {
					grid_size[1],
					top_spacing,
				},
			}
			height_used = height_used + top_spacing
		end

		for i = 1, max_stat_amount do
			local stat_layout = stats_layouts[i]

			if stat_layout then
				stat_layout.size = stat_size
				layout[#layout + 1] = stat_layout
			end
		end

		if max_stat_amount < #stats_layouts then
			layout[#layout + 1] = {
				strict_size = true,
				widget_type = layout_blueprint_names.body,
				text_color = Color.terminal_text_body_sub_header(255, true),
				text = Localize("loc_penance_menu_additional_objectives_info", true, {
					num_extra_objectives = tostring(#stats_layouts - max_stat_amount),
				}),
				size = {
					nil,
					20,
				},
			}
			height_used = height_used + 20
		end

		if use_spacing and #stats_layouts > 0 then
			layout[#layout + 1] = {
				widget_type = layout_blueprint_names.dynamic_spacing,
				size = {
					grid_size[1],
					bottom_spacing,
				},
			}
			height_used = height_used + bottom_spacing
		end

		space_left = grid_size[2] - (height_used + reward_layouts_height)
	end

	local achievement_type_name = achievement_definition.type

	if achievement_type_name == "meta" and not can_claim then
		local sub_achievements = achievement_definition.achievements
		local num_sub_achievements = table.size(sub_achievements)
		local num_entries = 0
		local max_entries = is_tooltip and 999 or 5
		local sub_achievement_entries = {}
		local blueprint_name = is_tooltip and "penance_icon_and_name" or "penance_icon_small"

		for sub_achievement_id, _ in pairs(sub_achievements) do
			if num_entries < max_entries then
				num_entries = num_entries + 1

				local sub_achievement = AchievementUIHelper.achievement_definition_by_id(sub_achievement_id)
				local sub_achievement_is_complete = Managers.achievements:achievement_completed(player, sub_achievement_id)
				local sub_achievement_title = AchievementUIHelper.localized_title(sub_achievement)
				local sub_achievement_family_order = AchievementUIHelper.get_achievement_family_order(sub_achievement)

				sub_achievement_entries[#sub_achievement_entries + 1] = {
					widget_type = layout_blueprint_names[blueprint_name],
					texture = sub_achievement.icon,
					completed = sub_achievement_is_complete,
					text = sub_achievement_title,
					family_index = sub_achievement_family_order,
				}
			else
				break
			end
		end

		local num_rows

		if blueprint_name == "penance_icon_small" then
			local entry_width = blueprint[layout_blueprint_names[blueprint_name]].size[1]
			local total_entries_width = entry_width * num_entries
			local width_left = grid_size[1] - total_entries_width
			local mid_spacing = math.min(num_entries > 0 and width_left / (num_entries - 1) or 0, 10)
			local total_mid_spacing = mid_spacing * (num_entries - 1)
			local side_spacing = (grid_size[1] - (total_entries_width + total_mid_spacing)) * 0.5

			layout[#layout + 1] = {
				widget_type = layout_blueprint_names.dynamic_spacing,
				size = {
					side_spacing,
					0,
				},
			}

			for i = 1, #sub_achievement_entries do
				layout[#layout + 1] = sub_achievement_entries[i]

				if i < #sub_achievement_entries then
					layout[#layout + 1] = {
						widget_type = layout_blueprint_names.dynamic_spacing,
						size = {
							mid_spacing,
							0,
						},
					}
				end
			end

			layout[#layout + 1] = {
				widget_type = layout_blueprint_names.dynamic_spacing,
				size = {
					side_spacing,
					0,
				},
			}

			local total_width = entry_width * num_entries

			num_rows = math.ceil(total_width / grid_size[1])
		else
			if use_spacing then
				layout[#layout + 1] = {
					widget_type = layout_blueprint_names.dynamic_spacing,
					size = {
						grid_size[1],
						20,
					},
				}
				height_used = height_used + 20
			end

			for i = 1, #sub_achievement_entries do
				layout[#layout + 1] = sub_achievement_entries[i]

				if i < #sub_achievement_entries then
					layout[#layout + 1] = {
						widget_type = layout_blueprint_names.dynamic_spacing,
						size = {
							grid_size[1],
							10,
						},
					}
					height_used = height_used + 10
				end
			end

			num_rows = num_entries
		end

		local height_added = blueprint[layout_blueprint_names.penance_icon_small].size[2] * num_rows

		if max_entries < num_sub_achievements then
			if use_spacing then
				layout[#layout + 1] = {
					widget_type = layout_blueprint_names.dynamic_spacing,
					size = {
						grid_size[1],
						10,
					},
				}
				height_added = height_added + 10
			end

			layout[#layout + 1] = {
				strict_size = true,
				widget_type = layout_blueprint_names.body,
				text_color = Color.terminal_text_body_sub_header(255, true),
				text = Localize("loc_penance_menu_additional_objectives_info", true, {
					num_extra_objectives = tostring(num_sub_achievements - max_entries),
				}),
				size = {
					nil,
					20,
				},
			}
			height_added = height_added + 20

			if use_spacing then
				layout[#layout + 1] = {
					widget_type = layout_blueprint_names.dynamic_spacing,
					size = {
						grid_size[1],
						10,
					},
				}
				height_added = height_added + 10
			end
		elseif use_spacing then
			layout[#layout + 1] = {
				widget_type = layout_blueprint_names.dynamic_spacing,
				size = {
					grid_size[1],
					20,
				},
			}
			height_added = height_added + 20
		end

		height_used = height_used + height_added
		space_left = space_left - height_added
	end

	if description_layout_entry then
		description_layout_entry.size[2] = space_left
		height_used = height_used + space_left
	elseif can_claim then
		layout[#layout + 1] = {
			widget_type = layout_blueprint_names.dynamic_spacing,
			size = {
				grid_size[1],
				space_left,
			},
		}
		height_used = height_used + space_left
	end

	if #reward_layouts > 0 then
		table.append(layout, reward_layouts)

		height_used = height_used + reward_layouts_height
	end

	return layout
end

PenanceOverviewView._should_display_achievement = function (self, player, is_complete, achievement_definition)
	local flags = achievement_definition.flags
	local hide_missing = flags.hide_missing
	local previous_id = achievement_definition.previous
	local next_id = achievement_definition.next
	local is_last = next_id == nil

	if hide_missing then
		local next_is_complete = next_id and Managers.achievements:achievement_completed(player, next_id)

		return is_complete and (is_last or not next_is_complete)
	else
		local previous_is_complete = not previous_id or Managers.achievements:achievement_completed(player, previous_id)

		return previous_is_complete and (not is_complete or is_last)
	end
end

PenanceOverviewView._cache_achievements = function (self, player)
	local total_score = 0
	local achievements_by_category = {}
	local achievements_by_category_unsorted = {}
	local achievements_by_recency = {}
	local achievements_by_progress = {}
	local achievement_definitions = Managers.achievements:achievement_definitions()
	local score_by_category = {}
	local completed_score_by_category = {}

	for _, achievement_config in pairs(achievement_definitions) do
		local achievement_id = achievement_config.id
		local category = achievement_config.category
		local is_completed = Managers.achievements:achievement_completed(player, achievement_id)
		local is_visible = true

		if is_visible then
			local _achievements_by_category = achievements_by_category[category] or {}

			_achievements_by_category[#_achievements_by_category + 1] = achievement_id
			achievements_by_category[category] = _achievements_by_category

			local _achievements_by_category_unsorted = achievements_by_category_unsorted[category] or {}

			_achievements_by_category_unsorted[#_achievements_by_category_unsorted + 1] = achievement_id
			achievements_by_category_unsorted[category] = _achievements_by_category_unsorted

			if not achievement_config.flags.hide_from_carousel or not achievement_config.type == "meta" then
				achievements_by_progress[#achievements_by_progress + 1] = achievement_id
			end
		end

		local should_add_score = not achievement_config.flags.hide_missing or is_completed

		if should_add_score then
			local achievement_score = achievement_config.score or 0

			score_by_category[category] = (score_by_category[category] or 0) + achievement_score

			if is_completed then
				total_score = total_score + achievement_score
				completed_score_by_category[category] = (completed_score_by_category[category] or 0) + achievement_score
				achievements_by_recency[#achievements_by_recency + 1] = achievement_id
			end
		end
	end

	local function _sort_by_index(a, b)
		return achievement_definitions[a].index < achievement_definitions[b].index
	end

	local function _sort_by_recency(a, b)
		local _, a_completion_time = Managers.achievements:achievement_completed(player, a)
		local _, b_completion_time = Managers.achievements:achievement_completed(player, b)

		if a_completion_time == b_completion_time then
			return _sort_by_index(a, b)
		end

		local a_type, b_type = type(a_completion_time), type(b_completion_time)

		if a_type == b_type then
			return b_completion_time < a_completion_time
		end

		local a_type_value = a_type == "number" and 2 or a_type == "string" and 1 or 0
		local b_type_value = b_type == "number" and 2 or b_type == "string" and 1 or 0

		return a_type_value < b_type_value
	end

	local function _sort_by_family(a, b)
		local a_achievement_definition = AchievementUIHelper.achievement_definition_by_id(a)
		local b_achievement_definition = AchievementUIHelper.achievement_definition_by_id(b)

		if AchievementUIHelper.is_achievements_from_same_family(a_achievement_definition, b_achievement_definition) then
			local a_achievement_family_order = AchievementUIHelper.get_achievement_family_order(a_achievement_definition)
			local b_achievement_family_order = AchievementUIHelper.get_achievement_family_order(b_achievement_definition)

			if a_achievement_family_order == b_achievement_family_order then
				return AchievementUIHelper.localized_title(a_achievement_definition) < AchievementUIHelper.localized_title(b_achievement_definition)
			else
				return a_achievement_family_order < b_achievement_family_order
			end
		end

		return AchievementUIHelper.localized_title(a_achievement_definition) < AchievementUIHelper.localized_title(b_achievement_definition)
	end

	self._achievements_by_category = achievements_by_category
	self._achievements_by_category_unsorted = achievements_by_category_unsorted

	for _, achievements in pairs(achievements_by_category) do
		table.sort(achievements, _sort_by_recency)
	end

	for _, achievements in pairs(achievements_by_category_unsorted) do
		table.sort(achievements, _sort_by_family)
	end

	self._achievements_by_recency = achievements_by_recency

	table.sort(achievements_by_recency, _sort_by_recency)

	self._achievements_by_progress = achievements_by_progress

	table.sort(achievements_by_progress, function (a, b)
		local a_achievement_id = a
		local a_achievement = AchievementUIHelper.achievement_definition_by_id(a_achievement_id)
		local a_using_progress = self:_draw_progress_bar_for_achievement(a_achievement)
		local a_bar_progress = a_using_progress and self:_get_achievement_bar_progress(a_achievement) or 0
		local b_achievement_id = b
		local b_achievement = AchievementUIHelper.achievement_definition_by_id(b_achievement_id)
		local b_using_progress = self:_draw_progress_bar_for_achievement(b_achievement)
		local b_bar_progress = b_using_progress and self:_get_achievement_bar_progress(b_achievement) or 0

		return b_bar_progress < a_bar_progress
	end)

	self._score_by_category = score_by_category
	self._completed_score_by_category = completed_score_by_category
end

local _device_list = {
	Keyboard,
	Mouse,
	Pad1,
}

PenanceOverviewView._handle_input = function (self, input_service, dt, t)
	if not self._initialized then
		return
	end

	local wintrack_element = self._wintrack_element

	if wintrack_element then
		local handle_wintrack_element_input = not self._result_overlay

		wintrack_element:set_handle_input(handle_wintrack_element_input)

		if self._draw_carousel then
			local currently_hovered_item = wintrack_element:currently_hovered_item()

			if not currently_hovered_item and math.abs((self._carousel_target_progress or 0) - (self._carousel_current_progress or 0)) < PenanceOverviewViewSettings.carousel_scroll_input_handle_threshold then
				self:_handle_carousel_scroll(input_service, dt)
			end
		end
	end

	local any_input_pressed = false
	local input_device_list = InputUtils.platform_device_list()

	for i = 1, #input_device_list do
		local device = input_device_list[i]

		if device.active() and device.any_pressed() then
			any_input_pressed = true

			break
		end
	end

	if any_input_pressed and self:_is_result_presentation_active() then
		self._close_result_overlay_next_frame = true
	end

	if self._penance_grid then
		local selected_grid_index = self._penance_grid:selected_grid_index()

		if selected_grid_index ~= self._selected_grid_penance_index then
			self:_on_penance_grid_selection_changed(selected_grid_index)
		end
	end
end

PenanceOverviewView.draw = function (self, dt, t, input_service, layer)
	if self._result_overlay then
		input_service = input_service:null_service()
	end

	local render_settings = self._render_settings
	local alpha_multiplier = render_settings.alpha_multiplier
	local animation_alpha_multiplier = self.animation_alpha_multiplier or 0

	render_settings.alpha_multiplier = animation_alpha_multiplier

	PenanceOverviewView.super.draw(self, dt, t, input_service, layer)

	local ui_renderer = self._ui_renderer
	local carousel_entries = self._carousel_entries

	if carousel_entries then
		for i = 1, #carousel_entries do
			local entry = carousel_entries[i]
			local grid = entry.grid
			local grid_alpha_multiplier = grid:alpha_multiplier()

			if grid_alpha_multiplier and grid_alpha_multiplier > 0 then
				grid:draw(dt, t, ui_renderer, render_settings, input_service)
			end
		end
	end

	render_settings.alpha_multiplier = alpha_multiplier
end

PenanceOverviewView._get_carousel_entry_settings = function (self, index)
	local carousel_entry_settings = PenanceOverviewViewSettings.carousel_entry_settings
	local position_index = (index - 1) % #carousel_entry_settings + 1
	local entry_settings = carousel_entry_settings[position_index]

	return entry_settings
end

PenanceOverviewView._add_carousel_entry = function (self, index)
	local current_ids = {}

	for i = 1, #self._carousel_entries do
		current_ids[#current_ids + 1] = self._carousel_entries[i].achievement_id
	end

	local add_layouts = 1
	local new_layouts = self:_get_carousel_layouts(current_ids, add_layouts)

	for i = 1, #new_layouts do
		local layout = new_layouts[i]
		local entry = self:_create_carousel_entry(layout)

		self._carousel_entries[index] = entry
	end
end

PenanceOverviewView._update_carousel_entries = function (self, dt, t, input_service)
	if self._claim_animation_id and not self:_is_animation_completed(self._claim_animation_id) then
		local entry = self._carousel_entries[self._destroyed_carousel_index]
		local grid = entry.grid

		if self._claim_animation_new_pivot then
			grid:set_pivot_offset(grid._pivot_offset[1], self._claim_animation_new_pivot)
			grid:update(dt, t, input_service)
		end

		return
	elseif self._claim_animation_id then
		self._claim_animation_id = nil
		self._claim_animation_new_pivot = nil

		self:_add_carousel_entry(self._destroyed_carousel_index)

		local entry = self._carousel_entries[self._destroyed_carousel_index]
		local grid = entry.grid

		if not self._using_cursor_navigation then
			grid:select()
		end

		self._destroyed_carousel_index = nil

		return
	end

	local global_alpha_multiplier = 1 - math.easeOutCubic(self._anim_wintrack_reward_hover_progress or 0)

	if self._draw_carousel then
		local carousel_entries = self._carousel_entries

		if carousel_entries then
			local carousel_entry_settings = PenanceOverviewViewSettings.carousel_entry_settings
			local num_visible_entries = #carousel_entry_settings
			local carousel_start_progress = self._carousel_start_progress or 0
			local carousel_target_progress = self._carousel_target_progress or 0
			local carousel_current_progress = self._carousel_current_progress or 0
			local carousel_target_progress_diff = carousel_target_progress - carousel_start_progress
			local carousel_scroll_speed_multiplier = self._carousel_scroll_speed_multiplier or 1
			local step_amount = math.max(dt * 0.6 * carousel_scroll_speed_multiplier, 5e-05)

			if carousel_target_progress_diff > 0 then
				self._carousel_current_progress = math.min(carousel_current_progress + step_amount, carousel_target_progress)
			else
				self._carousel_current_progress = math.max(carousel_current_progress - step_amount, carousel_target_progress)
			end

			if self._carousel_start_progress and self._carousel_current_progress == carousel_target_progress then
				self._carousel_scroll_speed_multiplier = nil
				self._carousel_start_progress = nil
			elseif self._carousel_scroll_speed_multiplier then
				self._carousel_scroll_speed_multiplier = math.max(self._carousel_scroll_speed_multiplier - PenanceOverviewViewSettings.carousel_scroll_speed_decrease, PenanceOverviewViewSettings.carousel_min_scroll_speed)
			end

			local anim_progress = (self._carousel_current_progress or 0) % 1
			local num_options = #carousel_entries
			local progress_per_option = 1 / num_options
			local entry_move_progress = anim_progress % progress_per_option / progress_per_option
			local center_index = math.ceil(num_visible_entries / 2)
			local start_reading_index = math.floor(anim_progress / progress_per_option) + math.floor(num_options * 0.5)
			local default_position = self:_scenegraph_world_position("carousel_card")
			local current_progress = self._carousel_current_progress
			local previous_progress = carousel_current_progress
			local progress_diff = current_progress >= 0 and current_progress - previous_progress or -(current_progress - previous_progress)

			self._carousel_accumulated_progress = self._carousel_accumulated_progress or 0
			self._carousel_accumulated_progress = self._carousel_accumulated_progress + progress_diff

			local carousel_state = "inactive"

			if self._carousel_current_progress ~= carousel_current_progress then
				if not self._carousel_animating then
					self._carousel_animating = true

					self:_play_sound(UISoundEvents.penance_menu_carousel_move_start)

					carousel_state = "starting"
				elseif progress_per_option <= self._carousel_accumulated_progress or self._carousel_accumulated_progress <= -progress_per_option then
					self._carousel_accumulated_progress = 0

					self:_play_sound(UISoundEvents.penance_menu_carousel_move_pass)

					carousel_state = "pass_card"
				else
					carousel_state = "in_progress"
				end
			elseif self._carousel_animating then
				self._carousel_animating = false
				self._carousel_accumulated_progress = 0

				self:_play_sound(UISoundEvents.penance_menu_carousel_move_stop)

				carousel_state = "stopped"
			end

			for i = 1, #carousel_entries do
				local entry = carousel_entries[i]
				local grid = entry.grid

				grid:set_visibility(false)
				grid:set_background_hovered(false)

				local anim_speed = 5
				local anim_hover_progress = entry.anim_hover_progress or 0

				if i == self._hovered_carousel_card_index then
					anim_hover_progress = math.min(anim_hover_progress + dt * anim_speed, 1)
				else
					anim_hover_progress = math.max(anim_hover_progress - dt * anim_speed, 0)
				end

				entry.anim_hover_progress = anim_hover_progress
			end

			local carousel_entry_anim_progress = self._carousel_entry_anim_progress or 0
			local hovered_card_index, hovered_card_layer
			local scroll_to_card_on_pressed = false
			local favorite_on_right_pressed = false
			local hovered_carousel_index

			for i = 1, num_visible_entries do
				local read_index = (start_reading_index + (i - 1)) % num_options + 1
				local index_diff = i - center_index
				local index_diff_abs = math.abs(index_diff)
				local entry_anim_progress = 0.8 + 0.2 * math.clamp(carousel_entry_anim_progress * ((center_index - index_diff_abs) * 0.5), 0, 1)
				local entry_alpha_anim_progress = math.clamp(carousel_entry_anim_progress * (center_index - index_diff_abs + 1), 0, 1)
				local entry = carousel_entries[read_index]
				local grid = entry.grid
				local entry_settings = self:_get_carousel_entry_settings(i)
				local entry_position = entry_settings.position
				local entry_alpha = entry_settings.alpha
				local entry_color_intensity = entry_settings.color_intensity
				local previous_entry_settings = self:_get_carousel_entry_settings(i - 1)
				local previous_entry_position = previous_entry_settings.position
				local previous_entry_alpha = previous_entry_settings.alpha
				local previous_entry_color_intensity = previous_entry_settings.color_intensity
				local index_anim_offset_x = entry_move_progress * (entry_position[1] - previous_entry_position[1])
				local index_anim_offset_y = entry_move_progress * (entry_position[2] - previous_entry_position[2])
				local alpha_anim_offset = entry_move_progress * (entry_alpha - previous_entry_alpha)
				local color_intensity_anim_offset = entry_move_progress * (entry_color_intensity - previous_entry_color_intensity)
				local anim_hover_progress = entry.anim_select_progress or entry.anim_hover_progress or 0
				local hover_offset_y = -10 * math.easeCubic(anim_hover_progress)
				local x = default_position[1] + (entry_position[1] - index_anim_offset_x) * entry_anim_progress
				local y = default_position[2] + (entry_position[2] - index_anim_offset_y) * entry_anim_progress - (1 - entry_anim_progress) * 100 + hover_offset_y
				local layer = (center_index - index_diff_abs) * 20

				grid:set_pivot_offset(x, y)
				grid:set_grid_interaction_offset(0, -hover_offset_y)
				grid:set_draw_layer(layer + 10)

				local alpha_multiplier = (entry_alpha - alpha_anim_offset) * global_alpha_multiplier * entry_alpha_anim_progress
				local color_intensity_multiplier = entry_color_intensity - color_intensity_anim_offset

				grid:set_alpha_multiplier(alpha_multiplier)
				grid:set_color_intensity_multiplier(color_intensity_multiplier)
				grid:set_visibility(alpha_multiplier > 0)

				if alpha_multiplier > 0 then
					grid:update(dt, t, input_service)
				end

				local is_hover = grid:hovered()
				local is_selected = grid:selected()

				if (is_hover or is_selected) and (not hovered_card_layer or hovered_card_layer < layer) and alpha_multiplier > 0.4 then
					hovered_card_index = read_index
					hovered_card_layer = layer
					hovered_carousel_index = i
				end
			end

			local entry = carousel_entries[self._hovered_carousel_card_index]

			if entry then
				local widgets = entry.grid:widgets()

				for i = 1, #widgets do
					local widget = widgets[i]

					widget.content.hovered = false
				end
			end

			if self._hovered_carousel_card_index ~= hovered_card_index then
				self:_play_sound(UISoundEvents.penance_menu_carousel_hovered)
			end

			self._hovered_carousel_card_index = hovered_card_index

			if hovered_card_index then
				local entry = carousel_entries[hovered_card_index]
				local grid = entry.grid

				grid:set_background_hovered(true)

				local pressed, right_pressed = grid:pressed()

				if entry then
					local widgets = entry.grid:widgets()

					for i = 1, #widgets do
						local widget = widgets[i]

						widget.content.hovered = true
					end
				end

				local can_claim = self:_can_claim_achievement_by_id(entry.achievement_id)

				if self._using_cursor_navigation then
					if pressed then
						local alpha_multiplier = grid:alpha_multiplier()

						if not can_claim or can_claim and alpha_multiplier < 0.95 then
							self:_set_carousel_index(hovered_card_index, true)
						else
							self:_on_carousel_card_pressed(hovered_card_index, entry)
						end
					end
				elseif pressed then
					if can_claim then
						self:_on_carousel_card_pressed(hovered_card_index, entry)
					end
				else
					self:_set_carousel_index(hovered_card_index, true)
				end
			end
		end
	end

	self._widgets_by_name.carousel_header.content.visible = self._draw_carousel
	self._widgets_by_name.carousel_footer.content.visible = self._draw_carousel
end

PenanceOverviewView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	PenanceOverviewView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

PenanceOverviewView._set_carousel_index = function (self, index, animate, has_direction_changed)
	local previous_index = self._current_carousel_index or 1

	self._current_carousel_index = index

	local num_carousel_entries = #self._carousel_entries
	local progress_per_index = 1 / num_carousel_entries
	local start = previous_index - 1
	local goal = index - 1
	local clockwise_distance = (goal - start) % num_carousel_entries
	local counterclockwise_distance = (start - goal) % num_carousel_entries
	local target_progress

	if clockwise_distance < counterclockwise_distance then
		target_progress = progress_per_index * clockwise_distance
	else
		target_progress = -progress_per_index * counterclockwise_distance
	end

	if has_direction_changed then
		self._current_scroll_direction = nil
	end

	self._carousel_scroll_speed_multiplier = math.min((self._carousel_scroll_speed_multiplier or PenanceOverviewViewSettings.carousel_initial_scroll_speed) + PenanceOverviewViewSettings.carousel_scroll_speed_increase, PenanceOverviewViewSettings.carousel_max_scroll_speed)
	self._carousel_start_progress = self._carousel_current_progress or self._carousel_target_progress or 0
	self._carousel_target_progress = (self._carousel_target_progress or 0) + target_progress
	self._widgets_by_name.carousel_footer.content.text = string.format("%d / %d", self._current_carousel_index, num_carousel_entries)
end

PenanceOverviewView._handle_carousel_scroll = function (self, input_service, dt)
	if self._result_overlay then
		input_service = input_service:null_service()
	end

	local navigation_value = 0

	if not self._using_cursor_navigation then
		if input_service:get("navigate_left_continuous") then
			navigation_value = -1
		elseif input_service:get("navigate_right_continuous") then
			navigation_value = 1
		end
	else
		local axis = 2
		local scroll_axis = input_service:get("scroll_axis")

		navigation_value = scroll_axis[axis]
	end

	if navigation_value ~= 0 then
		self._accumulated_scroll_value = self._accumulated_scroll_value or 0
		self._accumulated_scroll_value = self._accumulated_scroll_value + navigation_value

		if self._accumulated_scroll_value >= 1 or self._accumulated_scroll_value <= -1 then
			local previous_scroll_direction = self._current_scroll_direction
			local current_scroll_direction = navigation_value > 0 and -1 or 1
			local direction_changed = previous_scroll_direction and previous_scroll_direction ~= current_scroll_direction

			if current_scroll_direction < 0 then
				local added_value = self._using_cursor_navigation and -1 or 1
				local index = math.index_wrapper((self._current_carousel_index or 0) + added_value, #self._carousel_entries)

				self:_set_carousel_index(index, true, direction_changed)
			else
				local added_value = self._using_cursor_navigation and 1 or -1
				local index = math.index_wrapper((self._current_carousel_index or 0) + added_value, #self._carousel_entries)

				self:_set_carousel_index(index, true, direction_changed)
			end

			if not self._using_cursor_navigation then
				self:_focus_on_card(self._current_carousel_index)
			end

			self._current_scroll_direction = current_scroll_direction
			self._accumulated_scroll_value = 0
		end
	elseif self._accumulated_scroll_value ~= 0 then
		self._accumulated_scroll_value = 0
	end
end

PenanceOverviewView._focus_on_card = function (self, index)
	local carousel_entries = self._carousel_entries

	if carousel_entries then
		for i = 1, #carousel_entries do
			local entry = carousel_entries[i]
			local grid = entry.grid

			if index == i then
				grid:select()
			else
				grid:unselect()
			end
		end
	end
end

PenanceOverviewView.on_resolution_modified = function (self, scale)
	PenanceOverviewView.super.on_resolution_modified(self, scale)
	self:_update_categories_tab_bar_position()
	self:_carousel_grid_on_resolution_modified(scale)
end

PenanceOverviewView._setup_account_state_data = function (self, data)
	local state = data.state

	if not state then
		return
	end

	local wintrack_element = self._wintrack_element
	local total_penance_points = state.xpTracked
	local animate = false
	local force_reward_bar_change = true

	self:_add_points(total_penance_points, animate, force_reward_bar_change)

	local rewarded_tiers = state.rewarded + 1

	self._rewarded_tiers = rewarded_tiers

	local already_claimed_tiers = data.claims
end

PenanceOverviewView._setup_track_data = function (self, data)
	local rewards = {}
	local points_per_reward = 100

	if data then
		local tiers = data.tiers

		if tiers then
			local archetype_name = self:_player():archetype_name()

			for i = 1, #tiers do
				local tier = tiers[i]
				local tier_rewards = tier.rewards
				local xp_limit = tier.xpLimit
				local items = {}

				for reward_name, reward in pairs(tier_rewards) do
					if reward.type == "item" then
						local item_id = reward.id
						local item = MasterItems.get_item(item_id)

						if #items > 0 then
							local first_item_archetypes = items[1].archetypes
							local first_item_has_matching_archetype = false

							if first_item_archetypes then
								for j = 1, #first_item_archetypes do
									local item_archetype = first_item_archetypes[j]

									if item_archetype == archetype_name then
										first_item_has_matching_archetype = true

										break
									end
								end
							end

							if not first_item_has_matching_archetype then
								local archetypes = item.archetypes
								local added_item = false

								if archetypes then
									for j = 1, #archetypes do
										local item_archetype = archetypes[j]

										if item_archetype == archetype_name then
											items[#items + 1] = items[1]
											items[1] = item
											added_item = true

											break
										end
									end
								end

								if not added_item then
									items[#items + 1] = item
								end
							else
								items[#items + 1] = item
							end
						else
							items[#items + 1] = item
						end
					end
				end

				rewards[i] = {
					points_required = xp_limit,
					items = items,
				}
			end
		end
	end

	if #rewards > 0 then
		self._wintrack_rewards = rewards
		self._wintrack_element = self:_add_element(ViewElementWintrack, "wintrack", 150, {}, "wintrack")

		self._wintrack_element:assign_rewards(rewards, points_per_reward)
	end
end

PenanceOverviewView._add_points = function (self, points, animate, force_reward_bar_change)
	self._total_score = self._total_score + points

	if self._wintrack_element then
		self._wintrack_element:add_points(points, animate, force_reward_bar_change)
	end

	if animate then
		self:_play_sound(UISoundEvents.penance_menu_penance_complete)
		self:_start_animation("on_points_added", self._widgets_by_name, self)
	end
end

PenanceOverviewView._update_single_animations = function (self, dt, t)
	local ui_animations = self._ui_animations

	for key, ui_animation in pairs(ui_animations) do
		UIAnimation.update(ui_animation, dt)

		if UIAnimation.completed(ui_animation) then
			ui_animations[key] = nil
		end
	end
end

PenanceOverviewView._update_animations = function (self, dt, t)
	PenanceOverviewView.super._update_animations(self, dt, t)

	if not self._initialized then
		return
	end

	local wintrack_element = self._wintrack_element

	if not wintrack_element then
		return
	end

	local tooltip_visible = wintrack_element:tooltip_visible()
	local anim_speed = 3
	local previous_anim_wintrack_reward_hover_progress = self._anim_wintrack_reward_hover_progress or 0
	local anim_wintrack_reward_hover_progress

	if tooltip_visible then
		anim_wintrack_reward_hover_progress = math.min(previous_anim_wintrack_reward_hover_progress + dt * anim_speed, 1)
	else
		anim_wintrack_reward_hover_progress = math.max(previous_anim_wintrack_reward_hover_progress - dt * anim_speed, 0)
	end

	if previous_anim_wintrack_reward_hover_progress ~= anim_wintrack_reward_hover_progress then
		local global_alpha_multiplier = 1 - math.easeOutCubic(self._anim_wintrack_reward_hover_progress or 0)

		if self._penance_tooltip_grid then
			self._penance_tooltip_grid:set_alpha_multiplier(global_alpha_multiplier)
		end

		if self._penance_grid then
			self._penance_grid:set_alpha_multiplier(global_alpha_multiplier)
		end

		if self._categories_tab_bar then
			self._categories_tab_bar:set_alpha_multiplier(global_alpha_multiplier)
		end

		local widgets_by_name = self._widgets_by_name

		widgets_by_name.page_header.alpha_multiplier = global_alpha_multiplier
		widgets_by_name.carousel_header.alpha_multiplier = global_alpha_multiplier
		widgets_by_name.carousel_footer.alpha_multiplier = global_alpha_multiplier
	end

	self._anim_wintrack_reward_hover_progress = anim_wintrack_reward_hover_progress
end

PenanceOverviewView._set_handle_navigation = function (self)
	local result_active = self:_is_result_presentation_active()

	if self._penance_grid then
		local should_disable_navigation = result_active or self._wintracks_focused

		if self._penance_grid:input_disabled() ~= should_disable_navigation then
			self._penance_grid:disable_input(should_disable_navigation)
		end
	end

	if self._categories_tab_bar then
		local should_use_navigation = not result_active and self._selected_top_option_key == "browser" and not self._wintracks_focused

		if self._categories_tab_bar:is_handling_navigation_input() ~= should_use_navigation then
			self._categories_tab_bar:set_is_handling_navigation_input(should_use_navigation)
		end
	end

	if self._top_panel then
		local should_use_navigation = not result_active and not self._wintracks_focused

		if self._top_panel:is_handling_navigation_input() ~= should_use_navigation then
			self._top_panel:set_is_handling_navigation_input(should_use_navigation)
		end
	end
end

PenanceOverviewView.update = function (self, dt, t, input_service)
	self:_set_handle_navigation()

	if self._enter_animation_id and self:_is_animation_completed(self._enter_animation_id) and not self._enter_animation_complete then
		self._enter_animation_complete = true
		self._enter_animation_id = nil
	end

	self:_update_commendation_status()

	local account_state_data = self._account_state_data

	if not account_state_data then
		local pass_input, pass_draw = PenanceOverviewView.super.update(self, dt, t, input_service)

		return pass_input, pass_draw
	end

	self:_update_carousel_entries(dt, t, input_service)

	local present_achievement_id_tooltip = self._selected_achievement_id

	if present_achievement_id_tooltip and not self._draw_carousel then
		if present_achievement_id_tooltip ~= self._presented_achievement_id_tooltip then
			local achievement_id = present_achievement_id_tooltip or nil

			self:_present_achievement_tooltip(achievement_id)
		end
	elseif self._penance_tooltip_visible then
		self._presented_achievement_id_tooltip = nil
		self._penance_tooltip_visible = true

		self._penance_tooltip_grid:set_visibility(false)
	end

	if self._add_penance_claimed_points_callback and not self._result_overlay then
		self._add_penance_claimed_points_callback()

		self._add_penance_claimed_points_callback = nil
	end

	if self._close_result_overlay_next_frame then
		self._close_result_overlay_next_frame = nil

		self:_close_result_overlay()
	end

	local penance_to_reward_bundle_map = self._penance_to_reward_bundle_map

	if penance_to_reward_bundle_map and not self._populated_unclaimed_penances then
		self:_setup_achievements()
		self:_setup_penance_category_buttons(self._category_button_config)

		local carousel_achievement_layouts = self:_get_carousel_layouts()

		if #carousel_achievement_layouts > 0 then
			self:_setup_carousel_entries(carousel_achievement_layouts, self._ui_renderer)
		end

		self:_setup_top_panel()
		self:_force_select_panel_index(1)

		self._enter_animation_id = self:_start_animation("on_enter", self._widgets_by_name, self)
		self._populated_unclaimed_penances = true
		self._initialized = true
	end

	local track_data = self._track_data

	if track_data and account_state_data and not self._setup_track_data_done then
		self:_setup_track_data(track_data)
		self:_setup_account_state_data(account_state_data)

		self._setup_track_data_done = true
	end

	local result_overlay = self._result_overlay
	local handle_input = true

	if result_overlay then
		if result_overlay:presentation_complete() then
			self._close_result_overlay_next_frame = true
		end

		handle_input = false
	end

	local visual_penance_points = 0
	local wintrack_element = self._wintrack_element

	if wintrack_element then
		local reward_index = wintrack_element:ready_to_claim_reward_by_index()

		if reward_index then
			self:_claim_wintrack_reward(reward_index)
		end

		if wintrack_element:is_initialized() then
			local rewarded_tiers = self._rewarded_tiers

			if rewarded_tiers and not self._setup_claimed_track_rewards then
				for i = 1, rewarded_tiers do
					self._wintrack_element:set_index_claimed(i)
				end

				self._setup_claimed_track_rewards = true
			end
		end

		visual_penance_points = wintrack_element:visual_points()

		if visual_penance_points >= wintrack_element:max_points() then
			visual_penance_points = self._total_score
		end
	end

	self:_set_penance_points_presentation(visual_penance_points)

	if self._present_reward_overlay then
		local reward_presentation_item = self._wintrack_reward_items[1]
		local result_data = {
			type = "item",
			item = reward_presentation_item,
		}

		self:_setup_result_overlay(result_data, RESULT_TYPES.wintrack)

		self._present_reward_overlay = nil
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	self:_update_single_animations(dt, t)
	self:_update_vo(dt, t)

	local pass_input, pass_draw = PenanceOverviewView.super.update(self, dt, t, input_service)

	return handle_input and pass_input, pass_draw
end

PenanceOverviewView._verify_favorite_achievements = function (self, index)
	local account_data = Managers.save:account_data()
	local favorite_achievements = account_data.favorite_achievements
	local player = self:_player()

	for i = 1, #favorite_achievements do
		local achievement_id = favorite_achievements[i]
		local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
		local can_claim = self:_can_claim_achievement_by_id(achievement_id)
		local is_complete = not can_claim and Managers.achievements:achievement_completed(player, achievement_id)

		if not achievement_definition or is_complete then
			local removed = AchievementUIHelper.remove_favorite_achievement(achievement_id)

			if removed then
				Managers.telemetry_reporters:reporter("penance_view"):register_tracking_event(achievement_id, false)
			end
		end
	end
end

PenanceOverviewView._claim_wintrack_reward = function (self, index)
	local rewards = self._wintrack_rewards
	local reward = rewards[index]
	local points_required = reward.points_required
	local wintrack_element = self._wintrack_element
	local current_wintrack_point = wintrack_element:points()

	if points_required <= current_wintrack_point then
		local backend_tier_index = index - 1

		self:_claim_track_tier(backend_tier_index):next(function (data)
			local body = data.body

			if not body then
				Log.warning("PenanceOverviewView", "Failed claiming track, no body returned")

				return
			end

			local claimed_rewards = body.rewards

			if not claimed_rewards then
				Log.warning("PenanceOverviewView", "Failed claiming track, no rewards returned")

				return
			end

			for reward_name, claimed_reward in pairs(claimed_rewards) do
				if claimed_reward.type == "item" then
					ItemUtils.register_track_reward(claimed_reward)
				end
			end

			self._wintrack_element:on_reward_claimed(index)
			Managers.telemetry_reporters:reporter("penance_view"):register_track_claim_event(index)

			local reward_items = reward.items

			self._wintrack_reward_items = {}

			for i, item in ipairs(reward_items) do
				self._wintrack_reward_items[i] = item
			end

			self._present_reward_overlay = true

			self:_play_sound(UISoundEvents.penance_menu_wintrack_reward_claim)
		end)
	end
end

PenanceOverviewView.on_exit = function (self)
	local save_manager = Managers.save

	if save_manager and self._use_large_penance_entries_init_value ~= self._use_large_penance_entries then
		local account_data = save_manager:account_data()

		if account_data.interface_settings then
			account_data.interface_settings.penance_list_setting_show_list_view = self._use_large_penance_entries

			save_manager:queue_save()
		end
	end

	if self._world_spawner then
		self._world_spawner:release_listener()
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	if self._enter_animation_id then
		self:_stop_animation(self._enter_animation_id)

		self._enter_animation_id = nil
	end

	if self._player_icon_load_id then
		Managers.ui:unload_profile_portrait(self._player_icon_load_id)

		self._player_icon_load_id = nil
	end

	local carousel_entries = self._carousel_entries

	if carousel_entries then
		for i = 1, #carousel_entries do
			local grid = carousel_entries[i].grid

			grid:destroy()
		end

		self._carousel_entries = nil
	end

	PenanceOverviewView.super.on_exit(self)

	local level = Managers.state.mission and Managers.state.mission:mission_level()

	if level and self._hub_interaction then
		Level.trigger_event(level, "lua_penances_store_closed")
	end

	if Managers.achievements then
		Managers.achievements:deactive_reward_claim_state()
	end

	if self._entered then
		Managers.telemetry_reporters:stop_reporter("penance_view")
	end
end

PenanceOverviewView._get_scenegraph_size = function (self, scenegraph_id)
	local definitions = self._definitions
	local scenegraph_definition = definitions.scenegraph_definition
	local grid_scenegraph = scenegraph_definition[scenegraph_id]

	return grid_scenegraph.size
end

PenanceOverviewView._setup_tooltip_grid = function (self, layout)
	local grid_scenegraph_id = "tooltip_grid"
	local grid_size = self:_get_scenegraph_size(grid_scenegraph_id)

	if not self._penance_tooltip_grid then
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = false,
			hide_dividers = false,
			ignore_divider_height = true,
			scrollbar_horizontal_offset = -8,
			scrollbar_width = 7,
			title_height = 0,
			use_terminal_background = true,
			widget_icon_load_margin = 0,
			grid_spacing = {
				0,
				0,
			},
			grid_size = grid_size,
			mask_size = {
				grid_size[1],
				grid_size[2] + mask_padding_size,
			},
		}
		local layer = 10

		self._penance_tooltip_grid = self:_add_element(ViewElementGrid, "tooltip_grid", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position(grid_scenegraph_id, self._penance_tooltip_grid)
		self._penance_tooltip_grid:set_empty_message("")

		local top_divider_material = "content/ui/materials/frames/item_info_upper_dynamic"
		local top_divider_size = {
			grid_size[1] + 6,
			36,
		}
		local top_divider_position = {
			0,
			-7,
			0,
		}
		local bottom_divider_material = "content/ui/materials/frames/item_info_lower_dynamic"
		local bottom_divider_size = {
			grid_size[1] + 6,
			36,
		}
		local bottom_divider_position = {
			0,
			1,
			0,
		}

		self._penance_tooltip_grid:update_dividers(top_divider_material, top_divider_size, top_divider_position, bottom_divider_material, bottom_divider_size, bottom_divider_position)
	end

	local grid = self._penance_tooltip_grid

	grid:present_grid_layout(layout, PenanceOverviewViewDefinitions.grid_blueprints)
	grid:set_handle_grid_navigation(true)
end

PenanceOverviewView._setup_penance_grid = function (self, layout, optional_display_name)
	local background_scenegraph_id = "penance_grid_background"
	local background_size = self:_get_scenegraph_size(background_scenegraph_id)
	local grid_scenegraph_id = "penance_grid"
	local grid_size = self:_get_scenegraph_size(grid_scenegraph_id)

	if not self._penance_grid then
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = false,
			hide_background = false,
			ignore_divider_height = true,
			scroll_start_margin = 110,
			scrollbar_horizontal_offset = -8,
			scrollbar_vertical_alignment = "bottom",
			scrollbar_vertical_margin = 80,
			scrollbar_vertical_offset = -28,
			scrollbar_width = 7,
			title_height = 30,
			top_padding = 80,
			use_terminal_background = true,
			using_custom_gamepad_navigation = true,
			widget_icon_load_margin = 0,
			grid_spacing = PenanceOverviewViewSettings.penance_grid_spacing,
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 40,
				grid_size[2] + mask_padding_size,
			},
			edge_padding = background_size[1] - grid_size[1],
			bottom_divider_passes = PenanceOverviewViewDefinitions.bottom_divider_passes,
		}
		local layer = 10

		self._penance_grid = self:_add_element(ViewElementGrid, "penance_grid", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position(grid_scenegraph_id, self._penance_grid)
		self._penance_grid:set_empty_message("")

		local top_divider_material = "content/ui/materials/frames/achievements/panel_main_top_frame"
		local top_divider_size = {
			grid_size[1] + 60,
			66,
		}
		local top_divider_position = {
			0,
			0,
			0,
		}
		local bottom_divider_material = "content/ui/materials/frames/achievements/panel_main_lower_frame"
		local bottom_divider_size = {
			grid_size[1] + 60,
			84,
		}
		local bottom_divider_position = {
			0,
			0,
			0,
		}

		self._penance_grid:update_dividers(top_divider_material, top_divider_size, top_divider_position, bottom_divider_material, bottom_divider_size, bottom_divider_position)
		self._penance_grid:update_dividers_alpha(0, 1)
	else
		self._selected_grid_penance_index = nil

		self._penance_grid:select_grid_index(nil)
	end

	local grid = self._penance_grid
	local left_click_callback = callback(self, "_cb_on_penance_pressed")
	local right_click_callback
	local optional_on_present_callback = callback(function ()
		grid:select_first_index()
	end)

	grid:present_grid_layout(layout, PenanceOverviewViewDefinitions.grid_blueprints, left_click_callback, right_click_callback, nil, nil, optional_on_present_callback)
	grid:set_handle_grid_navigation(true)
end

PenanceOverviewView._on_penance_grid_selection_changed = function (self, index)
	self._selected_grid_penance_index = index

	local selected_achievement_id
	local penance_grid_widgets = self._penance_grid:widgets()

	if penance_grid_widgets then
		local widget = penance_grid_widgets[index]

		if widget then
			local content = widget.content
			local element = content.element
			local achievement_id = element and element.achievement_id

			selected_achievement_id = achievement_id
		end
	end

	self._selected_achievement_id = selected_achievement_id
end

PenanceOverviewView._claim_penance = function (self, reward_bundle)
	local backend_interface = Managers.backend.interfaces
	local player_rewards = backend_interface.player_rewards
	local promise = player_rewards:claim_bundle_reward(reward_bundle.id):next(function (data)
		if not data then
			Log.error("PenanceOverviewView", "Error claiming penance: no data returned")

			return
		end

		local body = data.body

		if not body then
			Log.error("PenanceOverviewView", "Error claiming penance: no body returned")

			return
		end

		local rewards = body.rewards

		if not rewards then
			Log.error("PenanceOverviewView", "Error claiming penance: no reward returned")

			return
		end

		local penance_id = reward_bundle.sourceInfo.sourceIdentifier

		self._penance_to_reward_bundle_map[penance_id] = nil

		Managers.telemetry_reporters:reporter("penance_view"):register_penance_claim_event(penance_id)

		self._refresh_carousel_entries = true

		local item_data, total_xp_awarded

		for _, reward in pairs(rewards) do
			local reward_type = reward.type

			if reward_type == "track-xp" then
				local xp_awarded = reward.xp

				total_xp_awarded = (total_xp_awarded or 0) + xp_awarded
			elseif reward_type == "item" then
				local master_id = reward.id

				if MasterItems.item_exists(master_id) then
					local rewarded_master_item = MasterItems.get_item(master_id)

					rewarded_master_item.uuid = reward.gearId
					rewarded_master_item.masterDataInstance = {
						id = master_id,
						overrides = {},
						slots = rewarded_master_item.slots,
					}

					do
						local gear_id, gear = ItemUtils.track_reward_item_to_gear(rewarded_master_item)

						Managers.data_service.gear:on_gear_created(gear_id, gear)

						local item = MasterItems.get_item_instance(gear, gear_id)

						if item then
							ItemUtils.mark_item_id_as_new(item, false)
						end
					end

					item_data = {
						type = "item",
						item = rewarded_master_item,
					}
				end
			end
		end

		local selected_option = self._category_by_achievement[penance_id]
		local num_unclaimed_left = selected_option and self._num_unclaimed_penances_per_category[selected_option] or -1

		if num_unclaimed_left > 0 then
			num_unclaimed_left = num_unclaimed_left - 1

			local content = self._widget_content_by_category[selected_option]

			if num_unclaimed_left == 0 and content then
				content.has_unclaimed_penances = false
			end

			self._num_unclaimed_penances_per_category[selected_option] = num_unclaimed_left
		end

		if item_data then
			self:_setup_result_overlay(item_data, RESULT_TYPES.penance)
		else
			self:_close_result_overlay()
		end

		if total_xp_awarded then
			if self._add_penance_claimed_points_callback then
				self._add_penance_claimed_points_callback()

				self._add_penance_claimed_points_callback = nil
			end

			if self._result_overlay then
				self._add_penance_claimed_points_callback = callback(function ()
					local animate = true
					local force_reward_bar_change = true

					self:_add_points(total_xp_awarded, animate, force_reward_bar_change)
				end)
			else
				local animate = true
				local force_reward_bar_change = true

				self:_add_points(total_xp_awarded, animate, force_reward_bar_change)
			end
		end
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("PenanceOverviewView", "Error claiming penance: %s", error_string)

		return {}
	end)

	return promise:next(function (data)
		return data
	end)
end

PenanceOverviewView._cb_on_penance_secondary_pressed = function (self, widget, config)
	local content = widget.content
	local element = content.element
	local achievement_id = element.achievement_id
	local is_currently_favorited = self:is_favorite_achievement(achievement_id)
	local is_favorited

	if not is_currently_favorited and not element.completed then
		is_favorited = self:request_achievement_favorite_add(achievement_id)

		self:_play_sound(UISoundEvents.penance_menu_penance_track)
	elseif self:request_achievement_favorite_remove(achievement_id) then
		is_favorited = false

		self:_play_sound(UISoundEvents.penance_menu_penance_untrack)
	end

	content.tracked = is_favorited
	element.tracked = is_favorited
end

PenanceOverviewView._cb_on_penance_pressed = function (self, widget, config)
	if widget.content.can_claim then
		local achievement_id = widget.content.element.achievement_id
		local reward_bundle = self._penance_to_reward_bundle_map[achievement_id]

		self._penance_claimed_callback = function ()
			self:request_achievement_favorite_remove(achievement_id)

			widget.content.can_claim = false
			widget.content.completed = true
			widget.content.tracked = false
		end

		if reward_bundle then
			self:_claim_penance(reward_bundle)
		else
			self._penance_claimed_callback()

			self._penance_claimed_callback = nil
		end
	else
		self._present_reward = true

		local penance_grid = self._penance_grid

		penance_grid:select_grid_widget(widget)
	end
end

PenanceOverviewView._setup_result_overlay = function (self, result_data, result_type)
	if self._result_overlay then
		self._result_overlay = nil

		self:_remove_element("result_overlay")
	end

	local reference_name = "result_overlay"
	local layer = 90

	if result_type == RESULT_TYPES.wintrack then
		self._result_overlay = self:_add_element(ViewElementWintrackItemRewardOverlay, reference_name, layer)
	elseif result_type == RESULT_TYPES.penance then
		self._result_overlay = self:_add_element(ViewElementItemResultOverlay, reference_name, layer)
	end

	self._result_overlay:start(result_data)
end

PenanceOverviewView._close_result_overlay = function (self)
	if self._result_overlay then
		self._result_overlay = nil

		self:_remove_element("result_overlay")
	end

	if self._wintrack_reward_items then
		table.remove(self._wintrack_reward_items, 1)

		if #self._wintrack_reward_items == 0 then
			if self._wintrack_reward_claimed_callback then
				self._wintrack_reward_claimed_callback()

				self._wintrack_reward_claimed_callback = nil
			end
		else
			self._present_reward_overlay = true
		end
	end

	if self._carousel_claimed_callback then
		self._carousel_claimed_callback()

		self._carousel_claimed_callback = nil
	end

	if self._penance_claimed_callback then
		self._penance_claimed_callback()

		self._penance_claimed_callback = nil
	end
end

PenanceOverviewView._is_result_presentation_active = function (self)
	if self._result_overlay then
		return true
	end

	return false
end

PenanceOverviewView._draw_progress_bar_for_achievement = function (self, achievement_definition, is_complete)
	local achievement_type_name = achievement_definition.type
	local achievement_type = AchievementTypes[achievement_type_name]
	local has_progress_bar = achievement_type.get_progress ~= nil
	local ignore_progress_bar = achievement_definition.flags[AchievementFlags.hide_progress] or is_complete

	return has_progress_bar and not ignore_progress_bar
end

PenanceOverviewView._can_claim_achievement_by_id = function (self, achievement_id)
	local can_claim = self._penance_to_reward_bundle_map[achievement_id] ~= nil

	return can_claim
end

PenanceOverviewView._get_achievement_bar_progress = function (self, achievement_definition)
	local player = self:_player()
	local achievement_type_name = achievement_definition.type
	local achievement_type = AchievementTypes[achievement_type_name]
	local progress, goal = achievement_type.get_progress(achievement_definition, player)

	progress = math.min(progress, goal)

	local fraction = progress / goal

	return fraction, progress, goal
end

PenanceOverviewView._get_penance_layout_entry_by_achievement_id = function (self, achievement_id)
	local player = self:_player()
	local achievement = AchievementUIHelper.achievement_definition_by_id(achievement_id)
	local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
	local achievement_family_order = AchievementUIHelper.get_achievement_family_order(achievement_definition)
	local is_currently_favorited = self:is_favorite_achievement(achievement_id)
	local can_claim = self:_can_claim_achievement_by_id(achievement_id)
	local is_complete = not can_claim and Managers.achievements:achievement_completed(player, achievement_id)
	local draw_progress_bar = self:_draw_progress_bar_for_achievement(achievement_definition, is_complete)
	local bar_progress, progress, goal

	if draw_progress_bar then
		bar_progress, progress, goal = self:_get_achievement_bar_progress(achievement_definition)
	end

	local title = AchievementUIHelper.localized_title(achievement_definition)
	local separate_private_discription = true
	local description = AchievementUIHelper.localized_description(achievement_definition, separate_private_discription)
	local progress_text = progress and (progress > 0 and TextUtilities.apply_color_to_text(tostring(progress), Color.ui_achievement_icon_completed(255, true)) or tostring(progress))
	local bar_values_text = progress_text and progress_text .. "/" .. tostring(goal)
	local reward_item, item_group = AchievementUIHelper.get_reward_item(achievement_definition)
	local reward_type_icon = reward_item and ItemUtils.type_texture(reward_item)
	local achievement_score = achievement.score or 0
	local widget_type = self._use_large_penance_entries and "penance_large" or "penance"

	return {
		widget_type = widget_type,
		texture = achievement.icon,
		item = reward_item,
		reward_icon = reward_type_icon,
		achievement_score = achievement_score,
		title = title,
		description = description,
		completed = is_complete,
		tracked = is_currently_favorited,
		bar_progress = bar_progress,
		bar_values_text = bar_values_text,
		can_claim = can_claim,
		achievement_id = achievement_id,
		family_index = achievement_family_order,
	}
end

PenanceOverviewView.on_category_button_pressed = function (self, index, option, force_selection)
	if index == self._selected_option_button_index and not force_selection then
		return
	end

	local category_id = option.category_id
	local display_name = option.display_name

	self:_set_title(display_name)

	local achievements_by_category = self._use_large_penance_entries and self._achievements_by_category or self._achievements_by_category_unsorted
	local grid_scenegraph_id = "penance_grid"
	local grid_size = self:_get_scenegraph_size(grid_scenegraph_id)
	local layout = {}

	if category_id then
		local achievements = achievements_by_category[category_id]

		if achievements then
			if #achievements > 0 then
				layout[#layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						10,
					},
				}
			end

			for i = 1, #achievements do
				local achievement_id = achievements[i]

				layout[#layout + 1] = self:_get_penance_layout_entry_by_achievement_id(achievement_id)
			end
		end

		local child_categories = option.child_categories

		if child_categories then
			for i = 1, #child_categories do
				local child_category_id = child_categories[i]
				local child_achievements = achievements_by_category[child_category_id]
				local child_category = AchievementCategories[child_category_id]

				if child_achievements then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							grid_size[1],
							10,
						},
					}
					layout[#layout + 1] = {
						widget_type = "header",
						text = Localize(child_category.display_name),
					}

					for j = 1, #child_achievements do
						local child_achievement_id = child_achievements[j]

						layout[#layout + 1] = self:_get_penance_layout_entry_by_achievement_id(child_achievement_id)
					end

					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							grid_size[1],
							10,
						},
					}
				end
			end
		end

		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10,
			},
		}
	end

	self:_setup_penance_grid(layout, display_name)

	self._selected_option_button_index = index

	self._categories_tab_bar:set_selected_index(index)

	if not self._using_cursor_navigation then
		self:_play_sound(UISoundEvents.tab_secondary_button_pressed)
	end
end

PenanceOverviewView.ui_renderer = function (self)
	return self._ui_renderer
end

PenanceOverviewView._create_carousel_entry = function (self, layout)
	local scenegraph_id = "carousel_card"
	local grid_size = self:_get_scenegraph_size(scenegraph_id)
	local mask_padding_size = 40
	local grid_settings = {
		enable_gamepad_scrolling = false,
		hide_background = false,
		hide_dividers = false,
		ignore_divider_height = true,
		no_resource_rendering = true,
		resource_renderer_background = true,
		scrollbar_horizontal_offset = 5,
		scrollbar_width = 7,
		title_height = 0,
		use_solid_terminal_background = true,
		widget_icon_load_margin = 0,
		grid_spacing = {
			0,
			0,
		},
		grid_size = grid_size,
		mask_size = {
			grid_size[1] + mask_padding_size,
			grid_size[2] + mask_padding_size,
		},
	}
	local layer = 10
	local scale = self._ui_renderer.scale or RESOLUTION_LOOKUP.scale
	local grid = ViewElementGrid:new(self, layer, scale, grid_settings)

	grid:set_render_scale(self._render_scale)
	self:_update_element_position(scenegraph_id, grid)
	grid:set_empty_message("")
	grid:present_grid_layout(layout, PenanceOverviewViewDefinitions.grid_blueprints)
	grid:set_handle_grid_navigation(true)

	local top_divider_material = "content/ui/materials/frames/achievements/card_upper"
	local top_divider_size = {
		grid_size[1] + 12,
		22,
	}
	local top_divider_position = {
		0,
		2,
		10,
	}
	local bottom_divider_material = "content/ui/materials/frames/achievements/card_lower"
	local bottom_divider_size = {
		grid_size[1] + 12,
		24,
	}
	local bottom_divider_position = {
		0,
		1,
		10,
	}

	grid:update_dividers(top_divider_material, top_divider_size, top_divider_position, bottom_divider_material, bottom_divider_size, bottom_divider_position)

	return {
		grid = grid,
		achievement_id = layout.achievement_id,
		layout = layout,
	}
end

PenanceOverviewView._setup_carousel_entries = function (self, achievement_layouts, ui_renderer)
	local carousel_entries = self._carousel_entries

	if carousel_entries then
		for i = 1, #carousel_entries do
			local grid = carousel_entries[i].grid

			grid:destroy()
		end

		self._carousel_entries = nil
	end

	carousel_entries = {}

	if not self._carousel_entries then
		for i = 1, #achievement_layouts do
			local layout = achievement_layouts[i]

			carousel_entries[#carousel_entries + 1] = self:_create_carousel_entry(layout)
		end

		self._carousel_entries = carousel_entries
	end

	self._carousel_current_progress = nil
	self._carousel_target_progress = nil
	self._carousel_start_progress = nil
	self._current_carousel_index = nil

	local animate = false

	self:_set_carousel_index(1, animate)
end

PenanceOverviewView._on_carousel_card_pressed = function (self, index, entry)
	local achievement_id = entry.achievement_id
	local reward_bundle = self._penance_to_reward_bundle_map[achievement_id]

	self._carousel_claimed_callback = function ()
		local grid = entry.grid
		local widgets = grid:widgets()

		self:request_achievement_favorite_remove(entry.achievement_id)

		for i = 1, #widgets do
			widgets[i].content.can_claim = false
			widgets[i].content.completed = true
			widgets[i].content.tracked = false
		end

		if self._penance_grid then
			local option = self._category_button_config[self._selected_option_button_index]

			self:on_category_button_pressed(self._selected_option_button_index, option, true)
		end

		local additional_widgets = {
			divider_top = grid._widgets_by_name.grid_divider_top,
			divider_bottom = grid._widgets_by_name.grid_divider_bottom,
			background = grid._widgets_by_name.grid_background,
		}
		local start_height = grid:grid_height()
		local start_pivot_offset = grid._pivot_offset[2]

		self._claim_animation_id = self:_start_animation("on_carousel_claimed", widgets, {
			parent = self,
			additional_widgets = additional_widgets,
			grid = grid,
			start_height = start_height,
			start_pivot_offset = start_pivot_offset,
		})
		self._destroyed_carousel_index = index
	end

	if reward_bundle then
		self:_claim_penance(reward_bundle)

		return true
	else
		self._carousel_claimed_callback()

		self._carousel_claimed_callback = nil

		return true
	end
end

PenanceOverviewView._on_carousel_card_secondary_pressed = function (self, index, entry)
	local achievement_id = entry.achievement_id
	local player = self:_player()
	local is_currently_favorited = self:is_favorite_achievement(achievement_id)
	local is_complete = Managers.achievements:achievement_completed(player, achievement_id)
	local can_claim = self:_can_claim_achievement_by_id(achievement_id)
	local is_favorited

	if not is_currently_favorited and not is_complete and not can_claim then
		is_favorited = self:request_achievement_favorite_add(achievement_id)

		self:_play_sound(UISoundEvents.penance_menu_penance_track)
	elseif self:request_achievement_favorite_remove(achievement_id) then
		is_favorited = false

		self:_play_sound(UISoundEvents.penance_menu_penance_untrack)
	end

	local grid = entry.grid
	local widgets = grid:widgets()

	for i = 1, #widgets do
		widgets[i].content.tracked = is_favorited
	end
end

PenanceOverviewView._setup_penance_category_buttons = function (self, options)
	local category_count = #options
	local button_size = {
		70,
		60,
	}
	local button_spacing = 4
	local settings = {
		grow_vertically = false,
		horizontal_alignment = "center",
		vertical_alignment = "top",
		button_size = button_size,
		button_spacing = button_spacing,
		input_label_offset = {
			25,
			15,
		},
	}
	local categories_tab_bar = self:_add_element(ViewElementTabMenu, "categories_tab_bar", 40, settings)

	self._num_unclaimed_penances_per_category = {}

	local button_template = {
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			style_id = "hotspot",
			content = {
				on_pressed_sound = UISoundEvents.tab_secondary_button_pressed,
				on_hover_sound = UISoundEvents.default_mouse_hover,
			},
			style = {
				anim_focus_speed = 8,
				anim_hover_speed = 8,
				anim_input_speed = 8,
				anim_select_speed = 8,
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				default_color = Color.terminal_background(nil, true),
				selected_color = Color.terminal_background_selected(nil, true),
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = Color.ui_grey_medium(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
			change_function = function (content, style)
				ButtonPassTemplates.terminal_button_change_function(content, style)
				ButtonPassTemplates.terminal_button_hover_change_function(content, style)
			end,
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(200, true),
				size_addition = {
					20,
					20,
				},
				offset = {
					0,
					0,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				disabled_color = Color.ui_grey_medium(255, true),
				offset = {
					0,
					0,
					2,
				},
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "text_bg",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				color = Color.black(150, true),
				size = {
					button_size[1] - 2,
					18,
				},
				offset = {
					0,
					-1,
					8,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text_counter",
			value = "0/0",
			value_id = "text_counter",
			style = {
				font_size = 16,
				font_type = "proxima_nova_bold",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					9,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				default_color = Color.terminal_text_header(255, true),
				disabled_color = Color.gray(255, true),
				color = Color.terminal_text_header(255, true),
				hover_color = Color.terminal_text_header_selected(255, true),
				size = {
					72,
					52,
				},
				original_size_addition = {
					-10,
					-10,
				},
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					-6,
					6,
				},
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local progress = math.max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
				local size_addition = 2 * math.easeInCubic(progress)
				local style_size_addition = style.size_addition
				local original_size_addition = style.original_size_addition

				style_size_addition[1] = original_size_addition[1] + size_addition * 2
				style_size_addition[2] = original_size_addition[1] + size_addition * 2

				ButtonPassTemplates.list_button_label_change_function(content, style)
			end,
		},
		{
			pass_type = "texture",
			style_id = "new_indicator",
			value = "content/ui/materials/symbols/new_item_indicator",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					90,
					90,
				},
				offset = {
					23,
					-5,
					4,
				},
				color = Color.terminal_corner_selected(255, true),
			},
			visibility_function = function (content, style)
				return content.has_unclaimed_penances
			end,
		},
	}
	local category_button = table.clone(button_template)

	category_button[1].style = {
		on_pressed_sound = UISoundEvents.tab_secondary_button_pressed,
	}

	for i = 1, category_count do
		local option = options[i]
		local score_progress
		local category_id = option.category_id
		local score, completed_score = self:_category_score(category_id)

		if score and score > 0 then
			score_progress = completed_score / score
		end

		local update_function = callback(self, "cb_category_tab_option_update")
		local display_name = option.display_name
		local pressed_callback = callback(self, "on_category_button_pressed", i, option)
		local entry_id = categories_tab_bar:add_entry(display_name, pressed_callback, category_button, option.icon, update_function)
		local entry_content = categories_tab_bar:content_by_id(entry_id)

		if score_progress then
			entry_content.score_progress = score_progress
		end

		local num_total_achievements, num_total_achievements_completed, num_unclaimed_achievements = self:_get_category_option_penance_amount(option)

		if not self._num_unclaimed_penances_per_category[category_id] then
			self._num_unclaimed_penances_per_category[category_id] = num_unclaimed_achievements
		end

		entry_content.text_counter = num_total_achievements_completed .. "/" .. num_total_achievements
		entry_content.has_unclaimed_penances = num_unclaimed_achievements > 0
		self._widget_content_by_category[category_id] = entry_content
	end

	local input_action_left = "navigate_secondary_left_pressed"
	local input_action_right = "navigate_secondary_right_pressed"

	categories_tab_bar:set_input_actions(input_action_left, input_action_right)
	categories_tab_bar:set_is_handling_navigation_input(false)

	self._categories_tab_bar = categories_tab_bar

	self:on_category_button_pressed(1, options[1], true)
	self:_update_categories_tab_bar_position()

	self._penance_category_options = options
	self._widgets_by_name.page_header.style.top_bar.size[1] = 36 + category_count * (button_size[1] + button_spacing) + button_spacing
end

PenanceOverviewView._get_category_option_penance_amount = function (self, option)
	local player = self:_player()
	local achievement_manager = Managers.achievements
	local achievements_by_category = self._achievements_by_category
	local category_id = option.category_id
	local achievements = achievements_by_category[category_id]
	local num_total_achievements = achievements and #achievements or 0
	local num_total_achievements_completed = 0
	local num_total_unclaimed_achievements = 0

	if achievements then
		for i = 1, #achievements do
			local achievement_id = achievements[i]

			if achievement_manager:achievement_completed(player, achievement_id) then
				num_total_achievements_completed = num_total_achievements_completed + 1
			end

			local has_unclaimed_penance_in_category = self._penance_to_reward_bundle_map[achievement_id] ~= nil

			if has_unclaimed_penance_in_category then
				num_total_unclaimed_achievements = num_total_unclaimed_achievements + 1
				self._category_by_achievement[achievement_id] = category_id
			end
		end
	end

	local child_categories = option.child_categories

	if child_categories then
		for i = 1, #child_categories do
			local child_category_id = child_categories[i]
			local child_achievements = achievements_by_category[child_category_id]

			if child_achievements then
				num_total_achievements = num_total_achievements + #child_achievements

				for j = 1, #child_achievements do
					local child_achievement_id = child_achievements[j]

					if achievement_manager:achievement_completed(player, child_achievement_id) then
						num_total_achievements_completed = num_total_achievements_completed + 1
					end

					local has_unclaimed_penance_in_category = self._penance_to_reward_bundle_map[child_achievement_id] ~= nil

					if has_unclaimed_penance_in_category then
						num_total_unclaimed_achievements = num_total_unclaimed_achievements + 1
						self._category_by_achievement[child_achievement_id] = category_id
					end
				end
			end
		end
	end

	return num_total_achievements, num_total_achievements_completed, num_total_unclaimed_achievements
end

PenanceOverviewView.cb_category_tab_option_update = function (self, content, style)
	local score_progress = content.score_progress

	if score_progress then
		-- Nothing
	end
end

PenanceOverviewView._carousel_grid_on_resolution_modified = function (self, scale)
	local carousel_entries = self._carousel_entries

	if not carousel_entries then
		return
	end

	for i = 1, #carousel_entries do
		local entry = carousel_entries[i]
		local grid = entry.grid

		grid:on_resolution_modified(scale)
	end
end

PenanceOverviewView._update_categories_tab_bar_position = function (self)
	if not self._categories_tab_bar then
		return
	end

	local position = self:_scenegraph_world_position("page_category_pivot")

	self._categories_tab_bar:set_pivot_offset(position[1], position[2])
end

PenanceOverviewView._category_score = function (self, category_id)
	local score_by_category = self._score_by_category
	local completed_score_by_category = self._completed_score_by_category
	local score = score_by_category[category_id] or 0
	local completed_score = completed_score_by_category[category_id] or 0
	local sub_categories = self._sub_categories[category_id]
	local sub_category_count = sub_categories and #sub_categories or 0

	for i = 1, sub_category_count do
		local sub_category_id = sub_categories[i]
		local sub_category_score, sub_category_completed_score = self:_category_score(sub_category_id)

		score = score + sub_category_score
		completed_score = completed_score + sub_category_completed_score
	end

	return score, completed_score
end

PenanceOverviewView._present_achievement_tooltip = function (self, achievement_id)
	self._presented_achievement_id_tooltip = achievement_id

	local player = self:_player()
	local achievement = AchievementUIHelper.achievement_definition_by_id(achievement_id)
	local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
	local can_claim = self:_can_claim_achievement_by_id(achievement_id)
	local is_complete = not can_claim and Managers.achievements:achievement_completed(player, achievement_id)
	local draw_progress_bar = self:_draw_progress_bar_for_achievement(achievement_definition, is_complete)
	local layout = {}
	local grid_scenegraph_id = "tooltip_grid"
	local grid_size = self:_get_scenegraph_size(grid_scenegraph_id)

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			20,
		},
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1] - 140,
			0,
		},
	}
	layout[#layout + 1] = {
		widget_type = "tooltip_penance",
		texture = achievement.icon,
		completed = is_complete,
		can_claim = can_claim,
	}

	local title = AchievementUIHelper.localized_title(achievement_definition)

	if title then
		layout[#layout + 1] = {
			widget_type = "tooltip_header",
			text = title,
		}
	end

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10,
		},
	}

	if draw_progress_bar then
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				30,
			},
		}

		local bar_progress, progress, goal = self:_get_achievement_bar_progress(achievement_definition)

		layout[#layout + 1] = {
			widget_type = "tooltip_progress_bar",
			text = tostring(progress) .. "/" .. tostring(goal),
			progress = bar_progress,
		}
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10,
			},
		}
	end

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10,
		},
	}

	local description = AchievementUIHelper.localized_description(achievement_definition)

	if description then
		layout[#layout + 1] = {
			widget_type = "tooltip_body",
			text = description,
		}
	end

	local stats = achievement_definition.stats
	local stats_sorting = achievement_definition.stats_sorting

	if stats then
		local player_id = player.remote and player.stat_id or player:local_player_id()

		for stat_name, stat_settings in _stats_sort_iterator(stats, stats_sorting) do
			local target = stat_settings.target
			local value = math.min(Managers.stats:read_user_stat(player_id, stat_name), target)
			local progress = _format_progress(value, target)
			local loc_stat_name = string.format("• %s", Localize(StatDefinitions[stat_name].stat_name or "unknown"))

			layout[#layout + 1] = {
				widget_type = "tooltip_stat",
				text = loc_stat_name,
				value = progress,
			}
		end
	end

	local reward_item, item_group = AchievementUIHelper.get_reward_item(achievement_definition)

	if reward_item then
		layout[#layout + 1] = {
			text = "Rewards:",
			widget_type = "tooltip_header",
			size = {
				grid_size[1],
			},
		}
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				10,
			},
		}
		layout[#layout + 1] = {
			widget_type = "tooltip_reward_item",
			item = reward_item,
			item_group = item_group,
		}
	end

	local is_tooltip = true
	local tooltip_layout = self:_get_achievement_card_layout(achievement_id, is_tooltip)

	self:_setup_tooltip_grid(tooltip_layout)
	self._penance_tooltip_grid:set_visibility(true)

	self._penance_tooltip_visible = true
end

PenanceOverviewView._setup_top_panel = function (self)
	local reference_name = "top_panel"
	local layer = 60

	self._top_panel = self:_add_element(ViewElementMenuPanel, reference_name, layer)
	self._panel_options = {
		{
			display_name = "loc_penance_menu_panel_option_highlights",
			key = "carousel",
			update = function (content, style, dt)
				content.hotspot.disabled = false

				local has_new_items = false

				content.show_alert = has_new_items
			end,
		},
		{
			display_name = "loc_penance_menu_panel_option_browser",
			key = "browser",
			update = function (content, style, dt)
				content.hotspot.disabled = false

				local has_new_items = false

				content.show_alert = has_new_items
			end,
		},
	}

	local panel_options = self._panel_options

	for i = 1, #panel_options do
		local settings = panel_options[i]
		local key = settings.key
		local display_name_loc_key = settings.display_name

		local function entry_callback_function()
			self:_on_panel_option_pressed(i)
		end

		local optional_update_function = settings.update
		local cb = callback(entry_callback_function)

		self._top_panel:add_entry(Localize(display_name_loc_key), cb, optional_update_function)
	end

	self._top_panel:set_is_handling_navigation_input(true)
end

PenanceOverviewView._on_panel_option_pressed = function (self, index)
	local old_top_panel_selection_index = self._top_panel:selected_index()

	if index == old_top_panel_selection_index then
		return
	end

	local panel_options = self._panel_options
	local option = panel_options[index]
	local key = option.key

	self._selected_top_option_key = key

	if key == "carousel" then
		if self._refresh_carousel_entries then
			local carousel_achievement_layouts = self:_get_carousel_layouts()

			self:_setup_carousel_entries(carousel_achievement_layouts, self._ui_renderer)

			self._refresh_carousel_entries = nil
		end

		self._draw_carousel = true
		self._penance_tooltip_visible = false

		if self._penance_tooltip_grid then
			self._penance_tooltip_grid:set_visibility(false)
		end

		if self._penance_grid then
			self._penance_grid:set_visibility(false)
		end

		if self._categories_tab_bar then
			self._categories_tab_bar:set_visibility(false)
		end

		self._widgets_by_name.page_header.content.visible = false

		self._categories_tab_bar:set_is_handling_navigation_input(false)
	elseif key == "browser" then
		self._draw_carousel = false
		self._carousel_current_progress = self._carousel_target_progress

		if self._penance_tooltip_grid then
			self._penance_tooltip_grid:set_visibility(true)
		end

		if self._penance_grid then
			self._penance_grid:set_visibility(true)
		end

		if self._categories_tab_bar then
			self._categories_tab_bar:set_visibility(true)
		end

		self._widgets_by_name.page_header.content.visible = true

		for i = 1, #self._carousel_entries do
			local entry = self._carousel_entries[i]
			local grid = entry.grid

			grid:set_alpha_multiplier(0)
		end

		self._categories_tab_bar:set_is_handling_navigation_input(true)
	end
end

PenanceOverviewView._force_select_panel_index = function (self, index)
	self:_on_panel_option_pressed(index)
	self._top_panel:set_selected_panel_index(index)
end

PenanceOverviewView.cb_on_switch_focus = function (self)
	if not self._using_cursor_navigation and self._wintrack_element then
		self._wintracks_focused = not self._wintracks_focused

		if self._wintracks_focused then
			self._wintrack_element:apply_focus_on_reward()
		else
			self._wintrack_element:remove_focus_on_reward()
		end
	end
end

PenanceOverviewView._cb_favorite_legend_visibility = function (self, add_to_favorite)
	local using_cursor_navigation = self._using_cursor_navigation
	local currently_tracked, can_track = AchievementUIHelper.favorite_achievement_count()

	if add_to_favorite and can_track <= currently_tracked then
		return false
	end

	local is_favorite
	local can_change = true
	local player = self:_player()

	if self._selected_top_option_key == "carousel" and not self._wintracks_focused then
		if self._draw_carousel == true and self._hovered_carousel_card_index then
			local carousel = self._carousel_entries[self._hovered_carousel_card_index]
			local grid = carousel and carousel.grid
			local widgets = grid:widgets()

			is_favorite = widgets[1].content.tracked

			local achievement_id = carousel.achievement_id
			local can_claim = self:_can_claim_achievement_by_id(achievement_id)
			local is_complete = Managers.achievements:achievement_completed(player, achievement_id)

			can_change = not is_complete and not can_claim
		end
	elseif self._selected_top_option_key == "browser" and not self._wintracks_focused then
		local index

		if using_cursor_navigation then
			index = self._penance_grid:hovered_grid_index()
		else
			index = self._penance_grid:selected_grid_index()
		end

		local widget = self._penance_grid:widget_by_index(index)

		is_favorite = widget and widget.content.tracked

		local achievement_id = widget and widget.content.element.achievement_id

		if achievement_id then
			local can_claim = self:_can_claim_achievement_by_id(achievement_id)
			local is_complete = not can_claim and Managers.achievements:achievement_completed(player, achievement_id)

			can_change = not is_complete and not can_claim
		end
	end

	return is_favorite ~= nil and is_favorite ~= add_to_favorite and can_change
end

PenanceOverviewView._on_favorite_pressed = function (self)
	if self._selected_top_option_key == "carousel" then
		local index = self._hovered_carousel_card_index
		local entry = self._carousel_entries[index]

		if entry then
			self:_on_carousel_card_secondary_pressed(index, entry)

			if self._penance_grid then
				local option = self._category_button_config[self._selected_option_button_index]

				self:on_category_button_pressed(self._selected_option_button_index, option, true)
			end
		end
	elseif self._selected_top_option_key == "browser" then
		local widget

		if self._using_cursor_navigation then
			widget = self._penance_grid:hovered_widget()
		else
			local index = self._penance_grid:selected_grid_index()

			widget = self._penance_grid:widget_by_index(index)
		end

		if widget then
			local config = widget.element

			self:_cb_on_penance_secondary_pressed(widget, config)
		end
	end
end

PenanceOverviewView._on_navigation_input_changed = function (self)
	PenanceOverviewView.super._on_navigation_input_changed(self)

	local setup_track_data_done = self._setup_track_data_done

	if not setup_track_data_done then
		return
	end

	if not self._using_cursor_navigation then
		self:_focus_on_card(self._current_carousel_index)
	else
		self:_focus_on_card()
	end

	if self._wintrack_element then
		self._wintrack_element:remove_focus_on_reward()

		self._wintracks_focused = false
	end
end

PenanceOverviewView._update_vo = function (self, dt, t)
	if self._hub_interaction then
		local queued_vo_event_request = self._queued_vo_event_request

		if queued_vo_event_request then
			local delay = queued_vo_event_request.delay

			if delay <= 0 then
				local events = queued_vo_event_request.events
				local voice_profile = queued_vo_event_request.voice_profile
				local optional_route_key = queued_vo_event_request.optional_route_key
				local is_opinion_vo = queued_vo_event_request.is_opinion_vo
				local world_spawner = self._world_spawner
				local dialogue_system = world_spawner and self:dialogue_system()

				if dialogue_system then
					self:play_vo_events(events, voice_profile, optional_route_key, nil, is_opinion_vo)

					self._queued_vo_event_request = nil
				else
					self._queued_vo_event_request = nil
				end
			else
				queued_vo_event_request.delay = delay - dt
			end
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
end

PenanceOverviewView.dialogue_system = function (self)
	local world_spawner = self._world_spawner
	local world = world_spawner and world_spawner:world()
	local extension_manager = world and Managers.ui:world_extension_manager(world)
	local dialogue_system = extension_manager and extension_manager:system_by_extension("DialogueExtension")

	return dialogue_system
end

PenanceOverviewView._cb_on_play_vo = function (self, id, event_name)
	self._current_vo_event = event_name
	self._current_vo_id = id
end

PenanceOverviewView.play_vo_events = function (self, events, voice_profile, optional_route_key, optional_delay, is_opinion_vo)
	local dialogue_system = self:dialogue_system()

	if optional_delay then
		self._queued_vo_event_request = {
			events = events,
			voice_profile = voice_profile,
			optional_route_key = optional_route_key,
			delay = optional_delay,
			is_opinion_vo = is_opinion_vo,
		}
	else
		local wwise_route_key = optional_route_key or 40
		local callback = self._vo_callback
		local vo_unit = Vo.play_local_vo_events(dialogue_system, events, voice_profile, wwise_route_key, callback, nil, is_opinion_vo)

		self._vo_unit = vo_unit
	end
end

return PenanceOverviewView
