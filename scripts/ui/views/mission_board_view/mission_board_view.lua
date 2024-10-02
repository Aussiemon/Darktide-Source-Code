-- chunkname: @scripts/ui/views/mission_board_view/mission_board_view.lua

local MissionBoardViewDefinitions = require("scripts/ui/views/mission_board_view/mission_board_view_definitions")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local PlayerVOStoryStage = require("scripts/utilities/player_vo_story_stage")
local Zones = require("scripts/settings/zones/zones")
local InputDevice = require("scripts/managers/input/input_device")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local Promise = require("scripts/foundation/utilities/promise")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local WalletSettings = require("scripts/settings/wallet_settings")
local TextUtils = require("scripts/utilities/ui/text")
local ViewElementMissionBoardOptions = require("scripts/ui/view_elements/view_element_mission_board_options/view_element_mission_board_options")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local ColorUtilities = require("scripts/utilities/ui/colors")
local MissionUtilities = require("scripts/utilities/ui/mission")
local RegionLocalizationMappings = require("scripts/settings/backend/region_localization")
local MissionBoardView = class("MissionBoardView", "BaseView")
local mission_types = {
	"normal",
	"auric",
}
local mission_type_by_id = {}

for i = 1, #mission_types do
	local mission_type = mission_types[i]

	mission_type_by_id[mission_type] = i
end

local mission_type_font = table.clone(UIFontSettings.header_1)

mission_type_font.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
mission_type_font.text_horizontal_alignment = "center"
mission_type_font.text_vertical_alignment = "center"
mission_type_font.font_size = 32

local mission_type_auric_font = table.clone(mission_type_font)

mission_type_auric_font.material = "content/ui/materials/font_gradients/slug_font_gradient_gold"

local mission_type_data = {
	normal = {
		display_name = "loc_mission_board_type_normal",
		title = "loc_mission_board_view_header_tertium_hive",
		display_style = mission_type_font,
	},
	auric = {
		display_name = "loc_mission_board_type_auric",
		title = "loc_mission_board_view_header_tertium_hive_auric",
		display_style = mission_type_auric_font,
	},
}

MissionBoardView.init = function (self, settings, context)
	MissionBoardView.super.init(self, MissionBoardViewDefinitions, settings, context)

	self._debug_draw_overlaps = true
	self._mission_widgets = {}
	self.can_start_mission = false
	self._promises = {}
	self._regions_latency = {}
	self._backend_data_expiry_time = -1
	self._has_queued_missions = false
	self._queued_mission_show_time = math.huge
	self._game_settings_visible = false
	self._gamepad_cursor_current_pos = Vector3Box(960, 540)
	self._gamepad_cursor_current_vel = Vector3Box()
	self._gamepad_cursor_target_pos = Vector3Box()
	self._gamepad_cursor_average_vel = Vector3Box()
	self._gamepad_cursor_snap_delay = 0
	self._cb_fetch_success = callback(self, "_fetch_success")
	self._cb_fetch_failure = callback(self, "_fetch_failure")

	Managers.event:register(self, "event_story_mission_started", "_on_story_mission_started")
end

MissionBoardView._on_view_requirements_complete = function (self)
	self._can_close = true
	self._render_scale = Managers.ui:view_render_scale()

	local definitions = self._definitions

	self._ui_scenegraph = self:_create_scenegraph(definitions)
	self._widgets, self._widgets_by_name = {}, {}

	local filtered_definitions = {}

	for name, widget_definition in pairs(definitions.widget_definitions) do
		if not definitions.dynamic_widget_definitions[name] then
			filtered_definitions[name] = widget_definition
		end
	end

	for name, function_definitions in pairs(definitions.dynamic_widget_definitions) do
		filtered_definitions[name] = function_definitions("normal")
	end

	self:_create_widgets(filtered_definitions, self._widgets, self._widgets_by_name)

	self._ui_sequence_animator = self:_create_sequence_animator(definitions)
	self._render_settings = {}

	self:on_enter()
end

