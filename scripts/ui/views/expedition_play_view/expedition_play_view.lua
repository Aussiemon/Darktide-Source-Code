-- chunkname: @scripts/ui/views/expedition_play_view/expedition_play_view.lua

local ExpeditionPlayViewDefinitions = require("scripts/ui/views/expedition_play_view/expedition_play_view_definitions")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local Danger = require("scripts/utilities/danger")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local Promise = require("scripts/foundation/utilities/promise")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local Zones = require("scripts/settings/zones/zones")
local ViewElementMissionBoardOptions = require("scripts/ui/view_elements/view_element_mission_board_options/view_element_mission_board_options")
local Text = require("scripts/utilities/ui/text")
local MissionUtilities = require("scripts/utilities/ui/mission")
local RegionLocalizationMappings = require("scripts/settings/backend/region_localization")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local ExpeditionPlayViewSettings = require("scripts/ui/views/expedition_play_view/expedition_play_view_settings")
local ExpeditionPlayViewTutorialBlueprints = require("scripts/ui/views/talent_builder_view/talent_builder_view_tutorial_blueprints")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ExpeditionPlayView = class("ExpeditionPlayView", "BaseView")

ExpeditionPlayView.init = function (self, settings, context)
	local parent = context and context.parent

	self._parent = parent
	self._backend_data_expiry_time = -1
	self._promises = {}
	self._cb_fetch_success = callback(self, "_fetch_success")
	self._cb_fetch_failure = callback(self, "_fetch_failure")
	self._play_button_anim_delay = 1

	local save_data = Managers.save:account_data()

	save_data.mission_board = save_data.mission_board or {}
	self._mission_board_save_data = save_data.mission_board
	self._mission_board_save_data.private_matchmaking = self._mission_board_save_data.private_matchmaking or false
	self._private_match = self._mission_board_save_data.private_matchmaking
	self._play_fast_enter_animation = context and context.play_fast_enter_animation
	self._info_button_input_action = "hotkey_menu_special_2"
	self._reward_change_button_input_action = "hotkey_menu_special_1"
	self._promise_container = PromiseContainer:new()

	local player = self:_player()
	local profile = player:profile()

	self._player_level = profile.current_level

	local party_manager = Managers.party_immaterium

	self._party_manager = party_manager

	ExpeditionPlayView.super.init(self, ExpeditionPlayViewDefinitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
end

ExpeditionPlayView.on_enter = function (self)
	ExpeditionPlayView.super.on_enter(self)

	self._widgets_by_name.play_button.content.hotspot.pressed_callback = callback(self, "_cb_on_mission_start")
	self._widgets_by_name.info_button.content.hotspot.pressed_callback = callback(self, "_cb_view_expedition_info")
	self._widgets_by_name.info_button.style.text.text_horizontal_alignment = "left"
	self._widgets_by_name.info_button.style.text.text_vertical_alignment = "top"
	self._widgets_by_name.reward_change_button.style.text.text_horizontal_alignment = "right"
	self._widgets_by_name.reward_change_button.style.text.text_vertical_alignment = "center"

	local tutorial_definitions = {
		widget_definitions = ExpeditionPlayViewDefinitions.tutorial_widgets_definitions,
	}
	local tutorial_widgets = {}

	self._tutorial_widgets = tutorial_widgets

	local tutorial_widgets_by_name = {}

	self._tutorial_widgets_by_name = tutorial_widgets_by_name

	self:_create_widgets(tutorial_definitions, tutorial_widgets, tutorial_widgets_by_name)
	self:_create_node_widgets()
	self:fetch_regions()
	self:_update_info_button_text()
	self:_update_reward_change_button_text()
	self:_set_play_button_game_mode_text(self._solo_play, self._private_match)

	local collected_loot = Managers.data_service.expedition:collected_loot()

	self._reward_presentation_delay = 1
	self._current_reward_data = {
		max_amount = 2500,
		previously_looted = 0,
		recently_looted = collected_loot,
	}

	self:_update_reward_progress_presentation(self._current_reward_data, 0)

	local save_manager = Managers.save
	local show_tutorial_popup = true

	if show_tutorial_popup then
		self:_show_tutorial_window()
	else
		self:_hide_tutorial_window()
	end
end

ExpeditionPlayView.can_show_tutorial = function (self)
	if not self._tutorial_grid then
		return true
	end

	return false
end

ExpeditionPlayView.cb_show_tutorial_window = function (self)
	self._show_tutorial_window_next_frame = true
end

ExpeditionPlayView._show_tutorial_window = function (self)
	self._show_tutorial_window_next_frame = false

	if not self:can_show_tutorial() then
		return
	end

	self._tutorial_widgets_by_name.tutorial_window.content.visible = true
	self._tutorial_widgets_by_name.tutorial_button_1.content.visible = true
	self._tutorial_widgets_by_name.tutorial_button_2.content.visible = true

	self:_setup_tutorial_grid()
	self:_present_tutorial_popup_page(1)
end

ExpeditionPlayView._setup_tutorial_grid = function (self)
	local definitions = self._definitions

	if not self._tutorial_grid then
		local grid_scenegraph_id = "tutorial_grid"
		local scenegraph_definition = definitions.scenegraph_definition
		local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
		local grid_size = grid_scenegraph.size
		local mask_padding_size = 0
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 18,
			scrollbar_width = 7,
			title_height = 0,
			widget_icon_load_margin = 0,
			grid_spacing = {
				0,
				0,
			},
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 20,
				grid_size[2] + mask_padding_size,
			},
		}
		local layer = (self._draw_layer or 0) + 10

		self._tutorial_grid = self:_add_element(ViewElementGrid, "tutorial_grid", layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position("tutorial_grid", self._tutorial_grid)
		self._tutorial_grid:set_empty_message("")
	end

	self._tutorial_widgets_by_name.tutorial_button_1.content.hotspot.pressed_callback = callback(self, "cb_on_tutorial_button_1_pressed")
	self._tutorial_widgets_by_name.tutorial_button_2.content.hotspot.pressed_callback = callback(self, "cb_on_tutorial_button_2_pressed")
	self._tutorial_window_open_animation_id = self:_start_animation("tutorial_window_open", self._tutorial_widgets_by_name, self)

	self:_play_sound(UISoundEvents.tutorial_popup_enter)
end

ExpeditionPlayView._present_tutorial_popup_page = function (self, page_index)
	local tutorial_popup_pages = ExpeditionPlayViewSettings.tutorial_popup_pages
	local page_content = tutorial_popup_pages[page_index]
	local tutorial_widgets_by_name = self._tutorial_widgets_by_name

	tutorial_widgets_by_name.tutorial_window.content.page_counter = tostring(page_index) .. "/" .. tostring(#tutorial_popup_pages)
	tutorial_widgets_by_name.tutorial_window.content.title = Localize(page_content.header)
	tutorial_widgets_by_name.tutorial_window.content.image = page_content.image

	local layout = {}

	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			10,
		},
	}
	layout[#layout + 1] = {
		widget_type = "text",
		text = Localize(page_content.text),
	}
	layout[#layout + 1] = {
		widget_type = "dynamic_spacing",
		size = {
			500,
			25,
		},
	}

	local grid = self._tutorial_grid

	grid:present_grid_layout(layout, ExpeditionPlayViewTutorialBlueprints)
	grid:set_handle_grid_navigation(true)

	self._active_tutorial_popup_page = page_index

	self:_update_tutorial_button_texts()
