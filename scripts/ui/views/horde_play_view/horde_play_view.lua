-- chunkname: @scripts/ui/views/horde_play_view/horde_play_view.lua

local HordePlayViewDefinitions = require("scripts/ui/views/horde_play_view/horde_play_view_definitions")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local Danger = require("scripts/utilities/danger")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local TextUtilities = require("scripts/utilities/ui/text")
local Promise = require("scripts/foundation/utilities/promise")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local Zones = require("scripts/settings/zones/zones")
local ViewElementMissionBoardOptions = require("scripts/ui/view_elements/view_element_mission_board_options/view_element_mission_board_options")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local TextUtils = require("scripts/utilities/ui/text")
local MissionUtilities = require("scripts/utilities/ui/mission")
local RegionLocalizationMappings = require("scripts/settings/backend/region_localization")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local HordesModeSettings = require("scripts/settings/hordes_mode_settings")
local _MISSION_DUMMY_DATA = {
	{
		category = "narrative",
		challenge = 2,
		credits = 4180,
		displayIndex = 13,
		duration = 86399.999,
		expiry = 1734040259999,
		expiry_game_time = 49467.13009181449,
		expiry_server_time = 1734040259999,
		id = "d1ef6cd9-bf5e-439b-b234-a8da5e5dbc39",
		map = "psykhanium",
		missionGiver = "explicator_a",
		missionSize = 1,
		mission_reward = 4180,
		mission_xp = 2000,
		requiredLevel = 1,
		required_level = 1,
		resistance = 2,
		start = 1733953860000,
		start_game_time = -36932.86890818551,
		start_server_time = 1733953860000,
		xp = 2000,
		flags = {},
		book = {},
		page = {},
		noqp = {},
		altered = {},
		activate_twins = {},
		chapter = {},
		extraRewards = {},
		layout_seed = math.random_seed(),
	},
	{
		category = "narrative",
		challenge = 3,
		credits = 7440,
		displayIndex = 4,
		duration = 86399.999,
		expiry = 1734040259999,
		expiry_game_time = 49467.13009181449,
		expiry_server_time = 1734040259999,
		id = "06efd4c7-66a2-42bb-befe-5e4a06fd3e68",
		map = "psykhanium",
		missionGiver = "explicator_a",
		missionSize = 1,
		mission_reward = 7440,
		mission_xp = 3100,
		requiredLevel = 3,
		required_level = 3,
		resistance = 3,
		start = 1733953860000,
		start_game_time = -36932.86890818551,
		start_server_time = 1733953860000,
		xp = 3100,
		flags = {},
		book = {},
		page = {},
		noqp = {},
		altered = {},
		activate_twins = {},
		chapter = {},
		extraRewards = {},
	},
	{
		category = "narrative",
		challenge = 4,
		credits = 14820,
		displayIndex = 10,
		duration = 86399.999,
		expiry = 1734040259999,
		expiry_game_time = 49467.13009181449,
		expiry_server_time = 1734040259999,
		id = "6279669c-3b01-490e-80d2-a225b5addd36",
		map = "psykhanium",
		missionGiver = "explicator_a",
		missionSize = 1,
		mission_reward = 14820,
		mission_xp = 4250,
		requiredLevel = 9,
		required_level = 9,
		resistance = 4,
		start = 1733953860000,
		start_game_time = -36932.86890818551,
		start_server_time = 1733953860000,
		xp = 4250,
		flags = {},
		book = {},
		page = {},
		noqp = {},
		altered = {},
		activate_twins = {},
		chapter = {},
		extraRewards = {},
	},
	{
		category = "narrative",
		challenge = 5,
		credits = 19950,
		displayIndex = 30,
		duration = 86399.999,
		expiry = 1734040259999,
		expiry_game_time = 49467.13009181449,
		expiry_server_time = 1734040259999,
		id = "5509473c-99d8-449c-b286-51e9f965af3c",
		map = "psykhanium",
		missionGiver = "explicator_a",
		missionSize = 1,
		mission_reward = 19950,
		mission_xp = 5450,
		requiredLevel = 15,
		required_level = 15,
		resistance = 4,
		start = 1733953860000,
		start_game_time = -36932.86890818551,
		start_server_time = 1733953860000,
		xp = 5450,
		flags = {},
		book = {},
		page = {},
		noqp = {},
		altered = {},
		activate_twins = {},
		chapter = {},
		extraRewards = {},
	},
}
local HordePlayView = class("HordePlayView", "BaseView")