MissionBoardView._create_widgets = function (self, filtered_definitions, widgets, widgets_by_name)
	local widget_definitions = filtered_definitions

	widgets = widgets or {}
	widgets_by_name = widgets_by_name or {}

	for name, definition in pairs(widget_definitions) do
		local widget = self:_create_widget(name, definition)

		widgets[#widgets + 1] = widget
	end

	return widgets, widgets_by_name
end

MissionBoardView._generate_widgets_by_mission_type = function (self, mission_Type)
	local definitions = self._definitions

	for name, function_definitions in pairs(definitions.dynamic_widget_definitions) do
		self:_unregister_widget_name(name)

		for i = 1, #self._widgets do
			local widget = self._widgets[i]

			if widget.name == name then
				table.remove(self._widgets, i)

				break
			end
		end

		local definition = function_definitions(mission_Type)
		local widget = self:_create_widget(name, definition)

		self._widgets[#self._widgets + 1] = widget
	end

	self:_setup_widgets()
end

MissionBoardView.on_enter = function (self)
	MissionBoardView.super.on_enter(self)

	local save_data = Managers.save:account_data()

	save_data.mission_board = save_data.mission_board or {}
	self._mission_board_save_data = save_data.mission_board
	self._mission_board_save_data.private_matchmaking = self._mission_board_save_data.private_matchmaking or false
	self._private_match = self._mission_board_save_data.private_matchmaking

	Managers.event:register(self, "event_register_camera", "event_register_camera")

	local world_spawner_settings = MissionBoardViewSettings.world_spawner_settings

	self._world_spawner = UIWorldSpawner:new(world_spawner_settings.world_name, world_spawner_settings.world_layer, world_spawner_settings.world_timer_name, self.view_name)

	self._world_spawner:spawn_level(world_spawner_settings.level_name)

	self._ui_resource_renderer = Managers.ui:create_renderer(MissionBoardViewSettings.resource_renderer_name, nil, true, self._ui_renderer.gui, self._ui_renderer.gui_retained, MissionBoardViewSettings.resource_renderer_material)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 40)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end

	self:on_resolution_modified(self._render_scale)

	local player = self:_player()
	local profile = player:profile()

	self._player_level = profile.current_level

	local party_manager = Managers.party_immaterium

	self._party_manager = party_manager

	local narrative_manager = Managers.narrative
	local narrative_event_name = "onboarding_step_mission_board_introduction"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end

	self:_reset_selection()
	self:_update_bonus_rewards():next(function ()
		self._quickplay_initialized = true

		self:_set_selected_quickplay(true)
	end):catch(function (error)
		self._quickplay_initialized = false

		self:_reset_selection()
	end)
	self:_set_play_button_game_mode_text(self._solo_play, self._private_match)
	self:fetch_regions()
	self:_setup_widgets()
end

MissionBoardView._setup_widgets = function (self)
	self._mission_board_save_data.quickplay_difficulty = self._mission_board_save_data.quickplay_difficulty or 1
	self._quickplay_difficulty = self._mission_board_save_data.quickplay_difficulty
	self._widgets_by_name.difficulty_stepper.content.danger = self._mission_board_save_data.quickplay_difficulty
	self._widgets_by_name.difficulty_stepper.content.on_changed_callback = callback(self, "_callback_on_danger_changed")

	local gamepad_cursor = self._widgets_by_name.gamepad_cursor

	gamepad_cursor.visible = InputDevice.gamepad_active
	self._widgets_by_name.game_settings.visible = false
	self._widgets_by_name.play_team_button.content.hotspot.pressed_callback = callback(self, "_callback_start_selected_mission")
	self._widgets_by_name.story_mission_view_button.content.hotspot.pressed_callback = callback(self, "_callback_story_mission_menu")

	local mission_medium_widget_template = MissionBoardViewDefinitions.widget_definitions_functions.mission_medium_widget_pass_function(self._selected_mission_type or "normal")

	if self._quickplay_widget then
		self:_unregister_widget_name(self._quickplay_widget.name)
	end

	self._quickplay_widget = self:_create_widget("quickplay", mission_medium_widget_template)

	local quickplay_content = self._quickplay_widget.content

	quickplay_content.objective_1_icon = "content/ui/materials/icons/mission_types/mission_type_quick"
	quickplay_content.objective_2_icon = nil
	quickplay_content.circumstance_icon = nil
	quickplay_content.is_quickplay = true
	self._mission_widgets[0] = self._quickplay_widget

	local mission_type = self._selected_mission_type or "normal"

	quickplay_content.mission_type = mission_type
	self._quickplay_widget.offset[1] = MissionBoardViewSettings.mission_positions[mission_type].quickplay_mission_position[1]
	self._quickplay_widget.offset[2] = MissionBoardViewSettings.mission_positions[mission_type].quickplay_mission_position[2]

	local localization_id = mission_type_data[mission_type].title
	local title = Localize(localization_id)

	self._widgets_by_name.planet.content.title = title
	self._widgets_by_name.difficulty_stepper.content.min_danger = MissionBoardViewSettings.stepper_difficulty[mission_type].min_danger
	self._widgets_by_name.difficulty_stepper.content.max_danger = MissionBoardViewSettings.stepper_difficulty[mission_type].max_danger

	self:_add_bonus_data()
end

MissionBoardView._callback_story_mission_menu = function (self)
	self:_play_sound(UISoundEvents.story_mission_open_mission_board_button)
	Managers.ui:open_view("story_mission_background_view", nil, nil, nil, nil, {})
end

MissionBoardView._generate_mission_type_selection = function (self)
	if self._mission_type_selection_widget then
		local widget = self._mission_type_selection_widget

		self:_unregister_widget_name(widget.name)

		self._mission_type_selection_widget = nil
	end

	local max_text_size = 200
	local size = {
		max_text_size + 100,
		40,
	}
	local selection_margin = 6
	local selection_size = {
		30,
		selection_margin,
	}
	local level_requirement_font = table.clone(UIFontSettings.body)

	level_requirement_font.text_horizontal_alignment = "center"
	level_requirement_font.text_vertical_alignment = "center"
	level_requirement_font.offset = {
		0,
		50,
		0,
	}
	level_requirement_font.text_color = Color.ui_orange_light(255, true)
	level_requirement_font.font_size = 18

	local pass_definitions = {
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				color = Color.black(170, true),
			},
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
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					3,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "level_requirement",
			value = "",
			value_id = "level_requirement",
			style = level_requirement_font,
			visibility_function = function (content)
				return content.level and content.level > self._player_level
			end,
			change_function = function (content, style)
				content.level_requirement = content.level and Localize("loc_mission_board_mission_mode_level_requirement", true, {
					player_level = content.level,
				}) or ""
			end,
		},
		{
			content_id = "hotspot_arrow_left",
			pass_type = "hotspot",
			style_id = "hotspot_arrow_left",
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
				on_select_sound = UISoundEvents.default_click,
			},
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					30,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "arrow_background_left",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					30,
				},
				default_color = Color.terminal_frame(127.5, true),
				color = Color.terminal_frame(127.5, true),
				hover_color = Color.terminal_frame_hover(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
			visibility_function = function (parent, content)
				return Managers.ui:using_cursor_navigation()
			end,
			change_function = function (content, style)
				local is_disabled = content.hotspot_arrow_left.disabled
				local is_hover = content.hotspot_arrow_left.is_hover
				local disabled_color = table.clone(style.default_color)

				disabled_color[1] = 127.5

				local color = is_disabled and disabled_color or is_hover and style.hover_color or style.default_color

				ColorUtilities.color_copy(color, style.color, true)
			end,
		},
		{
			pass_type = "texture_uv",
			style_id = "arrow_left",
			value = "content/ui/materials/buttons/arrow_01",
			value_id = "arrow_left",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					16,
					20,
				},
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
				offset = {
					6,
					0,
					2,
				},
				default_color = Color.terminal_text_header(255, true),
				disabled_color = Color.terminal_text_header_disabled(255, true),
			},
			visibility_function = function (parent, content)
				return Managers.ui:using_cursor_navigation()
			end,
			change_function = function (content, style)
				local is_disabled = content.hotspot_arrow_left.disabled
				local color = is_disabled and style.disabled_color or style.default_color

				ColorUtilities.color_copy(color, style.color, true)
			end,
		},
		{
			pass_type = "text",
			style_id = "arrow_left_text",
			value = "",
			value_id = "arrow_left_text",
			style = {
				font_size = 24,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				offset = {
					10,
					0,
					1,
				},
				text_color = Color.terminal_text_header(255, true),
				default_color = Color.terminal_text_header(255, true),
				disabled_color = Color.terminal_text_header_disabled(255, true),
			},
			visibility_function = function (parent, content)
				return not Managers.ui:using_cursor_navigation()
			end,
			change_function = function (content, style)
				local is_disabled = content.hotspot_arrow_left.disabled
				local color = is_disabled and style.disabled_color or style.default_color

				ColorUtilities.color_copy(color, style.text_color, true)
			end,
		},
		{
			pass_type = "text",
			style_id = "arrow_right_text",
			value = "",
			value_id = "arrow_right_text",
			style = {
				font_size = 24,
				text_horizontal_alignment = "right",
				text_vertical_alignment = "center",
				offset = {
					-10,
					0,
					1,
				},
				text_color = Color.terminal_text_header(255, true),
				default_color = Color.terminal_text_header(255, true),
				disabled_color = Color.terminal_text_header_disabled(255, true),
			},
			visibility_function = function (parent, content)
				return not Managers.ui:using_cursor_navigation()
			end,
			change_function = function (content, style)
				local is_disabled = content.hotspot_arrow_right.disabled
				local color = is_disabled and style.disabled_color or style.default_color

				ColorUtilities.color_copy(color, style.text_color, true)
			end,
		},
		{
			content_id = "hotspot_arrow_right",
			pass_type = "hotspot",
			style_id = "hotspot_arrow_right",
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
				on_select_sound = UISoundEvents.default_click,
			},
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					30,
				},
				offset = {
					-0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "arrow_background_right",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					30,
				},
				default_color = Color.terminal_frame(127.5, true),
				color = Color.terminal_frame(127.5, true),
				hover_color = Color.terminal_frame_hover(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
			visibility_function = function (parent, content)
				return Managers.ui:using_cursor_navigation()
			end,
			change_function = function (content, style)
				local is_disabled = content.hotspot_arrow_right.disabled
				local is_hover = content.hotspot_arrow_right.is_hover
				local disabled_color = table.clone(style.default_color)

				disabled_color[1] = 127.5

				local color = is_disabled and disabled_color or is_hover and style.hover_color or style.default_color

				ColorUtilities.color_copy(color, style.color, true)
			end,
		},
		{
			pass_type = "texture",
			style_id = "arrow_right",
			value = "content/ui/materials/buttons/arrow_01",
			value_id = "arrow_right",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					16,
					20,
				},
				offset = {
					-6,
					0,
					2,
				},
				default_color = Color.terminal_text_header(255, true),
				disabled_color = Color.terminal_text_header_disabled(255, true),
			},
			visibility_function = function (parent, content)
				return Managers.ui:using_cursor_navigation()
			end,
			change_function = function (content, style)
				local is_disabled = content.hotspot_arrow_right.disabled
				local color = is_disabled and style.disabled_color or style.default_color

				ColorUtilities.color_copy(color, style.color, true)
			end,
		},
	}

	for i = 1, #mission_types do
		local total_size_selection = #mission_types * (selection_size[1] + selection_margin) - selection_margin
		local selection_offset = (selection_size[1] + selection_margin) * (i - 1) - total_size_selection * 0.5 + selection_size[1] * 0.5
		local mission_type = mission_types[i]
		local data = mission_type_data[mission_type]

		pass_definitions[#pass_definitions + 1] = {
			pass_type = "text",
			style_id = "title_" .. i,
			value = Localize(data.display_name),
			value_id = "title_" .. i,
			style = data.display_style,
		}
		pass_definitions[#pass_definitions + 1] = {
			pass_type = "hotspot",
			content_id = "hotspot_selection_" .. i,
			style_id = "hotspot_selection_" .. i,
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click,
				on_select_sound = UISoundEvents.default_click,
			},
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = selection_size,
				offset = {
					selection_offset,
					selection_size[2] + selection_margin,
				},
			},
		}
		pass_definitions[#pass_definitions + 1] = {
			pass_type = "rect",
			style_id = "selection_" .. i,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				color = Color.terminal_text_header(255, true),
				size = selection_size,
				offset = {
					selection_offset,
					selection_size[2] + selection_margin,
				},
			},
		}
	end

	local widget_definition = UIWidget.create_definition(pass_definitions, "mission_type_selection_pivot", nil, size)
	local widget = self:_create_widget("mission_type_selection", widget_definition)

	widget.content.index_length = #mission_types

	local function change_mission_type(next_index)
		local content = widget.content
		local selected_index = math.clamp(next_index, 1, content.index_length)
		local first_run = false

		if selected_index ~= widget.content.selected_index then
			if not widget.content.selected_index then
				first_run = true
			end

			widget.content.selected_index = selected_index

			for i = 1, widget.content.index_length do
				local title_id = "title_" .. i
				local selection_id = "selection_" .. i

				widget.style[title_id].visible = selected_index == i
				widget.style[selection_id].color = selected_index == i and Color.terminal_text_header(255, true) or Color.terminal_text_header_disabled(204, true)
			end

			widget.style.arrow_left.visible = true
			widget.style.arrow_left_text.visible = true
			widget.content.hotspot_arrow_left.disabled = false
			widget.style.arrow_right.visible = true
			widget.style.arrow_right_text.visible = true
			widget.content.hotspot_arrow_right.disabled = false
			widget.style.arrow_background_left.visible = true
			widget.style.arrow_background_right.visible = true

			if selected_index == 1 then
				widget.content.hotspot_arrow_left.disabled = true
			end

			if selected_index == widget.content.index_length then
				widget.content.hotspot_arrow_right.disabled = true
			end

			local mission_type = mission_types[selected_index]

			widget.content.level = PlayerProgressionUnlocks.mission_type_unlocks[mission_type]

			if not first_run then
				self:_telemetry_close()
			end

			self._selected_mission_type = mission_type

			self:_telemetry_open()

			if not first_run then
				self:_callback_switch_mission_board(mission_type)
			end
		end
	end

	widget.content.hotspot_arrow_left.pressed_callback = function ()
		change_mission_type(widget.content.selected_index - 1)
	end

	widget.content.hotspot_arrow_right.pressed_callback = function ()
		change_mission_type(widget.content.selected_index + 1)
	end

	widget.content.hotspot_selection_1.pressed_callback = function ()
		change_mission_type(1)
	end

	widget.content.hotspot_selection_2.pressed_callback = function ()
		change_mission_type(2)
	end

	local selected_mission_type_id = self._selected_mission_type and mission_type_by_id[self._selected_mission_type] or 1

	change_mission_type(selected_mission_type_id)

	self._mission_type_selection_widget = widget
