local Definitions = require("scripts/ui/views/inbox_view/inbox_view_definitions")
local InboxViewSettings = require("scripts/ui/views/inbox_view/inbox_view_settings")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ProfileUtils = require("scripts/utilities/profile_utils")
local Promise = require("scripts/foundation/utilities/promise")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local InventoryBlueprints = require("scripts/ui/views/inventory_view/inventory_view_content_blueprints")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local InboxView = class("InboxView", "BaseView")

InboxView.init = function (self, settings)
	InboxView.super.init(self, Definitions, settings)

	self._stats_animation_progress = {}
end

InboxView.on_enter = function (self)
	InboxView.super.on_enter(self)
	self:_setup_input_legend()
	self:_create_offscreen_renderer()
	self:_setup_stats_preview_widgets()
	self:_set_preview_widgets_visibility(false)
	self:_fetch_store_items()

	local context = self._context
	local player = context and context.player or self:_player()
	local profile = player:profile()
	self._presentation_profile = table.clone_instance(profile)

	self:_set_player_profile_information(player)
end

InboxView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InboxView._set_player_profile_information = function (self, player)
	local profile = player:profile()
	local character_name = ProfileUtils.character_name(profile)
	local current_level = profile.current_level
	local character_title = ProfileUtils.character_title(profile)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.character_name.content.text = character_name
	widgets_by_name.character_title.content.text = character_title
	widgets_by_name.character_level.content.text = tostring(current_level) .. " "

	self:_set_experience_bar(0, 0)
	self:_fetch_character_progression(player)
	self:_request_player_icon()
end

InboxView._request_player_icon = function (self)
	local material_values = self._widgets_by_name.character_portrait.style.texture.material_values
	material_values.use_placeholder_texture = 1

	self:_load_portrait_icon()
end

InboxView._load_portrait_icon = function (self)
	local profile = self._presentation_profile
	local cb = callback(self, "_cb_set_player_icon")
	local icon_load_id = Managers.ui:load_profile_portrait(profile, cb)
	self._portrait_loaded_info = {
		icon_load_id = icon_load_id
	}
end

InboxView._cb_set_player_icon = function (self, grid_index, rows, columns)
	local material_values = self._widgets_by_name.character_portrait.style.texture.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
end

InboxView._set_experience_bar = function (self, experience_fraction, duration)
	if duration then
		self._experience_fraction_duration_time = 0
		self._experience_fraction_duration_delay = duration
		self._target_experience_fraction = experience_fraction
		experience_fraction = 0
	end

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.character_experience
	widget.content.progress = experience_fraction
	self._current_experience_fraction = experience_fraction
end

InboxView._fetch_character_progression = function (self, player)
	if self._character_progression_promise then
		return
	end

	self._fetching_character_progression = true
	local profiles_promise = nil
	local character_id = player:character_id()

	if Managers.backend:authenticated() then
		local backend_interface = Managers.backend.interfaces
		profiles_promise = backend_interface.progression:get_progression("character", character_id):next(function (results)
			local progression_data = results
			local current_level_experience = progression_data and progression_data.currentXpInLevel or 0
			local needed_level_experience = progression_data and progression_data.neededXpForNextLevel or 0
			local normalized_progress = needed_level_experience > 0 and current_level_experience / (current_level_experience + needed_level_experience) or 0

			return normalized_progress
		end):catch(function (error)
			Log.error("InboxView", "Error fetching character progression: %s", error)
		end)
	else
		profiles_promise = Promise.new()
		local level_experience_progress = 0

		profiles_promise:resolve(level_experience_progress)
	end

	profiles_promise:next(function (level_progress)
		level_progress = level_progress or 0

		self:_set_experience_bar(level_progress, 2)

		self._character_progression_promise = nil
		self._fetching_character_progression = false
		self._dirty_character_list = true
	end):catch(function (error)
		self._character_progression_promise = nil

		Log.error("InboxView", "Error fetching character progression: %s", error)

		self._fetching_character_progression = false
	end)

	self._character_progression_promise = profiles_promise
end

InboxView._create_offscreen_renderer = function (self)
	local view_name = self.view_name
	local world_layer = 10
	local world_name = self.__class_name .. "_ui_offscreen_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil, view_name)
	local viewport_name = "offscreen_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "offscreen_renderer"
	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name
	}
end