HordePlayView.init = function (self, settings, context)
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

	local player = self:_player()
	local profile = player:profile()

	self._player_level = profile.current_level

	local party_manager = Managers.party_immaterium

	self._party_manager = party_manager

	HordePlayView.super.init(self, HordePlayViewDefinitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
end

HordePlayView.on_enter = function (self)
	HordePlayView.super.on_enter(self)

	self._widgets_by_name.play_button.content.hotspot.pressed_callback = callback(self, "_cb_on_mission_start")

	self:fetch_regions()
	self:_set_play_button_game_mode_text(self._solo_play, self._private_match)
end

HordePlayView._cb_on_mission_start = function (self)
	if not self.can_start_mission then
		return
	end

	local mission = self._selected_mission

	if not mission then
		return
	end

	self:_play_sound(UISoundEvents.story_mission_start_mission)
	self:on_back_pressed()

	local mission_id = mission.id
	local private_match = self._private_match

	Managers.party_immaterium:wanted_mission_selected(mission_id, private_match, BackendUtilities.prefered_mission_region)
end

HordePlayView._update_fetch_missions = function (self, t)
	if t < self._backend_data_expiry_time or self._is_fetching_missions then
		return
	end

	self._is_fetching_missions = true

	local missions_promise = self:_cancel_promise_on_exit(Managers.data_service.mission_board:fetch(nil, 1))

	self._mission_promise = missions_promise

	missions_promise:next(function (mission_data)
		self._mission_promise = nil

		return Promise.resolved(mission_data)
	end):next(self._cb_fetch_success):catch(self._cb_fetch_failure)
end

HordePlayView._fetch_success = function (self, data)
	local missions = data.missions
	local num_mission_to_display = 4
	local mission_difficulties_selected = {}
	local num_mission_difficulties_selected = 0
	local filtered_missions = {}

	for _, mission in ipairs(missions) do
		local difficulty_id = mission.challenge .. "-" .. mission.resistance

		if mission.category == "horde" and not mission_difficulties_selected[difficulty_id] and Danger.calculate_danger(mission.challenge, mission.resistance) then
			mission_difficulties_selected[difficulty_id] = true
			num_mission_difficulties_selected = num_mission_difficulties_selected + 1
			filtered_missions[#filtered_missions + 1] = mission
		end
	end

	local function sort_func(a, b)
		local a_danger_level = Danger.calculate_danger(a.challenge, a.resistance)
		local b_danger_level = Danger.calculate_danger(b.challenge, b.resistance)

		return a_danger_level < b_danger_level
	end

	table.sort(filtered_missions, sort_func)

	self._missions = filtered_missions

	local option_widgets = {}
	local num_missions_available = #self._missions

	if num_missions_available > 0 then
		for i = 1, num_mission_to_display do
			local mission = self._missions[math.min(i, #self._missions)]

			self:_assign_option_data(i, mission)

			local widgets_by_name = self._widgets_by_name

			option_widgets[i] = widgets_by_name["option_" .. i]
		end
	end

	self._option_widgets = option_widgets
	self._backend_data = data
	self._backend_data_expiry_time = data.expiry_game_time
	self._is_fetching_missions = false

	if not self._initialized and #self._missions > 0 then
		self._initialized = true

		if self._play_fast_enter_animation then
			self._enter_animation_id = self:_start_animation("on_enter_fast", self._widgets_by_name, self)
		else
			self._enter_animation_id = self:_start_animation("on_enter", self._widgets_by_name, self)
		end

		local ignore_sound = true

		self:_set_selected_option(1, ignore_sound)
	elseif self._initialized and #self._missions == 0 then
		self._initialized = false

		for i = 1, #self._widgets do
			local widget = self._widgets[i]

			widget.alpha_multiplier = 0
		end
	end
end

HordePlayView._fetch_failure = function (self, error_message)
	Log.error("HordePlayView", "Fetching missions failed %s %s", error_message[1], error_message[2])

	local fetch_retry_cooldown = 5

	self._backend_data_expiry_time = Managers.time:time("main") + fetch_retry_cooldown
	self._is_fetching_missions = false
end

HordePlayView._cancel_promise_on_exit = function (self, promise)
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

HordePlayView._set_selected_option = function (self, index, ignore_sound)
	local option_widgets = self._option_widgets

	for i = 1, #option_widgets do
		local widget = option_widgets[i]
		local content = widget.content
		local hotspot = content.hotspot

		hotspot.is_selected = i == index
	end

	local missions = self._missions
	local mission = missions[index]

	if mission then
		self:_set_selected_mission(mission)
	end

	self._selected_mission_index = index

	if not ignore_sound then
		self:_play_sound(UISoundEvents.story_mission_option_selected)
	end
end

HordePlayView._cb_on_options_button_pressed = function (self, option_index, data)
	if option_index ~= self._selected_mission_index then
		self:_set_selected_option(option_index)
	end
end

HordePlayView._assign_option_data = function (self, option_index, data)
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
		local amount_text = "+" .. TextUtilities.format_currency(reward.amount or 0)
		local text_id = "reward_text_" .. i
		local icon_id = "reward_icon_" .. i

		content[icon_id] = reward.icon
		content[text_id] = amount_text

		local icon_style = style[icon_id]
		local text_style = style[text_id]
		local icon_text_width_difference = math.abs(text_style.default_offset[1]) - math.abs(icon_style.default_offset[1])

		icon_style.offset[1] = icon_style.default_offset[1] - total_reward_horizontal_offset

		local text_options = UIFonts.get_font_options_by_style(text_style)
		local text_width = UIRenderer.text_size(ui_renderer, amount_text, text_style.font_type, text_style.font_size, {
			400,
			30,
		}, text_options)

		text_style.offset[1] = text_style.default_offset[1] - total_reward_horizontal_offset
		total_reward_horizontal_offset = total_reward_horizontal_offset + text_width + icon_text_width_difference + reward_spacing
	end

	local display_name = danger_settings.display_name

	content.title_text = Localize(display_name)
end

HordePlayView._set_selected_mission = function (self, mission)
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

HordePlayView._on_navigation_input_changed = function (self)
	HordePlayView.super._on_navigation_input_changed(self)
end

HordePlayView.on_resolution_modified = function (self, scale)
	HordePlayView.super.on_resolution_modified(self, scale)
end

HordePlayView.on_back_pressed = function (self)
	if self._mission_board_options then
		return true
	end

	if Managers.ui:view_active("training_grounds_view") then
		Managers.ui:close_view("training_grounds_view")

		return true
	end

	return false
end

HordePlayView.draw = function (self, dt, t, input_service, layer)
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

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer, render_settings)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, stored_input_service)

	render_settings.alpha_multiplier = alpha_multiplier
end

local _required_level_loc_table = {
	required_level = -1,
}

HordePlayView._update_can_start_mission = function (self)
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

HordePlayView._set_info_text = function (self, level, text)
	local info_box = self._widgets_by_name.info_box

	info_box.visible = not not text

	if text then
		info_box.content.text = text
		info_box.style.frame.color = info_box.style.frame["color_" .. level]
	end
end

HordePlayView._set_play_button_game_mode_text = function (self, is_solo_play, is_private_match)
	local play_button_legend_content = self._widgets_by_name.play_button_legend.content

	if not is_solo_play and not is_private_match then
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_play_public"))
	elseif is_solo_play then
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_toggle_solo_play"))
	else
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_play_private"))
	end
end

HordePlayView.update = function (self, dt, t, input_service)
	self._is_in_matchmaking = self:_get_matchmaking_status()

	self:_update_fetch_missions(t)
	self:_update_can_start_mission()

	return HordePlayView.super.update(self, dt, t, input_service)
end

HordePlayView._get_matchmaking_status = function (self)
	return not self._party_manager:are_all_members_in_hub()
end

HordePlayView._handle_input = function (self, input_service, dt, t)
	if self._mission_board_options or not self._initialized then
		input_service = input_service:null_service()
	end

	local selected_mission_index = self._selected_mission_index

	if selected_mission_index then
		local handled = false

		if not Managers.ui:using_cursor_navigation() and input_service:get("confirm_pressed") and self.can_start_mission then
			handled = true

			self:_cb_on_mission_start()
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

HordePlayView.on_exit = function (self)
	if self._mission_promise then
		self._mission_promise:cancel()

		self._mission_promise = nil
	end

	if self._region_promise then
		self._region_promise:cancel()

		self._region_promise = nil
	end

	if self._enter_animation_id then
		self:_stop_animation(self._enter_animation_id)

		self._enter_animation_id = nil
	end

	if self._play_button_animation_id then
		self:_stop_animation(self._play_button_animation_id)

		self._play_button_animation_id = nil
	end

	HordePlayView.super.on_exit(self)
end

HordePlayView.ui_renderer = function (self)
	return self._ui_renderer
end

HordePlayView._callback_open_options = function (self, region_data)
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

HordePlayView._callback_close_options = function (self)
	self:_destroy_options_element()
end

HordePlayView._destroy_options_element = function (self)
	self:_remove_element("mission_board_options_element")

	self._mission_board_options = nil
end

HordePlayView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

HordePlayView.fetch_regions = function (self)
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
end

HordePlayView._callback_toggle_private_matchmaking = function (self)
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

return HordePlayView