end

MissionBoardView.on_exit = function (self)
	local promises = self._promises

	for promise, _ in pairs(promises) do
		promise:cancel()
	end

	local mission_board_save_data = self._mission_board_save_data

	if mission_board_save_data and (self._quickplay_difficulty ~= mission_board_save_data.quickplay_difficulty or self._private_match ~= mission_board_save_data.private_matchmaking) then
		mission_board_save_data.quickplay_difficulty = self._quickplay_difficulty
		mission_board_save_data.private_matchmaking = self._private_match

		Managers.save:queue_save()
	end

	if self._selected_mission_type then
		self:_telemetry_close()
	end

	if self._input_legend_element then
		self:_remove_element("input_legend")

		self._input_legend_element = nil
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:release_listener()
		world_spawner:destroy()

		self._world_spawner = nil
	end

	if self._ui_resource_renderer then
		Managers.ui:destroy_renderer(MissionBoardViewSettings.resource_renderer_name)

		self._ui_resource_renderer = nil
	end

	if self._region_confirm_popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._region_confirm_popup_id)

		self._region_confirm_popup_id = nil
	end

	Managers.event:unregister(self, "event_story_mission_started")
	MissionBoardView.super.on_exit(self)
end

MissionBoardView._on_story_mission_started = function (self)
	self:_on_back_pressed()
end

local story_mission_frame_anims = {
	"story_mission_button_anim_1",
	"story_mission_button_anim_2",
	"story_mission_button_anim_3",
	"story_mission_button_anim_4",
}