InboxView._create_grid = function (self, entries)
	self._current_scrollbar_progress = nil
	local widgets = {}
	local size = ItemPassTemplates.icon_size
	local pass_template = ItemPassTemplates.item
	local grid_spacing = {
		15,
		15
	}
	local scenegraph_width = size[1] * 4 + grid_spacing[1] * 3
	local scenegraph_height = nil

	self:_set_scenegraph_size("grid_background", scenegraph_width, scenegraph_height)
	self:_set_scenegraph_size("grid_mask", scenegraph_width + 20, scenegraph_height)
	self:_set_scenegraph_size("grid_interaction", scenegraph_width, scenegraph_height)

	local function unload_icon(parent, widget, element, ui_renderer)
		local content = widget.content

		if content.icon_load_id then
			local material_values = widget.style.icon.material_values
			material_values.use_placeholder_texture = 1

			Managers.ui:unload_item_icon(content.icon_load_id)

			content.icon_load_id = nil
		end
	end

	for i = 1, #entries do
		local entry = entries[i]
		local widget_definition = UIWidget.create_definition(pass_template, "grid_content_pivot", nil, size)
		local name = "widget_inventory_" .. i
		local widget = self:_create_widget(name, widget_definition)
		local content = widget.content
		content.hotspot.pressed_callback = callback(self, "cb_on_grid_entry_pressed", widget, entry)
		content.element = entry
		local slot = entry.slot

		if slot then
			local item = entry.item
			content.item = item

			if item then
				widget.unload_icon = unload_icon
			end
		end

		widgets[#widgets + 1] = widget
	end

	local grid = UIWidgetGrid:new(widgets, widgets, self._ui_scenegraph, "grid_background", "down", grid_spacing)
	local scrollbar_widget = self._widgets_by_name.grid_scrollbar

	grid:assign_scrollbar(scrollbar_widget, "grid_content_pivot", "grid_background")
	grid:set_scrollbar_progress(0)

	self._inbox_grid = {
		widgets = widgets,
		grid = grid
	}
end

InboxView._apply_item_icon_cb_func = function (self, widget, grid_index, rows, columns)
	local material_values = widget.style.icon.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
end

InboxView._remove_item_icon_cb_func = function (self, widget, ui_renderer)
	local material_values = widget.style.icon.material_values
	material_values.use_placeholder_texture = 1
end

InboxView._on_back_pressed = function (self)
	Managers.ui:close_view(self.view_name)
end

InboxView._destroy_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		world_data = nil
	end
end

InboxView.update = function (self, dt, t, input_service)
	if self._inbox_grid then
		self._inbox_grid.grid:update(dt, t)

		local current_scrollbar_progress = self._inbox_grid.grid:scrollbar_progress()

		if self._current_scrollbar_progress ~= current_scrollbar_progress then
			self._current_scrollbar_progress = current_scrollbar_progress

			self:_update_grid_widgets_visibility()
		end
	end

	self:_update_stat_bar_animations(dt)

	return InboxView.super.update(self, dt, t, input_service)
end

InboxView._update_grid_widgets_visibility = function (self)
	local widgets = self._inbox_grid.widgets

	if widgets then
		local num_widgets = #widgets
		local ui_renderer = self._ui_offscreen_renderer

		for i = 1, num_widgets do
			local widget = widgets[i]
			local content = widget.content
			local visible = self._inbox_grid.grid:is_widget_visible(widget)
			content.visible = visible
		end

		for i = 1, num_widgets do
			local widget = widgets[i]
			local content = widget.content
			local element = content.element
			local visible = content.visible

			if not visible and widget.unload_icon and content.icon_load_id then
				widget.unload_icon(self, widget, element, ui_renderer)
			end
		end

		for i = 1, num_widgets do
			local widget = widgets[i]
			local content = widget.content
			local visible = content.visible

			if visible then
				local content = widget.content
				local item = content.item

				if not content.icon_load_id then
					local cb = callback(self, "_apply_item_icon_cb_func", widget)
					content.icon_load_id = Managers.ui:load_item_icon(item, cb)
				end
			end
		end
	end
end

InboxView.draw = function (self, dt, t, input_service, layer)
	self:_draw_grid(dt, t, input_service)
	InboxView.super.draw(self, dt, t, input_service, layer)
end

InboxView._draw_grid = function (self, dt, t, input_service, layer)
	if self._inbox_grid then
		UIRenderer.begin_pass(self._offscreen_renderer, self._ui_scenegraph, input_service, dt, self._render_settings)

		for i = 1, #self._inbox_grid.widgets do
			local widget = self._inbox_grid.widgets[i]

			if self._inbox_grid.grid and self._inbox_grid.grid:is_widget_visible(widget) then
				UIWidget.draw(widget, self._offscreen_renderer)
			end
		end

		UIRenderer.end_pass(self._offscreen_renderer)
	end
end

InboxView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	InboxView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local stat_widgets = self._stat_widgets

	if stat_widgets then
		for i = 1, #stat_widgets do
			local widget = stat_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

InboxView._destroy_grid_widgets = function (self)
	local widgets = self._inbox_grid and self._inbox_grid.widgets

	if widgets then
		local num_widgets = #widgets
		local ui_renderer = self._ui_offscreen_renderer

		for i = 1, num_widgets do
			local widget = widgets[i]
			local element = widget.element
			local content = widget.content

			if content.icon_load_id then
				local material_values = widget.style.icon.material_values
				material_values.use_placeholder_texture = 1

				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end
	end
end

InboxView.on_exit = function (self)
	InboxView.super.on_exit(self)
	self:_destroy_grid_widgets()
	self:_destroy_renderer()
end

InboxView._fetch_store_items = function (self)
	local store_promise = nil

	self:_set_loading_visible(true)

	if not store_promise then
		self:_set_empty_list()

		return
	end

	store_promise:next(function (store_catalogue)
		if self._destroyed then
			return
		end

		local store_data = store_catalogue.data
		local public_filtered = store_data.public_filtered
		local layout = self:_create_grid_layout(public_filtered)

		if #layout == 0 then
			self:_set_empty_list()
		else
			self:_set_loading_visible(false)
			self:_create_grid(layout)
		end
	end)
end

InboxView._create_grid_layout = function (self, item_offers)
	local layout = {}

	for i = 1, #item_offers do
		local offer = item_offers[i]
		local offer_id = offer.offerId
		local sku = offer.sku
		local category = sku.category

		if category == "item_instance" then
			local item = MasterItems.get_store_item_instance(offer.description)

			if item then
				layout[#layout + 1] = {
					item = item,
					slot = ItemSlotSettings.slot_secondary
				}
			end
		end
	end

	return layout
end

InboxView.cb_on_grid_entry_pressed = function (self, widget, element)
	local item = element.item

	if item and item ~= self._previewed_item then
		self:_preview_element(element)
	end
end

InboxView._preview_element = function (self, element)
	local item = element.item
	self._previewed_item = item

	self:_setup_item_stats(item)

	local display_name = ItemUtils.display_name(item)
	local sub_display_name = ItemUtils.sub_display_name(item)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.item_detail.content.name = display_name
	widgets_by_name.item_detail.content.item_type = sub_display_name
	local item_widget = widgets_by_name.item_image
	local content = item_widget.content
	content.disabled = true

	if content.icon_load_id then
		local material_values = item_widget.style.icon.material_values
		material_values.use_placeholder_texture = 1

		Managers.ui:unload_item_icon(content.icon_load_id)

		content.icon_load_id = nil
	end

	local cb = callback(self, "_apply_item_icon_cb_func", item_widget)
	content.icon_load_id = Managers.ui:load_item_icon(item, cb)
	local visible = true

	self:_set_preview_widgets_visibility(visible)
end

InboxView._set_loading_visible = function (self, visible)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.loading.content.visible = visible
	widgets_by_name.inventory_grid.content.visible = not visible

	self:_set_preview_widgets_visibility(false)
end

InboxView._set_empty_list = function (self)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.loading.content.text = "No Items available"
end

InboxView._set_preview_widgets_visibility = function (self, visible)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.item_background.content.visible = visible
	widgets_by_name.item_detail_intro.content.visible = visible
	widgets_by_name.item_image.content.visible = visible
	widgets_by_name.item_detail.content.visible = visible
	widgets_by_name.claim_button.content.visible = visible
	widgets_by_name.stats_divider.content.visible = visible
	widgets_by_name.modifications_divider.content.visible = visible
	widgets_by_name.blessings_divider.content.visible = visible
	local stat_widgets = self._stat_widgets

	if stat_widgets then
		for i = 1, #stat_widgets do
			local widget = stat_widgets[i]
			widget.content.visible = visible
		end
	end
end

InboxView._setup_stats_preview_widgets = function (self)
	local num_stats = 6
	local max_rows = 2
	local stats_size = {
		216.66666666666666,
		40
	}
	local weapon_bar_text_style = table.clone(UIFontSettings.body_small)
	weapon_bar_text_style.text_horizontal_alignment = "left"
	weapon_bar_text_style.text_vertical_alignment = "center"
	weapon_bar_text_style.offset = {
		-4,
		0,
		0
	}
	local weapon_stats_bar_background_margin = 2
	local weapon_stat_bar = {
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = weapon_bar_text_style
		},
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				size = {
					nil,
					6
				},
				size_addition = {
					weapon_stats_bar_background_margin * 2,
					weapon_stats_bar_background_margin * 2
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					0,
					0,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "bar",
			value = "content/ui/materials/bars/simple/fill",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				size = {
					nil,
					6
				},
				offset = {
					-weapon_stats_bar_background_margin,
					0,
					1
				},
				color = Color.white(255, true)
			},
			change_function = function (content, style)
				local progress = content.progress or 0
				local new_bar_length = stats_size[1] * progress
				style.size[1] = new_bar_length
			end
		},
		{
			pass_type = "texture",
			style_id = "end",
			value = "content/ui/materials/bars/simple/end",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				size = {
					12,
					16
				},
				offset = {
					0,
					5,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			change_function = function (content, style)
				local progress = content.progress or 0
				style.offset[1] = stats_size[1] * progress - 8
				local alpha_multiplier = math.clamp(progress / 0.2, 0, 1)
				style.color[1] = 255 * alpha_multiplier
			end
		}
	}
	local widget_definition = UIWidget.create_definition(weapon_stat_bar, "stat_pivot", nil, stats_size)
	local widgets = {}
	local spacing = 30

	for i = 1, num_stats do
		local name = "stat_" .. i
		local widget = self:_create_widget(name, widget_definition)
		local column = (i - 1) % max_rows + 1
		local row = math.ceil(i / max_rows)
		local offset = widget.offset
		offset[2] = (column - 1) * stats_size[2] + (column - 1) * spacing
		offset[1] = (row - 1) * stats_size[1]
		widgets[#widgets + 1] = widget
	end

	self._stat_widgets = widgets
end

InboxView._setup_item_stats = function (self, item)
	table.clear(self._stats_animation_progress)

	local context = {
		{
			title = "loc_weapon_stats_title_damage",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_rate_of_fire",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_handling",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_range",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_reload_speed",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_area_damage",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_mobility",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_suppress",
			progress = math.random_range(0, 1)
		},
		{
			title = "loc_weapon_stats_title_ammo",
			progress = math.random_range(0, 1)
		}
	}
	local widgets_by_name = self._widgets_by_name
	local anim_duration = 1

	for i = 1, #context do
		local data = context[i]
		local name = "stat_" .. i
		local widget = widgets_by_name[name]

		if widget then
			widget.content.text = Localize(data.title)
			local value = data.progress

			self:_set_stat_bar_value(i, value, anim_duration)
		end
	end
end

InboxView._set_stat_bar_value = function (self, stat_index, value, duration, should_reset)
	local stats_animation_progress = self._stats_animation_progress
	local name = "stat_" .. stat_index
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name[name]
	local content = widget.content
	local current_progress = content.progress or 0
	local anim_data = {
		time = 0,
		start_value = should_reset and 0 or current_progress,
		end_value = value,
		duration = duration,
		widget = widget
	}
	stats_animation_progress[#stats_animation_progress + 1] = anim_data
end

InboxView._update_stat_bar_animations = function (self, dt)
	local stats_animation_progress = self._stats_animation_progress

	if not stats_animation_progress or #stats_animation_progress < 1 then
		return
	end

	for i = #stats_animation_progress, 1, -1 do
		local data = stats_animation_progress[i]
		local duration = data.duration
		local end_value = data.end_value
		local start_value = data.start_value
		local time = data.time
		local widget = data.widget
		time = time + dt
		local time_progress = math.clamp(time / duration, 0, 1)
		local anim_progress = math.ease_out_exp(time_progress)
		local target_value = end_value - start_value
		local anim_fraction = start_value + target_value * anim_progress
		widget.content.progress = anim_fraction

		if time_progress < 1 then
			data.time = time
		else
			stats_animation_progress[i] = nil
		end
	end
end

return InboxView
