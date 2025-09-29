-- chunkname: @scripts/ui/views/penance_overview_view/penance_overview_view.lua

local PenanceOverviewViewDefinitions = require("scripts/ui/views/penance_overview_view/penance_overview_view_definitions")
local PenanceOverviewViewSettings = require("scripts/ui/views/penance_overview_view/penance_overview_view_settings")
local AchievementCategories = require("scripts/settings/achievements/achievement_categories")
local AchievementFlags = require("scripts/settings/achievements/achievement_flags")
local AchievementTypes = require("scripts/managers/achievements/achievement_types")
local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local Breeds = require("scripts/settings/breed/breeds")
local InputUtils = require("scripts/managers/input/input_utils")
local ItemUtils = require("scripts/utilities/items")
local LoadingStateData = require("scripts/ui/loading_state_data")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local StatDefinitions = require("scripts/managers/stats/stat_definitions")
local TextUtilities = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementItemResultOverlay = require("scripts/ui/view_elements/view_element_item_result_overlay/view_element_item_result_overlay")
local ViewElementLoadingOverlay = require("scripts/ui/view_elements/view_element_loading_overlay/view_element_loading_overlay")
local ViewElementMenuPanel = require("scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local ViewElementWintrack = require("scripts/ui/view_elements/view_element_wintrack/view_element_wintrack")
local ViewElementWintrackItemRewardOverlay = require("scripts/ui/view_elements/view_element_wintrack_item_reward_overlay/view_element_wintrack_item_reward_overlay")
local Vo = require("scripts/utilities/vo")

local function _stats_sort_iterator(stats, stats_sorting)
	local sort_table = stats_sorting or table.keys(stats)
	local ii = 0

	return function ()
		ii = ii + 1

		return sort_table[ii], stats[sort_table[ii]]
	end
end

local RESULT_TYPES = table.enum("wintrack", "penance")
local PENANCE_TRACK_ID = "dec942ce-b6ba-439c-95e2-022c5d71394d"
local PenanceOverviewView = class("PenanceOverviewView", "BaseView")

PenanceOverviewView.init = function (self, settings, context)
	self._legend_input_ids = nil
	self._achievements = nil
	self._categories = nil
	self._wintracks_focused = false
	self._result_overlay_queue = {}
	self._achievements_by_category = {}
	self._widget_content_by_category = {}
	self._promise_container = PromiseContainer:new()
	self.animation_alpha_multiplier = 0
	self._global_alpha_multiplier = 1
	self._anim_wintrack_reward_hover_progress = 0
	self._total_score = 0
	self._visual_score = 0
	self._target_score = 0
	self._is_claiming_rewards = false

	local save_manager = Managers.save

	if save_manager then
		local account_data = save_manager:account_data()

		self._use_large_penance_entries = not not account_data.interface_settings.penance_list_setting_show_list_view
		self._penance_category_index = account_data.interface_settings.penance_category_index
	end

	PenanceOverviewView.super.init(self, PenanceOverviewViewDefinitions, settings, context)

	self._pass_input = false
	self._pass_draw = false
	self._allow_close_hotkey = true

	self:_setup_penance_filter_options()

	self._current_vo_event = nil
	self._current_vo_id = nil
	self._vo_unit = nil
	self._vo_callback = callback(self, "_cb_on_play_vo")
	self._vo_world_spawner = nil
	self._hub_interaction = context and context.hub_interaction

	local promises = {}

	promises[#promises + 1] = self._promise_container:cancel_on_destroy(Managers.data_service.account:has_migrated_commendation_score()):next(callback(self, "_on_migration_check_success"))
	promises[#promises + 1] = self._promise_container:cancel_on_destroy(Managers.backend.interfaces.player_rewards:get_penance_rewards_by_source()):next(callback(self, "_on_penance_reward_check_success"), callback(self, "_on_penance_reward_check_error"))
	promises[#promises + 1] = self._promise_container:cancel_on_destroy(Managers.data_service.penance_track:get_track(PENANCE_TRACK_ID)):next(callback(self, "_on_penance_track_fetched_success"))

	Promise.all(unpack(promises)):next(callback(self, "_fetch_track_state")):next(callback(self, "_on_backend_success")):catch(callback(self, "_on_backend_error"))
end

PenanceOverviewView._on_backend_error = function (self, error)
	local view_name = self.view_name

	Managers.ui:close_view(view_name)
end

PenanceOverviewView._on_migration_check_success = function (self, value)
	if not value then
		local player = self:_player()
		local account_id = player:account_id()

		return self._promise_container:cancel_on_destroy(Managers.backend.interfaces.commendations:init_commendation_score(account_id))
	end
end

PenanceOverviewView._on_penance_reward_check_success = function (self, rewards)
	self._penance_to_reward_bundle_map = {}

	for i = 1, #rewards do
		local reward = rewards[i]

		self._penance_to_reward_bundle_map[reward.penance_id] = reward.reward_bundle
	end
end

PenanceOverviewView._on_penance_reward_check_error = function (self, error)
	Log.warning("PenanceOverviewView", "Error during penance reward check: %s. Not showing rewards.", tostring(error))

	return self:_on_penance_reward_check_success({})
end

PenanceOverviewView._on_penance_track_fetched_success = function (self, track_data)
	self._track_data = track_data
end

PenanceOverviewView._fetch_track_state = function (self)
	return self._promise_container:cancel_on_destroy(Managers.backend.interfaces.tracks:get_track_state(PENANCE_TRACK_ID)):next(function (track_state)
		self._account_state_data = track_state
	end)
end

PenanceOverviewView._on_backend_success = function (self)
	self._backend_ready = true
end

PenanceOverviewView.on_enter = function (self)
	PenanceOverviewView.super.on_enter(self)
	self:_setup_input_legend()
	self:_add_element(ViewElementLoadingOverlay, "loading_overlay", 200)

	if PenanceOverviewViewSettings.background_world_params then
		self:_setup_background_world(PenanceOverviewViewSettings.background_world_params)
	end

	local rumour_line = math.random() > 0.9
	local vo_events = {
		rumour_line and "hub_interact_boon_vendor_rumour_politics_a" or "hub_interact_penance_greeting_a",
	}

	self:play_vo_events(vo_events, "boon_vendor_a", nil, 0.8)
	self:_register_event("event_request_achievement_favorite_add", "request_achievement_favorite_add")
	self:_register_event("event_request_achievement_favorite_remove", "request_achievement_favorite_remove")
	Managers.telemetry_reporters:start_reporter("penance_view")
end

PenanceOverviewView._finish_setup = function (self)
	self._initialized = true

	self:_setup_achievements()

	local track_data = self._track_data

	self:_setup_track_data(track_data)

	local account_state_data = self._account_state_data

	self:_setup_account_state_data(account_state_data)
	self:_setup_top_panel()

	self._enter_animation_id = self:_start_animation("on_enter")
end

PenanceOverviewView._change_category_config_value = function (self, achievement_id, value_name, delta)
	local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
	local category_id = achievement_definition.category
	local parent_id = self._category_to_parent[category_id]
	local parent_config = self._category_button_config_by_id[parent_id]

	parent_config[value_name] = parent_config[value_name] + delta

	return parent_id, parent_config[value_name]
end

PenanceOverviewView.request_achievement_favorite_add = function (self, achievement_id)
	local added = AchievementUIHelper.add_favorite_achievement(achievement_id, false)

	if added then
		Managers.telemetry_reporters:reporter("penance_view"):register_tracking_event(achievement_id, true)

		local parent_id, favorite_count = self:_change_category_config_value(achievement_id, "favorite_count", 1)
		local content = self._widget_content_by_category[parent_id]

		if content then
			content.has_favorite_penances = favorite_count > 0
		end
	end

	return added
end

PenanceOverviewView.request_achievement_favorite_remove = function (self, achievement_id)
	local removed = AchievementUIHelper.remove_favorite_achievement(achievement_id, false)

	if removed then
		Managers.telemetry_reporters:reporter("penance_view"):register_tracking_event(achievement_id, false)

		local parent_id, favorite_count = self:_change_category_config_value(achievement_id, "favorite_count", -1)
		local content = self._widget_content_by_category[parent_id]

		if content then
			content.has_favorite_penances = favorite_count > 0
		end
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

PenanceOverviewView.cb_on_close_pressed = function (self)
	local can_exit = self:can_exit()

	if not can_exit then
		return
	end

	local view_name = self.view_name

	Managers.ui:close_view(view_name)
end

PenanceOverviewView.cb_on_toggle_penance_appearance = function (self)
	self._use_large_penance_entries = not self._use_large_penance_entries

	local index = self._selected_option_button_index

	self:_select_category(index)
end

PenanceOverviewView._set_title = function (self, text)
	local widget = self._widgets_by_name.page_header

	widget.content.text = Localize(text)
end

PenanceOverviewView._build_top_category_to_parent_cache = function (self)
	local category_to_parent = {}

	for category_id, _ in pairs(AchievementCategories) do
		local parent_id = category_id

		while AchievementCategories[parent_id].parent_name do
			parent_id = AchievementCategories[parent_id].parent_name
		end

		category_to_parent[category_id] = parent_id
	end

	self._category_to_parent = category_to_parent
end

PenanceOverviewView._build_category_button_config = function (self)
	local categories_by_sort_index = table.keys(AchievementCategories)
	local category_to_parent = self._category_to_parent

	table.sort(categories_by_sort_index, function (a, b)
		local a_category = AchievementCategories[a]
		local b_category = AchievementCategories[b]

		return a_category.sort_index < b_category.sort_index
	end)

	local category_button_config = {}
	local category_button_config_by_id = {}

	for _, category_id in ipairs(categories_by_sort_index) do
		local category_config = AchievementCategories[category_id]
		local parent_name = category_to_parent[category_id]

		if parent_name == category_id then
			category_button_config[#category_button_config + 1] = {
				completed_count = 0,
				favorite_count = 0,
				total_count = 0,
				unclaimed_count = 0,
				category_id = category_id,
				display_name = category_config.display_name,
				icon = PenanceOverviewViewSettings.category_icons[category_id] or "content/ui/materials/icons/item_types/upper_bodies",
				child_categories = {},
			}
			category_button_config_by_id[category_id] = category_button_config[#category_button_config]
		end
	end

	for _, category_id in ipairs(categories_by_sort_index) do
		local parent_id = category_to_parent[category_id]

		if parent_id ~= category_id then
			local child_categories = category_button_config_by_id[parent_id].child_categories

			child_categories[#child_categories + 1] = category_id
		end
	end

	local player = self:_player()
	local achievement_manager = Managers.achievements
	local achievements_by_category = self._achievements_by_category

	for _, category_id in ipairs(categories_by_sort_index) do
		local parent_config = category_button_config_by_id[category_to_parent[category_id]]
		local category_achievements = achievements_by_category[category_id]
		local category_achievement_count = category_achievements and #category_achievements or 0

		parent_config.total_count = parent_config.total_count + category_achievement_count

		for i = 1, category_achievement_count do
			local achievement_id = category_achievements[i]

			if achievement_manager:achievement_completed(player, achievement_id) then
				parent_config.completed_count = parent_config.completed_count + 1
			end

			if self:_can_claim_achievement_by_id(achievement_id) then
				parent_config.unclaimed_count = parent_config.unclaimed_count + 1
			end

			if self:is_favorite_achievement(achievement_id) then
				parent_config.favorite_count = parent_config.favorite_count + 1
			end
		end
	end

	self._category_button_config = category_button_config
	self._category_button_config_by_id = category_button_config_by_id
end

PenanceOverviewView._build_achievements_cache = function (self)
	local player = self:_player()
	local total_score = 0
	local achievements_by_category = {}
	local achievements_by_recency = {}
	local achievements_by_progress = {}
	local achievement_definitions = Managers.achievements:achievement_definitions()

	for _, achievement_config in pairs(achievement_definitions) do
		local achievement_id = achievement_config.id
		local category = achievement_config.category
		local is_completed = Managers.achievements:achievement_completed(player, achievement_id)

		do
			local _achievements_by_category = achievements_by_category[category] or {}

			_achievements_by_category[#_achievements_by_category + 1] = achievement_id
			achievements_by_category[category] = _achievements_by_category
		end

		if not is_completed then
			achievements_by_progress[#achievements_by_progress + 1] = achievement_id
		end

		if is_completed then
			local achievement_score = achievement_config.score or 0

			total_score = total_score + achievement_score
			achievements_by_recency[#achievements_by_recency + 1] = achievement_id
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

	local function _sort_by_progress(a, b)
		local a_achievement_id = a
		local a_achievement = AchievementUIHelper.achievement_definition_by_id(a_achievement_id)
		local a_using_progress = self:_achievement_should_display_progress_bar(a_achievement)
		local a_bar_progress = a_using_progress and self:_get_achievement_bar_progress(a_achievement) or 0
		local b_achievement_id = b
		local b_achievement = AchievementUIHelper.achievement_definition_by_id(b_achievement_id)
		local b_using_progress = self:_achievement_should_display_progress_bar(b_achievement)
		local b_bar_progress = b_using_progress and self:_get_achievement_bar_progress(b_achievement) or 0

		return b_bar_progress < a_bar_progress
	end

	self._achievement_ids = table.keys(achievement_definitions)
	self._achievements_by_category = achievements_by_category
	self._achievements_by_recency = achievements_by_recency

	table.sort(achievements_by_recency, _sort_by_recency)

	self._achievements_by_progress = achievements_by_progress

	table.sort(achievements_by_progress, _sort_by_progress)
end

PenanceOverviewView._setup_achievements = function (self)
	self:_build_top_category_to_parent_cache()
	self:_build_achievements_cache()
	self:_build_category_button_config()
	self:_remove_completed_favorites()
end

local function is_meta_achievement(achievement_id)
	local achievement = AchievementUIHelper.achievement_definition_by_id(achievement_id)

	return achievement and achievement.type == "meta"
end

local function inversed_filter(f)
	return function (...)
		return not f(...)
	end
end

PenanceOverviewView._get_carousel_layouts = function (self, max_amount, blocked_ids)
	max_amount = math.min(max_amount or PenanceOverviewViewSettings.carousel_max_entries, PenanceOverviewViewSettings.carousel_max_entries)

	if max_amount == 0 then
		return {}
	end

	blocked_ids = blocked_ids or {}

	local player = self:_player()
	local favorite_achievements = Managers.save:account_data().favorite_achievements or {}
	local sources = {}

	sources[#sources + 1] = table.filter_array(favorite_achievements, callback(self, "_can_claim_achievement_by_id"))
	sources[#sources + 1] = table.filter_array(self._achievement_ids, callback(self, "_can_claim_achievement_by_id"))
	sources[#sources + 1] = favorite_achievements

	local archetype_name = player:archetype_name()
	local default_highlight_penances = PenanceOverviewViewSettings.default_highlight_penances[archetype_name]

	if default_highlight_penances then
		sources[#sources + 1] = table.filter_array(default_highlight_penances, inversed_filter(callback(Managers.achievements, "achievement_completed", player)))
	end

	sources[#sources + 1] = table.filter_array(self._achievements_by_progress, inversed_filter(is_meta_achievement))
	sources[#sources + 1] = table.filter_array(self._achievements_by_progress, is_meta_achievement)
	sources[#sources + 1] = self._achievements_by_recency

	local result_ids = {}

	for _, ids in ipairs(sources) do
		for _, id in ipairs(ids) do
			if blocked_ids[id] then
				-- Nothing
			else
				local definition = AchievementUIHelper.achievement_definition_by_id(id)

				if not definition then
					-- Nothing
				elseif definition.flags and definition.flags.hide_from_carousel then
					-- Nothing
				else
					local layout = self:_get_achievement_card_layout(id)

					if not layout then
						-- Nothing
					else
						result_ids[#result_ids + 1] = layout
						blocked_ids[id] = true

						if #result_ids == max_amount then
							return result_ids
						end
					end
				end
			end
		end
	end

	return result_ids
end

PenanceOverviewView._get_achievement_card_layout = function (self, achievement_id, is_tooltip)
	local player = self:_player()
	local achievement = AchievementUIHelper.achievement_definition_by_id(achievement_id)
	local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
	local can_claim = not is_tooltip and self:_can_claim_achievement_by_id(achievement_id)
	local is_complete = not can_claim and Managers.achievements:achievement_completed(player, achievement_id)
	local is_favorite = AchievementUIHelper.is_favorite_achievement(achievement_id)
	local achievement_score = achievement.score or 0
	local achievement_family_order = AchievementUIHelper.get_achievement_family_order(achievement)
	local draw_progress_bar = self:_achievement_should_display_progress_bar(achievement_definition, is_complete)
	local use_spacing = true
	local blueprint = PenanceOverviewViewDefinitions.grid_blueprints
	local layout = {}
	local layout_blueprint_names_by_grid = PenanceOverviewViewSettings.blueprints_by_page
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

	layout.achievement_id = achievement_id
	layout.tracked = AchievementUIHelper.is_favorite_achievement(achievement_id)

	return layout
end

PenanceOverviewView._handle_input = function (self, input_service, dt, t)
	if not self._initialized then
		return
	end

	local wintrack_element = self._wintrack_element

	if wintrack_element then
		local handle_wintrack_element_input = not self._result_overlay and not self._is_loading

		wintrack_element:set_handle_input(handle_wintrack_element_input)
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
end

PenanceOverviewView.draw = function (self, dt, t, input_service, layer)
	if self._result_overlay then
		input_service = input_service:null_service()
	end

	local render_settings = self._render_settings
	local alpha_multiplier = render_settings.alpha_multiplier
	local animation_alpha_multiplier = self.animation_alpha_multiplier or alpha_multiplier

	render_settings.alpha_multiplier = animation_alpha_multiplier

	PenanceOverviewView.super.draw(self, dt, t, input_service, layer)

	if self._initialized then
		self:_draw_current_panel(dt, t, input_service, layer)
	end

	render_settings.alpha_multiplier = alpha_multiplier
end

PenanceOverviewView._add_carousel_entry = function (self, index)
	local carousel_entries = self._carousel_entries
	local current_ids = table.set(table.map(carousel_entries, function (entry)
		return entry.achievement_id
	end))
	local add_layouts = 1
	local new_layouts = self:_get_carousel_layouts(add_layouts, current_ids)

	carousel_entries[index] = self:_create_carousel_entry(new_layouts[1])

	return carousel_entries[index]
end

PenanceOverviewView._update_carousel_entries = function (self, dt, t, input_service)
	dt = math.min(dt, 0.1)

	local carousel_entries = self._carousel_entries
	local carousel_count = #carousel_entries
	local carousel_target_index = self._carousel_target_index
	local delta = math.normalize_modulus(carousel_target_index - self._carousel_current_index, carousel_count)
	local at_target = self._carousel_target_index == self._carousel_current_index
	local target_speed = (delta > 0 and 1 or -1) * (at_target and 0 or PenanceOverviewViewSettings.carousel_scroll_speed)

	if math.sign(target_speed) ~= math.sign(self._carousel_speed) then
		self._carousel_speed = PenanceOverviewViewSettings.initial_carousel_factor_speed * target_speed

		if target_speed ~= 0 then
			self:_play_sound(UISoundEvents.penance_menu_carousel_move_start)
		end
	end

	self._carousel_speed = math.lerp(target_speed, self._carousel_speed, PenanceOverviewViewSettings.carousel_acceleration^dt)

	local scroll_speed = self._carousel_speed * dt

	if at_target then
		-- Nothing
	elseif math.abs(scroll_speed) > math.abs(delta) then
		self._carousel_current_index = carousel_target_index
		self._carousel_speed = 0

		self:_play_sound(UISoundEvents.penance_menu_carousel_move_stop)
	else
		if math.floor(self._carousel_current_index + scroll_speed) ~= math.floor(self._carousel_current_index) then
			self:_play_sound(UISoundEvents.penance_menu_carousel_move_pass)
		end

		self._carousel_current_index = math.index_wrapper(self._carousel_current_index + scroll_speed, carousel_count)
	end

	local global_alpha = self._global_alpha_multiplier
	local default_position = self:_scenegraph_world_position("carousel_card")
	local default_size = self:_get_scenegraph_size("carousel_card")
	local hovered_card_index, hovered_card_layer
	local carousel_slots = PenanceOverviewViewSettings.carousel_entry_settings
	local slot_count = #carousel_slots
	local center_index = math.ceil(slot_count / 2)
	local index_offset = 0

	if carousel_count < slot_count then
		index_offset = math.floor((slot_count - carousel_count) / 2)
	end

	for i = 1, carousel_count do
		local entry = carousel_entries[i]
		local grid = entry.grid

		grid:set_visibility(false)
		grid:set_background_hovered(false)

		local index = index_offset + 1 + (i - self._carousel_current_index + center_index - 1) % carousel_count

		if index < 1 or slot_count < index then
			-- Nothing
		else
			local from_index = math.clamp(math.floor(index), 1, slot_count)
			local to_index = math.clamp(math.ceil(index), 1, slot_count)
			local from = carousel_slots[from_index]
			local to = carousel_slots[to_index]
			local p = index % 1
			local center_distance = math.abs(center_index - index)
			local anim_hover_progress = entry.anim_hover_progress or 0
			local hover_offset_y = -10 * math.easeCubic(anim_hover_progress)
			local color_intensity = math.lerp(from.color_intensity, to.color_intensity, p)
			local alpha = math.lerp(from.alpha, to.alpha, p) * global_alpha
			local x = default_position[1] + math.lerp(from.position[1], to.position[1], p)
			local y = default_position[2] + math.lerp(from.position[2], to.position[2], p) + math.clamp(3 * alpha, 0, 1) * hover_offset_y + (default_size[2] - grid:grid_height()) / 2
			local z = 10 + math.round(20 * (center_index - center_distance))

			grid:set_pivot_offset(x, y)
			grid:set_grid_interaction_offset(0, -hover_offset_y)
			grid:set_draw_layer(z)
			grid:set_alpha_multiplier(alpha)
			grid:set_color_intensity_multiplier(color_intensity)

			local is_visible = alpha > 0

			grid:set_visibility(is_visible)

			if is_visible then
				grid:update(dt, t, input_service)
			end

			local is_hovered = grid:hovered()
			local is_selected = grid:selected()

			if (is_hovered or is_selected) and (not hovered_card_layer or hovered_card_layer < z) and alpha > 0.6 then
				hovered_card_index = i
				hovered_card_layer = z
			end
		end
	end

	for i = 1, carousel_count do
		local entry = carousel_entries[i]
		local is_hovered = i == hovered_card_index
		local speed = 5

		entry.anim_hover_progress = math.clamp((entry.anim_hover_progress or 0) + dt * (is_hovered and speed or -speed), 0, 1)
	end

	local changed_hover_entry = self._hovered_carousel_card_index ~= hovered_card_index
	local previously_hovered_entry = carousel_entries[self._hovered_carousel_card_index]

	if changed_hover_entry ~= hovered_card_index and previously_hovered_entry then
		local widgets = previously_hovered_entry.grid:widgets()

		for i = 1, #widgets do
			local widget = widgets[i]

			widget.content.hovered = false
		end
	end

	if changed_hover_entry then
		self:_play_sound(UISoundEvents.penance_menu_carousel_hovered)
	end

	self._hovered_carousel_card_index = hovered_card_index

	local hovered_entry = carousel_entries[hovered_card_index]

	if hovered_entry then
		local grid = hovered_entry.grid

		grid:set_background_hovered(true)

		local pressed, right_pressed = grid:pressed()
		local widgets = hovered_entry.grid:widgets()

		for i = 1, #widgets do
			local widget = widgets[i]

			widget.content.hovered = true
		end

		if pressed and not right_pressed then
			local alpha_multiplier = grid:alpha_multiplier()
			local allow_claim = alpha_multiplier >= 0.95 or not self._using_cursor_navigation

			self:_on_carousel_card_pressed(hovered_card_index, hovered_entry, allow_claim)
		end
	end
end

PenanceOverviewView._set_carousel_index = function (self, index, animate)
	self._carousel_target_index = index

	local num_carousel_entries = #self._carousel_entries

	self._widgets_by_name.carousel_footer.content.text = string.format("%d / %d", self._carousel_target_index, num_carousel_entries)

	if not self._using_cursor_navigation then
		self:_focus_on_card(self._carousel_target_index)
	end

	if not animate then
		self._carousel_current_index = index
	end
end

PenanceOverviewView._handle_carousel_scroll = function (self, input_service, dt)
	local wintrack_element = self._wintrack_element
	local is_hovering_item = wintrack_element and wintrack_element:currently_hovered_item() ~= nil

	if self._result_overlay or is_hovering_item then
		input_service = input_service:null_service()
	end

	local carousel_count = self._carousel_entries and #self._carousel_entries or 0
	local delta = math.normalize_modulus(self._carousel_target_index - self._carousel_current_index, carousel_count)

	if math.abs(delta) > PenanceOverviewViewSettings.carousel_scroll_input_handle_threshold then
		return
	end

	local axis_index = self._using_cursor_navigation and 2 or 1
	local axis_name = self._using_cursor_navigation and "scroll_axis" or "navigate_controller"
	local scroll_axis = input_service:get(axis_name)
	local navigation_value = scroll_axis[axis_index]

	if math.abs(navigation_value) < PenanceOverviewViewSettings.carousel_scroll_deadzone then
		navigation_value = 0
	end

	if not self._using_cursor_navigation then
		navigation_value = navigation_value * dt
	end

	self._accumulated_scroll_value = self._accumulated_scroll_value or 0

	if navigation_value ~= 0 then
		self._accumulated_scroll_value = self._accumulated_scroll_value + navigation_value
	else
		self._accumulated_scroll_value = self._accumulated_scroll_value * PenanceOverviewViewSettings.carousel_scroll_decay^dt
	end

	if math.abs(self._accumulated_scroll_value) > PenanceOverviewViewSettings.carousel_scroll_sensitivity then
		local new_index = math.index_wrapper(self._carousel_target_index + math.sign(self._accumulated_scroll_value), carousel_count)

		self:_set_carousel_index(new_index, true)

		self._accumulated_scroll_value = 0
	end
end

PenanceOverviewView._focus_on_card = function (self, index)
	local carousel_entries = self._carousel_entries

	if not carousel_entries then
		return
	end

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

	local total_penance_points = state.xpTracked
	local animate = false

	self._total_score = total_penance_points

	self:_add_points(total_penance_points, animate)

	local rewarded_tiers = state.rewarded + 1

	self._rewarded_tiers = rewarded_tiers
end

PenanceOverviewView._extract_track_rewards = function (self, data)
	local rewards = {}

	if not data then
		return rewards
	end

	local tiers = data.tiers

	if not tiers then
		return rewards
	end

	local archetype_name = self:_player():archetype_name()

	for i = 1, #tiers do
		local tier = tiers[i]
		local tier_rewards = tier.rewards
		local xp_limit = tier.xpLimit
		local items = {}

		for _, reward in pairs(tier_rewards) do
			if reward.type == "item" then
				local item_id = reward.id
				local item = MasterItems.get_item(item_id)

				items[#items + 1] = item
			end
		end

		local item_count = #items

		for j = 1, item_count do
			local archetypes = items[j].archetypes
			local has_archetype = archetypes and table.array_contains(archetypes, archetype_name)

			if has_archetype then
				items[1], items[j] = items[j], items[1]

				break
			end
		end

		rewards[i] = {
			points_required = xp_limit,
			items = items,
		}
	end

	return rewards
end

PenanceOverviewView._setup_track_data = function (self, data)
	local rewards = self:_extract_track_rewards(data)
	local points_per_reward = 100

	if #rewards > 0 then
		self._wintrack_rewards = rewards
		self._wintrack_element = self:_add_element(ViewElementWintrack, "wintrack", 150, {}, "wintrack")

		self._wintrack_element:assign_rewards(rewards, points_per_reward)
	end
end

PenanceOverviewView._add_points = function (self, points, animate)
	self._target_score = self._target_score + points

	self._wintrack_element:add_points(points, animate, true)

	if animate then
		self:_play_sound(UISoundEvents.penance_menu_penance_complete)
		self:_start_animation("on_points_added", self._widgets_by_name, self)
	else
		self._visual_score = self._target_score

		self:_set_penance_points_presentation(self._visual_score)
	end
end

PenanceOverviewView._set_tooltip_alpha = function (self, global_alpha_multiplier)
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

PenanceOverviewView._update_tooltip_visibility = function (self, dt, t)
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
		self._anim_wintrack_reward_hover_progress = anim_wintrack_reward_hover_progress
		self._global_alpha_multiplier = 1 - math.easeOutCubic(anim_wintrack_reward_hover_progress)

		self:_set_tooltip_alpha(self._global_alpha_multiplier)
	end
end

PenanceOverviewView._set_handle_navigation = function (self)
	local result_active = self:_is_result_presentation_active()
	local disable_input = result_active or self._wintracks_focused or self._is_loading
	local penance_grid = self._penance_grid

	if penance_grid and penance_grid:input_disabled() ~= disable_input then
		penance_grid:disable_input(disable_input)
	end

	local penance_tooltip_grid = self._penance_tooltip_grid

	if penance_tooltip_grid and penance_tooltip_grid:input_disabled() ~= disable_input then
		penance_tooltip_grid:disable_input(disable_input)
	end

	local categories_tab_bar = self._categories_tab_bar

	if categories_tab_bar and categories_tab_bar:input_disabled() ~= disable_input then
		categories_tab_bar:disable_input(disable_input)
	end

	local top_panel = self._top_panel

	if top_panel and top_panel:input_disabled() ~= disable_input then
		top_panel:disable_input(disable_input)
	end
end

PenanceOverviewView._update_loading = function (self, dt, t)
	local should_load = self._enter_animation ~= nil and (not self._initialized or self._is_claiming_rewards)
	local is_loading = self._is_loading
	local show_loading = is_loading and self._claim_animation_id == nil and not self._enter_animation

	if show_loading then
		Managers.event:trigger("event_set_waiting_state", LoadingStateData.WAIT_REASON.backend)
	end

	if should_load and not is_loading then
		self._is_loading = true

		Managers.event:trigger("event_start_waiting")
	end

	if not should_load and is_loading then
		self._is_loading = false

		Managers.event:trigger("event_stop_waiting")
	end
end

PenanceOverviewView._update_result_queue = function (self, dt, t)
	local result_overlay_queue = self._result_overlay_queue

	if not result_overlay_queue then
		return
	end

	local result_overlay = self._result_overlay
	local should_close = result_overlay ~= nil and (self._close_result_overlay_next_frame or result_overlay:presentation_complete())

	if should_close then
		self:_remove_element("result_overlay")

		self._close_result_overlay_next_frame = false
		self._result_overlay = nil
	end

	if not self._result_overlay and #result_overlay_queue > 0 then
		local result_entry = table.remove(result_overlay_queue, 1)

		self:_setup_result_overlay(result_entry.reward, result_entry.type)
	end

	return self._result_overlay ~= nil
end

PenanceOverviewView._update_score = function (self, dt, t)
	local skip_update = not self._initialized or self._is_claiming_rewards or self._result_overlay

	if skip_update then
		return
	end

	if self._target_score < self._total_score then
		local diff = self._total_score - self._target_score

		self:_add_points(diff, true)
	end

	local old_visual_score = self._visual_score
	local wintrack_element = self._wintrack_element
	local wintrack_points = wintrack_element and wintrack_element:visual_points() or 0
	local wintrack_max_points = wintrack_element and wintrack_element:max_points() or 1

	if wintrack_points < wintrack_max_points then
		self._visual_score = wintrack_points
	elseif self._visual_score < self._target_score then
		local diff = self._target_score - self._visual_score

		self._visual_score = self._visual_score + math.min(diff, math.ceil(10 * dt * diff))
	end

	if old_visual_score ~= self._visual_score then
		self:_set_penance_points_presentation(self._visual_score)
	end
end

PenanceOverviewView._update_wintrack = function (self, dt, t)
	local wintrack_element = self._wintrack_element

	if not wintrack_element then
		return
	end

	local reward_index = wintrack_element:ready_to_claim_reward_by_index()

	if reward_index then
		self:_claim_wintrack_reward(reward_index)
	end

	if not self._wintrack_initialized and wintrack_element:is_initialized() then
		self._wintrack_initialized = true

		local rewarded_tiers = self._rewarded_tiers

		for i = 1, rewarded_tiers do
			wintrack_element:set_index_claimed(i)
		end

		wintrack_element:set_index_claimed(0)
	end
end

PenanceOverviewView.update = function (self, dt, t, input_service)
	self:_update_loading(dt, t)

	if self._backend_ready and self._entered and not self._initialized then
		self:_finish_setup()
	end

	if not self._initialized then
		local pass_input, pass_draw = PenanceOverviewView.super.update(self, dt, t, input_service)

		return pass_input, pass_draw
	end

	if self._enter_animation_id and self:_is_animation_completed(self._enter_animation_id) and not self._enter_animation_complete then
		self._enter_animation_complete = true
		self._enter_animation_id = nil
	end

	self:_set_handle_navigation()
	self:_update_current_panel(dt, t, input_service)

	local handle_input = not self:_update_result_queue(dt, t)

	self:_update_wintrack(dt, t)
	self:_update_score(dt, t)

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	self:_update_tooltip_visibility(dt, t)
	self:_update_vo(dt, t)

	local pass_input, pass_draw = PenanceOverviewView.super.update(self, dt, t, input_service)

	return handle_input and pass_input, pass_draw
end

PenanceOverviewView._remove_completed_favorites = function (self)
	local account_data = Managers.save:account_data()
	local favorite_achievements = account_data.favorite_achievements
	local player = self:_player()

	for i = 1, #favorite_achievements do
		local achievement_id = favorite_achievements[i]
		local achievement_definition = Managers.achievements:achievement_definition(achievement_id)
		local can_claim = self:_can_claim_achievement_by_id(achievement_id)
		local is_complete = Managers.achievements:achievement_completed(player, achievement_id)
		local should_remove = not achievement_definition or not can_claim and is_complete

		if should_remove then
			self:request_achievement_favorite_remove(achievement_id)
		end
	end
end

PenanceOverviewView._on_wintrack_claim_success = function (self, index, reward, data)
	local claimed_rewards = table.nested_get(data, "body", "rewards")

	if not claimed_rewards then
		Log.warning("PenanceOverviewView", "Failed claiming track, no rewards returned")

		return self:_on_wintrack_claim_failure()
	end

	self._is_claiming_rewards = false

	for _, claimed_reward in pairs(claimed_rewards) do
		if claimed_reward.type == "item" then
			ItemUtils.register_track_reward(claimed_reward)
		end
	end

	self._wintrack_element:on_reward_claimed(index)
	Managers.telemetry_reporters:reporter("penance_view"):register_track_claim_event(index)

	local reward_items = reward.items

	for _, item in ipairs(reward_items) do
		self._result_overlay_queue[#self._result_overlay_queue + 1] = {
			reward = {
				type = "item",
				item = item,
			},
			type = RESULT_TYPES.wintrack,
		}
	end

	self:_play_sound(UISoundEvents.penance_menu_wintrack_reward_claim)
end

PenanceOverviewView._on_wintrack_claim_failure = function (self)
	Log.warning("PenanceOverviewView", "Failed to claim wintrack reward.")

	self._is_claiming_rewards = false
end

PenanceOverviewView._claim_wintrack_reward = function (self, index)
	if self._is_claiming_rewards then
		return
	end

	self._is_claiming_rewards = true

	local rewards = self._wintrack_rewards
	local reward = rewards[index]
	local points_required = reward.points_required
	local wintrack_element = self._wintrack_element
	local current_wintrack_point = wintrack_element:points()

	if current_wintrack_point < points_required then
		return
	end

	local backend_tier_index = index - 1

	self._promise_container:cancel_on_destroy(Managers.backend.interfaces.tracks:claim_track_tier(PENANCE_TRACK_ID, backend_tier_index)):next(callback(self, "_on_wintrack_claim_success", index, reward), callback(self, "_on_wintrack_claim_failure"))
end

PenanceOverviewView.on_exit = function (self)
	local save_manager = Managers.save

	if save_manager then
		local account_data = save_manager:account_data()

		if account_data and account_data.interface_settings then
			account_data.interface_settings.penance_list_setting_show_list_view = self._use_large_penance_entries
		end

		if account_data and account_data.interface_settings then
			account_data.interface_settings.penance_category_index = self._penance_category_index
		end

		save_manager:queue_save()
	end

	self:_on_panel_option_pressed(nil)
	self._promise_container:delete()

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
	local carousel_count = carousel_entries and #carousel_entries or 0

	for i = 1, carousel_count do
		local grid = carousel_entries[i].grid

		grid:destroy()
	end

	self._carousel_entries = nil

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

PenanceOverviewView._delete_tooltip_grid = function (self)
	if not self._penance_tooltip_grid then
		return
	end

	self:_remove_element("tooltip_grid")

	self._penance_tooltip_grid = nil
end

PenanceOverviewView._setup_tooltip_grid = function (self)
	self:_delete_tooltip_grid()

	local grid_scenegraph_id = "tooltip_grid"
	local grid_size = self:_get_scenegraph_size(grid_scenegraph_id)
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
	local grid = self:_add_element(ViewElementGrid, "tooltip_grid", layer, grid_settings, grid_scenegraph_id)

	self:_update_element_position(grid_scenegraph_id, grid)
	grid:set_empty_message("")

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

	grid:update_dividers(top_divider_material, top_divider_size, top_divider_position, bottom_divider_material, bottom_divider_size, bottom_divider_position)

	self._penance_tooltip_grid = grid
end

PenanceOverviewView._present_tooltip_grid_layout = function (self, layout)
	local grid = self._penance_tooltip_grid

	grid:present_grid_layout(layout, PenanceOverviewViewDefinitions.grid_blueprints)
	grid:set_handle_grid_navigation(true)
end

PenanceOverviewView._delete_penance_grid = function (self)
	if not self._penance_grid then
		return
	end

	self:_remove_element("penance_grid")

	self._penance_grid = nil
end

PenanceOverviewView._setup_penance_grid = function (self)
	self:_delete_penance_grid()

	local background_scenegraph_id = "penance_grid_background"
	local background_size = self:_get_scenegraph_size(background_scenegraph_id)
	local grid_scenegraph_id = "penance_grid"
	local grid_size = self:_get_scenegraph_size(grid_scenegraph_id)
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
	local grid = self:_add_element(ViewElementGrid, "penance_grid", layer, grid_settings, grid_scenegraph_id)

	self:_update_element_position(grid_scenegraph_id, grid)
	grid:set_empty_message("")

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

	grid:update_dividers(top_divider_material, top_divider_size, top_divider_position, bottom_divider_material, bottom_divider_size, bottom_divider_position)
	grid:update_dividers_alpha(0, 1)

	self._penance_grid = grid
end

PenanceOverviewView._present_penance_grid_layout = function (self, layout, optional_display_name)
	local grid = self._penance_grid
	local left_click_callback = callback(self, "_cb_on_penance_pressed")
	local right_click_callback

	local function optional_on_present_callback()
		grid:select_first_index()
	end

	grid:present_grid_layout(layout, PenanceOverviewViewDefinitions.grid_blueprints, left_click_callback, right_click_callback, nil, nil, optional_on_present_callback)
	grid:set_handle_grid_navigation(true)
end

PenanceOverviewView._add_new_item = function (self, master_item)
	local gear_id, gear = ItemUtils.track_reward_item_to_gear(master_item)

	Managers.data_service.gear:on_gear_created(gear_id, gear)

	local item = MasterItems.get_item_instance(gear, gear_id)

	if item then
		ItemUtils.mark_item_id_as_new(item, false)
	end
end

PenanceOverviewView._remove_penance_from_unclaimed_count = function (self, achievement_id)
	local parent_id, unclaimed_count = self:_change_category_config_value(achievement_id, "unclaimed_count", -1)
	local content = self._widget_content_by_category[parent_id]

	if content then
		content.has_unclaimed_penances = unclaimed_count > 0
	end
end

PenanceOverviewView._on_penance_claim_success = function (self, reward_bundle, backend_data)
	local rewards = table.nested_get(backend_data, "body", "rewards")

	if not rewards then
		return self:_on_penance_claim_failed(reward_bundle)
	end

	local achievement_id = reward_bundle.sourceInfo.sourceIdentifier

	Managers.telemetry_reporters:reporter("penance_view"):register_penance_claim_event(achievement_id)
	self:request_achievement_favorite_remove(achievement_id)
	self:_remove_penance_from_unclaimed_count(achievement_id)

	self._penance_to_reward_bundle_map[achievement_id] = nil

	local item_rewards, total_xp_awarded = {}, 0

	for _, reward in pairs(rewards) do
		local reward_type = reward.type

		if reward_type == "track-xp" then
			local xp_awarded = reward.xp

			total_xp_awarded = total_xp_awarded + xp_awarded
		end

		if reward_type == "item" then
			local master_id = reward.id

			if MasterItems.item_exists(master_id) then
				local rewarded_master_item = MasterItems.get_item(master_id)

				rewarded_master_item.uuid = reward.gearId
				rewarded_master_item.masterDataInstance = {
					id = master_id,
					overrides = {},
					slots = rewarded_master_item.slots,
				}

				self:_add_new_item(rewarded_master_item)

				item_rewards[#item_rewards + 1] = {
					type = "item",
					item = rewarded_master_item,
				}
			end
		end
	end

	for _, item_reward in ipairs(item_rewards) do
		self._result_overlay_queue[#self._result_overlay_queue + 1] = {
			reward = item_reward,
			type = RESULT_TYPES.penance,
		}
	end

	self._total_score = self._total_score + total_xp_awarded
	self._is_claiming_rewards = false

	return true
end

PenanceOverviewView._on_penance_claim_failed = function (self, reward_bundle, error)
	Log.warning("PenanceOverviewView", "Failed to claim penance reward '%s' with error: %s", reward_bundle.id, error or "Unknown error")

	self._is_claiming_rewards = false

	return false
end

PenanceOverviewView._claim_penance = function (self, reward_bundle)
	if self._is_claiming_rewards then
		return Promise.resolved(false)
	end

	self._is_claiming_rewards = true

	local backend_interface = Managers.backend.interfaces
	local player_rewards = backend_interface.player_rewards
	local promise = self._promise_container:cancel_on_destroy(player_rewards:claim_bundle_reward(reward_bundle.id)):next(callback(self, "_on_penance_claim_success", reward_bundle)):catch(callback(self, "_on_penance_claim_failed", reward_bundle))

	return promise
end

PenanceOverviewView._cb_on_penance_secondary_pressed = function (self, widget)
	local content = widget.content
	local element = content.element
	local achievement_id = element.achievement_id
	local is_favorite = self:_switch_favorite_status(achievement_id)

	content.tracked = is_favorite
	element.tracked = is_favorite
end

PenanceOverviewView._cb_on_penance_pressed = function (self, widget, config)
	local claim_requested = widget.content.can_claim and not self._is_claiming_rewards

	if not claim_requested then
		local penance_grid = self._penance_grid

		penance_grid:select_grid_widget(widget)

		return
	end

	local achievement_id = widget.content.element.achievement_id
	local reward_bundle = self._penance_to_reward_bundle_map[achievement_id]
	local promise = Promise.resolved(true)

	if reward_bundle then
		promise = self:_claim_penance(reward_bundle)
	end

	self._panel_promise_container:cancel_on_destroy(promise):next(function (success)
		if not success then
			return
		end

		local content = widget.content

		content.can_claim = false
		content.completed = true
		content.tracked = false
	end)
end

PenanceOverviewView._setup_result_overlay = function (self, result_data, result_type)
	local reference_name = "result_overlay"
	local layer = 90

	if result_type == RESULT_TYPES.wintrack then
		self._result_overlay = self:_add_element(ViewElementWintrackItemRewardOverlay, reference_name, layer)
	elseif result_type == RESULT_TYPES.penance then
		self._result_overlay = self:_add_element(ViewElementItemResultOverlay, reference_name, layer)
	end

	self._result_overlay:start(result_data)
end

PenanceOverviewView._is_result_presentation_active = function (self)
	return not not self._result_overlay
end

PenanceOverviewView._achievement_should_display_progress_bar = function (self, achievement_definition, is_complete)
	local achievement_type_name = achievement_definition.type
	local achievement_type = AchievementTypes[achievement_type_name]
	local has_progress_bar = achievement_type.get_progress ~= nil
	local ignore_progress_bar = achievement_definition.flags[AchievementFlags.hide_progress] or is_complete

	return has_progress_bar and not ignore_progress_bar
end

PenanceOverviewView._can_claim_achievement_by_id = function (self, achievement_id)
	return self._penance_to_reward_bundle_map[achievement_id] ~= nil
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
	local draw_progress_bar = self:_achievement_should_display_progress_bar(achievement_definition, is_complete)
	local bar_progress, progress, goal

	if draw_progress_bar then
		bar_progress, progress, goal = self:_get_achievement_bar_progress(achievement_definition)
	end

	local title = AchievementUIHelper.localized_title(achievement_definition)
	local separate_private_description = true
	local description = AchievementUIHelper.localized_description(achievement_definition, separate_private_description)
	local progress_text = progress and (progress > 0 and TextUtilities.apply_color_to_text(tostring(progress), Color.ui_achievement_icon_completed(255, true)) or tostring(progress))
	local bar_values_text = progress_text and progress_text .. "/" .. tostring(goal)
	local reward_item, _ = AchievementUIHelper.get_reward_item(achievement_definition)
	local reward_type_icon = reward_item and ItemUtils.type_texture(reward_item)
	local achievement_score = achievement.score or 0
	local achievement_icon = achievement.icon
	local widget_type = self._use_large_penance_entries and "penance_large" or "penance"

	return {
		widget_type = widget_type,
		texture = achievement_icon,
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

PenanceOverviewView._penance_comparator = function (self, favorite_comparator, completion_comparator)
	return function (a_id, b_id)
		local achievements = Managers.achievements
		local player = self:_player()

		if favorite_comparator then
			local a_favorite = self:is_favorite_achievement(a_id)
			local b_favorite = self:is_favorite_achievement(b_id)

			if a_favorite and not b_favorite then
				return favorite_comparator == ">"
			end

			if b_favorite and not a_favorite then
				return favorite_comparator == "<"
			end
		end

		if completion_comparator then
			local a_completed = achievements:achievement_completed(player, a_id)
			local b_completed = achievements:achievement_completed(player, b_id)

			if a_completed and not b_completed then
				return completion_comparator == ">"
			end

			if b_completed and not a_completed then
				return completion_comparator == "<"
			end
		end

		local a = achievements:achievement_definition(a_id)
		local b = achievements:achievement_definition(b_id)

		return a.index < b.index
	end
end

PenanceOverviewView._add_category_to_penance_grid_layout = function (self, layout, show_header, category_id, comparator)
	local category = AchievementCategories[category_id]

	if not category then
		return
	end

	local achievements = self._achievements_by_category[category_id]
	local filter = self._penance_grid_filters and self._penance_grid_filters[self._current_filter_index].filter

	achievements = achievements and (filter and table.filter_array(achievements, filter) or table.shallow_copy_array(achievements))

	local achievement_count = achievements and #achievements or 0

	if achievement_count == 0 then
		return
	end

	local grid_scenegraph_id = "penance_grid"
	local grid_size = self:_get_scenegraph_size(grid_scenegraph_id)

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10,
		},
	}

	local display_name = category.display_name

	if show_header then
		layout[#layout + 1] = {
			widget_type = "header",
			text = Localize(display_name),
		}
	end

	table.sort(achievements, comparator)

	for i = 1, achievement_count do
		local achievement_id = achievements[i]

		layout[#layout + 1] = self:_get_penance_layout_entry_by_achievement_id(achievement_id)
	end

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10,
		},
	}
end

PenanceOverviewView._get_penance_grid_layout = function (self, display_name, category_id, child_categories)
	self:_set_title(display_name)

	local using_large_penances = self._use_large_penance_entries
	local comparator = self:_penance_comparator(using_large_penances and ">", using_large_penances and "<")
	local layout = {}

	self:_add_category_to_penance_grid_layout(layout, false, category_id, comparator)

	local child_count = child_categories and #child_categories or 0

	for i = 1, child_count do
		local child_category_id = child_categories[i]

		self:_add_category_to_penance_grid_layout(layout, true, child_category_id, comparator)
	end

	return layout
end

PenanceOverviewView._select_category = function (self, index)
	local option = self._category_button_config[index]

	if not option then
		return
	end

	self._penance_category_index = index

	local category_id = option.category_id
	local display_name = option.display_name
	local child_categories = option.child_categories
	local layout = self:_get_penance_grid_layout(display_name, category_id, child_categories)

	self:_present_penance_grid_layout(layout, display_name)

	self._selected_option_button_index = index

	self._categories_tab_bar:set_selected_index(index)

	if not self._using_cursor_navigation then
		self:_play_sound(UISoundEvents.tab_secondary_button_pressed)
	end
end

PenanceOverviewView.on_category_button_pressed = function (self, index)
	if index == self._selected_option_button_index then
		return
	end

	self:_select_category(index)
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

PenanceOverviewView._delete_carousel_entries = function (self)
	local entries = self._carousel_entries
	local entry_count = entries and #entries or 0

	for i = 1, entry_count do
		entries[i].grid:delete()
	end

	self._carousel_entries = nil
end

PenanceOverviewView._setup_carousel_entries = function (self, achievement_layouts)
	self:_delete_carousel_entries()

	local carousel_entries = {}

	for i = 1, #achievement_layouts do
		local layout = achievement_layouts[i]

		carousel_entries[#carousel_entries + 1] = self:_create_carousel_entry(layout)
	end

	self._carousel_entries = carousel_entries
	self._accumulated_scroll_value = 0
	self._carousel_current_index = 1
	self._carousel_target_index = 1
	self._carousel_speed = 0

	self:_set_carousel_index(1, false)
end

PenanceOverviewView._on_carousel_card_pressed = function (self, index, entry, allow_claim)
	allow_claim = allow_claim ~= false

	local achievement_id = entry.achievement_id
	local claim_requested = allow_claim and not self._destroyed_carousel_index and self:_can_claim_achievement_by_id(achievement_id)

	if not claim_requested then
		self:_set_carousel_index(index, true)

		return
	end

	local reward_bundle = self._penance_to_reward_bundle_map[achievement_id]

	if reward_bundle then
		self:_claim_penance(reward_bundle)
	end

	local grid = entry.grid
	local widgets = grid:widgets()

	for i = 1, #widgets do
		local content = widgets[i].content

		content.can_claim = false
		content.completed = true
		content.tracked = false
	end

	local start_height = grid:grid_height()
	local start_pivot_offset = grid._pivot_offset[2]
	local additional_widgets = {
		divider_top = grid._widgets_by_name.grid_divider_top,
		divider_bottom = grid._widgets_by_name.grid_divider_bottom,
		background = grid._widgets_by_name.grid_background,
	}

	self._claim_animation_id = self:_start_animation("on_carousel_claimed", widgets, {
		additional_widgets = additional_widgets,
		grid = grid,
		start_height = start_height,
		start_pivot_offset = start_pivot_offset,
	})
	self._destroyed_carousel_index = index
end

PenanceOverviewView._can_switch_favorite_status = function (self, achievement_id)
	local is_currently_favorite = self:is_favorite_achievement(achievement_id)

	if is_currently_favorite then
		return true
	end

	local currently_tracked, can_track = AchievementUIHelper.favorite_achievement_count()

	if can_track <= currently_tracked then
		return false
	end

	local player = self:_player()
	local is_complete = Managers.achievements:achievement_completed(player, achievement_id)
	local can_claim = self:_can_claim_achievement_by_id(achievement_id)

	return not is_complete and not can_claim
end

PenanceOverviewView._switch_favorite_status = function (self, achievement_id)
	local is_currently_favorite = self:is_favorite_achievement(achievement_id)
	local is_favorite = is_currently_favorite
	local can_switch = self:_can_switch_favorite_status(achievement_id)

	if not is_currently_favorite and can_switch and self:request_achievement_favorite_add(achievement_id) then
		is_favorite = true

		self:_play_sound(UISoundEvents.penance_menu_penance_track)
	end

	if is_currently_favorite and can_switch and self:request_achievement_favorite_remove(achievement_id) then
		is_favorite = false

		self:_play_sound(UISoundEvents.penance_menu_penance_untrack)
	end

	return is_favorite
end

PenanceOverviewView._on_carousel_card_secondary_pressed = function (self, index, entry)
	local achievement_id = entry.achievement_id
	local is_favorite = self:_switch_favorite_status(achievement_id)
	local grid = entry.grid
	local widgets = grid:widgets()

	for i = 1, #widgets do
		widgets[i].content.tracked = is_favorite
	end
end

PenanceOverviewView.cb_on_filter_changed = function (self)
	self._current_filter_index = math.index_wrapper(self._current_filter_index + 1, #self._penance_grid_filters)

	local index = self._selected_option_button_index

	self:_select_category(index)
end

PenanceOverviewView._filter_completed = function (self, achievement_id)
	local player = self:_player()

	return Managers.achievements:achievement_completed(player, achievement_id)
end

PenanceOverviewView._filter_uncompleted = function (self, achievement_id)
	return not self:_filter_completed(achievement_id)
end

PenanceOverviewView._setup_penance_filter_options = function (self)
	self._current_filter_index = 1
	self._penance_grid_filters = {
		{
			display_name = "loc_penance_grid_show_all",
			filter = false,
		},
		{
			display_name = "loc_penance_grid_show_completed",
			filter = callback(self, "_filter_completed"),
		},
		{
			display_name = "loc_penance_grid_show_uncompleted",
			filter = callback(self, "_filter_uncompleted"),
		},
	}
end

PenanceOverviewView._delete_penance_category_grid = function (self)
	if not self._categories_tab_bar then
		return
	end

	self:_remove_element("categories_tab_bar")

	self._categories_tab_bar = nil
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
		wrapped_selection = true,
		button_size = button_size,
		button_spacing = button_spacing,
		input_label_offset = {
			25,
			15,
		},
	}
	local categories_tab_bar = self:_add_element(ViewElementTabMenu, "categories_tab_bar", 40, settings)

	self._categories_tab_bar = categories_tab_bar

	local button_template = PenanceOverviewViewDefinitions.grid_blueprints.category_button.pass_template

	self._widget_content_by_category = {}

	for i = 1, category_count do
		local option = options[i]
		local category_id = option.category_id
		local display_name = option.display_name
		local pressed_callback = callback(self, "on_category_button_pressed", i)
		local entry_id = categories_tab_bar:add_entry(display_name, pressed_callback, button_template, option.icon)
		local entry_content = categories_tab_bar:content_by_id(entry_id)
		local num_total_achievements = option.total_count
		local num_total_achievements_completed = option.completed_count
		local num_unclaimed_achievements = option.unclaimed_count
		local num_favorite_achievements = option.favorite_count

		entry_content.text_counter = string.format("%d/%d", num_total_achievements_completed, num_total_achievements)
		entry_content.has_unclaimed_penances = num_unclaimed_achievements > 0
		entry_content.has_favorite_penances = num_favorite_achievements > 0
		self._widget_content_by_category[category_id] = entry_content
	end

	local input_action_left = "navigate_secondary_left_pressed"
	local input_action_right = "navigate_secondary_right_pressed"

	categories_tab_bar:set_input_actions(input_action_left, input_action_right)
	categories_tab_bar:set_is_handling_navigation_input(true)

	local index = math.clamp(self._penance_category_index or 1, 1, category_count)

	self:_select_category(index)
	self:_update_categories_tab_bar_position()

	self._widgets_by_name.page_header.style.top_bar.size[1] = 32 + category_count * (button_size[1] + button_spacing) + button_spacing
end

PenanceOverviewView._carousel_grid_on_resolution_modified = function (self, scale)
	local carousel_entries = self._carousel_entries
	local carousel_count = carousel_entries and #carousel_entries or 0

	for i = 1, carousel_count do
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

PenanceOverviewView._setup_top_panel = function (self)
	local reference_name = "top_panel"
	local layer = 60

	self._top_panel = self:_add_element(ViewElementMenuPanel, reference_name, layer)
	self._panel_options = {
		{
			display_name = "loc_penance_menu_panel_option_highlights",
			key = "carousel",
			on_enter = callback(self, "_open_carousel_panel"),
			on_exit = callback(self, "_exit_carousel_panel"),
			on_update = callback(self, "_update_carousel_panel"),
			on_draw = callback(self, "_draw_carousel_panel"),
		},
		{
			display_name = "loc_penance_menu_panel_option_browser",
			key = "browser",
			on_enter = callback(self, "_open_browser_panel"),
			on_exit = callback(self, "_exit_browser_panel"),
			on_update = callback(self, "_update_browser_panel"),
			on_draw = callback(self, "_draw_browser_panel"),
		},
	}

	local panel_options = self._panel_options

	for i = 1, #panel_options do
		local settings = panel_options[i]
		local display_name_loc_key = settings.display_name
		local cb = callback(self, "_on_panel_option_pressed", i)

		self._top_panel:add_entry(Localize(display_name_loc_key), cb)
	end

	self._top_panel:set_is_handling_navigation_input(true)
	self._top_panel:set_selected_panel_index(1, true)
end

PenanceOverviewView._open_carousel_panel = function (self)
	self._widgets_by_name.carousel_header.content.visible = true
	self._widgets_by_name.carousel_footer.content.visible = true

	local carousel_achievement_layouts = self:_get_carousel_layouts()

	self:_setup_carousel_entries(carousel_achievement_layouts)
end

PenanceOverviewView._update_carousel_panel = function (self, dt, t, input_service)
	self:_handle_carousel_scroll(input_service, dt)
	self:_update_carousel_entries(dt, t, input_service)

	local claim_animation_id = self._claim_animation_id
	local claim_is_animating = claim_animation_id and not self:_is_animation_completed(claim_animation_id)

	if claim_animation_id and not claim_is_animating then
		self._claim_animation_id = nil
	end

	local can_update_carousel = not claim_is_animating and not self._is_claiming_rewards

	if not can_update_carousel then
		return
	end

	local destroyed_carousel_index = self._destroyed_carousel_index

	if destroyed_carousel_index then
		local new_entry = self:_add_carousel_entry(destroyed_carousel_index)

		if not self._using_cursor_navigation then
			new_entry.grid:select()
		end

		self._destroyed_carousel_index = nil
	end
end

PenanceOverviewView._draw_carousel_panel = function (self, dt, t, input_service, layer)
	local ui_renderer = self._ui_renderer
	local render_settings = self._render_settings
	local carousel_entries = self._carousel_entries
	local carousel_count = carousel_entries and #carousel_entries or 0

	for i = 1, carousel_count do
		local entry = carousel_entries[i]
		local grid = entry.grid
		local grid_alpha_multiplier = grid:alpha_multiplier()

		if grid_alpha_multiplier and grid_alpha_multiplier > 0 then
			grid:draw(dt, t, ui_renderer, render_settings, input_service)
		end
	end
end

PenanceOverviewView._exit_carousel_panel = function (self)
	self:_delete_carousel_entries()

	self._destroyed_carousel_index = nil

	if self._claim_animation_id then
		self:_stop_animation(self._claim_animation_id)

		self._claim_animation_id = nil
	end

	self._widgets_by_name.carousel_header.content.visible = false
	self._widgets_by_name.carousel_footer.content.visible = false
end

PenanceOverviewView._open_browser_panel = function (self)
	self._widgets_by_name.page_header.content.visible = true

	self:_setup_tooltip_grid()
	self:_setup_penance_grid()
	self:_setup_penance_category_buttons(self._category_button_config)
	self:_set_tooltip_alpha(self._global_alpha_multiplier)
end

PenanceOverviewView._update_browser_panel = function (self, dt, t, input_service)
	local selected_widget = self._penance_grid:selected_grid_widget()
	local selected_achievement_id = selected_widget and selected_widget.content.element.achievement_id

	if selected_achievement_id ~= self._selected_tooltip_id then
		self._selected_tooltip_id = selected_achievement_id

		local has_achievement_id = selected_achievement_id ~= nil
		local tooltip_layout = has_achievement_id and self:_get_achievement_card_layout(selected_achievement_id, true) or {}

		self:_present_tooltip_grid_layout(tooltip_layout)
		self._penance_tooltip_grid:set_visibility(has_achievement_id)
	end
end

PenanceOverviewView._draw_browser_panel = function (self, dt, t, input_service, layer)
	return
end

PenanceOverviewView._exit_browser_panel = function (self)
	self._selected_tooltip_id = nil
	self._widget_content_by_category = {}

	self:_delete_penance_category_grid()
	self:_delete_penance_grid()
	self:_delete_tooltip_grid()

	self._widgets_by_name.page_header.content.visible = false
end

PenanceOverviewView._switch_panel = function (self, index)
	local old_index = self._selected_top_option_index

	if index == old_index then
		return
	end

	local panel_options = self._panel_options
	local old_option = panel_options[old_index]

	if old_option then
		self._panel_promise_container:delete()
	end

	if old_option and old_option.on_exit then
		old_option.on_exit()
	end

	local option = panel_options[index]

	self._selected_top_option_index = index
	self._selected_top_option_key = option and option.key
	self._panel_promise_container = PromiseContainer:new()

	if option and option.on_enter then
		option.on_enter()
	end
end

PenanceOverviewView._on_panel_option_pressed = function (self, index)
	self._switch_to_panel_index = index
end

PenanceOverviewView._call_on_current_panel = function (self, name, ...)
	local selected_index = self._selected_top_option_index
	local current_option = self._panel_options[selected_index]

	if current_option and current_option[name] then
		return current_option[name](...)
	end
end

PenanceOverviewView._update_current_panel = function (self, ...)
	if self._switch_to_panel_index then
		self:_switch_panel(self._switch_to_panel_index)

		self._switch_to_panel_index = nil
	end

	return self:_call_on_current_panel("on_update", ...)
end

PenanceOverviewView._draw_current_panel = function (self, ...)
	return self:_call_on_current_panel("on_draw", ...)
end

PenanceOverviewView.cb_on_switch_focus = function (self)
	if self._using_cursor_navigation then
		return
	end

	local wintrack_element = self._wintrack_element

	if not wintrack_element then
		return
	end

	self._wintracks_focused = not self._wintracks_focused

	if self._wintracks_focused then
		wintrack_element:apply_focus_on_reward()
	else
		wintrack_element:remove_focus_on_reward()
	end
end

PenanceOverviewView._get_target = function (self)
	if self._wintracks_focused then
		return
	end

	local selected_top_option_key = self._selected_top_option_key

	if selected_top_option_key == "carousel" then
		local index = self._hovered_carousel_card_index
		local entry = self._carousel_entries[index]
		local achievement_id = entry and entry.achievement_id

		return index, entry, achievement_id
	elseif selected_top_option_key == "browser" then
		local index

		if self._using_cursor_navigation then
			index = self._penance_grid:hovered_grid_index()
		else
			index = self._penance_grid:selected_grid_index()
		end

		local widget = self._penance_grid:widget_by_index(index)
		local config = widget and widget.content.element
		local achievement_id = config and config.achievement_id

		return index, widget, achievement_id
	end
end

PenanceOverviewView._cb_favorite_legend_visibility = function (self, add_to_favorite)
	local _, _, achievement_id = self:_get_target()

	if not achievement_id then
		return false
	end

	local is_favorite = self:is_favorite_achievement(achievement_id)
	local can_change = self:_can_switch_favorite_status(achievement_id)

	return is_favorite ~= add_to_favorite and can_change
end

PenanceOverviewView._on_favorite_pressed = function (self)
	local index, entry, achievement_id = self:_get_target()

	if not achievement_id then
		return
	end

	local selected_top_option_key = self._selected_top_option_key

	if selected_top_option_key == "carousel" then
		self:_on_carousel_card_secondary_pressed(index, entry)
	elseif selected_top_option_key == "browser" then
		self:_cb_on_penance_secondary_pressed(entry)
	end
end

PenanceOverviewView._on_navigation_input_changed = function (self)
	PenanceOverviewView.super._on_navigation_input_changed(self)

	local initialized = self._initialized

	if not initialized then
		return
	end

	if not self._using_cursor_navigation then
		self:_focus_on_card(self._carousel_target_index)
	else
		self:_focus_on_card()
	end

	if self._wintrack_element then
		self._wintrack_element:remove_focus_on_reward()

		self._wintracks_focused = false
	end
end

PenanceOverviewView._currently_hovered_wintrack_item = function (self)
	return self._wintrack_element and self._wintrack_element:currently_hovered_item() or nil
end

PenanceOverviewView.cb_on_inspect_pressed = function (self)
	local previewed_item = self:_currently_hovered_wintrack_item()

	if not previewed_item then
		return
	end

	local item_type = previewed_item.item_type
	local is_weapon = item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED"
	local view_name = "cosmetics_inspect_view"

	if is_weapon or item_type == "GADGET" then
		view_name = "inventory_weapon_details_view"
	end

	if Managers.ui:view_active(view_name) then
		return
	end

	local is_weapon_skin = item_type == "WEAPON_SKIN"
	local visual_item = is_weapon_skin and ItemUtils.weapon_skin_preview_item(previewed_item, true) or previewed_item
	local real_profile = self:_player():profile()
	local player_profile = real_profile and table.clone_instance(real_profile)
	local player_archetype = player_profile and player_profile.archetype
	local correct_archetype = visual_item.archetypes == nil or #visual_item.archetypes == 0 or player_archetype ~= nil and table.array_contains(visual_item.archetypes, player_archetype.name)
	local correct_breed = visual_item.breeds == nil or #visual_item.breeds == 0 or player_archetype ~= nil and table.array_contains(visual_item.breeds, player_archetype.breed)
	local is_item_supported_on_played_character = correct_archetype and correct_breed
	local preferred_gender = player_profile and player_profile.gender

	player_profile = is_item_supported_on_played_character and player_profile or ItemUtils.create_mannequin_profile_by_item(visual_item, preferred_gender)

	local context

	if is_weapon_skin then
		local slots = visual_item.slots
		local slot_name = slots[1]

		player_profile.loadout[slot_name] = visual_item

		local archetype = player_archetype
		local breed_name = archetype.breed
		local breed = Breeds[breed_name]
		local state_machine = breed.inventory_state_machine
		local animation_event = visual_item.inventory_animation_event or "inventory_idle_default"

		context = {
			disable_zoom = true,
			profile = player_profile,
			state_machine = state_machine,
			animation_event = animation_event,
			wield_slot = slot_name,
			preview_with_gear = is_item_supported_on_played_character,
			preview_item = visual_item,
		}
	else
		context = {
			profile = player_profile,
			preview_with_gear = is_item_supported_on_played_character,
			preview_item = previewed_item,
		}
	end

	Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
end

PenanceOverviewView.can_inspect_item = function (self)
	local item = self:_currently_hovered_wintrack_item()

	if not item then
		return false
	end

	if UISettings.inspectable_item_types[item.item_type] then
		return true
	end

	return false
end

PenanceOverviewView._update_vo = function (self, dt, t)
	if not self._hub_interaction then
		return
	end

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