end

ExpeditionPlayView._hide_tutorial_window = function (self)
	self._tutorial_widgets_by_name.tutorial_window.content.visible = false
	self._tutorial_window_hovered = false
	self._tutorial_widgets_by_name.tutorial_button_1.content.visible = false
	self._tutorial_widgets_by_name.tutorial_button_2.content.visible = false

	if self._tutorial_grid then
		self:_remove_element("tutorial_grid")

		self._tutorial_grid = nil

		self:_play_sound(UISoundEvents.tutorial_popup_exit)

		local save_manager = Managers.save
		local save_data = save_manager:account_data()
	end

	self._close_tutorial_grid_next_frame = false

	if self._tutorial_window_open_animation_id then
		self:_stop_animation(self._tutorial_window_open_animation_id)

		self._tutorial_window_open_animation_id = nil
	end
end

ExpeditionPlayView._handle_tutorial_button_gamepad_navigation = function (self, input_service)
	local tutorial_widgets_by_name = self._tutorial_widgets_by_name

	if input_service:get("navigate_left_continuous") then
		if not tutorial_widgets_by_name.tutorial_button_1.content.hotspot.is_selected then
			tutorial_widgets_by_name.tutorial_button_1.content.hotspot.is_selected = true
			tutorial_widgets_by_name.tutorial_button_2.content.hotspot.is_selected = false

			self:_play_sound(UISoundEvents.default_mouse_hover)
		end
	elseif input_service:get("navigate_right_continuous") and not tutorial_widgets_by_name.tutorial_button_2.content.hotspot.is_selected then
		tutorial_widgets_by_name.tutorial_button_1.content.hotspot.is_selected = false
		tutorial_widgets_by_name.tutorial_button_2.content.hotspot.is_selected = true

		self:_play_sound(UISoundEvents.default_mouse_hover)
	end
end

ExpeditionPlayView._update_tutorial_button_texts = function (self)
	local page_index = self._active_tutorial_popup_page

	if not page_index then
		return
	end

	local tutorial_popup_pages = ExpeditionPlayViewSettings.tutorial_popup_pages
	local page_content = tutorial_popup_pages[page_index]
	local using_cursor_navigation = self._using_cursor_navigation
	local tutorial_widgets_by_name = self._tutorial_widgets_by_name
	local button_1_default_text = page_content.button_1 and Localize(page_content.button_1) or "n/a"
	local button_2_default_text = page_content.button_2 and Localize(page_content.button_2) or "n/a"

	tutorial_widgets_by_name.tutorial_button_1.content.original_text = button_1_default_text
	tutorial_widgets_by_name.tutorial_button_2.content.original_text = button_2_default_text

	if using_cursor_navigation then
		tutorial_widgets_by_name.tutorial_button_1.content.hotspot.is_selected = false
		tutorial_widgets_by_name.tutorial_button_2.content.hotspot.is_selected = false
	elseif not tutorial_widgets_by_name.tutorial_button_1.content.hotspot.is_selected or tutorial_widgets_by_name.tutorial_button_2.content.hotspot.is_selected then
		tutorial_widgets_by_name.tutorial_button_1.content.hotspot.is_selected = false
		tutorial_widgets_by_name.tutorial_button_2.content.hotspot.is_selected = true
	end
