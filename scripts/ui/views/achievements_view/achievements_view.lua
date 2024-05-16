-- chunkname: @scripts/ui/views/achievements_view/achievements_view.lua

local AchievementCategories = require("scripts/settings/achievements/achievement_categories")
local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local Definitions = require("scripts/ui/views/achievements_view/achievements_view_definitions")
local InputUtils = require("scripts/managers/input/input_utils")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewStyles = require("scripts/ui/views/achievements_view/achievements_view_styles")
local UISettings = require("scripts/settings/ui/ui_settings")
local CATEGORIES_GRID = 1
local ACHIEVEMENT_GRID = 2
local AchievementsView = class("AchievementsView", "BaseView")

AchievementsView.init = function (self, settings, context)
	AchievementsView.super.init(self, Definitions, settings, context)

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
	self._categories = nil
	self._has_achievements = false
	self._sub_categories = nil
	self._layouts_by_category = {}
	self._achievements_by_category = {}
	self._widgets_by_category = {}
	self._total_score = 0
	self._score_by_category = {}
	self._grids = {}
	self._focused_grid_id = nil
	self._next_category_id = nil
	self._show_summary_next_frame = nil
	self._showing_summary = false
	self._current_favorites = {}
	self._allow_close_hotkey = true

	self:_setup_input_legend()
	self:_setup_grids()
	self:_setup_achievements()
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

AchievementsView._outdated_favorites = function (self)
	local favorite_achievements = Managers.save:account_data().favorite_achievements

	return not table.array_equals(self._current_favorites, favorite_achievements)
end

AchievementsView._update_summary = function (self)
	if not self._showing_summary then
		return
	end

	if self:_outdated_favorites() then
		self:_show_summary()
	end
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

	local category_id = self._current_category_id
	local category_widget = self._widgets_by_category[category_id]
	local gamepad_unfold_hint_widget = self._widgets_by_name.gamepad_unfold_hint
	local unfold_hints_visible = using_gamepad and category_id and self:_visible_sub_category_count(category_id) > 1

	gamepad_unfold_hint_widget.visible = unfold_hints_visible

	if unfold_hints_visible then
		local unfolded = category_widget.content.unfolded
		local button_hint_text = unfolded and "loc_achievements_view_button_hint_fold_category" or "loc_achievements_view_button_hint_unfold_category"
		local gamepad_action = "confirm_pressed"
		local service_type = "View"
		local alias_key = Managers.ui:get_input_alias_key(gamepad_action, service_type)
		local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

		gamepad_unfold_hint_widget.content.text = string.format(Localize("loc_input_legend_text_template"), input_text, Localize(button_hint_text))
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
		elseif input_service:get("confirm_pressed") then
			local grid = self._grids[focused_grid_id]
			local focused_widget = grid:selected_grid_widget()
			local fold_callback = focused_widget and focused_widget.content.fold_callback

			if fold_callback then
				fold_callback()
			end
		elseif input_service:get("secondary_action_pressed") then
			local grid = self._grids[focused_grid_id]
			local focused_widget = grid:selected_grid_widget()
			local change_favorite_callback = focused_widget and focused_widget.content.change_favorite_callback

			if change_favorite_callback then
				change_favorite_callback()
			end
		end
	elseif focused_grid_id == CATEGORIES_GRID then
		if input_service:get("navigate_right_continuous") then
			local grid = self._grids[ACHIEVEMENT_GRID]

			if self._has_achievements and grid:first_interactable_grid_index() then
				focused_grid_id = ACHIEVEMENT_GRID
			else
				self._next_category_id = nil
			end

			grid_has_changed = true
		elseif input_service:get("confirm_pressed") then
			local current_category_id = self._current_category_id

			if current_category_id and self:_visible_sub_category_count(current_category_id) > 1 then
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

