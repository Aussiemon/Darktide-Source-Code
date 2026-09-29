-- chunkname: @scripts/ui/views/live_events_view/live_event_track_progress_view/live_event_track_progress_view.lua

require("scripts/ui/views/base_view")

local ItemUtils = require("scripts/utilities/items")
local LoadingStateData = require("scripts/ui/loading_state_data")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementLoadingOverlay = require("scripts/ui/view_elements/view_element_loading_overlay/view_element_loading_overlay")
local ENTRY_TEXT_SCROLL_PADDING = 10
local ENTRY_TEXT_SPACING = 10
local LiveEventTrackProgressView = class("LiveEventTrackProgressView", "BaseView")

LiveEventTrackProgressView.init = function (self, config, settings, context)
	self._config = config
	self._content_blueprints = config.content_blueprints
	self._dynamic_elements = {}
	self._context = context
	self._promise_container = PromiseContainer:new()
	self._url_textures = {}
	self._interpolation_time = 0
	self._previous_stat_value = 0
	self._stat_value = 0

	LiveEventTrackProgressView.super.init(self, config.definitions, settings, context)
end

LiveEventTrackProgressView._log_category = function (self)
	return self._config.log_category or self.__class_name
end

LiveEventTrackProgressView._url_loader_group = function (self)
	return self._config.url_loader_group or self.view_name
end

LiveEventTrackProgressView.on_enter = function (self)
	LiveEventTrackProgressView.super.on_enter(self)

	self._refetch_count = 0

	self:_add_element(ViewElementLoadingOverlay, "loading_overlay", 500, {
		fade_in_time = 0.01,
		fade_out_time = 0.01,
		use_parent_renderer = true,
	})

	self._content_container_size = table.clone(self._ui_scenegraph.content_pivot.size)

	self:_setup_input_legend()
	self:_create_offscreen_renderer()

	self._selected_idx = 1
	self._interpolation_start_time = Managers.time:time("main")
	self._backend_track = self:_fetch_backend_track()

	local config = self._config

	Managers.data_service.global_stats:subscribe(self, "_cb_on_stat_update", config.global_stat_category, config.global_stat, 0)

	local promise = self._promise_container:cancel_on_destroy(Managers.data_service.global_stats:get(config.global_stat_category))

	Managers.event:trigger("event_start_waiting", promise, LoadingStateData.WAIT_REASON.backend)
	promise:next(callback(self, "_cb_on_get_stats"), callback(self, "_cb_on_error", "get_stats", false))

	self._entry_widgets = {
		title_text = self._widgets_by_name.entry_title_text,
		subtitle_text = self._widgets_by_name.entry_subtitle_text,
		image = self._widgets_by_name.entry_image,
		body_text = self._widgets_by_name.entry_body_text,
	}
end

LiveEventTrackProgressView._fetch_backend_track = function (self)
	local backend_events = Managers.live_event:get_raw_backend_events()

	for i = 1, #backend_events do
		local event = backend_events[i]

		if event.name == self._config.global_track then
			return event
		end
	end

	return nil
end

LiveEventTrackProgressView.on_exit = function (self)
	self:_destroy_offscreen_renderer()
	LiveEventTrackProgressView.super.on_exit(self)
end

LiveEventTrackProgressView._create_offscreen_renderer = function (self)
	local world_layer = 103
	local world_name = self.__class_name .. "_ui_entry_text_offscreen_world"
	local world = Managers.ui:create_world(world_name, world_layer, "ui", self.view_name)
	local viewport_name = world_name .. "_viewport"
	local viewport_type = "overlay_offscreen_2"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "_entry_text_offscreen_renderer"

	self._entry_text_offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._entry_text_offscreen_world = {
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name,
	}
end

LiveEventTrackProgressView._destroy_offscreen_renderer = function (self)
	local world_data = self._entry_text_offscreen_world

	if not world_data then
		return
	end

	self._entry_text_offscreen_renderer = nil
	self._entry_text_offscreen_world = nil

	Managers.ui:destroy_renderer(world_data.renderer_name)
	ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
	Managers.ui:destroy_world(world_data.world)
end

