-- chunkname: @scripts/ui/views/live_events_view/live_events_view_templates.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local TextUtilities = require("scripts/utilities/ui/text")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local InputUtils = require("scripts/managers/input/input_utils")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local MasterItems = require("scripts/backend/master_items")
local WalletSettings = require("scripts/settings/wallet_settings")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local LiveEvents = require("scripts/settings/live_event/live_events")
local InputDevice = require("scripts/managers/input/input_device")
local Promise = require("scripts/foundation/utilities/promise")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local Styles = require("scripts/ui/views/live_events_view/live_events_view_styles")
local Settings = require("scripts/ui/views/live_events_view/live_events_view_settings")
local event_progress_bar_content_override = {
	progress = 0,
	bar_length = Settings.default_progress_bar_size[1],
}

local function _reward_elements_change_function(content, style, dt, animations)
	local hotspot = content.hotspot or content.parent.hotspot

	if hotspot.is_hover then
		style.color = style.hover_color
	elseif InputDevice.gamepad_active and hotspot.is_selected then
		style.color = style.selected_color
	else
		style.color = style.default_color
	end
end

local RewardTemplates = {
	default = {
		currency = {
			widget_template = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					value_id = "frame",
					style = Styles.reward.frame,
					change_function = _reward_elements_change_function,
				},
				{
					pass_type = "texture",
					style_id = "frameframe_corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					value_id = "frame_corner",
					style = Styles.reward.frame_corner,
					change_function = _reward_elements_change_function,
				},
				{
					pass_type = "texture",
					style_id = "background",
					value = "content/ui/materials/backgrounds/terminal_basic",
					value_id = "background",
					style = Styles.reward.background,
				},
				{
					content_id = "hotspot",
					pass_type = "hotspot",
					style_id = "hotspot",
					style = Styles.reward.hotspot,
				},
				{
					pass_type = "texture",
					style_id = "icon",
					value_id = "icon",
					style = Styles.reward.currency_icon,
				},
				{
					pass_type = "text",
					style_id = "amount",
					value = "",
					value_id = "amount",
					style = Styles.reward.amount,
				},
			}, "rewards_box"),
			init = function (parent, widget, reward, tier)
				local amount = reward.amount
				local currency = reward.currency
				local currency_settings = currency and WalletSettings[currency]
				local currency_icon = currency_settings and currency_settings.icon_texture_big
				local content, style = widget.content, widget.style

				content.icon = currency_icon
				content.amount = tostring(amount)
				content.reward = reward
				content.tier_xp = tier.target
			end,
		},
		item = {
			widget_template = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					value_id = "frame",
					style = Styles.reward.frame,
					change_function = _reward_elements_change_function,
				},
				{
					pass_type = "texture",
					style_id = "frameframe_corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					value_id = "frame_corner",
					style = Styles.reward.frame_corner,
					change_function = _reward_elements_change_function,
				},
				{
					pass_type = "texture",
					style_id = "background",
					value = "content/ui/materials/backgrounds/terminal_basic",
					value_id = "background",
					style = Styles.reward.background,
				},
				{
					content_id = "hotspot",
					pass_type = "hotspot",
					style_id = "hotspot",
					style = Styles.reward.hotspot,
				},
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/icons/items/containers/item_container_landscape",
					value_id = "icon",
					style = Styles.reward.icon,
				},
			}, "rewards_box"),
			init = function (parent, widget, reward, tier)
				local id = reward.id
				local item = MasterItems.get_item(id)

				parent:_request_item_icon(widget, item, parent._ui_renderer)

				widget.content.item = item
				widget.content.reward = reward
				widget.content.tier_xp = tier.target
			end,
		},
		item_local = {
			widget_template = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					value_id = "frame",
					style = Styles.reward.frame,
					change_function = _reward_elements_change_function,
				},
				{
					pass_type = "texture",
					style_id = "frameframe_corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					value_id = "frame_corner",
					style = Styles.reward.frame_corner,
					change_function = _reward_elements_change_function,
				},
				{
					pass_type = "texture",
					style_id = "background",
					value = "content/ui/materials/backgrounds/terminal_basic",
					value_id = "background",
					style = Styles.reward.background,
				},
				{
					content_id = "hotspot",
					pass_type = "hotspot",
					style_id = "hotspot",
					style = Styles.reward.hotspot,
				},
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/icons/items/containers/item_container_landscape",
					value_id = "icon",
					style = Styles.reward.icon,
				},
			}, "rewards_box"),
			init = function (parent, widget, item_id)
				local item = MasterItems.get_item(item_id)

				parent:_request_item_icon(widget, item, parent._ui_renderer)

				widget.content.item = item
				widget.content.reward = nil
				widget.content.tier_xp = nil
			end,
		},
	},
}

local function _get_leftover_resource_stat(backend_data, statistic_type)
	if not backend_data or not backend_data.statistics then
		return 0
	end

	local statistics_data = backend_data.statistics

	for i = 1, #statistics_data do
		local stat_data = statistics_data[i]
		local type_path = stat_data.typePath
		local stat_type = type_path and type_path[1]

		if stat_type and stat_type == statistic_type then
			local value = stat_data.value

			if value then
				return value.collected or 0
			end
		end
	end

	return 0
end

local function _faction_network_value(event_id, faction)
	local event_settings = LiveEvents[event_id]
	local faction_network_lookup = event_settings and event_settings.faction_network_lookup

	if not faction_network_lookup then
		return nil
	end

	for network_index, faction_key in pairs(faction_network_lookup) do
		if faction_key == faction then
			return network_index - 1
		end
	end

	return nil
end

