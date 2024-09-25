-- chunkname: @scripts/ui/views/group_finder_view/group_finder_view.lua

local GroupFinderViewDefinitions = require("scripts/ui/views/group_finder_view/group_finder_view_definitions")
local TextUtils = require("scripts/utilities/ui/text")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local PlayerCompositions = require("scripts/utilities/players/player_compositions")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Promise = require("scripts/foundation/utilities/promise")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local TextUtilities = require("scripts/utilities/ui/text")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementMissionBoardOptions = require("scripts/ui/view_elements/view_element_mission_board_options/view_element_mission_board_options")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local RegionLocalizationMappings = require("scripts/settings/backend/region_localization")
local ProfileUtils = require("scripts/utilities/profile_utils")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local GroupFinderView = class("GroupFinderView", "BaseView")
local STATE = table.enum("idle", "fetching_tags", "browsing", "advertising")
local settings_by_category = {
	start_group = {
		text = Localize("loc_group_finder_category_start_group"),
	},
	game_mode = {
		description_sort_order = 3,
		text = Localize("loc_group_finder_category_game_mode"),
	},
	difficulty = {
		description_sort_order = 4,
		text = Localize("loc_group_finder_category_difficulty"),
	},
	language = {
		description_sort_order = 1,
		text = Localize("loc_group_finder_category_language"),
	},
	key_words = {
		description_sort_order = 2,
		text = Localize("loc_group_finder_category_key_words"),
	},
}

local function _tags_sort_function(a, b)
	local a_ui_category = a.ui_category
	local a_category_settings = a_ui_category and settings_by_category[a_ui_category]
	local a_description_sort_order = a_category_settings and a_category_settings.description_sort_order or math.huge
	local b_ui_category = b.ui_category
	local b_category_settings = b_ui_category and settings_by_category[b_ui_category]
	local b_description_sort_order = b_category_settings and b_category_settings.description_sort_order or math.huge

	if a_description_sort_order == b_description_sort_order then
		return a.name < b.name
	end

	return a_description_sort_order < b_description_sort_order
end

local REQUEST_DURATION = 90

GroupFinderView.init = function (self, settings, context)
	self._state = STATE.idle
	self._selected_tags = {}
	self._selected_tags_by_name = {}
	self._is_party_full = false
	self._groups = {}
	self._sent_requests = {}
	self._sent_requests_duration = {}
	self._advertisement_join_requests_version = -1
	self._lowest_party_member_level = 0
	self._highest_tag_level_requirement = 0
	self._anim_preview_progress = 1
	self._visited_tag_pages = {
		{},
	}
	self._promises = {}
	self._regions_latency = {}
	self._show_group_loading = false
	self._player_request_button_accept_input_action = "confirm_pressed"
	self._player_request_button_decline_input_action = "hotkey_menu_special_1"
	self._refresh_button_input_action = "group_finder_refresh_groups"
	self._preview_button_input_action = "group_finder_group_inspect"
	self._start_group_button_input_action = "hotkey_menu_special_2"
	self._cancel_group_button_input_action = "hotkey_menu_special_2"
	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	GroupFinderView.super.init(self, GroupFinderViewDefinitions, settings, context)

	self._pass_input = false
	self._pass_draw = false
	self._allow_close_hotkey = false
end

GroupFinderView.on_enter = function (self)
	GroupFinderView.super.on_enter(self)

	local definitions = self._definitions

	if definitions.background_world_params then
		self:_setup_background_world(definitions.background_world_params)
	end

	self:_setup_widgets_stating_states()
	self:_set_group_list_empty_info_visibility(false)
	self:_update_refresh_button_text()
	self:_update_preview_input_text()
	self:_update_player_request_button_accept()
	self:_update_player_request_button_decline()
	self:_create_group_loading_widget()

	local input_legend_params = self._definitions.input_legend_params

	if input_legend_params then
		self:_setup_input_legend(input_legend_params)
	end

	self:_set_state(STATE.fetching_tags)

	self._enter_animation_id = self:_start_animation("on_enter", self._widgets_by_name, self)

	self:_register_event(PlayerCompositions.player_composition_changed_event, "event_party_composition_changed")
end

GroupFinderView._setup_widgets_stating_states = function (self)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.join_button.content.hotspot.pressed_callback = callback(self, "_cb_on_join_button_pressed")
	widgets_by_name.join_button.content.hotspot.disabled = true
	widgets_by_name.player_request_button_accept.style.text.text_horizontal_alignment = "right"
	widgets_by_name.player_request_button_decline.style.text.text_horizontal_alignment = "right"
	widgets_by_name.refresh_button.style.text.text_horizontal_alignment = "right"
	widgets_by_name.refresh_button.content.hotspot.pressed_callback = callback(self, "_cb_on_refresh_button_pressed")
	widgets_by_name.start_group_button.content.hotspot.pressed_callback = callback(self, "_cb_on_start_group_button_pressed")
	widgets_by_name.previous_filter_button.content.hotspot.pressed_callback = callback(self, "_cb_on_previous_filter_button_pressed")

	ButtonPassTemplates.terminal_button_hold_small.init(self, self._widgets_by_name.cancel_group_button, self._ui_renderer, {
		keep_hold_active = true,
		timer = 0.5,
		text = Utf8.upper(Localize("loc_group_finder_cancel_group_button")),
		complete_function = callback(self, "_cb_on_cancel_group_button_pressed"),
		input_action = self._cancel_group_button_input_action .. "_hold",
		start_input_action = self._cancel_group_button_input_action,
	})

	widgets_by_name.join_button_level_warning.content.level_requirement_met = true

	self:_set_preview_grid_visibility(false)

	self._side_widgets_by_state = {
		[STATE.browsing] = {
			widgets_by_name.start_group_button_level_warning,
			widgets_by_name.start_group_button_party_full_warning,
			widgets_by_name.start_group_button,
			widgets_by_name.previous_filter_button,
			widgets_by_name.start_group_button_header,
			widgets_by_name.category_description,
			widgets_by_name.filter_page_divider_top,
			widgets_by_name.filter_page_divider_bottom,
		},
		[STATE.advertising] = {
			widgets_by_name.player_request_window,
			widgets_by_name.created_group_party_title,
			widgets_by_name.cancel_group_button,
			widgets_by_name.team_member_1,
			widgets_by_name.team_member_2,
			widgets_by_name.team_member_3,
			widgets_by_name.team_member_4,
			widgets_by_name.own_group_presentation,
			widgets_by_name.player_request_button_accept,
			widgets_by_name.player_request_button_decline,
		},
	}
end

GroupFinderView._setup_input_legend = function (self, input_legend_params)
	if self:_element("input_legend") then
		self:_remove_element("input_legend")
	end

	local layer = input_legend_params.layer or 10

	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", layer)

	local buttons_params = input_legend_params.buttons_params

	for i = 1, #buttons_params do
		local legend_input = buttons_params[i]

		self:add_input_legend_entry(legend_input)
	end
end

GroupFinderView.add_input_legend_entry = function (self, entry_params)
	local input_legend = self:_element("input_legend")
	local press_callback
	local on_pressed_callback = entry_params.on_pressed_callback

	if on_pressed_callback then
		local callback_parent = self[on_pressed_callback] and self or nil

		if not callback_parent and self._active_view then
			local view_instance = self._active_view and Managers.ui:view_instance(self._active_view)

			callback_parent = view_instance
		end

		press_callback = callback_parent and callback(callback_parent, on_pressed_callback)
	end

	local display_name = entry_params.display_name
	local input_action = entry_params.input_action
	local visibility_function = entry_params.visibility_function
	local alignment = entry_params.alignment
	local suffix_function = entry_params.suffix_function

	return input_legend:add_entry(display_name, input_action, visibility_function, press_callback, alignment, nil, nil, nil, suffix_function)
end

GroupFinderView._create_group_loading_widget = function (self)
	local widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(127.5, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/loading/loading_icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					256,
					256,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "group_loading")

	self._group_loading_widget = self:_create_widget("loading", widget_definition)
end

GroupFinderView._update_group_loading_widget = function (self, dt)
	if not self._group_loading_widget then
		return
	end

	local anim_speed = 4

	if anim_speed then
		local group_loading_anim_progress = self._group_loading_anim_progress or 0

		if self._show_group_loading then
			group_loading_anim_progress = math.min(group_loading_anim_progress + dt * anim_speed, 1)
		else
			group_loading_anim_progress = math.max(group_loading_anim_progress - dt * anim_speed, 0)
		end

		self._group_loading_anim_progress = group_loading_anim_progress
	end

	self._group_loading_widget.alpha_multiplier = self._group_loading_anim_progress or 0
end

GroupFinderView._setup_background_world = function (self, world_params)
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

GroupFinderView.event_register_camera = function (self, camera_unit)
	local world_params = self._definitions.background_world_params

	self:_unregister_event(world_params.register_camera_event)

	local viewport_name = world_params.viewport_name or self.view_name .. "_viewport"
	local viewport_type = world_params.viewport_type or "default"
	local viewport_layer = world_params.viewport_layer or 1
	local shading_environment = world_params.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
end