LiveEventTrackProgressView.destroy = function (self)
	self:_destroy_offscreen_renderer()
	self._promise_container:delete()
	Managers.data_service.global_stats:unsubscribe(self, self._config.global_stat_category, self._config.global_stat)
	self:_unload_url_textures()
	LiveEventTrackProgressView.super.destroy(self)
end

LiveEventTrackProgressView._unload_url_textures = function (self)
	local url_textures = self._url_textures

	for url, _ in pairs(url_textures) do
		Managers.url_loader:unload_texture(url)
	end

	self._url_textures = {}
end

LiveEventTrackProgressView._cb_on_get_stats = function (self, stats)
	local current_stat_value = stats[self._config.global_stat] or 0

	self._stat_value = current_stat_value

	self:_cb_on_stat_update(self._config.global_stat, current_stat_value)
	self:_fetch_track_state()
end

LiveEventTrackProgressView._fetch_track_state = function (self)
	if self._is_fetching_track_state then
		return
	end

	if not self._backend_track then
		self._backend_track_state = {}

		self:_fetch_mail_items()

		return
	end

	self._is_fetching_track_state = true

	local promise = self._promise_container:cancel_on_destroy(Managers.backend.interfaces.tracks:get_track_state(self._backend_track.id))

	promise:next(function (track_state)
		self._is_fetching_track_state = nil
		self._backend_track_state = track_state or {}

		self:_fetch_mail_items()
	end, function (error)
		self._is_fetching_track_state = nil

		self:_cb_on_error("fetch_track_state", false, error)
	end)
end

LiveEventTrackProgressView._fetch_mail_items = function (self)
	if self._is_fetching_mail then
		return
	end

	local t = Managers.time:time("main")

	if self._mail_fetch_time and t - self._mail_fetch_time < 5 then
		return
	end

	self._refetch_count = self._refetch_count + 1

	if self._refetch_count > 5 then
		return
	end

	self._mail_fetch_time = t
	self._is_fetching_mail = true

	local promise = self._promise_container:cancel_on_destroy(Managers.data_service.news:get_category(self._config.mail_category, false))

	Managers.event:trigger("event_start_waiting", promise, LoadingStateData.WAIT_REASON.backend)
	promise:next(function (mail_items)
		if mail_items and #mail_items ~= 0 then
			self._refetch_count = 0
		end

		self._is_fetching_mail = nil

		self:_cb_on_fetch_mail_items(mail_items)
	end, function (error)
		self._refetch_count = 0
		self._is_fetching_mail = nil

		self:_cb_on_error("fetch_mail_items", false, error)
	end)

	return promise
end

LiveEventTrackProgressView._on_navigation_input_changed = function (self)
	LiveEventTrackProgressView.super._on_navigation_input_changed(self)

	if self._grid == nil then
		return
	end

	if self._using_cursor_navigation then
		self._grid:select_grid_index(nil)
	else
		self._grid:select_first_index()
	end
end

LiveEventTrackProgressView._handle_input = function (self, input_service, dt, t)
	if self._grid == nil then
		input_service = input_service:null_service()
	end

	LiveEventTrackProgressView.super._handle_input(self, input_service, dt, t)
end

LiveEventTrackProgressView._cb_on_back_pressed = function (self)
	self:_close()
end

LiveEventTrackProgressView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

LiveEventTrackProgressView._close = function (self)
	local view_name = self.view_name

	Managers.ui:close_view(view_name)
	self:_play_sound(UISoundEvents.default_menu_exit)
end

LiveEventTrackProgressView.ui_renderer = function (self)
	return self._ui_renderer
end

LiveEventTrackProgressView._present_data = function (self, data)
	local grid = self:_create_grid(data)

	grid.data = data

	local grid_settings = grid:menu_settings()
	local grid_size = table.clone(grid_settings.grid_size)

	grid_size[1] = grid_size[1] - grid_settings.grid_spacing[1]

	local layout = {}

	for i, v in ipairs(data) do
		layout[i] = {
			widget_type = "button",
			data_entry = v,
			column_count = grid_settings.column_count,
			grid_spacing = grid_settings.grid_spacing,
			grid_size = grid_size,
			callback = callback(self, "_cb_on_data_entry_pressed"),
			parent_view = self,
		}
	end

	grid:present_grid_layout(layout, self._content_blueprints)

	self._grid = grid

	if not self:using_cursor_navigation() then
		grid:select_first_index()
	end

	grid:set_visibility(false)
	Promise.delay(0):next(function ()
		grid:set_visibility(true)
		self:_set_scenegraph_size("content_pivot", grid_size[1], grid_size[2])
	end)
