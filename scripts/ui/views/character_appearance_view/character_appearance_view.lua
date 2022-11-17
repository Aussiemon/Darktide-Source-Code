local Definitions = require("scripts/ui/views/character_appearance_view/character_appearance_view_definitions")
local CharacterAppearanceViewSettings = require("scripts/ui/views/character_appearance_view/character_appearance_view_settings")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local CharacterAppearanceViewTestify = GameParameters.testify and require("scripts/ui/views/character_appearance_view/character_appearance_view_testify")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local ContentBlueprints = require("scripts/ui/views/character_appearance_view/character_appearance_view_content_blueprints")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local TextUtils = require("scripts/utilities/ui/text")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local CharacterAppearanceViewFontStyle = require("scripts/ui/views/character_appearance_view/character_appearance_view_font_style")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UISettings = require("scripts/settings/ui/ui_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local EyeMaterialOverrides = require("scripts/settings/equipment/item_material_overrides/player_material_overrides_eye_colors")
local SkinMaterialOverrides = require("scripts/settings/equipment/item_material_overrides/player_material_overrides_skin_colors")
local HairMaterialOverrides = require("scripts/settings/equipment/item_material_overrides/player_material_overrides_hair_colors")
local HomePlanets = require("scripts/settings/character/home_planets")
local Childhood = require("scripts/settings/character/childhood")
local GrowingUp = require("scripts/settings/character/growing_up")
local FormativeEvent = require("scripts/settings/character/formative_event")
local Crimes = require("scripts/settings/character/crimes")
local Personalities = require("scripts/settings/character/personalities")
local Breeds = require("scripts/settings/breed/breeds")
local CharacterAppearanceView = class("CharacterAppearanceView", "BaseView")
local InputUtils = require("scripts/managers/input/input_utils")
local ItemUtils = require("scripts/utilities/items")
local eye_types = {
	{
		icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r1_l1",
		name = "no_blind",
		sort_order = 1
	},
	{
		icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r0_l1",
		name = "blind_left",
		sort_order = 2,
		search_string = "blind_left"
	},
	{
		icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r1_l0",
		name = "blind_right",
		sort_order = 3,
		search_string = "blind_right"
	},
	{
		icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r0_l0",
		name = "blind_both",
		sort_order = 4,
		search_string = "blind_both"
	},
	{
		icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r2_l2",
		name = "black_scalera",
		sort_order = 5,
		search_string = "black_scalera"
	}
}
local choices_presentation = {
	home_planet = {
		description = "loc_character_birthplace_planet_title_name",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood"
	},
	childhood = {
		description = "loc_character_childhood_title_name",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood"
	},
	growing_up = {
		description = "loc_character_growing_up_title_name",
		icon_texture = "content/ui/textures/icons/generic/placeholder_growingup"
	},
	formative_event = {
		description = "loc_character_event_title_name",
		icon_texture = "content/ui/textures/icons/generic/placeholder_formative"
	}
}

local function get_eye_type_index_by_option(option)
	local name = option.material_overrides[1]

	for i = 1, #eye_types do
		local eye_type = eye_types[i]
		local search_string = eye_type.search_string

		if search_string and string.find(name, search_string) then
			return i
		end
	end

	return 1
end

local function sort_by_order(appearance_a, appearance_b)
	if appearance_a.sort_order and appearance_b.sort_order then
		return appearance_a.sort_order < appearance_b.sort_order
	else
		return false
	end
end

local function sort_by_string_name(appearance_a, appearance_b)
	if appearance_a.dev_name and appearance_b.dev_name then
		return appearance_a.dev_name < appearance_b.dev_name
	else
		return false
	end
end

CharacterAppearanceView.init = function (self, settings, context)
	self._character_create = context.character_create
	self._profile_versions = table.clone(self._character_create:profile_value_versions())
	self._context = context
	self._parent = context and context.parent
	self._force_character_creation = context.force_character_creation

	CharacterAppearanceView.super.init(self, Definitions, settings)

	if context.pass_draw ~= nil then
		self._pass_draw = context.pass_draw
	end

	if context.pass_input ~= nil then
		self._pass_input = context.pass_input
	end

	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()
end

CharacterAppearanceView.on_enter = function (self)
	CharacterAppearanceView.super.on_enter(self)

	self._current_progress = 0
	self._page_grids = {}
	self._camera_zoomed = false
	self._gear_visible = false
	self._page_indicator_widgets = {}
	self._is_character_showing = false
	self._active_page_number = 1
	self._block_continue = {}
	self._pages = self:_get_pages()
	self._character_name_status = {
		custom = false
	}

	for i = 1, #self._pages do
		self._block_continue[i] = {
			false
		}
	end

	self._navigation = {
		index = 0,
		grid = 0
	}
	self._backstory_selection_page = nil
	self._backstory_selection = nil

	self:_register_event("update_character_sync_state", "_event_profile_sync_changed")

	local is_syncing = self._parent and self._parent._character_is_syncing or false

	self:_event_profile_sync_changed(is_syncing)
	self:_create_offscreen_renderer()
	self:_setup_input_legend()
	self:_setup_button_callbacks()
	self:_setup_profile_background()
	self:_create_page_indicators()
	self._character_create:reset_backstory()
	self:_randomize_character_backstory()
	self:_open_page(1)
end

CharacterAppearanceView._create_offscreen_renderer = function (self)
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

CharacterAppearanceView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

CharacterAppearanceView._setup_button_callbacks = function (self)
	self._widgets_by_name.continue_button.content.hotspot.pressed_callback = callback(self, "_on_continue_pressed")
end

CharacterAppearanceView._setup_background_world = function (self)
	local breed_name = self._character_create:breed()
	local default_camera_event_id = "event_register_character_appearance_default_camera_" .. breed_name

	self[default_camera_event_id] = function (self, camera_unit)
		self._default_camera_unit = camera_unit
		local viewport_name = CharacterAppearanceViewSettings.viewport_name
		local viewport_type = CharacterAppearanceViewSettings.viewport_type
		local viewport_layer = CharacterAppearanceViewSettings.viewport_layer
		local shading_environment = CharacterAppearanceViewSettings.shading_environment

		self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
		self:_unregister_event(default_camera_event_id)
	end

	self:_register_event(default_camera_event_id)

	self._camera_by_slot_id = {}

	for slot_name, slot in pairs(ItemSlotSettings) do
		if slot.slot_type == "body" then
			local item_camera_event_id = "event_register_character_appearance_camera_" .. breed_name .. "_" .. slot_name

			self[item_camera_event_id] = function (self, camera_unit)
				self._camera_by_slot_id[slot_name] = camera_unit
				self._camera_zoomed = self:_is_camera_zoomed(slot_name)

				self:_unregister_event(item_camera_event_id)
			end

			self:_register_event(item_camera_event_id)
		end
	end

	self:_register_event("event_register_character_spawn_point")

	local world_name = CharacterAppearanceViewSettings.world_name
	local world_layer = CharacterAppearanceViewSettings.world_layer
	local world_timer_name = CharacterAppearanceViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)
	local level_name = CharacterAppearanceViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

CharacterAppearanceView._setup_profile_background = function (self)
	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype
	self._widgets_by_name.list_background.content.class_background = selected_archetype.archetype_icon_large
	local selected_archetype_name = selected_archetype.name
	self._widgets_by_name.corners.content.left_upper = UISettings.inventory_frames_by_archetype[selected_archetype_name].right_upper
	self._widgets_by_name.corners.content.right_upper = UISettings.inventory_frames_by_archetype[selected_archetype_name].right_upper
	self._widgets_by_name.corners.content.left_lower = UISettings.inventory_frames_by_archetype[selected_archetype_name].left_lower
	self._widgets_by_name.corners.content.right_lower = UISettings.inventory_frames_by_archetype[selected_archetype_name].right_lower
end

CharacterAppearanceView.event_register_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	self:_spawn_profile(spawn_point_unit)
end

CharacterAppearanceView._spawn_profile = function (self, spawn_point_unit)
	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()
	self._profile_spawner = UIProfileSpawner:new("CharacterAppearanceView", world, camera, unit_spawner)
	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)
	self._spawn_point_position = Vector3.to_array(spawn_position)
	local profile = self._character_create:profile()

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation)

	local archetype_settings = profile.archetype
	local archetype_name = archetype_settings.name
	local breed_name = archetype_settings.breed
	local breed_settings = Breeds[breed_name]
	local character_creation_state_machine = breed_settings.character_creation_state_machine
	local animations_per_archetype = CharacterAppearanceViewSettings.animations_per_archetype
	local animations_settings = animations_per_archetype[archetype_name]
	local animation_event = animations_settings.initial_event

	self._profile_spawner:assign_state_machine(character_creation_state_machine, animation_event)
end

CharacterAppearanceView._on_continue_pressed = function (self)
	local num_pages = #self._pages
	local active_page_number = self._active_page_number

	if active_page_number == num_pages and self._await_validation then
		self._block_continue[self._active_page_number] = {
			true
		}

		self:_show_loading_awaiting_validation(true)

		local name = self._character_create:name()

		self._character_create:check_name(name):next(function (data)
			self:_show_loading_awaiting_validation(false)

			if data.permitted == false then
				return self:_create_errors_name_input({
					Localize("loc_character_create_name_validation_failed_message")
				})
			else
				self._block_continue[self._active_page_number] = {
					false
				}
				self._await_validation = false

				return self:_on_continue_pressed()
			end
		end):catch(function (error)
			self._block_continue[self._active_page_number] = {
				false
			}

			self:_show_loading_awaiting_validation(false)
		end)
	else
		local world = Managers.ui:world()
		local wwise_world = Managers.world:wwise_world(world)

		if self._current_sound_id and WwiseWorld.is_playing(wwise_world, self._current_sound_id) then
			WwiseWorld.stop_event(wwise_world, self._current_sound_id)
		end

		if active_page_number == num_pages then
			if not self._popup_finish_open then
				self._popup_finish_open = true
				local context = {
					title_text = "loc_popup_header_create_character",
					description_text = "loc_popup_description_create_character",
					options = {
						{
							text = "loc_character_create_confirm_play_prologue",
							stop_exit_sound = true,
							close_on_pressed = true,
							on_pressed_sound = UISoundEvents.finalize_creation_confirm,
							callback = callback(function ()
								local skip_onboarding = false

								Managers.event:trigger("event_create_new_character_continue", skip_onboarding)
							end)
						},
						{
							text = "loc_popup_button_cancel",
							template_type = "terminal_button_small",
							close_on_pressed = true,
							hotkey = "back",
							callback = callback(function ()
								self._popup_finish_open = nil
							end)
						}
					}
				}

				if Managers.data_service.account:has_completed_onboarding() then
					local skip_onboarding_option = {
						text = "loc_character_create_confirm_skip_prologue",
						stop_exit_sound = true,
						close_on_pressed = true,
						on_pressed_sound = UISoundEvents.finalize_creation_confirm,
						callback = callback(function ()
							local skip_onboarding = true

							Managers.event:trigger("event_create_new_character_continue", skip_onboarding)
						end)
					}

					table.insert(context.options, 2, skip_onboarding_option)
				end

				Managers.event:trigger("event_show_ui_popup", context)
			end
		else
			local next_page_index = active_page_number + 1

			self:_open_page(next_page_index)
		end
	end
end

CharacterAppearanceView._randomize_character_appearance = function (self)
	self._character_create:randomize_presets()
	self:_update_appearance_selection()
	self:_update_appearance_icon()
	self._character_create:reset_height()

	local height = self._character_create:height()

	self:_set_character_height(height)

	if self._page_grids[2] and self._page_grids[2].entry and self._page_grids[2].entry.type == "height" then
		local template_name = self._page_grids[2].entry.template
		local widget = self._page_grids[2].widgets[1]
		local template = ContentBlueprints.blueprints[template_name]

		template.reset(self, widget)
	else
		self._height_changed = true
	end
end

CharacterAppearanceView._update_appearance_selection = function (self)
	for i = 1, #self._page_grids[1].widgets do
		local widget = self._page_grids[1].widgets[i]

		if widget.content.element_selected == true then
			local options = self._pages[self._active_page_number].content.options[i].options

			for j = 1, #options do
				if options[j].grid_template ~= "single" then
					local selected_value = options[j].get_value_function and options[j].get_value_function()
					local page_grid = self._page_grids[j + 1]

					for k = 1, #page_grid.widgets do
						local widget = page_grid.widgets[k]

						if selected_value and selected_value == widget.content.entry.value then
							widget.content.element_selected = true
						else
							widget.content.element_selected = false
						end
					end
				end
			end

			break
		end
	end
end

CharacterAppearanceView._handle_continue_button_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local service_type = DefaultViewInputSettings.service_type
	local continue_button_action = "secondary_action_pressed"
	local continue_button_action_display_name, continue_button_text = nil

	if self._backstory_selection_page then
		continue_button_action_display_name = "loc_character_backstory_selection"
	elseif self._active_page_number == #self._pages then
		continue_button_action_display_name = "loc_character_create_finish"
	else
		continue_button_action_display_name = "loc_character_create_advance"
	end

	if not self._using_cursor_navigation then
		continue_button_text = TextUtils.localize_with_button_hint(continue_button_action, continue_button_action_display_name, nil, service_type, Localize("loc_input_legend_text_template"))
	else
		continue_button_text = Localize(continue_button_action_display_name)
	end

	widgets_by_name.continue_button.content.text = Utf8.upper(continue_button_text)
end