local function _callback_leftover_make_choice(parent, event, faction, button_content, entry_widgets)
	if not event then
		Log.error("LiveEventEntry", "No event id found for leftover choice button callback")

		return
	end

	button_content.resource_button_hotspot.choice_made = true

	local event_id = event.template_name
	local track_id = event.id

	if not track_id then
		Log.error("LiveEventEntry", "No track id on event '%s' for leftover pledge", tostring(event_id))

		button_content.resource_button_hotspot.choice_made = nil

		return
	end

	local faction_network = _faction_network_value(event_id, faction)

	if not faction_network then
		Log.error("LiveEventEntry", "No network value for faction '%s' on event '%s'", tostring(faction), tostring(event_id))

		button_content.resource_button_hotspot.choice_made = nil

		return
	end

	local game_session = Managers.state.game_session
	local is_server = game_session and game_session:is_server()
	local player_made_choice = false

	if not DEDICATED_SERVER and not is_server then
		if not game_session then
			Log.error("LiveEventEntry", "No game session available to send leftover pledge")

			button_content.resource_button_hotspot.choice_made = nil

			return
		end

		game_session:send_rpc_server("rpc_live_event_pledge_resources", track_id, faction_network)

		player_made_choice = true
	end

	if player_made_choice then
		local global_stat_settings = Settings.global_stats_settings and Settings.global_stats_settings[event_id]
		local global_stats = global_stat_settings and global_stat_settings.stats
		local global_stat_name = global_stats and global_stats[faction]
		local entry_body = entry_widgets and entry_widgets.entry_body
		local content = entry_body and entry_body.content

		if global_stat_name and content then
			local amount = content.resource_collected or 0
			local temp_data = parent:get_temp_progression_data()

			temp_data[event_id] = {
				page_idx = parent._selected_entry_page,
				[global_stat_name] = (content[global_stat_name] or 0) + amount,
			}
		end
	end
end

local function _create_side_choice_widget(event_id, faction)
	local faction_settings = Settings.faction_settings and Settings.faction_settings[event_id]

	if not faction_settings then
		Log.error("LiveEventEntry", "No faction settings found for faction %s, cannot create leftover choice widget", faction)

		return nil
	end

	local faction_data = faction_settings[faction]
	local faction_texture = faction_data and faction_data.texture
	local title_text = faction_data and Localize(faction_data.display_name)
	local background_style = table.clone(Styles.entry.side_table.background)

	background_style.material_values.texture_map = faction_texture

	local passes = {
		{
			pass_type = "texture_uv",
			style_id = "background",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "background",
			style = background_style,
		},
		{
			pass_type = "text",
			style_id = "title_text",
			value_id = "title_text",
			value = title_text,
			style = Styles.entry.side_table.title_text,
		},
		{
			pass_type = "text",
			style_id = "boons_text",
			value_id = "boons_text",
			value = Localize("loc_settings_menu_group_buff_interface_settings"),
			style = Styles.entry.side_table.boons_text,
		},
		{
			pass_type = "texture",
			style_id = "boons_text_divider",
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "boons_text_divider",
			style = Styles.entry.side_table.boons_text_divider,
		},
		{
			pass_type = "text",
			style_id = "boons_description",
			value_id = "boons_description",
			style = Styles.entry.side_table.boons_description,
		},
		{
			content_id = "resource_button_hotspot",
			pass_type = "hotspot",
			style_id = "resource_button_hotspot",
			style = Styles.entry.side_table.resource_button_hotspot,
			change_function = function (hotspot, style)
				hotspot.disabled = hotspot.choice_made and hotspot.choice_made or hotspot.disabled

				if not hotspot.disabled and InputDevice.gamepad_active then
					local input_service = Managers.input:get_input_service("View")
					local gamepad_input = hotspot.gamepad_input

					if gamepad_input and input_service:get(gamepad_input) then
						hotspot:pressed_callback()
					end
				end
			end,
		},
		{
			pass_type = "texture",
			style_id = "resource_button_background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "resource_button_background",
			style = Styles.entry.side_table.resource_button_background,
		},
		{
			pass_type = "texture",
			style_id = "resource_button_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			value_id = "resource_button_gradient",
			style = Styles.entry.side_table.resource_button_gradient,
			change_function = function (content, style)
				ButtonPassTemplates.terminal_button_change_function(content, style, "resource_button_hotspot")
				ButtonPassTemplates.terminal_button_hover_change_function(content, style, "resource_button_hotspot")
			end,
			visibility_function = function (content, style)
				return not content.resource_button_hotspot.disabled
			end,
		},
		{
			pass_type = "texture",
			style_id = "resource_button_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			value_id = "resource_button_frame",
			style = Styles.entry.side_table.resource_button_frame,
			change_function = function (content, style)
				ButtonPassTemplates.terminal_button_hover_change_function(content, style, "resource_button_hotspot")
			end,
			visibility_function = function (content, style)
				return not content.resource_button_hotspot.disabled
			end,
		},
		{
			pass_type = "texture",
			style_id = "resource_button_corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			value_id = "resource_button_corner",
			style = Styles.entry.side_table.resource_button_corner,
			change_function = function (content, style)
				ButtonPassTemplates.terminal_button_hover_change_function(content, style, "resource_button_hotspot")
			end,
			visibility_function = function (content, style)
				return not content.resource_button_hotspot.disabled
			end,
		},
		{
			pass_type = "rect",
			style_id = "resource_button_rect",
			value_id = "resource_button_rect",
			style = Styles.entry.side_table.resource_button_rect,
			visibility_function = function (content, style)
				return content.resource_button_hotspot.disabled
			end,
		},
		{
			pass_type = "text",
			style_id = "resource_button_text",
			value_id = "resource_button_text",
			style = Styles.entry.side_table.resource_button_text,
			change_function = function (content, style)
				local hotspot = content.resource_button_hotspot

				if hotspot.gamepad_input and InputDevice.gamepad_active then
					local input_service = Managers.input:get_input_service("View")
					local gamepad_input = hotspot.gamepad_input

					if gamepad_input then
						local service_type = "View"
						local input_text = InputUtils.input_text_for_current_input_device(service_type, gamepad_input)
						local loc_key = content.resource_button_text_key or ""

						content.resource_button_text = string.format("%s %s", input_text, Localize(loc_key))
					end
				else
					local loc_key = content.resource_button_text_key or ""

					content.resource_button_text = Localize(loc_key)
				end

				ButtonPassTemplates.default_button_text_change_function(content, style, "resource_button_hotspot")
			end,
		},
	}
	local widget = UIWidget.create_definition(passes, "entries")

	return widget
