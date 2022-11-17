local Definitions = require("scripts/ui/views/class_selection_view/class_selection_view_definitions")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ClassSelectionViewSettings = require("scripts/ui/views/class_selection_view/class_selection_view_settings")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local TextUtils = require("scripts/utilities/ui/text")
local MasterItems = require("scripts/backend/master_items")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local ContentBlueprints = require("scripts/ui/views/class_selection_view/class_selection_view_blueprints")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local InputUtils = require("scripts/managers/input/input_utils")
local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local UISettings = require("scripts/settings/ui/ui_settings")
local ClassSelectionViewTestify = GameParameters.testify and require("scripts/ui/views/class_selection_view/class_selection_view_testify")
local PACKAGE_BASE_PATH = "packages/ui/views/talents_view/"
local ClassSelectionView = class("ClassSelectionView", "BaseView")
local default_classes = {
	veteran = "veteran_2",
	psyker = "psyker_2",
	zealot = "zealot_2",
	ogryn = "ogryn_2"
}

ClassSelectionView.init = function (self, settings, context)
	ClassSelectionView.super.init(self, Definitions, settings)

	self._character_create = context.character_create
	self._pass_draw = false
	self._allow_close_hotkey = false
	self._force_character_creation = context.force_character_creation
end

ClassSelectionView.on_enter = function (self)
	ClassSelectionView.super.on_enter(self)

	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	self:_create_offscreen_renderer()
	self:_setup_input_legend()
	self:_register_button_callbacks()

	self._domain_options = self._character_create:archetype_options()
	local profile = self._character_create:profile()
	self._classes_visible = false

	self:_create_domain_option_widgets()
	self:_show_classes_widgets(false, profile.archetype)
	self:_handle_continue_button_text()
	self:_start_loading_talent_icons()

	self._setup_complete = true
end

ClassSelectionView._start_loading_talent_icons = function (self)
	local all_specializations = {}

	for i = 1, #self._domain_options do
		local domain = self._domain_options[i]

		for class_name, class_data in pairs(domain.specializations) do
			if class_data.title and not class_data.disabled then
				all_specializations[#all_specializations + 1] = class_data.name
			end
		end
	end

	self._talents_load_id = {}
	self._loaded_icons = {
		count = 0,
		all_loaded = false
	}

	for i = 1, #all_specializations do
		local specialization_name = all_specializations[i]
		local package_name = PACKAGE_BASE_PATH .. specialization_name
		self._talents_load_id[#self._talents_load_id + 1] = Managers.package:load(package_name, "ClassSelectionView", callback(self, "_should_load_icons"))
	end
end

ClassSelectionView._should_load_icons = function (self)
	self._loaded_icons.count = self._loaded_icons.count + 1
	self._loaded_icons.all_loaded = #self._talents_load_id == self._loaded_icons.count

	if self._loaded_icons.all_loaded then
		local class_abilities_info_widgets = self._class_abilities_info_widgets

		if self._class_abilities_info_widgets and class_abilities_info_widgets then
			for i = 1, #class_abilities_info_widgets do
				local widget = class_abilities_info_widgets[i]

				if widget.type == "ability" then
					local template = ContentBlueprints[widget.type]

					template.load_icon(widget, widget.element)
				end
			end
		end
	end
end

ClassSelectionView._create_offscreen_renderer = function (self)
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

ClassSelectionView._destroy_offscreen_renderer = function (self)
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

ClassSelectionView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

ClassSelectionView._register_button_callbacks = function (self)
	self._widgets_by_name.continue_button.content.hotspot.pressed_callback = function ()
		self:_on_continue_pressed()
	end

	self._widgets_by_name.details_button.content.hotspot.pressed_callback = function ()
		self:_on_details_pressed()
	end
end

ClassSelectionView._setup_background_world = function (self, level_name)
	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	self:_register_event("event_register_character_camera")
	self:_register_event("event_register_character_spawn_point")

	local world_name = ClassSelectionViewSettings.world_name
	local world_layer = ClassSelectionViewSettings.world_layer
	local world_timer_name = ClassSelectionViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	self._world_spawner:spawn_level(level_name)
end

ClassSelectionView.event_register_character_camera = function (self, camera_unit)
	self:_unregister_event("event_register_character_camera")

	local viewport_name = ClassSelectionViewSettings.viewport_name
	local viewport_type = ClassSelectionViewSettings.viewport_type
	local viewport_layer = ClassSelectionViewSettings.viewport_layer
	local shading_environment = ClassSelectionViewSettings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)

	self._fade_animation_id = self:_start_animation("fade_in", nil, self._render_settings)
end

ClassSelectionView.event_register_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit
end

ClassSelectionView._enable_blur = function (self, enable)
	local world_spawner = self._world_spawner

	if world_spawner then
		if enable then
			self._world_spawner:set_camera_blur(0.9, 0.1)
		else
			self._world_spawner:set_camera_blur(0, 0.1)
		end
	end
end

ClassSelectionView.draw = function (self, dt, t, input_service, layer)
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph
	local render_settings = self._render_settings
	local domain_options_widgets = self._domain_options_widgets
	local class_details_widgets = self._class_details_widgets
	local class_options_widgets = self._class_options_widgets

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if domain_options_widgets then
		for i = 1, #domain_options_widgets do
			local widget = domain_options_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if class_details_widgets then
		for i = 1, #class_details_widgets do
			local background_widget = class_details_widgets[i].background
			local info_widget = class_details_widgets[i].info

			UIWidget.draw(background_widget, ui_renderer)
			UIWidget.draw(info_widget, ui_renderer)
		end
	end

	if class_options_widgets then
		for i = 1, #class_options_widgets do
			local widget = class_options_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)
	UIRenderer.begin_pass(self._offscreen_renderer, ui_scenegraph, input_service, dt, render_settings)

	local class_abilities_info_widgets = self._class_abilities_info_widgets

	if class_abilities_info_widgets then
		for i = 1, #class_abilities_info_widgets do
			local widget = class_abilities_info_widgets[i]

			UIWidget.draw(widget, self._offscreen_renderer)
		end
	end

	UIRenderer.end_pass(self._offscreen_renderer)
	ClassSelectionView.super.draw(self, dt, t, input_service, layer)