end

ExpeditionPlayView.cb_on_tutorial_button_1_pressed = function (self)
	local current_page_index = self._active_tutorial_popup_page or 1

	if current_page_index > 1 then
		local next_page_index = math.max(current_page_index - 1, 1)

		self:_present_tutorial_popup_page(next_page_index)
		self:_play_sound(UISoundEvents.tutorial_popup_slide_previous)
	else
		self._close_tutorial_grid_next_frame = true
	end
end

ExpeditionPlayView.cb_on_tutorial_button_2_pressed = function (self)
	local current_page_index = self._active_tutorial_popup_page or 1

	if current_page_index < #ExpeditionPlayViewSettings.tutorial_popup_pages then
		local next_page_index = math.min(current_page_index + 1, #ExpeditionPlayViewSettings.tutorial_popup_pages)

		self:_present_tutorial_popup_page(next_page_index)
		self:_play_sound(UISoundEvents.tutorial_popup_slide_next)
	else
		self._close_tutorial_grid_next_frame = true
	end
end

ExpeditionPlayView._is_handling_popup_window = function (self)
	return self._tutorial_grid and true or false
end

ExpeditionPlayView._cb_view_expedition_info = function (self)
	Managers.event:trigger("event_select_story_mission_background_option", 3)
end

ExpeditionPlayView._debug_start_mission_level = function (self, mission_name, layout_seed)
	local mechanism_context = {
		mission_name = mission_name,
		layout_seed = layout_seed,
	}
	local Missions = require("scripts/settings/mission/mission_templates")
	local mission_settings = Missions[mission_name]
	local mechanism_name = mission_settings.mechanism_name
	local game_mode_name = mission_settings.game_mode_name
	local game_mode_settings = GameModeSettings[game_mode_name]

	if game_mode_settings.host_singleplay then
		Managers.multiplayer_session:boot_singleplayer_session()
	end

	local is_host = Managers.connection:is_host()

	if is_host then
		Managers.connection:reset_seed()
	end

	Managers.mechanism:change_mechanism(mechanism_name, mechanism_context)
	Managers.mechanism:trigger_event("all_players_ready")
end

ExpeditionPlayView._cb_on_mission_start = function (self)
	if not self.can_start_mission then
		return
	end

	local mission = self._selected_mission

	if not mission then
		return
	end

	self:_play_sound(UISoundEvents.expedition_menu_start)
	self:on_back_pressed()
	Managers.event:trigger("event_story_mission_started")

	local prefered_mission_region = Managers.data_service.region_latency:get_prefered_mission_region()

	self._party_manager:wanted_mission_selected(mission.id, self._private_match, prefered_mission_region)
end

ExpeditionPlayView._update_fetch_missions = function (self, t)
	if t < self._backend_data_expiry_time or self._is_fetching_missions then
		return
	end

	self._is_fetching_missions = true

	self._promise_container:cancel_on_destroy(Managers.data_service.mission_board:fetch(nil, 1)):next(function (mission_data)
		return Promise.resolved(mission_data)
	end):next(self._cb_fetch_success):catch(self._cb_fetch_failure)
end

ExpeditionPlayView._extract_and_validate_node_id = function (self, mission_flags)
	if not mission_flags then
		return nil
	end

	local node_ids = {}
	local prefix = "exped-node-"

	for flag, _ in pairs(mission_flags) do
		local a, b = string.find(flag, prefix, 1, true)

		if a == 1 and b == #prefix then
			table.insert(node_ids, flag)
		end
	end

	if #node_ids == 1 then
		return node_ids[1]
	end

	return nil
end

ExpeditionPlayView._missions_for_selected_node = function (self, missions, selected_node)
	local selected_node_missions = {}

	for _, mission in pairs(missions) do
		for flag, _ in pairs(mission.flags) do
			if flag == selected_node then
				table.insert(selected_node_missions, mission)
			end
		end
	end

	return selected_node_missions
end

ExpeditionPlayView._fetch_success = function (self, data)
	local missions = data.missions
	local filtered_nodes = {}
	local filtered_missions = {}

	for _, mission in ipairs(missions) do
		local valid = true

		if mission.category == "expedition" then
			valid = valid and mission.flags ~= nil

			if valid then
				local node_id = self:_extract_and_validate_node_id(mission.flags)

				valid = node_id ~= nil

				if valid then
					table.insert_unique(filtered_nodes, node_id)
				end
			end
		end

		if valid then
			filtered_missions[#filtered_missions + 1] = mission
		end
	end

	local function sort_func(a, b)
		local a_danger_level = Danger.calculate_danger(a.challenge, a.resistance)
		local b_danger_level = Danger.calculate_danger(b.challenge, b.resistance)

		return a_danger_level < b_danger_level
	end

	table.sort(filtered_missions, sort_func)

	self._node_ids = filtered_nodes
	self._missions = filtered_missions

	if not self._selected_node_id then
		self._selected_node_id = filtered_nodes[1]
	end

	local selected_node_missions = self:_missions_for_selected_node(self._missions, self._selected_node_id)

	for name, widget in pairs(self._node_widgets_by_name) do
		widget.content.hotspot.is_selected = name == self._selected_node_id
	end

	local option_widgets = {}
	local available_missions = selected_node_missions
	local num_missions_to_display = math.min(#available_missions, 3)

	if #available_missions > 0 then
		for i = 1, num_missions_to_display do
			local mission = available_missions[math.min(i, #available_missions)]

			self:_assign_option_data(i, mission)

			local widgets_by_name = self._widgets_by_name

			option_widgets[i] = widgets_by_name["option_" .. i]
		end
	end

	self._option_widgets = option_widgets
	self._backend_data = data
	self._backend_data_expiry_time = data.expiry_game_time
	self._is_fetching_missions = false

	if not self._initialized and #available_missions > 0 then
		self._initialized = true

		if self._play_fast_enter_animation then
			self._enter_animation_id = self:_start_animation("on_enter_fast", self._widgets_by_name, self)
		else
			self._enter_animation_id = self:_start_animation("on_enter", self._widgets_by_name, self)
		end

		local ignore_sound = true

		self:_set_selected_option(1, ignore_sound)
	elseif self._initialized and #available_missions == 0 then
		self._initialized = false

		for i = 1, #self._widgets do
			local widget = self._widgets[i]

			widget.alpha_multiplier = #available_missions > 0 and 1 or 0
		end
	end
end

ExpeditionPlayView._fetch_failure = function (self, error_message)
	Log.error("ExpeditionPlayView", "Fetching missions failed %s %s", error_message[1], error_message[2])

	local fetch_retry_cooldown = 5

	self._backend_data_expiry_time = Managers.time:time("main") + fetch_retry_cooldown
	self._is_fetching_missions = false
	self._initialized = true
end

ExpeditionPlayView._set_selected_option = function (self, index, ignore_sound)
	local option_widgets = self._option_widgets

	for i = 1, #option_widgets do
		local widget = option_widgets[i]
		local content = widget.content
		local hotspot = content.hotspot

		hotspot.is_selected = i == index
	end

	local missions = self:_missions_for_selected_node(self._missions, self._selected_node_id or self._node_ids[1])
	local mission = missions[index]

	if mission then
		self:_set_selected_mission(mission)
	end

	self._selected_mission_index = index

	if not ignore_sound then
		self:_play_sound(UISoundEvents.story_mission_option_selected)
	end
end

ExpeditionPlayView._cb_on_options_button_pressed = function (self, option_index, data)
	self:_set_selected_option(option_index)
end

ExpeditionPlayView._assign_option_data = function (self, option_index, data)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name["option_" .. option_index]
	local content = widget.content
	local style = widget.style

	content.hotspot.pressed_callback = callback(self, "_cb_on_options_button_pressed", option_index, data)

	local danger_settings = Danger.danger_by_difficulty(data.challenge, data.resistance)
	local danger_color = danger_settings.color

	for i = 1, 5 do
		local difficulty_style_id = "difficulty_box_" .. i
		local color = style[difficulty_style_id].color

		if i <= danger_settings.index then
			local ignore_alpha = true

			ColorUtilities.color_copy(danger_color, color, ignore_alpha)
		end
	end

	local xp = data.xp
	local credits = data.credits
	local extraRewards = data.extraRewards.circumstance

	xp = extraRewards and extraRewards.xp and extraRewards.xp + xp or xp
	credits = extraRewards and extraRewards.credits and extraRewards.credits + credits or credits

	local rewards = {
		{
			icon = "content/ui/materials/icons/currencies/credits_small",
			amount = credits,
		},
		{
			icon = "content/ui/materials/icons/currencies/experience_small",
			amount = xp,
		},
	}
	local ui_renderer = self:ui_renderer()
	local reward_spacing = 15
	local total_reward_horizontal_offset = 0

	for i = 1, #rewards do
		local reward = rewards[i]
		local amount_text = "+" .. Text.format_currency(reward.amount or 0)
		local text_id = "reward_text_" .. i
		local icon_id = "reward_icon_" .. i

		content[icon_id] = reward.icon
		content[text_id] = amount_text

		local icon_style = style[icon_id]
		local text_style = style[text_id]
		local icon_text_width_difference = math.abs(text_style.default_offset[1]) - math.abs(icon_style.default_offset[1])

		icon_style.offset[1] = icon_style.default_offset[1] - total_reward_horizontal_offset

		local text_width = Text.text_width(ui_renderer, amount_text, text_style, {
			400,
			30,
		})

		text_style.offset[1] = text_style.default_offset[1] - total_reward_horizontal_offset
		total_reward_horizontal_offset = total_reward_horizontal_offset + text_width + icon_text_width_difference + reward_spacing
	end

	local display_name = danger_settings.display_name

	content.title_text = Localize(display_name)
end

ExpeditionPlayView._set_selected_mission = function (self, mission)
	self._selected_mission = mission

	local widgets_by_name = self._widgets_by_name
	local map = mission.map
	local mission_template = MissionTemplates[map]
	local widget = widgets_by_name.detail

	widget.dirty = true
	widget.visible = true

	local content = widget.content
	local player_level = self._player_level
	local required_level = mission.requiredLevel or 0
	local is_locked = player_level < required_level
	local mission_type = MissionTypes[mission_template.mission_type or "undefined"]

	content.header_icon = mission_type.icon
	content.header_subtitle = Localize(Zones[mission_template.zone_id].name)
	content.header_title = Localize(mission_template.mission_name)
	content.is_locked = is_locked
	content.start_game_time = mission.start_game_time
	content.expiry_game_time = mission.expiry_game_time
	content.is_flash = mission.flags.flash

	local location_image_material_values = widget.style.location_image.material_values

	location_image_material_values.texture_map = mission_template.texture_big
	location_image_material_values.show_static = is_locked and 1 or 0

	local objective_widget = widgets_by_name.objective

	objective_widget.content.header_icon = mission_type.icon
	objective_widget.content.header_title = Localize("loc_misison_board_main_objective_title")
	objective_widget.content.header_subtitle = Localize(mission_type.name)
	objective_widget.content.body_text = Localize(mission_template.mission_description)
	objective_widget.content.is_locked = is_locked
end

ExpeditionPlayView._update_reward_bar_animations = function (self, dt, t)
	if self._reward_presentation_delay then
		self._reward_presentation_delay = self._reward_presentation_delay - dt

		if self._reward_presentation_delay <= 0 then
			self._reward_presentation_delay = nil
			self._reward_presentation_time = 0
		end
	elseif self._reward_presentation_time then
		local time = self._reward_presentation_time
		local reward_data = self._current_reward_data
		local previous_amount = reward_data.previously_looted
		local amount_collected = reward_data.recently_looted
		local max_amount = reward_data.max_amount
		local max_anim_amount = max_amount - previous_amount
		local amount_collected_capped = math.min(amount_collected, max_anim_amount)
		local max_time = 2
		local total_time = math.max(max_time * 0.33, max_time * (amount_collected_capped / max_amount))
		local new_time = math.min(time + dt, total_time)
		local progress = new_time / total_time

		if progress >= 1 then
			self._reward_presentation_time = nil
		else
			self._reward_presentation_time = new_time
		end

		self:_update_reward_progress_presentation(reward_data, progress)
	end
end

ExpeditionPlayView._update_reward_progress_presentation = function (self, reward_data, progress)
	local anim_progress = progress
	local previous_amount = reward_data.previously_looted
	local amount_collected = reward_data.recently_looted
	local max_amount = reward_data.max_amount
	local max_anim_amount = max_amount - previous_amount
	local amount_collected_capped = math.min(amount_collected, max_anim_amount)
	local amount_to_present = previous_amount + math.ceil(amount_collected_capped * anim_progress)
	local reward_progress_bar = self._widgets_by_name.reward_progress_bar

	reward_progress_bar.content.progress = amount_to_present / max_amount

	local reward_area = self._widgets_by_name.reward_area

	reward_area.content.counter_title = amount_to_present .. " / " .. max_amount .. " Collected"
end

ExpeditionPlayView._update_info_button_text = function (self)
	local action = self._info_button_input_action
	local service_type = "View"
	local include_input_type = false
	local button_text = Text.localize_with_button_hint(action, "loc_story_mission_play_menu_info_button_text", nil, service_type, Localize("loc_input_legend_text_template"), include_input_type)

	self._widgets_by_name.info_button.content.text = button_text
end

ExpeditionPlayView._update_reward_change_button_text = function (self)
	local action = self._reward_change_button_input_action
	local service_type = "View"
	local include_input_type = false
	local button_text = Text.localize_with_button_hint(action, "loc_contracts_reroll_button", nil, service_type, Localize("loc_input_legend_text_template"), include_input_type)

	self._widgets_by_name.reward_change_button.content.text = button_text
end

ExpeditionPlayView._on_navigation_input_changed = function (self)
	ExpeditionPlayView.super._on_navigation_input_changed(self)
	self:_update_info_button_text()
	self:_update_reward_change_button_text()
end

ExpeditionPlayView.on_resolution_modified = function (self, scale)
	ExpeditionPlayView.super.on_resolution_modified(self, scale)
end

ExpeditionPlayView.on_back_pressed = function (self)
	if self._mission_board_options then
		return true
	end

	if Managers.ui:view_active("expedition_background_view") then
		Managers.ui:close_view("expedition_background_view")

		return true
	end

	return false
end

ExpeditionPlayView.draw = function (self, dt, t, input_service, layer)
	if not self._initialized then
		return
	end

	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer

	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local alpha_multiplier = render_settings.alpha_multiplier
	local stored_input_service = input_service

	if self._mission_board_options then
		input_service = input_service:null_service()
	end

	local ui_scenegraph = self._ui_scenegraph
	local tutorial_widgets = self._tutorial_widgets

	if tutorial_widgets then
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

		local num_widgets = #tutorial_widgets

		for i = 1, num_widgets do
			local widget = tutorial_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end

		UIRenderer.end_pass(ui_renderer)

		if self._tutorial_grid then
			input_service = input_service:null_service()
		end
	end

	self:_draw_node_widgets(dt, t, input_service, ui_renderer, render_settings, ui_scenegraph)
	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer, render_settings)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, stored_input_service)

	render_settings.alpha_multiplier = alpha_multiplier
end

ExpeditionPlayView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ExpeditionPlayView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

local _required_level_loc_table = {
	required_level = -1,
}

ExpeditionPlayView._update_can_start_mission = function (self)
	local player_level = self._player_level
	local mission = self._selected_mission
	local required_level = mission and mission.requiredLevel or 0
	local is_locked = false

	if player_level < required_level then
		_required_level_loc_table.required_level = required_level

		self:_set_info_text("warning", Localize("loc_mission_board_view_required_level", true, _required_level_loc_table))

		is_locked = true
	elseif not self._party_manager:are_all_members_in_hub() then
		self:_set_info_text("warning", Localize("loc_mission_board_team_mate_not_available"))

		is_locked = true
	elseif self._private_match then
		if self._party_manager:num_other_members() < 1 then
			self:_set_info_text("warning", Localize("loc_mission_board_cannot_private_match"))

			is_locked = true
		else
			self:_set_info_text("info", nil)
		end
	else
		self:_set_info_text("info", nil)
	end

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.play_button.content.visible = not is_locked
	widgets_by_name.play_button_legend.content.visible = not is_locked

	if is_locked then
		self._play_button_anim_delay = nil
	end

	self.can_start_mission = not is_locked

	return is_locked
end

ExpeditionPlayView._set_info_text = function (self, level, text)
	local info_box = self._widgets_by_name.info_box

	info_box.visible = not not text

	if text then
		info_box.content.text = text
		info_box.style.frame.color = info_box.style.frame["color_" .. level]
	end
end

ExpeditionPlayView._set_play_button_game_mode_text = function (self, is_solo_play, is_private_match)
	local play_button_legend_content = self._widgets_by_name.play_button_legend.content

	if not is_solo_play and not is_private_match then
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_play_public"))
	elseif is_solo_play then
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_toggle_solo_play"))
	else
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_play_private"))
	end
end

ExpeditionPlayView.update = function (self, dt, t, input_service)
	if self._show_tutorial_window_next_frame then
		self:_show_tutorial_window()
	end

	if self._close_tutorial_grid_next_frame then
		self:_hide_tutorial_window()
	end

	self:_update_reward_bar_animations(dt, t)

	self._is_in_matchmaking = self:_get_matchmaking_status()

	self:_update_fetch_missions(t)
	self:_update_can_start_mission()

	local pass_input, pass_draw = ExpeditionPlayView.super.update(self, dt, t, input_service)

	if self:_is_handling_popup_window() then
		pass_input = false
	end

	return pass_input, pass_draw
end

ExpeditionPlayView._get_matchmaking_status = function (self)
	return not self._party_manager:are_all_members_in_hub()
end

ExpeditionPlayView._handle_input = function (self, input_service, dt, t)
	if self._mission_board_options or not self._initialized then
		input_service = input_service:null_service()
	end

	local tutorial_widgets_by_name = self._tutorial_widgets_by_name

	if self._tutorial_grid then
		if not self._close_tutorial_grid_next_frame and not self._tutorial_window_open_animation_id then
			self:_handle_tutorial_button_gamepad_navigation(input_service)

			if input_service:get("back") then
				self:cb_on_tutorial_button_1_pressed()
			elseif input_service:get("gamepad_confirm_pressed") then
				if tutorial_widgets_by_name.tutorial_button_1.content.hotspot.is_selected then
					self:cb_on_tutorial_button_1_pressed()
				elseif tutorial_widgets_by_name.tutorial_button_2.content.hotspot.is_selected then
					self:cb_on_tutorial_button_2_pressed()
				end
			end
		end

		if self._tutorial_window_open_animation_id and self:_is_animation_completed(self._tutorial_window_open_animation_id) then
			self._tutorial_window_open_animation_id = nil
		end
	else
		local selected_mission_index = self._selected_mission_index

		if selected_mission_index then
			local handled = false

			if not Managers.ui:using_cursor_navigation() and input_service:get("confirm_pressed") and self.can_start_mission then
				handled = true

				self:_cb_on_mission_start()
			end

			if not handled then
				local info_button_input_action = self._info_button_input_action

				if input_service:get(info_button_input_action) then
					self:_cb_view_expedition_info()
				end
			end

			if not handled then
				local new_index

				if input_service:get("navigate_up_continuous") then
					new_index = math.max(selected_mission_index - 1, 1)
				elseif input_service:get("navigate_down_continuous") then
					local num_options = #self._option_widgets

					new_index = math.min(selected_mission_index + 1, num_options)
				end

				if new_index and new_index ~= selected_mission_index then
					self:_set_selected_option(new_index)
				end
			end
		end
	end
end

ExpeditionPlayView.on_exit = function (self)
	if self._enter_animation_id then
		self:_stop_animation(self._enter_animation_id)

		self._enter_animation_id = nil
	end

	if self._play_button_animation_id then
		self:_stop_animation(self._play_button_animation_id)

		self._play_button_animation_id = nil
	end

	ExpeditionPlayView.super.on_exit(self)
end

ExpeditionPlayView.destroy = function (self)
	self._promise_container:delete()
	ExpeditionPlayView.super.destroy(self)
end

ExpeditionPlayView.ui_renderer = function (self)
	return self._ui_renderer
end

ExpeditionPlayView._callback_open_options = function (self, region_data)
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
				Managers.data_service.region_latency:set_prefered_mission_region(value)
			end,
			get_function = function (template)
				local options = template.options_function()
				local prefered_mission_region = Managers.data_service.region_latency:get_prefered_mission_region()

				for i = 1, #options do
					local option = options[i]

					if option.value == prefered_mission_region then
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
				Managers.data_service.region_latency:set_prefered_mission_region(value)
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

ExpeditionPlayView._callback_close_options = function (self)
	self:_destroy_options_element()
end

ExpeditionPlayView._destroy_options_element = function (self)
	self:_remove_element("mission_board_options_element")

	self._mission_board_options = nil
end

ExpeditionPlayView.dialogue_system = function (self)
	return self._parent and self._parent:dialogue_system()
end

ExpeditionPlayView.fetch_regions = function (self)
	return self._promise_container:cancel_on_destroy(Managers.data_service.region_latency:fetch_regions_latency()):next(function (regions_latency)
		self._regions_latency = regions_latency
	end)
end

ExpeditionPlayView._callback_toggle_private_matchmaking = function (self)
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

ExpeditionPlayView._set_node_status = function (self)
	local nodes_data = Managers.data_service.expedition._nodes

	for name, data in pairs(nodes_data) do
		local ui_node_name = "exped-node-" .. name

		if data.status == "completed" then
			self:_set_node_completed(ui_node_name)
		elseif data.status == "progressing" then
			self:_set_node_progressing(ui_node_name, data.collected or 0, data.to_collect)
		else
			self:_set_node_locked(ui_node_name)
		end
	end
end

ExpeditionPlayView._create_node_widgets = function (self)
	local node_definitions = {
		widget_definitions = {
			["exped-node-node_a"] = self:_create_node_widget_definition("node_map", "Expedition A", {
				25,
				0,
				3,
			}, "exped-node-node_a"),
			["exped-node-node_b"] = self:_create_node_widget_definition("node_map", "Expedition B", {
				25 + ExpeditionPlayViewSettings.node_size[1] + 50,
				0,
				3,
			}, "exped-node-node_b"),
			["exped-node-node_c"] = self:_create_node_widget_definition("node_map", "Expedition C", {
				25 + ExpeditionPlayViewSettings.node_size[1] + 50 + ExpeditionPlayViewSettings.node_size[1] + 50,
				0,
				3,
			}, "exped-node-node_c"),
			["exped-node-node_d"] = self:_create_node_widget_definition("node_map", "Expedition D", {
				25 + ExpeditionPlayViewSettings.node_size[1] + 50 + ExpeditionPlayViewSettings.node_size[1] + 50 + ExpeditionPlayViewSettings.node_size[1] + 50,
				0,
				3,
			}, "exped-node-node_d"),
		},
	}
	local node_widgets = {}

	self._node_widgets = node_widgets

	local node_widgets_by_name = {}

	self._node_widgets_by_name = node_widgets_by_name

	self:_create_widgets(node_definitions, node_widgets, node_widgets_by_name)

	self._selected_node_id = "exped-node-node_a"

	self:_set_node_status()
end

ExpeditionPlayView._cb_on_node_selected = function (self, node_id)
	local nodes = self._node_widgets_by_name

	for name, widget in pairs(nodes) do
		widget.content.hotspot.is_selected = name == node_id
	end

	self._selected_node_id = node_id
	self._backend_data_expiry_time = 0

	self:_set_selected_option(1, true)
end

ExpeditionPlayView._create_node_widget_definition = function (self, scenegraph_id, title, offset, node_id)
	return UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background_rect",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = offset,
				size = ExpeditionPlayViewSettings.node_size,
				color = Color.terminal_grid_background_gradient(nil, true),
			},
		},
		{
			content_id = "hotspot",
			pass_type = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.story_mission_option_mouse_hover,
				on_pressed_sound = UISoundEvents.story_mission_option_selected,
				pressed_callback = callback(self, "_cb_on_node_selected", node_id),
			},
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = offset,
				size = ExpeditionPlayViewSettings.node_size,
			},
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/masks/gradient_horizontal_sides_02",
			style = {
				horizontal_alignment = "left",
				max_alpha = 255,
				min_alpha = 150,
				scale_to_material = false,
				vertical_alignment = "center",
				default_color = Color.terminal_background_gradient(nil, true),
				hover_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_background_selected(nil, true),
				size = ExpeditionPlayViewSettings.node_size,
				offset = offset,
			},
			change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function,
		},
		{
			pass_type = "texture",
			style_id = "frame_tile",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				default_color = Color.terminal_frame(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				size = ExpeditionPlayViewSettings.node_size,
				offset = offset,
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "texture",
			style_id = "frame_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				default_color = Color.terminal_corner(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				size = ExpeditionPlayViewSettings.node_size,
				offset = offset,
			},
			change_function = ButtonPassTemplates.terminal_button_change_function,
		},
		{
			pass_type = "text",
			value_id = "title",
			value = title,
			style = {
				font_size = 24,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				line_spacing = 1,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "top",
				vertical_alignment = "center",
				text_color = Color.terminal_text_header(nil, true),
				offset = offset,
				size = ExpeditionPlayViewSettings.node_size,
			},
		},
		{
			pass_type = "text",
			style_id = "status_text",
			value = "locked",
			value_id = "status_text",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				line_spacing = 1.2,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.ui_red_medium(nil, true),
				offset = {
					offset[1],
					offset[2] + 12,
					offset[3],
				},
				size = ExpeditionPlayViewSettings.node_size,
			},
		},
		{
			pass_type = "text",
			style_id = "collected_number",
			value = "0",
			value_id = "collected_number",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				line_spacing = 1,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "center",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					offset[1],
					offset[2] - 38,
					offset[3],
				},
				size = ExpeditionPlayViewSettings.node_size,
			},
		},
		{
			pass_type = "text",
			style_id = "collected_text",
			value = "collected of",
			value_id = "collected_text",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				line_spacing = 1,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "center",
				text_color = Color.terminal_text_body_sub_header(nil, true),
				offset = {
					offset[1],
					offset[2] - 20,
					offset[3],
				},
				size = ExpeditionPlayViewSettings.node_size,
			},
		},
		{
			pass_type = "text",
			style_id = "required_number",
			value = "1337",
			value_id = "required_number",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "left",
				line_spacing = 1,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "center",
				text_color = Color.terminal_text_body(nil, true),
				offset = {
					offset[1],
					offset[2],
					offset[3],
				},
				size = ExpeditionPlayViewSettings.node_size,
			},
		},
	}, scenegraph_id, nil, {
		node_id = node_id,
	})