GroupFinderView._get_group_finder_tags = function (self)
	local function format_response(response)
		if not response or not response.tags then
			Log.error("GroupFinderView", "Invalid response: response or response.tags is nil")

			return {}
		end

		local formatted_response = {}
		local formatted_response_by_name = {}
		local parents_map = {}
		local response_tags = response.tags.tags

		for _, tag in ipairs(response_tags) do
			local formatted_tag = {
				name = tag.name,
				locked = tag.locked,
				level_requirement = tag.levelRequirement,
				mutually_exclusive = tag.mutuallyExclusive,
				unlocks = tag.unlocks,
				pattern = tag.pattern,
				root_tag = tag.rootTag,
				display_mode = tag.display and tag.display.mode,
				ui_category = tag.display and tag.display.uiGroup,
				widget_type = tag.display and tag.display.widgetType,
				header = tag.display and tag.display.header,
				text = tag.display and tag.display.text and Localize(tag.display.text) or "",
				background_texture = tag.display and tag.display.backgroundTexture,
				difficulty = tag.display and tag.display.difficulty,
				difficulty_board = tag.display and tag.display.difficulty_board,
			}

			if tag.unlocks then
				for _, child_name in ipairs(tag.unlocks) do
					if not parents_map[child_name] then
						parents_map[child_name] = {}
					end

					table.insert(parents_map[child_name], tag.name)
				end
			end

			table.insert(formatted_response, formatted_tag)

			formatted_response_by_name[tag.name] = formatted_tag
		end

		for _, tag in ipairs(formatted_response) do
			if tag.locked and parents_map[tag.name] then
				tag.parents = parents_map[tag.name]
			end
		end

		for _, tag in ipairs(formatted_response) do
			if not tag.root_tag then
				local unlocks = tag.unlocks

				if unlocks then
					local mutually_exclusive = tag.mutually_exclusive

					if mutually_exclusive then
						local mutually_exclusive_additions = {}

						for _, mutually_exclusive_tag_name in ipairs(mutually_exclusive) do
							local mutually_exclusive_tag = formatted_response_by_name[mutually_exclusive_tag_name]
							local mutually_exclusive_tag_unlocks = mutually_exclusive_tag.unlocks

							if mutually_exclusive_tag_unlocks then
								for _, key in ipairs(mutually_exclusive_tag_unlocks) do
									if not table.contains(unlocks, key) then
										mutually_exclusive_additions[key] = true
									end
								end
							end
						end

						for key, _ in pairs(mutually_exclusive_additions) do
							if not table.contains(mutually_exclusive, key) then
								mutually_exclusive[#mutually_exclusive + 1] = key
							end
						end
					end
				end
			end
		end

		for _, tag in ipairs(formatted_response) do
			local tag_name = tag.name

			if not tag.root_tag then
				local mutually_exclusive = tag.mutually_exclusive or {}

				for _, inspect_tag in ipairs(formatted_response) do
					if inspect_tag.mutually_exclusive and table.contains(inspect_tag.mutually_exclusive, tag_name) and not table.contains(mutually_exclusive, inspect_tag.name) then
						table.insert(mutually_exclusive, inspect_tag.name)
					end
				end

				if table.size(mutually_exclusive) > 0 then
					tag.mutually_exclusive = mutually_exclusive
				end
			end
		end

		return formatted_response
	end

	local promise = self:_cancel_promise_on_exit(Managers.data_service.social:get_group_finder_tags():next(function (response)
		return response
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("GroupFinderView", "Error fetching groupfinder tags: %s", error_string)

		return {}
	end))

	return promise:next(function (response)
		return format_response(response)
	end)
end

GroupFinderView._on_fetching_tags_complete = function (self)
	local visited_tag_pages = self._visited_tag_pages

	for _, tag in ipairs(self._tags) do
		local root_tag = tag.root_tag

		if root_tag then
			table.insert(visited_tag_pages[1], tag)
		end
	end

	local save_manager = Managers.save
	local player = self:_player()
	local character_id = player:character_id()
	local save_data = save_manager:character_data(character_id)
	local group_finder_search_tags = save_data and save_data.group_finder_search_tags

	if group_finder_search_tags then
		for i = #group_finder_search_tags, 1, -1 do
			local tag_name = group_finder_search_tags[i]
			local tag = self:_get_tag_by_name(tag_name)

			if tag then
				local can_select_tag = self:_can_select_tag(tag)

				if can_select_tag then
					self:_add_selected_tag(tag)
				else
					table.remove(group_finder_search_tags, i)
				end
			else
				table.remove(group_finder_search_tags, i)
			end
		end
	end

	self:_update_tag_grid()
	self:_update_tag_navigation_buttons_status()

	local party_immaterium = Managers.party_immaterium

	if party_immaterium and party_immaterium:is_party_advertisement_active() then
		self:_set_state(STATE.advertising)
	else
		self:_set_state(STATE.browsing)
	end
end

GroupFinderView._get_tag_depth = function (self, current_tag)
	local function get_max_depth(tag_name, current_depth)
		current_depth = current_depth or 0

		local tags = self._group_finder_tags_data
		local found_depth

		for _, tag in ipairs(tags) do
			if tag.name == tag_name then
				found_depth = current_depth

				if tag.unlocks then
					for _, unlocked_tag_name in ipairs(tag.unlocks) do
						local depth = get_max_depth(unlocked_tag_name, current_depth + 1)

						if depth and (not found_depth or found_depth < depth) then
							found_depth = depth
						end
					end
				end
			end
		end

		return found_depth
	end

	return get_max_depth(current_tag, 1)
end

GroupFinderView._get_visited_tag_pages = function (self)
	return self._visited_tag_pages
end

GroupFinderView._get_page_descripion_by_category = function (self, category_name)
	local category_settings = settings_by_category[category_name]
	local description = category_settings and category_settings.text or "n/a"

	return description
end

local _temp_used_header_list = {}

GroupFinderView._get_layout_by_tags = function (self, tags, grid_size, tags_layout, is_preview)
	table.clear(_temp_used_header_list)

	tags_layout = tags_layout or {}

	if not is_preview then
		tags_layout[#tags_layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				15,
			},
		}
	end

	local player = self:_player()
	local profile = player:profile()
	local current_level = profile and profile.current_level or 0
	local num_tags = #tags

	for i = 1, num_tags do
		local tag = tags[i]
		local layout_data = {}

		if not is_preview then
			local header = tag.header

			if header and not _temp_used_header_list[header] then
				_temp_used_header_list[header] = true
				tags_layout[#tags_layout + 1] = {
					widget_type = "header",
					text = Localize(header),
					size = {
						grid_size[1],
						100,
					},
				}
				tags_layout[#tags_layout + 1] = {
					widget_type = "dynamic_spacing",
					size = {
						grid_size[1],
						30,
					},
				}
			end
		end

		local widget_type = is_preview and "tag_preview" or tag.widget_type
		local small_spacing = widget_type == "tag_checkbox"

		layout_data.is_preview = is_preview
		layout_data.widget_type = widget_type or "tag_default"
		layout_data.text = tag.text
		layout_data.tag = tag

		local level_requirement = tag.level_requirement or 0
		local level_requirement_met = is_preview or level_requirement <= current_level

		layout_data.required_level = not level_requirement_met and level_requirement
		layout_data.level_requirement_met = level_requirement_met
		layout_data.dynamic_size = false
		layout_data.size = {
			grid_size[1],
			small_spacing and 40 or nil,
		}

		if not is_preview then
			layout_data.pressed_callback = callback(self, "_cb_on_list_tag_pressed", layout_data)
		end

		if layout_data.widget_type == "tag_slot_button" then
			layout_data.get_selected_unlocks_tags = callback(function ()
				return self:get_selected_unlocks_by_tag(tag)
			end)
		end

		tags_layout[#tags_layout + 1] = layout_data

		if not is_preview and i < num_tags then
			tags_layout[#tags_layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					10,
					small_spacing and 15 or 30,
				},
			}
		end
	end

	if not is_preview then
		tags_layout[#tags_layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				grid_size[1],
				15,
			},
		}
	end

	return tags_layout
end

GroupFinderView.allow_close_hotkey = function (self)
	return self._allow_close_hotkey and self:using_cursor_navigation()
end

GroupFinderView.cb_on_clear_pressed = function (self)
	local selected_tags = self._selected_tags

	if #selected_tags == 0 then
		return
	end

	local selected_tags_by_name = self._selected_tags_by_name

	table.clear(selected_tags)
	table.clear(selected_tags_by_name)

	self._highest_tag_level_requirement = self:_get_highest_tag_level_requirement(self._selected_tags)

	local clear_slot_widgets = true

	self:_update_tag_widgets(clear_slot_widgets)
	self:_reset_search()
	self:_update_tag_navigation_buttons_status()
	self:_play_sound(UISoundEvents.group_finder_filter_list_tag_deselected)
end

