local Definitions = require("scripts/ui/views/achievements_view/achievements_view_definitions")
local AchievementCategories = require("scripts/settings/achievements/achievement_categories")
local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local AchievementUITypes = require("scripts/settings/achievements/achievement_ui_types")
local TextUtils = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewStyles = require("scripts/ui/views/achievements_view/achievements_view_styles")
local CATEGORIES_GRID = 1
local ACHIEVEMENT_GRID = 2
local AchievementsView = class("AchievementsView", "BaseView")
local data_service = Managers.data_service.account
local _get_reward_item = AchievementUIHelper.get_reward_item

local function _progression_sort_function(a, b)
	local a_progression = a.progress_current / a.progress_goal
	local b_progression = b.progress_current / b.progress_goal

	return a_progression > b_progression
end

local function _completion_time_sort_function(a, b)
	local a_completed_time = a.completed_time
	local b_completed_time = b.completed_time

	if a_completed_time and b_completed_time then
		return b_completed_time < a_completed_time
	elseif a_completed_time then
		return true
	elseif b_completed_time then
		return false
	else
		return a.sort_index < b.sort_index
	end
end

local function _achievements_sort_function(a, b)
	local a_completed = a.completed
	local b_completed = b.completed

	if a_completed and b_completed then
		return _completion_time_sort_function(a, b)
	elseif a_completed then
		return true
	elseif b_completed then
		return false
	else
		return a.sort_index < b.sort_index
	end
end

AchievementsView.init = function (self, settings, context)
	AchievementsView.super.init(self, Definitions, settings)

	local parent = context and context.parent

	if parent then
		parent:set_active_view_instance(self)

		self._parent = parent
		self._pass_input = true
		self._pass_draw = true
	end
end

AchievementsView.on_enter = function (self)
	AchievementsView.super.on_enter(self)

	self._legend_input_ids = nil
	self._achievements = nil
	self._completed_achievements = nil
	self._achievements_in_progress = nil
	self._categories = nil
	self._current_achievements = nil
	self._num_achievements_completed = 0
	self._num_achievements_total = 0
	self._total_score = 0
	self._grids = {}
	self._focused_grid_id = nil
	self._categories_layout = nil
	self._main_grid_layout = nil
	self._next_category_id = nil
	self._show_summary_next_frame = nil
	self._allow_close_hotkey = true

	self:_setup_input_legend()
	self:_setup_grids()
	self:_populate_page()
end

AchievementsView.on_exit = function (self)
	local legend_input_ids = self._legend_input_ids

	if legend_input_ids and not self._parent._destroyed then
		for i = 1, #legend_input_ids do
			local id = legend_input_ids[i]

			self._parent:remove_input_legend_entry(id)
		end
	end

	AchievementsView.super.on_exit(self)
end

AchievementsView.on_resolution_modified = function (self, scale)
	AchievementsView.super.on_resolution_modified(self, scale)
	self:_update_grid_positions()
end

AchievementsView.update = function (self, dt, t, input_service)
	self:_update_current_category()

	self._allow_close_hotkey = self._focused_grid_id ~= ACHIEVEMENT_GRID

	return AchievementsView.super.update(self, dt, t, input_service)
end

AchievementsView.on_back_pressed = function (self)
	return not self._allow_close_hotkey
end

