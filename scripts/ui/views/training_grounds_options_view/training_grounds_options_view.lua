local TrainingGroundsOptionsViewSettings = require("scripts/ui/views/training_grounds_options_view/training_grounds_options_view_settings")
local definition_path = "scripts/ui/views/training_grounds_options_view/training_grounds_options_view_definitions"
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local MasterItems = require("scripts/backend/master_items")
local TrainingGroundsSoundEvents = require("scripts/settings/training_grounds/training_grounds_sound_events")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local TrainingGroundsOptionsView = class("TrainingGroundsOptionsView", "BaseView")
local SINGLEPLAY_TYPES = MatchmakingConstants.SINGLEPLAY_TYPES
local view_settings = TrainingGroundsOptionsViewSettings

local function get_input_text(action_name, input_service_name)
	local alias_key = Managers.ui:get_input_alias_key(action_name, input_service_name)
	local input_text = InputUtils.input_text_for_current_input_device(input_service_name, alias_key)

	return input_text
end

TrainingGroundsOptionsView.init = function (self, settings, context)
	local definitions = require(definition_path)

	TrainingGroundsOptionsView.super.init(self, definitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
	self.training_grounds_settings = context.training_grounds_settings or "basic"
	self._context = context
	self._icons_load_ids = {}
end

TrainingGroundsOptionsView.on_enter = function (self)
	TrainingGroundsOptionsView.super.on_enter(self)
	self:_register_button_callbacks()
	self:_setup_info()

	if InputDevice.gamepad_active then
		self:_set_play_button_text()
	end
end

TrainingGroundsOptionsView._register_button_callbacks = function (self)
	local mechanism_context = self._context.mechanism_context
	local widgets_by_name = self._widgets_by_name
	local play_button = widgets_by_name.play_button
	play_button.content.hotspot.pressed_callback = callback(self, "_start_training_grounds", mechanism_context)
end

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	local material_values = widget.style.icon.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

TrainingGroundsOptionsView._load_reward_item_icons = function (self)
	local player = Managers.player:local_player(1)
	local profile = player:profile()
	local loadout = profile.loadout
	local slot_name = "slot_primary"
	local render_context = {
		camera_focus_slot_name = slot_name
	}
	local primary_item = loadout.slot_primary
	local reward_1 = self._widgets_by_name.reward_1

	if primary_item then
		local cb = callback(_apply_live_item_icon_cb_func, reward_1)
		local load_icon_id = Managers.ui:load_item_icon(primary_item, cb, render_context)
		reward_1.content.icon_load_id = load_icon_id
		reward_1.content.text = Localize(primary_item.display_name)
		self._icons_load_ids[#self._icons_load_ids + 1] = load_icon_id
	else
		reward_1.content.text = "n/a"
	end

	local slot_name = "slot_secondary"
	local secondary_item = loadout.slot_secondary
	local reward_2 = self._widgets_by_name.reward_2

	if secondary_item then
		render_context.camera_focus_slot_name = slot_name
		local cb = callback(_apply_live_item_icon_cb_func, reward_2)
		local load_icon_id = Managers.ui:load_item_icon(secondary_item, cb, render_context)
		reward_2.content.icon_load_id = load_icon_id
		reward_2.content.text = Localize(secondary_item.display_name)
		self._icons_load_ids[#self._icons_load_ids + 1] = load_icon_id
	else
		reward_2.content.text = "n/a"
	end
end

TrainingGroundsOptionsView._on_navigation_input_changed = function (self)
	self:_set_play_button_text()
end

TrainingGroundsOptionsView._set_play_button_text = function (self)
	local gamepad_active = InputDevice.gamepad_active
	local play_button = self._widgets_by_name.play_button
	local button_content = play_button.content
	local settings = view_settings.play_settings[self.training_grounds_settings]
	local input_text = get_input_text("confirm_pressed", "View")
	local text = gamepad_active and string.format("%s %s", input_text, Utf8.upper(settings.play_button_text)) or Utf8.upper(settings.play_button_text)
	button_content.original_text = text
	button_content.hotspot.is_selected = gamepad_active
end

TrainingGroundsOptionsView._start_training_grounds = function (self, mechanism_context)
	Managers.ui:play_2d_sound(TrainingGroundsSoundEvents.tg_hub_button)

	local level = Managers.state.mission:mission_level()

	if level then
		Level.trigger_event(level, "training_grounds_started")
	end

	local widgets_by_name = self._widgets_by_name
	local difficulty_stepper = widgets_by_name.difficulty_stepper
	local challenge_level = difficulty_stepper.content.danger
	mechanism_context.challenge_level = challenge_level
	local mission_name = mechanism_context.mission_name
	local Missions = require("scripts/settings/mission/mission_templates")
	local mission_settings = Missions[mission_name]
	local mechanism_name = mission_settings.mechanism_name
	local game_mode_name = mission_settings.game_mode_name
	local game_mode_settings = GameModeSettings[game_mode_name]

	if game_mode_settings.host_singleplay then
		Managers.multiplayer_session:reset("Hosting training grounds singleplayer mission")
		Managers.multiplayer_session:boot_singleplayer_session()
	end

	local is_host = Managers.connection:is_host()

	if is_host then
		Managers.connection:reset_seed()
	end

	Managers.mechanism:change_mechanism(mechanism_name, mechanism_context)
	Managers.mechanism:trigger_event("all_players_ready")
end

TrainingGroundsOptionsView.on_exit = function (self)
	TrainingGroundsOptionsView.super.on_exit(self)
end

TrainingGroundsOptionsView._setup_info = function (self)
	local widgets_by_name = self._widgets_by_name
	local header = widgets_by_name.header
	local body = widgets_by_name.body
	local play_button = widgets_by_name.play_button
	local header_content = header.content
	local body_content = body.content
	local play_button_content = play_button.content
	local settings = view_settings.play_settings[self.training_grounds_settings]
	header_content.header = settings.header_text
	header_content.sub_header = settings.sub_header_text
	body_content.body_text = settings.body_text
	play_button_content.text = settings.play_button_text
	local in_matchmaking = Managers.data_service.social:is_in_matchmaking()

	if in_matchmaking then
		play_button_content.hotspot.disabled = true
	end

	widgets_by_name.difficulty_stepper.content.danger = 3
	widgets_by_name.select_difficulty_text.content.text = Localize("loc_mission_board_select_difficulty")

	if self.training_grounds_settings ~= "shooting_range" then
		widgets_by_name.difficulty_stepper.content.visible = false
		widgets_by_name.select_difficulty_text.content.visible = false
	end

	if Managers.narrative:is_chapter_complete("onboarding", "play_training") then
		widgets_by_name.rewards_header.visible = false
		widgets_by_name.separator.content.visible = false
	else
		widgets_by_name.separator.content.visible = true
		widgets_by_name.rewards_header.visible = true
	end

	if self.training_grounds_settings ~= "basic" then
		if self.training_grounds_settings == "advanced" then
			local separator_widget = self._widgets_by_name.separator
			separator_widget.content.visible = false
		end

		widgets_by_name.rewards_header.content.visible = false
		widgets_by_name.reward_1.content.visible = false
		widgets_by_name.reward_2.content.visible = false
		local panel_size_small = view_settings.panel_size.small

		self:_resize_background(panel_size_small)
	else
		widgets_by_name.rewards_header.content.text = Utf8.upper(Localize("loc_training_grounds_rewards_title"))

		if Managers.narrative:is_chapter_complete("onboarding", "play_training") then
			widgets_by_name.reward_1.content.visible = false
			widgets_by_name.reward_2.content.visible = false
			local panel_size_small = view_settings.panel_size.small

			self:_resize_background(panel_size_small)
		else
			self:_load_reward_item_icons()
		end
	end
end

TrainingGroundsOptionsView._resize_background = function (self, new_size)
	self:_set_scenegraph_size("left_panel", new_size[1], new_size[2])

	local background_widget = self._widgets_by_name.background
	local style = background_widget.style
	style.background.size = {
		new_size[1] - 40,
		new_size[2] + 136
	}
	background_widget.dirty = true
end

TrainingGroundsOptionsView._unload_reward_item_icons = function (self)
	for i = 1, #self._icons_load_ids do
		Managers.ui:unload_item_icon(self._icons_load_ids[i])
	end
end

TrainingGroundsOptionsView.destroy = function (self)
	TrainingGroundsOptionsView.super.destroy(self)
	self:_unload_reward_item_icons()
end

return TrainingGroundsOptionsView