end

LiveEventTrackProgressView._create_grid = function (self, data)
	local grid_config = self._config.grid or {}
	local column_count = grid_config.column_count or 4
	local row_count = grid_config.row_count or 2
	local grid_height = row_count * self._content_blueprints.button.size[2]
	local scenegraph_ref = self._ui_scenegraph.content_pivot
	local grid_settings = {
		bottom_chin = 0,
		edge_padding = -10,
		enable_gamepad_scrolling = false,
		hide_background = true,
		hide_dividers = true,
		horizontal_alignment = "center",
		no_resource_rendering = true,
		reset_selection_on_navigation_change = false,
		title_height = 0,
		top_padding = 0,
		use_parent_ui_renderer = true,
		column_count = column_count,
		grid_spacing = {
			20,
			0,
		},
	}
	local original_size = self._content_container_size
	local grid_size = {
		original_size[1] - grid_settings.edge_padding + 25 * (1 + 1 / column_count),
		grid_settings.top_padding + grid_settings.bottom_chin + grid_height + grid_settings.grid_spacing[2] * row_count + 10,
	}

	grid_settings.grid_size = grid_size
	grid_settings.mask_size = grid_size

	local grid_layer = scenegraph_ref.world_position[3] or 1
	local ref_name = string.format("%s_element_%s", scenegraph_ref.name, "buttons")
	local option_grid = self:_add_element(ViewElementGrid, ref_name, grid_layer, grid_settings, scenegraph_ref.name)

	option_grid.visible = false

	option_grid:set_pivot_offset(scenegraph_ref.world_position[1], scenegraph_ref.world_position[2])
	option_grid:set_empty_message(Localize(self._config.locked_entry_loc_key))

	self._dynamic_elements[ref_name] = option_grid

	return option_grid
end

LiveEventTrackProgressView._clean_ui = function (self)
	for ref_name, element in pairs(self._dynamic_elements) do
		self:_remove_element(ref_name)
	end

	self._grid = nil
end

LiveEventTrackProgressView._cb_on_data_entry_pressed = function (self, widget, is_preselected)
	local element = widget.content.element
	local data_entry = element.data_entry

	self._selected_idx = element.data_entry.idx

	self:_show_data_entry(data_entry)

	if is_preselected then
		return
	end

	if data_entry.locked then
		return
	end

	local promise = self._promise_container:cancel_on_destroy(self:_claim_tiers_to(data_entry))

	Managers.event:trigger("event_start_waiting", promise, LoadingStateData.WAIT_REASON.backend)
	promise:next(nil, callback(self, "_cb_on_error", "claim_track_tier", true))
end