AchievementsView._on_navigation_input_changed = function (self)
	local using_gamepad = not self._using_cursor_navigation
	local focused_grid_id = using_gamepad and (self._focused_grid_id or CATEGORIES_GRID) or nil
	local grids = self._grids

	for i = 1, #grids do
		local is_focused_grid = i == focused_grid_id
		local grid = grids[i]
		local selected_grid_index = grid:selected_grid_index()
		local focused_grid_index = grid:focused_grid_index()

		if is_focused_grid then
			if not selected_grid_index and focused_grid_index then
				grid:select_grid_index(focused_grid_index)
			else
				selected_grid_index = selected_grid_index or grid:select_first_index()
			end

			grid:focus_grid_index(selected_grid_index)
		else
			grid:focus_grid_index(nil)
		end

		if i == CATEGORIES_GRID and not selected_grid_index then
			grid:select_first_index()
		end

		grid:disable_input(using_gamepad and not is_focused_grid)
	end

	local categories = self._categories
	local category = categories and categories[self._current_category_id]
	local gamepad_unfold_hint_widget = self._widgets_by_name.gamepad_unfold_hint
	local unfold_hints_visible = using_gamepad and category and category.has_sub_categories
	gamepad_unfold_hint_widget.visible = unfold_hints_visible

	if unfold_hints_visible then
		local show_sub_categories = category.widget.content.show_sub_categories
		local button_hint_text = show_sub_categories and "loc_achievements_view_button_hint_fold_category" or "loc_achievements_view_button_hint_unfold_category"
		gamepad_unfold_hint_widget.content.text = TextUtils.localize_with_button_hint("secondary_action_pressed", button_hint_text)
	end

	self._focused_grid_id = focused_grid_id
end

AchievementsView._handle_input = function (self, input_service, dt, t)
	local focused_grid_id = self._focused_grid_id

	if not focused_grid_id then
		return
	end

	local grid_has_changed = false

	if focused_grid_id == ACHIEVEMENT_GRID then
		if input_service:get("navigate_left_continuous") or input_service:get("back") then
			focused_grid_id = CATEGORIES_GRID
			grid_has_changed = true
		elseif input_service:get("secondary_action_pressed") then
			local grid = self._grids[focused_grid_id]
			local focused_widget = grid:selected_grid_widget()
			local fold_callback = focused_widget and focused_widget.content.fold_callback

			if fold_callback then
				fold_callback()
			end
		end
	elseif focused_grid_id == CATEGORIES_GRID then
		if input_service:get("navigate_right_continuous") or input_service:get("confirm_pressed") then
			local grid = self._grids[ACHIEVEMENT_GRID]

			if self._current_achievements and grid:first_interactable_grid_index() then
				focused_grid_id = ACHIEVEMENT_GRID
			else
				self._next_category_id = nil
			end

			grid_has_changed = true
		elseif input_service:get("secondary_action_pressed") then
			local current_category_id = self._current_category_id

			if current_category_id then
				self:_fold_or_unfold_subcategories(current_category_id)

				grid_has_changed = true
			end
		end
	end

	if grid_has_changed then
		self._focused_grid_id = focused_grid_id

		self:_on_navigation_input_changed()
	end
end

AchievementsView._cb_summary_selected = function (self)
	self._show_summary_next_frame = true
	self._next_category_id = nil
end

AchievementsView._cb_category_selected = function (self, widget, config, category_id)
	self._next_category_id = category_id
end

AchievementsView._cb_unfold_legend_button_visibility = function (self, should_be_unfolded)
	if self._using_cursor_navigation then
		return false
	end

	local focused_grid_id = self._focused_grid_id

	if focused_grid_id ~= ACHIEVEMENT_GRID then
		return false
	end

	local grid = self._grids[focused_grid_id]
	local widget = grid:selected_grid_widget()

	return widget and widget.content.unfolded == should_be_unfolded
end

AchievementsView._cb_category_pressed = function (self, widget, config)
	local category = config.category
	local category_id = category and category.id

	if config.has_sub_categories and self._using_cursor_navigation then
		self:_fold_or_unfold_subcategories(category_id)
	else
		local grid = self._grids[CATEGORIES_GRID]
		local grid_index = grid:widget_index(widget)

		grid:select_grid_index(grid_index)
	end
end

AchievementsView._populate_page = function (self)
	data_service:get_achievements():next(function (achievements)
		if self._destroyed then
			return
		end

		self:_set_achievements_and_categories(achievements)
		self:_populate_categories_column()
		self:_show_summary()
		self:_on_navigation_input_changed()
	end)
end

