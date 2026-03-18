-- chunkname: @scripts/ui/views/live_events_view/live_events_view_templates.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local TextUtilities = require("scripts/utilities/ui/text")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local MasterItems = require("scripts/backend/master_items")
local WalletSettings = require("scripts/settings/wallet_settings")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local LiveEvents = require("scripts/settings/live_event/live_events")
local InputDevice = require("scripts/managers/input/input_device")
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
				local reward_type = reward.type
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
				local item = MasterItems.get_item(reward.id)

				parent:_request_item_icon(widget, item, parent._ui_renderer)

				widget.content.item = item
				widget.content.reward = reward
				widget.content.tier_xp = tier.target
			end,
		},
	},
}
local EntryBodyTemplates = {
	default = {
		widget_template = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "top_detail",
				value = "content/ui/materials/dividers/horizontal_frame_big_upper",
				value_id = "top_detail",
				style = Styles.entry.top_detail,
			},
			{
				pass_type = "texture",
				style_id = "top_center_detail",
				value = "content/ui/materials/frames/end_of_round/reward_levelup_upper_skull_gray",
				value_id = "top_center_detail",
				style = Styles.entry.top_center_detail,
			},
			{
				pass_type = "texture",
				style_id = "bottom_detail",
				value = "content/ui/materials/dividers/horizontal_frame_big_lower",
				value_id = "bottom_detail",
				style = Styles.entry.bottom_detail,
			},
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
				pass_type = "rect",
				style_id = "background_rect",
				style = Styles.entry.background_rect,
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/terminal_basic",
				value_id = "background",
				style = Styles.entry.background,
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

			content.rewards_track_text = entry_data and Localize("loc_mission_voting_view_salary") .. ":" or ""
			style.rewards_track_text.visible = not not event
			style.rewards_track_text.offset[2] = height
			height = height + 20
			widget.visible = true

			return height
		end,
	},
}
local ProgressBarTemplates = {
	default = {
		widget_template = UIWidget.create_definition(BarPassTemplates.experience_bar, "event_progress_bar", event_progress_bar_content_override),
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
			event_progress_bar_style.bar.color = Color.golden_rod(255, true)

			parent:_set_current_event_progress(current_progress)
			parent:_set_current_event_progress_text(current_progress, max_progress)
		end,
	},
}
local Templates = {}

Templates.default = {
	composition = {
		entry_body = EntryBodyTemplates.default,
		rewards = RewardTemplates.default,
		progress_bar = ProgressBarTemplates.default,
	},
	initialize = function (parent, composition, event, event_data)
		if not composition or table.is_empty(composition) then
			return
		end

		local entry_widgets = {}
		local ui_renderer = parent._ui_renderer
		local total_height = 0
		local body_template = composition.entry_body

		if body_template then
			local widget_definition = body_template.widget_template
			local widget = UIWidget.init("entry_body", widget_definition)

			entry_widgets.entry_body = widget
			total_height = body_template.init(parent, widget, event, event_data, ui_renderer)
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
			local reward_start_x = -(#tiers * (Styles.sizes.reward_size[1] + 40)) / 2

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
						local widget_definition = reward_template[reward.type] and reward_template[reward.type].widget_template

						reward_widget = UIWidget.init("reward_" .. tier_index .. "_" .. reward_index, reward_template.widget_template)

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

						reward_widget.offset[1] = offset_x - Styles.sizes.reward_size[1] / 2
						line_widget.offset[1] = line_spacing - 2

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

			entry_reward_widgets.rewards = reward_widgets
			entry_reward_widgets.lines = line_widgets
			entry_widgets.rewards = entry_reward_widgets
		end

		if should_increase_size then
			total_height = total_height + Styles.sizes.reward_size[2] + 10
		end

		local progress_bar_template = composition.progress_bar

		if event and progress_bar_template then
			local widget_definition = progress_bar_template.widget_template
			local widget = UIWidget.init("progress_bar", widget_definition)

			entry_widgets.progress_bar = widget

			progress_bar_template.init(parent, widget, event, ui_renderer)

			total_height = total_height + 260
		else
			parent:_set_current_event_progress_text()
		end

		parent:_set_scenegraph_size("entries_anchor", nil, total_height)

		return entry_widgets
	end,
	draw = function (parent, dt, t, ui_renderer, render_settings, input_service, entry_widgets)
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
	end,
	destroy = function (parent, entry_widgets, ui_renderer)
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
	end,
}

return Templates