AchievementsView._cache_achievements = function (self, player)
	local total_score = 0
	local achievements_by_category = {}
	local achievements_by_recency = {}
	local achievement_definitions = Managers.achievements:achievement_definitions()
	local score_by_category = {}
	local completed_score_by_category = {}

	for _, achievement_config in pairs(achievement_definitions) do
		local achievement_id = achievement_config.id
		local category = achievement_config.category
		local is_completed = Managers.achievements:achievement_completed(player, achievement_id)
		local is_visible = self:_should_display_achievement(player, is_completed, achievement_config)

		if is_visible then
			local _achievements_by_category = achievements_by_category[category] or {}

			_achievements_by_category[#_achievements_by_category + 1] = achievement_id
			achievements_by_category[category] = _achievements_by_category
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

	self._achievements_by_category = achievements_by_category

	for _, achievements in pairs(achievements_by_category) do
		table.sort(achievements, _sort_by_index)
	end

	self._achievements_by_recency = achievements_by_recency

	table.sort(achievements_by_recency, function (a, b)
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

		return b_type_value < a_type_value
	end)

	self._total_score = total_score
	self._score_by_category = score_by_category
	self._completed_score_by_category = completed_score_by_category
end

AchievementsView._category_score = function (self, category_id)
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

AchievementsView._populate_category_grid = function (self, player)
	local on_selected_callback = callback(self, "_cb_category_selected")
	local on_pressed_callback = callback(self, "_cb_category_pressed")
	local layout = {
		{
			widget_type = "category_list_padding_top",
		},
		{
			label = "loc_achievements_view_summary",
			widget_type = "simple_category_button",
			selected_callback = callback(self, "_cb_summary_selected"),
		},
	}
	local original_layout_size = #layout
	local widgets_by_category = self._widgets_by_category
	local current_largest_index = 0

	for category_id, category_config in pairs(AchievementCategories) do
		local index = original_layout_size + category_config.sort_index
		local parent_name = category_config.parent_name
		local is_top_category = parent_name == nil
		local widget_type

		if is_top_category then
			local sub_category_count = self:_visible_sub_category_count(category_id)

			widget_type = sub_category_count > 1 and "top_category_button" or "simple_category_button"
		else
			widget_type = "sub_category_button"
		end

		local percent_done
		local score, completed_score = self:_category_score(category_id)

		if score > 0 then
			percent_done = math.round(100 * completed_score / score)
		end

		local is_only_child = self:_visible_sub_category_count(parent_name) == 1
		local is_visible = self:_is_category_visible(category_id)

		if is_visible and not is_only_child then
			layout[index] = {
				widget_type = widget_type,
				category = category_id,
				label = category_config.display_name,
				selected_callback = on_selected_callback,
				parent_name = parent_name,
				percent_done = percent_done,
				widgets_by_category = widgets_by_category,
			}
			current_largest_index = math.max(current_largest_index, index)
		end
	end

	for i = 2, current_largest_index do
		local j = i

		while j - 1 >= 1 and layout[j - 1] == nil do
			layout[j - 1] = layout[j]
			layout[j] = nil
			j = j - 1
		end
	end

	layout[#layout + 1] = {
		widget_type = "category_list_padding_bottom",
	}

	local blueprints = self._definitions.blueprints
	local categories_grid = self._grids[CATEGORIES_GRID]

	categories_grid:present_grid_layout(layout, blueprints, on_pressed_callback)

	local total_score = self._total_score
	local widget = self._widgets_by_name.categories_header
	local completed_widget_content = widget.content

	completed_widget_content.total_score = Localize("loc_achievements_view_total_score", true, {
		score = total_score,
	})
end

AchievementsView._first_visible_sub_category = function (self, category_id)
	local sub_category = self._sub_categories[category_id]
	local sub_category_count = sub_category and #sub_category or 0

	for i = 1, sub_category_count do
		local sub_category_id = sub_category[i]

		if self:_is_category_visible(sub_category_id) then
			return sub_category_id
		end
	end
end

AchievementsView._visible_sub_category_count = function (self, category_id)
	local sub_category = self._sub_categories[category_id]
	local sub_category_count = sub_category and #sub_category or 0
	local visible_sub_category = 0

	for i = 1, sub_category_count do
		local sub_category_id = sub_category[i]

		if self:_is_category_visible(sub_category_id) then
			visible_sub_category = visible_sub_category + 1
		end
	end

	return visible_sub_category
end

AchievementsView._is_category_visible = function (self, category_id)
	local category_config = AchievementCategories[category_id]
	local parent_name = category_config.parent_name
	local is_top_category = parent_name == nil
	local achievement_ids = self._achievements_by_category[category_id]
	local achievement_ids_count = achievement_ids and #achievement_ids or 0
	local is_visible = achievement_ids_count > 0 or is_top_category

	return is_visible
end

AchievementsView._cache_sub_categories = function (self)
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

AchievementsView._setup_achievements = function (self)
	local player = Managers.player:local_player(1)

	self:_cache_sub_categories()
	self:_cache_achievements(player)
	self:_populate_category_grid(player)
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

	if focused_grid_id == nil then
		return false
	end

	local grid = self._grids[focused_grid_id]
	local widget = grid:selected_grid_widget()

	return widget and widget.content.unfolded == should_be_unfolded
end

AchievementsView._cb_favorite_legend_visibility = function (self, add_to_favorite)
	local using_cursor_navigation = self._using_cursor_navigation
	local currently_tracked, can_track = AchievementUIHelper.favorite_achievement_count()

	if add_to_favorite and can_track <= currently_tracked then
		return false
	end

	local focused_grid_id = self._focused_grid_id

	if not using_cursor_navigation and focused_grid_id ~= ACHIEVEMENT_GRID then
		return false
	end

	local widget
	local grid = self._grids[ACHIEVEMENT_GRID]

	if using_cursor_navigation then
		widget = grid:hovered_widget()
	else
		widget = grid:selected_grid_widget()
	end

	local is_favorite = widget and widget.content.is_favorite

	return is_favorite ~= nil and is_favorite ~= add_to_favorite
end

AchievementsView._cb_category_pressed = function (self, widget, config)
	local category_id = config.category
	local visible_sub_category_count = self:_visible_sub_category_count(category_id)

	if visible_sub_category_count > 1 and self._using_cursor_navigation then
		self:_fold_or_unfold_subcategories(category_id)
	else
		local grid = self._grids[CATEGORIES_GRID]
		local grid_index = grid:widget_index(widget)

		grid:select_grid_index(grid_index)
	end
end

AchievementsView._update_current_category = function (self)
	if self._show_summary_next_frame then
		self:_show_summary()

		self._show_summary_next_frame = nil
		self._current_category_id = nil
		self._has_achievements = true
		self._next_category_id = nil

		self:_on_navigation_input_changed()
	end

	local next_category_id = self._next_category_id

	if next_category_id then
		self._showing_summary = false

		if next_category_id ~= self._current_category_id then
			self:_populate_achievements_grid(next_category_id)

			self._has_achievements = true
			self._current_category_id = next_category_id
		end

		self._next_category_id = nil
		self._show_summary_next_frame = nil

		self:_on_navigation_input_changed()
	end

	self:_update_summary()
end

AchievementsView._fold_or_unfold_subcategories = function (self, category_id)
	local widgets_by_category = self._widgets_by_category
	local sub_categories = self._sub_categories[category_id]
	local category_widget = widgets_by_category[category_id]

	if not sub_categories or #sub_categories == 0 then
		Log.warning("AchievementsView", "Trying to fold / unfold category '%s' without subcategories.", category_id)

		return
	end

	local top_category_content = category_widget.content
	local unfolded = not top_category_content.unfolded

	top_category_content.unfolded = unfolded

	local top_category_style = category_widget.style
	local arrow_style = top_category_style.arrow

	arrow_style.angle = math.degrees_to_radians(unfolded and 90 or -90)

	self:_play_sound(unfolded and arrow_style.unfold_sound or arrow_style.fold_sound)

	for i = 1, #sub_categories do
		local sub_category_id = sub_categories[i]
		local widget = widgets_by_category[sub_category_id]

		if widget and widget.visible ~= unfolded then
			widget.visible = unfolded

			local widget_style = widget.style
			local widget_content = widget.content

			widget_content.size = unfolded and widget_style.unfolded_size or widget_style.folded_size
		end
	end

	local categories_grid = self._grids[CATEGORIES_GRID]

	categories_grid:force_update_list_size_keeping_scroll()
end

AchievementsView._show_summary = function (self)
	local player = Managers.player:local_player(1)
	local blueprints = self._definitions.blueprints
	local layout = self._summary_layout
	local achievement_definitions = Managers.achievements:achievement_definitions()

	if not layout or self:_outdated_favorites() then
		layout = {}
		layout[#layout + 1] = {
			widget_type = "list_padding",
		}
		layout[#layout + 1] = {
			display_name = "loc_achievements_view_summary_completed",
			widget_type = "header",
		}

		local completed_achievements = self._achievements_by_recency

		for i = 1, ViewStyles.achievement_summary.num_completed_to_show do
			local achievement_id = completed_achievements[i]

			if achievement_id then
				local achievement = achievement_definitions[achievement_id]

				layout[#layout + 1] = {
					block_folding = true,
					is_complete = true,
					widget_type = "achievement",
					player = player,
					achievement_definition = achievement,
				}
			else
				layout[#layout + 1] = {
					widget_type = "empty_space",
				}
			end
		end

		local max_favorite_achievements = UISettings.max_favorite_achievements
		local favorite_achievements = Managers.save:account_data().favorite_achievements

		for i = #favorite_achievements, 1, -1 do
			local achievement_id = favorite_achievements[i]
			local achievement_definition = achievement_definitions[achievement_id]

			if not achievement_definition then
				AchievementUIHelper.remove_favorite_achievement(achievement_id)
				table.remove(favorite_achievements, i)
			end
		end

		layout[#layout + 1] = {
			display_name = "loc_achievements_view_summary_favorite",
			widget_type = "header",
			localization_options = {
				current = #favorite_achievements,
				cap = max_favorite_achievements,
			},
		}

		for i = 1, max_favorite_achievements do
			local achievement_id = favorite_achievements[i]
			local achievement = achievement_definitions[achievement_id]

			if achievement then
				local is_complete = Managers.achievements:achievement_completed(player, achievement_id)

				layout[#layout + 1] = {
					block_folding = true,
					widget_type = "achievement",
					player = player,
					achievement_definition = achievement,
					is_complete = is_complete,
				}
			elseif i == 1 then
				layout[#layout + 1] = {
					display_name = "loc_achievements_view_summary_empty_favorite",
					widget_type = "description",
				}
			else
				layout[#layout + 1] = {
					widget_type = "empty_space",
				}
			end
		end

		self._summary_layout = layout
		self._current_favorites = table.shallow_copy(favorite_achievements)
	end

	if self._focused_grid_id ~= CATEGORIES_GRID then
		self._focused_grid_id = CATEGORIES_GRID

		self:_on_navigation_input_changed()
	end

	self._showing_summary = true

	self._grids[ACHIEVEMENT_GRID]:present_grid_layout(layout, blueprints)
end

AchievementsView._should_display_achievement = function (self, player, is_complete, achievement_definition)
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

AchievementsView._populate_achievements_grid = function (self, category_id)
	local player = Managers.player:local_player(1)
	local cache_category_id = category_id
	local visible_sub_category_count = self:_visible_sub_category_count(category_id)

	if visible_sub_category_count == 1 then
		category_id = self:_first_visible_sub_category(category_id)
	end

	local achievement_ids = self._achievements_by_category[category_id]
	local achievement_ids_count = achievement_ids and #achievement_ids or 0
	local category_label = AchievementCategories[category_id].display_name
	local cached_layout = self._layouts_by_category[cache_category_id]

	if cached_layout then
		local blueprints = self._definitions.blueprints
		local achievement_grid = self._grids[ACHIEVEMENT_GRID]

		achievement_grid:present_grid_layout(cached_layout, blueprints)

		return
	end

	if achievement_ids_count == 0 then
		local blueprints = self._definitions.blueprints
		local achievement_grid = self._grids[ACHIEVEMENT_GRID]

		achievement_grid:present_grid_layout({}, blueprints)

		return
	end

	local layout = {
		{
			widget_type = "list_padding",
		},
		{
			widget_type = "header",
			display_name = category_label,
		},
	}
	local layout_size = #layout
	local achievement_definitions = Managers.achievements:achievement_definitions()

	for i = 1, achievement_ids_count do
		local achievement_id = achievement_ids[i]
		local achievement_definition = achievement_definitions[achievement_id]
		local is_complete = Managers.achievements:achievement_completed(player, achievement_id)
		local should_display = true

		if should_display then
			local widget = {
				block_folding = false,
				widget_type = "achievement",
				player = player,
				achievement_definition = achievement_definition,
				is_complete = is_complete,
			}

			layout_size = layout_size + 1
			layout[layout_size] = widget
		end
	end

	layout_size = layout_size + 1
	layout[layout_size] = {
		widget_type = "list_padding",
	}
	self._layouts_by_category[cache_category_id] = layout

	local blueprints = self._definitions.blueprints
	local achievement_grid = self._grids[ACHIEVEMENT_GRID]

	achievement_grid:present_grid_layout(layout, blueprints)
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