AchievementsView._update_current_category = function (self)
	if self._show_summary_next_frame then
		self:_show_summary()

		self._show_summary_next_frame = nil
		self._current_category_id = nil
		self._current_achievements = nil
		self._next_category_id = nil

		self:_on_navigation_input_changed()
	end

	local next_category_id = self._next_category_id

	if next_category_id then
		if next_category_id ~= self._current_category_id then
			local category = self._categories[next_category_id]
			local label = category and category.num_total > 0 and category.label
			local achievements = self._categories[next_category_id].achievements

			self:_populate_achievements_grid(achievements, label)

			self._current_achievements = achievements
			self._current_category_id = next_category_id
		end

		self._next_category_id = nil
		self._show_summary_next_frame = nil

		self:_on_navigation_input_changed()
	end
end

AchievementsView._fold_or_unfold_subcategories = function (self, category_id)
	local categories = self._categories
	local category = categories[category_id]
	local sub_categories = category.sub_categories
	local category_widget = category.widget

	if not sub_categories or #sub_categories == 0 then
		local categories_grid = self._grids[CATEGORIES_GRID]

		categories_grid:scroll_to_grid_widget(category_widget)

		return
	end

	local top_category_content = category_widget.content
	local show_sub_categories = not top_category_content.show_sub_categories
	top_category_content.show_sub_categories = show_sub_categories
	local top_category_style = category_widget.style
	local frame_height = show_sub_categories and top_category_style.unfolded_height or top_category_style.folded_height
	local arrow_style = top_category_style.arrow
	arrow_style.angle = math.degrees_to_radians(show_sub_categories and 90 or -90)

	self:_play_sound(show_sub_categories and arrow_style.unfold_sound or arrow_style.fold_sound)

	for i = 1, #sub_categories do
		local sub_category = sub_categories[i]
		local widget = sub_category.widget

		if widget.visible ~= show_sub_categories then
			widget.visible = show_sub_categories
			local widget_style = widget.style
			local widget_content = widget.content
			widget_content.size = show_sub_categories and widget_style.unfolded_size or widget_style.folded_size
		end
	end

	local categories_grid = self._grids[CATEGORIES_GRID]

	categories_grid:force_update_list_size()
	categories_grid:scroll_to_grid_widget(category_widget, nil, show_sub_categories)
end

AchievementsView._show_summary = function (self)
	local blueprints = self._definitions.blueprints
	local layout = self._summary_layout

	if not layout then
		layout = {
			[#layout + 1] = {
				widget_type = "list_padding"
			},
			[#layout + 1] = {
				display_name = "loc_achievements_view_summary_completed",
				widget_type = "header"
			}
		}
		local completed_achievements = self._completed_achievements

		for i = 1, ViewStyles.achievement_summary.num_completed_to_show do
			local achievement = completed_achievements[i]

			if achievement then
				layout[#layout + 1] = {
					completed = true,
					is_summary = true,
					widget_type = "normal_achievement",
					achievement = achievement,
					reward_item = _get_reward_item(achievement)
				}
			else
				layout[#layout + 1] = {
					widget_type = "empty_space"
				}
			end
		end

		layout[#layout + 1] = {
			display_name = "loc_achievements_view_summary_near_completed",
			widget_type = "header"
		}
		local achievements_in_progress = self._achievements_in_progress

		for i = 1, ViewStyles.achievement_summary.num_near_completed_to_show do
			local achievement = achievements_in_progress[i]

			if achievement then
				layout[#layout + 1] = {
					completed = false,
					is_summary = true,
					widget_type = "normal_achievement",
					achievement = achievement,
					reward_item = _get_reward_item(achievement)
				}
			end
		end

		self._summary_layout = layout
	end

	self._grids[ACHIEVEMENT_GRID]:present_grid_layout(layout, blueprints)
end

local _achievement_list_padding = {
	widget_type = "list_padding"
}