CharacterAppearanceView._randomize_character_backstory = function (self)
	local backstory_options = self:_get_backstory_content().options

	for i = 1, #backstory_options do
		local available_indexes = {}

		for j = 1, #backstory_options[i].options do
			local backstory = backstory_options[i].options[j]

			if backstory.visibility_function and backstory.visibility_function() or not backstory.visibility_function then
				available_indexes[#available_indexes + 1] = j
			end
		end

		local random_index = math.random(1, #available_indexes)
		local choosen_index = available_indexes[random_index]

		backstory_options[i].options[choosen_index].on_randomize()
	end
end

CharacterAppearanceView._randomize_character_name = function (self)
	local name = self._character_create:randomize_name()
	self._character_name_status.custom = false
	self._await_validation = false

	if self._page_widgets then
		local input_widget = self._page_widgets[1]
		local content = input_widget.content
		content.input_text = name

		self:_stop_character_name_input()
		self:_update_character_name()
		self:_update_final_page_text()
	else
		self._character_create:set_name(name)
	end
end

CharacterAppearanceView._stop_character_name_input = function (self)
	if self._page_widgets then
		local input_widget = self._page_widgets[1]
		local content = input_widget.content
		content.selected_text = nil
		content._selection_start = nil
		content._selection_end = nil
		content.is_writing = false
	end
end

CharacterAppearanceView._update_character_custom_name = function (self)
	self._character_name_status.custom = true
	self._await_validation = true

	self:_update_character_name()
end

CharacterAppearanceView._update_character_name = function (self)
	local widget = self._page_widgets[1]
	local name = type(widget.content.input_text) == "string" and widget.content.input_text ~= "" and widget.content.input_text or widget.content.selected_text or ""
	local input_error = true
	local invalid_characters_used = string.match(name, "[^%\\'%\\-%\\`%\\´%a]")
	local string_empty = name == ""
	input_error = string_empty

	self:_create_errors_name_input()

	self._block_continue[self._active_page_number] = {
		input_error
	}

	self._character_create:set_name(name)
	self:_update_final_page_text()
end

CharacterAppearanceView._sync_profile_changes = function (self)
	local character_create = self._character_create
	local recent_profile_versions = character_create:profile_value_versions()
	local profile_versions = self._profile_versions

	if profile_versions.profile == recent_profile_versions.profile then
		return
	end

	if profile_versions.gender ~= recent_profile_versions.gender then
		profile_versions.gender = recent_profile_versions.gender
	end

	profile_versions.profile = recent_profile_versions.profile
end

CharacterAppearanceView._change_page_indicator = function (self, index)
	local page_indicator_widgets = self._page_indicator_widgets

	for i = 1, #page_indicator_widgets do
		local widget = page_indicator_widgets[i]
		widget.content.hotspot.is_focused = i == index
	end
end

CharacterAppearanceView._move_camera = function (self, revert)
	local world_spawner = self._world_spawner
	local time = 1.5
	local func_ptr = math.easeOutCubic
	local boxed_camera_start_position = world_spawner:boxed_camera_start_position()
	local default_camera_world_position = Vector3.from_array(boxed_camera_start_position)
	local boxed_camera_start_rotation = world_spawner:boxed_camera_start_rotation()
	local default_camera_world_rotation = boxed_camera_start_rotation:unbox()
	local target_world_position = default_camera_world_position
	local target_world_rotation = default_camera_world_rotation
	local camera_world_position = default_camera_world_position
	local camera_world_rotation = default_camera_world_rotation

	if revert == true then
		world_spawner:set_camera_position_axis_offset("x", target_world_position.x - camera_world_position.x, time, func_ptr)
	else
		local profile = self._character_create:profile()
		local selected_archetype = profile.archetype.name

		if selected_archetype == "ogryn" then
			world_spawner:set_camera_position_axis_offset("x", 1.7 - (target_world_position.x - camera_world_position.x), time, func_ptr)
		else
			world_spawner:set_camera_position_axis_offset("x", 1.2 - (target_world_position.x - camera_world_position.x), time, func_ptr)
		end
	end

	local camera_world_rotation_x, camera_world_rotation_y, camera_world_rotation_z = Quaternion.to_euler_angles_xyz(camera_world_rotation)
	local target_world_rotation_x, target_world_rotation_y, target_world_rotation_z = Quaternion.to_euler_angles_xyz(target_world_rotation)

	world_spawner:set_camera_rotation_axis_offset("x", target_world_rotation_x - camera_world_rotation_x, time, func_ptr)
end

CharacterAppearanceView._open_page = function (self, index)
	if self._pages[self._active_page_number] and self._pages[self._active_page_number].leave then
		self._pages[self._active_page_number].leave()
	end

	self._active_page_number = index
	local page = self._pages[index]

	self:_hide_pages_widgets()
	self:_destroy_generated_widgets()

	if page.show_character and not self._profile_spawner then
		self:_setup_background_world()

		self._widgets_by_name.background.content.visible = false
	elseif not page.show_character and self._profile_spawner then
		self:_destroy_background()

		self._widgets_by_name.background.content.visible = true
	end

	self._widgets_by_name.background.content.texture = page.background and page.background.value
	self._widgets_by_name.background.style.texture.uvs = page.background and page.background.uvs or {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}

	if page.top_frame then
		self._widgets_by_name.list_background.content.top_frame = page.top_frame.header
		self._widgets_by_name.list_background.style.top_frame.size = page.top_frame.size
		self._widgets_by_name.list_background.style.top_frame.offset = page.top_frame.offset
		self._widgets_by_name.list_background.content.top_frame_extra = page.top_frame.header_extra
		self._widgets_by_name.list_background.style.top_frame_extra.size = page.top_frame.size
		self._widgets_by_name.list_background.style.top_frame_extra.offset = page.top_frame.offset
		self._widgets_by_name.list_header.style.divider.color[1] = 0
		self._widgets_by_name.list_header.style.text_title.offset = page.top_frame.title_offset
		self._widgets_by_name.list_header.content.icon = page.top_frame.icon
		self._widgets_by_name.list_header.style.icon.offset = page.top_frame.icon_offset or {
			0,
			0,
			0
		}
		self._widgets_by_name.list_header.style.icon.size = page.top_frame.icon_size or {
			0,
			0
		}
	else
		self._widgets_by_name.list_background.content.top_frame = "content/ui/materials/dividers/horizontal_frame_big_upper"
		self._widgets_by_name.list_background.style.top_frame.size = {
			480,
			36
		}
		self._widgets_by_name.list_background.style.top_frame.offset = {
			0,
			-18,
			1
		}
		self._widgets_by_name.list_background.content.top_frame_extra = nil
		self._widgets_by_name.list_background.style.top_frame_extra.size = {
			480,
			36
		}
		self._widgets_by_name.list_background.style.top_frame_extra.offset = {
			0,
			-18,
			1
		}
		self._widgets_by_name.list_header.content.icon = nil
		self._widgets_by_name.list_header.style.divider.color[1] = 255
		self._widgets_by_name.list_header.style.text_title.offset = {
			0,
			0,
			2
		}
	end

	if page.show_character and self._is_character_showing then
		self:_set_camera(page.camera_focus, page.gear_visible)
	end

	self:_change_page_indicator(index)

	if page.enter then
		page:enter()
	end

	local selected_index = nil

	if self._page_grids[1] and self._page_grids[1].widgets then
		for i = 1, #self._page_grids[1].widgets do
			local widget = self._page_grids[1].widgets[i]

			if widget.content.element_selected then
				selected_index = i

				break
			end
		end
	end

	if not self._using_cursor_navigation and selected_index then
		self:_update_current_navigation_position(1, selected_index)
	elseif not self._using_cursor_navigation then
		self:_update_current_navigation_position(1, 1)
	else
		self:_update_current_navigation_position(1, 0)
	end
end

CharacterAppearanceView._update_appearance_background = function (self, added_spacing)
	local scenegraph_x = self._ui_scenegraph.grid_2_area.position[1]
	local scenegraph_y = self._ui_scenegraph.grid_2_area.position[2]
	local margin = 80

	self:_set_scenegraph_position("appearance_background", scenegraph_x - margin * 0.5, scenegraph_y - margin * 0.5)

	local background_size = {
		0,
		0
	}
	local visible = false

	for i = 2, 3 do
		if self._page_grids[i] and self._page_grids[i].grid then
			local scenegraph_name = "grid_" .. i .. "_area"
			local size_x = self._ui_scenegraph[scenegraph_name].size[1]
			local size_y = self._ui_scenegraph[scenegraph_name].size[2]
			background_size[1] = background_size[1] + size_x
			background_size[2] = math.max(background_size[2], size_y)
			visible = true
		end
	end

	self:_set_scenegraph_size("appearance_background", background_size[1] + margin + added_spacing, background_size[2] + margin)

	self._widgets_by_name.appearance_background.content.visible = visible

	if visible then
		local choice_margin = 20

		self:_set_scenegraph_position("choice_detail", scenegraph_x - margin * 0.5, scenegraph_y + background_size[2] + choice_margin + margin * 0.5)
	end
end

CharacterAppearanceView._populate_page_grid = function (self, index, entry)
	if self._page_grids[index] then
		local grid = self._page_grids[index]
		local widgets = grid.widgets

		if widgets then
			for i = 1, #widgets do
				local widget = widgets[i]
				local widget_name = widget.name
				local content = widget.content

				if widget.loads_icon and content.icon_load_id then
					self:_unload_appearance_icon(widget)
				end

				self:_unregister_widget_name(widget_name)
			end
		end
	end

	local widgets = {}
	local alignment_list = {}
	local template_type = entry.template
	local template = ContentBlueprints.blueprints[template_type]
	local grid_template = entry.grid_template
	local grid_start_name = "grid_" .. index .. "_"
	local size = template.size
	local pass_template = template.pass_template
	local init = template.init
	local options = entry.options
	local focused_value = entry.get_value_function and entry.get_value_function()
	local widget_definitions = {
		scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, grid_start_name .. "scrollbar"),
		interaction = UIWidget.create_definition({
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			}
		}, grid_start_name .. "interaction"),
		mask = UIWidget.create_definition({
			{
				value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
				pass_type = "texture",
				style = {
					color = {
						255,
						255,
						255,
						255
					}
				}
			}
		}, grid_start_name .. "mask")
	}
	local support_widgets = {}

	for name, definition in pairs(widget_definitions) do
		local name = grid_start_name .. name

		if self._widgets_by_name[name] then
			self:_unregister_widget_name(name)
		end

		support_widgets[#support_widgets + 1] = self:_create_widget(name, definition)
	end

	local num_widgets = 0

	for i = 1, #options do
		local option = options[i]

		if option.visibility_function and option.visibility_function() == true or not option.visibility_function then
			num_widgets = num_widgets + 1
		end
	end

	local spacing = {
		0,
		0
	}
	local direction = "down"
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph_spacing = {
		50
	}
	local area_1_mask_margin = {
		30,
		10
	}
	local mask_margin = {
		30,
		30
	}
	local prev_scenegraph_size = {
		0,
		0
	}
	local prev_scenegraph_position = {
		0,
		0
	}
	local scrollbar_diff = 35
	local max_widgets_per_column = num_widgets
	local grid_visible_widgets = num_widgets
	local total_columns = 1
	local using_scrollbar = false
	local added_spacing = 0

	if index - 1 > 0 then
		local prev_grid_start_name = "grid_" .. index - 1 .. "_"
		local prev_scenegraph = self._ui_scenegraph[prev_grid_start_name .. "area"]
		prev_scenegraph_size = prev_scenegraph.size
		prev_scenegraph_position = prev_scenegraph.position
	end

	local page = self._pages[self._active_page_number]
	local max_area_height = CharacterAppearanceViewSettings.area_grid_size[2]
	local area_height = max_area_height
	local description_text_size = 0

	if page.description then
		if index == 1 then
			local size = self:_get_text_size(page.description, "list_description_style")
			local scenegraph = self._ui_scenegraph[grid_start_name .. "area"]
			local text_margin = 15
			description_text_size = size[2] + text_margin * 2
			prev_scenegraph_position = {
				0,
				description_text_size
			}
			area_height = max_area_height - description_text_size

			self:_set_scenegraph_position(grid_start_name .. "area", 0, description_text_size + area_1_mask_margin[2])
			self:_set_scenegraph_size("list_description", nil, description_text_size)
			self:_set_scenegraph_size(grid_start_name .. "area", scenegraph.size[1], area_height - area_1_mask_margin[2] * 2)
			self:_set_scenegraph_size(grid_start_name .. "scrollbar", nil, area_height - scrollbar_diff)
			self:_set_scenegraph_position(grid_start_name .. "scrollbar", nil, area_1_mask_margin[2])
			self:_set_scenegraph_size(grid_start_name .. "mask", scenegraph.size[1] + area_1_mask_margin[1], area_height)
			self:_set_scenegraph_position(grid_start_name .. "content_pivot", 10, nil)
		elseif index == 2 then
			prev_scenegraph_position[2] = 0
		end
	elseif index == 1 then
		local scenegraph = self._ui_scenegraph[grid_start_name .. "area"]

		self:_set_scenegraph_size("list_description", nil, 0)
		self:_set_scenegraph_position(grid_start_name .. "area", 0, 15)
		self:_set_scenegraph_size(grid_start_name .. "area", scenegraph.size[1], max_area_height - area_1_mask_margin[2] * 2)
		self:_set_scenegraph_size(grid_start_name .. "scrollbar", nil, max_area_height - scrollbar_diff)
		self:_set_scenegraph_position(grid_start_name .. "scrollbar", nil, area_1_mask_margin[2])
		self:_set_scenegraph_size(grid_start_name .. "mask", scenegraph.size[1] + area_1_mask_margin[1], max_area_height)
		self:_set_scenegraph_position(grid_start_name .. "content_pivot", 10, nil)
	else
		self:_set_scenegraph_position(grid_start_name .. "content_pivot", 0, nil)

		if index == 2 then
			local margin = 40
			scenegraph_spacing = {
				65,
				self._ui_scenegraph.list_pivot.position[2] + margin
			}
		elseif index > 2 then
			scenegraph_spacing[2] = prev_scenegraph_position[2]
			added_spacing = scenegraph_spacing[1]
		end
	end

	local grid_height = max_area_height

	if grid_template == "icon" or grid_template == "icon_small" or grid_template == "slot_icon" then
		spacing = {
			10,
			10
		}
		local max_num_columns = 3
		local total_widgets = num_widgets

		if grid_template == "icon_small" then
			max_num_columns = 2
		end

		local background_margin = 80
		grid_height = self._ui_scenegraph.list_background.size[2] - background_margin
		local widgets_total_height = total_widgets * size[2]
		local required_columns = math.ceil(widgets_total_height / grid_height)
		total_columns = math.min(required_columns, max_num_columns)
		local widgets_per_column = math.floor(total_widgets / total_columns)
		local remaining_widgets = total_widgets % total_columns
		max_widgets_per_column = widgets_per_column + math.ceil(remaining_widgets / total_columns)

		if grid_height < max_widgets_per_column then
			using_scrollbar = true
			grid_visible_widgets = grid_height
		else
			grid_visible_widgets = max_widgets_per_column
		end
	end

	local calculated_height = grid_visible_widgets * size[2] + grid_visible_widgets * spacing[2]
	local scenegraph_height = math.min(calculated_height, grid_height)
	local scenegraph_width = total_columns * size[1] + (total_columns - 1) * spacing[1]
	local scenegraph_x = prev_scenegraph_position[1] + prev_scenegraph_size[1] + scenegraph_spacing[1]
	local scenegraph_y = scenegraph_spacing[2]
	local grid_scenegraph = grid_start_name .. "area"
	local grid_content_scenegraph = grid_start_name .. "content_pivot"

	self:_set_scenegraph_position(grid_start_name .. "area", scenegraph_x, scenegraph_y)
	self:_set_scenegraph_size(grid_start_name .. "interaction", scenegraph_width, scenegraph_height)

	if index > 1 then
		scenegraph_y = scenegraph_y or 0

		self:_set_scenegraph_position(grid_start_name .. "area", scenegraph_x, scenegraph_y)
		self:_set_scenegraph_size(grid_scenegraph, scenegraph_width, scenegraph_height)
		self:_set_scenegraph_size(grid_start_name .. "scrollbar", nil, scenegraph_height)
		self:_set_scenegraph_size(grid_start_name .. "mask", scenegraph_width + mask_margin[1], scenegraph_height + mask_margin[2])
	else
		self:_set_scenegraph_position(grid_start_name .. "area", scenegraph_x - 60, scenegraph_y)

		local height = math.min(CharacterAppearanceViewSettings.area_grid_size[2], description_text_size + scenegraph_height + 20)

		self:_set_scenegraph_size("list_background", scenegraph_width, height)
	end

	local visible_index = 0

	for i = 1, #options do
		local option = options[i]

		if option.visibility_function and option.visibility_function() == true or not option.visibility_function then
			visible_index = visible_index + 1
			local option_pass_template = pass_template
			local option_size = size
			local option_init = init
			local option_template_type = template_type

			if entry.no_option and i == 1 then
				option_template_type = "icon"
				local template = ContentBlueprints.blueprints[option_template_type]
				option_pass_template = template.pass_template
				option_size = template.size
				option_init = template.init
			end

			local widget_definition = UIWidget.create_definition(option_pass_template, grid_start_name .. "content_pivot", nil, option_size)
			local name = grid_start_name .. "option_" .. i
			local widget = self:_create_widget(name, widget_definition)
			widget.content.slot_name = entry.slot_name
			widget.content.entry = option
			widget.index = visible_index
			local element_selected = focused_value and focused_value == option.value
			widget.content.element_selected = element_selected
			widget.content.visible = false
			local icon_texture = option.icon_texture

			if entry.no_option and i == 1 then
				local icon_texture = "content/ui/textures/icons/appearances/no_option"
				widget.content.icon_texture = icon_texture
			elseif option_template_type == "icon" and not icon_texture then
				local count = entry.no_option and i - 1 or i
				local icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", count)
				widget.content.icon_texture = icon_texture
			elseif entry.template == "icon" then
				widget.content.icon_texture = icon_texture
			end

			widget.content.icon_background = entry.icon_background

			if option_init then
				option_init(self, widget, entry, option, index, "_on_entry_pressed")
			end

			if option.should_present_option and option.should_present_option.reason then
				local reason = option.should_present_option.reason
				local choice_info = choices_presentation[reason]
				widget.alpha_multiplier = option.should_present_option.should_present_option == false and 0.5 or 1
				widget.content.use_choice_icon = true
				widget.style.choice_icon.material_values = {
					texture_map = choice_info.icon_texture
				}

				if focused_value == option.value then
					self:_check_widget_choice_detail_visibility(widget)
				end
			end

			widget.loads_icon = option_template_type == "slot_icon"
			widgets[#widgets + 1] = widget
			alignment_list[#alignment_list + 1] = widget
		end
	end

	local grid = UIWidgetGrid:new(widgets, alignment_list, ui_scenegraph, grid_scenegraph, direction, spacing)
	local scrollbar_widget = self._widgets_by_name[grid_start_name .. "scrollbar"]

	grid:assign_scrollbar(scrollbar_widget, grid_content_scenegraph, grid_scenegraph)
	grid:set_scrollbar_progress(0)
	grid:set_scroll_step_length(size[2])

	self._page_grids[index] = {
		can_navigate = true,
		offset = true,
		widgets = widgets,
		grid = grid,
		support_widgets = support_widgets,
		max_widgets_per_column = max_widgets_per_column,
		num_columns = total_columns,
		using_scrollbar = using_scrollbar,
		entry = entry
	}

	self:_update_appearance_background(added_spacing)

	self._updated_scenegraph = true
end

CharacterAppearanceView._should_present_option = function (self, option)
	if type(option.value) ~= "table" then
		return {
			should_present_option = true
		}
	end

	local should_present_option = true
	local profile = self._character_create:profile()
	local reason, display_name = nil
	local options_to_validate = {
		{
			value_table = option.value.breeds,
			profile_choice = profile.breed
		},
		{
			value_table = option.value.genders,
			profile_choice = profile.gender
		},
		{
			value_table = option.value.archetypes,
			profile_choice = profile.archetype.name
		}
	}

	for i = 1, #options_to_validate do
		local option_to_validation = options_to_validate[i]
		local value_table = option_to_validation.value_table
		local profile_choice = option_to_validation.profile_choice
		local result = self:_is_option_valid(value_table, profile_choice)

		if result == false then
			should_present_option = result

			break
		end
	end

	if should_present_option == true then
		local backstory_options_to_validate = {
			{
				choice_name = "home_planet",
				value_table = option.value.home_planets,
				profile_choice = profile.lore.backstory.planet,
				reference = HomePlanets
			},
			{
				choice_name = "childhood",
				value_table = option.value.childhoods,
				profile_choice = profile.lore.backstory.childhood,
				reference = Childhood
			},
			{
				choice_name = "growing_up",
				value_table = option.value.upbringings,
				profile_choice = profile.lore.backstory.growing_up,
				reference = GrowingUp
			},
			{
				choice_name = "formative_event",
				value_table = option.value.formative_events,
				profile_choice = profile.lore.backstory.formative_event,
				reference = FormativeEvent
			}
		}
		should_present_option = nil

		for i = 1, #backstory_options_to_validate do
			local option_to_validation = backstory_options_to_validate[i]
			local result = self:_is_backstory_option_valid(option_to_validation)

			if result then
				should_present_option = result.is_option_valid
				reason = result.reason
				display_name = result.display_name
			end
		end
	end

	if should_present_option == nil then
		should_present_option = true
	end

	return {
		should_present_option = should_present_option,
		reason = reason,
		display_name = display_name
	}
end

CharacterAppearanceView._is_option_valid = function (self, value_table, profile_choice)
	if not value_table then
		return true
	end

	if #value_table == 0 then
		return true
	end

	local is_option_valid = false

	for i = 1, #value_table do
		local value = value_table[i]

		if profile_choice == value then
			is_option_valid = true

			break
		end
	end

	return is_option_valid
end

CharacterAppearanceView._is_backstory_option_valid = function (self, values)
	if not values.value_table then
		return nil
	end

	if #values.value_table == 0 then
		return nil
	end

	local is_option_valid = false
	local reason = values.choice_name
	local display_name = ""

	for i = 1, #values.value_table do
		local value = values.value_table[i]

		if value then
			is_option_valid = values.profile_choice == value
			display_name = values.reference[value].display_name

			break
		end
	end

	return {
		is_option_valid = is_option_valid,
		reason = reason,
		display_name = display_name
	}
end

CharacterAppearanceView._zoom_camera = function (self)
	local slot_name = nil

	if self._camera_zoomed then
		slot_name = nil
	else
		slot_name = "slot_body_face"
	end

	self:_set_camera(slot_name, self._gear_visible)
end

CharacterAppearanceView._is_camera_zoomed = function (self, camera_focus)
	return camera_focus == "slot_body_face"
end

CharacterAppearanceView._set_camera_height_option = function (self, camera_focus, gear_visible)
	self:_set_camera(camera_focus, gear_visible, true)

	self._disable_zoom = true
	local world_spawner = self._world_spawner
	local time = 1
	local func_ptr = math.easeOutCubic
	local boxed_camera_start_position = world_spawner:boxed_camera_start_position()
	local default_camera_world_position = Vector3.from_array(boxed_camera_start_position)
	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype.name

	if selected_archetype == "ogryn" then
		world_spawner:set_camera_position_axis_offset("y", default_camera_world_position.y + 2.8, time, func_ptr)
		world_spawner:set_camera_position_axis_offset("x", default_camera_world_position.x + 2.6, time, func_ptr)
	else
		world_spawner:set_camera_position_axis_offset("y", default_camera_world_position.y - 0.5, time, func_ptr)
	end
end

CharacterAppearanceView._set_camera = function (self, camera_focus, gear_visible, no_height_compensation, time)
	self._disable_zoom = false
	self._gear_visible = gear_visible

	self._character_create:set_gear_visible(gear_visible)

	local slot_camera_unit = self._camera_by_slot_id[camera_focus]
	self._focus_camera_unit = slot_camera_unit
	local world_spawner = self._world_spawner
	local time = time or 1
	local func_ptr = math.easeOutCubic
	local is_camera_zoomed = self:_is_camera_zoomed(camera_focus)
	local camera_zoom_changed = self._camera_zoomed ~= is_camera_zoomed
	local profile = self._character_create:profile()
	local archetype_settings = profile.archetype
	local archetype_name = archetype_settings.name

	if camera_zoom_changed then
		local animations_per_archetype = CharacterAppearanceViewSettings.animations_per_archetype
		local animations_settings = animations_per_archetype[archetype_name]
		local animation_event = nil

		if is_camera_zoomed then
			animation_event = animations_settings.events.head
		else
			animation_event = animations_settings.events.body
		end

		self._profile_spawner:assign_animation_event(animation_event)

		self._camera_zoomed = is_camera_zoomed
	end

	local boxed_camera_start_position = world_spawner:boxed_camera_start_position()
	local default_camera_world_position = Vector3.from_array(boxed_camera_start_position)
	local boxed_camera_start_rotation = world_spawner:boxed_camera_start_rotation()
	local default_camera_world_rotation = boxed_camera_start_rotation:unbox()
	local target_world_position = slot_camera_unit and Unit.world_position(slot_camera_unit, 1) or default_camera_world_position
	local target_world_rotation = slot_camera_unit and Unit.world_rotation(slot_camera_unit, 1) or default_camera_world_rotation
	local camera_world_position = default_camera_world_position
	local camera_world_rotation = default_camera_world_rotation

	world_spawner:set_camera_position_axis_offset("x", target_world_position.x - camera_world_position.x, time, func_ptr)
	world_spawner:set_camera_position_axis_offset("y", target_world_position.y - camera_world_position.y, time, func_ptr)

	if no_height_compensation then
		world_spawner:set_camera_position_axis_offset("z", target_world_position.z - camera_world_position.z, time, func_ptr)
	else
		local head_position = self._profile_spawner:node_world_position("j_head")
		local model_height_difference = archetype_name == "ogryn" and -0.2 or 0

		if head_position then
			local head_world_position = head_position and Vector3.to_array(head_position) or target_world_position
			local spawn_position = self._spawn_point_position
			local head_z_position = head_world_position[3] - spawn_position[3]
			model_height_difference = head_z_position - self._default_head_z_position
		end

		world_spawner:set_camera_position_axis_offset("z", target_world_position.z + model_height_difference - camera_world_position.z, time, func_ptr)
	end

	local camera_world_rotation_x, camera_world_rotation_y, camera_world_rotation_z = Quaternion.to_euler_angles_xyz(camera_world_rotation)
	local target_world_rotation_x, target_world_rotation_y, target_world_rotation_z = Quaternion.to_euler_angles_xyz(target_world_rotation)

	world_spawner:set_camera_rotation_axis_offset("x", target_world_rotation_x - camera_world_rotation_x, time, func_ptr)
	world_spawner:set_camera_rotation_axis_offset("y", target_world_rotation_y - camera_world_rotation_y, time, func_ptr)
	world_spawner:set_camera_rotation_axis_offset("z", target_world_rotation_z - camera_world_rotation_z, time, func_ptr)
end

CharacterAppearanceView.draw = function (self, dt, t, input_service, layer)
	self:_draw_grid(dt, t, input_service)
	CharacterAppearanceView.super.draw(self, dt, t, input_service, layer)
end

CharacterAppearanceView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	CharacterAppearanceView.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	local page_indicator_widgets = self._page_indicator_widgets

	if #page_indicator_widgets > 0 then
		for i = 1, #page_indicator_widgets do
			local widget = page_indicator_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local errors_widgets = self._name_input_errors_widgets

	if errors_widgets and #errors_widgets > 0 then
		for i = 1, #errors_widgets do
			local widget = errors_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local reward_widgets = self._reward_widgets

	if reward_widgets and #reward_widgets > 0 then
		for i = 1, #reward_widgets do
			local widget = reward_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local planet_widgets = self._planet_widgets

	if planet_widgets and #planet_widgets > 0 then
		for i = 1, #planet_widgets do
			local widget = planet_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local page_widgets = self._page_widgets

	if page_widgets and #page_widgets > 0 then
		for i = 1, #page_widgets do
			local widget = page_widgets[i]

			UIWidget.draw(widget, ui_renderer)

			if widget.content.template_type then
				local template = ContentBlueprints.blueprints[widget.content.template_type]

				if template and template.update then
					template.update(self, widget)
				end
			end
		end
	end
end

CharacterAppearanceView._draw_grid = function (self, dt, t, input_service)
	local render_settings = self._render_settings
	local ui_scenegraph = self._ui_scenegraph

	for i = 1, #self._page_grids do
		local page_grid = self._page_grids[i]
		local grid = page_grid.grid
		local widgets = page_grid.widgets
		local support_widgets = page_grid.support_widgets
		local offset = page_grid.offset

		UIRenderer.begin_pass(self._ui_renderer, ui_scenegraph, input_service, dt, render_settings)

		if support_widgets then
			for i = 1, #support_widgets do
				local widget = support_widgets[i]

				UIWidget.draw(widget, self._ui_renderer)
			end
		end

		if widgets and not offset then
			for i = 1, #widgets do
				local widget = widgets[i]

				if grid and grid:is_widget_visible(widget) then
					UIWidget.draw(widget, self._ui_renderer)
				elseif not grid then
					UIWidget.draw(widget, self._ui_renderer)
				end
			end
		end

		UIRenderer.end_pass(self._ui_renderer)
		UIRenderer.begin_pass(self._offscreen_renderer, ui_scenegraph, input_service, dt, render_settings)

		if widgets and offset then
			for i = 1, #widgets do
				local widget = widgets[i]

				if grid and grid:is_widget_visible(widget) then
					UIWidget.draw(widget, self._offscreen_renderer)
				elseif not grid then
					UIWidget.draw(widget, self._offscreen_renderer)
				end
			end
		end

		UIRenderer.end_pass(self._offscreen_renderer)
	end
end

CharacterAppearanceView._event_profile_sync_changed = function (self, is_active)
	self:_show_loading_character(is_active)
end

CharacterAppearanceView._show_loading_character = function (self, is_active)
	self._loading_overlay_visible = is_active

	if is_active then
		self._widgets_by_name.loading_overlay.content.text = ""
	end

	self._widgets_by_name.loading_overlay.content.visible = is_active
end

CharacterAppearanceView._show_loading_awaiting_validation = function (self, is_active)
	self._loading_overlay_visible = is_active

	if is_active then
		self._widgets_by_name.loading_overlay.content.text = Localize("loc_character_create_await_validation")
	end

	self._widgets_by_name.loading_overlay.content.visible = is_active
end

CharacterAppearanceView.update = function (self, dt, t, input_service)
	if self.closing_view then
		return
	end

	if self._loading_overlay_visible == true then
		input_service = input_service:null_service()
	end

	local page = self._pages[self._active_page_number]

	self:_sync_profile_changes()

	if self._profile_spawner then
		self._profile_spawner:update(dt, t, input_service)

		local is_spawned = self._profile_spawner:spawned()

		if is_spawned and self._character_spawned_next_frame then
			self._character_spawned_next_frame = false

			self:_show_loading_character(false)
		elseif page.show_character and not is_spawned and not self._character_spawned_next_frame and not self._loading_overlay_visible then
			self:_show_loading_character(true)
		end

		if page.show_character and not self._is_character_showing and is_spawned then
			local original_scale = self._profile_spawner:character_scale()
			local profile_height = self._character_create:height()
			local head_world_position = Vector3.to_array(self._profile_spawner:node_world_position("j_head"))
			local spawn_position = self._spawn_point_position
			local default_head_z_position = head_world_position[3] - spawn_position[3]
			local starting_scale_diff = 1 + 1 - original_scale[3]
			self._default_head_z_position = default_head_z_position * starting_scale_diff

			self:_set_character_height(profile_height)

			self._is_character_showing = true
			self._character_spawned_next_frame = true
			self._height_changed = true
		end
	end

	if not page.show_character and self._is_character_showing then
		self._is_character_showing = false
	end

	if self._updated_scenegraph then
		self._updated_scenegraph = false
	else
		local icons_visual_margin = CharacterAppearanceViewSettings.icons_visual_margin

		for i = 1, #self._page_grids do
			local grid = self._page_grids[i].grid

			if grid then
				grid:update(dt, t)

				local widgets = self._page_grids[i].widgets
				local interaction_widget = self._widgets_by_name["grid_" .. i .. "_interaction"]
				local is_grid_hovered = not self._using_cursor_navigation or interaction_widget.content.hotspot.is_hover or false
				local update_visible_icon_prioritization_load = false

				for j = 1, #widgets do
					local widget = widgets[j]
					local content = widget.content
					local visible = grid:is_widget_visible(widget)
					local render_icon = grid:is_widget_visible(widget, icons_visual_margin)
					local previously_visible = content.visible
					content.visible = visible
					content.render_icon = render_icon or visible

					if visible and not previously_visible then
						update_visible_icon_prioritization_load = true
					end

					if not render_icon and widget.loads_icon and content.icon_load_id then
						self:_unload_appearance_icon(widget)
					elseif render_icon and widget.loads_icon and not content.icon_load_id then
						local prioritized = visible

						self:_load_appearance_icon(widget, prioritized)
					end

					if content.hotspot then
						content.hotspot.force_disabled = not is_grid_hovered
					end
				end

				if update_visible_icon_prioritization_load then
					local prioritized = true

					for j = #widgets, 1, -1 do
						local widget = widgets[j]
						local content = widget.content
						local visible = content.visible

						if visible and widget.loads_icon and content.icon_load_id then
							self:_update_load_appearance_icon_priority(widget, prioritized)
						end
					end
				end
			end
		end
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(CharacterAppearanceViewTestify, self)
	end

	local continue_disabled = false

	if self._block_continue then
		for page_index, entries in pairs(self._block_continue) do
			if page_index == self._active_page_number then
				for i = 1, #entries do
					local entry = entries[i]

					if self._active_page_number == 5 and self._page_grids[1] and self._page_grids[1].widgets and self._page_grids[1].widgets[i] then
						self._page_grids[1].widgets[i].content.show_warning = entry
					elseif self._active_page_number == 6 and self._page_grids[1] and self._page_grids[1].widgets and self._page_grids[1].widgets[i] then
						self._page_grids[1].widgets[i].content.show_warning = entry
					end

					if entry == true then
						continue_disabled = true
					end
				end

				break
			end
		end
	end

	self._widgets_by_name.continue_button.content.hotspot.disabled = continue_disabled
	local world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(world)

	if self._current_sound_id and WwiseWorld.is_playing(wwise_world, self._current_sound_id) then
		self._current_progress = ContentBlueprints.pulse_animations.update(dt, self._current_progress, self._current_sound_widget)
	elseif self._current_sound_id and not WwiseWorld.is_playing(wwise_world, self._current_sound_id) then
		self._current_sound_id = nil
		self._current_progress = 0
		self._current_sound_widget.content.audio_playing = false
		self._current_sound_widget = nil
	end

	if self._set_camera_next_frame then
		local selected_index = nil

		for i = 1, #self._page_grids[1].widgets do
			local widget = self._page_grids[1].widgets[i]

			if widget.content.element_selected then
				selected_index = i

				break
			end
		end

		local camera_focus, gear_visible = nil
		local page = self._pages[self._active_page_number]

		if selected_index then
			camera_focus = page.content.options[selected_index].camera_focus
			gear_visible = page.content.options[selected_index].gear_visible
		else
			camera_focus = page.camera_focus
			gear_visible = page.gear_visible
		end

		self:_set_camera(camera_focus, gear_visible, nil, 0)

		self._set_camera_next_frame = nil
	end

	if self._height_changed then
		self._height_changed = false
		self._set_camera_next_frame = true
	end

	return CharacterAppearanceView.super.update(self, dt, t, input_service)
end

CharacterAppearanceView._on_entry_pressed = function (self, current_widget, option, grid_index)
	if self._current_sound_id then
		local world = Managers.ui:world()
		local wwise_world = Managers.world:wwise_world(world)

		WwiseWorld.stop_event(wwise_world, self._current_sound_id)
	end

	if self._active_page_number == 1 then
		self:_play_sound(UISoundEvents.character_create_planet_select)
	else
		self:_play_sound(UISoundEvents.character_appearence_option_pressed)
	end

	for i = 1, #self._page_grids[grid_index].widgets do
		local widget = self._page_grids[grid_index].widgets[i]
		widget.content.element_selected = current_widget.index == i
	end

	if self._using_cursor_navigation then
		self:_update_current_navigation_position(grid_index, current_widget.index)
	end

	self:_check_widget_choice_detail_visibility(current_widget)

	local on_pressed_function = option.on_pressed_function

	if on_pressed_function then
		on_pressed_function(current_widget)
	end
end

CharacterAppearanceView._check_widget_choice_detail_visibility = function (self, widget)
	if widget and widget.content.entry.should_present_option and widget.content.entry.should_present_option.should_present_option == true and widget.content.entry.should_present_option.reason then
		local reason = widget.content.entry.should_present_option.reason
		local choice_info = choices_presentation[reason]
		self._widgets_by_name.choice_detail.content.visible = true
		self._widgets_by_name.choice_detail.content.use_choice_icon = true
		self._widgets_by_name.choice_detail.style.choice_icon.material_values = {
			texture_map = choice_info.icon_texture
		}
		self._widgets_by_name.choice_detail.content.text = Localize("loc_character_create_choice_reason", true, {
			description = Localize(choice_info.description),
			choice = Localize(widget.content.entry.should_present_option.display_name)
		})
		self._widgets_by_name.choice_detail.content.available = true
	elseif widget and widget.content.entry.should_present_option and widget.content.entry.should_present_option.should_present_option == false and widget.content.entry.should_present_option.reason then
		local reason = widget.content.entry.should_present_option.reason
		local choice_info = choices_presentation[reason]
		self._widgets_by_name.choice_detail.content.visible = true
		self._widgets_by_name.choice_detail.content.use_choice_icon = true
		self._widgets_by_name.choice_detail.style.choice_icon.material_values = {
			texture_map = choice_info.icon_texture
		}
		self._widgets_by_name.choice_detail.content.text = Localize("loc_character_create_choice_reason", true, {
			description = Localize(choice_info.description),
			choice = Localize(widget.content.entry.should_present_option.display_name)
		})
		self._widgets_by_name.choice_detail.content.available = false
	elseif self._widgets_by_name.choice_detail.content.visible == true then
		self._widgets_by_name.choice_detail.content.visible = false
	end
end

CharacterAppearanceView._on_navigation_input_changed = function (self)
	CharacterAppearanceView.super._on_navigation_input_changed(self)
	self:_handle_continue_button_text()

	if self._page_widgets then
		local randomize_button_widget = self:_create_randomize_button()
		self._page_widgets[2] = randomize_button_widget

		self:_update_final_page_text()
	end

	local current_grid_index = self._navigation.grid
	local current_widget_index = self._navigation.index
	local current_widget = self._page_grids[current_grid_index] and self._page_grids[current_grid_index].widgets and self._page_grids[current_grid_index].widgets[current_widget_index]
	local current_widget_hotspot = current_widget and current_widget.content.hotspot

	if current_widget_hotspot and self._using_cursor_navigation then
		current_widget_hotspot.is_focused = false
	elseif current_widget_hotspot and not self._using_cursor_navigation then
		current_widget_hotspot.is_focused = true
	end
end

CharacterAppearanceView._update_current_navigation_position = function (self, grid_index, widget_index)
	local current_grid_index = self._navigation.grid
	local current_widget_index = self._navigation.index
	local current_widget = self._page_grids[current_grid_index] and self._page_grids[current_grid_index].widgets and self._page_grids[current_grid_index].widgets[current_widget_index]
	local new_widget = self._page_grids[grid_index] and self._page_grids[grid_index].widgets and self._page_grids[grid_index].widgets[widget_index]

	if not self._using_cursor_navigation and new_widget then
		local grid = self._page_grids[grid_index].grid
		local widget_height = new_widget.content.size[2]
		local total_widgets = #self._page_grids[grid_index].widgets
		local is_visible = grid:is_widget_visible(new_widget, -widget_height)

		if not is_visible then
			local current_scrollbar_progress = grid:scrollbar_progress()
			local spacing = grid:get_spacing()
			local scroll_height = grid:scroll_length()
			local area_height = grid:area_length()
			local num_columns = self._page_grids[grid_index].num_columns
			local inverse = current_widget_index and widget_index < current_widget_index
			local new_row = nil
			new_row = widget_index % num_columns == 0 and inverse and math.floor(widget_index / num_columns) - 1 or not inverse and total_widgets < widget_index + num_columns and math.ceil(widget_index / num_columns) + 1 or inverse and math.floor(widget_index / num_columns) or math.ceil(widget_index / num_columns)
			local top_position = scroll_height * current_scrollbar_progress
			local bottom_position = top_position + area_height
			local visible_height = inverse and top_position or bottom_position
			local widget_height_position = new_row * widget_height + spacing[2] * new_row
			local progress = widget_height_position - visible_height
			local scrollbar_progress = current_scrollbar_progress + progress / scroll_height

			grid:focus_grid_index(widget_index, scrollbar_progress, true)
		else
			grid:focus_grid_index(widget_index)
		end
	end

	if current_grid_index ~= grid_index then
		if current_widget and current_widget.content.hotspot then
			current_widget.content.hotspot.is_focused = false
		end

		if self._page_grids[current_grid_index] and self._page_grids[current_grid_index].entry and self._page_grids[current_grid_index].entry.leave then
			local page = self._page_grids[current_grid_index]

			self._page_grids[current_grid_index].entry.leave(page)
		end

		if self._page_grids[grid_index] and self._page_grids[grid_index].entry and self._page_grids[grid_index].entry.enter then
			local page = self._page_grids[grid_index]

			self._page_grids[grid_index].entry.enter(page)
		end
	end

	self._navigation = {
		index = widget_index,
		grid = grid_index
	}
end

CharacterAppearanceView._update_load_appearance_icon_priority = function (self, widget, prioritized)
	local material_values = widget.style.texture.material_values
	local content = widget.content

	if material_values.use_placeholder_texture ~= 0 then
		local icon_profile = content.icon_profile

		Managers.ui:update_player_appearance(icon_profile, prioritized)
	end
end

CharacterAppearanceView._load_appearance_icon = function (self, widget, prioritized)
	local profile = table.clone_instance(self._character_create:profile())

	self._character_create.set_item_per_slot_preview(self._character_create, widget.content.slot_name, widget.content.entry.value, profile)

	local cb = callback(self, "_set_player_icon", widget)
	profile.character_id = widget.index
	local icon_load_id = Managers.ui:load_appearance_portrait(profile, cb, nil, prioritized)
	widget.content.icon_load_id = icon_load_id
	widget.content.icon_profile = profile
end

CharacterAppearanceView._update_appearance_icon = function (self)
	for i = 1, #self._page_grids do
		local grid = self._page_grids[i]

		for j = 1, #grid.widgets do
			local widget = grid.widgets[j]

			if widget.content.icon_load_id then
				local profile = table.clone_instance(self._character_create:profile())

				self._character_create.set_item_per_slot_preview(self._character_create, widget.content.slot_name, widget.content.entry.value, profile)

				profile.character_id = j

				Managers.event:trigger("event_player_appearance_updated", profile)
			end
		end
	end
end

CharacterAppearanceView._unload_appearance_icon = function (self, widget)
	Managers.ui:unload_appearance_portrait(widget.content.icon_load_id)

	widget.content.icon_load_id = nil
	widget.content.icon_profile = nil
	local material_values = widget.style.texture.material_values
	material_values.use_placeholder_texture = 1
end

CharacterAppearanceView._unload_all_appearance_icons = function (self)
	for i = 1, #self._page_grids do
		local grid = self._page_grids[i]

		for j = 1, #grid.widgets do
			local widget = grid.widgets[j]

			if widget.content.icon_load_id then
				self:_unload_appearance_icon(widget)
			end
		end
	end
end

CharacterAppearanceView._set_player_icon = function (self, widget, grid_index, rows, columns, render_target)
	local material_values = widget.style.texture.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

CharacterAppearanceView._create_page_indicators = function (self)
	for i = 1, #self._page_indicator_widgets do
		local widget = self._page_indicator_widgets[i]

		self:_unregister_widget_name(widget.name)
	end

	local num_pages = #self._pages

	if num_pages < 2 then
		self._widgets_by_name.page_indicator_frame.content.visible = false

		return
	else
		self._widgets_by_name.page_indicator_frame.content.visible = true
	end

	local page_indicator_widgets = {}
	local width = 15
	local spacing = 10
	local total_width = 0
	local definitions = self._definitions
	local page_indicator_definition = UIWidget.create_definition(ButtonPassTemplates.page_indicator_terminal, "page_indicator", nil, {
		20,
		20
	})

	for i = 1, num_pages do
		local name = "page_indicator_" .. i
		local widget = self:_create_widget(name, page_indicator_definition)
		widget.offset[1] = width * (i - 1) + spacing * i
		widget.offset[3] = 50
		page_indicator_widgets[i] = widget
	end

	if num_pages > 0 then
		total_width = page_indicator_widgets[num_pages].offset[1] + width + spacing

		self:_set_scenegraph_size("page_indicator", total_width, nil)

		self._page_indicator_widgets = page_indicator_widgets
	end
end

CharacterAppearanceView._on_close_pressed = function (self)
	local world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.stop_event(wwise_world, self._current_sound_id)
	self:_play_sound(UISoundEvents.character_create_abort)

	if self._backstory_selection_page then
		self._backstory_selection_page.leave(true)
		self:_open_page(self._active_page_number)
	elseif self._using_cursor_navigation == false and self._navigation.grid > 1 and self._active_page_number == 5 then
		for i = 1, #self._page_grids[1].widgets do
			local widget = self._page_grids[1].widgets[i]

			if widget.content.element_selected == true then
				self:_update_current_navigation_position(1, i)

				break
			end
		end
	elseif self._active_page_number > 1 then
		local previous_index = self._active_page_number - 1

		self:_open_page(previous_index)
	else
		Managers.event:trigger("event_create_new_character_back")
	end
end

CharacterAppearanceView._destroy_renderer = function (self)
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

CharacterAppearanceView._destroy_background = function (self)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end
end

CharacterAppearanceView.on_exit = function (self)
	CharacterAppearanceView.super.on_exit(self)
	self:_unload_all_appearance_icons()
	self:_destroy_background()
	self:_destroy_renderer()
	self._character_create:set_name("")
	Managers.event:unregister(self, "update_character_sync_state")
end

CharacterAppearanceView._set_selected_backstory = function (self)
	if not self._backstory_selection then
		return
	end

	local action = self._backstory_selection.action
	local settings = self._backstory_selection.settings
	local option = self._backstory_selection.option

	self._character_create[action](self._character_create, option)

	if action == "set_planet" then
		self:_randomize_character_backstory()
	end

	self._backstory_selection = nil
end

CharacterAppearanceView._populate_backstory_info = function (self, settings)
	if not self._page_grids[2] or self._page_grids[2] and #self._page_grids[2].widgets == 0 then
		local widgets = {}

		for name, definition in pairs(Definitions.choice_descriptions_definitions) do
			local name = name
			local widget = self:_create_widget(name, definition)
			widgets[#widgets + 1] = widget
		end

		self._page_grids[2] = {
			widgets = widgets
		}
	end

	self:_generate_reward_widgets()

	local widget_definitions = {
		background = UIWidget.create_definition({
			{
				value_id = "background",
				style_id = "background",
				pass_type = "texture",
				value = "content/ui/materials/backgrounds/terminal_basic",
				style = {
					vertical_alignment = "top",
					scale_to_material = true,
					horizontal_alignment = "center",
					color = Color.terminal_grid_background(nil, true),
					size_addition = {
						10,
						30
					},
					offset = {
						0,
						-15,
						0
					}
				}
			},
			{
				value_id = "top_frame",
				style_id = "top_frame",
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_upper",
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "center",
					size = {
						nil,
						36
					},
					offset = {
						0,
						-18,
						1
					}
				}
			},
			{
				value = "content/ui/materials/dividers/horizontal_frame_big_lower",
				pass_type = "texture",
				style = {
					vertical_alignment = "bottom",
					horizontal_alignment = "center",
					size = {
						nil,
						36
					},
					offset = {
						0,
						18,
						1
					}
				}
			}
		}, "backstory_selection_pivot_background")
	}
	local support_widgets = {}

	for name, definition in pairs(widget_definitions) do
		local name = "backstory_selection_pivot_background"

		if self._widgets_by_name[name] then
			self:_unregister_widget_name(name)
		end

		support_widgets[#support_widgets + 1] = self:_create_widget(name, definition)
	end

	local option_title = self._widgets_by_name.option_title
	local option_description = self._widgets_by_name.option_description
	local option_effect_title = self._widgets_by_name.option_effect_title
	local option_effect_description = self._widgets_by_name.option_effect_description
	local effect_margin = 100
	local text_margin = 20
	local background_margin = {
		40,
		40
	}
	local content_width = 440
	local background_size = {
		content_width + background_margin[1] * 2,
		background_margin[2] * 2
	}
	option_title.content.text = Utf8.upper(Localize(settings.display_name))
	option_description.content.text = Localize(settings.description)
	option_effect_title.content.text = Localize("loc_character_title_unlocks")
	local title_font_style = option_title.style.text
	local description_font_style = option_description.style.text
	local effect_title_font_style = option_effect_title.style.text
	local title_font_style_options = UIFonts.get_font_options_by_style(title_font_style)
	local description_font_style_options = UIFonts.get_font_options_by_style(description_font_style)
	local effect_title_font_style_options = UIFonts.get_font_options_by_style(effect_title_font_style)
	local _, title_height = UIRenderer.text_size(self._ui_renderer, option_title.content.text, title_font_style.font_type, title_font_style.font_size, {
		content_width,
		0
	}, title_font_style_options)
	local _, description_height = UIRenderer.text_size(self._ui_renderer, option_description.content.text, description_font_style.font_type, description_font_style.font_size, {
		content_width,
		0
	}, description_font_style_options)
	local _, effect_title_height = UIRenderer.text_size(self._ui_renderer, option_effect_title.content.text, effect_title_font_style.font_type, effect_title_font_style.font_size, {
		content_width,
		0
	}, effect_title_font_style_options)
	option_title.style.text.size = {
		content_width,
		title_height
	}
	option_description.style.text.size = {
		content_width,
		description_height
	}
	option_effect_title.style.text.size = {
		content_width,
		effect_title_height
	}
	option_title.offset = {
		background_margin[1],
		background_margin[2],
		1
	}
	option_description.offset = {
		background_margin[1],
		background_margin[2] + title_height + text_margin,
		1
	}
	background_size[2] = background_size[2] + option_title.style.text.size[2] + option_description.style.text.size[2] + text_margin
	local show_reward_text = self._pages[self._active_page_number].show_rewards_text or true
	option_effect_title.content.visible = false
	option_effect_description.content.visible = false

	if show_reward_text and settings and settings.unlocks then
		option_effect_title.content.visible = true
		option_effect_description.content.visible = true
		local reward_height = 0
		option_effect_title.offset = {
			background_margin[1],
			background_margin[2] + option_description.style.text.offset[2] + option_description.style.text.size[2] + effect_margin,
			1
		}
		local start_pos = {
			background_margin[1],
			option_effect_title.offset[2] + 50
		}
		reward_height = self:_generate_reward_widgets(settings, start_pos, {
			content_width,
			0
		})
		background_size[2] = background_size[2] + reward_height + effect_margin
	end

	self:_set_scenegraph_size("backstory_selection_pivot_background", background_size[1], background_size[2])

	local list_width, list_height = self:_scenegraph_size("list_background")

	if list_height < background_size[2] then
		local active_page_number = self._active_page_number
		local page = self._pages[active_page_number]
		self._ui_scenegraph.backstory_selection_pivot.vertical_alignment = "top"

		self:_set_scenegraph_position("backstory_selection_pivot", nil, page.top_frame.offset[2] * 0.5)
	else
		self._ui_scenegraph.backstory_selection_pivot.vertical_alignment = "bottom"

		self:_set_scenegraph_position("backstory_selection_pivot", nil, -background_size[2])
	end

	self._page_grids[2].support_widgets = support_widgets

	self:_handle_continue_button_text()

	local choice_margin = 20
	local pos = self._ui_scenegraph.backstory_selection_pivot.position
	local list_pos = self._ui_scenegraph.list_pivot.position
	local size = self._ui_scenegraph.backstory_selection_pivot_background.size
	self._ui_scenegraph.choice_detail.vertical_alignment = self._ui_scenegraph.backstory_selection_pivot.vertical_alignment

	self:_set_scenegraph_position("choice_detail", pos[1], pos[2] + list_pos[2] + background_size[2] + choice_margin)
end

CharacterAppearanceView._generate_reward_widgets = function (self, settings, start_pos, background_size)
	if self._reward_widgets then
		for i = 1, #self._reward_widgets do
			local widget = self._reward_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._reward_widgets = nil
	end

	if not settings or not settings.unlocks then
		return 0
	end

	local widgets = {}
	local margin = 20
	local start_offset_y = 0
	local start_pos_width = start_pos and start_pos[1] or 0
	local start_pos_height = start_pos and start_pos[2] or 0

	for i = 1, #settings.unlocks do
		local unlock = settings.unlocks[i]
		local template_type = nil

		if unlock.type == "item" then
			template_type = "reward_cosmetic"
		else
			template_type = "reward_text"
		end

		local template = ContentBlueprints.blueprints[template_type]
		local pass_template = template.pass_template
		local size = template.size
		local widget_definition = UIWidget.create_definition(pass_template, "backstory_selection_pivot", nil, size)
		local name = "reward_" .. i
		local widget = self:_create_widget(name, widget_definition)

		if template.init then
			template.init(self, widget, unlock)
		end

		local text_style = widget.style.title
		local style = UIFonts.get_font_options_by_style(text_style)
		local _, text_height = UIRenderer.text_size(self._ui_renderer, Localize(unlock.text), text_style.font_type, text_style.font_size, {
			background_size[1],
			0
		}, style)
		local widget_height = math.max(size[2], text_height)
		widget.content.size[2] = widget_height
		widget.offset[1] = start_pos_width
		widget.offset[2] = start_offset_y + start_pos_height
		start_offset_y = start_offset_y + widget_height + margin
		widgets[#widgets + 1] = widget
	end

	self._reward_widgets = widgets

	return start_offset_y - margin
end

CharacterAppearanceView._get_text_size = function (self, text, style_name)
	local font_style = CharacterAppearanceViewFontStyle[style_name]
	local style = UIFonts.get_font_options_by_style(font_style)
	local width, height = UIRenderer.text_size(self._ui_renderer, text, font_style.font_type, font_style.font_size, {
		440,
		0
	}, style)

	return {
		width + 20,
		height + 20
	}
end

CharacterAppearanceView._is_backstory_option_visible = function (self, option)
	if not option.visibility then
		return true
	end

	for name, ids in pairs(option.visibility) do
		if name == "home_planet" then
			local selected_planet = self._character_create:planet()
			local selected_planet_id = HomePlanets[selected_planet].id

			for i = 1, #ids do
				local id = ids[i]

				if selected_planet_id == id then
					return true
				end
			end
		elseif name == "archetype" then
			local profile = self._character_create:profile()
			local selected_archetype = profile.archetype.name

			for i = 1, #ids do
				local id = ids[i]

				if selected_archetype == id then
					return true
				end
			end
		end
	end

	return false
end

CharacterAppearanceView._hide_pages_widgets = function (self)
	for i = 1, #self._page_indicator_widgets do
		local widget = self._page_indicator_widgets[i]
		widget.content.visible = false
	end

	self._widgets_by_name.list_background.content.visible = false
	self._widgets_by_name.list_header.content.visible = false
	self._widgets_by_name.list_description.content.visible = false
	self._widgets_by_name.page_indicator_frame.content.visible = false
	self._widgets_by_name.continue_button.content.visible = false
	self._widgets_by_name.backstory_title.content.visible = false
	self._widgets_by_name.backstory_text.content.visible = false
	self._widgets_by_name.backstory_background.content.visible = false
	self._widgets_by_name.choice_detail.content.visible = false
	self._widgets_by_name.backstory_text.alpha_multiplier = 0
end

CharacterAppearanceView._destroy_generated_widgets = function (self, start_index)
	local start_index = start_index or 1

	for i = start_index, #self._page_grids do
		local page_grid = self._page_grids[i]

		for j = 1, #page_grid.widgets do
			local widget = page_grid.widgets[j]
			local widget_name = widget.name
			local content = widget.content

			if widget.loads_icon and content.icon_load_id then
				self:_unload_appearance_icon(widget)
			end

			self:_unregister_widget_name(widget_name)
		end

		self._page_grids[i] = {
			widgets = {}
		}
	end

	self:_generate_reward_widgets()
end

CharacterAppearanceView._show_default_page = function (self, page)
	for i = 1, #self._page_indicator_widgets do
		local widget = self._page_indicator_widgets[i]
		widget.content.visible = true
	end

	local title = page.title

	if title then
		self._widgets_by_name.list_header.content.text_title = Utf8.upper(title)
	end

	local description = page.description

	if description then
		self._widgets_by_name.list_description.content.text = description
	end

	self._widgets_by_name.list_background.content.visible = true
	self._widgets_by_name.list_header.content.visible = true
	self._widgets_by_name.list_description.content.visible = not not description

	if self._pages and #self._pages >= 2 then
		self._widgets_by_name.page_indicator_frame.content.visible = true
	end

	self._widgets_by_name.continue_button.content.visible = true
end

CharacterAppearanceView._update_final_page_text = function (self)
	local planet_snippet = HomePlanets[self._character_create:planet()].story_snippet
	local childhood_snippet = Childhood[self._character_create:childhood()].story_snippet
	local growing_up_snippet = GrowingUp[self._character_create:growing_up()].story_snippet
	local formative_event_snippet = FormativeEvent[self._character_create:formative_event()].story_snippet
	local crime_snippet = Crimes[self._character_create:crime()].story_snippet
	local end_snippet = Localize("loc_character_backstory_snippet")
	local backstory_text_widget = self._widgets_by_name.backstory_text
	local backstory_title_widget = self._widgets_by_name.backstory_title
	local input_widget = self._widgets_by_name.name_input_widget
	local reference_width = self._ui_scenegraph.backstory_pivot.size[1]
	local input_widget_height = input_widget.content.size[2]
	local backstory_text = string.format([[
%s %s %s %s

%s

%s]], Localize(planet_snippet), Localize(childhood_snippet), Localize(growing_up_snippet), Localize(formative_event_snippet), Localize(crime_snippet), end_snippet)
	backstory_text_widget.content.text = backstory_text
	local text_style = backstory_text_widget.style.text
	local title_style = backstory_title_widget.style.text
	local text_font_style = UIFonts.get_font_options_by_style(text_style)
	local text_width, text_height = UIRenderer.text_size(self._ui_renderer, backstory_text, text_style.font_type, text_style.font_size, {
		reference_width,
		0
	}, text_font_style)
	backstory_text_widget.content.size = {
		reference_width,
		text_height
	}
	local margin = {
		80,
		80
	}
	local description_margin = 40
	local title_font_style = UIFonts.get_font_options_by_style(title_style)
	local title_width, title_height = UIRenderer.text_size(self._ui_renderer, backstory_title_widget.content.text, title_style.font_type, title_style.font_size, {
		reference_width,
		math.huge
	}, title_font_style)
	backstory_title_widget.content.size = {
		title_width + 10,
		title_height
	}
	input_widget.offset[2] = title_height + description_margin
	input_widget.offset[3] = 3
	self._widgets_by_name.randomize_button.offset[2] = input_widget.offset[2]
	backstory_text_widget.offset[2] = input_widget.offset[2] + input_widget_height + description_margin
	local full_height = backstory_text_widget.offset[2] + text_height

	self:_set_scenegraph_size("backstory_background", reference_width + margin[1], full_height + margin[2])
	self:_set_scenegraph_position("backstory_background", -margin[1] * 0.5, -margin[2] * 0.5)
end

CharacterAppearanceView._show_final_page = function (self, page)
	self:_create_errors_name_input()
	self:_destroy_support_page_widgets()

	for i = 1, #self._page_indicator_widgets do
		local widget = self._page_indicator_widgets[i]
		widget.content.visible = true
	end

	self._widgets_by_name.continue_button.content.visible = true
	self._widgets_by_name.page_indicator_frame.content.visible = true
	local name = "name_input_widget"
	local template_type = "name_input"
	local template = ContentBlueprints.blueprints[template_type]
	local pass_template = template.pass_template
	local size = template.size
	local widget_definition = UIWidget.create_definition(pass_template, "name_input", nil, size)
	local widget = self:_create_widget(name, widget_definition)
	local character_name = self._character_create:name()
	widget.content.template_type = template_type

	template.init(self, widget, character_name)
	self:_set_scenegraph_size("name_input", size[1], size[2])

	local randomize_button_widget = self:_create_randomize_button()
	local backstory_text_widget = self._widgets_by_name.backstory_text
	local backstory_title_widget = self._widgets_by_name.backstory_title
	local backstory_background_widget = self._widgets_by_name.backstory_background
	local playing_animation = backstory_text_widget.content.animation_id

	if playing_animation and self:_is_animation_active(playing_animation) then
		self:_complete_animation(playing_animation)

		backstory_text_widget.content.animation_id = nil
	end

	widget.alpha_multiplier = 0
	randomize_button_widget.alpha_multiplier = 0
	local params = {
		widgets = {
			backstory_text_widget,
			backstory_title_widget,
			backstory_background_widget,
			widget,
			randomize_button_widget
		}
	}
	local animation_id = self:_start_animation("on_enter", nil, params)
	backstory_text_widget.content.animation_id = animation_id
	backstory_text_widget.content.visible = true
	backstory_title_widget.content.visible = true
	backstory_background_widget.content.visible = true
	self._page_widgets = {
		widget,
		randomize_button_widget
	}

	self:_update_final_page_text()
end

CharacterAppearanceView._create_randomize_button = function (self)
	local service_type = DefaultViewInputSettings.service_type
	local text_margin = 0
	local button_margin = {
		40,
		0
	}

	if self._page_widgets then
		local widget = self._page_widgets[2]

		self:_unregister_widget_name(widget.name)

		self._page_widgets[2] = nil
	end

	local template_type = "name_input"
	local template = ContentBlueprints.blueprints[template_type]
	local size = template.size
	local randomize_button_widget = self:_create_widget("randomize_button", Definitions.randomize_button_definition)
	local show_icon = self._using_cursor_navigation
	randomize_button_widget.content.show_icon = show_icon

	if not self._using_cursor_navigation then
		local action = "hotkey_menu_special_2"
		local alias_key = Managers.ui:get_input_alias_key(action, service_type)
		local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)
		randomize_button_widget.content.text = string.format("%s %s", input_text, Localize("loc_randomize"))
	else
		randomize_button_widget.content.text = Localize("loc_randomize")
		text_margin = 15
	end

	local text_style = randomize_button_widget.style.text
	local style = UIFonts.get_font_options_by_style(text_style)
	local text_width, text_height = UIRenderer.text_size(self._ui_renderer, randomize_button_widget.content.text, text_style.font_type, text_style.font_size, {
		math.huge,
		math.huge
	}, style)
	local icon_width = show_icon and randomize_button_widget.style.icon.size[1] or 0
	randomize_button_widget.content.size[1] = text_width + button_margin[1] * 2 + text_margin + icon_width
	randomize_button_widget.style.icon.offset[1] = button_margin[1]
	randomize_button_widget.style.text.offset[1] = icon_width + button_margin[1] + text_margin
	randomize_button_widget.offset = {
		size[1] + 25,
		(size[2] - randomize_button_widget.content.size[2]) * 0.5,
		randomize_button_widget.offset[3]
	}
	randomize_button_widget.content.hotspot.pressed_callback = callback(self, "_randomize_character_name")

	return randomize_button_widget
end

CharacterAppearanceView._set_character_height = function (self, scale_factor)
	self._profile_spawner:set_character_scale(scale_factor)
	self._character_create:set_height(scale_factor)
end

CharacterAppearanceView._get_appearance_category_options = function (self, category_entry_options)
	local function on_pressed_function(function_name, value, value_key)
		local character_create = self._character_create

		if value_key then
			character_create[function_name](character_create, value_key, value)
		else
			character_create[function_name](character_create, value)
		end
	end

	local function get_value_function(function_name, value_key)
		local character_create = self._character_create

		if value_key then
			return character_create[function_name](character_create, value_key)
		else
			return character_create[function_name](character_create)
		end
	end

	local function select_eye_by_type(new_option, slot_name)
		local current_option = self._character_create.slot_item(self._character_create, slot_name)
		local current_option_type_index = get_eye_type_index_by_option(current_option)
		local current_option_type = eye_types[current_option_type_index]
		local current_option_name = current_option.material_overrides[1]

		if current_option_type.search_string then
			current_option_name = string.gsub(current_option_name, current_option_type.search_string, "")
		end

		current_option_name = string.gsub(current_option_name, "_", "")
		local new_eye_type_name = new_option.name
		local new_eye_options_by_type = self._eye_options_by_type[new_eye_type_name]
		local selected_option = nil

		for i = 1, #new_eye_options_by_type do
			local eye_option = new_eye_options_by_type[i]
			local eye_option_name = eye_option.material_overrides[1]

			if new_option.search_string then
				eye_option_name = string.gsub(eye_option_name, new_option.search_string, "")
			end

			eye_option_name = string.gsub(eye_option_name, "_", "")

			if eye_option_name == current_option_name then
				selected_option = eye_option

				break
			end
		end

		selected_option = selected_option or new_eye_options_by_type[1]

		self._character_create.set_item_per_slot(self._character_create, slot_name, selected_option)
	end

	local function get_type_by_eye(slot_name)
		local current_option = self._character_create.slot_item(self._character_create, slot_name)
		local index = get_eye_type_index_by_option(current_option)

		return eye_types[index]
	end

	local category_options = {}

	for i = 1, #category_entry_options do
		local category_entry_option = category_entry_options[i]
		local entry_type = category_entry_option.type
		local entry_options = category_entry_option.options
		local entry_slot_name = category_entry_option.slot_name
		local entry_type_template = category_entry_option.template
		local entry_type_grid_template = category_entry_option.grid_template
		local entry_no_option = category_entry_option.no_option
		local entry_icon_background = category_entry_option.icon_background
		local entry_initialized = category_entry_option.initialized
		local entry_enter = category_entry_option.enter
		local entry_leave = category_entry_option.leave
		local options = {}
		category_options[i] = {
			template = entry_type_template,
			slot_name = entry_slot_name,
			options = options,
			grid_template = entry_type_grid_template,
			enter = entry_enter,
			leave = entry_leave,
			no_option = entry_no_option,
			icon_background = entry_icon_background,
			type = entry_type,
			initialized = entry_initialized
		}

		if entry_type == "skin_color" then
			for j = 1, #entry_options do
				local option = entry_options[j]
				local skin_override = SkinMaterialOverrides[option.material_overrides[1]]
				local property_overrides = skin_override.property_overrides
				local hsv_skin = property_overrides.hsv_skin
				options[#options + 1] = {
					color = hsv_skin,
					value = option,
					on_pressed_function = function (widget)
						on_pressed_function("set_item_per_slot", option, entry_slot_name)

						local page_five = self._pages[5]

						if page_five then
							self:_check_appearance_continue_block(page_five.content)
						end

						self:_update_appearance_icon()
					end
				}
			end

			category_options[i].get_value_function = callback(get_value_function, "slot_item", entry_slot_name)
			category_options[i].texture = "content/ui/materials/icons/appearances/skin_color"
		elseif entry_type == "eye_type" then
			for j = 1, #entry_options do
				local option = entry_options[j]
				options[#options + 1] = {
					value = option,
					icon_texture = option.icon_texture,
					on_pressed_function = function (widget)
						select_eye_by_type(option, entry_slot_name)

						local page = self._pages[self._active_page_number]
						page.content = self:_get_appearance_content()
						local current_index = nil

						for k = 1, #self._page_grids[1].widgets do
							local widget = self._page_grids[1].widgets[k]

							if widget.content.element_selected == true then
								current_index = k
							end
						end

						if current_index then
							self:_open_appearance_options(current_index)
						end

						self:_update_appearance_selection()

						local page_five = self._pages[5]

						if page_five then
							self:_check_appearance_continue_block(page_five.content)
						end

						self:_update_appearance_icon()
					end
				}
			end

			category_options[i].get_value_function = callback(get_type_by_eye, entry_slot_name)
		elseif entry_type == "eye_color" then
			for j = 1, #entry_options do
				local option = entry_options[j]
				local eye_override = EyeMaterialOverrides[option.material_overrides[1]]
				local property_overrides = eye_override.property_overrides
				local hsv_eye = property_overrides.hsv_eye
				options[#options + 1] = {
					value = option,
					color = hsv_eye,
					on_pressed_function = function (widget)
						on_pressed_function("set_item_per_slot", option, entry_slot_name)

						local page_five = self._pages[5]

						if page_five then
							self:_check_appearance_continue_block(page_five.content)
						end

						self:_update_appearance_icon()
					end
				}
			end

			category_options[i].get_value_function = callback(get_value_function, "slot_item", entry_slot_name)
			category_options[i].texture = "content/ui/materials/icons/appearances/eye_color"
		elseif entry_type == "hair_color" then
			for j = 1, #entry_options do
				local option = entry_options[j]
				local skin_override = HairMaterialOverrides[option.material_overrides[1]]
				local property_overrides = skin_override.property_overrides
				local hair_rgb = property_overrides.hair_rgb
				local color = {
					255,
					hair_rgb[1] * 255,
					hair_rgb[2] * 255,
					hair_rgb[3] * 255
				}
				options[#options + 1] = {
					color = color,
					value = option,
					on_pressed_function = function ()
						on_pressed_function("set_item_per_slot", option, entry_slot_name)

						local page_five = self._pages[5]

						if page_five then
							self:_check_appearance_continue_block(page_five.content)
						end

						self:_update_appearance_icon()
					end
				}
			end

			category_options[i].get_value_function = callback(get_value_function, "slot_item", entry_slot_name)
			category_options[i].texture = "content/ui/materials/icons/appearances/hair_color"
		elseif entry_type == "gender" then
			local gender_display_name = {
				male = "loc_gender_display_name_male",
				female = "loc_gender_display_name_female"
			}
			local gender_presentation = {
				female = "content/ui/textures/icons/appearances/body_types/feminine",
				male = "content/ui/textures/icons/appearances/body_types/masculine"
			}

			for j = 1, #entry_options do
				local option = entry_options[j]
				options[#options + 1] = {
					on_pressed_function = function (widget)
						on_pressed_function("set_gender", option)

						local page = self._pages[self._active_page_number]
						page.content = self:_get_appearance_content()

						self:_populate_page_grid(1, page.content)

						local page_five = self._pages[5]

						if page_five then
							self:_check_appearance_continue_block(page_five.content)
						end

						self._character_create:reset_height()

						local height = self._character_create:height()

						self:_set_character_height(height)

						self._height_changed = true
					end,
					display_name = gender_display_name[option],
					value = option,
					icon_texture = gender_presentation[option]
				}
			end

			category_options[i].get_value_function = callback(get_value_function, "gender")
		elseif entry_type == "height" then
			for j = 1, #entry_options do
				local option = entry_options[j]
				options[#options + 1] = {
					on_value_updated = function (value)
						local height_range = self._character_create:get_height_values_range()
						local min_height = height_range.min
						local max_height = height_range.max
						local scale_factor = math.lerp(min_height, max_height, value)
						local fmtStr = string.format("%%0.%sf", 3)
						scale_factor = string.format(fmtStr, scale_factor)
						scale_factor = tonumber(scale_factor)

						self:_set_character_height(scale_factor)
					end
				}
			end
		else
			for j = 1, #entry_options do
				local option = entry_options[j]
				options[#options + 1] = {
					value = option,
					on_pressed_function = function (widget)
						on_pressed_function("set_item_per_slot", option, entry_slot_name)

						local page_five = self._pages[5]

						if page_five then
							self:_check_appearance_continue_block(page_five.content)
						end
					end
				}
			end

			category_options[i].get_value_function = callback(get_value_function, "slot_item", entry_slot_name)
		end
	end

	self:_check_valid_appearance_options(category_options)

	return category_options
end

CharacterAppearanceView._get_planet_content = function (self)
	local planets = self._character_create:planet_options()
	local planet_options = {}

	for i = 1, #planets do
		local option = planets[i]
		local planet_settings = HomePlanets[option]
		planet_options[i] = {
			text = Localize(planet_settings.display_name),
			value = option,
			on_pressed_function = function ()
				self._backstory_selection = {
					action = "set_planet",
					settings = planet_settings,
					option = option
				}

				self:_set_selected_backstory()
				self:_move_background_to_position(planet_settings)
				self:_populate_backstory_info(planet_settings)
			end
		}
	end

	return {
		template = "button",
		options = planet_options,
		get_value_function = callback(self._character_create, "planet"),
		reset_value_function = callback(self._character_create, "set_planet", nil),
		settings = HomePlanets
	}
end

CharacterAppearanceView._get_childhood_content = function (self)
	local childhood = self._character_create:childhood_options()
	local childhood_options = {}

	if childhood and #childhood > 1 then
		for i = 1, #childhood do
			local option = childhood[i]
			local childhood_settings = Childhood[option]
			childhood_options[#childhood_options + 1] = {
				text = Localize(childhood_settings.display_name),
				value = option,
				on_pressed_function = function ()
					self._backstory_selection = {
						action = "set_childhood",
						settings = childhood_settings,
						option = option
					}

					self:_set_selected_backstory()
					self:_populate_backstory_info(childhood_settings)
				end,
				on_randomize = function ()
					self._backstory_selection = {
						action = "set_childhood",
						settings = childhood_settings,
						option = option
					}

					self:_set_selected_backstory()
				end,
				visibility_function = function ()
					return self:_is_backstory_option_visible(childhood_settings)
				end
			}
		end
	end

	return {
		template = "button",
		options = childhood_options,
		get_value_function = callback(self._character_create, "childhood"),
		reset_value_function = callback(self._character_create, "set_childhood", nil),
		settings = Childhood
	}
end

CharacterAppearanceView._get_growing_up_content = function (self)
	local growing_up = self._character_create:growing_up_options()
	local growing_up_options = {}

	if growing_up and #growing_up > 1 then
		for i = 1, #growing_up do
			local option = growing_up[i]
			local growing_up_settings = GrowingUp[option]
			growing_up_options[#growing_up_options + 1] = {
				text = Localize(growing_up_settings.display_name),
				value = option,
				on_pressed_function = function ()
					self._backstory_selection = {
						action = "set_growing_up",
						settings = growing_up_settings,
						option = option
					}

					self:_set_selected_backstory()
					self:_populate_backstory_info(growing_up_settings)
				end,
				on_randomize = function ()
					self._backstory_selection = {
						action = "set_growing_up",
						settings = growing_up_settings,
						option = option
					}

					self:_set_selected_backstory()
				end,
				get_value_function = callback(self._character_create, "growing_up"),
				visibility_function = function ()
					return self:_is_backstory_option_visible(growing_up_settings)
				end
			}
		end
	end

	return {
		template = "button",
		options = growing_up_options,
		get_value_function = callback(self._character_create, "growing_up"),
		reset_value_function = callback(self._character_create, "set_growing_up", nil),
		settings = GrowingUp
	}
end

CharacterAppearanceView._get_formative_event_content = function (self)
	local formative_events = self._character_create:formative_event_options()
	local formative_events_options = {}

	if formative_events and #formative_events > 1 then
		for i = 1, #formative_events do
			local option = formative_events[i]
			local formative_events_settings = FormativeEvent[option]
			formative_events_options[#formative_events_options + 1] = {
				text = Localize(formative_events_settings.display_name),
				value = option,
				on_pressed_function = function ()
					self._backstory_selection = {
						action = "set_formative_event",
						settings = formative_events_settings,
						option = option
					}

					self:_set_selected_backstory()
					self:_populate_backstory_info(formative_events_settings)
				end,
				on_randomize = function ()
					self._backstory_selection = {
						action = "set_formative_event",
						settings = formative_events_settings,
						option = option
					}

					self:_set_selected_backstory()
				end,
				visibility_function = function ()
					return self:_is_backstory_option_visible(formative_events_settings)
				end
			}
		end
	end

	return {
		template = "button",
		options = formative_events_options,
		get_value_function = callback(self._character_create, "formative_event"),
		reset_value_function = callback(self._character_create, "set_formative_event", nil),
		settings = FormativeEvent
	}
end

CharacterAppearanceView._get_backstory_content = function (self)
	local backstory_options = {}
	local backstory = {
		get_value_function = function ()
			return
		end,
		options = backstory_options
	}
	local childhood = self:_get_childhood_content()

	if childhood and #childhood.options > 1 then
		backstory_options[#backstory_options + 1] = {
			page_template = "backstory_selection",
			title = Localize("loc_character_childhood_title_name"),
			options = childhood.options,
			get_value_function = childhood.get_value_function,
			reset_value_function = childhood.reset_value_function,
			settings = Childhood,
			template = childhood.template,
			enter = function (page)
				local selected_option = page.get_value_function()

				if selected_option then
					local childhood_settings = Childhood[selected_option]

					self:_populate_backstory_info(childhood_settings)
				end

				self:_handle_continue_button_text()
			end,
			leave = function (cancel_selection)
				if cancel_selection then
					self._backstory_selection = nil
				else
					self:_set_selected_backstory()
				end
			end
		}
	end

	local growing_up = self:_get_growing_up_content()

	if growing_up and #growing_up.options > 1 then
		backstory_options[#backstory_options + 1] = {
			page_template = "backstory_selection",
			title = Localize("loc_character_growing_up_title_name"),
			options = growing_up.options,
			get_value_function = growing_up.get_value_function,
			reset_value_function = growing_up.reset_value_function,
			settings = GrowingUp,
			template = growing_up.template,
			enter = function (page)
				local selected_option = page.get_value_function()

				if selected_option then
					local growing_up_settings = GrowingUp[selected_option]

					self:_populate_backstory_info(growing_up_settings)
				end

				self:_handle_continue_button_text()
			end,
			leave = function (cancel_selection)
				if cancel_selection then
					self._backstory_selection = nil
				else
					self:_set_selected_backstory()
				end
			end
		}
	end

	local formative_events = self:_get_formative_event_content()

	if formative_events and #formative_events.options > 1 then
		backstory_options[#backstory_options + 1] = {
			page_template = "backstory_selection",
			title = Localize("loc_character_event_title_name"),
			options = formative_events.options,
			get_value_function = formative_events.get_value_function,
			reset_value_function = formative_events.reset_value_function,
			settings = FormativeEvent,
			template = formative_events.template,
			enter = function (page)
				self._backstory_selection_page = page
				local selected_option = page.get_value_function()

				if selected_option then
					local formative_events_settings = FormativeEvent[selected_option]

					self:_populate_backstory_info(formative_events_settings)
				end

				self:_handle_continue_button_text()
			end,
			leave = function (cancel_selection)
				self._backstory_selection_page = nil

				if cancel_selection then
					self._backstory_selection = nil
				else
					self:_set_selected_backstory()
				end
			end
		}
	end

	return backstory
end

CharacterAppearanceView._get_appearance_content = function (self)
	local appearance_options = {}
	local appearance = {
		template = "category_button",
		options = appearance_options,
		get_value_function = function ()
			return
		end
	}
	local gender_options = self._character_create:gender_options()

	if gender_options and #gender_options > 1 then
		appearance_options[#appearance_options + 1] = {
			icon = "content/ui/materials/icons/item_types/body_types",
			text = Localize("loc_gender"),
			on_pressed_function = function (widget)
				self:_open_appearance_options(widget.index)
			end,
			options = self:_get_appearance_category_options({
				{
					slot_name = "slot_body",
					grid_template = "icon",
					template = "icon",
					type = "gender",
					options = gender_options
				}
			})
		}
	end

	local face_item_options = self._character_create:slot_item_options("slot_body_face")
	local skin_color_options = self._character_create:slot_item_options("slot_body_skin_color")

	if face_item_options and #face_item_options > 1 then
		table.sort(face_item_options, sort_by_string_name)
		table.sort(face_item_options, sort_by_order)
		table.sort(skin_color_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/face_types",
			text = Localize("loc_face"),
			on_pressed_function = function (widget)
				self:_open_appearance_options(widget.index)
			end,
			options = self:_get_appearance_category_options({
				{
					grid_template = "icon",
					template = "slot_icon",
					slot_name = "slot_body_face",
					options = face_item_options
				},
				{
					slot_name = "slot_body_skin_color",
					grid_template = "icon_small",
					template = "icon_small_texture_hsv",
					type = "skin_color",
					options = skin_color_options
				}
			})
		}
	end

	local eye_color_options = self._character_create:slot_item_options("slot_body_eye_color")

	local function sort_eye_color_by_type()
		local colors_eye_black_scalera = {}
		local colors_eye_blind_left = {}
		local colors_eye_blind_right = {}
		local colors_eye_blind_both = {}
		local colors_eye = {}

		for i = 1, #eye_color_options do
			local eye_color = eye_color_options[i]
			local index = get_eye_type_index_by_option(eye_color)

			if eye_types[index].name == "black_scalera" then
				colors_eye_black_scalera[#colors_eye_black_scalera + 1] = eye_color
			elseif eye_types[index].name == "blind_left" then
				colors_eye_blind_left[#colors_eye_blind_left + 1] = eye_color
			elseif eye_types[index].name == "blind_right" then
				colors_eye_blind_right[#colors_eye_blind_right + 1] = eye_color
			elseif eye_types[index].name == "blind_both" then
				colors_eye_blind_both[#colors_eye_blind_both + 1] = eye_color
			else
				colors_eye[#colors_eye + 1] = eye_color
			end
		end

		local result = {
			no_blind = colors_eye,
			blind_left = colors_eye_blind_left,
			blind_right = colors_eye_blind_right,
			blind_both = colors_eye_blind_both,
			black_scalera = colors_eye_black_scalera
		}

		return result
	end

	if eye_color_options and #eye_color_options > 1 then
		self._eye_options_by_type = sort_eye_color_by_type()
		local current_option = self._character_create.slot_item(self._character_create, "slot_body_eye_color")
		local index = get_eye_type_index_by_option(current_option)
		local filtered_eye_types = {}

		for type_name, data in pairs(self._eye_options_by_type) do
			if #data > 0 then
				for i = 1, #eye_types do
					if type_name == eye_types[i].name then
						filtered_eye_types[#filtered_eye_types + 1] = eye_types[i]

						break
					end
				end
			end
		end

		local filtered_eye_colors = self._eye_options_by_type[eye_types[index].name]

		table.sort(filtered_eye_types, sort_by_order)
		table.sort(filtered_eye_colors, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/eye_color",
			text = Localize("loc_eye_color"),
			on_pressed_function = function (widget)
				self:_open_appearance_options(widget.index)
			end,
			options = self:_get_appearance_category_options({
				{
					slot_name = "slot_body_eye_color",
					grid_template = "icon",
					template = "icon",
					type = "eye_type",
					options = filtered_eye_types
				},
				{
					slot_name = "slot_body_eye_color",
					grid_template = "icon_small",
					template = "icon_small_texture_hsv",
					type = "eye_color",
					options = filtered_eye_colors
				}
			})
		}
	end

	local hair_item_options = self._character_create:slot_item_options("slot_body_hair")
	local hair_color_options = self._character_create:slot_item_options("slot_body_hair_color")

	if hair_item_options and #hair_item_options > 1 then
		table.sort(hair_item_options, sort_by_string_name)
		table.sort(hair_item_options, sort_by_order)
		table.sort(hair_color_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/hair_styles",
			text = Localize("loc_hair"),
			on_pressed_function = function (widget)
				self:_open_appearance_options(widget.index)
			end,
			options = self:_get_appearance_category_options({
				{
					grid_template = "icon",
					template = "slot_icon",
					slot_name = "slot_body_hair",
					options = hair_item_options
				},
				{
					slot_name = "slot_body_hair_color",
					grid_template = "icon_small",
					template = "icon_small_texture",
					type = "hair_color",
					options = hair_color_options
				}
			})
		}
	end

	local face_hair_options = self._character_create:slot_item_options("slot_body_face_hair")
	local facial_hair_color_options = self._character_create:slot_item_options("slot_body_hair_color")

	if face_hair_options and #face_hair_options > 1 then
		table.sort(face_hair_options, sort_by_string_name)
		table.sort(face_hair_options, sort_by_order)
		table.sort(facial_hair_color_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/facial_hair_styles",
			text = Localize("loc_face_hair"),
			on_pressed_function = function (widget)
				self:_open_appearance_options(widget.index)
			end,
			options = self:_get_appearance_category_options({
				{
					grid_template = "icon",
					template = "slot_icon",
					slot_name = "slot_body_face_hair",
					options = face_hair_options
				},
				{
					slot_name = "slot_body_hair_color",
					grid_template = "icon_small",
					template = "icon_small_texture",
					type = "hair_color",
					options = facial_hair_color_options
				}
			})
		}
	end

	local face_tattoo_options = self._character_create:slot_item_options("slot_body_face_tattoo")

	if face_tattoo_options and #face_tattoo_options > 1 then
		table.sort(face_tattoo_options, sort_by_string_name)
		table.sort(face_tattoo_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/face_tattoos",
			text = Localize("loc_face_tattoo"),
			on_pressed_function = function (widget)
				self:_open_appearance_options(widget.index)
			end,
			options = self:_get_appearance_category_options({
				{
					slot_name = "slot_body_face_tattoo",
					grid_template = "icon",
					template = "icon",
					icon_background = "content/ui/textures/icons/appearances/backgrounds/face_tattoos",
					no_option = true,
					options = face_tattoo_options
				}
			})
		}
	end

	local body_tattoo_options = self._character_create:slot_item_options("slot_body_tattoo")

	if body_tattoo_options and #body_tattoo_options > 1 then
		table.sort(body_tattoo_options, sort_by_string_name)
		table.sort(body_tattoo_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			icon = "content/ui/materials/icons/item_types/body_tattoos",
			text = Localize("loc_body_tattoo"),
			on_pressed_function = function (widget)
				self:_open_appearance_options(widget.index)
			end,
			options = self:_get_appearance_category_options({
				{
					slot_name = "slot_body_tattoo",
					grid_template = "icon",
					template = "icon",
					icon_background = "content/ui/textures/icons/appearances/backgrounds/body_tattoos",
					no_option = true,
					options = body_tattoo_options
				}
			})
		}
	end

	local face_scar_options = self._character_create:slot_item_options("slot_body_face_scar")

	if face_scar_options and #face_scar_options > 1 then
		table.sort(face_scar_options, sort_by_string_name)
		table.sort(face_scar_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/scars",
			text = Localize("loc_face_scar"),
			on_pressed_function = function (widget)
				self:_open_appearance_options(widget.index)
			end,
			options = self:_get_appearance_category_options({
				{
					slot_name = "slot_body_face_scar",
					grid_template = "icon",
					template = "icon",
					icon_background = "content/ui/textures/icons/appearances/backgrounds/scars",
					no_option = true,
					options = face_scar_options
				}
			})
		}
	end

	appearance_options[#appearance_options + 1] = {
		icon = "content/ui/materials/icons/item_types/height",
		text = Localize("loc_body_height"),
		on_pressed_function = function (widget)
			self:_open_appearance_options(widget.index)
		end,
		options = self:_get_appearance_category_options({
			{
				grid_template = "single",
				template = "vertical_slider",
				type = "height",
				initialized = function (page_grid)
					local page = self._pages[self._active_page_number]

					self:_set_camera_height_option(nil, page.gear_visible)
				end,
				enter = function (page_grid)
					local widget = page_grid.widgets[1]
					widget.content.element_selected = true
				end,
				leave = function (page_grid)
					local widget = page_grid.widgets[1]
					widget.content.element_selected = false
				end,
				options = {
					{}
				}
			}
		})
	}

	return appearance
end

CharacterAppearanceView._get_personality_content = function (self)
	local personalities = self._character_create:personality_options()
	local personality_options = {}

	local function on_personality_voice_trigger(personality_settings, widget)
		local world = Managers.ui:world()
		local wwise_world = Managers.world:wwise_world(world)
		local sample_sound_event = personality_settings.sample_sound_event

		for i = 1, #self._page_grids[1].widgets do
			local audio_widget = self._page_grids[1].widgets[i]
			audio_widget.content.audio_playing = false
		end

		if self._current_sound_id and WwiseWorld.is_playing(wwise_world, self._current_sound_id) and self._current_sound_widget == widget then
			WwiseWorld.stop_event(wwise_world, self._current_sound_id)

			self._current_progress = 0
		else
			WwiseWorld.stop_event(wwise_world, self._current_sound_id)

			self._current_progress = 0

			self:_play_sound(UISoundEvents.character_appearence_stop_voice_preview)
			ContentBlueprints.pulse_animations.init(widget)

			self._current_sound_id = self:_play_sound(sample_sound_event)
			widget.content.audio_playing = true
			self._current_sound_widget = widget
		end
	end

	local function on_personality_changed(value)
		self._character_create:set_personality(value)
	end

	if personalities and #personalities > 1 then
		for i = 1, #personalities do
			local option = personalities[i]
			local personality_settings = Personalities[option]
			personality_options[i] = {
				text = Localize(personality_settings.display_name),
				value = option,
				on_changed_function = function ()
					on_personality_changed(option)
					self:_populate_backstory_info(personality_settings)

					local page_six = self._pages[6]

					if page_six then
						page_six.content = self:_get_personality_content()

						self:_check_personality_continue_block(page_six.content)
					end
				end,
				on_pressed_function = function (widget)
					on_personality_changed(option)
					on_personality_voice_trigger(personality_settings, widget)
					self:_populate_backstory_info(personality_settings)

					local page_six = self._pages[6]

					if page_six then
						self:_check_personality_continue_block(page_six.content)
					end
				end,
				on_voice_pressed_function = function (element, widget)
					return
				end
			}
		end
	end

	return {
		page_template = "backstory_selection",
		template = "personality_button",
		options = self:_check_valid_personality_options(personality_options),
		get_value_function = callback(self._character_create, "personality"),
		settings = Personalities
	}
end

CharacterAppearanceView._get_crime_content = function (self)
	local crimes = self._character_create:crime_options()
	local crime_options = {}

	if crimes and #crimes > 1 then
		for i = 1, #crimes do
			local option = crimes[i]
			local crime_settings = Crimes[option]
			crime_options[i] = {
				text = Localize(crime_settings.display_name),
				value = option,
				on_pressed_function = function ()
					self._backstory_selection = {
						action = "set_crime",
						settings = crime_settings,
						option = option
					}

					self:_set_selected_backstory()
					self:_populate_backstory_info(crime_settings)
				end
			}
		end
	end

	return {
		page_template = "backstory_selection",
		template = "button",
		title = Localize("loc_character_create_title_crime"),
		options = crime_options,
		get_value_function = callback(self._character_create, "crime"),
		settings = Crimes
	}
end

CharacterAppearanceView._open_appearance_options = function (self, index)
	local options = self._pages[self._active_page_number].content.options[index].options
	local camera_focus = self._pages[self._active_page_number].content.options[index].camera_focus
	local gear_visible = self._pages[self._active_page_number].content.options[index].gear_visible

	self:_set_camera(camera_focus, gear_visible)
	self:_destroy_generated_widgets(2)

	for i = 1, #options do
		local option = options[i]
		local grid_index = 1 + i

		self:_populate_page_grid(grid_index, option)
	end

	if self._page_grids[2].entry and self._page_grids[2].entry.initialized then
		local page = self._page_grids[2]

		self._page_grids[2].entry.initialized(page)
	end
end

CharacterAppearanceView._get_pages = function (self)
	return {
		{
			show_character = false,
			enter = function (page)
				self:_populate_page_grid(1, page.content)
				self:_show_default_page(page)
				self:_setup_planets_widgets()

				local option = page.content.get_value_function()

				if option then
					local planet_settings = HomePlanets[option]

					self:_populate_backstory_info(planet_settings)
					self:_move_background_to_position(HomePlanets[option], true)
				end
			end,
			leave = function ()
				if self._planet_background_animation_id and self:_is_animation_active(self._planet_background_animation_id) then
					self._reset_background = true

					self:_complete_animation(self._planet_background_animation_id)

					self._planet_background_animation_id = nil
				end

				self:_destroy_planets_widgets()
			end,
			title = Localize("loc_character_create_title_home_planet"),
			top_frame = {
				icon = "content/ui/materials/icons/character_creator/home_planet",
				header = "content/ui/materials/frames/character_creator_top",
				header_extra = "content/ui/materials/effects/character_creator_top_candles",
				size = {
					485,
					230
				},
				offset = {
					0,
					-205,
					1
				},
				title_offset = {
					0,
					-4,
					2
				},
				icon_size = {
					100,
					100
				},
				icon_offset = {
					0,
					-130,
					3
				}
			},
			description = Localize("loc_character_creator_home_planet_introduction"),
			background = {
				value = "content/ui/materials/backgrounds/backstory/home_planet",
				uvs = {
					{
						0,
						0
					},
					{
						0.17,
						0.17
					}
				},
				size = {
					11016,
					6400
				}
			},
			content = self:_get_planet_content()
		},
		{
			show_character = false,
			enter = function (page)
				self:_populate_page_grid(1, page.content)
				self:_show_default_page(page)

				local option = page.content.get_value_function()

				if option then
					local childhood_settings = Childhood[option]

					self:_populate_backstory_info(childhood_settings)
				end
			end,
			title = Localize("loc_character_childhood_title_name"),
			description = Localize("loc_character_creator_childhood_introduction"),
			background = {
				value = "content/ui/materials/backgrounds/backstory/childhood",
				size = {
					1920,
					1080
				}
			},
			top_frame = {
				icon = "content/ui/materials/icons/character_creator/childhood",
				header = "content/ui/materials/frames/character_creator_top",
				header_extra = "content/ui/materials/effects/character_creator_top_candles",
				size = {
					485,
					230
				},
				offset = {
					0,
					-205,
					1
				},
				title_offset = {
					0,
					-4,
					2
				},
				icon_size = {
					100,
					100
				},
				icon_offset = {
					0,
					-130,
					3
				}
			},
			content = self:_get_childhood_content()
		},
		{
			show_character = false,
			enter = function (page)
				self:_populate_page_grid(1, page.content)
				self:_show_default_page(page)

				local option = page.content.get_value_function()

				if option then
					local growing_up_settings = GrowingUp[option]

					self:_populate_backstory_info(growing_up_settings)
				end
			end,
			title = Localize("loc_character_growing_up_title_name"),
			description = Localize("loc_character_creator_growing_up_introduction"),
			top_frame = {
				icon = "content/ui/materials/icons/character_creator/growth",
				header = "content/ui/materials/frames/character_creator_top",
				header_extra = "content/ui/materials/effects/character_creator_top_candles",
				size = {
					485,
					230
				},
				offset = {
					0,
					-205,
					1
				},
				title_offset = {
					0,
					-4,
					2
				},
				icon_size = {
					100,
					100
				},
				icon_offset = {
					0,
					-130,
					3
				}
			},
			background = {
				value = "content/ui/materials/backgrounds/backstory/growing_up",
				size = {
					1920,
					1080
				}
			},
			content = self:_get_growing_up_content()
		},
		{
			show_character = false,
			enter = function (page)
				self:_populate_page_grid(1, page.content)
				self:_show_default_page(page)

				local option = page.content.get_value_function()

				if option then
					local formative_event_settings = FormativeEvent[option]

					self:_populate_backstory_info(formative_event_settings)
				end
			end,
			title = Localize("loc_character_event_title_name"),
			description = Localize("loc_character_creator_formative_event_introduction"),
			top_frame = {
				icon = "content/ui/materials/icons/character_creator/accomplishment",
				header = "content/ui/materials/frames/character_creator_top",
				header_extra = "content/ui/materials/effects/character_creator_top_candles",
				size = {
					485,
					230
				},
				offset = {
					0,
					-205,
					1
				},
				title_offset = {
					0,
					-4,
					2
				},
				icon_size = {
					100,
					100
				},
				icon_offset = {
					0,
					-130,
					3
				}
			},
			background = {
				value = "content/ui/materials/backgrounds/backstory/formative_event",
				size = {
					1920,
					1080
				}
			},
			content = self:_get_formative_event_content()
		},
		{
			show_character = true,
			enter = function (page)
				page.content = self:_get_appearance_content()

				self:_check_appearance_continue_block(page.content)
				self:_populate_page_grid(1, page.content)
				self:_show_default_page(page)
			end,
			title = Localize("loc_character_create_title_appearance"),
			top_frame = {
				icon = "content/ui/materials/icons/character_creator/appearence",
				header = "content/ui/materials/frames/character_creator_top",
				header_extra = "content/ui/materials/effects/character_creator_top_candles",
				size = {
					485,
					230
				},
				offset = {
					0,
					-205,
					1
				},
				title_offset = {
					0,
					-4,
					2
				},
				icon_size = {
					100,
					100
				},
				icon_offset = {
					0,
					-130,
					3
				}
			},
			content = {},
			get_value_function = function ()
				return 1
			end
		},
		{
			show_rewards_text = false,
			gear_visible = false,
			show_character = true,
			enter = function (page)
				page.content = self:_get_personality_content()

				self:_check_personality_continue_block(page.content)
				self:_populate_page_grid(1, page.content)
				self:_show_default_page(page)

				local option = page.content.get_value_function()

				if option then
					local persoanlity_settings = Personalities[option]

					self:_populate_backstory_info(persoanlity_settings)
				end
			end,
			leave = function ()
				self:_play_sound(UISoundEvents.character_appearence_stop_voice_preview)
			end,
			title = Localize("loc_character_create_title_personality"),
			top_frame = {
				icon = "content/ui/materials/icons/character_creator/personality",
				header = "content/ui/materials/frames/character_creator_top",
				header_extra = "content/ui/materials/effects/character_creator_top_candles",
				size = {
					485,
					230
				},
				offset = {
					0,
					-205,
					1
				},
				title_offset = {
					0,
					-4,
					2
				},
				icon_size = {
					100,
					100
				},
				icon_offset = {
					0,
					-130,
					3
				}
			},
			description = Localize("loc_character_creator_personality_introduction")
		},
		{
			gear_visible = true,
			show_character = true,
			enter = function (page)
				local profile = self._character_create:profile()
				local selected_archetype = profile.archetype.name
				local selected_gender = self._character_create:gender()

				if self._character_name_status.archetype ~= selected_archetype or self._character_name_status.gender ~= selected_gender then
					self._character_name_status.archetype = selected_archetype
					self._character_name_status.gender = selected_gender

					self._character_create:_fetch_suggested_names_by_profile()
				end

				self:_populate_page_grid(1, page.content)
				self:_show_default_page(page)

				local option = page.content.get_value_function()

				if option then
					local crime_settings = Crimes[option]

					self:_populate_backstory_info(crime_settings)
				end
			end,
			title = Localize("loc_character_create_title_crime"),
			top_frame = {
				icon = "content/ui/materials/icons/character_creator/sentence",
				header = "content/ui/materials/frames/character_creator_top",
				header_extra = "content/ui/materials/effects/character_creator_top_candles",
				size = {
					485,
					230
				},
				offset = {
					0,
					-205,
					1
				},
				title_offset = {
					0,
					-4,
					2
				},
				icon_size = {
					100,
					100
				},
				icon_offset = {
					0,
					-130,
					3
				}
			},
			description = Localize("loc_character_creator_sentence_introduction"),
			content = self:_get_crime_content()
		},
		{
			gear_visible = true,
			show_character = true,
			enter = function (page)
				self:_show_final_page(page)

				if self._using_cursor_navigation then
					self._page_widgets[1].content.hotspot.on_pressed = true
				else
					self._page_widgets[1].content.hotspot.is_focused = true
				end

				self:_update_character_name()
				self:_move_camera()
				self:_handle_continue_button_text()
			end,
			leave = function ()
				self:_move_camera(true)
				self:_create_errors_name_input()
				self:_destroy_support_page_widgets()
			end
		}
	}
end

CharacterAppearanceView._check_appearance_continue_block = function (self, page_content)
	local options = page_content.options

	if type(options) == "table" then
		for i = 1, #options do
			local block_continue = false
			local option = options[i]

			if type(option) == "table" then
				for f = 1, #option.options do
					local selected_value = option.options[f].get_value_function and option.options[f].get_value_function()

					if option.options[f].options then
						local selected_option = nil

						for j = 1, #option.options[f].options do
							local appearance_option = option.options[f].options[j]

							if appearance_option.value == selected_value then
								selected_option = appearance_option

								break
							end
						end

						if type(selected_option) == "table" then
							local should_present_option = self:_should_present_option(selected_option)

							if should_present_option and should_present_option.should_present_option == false then
								block_continue = true

								break
							end
						end
					end
				end
			end

			self._block_continue[self._active_page_number][i] = block_continue
		end
	end
end

CharacterAppearanceView._check_personality_continue_block = function (self, page_content)
	local options = page_content.options

	if type(options) == "table" then
		for i = 1, #options do
			local selected_value = page_content.get_value_function and page_content.get_value_function()
			local option = options[i]
			local block_continue = false

			if option.value == selected_value then
				local personality_option = {
					value = Personalities[options[i].value]
				}
				local should_present_option = self:_should_present_option(personality_option)

				if should_present_option and should_present_option.should_present_option == false then
					block_continue = true
				end
			end

			self._block_continue[self._active_page_number][i] = block_continue
		end
	end
end

CharacterAppearanceView._check_valid_appearance_options = function (self, category_options)
	for i = 1, #category_options do
		local category_option = category_options[i]
		local requires_reselection = false
		local filtered_options = {}
		local available_options = {}
		local options = category_option.options
		local no_option = category_option.no_option
		local focused_value = category_option.get_value_function and category_option.get_value_function()

		for f = 1, #options do
			local option = options[f]
			local should_present_option = self:_should_present_option(option)
			option.should_present_option = should_present_option

			if should_present_option.should_present_option == false and focused_value == option.value and requires_reselection == false then
				requires_reselection = true
			end

			if should_present_option.should_present_option == true or should_present_option.should_present_option == false and should_present_option.reason then
				filtered_options[#filtered_options + 1] = option
			end

			if should_present_option.should_present_option == true then
				available_options[#available_options + 1] = option
			end
		end

		if requires_reselection == true then
			local random_index = math.random(1, #available_options)
			local new_option = available_options[random_index]

			new_option.on_pressed_function()
		end

		local temp_backstory_enabled = {}
		local temp_backstory_disabled = {}
		local temp_remaining = {}
		local start_count = 1

		if no_option then
			temp_backstory_enabled[#temp_backstory_enabled + 1] = filtered_options[start_count]
			start_count = start_count + 1
		end

		for i = start_count, #filtered_options do
			local filtered_option = filtered_options[i]

			if filtered_option.should_present_option and filtered_option.should_present_option.should_present_option == true and filtered_option.should_present_option.reason then
				temp_backstory_enabled[#temp_backstory_enabled + 1] = filtered_option
			elseif filtered_option.should_present_option and filtered_option.should_present_option.should_present_option == false and filtered_option.should_present_option.reason then
				temp_backstory_disabled[#temp_backstory_disabled + 1] = filtered_option
			elseif not filtered_option.should_present_option or filtered_option.should_present_option.should_present_option == true then
				temp_remaining[#temp_remaining + 1] = filtered_option
			end
		end

		temp_backstory_enabled = table.append(temp_backstory_enabled, temp_remaining)
		temp_backstory_enabled = table.append(temp_backstory_enabled, temp_backstory_disabled)
		filtered_options = temp_backstory_enabled
		category_options[i].options = filtered_options
	end
end

CharacterAppearanceView._check_valid_personality_options = function (self, options)
	local selected_value = self._character_create:personality()
	local filtered_options = {}
	local available_options = {}
	local requires_reselection = false

	for i = 1, #options do
		local option = options[i]
		local personality_options = {
			value = Personalities[option.value]
		}
		local should_present_option = self:_should_present_option(personality_options)
		option.should_present_option = should_present_option

		if should_present_option.should_present_option == false and selected_value == option.value and requires_reselection == false then
			requires_reselection = true
		end

		if should_present_option.should_present_option == true or should_present_option.should_present_option == false and should_present_option.reason then
			filtered_options[#filtered_options + 1] = option
		end

		if should_present_option.should_present_option == true then
			available_options[#available_options + 1] = option
		end
	end

	if requires_reselection == true then
		local random_index = math.random(1, #available_options)
		local new_option = available_options[random_index]

		new_option.on_changed_function()
	end

	local temp_backstory_enabled = {}
	local temp_backstory_disabled = {}
	local temp_remaining = {}
	local start_count = 1

	for i = start_count, #filtered_options do
		local filtered_option = filtered_options[i]

		if filtered_option.should_present_option and filtered_option.should_present_option.should_present_option == true and filtered_option.should_present_option.reason then
			temp_backstory_enabled[#temp_backstory_enabled + 1] = filtered_option
		elseif filtered_option.should_present_option and filtered_option.should_present_option.should_present_option == false and filtered_option.should_present_option.reason then
			temp_backstory_disabled[#temp_backstory_disabled + 1] = filtered_option
		elseif not filtered_option.should_present_option or filtered_option.should_present_option.should_present_option == true then
			temp_remaining[#temp_remaining + 1] = filtered_option
		end
	end

	temp_backstory_enabled = table.append(temp_backstory_enabled, temp_remaining)
	temp_backstory_enabled = table.append(temp_backstory_enabled, temp_backstory_disabled)
	filtered_options = temp_backstory_enabled

	return filtered_options
end

CharacterAppearanceView._create_errors_name_input = function (self, errors)
	if self._name_input_errors_widgets then
		for i = 1, #self._name_input_errors_widgets do
			local widget = self._name_input_errors_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._name_input_errors_widgets = {}
	end

	if errors then
		local error_widgets = {}
		local reference_widget = self._page_widgets[1]
		local reference_offset = reference_widget.offset
		local reference_size = reference_widget.content.size
		local margin = {
			0,
			20
		}
		local offset_text = 0
		local margin_text = 30

		for i = 1, #errors do
			local error = errors[i]
			local name = "error_" .. i
			local definition = Definitions.error_text_definitions
			local widget = self:_create_widget(name, definition)
			widget.content.text = error
			local style = widget.style.text
			local width, height = UIRenderer.text_size(self._ui_renderer, error, style.font_type, style.font_size, {
				reference_size[1],
				0
			}, style)
			offset_text = offset_text - height
			offset_text = i == 1 and offset_text or offset_text - margin_text
			widget.content.size = {
				reference_size[1],
				height
			}
			widget.offset = {
				0,
				offset_text,
				2
			}
			error_widgets[#error_widgets + 1] = widget
		end

		self._name_input_errors_widgets = error_widgets
	end
end

CharacterAppearanceView._destroy_support_page_widgets = function (self)
	if self._page_widgets then
		for i = 1, #self._page_widgets do
			local widget = self._page_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._page_widgets = nil
	end
end

CharacterAppearanceView._handle_input = function (self, input_service)
	if self._page_widgets and not self._using_cursor_navigation and input_service:get("hotkey_menu_special_2") then
		self:_randomize_character_name()
	end

	if input_service:get("navigate_up_continuous") then
		self:_grid_navigation("up")
	elseif input_service:get("navigate_down_continuous") then
		self:_grid_navigation("down")
	elseif input_service:get("navigate_left_continuous") then
		self:_grid_navigation("left")
	elseif input_service:get("navigate_right_continuous") then
		self:_grid_navigation("right")
	elseif not self._using_cursor_navigation and input_service:get("secondary_action_pressed") then
		if not self._widgets_by_name.continue_button.content.hotspot.disabled then
			self:_on_continue_pressed()
		end
	elseif self._using_cursor_navigation and input_service:get("confirm_pressed") and self._active_page_number == 8 and self._page_widgets and self._page_widgets[1].content.is_writing and not self._widgets_by_name.continue_button.content.hotspot.disabled then
		self:_on_continue_pressed()
	end
end

CharacterAppearanceView._grid_navigation = function (self, start_direction)
	local function calculate_nearest_index_position_new_grid(grid_index, index, new_grid_index, is_going_right)
		local new_max_widgets_per_column = self._page_grids[new_grid_index].max_widgets_per_column
		local total_columns = self._page_grids[grid_index].num_columns
		local new_total_columns = self._page_grids[new_grid_index].num_columns
		local scrollbar_progress = self._page_grids[grid_index].grid:scrollbar_progress()
		local grid_size = self._page_grids[grid_index].grid:area_length()
		local grid_total_size = self._page_grids[grid_index].grid:length()
		local element_type = self._page_grids[grid_index].entry.template
		local element_size = ContentBlueprints.blueprints[element_type].size
		local element_spacing = {
			0,
			0
		}
		local grid_template = self._page_grids[new_grid_index].entry.grid_template

		if grid_template == "icon" or grid_template == "icon_small" then
			element_spacing = {
				10,
				10
			}
		end

		local element_total_height = element_size[2] + element_spacing[2]
		local start_height = (grid_total_size - grid_size) * math.abs(scrollbar_progress)
		local row_position = math.ceil(index / total_columns)
		local element_start_height_position = (row_position - 1) * element_total_height - start_height
		local element_mid_height_position = element_start_height_position + element_total_height * 0.5
		local new_grid_size = self._page_grids[new_grid_index].grid:area_length()
		local new_grid_total_size = self._page_grids[new_grid_index].grid:length()
		local new_element_type = self._page_grids[new_grid_index].entry.template
		local new_element_size = ContentBlueprints.blueprints[new_element_type].size
		local new_element_spacing = {
			0,
			0
		}
		local new_grid_template = self._page_grids[new_grid_index].entry.grid_template

		if new_grid_template == "icon" or new_grid_template == "icon_small" then
			new_element_spacing = {
				10,
				10
			}
		end

		local new_element_total_height = new_element_size[2] + new_element_spacing[2]
		local new_scrollbar_progress = self._page_grids[new_grid_index].grid:scrollbar_progress()
		local new_start_height = (new_grid_total_size - new_grid_size) * math.abs(new_scrollbar_progress)
		local element_on_previous_mid_height = math.ceil(element_mid_height_position / new_element_total_height)
		local new_start_row = math.ceil(new_start_height / new_element_total_height)
		local new_index_row = element_on_previous_mid_height + new_start_row
		new_index_row = new_max_widgets_per_column > new_index_row and new_index_row or new_max_widgets_per_column
		local new_index = nil

		if is_going_right then
			new_index = (new_index_row - 1) * new_total_columns + 1
		else
			new_index = new_index_row * new_total_columns
		end

		return new_index
	end

	local index = self._navigation.index or 0
	local grid_index = self._navigation.grid or 1
	local current_grid = self._page_grids[grid_index]
	local total_index = #current_grid.widgets
	local new_index, new_grid_index = nil
	local direction = start_direction

	if not current_grid or not current_grid.grid then
		return
	end

	if current_grid.grid._direction == "right" then
		if start_direction == "up" then
			direction = "right"
		elseif start_direction == "down" then
			direction = "left"
		elseif start_direction == "left" then
			direction = "up"
		elseif start_direction == "right" then
			direction = "down"
		end
	end

	if index == 0 then
		if direction == "up" then
			new_index = total_index
		else
			new_index = 1
		end

		new_grid_index = grid_index
	else
		local total_columns = current_grid.num_columns
		local current_row = math.ceil(index / total_columns)
		local current_column = index % total_columns > 0 and index % total_columns or total_columns
		local start_index_current_column = current_column
		local last_row = current_column <= total_index % total_columns and math.ceil(total_index / total_columns) or math.floor(total_index / total_columns)
		local end_index_current_column = (last_row - 1) * total_columns + current_column

		if direction == "up" then
			new_index = index - total_columns
			new_grid_index = grid_index

			if new_index < start_index_current_column then
				new_index = end_index_current_column
			end
		elseif direction == "down" then
			new_index = index + total_columns
			new_grid_index = grid_index

			if end_index_current_column < new_index then
				new_index = start_index_current_column
			end
		elseif direction == "right" then
			new_index = index and index + 1 or 1
			new_grid_index = grid_index

			if total_index < new_index or current_row < math.ceil(new_index / total_columns) then
				new_grid_index = new_grid_index + 1
			end

			local is_next_grid_valid = self._page_grids[new_grid_index] and self._page_grids[new_grid_index].can_navigate

			if not is_next_grid_valid then
				new_index = index
				new_grid_index = grid_index
			elseif new_grid_index ~= grid_index and new_grid_index == 2 then
				new_index = calculate_nearest_index_position_new_grid(grid_index, index, new_grid_index, true)
			elseif new_grid_index ~= grid_index then
				new_index = calculate_nearest_index_position_new_grid(grid_index, index, new_grid_index, true)
			end
		elseif direction == "left" then
			new_index = index and index - 1 or 1
			new_grid_index = grid_index

			if new_index < 1 or math.ceil(new_index / total_columns) < current_row then
				new_grid_index = new_grid_index - 1
			end

			local is_next_grid_valid = self._page_grids[new_grid_index] and self._page_grids[new_grid_index].can_navigate

			if not is_next_grid_valid then
				new_index = index
				new_grid_index = grid_index
			elseif new_grid_index ~= grid_index and new_grid_index == 1 then
				new_index = 1

				for i = 1, #self._page_grids[new_grid_index].widgets do
					local widget = self._page_grids[new_grid_index].widgets[i]

					if widget.content.element_selected == true then
						new_index = i

						break
					end
				end
			elseif new_grid_index ~= grid_index then
				new_index = calculate_nearest_index_position_new_grid(grid_index, index, new_grid_index)
			end
		end
	end

	self:_update_current_navigation_position(new_grid_index, new_index)
end

CharacterAppearanceView._move_background_to_position = function (self, planet, skip_animation)
	local start_planet_widget, end_planet_widget = nil
	local background = self._pages[self._active_page_number].background

	for i = 1, #self._planet_widgets do
		local widget = self._planet_widgets[i]

		if widget.content.current_planet then
			if widget.content.planet_data.id == planet.id then
				return
			end

			widget.content.current_planet = false
			start_planet_widget = widget
		end

		if planet.id == widget.content.planet_data.id then
			end_planet_widget = widget
		end
	end

	if start_planet_widget then
		start_planet_widget.content.visible = true
	end

	end_planet_widget.content.current_planet = true
	local texture_size = background.size
	local uv_diff = 1920 / background.size[1]
	local start_position = start_planet_widget and start_planet_widget.content.planet_data.position
	local end_position = planet.position
	local start_uv = nil

	if start_planet_widget then
		start_uv = {
			{
				start_position[1] / texture_size[1] - uv_diff / 2,
				start_position[2] / texture_size[2] - uv_diff / 2
			},
			{
				start_position[1] / texture_size[1] + uv_diff / 2,
				start_position[2] / texture_size[2] + uv_diff / 2
			}
		}
	else
		start_uv = self._widgets_by_name.background.style.texture.uvs
	end

	local end_uv = {
		{
			end_position[1] / texture_size[1] - uv_diff / 2,
			end_position[2] / texture_size[2] - uv_diff / 2
		},
		{
			end_position[1] / texture_size[1] + uv_diff / 2,
			end_position[2] / texture_size[2] + uv_diff / 2
		}
	}
	local params = {
		start_uv = start_uv,
		end_uv = end_uv,
		planets = self._planet_widgets,
		start_planet_widget = start_planet_widget,
		end_planet_widget = end_planet_widget
	}

	if skip_animation then
		self._widgets_by_name.background.style.texture.uvs = end_uv

		for i = 1, #self._planet_widgets do
			local widget = self._planet_widgets[i]
			widget.content.visible = false
			widget.content.current_planet = false
		end

		end_planet_widget.content.visible = true
		end_planet_widget.style.planet.offset[1] = CharacterAppearanceViewSettings.planet_offset[1]
		end_planet_widget.style.planet.offset[2] = CharacterAppearanceViewSettings.planet_offset[2]
		end_planet_widget.content.current_planet = true
	else
		if self._planet_background_animation_id and self:_is_animation_active(self._planet_background_animation_id) then
			self:_complete_animation(self._planet_background_animation_id)

			self._planet_background_animation_id = nil
		end

		self._planet_background_animation_id = self:_start_animation("on_planet_select", self._widgets_by_name, params)
	end
end

CharacterAppearanceView._setup_planets_widgets = function (self)
	local planet_definition = UIWidget.create_definition({
		{
			value_id = "planet",
			style_id = "planet",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "screen")
	local widgets = {}

	for option_name, planet_values in pairs(HomePlanets) do
		local name = string.format("planet_%s", option_name)
		local widget = self:_create_widget(name, planet_definition)
		local style = widget.style
		local content = widget.content
		style.planet.size = planet_values.image.size
		style.planet.material_values = {
			texture_map = planet_values.image.path
		}
		content.planet_data = planet_values
		widget.offset = {
			0,
			0,
			2
		}
		widget.content.visible = false
		widgets[#widgets + 1] = widget
	end

	self._planet_widgets = widgets
end

CharacterAppearanceView._destroy_planets_widgets = function (self)
	if self._planet_widgets then
		for i = 1, #self._planet_widgets do
			local widget = self._planet_widgets[i]

			self:_unregister_widget_name(widget.name)
		end
	end

	self._planet_widgets = nil
end

CharacterAppearanceView.on_resolution_modified = function (self)
	CharacterAppearanceView.super.on_resolution_modified(self)
	self:_align_background()
end

CharacterAppearanceView._align_background = function (self)
	local screen_width = RESOLUTION_LOOKUP.width
	local screen_height = RESOLUTION_LOOKUP.height
	local inverse_scale = RESOLUTION_LOOKUP.inverse_scale
	local parent_size_x = screen_width * inverse_scale
	local parent_size_y = screen_height * inverse_scale
	local reference_size = self._pages[self._active_page_number].background and self._pages[self._active_page_number].background.size or {
		1920,
		1080
	}
	local width_reference_ratio = reference_size[1] / reference_size[2]
	local height_reference_ratio = reference_size[2] / reference_size[1]
	local screen_ratio = screen_width / screen_height
	local size = {
		parent_size_x,
		parent_size_y
	}

	if width_reference_ratio < screen_ratio then
		size = {
			parent_size_x,
			parent_size_x * height_reference_ratio
		}
	elseif screen_ratio < width_reference_ratio then
		size = {
			parent_size_y * width_reference_ratio,
			parent_size_y
		}
	end

	self._widgets_by_name.background.content.size = size
	self._widgets_by_name.background.offset = {
		parent_size_x / 2 - size[1] / 2,
		parent_size_y / 2 - size[2] / 2,
		0
	}
end

CharacterAppearanceView.dialogue_system = function (self)
	if self._is_barber then
		return self._parent:dialogue_system()
	else
		return nil
	end
end

return CharacterAppearanceView