end

ExpeditionPlayView._draw_node_widgets = function (self, dt, t, input_service, ui_renderer, render_settings, ui_scenegraph)
	local node_widgets = self._node_widgets

	if node_widgets then
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

		local num_widgets = #node_widgets

		for i = 1, num_widgets do
			local widget = node_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end

		UIRenderer.end_pass(ui_renderer)
	end
end

ExpeditionPlayView._set_node_locked = function (self, node_id)
	local node = self._node_widgets_by_name[node_id]

	node.style.background_rect.color = Color.terminal_background_dark(nil, true)
	node.content.hotspot.pressed_callback = nil
	node.style.background_gradient.default_color = Color.ui_red_medium(nil, true)
	node.style.background_gradient.hover_color = Color.ui_red_medium(nil, true)
	node.style.frame_tile.default_color = Color.ui_red_medium(nil, true)
	node.style.frame_tile.hover_color = Color.ui_red_medium(nil, true)
	node.style.frame_corner.default_color = Color.ui_red_light(nil, true)
	node.style.frame_corner.hover_color = Color.ui_red_light(nil, true)
	node.style.status_text.text_color = Color.ui_red_medium(nil, true)
	node.content.status_text = "locked"
	node.style.collected_number.text_color = Color.terminal_text_body(0, true)
	node.style.collected_text.text_color = Color.terminal_text_body_sub_header(0, true)
	node.style.required_number.text_color = Color.terminal_text_body(0, true)