end

ClassSelectionView.update = function (self, dt, t, input_service)
	if self._new_level_name then
		self:_setup_background_world(self._new_level_name)

		self._new_level_name = nil
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	local grid = self._class_abilities_info_grid

	if grid then
		grid:update(dt, t, input_service)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(ClassSelectionViewTestify, self)
	end

	return ClassSelectionView.super.update(self, dt, t, input_service)
end

ClassSelectionView._on_choose_pressed = function (self)
	if self._classes_visible then
		self._character_create:set_specialization(self._selected_class.name)
		self:_play_sound(UISoundEvents.character_create_confirm)
		Managers.event:trigger("event_create_new_character_continue")
	else
		self:_on_class_pressed(self._selected_class.name)
	end
end

ClassSelectionView._on_continue_pressed = function (self)
	self._character_create:set_specialization(self._selected_class.name)
	self:_play_sound(UISoundEvents.character_create_confirm)
	Managers.event:trigger("event_create_new_character_continue")
end

ClassSelectionView._on_details_pressed = function (self)
	if self._classes_visible then
		self._widgets_by_name.details_button.content.text = Utf8.upper(Localize("loc_mission_voting_view_show_details"))

		self:_show_classes_widgets(false)
	else
		self._widgets_by_name.details_button.content.text = Utf8.upper(Localize("loc_mission_voting_view_hide_details"))

		self:_on_class_pressed(self._selected_class.name)
	end
end

ClassSelectionView._on_back_pressed = function (self)
	Managers.event:trigger("event_create_new_character_back")
	self:_play_sound(UISoundEvents.character_create_abort)
end