end

local EntryBodyTemplates = {
	default = {
		widget_template = UIWidget.create_definition({
			{
				pass_type = "text",
				style_id = "event_name",
				value = "event_name",
				value_id = "event_name",
				style = Styles.texts.event_name,
			},
			{
				pass_type = "texture",
				style_id = "event_name_divider",
				value = "content/ui/materials/dividers/skull_center_02",
				value_id = "event_name_divider",
				style = Styles.texts.event_name_divider,
			},
			{
				pass_type = "text",
				style_id = "event_lore",
				value = "event_lore",
				value_id = "event_lore",
				style = Styles.texts.event_lore,
			},
			{
				pass_type = "text",
				style_id = "event_context",
				value = "event_context",
				value_id = "event_context",
				style = Styles.texts.event_context,
			},
			{
				pass_type = "text",
				style_id = "event_description",
				value = "event_description",
				value_id = "event_description",
				style = Styles.texts.event_description,
			},
			{
				pass_type = "text",
				style_id = "rewards_track_text",
				value_id = "rewards_track_text",
				style = Styles.texts.rewards_track_text,
			},
		}, "entries"),
		init = function (parent, widget, event, event_data, ui_renderer)
			local event_id = event and event.template_name or event_data.id
			local entry_data = LiveEvents[event_id]
			local height = Styles.spacing.text_top_padding + Styles.spacing.event_name_height + 20
			local content, style = widget.content, widget.style

			content.event_name = entry_data and Localize(entry_data.name) or ""

			if entry_data and entry_data.lore then
				local event_lore = Localize(entry_data.lore)

				content.event_lore = event_lore

				local lore_text_style = style.event_lore
				local lore_text_height = TextUtilities.text_height(ui_renderer, event_lore, lore_text_style, lore_text_style.size, true)

				lore_text_style.size[2] = lore_text_height
				height = height + lore_text_height + 46
				style.event_lore.visible = true
			else
				style.event_lore.visible = false
			end

			local event_description = entry_data and Localize(entry_data.description) or "n/a"

			content.event_description = event_description

			local description_text_height = TextUtilities.text_height(ui_renderer, event_description, Styles.texts.event_description, Styles.texts.event_description.size, true)
			local description_text_style = style.event_description

			description_text_style.size[2] = description_text_height
			description_text_style.offset[2] = height + 20
			height = height + description_text_height + 60

			if entry_data and entry_data.event_context then
				local event_context = Localize(entry_data.event_context)

				content.event_context = event_context

				local context_text_style = style.event_context
				local context_text_height = TextUtilities.text_height(ui_renderer, event_context, context_text_style, context_text_style.size, true)

				context_text_style.size[2] = context_text_height
				context_text_style.offset[2] = height
				height = height + context_text_height + 20
				style.event_context.visible = true
			else
				style.event_context.visible = false
			end

			content.rewards_track_text = entry_data and Localize("loc_mission_voting_view_salary") .. ":" or ""
			style.rewards_track_text.visible = not not event or event_data and event_data.item_rewards
			style.rewards_track_text.offset[2] = height
			height = height + 20
			widget.visible = true

			return height
		end,
	},
	skulls_guns = {
		widget_template = UIWidget.create_definition({
			{
				pass_type = "text",
				style_id = "event_name",
				value = "event_name",
				value_id = "event_name",
				style = Styles.texts.event_name,
			},
			{
				pass_type = "texture",
				style_id = "event_name_divider",
				value = "content/ui/materials/dividers/skull_center_02",
				value_id = "event_name_divider",
				style = Styles.texts.event_name_divider,
			},
			{
				pass_type = "text",
				style_id = "event_lore",
				value = "event_lore",
				value_id = "event_lore",
				style = Styles.texts.event_lore,
			},
			{
				pass_type = "text",
				style_id = "event_context",
				value = "event_context",
				value_id = "event_context",
				style = Styles.texts.event_context,
			},
			{
				pass_type = "text",
				style_id = "event_description",
				value = "event_description",
				value_id = "event_description",
				style = Styles.texts.event_description,
			},
			{
				pass_type = "text",
				style_id = "rewards_track_text",
				value_id = "rewards_track_text",
				style = Styles.texts.rewards_track_text,
			},
			{
				content_id = "event_view_button_hotspot",
				pass_type = "hotspot",
				style_id = "event_view_button_hotspot",
				style = Styles.entry.event_view_button.hotspot,
			},
			{
				pass_type = "texture",
				style_id = "event_view_button_background",
				value = "content/ui/materials/backgrounds/terminal_basic",
				value_id = "event_view_button_background",
				style = Styles.entry.event_view_button.background,
			},
			{
				pass_type = "texture",
				style_id = "event_view_button_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				value_id = "event_view_button_gradient",
				style = Styles.entry.event_view_button.gradient,
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_change_function(content, style, "event_view_button_hotspot")
					ButtonPassTemplates.terminal_button_hover_change_function(content, style, "event_view_button_hotspot")
				end,
				visibility_function = function (content, style)
					return not content.event_view_button_hotspot.disabled
				end,
			},
			{
				pass_type = "texture",
				style_id = "event_view_button_frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				value_id = "event_view_button_frame",
				style = Styles.entry.event_view_button.frame,
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style, "event_view_button_hotspot")
				end,
				visibility_function = function (content, style)
					return not content.event_view_button_hotspot.disabled
				end,
			},
			{
				pass_type = "texture",
				style_id = "event_view_button_corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				value_id = "event_view_button_corner",
				style = Styles.entry.event_view_button.corner,
				change_function = function (content, style)
					ButtonPassTemplates.terminal_button_hover_change_function(content, style, "event_view_button_hotspot")
				end,
				visibility_function = function (content, style)
					return not content.event_view_button_hotspot.disabled
				end,
			},
			{
				pass_type = "rect",
				style_id = "event_view_button_rect",
				value_id = "event_view_button_rect",
				style = Styles.entry.event_view_button.rect,
				visibility_function = function (content, style)
					return content.event_view_button_hotspot.disabled
				end,
			},
			{
				pass_type = "text",
				style_id = "event_view_button_text",
				value_id = "event_view_button_text",
				style = Styles.entry.event_view_button.text,
				change_function = function (content, style)
					ButtonPassTemplates.default_button_text_change_function(content, style, "event_view_button_hotspot")

					local gamepad_active = content.event_view_button_hotspot.gamepad_active

					if not content.was_gamepad_active and gamepad_active then
						local service_type = "View"
						local alias_key = Managers.ui:get_input_alias_key("gamepad_secondary_action_pressed", service_type)
						local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

						content.event_view_button_text = string.format("%s %s", input_text, Localize("loc_skulls_guns_progress_view_open_cta"))
					elseif content.was_gamepad_active and not gamepad_active then
						content.event_view_button_text = Localize("loc_skulls_guns_progress_view_open_cta")
					end

					content.was_gamepad_active = gamepad_active
				end,
			},
		}, "entries_anchor"),
		init = function (parent, widget, event, event_data, ui_renderer)
			local event_id = event and event.template_name or event_data.id
			local entry_data = LiveEvents[event_id]
			local height = Styles.spacing.text_top_padding + Styles.spacing.event_name_height + 20
			local content, style = widget.content, widget.style

			content.event_name = entry_data and Localize(entry_data.name) or ""

			if entry_data and entry_data.lore then
				local event_lore = Localize(entry_data.lore)

				content.event_lore = event_lore

				local lore_text_style = style.event_lore
				local lore_text_height = TextUtilities.text_height(ui_renderer, event_lore, lore_text_style, lore_text_style.size, true)

				lore_text_style.size[2] = lore_text_height
				height = height + lore_text_height + 46
				style.event_lore.visible = true
			else
				style.event_lore.visible = false
			end

			local event_description = entry_data and Localize(entry_data.description) or "n/a"

			content.event_description = event_description

			local description_text_height = TextUtilities.text_height(ui_renderer, event_description, Styles.texts.event_description, Styles.texts.event_description.size, true)
			local description_text_style = style.event_description

			description_text_style.size[2] = description_text_height
			description_text_style.offset[2] = height + 20
			height = height + description_text_height + 60

			if entry_data and entry_data.event_context then
				local event_context = Localize(entry_data.event_context)

				content.event_context = event_context

				local context_text_style = style.event_context
				local context_text_height = TextUtilities.text_height(ui_renderer, event_context, context_text_style, context_text_style.size, true)

				context_text_style.size[2] = context_text_height
				context_text_style.offset[2] = height
				height = height + context_text_height + 20
				style.event_context.visible = true
			else
				style.event_context.visible = false
			end

			style.event_view_button_hotspot.offset[2] = height + 10
			style.event_view_button_background.offset[2] = height + 10 - 12
			style.event_view_button_gradient.offset[2] = height + 10
			style.event_view_button_frame.offset[2] = height + 10
			style.event_view_button_corner.offset[2] = height + 10
			style.event_view_button_rect.offset[2] = height + 10
			style.event_view_button_text.offset[2] = height + 10
			content.event_view_button_text = Localize("loc_action_interaction_open")
			height = height + Styles.sizes.event_button_size[2] + 20
			content.rewards_track_text = entry_data and Localize("loc_mission_voting_view_salary") .. ":" or ""
			style.rewards_track_text.visible = not not event
			style.rewards_track_text.offset[2] = height
			height = height + 20
			widget.visible = true

			return height
		end,
	},
	leftover = {
		widget_template = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "resource_decoration_icon",
				value = "content/ui/materials/live_events/leftover/leftover_relic_symbol_decoration",
				value_id = "resource_decoration_icon",
				style = Styles.entry.resource_decoration_icon,
			},
			{
				pass_type = "texture",
				style_id = "resource_counter_frame",
				value = "content/ui/materials/live_events/collected_resouces_frame",
				value_id = "resource_counter_frame",
				style = Styles.entry.resource_counter_frame,
			},
			{
				pass_type = "text",
				style_id = "resource_counter_text",
				value = "0",
				value_id = "resource_counter_text",
				style = Styles.entry.resource_counter_text,
				change_function = function (content, style)
					local resource_collected = content.resource_collected or 0

					content.resource_counter_text = tostring(resource_collected)
				end,
			},
			{
				pass_type = "text",
				style_id = "resource_counter_label",
				value_id = "resource_counter_label",
				value = Localize("loc_resource_counter_label"),
				style = Styles.entry.resource_counter_label,
			},
			{
				pass_type = "text",
				style_id = "resource_collected_text",
				value_id = "resource_collected_text",
				value = Localize("loc_collected_resources"),
				style = Styles.texts.resource_collected_text,
			},
			{
				pass_type = "texture",
				style_id = "tug_of_war_bar_frame",
				value = "content/ui/materials/live_events/live_events_view_progress_bar_frame_foreground",
				value_id = "tug_of_war_bar_frame",
				style = Styles.entry.tug_of_war_bar_frame,
			},
			{
				pass_type = "texture_uv",
				style_id = "tug_of_war_bar_fill_a",
				value = "content/ui/materials/live_events/live_events_view_progress_bar_faction_a",
				value_id = "tug_of_war_bar_fill_a",
				style = Styles.entry.tug_of_war_bar_fill_left,
			},
			{
				pass_type = "texture_uv",
				style_id = "tug_of_war_bar_fill_b",
				value = "content/ui/materials/live_events/live_events_view_progress_bar_faction_b",
				value_id = "tug_of_war_bar_fill_b",
				style = Styles.entry.tug_of_war_bar_fill_right,
			},
			{
				pass_type = "texture",
				style_id = "tug_of_war_bar_background",
				value = "content/ui/materials/live_events/live_events_view_progress_bar_frame_background",
				value_id = "tug_of_war_bar_background",
				style = Styles.entry.tug_of_war_bar_background,
			},
			{
				pass_type = "texture",
				style_id = "tug_of_war_bar_divider",
				value = "content/ui/materials/live_events/live_events_view_progress_bar_devider_glow",
				value_id = "tug_of_war_bar_divider",
				style = Styles.entry.tug_of_war_bar_divider,
			},
			{
				pass_type = "text",
				style_id = "tug_of_war_bar_text_left",
				value = "0",
				value_id = "tug_of_war_bar_text_left",
				style = Styles.entry.tug_of_war_bar_text_left,
			},
			{
				pass_type = "text",
				style_id = "tug_of_war_bar_text_right",
				value = "0",
				value_id = "tug_of_war_bar_text_right",
				style = Styles.entry.tug_of_war_bar_text_right,
			},
		}, "entries"),
		init = function (parent, widget, event, event_data, ui_renderer)
			local event_id = event and event.template_name or event_data.id
			local entry_data = LiveEvents[event_id]
			local height = Styles.spacing.text_top_padding + Styles.spacing.event_name_height + 20
			local content, style = widget.content, widget.style
			local bar_style_a = style.tug_of_war_bar_fill_a
			local bar_style_b = style.tug_of_war_bar_fill_b
			local bar_left_x = (Styles.sizes.entry_width - Styles.sizes.tug_o_war_bar_fill_size[1]) * 0.5 + 2

			bar_style_a.size[1] = bar_style_a.default_size[1] * 0.5
			bar_style_b.size[1] = bar_style_b.default_size[1] * 0.5
			bar_style_a.uvs[2][1] = 0.5
			bar_style_b.uvs[1][1] = 0.5
			bar_style_a.offset[1] = bar_left_x
			bar_style_b.offset[1] = bar_left_x + bar_style_a.size[1] - 2
			style.tug_of_war_bar_divider.offset[1] = bar_style_a.offset[1] + bar_style_a.size[1] - 19.2
			content.display_stat_a = 0
			content.display_stat_b = 0
			content.tug_of_war_bar_text_left = "0"
			content.tug_of_war_bar_text_right = "0"
			content.event_name = entry_data and Localize(entry_data.name) or ""

			local local_player = Managers.player:local_player(1)
			local account_id = local_player:account_id()
			local track_id = event and event.id

			if track_id then
				Managers.backend.interfaces.tracks:get_track_statistics_by_type(account_id, track_id, "artifacts"):next(function (response)
					local collected_resources = _get_leftover_resource_stat(response, "artifacts")

					content.resource_collected = collected_resources
				end):catch(function (error)
					Log.error("LiveEventEntry", "Failed to get track statistics for event %s, error: %s", event_id, tostring(error))

					content.resource_collected = 0
				end)
			else
				content.resource_collected = 0
			end

			local faction_settings = Settings.faction_settings and Settings.faction_settings[event_id]
			local global_stat_settings = Settings.global_stats_settings and Settings.global_stats_settings[event_id]

			if global_stat_settings and faction_settings then
				local global_stats = global_stat_settings.stats

				Managers.data_service.global_stats:subscribe(parent, "_callback_on_faction_stat_update", global_stat_settings.category, global_stats[faction_settings.pure.id], 0)
				Managers.data_service.global_stats:subscribe(parent, "_callback_on_faction_stat_update", global_stat_settings.category, global_stats[faction_settings.impure.id], 0)

				if parent._promise_container then
					parent._promise_container:cancel_on_destroy(Managers.data_service.global_stats:get(global_stat_settings.category)):next(function (stats)
						local stat_a, stat_b = 0, 0
						local faction_a_id = faction_settings.pure.id
						local faction_b_id = faction_settings.impure.id

						stat_a = stats[global_stats[faction_a_id]] or 0
						stat_b = stats[global_stats[faction_b_id]] or 0
						content[global_stats[faction_a_id]] = stat_a
						content[global_stats[faction_b_id]] = stat_b
						content.tug_o_war_ready = true

						local tot_stat = stat_a + stat_b
						local temp_data = parent:get_temp_progression_data()

						temp_data[event_id] = {
							page_idx = parent._selected_entry_page,
							[global_stats[faction_a_id]] = stat_a,
							[global_stats[faction_b_id]] = stat_b,
						}
					end):catch(function (error)
						Log.error("LiveEventEntry", "Failed to get global stats for event %s, error: %s", event_id, tostring(error))

						if not faction_settings or not global_stats then
							content.tug_of_war_bar_text_left = "0"
							content.tug_of_war_bar_text_right = "0"

							return
						end

						local faction_a_id = faction_settings.pure.id
						local faction_b_id = faction_settings.impure.id

						content.tug_of_war_bar_text_left = "0"
						content.tug_of_war_bar_text_right = "0"
						content[global_stats[faction_a_id]] = 0
						content[global_stats[faction_b_id]] = 0
					end)
				end
			end

			height = height + 20
			widget.visible = true

			return Styles.sizes.entry_height
		end,
	},
}
local experience_bar_passes = table.clone(BarPassTemplates.experience_bar)
local default_progress_bar_passes = table.append(experience_bar_passes, {
	{
		pass_type = "text",
		scenegraph_id = "event_progress_bar",
		style_id = "progress_text",
		value_id = "progress_text",
		style = Styles.event_progress_bar.progress_text,
	},
})
local ProgressBarTemplates = {
	default = {
		widget_template = UIWidget.create_definition(default_progress_bar_passes, "event_progress_bar", event_progress_bar_content_override),
		init = function (parent, widget, event, ui_renderer)
			if not event then
				return
			end

			local event_progress_bar_content = widget.content
			local event_progress_bar_style = widget.style
			local current_progress = Managers.live_event:event_progress(nil, event.id)
			local tiers = event.tiers or {}
			local num_tiers = #tiers
			local max_progress = math.max(tiers[num_tiers] and tiers[num_tiers].target or 1, 1)

			current_progress = math.clamp(current_progress, 0, max_progress)

			local actual_progress = math.clamp(current_progress / max_progress, 0, 1)

			event_progress_bar_content.progress = actual_progress or 0
			event_progress_bar_content.current_progress = actual_progress or 0
			event_progress_bar_content.max_progress = max_progress
			event_progress_bar_content.progress_text = string.format("%d / %d", current_progress, max_progress)
			event_progress_bar_style.bar.color = Color.golden_rod(255, true)

			parent:_set_current_event_progress(current_progress)
		end,
	},
}
local default_main_page_composition = {
	entry_body = EntryBodyTemplates.default,
	rewards = RewardTemplates.default,
	progress_bar = ProgressBarTemplates.default,
}