AchievementsView._populate_achievements_grid = function (self, achievements, group_label)
	local ITEM_TYPES = UISettings.ITEM_TYPES
	local blueprints = self._definitions.blueprints
	local layout = {}

	for id, achievement in pairs(achievements) do
		if not achievement.hidden then
			local achievement_context = {
				achievement = achievement,
				sort_index = achievement.sort_index,
				completed = achievement.completed,
				completed_time = achievement.completed_time
			}
			local is_completed = achievement.completed
			local is_meta_achievement = achievement.type == AchievementUITypes.meta
			local is_feat_of_strength = achievement.type == AchievementUITypes.feat_of_strength
			local related_commendation_ids = achievement.related_commendation_ids

			if related_commendation_ids then
				achievement_context.widget_type = "foldout_achievement"
				local all_achievements = self._achievements
				local sub_achievements = {}

				for i = 1, #related_commendation_ids do
					local related_commendation_id = related_commendation_ids[i]
					local related_achievement = all_achievements[related_commendation_id]
					sub_achievements[#sub_achievements + 1] = related_achievement
				end

				local first_completed = sub_achievements[1] and sub_achievements[1].completed

				if is_completed or is_meta_achievement or not first_completed then
					achievement_context.sub_achievements = sub_achievements
				else
					achievement_context.widget_type = "normal_achievement"
				end
			else
				achievement_context.widget_type = "normal_achievement"
			end

			local reward_item, item_group = _get_reward_item(achievement)

			if reward_item then
				achievement_context.reward_item = reward_item
				achievement_context.reward_item_group = item_group
				achievement_context.widget_type = "foldout_achievement"
			end

			layout[#layout + 1] = achievement_context
		end
	end

	table.sort(layout, _achievements_sort_function)
	table.insert(layout, 1, _achievement_list_padding)

	layout[#layout + 1] = _achievement_list_padding

	if group_label then
		table.insert(layout, 2, {
			widget_type = "header",
			display_name = group_label
		})
	end

	self._main_grid_layout = layout

	self._grids[ACHIEVEMENT_GRID]:present_grid_layout(layout, blueprints)
end

AchievementsView._populate_categories_column = function (self)
	local categories = self._categories
	local blueprints = self._definitions.blueprints
	local on_selected_callback = callback(self, "_cb_category_selected")
	local on_pressed_callback = callback(self, "_cb_category_pressed")
	local layout = {
		[#layout + 1] = {
			sort_index = 1,
			widget_type = "category_list_padding_top"
		}
	}
	local summary = {
		label = "loc_achievements_view_summary",
		sort_index = 2,
		widget_type = "simple_category_button",
		selected_callback = callback(self, "_cb_summary_selected")
	}
	layout[#layout + 1] = summary

	for id, category in pairs(categories) do
		if category.is_top_category then
			local sub_categories = category.sub_categories
			local widget_type = nil
			local has_sub_categories = sub_categories and #sub_categories > 0
			widget_type = has_sub_categories and "top_category_button" or "simple_category_button"
			local category_context = {
				widget_type = widget_type,
				category = category,
				selected_callback = on_selected_callback,
				has_sub_categories = has_sub_categories,
				sort_index = category.sort_index * 100
			}
			layout[#layout + 1] = category_context

			if has_sub_categories then
				local parent_sort_index = category_context.sort_index
				local parent_original_sort_index = category.sort_index

				for i = 1, #sub_categories do
					local sub_category = sub_categories[i]
					local sub_category_context = {
						widget_type = "sub_category_button",
						category = sub_category,
						parent_category = category,
						selected_callback = on_selected_callback,
						sort_index = parent_sort_index + sub_category.sort_index - parent_original_sort_index
					}
					layout[#layout + 1] = sub_category_context
				end
			end
		end
	end

	table.sort(layout, function (a, b)
		return (a.sort_index or 0) < (b.sort_index or 0)
	end)

	layout[#layout + 1] = {
		widget_type = "category_list_padding_bottom",
		sort_index = (#layout + 1) * 100
	}
	self._categories_layout = layout
	local categories_grid = self._grids[CATEGORIES_GRID]

	categories_grid:present_grid_layout(layout, blueprints, on_pressed_callback)

	local num_achievements_completed = self._num_achievements_completed
	local num_achievements_total = self._num_achievements_total
	local widget = self._widgets_by_name.categories_header
	local completed_widget_content = widget.content
	completed_widget_content.completed = Localize("loc_achievements_view_num_completed", true, {
		completed = num_achievements_completed,
		total = num_achievements_total
	})
	completed_widget_content.total_score = Localize("loc_achievements_view_total_score", true, {
		score = self._total_score
	})
end

AchievementsView._setup_input_legend = function (self)
	local parent = self._parent

	if parent then
		local legend_inputs = self._definitions.legend_inputs
		local legend_input_ids = {}

		for i = 1, #legend_inputs do
			local entry_params = legend_inputs[i]
			legend_input_ids[i] = parent:add_input_legend_entry(entry_params)
		end

		self._legend_input_ids = legend_input_ids
	end
end

AchievementsView._setup_grids = function (self)
	local grid_settings = self._definitions.grid_settings
	local layout_dummy = {}

	for i = 1, #grid_settings do
		local view_element_grid_settings = grid_settings[i]
		local scenegraph_id = view_element_grid_settings.scenegraph_id
		local layer = 1
		local grid = self:_add_element(ViewElementGrid, scenegraph_id, layer, view_element_grid_settings)

		grid:set_empty_message("")
		grid:present_grid_layout(layout_dummy)

		self._grids[i] = grid
	end

	self:_update_grid_positions()
end

AchievementsView._set_achievements_and_categories = function (self, achievements)
	local achievement_types = AchievementUITypes
	local num_achievements_total = 0
	local num_achievements_completed = 0
	local categories = {}
	local completed_achievements = {}
	local achievements_in_progress = {}
	local achievement_categories = AchievementCategories

	for id, category_settings in pairs(achievement_categories) do
		local parent_id = category_settings.parent_name
		local category = categories[id] or {}
		category.id = id
		category.label = category_settings.display_name
		category.achievements = {}
		category.sub_categories = category.sub_categories or {}
		category.is_top_category = parent_id == nil
		category.num_total = 0
		category.num_completed = 0
		category.sort_index = category_settings.sort_index
		categories[id] = category

		if parent_id then
			local parent_category = categories[parent_id]

			if not parent_category then
				parent_category = {
					sub_categories = {}
				}
				categories[parent_id] = parent_category
			end

			local parent_sub_categories = parent_category.sub_categories
			parent_sub_categories[#parent_sub_categories + 1] = category
		end
	end

	local total_score = 0

	for id, achievement in pairs(achievements) do
		num_achievements_total = num_achievements_total + 1
		local category = categories[achievement.category]
		category.achievements[id] = achievement
		category.num_total = category.num_total + 1

		if achievement.completed then
			num_achievements_completed = num_achievements_completed + 1
			category.num_completed = category.num_completed + 1
			completed_achievements[num_achievements_completed] = achievement
			total_score = total_score + achievement.score
		elseif achievement.type == achievement_types.increasing_stat and achievement.progress_current > 0 and not achievement.hidden then
			achievements_in_progress[#achievements_in_progress + 1] = achievement
		end
	end

	table.sort(completed_achievements, _completion_time_sort_function)
	table.sort(achievements_in_progress, _progression_sort_function)

	self._achievements = achievements
	self._completed_achievements = completed_achievements
	self._achievements_in_progress = achievements_in_progress
	self._total_score = total_score
	self._categories = categories
	self._num_achievements_completed = num_achievements_completed
	self._num_achievements_total = num_achievements_total
end

AchievementsView._update_grid_positions = function (self)
	local grid_settings = self._definitions.grid_settings
	local grids = self._grids

	for i = 1, #grids do
		local view_element_grid_settings = grid_settings[i]
		local scenegraph_id = view_element_grid_settings.scenegraph_id
		local position = self:_scenegraph_world_position(scenegraph_id)

		grids[i]:set_pivot_offset(position[1], position[2])
	end
end

return AchievementsView