ClassSelectionView._on_quit_pressed = function (self)
	local context = {
		title_text = "loc_popup_header_quit_game",
		description_text = "loc_popup_description_quit_game",
		options = {
			{
				text = "loc_popup_button_continue_game",
				close_on_pressed = true,
				hotkey = "back"
			},
			{
				text = "loc_popup_button_quit_game",
				close_on_pressed = true,
				callback = callback(function ()
					Application.quit()
				end)
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context)
end

ClassSelectionView.on_exit = function (self)
	if self._input_legend_element then
		self._input_legend_element = nil

		self:_remove_element("input_legend")
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	self:_destroy_offscreen_renderer()
	ClassSelectionView.super.on_exit(self)

	for i = 1, #self._talents_load_id do
		local load_id = self._talents_load_id[i]

		Managers.package:release(load_id)
	end
end

ClassSelectionView._handle_input = function (self, input_service)
	local input_handled = false

	if not self._using_cursor_navigation then
		if input_service:get("confirm_pressed") then
			self:_on_details_pressed()

			input_handled = true
		elseif input_service:get("secondary_action_pressed") then
			self:_on_continue_pressed()

			input_handled = true
		end
	end

	local domain_options = self._domain_options
	local num_options = nil

	if not input_handled then
		local new_selection_index, current_selection_index = nil
		current_selection_index = self._selected_domain and table.index_of(domain_options, self._selected_domain) or 1
		num_options = #domain_options

		if input_service:get("navigate_left_continuous") or input_service:get("navigate_primary_left_pressed") then
			if current_selection_index > 1 then
				new_selection_index = current_selection_index - 1
			end
		elseif (input_service:get("navigate_right_continuous") or input_service:get("navigate_primary_right_pressed")) and current_selection_index < num_options then
			new_selection_index = current_selection_index + 1
		end

		if new_selection_index then
			local target_option = self._domain_options[new_selection_index]

			self:_on_domain_pressed(target_option)
		end
	end
end

ClassSelectionView._on_navigation_input_changed = function (self)
	ClassSelectionView.super._on_navigation_input_changed(self)
	self:_handle_continue_button_text()
end

ClassSelectionView._create_domain_option_widgets = function (self)
	self:_destroy_domain_option_widgets()

	local domain_option_definition = Definitions.domain_option_definition
	local domain_selection_definition = Definitions.domain_selection_definition
	local size = domain_option_definition.size
	local widgets = {}
	local options = self._domain_options
	local num_options = #options
	local widget_width = size[1]
	local spacing = ClassSelectionViewSettings.domain_option_spacing
	local start_offset_x = 0
	local widget_left = self:_create_widget("domain_select_left", domain_selection_definition.left)
	widget_left.offset[1] = -ClassSelectionViewSettings.domain_select_spacing

	for i = 1, num_options do
		local option = options[i]
		local name = "domain_option_" .. i
		local widget = self:_create_widget(name, domain_option_definition)
		local content = widget.content
		content.icon = option.archetype_icon_selection_large_unselected
		content.icon_highlight = option.archetype_icon_selection_large
		content.hotspot.pressed_callback = callback(self, "_on_domain_pressed", option)
		content.archetype_title = option.archetype_title
		widgets[#widgets + 1] = widget
		widget.offset[1] = start_offset_x
		start_offset_x = start_offset_x + widget_width + spacing
	end

	local widget_right = self:_create_widget("domain_select_right", domain_selection_definition.right)
	widget_right.offset[1] = start_offset_x
	self._domain_options_widgets = widgets

	self:_set_scenegraph_size("domain_options", start_offset_x, nil)

	self._domain_options_select_widget = {
		widget_left,
		widget_right
	}
end

ClassSelectionView._on_domain_pressed = function (self, selected_domain)
	if selected_domain ~= self._selected_domain then
		self._selected_domain = selected_domain

		self._character_create:set_archetype(selected_domain)

		local selection_sound_event = self._selected_domain.selection_sound_event

		self:_play_sound(selection_sound_event)

		if self._setup_complete then
			self:_play_sound(UISoundEvents.character_create_archetype_pressed)
		end

		if self._fade_animation_id and self:_is_animation_active(self._fade_animation_id) then
			self:_stop_animation(self._fade_animation_id)
		end

		self._widgets_by_name.transition_fade.alpha_multiplier = 1
		self._new_level_name = selected_domain.archetype_selection_level
	else
		self._widgets_by_name.transition_fade.alpha_multiplier = 0
	end

	local domain_options_widgets = self._domain_options_widgets

	for i = 1, #domain_options_widgets do
		local widget = domain_options_widgets[i]
		local content = widget.content
		content.hotspot.is_focused = selected_domain.archetype_title == content.archetype_title
	end

	if self._classes_visible then
		self:_show_class_details(false)

		self._widgets_by_name.details_button.content.text = Utf8.upper(Localize("loc_mission_voting_view_show_details"))
		self._widgets_by_name.class_background.content.visible = false

		self:_enable_blur(false)

		self._classes_visible = false
	end

	local selected_class_name = nil

	for class_name, class in pairs(self._selected_domain.specializations) do
		if class.title and not class.disabled and class.name == default_classes[self._selected_domain.name] then
			selected_class_name = class_name

			break
		end
	end

	self._selected_class = self._selected_domain.specializations[selected_class_name]

	self:_update_domain_info()
end

ClassSelectionView._update_domain_info = function (self)
	local widgets_by_name = self._widgets_by_name
	local selected_domain = self._selected_domain
	local selected_class = self._selected_class
	local widget = widgets_by_name.domain_info
	local domain_titles = {
		psyker = "loc_class_psyker-psykinetic_title",
		veteran = "loc_class_veteran-sharpshooter_title",
		zealot = "loc_class_zealot-preacher_title",
		ogryn = "loc_class_ogryn-skullbreaker_title"
	}
	widget.content.title = Localize(domain_titles[selected_domain.name])
	widget.content.description = Localize(selected_domain.archetype_description)
	widgets_by_name.corners.content.left_upper = UISettings.inventory_frames_by_archetype[selected_domain.name].right_upper
	widgets_by_name.corners.content.right_upper = UISettings.inventory_frames_by_archetype[selected_domain.name].right_upper
	widgets_by_name.corners.content.left_lower = UISettings.inventory_frames_by_archetype[selected_domain.name].left_lower
	widgets_by_name.corners.content.right_lower = UISettings.inventory_frames_by_archetype[selected_domain.name].right_lower
end

ClassSelectionView._update_choose_button_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local details_button_display_name = Utf8.upper(Localize("loc_character_create_button_details"))
	local choose_button_display_name = Utf8.upper(Localize("loc_character_backstory_selection"))
	local title = nil

	if self._classes_visible then
		title = choose_button_display_name
	else
		title = details_button_display_name
	end

	widgets_by_name.choose_button.content.text = title
end

ClassSelectionView._show_classes_widgets = function (self, show, force_domain)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.class_background.content.visible = show
	local selected_domain = nil

	if force_domain ~= nil then
		selected_domain = force_domain
	else
		selected_domain = self._selected_domain
	end

	self:_enable_blur(show)

	if show then
		self:_show_class_details(true)

		if self._fade_animation_id and self:_is_animation_active(self._fade_animation_id) then
			self:_stop_animation(self._fade_animation_id)
		end

		self._widgets_by_name.transition_fade.alpha_multiplier = 0.5
	else
		widgets_by_name.main_title.content.visible = true
		widgets_by_name.main_title.content.text = Utf8.upper(Localize("loc_main_menu_create_button"))

		self:_show_class_details(false)

		self._widgets_by_name.transition_fade.alpha_multiplier = 0

		self:_on_domain_pressed(selected_domain)
	end

	self._classes_visible = show
end

ClassSelectionView._destroy_class_option_widgets = function (self)
	if self._class_options_widgets then
		for i = 1, #self._class_options_widgets do
			local widget = self._class_options_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._class_options_widgets = nil
	end
end

ClassSelectionView._create_class_option_widgets = function (self)
	self:_destroy_class_option_widgets()

	local definitions = self._definitions
	local class_option_definition = definitions.class_option_definition
	local option = self._selected_domain
	local widgets = {}
	local size = ClassSelectionViewSettings.class_option_icon_size
	local spacing = ClassSelectionViewSettings.class_select_spacing
	local start_offset_x = 0
	local count = 0

	for class_name, class in pairs(option.specializations) do
		if class.title and not class.disabled then
			count = count + 1
			local name = "option_" .. count
			local widget = self:_create_widget(name, class_option_definition)
			local content = widget.content
			content.hotspot.pressed_callback = callback(self, "_on_class_pressed", class_name)
			widgets[#widgets + 1] = widget
			widget.offset[1] = start_offset_x
			start_offset_x = start_offset_x + size[1] + spacing
			content.hotspot.is_focused = class.title == self._selected_class.title
			content.class_name = class_name
			content.title = Utf8.upper(Localize(class.title))
			widget.style.icon.material_values.main_texture = class.specialization_banner
		end
	end

	self._class_options_widgets = widgets
end

ClassSelectionView._on_class_pressed = function (self, class_name)
	if not self._classes_visible or not self._selected_class or class_name ~= self._selected_class.name then
		local widgets_by_name = self._widgets_by_name
		self._selected_class = self._selected_domain.specializations[class_name]
		widgets_by_name.class_background.content.class_background = self._selected_domain.archetype_icon_large

		self:_show_classes_widgets(true)
	end

	self:_play_sound(UISoundEvents.character_create_class_select)
end

ClassSelectionView._destroy_domain_option_widgets = function (self)
	if self._domain_options_widgets then
		for i = 1, #self._domain_options_widgets do
			local widget = self._domain_options_widgets[i]

			self:_unregister_widget_name(widget.name)
		end
	end

	if self._domain_options_select_widget then
		for i = 1, #self._domain_options_select_widget do
			local widget = self._domain_options_select_widget[i]

			self:_unregister_widget_name(widget.name)
		end
	end

	self._domain_options_widgets = nil
	self._domain_options_select_widget = nil
end

ClassSelectionView._destroy_class_abilities_info = function (self)
	if self._class_abilities_info_widgets then
		for i = 1, #self._class_abilities_info_widgets do
			local widget = self._class_abilities_info_widgets[i]
			local template = ContentBlueprints[widget.element.type]

			if template and template.destroy then
				template.destroy(self, widget)
			end

			self:_unregister_widget_name(widget.name)
		end

		self._class_abilities_info_widgets = nil

		self._class_abilities_info_grid:destroy()

		self._class_abilities_info_grid = nil
		local scrollbar_widget = self._widgets_by_name.class_details_scrollbar
		scrollbar_widget.content.visible = false
	end
end

ClassSelectionView._show_class_details = function (self, show)
	local widgets_by_name = self._widgets_by_name

	if show then
		self:_create_class_abilities_info()
	else
		self:_destroy_class_abilities_info()
	end
end

ClassSelectionView._create_class_abilities_info = function (self)
	local scenegraph_id = "class_details"
	local scenegraph_pivot = "class_details_content_pivot"

	self:_destroy_class_abilities_info()

	local info_data = {}
	local selected_class = self._selected_class
	local class_name = selected_class.name
	local selected_domain = self._selected_domain
	local domain_name = selected_domain.name
	local class_info = selected_domain.specializations[class_name]
	local talent_definitions = ArchetypeTalents[domain_name][class_name]
	local coherencies = {}
	local class_abilities = {}
	local grenades = {}
	local combat_abilities = {}
	local unique_weapons = {}
	local talent_lookup = {}

	for i = 1, #class_info.talent_groups do
		local talent = class_info.talent_groups[i]

		if talent.required_level == 1 then
			for f = 1, #talent.talents do
				talent_lookup[#talent_lookup + 1] = {
					name = talent.talents[f],
					group = talent.group_name
				}
			end
		end
	end

	for i = 1, #talent_lookup do
		local talent_info = talent_lookup[i]
		local name = talent_info.name
		local talent = talent_definitions[name]

		if talent_info.group == "combat" then
			combat_abilities[#combat_abilities + 1] = talent
		elseif talent_info.group == "tactical" then
			grenades[#grenades + 1] = talent
		elseif talent_info.group == "aura" then
			coherencies[#coherencies + 1] = talent
		elseif talent_info.group == "passive" then
			class_abilities[#class_abilities + 1] = talent
		end
	end

	if selected_class.unique_weapons then
		for i = 1, #selected_class.unique_weapons do
			local weapon = selected_class.unique_weapons[i]
			local item = MasterItems.get_item(weapon.item)

			if item then
				unique_weapons[#unique_weapons + 1] = {
					item = table.clone_instance(item),
					display_name = weapon.display_name
				}
			end
		end
	end

	info_data[#info_data + 1] = {
		type = "video",
		data = {
			video_path = self._selected_class.video
		}
	}
	info_data[#info_data + 1] = {
		type = "description_short",
		data = {
			text = self._selected_class.description_short
		}
	}
	info_data[#info_data + 1] = {
		size = 20,
		type = "spacing"
	}
	info_data[#info_data + 1] = {
		type = "description",
		data = {
			text = self._selected_class.description
		}
	}
	info_data[#info_data + 1] = {
		size = 80,
		type = "spacing"
	}

	if #combat_abilities > 0 then
		info_data[#info_data + 1] = {
			type = "title",
			data = Localize("loc_glossary_term_combat_ability")
		}
		info_data[#info_data + 1] = {
			size = 20,
			type = "spacing"
		}
		info_data[#info_data + 1] = {
			ability_type = "combat_ability",
			type = "ability",
			data = combat_abilities,
			icon_size = {
				110,
				96
			}
		}
		info_data[#info_data + 1] = {
			size = 40,
			type = "spacing"
		}
	end

	if #class_abilities > 0 then
		info_data[#info_data + 1] = {
			type = "title",
			data = Localize("loc_glossary_term_passive")
		}
		info_data[#info_data + 1] = {
			size = 20,
			type = "spacing"
		}
		info_data[#info_data + 1] = {
			type = "ability",
			data = class_abilities
		}
		info_data[#info_data + 1] = {
			size = 40,
			type = "spacing"
		}
	end

	if #grenades > 0 then
		info_data[#info_data + 1] = {
			type = "title",
			data = Localize("loc_glossary_term_tactical")
		}
		info_data[#info_data + 1] = {
			size = 20,
			type = "spacing"
		}
		info_data[#info_data + 1] = {
			type = "ability",
			data = grenades
		}
		info_data[#info_data + 1] = {
			size = 40,
			type = "spacing"
		}
	end

	if #coherencies > 0 then
		info_data[#info_data + 1] = {
			type = "title",
			data = Localize("loc_glossary_term_aura")
		}
		info_data[#info_data + 1] = {
			size = 20,
			type = "spacing"
		}
		info_data[#info_data + 1] = {
			type = "ability",
			data = coherencies
		}
		info_data[#info_data + 1] = {
			size = 40,
			type = "spacing"
		}
	end

	if #unique_weapons > 0 then
		info_data[#info_data + 1] = {
			type = "title",
			data = Localize("loc_class_selection_specialization_class_unique_weapons_title")
		}
		info_data[#info_data + 1] = {
			size = 20,
			type = "spacing"
		}
		info_data[#info_data + 1] = {
			type = "weapon",
			data = unique_weapons
		}
	end

	local widgets = {}
	local alignment_widgets = {}

	for i = 1, #info_data do
		local info = info_data[i]
		local type = info.type
		local template = ContentBlueprints[type]
		local pass_definitions = template and template.pass_definitions or {}

		if type == "title" then
			local widget_definition = UIWidget.create_definition(pass_definitions, scenegraph_pivot)
			local widget_name = string.format("class_data_%d_%d", i, 1)
			local widget = self:_create_widget(widget_name, widget_definition)
			local element = {
				text = Utf8.upper(info.data)
			}

			template.init(self, widget, element)

			widgets[#widgets + 1] = widget
			alignment_widgets[#alignment_widgets + 1] = {
				horizontal_alignment = "center",
				size = {
					ClassSelectionViewSettings.class_size[1],
					widget.content.size[2]
				},
				offset = widget.offset,
				name = widget.name
			}
		elseif type == "ability" then
			for f = 1, #info.data do
				local ability = info.data[f]
				local widget_definition = UIWidget.create_definition(pass_definitions, scenegraph_pivot)
				local widget_name = string.format("class_data_%d_%d", i, f)
				local widget = self:_create_widget(widget_name, widget_definition)
				local element = {
					ability = ability,
					icon_size = info.icon_size,
					ability_type = info.ability_type,
					type = type
				}

				template.init(self, widget, element)

				if self._loaded_icons.all_loaded then
					template.load_icon(self, widget, element)
				end

				widgets[#widgets + 1] = widget
				alignment_widgets[#alignment_widgets + 1] = {
					horizontal_alignment = "center",
					size = {
						ClassSelectionViewSettings.class_size[1],
						widget.content.size[2]
					},
					offset = widget.offset,
					name = widget.name
				}
			end
		elseif type == "weapon" then
			for f = 1, #info.data do
				local weapon = info.data[f]
				local widget_definition = UIWidget.create_definition(pass_definitions, scenegraph_pivot)
				local widget_name = string.format("class_data_%d_%d", i, f)
				local widget = self:_create_widget(widget_name, widget_definition)
				local item = weapon.item
				local element = {
					item = item,
					display_name = weapon.display_name
				}

				template.init(self, widget, element)
				template.load_icon(self, widget, element)

				widgets[#widgets + 1] = widget
				alignment_widgets[#alignment_widgets + 1] = {
					horizontal_alignment = "center",
					size = {
						ClassSelectionViewSettings.class_size[1],
						widget.content.size[2]
					},
					offset = widget.offset,
					name = widget.name
				}
				widgets[#widgets + 1] = nil
				alignment_widgets[#alignment_widgets + 1] = {
					size = {
						ClassSelectionViewSettings.class_size[1],
						20
					}
				}
			end
		elseif type == "spacing" then
			widgets[#widgets + 1] = nil
			alignment_widgets[#alignment_widgets + 1] = {
				size = {
					ClassSelectionViewSettings.class_size[1],
					info.size
				}
			}
		else
			local widget_definition = UIWidget.create_definition(pass_definitions, scenegraph_pivot)
			local widget_name = string.format("class_data_%d_%d", i, 1)
			local widget = self:_create_widget(widget_name, widget_definition)
			local element = table.clone(info.data)
			element.type = type

			template.init(self, widget, element)

			widgets[#widgets + 1] = widget
			alignment_widgets[#alignment_widgets + 1] = {
				horizontal_alignment = "center",
				size = {
					ClassSelectionViewSettings.class_size[1],
					widget.content.size[2]
				},
				offset = widget.offset,
				name = widget.name
			}
		end
	end

	local ui_scenegraph = self._ui_scenegraph
	local grid = UIWidgetGrid:new(widgets, alignment_widgets, ui_scenegraph, scenegraph_id, "down", {
		0,
		0
	})
	local scrollbar_widget = self._widgets_by_name.class_details_scrollbar
	scrollbar_widget.content.visible = true

	grid:assign_scrollbar(scrollbar_widget, scenegraph_pivot, scenegraph_id)
	grid:set_scrollbar_progress(0)

	self._class_abilities_info_grid = grid
	self._class_abilities_info_widgets = widgets

	grid:select_grid_index(1)
end

ClassSelectionView.on_choose_pressed = function (self)
	self:_on_choose_pressed()
end

ClassSelectionView.archetype_options = function (self)
	return self._domain_options
end

ClassSelectionView.on_domain_pressed = function (self, target_option)
	self:_on_domain_pressed(target_option)
end

ClassSelectionView._cb_on_open_options_pressed = function (self)
	Managers.ui:open_view("options_view")
end

ClassSelectionView._handle_continue_button_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local service_type = DefaultViewInputSettings.service_type
	local continue_button_action = "secondary_action_pressed"
	local continue_button_action_display_name = "loc_character_creator_continue"
	local continue_button_text = nil

	if not self._using_cursor_navigation then
		continue_button_text = TextUtils.localize_with_button_hint(continue_button_action, continue_button_action_display_name, nil, service_type, Localize("loc_input_legend_text_template"))
	else
		continue_button_text = Localize(continue_button_action_display_name)
	end

	widgets_by_name.continue_button.content.text = Utf8.upper(continue_button_text)
end

return ClassSelectionView