local function _default_initialize_function(parent, composition, event, event_data, page_index)
	if not composition or table.is_empty(composition) then
		return
	end

	page_index = page_index or 1

	local page_offset_x = Settings.default_entry_width * (page_index - 1)
	local entry_widgets = {}
	local ui_renderer = parent._ui_renderer
	local total_height = 0
	local body_template = composition.entry_body

	if body_template then
		local widget_definition = body_template.widget_template
		local widget = UIWidget.init("entry_body", widget_definition)

		entry_widgets.entry_body = widget
		total_height = body_template.init(parent, widget, event, event_data, ui_renderer)
		widget.offset[1] = page_offset_x
	end

	local should_increase_size = false
	local rewards_template = composition.rewards
	local entry_reward_widgets = {}
	local reward_widgets = {}
	local line_widgets = {}

	if event and rewards_template then
		local tiers = event.tiers or {}
		local bar_width = Settings.default_progress_bar_size[1]
		local rewards_box_width = parent._ui_scenegraph.rewards_box.size[1]
		local num_tiers = #tiers
		local max_target_exp = math.max(tiers[num_tiers] and tiers[num_tiers].target or 1, 1)

		for k = 1, num_tiers do
			local tier = tiers[k]
			local rewards = tier.rewards or {}

			for j = 1, #rewards do
				local tier_index = k
				local reward_index = j
				local reward = rewards[j]
				local reward_template = rewards_template[reward.type]

				if reward_template then
					local reward_widget
					local widget_definition = reward_template.widget_template

					reward_widget = UIWidget.init("reward_" .. tier_index .. "_" .. reward_index, widget_definition)

					reward_template.init(parent, reward_widget, reward, tier)

					reward_widgets[#reward_widgets + 1] = reward_widget

					local line_widget_definition = UIWidget.create_definition({
						{
							pass_type = "texture",
							style_id = "line",
							value = "content/ui/materials/mission_board/mission_line",
							value_id = "line",
							style = Styles.reward.bar_connection_line,
						},
					}, "event_progress_bar")
					local line_widget = UIWidget.init("line_" .. tier_index .. "_" .. reward_index, line_widget_definition)

					line_widgets[#line_widgets + 1] = line_widget

					local tier_target_exp = tier.target or 1
					local rewards_spacing = tier_target_exp / max_target_exp * rewards_box_width
					local line_spacing = tier_target_exp / max_target_exp * bar_width
					local offset_x = rewards_spacing - 2

					reward_widget.offset[1] = page_offset_x + offset_x - Styles.sizes.reward_size[1] / 2
					line_widget.offset[1] = page_offset_x + line_spacing - 2

					local has_reward_with_same_target = false

					for m = 1, #reward_widgets do
						local widget = reward_widgets[m]
						local content = widget.content

						if content.tier_xp == tier.target and widget ~= reward_widget then
							has_reward_with_same_target = true
							should_increase_size = true

							break
						end
					end

					if has_reward_with_same_target then
						reward_widget.offset[2] = -(Styles.sizes.reward_size[2] + 10)
					else
						reward_widget.offset[2] = -(j - 1) * (Styles.sizes.reward_size[2] + 10)
					end
				else
					Log.warning("LiveEventsView", "No reward template found for reward type %s", tostring(reward.type))
				end
			end
		end
	elseif event_data and event_data.item_rewards then
		local item_rewards = event_data.item_rewards
		local rewards_box_width = parent._ui_scenegraph.rewards_box.size[1]
		local reward_start_x = rewards_box_width * 0.5 - Styles.sizes.reward_size[1] * 0.5

		for reward_index, reward in pairs(item_rewards) do
			local reward_template = rewards_template.item_local

			if reward_template then
				local widget_definition = reward_template.widget_template
				local reward_widget = UIWidget.init("reward_item_" .. reward_index, widget_definition)

				reward_template.init(parent, reward_widget, reward, {})

				reward_widgets[#reward_widgets + 1] = reward_widget
				reward_widget.offset[1] = page_offset_x + reward_start_x + (reward_index - 1) * (Styles.sizes.reward_size[1] + 40)
				reward_widget.offset[2] = Styles.sizes.reward_size[2]
			end
		end

		total_height = total_height + Styles.sizes.reward_size[2] + 80
	end

	entry_reward_widgets.rewards = reward_widgets
	entry_reward_widgets.lines = line_widgets
	entry_widgets.rewards = entry_reward_widgets

	if should_increase_size then
		total_height = total_height + Styles.sizes.reward_size[2] + 10
	end

	local progress_bar_template = composition.progress_bar

	if event and progress_bar_template then
		local widget_definition = progress_bar_template.widget_template
		local widget = UIWidget.init("progress_bar", widget_definition)

		entry_widgets.progress_bar = widget

		progress_bar_template.init(parent, widget, event, ui_renderer)

		widget.offset[1] = page_offset_x
		total_height = total_height + 260
	end

	return entry_widgets, total_height
end

local function _default_draw_function(parent, dt, t, ui_renderer, render_settings, input_service, entry_widgets)
	if not entry_widgets or table.is_empty(entry_widgets) then
		return
	end

	if entry_widgets.entry_body then
		UIWidget.draw(entry_widgets.entry_body, ui_renderer)
	end

	if entry_widgets.rewards then
		local rewards = entry_widgets.rewards.rewards or {}

		for _, reward_widget in pairs(rewards) do
			UIWidget.draw(reward_widget, ui_renderer)
		end

		local lines = entry_widgets.rewards.lines or {}

		for _, line_widget in pairs(lines) do
			UIWidget.draw(line_widget, ui_renderer)
		end
	end

	if entry_widgets.progress_bar then
		UIWidget.draw(entry_widgets.progress_bar, ui_renderer)
	end
end

local function _default_destroy_function(parent, entry_widgets, ui_renderer)
	if not entry_widgets or table.is_empty(entry_widgets) then
		return
	end

	if entry_widgets.entry_body then
		UIWidget.destroy(ui_renderer, entry_widgets.entry_body)
	end

	if entry_widgets.rewards then
		local rewards = entry_widgets.rewards.rewards or {}

		for _, reward_widget in pairs(rewards) do
			parent:_unload_item_icon(reward_widget, ui_renderer)
			UIWidget.destroy(ui_renderer, reward_widget)
		end

		local lines = entry_widgets.rewards.lines or {}

		for _, line_widget in pairs(lines) do
			UIWidget.destroy(ui_renderer, line_widget)
		end
	end

	if entry_widgets.progress_bar then
		UIWidget.destroy(ui_renderer, entry_widgets.progress_bar)
	end

	table.clear(entry_widgets)
end

local Templates = {}

Templates.default = {
	pages = {
		{
			composition = table.clone(default_main_page_composition),
			initialize = _default_initialize_function,
			draw = _default_draw_function,
			destroy = _default_destroy_function,
		},
	},
}
Templates.skulls_guns = {
	pages = {
		{
			composition = {
				entry_body = EntryBodyTemplates.skulls_guns,
				rewards = RewardTemplates.default,
				progress_bar = ProgressBarTemplates.default,
			},
			initialize = function (parent, composition, event, event_data, page_index)
				local entry_widgets, total_height = _default_initialize_function(parent, composition, event, event_data, page_index)
				local LiveEventSkullsGunsProgressView = require("scripts/ui/views/live_events_view/live_event_skulls_guns_progress_view/live_event_skulls_guns_progress_view")
				local widget = entry_widgets.entry_body

				widget.content.event_view_button_hotspot.pressed_callback = LiveEventSkullsGunsProgressView.open
				widget.content.event_view_button_text = Localize("loc_skulls_guns_progress_view_open_cta")

				return entry_widgets, total_height
			end,
			draw = function (parent, dt, t, ui_renderer, render_settings, input_service, entry_widgets)
				_default_draw_function(parent, dt, t, ui_renderer, render_settings, input_service, entry_widgets)

				if input_service:get("gamepad_secondary_action_pressed") then
					entry_widgets.entry_body.content.event_view_button_hotspot.pressed_callback()
				end
			end,
			destroy = _default_destroy_function,
		},
	},
}

local leftover_choice_page = {
	composition = {
		entry_body = EntryBodyTemplates.leftover,
		rewards = RewardTemplates.default,
	},
	initialize = function (parent, composition, event, event_data, page_index)
		if not composition or table.is_empty(composition) then
			return
		end

		local event_id = event and event.template_name or event_data.id
		local entry_widgets = {}
		local ui_renderer = parent._ui_renderer
		local total_height = 0
		local body_template = composition.entry_body
		local body_widget

		if body_template then
			local widget_definition = body_template.widget_template
			local widget = UIWidget.init("entry_body", widget_definition)

			entry_widgets.entry_body = widget
			body_widget = widget
			total_height = body_template.init(parent, widget, event, event_data, ui_renderer)
			widget.offset[1] = Settings.default_entry_width * (page_index - 1)
		end

		local player_resources = body_widget.content.resource_collected or 0
		local faction_settings = Settings.faction_settings and Settings.faction_settings[event_id]
		local left_side_choice_widget_def = _create_side_choice_widget(event_id, faction_settings.pure.id)
		local right_side_choice_widget_def = _create_side_choice_widget(event_id, faction_settings.impure.id)
		local left_side_choice_widget = UIWidget.init("left_side_choice_widget", left_side_choice_widget_def)
		local right_side_choice_widget = UIWidget.init("right_side_choice_widget", right_side_choice_widget_def)
		local left_side_choice_content = left_side_choice_widget.content

		left_side_choice_content.resource_button_text_key = "loc_give_resource_to_faction_a"
		left_side_choice_content.resource_button_hotspot.pressed_callback = callback(_callback_leftover_make_choice, parent, event, "pure", left_side_choice_content, entry_widgets)
		left_side_choice_widget.style.resource_button_hotspot.on_pressed_sound = UISoundEvents.play_ui_live_event_resource_pledged_01
		left_side_choice_content.resource_button_hotspot.disabled = player_resources <= 0
		left_side_choice_content.resource_button_hotspot.gamepad_input = "group_finder_group_clear_tags"

		local faction_a_settings = faction_settings and faction_settings.pure
		local faction_a_buff = faction_a_settings and faction_a_settings.buff

		if faction_a_buff then
			local faction_a_buff_data = BuffTemplates[faction_a_buff]

			if faction_a_buff_data and faction_a_buff_data.display_description then
				left_side_choice_content.boons_description = Localize(faction_a_buff_data.display_description)
			end
		end

		local right_side_choice_content = right_side_choice_widget.content

		right_side_choice_content.resource_button_text_key = "loc_give_resource_to_faction_b"
		right_side_choice_content.resource_button_hotspot.pressed_callback = callback(_callback_leftover_make_choice, parent, event, "impure", right_side_choice_content, entry_widgets)
		right_side_choice_widget.style.resource_button_hotspot.on_pressed_sound = UISoundEvents.play_ui_live_event_resource_pledged_02
		right_side_choice_content.resource_button_hotspot.disabled = player_resources <= 0
		right_side_choice_content.resource_button_hotspot.gamepad_input = "group_finder_start_group"

		local faction_b_settings = faction_settings and faction_settings.impure
		local faction_b_buff = faction_b_settings and faction_b_settings.buff

		if faction_b_buff then
			local faction_b_buff_data = BuffTemplates[faction_b_buff]

			if faction_b_buff_data and faction_b_buff_data.display_description then
				right_side_choice_content.boons_description = Localize(faction_b_buff_data.display_description)
			end
		end

		left_side_choice_widget.offset[1] = Settings.default_entry_width * (page_index - 1)
		right_side_choice_widget.offset[1] = Settings.default_entry_width * (page_index - 1) + Settings.default_entry_width * 0.5
		entry_widgets.left_side_choice_widget = left_side_choice_widget
		entry_widgets.right_side_choice_widget = right_side_choice_widget

		return entry_widgets, total_height
	end,
	draw = function (parent, dt, t, ui_renderer, render_settings, input_service, entry_widgets)
		_default_draw_function(parent, dt, t, ui_renderer, render_settings, input_service, entry_widgets)

		if entry_widgets.left_side_choice_widget then
			UIWidget.draw(entry_widgets.left_side_choice_widget, ui_renderer)
		end

		if entry_widgets.right_side_choice_widget then
			UIWidget.draw(entry_widgets.right_side_choice_widget, ui_renderer)
		end
	end,
	update = function (parent, dt, t, input_service, entry_widgets)
		local entry_body = entry_widgets.entry_body

		if entry_body then
			local content = entry_body.content
			local style = entry_body.style
			local global_stat_settings = Settings.global_stats_settings and Settings.global_stats_settings.leftover
			local faction_settings = Settings.faction_settings and Settings.faction_settings.leftover

			if global_stat_settings and faction_settings then
				local faction_a_id = faction_settings.pure.id
				local faction_b_id = faction_settings.impure.id
				local global_stats = global_stat_settings.stats
				local temp_data = parent:get_temp_progression_data()
				local event_temp_data = temp_data.leftover or {}
				local temp_stat_a = event_temp_data[global_stats[faction_a_id]]
				local temp_stat_b = event_temp_data[global_stats[faction_b_id]]
				local target_stat_a = temp_stat_a or content["target_" .. global_stats[faction_a_id]]
				local target_stat_b = temp_stat_b or content["target_" .. global_stats[faction_b_id]]
				local display_stat_a = content.display_stat_a or 0
				local display_stat_b = content.display_stat_b or 0

				if (target_stat_a or target_stat_b) and (target_stat_a ~= display_stat_a or target_stat_b ~= display_stat_b) then
					local bar_style_a = style.tug_of_war_bar_fill_a
					local bar_style_b = style.tug_of_war_bar_fill_b
					local lerped_a = target_stat_a and math.lerp(display_stat_a, target_stat_a, dt * 5) or display_stat_a
					local lerped_b = target_stat_b and math.lerp(display_stat_b, target_stat_b, dt * 5) or display_stat_b
					local lerped_tot = lerped_a + lerped_b
					local pct_a = lerped_tot > 0 and lerped_a / lerped_tot or 0.5
					local pct_b = lerped_tot > 0 and lerped_b / lerped_tot or 0.5

					bar_style_a.size[1] = bar_style_a.default_size[1] * pct_a
					bar_style_a.uvs[2][1] = pct_a
					bar_style_b.size[1] = bar_style_b.default_size[1] * pct_b
					bar_style_b.uvs[1][1] = pct_a
					bar_style_a.offset[1] = (Styles.sizes.entry_width - Styles.sizes.tug_o_war_bar_fill_size[1]) * 0.5 + 2
					bar_style_b.offset[1] = bar_style_a.offset[1] + bar_style_a.size[1] - 2
					style.tug_of_war_bar_divider.offset[1] = bar_style_a.offset[1] + bar_style_a.size[1] - 19.2
					content.display_stat_a = lerped_a
					content.display_stat_b = lerped_b
					content.tug_of_war_bar_text_left = TextUtilities.format_currency(math.round(lerped_a))
					content.tug_of_war_bar_text_right = TextUtilities.format_currency(math.round(lerped_b))
				end
			end

			local player_resources = content.resource_collected or 0
			local tug_o_war_ready = content.tug_o_war_ready == true
			local left_side_choice_button = entry_widgets.left_side_choice_widget

			if left_side_choice_button then
				local button_content = left_side_choice_button.content

				button_content.resource_button_hotspot.disabled = player_resources <= 0 or not tug_o_war_ready
			end

			local right_side_choice_button = entry_widgets.right_side_choice_widget

			if right_side_choice_button then
				local button_content = right_side_choice_button.content

				button_content.resource_button_hotspot.disabled = player_resources <= 0 or not tug_o_war_ready
			end
		end
	end,
	destroy = function (parent, entry_widgets, ui_renderer)
		if entry_widgets.left_side_choice_widget then
			UIWidget.destroy(ui_renderer, entry_widgets.left_side_choice_widget)
		end

		if entry_widgets.right_side_choice_widget then
			UIWidget.destroy(ui_renderer, entry_widgets.right_side_choice_widget)
		end

		_default_destroy_function(parent, entry_widgets, ui_renderer)

		local global_stats_settings = Settings.global_stats_settings and Settings.global_stats_settings.leftover
		local faction_settings = Settings.faction_settings and Settings.faction_settings.leftover

		if global_stats_settings and faction_settings then
			local global_stats = global_stats_settings.stats
			local faction_a_id = faction_settings.pure.id
			local faction_b_id = faction_settings.impure.id

			Managers.data_service.global_stats:unsubscribe(parent, global_stats_settings.category, global_stats[faction_a_id])
			Managers.data_service.global_stats:unsubscribe(parent, global_stats_settings.category, global_stats[faction_b_id])
		end
	end,
}

Templates.leftover = table.clone_instance(Templates.default)

table.insert(Templates.leftover.pages, 1, leftover_choice_page)

return Templates