GroupFinderView.cb_handle_back_pressed = function (self)
	local visited_tag_pages = self:_get_visited_tag_pages()

	if #visited_tag_pages >= 2 then
		visited_tag_pages[#visited_tag_pages] = nil

		self:_update_tag_grid()
		self:_update_tag_navigation_buttons_status()
		self:_play_sound(UISoundEvents.group_finder_filter_list_back)
	elseif self:can_exit() then
		local view_name = self.view_name

		Managers.ui:close_view(view_name)
	end
end

GroupFinderView._handle_input = function (self, input_service, dt, t)
	local state = self._state
	local using_cursor_navigation = self:using_cursor_navigation()
	local wanted_preview_group_id

	if not using_cursor_navigation then
		local tags_grid = self._tags_grid
		local group_grid = self._group_grid
		local player_request_grid = self._player_request_grid

		if state == STATE.advertising then
			local input_handled = false

			if player_request_grid and not input_handled then
				local selected_grid_widget = player_request_grid:selected_grid_widget()
				local selected_grid_element = selected_grid_widget and selected_grid_widget.content.element

				if selected_grid_element then
					local player_request_button_accept_input_action = self._player_request_button_accept_input_action

					if not input_handled and input_service:get(player_request_button_accept_input_action) then
						self:_cb_on_player_request_accept_pressed(selected_grid_element)

						input_handled = true
					end

					local player_request_button_decline_input_action = self._player_request_button_decline_input_action

					if not input_handled and input_service:get(player_request_button_decline_input_action) then
						self:_cb_on_player_request_decline_pressed(selected_grid_element)
					end
				end
			end
		elseif state == STATE.browsing then
			if input_service:get(self._preview_button_input_action) then
				wanted_preview_group_id = self._selected_group_id
			end

			if group_grid then
				if self._previewed_group_id then
					if group_grid:is_gamepad_scrolling_enabled() then
						group_grid:set_enable_gamepad_scrolling(false)
					end
				elseif not group_grid:is_gamepad_scrolling_enabled() then
					group_grid:set_enable_gamepad_scrolling(true)
				end
			end

			if tags_grid:selected_grid_index() then
				if input_service:get("navigate_right_continuous") and group_grid and #group_grid:widgets() > 0 then
					tags_grid:select_grid_index(nil)
					group_grid:select_first_index()
				end
			elseif group_grid:selected_grid_index() and input_service:get("navigate_left_continuous") and self._can_leave_group_grid_selection then
				group_grid:select_grid_index(nil)
				tags_grid:select_first_index()
			end

			local refresh_button_input_action = self._refresh_button_input_action

			if input_service:get(refresh_button_input_action) then
				self:_cb_on_refresh_button_pressed()
			end

			local start_group_button_input_action = self._start_group_button_input_action

			if input_service:get(start_group_button_input_action) then
				self:_cb_on_start_group_button_pressed()
			end
		end
	elseif state == STATE.browsing then
		local refresh_button_input_action = self._refresh_button_input_action

		if input_service:get(refresh_button_input_action) then
			self:_cb_on_refresh_button_pressed()
		end

		local group_grid = self._group_grid

		if group_grid and input_service:get(self._preview_button_input_action) then
			local hovered_group_id
			local hovered_grid_index = group_grid:hovered_grid_index()

			if hovered_grid_index then
				local selected_widget = hovered_grid_index and group_grid:widget_by_index(hovered_grid_index)

				if selected_widget then
					local content = selected_widget.content
					local element = content.element

					hovered_group_id = element and element.group_id
				end
			end

			wanted_preview_group_id = hovered_group_id or self._selected_group_id
		end
	end

	if wanted_preview_group_id ~= self._previewed_group_id then
		self:_setup_group_preview(wanted_preview_group_id)
	end

	local tags_grid = self._tags_grid

	if tags_grid then
		if self._previewed_group_id then
			tags_grid:disable_input(true)
		else
			tags_grid:disable_input(false)
		end
	end

	self:_handle_group_list_input(input_service)
end

GroupFinderView._handle_group_list_input = function (self, input_service)
	local widgets_by_name = self._widgets_by_name
	local join_button = widgets_by_name.join_button
	local button_disabled = true
	local selected_group_id = self._selected_group_id

	if selected_group_id then
		local group_grid = self._group_grid

		if group_grid then
			local grid_widgets = group_grid:widgets()

			for i = 1, #grid_widgets do
				local grid_widget = grid_widgets[i]
				local content = grid_widget.content
				local group_id = content.group_id

				if group_id == selected_group_id then
					if not content.use_overlay then
						button_disabled = false
					end

					break
				end
			end
		end
	end

	local selected_group_level_requirement_met = self._selected_group_level_requirement_met

	button_disabled = button_disabled or selected_group_level_requirement_met == false
	join_button.content.hotspot.disabled = button_disabled
end

GroupFinderView._respond_to_join_request = function (self, element, accept)
	local party_immaterium = Managers.party_immaterium

	if not party_immaterium then
		return
	end

	self:_play_sound(UISoundEvents.group_finder_request_button_decline)

	local join_request = element.join_request
	local account_id = join_request.account_id
	local party_id = self:party_id()
	local promise, id = party_immaterium:party_finder_respond_to_join_request(party_id, account_id, accept)

	self:_cancel_promise_on_exit(promise)
end

GroupFinderView._cb_on_player_request_accept_pressed = function (self, element)
	self:_play_sound(UISoundEvents.group_finder_request_button_accept)
	self:_respond_to_join_request(element, true)
end

GroupFinderView._cb_on_player_request_decline_pressed = function (self, element)
	self:_respond_to_join_request(element, false)
end

GroupFinderView._is_tag_mutually_exclusive_with_current_selection = function (self, tag)
	local is_mutually_exclusive = false
	local deselection_allowed = true
	local mutually_exclusive = tag.mutually_exclusive

	if mutually_exclusive then
		for i = 1, #mutually_exclusive do
			local mutually_exclusive_tag_name = mutually_exclusive[i]
			local mutually_exclusive_tag = self:_get_tag_by_name(mutually_exclusive_tag_name)

			if self:_is_tag_name_selected(mutually_exclusive_tag_name) then
				local parents = mutually_exclusive_tag.parents

				if parents then
					is_mutually_exclusive = true

					if tag.ui_category ~= mutually_exclusive_tag.ui_category then
						deselection_allowed = false
					end
				end
			end
		end
	end

	return is_mutually_exclusive, deselection_allowed
end

local _temp_return_value_by_visisted_tag = {}

GroupFinderView._can_select_tag = function (self, tag, _ignore_tag_name)
	local tag_name = tag.name

	if tag.root_tag then
		return false
	end

	if not _ignore_tag_name then
		table.clear(_temp_return_value_by_visisted_tag)
	end

	if _temp_return_value_by_visisted_tag[tag_name] ~= nil then
		return _temp_return_value_by_visisted_tag[tag_name]
	end

	local character_level = self:character_level()
	local level_requirement = tag.level_requirement or 0
	local level_requirement_met = level_requirement <= character_level

	if not level_requirement_met then
		_temp_return_value_by_visisted_tag[tag_name] = false

		return false
	end

	local tag_is_already_selected = self:_is_tag_name_selected(tag_name)

	if tag_is_already_selected then
		_temp_return_value_by_visisted_tag[tag_name] = false

		return false
	end

	local has_mutually_exclusive_selections, _ = self:_is_tag_mutually_exclusive_with_current_selection(tag)

	if has_mutually_exclusive_selections then
		_temp_return_value_by_visisted_tag[tag_name] = false

		return false
	end

	local parents = tag.parents

	if parents then
		local only_root_tag_parents = true
		local has_available_parent_path = false

		for i = 1, #parents do
			local parent_name = parents[i]
			local parent_tag = self:_get_tag_by_name(parent_name)

			if not parent_tag.root_tag then
				only_root_tag_parents = false

				if self:_is_tag_name_selected(parent_name) then
					_temp_return_value_by_visisted_tag[tag_name] = true

					return true
				elseif self:_can_select_tag(parent_tag, tag_name) then
					has_available_parent_path = true
				end
			end
		end

		if not only_root_tag_parents then
			_temp_return_value_by_visisted_tag[tag_name] = has_available_parent_path

			return has_available_parent_path
		end
	end

	_temp_return_value_by_visisted_tag[tag_name] = true

	return true
end

GroupFinderView._cb_on_list_tag_pressed = function (self, element)
	if not element.level_requirement_met then
		return
	end

	local tag = element.tag
	local pressed_tag_name = tag.name
	local can_select_tag = self:_can_select_tag(tag)

	if can_select_tag then
		if self:_add_selected_tag(tag) then
			self:_play_sound(UISoundEvents.group_finder_filter_list_tag_selected)
		end
	elseif self:_is_tag_name_selected(pressed_tag_name) then
		if self:_remove_selected_tag(tag) then
			self:_play_sound(UISoundEvents.group_finder_filter_list_tag_deselected)
		end
	else
		local is_mutually_exclusive, deselection_allowed = self:_is_tag_mutually_exclusive_with_current_selection(tag)

		if is_mutually_exclusive and deselection_allowed then
			local mutually_exclusive = tag.mutually_exclusive

			for i = 1, #mutually_exclusive do
				local mutually_exclusive_tag_name = mutually_exclusive[i]
				local mutually_exclusive_tag = self:_get_tag_by_name(mutually_exclusive_tag_name)

				self:_remove_selected_tag(mutually_exclusive_tag)
			end

			if self:_add_selected_tag(tag) then
				self:_play_sound(UISoundEvents.group_finder_filter_list_tag_selected)
			end
		end
	end

	self:_update_tag_widgets()
	self:_reset_search()
	self:_update_tag_navigation_buttons_status()

	if element.auto_next then
		self._auto_continue_from_tag = tag
	end
end

GroupFinderView._update_tag_widgets = function (self, clear_slot_widgets)
	local any_visible_tag_selected = false
	local tags_grid = self._tags_grid

	if tags_grid then
		local grid_widgets = tags_grid:widgets()

		for i = 1, #grid_widgets do
			local grid_widget = grid_widgets[i]
			local content = grid_widget.content
			local widget_element = content.element
			local tag = widget_element.tag

			if tag then
				local tag_name = tag.name
				local is_tag_selected = self:_is_tag_name_selected(tag_name)

				if clear_slot_widgets then
					content.slot_filled = false
				end

				local hotspot = content.hotspot

				if hotspot then
					content.checked = is_tag_selected

					if content.checked then
						any_visible_tag_selected = true
					end
				end

				local root_tag = tag.root_tag
				local disabled = true

				if root_tag then
					disabled = false
				else
					local level_requirement_met = widget_element.level_requirement_met

					if level_requirement_met then
						local can_select_tag = self:_can_select_tag(tag)

						if not can_select_tag then
							if is_tag_selected then
								disabled = false
							else
								local is_mutually_exclusive, deselection_allowed = self:_is_tag_mutually_exclusive_with_current_selection(tag)

								if is_mutually_exclusive and deselection_allowed then
									disabled = false
								end
							end
						else
							disabled = false
						end
					end
				end

				hotspot.disabled = disabled
			end
		end

		for i = 1, #grid_widgets do
			local grid_widget = grid_widgets[i]
			local content = grid_widget.content
			local hotspot = content.hotspot

			if hotspot then
				content.any_visible_tag_selected_last_frame = any_visible_tag_selected
			end
		end
	end
end

GroupFinderView._is_tag_name_selected = function (self, tag_name)
	return self._selected_tags_by_name[tag_name]
end

GroupFinderView._get_highest_tag_level_requirement = function (self, tags)
	local highest_tag_level_requirement = 0

	for i = 1, #tags do
		local tag = tags[i]
		local level_requirement = tag.level_requirement or 0

		if highest_tag_level_requirement < level_requirement then
			highest_tag_level_requirement = level_requirement
		end
	end

	return highest_tag_level_requirement
end

GroupFinderView._add_selected_tag = function (self, tag)
	local tag_name = tag.name

	if not self._selected_tags_by_name[tag_name] then
		self._selected_tags_by_name[tag_name] = tag
		self._selected_tags[#self._selected_tags + 1] = tag
		self._highest_tag_level_requirement = self:_get_highest_tag_level_requirement(self._selected_tags)

		return true
	end
end

GroupFinderView._remove_selected_tag = function (self, tag)
	local tag_name = tag.name

	if self._selected_tags_by_name[tag_name] then
		self._selected_tags_by_name[tag_name] = nil

		for i = 1, #self._selected_tags do
			if self._selected_tags[i].name == tag_name then
				table.remove(self._selected_tags, i)

				self._highest_tag_level_requirement = self:_get_highest_tag_level_requirement(self._selected_tags)

				return true
			end
		end
	end
end

GroupFinderView._update_tag_navigation_buttons_status = function (self)
	local visited_tag_pages = self:_get_visited_tag_pages()
	local selected_tags = self._selected_tags
	local widgets_by_name = self._widgets_by_name
	local previous_filter_button = widgets_by_name.previous_filter_button

	previous_filter_button.content.hotspot.disabled = #visited_tag_pages <= 1

	local lowest_party_member_level = self._lowest_party_member_level
	local highest_tag_level_requirement = self._highest_tag_level_requirement
	local is_level_requirement_met = highest_tag_level_requirement <= lowest_party_member_level
	local is_party_full = self._is_party_full

	widgets_by_name.start_group_button_party_full_warning.content.is_party_full = is_party_full
	widgets_by_name.start_group_button_level_warning.content.level_requirement_met = is_party_full and true or is_level_requirement_met

	local start_group_button = widgets_by_name.start_group_button

	start_group_button.content.hotspot.disabled = is_party_full or not is_level_requirement_met or #selected_tags <= 0
end

GroupFinderView._generate_tags_description = function (self, tags)
	local text = ""
	local grid_scenegraph_id = "group_grid"
	local definitions = self._definitions
	local scenegraph_definition = definitions.scenegraph_definition
	local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
	local grid_size = grid_scenegraph.size
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.own_group_presentation
	local description_text_style = widget.style.description
	local extra_tags_width = 50
	local max_length = (grid_size[1] - 20) * 0.5 + description_text_style.size_addition[1] - extra_tags_width
	local extra_tags_counter = 0

	for i = 1, #tags do
		local tag = tags[i]
		local new_text = text .. "[" .. tag.text .. "] "
		local width, _ = self:_text_size_for_style(new_text, description_text_style, {
			max_length + max_length,
			5,
		})

		if width <= max_length then
			text = new_text
		else
			extra_tags_counter = extra_tags_counter + 1
		end
	end

	if extra_tags_counter > 0 then
		text = text .. " (+" .. tostring(extra_tags_counter) .. ")"
	end

	return text
end

GroupFinderView._get_selected_tags = function (self, return_table)
	return_table = return_table or {}

	local tags_grid = self._tags_grid

	if tags_grid then
		local grid_widgets = tags_grid:widgets()

		for i = 1, #grid_widgets do
			local grid_widget = grid_widgets[i]
			local content = grid_widget.content
			local hotspot = content.hotspot

			if hotspot then
				local checked = content.checked

				if checked then
					local widget_element = content.element
					local tag = widget_element.tag

					if tag then
						return_table[#return_table + 1] = tag
					end
				end
			end
		end
	end

	return return_table
end

GroupFinderView._cb_on_list_group_pressed = function (self, element, widget_index)
	if self._previewed_group_id then
		return
	end

	if self:using_cursor_navigation() then
		local group_grid = self._group_grid

		if group_grid then
			if group_grid:selected_grid_index() == widget_index then
				group_grid:select_grid_index(nil)
			else
				group_grid:select_grid_index(widget_index)
			end
		end
	else
		self:_cb_on_join_button_pressed()
	end
end

GroupFinderView._on_group_selection_changed = function (self)
	local group_grid = self._group_grid
	local selected_grid_index = group_grid and group_grid:selected_grid_index()
	local selected_widget = selected_grid_index and group_grid:widget_by_index(selected_grid_index)

	if selected_widget then
		local content = selected_widget.content
		local element = content.element

		self._selected_group_id = element and element.group_id
		self._selected_group_grid_index = selected_grid_index
	else
		self._selected_group_id = nil
		self._selected_group_grid_index = nil
		self._selected_group_level_requirement_met = nil
	end

	local group = self._selected_group_id and self:_group_by_id(self._selected_group_id)

	if group then
		local level_requirement_met = group.level_requirement_met

		self._selected_group_level_requirement_met = level_requirement_met
	else
		self._selected_group_level_requirement_met = nil
	end

	self._widgets_by_name.join_button_level_warning.content.level_requirement_met = self._selected_group_level_requirement_met ~= false
end

GroupFinderView._setup_group_preview = function (self, group_id)
	local group = self:_group_by_id(group_id)

	if group then
		self._previewed_group_id = group_id

		local tags = group and group.tags
		local group_grid_size = self._ui_scenegraph.group_grid.size
		local tags_grid_size = self._ui_scenegraph.tags_grid.size
		local player_request_grid_size = self._ui_scenegraph.player_request_grid.size
		local preview_grid_size = self._ui_scenegraph.preview_grid.size
		local layout = {}

		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				preview_grid_size[1],
				60,
			},
		}

		local group_width = group_grid_size[1] * 0.5 - 5

		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				(preview_grid_size[1] - group_width) * 0.5,
				20,
			},
		}

		local group_entry = {
			is_preview = true,
			level_requirement_met = true,
			widget_type = "group",
			group = group,
			description = group.description,
			group_id = group.id,
			tags = tags,
		}

		layout[#layout + 1] = group_entry
		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				preview_grid_size[1],
				30,
			},
		}
		layout[#layout + 1] = {
			horizontal_alignment = "center",
			texture = "content/ui/materials/dividers/skull_center_01",
			vertical_alignment = "center",
			widget_type = "texture",
			texture_size = {
				380,
				30,
			},
			color = Color.terminal_text_body_sub_header(nil, true),
			size = {
				preview_grid_size[1],
				30,
			},
		}

		local group_members = group.members

		if group_members and #group_members > 0 then
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					preview_grid_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				widget_type = "header",
				text = Localize("loc_group_finder_group_player_title"),
				size = {
					preview_grid_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					preview_grid_size[1],
					10,
				},
			}

			for _, member in ipairs(group_members) do
				local presence_info = member.presence_info

				if presence_info and presence_info.synced then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							preview_grid_size[1] * 0.5 - player_request_grid_size[1] * 0.5,
							50,
						},
					}

					local entry = {
						is_preview = true,
						widget_type = "player_request_entry",
						presence_info = presence_info,
					}

					layout[#layout + 1] = entry
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							preview_grid_size[1] * 0.5 - player_request_grid_size[1] * 0.5,
							50,
						},
					}
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							preview_grid_size[1],
							10,
						},
					}
				end
			end
		end

		if tags then
			local spacing = 10
			local preview_tag_row_width = player_request_grid_size[1]
			local preview_tag_size = {
				(preview_tag_row_width - spacing) * 0.5,
				30,
			}

			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					preview_grid_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				widget_type = "header",
				text = Localize("loc_group_finder_category_option_key_words"),
				size = {
					preview_grid_size[1],
					30,
				},
			}
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					preview_grid_size[1],
					10,
				},
			}

			local tag_layout = self:_get_layout_by_tags(tags, preview_tag_size, nil, true)

			for i = 1, #tag_layout do
				local is_even = i % 2 == 0

				if not is_even then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							(preview_grid_size[1] - preview_tag_row_width) * 0.5,
							10,
						},
					}
				end

				layout[#layout + 1] = tag_layout[i]

				if not is_even then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							spacing,
							10,
						},
					}
				end

				if is_even then
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							(preview_grid_size[1] - preview_tag_row_width) * 0.5,
							10,
						},
					}
					layout[#layout + 1] = {
						widget_type = "dynamic_spacing",
						size = {
							preview_grid_size[1],
							10,
						},
					}
				end
			end
		end

		layout[#layout + 1] = {
			widget_type = "dynamic_spacing",
			size = {
				preview_grid_size[1],
				30,
			},
		}

		self:_populate_preview_grid(layout)
		self:_set_preview_grid_visibility(true)
	else
		self._previewed_group_id = nil

		self:_set_preview_grid_visibility(false)
	end
