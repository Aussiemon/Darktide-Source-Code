-- chunkname: @scripts/ui/views/havoc_play_view/havoc_play_view.lua

local HavocPlayViewDefinitions = require("scripts/ui/views/havoc_play_view/havoc_play_view_definitions")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local Havoc = require("scripts/utilities/havoc")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local Promise = require("scripts/foundation/utilities/promise")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local TextUtilities = require("scripts/utilities/ui/text")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementTutorialOverlay = require("scripts/ui/view_elements/view_element_tutorial_overlay/view_element_tutorial_overlay")
local Zones = require("scripts/settings/zones/zones")
local WalletSettings = require("scripts/settings/wallet_settings")
local HavocPlayView = class("HavocPlayView", "BaseView")
local havoc_info = Managers.data_service.havoc:get_settings()

HavocPlayView.init = function (self, settings, context)
	local parent = context and context.parent

	self._parent = parent
	self._play_button_anim_delay = 1
	self._play_fast_enter_animation = context and context.play_fast_enter_animation

	local player = self:_player()
	local profile = player:profile()

	self._player_level = profile.current_level

	local party_manager

	party_manager = party_manager or Managers.party_immaterium
	self._party_manager = party_manager

	HavocPlayView.super.init(self, HavocPlayViewDefinitions, settings, context)

	self._pass_input = true
	self._pass_draw = true

	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")
end

HavocPlayView.on_enter = function (self)
	HavocPlayView.super.on_enter(self)
	self:_setup_current_havoc_mission_data()

	self._widgets_by_name.play_button.content.hotspot.pressed_callback = callback(self, "_cb_on_mission_start")
	self._widgets_by_name.party_finder_button.content.hotspot.pressed_callback = callback(self, "_cb_on_party_finder_pressed")
	self._widgets_by_name.play_button.content.hotspot.disabled = not self._parent.havoc_order.id

	Managers.data_service.havoc:refresh_havoc_status()
	self:_populate_week_data()
	self:_setup_forward_gui()

	self._tutorial_overlay = self:_add_element(ViewElementTutorialOverlay, "tutorial_overlay", 200, {})
end