end

ExpeditionPlayView._set_node_progressing = function (self, node_id, collected, to_collect)
	local node = self._node_widgets_by_name[node_id]

	node.style.background_rect.color = Color.terminal_grid_background_gradient(nil, true)
	node.content.hotspot.pressed_callback = callback(self, "_cb_on_node_selected", node_id)
	node.style.background_gradient.default_color = Color.terminal_background_gradient(nil, true)
	node.style.background_gradient.hover_color = Color.terminal_background_gradient(nil, true)
	node.style.frame_tile.default_color = Color.terminal_frame(nil, true)
	node.style.frame_tile.hover_color = Color.terminal_frame_hover(nil, true)
	node.style.frame_corner.default_color = Color.terminal_corner(nil, true)
	node.style.frame_corner.hover_color = Color.terminal_corner_hover(nil, true)
	node.style.status_text.text_color = Color.ui_red_medium(0, true)
	node.content.collected_number = collected
	node.style.collected_number.text_color = Color.terminal_text_body(nil, true)
	node.style.collected_text.text_color = Color.terminal_text_body_sub_header(nil, true)
	node.content.required_number = to_collect
	node.style.required_number.text_color = Color.terminal_text_body(nil, true)
end

ExpeditionPlayView._set_node_completed = function (self, node_id)
	local node = self._node_widgets_by_name[node_id]

	node.style.background_rect.color = Color.terminal_grid_background_gradient(nil, true)
	node.content.hotspot.pressed_callback = callback(self, "_cb_on_node_selected", node_id)
	node.style.background_gradient.default_color = Color.terminal_background_gradient(nil, true)
	node.style.background_gradient.hover_color = Color.terminal_background_gradient(nil, true)
	node.style.frame_tile.default_color = Color.terminal_frame(nil, true)
	node.style.frame_tile.hover_color = Color.terminal_frame_hover(nil, true)
	node.style.frame_corner.default_color = Color.terminal_corner(nil, true)
	node.style.frame_corner.hover_color = Color.terminal_corner_hover(nil, true)
	node.style.status_text.text_color = Color.terminal_text_body_sub_header(nil, true)
	node.content.status_text = "completed"
	node.style.collected_number.text_color = Color.terminal_text_body(0, true)
	node.style.collected_text.text_color = Color.terminal_text_body_sub_header(0, true)
	node.style.required_number.text_color = Color.terminal_text_body(0, true)
end

return ExpeditionPlayView