end

GroupFinderView._prepare_group_members_presence_data = function (self, group)
	local members = group.members
	local group_members = {}
	local group_member_promises = {}

	for _, member in ipairs(members) do
		local member_status = member.status

		if member_status == "CONNECTED" then
			local member_account_id = member.account_id
			local group_member = group_members[member_account_id]

			if not group_member then
				group_member = {
					account_id = member_account_id,
					presence_info = {},
				}
				group_members[#group_members + 1] = group_member
			end

			local _, promise = Managers.presence:get_presence(member_account_id)

			group_member_promises[#group_member_promises + 1] = promise

			self:_cancel_promise_on_exit(promise)
			promise:next(function (data)
				local member_data

				for i = 1, #group_members do
					if group_members[i].account_id == member_account_id then
						member_data = group_members[i]

						break
					end
				end

				if member_data then
					local presence_info = member_data.presence_info
					local parsed_character_profile = data._parsed_character_profile

					if parsed_character_profile then
						local name = parsed_character_profile.name
						local current_level = parsed_character_profile.current_level
						local archetype = parsed_character_profile.archetype
						local archetype_name = archetype.name

						presence_info.name = name
						presence_info.level = current_level
						presence_info.archetype = archetype_name
						presence_info.profile = parsed_character_profile
					end
				end
			end):catch(function (error)
				Log.error("GroupFinder", "Presence failed")
			end)
		end
	end

	if #group_member_promises > 0 then
		local unpack_func = unpack_index[#group_member_promises]

		return Promise.all(unpack_func(group_member_promises, 1)):next(function ()
			return group_members
		end)
	else
		return Promise.resolved():next(function ()
			return group_members
		end)
	end
end

GroupFinderView.draw = function (self, dt, t, input_service, layer)
	local render_settings = self._render_settings
	local alpha_multiplier = render_settings.alpha_multiplier
	local animation_alpha_multiplier = self.animation_alpha_multiplier or 0

	render_settings.alpha_multiplier = animation_alpha_multiplier

	GroupFinderView.super.draw(self, dt, t, input_service, layer)

	render_settings.alpha_multiplier = alpha_multiplier
end

GroupFinderView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	GroupFinderView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local group_loading_widget = self._group_loading_widget

	if group_loading_widget then
		UIWidget.draw(group_loading_widget, ui_renderer)
	end
end

GroupFinderView.on_resolution_modified = function (self, scale)
	GroupFinderView.super.on_resolution_modified(self, scale)
end

GroupFinderView._cb_on_join_button_pressed = function (self)
	if self._widgets_by_name.join_button.content.hotspot.disabled then
		return
	end

	if not self._selected_group_id then
		return
	end

	local group = self:_group_by_id(self._selected_group_id)

	if not group then
		return
	end

	self:_set_group_request_status(group.id, "sent")

	local party_immaterium = Managers.party_immaterium

	if party_immaterium then
		local player = self:_player()
		local account_id = player:account_id()

		party_immaterium:send_request_to_join_party(group, account_id):next(function (response)
			if response.accepted then
				self:_set_group_request_status(group.id, "approved")
			else
				self:_set_group_request_status(group.id, "declined")
			end
		end):catch(function (error)
			Log.error("GroupFinderView", "Error joining game" .. table.tostring(error, 3))
			table.insert(self._sent_requests, group.id)
			self:_set_group_request_status(group.id, "declined")
		end)

		local message = Localize("loc_group_finder_join_notification_sent")

		Managers.event:trigger("event_add_notification_message", "default", message, nil, nil)
		self:_play_sound(UISoundEvents.group_finder_request_to_join_group)
	end
end

GroupFinderView._set_group_request_status = function (self, id, state)
	self._sent_requests[id] = state
	self._sent_requests_duration[id] = Managers.time:time("ui") + REQUEST_DURATION
end

GroupFinderView._get_group_request_status = function (self, id)
	return self._sent_requests[id]
end

GroupFinderView._handle_group_request_status_clearing = function (self, t)
	local sent_requests = self._sent_requests
	local sent_requests_duration = self._sent_requests_duration

	for id, time in pairs(sent_requests_duration) do
		if time < t then
			sent_requests[id] = nil
			sent_requests_duration[id] = nil
		end
	end
end

GroupFinderView._cb_on_start_group_button_pressed = function (self)
	local widget = self._widgets_by_name.start_group_button
	local content = widget.content
	local hotspot = content.hotspot

	if hotspot.disabled then
		return
	end

	local party_immaterium = Managers.party_immaterium

	if not party_immaterium then
		return
	end

	if self._previewed_group_id then
		return
	end

	local region = BackendUtilities.prefered_mission_region
	local selected_tags = self._selected_tags

	if #selected_tags <= 0 then
		return
	end

	local tags_for_group_advertisement = {}

	for i = 1, #selected_tags do
		if selected_tags[i].name then
			table.insert(tags_for_group_advertisement, selected_tags[i].name)

			if selected_tags[i].parents then
				local parents_data = self:_get_tags_by_names(selected_tags[i].parents)

				for j = 1, #parents_data do
					if parents_data[j].root_tag then
						local already_in_list = false

						for k = 1, #tags_for_group_advertisement do
							if tags_for_group_advertisement[k] == parents_data[j].name then
								already_in_list = true

								break
							end
						end

						if not already_in_list then
							table.insert(tags_for_group_advertisement, parents_data[j].name)
						end
					end
				end
			end
		end
	end

	if #tags_for_group_advertisement == 0 then
		return
	end

	local promise, id = party_immaterium:start_party_finder_advertise({}, tags_for_group_advertisement, region)

	Log.info("Party advertisement initiated with ID:", id)
	self:_cancel_promise_on_exit(promise)
	promise:next(function (result)
		Log.info("Party advertisement successfully started with result:", result)
		self:_set_state(STATE.advertising)
	end):catch(function (error)
		Log.error("Failed to start party advertisement. Error:", table.tostring(error, 10))
	end)
	self:_play_sound(UISoundEvents.group_finder_own_group_advertisement_start)
end

GroupFinderView._group_by_id = function (self, group_id)
	local groups = self._groups

	for i = 1, #groups do
		local group = groups[i]

		if group.id == group_id then
			return group
		end
	end
end

GroupFinderView._cb_on_previous_filter_button_pressed = function (self)
	if self._previewed_group_id then
		return
	end

	self:cb_handle_back_pressed()
end

local _temp_selected_unlocks = {}

GroupFinderView.get_selected_unlocks_by_tag = function (self, tag)
	table.clear(_temp_selected_unlocks)

	local unlocks = tag.unlocks

	if unlocks then
		for i = 1, #unlocks do
			local unlock_tag_name = unlocks[i]

			if self:_is_tag_name_selected(unlock_tag_name) then
				local unlock_tag = self:_get_tag_by_name(unlock_tag_name)

				_temp_selected_unlocks[#_temp_selected_unlocks + 1] = unlock_tag
			end
		end
	end

	return _temp_selected_unlocks
end

GroupFinderView._get_tag_by_name = function (self, name)
	local tags = self._tags

	for i = 1, #tags do
		local tag = tags[i]

		if tag.name == name then
			return tag
		end
	end
end

GroupFinderView._get_tags_by_names = function (self, names)
	local tags = self._tags
	local return_tags = {}

	for _, name in ipairs(names) do
		for i = 1, #tags do
			local tag = tags[i]

			if tag.name == name then
				return_tags[#return_tags + 1] = tag
			end
		end
	end

	return return_tags
end

GroupFinderView._handle_next_filter_button_options = function (self, tag)
	local unlocks = tag.unlocks
	local next_page_tags = self:_get_tags_by_names(unlocks)

	if next_page_tags then
		local visited_tag_pages = self:_get_visited_tag_pages()

		visited_tag_pages[#visited_tag_pages + 1] = next_page_tags

		self:_set_state(STATE.browsing)
		self:_update_tag_grid()
		self:_update_tag_navigation_buttons_status()
		self:_play_sound(UISoundEvents.group_finder_filter_list_category_pressed)
	end
end

GroupFinderView._update_tag_grid = function (self)
	local visited_tag_pages = self:_get_visited_tag_pages()
	local tags = visited_tag_pages[#visited_tag_pages]
	local first_tag = tags[1]
	local first_ui_category = first_tag.ui_category
	local description_text = self:_get_page_descripion_by_category(first_ui_category)

	if self._category_description_animation_id then
		self:_stop_animation(self._category_description_animation_id)

		self._category_description_animation_id = nil
	end

	self._category_description_animation_id = self:_start_animation("update_widget_text_fade", self._widgets_by_name.category_description, {
		new_text = description_text or "",
	})

	local tags_grid_size = self._ui_scenegraph.tags_grid.size
	local tags_layout = self:_get_layout_by_tags(tags, tags_grid_size)

	self:_populate_tags_grid(tags_layout)
end

GroupFinderView._cb_on_cancel_group_button_pressed = function (self)
	local widget = self._widgets_by_name.cancel_group_button
	local content = widget.content

	if not content.visible then
		return
	end

	content.hold_active = false
	content.current_timer = 0
	content.hold_progress = 0

	local party_immaterium = Managers.party_immaterium

	if not party_immaterium then
		return
	end

	if self._listed_group then
		for i = 1, #self._groups do
			local group = self._groups[i]

			if group.id == self._listed_group.id then
				table.remove(self._groups, i)
				self:_update_group_grid()

				break
			end
		end
	end

	local promise, id = party_immaterium:cancel_party_finder_advertise()

	self:_cancel_promise_on_exit(promise)

	self._cancel_group_promise = promise

	promise:next(function (response)
		self._advertisement_join_requests_version = -1

		self:_populate_player_request_grid({})

		self._cancel_group_promise = nil

		self:_set_state(STATE.browsing)
		self:_reset_search()
	end)
	self:_play_sound(UISoundEvents.group_finder_own_group_advertisement_stop)
end

GroupFinderView._cb_on_refresh_button_pressed = function (self)
	if self._refresh_promise then
		return
	end

	local refresh_promise

	if self._refresh_available_timer then
		self._show_group_loading = true

		local delay_promise = Promise.delay(self._refresh_available_timer)

		refresh_promise = Promise.all(self:_reset_search(), delay_promise)
	else
		refresh_promise = self:_reset_search()
	end

	self._refresh_available_timer = 5
	self._refresh_promise = refresh_promise:next(function ()
		self._refresh_promise = nil

		if not self:using_cursor_navigation() and not self._tags_grid:selected_grid_index() then
			self._tags_grid:select_first_index()
		end
	end)

	self:_play_sound(UISoundEvents.group_finder_refresh_group_list)
end

GroupFinderView._set_state = function (self, new_state)
	Log.info("[GroupFinderView] - set state: CURRENT STATE: " .. self._state .. " | NEW STATE: " .. new_state)

	self._state = new_state
	self._anim_preview_progress = -0.01

	if new_state == STATE.idle then
		self:_set_group_list_empty_info_visibility(false)

		self._show_group_loading = false
	elseif new_state == STATE.fetching_tags then
		self:_set_group_list_empty_info_visibility(false)
		self:_update_grids_selection()

		self._show_group_loading = false

		self:_set_own_group_listing_widgets_visibility(false)
		self:_set_group_browsing_widgets_visibility(false)
		self:_set_tag_grid_visibility(false)
		self:_update_party_statuses()
		self:_cancel_promise_on_exit(Promise.all(self:fetch_regions(), self:_get_group_finder_tags():next(function (group_finder_tags_data)
			if not group_finder_tags_data or #group_finder_tags_data <= 0 then
				local context = {
					description_text = "loc_popup_unavailable_view_group_finder_description",
					title_text = "loc_action_interaction_unavailable",
					enter_popup_sound = UISoundEvents.social_menu_receive_invite,
					options = {
						{
							close_on_pressed = true,
							hotkey = "back",
							text = "loc_popup_button_close",
							callback = function ()
								Managers.ui:close_view(self.view_name)
							end,
						},
					},
				}

				Managers.event:trigger("event_show_ui_popup", context)
			else
				self._tags = group_finder_tags_data

				self:_on_fetching_tags_complete()
			end
		end)))
	elseif new_state == STATE.browsing then
		self:_set_group_list_empty_info_visibility(false)
		self:_update_grids_selection()
		self:_set_own_group_listing_widgets_visibility(false)
		self:_set_group_browsing_widgets_visibility(true)
		self:_set_tag_grid_visibility(true)
		self:_update_party_statuses()
	elseif new_state == STATE.advertising then
		self:_update_grids_selection()

		self._show_group_loading = false

		self:_set_group_list_empty_info_visibility(false)

		local party_immaterium = Managers.party_immaterium

		if party_immaterium then
			local advertise_state = party_immaterium:advertise_state()

			self._listed_group = advertise_state
		end

		self:_update_group_grid()
		self:_set_own_group_listing_widgets_visibility(true)
		self:_set_group_browsing_widgets_visibility(false)
		self:_set_tag_grid_visibility(false)
		self:_init_own_group_presentation(self._listed_group)
		self:_update_listed_group()
	end
end

GroupFinderView._init_own_group_presentation = function (self, listed_group)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.own_group_presentation
	local tags_by_name = listed_group.tags
	local tags = {}

	for _, tag_name in ipairs(tags_by_name) do
		local tag = self:_get_tag_by_name(tag_name)

		if tag and not tag.root_tag then
			tags[#tags + 1] = tag
		end
	end

	table.sort(tags, _tags_sort_function)

	local own_group_visualization = {}

	own_group_visualization.level_requirement_met = true
	own_group_visualization.group_id = listed_group.party_id
	own_group_visualization.tags = tags
	own_group_visualization.description = self:_generate_tags_description(tags)
	own_group_visualization.status = listed_group.status
	own_group_visualization.version = listed_group.version
	own_group_visualization.restrictions = listed_group.restrictions
	own_group_visualization.members = {}
	own_group_visualization.group = own_group_visualization
	own_group_visualization.disabled = true
	self._own_group_visualization = own_group_visualization

	local definitions = self._definitions
	local groups_blueprints = definitions.groups_blueprints

	groups_blueprints.group.init(self, widget, self._own_group_visualization, nil, nil, self._ui_renderer)
end

local time_loc_string_start = "loc_group_finder_group_list_last_time_updated_start"
local time_loc_string = "loc_group_finder_group_list_last_time_updated"

GroupFinderView._update_group_list_time_stamp = function (self, dt, t)
	local last_time_group_list_updated = self._last_time_group_list_updated

	if not last_time_group_list_updated then
		return
	end

	local current_time = t - last_time_group_list_updated

	if current_time % 60 > 1 then
		return
	end

	local presentation_text

	if current_time < 60 then
		presentation_text = Localize(time_loc_string_start)
	else
		local time_text = TextUtilities.format_time_span_localized(current_time, false, true)

		presentation_text = Localize(time_loc_string, true, {
			time = time_text,
		})
	end

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.group_list_time_stamp

	widget.content.text = presentation_text
end

GroupFinderView._update_own_group_presentation = function (self, input_service, dt, t, ui_renderer)
	local definitions = self._definitions
	local groups_blueprints = definitions.groups_blueprints
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.own_group_presentation

	groups_blueprints.group.update(self, widget, input_service, dt, t, ui_renderer)
end

GroupFinderView._update_incoming_join_requests = function (self, t)
	local party_immaterium = Managers.party_immaterium

	if not party_immaterium then
		return
	end

	local join_requests, version = party_immaterium:advertisement_request_to_join_list()

	if version ~= self._advertisement_join_requests_version then
		self._advertisement_join_requests_version = version

		self:_populate_player_request_grid(join_requests or {})
	end
end

GroupFinderView.update = function (self, dt, t, input_service)
	local is_in_matchmaking = Managers.data_service.social:is_in_matchmaking()

	if is_in_matchmaking and not Managers.ui:is_view_closing(self.view_name) then
		Managers.ui:close_view(self.view_name)

		return
	end

	if self._refresh_available_timer then
		self._refresh_available_timer = self._refresh_available_timer - dt

		if self._refresh_available_timer <= 0 then
			self._refresh_available_timer = nil
		end
	end

	self:_handle_group_request_status_clearing(t)
	self:_update_group_list_time_stamp(dt, t)

	local anim_alpha_speed = 8
	local anim_preview_progress = self._anim_preview_progress or 0

	if self._previewed_group_id then
		anim_preview_progress = math.min(anim_preview_progress + dt * anim_alpha_speed, 1)
	else
		anim_preview_progress = math.max(anim_preview_progress - dt * anim_alpha_speed, 0)
	end

	local current_state = self._state

	if anim_preview_progress ~= self._anim_preview_progress then
		if self._preview_grid then
			self._preview_grid:set_alpha_multiplier(anim_preview_progress)

			self._widgets_by_name.preview_window.alpha_multiplier = anim_preview_progress
		end

		if self._tags_grid then
			self._tags_grid:set_alpha_multiplier(1 - anim_preview_progress)
		end

		local side_widgets = self._side_widgets_by_state[current_state]

		if side_widgets then
			for i = 1, #side_widgets do
				local widget = side_widgets[i]

				widget.alpha_multiplier = 1 - anim_preview_progress
			end
		end

		self._anim_preview_progress = anim_preview_progress
	end

	if current_state == STATE.browsing then
		local party_immaterium = Managers.party_immaterium

		if party_immaterium and party_immaterium:is_party_advertisement_active() then
			self:_set_state(STATE.advertising)
		else
			self:_start_advertisements_stream()
			self:_handle_incoming_advertisement_events()

			local group_grid = self._group_grid

			if group_grid:selected_grid_index() ~= self._selected_group_grid_index then
				self:_on_group_selection_changed()
			end

			local hovered_grid_index = group_grid:hovered_grid_index()
			local show_preview_input = hovered_grid_index or self._selected_group_grid_index

			self._widgets_by_name.preview_input_text.alpha_multiplier = show_preview_input and 1 or 0
			self._can_leave_group_grid_selection = group_grid:selected_grid_index() and group_grid:selected_grid_index() % 2 == 1
		end
	elseif current_state == STATE.advertising then
		local party_immaterium = Managers.party_immaterium

		if party_immaterium and party_immaterium:is_party_advertisement_active() then
			self:_handle_incoming_advertisement_events()
			self:_update_incoming_join_requests()

			local widgets_by_name = self._widgets_by_name

			ButtonPassTemplates.terminal_button_hold_small.update(self, widgets_by_name.cancel_group_button, self._ui_renderer, dt)

			local player_request_grid = self._player_request_grid

			if player_request_grid then
				local selected_grid_index = player_request_grid:selected_grid_index()
				local input_prompts_visible = selected_grid_index ~= nil and not self:using_cursor_navigation()

				widgets_by_name.player_request_button_accept.content.visible = input_prompts_visible
				widgets_by_name.player_request_button_decline.content.visible = input_prompts_visible
			end

			local own_group_visualization = self._own_group_visualization

			if own_group_visualization.group_id ~= self:party_id() then
				self:_set_state(STATE.advertising)
			end
		else
			self:_set_state(STATE.browsing)
		end
	end

	self:_update_group_loading_widget(dt)
	self:_update_own_group_presentation(input_service, dt, t, self._ui_renderer)

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	if self._auto_continue_from_tag then
		self:_handle_next_filter_button_options(self._auto_continue_from_tag)

		self._auto_continue_from_tag = nil
	end

	local tags_grid = self._tags_grid

	if tags_grid and tags_grid:visible() ~= self._tag_grid_visibility then
		tags_grid:set_visibility(self._tag_grid_visibility)
	end

	local preview_grid = self._preview_grid

	if preview_grid and preview_grid:visible() ~= self._preview_grid_visibility then
		preview_grid:set_visibility(self._preview_grid_visibility)
	end

	return GroupFinderView.super.update(self, dt, t, input_service)
end

GroupFinderView.can_exit = function (self)
	local widgets_by_name = self._widgets_by_name

	return GroupFinderView.super.can_exit(self)
end

GroupFinderView.on_exit = function (self)
	local save_manager = Managers.save
	local player = self:_player()
	local character_id = player:character_id()
	local save_data = save_manager:character_data(character_id)
	local group_finder_search_tags = save_data and save_data.group_finder_search_tags

	if group_finder_search_tags then
		table.clear(group_finder_search_tags)

		local selected_tags_by_name = self._selected_tags_by_name

		for tag_name, _ in pairs(selected_tags_by_name) do
			group_finder_search_tags[#group_finder_search_tags + 1] = tag_name
		end

		save_manager:queue_save()
	end

	local promises = self._promises

	for promise, _ in pairs(promises) do
		promise:cancel()
	end

	if self._enter_animation_id then
		self:_stop_animation(self._enter_animation_id)

		self._enter_animation_id = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	local ui_renderer = self._ui_renderer
	local widgets_by_name = self._widgets_by_name

	for i = 1, 4 do
		local widget_name = "team_member_" .. i
		local widget = widgets_by_name[widget_name]
		local content = widget.content

		if content.slot_filled then
			self:_unload_portrait_icon(widget, ui_renderer)
		end
	end

	GroupFinderView.super.on_exit(self)
end

GroupFinderView.ui_renderer = function (self)
	return self._ui_renderer
end

GroupFinderView._set_own_group_listing_widgets_visibility = function (self, visible)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.player_request_window.content.visible = visible
	widgets_by_name.created_group_party_title.content.visible = visible
	widgets_by_name.player_request_grid_title.content.visible = visible
	widgets_by_name.cancel_group_button.content.visible = visible
	widgets_by_name.team_member_1.content.visible = visible
	widgets_by_name.team_member_2.content.visible = visible
	widgets_by_name.team_member_3.content.visible = visible
	widgets_by_name.team_member_4.content.visible = visible
	widgets_by_name.own_group_presentation.content.visible = visible
	widgets_by_name.player_request_button_accept.content.visible = false
	widgets_by_name.player_request_button_decline.content.visible = false

	if self._player_request_grid then
		self._player_request_grid:set_visibility(visible)
	end
end

GroupFinderView._set_group_browsing_widgets_visibility = function (self, visible)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.group_window.content.visible = visible
	widgets_by_name.join_button.content.visible = visible
	widgets_by_name.refresh_button.content.visible = visible
	widgets_by_name.preview_input_text.content.visible = visible
	widgets_by_name.group_list_time_stamp.content.visible = visible
	widgets_by_name.join_button_level_warning.content.visible = visible

	self:_set_start_group_widgets_visibility(visible)

	if self._group_grid then
		self._group_grid:set_visibility(visible)
	end
end

GroupFinderView._set_group_list_empty_info_visibility = function (self, visible)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.group_window_info.content.visible = visible
end

GroupFinderView._set_start_group_widgets_visibility = function (self, visible)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.start_group_button_level_warning.content.visible = visible
	widgets_by_name.start_group_button_party_full_warning.content.visible = visible
	widgets_by_name.start_group_button.content.visible = visible
	widgets_by_name.previous_filter_button.content.visible = visible
	widgets_by_name.start_group_button_header.content.visible = visible
	widgets_by_name.category_description.content.visible = visible
	widgets_by_name.filter_page_divider_top.content.visible = visible
	widgets_by_name.filter_page_divider_bottom.content.visible = visible
end

GroupFinderView.event_party_composition_changed = function (self)
	if self._state == STATE.advertising then
		self:_update_listed_group()
	end

	self:_update_party_statuses()
end

GroupFinderView._update_party_statuses = function (self)
	local player_composition_name_party = "party"
	local party_players = PlayerCompositions.players(player_composition_name_party, {})
	local lowest_party_member_level = math.huge
	local num_party_members = 0

	for _, player in pairs(party_players) do
		num_party_members = num_party_members + 1

		local profile = player:profile()
		local current_level = profile and profile.current_level or 1

		if current_level < lowest_party_member_level then
			lowest_party_member_level = current_level
		end
	end

	self._lowest_party_member_level = lowest_party_member_level
	self._is_party_full = num_party_members >= 4

	self:_update_tag_navigation_buttons_status()
end

GroupFinderView._update_listed_group = function (self)
	local widgets_by_name = self._widgets_by_name
	local player_composition_name_party = "party"
	local temp_team_players = {}
	local players_sorted_by_name = {}
	local party_players = PlayerCompositions.players(player_composition_name_party, temp_team_players)

	for _, player in pairs(party_players) do
		players_sorted_by_name[#players_sorted_by_name + 1] = player
	end

	table.sort(players_sorted_by_name, function (a, b)
		return a:name() < b:name()
	end)

	local own_group_visualization = self._own_group_visualization
	local members = own_group_visualization.members

	for i = 1, 4 do
		local player = players_sorted_by_name[i]
		local widget_name = "team_member_" .. i
		local widget = widgets_by_name[widget_name]
		local content = widget.content
		local style = widget.style

		if player then
			local profile = player:profile()
			local character_archetype_title = ProfileUtils.character_archetype_title(profile)
			local character_level = tostring(profile.current_level) .. " "

			content.character_archetype_title = string.format("%s %s", character_archetype_title, character_level)
			content.character_name = ProfileUtils.character_name(profile)

			local archetype = profile.archetype

			content.archetype_icon = archetype.archetype_icon_selection_large_unselected

			local player_title = ProfileUtils.character_title(profile)

			if player_title then
				content.character_title = player_title
			end

			if not player_title or player_title == "" then
				style.character_name.offset[2] = -12
				style.character_archetype_title.offset[2] = -1
			else
				style.character_name.offset[2] = -30
				style.character_archetype_title.offset[2] = 12
			end

			if content.slot_filled then
				local ui_renderer = self._ui_renderer

				self:_unload_portrait_icon(widget, ui_renderer)
			end

			self:_request_player_icon(profile, widget)

			local loadout = profile.loadout
			local frame_item = loadout and loadout.slot_portrait_frame

			if frame_item then
				local cb = callback(self, "_cb_set_player_frame", widget)

				widget.content.frame_load_id = Managers.ui:load_item_icon(frame_item, cb)
			end

			local insignia_item = loadout and loadout.slot_insignia

			if insignia_item then
				local cb = callback(self, "_cb_set_player_insignia", widget)

				widget.content.insignia_load_id = Managers.ui:load_item_icon(insignia_item, cb)
			end

			if not members[i] then
				members[i] = {
					presence_info = {},
				}
			end

			members[i].account_id = player:account_id()
			members[i].presence_info.archetype = archetype.name
			members[i].presence_info.synced = true
		elseif members[i] then
			members[i] = nil
		end

		content.slot_filled = player ~= nil
	end
end

GroupFinderView._cb_set_player_frame = function (self, widget, item)
	local material_values = widget.style.character_portrait.material_values

	material_values.portrait_frame_texture = item.icon
end

GroupFinderView._cb_set_player_insignia = function (self, widget, item)
	local icon_style = widget.style.character_insignia
	local material_values = icon_style.material_values

	if item.icon_material and item.icon_material ~= "" then
		if material_values.texture_map then
			material_values.texture_map = nil
		end

		widget.content.character_insignia = item.icon_material
	else
		material_values.texture_map = item.icon
	end

	icon_style.color[1] = 255
end

GroupFinderView._request_player_icon = function (self, profile, widget)
	local material_values = widget.style.character_portrait.material_values

	material_values.use_placeholder_texture = 1

	self:_load_portrait_icon(profile, widget)
end

GroupFinderView._load_portrait_icon = function (self, profile, widget)
	local load_cb = callback(self, "_cb_set_player_icon", widget)
	local unload_cb = callback(self, "_cb_unset_player_icon", widget)

	widget.content.icon_load_id = Managers.ui:load_profile_portrait(profile, load_cb, nil, unload_cb)
end

GroupFinderView._cb_set_player_icon = function (self, widget, grid_index, rows, columns, render_target)
	local material_values = widget.style.character_portrait.material_values

	widget.content.character_portrait = "content/ui/materials/base/ui_portrait_frame_base"
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

GroupFinderView._cb_unset_player_icon = function (self, widget)
	local material_values = widget.style.character_portrait.material_values

	material_values.use_placeholder_texture = nil
	material_values.rows = nil
	material_values.columns = nil
	material_values.grid_index = nil
	material_values.texture_icon = nil
	widget.content.character_portrait = "content/ui/materials/base/ui_portrait_frame_base_no_render"
end

GroupFinderView._unload_portrait_icon = function (self, widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)

	local icon_load_id = widget.content.icon_load_id
	local frame_load_id = widget.content.frame_load_id
	local insignia_load_id = widget.content.insignia_load_id

	if icon_load_id then
		Managers.ui:unload_profile_portrait(icon_load_id)

		widget.content.icon_load_id = nil
	end

	if frame_load_id then
		Managers.ui:unload_item_icon(frame_load_id)

		widget.content.frame_load_id = nil
	end

	if insignia_load_id then
		Managers.ui:unload_item_icon(insignia_load_id)

		widget.content.insignia_load_id = nil

		local icon_style = widget.style.character_insignia

		icon_style.color[1] = 0
	end
end

GroupFinderView._is_table_containing_tags = function (self, source_tags, tags)
	for i = 1, #tags do
		local tag = tags[i]
		local tag_name = tag.name
		local found = false

		for j = 1, #source_tags do
			local source_tag = source_tags[j]
			local source_tag_name = source_tag.name

			if source_tag_name == tag_name then
				found = true
			end
		end

		if not found then
			return false
		end
	end

	return true
end

GroupFinderView._update_group_grid = function (self, optional_complete_callback)
	self._selected_group_id = nil
	self._selected_group_grid_index = nil
	self._selected_group_level_requirement_met = nil

	local groups = self._groups

	self:_populate_group_grid(groups, optional_complete_callback)
end

GroupFinderView._is_searching = function (self)
	return self._search_connection and #self._found_groups == 0
end

GroupFinderView._reset_search = function (self)
	self:_set_group_list_empty_info_visibility(false)

	self._groups = {}

	self:_update_group_grid()

	if self._search_connection_id then
		local abort_promise, _ = self:_cancel_promise_on_exit(Managers.grpc:abort_operation(self._search_connection_id))

		abort_promise:next(function ()
			Log.info("GroupFinderView", "STREAM CLOSED")

			self._found_groups = {}
			self._search_connection_promise = nil
			self._search_connection_id = nil
		end)

		return abort_promise
	end
end

GroupFinderView._start_advertisements_stream = function (self)
	local grpc = Managers.grpc

	if not self._search_connection_promise and not self._refresh_promise then
		Log.info("GroupFinderView", "OPEN STREAM")

		local region = BackendUtilities.prefered_mission_region
		local tags = self._selected_tags
		local tags_for_group_search = {}

		for i = 1, #tags do
			if tags[i].name then
				table.insert(tags_for_group_search, tags[i].name)
			end
		end

		Log.info("GroupFinderView", "Category: " .. region .. ", Tags: " .. table.concat(tags_for_group_search, ", "))

		self._show_group_loading = true
		self._groups = {}

		self:_update_group_grid()

		self._group_list_initialized = false

		local promise, id = grpc:party_finder_list_advertisements_stream(region, tags_for_group_search)

		if not promise then
			Log.error("GroupFinderView", "Failed to start advertisement stream: promise is nil")

			return
		end

		self:_cancel_promise_on_exit(promise)

		self._search_connection_id = id

		Log.info("GroupFinderView", "Stream ID: " .. tostring(self._search_connection_id))

		self._search_connection_promise = promise

		promise:next(function ()
			Log.info("GroupFinderView", "STREAM CLOSED")

			self._search_connection_promise = nil
		end):catch(function (error)
			if error.aborted then
				Log.info("GroupFinderView", "STREAM ABORTED " .. tostring(id))
			else
				Log.error("GroupFinderView", "STREAM ERROR")
				Log.error("GroupFinderView", table.tostring(error, 10))
			end
		end)
	end
end

GroupFinderView.party_id = function (self)
	local party_immaterium = Managers.party_immaterium

	return party_immaterium and party_immaterium:party_id()
end

GroupFinderView._handle_incoming_advertisement_events = function (self)
	local search_connection_id = self._search_connection_id

	if not search_connection_id then
		return
	end

	local grpc = Managers.grpc
	local events = grpc:get_party_finder_list_advertisements_events(tostring(search_connection_id))

	if not events then
		return
	end

	local state = self._state
	local group_list_initialized = self._group_list_initialized
	local player = self:_player()
	local profile = player:profile()
	local current_level = profile and profile.current_level or 0

	Log.info("GroupFinderView", "Received Events: " .. table.tostring(events, 10))

	for j = 1, #events do
		local event = events[j]
		local event_type = event.type

		Log.info("GroupFinderView", "Processing event type: " .. tostring(event_type))

		if event_type == "advertisement_entries_update" then
			if state == STATE.browsing and not self._group_list_initialized then
				group_list_initialized = true

				local entries = event.entries
				local groups = {}

				for i = 1, #entries do
					local entry = entries[i]
					local entry_tags = entry.tags
					local group_tags = {}

					for k = 1, #entry_tags do
						local tag_name = entry_tags[k]
						local tag = self:_get_tag_by_name(tag_name)

						if tag and not tag.root_tag then
							table.insert(group_tags, tag)
						end
					end

					table.sort(group_tags, _tags_sort_function)

					local description = self:_generate_tags_description(group_tags)
					local required_level = self:_get_highest_tag_level_requirement(group_tags) or 0
					local level_requirement_met = required_level <= current_level
					local group = {
						tags = group_tags,
						id = entry.party_id,
						members = {},
						version = entry.version,
						description = description,
						required_level = required_level,
						level_requirement_met = level_requirement_met,
					}

					groups[#groups + 1] = group
				end

				self._groups = groups
			end
		elseif event_type == "party_update" then
			Log.info("GroupFinderView", "Updating participants from party update: " .. table.tostring(event, 10))

			local party = event.party
			local members = party and party.members

			if not members then
				return
			end

			if state == STATE.advertising then
				if party.party_id == self:party_id() then
					break
				end
			elseif state == STATE.browsing then
				local party_id = party.party_id
				local group = self:_group_by_id(party_id)

				if group then
					local group_members = group.members

					for i = #group_members, 1, -1 do
						local group_member = group_members[i]
						local group_member_account_id = group_member.account_id
						local remove = true

						for _, member in ipairs(members) do
							if group_member_account_id == member.account_id then
								remove = false

								break
							end
						end

						if remove then
							table.remove(group_members, i)
						end
					end

					for _, member in ipairs(members) do
						local member_status = member.status

						if member_status == "CONNECTED" then
							local member_account_id = member.account_id
							local group_member = group_members[member_account_id]

							if not group_member then
								group_member = {
									account_id = member_account_id,
									presence_info = {},
								}
								group_members[#group_members + 1] = group_member
							end

							local _, promise = Managers.presence:get_presence(member_account_id)

							self:_cancel_promise_on_exit(promise)
							promise:next(function (data)
								if not data then
									return
								end

								local member_group = self:_group_by_id(party_id)
								local member_group_members = member_group and member_group.members
								local member_data

								if member_group_members then
									for i = 1, #member_group_members do
										if member_group_members[i].account_id == member_account_id then
											member_data = member_group_members[i]

											break
										end
									end
								end

								if member_data then
									local presence_info = member_data.presence_info
									local parsed_character_profile = data._parsed_character_profile

									if parsed_character_profile then
										local name = parsed_character_profile.name
										local member_current_level = parsed_character_profile.current_level
										local archetype = parsed_character_profile.archetype
										local archetype_name = archetype.name

										presence_info.name = name
										presence_info.level = member_current_level
										presence_info.archetype = archetype_name
										presence_info.profile = parsed_character_profile
										presence_info.synced = true
									end
								end
							end):catch(function (error)
								Log.error("GroupFinder", "Presence failed")

								local account_members = self:_group_by_id(party_id)

								if account_members then
									for i = 1, #account_members do
										if account_members[i].account_id == member_account_id then
											table.remove(account_members, i)

											break
										end
									end
								end
							end)
						end
					end
				end
			end
		end
	end

	if state == STATE.browsing and not self._group_list_initialized and group_list_initialized then
		self._group_list_initialized = group_list_initialized

		local cb_on_grid_popluated = callback(function ()
			if self._group_list_initialized then
				self._show_group_loading = false

				local is_list_empty = #self._groups <= 0

				self:_set_group_list_empty_info_visibility(is_list_empty)

				self._last_time_group_list_updated = Managers.ui:get_time("ui")
			end
		end)

		self:_update_group_grid(cb_on_grid_popluated)
	end
end

GroupFinderView._populate_preview_grid = function (self, layout)
	local definitions = self._definitions

	if not self._preview_grid then
		local grid_scenegraph_id = "preview_grid"
		local window_scenegraph_id = "preview_window"
		local scenegraph_definition = definitions.scenegraph_definition
		local window_scenegraph = scenegraph_definition[window_scenegraph_id]
		local grid_size = window_scenegraph.size
		local grid_settings = {
			edge_padding = 0,
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			resource_renderer_background = false,
			scrollbar_horizontal_offset = -5,
			scrollbar_vertical_margin = 0,
			scrollbar_vertical_offset = 0,
			scrollbar_width = 7,
			title_height = 0,
			top_padding = 0,
			widget_icon_load_margin = 0,
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 200,
				grid_size[2] - 20,
			},
			grid_spacing = {
				0,
				0,
			},
		}
		local layer = (self._draw_layer or 0) + 40

		self._preview_grid = self:_add_element(ViewElementGrid, "preview_grid", layer, grid_settings, grid_scenegraph_id)

		self._preview_grid:set_alpha_multiplier(0)

		self._widgets_by_name.preview_window.alpha_multiplier = 0

		self:_update_element_position("preview_grid", self._preview_grid)
		self._preview_grid:set_empty_message("")
	end

	local grid = self._preview_grid

	grid:present_grid_layout(layout, GroupFinderViewDefinitions.grid_blueprints)
	grid:set_handle_grid_navigation(true)
	self:_set_preview_grid_visibility(true)
end

GroupFinderView._set_preview_grid_visibility = function (self, visible)
	self._preview_grid_visibility = visible
	self._widgets_by_name.preview_window.content.visible = visible
end

GroupFinderView._populate_tags_grid = function (self, layout, optional_grid_spacing)
	local definitions = self._definitions

	if not self._tags_grid then
		local grid_scenegraph_id = "tags_grid"
		local scenegraph_definition = definitions.scenegraph_definition
		local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
		local grid_size = grid_scenegraph.size
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = false,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 17,
			scrollbar_width = 7,
			title_height = 0,
			widget_icon_load_margin = 0,
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 20,
				grid_size[2] + mask_padding_size,
			},
			grid_spacing = {
				0,
				0,
			},
		}
		local layer = (self._draw_layer or 0) + 10

		self._tags_grid = self:_add_element(ViewElementGrid, "tags_grid", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position("tags_grid", self._tags_grid)
		self._tags_grid:set_empty_message("")
	end

	local grid = self._tags_grid
	local menu_settings = grid:menu_settings()

	if optional_grid_spacing then
		menu_settings.grid_spacing[1] = optional_grid_spacing[1] or 0
		menu_settings.grid_spacing[2] = optional_grid_spacing[2] or 0
	else
		menu_settings.grid_spacing[1] = 0
		menu_settings.grid_spacing[2] = 0
	end

	local cb_on_grid_layout_updated = callback(self, "_on_populate_tags_grid_completed")

	grid:present_grid_layout(layout, GroupFinderViewDefinitions.grid_blueprints, nil, nil, nil, nil, cb_on_grid_layout_updated)
	grid:set_handle_grid_navigation(true)
end

GroupFinderView._on_populate_tags_grid_completed = function (self)
	self:_update_tag_widgets()
	self:_update_tag_navigation_buttons_status()

	local grid = self._tags_grid
	local widgets = grid:widgets()

	if self._tag_grid_enter_animation_id then
		self:_stop_animation(self._tag_grid_enter_animation_id)

		self._tag_grid_enter_animation_id = nil
	end

	for _, widget in pairs(widgets) do
		widget.alpha_multiplier = 0
	end

	self._tag_grid_enter_animation_id = self:_start_animation("tag_grid_entry", widgets, self)

	if not self:using_cursor_navigation() then
		grid:select_first_index()
	end
end

GroupFinderView._set_tag_grid_visibility = function (self, visible)
	self._tag_grid_visibility = visible
end

GroupFinderView._populate_group_grid = function (self, groups, optional_complete_callback)
	local definitions = self._definitions
	local grid_scenegraph_id = "group_grid"
	local scenegraph_definition = definitions.scenegraph_definition
	local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
	local grid_size = grid_scenegraph.size

	if not self._group_grid then
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 17,
			scrollbar_vertical_margin = 0,
			scrollbar_vertical_offset = 0,
			scrollbar_width = 7,
			title_height = 0,
			top_padding = 0,
			use_select_on_focused = true,
			widget_icon_load_margin = 0,
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 20,
				grid_size[2] + mask_padding_size,
			},
			grid_spacing = {
				0,
				10,
			},
		}
		local layer = (self._draw_layer or 0) + 10

		self._group_grid = self:_add_element(ViewElementGrid, "group_grid", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position("group_grid", self._group_grid)
		self._group_grid:set_empty_message("")
	end

	local grid = self._group_grid
	local layout = {}

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10,
		},
	}

	for i = 1, #groups do
		local group = groups[i]
		local entry = {
			widget_type = "group",
			group = group,
			description = group.description,
			group_id = group.id,
			tags = group.tags,
			required_level = group.required_level,
			level_requirement_met = group.level_requirement_met,
			group_request_status_callback = function ()
				return self:_get_group_request_status(group.id)
			end,
		}

		entry.pressed_callback = callback(self, "_cb_on_list_group_pressed", entry, i)
		layout[#layout + 1] = entry

		if i % 2 == 1 and i < #groups then
			layout[#layout + 1] = {
				widget_type = "dynamic_spacing",
				size = {
					10,
					10,
				},
			}
		end
	end

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10,
		},
	}

	grid:present_grid_layout(layout, GroupFinderViewDefinitions.grid_blueprints, nil, nil, nil, nil, optional_complete_callback)
	grid:set_handle_grid_navigation(true)
end

GroupFinderView._populate_player_request_grid = function (self, join_requests_by_account_id)
	local definitions = self._definitions
	local grid_scenegraph_id = "player_request_grid"
	local scenegraph_definition = definitions.scenegraph_definition
	local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
	local grid_size = grid_scenegraph.size

	if not self._player_request_grid then
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 13,
			scrollbar_vertical_offset = 10,
			scrollbar_width = 7,
			title_height = 0,
			widget_icon_load_margin = 0,
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 20,
				grid_size[2] + mask_padding_size,
			},
			grid_spacing = {
				0,
				10,
			},
		}
		local layer = (self._draw_layer or 0) + 10

		self._player_request_grid = self:_add_element(ViewElementGrid, "player_request_grid", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position("player_request_grid", self._player_request_grid)
		self._player_request_grid:set_empty_message("")
	end

	local grid = self._player_request_grid
	local layout = {}

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			15,
		},
	}

	for account_id, join_request in pairs(join_requests_by_account_id) do
		local presence = join_request.presence
		local name = presence:character_name()
		local profile = presence:character_profile()
		local current_level = profile.current_level
		local archetype = profile.archetype
		local archetype_name = archetype.name
		local presence_info = {
			name = name,
			level = current_level,
			archetype = archetype_name,
			profile = profile,
		}
		local entry = {
			widget_type = "player_request_entry",
			presence_info = presence_info,
			join_request = join_request,
		}

		entry.accept_callback = callback(self, "_cb_on_player_request_accept_pressed", entry)
		entry.decline_callback = callback(self, "_cb_on_player_request_decline_pressed", entry)
		layout[#layout + 1] = entry
	end

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			15,
		},
	}

	local current_selected_grid_index = grid:selected_grid_index()
	local cb_on_grid_layout_updated = callback(self, "_on_populate_player_request_grid_completed", current_selected_grid_index)

	grid:present_grid_layout(layout, GroupFinderViewDefinitions.grid_blueprints, nil, nil, nil, nil, cb_on_grid_layout_updated)
	grid:set_handle_grid_navigation(true)
end

GroupFinderView._on_populate_player_request_grid_completed = function (self, current_selected_grid_index)
	if not self:using_cursor_navigation() and self._state == STATE.advertising then
		local grid = self._player_request_grid

		if current_selected_grid_index then
			grid:select_grid_index(current_selected_grid_index)

			if not grid:selected_grid_index() then
				grid:select_first_index()
			end
		else
			grid:select_first_index()
		end
	end
end

local _dummy_text_size = {
	800,
	50,
}

GroupFinderView._update_player_request_button_decline = function (self)
	local action = self._player_request_button_decline_input_action
	local service_type = "View"
	local include_input_type = false
	local text = TextUtils.localize_with_button_hint(action, "loc_group_finder_player_request_action_decline", nil, service_type, Localize("loc_input_legend_text_template"), include_input_type)
	local widget = self._widgets_by_name.player_request_button_decline

	widget.content.text = text

	if self:using_cursor_navigation() then
		widget.alpha_multiplier = 0
	end

	local width = self:_text_size_for_style(text, widget.style.text, _dummy_text_size)

	self:_set_scenegraph_size("player_request_button_decline", width + 10)
	self:_force_update_scenegraph()
end

GroupFinderView._update_player_request_button_accept = function (self)
	local action = self._player_request_button_accept_input_action
	local service_type = "View"
	local include_input_type = false
	local text = TextUtils.localize_with_button_hint(action, "loc_group_finder_player_request_action_accept", nil, service_type, Localize("loc_input_legend_text_template"), include_input_type)
	local widget = self._widgets_by_name.player_request_button_accept

	widget.content.text = text

	if self:using_cursor_navigation() then
		widget.alpha_multiplier = 0
	end

	local width = self:_text_size_for_style(text, widget.style.text, _dummy_text_size)

	self:_set_scenegraph_size("player_request_button_accept", width + 10)
	self:_set_scenegraph_position("player_request_button_accept", -(width + 10 + 30))
	self:_force_update_scenegraph()
end

GroupFinderView._update_preview_input_text = function (self)
	local action = self._preview_button_input_action
	local service_type = "View"
	local include_input_type = false
	local text = TextUtils.localize_with_button_hint(action, "loc_mission_voting_view_show_details", nil, service_type, Localize("loc_input_legend_text_template"), include_input_type)
	local widget = self._widgets_by_name.preview_input_text

	widget.content.text = text

	local width = self:_text_size_for_style(text, widget.style.text, _dummy_text_size)

	self:_set_scenegraph_size("preview_input_text", width + 10)
end

GroupFinderView._update_refresh_button_text = function (self)
	local action = self._refresh_button_input_action
	local service_type = "View"
	local include_input_type = false
	local text = TextUtils.localize_with_button_hint(action, "loc_group_finder_refresh_group_list_button", nil, service_type, Localize("loc_input_legend_text_template"), include_input_type)
	local widget = self._widgets_by_name.refresh_button

	widget.content.text = text

	local width = self:_text_size_for_style(text, widget.style.text, _dummy_text_size)

	self:_set_scenegraph_size("refresh_button", width + 10)
end

GroupFinderView._on_navigation_input_changed = function (self)
	GroupFinderView.super._on_navigation_input_changed(self)
	self:_update_grids_selection()
	self:_update_player_request_button_accept()
	self:_update_player_request_button_decline()
	self:_update_refresh_button_text()
	self:_update_preview_input_text()
end

GroupFinderView._update_grids_selection = function (self)
	local using_cursor_navigation = self:using_cursor_navigation()
	local state = self._state
	local tags_grid = self._tags_grid
	local group_grid = self._group_grid
	local player_request_grid = self._player_request_grid

	if using_cursor_navigation then
		if tags_grid then
			tags_grid:select_grid_index(nil)
		end

		if group_grid then
			group_grid:select_grid_index(nil)
		end

		if player_request_grid then
			player_request_grid:select_grid_index(nil)
		end
	elseif state == STATE.advertising then
		if tags_grid then
			tags_grid:select_grid_index(nil)
		end

		if group_grid then
			group_grid:select_grid_index(nil)
		end

		if player_request_grid and not player_request_grid:selected_grid_index() then
			player_request_grid:select_first_index()
		end
	elseif state == STATE.browsing then
		if player_request_grid then
			player_request_grid:select_grid_index(nil)
		end

		if not tags_grid:selected_grid_index() then
			tags_grid:select_first_index()
			group_grid:select_grid_index(nil)
		end
	end
end

GroupFinderView._cancel_promise_on_exit = function (self, promise)
	local promises = self._promises

	if promise:is_pending() and not promises[promise] then
		promises[promise] = true

		promise:next(function ()
			self._promises[promise] = nil
		end, function ()
			self._promises[promise] = nil
		end)
	end

	return promise
end

GroupFinderView._callback_open_options = function (self, region_data)
	self._mission_board_options = self:_add_element(ViewElementMissionBoardOptions, "mission_board_options_element", 200, {
		on_destroy_callback = callback(self, "_callback_close_options"),
	})

	local regions_latency = self._regions_latency
	local presentation_data = {
		{
			display_name = "loc_mission_board_view_options_Matchmaking_Location",
			id = "region_matchmaking",
			tooltip_text = "loc_matchmaking_change_region_confirmation_desc",
			widget_type = "dropdown",
			validation_function = function ()
				return
			end,
			on_activated = function (value, template)
				BackendUtilities.prefered_mission_region = value
			end,
			get_function = function (template)
				local options = template.options_function()

				for i = 1, #options do
					local option = options[i]

					if option.value == BackendUtilities.prefered_mission_region then
						return option.id
					end
				end

				return 1
			end,
			options_function = function (template)
				local options = {}

				for region_name, latency_data in pairs(regions_latency) do
					local loc_key = RegionLocalizationMappings[region_name]
					local ignore_localization = true
					local region_display_name = loc_key and Localize(loc_key) or region_name

					if math.abs(latency_data.min_latency - latency_data.max_latency) < 5 then
						region_display_name = string.format("%s %dms", region_display_name, latency_data.min_latency)
					else
						region_display_name = string.format("%s %d-%dms", region_display_name, latency_data.min_latency, latency_data.max_latency)
					end

					options[#options + 1] = {
						id = region_name,
						display_name = region_display_name,
						ignore_localization = ignore_localization,
						value = region_name,
						latency_order = latency_data.min_latency,
					}
				end

				table.sort(options, function (a, b)
					return a.latency_order < b.latency_order
				end)

				return options
			end,
			on_changed = function (value)
				BackendUtilities.prefered_mission_region = value
			end,
		},
		{
			display_name = "loc_private_tag_name",
			id = "private_match",
			tooltip_text = "loc_mission_board_view_options_private_game_desc",
			widget_type = "checkbox",
			start_value = self._private_match,
			get_function = function ()
				return self._private_match
			end,
			on_activated = function (value, data)
				data.changed_callback(value)
			end,
			on_changed = function (value)
				self:_callback_toggle_private_matchmaking()
			end,
		},
	}

	self._mission_board_options:present(presentation_data)
end

GroupFinderView._callback_close_options = function (self)
	self:_destroy_options_element()
end

GroupFinderView._destroy_options_element = function (self)
	self:_remove_element("mission_board_options_element")

	self._mission_board_options = nil
end

GroupFinderView.fetch_regions = function (self)
	local region_promise = Managers.backend.interfaces.region_latency:get_region_latencies()

	self._region_promise = region_promise

	self:_cancel_promise_on_exit(region_promise):next(function (regions_data)
		local prefered_region_promise

		if BackendUtilities.prefered_mission_region == "" then
			prefered_region_promise = self:_cancel_promise_on_exit(Managers.backend.interfaces.region_latency:get_preferred_reef())
		else
			prefered_region_promise = Promise.resolved()
		end

		prefered_region_promise:next(function (prefered_region)
			BackendUtilities.prefered_mission_region = BackendUtilities.prefered_mission_region ~= "" and BackendUtilities.prefered_mission_region or prefered_region or regions_data[1].reefs[1]

			local regions_latency = Managers.backend.interfaces.region_latency:get_reef_info_based_on_region_latencies(regions_data)

			self._regions_latency = regions_latency
			self._region_promise = nil
		end)
	end)

	return region_promise
end

GroupFinderView._callback_toggle_private_matchmaking = function (self)
	self._private_match = not self._private_match

	if self._solo_play then
		self._solo_play = false
	end

	self:_set_play_button_game_mode_text(self._solo_play, self._private_match)

	local mission_board_save_data = self._mission_board_save_data

	if mission_board_save_data then
		local changed = false

		if self._private_match ~= mission_board_save_data.private_matchmaking then
			mission_board_save_data.private_matchmaking = self._private_match
			changed = true
		end

		if changed then
			Managers.save:queue_save()
		end
	end
end

return GroupFinderView