HavocPlayView._setup_current_havoc_mission_data = function (self)
	local current_havoc_order = self._parent.havoc_order
	local widgets_by_name = self._widgets_by_name
	local definitions = self._definitions
	local rank_badge_definitions = definitions.badge_definitions
	local rank_badge_size = rank_badge_definitions.size
	local rank_badge_passes = rank_badge_definitions.pass_template_function(self, {
		rank = current_havoc_order.data.rank,
	})
	local rank_badge_widget_definition = UIWidget.create_definition(rank_badge_passes, "current_rank", nil, rank_badge_size)
	local widget = UIWidget.init("rank_badge", rank_badge_widget_definition)

	self._widgets_by_name.rank_badge = widget
	self._widgets[1 + #self._widgets] = widget

	local color = Color.golden_rod(nil, true)
	local charges_widget = widgets_by_name.current_order_charges_remaining_description

	charges_widget.content.visible = current_havoc_order.data.rank > 1

	for i = 1, 3 do
		charges_widget.style["havoc_charge_" .. i].color[1] = i <= current_havoc_order.charges and 255 or 127
	end

	local _player = self:_player()
	local player_unit = _player.player_unit
	local player_owner = Managers.state.player_unit_spawn:owner(player_unit)
	local stat_id = player_owner.remote and player_owner.stat_id or player_owner:local_player_id()

	self._user_stat_id = stat_id

	local highest_reached = self._parent._havoc_week_data and self._parent._havoc_week_data.all_time or 0

	if highest_reached == 0 then
		highest_reached = Localize("loc_generic_interaction")
	end

	widgets_by_name.all_time_highest_level_header.content.text = highest_reached
	self._reward_end_time = self._parent._havoc_week_end_time

	local mission = current_havoc_order.blueprint.template

	self._mission = mission

	if not self._initialized then
		self._initialized = true

		if self._play_fast_enter_animation then
			self._enter_animation_id = self:_start_animation("on_enter_fast", widgets_by_name, self)
		else
			self._enter_animation_id = self:_start_animation("on_enter", widgets_by_name, self)
		end
	end

	local map = mission.id
	local mission_template = MissionTemplates[map]
	local widget = widgets_by_name.detail

	widget.visible = true

	local content = widget.content
	local mission_type = MissionTypes[mission_template.mission_type or "undefined"]

	content.header_icon = mission_type.icon
	content.header_subtitle = Localize(Zones[mission_template.zone_id].name)
	content.header_title = Localize(mission_template.mission_name)

	local location_image_material_values = widget.style.location_image.material_values

	location_image_material_values.texture_map = mission_template.texture_big
	location_image_material_values.show_static = 0

	local objective_widget = widgets_by_name.objective

	objective_widget.content.header_icon = mission_type.icon
	objective_widget.content.header_title = Localize("loc_misison_board_main_objective_title")
	objective_widget.content.header_subtitle = Localize(mission_type.name)
	objective_widget.content.body_text = Localize(mission_template.mission_description)

	local havoc_mission_flag_data = self:_extract_havoc_flags_data()
	local circumstances = havoc_mission_flag_data.circumstances

	if circumstances then
		local mission_circumstances_presentation_data = {}

		for key, _ in pairs(circumstances) do
			local circumstance_presentation_data = CircumstanceTemplates[key]

			mission_circumstances_presentation_data[#mission_circumstances_presentation_data + 1] = circumstance_presentation_data.ui
		end

		self:_setup_mission_detail_grid(mission_circumstances_presentation_data)
	end

	self.can_start_mission = true
end

HavocPlayView._extract_havoc_flags_data = function (self)
	local current_havoc_order = self._parent.havoc_order
	local flags = current_havoc_order.blueprint.flags
	local data_validations = {
		applied_themes = "havoc-theme-",
		circumstances = "havoc-circ-",
		factions = "havoc-faction-",
		negative_modifiers = "havoc-mods-",
	}
	local result = {}

	for id, _ in pairs(flags) do
		for data_id, prefix in pairs(data_validations) do
			local found_index, removal_start_index = string.find(id, prefix, 1, true)

			if found_index then
				result[data_id] = result[data_id] or {}

				local string_data = string.sub(id, removal_start_index + 1)

				string_data = string.gsub(string_data, "maelstrom_plus", "havoc")

				if data_id == "negative_modifiers" then
					do
						local new_index = #result[data_id] + 1
						local value_found_index, removal_start_index = string.find(string_data, "-", 1, true)
						local modifier = string.sub(string_data, 1, removal_start_index - 1)
						local value = string.sub(string_data, removal_start_index + 1)

						result[data_id][modifier] = value or true
					end

					break
				end

				result[data_id][string_data] = true

				break
			end
		end
	end

	return result
end

HavocPlayView.cb_view_lore = function (self)
	Managers.event:trigger("event_select_havoc_background_option", 2)
end

HavocPlayView._populate_week_data = function (self, data)
	local widgets_by_name = self._widgets_by_name

	if self._parent._havoc_week_data then
		local reward_objective_1_widget = widgets_by_name.reward_objective_1
		local reward_objective_2_widget = widgets_by_name.reward_objective_2
		local week_rank = self._parent._havoc_week_data.week_rank or 0

		reward_objective_1_widget.style.checkmark.text_color = week_rank > 0 and reward_objective_1_widget.style.checkmark.complete_text_color or reward_objective_1_widget.style.checkmark.incomplete_text_color
		reward_objective_2_widget.content.counter = week_rank

		local weekly_reward_widget = widgets_by_name.weekly_reward
		local weekly_reward_header_widget = widgets_by_name.reward_header
		local weekly_reward_content = weekly_reward_widget.content
		local weekly_reward_style = weekly_reward_widget.style
		local rewards = {}

		for i = 1, #self._parent._havoc_week_data.rewards do
			local wallet_type = self._parent._havoc_week_data.rewards[i]
			local wallet = WalletSettings[wallet_type]

			rewards[#rewards + 1] = {
				icon = wallet.icon_texture_small,
			}
		end

		if table.is_empty(rewards) or week_rank == 0 then
			weekly_reward_widget.content.visible = false
			weekly_reward_header_widget.content.visible = false
		else
			for i = 1, 3 do
				local icon_id = "reward_icon_" .. i
				local icon_style = weekly_reward_style[icon_id]
				local reward = rewards[i]

				if reward then
					weekly_reward_content[icon_id] = reward.icon
					icon_style.color[1] = 255
				else
					icon_style.color[1] = 0
				end
			end

			weekly_reward_widget.content.visible = true
			weekly_reward_header_widget.content.visible = true
		end
	end
end

HavocPlayView._update_reward_timer = function (self, dt)
	if not self._reward_end_time then
		return
	end

	self._reward_end_time = math.max(self._reward_end_time - dt, 0)

	if self._reward_end_time == 0 then
		Managers.event:trigger("event_havoc_background_on_end_time_met")

		self._reward_end_time = nil

		return
	end

	local timer_color = Color.terminal_text_header(255, true)
	local tutorial_overlay = self._tutorial_overlay

	if tutorial_overlay and tutorial_overlay:is_active() then
		local background_color_intensity = tutorial_overlay:background_color_intensity()

		timer_color[2] = timer_color[2] * background_color_intensity
		timer_color[3] = timer_color[3] * background_color_intensity
		timer_color[4] = timer_color[4] * background_color_intensity
	end

	self._widgets_by_name.reward_timer_header.content.text = string.format("Time left until order reset %s", TextUtilities.apply_color_to_text(TextUtilities.format_time_span_long_form_localized(self._reward_end_time), timer_color))
end

HavocPlayView._setup_mission_detail_grid = function (self, mission_circumstances)
	local definitions = self._definitions
	local grid_scenegraph_id = "mission_detail_grid"
	local scenegraph_definition = definitions.scenegraph_definition
	local grid_scenegraph = scenegraph_definition[grid_scenegraph_id]
	local grid_size = grid_scenegraph.size

	if not self._mission_detail_grid then
		local mask_padding_size = 20
		local grid_settings = {
			enable_gamepad_scrolling = true,
			hide_background = true,
			hide_dividers = true,
			scrollbar_horizontal_offset = 14,
			scrollbar_width = 7,
			title_height = 0,
			widget_icon_load_margin = 0,
			grid_spacing = {
				10,
				10,
			},
			grid_size = grid_size,
			mask_size = {
				grid_size[1] + 40,
				grid_size[2] + mask_padding_size,
			},
		}
		local layer = (self._draw_layer or 0) + 10

		self._mission_detail_grid = self:_add_element(ViewElementGrid, grid_scenegraph_id, layer, grid_settings, grid_scenegraph_id)

		self:_update_element_position(grid_scenegraph_id, self._mission_detail_grid)
		self._mission_detail_grid:set_alpha_multiplier(0)
		self._mission_detail_grid:set_empty_message("")
	end

	local grid = self._mission_detail_grid
	local layout = {}

	for _, entry in ipairs(mission_circumstances) do
		local title = entry.display_name
		local description = entry.description
		local icon = entry.icon

		layout[#layout + 1] = {
			widget_type = "mutator",
			header = Localize(title),
			text = Localize(description),
			icon = icon,
		}
	end

	local grid_blueprints = definitions.grid_blueprints

	grid:present_grid_layout(layout, grid_blueprints)
	grid:set_handle_grid_navigation(true)
end

HavocPlayView._cb_view_story_mission_lore = function (self)
	Managers.event:trigger("event_select_story_mission_background_option", 3)
end

HavocPlayView._cb_on_party_finder_pressed = function (self)
	if self._widgets_by_name.party_finder_button.content.hotspot.disabled then
		return
	end

	local context = {
		can_exit = true,
	}
	local view_name = "group_finder_view"

	Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
end

HavocPlayView._cb_on_mission_start = function (self)
	if not self.can_start_mission or self._widgets_by_name.play_button.content.hotspot.disabled then
		return
	end

	local current_havoc_order = self._parent.havoc_order
	local activate_mission_promise

	if current_havoc_order.ongoing_id then
		activate_mission_promise = Promise.resolved({
			id = current_havoc_order.ongoing_id,
		})
	else
		activate_mission_promise = Managers.data_service.havoc:activate_havoc_mission(current_havoc_order.id)
	end

	activate_mission_promise:next(function (mission)
		self:_play_sound(UISoundEvents.havoc_terminal_start_mission)
		self:on_back_pressed()
		Managers.event:trigger("event_story_mission_started")

		local mission_id = mission.id
		local private_match = false

		Managers.party_immaterium:wanted_mission_selected(mission_id, private_match)
	end):catch(function (error)
		Log.error("DebugFunctions", "Could not create debug mission " .. table.tostring(error, 5))
	end)
end

HavocPlayView._on_navigation_input_changed = function (self)
	HavocPlayView.super._on_navigation_input_changed(self)
end

HavocPlayView.on_resolution_modified = function (self, scale)
	HavocPlayView.super.on_resolution_modified(self, scale)
end

HavocPlayView.on_back_pressed = function (self)
	local tutorial_overlay = self._tutorial_overlay

	if tutorial_overlay and tutorial_overlay:is_active() then
		tutorial_overlay:force_close()

		return true
	end

	if Managers.ui:view_active("havoc_background_view") then
		Managers.ui:close_view("havoc_background_view")

		return true
	end

	return false
end

HavocPlayView.draw = function (self, dt, t, input_service, layer)
	if not self._initialized then
		return
	end

	local tutorial_overlay = self._tutorial_overlay

	if tutorial_overlay then
		tutorial_overlay:draw_begin(self._ui_renderer)
		tutorial_overlay:draw_begin(self._ui_forward_renderer)

		if tutorial_overlay:is_active() then
			input_service = input_service:null_service()
		end
	end

	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer

	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self.anim_alpha_multiplier or 0

	if self._mission_detail_grid then
		self._mission_detail_grid:set_alpha_multiplier(alpha_multiplier)
	end

	local stored_input_service = input_service
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	local tutorial_overlay_active = tutorial_overlay and tutorial_overlay:is_active()
	local widgets = self._widgets

	for i = 1, #widgets do
		local widget = widgets[i]

		if tutorial_overlay_active then
			tutorial_overlay:draw_external_widget(widget, self._ui_renderer, render_settings)
		else
			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, stored_input_service)

	render_settings.alpha_multiplier = alpha_multiplier

	if tutorial_overlay then
		tutorial_overlay:draw_end(self._ui_renderer)
		tutorial_overlay:draw_end(self._ui_forward_renderer)
	end
end

HavocPlayView._update_elements = function (self, dt, t, input_service)
	local elements_array = self._elements_array

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				local element_name = element.__class_name
				local element_input_service = input_service

				element:update(dt, t, element_input_service)
			end
		end
	end
end

HavocPlayView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local tutorial_overlay = self._tutorial_overlay
	local tutorial_overlay_active = tutorial_overlay and tutorial_overlay:is_active()
	local elements_array = self._elements_array

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				local element_name = element.__class_name
				local element_input_service = input_service

				if tutorial_overlay_active then
					tutorial_overlay:draw_external_element(element, dt, t, ui_renderer, render_settings, input_service)
				else
					element:draw(dt, t, ui_renderer, render_settings, element_input_service)
				end
			end
		end
	end
end

HavocPlayView.update = function (self, dt, t, input_service)
	local tutorial_overlay = self._tutorial_overlay

	if tutorial_overlay and tutorial_overlay:is_active() then
		input_service = input_service:null_service()
	end

	self:_update_can_play()
	self:_update_reward_timer(dt)

	return HavocPlayView.super.update(self, dt, t, input_service)
end

HavocPlayView._update_can_play = function (self)
	local widgets_by_name = self._widgets_by_name
	local all_can_play, denied_info = Managers.data_service.havoc:can_all_party_members_play_havoc()
	local all_participants_avaialble = self._party_manager:are_all_members_in_hub()
	local min_participants = havoc_info.min_participants or 1
	local party_members

	if GameParameters.prod_like_backend then
		party_members = self._party_manager:all_members()
	else
		party_members = self._party_manager:members()
	end

	local party_size = party_members and #party_members > 0 and #party_members or 1
	local is_min_party_size = min_participants <= party_size

	if all_can_play and all_participants_avaialble and is_min_party_size then
		widgets_by_name.play_button.content.hotspot.disabled = false
		widgets_by_name.play_button_disabled_info.visible = false
	else
		widgets_by_name.play_button.content.hotspot.disabled = true
		widgets_by_name.play_button_disabled_info.visible = true

		local found_myself = false

		if denied_info then
			for i = 1, #denied_info do
				if denied_info[i].is_myself then
					found_myself = true

					break
				end
			end
		end

		local reason

		if not is_min_party_size then
			reason = Localize("loc_minimum_participants_required", true, {
				amount = min_participants,
			})
		elseif found_myself then
			reason = Localize("loc_havoc_play_player_prohibited")
		else
			reason = Localize("loc_havoc_play_party_prohibited")
		end

		widgets_by_name.play_button_disabled_info.content.text = reason
	end
end

HavocPlayView._handle_input = function (self, input_service, dt, t)
	local tutorial_overlay = self._tutorial_overlay

	if tutorial_overlay and tutorial_overlay:is_active() then
		input_service = input_service:null_service()
	end

	if not self._initialized then
		input_service = input_service:null_service()
	end

	if not Managers.ui:using_cursor_navigation() then
		if input_service:get("confirm_pressed") and self.can_start_mission then
			self:_cb_on_mission_start()
		end

		if input_service:get("secondary_action_pressed") then
			self:_cb_on_party_finder_pressed()
		end
	end
end

HavocPlayView.on_exit = function (self)
	if self._mission_detail_grid then
		self._mission_detail_grid:set_visibility(false)
	end

	if self._mission_promise then
		self._mission_promise:cancel()

		self._mission_promise = nil
	end

	if self._enter_animation_id then
		self:_stop_animation(self._enter_animation_id)

		self._enter_animation_id = nil
	end

	if self._play_button_animation_id then
		self:_stop_animation(self._play_button_animation_id)

		self._play_button_animation_id = nil
	end

	self:_destroy_forward_gui()
	HavocPlayView.super.on_exit(self)
end

HavocPlayView.ui_renderer = function (self)
	return self._ui_renderer
end

HavocPlayView.dialogue_system = function (self)
	local parent = self._parent

	if parent then
		return parent.dialogue_system and parent:dialogue_system()
	end
end

HavocPlayView.cb_on_help_pressed = function (self)
	local tutorial_overlay_data = {}

	tutorial_overlay_data[#tutorial_overlay_data + 1] = {
		grow_from_center = true,
		window_width = 800,
		widgets_name = {
			"page_header",
			"all_time_highest_description_header",
			"all_time_highest_level_header",
			"reward_timer_header",
		},
		position_data = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			x = 154,
			y = 164,
			z = 0,
		},
		layout = {
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					25,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_havoc_onboarding_rank_title"),
				style = {
					font_size = 30,
				},
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					20,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_havoc_onboarding_rank_description"),
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					25,
				},
			},
		},
	}
	tutorial_overlay_data[#tutorial_overlay_data + 1] = {
		grow_from_center = true,
		window_width = 1000,
		widgets_name = {
			"rank_badge",
			"current_rank",
			"current_rank_header",
			"objective",
			"detail",
			"mission_detail_grid",
			"mission_detail_grid_background",
		},
		elements = {
			self._mission_detail_grid,
		},
		position_data = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			x = 780,
			y = 60,
			z = 0,
		},
		layout = {
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					25,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_havoc_onboarding_order_title"),
				style = {
					font_size = 30,
				},
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					20,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_havoc_onboarding_order_description"),
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					25,
				},
			},
		},
	}
	tutorial_overlay_data[#tutorial_overlay_data + 1] = {
		grow_from_center = true,
		window_width = 800,
		widgets_name = {
			"reward_title",
			"reward_description",
			"reward_objective_1",
			"reward_objective_2",
			"reward_header",
			"weekly_reward",
		},
		position_data = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			x = 510,
			y = 140,
			z = 0,
		},
		layout = {
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					25,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_havoc_onboarding_reward_title"),
				style = {
					font_size = 30,
				},
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					20,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_havoc_onboarding_reward_description"),
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					25,
				},
			},
		},
	}
	tutorial_overlay_data[#tutorial_overlay_data + 1] = {
		grow_from_center = true,
		window_width = 800,
		widgets_name = {
			"party_finder_button",
			"current_order_charges_remaining_description",
			"play_button",
		},
		position_data = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			x = 930,
			y = 672,
			z = 0,
		},
		layout = {
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					25,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_havoc_onboarding_party_title"),
				style = {
					font_size = 30,
				},
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					20,
				},
			},
			{
				widget_type = "text",
				text = Localize("loc_havoc_onboarding_party_description"),
			},
			{
				widget_type = "dynamic_spacing",
				size = {
					800,
					25,
				},
			},
		},
	}

	local tutorial_start_delay = 0.5

	self._tutorial_overlay:activate(tutorial_overlay_data, tutorial_start_delay)
end

HavocPlayView._setup_forward_gui = function (self)
	local ui_manager = Managers.ui
	local timer_name = "ui"
	local world_layer = 110
	local world_name = self._unique_id .. "_ui_forward_world"
	local view_name = self.view_name

	self._forward_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = self._unique_id .. "_ui_forward_world_viewport"
	local viewport_type = "default_with_alpha"
	local viewport_layer = 1

	self._forward_viewport = ui_manager:create_viewport(self._forward_world, viewport_name, viewport_type, viewport_layer)
	self._forward_viewport_name = viewport_name

	local renderer_name = self._unique_id .. "_forward_renderer"

	self._ui_forward_renderer = ui_manager:create_renderer(renderer_name, self._forward_world)
end

HavocPlayView._destroy_forward_gui = function (self)
	if self._ui_forward_renderer then
		self._ui_forward_renderer = nil

		Managers.ui:destroy_renderer(self._unique_id .. "_forward_renderer")

		local world = self._forward_world
		local viewport_name = self._forward_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._forward_viewport_name = nil
		self._forward_world = nil
	end
end

return HavocPlayView