MissionBoardView._update_story_mission_button_anim = function (self, dt)
	local widgets_by_name = self._widgets_by_name
	local story_mission_view_button = widgets_by_name.story_mission_view_button

	if story_mission_view_button and story_mission_view_button.content.visible then
		if not self._story_mission_button_anim_delay then
			if self._story_mission_button_animation_id then
				self:_stop_animation(self._story_mission_button_animation_id)

				self._story_mission_button_animation_id = nil
			end

			local anim_index = math.random(1, #story_mission_frame_anims)
			local anim_name = story_mission_frame_anims[anim_index]

			self._story_mission_button_animation_id = self:_start_animation(anim_name, widgets_by_name, self)
			self._story_mission_button_anim_delay = math.random(5, 10)
		else
			self._story_mission_button_anim_delay = self._story_mission_button_anim_delay - dt

			if self._story_mission_button_anim_delay <= 0 then
				self._story_mission_button_anim_delay = nil
			end
		end
	end
end

MissionBoardView.update = function (self, dt, t, input_service)
	MissionBoardView.super.update(self, dt, t, input_service)
	self:_update_fetch_missions(t)
	self:_update_happening(t)
	self:_update_can_start_mission()
	self:_update_story_mission_button_anim(dt)

	if self._widgets_by_name.region then
		local widget = self._widgets_by_name.region

		self:_update_server_list(widget, input_service)
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	self._is_in_matchmaking = self:_get_matchmaking_status()
end

MissionBoardView._get_matchmaking_status = function (self)
	return not self._party_manager:are_all_members_in_hub()
end

MissionBoardView._handle_input = function (self, input_service, dt, t)
	if self._mission_board_options then
		input_service = input_service:null_service()
	end

	MissionBoardView.super._handle_input(self, input_service, dt, t)

	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		local widget_content = mission_widgets[i].content

		if widget_content.hotspot.on_pressed then
			self:_set_selected_mission(widget_content.mission, true)

			break
		end
	end

	if self._quickplay_initialized then
		local quickplay_widget = self._quickplay_widget

		if quickplay_widget.content.hotspot.on_pressed then
			self:_set_selected_quickplay(true)
		end
	end

	local flash_mission_widget = self._flash_mission_widget

	if flash_mission_widget and flash_mission_widget.visible and flash_mission_widget.content.hotspot.on_pressed then
		self:_set_selected_mission(flash_mission_widget.content.mission, true, true)
	end

	local story_mission_view_button = self._widgets_by_name.story_mission_view_button

	if story_mission_view_button.content.visible then
		local gamepad_action = story_mission_view_button.content.gamepad_action

		if gamepad_action and not Managers.ui:using_cursor_navigation() and input_service:get(gamepad_action) then
			self:_callback_story_mission_menu()
		end
	end

	if not Managers.ui:using_cursor_navigation() then
		local play_team_button = self._widgets_by_name.play_team_button
		local play_team_gamepad_action = play_team_button and play_team_button.content.gamepad_action

		if play_team_button and play_team_gamepad_action and input_service:get(play_team_gamepad_action) and not play_team_button.content.hotspot.disabled then
			self._widgets_by_name.play_team_button.content.hotspot.pressed_callback()
		elseif self._mission_type_selection_widget then
			if input_service:get("navigate_secondary_left_pressed") then
				self._mission_type_selection_widget.content.hotspot_arrow_left.pressed_callback()
			elseif input_service:get("navigate_secondary_right_pressed") then
				self._mission_type_selection_widget.content.hotspot_arrow_right.pressed_callback()
			end
		end
	end

	local last_pressed_device = InputDevice.last_pressed_device
	local gamepad_cursor = self._widgets_by_name.gamepad_cursor
	local cursor_active = last_pressed_device and last_pressed_device:type() ~= "mouse"

	gamepad_cursor.visible = cursor_active

	if cursor_active then
		local input = input_service:get("navigation_keys_virtual_axis") + input_service:get("navigate_controller")

		input[2] = -input[2]

		local input_len = Vector3.length(input)

		if input_len > 1 then
			input = input / input_len
			input_len = 1
		end

		local settings = MissionBoardViewSettings.gamepad_cursor_settings
		local pos = Vector3Box.unbox(self._gamepad_cursor_current_pos)
		local vel = Vector3Box.unbox(self._gamepad_cursor_current_vel)
		local avg_vel = Vector3Box.unbox(self._gamepad_cursor_average_vel)
		local tar_pos = Vector3Box.unbox(self._gamepad_cursor_target_pos)
		local norm_avg_vel, len_avg_vel = Vector3.direction_length(avg_vel)

		if input_len > settings.snap_input_length_threshold then
			self._gamepad_cursor_snap_delay = math.max(self._gamepad_cursor_snap_delay, t + settings.snap_delay)
		elseif t > self._gamepad_cursor_snap_delay then
			pos = Vector3.lerp(tar_pos, pos, settings.snap_movement_rate^dt)
		end

		local drag_coefficient = 1
		local scenegraph = self._ui_scenegraph
		local cursor_size = Vector3.from_array_flat(scenegraph.gamepad_cursor.size)
		local wanted_size = Vector2(settings.default_size_x, settings.default_size_y)

		do
			local best_pos
			local best_score = -math.huge
			local is_sticky = len_avg_vel < settings.stickiness_speed_threshold
			local cursor_center = pos
			local cursor_pos = cursor_center - 0.5 * cursor_size
			local overlapping_missions = {}

			for i = 0, #mission_widgets do
				local widget = mission_widgets[i]
				local is_valid = widget and widget.visible and (not widget.content.is_quickplay or self._quickplay_initialized)

				if is_valid then
					local widget_pos = Vector2(widget.offset[1], widget.offset[2])
					local widget_size = Vector3.from_array_flat(scenegraph[widget.scenegraph_id].size)
					local widget_center = widget_pos + 0.5 * widget_size
					local delta_dir, delta_len = Vector3.direction_length(widget_center - cursor_center)
					local dot = math.max(1e-06, Vector3.dot(norm_avg_vel, delta_dir))
					local score = math.sqrt(dot) / math.max(1, delta_len)

					if is_sticky then
						score = score + 10 * math.max(0, settings.stickiness_radius - delta_len * delta_len)
					end

					local has_overlap = math.box_overlap_box(widget_pos, widget_size, cursor_pos, cursor_size)

					if has_overlap then
						if widget.content.is_quickplay then
							overlapping_missions[#overlapping_missions + 1] = "quickplay"
						else
							overlapping_missions[#overlapping_missions + 1] = widget.content.mission
						end

						drag_coefficient = settings.widget_drag_coefficient

						if delta_len < settings.stickiness_radius then
							wanted_size = widget_size
							score = score + 1000
						end
					end

					if best_score < score then
						best_score = score
						best_pos = widget_center
					end
				end
			end

			local new_mission

			for i = 1, #overlapping_missions do
				local mission = overlapping_missions[i]

				if mission == self._selected_mission or not self._selected_mission and mission == "quickplay" then
					new_mission = nil

					break
				else
					new_mission = mission
				end
			end

			if new_mission then
				if new_mission == "quickplay" then
					self:_set_selected_quickplay()
					self:_play_sound(UISoundEvents.mission_board_node_hover)
				else
					self:_set_selected_mission(new_mission)
					self:_play_sound(UISoundEvents.mission_board_node_hover)
				end
			end

			if len_avg_vel > settings.snap_selection_speed_threshold and best_pos then
				Vector3Box.store(self._gamepad_cursor_target_pos, best_pos)
			end
		end

		pos = pos + vel * dt
		vel = vel * settings.cursor_friction_coefficient^dt + settings.cursor_acceleration * drag_coefficient * dt * input

		if Vector3.length_squared(vel) < settings.cursor_minimum_speed then
			Vector3.set_xyz(vel, 0, 0, 0)
		end

		avg_vel = math.lerp(avg_vel, vel, settings.average_speeed_smoothing^dt)
		pos[1] = math.clamp(pos[1], settings.bounds_min_x, settings.bounds_max_x)
		pos[2] = math.clamp(pos[2], settings.bounds_min_y, settings.bounds_max_y)

		Vector3Box.store(self._gamepad_cursor_current_pos, pos)
		Vector3Box.store(self._gamepad_cursor_current_vel, vel)
		Vector3Box.store(self._gamepad_cursor_average_vel, avg_vel)

		local x, y = Vector3.to_elements(pos)

		self:_set_scenegraph_position("gamepad_cursor_pivot", x, y)

		local width, height = Vector3.to_elements(math.lerp(wanted_size, cursor_size, settings.size_resize_rate^dt))

		self:_set_scenegraph_size("gamepad_cursor", width, height)

		local arrow_style = gamepad_cursor.style.arrow

		arrow_style.angle = math.radian_lerp(math.pi + math.atan2(tar_pos[2] - pos[2], pos[1] - tar_pos[1]), arrow_style.angle, settings.arrow_rotate_rate^dt)

		local alpha = 255 * (1 - math.clamp(t - self._gamepad_cursor_snap_delay, 0, 1))

		gamepad_cursor.style.glow.color[1] = alpha
		gamepad_cursor.style.rect.color[1] = alpha * 0.12549019607843137
		gamepad_cursor.style.arrow.color[1] = alpha
		gamepad_cursor.style.frame.color[1] = alpha
		gamepad_cursor.style.corner.color[1] = alpha
	end
end

local _required_level_loc_table = {
	required_level = -1,
}

MissionBoardView._update_can_start_mission = function (self)
	local selected_mission = self._selected_mission
	local required_level

	if selected_mission then
		required_level = selected_mission.requiredLevel
	else
		local danger = self._quickplay_difficulty
		local mission_mode = self._selected_mission_type

		required_level = DangerSettings.required_level_by_mission_type(danger, mission_mode)
	end

	local widgets_by_name = self._widgets_by_name
	local is_locked = false

	if required_level > self._player_level then
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

	widgets_by_name.play_team_button.content.hotspot.disabled = is_locked
	self.can_start_mission = not is_locked

	return is_locked
end

MissionBoardView._set_info_text = function (self, level, text)
	local info_box = self._widgets_by_name.info_box

	info_box.visible = not not text

	if text then
		info_box.content.text = text
		info_box.style.frame.color = info_box.style.frame["color_" .. level]
	end
end

MissionBoardView._set_gamepad_cursor = function (self, widget)
	local offset = widget.offset
	local size_x, size_y = self:_scenegraph_size(widget.scenegraph_id)
	local x, y = offset[1] + 0.5 * size_x, offset[2] + 0.5 * size_y

	self._gamepad_cursor_target_pos[1] = x
	self._gamepad_cursor_target_pos[2] = y
	self._gamepad_cursor_current_pos[1] = x
	self._gamepad_cursor_current_pos[2] = y
end

MissionBoardView._reset_selection = function (self)
	self._selected_mission = nil

	local mission_widgets = self._mission_widgets

	if mission_widgets then
		for i = 0, #mission_widgets do
			local widget = mission_widgets[i]

			if widget then
				widget.content.hotspot.is_selected_mission_board = false
			end
		end
	end

	if self._bonus_widgets then
		for i = 1, #self._bonus_widgets do
			local widget = self._bonus_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._bonus_widgets = nil
	end

	if self._quickplay_widget then
		self._quickplay_widget.content.hotspot.is_selected_mission_board = false
	end

	self._widgets_by_name.detail.visible = false
	self._widgets_by_name.objective_1.visible = false
	self._widgets_by_name.objective_2.visible = false
	self._widgets_by_name.difficulty_stepper.visible = false
	self._widgets_by_name.difficulty_stepper_window.visible = false
	self._widgets_by_name.play_team_button.visible = false
	self._widgets_by_name.play_team_button_legend.visible = false
end

MissionBoardView._set_selected_quickplay = function (self, move_gamepad_cursor)
	self:_reset_selection()

	self._selected_mission = nil

	local mission_widgets = self._mission_widgets

	for i = 0, #mission_widgets do
		local widget = mission_widgets[i]

		if widget then
			widget.content.hotspot.is_selected_mission_board = false
		end
	end

	self._quickplay_widget.content.hotspot.is_selected_mission_board = true

	if move_gamepad_cursor then
		self:_set_gamepad_cursor(self._quickplay_widget)
	end

	do
		local widget = self._widgets_by_name.detail

		widget.dirty = true
		widget.visible = true

		local content = widget.content
		local style = widget.style

		content.header_subtitle = self._widgets_by_name.planet.content.title
		content.header_title = Localize("loc_mission_board_quickplay_header")
		content.danger = nil
		content.is_locked = false
		content.start_game_time = nil
		content.circumstance_icon = nil
		content.is_flash = false

		local location_image_material_values = widget.style.location_image.material_values

		location_image_material_values.texture_map = "content/ui/textures/missions/quickplay"
		location_image_material_values.show_static = 0

		if self._bonus_data and self._bonus_data.quickplay then
			if self._bonus_widgets then
				for i = 1, #self._bonus_widgets do
					local widget = self._bonus_widgets[i]

					self:_unregister_widget_name(widget.name)
				end

				self._bonus_widgets = nil
			end

			style.bonus_title.visible = true

			local bonus_widgets = {}
			local count = 0
			local start_offset = 0

			for type, value in pairs(self._bonus_data.quickplay) do
				local currency_name, currency_icon

				if type == "xp" then
					currency_name = Localize("loc_mission_board_view_experience")
					currency_icon = "content/ui/materials/icons/currencies/experience_small"
				else
					currency_name = WalletSettings[type] and Localize(WalletSettings[type].display_name) or type
					currency_icon = WalletSettings[type].icon_texture_small
				end

				local bonus_definition = MissionBoardViewDefinitions.bonus_data_widget_definitons
				local widget = self:_create_widget("bonus_data_" .. type, bonus_definition)

				widget.content.text = string.format("+ %d%% %s", value, currency_name)
				widget.content.icon = currency_icon
				widget.offset = {
					20,
					start_offset + 32 * count,
					2,
				}
				count = count + 1
				bonus_widgets[#bonus_widgets + 1] = widget
			end

			self._bonus_widgets = bonus_widgets
		else
			style.bonus_title.visible = false
		end
	end

	do
		local vo_profile = MissionBoardViewSettings.quickplay_vo_profile
		local speaker_settings = DialogueSpeakerVoiceSettings[vo_profile]
		local widget = self._widgets_by_name.objective_1

		widget.dirty = true
		widget.visible = true

		local content = widget.content
		local style = widget.style

		content.header_icon = "content/ui/materials/icons/mission_types/mission_type_quick"
		content.header_subtitle = Localize("loc_mission_board_quickplay_header")
		content.body_text = Localize("loc_mission_board_quickplay_description")
		content.speaker_icon = speaker_settings.material_small
		content.speaker_text = "/ " .. Localize(speaker_settings.full_name)
		content.xp = nil
		content.credits = nil

		local description_style_options = UIFonts.get_font_options_by_style(style.body_text)
		local margin = 20
		local bottom_spacing = content.speaker_icon and 15 or 0
		local max_width = self._ui_scenegraph.objective.size[1] - margin * 2
		local description_width, description_height = UIRenderer.text_size(self._ui_renderer, content.body_text, style.body_text.font_type, style.body_text.font_size, {
			max_width,
			1080,
		}, description_style_options)

		widget.content.size = {
			self._ui_scenegraph.objective.size[1],
			self._ui_scenegraph.objective_header.size[2] + description_height + margin * 2 + bottom_spacing,
		}
		widget.style.reward_background.offset[2] = widget.content.size[2]
		widget.style.reward_gradient.offset[2] = widget.content.size[2]
		widget.style.reward_frame.offset[2] = widget.content.size[2]
		widget.style.reward_icon.offset[2] = widget.content.size[2]
		widget.style.reward_text.offset[2] = widget.content.size[2]
		widget.style.speaker_frame.offset[2] = widget.content.size[2]
		widget.style.speaker_corner.offset[2] = widget.content.size[2]
		widget.style.speaker_icon.offset[2] = widget.content.size[2]
		widget.offset[2] = self._ui_scenegraph.detail.size[2] + margin
		self._widgets_by_name.difficulty_stepper.offset[2] = widget.offset[2] + widget.content.size[2] + margin
	end

	self._widgets_by_name.objective_2.visible = false
	self._widgets_by_name.difficulty_stepper.visible = true
	self._widgets_by_name.difficulty_stepper_window.visible = true
	self._widgets_by_name.play_team_button.visible = true
	self._widgets_by_name.play_team_button_legend.visible = true
end

MissionBoardView._set_selected_mission = function (self, mission, move_gamepad_cursor, is_flash)
	self:_reset_selection()

	self._selected_mission = mission

	local selected_mission_id = mission.id
	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		local widget = mission_widgets[i]

		if widget then
			local content = widget.content
			local widget_mission = content.mission
			local is_selected = widget_mission.id == selected_mission_id

			content.hotspot.is_selected_mission_board = is_selected

			if is_selected and move_gamepad_cursor then
				self:_set_gamepad_cursor(widget)
			end
		end
	end

	self._quickplay_widget.content.hotspot.is_selected_mission_board = false

	local is_locked = self._player_level < mission.requiredLevel
	local xp = mission.xp
	local credits = mission.credits
	local mission_template = MissionTemplates[mission.map]

	do
		local danger = DangerSettings.calculate_danger(mission.challenge, mission.resistance)
		local widget = self._widgets_by_name.detail

		widget.dirty = true
		widget.visible = true

		local content = widget.content
		local style = widget.style
		local mission_type = MissionTypes[mission_template.mission_type]

		content.header_icon = mission_type.icon
		content.header_subtitle = Localize(Zones[mission_template.zone_id].name)
		content.header_title = Localize(mission_template.mission_name)
		content.danger = danger
		content.is_locked = is_locked
		content.start_game_time = mission.start_game_time
		content.expiry_game_time = mission.expiry_game_time
		content.is_flash = mission.flags.flash

		local circumstance = mission.circumstance

		if circumstance ~= "default" then
			local circumstance_template = CircumstanceTemplates[circumstance]
			local circumstance_ui_data = circumstance_template and circumstance_template.ui

			if circumstance_ui_data then
				content.has_circumstance = true
				content.circumstance_name = Localize(circumstance_ui_data.display_name)
				content.circumstance_description = Localize(circumstance_ui_data.description)
				content.circumstance_icon = circumstance_ui_data.icon

				local description_margin = 5
				local default_height = 100
				local description_text_box_size = {
					self._ui_scenegraph.detail_circumstance.size[1],
					default_height,
				}
				local title_style_options = UIFonts.get_font_options_by_style(style.circumstance_name)
				local description_style_options = UIFonts.get_font_options_by_style(style.circumstance_description)
				local title_size = {
					description_text_box_size[1] + style.circumstance_name.size_addition[1],
					description_text_box_size[2] + style.circumstance_name.size_addition[2],
				}
				local description_size = {
					description_text_box_size[1] + style.circumstance_description.size_addition[1],
					description_text_box_size[2] + style.circumstance_description.size_addition[2],
				}
				local circumstance_name_width, circumstance_name_height = UIRenderer.text_size(self._ui_renderer, content.circumstance_name, style.circumstance_name.font_type, style.circumstance_name.font_size, title_size, title_style_options)
				local circumstance_description_width, circumstance_description_height = UIRenderer.text_size(self._ui_renderer, content.circumstance_description, style.circumstance_description.font_type, style.circumstance_description.font_size, description_size, description_style_options)
				local title_height = circumstance_name_height - style.circumstance_name.size_addition[2]
				local description_height = circumstance_description_height - style.circumstance_description.size_addition[2]

				style.circumstance_name.size = {
					title_size[1] - style.circumstance_name.size_addition[1],
					title_height,
				}
				style.circumstance_description.offset[2] = style.circumstance_name.offset[2] + title_height + description_margin
				style.circumstance_description.size = {
					description_size[1] - style.circumstance_description.size_addition[1],
					description_height,
				}

				local text_height = style.circumstance_description.offset[2] + style.circumstance_description.size[2]

				self:_set_scenegraph_size("detail_circumstance", nil, text_height + 30)
			else
				content.has_circumstance = false
				content.circumstance_icon = nil
			end

			local extraRewards = mission.extraRewards and mission.extraRewards.circumstance

			xp = extraRewards and extraRewards.xp and extraRewards.xp + xp or xp

			if extraRewards and extraRewards.credits then
				credits = extraRewards.credits + credits or credits
			end
		else
			content.circumstance_icon = nil
		end

		local location_image_material_values = widget.style.location_image.material_values

		location_image_material_values.texture_map = mission_template.texture_big
		location_image_material_values.show_static = is_locked and 1 or 0
		style.bonus_title.visible = false

		if self._bonus_widgets then
			for i = 1, #self._bonus_widgets do
				local widget = self._bonus_widgets[i]

				self:_unregister_widget_name(widget.name)
			end

			self._bonus_widgets = nil
		end
	end

	do
		local vo_profile = mission.missionGiver or mission_template.mission_brief_vo.vo_profile
		local speaker_settings = DialogueSpeakerVoiceSettings[vo_profile]
		local mission_type = MissionTypes[mission_template.mission_type]
		local widget = self._widgets_by_name.objective_1

		widget.dirty = true
		widget.visible = true

		local content = widget.content
		local style = widget.style

		content.header_icon = mission_type.icon
		content.header_subtitle = Localize(mission_type.name)
		content.body_text = Localize(mission_template.mission_description)
		content.speaker_icon = speaker_settings.material_small
		content.speaker_text = "/ " .. Localize(speaker_settings.full_name)
		content.xp = TextUtils.format_currency(xp)
		content.credits = TextUtils.format_currency(credits)

		local description_style_options = UIFonts.get_font_options_by_style(style.body_text)
		local margin = 20
		local bottom_spacing = content.speaker_icon and 15 or 0
		local max_width = self._ui_scenegraph.objective.size[1] - margin * 2
		local description_width, description_height = UIRenderer.text_size(self._ui_renderer, content.body_text, style.body_text.font_type, style.body_text.font_size, {
			max_width,
			1080,
		}, description_style_options)

		widget.content.size = {
			self._ui_scenegraph.objective.size[1],
			self._ui_scenegraph.objective_header.size[2] + description_height + margin * 2 + bottom_spacing,
		}
		widget.style.reward_background.offset[2] = widget.content.size[2]
		widget.style.reward_gradient.offset[2] = widget.content.size[2]
		widget.style.reward_frame.offset[2] = widget.content.size[2]
		widget.style.reward_icon.offset[2] = widget.content.size[2]
		widget.style.reward_text.offset[2] = widget.content.size[2]
		widget.style.speaker_frame.offset[2] = widget.content.size[2]
		widget.style.speaker_corner.offset[2] = widget.content.size[2]
		widget.style.speaker_icon.offset[2] = widget.content.size[2]
		widget.offset[2] = self._ui_scenegraph.detail.size[2] + margin
	end

	do
		local side_mission_template = MissionObjectiveTemplates.side_mission.objectives[mission.sideMission]
		local widget = self._widgets_by_name.objective_2

		widget.dirty = true
		widget.visible = mission.flags.side and side_mission_template

		if widget.visible then
			local extraRewards = mission.extraRewards.sideMission
			local content = widget.content
			local style = widget.style

			content.header_icon = side_mission_template.icon
			content.header_subtitle = Localize(side_mission_template.header)
			content.body_text = Localize(side_mission_template.description)
			content.speaker_text = nil
			content.speaker_icon = nil
			content.xp = extraRewards and extraRewards.xp or 0
			content.credits = extraRewards and extraRewards.credits or 0
			content.xp = TextUtils.format_currency(content.xp)
			content.credits = TextUtils.format_currency(content.credits)

			local description_style_options = UIFonts.get_font_options_by_style(style.body_text)
			local margin = 20
			local bottom_spacing = (content.speaker_icon or extraRewards) and 15 or 0
			local max_width = self._ui_scenegraph.objective.size[1] - margin * 2
			local description_width, description_height = UIRenderer.text_size(self._ui_renderer, content.body_text, style.body_text.font_type, style.body_text.font_size, {
				max_width,
				1080,
			}, description_style_options)

			widget.content.size = {
				self._ui_scenegraph.objective.size[1],
				self._ui_scenegraph.objective_header.size[2] + description_height + margin * 2 + bottom_spacing,
			}
			widget.style.reward_background.offset[2] = widget.content.size[2]
			widget.style.reward_gradient.offset[2] = widget.content.size[2]
			widget.style.reward_frame.offset[2] = widget.content.size[2]
			widget.style.reward_icon.offset[2] = widget.content.size[2]
			widget.style.reward_text.offset[2] = widget.content.size[2]
			widget.style.speaker_frame.offset[2] = widget.content.size[2]
			widget.style.speaker_corner.offset[2] = widget.content.size[2]
			widget.style.speaker_icon.offset[2] = widget.content.size[2]
			widget.offset[2] = self._widgets_by_name.objective_1.offset[2] + self._widgets_by_name.objective_1.content.size[2] + margin
		end
	end

	self._widgets_by_name.difficulty_stepper.visible = false
	self._widgets_by_name.difficulty_stepper_window.visible = false
	self._widgets_by_name.play_team_button.visible = true
	self._widgets_by_name.play_team_button_legend.visible = true
end

MissionBoardView.draw = function (self, dt, t, input_service, layer)
	if not _hide_help_debug_message then
		-- Nothing
	end

	local ui_renderer = self:_begin_render_offscreen()
	local stored_service = input_service

	if self._mission_board_options then
		input_service = input_service:null_service()
	end

	UIRenderer.begin_pass(ui_renderer, self._ui_scenegraph, input_service, dt, self._render_settings)

	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		local widget = mission_widgets[i]

		if widget then
			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._quickplay_initialized then
		UIWidget.draw(self._quickplay_widget, ui_renderer)
	end

	if self._widgets_by_name.region then
		UIWidget.draw(self._widgets_by_name.region, ui_renderer)
	end

	if self._bonus_widgets then
		for i = 1, #self._bonus_widgets do
			local widget = self._bonus_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._mission_type_selection_widget then
		local widget = self._mission_type_selection_widget

		UIWidget.draw(widget, ui_renderer)
	end

	UIRenderer.end_pass(ui_renderer)
	self:_end_render_offscreen()
	MissionBoardView.super.draw(self, dt, t, input_service, layer)

	if self._mission_board_options then
		local elements_array = self._elements_array

		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				local element_name = element.__class_name

				if element_name == "ViewElemenMissionBoardOptions" then
					element:draw(dt, t, ui_renderer, self._render_settings, stored_service)
				end
			end
		end
	end
end

MissionBoardView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local elements_array = self._elements_array

	for i = 1, #elements_array do
		local element = elements_array[i]

		if element then
			local element_name = element.__class_name

			if element_name ~= "ViewElemenMissionBoardOptions" then
				element:draw(dt, t, ui_renderer, render_settings, input_service)
			end
		end
	end
end

MissionBoardView._begin_render_offscreen = function (self, dt, input_service)
	if not MissionBoardViewSettings.resource_renderer_enabled then
		return self._ui_renderer
	end

	local gui = self._ui_renderer.gui
	local ui_resource_renderer = self._ui_resource_renderer

	Gui.render_pass(gui, 0, ui_resource_renderer.base_render_pass, true, ui_resource_renderer.render_target)
	Gui.render_pass(gui, 1, "to_screen", false)

	return self._ui_resource_renderer
end

MissionBoardView._end_render_offscreen = function (self)
	if not MissionBoardViewSettings.resource_renderer_enabled then
		return
	end

	local gui = self._ui_renderer.gui
	local material = self._ui_resource_renderer.render_target_material

	Gui.bitmap(gui, material, "render_pass", "to_screen", Vector3(0, 0, 100), Vector2(Gui.resolution()))
end

MissionBoardView._destroy_mission_widget = function (self, widget)
	if not widget then
		return
	end

	local content = widget.content
	local mission_widgets = self._mission_widgets

	if widget == self._flash_mission_widget then
		local index = table.find(mission_widgets, widget)

		table.remove(mission_widgets, index)

		self._flash_mission_widget = nil
	else
		if content.mission_type == (self._selected_mission_type or "normal") then
			self._free_widget_positions[content.position.index] = content.position
		end

		UIWidget.destroy(self._ui_resource_renderer, widget)
		table.swap_delete(mission_widgets, table.find(mission_widgets, widget))
	end

	self:_unregister_widget_name(widget.name)
end

MissionBoardView._join_mission_data = function (self)
	local missions = self._backend_data.filtered_missions
	local widgets_by_name = self._widgets_by_name
	local mission_widgets = self._mission_widgets
	local found_removed_mission = false

	for i = #mission_widgets, 1, -1 do
		local widget = mission_widgets[i]

		if widget and widget.content.mission and widget.content.mission.id then
			local id = widget.content.mission.id

			if not table.find_by_key(missions, "id", id) then
				found_removed_mission = true

				if not widget.content.exit_anim_id then
					widget.content.exit_anim_id = self:_start_animation("mission_exit", widget, self, nil, 1, math.random_range(0, 0.5))
				end
			end
		end
	end

	if found_removed_mission then
		return
	end

	self._has_queued_missions = false

	local earliest_queued_mission_show_time = math.huge
	local t = Managers.time:time("main")
	local mission_small_widget_template = MissionBoardViewDefinitions.widget_definitions_functions.mission_small_widget_pass_function(self._selected_mission_type or "normal")
	local has_flash_mission_changed = false
	local has_story_mission_changed = false

	for i = 1, #missions do
		do
			local mission = missions[i]

			if widgets_by_name[mission.id] then
				-- Nothing
			else
				if t < mission.start_game_time then
					local server_time = Managers.backend:get_server_time(t)

					Log.info("MissionBoardView", "Not showing mission '%s', it's from the future, (%s>%s)", mission.id, tostring(mission.start_server_time), tostring(server_time))

					self._has_queued_missions = true
					earliest_queued_mission_show_time = math.min(mission.start_game_time, earliest_queued_mission_show_time)

					goto label_1_0
				end

				if mission.flags.flash and not has_flash_mission_changed then
					if not self._flash_mission_widget or not self._flash_mission_widget.content.mission or self._flash_mission_widget.content.mission.id ~= mission.id then
						if not self._flash_mission_widget then
							local mission_medium_widget_template = MissionBoardViewDefinitions.widget_definitions_functions.mission_medium_widget_pass_function(self._selected_mission_type or "normal")

							self._flash_mission_widget = self:_create_widget("flash", mission_medium_widget_template)
							self._flash_mission_widget.content.title = Localize("loc_mission_board_maelstrom_header")

							local mission_type = self._selected_mission_type or "normal"

							self._flash_mission_widget.offset[1] = MissionBoardViewSettings.mission_positions[mission_type].flash_mission_position[1]
							self._flash_mission_widget.offset[2] = MissionBoardViewSettings.mission_positions[mission_type].flash_mission_position[2]
						end

						self._flash_mission_widget.visible = false

						if self:_populate_mission_widget(self._flash_mission_widget, mission, self._flash_mission_widget.offset, true) then
							self:_start_animation("mission_enter", self._flash_mission_widget, self, nil, 1, math.random_range(0, 0.5))
							table.insert(mission_widgets, 1, self._flash_mission_widget)
						end
					end

					has_flash_mission_changed = true
				else
					local danger = DangerSettings.calculate_danger(mission.challenge, mission.resistance)
					local position = self:_get_free_position(mission.displayIndex, danger)

					if position then
						local widget = self:_create_widget(mission.id, mission_small_widget_template)

						if self:_populate_mission_widget(widget, mission, position) then
							widget.visible = false

							self:_start_animation("mission_enter", widget, self, nil, 1, math.random_range(0, 0.5))

							mission_widgets[#mission_widgets + 1] = widget
						end
					else
						Log.info("MissionBoardView", "Not showing mission '%s', due to lack of free spots", mission.id)

						self._has_queued_missions = true
					end
				end
			end
		end

		::label_1_0::
	end

	self._queued_mission_show_time = earliest_queued_mission_show_time
end

MissionBoardView._get_free_position = function (self, preferred_index, prefered_danger)
	local free_widget_positions = self._free_widget_positions
	local index = preferred_index or math.random(#free_widget_positions)
	local free_widget_positions_len = #free_widget_positions
	local available_prefered_danger = {}

	for i = 1, free_widget_positions_len do
		local free_widget_position = free_widget_positions[i]
		local free_widget_prefered_danger = free_widget_position and free_widget_position.prefered_danger

		if type(free_widget_prefered_danger) == "number" and prefered_danger == free_widget_prefered_danger then
			available_prefered_danger[#available_prefered_danger + 1] = free_widget_position
		end
	end

	local available_prefered_danger_len = #available_prefered_danger

	for i = 0, available_prefered_danger_len do
		local rand_index = (index - 1 + 47 * i) % available_prefered_danger_len + 1
		local position = available_prefered_danger[rand_index]

		if position then
			local position_index = position.index

			free_widget_positions[position_index] = false

			return position
		end
	end

	for i = 0, free_widget_positions_len do
		local rand_index = (index - 1 + 47 * i) % free_widget_positions_len + 1
		local position = free_widget_positions[rand_index]

		if position then
			free_widget_positions[rand_index] = false

			return position
		end
	end

	return false
end

MissionBoardView._populate_mission_widget = function (self, widget, mission, position, is_medium_widget)
	local map = mission.map
	local mission_template = MissionTemplates[map]

	widget.offset[1] = position[1]
	widget.offset[2] = position[2]

	local content = widget.content
	local style = widget.style

	content.mission = mission
	content.position = position
	style.mission_line.size[2] = position.length or 800 - position[2]

	local seed = math.floor(3511 * mission.start_game_time) + 68927 * math.floor(mission.expiry_game_time)
	local is_locked = self._player_level < mission.requiredLevel
	local location_image_material_values = style.location_image.material_values

	location_image_material_values.texture_map = is_medium_widget and mission_template.texture_medium or mission_template.texture_small
	location_image_material_values.show_static = is_locked and 1 or 0

	local danger = DangerSettings.calculate_danger(mission.challenge, mission.resistance)

	content.danger = danger
	content.is_locked = is_locked

	local completed_danger = self:_mission_highest_completed_danger(map)

	if completed_danger and completed_danger > 0 then
		local mission_difficulty_complete_icons = MissionBoardViewSettings.mission_difficulty_complete_icons
		local material = mission_difficulty_complete_icons[completed_danger]

		if material then
			content.completed_danger = completed_danger
			content.mission_completed_icon = material
		end
	end

	local circumstance = mission.circumstance

	if circumstance ~= "default" then
		local circumstance_template = CircumstanceTemplates[circumstance]
		local circumstance_ui_data = circumstance_template and circumstance_template.ui

		if circumstance_ui_data then
			content.has_circumstance = true
			content.circumstance_name = Localize(circumstance_ui_data.display_name)
			content.circumstance_description = Localize(circumstance_ui_data.description)
			content.circumstance_icon = circumstance_ui_data.icon
		end
	else
		content.circumstance_icon = nil
	end

	local mission_type = MissionTypes[mission_template.mission_type]

	content.objective_1_icon = mission_type.icon

	local side_mission_template = MissionObjectiveTemplates.side_mission.objectives[mission.sideMission]

	content.objective_2_icon = mission.flags.side and side_mission_template and side_mission_template.icon
	content.start_game_time = mission.start_game_time
	content.expiry_game_time = mission.expiry_game_time
	content.is_flash = mission.flags.flash
	content.fluff_frame = math.random_array_entry(MissionBoardViewSettings.fluff_frames, seed)
	content.mission_type = self._selected_mission_type or "normal"

	return true
end

MissionBoardView._mission_highest_completed_danger = function (self, mission_name)
	local key = "__m_" .. mission_name .. "_md"

	return Managers.stats:read_user_stat(1, key)
end

MissionBoardView.on_resolution_modified = function (self, scale)
	for _, widget in pairs(self._widgets_by_name) do
		widget.dirty = true
	end

	local material = self._ui_resource_renderer.render_target_material

	Material.set_scalar(material, "scanline_intensity", math.max(0.1, math.ilerp(0.6666666666666666, 1, scale)))
end

MissionBoardView.event_register_camera = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_camera")

	local world_spawner_settings = MissionBoardViewSettings.world_spawner_settings

	self._camera_unit = camera_unit

	self._world_spawner:create_viewport(camera_unit, world_spawner_settings.viewport_name, world_spawner_settings.viewport_type, world_spawner_settings.viewport_layer, world_spawner_settings.viewport_shading_environment)
	self._world_spawner:set_listener(world_spawner_settings.viewport_name)
end

MissionBoardView._update_fetch_missions = function (self, t)
	if self._do_widget_refresh then
		self._do_widget_refresh = false

		self:_join_mission_data()

		return
	elseif self._has_queued_missions and t >= self._queued_mission_show_time then
		self:_join_mission_data()

		return
	elseif t < self._backend_data_expiry_time or self._is_fetching_missions then
		return
	end

	self._is_fetching_missions = true

	local missions_future = self:_cancel_promise_on_exit(Managers.data_service.mission_board:fetch(nil, 1))

	missions_future:next(function (mission_data)
		return self:_update_bonus_rewards():next(function ()
			self._widgets_by_name.search_text.visible = false

			return Promise.resolved(mission_data)
		end)
	end):next(self._cb_fetch_success):catch(self._cb_fetch_failure)
end

MissionBoardView._update_bonus_rewards = function (self)
	return self:_cancel_promise_on_exit(Managers.data_service.mission_board:get_rewards()):next(function (bonus_data)
		local filtered_bonus_data = {}

		for mission_type, values in pairs(bonus_data) do
			for type, value in pairs(values) do
				local percentile_value = math.floor(value * 100 - 100)

				if percentile_value > 0 then
					filtered_bonus_data[mission_type] = filtered_bonus_data[mission_type] or {}
					filtered_bonus_data[mission_type][type] = percentile_value
				end
			end
		end

		self._bonus_data = filtered_bonus_data
	end):catch(function ()
		self._bonus_data = {}
	end)
end

MissionBoardView._fetch_success = function (self, data)
	local has_mission_types = false
	local missions = data.missions
	local narrative_mission = MissionUtilities.get_latest_narrative_mission(missions)
	local has_story_mission = not not narrative_mission
	local mission_giver = narrative_mission and narrative_mission.missionGiver
	local speaker_settings = mission_giver and DialogueSpeakerVoiceSettings[mission_giver]

	self._widgets_by_name.story_mission_view_button.content.visible = has_story_mission
	self._widgets_by_name.story_mission_view_button_frame.content.visible = has_story_mission

	if speaker_settings and speaker_settings.icon then
		self._widgets_by_name.story_mission_view_button_frame.style.char.material_values.main_texture = speaker_settings.icon
		self._widgets_by_name.story_mission_view_button_frame.style.char.size = {
			120,
			120,
		}
	end

	for i = 1, #missions do
		local mission = missions[i]

		if has_mission_types == true then
			break
		end

		for j = 1, #mission_types do
			if mission.category == mission_types[j] then
				has_mission_types = true

				break
			end
		end
	end

	self._backend_data = data
	self._backend_data_expiry_time = data.expiry_game_time
	self._is_fetching_missions = false
	self._do_widget_refresh = true

	self:_filter_mission_board(self._selected_mission_type)

	if has_mission_types then
		self:_generate_mission_type_selection()
	end

	self:_add_bonus_data()
end

MissionBoardView._add_bonus_data = function (self)
	if self._bonus_data then
		if self._bonus_data.quickplay and self._quickplay_widget then
			local max_bonus = 0
			local min_bonus = math.huge

			for type, value in pairs(self._bonus_data.quickplay) do
				min_bonus = math.min(min_bonus, value)
				max_bonus = math.max(max_bonus, value)
			end

			if min_bonus == max_bonus then
				local localized_bonus = Localize("loc_mission_board_card_bonus_text", true, {
					bonus_text = tostring(max_bonus),
				})

				self._quickplay_widget.content.bonus = localized_bonus
			else
				local bonus_range_text = string.format("%d-%d", min_bonus, max_bonus)
				local localized_bonus = Localize("loc_mission_board_card_bonus_text", true, {
					bonus_text = bonus_range_text,
				})

				self._quickplay_widget.content.bonus = localized_bonus
			end
		end

		if self._bonus_data.flash then
			local max_bonus = 0
			local min_bonus = math.huge

			for type, value in pairs(self._bonus_data.flash) do
				min_bonus = math.min(min_bonus, value)
				max_bonus = math.max(max_bonus, value)
			end

			if min_bonus == max_bonus then
				local localized_bonus = Localize("loc_mission_board_card_bonus_text", true, {
					bonus_text = tostring(max_bonus),
				})

				self._flash_mission_widget.content.bonus = localized_bonus
			else
				local bonus_range_text = string.format("%d-%d", min_bonus, max_bonus)
				local localized_bonus = Localize("loc_mission_board_card_bonus_text", true, {
					bonus_text = bonus_range_text,
				})

				self._flash_mission_widget.content.bonus = localized_bonus
			end
		end

		if self._bonus_data.story_mission then
			local max_bonus = 0
			local min_bonus = math.huge

			for type, value in pairs(self._bonus_data.story_mission) do
				min_bonus = math.min(min_bonus, value)
				max_bonus = math.max(max_bonus, value)
			end

			if min_bonus == max_bonus then
				local localized_bonus = Localize("loc_mission_board_card_bonus_text", true, {
					bonus_text = tostring(max_bonus),
				})

				self._story_mission_widget.content.bonus = localized_bonus
			else
				local bonus_range_text = string.format("%d-%d", min_bonus, max_bonus)
				local localized_bonus = Localize("loc_mission_board_card_bonus_text", true, {
					bonus_text = bonus_range_text,
				})

				self._story_mission_widget.content.bonus = localized_bonus
			end
		end
	end
end

MissionBoardView._fetch_failure = function (self, error_message)
	Log.error("MissionBoardView", "Fetching missions failed %s %s", error_message[1], error_message[2])

	self._backend_data_expiry_time = Managers.time:time("main") + MissionBoardViewSettings.fetch_retry_cooldown
	self._is_fetching_missions = false
end

MissionBoardView._update_happening = function (self, t)
	local happening = self._backend_data and self._backend_data.happening
	local widget = self._widgets_by_name.happening

	if happening and false then
		local circumstances = happening.circumstances

		for i = 1, #circumstances do
			local circumstance_name = circumstances[i]
			local circumstance_template = CircumstanceTemplates[circumstance_name]
			local circumstance_ui = circumstance_template and circumstance_template.ui
			local happening_display_name = circumstance_ui and circumstance_ui.happening_display_name

			if happening_display_name then
				widget.content.subtitle = Localize(happening_display_name)
				widget.visible = true

				return
			end
		end
	end

	widget.visible = false
end

MissionBoardView._callback_open_options = function (self, region_data)
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

MissionBoardView._callback_close_options = function (self)
	self:_destroy_options_element()
end

MissionBoardView._destroy_options_element = function (self)
	self:_remove_element("mission_board_options_element")

	self._mission_board_options = nil
end

MissionBoardView._callback_switch_mission_board = function (self, mission_type)
	self._free_widget_positions = nil

	self:_filter_mission_board(mission_type)

	self._widgets_by_name.difficulty_stepper.content.min_danger = MissionBoardViewSettings.stepper_difficulty[mission_type].min_danger
	self._widgets_by_name.difficulty_stepper.content.max_danger = MissionBoardViewSettings.stepper_difficulty[mission_type].max_danger

	self:_generate_widgets_by_mission_type(mission_type)

	if self._quickplay_initialized then
		self:_set_selected_quickplay(true)
	else
		self:_reset_selection()
	end

	self:_join_mission_data()
end

MissionBoardView._clean_backend_data = function (self, missions)
	for ii = #missions, 1, -1 do
		local mission_config = missions[ii]

		if not rawget(MissionTemplates, mission_config.map) then
			Log.exception("MissionBoardView", "Got mission from backend that doesn't exist locally '%s'", mission_config.map)
			table.remove(missions, ii)
		end
	end
end

MissionBoardView._filter_mission_board = function (self, board_type)
	if board_type == "normal" then
		board_type = nil
	end

	if not self._backend_data or not self._backend_data.missions then
		return {}
	end

	self:_clean_backend_data(self._backend_data.missions)

	local filtered_missions = {}

	for i = 1, #self._backend_data.missions do
		local mission = self._backend_data.missions[i]

		if mission.category == board_type then
			filtered_missions[#filtered_missions + 1] = mission
		end
	end

	self._free_widget_positions = self._free_widget_positions or table.clone(MissionBoardViewSettings.mission_positions[board_type or "normal"])
	self._quickplay_widget.offset[1] = self._free_widget_positions.quickplay_mission_position[1]
	self._quickplay_widget.offset[2] = self._free_widget_positions.quickplay_mission_position[2]

	if self._flash_mission_widget then
		self._flash_mission_widget.offset[1] = self._free_widget_positions.flash_mission_position[1]
		self._flash_mission_widget.offset[2] = self._free_widget_positions.flash_mission_position[2]
	end

	local localization_id = mission_type_data[self._selected_mission_type] and mission_type_data[self._selected_mission_type].title or mission_type_data.normal.title
	local title = Localize(localization_id)

	self._widgets_by_name.planet.content.title = title
	self._backend_data.filtered_missions = filtered_missions
end

MissionBoardView._on_back_pressed = function (self)
	if self._mission_board_options then
		-- Nothing
	else
		self:_callback_close_view()
	end
end

MissionBoardView._callback_close_view = function (self)
	Managers.ui:close_view(self.view_name)
end

MissionBoardView._callback_start_selected_mission = function (self)
	if not self.can_start_mission then
		return
	end

	self:_play_sound(UISoundEvents.mission_board_start_mission)
	Managers.ui:close_view(self.view_name)

	if Managers.narrative:complete_event(Managers.narrative.EVENTS.mission_board) then
		PlayerVOStoryStage.refresh_hub_story_stage()
	end

	local selected_mission = self._selected_mission
	local quickplay_difficulty = self._quickplay_difficulty

	if self._selected_mission then
		self._party_manager:wanted_mission_selected(self._selected_mission.id, self._private_match, BackendUtilities.prefered_mission_region)
	else
		local quickplay_data = "qp:challenge=" .. quickplay_difficulty

		if self._selected_mission_type and self._selected_mission_type ~= "normal" then
			quickplay_data = quickplay_data .. "|" .. self._selected_mission_type
		end

		self._party_manager:wanted_mission_selected(quickplay_data, self._private_match, BackendUtilities.prefered_mission_region)
	end
end

MissionBoardView._callback_toggle_game_settings_visibility = function (self)
	local previous_animation_id = self._game_settings_animation_id

	if previous_animation_id then
		self:_stop_animation(previous_animation_id)
	end

	local new_state = not self._game_settings_visible
	local animation_name = new_state and "game_settings_enter" or "game_settings_exit"

	self._game_settings_animation_id = self:_start_animation(animation_name, self._widgets_by_name, self)
	self._game_settings_visible = new_state
end

MissionBoardView._callback_on_danger_changed = function (self)
	self._quickplay_difficulty = self._widgets_by_name.difficulty_stepper.content.danger
end

MissionBoardView._callback_toggle_private_matchmaking = function (self)
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

MissionBoardView._set_play_button_game_mode_text = function (self, is_solo_play, is_private_match)
	local play_button_content = self._widgets_by_name.play_team_button.content
	local play_button_legend_content = self._widgets_by_name.play_team_button_legend.content
	local play_button_text = Utf8.upper(Localize("loc_mission_board_view_accept_mission"))
	local sub_text_color = Color.terminal_text_body_sub_header(255, true)

	if not is_solo_play and not is_private_match then
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_play_public"))
	elseif is_solo_play then
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_toggle_solo_play"))
	else
		play_button_legend_content.text = Utf8.upper(Localize("loc_mission_board_play_private"))
	end
end

MissionBoardView._callback_mission_widget_exit_done = function (self, widget)
	self:_destroy_mission_widget(widget)

	if self._selected_mission == widget.content.mission then
		if self._quickplay_initialized then
			self:_set_selected_quickplay()
		else
			self:_reset_selection()
		end
	end

	local mission_widgets = self._mission_widgets

	for i = 1, #mission_widgets do
		local widget = mission_widgets[i]

		if widget and widget.content.exit_anim_id then
			return
		end
	end

	self:_join_mission_data()
end

MissionBoardView.fetch_regions = function (self)
	local region_promise = Managers.backend.interfaces.region_latency:get_region_latencies()

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
		end)
	end)
end

MissionBoardView._cancel_promise_on_exit = function (self, promise)
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

MissionBoardView._on_group_finder_pressed = function (self)
	local view_name = "group_finder_view"
	local ui_manager = Managers.ui

	if ui_manager and not Managers.ui:view_active(view_name) then
		Managers.ui:open_view(view_name)
	end
end

MissionBoardView._telemetry_open = function (self)
	local telemetry_manager = Managers.telemetry_events

	if telemetry_manager then
		local name = string.format("%s_mission_board_view", self._selected_mission_type)

		telemetry_manager:open_view(name, self._hub_interaction)
	end
end

MissionBoardView._telemetry_close = function (self)
	local telemetry_manager = Managers.telemetry_events

	if telemetry_manager then
		local name = string.format("%s_mission_board_view", self._selected_mission_type)

		telemetry_manager:close_view(name)
	end
end

return MissionBoardView