LiveEventTrackProgressView._claim_tiers_to = function (self, target_entry)
	local entries_to_claim = {}

	for i = 1, #self._lore_entries do
		local entry = self._lore_entries[i]

		if entry.event_id and entry.event_id == target_entry.event_id and not entry.reward_claimed and not entry.locked and entry.tier_idx <= target_entry.tier_idx then
			entries_to_claim[#entries_to_claim + 1] = entry
		end
	end

	table.sort(entries_to_claim, function (a, b)
		return a.tier_idx < b.tier_idx
	end)

	local function mark_mail_read(entry)
		if entry.mail_id and not entry.mail_read and entry.mark_read then
			local mail_promise = self._promise_container:cancel_on_destroy(entry.mark_read())

			mail_promise:next(function (_)
				entry.mail_read = true
			end, callback(self, "_cb_on_error", "mark_mail_read", true))
		end
	end

	mark_mail_read(target_entry)

	if #entries_to_claim == 0 then
		return Promise.resolved(nil)
	end

	local function claim_next(idx)
		if idx > #entries_to_claim then
			return Promise.resolved(nil)
		end

		local entry = entries_to_claim[idx]

		return Managers.backend.interfaces.tracks:claim_track_tier(entry.event_id, entry.tier_idx - 1):next(function (result)
			entry.reward_claimed = true

			if result and result.body and result.body.rewards then
				self:_show_result_notification(result.body.rewards)
			end

			Managers.event:trigger("event_live_event_track_tier_claimed", entry.event_id, entry.tier_idx)
			mark_mail_read(entry)

			return claim_next(idx + 1)
		end)
	end

	return claim_next(1)
end

LiveEventTrackProgressView._show_result_notification = function (self, rewards)
	local currency_rewarded = false
	local item_rewards = {}

	for _, reward in pairs(rewards) do
		if reward.type == "currency" then
			Managers.event:trigger("event_add_notification_message", "currency", {
				currency = reward.currency,
				amount = reward.amount,
			})

			currency_rewarded = true
		elseif reward.type == "item" then
			local gear_id = reward.gearId
			local master_id = reward.id

			if gear_id and master_id then
				local item = MasterItems.get_item(master_id)

				if item then
					local item_type = item.item_type

					item_rewards[#item_rewards + 1] = {
						gear_id = gear_id,
						item_type = item_type,
					}
				end
			end
		end
	end

	if #item_rewards > 0 then
		Managers.data_service.gear:invalidate_gear_cache()

		for i = 1, #item_rewards do
			local reward = item_rewards[i]

			ItemUtils.mark_item_id_as_new(reward, table.array_contains(Managers.dlc.ITEM_TYPE_NOTIFICATION_BLACKLIST, reward.item_type))
		end
	end

	if currency_rewarded then
		Managers.data_service.store:invalidate_wallets_cache()
	end
end

LiveEventTrackProgressView._show_data_entry = function (self, data_entry)
	self._entry_widgets.title_text.content.text = data_entry.title
	self._entry_widgets.subtitle_text.content.text = data_entry.subtitle
	self._entry_widgets.body_text.content.text = data_entry.body

	local image_widget = self._entry_widgets.image

	if data_entry.body_image then
		image_widget.content.has_image = true

		self:_fetch_image_data_async(data_entry.body_image):next(function (texture_data)
			image_widget.style.image.material_values.texture_map = texture_data.texture
		end)
	else
		image_widget.content.has_image = false
		image_widget.style.image.material_values.texture_map = nil
	end

	self:_refresh_entry_text_layout()
end

LiveEventTrackProgressView._refresh_entry_text_layout = function (self)
	local entry_widgets = self._entry_widgets
	local subtitle_widget = entry_widgets.subtitle_text
	local body_widget = entry_widgets.body_text
	local scrollbar_widget = self._widgets_by_name.entry_text_scrollbar

	if not scrollbar_widget then
		return
	end

	local _, subtitle_height = self:_text_size(subtitle_widget.content.text or "", subtitle_widget.style.text)
	local _, body_height = self:_text_size(body_widget.content.text or "", body_widget.style.text)
	local _, region_height = self:_scenegraph_size("entry_text_area")

	self._entry_subtitle_height = subtitle_height

	local content_height = ENTRY_TEXT_SCROLL_PADDING + subtitle_height + ENTRY_TEXT_SPACING + body_height + ENTRY_TEXT_SCROLL_PADDING
	local scroll_length = math.max(content_height - region_height, 0)

	self._entry_text_scroll_length = scroll_length

	local scrollbar_content = scrollbar_widget.content

	scrollbar_content.scroll_length = scroll_length
	scrollbar_content.area_length = region_height
	scrollbar_content.value = 0
	scrollbar_content.scroll_value = nil
	scrollbar_content.scroll_add = nil
	scrollbar_content.current_scroll_direction = nil
end

LiveEventTrackProgressView._apply_entry_text_scroll = function (self)
	local scrollbar_widget = self._widgets_by_name.entry_text_scrollbar

	if not scrollbar_widget then
		return
	end

	local scroll_length = self._entry_text_scroll_length or 0
	local scroll_offset = scroll_length > 0 and scroll_length * (scrollbar_widget.content.value or 0) or 0
	local top_padding = ENTRY_TEXT_SCROLL_PADDING - scroll_offset
	local entry_widgets = self._entry_widgets

	entry_widgets.subtitle_text.style.text.offset[2] = top_padding
	entry_widgets.body_text.style.text.offset[2] = top_padding + (self._entry_subtitle_height or 0) + ENTRY_TEXT_SPACING
end

LiveEventTrackProgressView._track_tier_to_data_entry = function (self, track, track_state, tier_idx, tier)
	if not tier.guards or not tier.guards.global then
		return nil, nil
	end

	local config = self._config
	local tier_name = tier.name
	local stat_required_amount = 0

	for i = 1, #tier.guards.global do
		local guard = tier.guards.global[i]

		if guard.type == "stat" and guard.category == config.global_stat_category and guard.name == config.global_stat then
			stat_required_amount = guard.limit
		end
	end

	local locked_text = Localize(config.locked_entry_loc_key)
	local data_entry = {
		body = "",
		locked = true,
		reward_claimed = false,
		event_id = track.id,
		tier_idx = tier_idx,
		tier_name = tier_name,
		stat_required = stat_required_amount,
		title = locked_text,
		subtitle = locked_text,
		rewards = {},
	}

	for k, v in pairs(tier.rewards) do
		table.insert(data_entry.rewards, v)
	end

	if track_state and track_state.state then
		data_entry.reward_claimed = track_state.state.rewarded + 1 >= data_entry.tier_idx
	end

	return tier_name, data_entry
end

LiveEventTrackProgressView._mail_to_data_entry = function (self, track, mail)
	if mail.eventName ~= self._config.event_name then
		return nil, nil
	end

	local contents = mail.contents
	local lore_entry = {
		locked = false,
		mail_id = mail.id,
		tier_name = mail.tierName,
		event_name = mail.eventName,
		mail_read = mail.is_read() or false,
		claimed = mail.is_read() or false,
		mark_claimed = mail.mark_claimed,
		mark_read = mail.mark_read,
	}

	for i = 1, #contents do
		local content = contents[i]
		local content_type = content.type
		local presentation = content.presentation
		local is_preview = presentation and table.array_contains(presentation, "preview")

		if content_type == "title" then
			lore_entry.title = content.data
		elseif content_type == "subtitle" then
			lore_entry.subtitle = content.data
		elseif content_type == "image" then
			if is_preview then
				lore_entry.preview_image = content.data
			else
				lore_entry.body_image = content.data
			end
		elseif content_type == "body" then
			lore_entry.body = content.data
		end
	end

	return lore_entry.tier_name, lore_entry
end

LiveEventTrackProgressView._merge_tier_and_mail = function (tier_data, mail_data)
	mail_data.rewards = tier_data.rewards
	mail_data.event_id = tier_data.event_id
	mail_data.reward_claimed = tier_data.reward_claimed
	mail_data.tier_idx = tier_data.tier_idx

	return mail_data
end

LiveEventTrackProgressView._cb_on_fetch_mail_items = function (self, mail_items)
	self._mail_items = mail_items

	local data_entries_dict = {}
	local backend_track = self._backend_track or {}
	local backend_tiers = backend_track.tiers or {}

	for i = 1, #backend_tiers do
		local tier_name, entry = self:_track_tier_to_data_entry(backend_track, self._backend_track_state, i, backend_tiers[i])

		if tier_name and entry then
			data_entries_dict[tier_name] = entry
		end
	end

	for i = 1, #mail_items do
		local tier_name, entry = self:_mail_to_data_entry(backend_track, mail_items[i])

		if tier_name and entry then
			local existing_entry = data_entries_dict[tier_name]

			if existing_entry then
				data_entries_dict[tier_name] = self._merge_tier_and_mail(existing_entry, entry)
			else
				data_entries_dict[tier_name] = entry
			end
		end
	end

	local data_entries = {}
	local first_locked_idx

	for k, v in table.sorted(data_entries_dict, {}) do
		data_entries[#data_entries + 1] = v
		v.idx = #data_entries

		if not first_locked_idx and v.locked then
			first_locked_idx = v.idx
		end

		v.first_locked_idx = first_locked_idx
	end

	self._lore_entries = data_entries

	self:_clean_ui()
	self:_present_data(data_entries)

	if not self._using_cursor_navigation then
		self._grid:select_grid_index(self._selected_idx)
	end

	local preselected_widget = self._grid:widget_by_index(self._selected_idx)

	if preselected_widget then
		self:_cb_on_data_entry_pressed(preselected_widget, true)
	end
end

LiveEventTrackProgressView._cb_on_stat_update = function (self, stat_name, stat_value)
	self._previous_stat_value = self._stat_value
	self._stat_value = stat_value
	self._interpolation_start_time = Managers.time:time("main")
end

LiveEventTrackProgressView._cb_on_error = function (self, request_id, keep_open, error)
	Log.error(self:_log_category(), "request failed for '%s' with error '%s'", request_id, error)

	if not keep_open then
		self:_close()
	end
end

LiveEventTrackProgressView.get_interpolated_stat = function (self, t)
	local interpolation_time = t - self._interpolation_start_time
	local p = math.clamp01(interpolation_time / self._config.max_interpolation_time)

	if self._previous_stat_value == self._stat_value then
		return self._stat_value
	end

	local _interpolated_stat = math.ceil(math.lerp(self._previous_stat_value, self._stat_value, p))

	return _interpolated_stat
end

LiveEventTrackProgressView.update = function (self, dt, t, input_service)
	LiveEventTrackProgressView.super.update(self, dt, t, input_service)

	if not self._lore_entries then
		return
	end

	self:_check_for_stat_updates(self:get_interpolated_stat(t))
end

LiveEventTrackProgressView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local entry_widgets = self._entry_widgets
	local subtitle_widget = entry_widgets and entry_widgets.subtitle_text
	local body_widget = entry_widgets and entry_widgets.body_text
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]

		if widget ~= subtitle_widget and widget ~= body_widget then
			UIWidget.draw(widget, ui_renderer)
		end
	end
end

LiveEventTrackProgressView.draw = function (self, dt, t, input_service, layer)
	LiveEventTrackProgressView.super.draw(self, dt, t, input_service, layer)

	local offscreen_renderer = self._entry_text_offscreen_renderer
	local entry_widgets = self._entry_widgets

	if not offscreen_renderer or not entry_widgets then
		return
	end

	self:_apply_entry_text_scroll()

	local render_settings = self._render_settings
	local previous_start_layer = render_settings.start_layer

	render_settings.start_layer = (layer or 1) + 1

	UIRenderer.begin_pass(offscreen_renderer, self._ui_scenegraph, input_service, dt, render_settings)
	UIWidget.draw(entry_widgets.subtitle_text, offscreen_renderer)
	UIWidget.draw(entry_widgets.body_text, offscreen_renderer)
	UIRenderer.end_pass(offscreen_renderer)

	render_settings.start_layer = previous_start_layer
end

LiveEventTrackProgressView._check_for_stat_updates = function (self, stat_value)
	local do_refetch = false

	for i = 1, #self._lore_entries do
		local entry = self._lore_entries[i]

		if entry.stat_required and stat_value >= entry.stat_required then
			do_refetch = true

			break
		end
	end

	if not do_refetch then
		return
	end

	self:_fetch_track_state()
end

LiveEventTrackProgressView._fetch_image_data_async = function (self, url)
	if url == nil then
		return Promise.rejected()
	end

	local url_textures = self._url_textures

	if not url_textures[url] then
		local promise = self._promise_container:cancel_on_destroy(Managers.url_loader:load_texture(url, nil, self:_url_loader_group()))

		Managers.event:trigger("event_start_waiting", promise, LoadingStateData.WAIT_REASON.backend)
		promise:next(function (texture_data)
			url_textures[url].data = texture_data

			return texture_data
		end)

		url_textures[url] = {
			promise = promise,
		}
	end

	return url_textures[url].promise
end

return LiveEventTrackProgressView
