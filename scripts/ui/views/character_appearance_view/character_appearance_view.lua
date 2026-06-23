-- chunkname: @scripts/ui/views/character_appearance_view/character_appearance_view.lua

local Breeds = require("scripts/settings/breed/breeds")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local CharacterAppearanceViewContentBlueprints = require("scripts/ui/views/character_appearance_view/character_appearance_view_content_blueprints")
local CharacterAppearanceViewFontStyle = require("scripts/ui/views/character_appearance_view/character_appearance_view_font_style")
local CharacterAppearanceViewSettings = require("scripts/ui/views/character_appearance_view/character_appearance_view_settings")
local CharacterCreate = require("scripts/utilities/character_create")
local Colors = require("scripts/utilities/ui/colors")
local CompanionDogRestrictions = require("scripts/settings/character/companion_dog_restrictions")
local Definitions = require("scripts/ui/views/character_appearance_view/character_appearance_view_definitions")
local HomePlanets = require("scripts/settings/character/home_planets")
local Items = require("scripts/utilities/items")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemSourceSettings = require("scripts/settings/item/item_source_settings_new")
local MasterItems = require("scripts/backend/master_items")
local Popups = require("scripts/utilities/ui/popups")
local ProfileUtils = require("scripts/utilities/profile_utils")
local Promise = require("scripts/foundation/utilities/promise")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local Text = require("scripts/utilities/ui/text")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ARCHETYPE_PAGES = CharacterAppearanceViewSettings.archetype_pages
local EYE_TYPES = CharacterAppearanceViewSettings.eye_types
local RESTRICTION_DATAS = CharacterAppearanceViewSettings.restriction_datas
local VO_EVENTS = CharacterAppearanceViewSettings.vo_events
local MINDWIPE_CHAIR_PAGES = {
	companion_name = true,
	crime = true,
	name = true,
	personality = true,
	voice = true,
}
local MINDWIPEABLE_PAGES = {
	personality = true,
	voice = true,
}
local RTPC_EFFECT_X = "vox_effect_01"
local RTPC_EFFECT_Y = "vox_effect_02"
local RTPC_EFFECT_SLIDER = "vox_effect_03"
local _continue_validation_item_slots, _add_gamepad_focused_slots, _remove_gamepad_focused_slots, _get_eye_type_index_by_option, _set_voice_character_create_values, _set_voice_wwise_values, _set_initial_voice_screen_component_values, _set_voice_screen_component_values
local CharacterAppearanceView = class("CharacterAppearanceView", "BaseView")

CharacterAppearanceView.init = function (self, settings, context)
	self._character_create = context.character_create
	self._context = context
	self._parent = context and context.parent

	if self._parent and self._parent.set_active_view_instance then
		self._parent:set_active_view_instance(self)
	end

	self._force_character_creation = context.force_character_creation
	self._is_barber_appearance = context.is_barber_appearance
	self._is_barber_companion_appearance = context.is_barber_companion_appearance
	self._is_barber_mindwipe = context.is_barber_mindwipe
	self._is_barber = context.is_barber_appearance or context.is_barber_mindwipe or context.is_barber_companion_appearance
	self._waiting_for_transform = false
	self._world_spawners = {}

	CharacterAppearanceView.super.init(self, Definitions, settings, context)

	if context.pass_draw ~= nil then
		self._pass_draw = context.pass_draw
	end

	if context.pass_input ~= nil then
		self._pass_input = context.pass_input
	end
end

CharacterAppearanceView.on_enter = function (self)
	self._character_create_promise = Promise:new()

	self._character_create_promise:next(function ()
		local input_manager = Managers.input
		local name = self.__class_name

		if not self._no_cursor then
			input_manager:push_cursor(name)

			self._cursor_pushed = true
		end

		self._update_scenegraph = true
		self._entered = true

		local enter_sound_events = self._settings.enter_sound_events

		if enter_sound_events then
			for ii = 1, #enter_sound_events do
				local sound_event = enter_sound_events[ii]

				self:_play_sound(sound_event)
			end
		end

		Managers.telemetry_events:open_view(self.view_name, false)

		self._profile_versions = table.clone(self._character_create:profile_value_versions())
		self._pages = self:_get_pages()
		self._page_grids = {}

		local profile = self._character_create:profile()
		local archetype = profile.archetype
		local archetype_name = profile.archetype.name

		Wwise.set_state("music_character_create", archetype_name)

		if not self._is_barber then
			local pre_character_creation_video_template_name = archetype and archetype.character_creation_intro_video_template_name

			if pre_character_creation_video_template_name then
				Managers.ui:open_view("video_view", nil, nil, nil, nil, {
					allow_skip_input = true,
					template = pre_character_creation_video_template_name,
				})
			end
		end

		self:_register_event("update_profiles_sync_state", "_event_profiles_sync_changed")

		local is_syncing = self._parent and self._parent._character_is_syncing or false

		self:_event_profiles_sync_changed(is_syncing)
		self:_create_offscreen_renderer()
		self:_setup_input_legend()
		self:_setup_button_callbacks()
		self:_setup_profile_background()
		self:_create_page_indicators()

		self._character_name_status = {
			archetype = nil,
			custom = false,
			gender = nil,
		}
		self._companion_name_status = {
			custom = false,
		}

		if self._is_barber_mindwipe then
			self._page_open_vo = {
				[2] = VO_EVENTS.mindwipe_backstory,
				[5] = VO_EVENTS.mindwipe_body_type,
				[6] = VO_EVENTS.mindwipe_personality,
			}

			local parent = self._parent

			if parent then
				parent:play_vo_events(VO_EVENTS.mindwipe_select, "training_ground_psyker_a", nil, 0.2)
			end
		end

		if not self._is_barber then
			self._character_create:reset_backstory()
		end

		self._fade_animation_id = self:_start_animation("on_level_switch")

		self:_open_page(1)

		self._character_create_promise = nil
	end)

	if not self._character_create then
		local item_definitions = MasterItems.get_cached()
		local player = Managers.player:local_player(1)
		local profile = player:profile()

		self._original_name = player:name()
		self._original_companion_name = player:companion_name()
		self._fetch_all_profiles_promise = Managers.data_service.profiles:fetch_all_profiles():next(function (data)
			self._character_create = CharacterCreate:new(item_definitions, data.gear, profile)

			self._character_create_promise:resolve()

			self._fetch_all_profiles_promise = nil

			if not self._is_barber then
				self._character_create:randomize_character_apperance_preset()
				self._character_create:randomize_personality()
			end
		end):catch(function (error)
			self._character_create = CharacterCreate:new(item_definitions, {}, profile)

			self._character_create_promise:resolve()

			self._fetch_all_profiles_promise = nil

			if not self._is_barber then
				self._character_create:randomize_character_apperance_preset()
				self._character_create:randomize_personality()
			end
		end)
	else
		self._character_create_promise:resolve()

		if not self._is_barber then
			self._character_create:randomize_character_apperance_preset()
			self._character_create:randomize_personality()
		end
	end
end

CharacterAppearanceView._archetype_page_data = function (self)
	local profile = self._character_create:profile()
	local archetype_name = profile.archetype and profile.archetype.name

	return ARCHETYPE_PAGES[archetype_name]
end

CharacterAppearanceView._get_pages = function (self)
	local profile = self._character_create:profile()
	local archetype = profile.archetype and profile.archetype.name
	local archetype_page_data = self:_archetype_page_data()
	local planet_page = {
		name = "home_planet",
		show_character = false,
		show_companion = false,
		on_enter = function (page, previous_page)
			local widgets, widgets_by_name = self:_create_planet_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(ii, grid)
				end
			end

			self._backstory_selection_page = true
		end,
		on_leave = function (page)
			if self._planet_background_animation_id then
				self:_stop_animation(self._planet_background_animation_id)

				self._planet_background_animation_id = nil
			end

			self:_destroy_page_widgets()

			self._backstory_selection_page = false
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_planet_options()
				end,
				selected_option = function ()
					local option = self._character_create:planet()

					return option and option.id
				end,
				on_reset = callback(self._character_create, "set_planet", nil),
				description = Localize(archetype_page_data.home_planet.description),
				top_frame = function (grid, grid_size, grid_scenegraph)
					local page_data = archetype_page_data.home_planet
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local planet_page_side_scroll = {
		name = "home_planet",
		render_world = true,
		show_character = false,
		show_companion = false,
		on_enter = function (page, previous_page)
			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end
			end
		end,
		on_leave = function (page, next_page)
			self:_reset_camera()

			local option = self._character_create:planet()
			local page_leave_sound = option and option.page_leave_sound or UISoundEvents.stop_ui_character_create_select_cartel_loops

			Managers.ui:play_2d_sound(page_leave_sound)
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_planet_options()
				end,
				selected_option = function ()
					local option = self._character_create:planet()

					return option and option.id
				end,
				description = Localize(archetype_page_data.home_planet.description),
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = archetype_page_data.home_planet
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local childhood_page = {
		name = "childhood",
		show_character = false,
		show_companion = false,
		on_enter = function (page, previous_page)
			local widgets, widgets_by_name = self:_create_childhood_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end
			end

			self._backstory_selection_page = true
		end,
		on_leave = function (page)
			self:_destroy_page_widgets()

			self._backstory_selection_page = false
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_childhood_options()
				end,
				selected_option = function ()
					local option = self._character_create:childhood()

					return option and option.id
				end,
				on_reset = callback(self._character_create, "set_childhood"),
				description = Localize(archetype_page_data.childhood.description),
				top_frame = function (grid, grid_size, grid_scenegraph)
					local page_data = archetype_page_data.childhood
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local growing_up_page = {
		name = "growing_up",
		show_character = false,
		show_companion = false,
		on_enter = function (page, previous_page)
			local widgets, widgets_by_name = self:_create_growing_up_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end
			end

			self._backstory_selection_page = true
		end,
		on_leave = function (page)
			self:_destroy_page_widgets()

			self._backstory_selection_page = false
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_growing_up_options()
				end,
				selected_option = function ()
					local option = self._character_create:growing_up()

					return option and option.id
				end,
				on_reset = callback(self._character_create, "set_growing_up", nil),
				description = Localize(archetype_page_data.growing_up.description),
				top_frame = function (grid, grid_size, grid_scenegraph)
					local page_data = archetype_page_data.growing_up
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local formative_event_page = {
		name = "formative_event",
		show_character = false,
		show_companion = false,
		on_enter = function (page, previous_page)
			local widgets, widgets_by_name = self:_create_formative_event_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end
			end

			self._backstory_selection_page = true
		end,
		on_leave = function (page)
			self:_destroy_page_widgets()

			self._backstory_selection_page = false
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_formative_event_options()
				end,
				selected_option = function ()
					local option = self._character_create:formative_event()

					return option and option.id
				end,
				on_reset = callback(self._character_create, "set_formative_event", nil),
				description = Localize(archetype_page_data.formative_event.description),
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = archetype_page_data.formative_event
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local appearance_page = {
		name = "appearance",
		show_character = true,
		show_companion = false,
		on_enter = function (page, previous_page)
			self._character_create:set_gear_visible(false)

			local widgets, widgets_by_name = self:_create_appearance_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)
			self:_update_appearance_background()
			self:_toggle_continue_alternative_action(true)
			self._profile_spawner:disable_rotation_input(false)

			if self._is_barber then
				self._character_create:add_default_barber_items(archetype)
			end

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end
			end
		end,
		on_leave = function (page, next_page)
			self:_toggle_continue_alternative_action(false)
			self:_set_camera(nil, nil, nil)
			self:_destroy_page_widgets()

			self._apperance_option_selected_index = nil
		end,
		update = function (page)
			if self._is_barber_appearance then
				local is_disabled = true
				local loadout = profile and profile.loadout

				if loadout then
					local player = Managers.player:local_player(1)
					local real_profile = player:profile()
					local has_modifications = self._character_create:has_modifications(real_profile, {
						"loadout",
						"height",
					})

					is_disabled = not has_modifications
				end

				self:_update_continue_button("slot_modifications", is_disabled)
			end

			local page_widgets = self._page_grids[1].widgets

			for ii = 1, #page_widgets do
				local widget = page_widgets[ii]
				local option = widget.content.option
				local visible, available, reason, reason_display_name = self:_check_valid_option(option)

				widget.content.visible = visible
				widget.content.hide_in_grid = not visible

				self:_update_widget_restrictions(widget, available, reason, reason_display_name)
			end
		end,
		grids = {
			{
				template = "category_button",
				init = function (grid_index, grid_data)
					grid_data.focused_on_gamepad_navigation = true

					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_appearance_options()
				end,
				selected_option = function ()
					return self._apperance_option_selected_index
				end,
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = archetype_page_data.appearance
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local companion_appearance_page = {
		name = "companion_appearance",
		show_character = false,
		show_companion = not self._is_barber_mindwipe,
		on_enter = function (page, previous_page)
			self:_toggle_continue_alternative_action(true)

			local widgets, widgets_by_name = self:_create_appearance_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)
			self:_update_appearance_background()
			self._profile_spawner:disable_rotation_input(false)

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end
			end
		end,
		on_leave = function (page)
			self:_toggle_continue_alternative_action(false)
			self:_destroy_page_widgets()

			self._apperance_option_selected_index = nil
		end,
		update = function ()
			if self._is_barber_companion_appearance then
				local has_modifications = true
				local loadout = profile and profile.loadout

				if loadout then
					local player = Managers.player:local_player(1)
					local real_profile = player:profile()

					has_modifications = self._character_create:has_modifications(real_profile, {
						"loadout",
					})
				end

				self:_update_continue_button("slot_modifications", not has_modifications)
			end
		end,
		grids = {
			{
				template = "category_button",
				init = function (grid_index, grid_data)
					grid_data.focused_on_gamepad_navigation = true

					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_companion_appearance_options()
				end,
				selected_option = function ()
					return self._apperance_option_selected_index
				end,
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = archetype_page_data.companion_appearance
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize("loc_arbites_customization_dog_title")),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local personality_page = {
		name = "personality",
		show_character = true,
		show_companion = false,
		on_enter = function (page, previous_page)
			self._character_create:set_gear_visible(false)

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end
			end

			self._profile_spawner:disable_rotation_input(self:_is_in_barber_chair())
		end,
		on_leave = function (page, next_page)
			self:_play_sound(UISoundEvents.character_appearence_stop_voice_preview)

			if self._voice_sample_source then
				local world = Managers.ui:world()
				local wwise_world = Managers.world:wwise_world(world)

				WwiseWorld.destroy_manual_source(wwise_world, self._voice_sample_source)

				self._voice_sample_source = nil
			end
		end,
		on_continue = function (page)
			if archetype == "broker" then
				return self:_fetch_suggested_names()
			end
		end,
		grids = {
			{
				template = "personality_button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_personality_options()
				end,
				selected_option = function ()
					local option = self._character_create:personality()

					return option and option.id
				end,
				description = Localize(archetype_page_data.personality.description),
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = archetype_page_data.personality
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local voice_page = {
		name = "voice",
		show_character = true,
		show_companion = false,
		on_enter = function (page, previous_page)
			self._character_create:set_gear_visible(false)

			local world_spawner = self._world_spawners[self._active_world]
			local world = world_spawner:world()
			local camera_unit = World.unit_by_name(world, "vox_camera")

			if camera_unit then
				local anim_time = 1.5
				local func_ptr = math.easeOutCubic
				local position = Unit.world_position(camera_unit, 1)
				local rotation = Unit.world_rotation(camera_unit, 1)

				world_spawner:set_target_camera_position(position.x, position.y, position.z, anim_time, func_ptr)
				world_spawner:set_target_camera_rotation(rotation, anim_time, func_ptr)
			end

			local voice_screen_unit = World.unit_by_name(world, "scitari_voice_creation_cogitator")

			if voice_screen_unit then
				Unit.flow_event(voice_screen_unit, "start")

				local extension_manager = Managers.ui:world_extension_manager(world)
				local component_system = extension_manager:system("component_system")
				local components = component_system:get_components(voice_screen_unit, "CrypticCharacterCreateVoiceScreen")

				if components then
					self._voice_screen_component = components[1]
				end
			end

			self._waveform_screen_unit = World.unit_by_name(world, "cryptic_cogitator_01")

			self:_toggle_continue_alternative_action(true)
			self._profile_spawner:disable_rotation_input(true)
			self._profile_spawner:set_auto_rotation_return(true)

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end

				local mask_widget = self._widgets_by_name.grid_1_mask

				mask_widget.style.style_id_1.size_addition[2] = 30

				local background_widget = self._widgets_by_name.grid_1_grid_background

				background_widget.style.background.offset[3] = -1
			end

			self._navigation.index = self._navigation.index + 1
		end,
		on_leave = function (page, next_page)
			local world_spawner = self._world_spawners[self._active_world]
			local world = world_spawner:world()
			local voice_screen_unit = World.unit_by_name(world, "scitari_voice_creation_cogitator")

			if voice_screen_unit then
				Unit.flow_event(voice_screen_unit, "stop")
			end

			self:_set_camera(nil, nil, nil)
			self:_toggle_continue_alternative_action(false)
			self:_play_sound(UISoundEvents.character_appearence_stop_voice_preview)

			if self._voice_sample_source then
				local world = Managers.ui:world()
				local wwise_world = Managers.world:wwise_world(world)

				WwiseWorld.destroy_manual_source(wwise_world, self._voice_sample_source)

				self._voice_sample_source = nil
			end

			if not self._is_barber_mindwipe and archetype == "cryptic" and next_page.index > page.index then
				if self._fade_animation_id then
					self:_stop_animation(self._fade_animation_id)
				end

				self._fade_animation_id = self:_start_animation("on_level_switch")
			end

			self._profile_spawner:set_auto_rotation_return(false)

			if archetype == "cryptic" then
				return self:_fetch_suggested_names()
			end
		end,
		grids = {
			{
				description = nil,
				height = 680,
				template = "voice_slider_matrix",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_voice_options()
				end,
				additional_options = function ()
					return self:_get_personality_options()
				end,
				selected_option = function ()
					local option = self._character_create:personality()

					return option and option.id
				end,
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = archetype_page_data.voice
					local passes = {
						{
							pass_type = "texture",
							style_id = "background_selected",
							value = "content/ui/materials/backgrounds/voice_matrix",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									210,
									0,
								},
								size = {
									470,
									415,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "background_gradient",
							value = "content/ui/materials/masks/gradient_horizontal_sides_02",
							style = {
								horizontal_alignment = "center",
								scale_to_material = true,
								vertical_alignment = "top",
								size = {
									470,
									410,
								},
								offset = {
									0,
									210,
									3,
								},
								color = Color.black(255, true),
							},
						},
						{
							pass_type = "texture",
							style_id = "top_divider",
							value = "content/ui/materials/dividers/divider_line_01",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								color = Color.terminal_corner_hover(150, true),
								offset = {
									0,
									210,
									0,
								},
								size = {
									480,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "bottom_divider",
							value = "content/ui/materials/dividers/divider_line_01",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "bottom",
								color = Color.terminal_corner_hover(150, true),
								offset = {
									0,
									388,
									0,
								},
								size = {
									480,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							value = "content/ui/materials/dividers/horizontal_frame_big_middle",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "bottom",
								size = {
									485,
									44,
								},
								offset = {
									0,
									415,
									1,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local crime_page = {
		name = "crime",
		show_character = archetype ~= "cryptic",
		show_companion = archetype == "adamant" and not self._is_barber_mindwipe,
		on_enter = function (page, previous_page)
			if archetype == "cryptic" then
				local widgets, widgets_by_name = self:_create_crime_widgets()

				self:_setup_page_widgets(widgets, widgets_by_name)
			end

			if archetype ~= "cryptic" then
				self._profile_spawner:disable_rotation_input(self:_is_in_barber_chair())
			end

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end
			end
		end,
		on_leave = function (page, next_page)
			if archetype == "cryptic" then
				self:_destroy_page_widgets()
			end
		end,
		on_continue = function (page)
			return self:_fetch_suggested_names()
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_crime_options()
				end,
				selected_option = function ()
					local option = self._character_create:crime()

					return option and option.id
				end,
				description = Localize(archetype_page_data.crime.description),
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = archetype_page_data.crime
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local name_page = {
		name = "name",
		show_character = true,
		show_companion = (archetype == "adamant" or archetype == "cryptic") and not self._is_barber_mindwipe,
		spawn_position_offset = not self._is_barber_mindwipe and archetype == "cryptic" and {
			0,
			0,
			-0.3,
		},
		camera_position_offset = not self._is_barber_mindwipe and archetype == "cryptic" and {
			0,
			0,
			-0.3,
		},
		on_enter = function (page, previous_page)
			self._character_create:set_gear_visible(true)

			if not self._is_barber then
				self._character_create:shelve_item_per_slot("slot_prop")
			end

			self:_set_camera(nil, nil, nil)
			self:_toggle_continue_alternative_action(true)

			if archetype == "cryptic" then
				self._profile_spawner:disable_rotation_input(false)
			else
				self._profile_spawner:disable_rotation_input(self:_is_in_barber_chair())
			end

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end
			end

			self:_pan_camera(false)

			local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
			local input_widget = support_widgets and support_widgets.name_input
			local name = input_widget and input_widget.content.input_text

			if name then
				local error_message = input_widget.content.error_message

				self:_check_input_errors(name, error_message)
			end
		end,
		on_leave = function (page, next_page)
			local show_gear = next_page.index > page.index

			self._character_create:set_gear_visible(show_gear)

			if not show_gear then
				self._character_create:try_unshelve_item_per_slot("slot_prop")
			end

			self:_set_camera(nil, nil, nil)

			if not self._is_barber_mindwipe and archetype == "cryptic" and next_page.index < page.index then
				if self._fade_animation_id then
					self:_stop_animation(self._fade_animation_id)
				end

				self._fade_animation_id = self:_start_animation("on_level_switch")
			end

			self:_toggle_continue_alternative_action(false)

			if next_page.index < page.index then
				self:_pan_camera(true)
			end
		end,
		on_continue = function (page)
			if not self._character_name_status.custom then
				return
			end

			self:_show_loading_awaiting_validation(true)

			local name = self._character_create:name()

			return self._character_create:check_name(name):next(function (data)
				self:_show_loading_awaiting_validation(false)

				if data.permitted == false then
					local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
					local input_widget = support_widgets and support_widgets.name_input
					local error_message = input_widget and input_widget.content.error_message

					self:_update_continue_button("input_error", true, error_message)

					return false
				end

				return true
			end):catch(function (error)
				self:_show_loading_awaiting_validation(false)

				return false
			end)
		end,
		update = function ()
			local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
			local input_widget = support_widgets and support_widgets.name_input

			if input_widget then
				if self._using_cursor_navigation then
					input_widget.content.hotspot.is_selected = false
					input_widget.content.hotspot.is_focused = false
				else
					input_widget.content.hotspot.is_selected = true
					input_widget.content.hotspot.is_focused = true
				end
			end
		end,
		grids = {
			{
				init = function (grid_index, grid_data)
					return self:_generate_final_page_widgets(grid_index, grid_data)
				end,
			},
		},
	}
	local name_companion_page = {
		name = "name_companion",
		show_character = true,
		show_companion = not self._is_barber_mindwipe,
		on_enter = function (page, previous_page)
			self:_toggle_continue_alternative_action(true)
			self._profile_spawner:disable_rotation_input(self:_is_in_barber_chair())

			local grids = page.grids

			if grids then
				for ii = 1, #grids do
					local grid = grids[ii]

					self:_populate_page_grid(1, grid)
				end
			end

			local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
			local input_widget = support_widgets and support_widgets.companion_name_input
			local name = input_widget and input_widget.content.input_text

			self:_pan_camera(false)

			if input_widget then
				local error_message = input_widget.content.error_message

				self:_check_input_errors(name, error_message)
			end
		end,
		on_leave = function ()
			self:_toggle_continue_alternative_action(false)
		end,
		on_continue = function (page)
			if not self._companion_name_status.custom then
				return
			end

			self:_show_loading_awaiting_validation(true)

			local name = self._character_create:companion_name()

			return self._character_create:check_companion_name(name):next(function (data)
				self:_show_loading_awaiting_validation(false)

				if data.permitted == false then
					local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
					local input_widget = support_widgets and support_widgets.companion_name_input
					local error_message = input_widget and input_widget.content.error_message

					self:_update_continue_button("input_error", true, error_message)

					return false
				end

				return true
			end):catch(function (error)
				self:_show_loading_awaiting_validation(false)

				return false
			end)
		end,
		update = function ()
			local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
			local input_widget = support_widgets and support_widgets.companion_name_input

			if input_widget then
				if self._using_cursor_navigation then
					input_widget.content.hotspot.is_selected = false
					input_widget.content.hotspot.is_focused = false
				else
					input_widget.content.hotspot.is_selected = true
					input_widget.content.hotspot.is_focused = true
				end
			end
		end,
		grids = {
			{
				init = function (grid_index, grid_data)
					return self:_generate_final_page_widgets(grid_index, grid_data, true)
				end,
			},
		},
	}
	local pages

	if self._is_barber_appearance then
		pages = {
			appearance_page,
		}
	elseif self._is_barber_companion_appearance then
		pages = {
			companion_appearance_page,
		}
	elseif archetype == "adamant" and self._is_barber_mindwipe then
		pages = {
			planet_page,
			childhood_page,
			growing_up_page,
			formative_event_page,
			appearance_page,
			personality_page,
			crime_page,
			name_page,
			name_companion_page,
		}
	elseif archetype == "adamant" then
		pages = {
			planet_page,
			childhood_page,
			growing_up_page,
			formative_event_page,
			appearance_page,
			personality_page,
			companion_appearance_page,
			crime_page,
			name_page,
			name_companion_page,
		}
	elseif archetype == "broker" then
		pages = {
			childhood_page,
			growing_up_page,
			planet_page_side_scroll,
			appearance_page,
			personality_page,
			name_page,
		}
	elseif archetype == "cryptic" then
		pages = {
			childhood_page,
			growing_up_page,
			formative_event_page,
			crime_page,
			planet_page_side_scroll,
			appearance_page,
			voice_page,
			name_page,
		}
	else
		pages = {
			planet_page,
			childhood_page,
			growing_up_page,
			formative_event_page,
			appearance_page,
			personality_page,
			crime_page,
			name_page,
		}
	end

	for ii = 1, #pages do
		pages[ii].index = ii
	end

	return pages
end

CharacterAppearanceView._setup_page_widgets = function (self, widgets, widgets_by_name)
	self:_destroy_page_widgets()

	self._page_widgets = widgets
	self._page_widgets_by_name = widgets_by_name
end

CharacterAppearanceView._create_planet_widgets = function (self)
	local material = "content/ui/materials/base/ui_default_base"
	local textures = {
		{
			value = "content/ui/textures/backgrounds/backstory/home_planet_1",
			position = {
				0,
				0,
			},
			size = {
				2754,
				1600,
			},
		},
		{
			value = "content/ui/textures/backgrounds/backstory/home_planet_2",
			position = {
				2754,
				0,
			},
			size = {
				2754,
				1600,
			},
		},
		{
			value = "content/ui/textures/backgrounds/backstory/home_planet_3",
			position = {
				0,
				1600,
			},
			size = {
				2754,
				1600,
			},
		},
		{
			value = "content/ui/textures/backgrounds/backstory/home_planet_4",
			position = {
				2754,
				1600,
			},
			size = {
				2754,
				1600,
			},
		},
	}
	local background_planet_passes = {}

	for ii = 1, #textures do
		local texture = textures[ii]

		background_planet_passes[#background_planet_passes + 1] = {
			pass_type = "texture",
			value_id = "background_" .. ii,
			style_id = "background_" .. ii,
			value = material,
			style = {
				size = texture.size,
				offset = {
					texture.position[1],
					texture.position[2],
					0,
				},
				material_values = {
					texture_map = texture.value,
				},
			},
		}
	end

	local background_planet_definitions = UIWidget.create_definition(background_planet_passes, "screen", nil, {
		5508,
		3200,
	})
	local background_planet_widget = self:_create_widget("background_planet", background_planet_definitions)
	local planet_passes = {}

	for id, data in pairs(HomePlanets) do
		local name = id
		local planet_image = data.image

		if planet_image then
			local planet_size = planet_image.size
			local planet_position = data.position
			local planet_pass = {
				pass_type = "texture",
				value = "content/ui/materials/base/ui_default_base",
				value_id = name,
				style_id = name,
				style = {
					offset = {
						planet_position[1],
						planet_position[2],
						3,
					},
					size = planet_size,
					size_addition = {
						-planet_size[1],
						-planet_size[2],
					},
					material_values = {
						texture_map = planet_image.path,
					},
				},
			}

			planet_passes[#planet_passes + 1] = planet_pass
		end
	end

	local planets_definition = UIWidget.create_definition(planet_passes, "screen")
	local planet_widget = self:_create_widget("home_planets", planets_definition)
	local widgets = {
		background_planet_widget,
		planet_widget,
	}
	local widgets_by_name = {
		background = background_planet_widget,
		planets = planet_widget,
	}

	return widgets, widgets_by_name
end

CharacterAppearanceView._create_childhood_widgets = function (self)
	local material = "content/ui/materials/backgrounds/backstory/childhood"
	local textures = {
		{
			size = {
				1920,
				1080,
			},
			position = {
				0,
				0,
			},
		},
	}
	local background_passes = {}

	background_passes[#background_passes + 1] = {
		pass_type = "rect",
		style = {
			color = Color.black(255, true),
		},
	}

	for ii = 1, #textures do
		local texture = textures[ii]

		background_passes[#background_passes + 1] = {
			pass_type = "texture",
			value_id = "background_" .. ii,
			style_id = "background_" .. ii,
			value = material,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = texture.size,
				offset = {
					texture.position[1],
					texture.position[2],
					0,
				},
			},
		}
	end

	local background_definitions = UIWidget.create_definition(background_passes, "screen")
	local widget = self:_create_widget("background_page", background_definitions)
	local widgets = {
		widget,
	}
	local widgets_by_name = {
		background = widget,
	}

	return widgets, widgets_by_name
end

CharacterAppearanceView._create_growing_up_widgets = function (self)
	local material = "content/ui/materials/backgrounds/backstory/growing_up"
	local textures = {
		{
			size = {
				1920,
				1080,
			},
			position = {
				0,
				0,
			},
		},
	}
	local background_passes = {}

	background_passes[#background_passes + 1] = {
		pass_type = "rect",
		style = {
			color = Color.black(255, true),
		},
	}

	for ii = 1, #textures do
		local texture = textures[ii]

		background_passes[#background_passes + 1] = {
			pass_type = "texture",
			value_id = "background_" .. ii,
			style_id = "background_" .. ii,
			value = material,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = texture.size,
				offset = {
					texture.position[1],
					texture.position[2],
					0,
				},
			},
		}
	end

	local background_definitions = UIWidget.create_definition(background_passes, "screen")
	local widget = self:_create_widget("background_page", background_definitions)
	local widgets = {
		widget,
	}

	return widgets
end

CharacterAppearanceView._create_crime_widgets = function (self)
	local material = "content/ui/materials/backgrounds/backstory/cryptic_crime"
	local textures = {
		{
			size = {
				1920,
				1080,
			},
			position = {
				0,
				0,
			},
		},
	}
	local background_passes = {}

	background_passes[#background_passes + 1] = {
		pass_type = "rect",
		style = {
			color = Color.black(255, true),
		},
	}

	for ii = 1, #textures do
		local texture = textures[ii]

		background_passes[#background_passes + 1] = {
			pass_type = "texture",
			value_id = "background_" .. ii,
			style_id = "background_" .. ii,
			value = material,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = texture.size,
				offset = {
					texture.position[1],
					texture.position[2],
					0,
				},
			},
		}
	end

	local background_definitions = UIWidget.create_definition(background_passes, "screen")
	local widget = self:_create_widget("background_page", background_definitions)
	local widgets = {
		widget,
	}

	return widgets
end

CharacterAppearanceView._create_formative_event_widgets = function (self)
	local material = "content/ui/materials/backgrounds/backstory/formative_event"
	local textures = {
		{
			size = {
				1920,
				1080,
			},
			position = {
				0,
				0,
			},
		},
	}
	local background_passes = {}

	background_passes[#background_passes + 1] = {
		pass_type = "rect",
		style = {
			color = Color.black(255, true),
		},
	}

	for ii = 1, #textures do
		local texture = textures[ii]

		background_passes[#background_passes + 1] = {
			pass_type = "texture",
			value_id = "background_" .. ii,
			style_id = "background_" .. ii,
			value = material,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = texture.size,
				offset = {
					texture.position[1],
					texture.position[2],
					0,
				},
			},
		}
	end

	local background_definitions = UIWidget.create_definition(background_passes, "screen")
	local widget = self:_create_widget("background_page", background_definitions)
	local widgets = {
		widget,
	}

	return widgets
end

CharacterAppearanceView._create_appearance_widgets = function (self)
	local background_definiton = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "top_frame",
			value = "content/ui/materials/dividers/horizontal_frame_big_upper",
			value_id = "top_frame",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					nil,
					36,
				},
				offset = {
					0,
					-18,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				color = Color.terminal_grid_background(nil, true),
				size_addition = {
					20,
					30,
				},
				offset = {
					0,
					-15,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					36,
				},
				offset = {
					0,
					18,
					2,
				},
			},
		},
	}, "grid_2_pivot", nil, {
		0,
		0,
	})
	local widget = self:_create_widget("background_appearance", background_definiton)
	local widgets = {
		widget,
	}
	local widgets_by_name = {
		background = widget,
	}

	return widgets, widgets_by_name
end

CharacterAppearanceView._destroy_page_widgets = function (self)
	if self._page_widgets then
		for ii = 1, #self._page_widgets do
			local widget = self._page_widgets[ii]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end
	end

	self._page_widgets = nil
	self._page_widgets_by_name = nil
end

CharacterAppearanceView._get_childhood_options = function (self)
	local childhood = self._character_create:childhood_options()
	local childhood_options = {}

	for id, option in pairs(childhood) do
		childhood_options[#childhood_options + 1] = {
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function ()
				self._character_create:set_childhood(id)

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return childhood_options
end

CharacterAppearanceView._get_growing_up_options = function (self)
	local growing_up = self._character_create:growing_up_options()
	local growing_up_options = {}

	for id, option in pairs(growing_up) do
		growing_up_options[#growing_up_options + 1] = {
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function ()
				self._character_create:set_growing_up(id)

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return growing_up_options
end

CharacterAppearanceView._get_formative_event_options = function (self)
	local formative_events = self._character_create:formative_event_options()
	local formative_events_options = {}

	for id, option in pairs(formative_events) do
		formative_events_options[#formative_events_options + 1] = {
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function ()
				self._character_create:set_formative_event(id)

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return formative_events_options
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
		renderer_name = renderer_name,
	}
end

CharacterAppearanceView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)

	local legend_inputs = self._definitions.legend_inputs

	for ii = 1, #legend_inputs do
		local legend_input = legend_inputs[ii]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

CharacterAppearanceView._setup_button_callbacks = function (self)
	self._widgets_by_name.continue_button.content.hotspot.pressed_callback = callback(self, "_on_continue_pressed")
end

CharacterAppearanceView._setup_profile_background = function (self)
	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype
	local selected_archetype_name = selected_archetype.name

	self._widgets_by_name.corners.content.left_upper = UISettings.inventory_frames_by_archetype[selected_archetype_name].right_upper
	self._widgets_by_name.corners.content.right_upper = UISettings.inventory_frames_by_archetype[selected_archetype_name].right_upper
	self._widgets_by_name.corners.content.left_lower = UISettings.inventory_frames_by_archetype[selected_archetype_name].left_lower
	self._widgets_by_name.corners.content.right_lower = UISettings.inventory_frames_by_archetype[selected_archetype_name].right_lower
end

CharacterAppearanceView.event_register_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	local spawn_position = Unit.world_position(spawn_point_unit, 1)

	self._spawn_point_position = Vector3.to_array(spawn_position)
end

CharacterAppearanceView._is_in_barber_chair = function (self, archetype)
	return self._is_barber_mindwipe and MINDWIPE_CHAIR_PAGES[self._active_page_name]
end

CharacterAppearanceView._spawn_profile = function (self, spawn_point_unit, optional_state_machine, optional_animation_event)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	if not spawn_point_unit then
		return
	end

	local active_page = self._pages[self._active_page_number]
	local show_character = active_page.show_character
	local show_companion = active_page.show_companion
	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)
	local spawn_position_offset = active_page.spawn_position_offset

	if spawn_position_offset then
		spawn_position[1] = spawn_position[1] + spawn_position_offset[1]
		spawn_position[2] = spawn_position[2] + spawn_position_offset[2]
		spawn_position[3] = spawn_position[3] + spawn_position_offset[3]
	end

	local world = Unit.world(spawn_point_unit)
	local world_spawner = self:_world_spawner_by_world(world)
	local camera = world_spawner:camera()
	local unit_spawner = world_spawner:unit_spawner()

	if show_companion or show_character then
		local profile = self._character_create:profile()
		local profile_spawner = UIProfileSpawner:new("CharacterAppearanceView", world, camera, unit_spawner)
		local _, companion_breed_name = ProfileUtils.has_companion(profile)
		local companion_state_machine, companion_animation_event

		if companion_breed_name then
			local companion_breed_settings = Breeds[companion_breed_name]

			companion_state_machine = companion_breed_settings.inventory_state_machine
			companion_animation_event = show_companion and show_character and "idle_inventory" or "idle_cosmetics"
		end

		local companion_data = {
			ignore = false,
			position = spawn_position,
			rotation = spawn_rotation,
			state_machine = companion_state_machine,
			animation_event = companion_animation_event,
		}
		local height = self:_is_in_barber_chair() and 1 or self._character_create:height()
		local scale = Vector3.one() * height

		profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation, scale, nil, nil, nil, nil, nil, nil, nil, nil, companion_data)
		profile_spawner:toggle_companion(show_companion)
		profile_spawner:toggle_character(show_character)

		local archetype_settings = profile.archetype
		local archetype_name = archetype_settings.name
		local character_appearance_state_machine = archetype_settings.character_appearance_state_machine
		local animations_per_archetype = CharacterAppearanceViewSettings.animations_per_archetype
		local archetype_animations_settings = animations_per_archetype[archetype_name]
		local animations_per_page = archetype_animations_settings.animations_per_page
		local animation_settings = animations_per_page[self._active_page_name] or animations_per_page.default
		local animation_event = animation_settings.default_event

		if optional_state_machine == nil then
			profile_spawner:assign_state_machine(character_appearance_state_machine, animation_event)
		elseif optional_animation_event ~= nil then
			profile_spawner:assign_state_machine(optional_state_machine, optional_animation_event)
		end

		self._profile_spawner = profile_spawner
	end
end

CharacterAppearanceView._on_continue_pressed = function (self)
	if not self._using_cursor_navigation then
		self:_play_sound(UISoundEvents.character_appearence_confirm)
	end

	local active_page_number = self._active_page_number
	local active_page = self._pages[self._active_page_number]
	local continue_promise

	self:_update_continue_button("continue_validation", true)

	if active_page.on_continue then
		continue_promise = active_page.on_continue(active_page)
	end

	continue_promise = continue_promise or Promise.resolved(true)

	continue_promise:next(function (result)
		self:_update_continue_button("continue_validation", false)

		if result then
			local next_page_index = active_page_number + 1
			local next_page = self._pages[next_page_index]

			if next_page then
				self:_open_page(next_page_index)
			else
				self:_show_final_popup()
			end
		end
	end)
end

CharacterAppearanceView._show_final_popup = function (self)
	local context

	if self._is_barber_mindwipe then
		local parent = self._parent
		local mindwipe_cost = parent._cost
		local balance_amount = parent._balance

		context = {
			description_text = "loc_popup_description_barber_finalise_mindwipe",
			title_text = "loc_popup_header_barber_finalise_mindwipe",
			description_text_params = {
				cost = mindwipe_cost,
				balance = balance_amount,
			},
			options = {
				{
					close_on_pressed = true,
					stop_exit_sound = true,
					text = "loc_barber_vendor_confirm_button",
					on_pressed_sound = UISoundEvents.finalize_creation_confirm,
					callback = function ()
						if not self.__deleted then
							local character_create = self._character_create
							local player = Managers.player:local_player(1)
							local real_character_id = player:character_id()

							self._confirm_popup_id = nil

							local operation_cost = parent:get_mindwipe_cost()

							character_create:transform(real_character_id, operation_cost)

							self._waiting_for_transform = true
						end
					end,
				},
				{
					close_on_pressed = true,
					hotkey = "back",
					template_type = "terminal_button_small",
					text = "loc_popup_button_cancel",
					callback = function ()
						self._confirm_popup_id = nil
					end,
				},
			},
		}
	elseif self._is_barber_appearance or self._is_barber_companion_appearance then
		local player = Managers.player:local_player(1)
		local real_profile = player:profile()
		local is_companion_appearance = self._is_barber_companion_appearance
		local archetype = real_profile and real_profile.archetype
		local companion_breed_name = archetype and archetype.companion_breed or "no_companion_in_archetype"

		context = {
			title_text = "loc_popup_header_barber_finalise_changes",
			description_text = not is_companion_appearance and "loc_popup_description_barber_finalise_changes" or "loc_popup_description_barber_" .. companion_breed_name .. "_finalise_changes",
			options = {
				{
					close_on_pressed = true,
					stop_exit_sound = true,
					text = "loc_barber_vendor_confirm_button",
					on_pressed_sound = UISoundEvents.finalize_creation_confirm,
					callback = function ()
						if not self.__deleted then
							local character_create = self._character_create
							local height = character_create:height()
							local profile = character_create and character_create:profile()
							local loadout = profile and profile.loadout

							if loadout then
								local changed_items = self._character_create:filter_changed_items(real_profile)

								if changed_items then
									Items.equip_slot_master_items(changed_items)
								end

								local real_unit = player.player_unit
								local character_id = real_profile.character_id

								if self._character_create:has_modifications(real_profile, {
									"height",
								}) then
									Managers.data_service.profiles:set_character_height(character_id, height)

									real_profile.personal.character_height = height

									Unit.set_local_scale(real_unit, 1, Vector3.one() * height)
								end
							end

							local parent = self._parent

							if parent then
								parent:play_vo_events(VO_EVENTS.vendor_purchase, "barber_a", nil, 1.7)

								parent._active_view_instance = nil

								parent:_handle_back_pressed()
							end

							self._confirm_popup_id = nil
						end
					end,
				},
				{
					close_on_pressed = true,
					hotkey = "back",
					template_type = "terminal_button_small",
					text = "loc_popup_button_cancel",
					callback = function ()
						self._confirm_popup_id = nil
					end,
				},
			},
		}
	else
		context = {
			description_text = "loc_popup_description_create_character",
			title_text = "loc_popup_header_create_character",
			options = {
				{
					close_on_pressed = true,
					stop_exit_sound = true,
					text = "loc_character_create_confirm_play_prologue",
					on_pressed_sound = UISoundEvents.finalize_creation_confirm,
					callback = function ()
						if not self.__deleted then
							local skip_onboarding = false

							self._confirm_popup_id = nil

							Managers.event:trigger("event_create_new_character_continue", skip_onboarding)
						end
					end,
				},
			},
		}

		local profile = self._character_create:profile()
		local selected_archetype = profile and profile.archetype
		local disable_prologue_skip = selected_archetype and selected_archetype.disable_prologue_skip

		if Managers.data_service.account:has_completed_onboarding() and not disable_prologue_skip then
			context.options[#context.options + 1] = {
				close_on_pressed = true,
				stop_exit_sound = true,
				text = "loc_character_create_confirm_skip_prologue",
				on_pressed_sound = UISoundEvents.finalize_creation_confirm,
				callback = function ()
					if not self.__deleted then
						local skip_onboarding = true

						self._confirm_popup_id = nil

						Managers.event:trigger("event_create_new_character_continue", skip_onboarding)
					end
				end,
			}
		end

		context.options[#context.options + 1] = {
			close_on_pressed = true,
			hotkey = "back",
			template_type = "terminal_button_small",
			text = "loc_popup_button_cancel",
			callback = function ()
				if not self.__deleted then
					self._confirm_popup_id = nil
				end
			end,
		}
	end

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._confirm_popup_id = id
	end)
end

CharacterAppearanceView._open_page = function (self, index)
	self._navigation = {
		grid = nil,
		index = nil,
	}

	local current_page = self._pages[self._active_page_number]

	if current_page and current_page.on_leave then
		current_page.on_leave(current_page, self._pages[index])
	end

	self:_clear_continue_disable_data()

	for ii = 1, #self._page_grids do
		self:_destroy_page_grid(ii)
	end

	local previous_index = self._active_page_number
	local previous_page = previous_index and self._pages[previous_index]

	self._active_page_number = index
	self._active_page_name = self._pages[self._active_page_number].name

	local new_page = self._pages[index]
	local prev_show_character = previous_page and previous_page.show_character
	local current_show_character = new_page.show_character
	local prev_show_companion = previous_page and previous_page.show_companion
	local current_show_companion = new_page.show_companion
	local render_world = new_page.render_world
	local changed_show_character = not prev_show_character ~= not current_show_character
	local changed_show_companion = not prev_show_companion ~= not current_show_companion

	self:_set_should_render_world(current_show_character or current_show_companion or render_world)
	self:_set_active_world(self._active_page_name, changed_show_character or changed_show_companion)

	if new_page.on_enter then
		new_page.on_enter(new_page, previous_page)
	end

	if self._is_barber_mindwipe then
		local page_open_vo = self._page_open_vo[index]

		if page_open_vo then
			local parent = self._parent

			if parent then
				parent:play_vo_events(page_open_vo, "training_ground_psyker_a", nil, 0.8)
			end

			self._page_open_vo[index] = nil
		end

		if self._active_page_number == #self._pages then
			self:_check_mindwipe_changes()
		end
	end

	self:_change_page_indicator(index)
	self:_check_widget_choice_detail_visibility()
end

CharacterAppearanceView._move_background_to_position = function (self, planet, skip_animation)
	local planets_widget = self._page_widgets_by_name.planets
	local background_widget = self._page_widgets_by_name.background
	local planets_widget_content = planets_widget.content
	local start_planet = planets_widget_content.current_planet
	local end_planet = planets_widget_content.new_planet

	if planet == end_planet then
		return
	end

	local animation_params = self._home_planet_animation_params

	if not animation_params then
		animation_params = {
			start_background_position = {},
			end_background_position = {},
			start_planet_position = {},
			end_planet_position = {},
		}
		self._home_planet_animation_params = animation_params
	end

	local planet_offset_on_screen_x, planet_offset_on_screen_y = unpack(CharacterAppearanceViewSettings.planet_offset)
	local start_position_x, start_position_y, background_start_position_x, background_start_position_y, start_planet_position_x, start_planet_position_y
	local scale = 1
	local ratio = 1
	local is_animation_active = self._planet_background_animation_id and self:_is_animation_active(self._planet_background_animation_id)

	if start_planet and not is_animation_active then
		start_position_x, start_position_y = unpack(start_planet.position)

		local start_planet_size = start_planet.image.size

		start_planet_position_x = start_position_x - planet_offset_on_screen_x + start_planet_size[1] / 2
		start_planet_position_y = start_position_y - planet_offset_on_screen_y + start_planet_size[2] / 2
		background_start_position_x = planet_offset_on_screen_x - start_position_x
		background_start_position_y = planet_offset_on_screen_y - start_position_y
	else
		background_start_position_x = background_widget.content.original_offset and background_widget.content.original_offset[1] or background_widget.offset[1]
		background_start_position_y = background_widget.content.original_offset and background_widget.content.original_offset[2] or background_widget.offset[2]
		start_planet_position_x = -1 * (planets_widget.content.original_offset and planets_widget.content.original_offset[1] or planets_widget.offset[1])
		start_planet_position_y = -1 * (planets_widget.content.original_offset and planets_widget.content.original_offset[2] or planets_widget.offset[2])
	end

	local planet_size = planet.image.size
	local end_position_x, end_position_y = unpack(planet.position)
	local end_planet_position_x = end_position_x - planet_offset_on_screen_x + planet_size[1] / 2
	local end_planet_position_y = end_position_y - planet_offset_on_screen_y + planet_size[2] / 2
	local background_end_position_x = planet_offset_on_screen_x - end_position_x
	local background_end_position_y = planet_offset_on_screen_y - end_position_y

	if skip_animation then
		background_widget.offset[1] = background_end_position_x * scale * ratio
		background_widget.offset[2] = background_end_position_y * scale * ratio
		planets_widget.offset[1] = -(end_planet_position_x * scale) * ratio
		planets_widget.offset[2] = -(end_planet_position_y * scale) * ratio
		planets_widget_content.current_planet = planet
		planets_widget_content.new_planet = planet

		local planet_style = planets_widget.style[planet.id]

		planet_style.visible = true
		planet_style.size_addition[1] = 0
		planet_style.size_addition[2] = 0
	else
		animation_params.start_background_position[1] = background_start_position_x * scale * ratio
		animation_params.start_background_position[2] = background_start_position_y * scale * ratio
		animation_params.end_background_position[1] = background_end_position_x * scale * ratio
		animation_params.end_background_position[2] = background_end_position_y * scale * ratio
		animation_params.start_planet_position[1] = start_planet_position_x * scale * ratio
		animation_params.start_planet_position[2] = start_planet_position_y * scale * ratio
		animation_params.end_planet_position[1] = end_planet_position_x * scale * ratio
		animation_params.end_planet_position[2] = end_planet_position_y * scale * ratio
		animation_params.target_planet = planet
		planets_widget_content.new_planet = planet

		if self._planet_background_animation_id and self:_is_animation_active(self._planet_background_animation_id) then
			self:_stop_animation(self._planet_background_animation_id)

			self._planet_background_animation_id = nil
		end

		self._planet_background_animation_id = self:_start_animation("on_planet_select", {
			home_planets = planets_widget,
			background_planet = background_widget,
		}, animation_params)
	end
end

CharacterAppearanceView._create_page_indicators = function (self)
	if self._page_indicator_widgets then
		for ii = 1, #self._page_indicator_widgets do
			local widget = self._page_indicator_widgets[ii]

			self:_unregister_widget_name(widget.name)
		end
	end

	local num_pages = #self._pages

	if num_pages < 2 then
		return
	end

	local page_indicator_widgets = {}
	local indicator_z_index = 50
	local page_indicator_frame_definition = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/dividers/skull_rendered_left_02",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					78,
					18,
				},
				offset = {
					-78,
					0,
					indicator_z_index,
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
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/dividers/skull_rendered_left_02",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					78,
					18,
				},
				offset = {
					78,
					0,
					indicator_z_index,
				},
			},
		},
	}, "page_indicator")
	local page_indicator_frame_widget = self:_create_widget("page_indicator_frame", page_indicator_frame_definition)

	page_indicator_widgets[#page_indicator_widgets + 1] = page_indicator_frame_widget

	local width = 15
	local spacing = 10
	local total_width = spacing
	local page_indicator_definition = UIWidget.create_definition(ButtonPassTemplates.page_indicator_terminal, "page_indicator", nil, {
		20,
		20,
	})

	for ii = 1, num_pages do
		local name = "page_indicator_" .. ii
		local widget = self:_create_widget(name, page_indicator_definition)

		widget.offset[1] = total_width
		widget.offset[3] = indicator_z_index
		total_width = total_width + width + spacing
		page_indicator_widgets[#page_indicator_widgets + 1] = widget
	end

	self:_set_scenegraph_size("page_indicator", total_width, nil)

	self._page_indicator_widgets = page_indicator_widgets
end

CharacterAppearanceView._change_page_indicator = function (self, index)
	local page_indicator_widgets = self._page_indicator_widgets

	if not page_indicator_widgets or #page_indicator_widgets == 0 then
		return
	end

	local indicator_position = 1

	for ii = 2, #page_indicator_widgets do
		local widget = page_indicator_widgets[ii]

		widget.content.hotspot.is_focused = indicator_position == index
		indicator_position = indicator_position + 1
	end
end

CharacterAppearanceView._event_profiles_sync_changed = function (self, is_active)
	self:_show_loading_character(is_active)
end

CharacterAppearanceView._show_loading_character = function (self, is_active)
	self._loading_overlay_visible = is_active

	if is_active then
		self._widgets_by_name.loading_overlay.content.text = ""
	end

	self._widgets_by_name.loading_overlay.content.visible = is_active
end

CharacterAppearanceView.update = function (self, dt, t, input_service)
	if self.closing_view or not self._entered then
		return
	end

	local continue_disabled = false

	if self._fade_animation_id and self:_is_animation_completed(self._fade_animation_id) then
		self._fade_animation_id = nil
	end

	for ii = 1, #self._page_grids do
		local page_grids = self._page_grids[ii]
		local grid = page_grids.grid

		if grid then
			grid:update(dt, t)

			local widgets = page_grids.widgets

			for jj = 1, #widgets do
				local widget = widgets[jj]
				local content = widget.content
				local element = content.element
				local visible = grid:is_widget_visible(widget)
				local template_name = element and element.template
				local template = template_name and CharacterAppearanceViewContentBlueprints[template_name]
				local unload_func = template and template.unload_icon
				local load_func = template and template.load_icon

				if not visible and content.icon_load_id and unload_func then
					unload_func(self, widget, element)
				elseif visible and not content.icon_load_id and load_func then
					load_func(self, widget, element)
				end

				if widget.template then
					template_name = widget.template
					template = template_name and CharacterAppearanceViewContentBlueprints[template_name]
				end

				if visible and template and template.update then
					template.update(self, widget, input_service, dt, t)
				end

				local option = widget.content.option

				if option and option.continue_validation then
					local available = option.continue_validation()

					widget.content.show_warning = not available

					if not available then
						continue_disabled = true
					end
				else
					widget.content.show_warning = nil
				end
			end
		end
	end

	self:_update_continue_button("widget_validation", continue_disabled)

	local page = self._pages[self._active_page_number]

	if page.update then
		page.update(page)
	end

	for _, world_spawner in pairs(self._world_spawners) do
		world_spawner:update(dt, t)
	end

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t, input_service)

		local is_spawned = profile_spawner:spawned()

		if is_spawned and self._character_spawned_next_frame then
			self._character_spawned_next_frame = false

			self:_show_loading_character(false)
		elseif (page.show_character or page.show_companion) and not is_spawned and not self._character_spawned_next_frame and not self._loading_overlay_visible and not self._is_character_showing then
			self:_show_loading_character(true)
		end

		if (page.show_character or page.show_companion) and not self._is_character_showing and is_spawned then
			local original_scale = profile_spawner:character_scale()
			local profile_height = self._character_create:height()
			local head_world_position = Vector3.to_array(profile_spawner:node_world_position("j_head"))
			local spawn_position = self._spawn_point_position
			local default_head_z_position = head_world_position[3] - spawn_position[3]
			local starting_scale_diff = 1 + (1 - original_scale[3])

			self._default_head_z_position = default_head_z_position * starting_scale_diff

			self:_set_character_height(profile_height)

			self._is_character_showing = true
			self._character_spawned_next_frame = true
		end

		local level = self._level

		if is_spawned then
			if self._is_barber_mindwipe and level then
				local character_unit = profile_spawner:spawned_character_unit()

				Level.set_flow_variable(level, "lua_character_unit", character_unit)

				local breed_name = self._character_create:breed()

				if breed_name == "ogryn" then
					Level.trigger_event(level, "lua_character_spawned_ogryn")
				else
					Level.trigger_event(level, "lua_character_spawned_human")
				end
			end

			self._level = nil
		end
	end

	if self._in_barber_chair and self._twitching_time then
		self._twitching_time = self._twitching_time - dt

		if self._twitching_time <= 0 then
			local animation_event = "pose_fear"

			profile_spawner:assign_face_animation_event(animation_event)

			self._twitching_time = nil
		end
	end

	if not page.show_character and not page.show_companion and self._is_character_showing then
		self._is_character_showing = false
	end

	if self._is_barber_mindwipe and self._waiting_for_transform then
		local character_create = self._character_create
		local transform_complete = character_create:get_transformation_complete()

		if transform_complete then
			local parent = self._parent

			if transform_complete.success then
				parent:_update_wallets()
				parent:play_vo_events(VO_EVENTS.mindwipe_conclusion, "training_ground_psyker_a", nil, 0.5)

				local height = character_create:height()
				local player = Managers.player:local_player(1)
				local real_unit = player.player_unit

				Unit.set_local_scale(real_unit, 1, Vector3.one() * height)

				local mission_board_service = Managers.data_service.mission_board
				local narrative_manager = Managers.narrative
				local is_eligable = mission_board_service and mission_board_service:get_is_character_eligible_to_skip_campaign()
				local not_already_completed_campaign = narrative_manager and not narrative_manager:is_story_complete("main_story")

				if is_eligable and not_already_completed_campaign then
					local character_id = player and player:character_id()
					local account_id = player and player:account_id()

					narrative_manager:set_story_to_chapter("main_story", "km_station")
					Popups.skip_player_journey.mind_wipe(nil, function ()
						if mission_board_service then
							Managers.telemetry_events:player_journey_popup_play_journey("mind_wipe", true)
							mission_board_service:skip_and_unlock_campaign(account_id, character_id):next(function (data)
								return mission_board_service:set_character_has_been_shown_skip_campaign_popup(account_id, character_id)
							end)
						end
					end, function ()
						if mission_board_service then
							Managers.telemetry_events:player_journey_popup_play_journey("mind_wipe", false)

							return mission_board_service:set_character_has_been_shown_skip_campaign_popup(account_id, character_id)
						end
					end)
				end
			else
				local context = {
					description_text = "loc_crafting_failure",
					title_text = "loc_popup_header_error",
					options = {
						{
							close_on_pressed = true,
							stop_exit_sound = true,
							text = "loc_barber_vendor_confirm_button",
							on_pressed_sound = UISoundEvents.default_click,
						},
					},
				}

				Managers.event:trigger("event_show_ui_popup", context)
			end

			parent._active_view_instance = nil

			parent:_handle_back_pressed()

			self._waiting_for_transform = false

			local viewport_name = "ui_credits_vendor_world_viewport"

			parent._world_spawner:set_listener(viewport_name)
		end
	end

	return CharacterAppearanceView.super.update(self, dt, t, input_service)
end

CharacterAppearanceView._update_continue_button = function (self, check_id, disabled, optional_error_message)
	local widget = self._widgets_by_name.continue_button
	local text_if_disabled_or_nil
	local active_error_id = widget.content.active_error_id
	local previous_active_error_id = active_error_id

	if active_error_id and not disabled and check_id == active_error_id then
		active_error_id = nil
	end

	if disabled then
		local error_message = ""

		active_error_id = active_error_id or check_id

		if not optional_error_message then
			if check_id == "mindwipe_no_changes" then
				error_message = Localize("loc_barber_vendor_view_required_change")
			end
		else
			error_message = optional_error_message
		end

		text_if_disabled_or_nil = error_message
	end

	widget.content.disabled_by_id = widget.content.disabled_by_id or {}
	widget.content.disabled_by_id[check_id] = text_if_disabled_or_nil

	if not active_error_id then
		for error_id, error_message in pairs(widget.content.disabled_by_id) do
			active_error_id = active_error_id or error_id

			if error_message ~= "" then
				active_error_id = error_id

				break
			end
		end
	end

	if previous_active_error_id ~= active_error_id then
		widget.content.active_error_id = active_error_id
		self._widgets_by_name.error_continue.content.text = active_error_id and widget.content.disabled_by_id and widget.content.disabled_by_id[active_error_id] or ""
	end

	local is_continue_disabled = widget.content.disabled_by_id and not table.is_empty(widget.content.disabled_by_id)
	local continue_button_action_display_name, continue_button_text

	continue_button_action_display_name = self._backstory_selection_page and "loc_character_backstory_selection" or self._active_page_number == #self._pages and (self._is_barber and "loc_button_barber_confirm" or "loc_character_create_finish") or "loc_character_create_advance"
	continue_button_text = Localize(continue_button_action_display_name)
	widget.content.original_text = Utf8.upper(continue_button_text)
	widget.content.hotspot.disabled = is_continue_disabled
end

CharacterAppearanceView._clear_continue_disable_data = function (self)
	self._widgets_by_name.continue_button.content.disabled_by_id = nil
	self._widgets_by_name.continue_button.content.active_error_id = nil
	self._widgets_by_name.error_continue.content.text = ""
end

CharacterAppearanceView._toggle_continue_alternative_action = function (self, use_alternative)
	self._widgets_by_name.continue_button.content.gamepad_action = use_alternative and "secondary_action_pressed" or "confirm_pressed"
end

CharacterAppearanceView._toggle_rotate_alternative_action = function (self, use_alternative)
	self._widgets_by_name.continue_button.content.gamepad_action = use_alternative
end

CharacterAppearanceView.draw = function (self, dt, t, input_service, layer)
	if self.closing_view or not self._entered then
		return
	end

	for ii = 1, #self._page_grids do
		local page_grid = self._page_grids[ii]

		if page_grid then
			local grid = page_grid.grid
			local widgets = page_grid.widgets
			local support_widgets = page_grid.support_widgets

			UIRenderer.begin_pass(self._offscreen_renderer, self._ui_scenegraph, input_service, dt, self._render_settings)

			if widgets then
				for jj = 1, #widgets do
					local widget = widgets[jj]

					if grid and grid:is_widget_visible(widget) then
						UIWidget.draw(widget, self._offscreen_renderer)

						local hotspot = widget.content.hotspot

						if hotspot then
							hotspot.force_disabled = false
						end
					end
				end
			end

			UIRenderer.end_pass(self._offscreen_renderer)
			UIRenderer.begin_pass(self._ui_renderer, self._ui_scenegraph, input_service, dt, self._render_settings)

			if support_widgets then
				for jj = 1, #support_widgets do
					local widget = support_widgets[jj]

					if not widget.content.is_grid_widget then
						UIWidget.draw(widget, self._ui_renderer)
					end
				end
			end

			UIRenderer.end_pass(self._ui_renderer)
		end
	end

	CharacterAppearanceView.super.draw(self, dt, t, input_service, layer)
end

CharacterAppearanceView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	CharacterAppearanceView.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	local page_indicator_widgets = self._page_indicator_widgets

	if page_indicator_widgets and #page_indicator_widgets > 0 then
		for ii = 1, #page_indicator_widgets do
			local widget = page_indicator_widgets[ii]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local page_widgets = self._page_widgets

	if page_widgets and #page_widgets > 0 then
		for ii = 1, #page_widgets do
			local widget = page_widgets[ii]

			UIWidget.draw(widget, ui_renderer)

			if widget.content.template_type then
				local template = CharacterAppearanceViewContentBlueprints.blueprints[widget.content.template_type]

				if template and template.update then
					template.update(self, widget)
				end
			end
		end
	end
end

CharacterAppearanceView._on_close_pressed = function (self)
	if not self._using_cursor_navigation and self._navigation.grid and self._navigation.grid > 1 and (self._active_page_name == "appearance" or self._active_page_name == "companion_appearance") then
		local current_navigation_position = self._apperance_option_selected_index or 1

		self:_remove_all_focus()
		self:_update_navigation(1, current_navigation_position, true)
	elseif self._active_page_number > 1 then
		local previous_index = self._active_page_number - 1

		self:_open_page(previous_index)
	elseif self._is_barber then
		self._parent._active_view_instance = nil

		self._parent:_handle_back_pressed()
	else
		Managers.event:trigger("event_create_new_character_back")
	end
end

CharacterAppearanceView._destroy_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local offscreen_world = self._offscreen_world

	if offscreen_world then
		Managers.ui:destroy_renderer(offscreen_world.renderer_name)
		ScriptWorld.destroy_viewport(offscreen_world.world, offscreen_world.viewport_name)
		Managers.ui:destroy_world(offscreen_world.world)

		self._offscreen_world = nil
	end
end

CharacterAppearanceView._destroy_background = function (self)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	for page_name, world_spawner in pairs(self._world_spawners) do
		if world_spawner:level() then
			Level.trigger_level_shutdown(world_spawner:level())
		end

		world_spawner:destroy()

		self._world_spawners[page_name] = nil
	end

	self:_set_should_render_world(false)
end

CharacterAppearanceView.on_exit = function (self)
	if self._confirm_popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._confirm_popup_id)

		self._confirm_popup_id = nil
	end

	if self._character_create_promise then
		self._character_create_promise:cancel()

		self._character_create_promise = nil
	end

	if self._fetch_all_profiles_promise then
		self._fetch_all_profiles_promise:cancel()

		self._fetch_all_profiles_promise = nil
	end

	if self._page_grids then
		for ii = 1, #self._page_grids do
			self:_destroy_page_grid(ii)
		end
	end

	Wwise.set_state("music_character_create", "none")
	self:_destroy_background()
	self:_destroy_renderer()
	CharacterAppearanceView.super.on_exit(self)
end

CharacterAppearanceView._get_planet_options = function (self)
	local planets = self._character_create:planet_options()
	local planet_options = {}
	local sorted_planets = table.keys(planets)

	table.sort(sorted_planets, function (a, b)
		return (planets[a].sort_order or Localize(planets[a].display_name)) < (planets[b].sort_order or Localize(planets[b].display_name))
	end)

	for ii = 1, #sorted_planets do
		local id = sorted_planets[ii]
		local option = planets[id]

		planet_options[#planet_options + 1] = {
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function (widget, pressed_options)
				self._character_create:set_planet(id)

				local profile = self._character_create:profile()
				local selected_archetype = profile.archetype.name
				local frames_by_planet = UISettings.inventory_frames_by_archetype[selected_archetype].by_home_planet

				if frames_by_planet then
					local frames = frames_by_planet[id]

					self._widgets_by_name.corners.content.left_upper = frames.right_upper
					self._widgets_by_name.corners.content.right_upper = frames.right_upper
					self._widgets_by_name.corners.content.left_lower = frames.left_lower
					self._widgets_by_name.corners.content.right_lower = frames.right_lower
				end

				if option.rotation then
					local instant = pressed_options and pressed_options.initialization_press

					self:_rotate_camera(Quaternion.from_euler_angles_xyz(unpack(option.rotation)), instant)
				else
					local skip_animation = pressed_options and (pressed_options.skip_animation or pressed_options.initialization_press)

					self:_move_background_to_position(option, skip_animation)
				end

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return planet_options
end

CharacterAppearanceView._generate_appearance_grid_widgets = function (self, grid_index, grid_data)
	local grid_columns = grid_data.grid_columns or 3
	local template_type = grid_data.template
	local template = CharacterAppearanceViewContentBlueprints[template_type]
	local grid_start_name = "grid_" .. grid_index .. "_"
	local grid_scenegraph = grid_start_name .. "pivot"
	local grid_area_scenegraph = grid_start_name .. "area"
	local grid_content_scenegraph = grid_start_name .. "content"
	local grid_scrollbar_scenegraph = grid_start_name .. "scrollbar"
	local options = grid_data.options
	local num_widgets = #options
	local scrollbar_added_width = 15
	local grid_spacing = {
		10,
		10,
	}
	local grid_width = template.size[1] * grid_columns + grid_spacing[1] * (grid_columns - 1)
	local grids_margin = grid_index > 2 and 0 or 20
	local grid_background_margin = 40
	local widgets = {}
	local alignment_list = {}
	local main_grid = self._page_grids[1]
	local selected_main_grid_index = main_grid and main_grid.grid and main_grid.grid:selected_grid_index()
	local selected_main_widget = selected_main_grid_index and main_grid.widgets and main_grid.widgets[selected_main_grid_index]
	local parent_available = not selected_main_widget or not selected_main_widget.content.choice_data or selected_main_widget.content.choice_data.available
	local mute_unique_icon = grid_data.mute_unique_icon
	local last_option_available

	for ii = 1, num_widgets do
		local option = options[ii]
		local name = grid_start_name .. "option_" .. ii

		if self._widgets_by_name[name] then
			self:_unregister_widget_name(name)
		end

		local visible, available, reason, reason_display_name = self:_check_valid_option(option)

		visible = visible and parent_available

		if mute_unique_icon and reason and RESTRICTION_DATAS[reason].unique_reason then
			reason = nil
			reason_display_name = nil
		end

		if visible then
			local pass_template = template.pass_template
			local size = template.size
			local widget_definition = UIWidget.create_definition(pass_template, grid_content_scenegraph, nil, size)
			local widget = self:_create_widget(name, widget_definition)

			if template.init then
				template.init(self, widget, grid_data, option, grid_index, "_on_entry_pressed")
			end

			widget.offset = {
				0,
				0,
				4,
			}
			widget.content.option = option

			self:_update_widget_restrictions(widget, available, reason, reason_display_name)

			if last_option_available ~= nil and last_option_available and not available then
				local divider_widget_definition = UIWidget.create_definition(CharacterAppearanceViewContentBlueprints.divider.pass_template, grid_content_scenegraph, nil, {
					grid_width,
					2,
				})
				local divider_widget = self:_create_widget(grid_start_name .. "_availability_divider", divider_widget_definition)

				widgets[#widgets + 1] = divider_widget
				alignment_list[#alignment_list + 1] = divider_widget
			end

			last_option_available = available
			widgets[#widgets + 1] = widget
			alignment_list[#alignment_list + 1] = widget
		end
	end

	local prev_grid_size = {
		0,
		0,
	}
	local prev_grid_position = {
		0,
		0,
	}
	local prev_grid_margin = grids_margin

	if grid_index > 1 then
		local prev_index = grid_index - 1

		prev_grid_margin = prev_index == 1 and 40 or self._page_grids[prev_index] and self._page_grids[prev_index].grids_margin or prev_grid_margin
		prev_grid_size = self._page_grids[prev_index] and self._page_grids[prev_index].size or prev_grid_size
		prev_grid_position = self._page_grids[prev_index] and self._page_grids[prev_index].position or prev_grid_position
	end

	local position_margin = grid_index == 1 and grid_background_margin * 0.5 or 0
	local grid_height_reduction = grid_index == 1 and grid_background_margin or 0
	local start_x_position = prev_grid_position[1] + prev_grid_size[1] + prev_grid_margin + position_margin
	local start_y_position = prev_grid_position[2] + position_margin
	local grid_position = {
		start_x_position,
		start_y_position,
	}
	local grid_size = {
		grid_width + scrollbar_added_width,
		math.max(400, prev_grid_size[2]) - grid_height_reduction,
	}
	local support_widget_definitions = {
		scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, grid_scrollbar_scenegraph, {
			using_custom_gamepad_navigation = true,
		}),
		interaction = UIWidget.create_definition({
			{
				content_id = "hotspot",
				pass_type = "hotspot",
			},
		}, grid_area_scenegraph),
		mask = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						5,
					},
					size_addition = {
						10,
						10,
					},
				},
			},
		}, grid_area_scenegraph),
	}
	local support_widgets = {}

	for name, definition in pairs(support_widget_definitions) do
		local widget_name = grid_start_name .. name

		if self._widgets_by_name[widget_name] then
			self:_unregister_widget_name(widget_name)
		end

		local widget = self:_create_widget(widget_name, definition)

		if name == "mask" then
			widget.offset = {
				widget.offset[1] - 10,
				widget.offset[2] - 10,
				widget.offset[3],
			}
		end

		widget.offset = {
			widget.offset[1],
			widget.offset[2],
			widget.offset[3] + 4,
		}
		support_widgets[name] = widget
	end

	local grid_widgets = {
		widgets = widgets,
		alignment_list = alignment_list,
		support_widgets = support_widgets,
		grid_data = {
			focused_on_gamepad_navigation = true,
			grid_size = grid_size,
			grid_scenegraph = grid_scenegraph,
			grid_content_scenegraph = grid_content_scenegraph,
			grid_area_scenegraph = grid_area_scenegraph,
			grid_scrollbar_scenegraph = grid_scrollbar_scenegraph,
			grid_position = grid_position,
			grid_spacing = grid_spacing,
			grids_margin = grids_margin,
		},
	}

	return grid_widgets.widgets, grid_widgets.alignment_list, grid_widgets.support_widgets, grid_widgets.grid_data
end

CharacterAppearanceView._update_appearance_background = function (self)
	local widget = self._page_widgets_by_name.background

	if widget then
		local size = {
			0,
			0,
		}
		local prev_x_position
		local x_margin = 0

		for ii = 2, #self._page_grids do
			local page_grid = self._page_grids[ii]

			if not table.is_empty(page_grid) then
				local grid_size = page_grid.size or {
					0,
					0,
				}
				local grid_position = page_grid.position or {
					0,
					0,
				}

				size[1] = size[1] + grid_size[1]
				size[2] = math.max(size[2], grid_size[2])

				if prev_x_position then
					x_margin = x_margin + (grid_position[1] - prev_x_position)
				end

				prev_x_position = grid_position[1] + grid_size[1]
			end
		end

		if size[1] == 0 then
			widget.content.visible = false
		else
			size[1] = size[1] + x_margin + 25
			size[2] = size[2] + 20
			widget.content.visible = true
		end

		widget.content.size = size
		widget.offset = {
			-20,
			-20,
			0,
		}
	end
end

CharacterAppearanceView._generate_backstory_grid_widgets = function (self, grid_index, grid_data)
	local widgets = {}
	local alignment_list = {}
	local grid_start_name = "grid_" .. grid_index .. "_"
	local grid_scenegraph = grid_start_name .. "pivot"
	local grid_area_scenegraph = grid_start_name .. "area"
	local title_font_style = CharacterAppearanceViewFontStyle.option_title_style
	local description_font_style = CharacterAppearanceViewFontStyle.description_style
	local option_title = Utf8.upper(Localize(grid_data.display_name))
	local option_description = Localize(grid_data.description)
	local content_width = 440
	local background_margin = {
		40,
		40,
	}
	local background_size = {
		content_width + background_margin[1] * 2,
		0,
	}
	local title_height = Text.text_height(self._ui_renderer, option_title, title_font_style, {
		content_width,
		0,
	})
	local description_height = Text.text_height(self._ui_renderer, option_description, description_font_style, {
		content_width,
		0,
	})
	local backstory_info_templates = {}

	backstory_info_templates[#backstory_info_templates + 1] = {
		size = {
			background_size[1],
			20,
		},
	}
	backstory_info_templates[#backstory_info_templates + 1] = {
		size = {
			background_size[1],
			title_height,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "option_title",
				value_id = "option_title",
				value = option_title,
				style = table.merge(table.clone(title_font_style), {
					size = {
						content_width,
						title_height,
					},
					offset = {
						background_margin[1],
						0,
						1,
					},
				}),
			},
		},
	}
	backstory_info_templates[#backstory_info_templates + 1] = {
		size = {
			background_size[1],
			20,
		},
	}
	backstory_info_templates[#backstory_info_templates + 1] = {
		size = {
			background_size[1],
			description_height,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "option_description",
				value_id = "option_description",
				value = option_description,
				style = table.merge(table.clone(description_font_style), {
					size = {
						content_width,
						description_height,
					},
					offset = {
						background_margin[1],
						0,
						1,
					},
				}),
			},
		},
	}

	if grid_data.unlocks then
		local effect_title_font_style = CharacterAppearanceViewFontStyle.effect_title_style
		local option_effect_title = Localize("loc_character_title_unlocks")
		local effect_title_height = Text.text_height(self._ui_renderer, option_effect_title, effect_title_font_style, {
			content_width,
			0,
		})

		backstory_info_templates[#backstory_info_templates + 1] = {
			size = {
				background_size[1],
				40,
			},
		}
		backstory_info_templates[#backstory_info_templates + 1] = {
			size = {
				background_size[1],
				effect_title_height + 15,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "option_effect_title",
					value_id = "option_effect_title",
					value = option_effect_title,
					style = table.merge(table.clone(effect_title_font_style), {
						size = {
							content_width,
							effect_title_height,
						},
						offset = {
							background_margin[1],
							0,
							1,
						},
					}),
				},
				{
					pass_type = "rect",
					style_id = "baseline",
					style = {
						vertical_alignment = "bottom",
						color = Color.terminal_corner(255, true),
						size = {
							content_width,
							2,
						},
						offset = {
							background_margin[1],
							0,
							1,
						},
					},
				},
			},
		}
		backstory_info_templates[#backstory_info_templates + 1] = {
			size = {
				background_size[1],
				20,
			},
		}

		for ii = 1, #grid_data.unlocks do
			local unlock = grid_data.unlocks[ii]
			local text_style = CharacterAppearanceViewFontStyle.reward_description_no_icon_style
			local text_height = Text.text_height(self._ui_renderer, Localize(unlock.text), text_style, {
				content_width,
				2000,
			})

			backstory_info_templates[#backstory_info_templates + 1] = {
				size = {
					background_size[1],
					text_height,
				},
				pass_template = {
					{
						pass_type = "text",
						style_id = "title",
						value_id = "title",
						value = Localize(unlock.text),
						style = table.merge(table.clone(text_style), {
							size = {
								content_width,
								text_height,
							},
							offset = {
								background_margin[1],
								0,
								1,
							},
						}),
					},
				},
			}
		end
	end

	backstory_info_templates[#backstory_info_templates + 1] = {
		size = {
			background_margin[1],
			30,
		},
	}

	local total_height = 0

	for ii = 1, #backstory_info_templates do
		local template = backstory_info_templates[ii]
		local widget
		local size = template.size

		total_height = total_height + size[2]

		if template.pass_template then
			local definition = UIWidget.create_definition(template.pass_template, grid_scenegraph, nil, size)

			widget = self:_create_widget(grid_start_name .. "widget_" .. ii, definition)
		end

		if widget then
			widgets[#widgets + 1] = widget
			alignment_list[#alignment_list + 1] = widget
		else
			widgets[#widgets + 1] = nil
			alignment_list[#alignment_list + 1] = {
				size = size,
			}
		end
	end

	background_size[2] = total_height

	local support_widget_definitions = {
		grid_background = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "top_frame",
				value = "content/ui/materials/dividers/horizontal_frame_big_upper",
				value_id = "top_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						-18,
						1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/terminal_basic",
				value_id = "background",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					color = Color.terminal_grid_background(nil, true),
					size_addition = {
						20,
						30,
					},
					offset = {
						0,
						-15,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "bottom_frame",
				value = "content/ui/materials/dividers/horizontal_frame_big_lower",
				value_id = "bottom_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						18,
						1,
					},
				},
			},
		}, grid_scenegraph, nil, background_size),
		mask = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						5,
					},
					size_addition = {
						10,
						10,
					},
				},
			},
		}, grid_area_scenegraph, nil, background_size),
	}
	local support_widgets = {}

	for name, definition in pairs(support_widget_definitions) do
		local widget = self:_create_widget(grid_start_name .. "support_widget_" .. name, definition)

		widget.offset = {
			widget.offset[1],
			widget.offset[2],
			widget.offset[3] + 4,
		}
		support_widgets[name] = widget
	end

	local grid_1_size = self._page_grids[1] and self._page_grids[1].size or {
		0,
		0,
	}
	local grid_1_position = self._page_grids[1] and self._page_grids[1].position or {
		0,
		0,
	}
	local start_x_position = grid_1_position[1] + grid_1_size[1] + 40
	local start_y_position = grid_1_position[2] + grid_1_size[2] - background_size[2]
	local grid_position = {
		start_x_position,
		start_y_position,
	}
	local return_grid_data = {
		size = background_size,
		grid_scenegraph = grid_scenegraph,
		grid_position = grid_position,
	}

	return widgets, alignment_list, support_widgets, return_grid_data
end

CharacterAppearanceView._generate_main_grid_widgets = function (self, grid_index, grid_data)
	local template_type = grid_data.template
	local focused_on_gamepad_navigation = grid_data.focused_on_gamepad_navigation
	local template = CharacterAppearanceViewContentBlueprints[template_type]
	local grid_start_name = "grid_" .. grid_index .. "_"
	local grid_scenegraph = grid_start_name .. "pivot"
	local grid_area_scenegraph = grid_start_name .. "area"
	local grid_content_scenegraph = grid_start_name .. "content"
	local grid_scrollbar_scenegraph = grid_start_name .. "scrollbar"
	local size = template.size
	local options = grid_data.options()
	local num_widgets = #options
	local page = self._pages[self._active_page_number]
	local widgets = {}
	local alignment_list = {}
	local grid_size = {
		480,
		grid_data.height or 600,
	}

	for ii = 1, num_widgets do
		local option = options[ii]
		local name = grid_start_name .. "option_" .. ii
		local pass_template_function = template.pass_template_function
		local pass_template = pass_template_function and pass_template_function(self, template, size) or template.pass_template

		if pass_template_function and template.pass_template then
			local pass_template_extra = template.pass_template

			for jj = 1, #pass_template_extra do
				pass_template[#pass_template + 1] = pass_template_extra[jj]
			end
		end

		local option_size = template.size
		local widget_definition = UIWidget.create_definition(pass_template, grid_content_scenegraph, nil, option_size)
		local widget = self:_create_widget(name, widget_definition)

		if template.init then
			template.init(self, widget, grid_data, option, grid_index, "_on_entry_pressed")
		end

		widget.offset = {
			0,
			0,
			4,
		}
		widget.content.option = option

		local visible, available, reason, reason_display_name = self:_check_valid_option(option)

		widget.content.visible = not not visible

		self:_update_widget_restrictions(widget, available, reason, reason_display_name)

		widgets[#widgets + 1] = widget
		alignment_list[#alignment_list + 1] = {
			horizontal_alignment = "center",
			size = {
				grid_size[1],
				option_size[2],
			},
			name = name,
		}

		local additional_widgets = template.additional_widgets

		if additional_widgets then
			for jj = 1, #additional_widgets do
				local additional_template = additional_widgets[jj]
				local multiplied_widget_id = additional_template.pass_multiplier and additional_template.pass_multiplier_iterative_offset and additional_template.pass_multiplier_id

				if multiplied_widget_id then
					local multiplier_option_id = additional_template.pass_multiplier_options
					local multiplier_options

					if multiplier_option_id == "personality" then
						multiplier_options = self:_get_personality_options()
					end

					local multiplier = additional_template.pass_multiplier
					local iterative_offset = {
						0,
						0,
						3,
					}
					local multiply_template = table.clone(CharacterAppearanceViewContentBlueprints[multiplied_widget_id])
					local multiply_pass_template_function = multiply_template.pass_template_function
					local multiply_passes = multiply_pass_template_function and multiply_pass_template_function(self, template, option_size) or multiply_template.pass_template

					for kk = 1, multiplier do
						option = multiplier_options and multiplier_options[kk] or option

						for ll = 1, #multiply_passes do
							local pass_iteration = multiply_passes[ll]

							for axis = 1, 3 do
								if pass_iteration.style and pass_iteration.style.offset then
									pass_iteration.style.offset[axis] = pass_iteration.style.offset[axis] + iterative_offset[axis]
								end
							end
						end

						local iterative_name = grid_start_name .. "option_" .. ii .. "_" .. jj .. "_" .. kk
						local iterative_size = multiply_template.size
						local iterative_widget_definition = UIWidget.create_definition(multiply_passes, grid_content_scenegraph, nil, iterative_size)
						local iterative_widget = self:_create_widget(iterative_name, iterative_widget_definition)

						if multiply_template.init then
							multiply_template.init(self, iterative_widget, grid_data, option, grid_index, "_on_entry_pressed")
						end

						iterative_widget.content.option = option
						iterative_widget.content.iteration = kk
						iterative_widget.template = multiplied_widget_id

						local iterative_visible, iterative_available, iterative_reason, iterative_reason_display_name = self:_check_valid_option(option)

						iterative_widget.content.visible = not not iterative_visible

						self:_update_widget_restrictions(iterative_widget, iterative_available, iterative_reason, iterative_reason_display_name)

						widgets[#widgets + 1] = iterative_widget
						alignment_list[#alignment_list + 1] = {
							size = {
								grid_size[1],
								iterative_size[2],
							},
							horizontal_alignment = additional_template.horizontal_alignment,
							name = iterative_name,
						}
						iterative_offset = additional_template.pass_multiplier_iterative_offset
					end
				end
			end
		end
	end

	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype
	local widget_definitions = {
		scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, grid_scrollbar_scenegraph, {
			using_custom_gamepad_navigation = true,
		}),
		interaction = UIWidget.create_definition({
			{
				content_id = "hotspot",
				pass_type = "hotspot",
			},
		}, grid_area_scenegraph),
		mask = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						5,
					},
					size_addition = {
						10,
						10,
					},
				},
			},
		}, grid_area_scenegraph),
		grid_background = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/terminal_basic",
				value_id = "background",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					color = Color.terminal_grid_background(nil, true),
					size_addition = {
						20,
						30,
					},
					offset = {
						0,
						-15,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "class_background",
				value_id = "class_background",
				value = selected_archetype.archetype_icon_large,
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = Color.black(80, true),
					size = {
						nil,
						480,
					},
					offset = {
						0,
						0,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_lower",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						18,
						2,
					},
				},
			},
		}, grid_scenegraph, nil, grid_size),
	}

	if grid_data.description then
		widget_definitions.grid_description = UIWidget.create_definition({
			{
				pass_type = "text",
				style_id = "text",
				value = "",
				value_id = "text",
				style = CharacterAppearanceViewFontStyle.list_description_style,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_middle",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					size = {
						nil,
						44,
					},
					offset = {
						0,
						22,
						1,
					},
				},
			},
		}, grid_scenegraph, nil, {
			grid_size[1],
			40,
		})
	end

	if grid_data.top_frame then
		widget_definitions.grid_top = grid_data.top_frame(page, grid_size, grid_scenegraph)
	else
		widget_definitions.grid_top = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "top_frame",
				value = "content/ui/materials/dividers/horizontal_frame_big_upper",
				value_id = "top_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						-18,
						2,
					},
				},
			},
		}, grid_scenegraph, nil, {
			grid_size[1],
			36,
		})
	end

	local grid_description_widget
	local support_widgets = {}

	for name, definition in pairs(widget_definitions) do
		local widget_name = grid_start_name .. name

		if self._widgets_by_name[widget_name] then
			self:_unregister_widget_name(widget_name)
		end

		local widget = self:_create_widget(widget_name, definition)

		if name == "grid_description" then
			grid_description_widget = widget
		end

		widget.offset = {
			widget.offset[1],
			widget.offset[2],
			widget.offset[3] + 4,
		}
		support_widgets[name] = widget
	end

	local description_text_size = 0

	if grid_data.description then
		local text = grid_data.description
		local style_name = "list_description_style"
		local font_style = CharacterAppearanceViewFontStyle[style_name]
		local x_offset = 20
		local text_size = {
			grid_description_widget.content.size[1] - x_offset * 2,
			grid_description_widget.content.size[2],
		}
		local _, text_height = Text.text_size(self._ui_renderer, text, font_style, text_size)
		local text_margin = 15

		text_height = text_height + text_margin * 2
		grid_description_widget.content.size[2] = text_height
		grid_description_widget.style.text.size = {
			text_size[1],
			text_height,
		}
		grid_description_widget.content.text = text
		description_text_size = text_height
	end

	local return_grid_data = {
		grid_size = grid_size,
		grid_top_padding = description_text_size + 10,
		grid_scenegraph = grid_scenegraph,
		grid_area_scenegraph = grid_area_scenegraph,
		grid_content_scenegraph = grid_content_scenegraph,
		grid_scrollbar_scenegraph = grid_scrollbar_scenegraph,
		grid_position = {
			25,
			200,
		},
		focused_on_gamepad_navigation = focused_on_gamepad_navigation,
	}

	return widgets, alignment_list, support_widgets, return_grid_data
end

CharacterAppearanceView._update_widget_restrictions = function (self, widget, available, reason, reason_display_name)
	widget.alpha_multiplier = available == false and 0.5 or 1

	if not reason then
		if widget.style.choice_icon then
			widget.content.use_choice_icon = false
			widget.style.choice_icon.material_values = nil
		end

		widget.content.choice_data = nil
	else
		local choice_data = widget.content.choice_data

		if choice_data and choice_data.available == available and choice_data.reason == reason and choice_data.reason_display_name == reason_display_name then
			return
		end

		local choice_info = self:_archetype_page_data()[reason] or RESTRICTION_DATAS[reason]

		if widget.style.choice_icon then
			widget.content.use_choice_icon = true
			widget.style.choice_icon.material_values = {
				texture_map = choice_info.icon_texture,
			}
		end

		widget.content.choice_data = {
			visible = not not reason,
			available = available,
			reason = reason,
			reason_display_name = reason_display_name,
		}
	end
end

CharacterAppearanceView._destroy_page_grid = function (self, index)
	if self._page_grids[index] then
		local page_grid = self._page_grids[index]
		local widgets = page_grid.widgets

		if widgets then
			for ii = 1, #widgets do
				local widget = widgets[ii]
				local widget_name = widget.name
				local content = widget.content
				local element = content.element
				local template_name = element and element.template
				local template = template_name and CharacterAppearanceViewContentBlueprints[template_name]
				local unload_func = template and template.unload_icon

				if content.icon_load_id and unload_func then
					unload_func(self, widget, element)
				end

				self:_unregister_widget_name(widget_name)
				UIWidget.destroy(self._offscreen_renderer, widget)
			end
		end

		local support_widgets = page_grid.support_widgets

		if support_widgets then
			for ii = 1, #support_widgets do
				local widget = support_widgets[ii]

				if not widget.content.is_grid_widget then
					local widget_name = widget.name

					self:_unregister_widget_name(widget_name)
					UIWidget.destroy(self._ui_renderer, widget)
				end
			end
		end

		self._page_grids[index] = nil
	end
end

CharacterAppearanceView._populate_page_grid = function (self, index, grid_data, on_present_callback)
	local first_page_grid_generated = index == 1 and not self._page_grids[index]

	self:_destroy_page_grid(index)

	local grid_widgets, grid_alignment_list, grid_support_widgets, generated_data = grid_data.init(index, grid_data)

	if not grid_widgets or table.is_empty(grid_widgets) then
		return
	end

	local support_widgets = {}

	for name, widget in pairs(grid_support_widgets) do
		support_widgets[#support_widgets + 1] = widget
	end

	local ui_scenegraph = self._ui_scenegraph
	local grid_scenegraph = generated_data.grid_scenegraph
	local grid_area_scenegraph = generated_data.grid_area_scenegraph
	local grid_content_scenegraph = generated_data.grid_content_scenegraph
	local grid_scrollbar_scenegraph = generated_data.grid_scrollbar_scenegraph
	local direction = generated_data and generated_data.grid_direction or grid_data.grid_direction or "down"
	local spacing = generated_data and generated_data.grid_spacing or grid_data.grid_spacing or {
		0,
		0,
	}
	local top_padding = generated_data and generated_data.grid_top_padding or grid_data.grid_top_padding or 0
	local size = generated_data and generated_data.grid_size or grid_data.grid_size or {
		0,
		0,
	}
	local focused_on_gamepad_navigation = generated_data and generated_data.focused_on_gamepad_navigation

	if generated_data.grid_position then
		local grid_position = generated_data.grid_position

		self:_set_scenegraph_position(grid_scenegraph, grid_position[1], grid_position[2])
	end

	self:_set_scenegraph_size(grid_scenegraph, size[1], size[2])

	local grid_size = {
		size[1],
		size[2] - top_padding,
	}

	if grid_area_scenegraph then
		if generated_data.grid_position then
			self:_set_scenegraph_position(grid_area_scenegraph, 0, top_padding)
		end

		self:_set_scenegraph_size(grid_area_scenegraph, grid_size[1], grid_size[2])
	end

	if grid_content_scenegraph then
		self:_set_scenegraph_size(grid_content_scenegraph, grid_size[1], grid_size[2])
	end

	local grid = UIWidgetGrid:new(grid_widgets, grid_alignment_list, ui_scenegraph, grid_area_scenegraph, direction, spacing, nil, nil, nil, nil, nil, nil, nil, grid_size)
	local scrollbar_widget = grid_support_widgets.scrollbar

	if scrollbar_widget then
		if grid_scrollbar_scenegraph then
			self:_set_scenegraph_size(grid_scrollbar_scenegraph, 7, grid_size[2] - 20)
		end

		grid:assign_scrollbar(scrollbar_widget, grid_content_scenegraph, grid_area_scenegraph)
		grid:set_scrollbar_progress(0)
	end

	local position_x, position_y = self:_scenegraph_position(grid_scenegraph)

	self:_force_update_scenegraph()

	self._page_grids[index] = {
		id = math.uuid(),
		widgets = grid_widgets,
		grid = grid,
		support_widgets = support_widgets,
		support_widgets_by_name = grid_support_widgets,
		size = size,
		position = {
			position_x,
			position_y,
		},
		grid_data = grid_data,
		focused_on_gamepad_navigation = focused_on_gamepad_navigation,
		grids_margin = generated_data.grids_margin,
	}

	local options = grid_data.options and grid_data.options()
	local additional_options = grid_data.additional_options and grid_data.additional_options()

	if additional_options then
		table.append(options, additional_options)
	end

	if options and not table.is_empty(options) then
		local has_selected_option = not not grid_data.selected_option

		if has_selected_option then
			local value = grid_data.selected_option()
			local widget_index_to_select = 1
			local option_to_select = options[widget_index_to_select]

			if value then
				local is_item = type(value) == "table" and (not not value.gear_id or not not value.always_owned or not not ItemSourceSettings[value.source])

				for ii = 1, #options do
					local option = options[ii]
					local is_equal

					if is_item then
						is_equal = option.value.name == value.name
					else
						is_equal = option.value == value
					end

					if is_equal then
						option_to_select = option
						widget_index_to_select = ii

						break
					end
				end
			end

			local pressed_options = {
				initialization_press = true,
				ignore_navigation_update = not first_page_grid_generated,
			}

			if grid_data.init_pressed_options and type(grid_data.init_pressed_options) == "table" then
				table.merge(pressed_options, grid_data.init_pressed_options)
			end

			self:_on_entry_pressed(grid_widgets[widget_index_to_select], option_to_select, index, pressed_options)
		end
	end

	if on_present_callback then
		on_present_callback(index, options)
	end
end

local select_path = {
	"option",
	"value",
}

CharacterAppearanceView._on_entry_pressed = function (self, current_widget, option, grid_index, pressed_options)
	local page_grid = self._page_grids[grid_index]
	local on_pressed_function = option.on_pressed_function
	local on_focused_function = option.on_focused_function
	local focused_on_gamepad_navigation = page_grid.focused_on_gamepad_navigation
	local initial_press = pressed_options and pressed_options.initialization_press
	local first_press_on_page = initial_press and not pressed_options.ignore_navigation_update
	local from_navigation = pressed_options and pressed_options.from_navigation
	local is_gamepad_navigation = not self._using_cursor_navigation

	page_grid.selected_widget = current_widget

	local widget_index = page_grid.grid:index_by_widget(current_widget)
	local original_grid_id = self._page_grids[grid_index].id

	if not pressed_options or not pressed_options.ignore_navigation_update then
		self:_update_navigation(grid_index, widget_index)
	end

	local new_grid_id = self._page_grids[grid_index].id

	if original_grid_id ~= new_grid_id then
		return
	end

	if not initial_press then
		self:_remove_all_focus()
		self:_check_widget_choice_detail_visibility(grid_index, widget_index)
	end

	local on_pressed_sound = table.safe_get(option, "data", "on_pressed_sound")

	if on_pressed_sound then
		Managers.ui:play_2d_sound(on_pressed_sound)
	end

	local slot_items = table.safe_get(option, "data", "slot_items")

	if slot_items and not self._is_barber_mindwipe then
		local item_definitions = MasterItems.get_cached()

		for slot_name, item_name in pairs(slot_items) do
			local item = item_definitions[item_name]

			self._character_create:set_item_per_slot(slot_name, item)
		end
	end

	local scrollbar_animation_progress = page_grid.grid:get_scrollbar_percentage_by_index(widget_index)

	if is_gamepad_navigation and focused_on_gamepad_navigation and from_navigation then
		page_grid.grid:focus_by_content(option.value, select_path, scrollbar_animation_progress, true)
	elseif on_pressed_function then
		page_grid.grid:select_by_content(option.value, select_path, scrollbar_animation_progress, true)

		if is_gamepad_navigation and (first_press_on_page or not initial_press) then
			page_grid.grid:focus_by_content(option.value, select_path, scrollbar_animation_progress, true)
		end
	end

	if is_gamepad_navigation and from_navigation and focused_on_gamepad_navigation and on_focused_function then
		on_focused_function(current_widget, pressed_options)
	elseif on_pressed_function then
		on_pressed_function(current_widget, pressed_options)
	end
end

CharacterAppearanceView._set_should_render_world = function (self, value)
	self._should_render_world = value
end

CharacterAppearanceView._level_names = function (self)
	local level_settings

	if self._is_barber then
		level_settings = CharacterAppearanceViewSettings.barber_level_names
	else
		level_settings = CharacterAppearanceViewSettings.level_names
	end

	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype.name
	local selected_level_settings = level_settings[selected_archetype]

	return selected_level_settings
end

CharacterAppearanceView._state_machines = function (self)
	local state_machine_settings

	if self._is_barber then
		state_machine_settings = CharacterAppearanceViewSettings.barber_state_machines
	else
		state_machine_settings = CharacterAppearanceViewSettings.state_machines
	end

	local state_machines = state_machine_settings.default
	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype.name
	local archetype_overrides = state_machines.archetype_overrides and state_machines.archetype_overrides[selected_archetype]

	if archetype_overrides then
		state_machines = table.merge(table.clone(state_machines), archetype_overrides)
	end

	return state_machines
end

CharacterAppearanceView._setup_background_world = function (self, page_name)
	local breed_name = self._character_create:breed() or "human"
	local breed = Breeds[breed_name]
	local body_size = breed.body_size
	local level_names = self:_level_names()

	if not level_names[page_name] then
		page_name = "default"
	end

	local default_camera_event_id = string.format("event_register_%s_character_appearance_default_camera", body_size)

	self[default_camera_event_id] = function (_, camera_unit)
		self._default_camera_unit = camera_unit

		local viewport_name = CharacterAppearanceViewSettings.viewport_name
		local viewport_type = CharacterAppearanceViewSettings.viewport_type
		local viewport_layer = CharacterAppearanceViewSettings.viewport_layer
		local shading_environment_settings = CharacterAppearanceViewSettings.shading_environments

		if self._is_barber then
			shading_environment_settings = CharacterAppearanceViewSettings.barber_shading_environments
		end

		local shading_environments = shading_environment_settings.default
		local profile = self._character_create:profile()
		local selected_archetype = profile.archetype.name
		local archetype_overrides = shading_environment_settings.archetype_overrides and shading_environment_settings.archetype_overrides[selected_archetype]

		if archetype_overrides then
			shading_environments = table.merge(table.clone(shading_environments), archetype_overrides)
		end

		local shading_environment = shading_environments[page_name] or shading_environments.default

		self._world_spawners[page_name]:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
		self:_unregister_event(default_camera_event_id)
	end

	self:_register_event(default_camera_event_id)

	self._camera_by_focus_name = {}

	for slot_name, slot in pairs(ItemSlotSettings) do
		if slot.slot_type == "body" then
			local item_slot_camera_event_id = string.format("event_register_character_appearance_camera_%s_%s", body_size, slot_name)

			self[item_slot_camera_event_id] = function (_, camera_unit)
				self._camera_by_focus_name[slot_name] = camera_unit

				self:_unregister_event(item_slot_camera_event_id)
			end

			self:_register_event(item_slot_camera_event_id)
		end
	end

	if self._is_barber_mindwipe then
		local spawn_point_event_id = string.format("event_register_character_spawn_point_%s", body_size)

		self[spawn_point_event_id] = function (_, spawn_point_unit)
			self._spawn_point_unit = spawn_point_unit

			self:_unregister_event(spawn_point_event_id)
		end

		self:_register_event(spawn_point_event_id)
	end

	self:_register_event("event_register_character_spawn_point")

	local world_name_prefix = CharacterAppearanceViewSettings.world_name_prefix
	local world_layer = CharacterAppearanceViewSettings.world_layer
	local world_timer_name = CharacterAppearanceViewSettings.timer_name
	local level_name = level_names[page_name]

	self._world_spawners[page_name] = UIWorldSpawner:new(world_name_prefix .. "_" .. page_name, world_layer, world_timer_name, self.view_name)

	self._world_spawners[page_name]:spawn_level(level_name)

	if self._is_barber_mindwipe and MINDWIPEABLE_PAGES[self._active_page_name] then
		self._level = self._world_spawners[page_name]:level()
	end
end

CharacterAppearanceView._is_camera_zoomed = function (self, camera_focus)
	return not not self._camera_by_focus_name[camera_focus]
end

CharacterAppearanceView._set_character_height = function (self, scale_factor)
	self._profile_spawner:set_character_scale(scale_factor)
	self._character_create:set_height(scale_factor)
end

CharacterAppearanceView._get_appearance_options = function (self)
	local appearance_options = {}
	local profile = self._character_create:profile()
	local archetype_name = profile.archetype.name
	local gender_options = self._character_create:gender_options()

	if gender_options and #gender_options > 1 and not self._is_barber_appearance then
		appearance_options[#appearance_options + 1] = {
			icon = "content/ui/materials/icons/item_types/body_types",
			text = Localize("loc_gender"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 1,
						slot_name = "slot_body",
						template = "icon",
						type = "gender",
						options = gender_options,
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local face_item_options = self._character_create:slot_item_options("slot_body_face")
	local skin_color_options = self._character_create:slot_item_options("slot_body_skin_color")
	local skin_color_secondary_options = self._character_create:slot_item_options("slot_body_skin_color_secondary")
	local skin_discoloration_options = self._character_create:slot_item_options("slot_body_skin_discoloration")

	if #face_item_options > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/face_types",
			continue_validation = function ()
				local slots = {
					"slot_body_face",
					"slot_body_skin_color",
					"slot_body_skin_color_secondary",
					"slot_body_skin_discoloration",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_face"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 3,
						slot_name = "slot_body_face",
						template = "slot_icon",
						options = face_item_options,
					},
					{
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_skin_color",
						template = "icon_small_texture_hsv",
						type = "skin_color",
						grid_columns = archetype_name == "cryptic" and 1 or 2,
						options = skin_color_options,
					},
					{
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_skin_color_secondary",
						template = "icon_small_texture_hsv",
						type = "skin_color",
						grid_columns = archetype_name == "cryptic" and 1 or 2,
						options = skin_color_secondary_options,
					},
					{
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_skin_discoloration",
						template = "icon_small_texture",
						grid_columns = archetype_name == "cryptic" and 1 or 2,
						options = skin_discoloration_options,
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local body_options = self._character_create:slot_item_options("slot_body_torso")

	if #body_options > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_torso",
			icon = "content/ui/materials/icons/item_types/cryptic_torso",
			continue_validation = function ()
				local slots = {
					"slot_body_torso",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_body_torso"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 2,
						icon_background = "content/ui/textures/icons/appearances/cryptic/torso",
						slot_name = "slot_body_torso",
						template = "icon",
						options = body_options,
						mute_unique_icon = archetype_name == "cryptic",
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local eye_color_options = self._character_create:slot_item_options("slot_body_eye_color")
	local eye_color_secondary_options = self._character_create:slot_item_options("slot_body_eye_color_secondary")

	local function sort_eye_color_by_type()
		local colors_eye_black_scalera = {}
		local colors_eye_blind_left = {}
		local colors_eye_blind_right = {}
		local colors_eye_blind_both = {}
		local colors_eye = {}

		for ii = 1, #eye_color_options do
			local eye_color = eye_color_options[ii]
			local index = _get_eye_type_index_by_option(eye_color)

			if EYE_TYPES[index].name == "black_scalera" then
				colors_eye_black_scalera[#colors_eye_black_scalera + 1] = eye_color
			elseif EYE_TYPES[index].name == "blind_left" then
				colors_eye_blind_left[#colors_eye_blind_left + 1] = eye_color
			elseif EYE_TYPES[index].name == "blind_right" then
				colors_eye_blind_right[#colors_eye_blind_right + 1] = eye_color
			elseif EYE_TYPES[index].name == "blind_both" then
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
			black_scalera = colors_eye_black_scalera,
		}

		return result
	end

	if #eye_color_options > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			continue_validation = function ()
				local slots = {
					"slot_body_eye_color",
					"slot_body_eye_color_secondary",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = archetype_name == "cryptic" and Localize("loc_lens_color") or Localize("loc_eye_color"),
			on_pressed_function = function (widget, pressed_options)
				self._eye_options_by_type = sort_eye_color_by_type()

				local current_option = self._character_create:slot_item("slot_body_eye_color")
				local index = _get_eye_type_index_by_option(current_option)
				local filtered_eye_types = {}

				for type_name, data in pairs(self._eye_options_by_type) do
					if #data > 0 then
						for ii = 1, #EYE_TYPES do
							if type_name == EYE_TYPES[ii].name then
								filtered_eye_types[#filtered_eye_types + 1] = EYE_TYPES[ii]

								break
							end
						end
					end
				end

				local filtered_eye_colors = self._eye_options_by_type[EYE_TYPES[index].name]
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 1,
						slot_name = "slot_body_eye_color",
						template = "icon",
						type = "eye_type",
						options = #filtered_eye_types > 1 and filtered_eye_types or {},
					},
					{
						grid_columns = 2,
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_eye_color",
						template = "icon_small_texture_hsv",
						type = "eye_color",
						options = filtered_eye_colors,
						mute_unique_icon = archetype_name == "cryptic",
					},
					{
						grid_columns = 2,
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_eye_color_secondary",
						template = "icon_small_texture_hsv",
						type = "eye_color",
						options = eye_color_secondary_options,
						mute_unique_icon = archetype_name == "cryptic",
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
			icon = archetype_name == "cryptic" and "content/ui/materials/icons/item_types/cryptic_lens_color" or "content/ui/materials/icons/item_types/eye_color",
		}
	end

	local hair_item_options = self._character_create:slot_item_options("slot_body_hair")
	local hair_color_options = self._character_create:slot_item_options("slot_body_hair_color")

	if #hair_item_options > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/hair_styles",
			continue_validation = function ()
				local slots = {
					"slot_body_hair",
					"slot_body_hair_color",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_hair"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 3,
						slot_name = "slot_body_hair",
						template = "slot_icon",
						options = hair_item_options,
						mute_unique_icon = archetype_name == "ogryn",
					},
					{
						grid_columns = 2,
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_hair_color",
						template = "icon_small_texture",
						type = "hair_color",
						options = hair_color_options,
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local face_hair_options = self._character_create:slot_item_options("slot_body_face_hair")
	local facial_hair_color_options = self._character_create:slot_item_options("slot_body_face_hair_color")

	facial_hair_color_options = table.filter_array(facial_hair_color_options, function (option)
		return table.contains(option.parent_slot_names, "slot_body_face_hair")
	end)

	if #face_hair_options > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/facial_hair_styles",
			continue_validation = function ()
				local slots = {
					"slot_body_face_hair",
					"slot_body_hair_color",
					"slot_body_face_hair_color",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_face_hair"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 3,
						slot_name = "slot_body_face_hair",
						template = "slot_icon",
						options = face_hair_options,
						mute_unique_icon = archetype_name == "ogryn",
					},
					{
						force_nil_item = true,
						grid_columns = 2,
						no_option = true,
						slot_name = "slot_body_face_hair_color",
						template = "icon_small_texture",
						type = "hair_color",
						options = facial_hair_color_options,
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local face_makeup_options = self._character_create:slot_item_options("slot_body_face_makeup")

	if #face_makeup_options > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/facial_makeup",
			continue_validation = function ()
				local slots = {
					"slot_body_face_makeup",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_face_makeup"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 3,
						slot_name = "slot_body_face_makeup",
						template = "slot_icon",
						options = face_makeup_options,
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local arm_options = self._character_create:slot_item_options("slot_body_arms")

	if #arm_options > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_arms",
			icon = "content/ui/materials/icons/item_types/cryptic_arms",
			continue_validation = function ()
				local slots = {
					"slot_body_arms",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_body_arms"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 2,
						icon_background = "content/ui/textures/icons/appearances/cryptic/arms",
						slot_name = "slot_body_arms",
						template = "icon",
						options = arm_options,
						mute_unique_icon = archetype_name == "cryptic",
					},
					{
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_skin_color",
						template = "icon_small_texture_hsv",
						type = "skin_color",
						grid_columns = archetype_name == "cryptic" and 1 or 2,
						options = skin_color_options,
						mute_unique_icon = archetype_name == "cryptic",
					},
					{
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_skin_color_secondary",
						template = "icon_small_texture_hsv",
						type = "skin_color",
						grid_columns = archetype_name == "cryptic" and 1 or 2,
						options = skin_color_secondary_options,
						mute_unique_icon = archetype_name == "cryptic",
					},
					{
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_skin_discoloration",
						template = "icon_small_texture",
						grid_columns = archetype_name == "cryptic" and 1 or 2,
						options = skin_discoloration_options,
						mute_unique_icon = archetype_name == "cryptic",
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local leg_options = self._character_create:slot_item_options("slot_body_legs")

	if #leg_options > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_legs",
			icon = "content/ui/materials/icons/item_types/cryptic_legs",
			continue_validation = function ()
				local slots = {
					"slot_body_legs",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_body_legs"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 2,
						icon_background = "content/ui/textures/icons/appearances/cryptic/legs",
						slot_name = "slot_body_legs",
						template = "icon",
						options = leg_options,
						mute_unique_icon = archetype_name == "cryptic",
					},
					{
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_skin_color",
						template = "icon_small_texture_hsv",
						type = "skin_color",
						grid_columns = archetype_name == "cryptic" and 1 or 2,
						options = skin_color_options,
						mute_unique_icon = archetype_name == "cryptic",
					},
					{
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_skin_color_secondary",
						template = "icon_small_texture_hsv",
						type = "skin_color",
						grid_columns = archetype_name == "cryptic" and 1 or 2,
						options = skin_color_secondary_options,
						mute_unique_icon = archetype_name == "cryptic",
					},
					{
						ignore_fallback_in_sorting = true,
						slot_name = "slot_body_skin_discoloration",
						template = "icon_small_texture",
						grid_columns = archetype_name == "cryptic" and 1 or 2,
						options = skin_discoloration_options,
						mute_unique_icon = archetype_name == "cryptic",
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local all_tattoos = {}

	table.append(all_tattoos, self._character_create:slot_item_options("slot_body_face_tattoo"))
	table.append(all_tattoos, self._character_create:slot_item_options("slot_body_tattoo"))

	local face_tattoos, body_tattoos, full_body_tattoos = table.partition(all_tattoos, 3, function (value, face_tattoos, body_tattoos, full_body_tattoos)
		if value.tattoo_group and value.tattoo_group ~= "" then
			return full_body_tattoos
		end

		local slots = value.slots

		if slots[1] == "slot_body_face_tattoo" then
			return face_tattoos
		end

		return body_tattoos
	end)

	if #face_tattoos > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/face_tattoos",
			continue_validation = function ()
				local slots = {
					"slot_body_face_tattoo",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_face_tattoo"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 3,
						icon_background = "content/ui/textures/icons/appearances/backgrounds/face_tattoos",
						no_option = true,
						slot_name = "slot_body_face_tattoo",
						template = "icon",
						type = "face_tattoo",
						options = face_tattoos,
						mute_unique_icon = archetype_name == "ogryn",
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	if #body_tattoos > 1 then
		appearance_options[#appearance_options + 1] = {
			icon = "content/ui/materials/icons/item_types/body_tattoos",
			continue_validation = function ()
				local slots = {
					"slot_body_tattoo",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_body_tattoo"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 3,
						icon_background = "content/ui/textures/icons/appearances/backgrounds/body_tattoos",
						no_option = true,
						slot_name = "slot_body_tattoo",
						template = "icon",
						type = "body_tattoo",
						options = body_tattoos,
						mute_unique_icon = archetype_name == "ogryn",
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local tattoo_groups = {}

	for ii = 1, #full_body_tattoos do
		local option = full_body_tattoos[ii]
		local tattoo_group = option.tattoo_group
		local slot = option.slots[1]

		tattoo_groups[tattoo_group] = tattoo_groups[tattoo_group] or {
			item_group = true,
		}
		tattoo_groups[tattoo_group][slot] = option
	end

	tattoo_groups = table.map_to_array(tattoo_groups, function (k, v)
		return v
	end)

	if not table.is_empty(tattoo_groups) then
		appearance_options[#appearance_options + 1] = {
			icon = "content/ui/materials/icons/item_types/full_body_tattoos",
			continue_validation = function ()
				local slots = {
					"slot_body_tattoo",
					"slot_body_face_tattoo",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_full_body_tattoo"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 3,
						icon_background = "content/ui/textures/icons/appearances/backgrounds/full_body_tattoos",
						no_option = true,
						template = "icon",
						type = "full_body_tattoo",
						options = tattoo_groups,
						slot_name = {
							"slot_body_tattoo",
							"slot_body_face_tattoo",
						},
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local face_scar_options = self._character_create:slot_item_options("slot_body_face_scar")

	if #face_scar_options > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/scars",
			continue_validation = function ()
				local slots = {
					"slot_body_face_scar",
				}

				return _continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_face_scar"),
			on_pressed_function = function (widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_columns = 3,
						icon_background = "content/ui/textures/icons/appearances/backgrounds/scars",
						no_option = true,
						slot_name = "slot_body_face_scar",
						template = "icon",
						options = face_scar_options,
					},
				})

				for ii = 1, #options do
					local option = options[ii]
					local grid_index = 1 + ii
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	appearance_options[#appearance_options + 1] = {
		icon = "content/ui/materials/icons/item_types/cryptic_height",
		text = Localize("loc_body_height"),
		on_pressed_function = function (widget, pressed_options)
			local options = self:_get_appearance_category_options({
				{
					grid_columns = 1,
					template = "vertical_slider",
					type = "height",
				},
			})

			for ii = 1, #options do
				local option = options[ii]
				local grid_index = 1 + ii
				local grid_data = {
					init = function ()
						return self:_generate_appearance_grid_widgets(grid_index, option)
					end,
					options = function ()
						return option.options
					end,
				}

				self:_populate_page_grid(grid_index, grid_data, function ()
					self:_set_camera_height_option(nil)
				end)
			end
		end,
	}

	for ii = 1, #appearance_options do
		local appearance_option = appearance_options[ii]

		appearance_option.value = ii

		local appearance_function = appearance_option.on_pressed_function

		appearance_option.on_pressed_function = function (widget, pressed_options)
			if ii == self._apperance_option_selected_index then
				return
			end

			for jj = 2, #self._page_grids do
				self:_destroy_page_grid(jj)
			end

			self._apperance_option_selected_index = ii

			self:_set_camera(appearance_option.camera_focus, nil, nil)
			appearance_function(widget, pressed_options)
			self:_update_appearance_background()
		end

		appearance_option.on_focused_function = function (grid_index, widget)
			return
		end
	end

	return appearance_options
end

CharacterAppearanceView._get_companion_appearance_options = function (self)
	local appearance_options = {}
	local dog_fur_options = self._character_create:slot_item_options("slot_companion_body_fur_color")
	local dog_skin_options = self._character_create:slot_item_options("slot_companion_body_skin_color")
	local selected_fur_option = self._character_create:slot_item("slot_companion_body_fur_color")
	local filtered_dog_fur_options = {}

	for ii = 1, #dog_fur_options do
		local dog_fur_option = dog_fur_options[ii]

		if CompanionDogRestrictions[dog_fur_option.dev_name] then
			filtered_dog_fur_options[#filtered_dog_fur_options + 1] = dog_fur_option
		end
	end

	local fur_skin_from_fur = CompanionDogRestrictions[selected_fur_option.dev_name] or {}
	local filtered_dog_skin_options = {}
	local dog_skin_from_dev_name = {}

	for ii = 1, #dog_skin_options do
		local dog_skin_option = dog_skin_options[ii]

		dog_skin_from_dev_name[dog_skin_option.dev_name] = dog_skin_option
	end

	for ii = 1, #fur_skin_from_fur do
		local skin_dev_name = fur_skin_from_fur[ii]

		filtered_dog_skin_options[#filtered_dog_skin_options + 1] = dog_skin_from_dev_name[skin_dev_name]
	end

	appearance_options[#appearance_options + 1] = {
		icon = "content/ui/materials/icons/item_types/fur_color",
		text = Localize("loc_character_creator_mastiff_fur"),
		on_pressed_function = function (widget, pressed_options)
			local options = self:_get_appearance_category_options({
				{
					grid_columns = 2,
					mute_unique_icon = true,
					slot_name = "slot_companion_body_fur_color",
					template = "icon",
					type = "dog_fur",
					options = filtered_dog_fur_options,
				},
				{
					grid_columns = 2,
					mute_unique_icon = true,
					slot_name = "slot_companion_body_skin_color",
					template = "icon_small_texture_hsv",
					type = "dog_skin",
					options = filtered_dog_skin_options,
				},
			})

			for ii = 1, #options do
				local option = options[ii]
				local grid_index = 1 + ii
				local grid_data = {
					init = function ()
						return self:_generate_appearance_grid_widgets(grid_index, option)
					end,
					selected_option = function ()
						if option.selected_option then
							return option.selected_option()
						end
					end,
					options = function ()
						return option.options
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end
		end,
	}

	local dog_coat_options = self._character_create:slot_item_options("slot_companion_body_coat_pattern")

	appearance_options[#appearance_options + 1] = {
		icon = "content/ui/materials/icons/item_types/fur_pattern",
		text = Localize("loc_arbites_customization_dog_pattern"),
		on_pressed_function = function (widget, pressed_options)
			local options = self:_get_appearance_category_options({
				{
					grid_columns = 1,
					icon_background = "content/ui/textures/icons/appearances/dog/fur_pattern",
					mute_unique_icon = true,
					no_option = true,
					slot_name = "slot_companion_body_coat_pattern",
					template = "icon",
					type = "dog_coat",
					options = dog_coat_options,
				},
			})

			for ii = 1, #options do
				local option = options[ii]
				local grid_index = 1 + ii
				local grid_data = {
					init = function ()
						return self:_generate_appearance_grid_widgets(grid_index, option)
					end,
					selected_option = function ()
						if option.selected_option then
							return option.selected_option()
						end
					end,
					options = function ()
						return option.options
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end
		end,
	}

	for ii = 1, #appearance_options do
		local appearance_option = appearance_options[ii]

		appearance_option.value = ii

		local appearance_function = appearance_option.on_pressed_function

		appearance_option.on_pressed_function = function (widget, pressed_options)
			if ii == self._apperance_option_selected_index then
				return
			end

			for jj = 2, #self._page_grids do
				self:_destroy_page_grid(jj)
			end

			self._apperance_option_selected_index = ii

			appearance_function(widget, pressed_options)
			self:_update_appearance_background()
		end

		appearance_option.on_focused_function = function (grid_index, widget)
			return
		end
	end

	return appearance_options
end

local HSV_PROPERTY_NAMES = table.set({
	"hsv_eye",
	"emissive_color_hsv_1",
	"emissive_color_hsv_2",
	"hsv_skin",
	"metal1_hsv_tint",
	"metal2_hsv_tint",
})

CharacterAppearanceView._hsv_from_item = function (self, item)
	local material_override_items = item.material_override_items

	if material_override_items then
		for ii = 1, #material_override_items do
			local override_item = MasterItems.get_cached()[material_override_items[ii]]
			local vector3_material_overrides = override_item and override_item.vector3_material_overrides

			if vector3_material_overrides then
				for override_i = 1, #vector3_material_overrides do
					local override_data = vector3_material_overrides[override_i]

					if HSV_PROPERTY_NAMES[override_data.property_name] then
						return override_data.value
					end
				end
			end
		end
	end

	return nil
end

local OXIDATION_LEVEL_PROPERTY_NAMES = table.set({
	"oxid_level",
})

CharacterAppearanceView._oxidation_level_from_item = function (self, item)
	local material_override_items = item.material_override_items

	if material_override_items then
		for ii = 1, #material_override_items do
			local override_item = MasterItems.get_cached()[material_override_items[ii]]
			local vector2_material_overrides = override_item and override_item.vector2_material_overrides

			if vector2_material_overrides then
				for override_i = 1, #vector2_material_overrides do
					local override_data = vector2_material_overrides[override_i]

					if OXIDATION_LEVEL_PROPERTY_NAMES[override_data.property_name] then
						return override_data.value
					end
				end
			end
		end
	end

	return nil
end

local OXIDATION_TEXTURE_SLOTS = table.set({
	"metal1_oxid_gradient",
	"metal2_oxid_gradient",
})

CharacterAppearanceView._oxidation_texture_from_item = function (self, item)
	local material_override_items = item.material_override_items

	if material_override_items then
		for ii = 1, #material_override_items do
			local override_item = MasterItems.get_cached()[material_override_items[ii]]
			local texture_material_overrides = override_item and override_item.texture_material_overrides

			if texture_material_overrides then
				for override_i = 1, #texture_material_overrides do
					local override_data = texture_material_overrides[override_i]

					if OXIDATION_TEXTURE_SLOTS[override_data.texture_slot] then
						return override_data.texture
					end
				end
			end
		end
	end

	return nil
end

CharacterAppearanceView._get_appearance_category_options = function (self, category_entry_options)
	category_entry_options = table.filter_array(category_entry_options, function (entry)
		return entry.options == nil or #entry.options > 0
	end)

	local profile = self._character_create:profile()
	local archetype_settings = profile.archetype
	local archetype_name = archetype_settings.name
	local grids = {}

	local function add_eye_color_grid(eye_color_options, init_pressed_options)
		local options = self:_get_appearance_category_options({
			{
				grid_columns = 2,
				ignore_fallback_in_sorting = true,
				slot_name = "slot_body_eye_color",
				template = "icon_small_texture_hsv",
				type = "eye_color",
				options = eye_color_options,
			},
		})

		for ii = 1, #options do
			local option = options[ii]
			local grid_index = 2 + ii
			local grid_data = {
				init = function ()
					return self:_generate_appearance_grid_widgets(grid_index, option)
				end,
				selected_option = function ()
					if option.selected_option then
						return option.selected_option()
					end
				end,
				options = function ()
					return option.options
				end,
				init_pressed_options = init_pressed_options,
			}

			self:_populate_page_grid(grid_index, grid_data)
		end
	end

	local function eye_items_by_selected_type(current_option)
		local eye_options = self._eye_options_by_type[current_option.name]
		local selected_option = eye_options[1]
		local ignored_params = current_option.search_params
		local current_override_data = {}
		local current_material_override_items = current_option.material_override_items

		if current_material_override_items then
			for ii = 1, #current_material_override_items do
				local override_item = MasterItems.get_cached()[current_material_override_items[ii]]
				local scalar_material_overrides = override_item and override_item.scalar_material_overrides
				local vector3_material_overrides = override_item.vector3_material_overrides

				if scalar_material_overrides then
					for override_i = 1, #scalar_material_overrides do
						local scalar_material_override = scalar_material_overrides[override_i]

						current_override_data[scalar_material_override.property_name] = scalar_material_override.value
					end
				end

				if vector3_material_overrides then
					for override_i = 1, #vector3_material_overrides do
						local vector3_material_override = vector3_material_overrides[override_i]

						current_override_data[vector3_material_override.property_name] = vector3_material_override.value
					end
				end
			end
		end

		for ii = 1, #eye_options do
			local found = true
			local eye_option = eye_options[ii]
			local material_override_items = eye_option.material_override_items
			local override_data = {}

			if material_override_items then
				for jj = 1, #material_override_items do
					local override_item = MasterItems.get_cached()[material_override_items[jj]]
					local scalar_material_overrides = override_item and override_item.scalar_material_overrides
					local vector3_material_overrides = override_item.vector3_material_overrides

					if scalar_material_overrides then
						for override_i = 1, #scalar_material_overrides do
							local scalar_material_override = scalar_material_overrides[override_i]

							override_data[scalar_material_override.property_name] = scalar_material_override.value
						end
					end

					if vector3_material_overrides then
						for override_i = 1, #vector3_material_overrides do
							local vector3_material_override = vector3_material_overrides[override_i]

							override_data[vector3_material_override.property_name] = vector3_material_override.value
						end
					end
				end
			end

			for name, override_value in pairs(override_data) do
				if not ignored_params[name] then
					local current_eye_override_value = current_override_data[name]

					if not current_eye_override_value or override_value and current_eye_override_value ~= override_value then
						found = false

						break
					end
				end
			end

			if found then
				selected_option = eye_option

				break
			end
		end

		return eye_options, selected_option
	end

	local function add_dog_skin_grid(dog_skin_options, init_pressed_options)
		local options = self:_get_appearance_category_options({
			{
				grid_columns = 2,
				icon_background = "content/ui/textures/icons/appearances/backgrounds/scars",
				slot_name = "slot_companion_body_skin_color",
				template = "icon_small_texture_hsv",
				type = "dog_skin",
				options = dog_skin_options,
			},
		})

		for ii = 1, #options do
			local option = options[ii]
			local grid_index = 2 + ii
			local grid_data = {
				init = function ()
					return self:_generate_appearance_grid_widgets(grid_index, option)
				end,
				selected_option = function ()
					if option.selected_option then
						return option.selected_option()
					end
				end,
				options = function ()
					return option.options
				end,
				init_pressed_options = init_pressed_options,
			}

			self:_populate_page_grid(grid_index, grid_data)
		end
	end

	local function dog_skin_items_by_selected_pattern(selected_fur_option)
		local dog_skin_options = self._character_create:slot_item_options("slot_companion_body_skin_color")
		local fur_skin_from_fur = CompanionDogRestrictions[selected_fur_option.dev_name] or {}
		local filtered_dog_skin_options = {}
		local dog_skin_from_dev_name = {}

		for ii = 1, #dog_skin_options do
			local dog_skin_option = dog_skin_options[ii]

			dog_skin_from_dev_name[dog_skin_option.dev_name] = dog_skin_option
		end

		for ii = 1, #fur_skin_from_fur do
			local skin_dev_name = fur_skin_from_fur[ii]

			filtered_dog_skin_options[#filtered_dog_skin_options + 1] = dog_skin_from_dev_name[skin_dev_name]
		end

		return filtered_dog_skin_options
	end

	for ii = 1, #category_entry_options do
		local category_entry_option = category_entry_options[ii]
		local entry_type = category_entry_option.type
		local entry_options = category_entry_option.options
		local entry_slot_name = category_entry_option.slot_name
		local entry_type_template = category_entry_option.template
		local grid_columns = category_entry_option.grid_columns
		local entry_no_option = category_entry_option.no_option
		local entry_icon_background = category_entry_option.icon_background
		local entry_enter = category_entry_option.on_enter
		local entry_leave = category_entry_option.on_leave
		local continue_validation = category_entry_option.validation
		local mute_unique_icon = category_entry_option.mute_unique_icon
		local ignore_fallback_in_sorting = category_entry_option.ignore_fallback_in_sorting
		local force_nil_item = category_entry_option.force_nil_item
		local temp_option_a, temp_option_b = {
			value = nil,
		}, {
			value = nil,
		}

		if entry_options then
			local function _is_fallback_item(option)
				if option.is_nil_item then
					return true
				end

				if not force_nil_item and option.is_fallback_item then
					if type(entry_slot_name) == "table" then
						return table.contains(entry_slot_name, option.slots[1])
					else
						return option.slots[1] == entry_slot_name
					end
				end

				return false
			end

			if entry_no_option and not table.find_func_array(entry_options, _is_fallback_item) then
				table.insert(entry_options, 1, {
					is_nil_item = true,
				})
			end

			local original_order = table.mirror_array(entry_options)

			local function _cmp(a, b)
				if type(a) ~= "table" or type(b) ~= "table" then
					return original_order[a] < original_order[b]
				end

				if not a.is_nil_item ~= not b.is_nil_item then
					return not not a.is_nil_item
				end

				if not a.is_fallback_item ~= not b.is_fallback_item and not ignore_fallback_in_sorting then
					return not not a.is_fallback_item
				end

				temp_option_a.value, temp_option_b.value = a, b

				local a_available, a_reason = self._character_create:is_option_available(temp_option_a)
				local b_available, b_reason = self._character_create:is_option_available(temp_option_b)

				if a_available ~= b_available then
					return a_available
				end

				local a_class_specific = a_reason == "class"
				local b_class_specific = b_reason == "class"

				if a_class_specific ~= b_class_specific then
					return a_class_specific
				end

				if a_reason ~= b_reason then
					if a_reason and b_reason then
						return a_reason < b_reason
					end

					return not not a_reason
				end

				local a_sort_order, b_sort_order = a.sort_order or math.huge, b.sort_order or math.huge

				if a_sort_order ~= b_sort_order then
					return a_sort_order < b_sort_order
				end

				if a.display_name and b.display_name and a.display_name ~= b.display_name then
					local loc_a, loc_b = Localize(a.display_name), Localize(b.display_name)

					if loc_a ~= loc_b then
						return loc_a < loc_b
					end
				end

				local hsv_a = self:_hsv_from_item(a)
				local hsv_b = self:_hsv_from_item(b)

				if hsv_a and hsv_b then
					for jj = 1, 3 do
						if hsv_a[jj] ~= hsv_b[jj] then
							return hsv_a[jj] < hsv_b[jj]
						end
					end
				end

				if a.name ~= b.name then
					return a.name < b.name
				end

				return original_order[a] < original_order[b]
			end

			table.sort(entry_options, function (a, b)
				local cmp_a

				if type(a) == "table" and a.item_group then
					for slot_id, item in pairs(a) do
						local order = 0

						if slot_id ~= "item_group" then
							order = order + 1
							original_order[item] = order

							if cmp_a then
								cmp_a = _cmp(cmp_a, item) and cmp_a or item
							else
								cmp_a = item
							end
						end
					end
				end

				local cmp_b

				if type(b) == "table" and b.item_group then
					for slot_id, item in pairs(b) do
						local order = 0

						if slot_id ~= "item_group" then
							order = order + 1
							original_order[item] = order

							if cmp_b then
								cmp_b = _cmp(cmp_b, item) and cmp_b or item
							else
								cmp_b = item
							end
						end
					end
				end

				return _cmp(cmp_a or a, cmp_b or b)
			end)
		end

		local options = {}

		grids[ii] = {
			focused_on_gamepad_navigation = true,
			continue_validation = continue_validation,
			template = entry_type_template,
			slot_name = entry_slot_name,
			options = options,
			grid_columns = grid_columns,
			on_enter = entry_enter,
			on_leave = entry_leave,
			no_option = entry_no_option,
			icon_background = entry_icon_background,
			type = entry_type,
			mute_unique_icon = mute_unique_icon,
		}

		if entry_type == "gender" then
			local gender_presentation = {
				female = "content/ui/textures/icons/appearances/body_types/feminine",
				male = "content/ui/textures/icons/appearances/body_types/masculine",
			}

			for jj = 1, #entry_options do
				local option = entry_options[jj]

				options[#options + 1] = {
					on_pressed_function = function (widget, pressed_options)
						if option ~= self._character_create:gender() then
							self._character_create:set_gender(option)

							local page = self._pages[self._active_page_number]
							local page_grids = page.grids

							if page_grids then
								for kk = 1, #page_grids do
									local grid = page_grids[kk]

									self:_populate_page_grid(1, grid)
								end
							end
						end
					end,
					value = option,
					icon_texture = gender_presentation[option],
					on_focused_function = function (grid_index, widget)
						return
					end,
				}
			end

			grids[ii].selected_option = function ()
				return self._character_create:gender()
			end
		elseif entry_type == "skin_color" then
			for jj = 1, #entry_options do
				local option = entry_options[jj]
				local hsv_skin = self:_hsv_from_item(option)
				local oxidation_level = self:_oxidation_level_from_item(option)
				local oxidation_texture = self:_oxidation_texture_from_item(option)

				options[#options + 1] = {
					color = hsv_skin,
					oxidation_level = oxidation_level,
					oxidation_texture = oxidation_texture,
					value = option,
					on_pressed_function = function (widget, pressed_options)
						self._character_create:set_item_per_slot(entry_slot_name, option)
						_remove_gamepad_focused_slots(self, entry_slot_name)
						self:_update_icons()
					end,
					on_focused_function = function (grid_index, widget)
						_add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[ii].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end

			if archetype_name == "cryptic" then
				grids[ii].texture = "content/ui/materials/icons/appearances/metal_color"
			else
				grids[ii].texture = "content/ui/materials/icons/appearances/skin_color"
			end
		elseif entry_type == "eye_type" then
			for jj = 1, #entry_options do
				local option = entry_options[jj]

				options[#options + 1] = {
					value = option,
					icon_texture = option.icon_texture,
					on_pressed_function = function (widget, pressed_options)
						local eye_options, selected_option = eye_items_by_selected_type(option)

						if not selected_option then
							return
						end

						self._character_create:set_item_per_slot(entry_slot_name, selected_option)
						_remove_gamepad_focused_slots(self, entry_slot_name)
						add_eye_color_grid(eye_options)
					end,
					on_focused_function = function (grid_index, widget)
						local eye_options, selected_option = eye_items_by_selected_type(option)

						if not selected_option then
							return
						end

						_add_gamepad_focused_slots(self, entry_slot_name, selected_option, nil, function (original_option)
							local eye_type_index = _get_eye_type_index_by_option(original_option)
							local eye_type_option = EYE_TYPES[eye_type_index]
							local new_eye_options, new_selected_option = eye_items_by_selected_type(eye_type_option)

							if new_selected_option then
								add_eye_color_grid(new_eye_options, {
									force_focus_navigation = self._navigation.previous_grid ~= self._navigation.grid and self._navigation.grid == 3,
								})
							end
						end)
						add_eye_color_grid(eye_options, {
							from_eye_type_focused = true,
						})
					end,
				}
			end

			grids[ii].selected_option = function ()
				local option = self._character_create:slot_item(entry_slot_name)
				local index = _get_eye_type_index_by_option(option)
				local selected_eye_type = EYE_TYPES[index]
				local selected_eye_type_name = selected_eye_type and selected_eye_type.name

				for jj = 1, #entry_options do
					local entry_option = entry_options[jj]

					if entry_option.name == selected_eye_type_name then
						return entry_option
					end
				end
			end
		elseif entry_type == "eye_color" then
			for jj = 1, #entry_options do
				local option = entry_options[jj]
				local hsv_eye = self:_hsv_from_item(option)

				options[#options + 1] = {
					value = option,
					color = hsv_eye,
					on_pressed_function = function (widget, pressed_options)
						if pressed_options and pressed_options.force_focus_navigation then
							local previous_grid = self._navigation.previous_grid
							local previous_index = self._navigation.previous_index

							self._navigation.previous_grid = self._navigation.grid
							self._navigation.previous_index = self._navigation.index
							self._navigation.grid = previous_grid
							self._navigation.index = previous_index

							self:_grid_navigation("right")
						elseif not pressed_options or not pressed_options.from_eye_type_focused then
							self._character_create:set_item_per_slot(entry_slot_name, option)
							_remove_gamepad_focused_slots(self, entry_slot_name)
						end
					end,
					on_focused_function = function (grid_index, widget, pressed_options)
						if pressed_options and pressed_options.from_eye_type_focused then
							return
						end

						_add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			if archetype_name == "cryptic" then
				grids[ii].texture = "content/ui/materials/icons/appearances/lens_color"
			else
				grids[ii].texture = "content/ui/materials/icons/appearances/eye_color"
			end

			grids[ii].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
		elseif entry_type == "hair_color" then
			for jj = 1, #entry_options do
				local option = entry_options[jj]
				local index = #options + 1
				local icon_texture = entry_no_option and index == 1 and "content/ui/textures/icons/appearances/no_option" or nil
				local color = {
					255,
					255,
					255,
					255,
				}
				local material_override_items = option.material_override_items

				if material_override_items then
					for kk = 1, #material_override_items do
						local override_item = MasterItems.get_cached()[material_override_items[kk]]
						local vector3_material_overrides = override_item and override_item.vector3_material_overrides

						if vector3_material_overrides then
							for override_i = 1, #vector3_material_overrides do
								local override_data = vector3_material_overrides[override_i]

								if override_data.property_name == "hair_rgb" then
									local hair_rgb = override_data.value

									color[2] = color[2] * hair_rgb[1]
									color[3] = color[3] * hair_rgb[2]
									color[4] = color[4] * hair_rgb[3]
								end
							end
						end
					end
				end

				options[index] = {
					icon_texture = icon_texture,
					color = not icon_texture and color or {
						0,
						255,
						255,
						255,
					},
					value = option,
					on_pressed_function = function (widget, pressed_options)
						self._character_create:set_item_per_slot(entry_slot_name, option)
						_remove_gamepad_focused_slots(self, entry_slot_name)
						self:_update_icons()
					end,
					on_focused_function = function (grid_index, widget)
						_add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[ii].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
			grids[ii].texture = "content/ui/materials/icons/appearances/hair_color"
		elseif entry_type == "dog_fur" then
			for name, option in pairs(entry_options) do
				local texture = ""
				local material_override_items = option.material_override_items

				if material_override_items then
					for jj = 1, #material_override_items do
						local override_item = MasterItems.get_cached()[material_override_items[jj]]
						local texture_material_overrides = override_item and override_item.texture_material_overrides

						if texture_material_overrides then
							for override_i = 1, #texture_material_overrides do
								local override_data = texture_material_overrides[override_i]

								if override_data.texture_slot == "fur_color_gradient" then
									texture = override_data.texture
								end
							end
						end
					end
				end

				options[#options + 1] = {
					value = option,
					icon_texture = texture,
					on_pressed_function = function (widget, pressed_options)
						self._character_create:set_item_per_slot(entry_slot_name, option)
						_remove_gamepad_focused_slots(self, entry_slot_name)

						local skin_options = dog_skin_items_by_selected_pattern(option)

						add_dog_skin_grid(skin_options)
					end,
					on_focused_function = function (grid_index, widget)
						_add_gamepad_focused_slots(self, entry_slot_name, option, nil, function (original_option)
							local dog_fur_option = self._character_create:slot_item(entry_slot_name)
							local skin_options = dog_skin_items_by_selected_pattern(dog_fur_option)

							_remove_gamepad_focused_slots(self, "slot_companion_body_skin_color")
							add_dog_skin_grid(skin_options, {
								force_focus_navigation = self._navigation.previous_grid ~= self._navigation.grid and self._navigation.grid == 3,
							})
						end)

						local skin_options = dog_skin_items_by_selected_pattern(option)

						add_dog_skin_grid(skin_options, {
							from_dog_fur_focused = true,
						})
					end,
				}
			end

			grids[ii].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
		elseif entry_type == "dog_skin" then
			for name, option in pairs(entry_options) do
				local color = {
					255,
					255,
					255,
				}
				local material_override_items = option.material_override_items

				if material_override_items then
					for jj = 1, #material_override_items do
						local override_item = MasterItems.get_cached()[material_override_items[jj]]
						local vector3_material_overrides = override_item and override_item.vector3_material_overrides

						if vector3_material_overrides then
							for override_i = 1, #vector3_material_overrides do
								local override_data = vector3_material_overrides[override_i]

								if override_data.property_name == "skin_hsv" then
									local skin_hsv = override_data.value

									color[1] = skin_hsv[1]
									color[2] = skin_hsv[2]
									color[3] = skin_hsv[3]
								end
							end
						end
					end
				end

				options[#options + 1] = {
					color = color,
					value = option,
					on_pressed_function = function (widget, pressed_options)
						if pressed_options and pressed_options.force_focus_navigation then
							local previous_grid = self._navigation.previous_grid
							local previous_index = self._navigation.previous_index

							self._navigation.previous_grid = self._navigation.grid
							self._navigation.previous_index = self._navigation.index
							self._navigation.grid = previous_grid
							self._navigation.index = previous_index

							self:_grid_navigation("right")
						elseif not pressed_options or not pressed_options.from_dog_fur_focused then
							self._character_create:set_item_per_slot(entry_slot_name, option)
							_remove_gamepad_focused_slots(self, entry_slot_name)
						else
							_add_gamepad_focused_slots(self, entry_slot_name, option)
						end
					end,
					on_focused_function = function (grid_index, widget, pressed_options)
						if pressed_options and pressed_options.from_dog_fur_focused then
							return
						end

						_add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[ii].texture = "content/ui/materials/icons/appearances/skin_color"
			grids[ii].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
		elseif entry_type == "height" then
			options[#options + 1] = {
				on_value_updated = function (value)
					local height_range = self._character_create:get_height_values_range()
					local min_height = height_range.min
					local max_height = height_range.max
					local scale_factor = math.lerp(min_height, max_height, value)
					local format_string = string.format("%%0.%sf", 3)

					scale_factor = string.format(format_string, scale_factor)
					scale_factor = tonumber(scale_factor)

					self:_set_character_height(scale_factor)
					self:_set_camera_height_option(0.5)
				end,
			}
		elseif entry_type == "dog_coat" then
			for name, option in pairs(entry_options) do
				local index = #options + 1
				local icon_texture

				if entry_no_option then
					if index == 1 then
						icon_texture = "content/ui/textures/icons/appearances/no_option"
					else
						icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", index - 1)
					end
				else
					icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", index)
				end

				options[index] = {
					value = option,
					icon_texture = icon_texture,
					on_pressed_function = function (widget, pressed_options)
						self._character_create:set_item_per_slot(entry_slot_name, option)
						_remove_gamepad_focused_slots(self, entry_slot_name)
					end,
					on_focused_function = function (grid_index, widget)
						_add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[ii].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
		elseif entry_type == "full_body_tattoo" or entry_type == "body_tattoo" or entry_type == "face_tattoo" then
			for jj = 1, #entry_options do
				local option = entry_options[jj]
				local index = #options + 1
				local icon_texture

				if entry_no_option then
					if index == 1 then
						icon_texture = "content/ui/textures/icons/appearances/no_option"
					else
						icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", index - 1)
					end
				else
					icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", index)
				end

				options[index] = {
					value = option,
					icon_texture = icon_texture,
					on_pressed_function = function (widget, pressed_options)
						if entry_type == "full_body_tattoo" then
							if option.is_nil_item then
								local face_slot_item = self._character_create:slot_item("slot_body_face_tattoo")

								if face_slot_item and face_slot_item.tattoo_group ~= "" then
									self._character_create:set_item_per_slot("slot_body_face_tattoo", nil)
									self._character_create:try_unshelve_item_per_slot("slot_body_face_tattoo")
								end

								local body_slot_item = self._character_create:slot_item("slot_body_tattoo")

								if body_slot_item and body_slot_item.tattoo_group ~= "" then
									self._character_create:set_item_per_slot("slot_body_tattoo", nil)
									self._character_create:try_unshelve_item_per_slot("slot_body_tattoo")
								end
							elseif option.item_group then
								for slot_id, item in pairs(option) do
									if slot_id ~= "item_group" then
										local slot_item = self._character_create:slot_item(slot_id)

										if slot_item and slot_item.tattoo_group ~= "" ~= (item.tattoo_group ~= "") then
											self._character_create:shelve_item_per_slot(slot_id, item)
										else
											self._character_create:set_item_per_slot(slot_id, item)
										end
									end
								end
							end
						elseif not pressed_options or not pressed_options.initialization_press then
							local face_slot_item = self._character_create:slot_item("slot_body_face_tattoo")

							if face_slot_item and face_slot_item.tattoo_group ~= "" then
								self._character_create:try_unshelve_item_per_slot("slot_body_face_tattoo")
								self._character_create:set_item_per_slot("slot_body_face_tattoo", nil)
							end

							local body_slot_item = self._character_create:slot_item("slot_body_tattoo")

							if body_slot_item and body_slot_item.tattoo_group ~= "" then
								self._character_create:try_unshelve_item_per_slot("slot_body_tattoo")
								self._character_create:set_item_per_slot("slot_body_tattoo", nil)
							end

							self._character_create:set_item_per_slot(entry_slot_name, option)
						end

						_remove_gamepad_focused_slots(self, entry_slot_name)
						self:_update_icons()
					end,
					on_focused_function = function (grid_index, widget)
						if option.item_group then
							for slot_id, item in pairs(option) do
								if slot_id ~= "item_group" then
									local slot_item = self._character_create:slot_item(slot_id)

									if slot_item and slot_item.tattoo_group ~= "" ~= (item.tattoo_group ~= "") then
										self._character_create:shelve_item_per_slot(slot_id, slot_item)
									end
								end
							end
						end

						_add_gamepad_focused_slots(self, entry_slot_name, option, nil, nil, true)
					end,
				}
			end

			grids[ii].selected_option = function ()
				if type(entry_slot_name) == "table" then
					local slot_name = entry_slot_name[1]
					local item_in_slot = self._character_create:slot_item(slot_name)

					if item_in_slot then
						for entry_i = 1, #entry_options do
							local option = entry_options[entry_i]

							if option[slot_name] and option[slot_name].name == item_in_slot.name then
								return option
							end
						end
					else
						return table.find_by_key(entry_options, "is_nil_item", true)
					end
				else
					return self._character_create:slot_item(entry_slot_name)
				end
			end
		else
			for jj = 1, #entry_options do
				local option = entry_options[jj]
				local index = #options + 1
				local icon_texture

				if entry_no_option then
					if index == 1 then
						icon_texture = "content/ui/textures/icons/appearances/no_option"
					else
						icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", index - 1)
					end
				else
					icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", index)
				end

				options[index] = {
					icon_texture = icon_texture,
					value = option,
					on_pressed_function = function (widget, pressed_options)
						self._character_create:set_item_per_slot(entry_slot_name, option)
						_remove_gamepad_focused_slots(self, entry_slot_name)
						self:_update_icons()
					end,
					on_focused_function = function (grid_index, widget)
						_add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[ii].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
		end
	end

	return grids
end

CharacterAppearanceView._check_valid_option = function (self, option)
	if option and type(option.data) ~= "table" and type(option.value) ~= "table" then
		return true
	end

	local value = option.data or option
	local visible = true
	local available = true
	local reason, reason_display_name

	if value and value.value and value.value.item_group then
		local temp_option = {
			value = nil,
		}

		for slot_id, sub_option in pairs(value.value) do
			temp_option.value = sub_option
			visible = visible and self._character_create:is_option_visible(temp_option)

			if visible then
				local sub_available, sub_reason, sub_reason_display_name = self._character_create:is_option_available(temp_option)

				available = available and sub_available
				reason = reason or sub_reason
				reason_display_name = reason_display_name or sub_reason_display_name
			else
				reason = nil
				reason_display_name = nil
			end
		end
	else
		visible = self._character_create:is_option_visible(value)

		if visible then
			available, reason, reason_display_name = self._character_create:is_option_available(value)
		end
	end

	return visible, available, reason, reason_display_name
end

CharacterAppearanceView._randomize_character_appearance_preset = function (self)
	self._character_create:randomize_character_apperance_preset()
	self:_update_character_apperance_selected_options()
	self:_update_icons()
end

CharacterAppearanceView._randomize_voice_effects = function (self)
	self._character_create:randomize_voice_effects()
	self:_update_voice_matrix_and_slider()
end

CharacterAppearanceView._update_voice_matrix_and_slider = function (self)
	local voice_effects = self._character_create:voice_effects()

	for ii = 1, #self._page_grids[1].widgets do
		local value_x, value_y, value_slider = voice_effects[RTPC_EFFECT_X], voice_effects[RTPC_EFFECT_Y], voice_effects[RTPC_EFFECT_SLIDER]
		local content = self._page_grids[1].widgets[ii].content

		if content.slider_value_x and content.slider_value_y then
			content.slider_value_x = value_x / 100
			content.slider_value_y = 1 - value_y / 100
		end

		if content.slider_value then
			content.slider_value = value_slider / 100
		end

		_set_voice_character_create_values(self._character_create, value_x, value_y, value_slider)
		_set_voice_wwise_values(self._voice_sample_source, value_x, value_y, value_slider)
		_set_voice_screen_component_values(self._voice_screen_component, value_x, value_y, value_slider)
	end
end

CharacterAppearanceView._update_character_apperance_selected_options = function (self)
	for ii = 1, #self._page_grids do
		local page_grid = self._page_grids[ii]
		local selected_option_func = page_grid.grid_data and page_grid.grid_data.selected_option

		if selected_option_func then
			local selected_option = selected_option_func()
			local widgets = page_grid.widgets

			if selected_option and widgets then
				for jj = 1, #widgets do
					local widget = widgets[jj]
					local widget_option = widget.content.option

					if widget_option and selected_option == widget_option.value then
						page_grid.grid:select_widget(widget, false, true)

						break
					end
				end
			end
		end
	end
end

CharacterAppearanceView._update_icons = function (self)
	for ii = 1, #self._page_grids do
		local grid = self._page_grids[ii]
		local widgets = grid.widgets

		if widgets then
			for jj = 1, #grid.widgets do
				local widget = grid.widgets[jj]
				local element = widget.content.element
				local template_name = element and element.template
				local template = template_name and CharacterAppearanceViewContentBlueprints[template_name]
				local update_func = template and template.update_icon

				if widget.content.icon_load_id and update_func then
					update_func(self, widget, element)
				end
			end
		end
	end
end

CharacterAppearanceView._get_personality_options = function (self)
	local personalities = self._character_create:personality_options()
	local personality_options = {}
	local world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(world)

	self._voice_sample_source = self._voice_sample_source or WwiseWorld.make_manual_source(wwise_world, Vector3.zero())

	local function on_personality_voice_trigger(personality_settings, widget)
		local sample_sound_event = personality_settings.sample_sound_event

		if widget.content.sound_id then
			local stop_event = "wwise/events/vo/stop_voice_preview"

			self:_play_sound(stop_event)

			widget.content.sound_id = nil

			if self._waveform_screen_unit then
				Unit.set_scalar_for_materials(self._waveform_screen_unit, "state", 0)
			end
		else
			for ii = 1, #self._page_grids[1].widgets do
				local grid_widget = self._page_grids[1].widgets[ii]
				local sound_id = grid_widget.content.sound_id

				if sound_id and WwiseWorld.is_playing(wwise_world, sound_id) then
					WwiseWorld.stop_event(wwise_world, sound_id)

					grid_widget.content.sound_id = nil
				end
			end

			widget.content.sound_id = WwiseWorld.trigger_resource_event(wwise_world, sample_sound_event, self._voice_sample_source)

			if self._waveform_screen_unit then
				Unit.set_scalar_for_materials(self._waveform_screen_unit, "state", 1)
			end
		end
	end

	for id, option in pairs(personalities) do
		personality_options[#personality_options + 1] = {
			continue_validation = function ()
				local current_personality = self._character_create:personality()

				if current_personality and current_personality.id == id then
					return self._character_create:is_option_available(current_personality)
				end

				return true
			end,
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function (widget, pressed_options)
				self._character_create:set_personality(id)

				local skip_voice = pressed_options and (pressed_options.skip_voice or pressed_options.initialization_press)

				if not skip_voice then
					on_personality_voice_trigger(option, widget)
				end

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return personality_options
end

CharacterAppearanceView._get_voice_options = function (self)
	local voice_settings = self._character_create:voice_options()
	local voice_template = {}
	local world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(world)

	self._voice_sample_source = self._voice_sample_source or WwiseWorld.make_manual_source(wwise_world, Vector3.zero())

	local voice_effects = self._character_create:voice_effects()

	_set_voice_wwise_values(self._voice_sample_source, voice_effects[RTPC_EFFECT_X], voice_effects[RTPC_EFFECT_Y], voice_effects[RTPC_EFFECT_SLIDER])
	_set_initial_voice_screen_component_values(self._voice_screen_component, voice_effects[RTPC_EFFECT_X], voice_effects[RTPC_EFFECT_Y], voice_effects[RTPC_EFFECT_SLIDER])

	local function on_voice_value_updated(value_x, value_y)
		for ii = 1, #self._page_grids[1].widgets do
			if value_y then
				_set_voice_character_create_values(self._character_create, value_x, value_y, nil)
				_set_voice_wwise_values(self._voice_sample_source, value_x, value_y, nil)
				_set_voice_screen_component_values(self._voice_screen_component, value_x, value_y, nil)
			else
				_set_voice_character_create_values(self._character_create, nil, nil, value_x)
				_set_voice_wwise_values(self._voice_sample_source, nil, nil, value_x)
				_set_voice_screen_component_values(self._voice_screen_component, nil, nil, value_x)
			end
		end
	end

	voice_template[#voice_template + 1] = {
		max_value = 100,
		min_value = 0,
		on_value_updated = function (value_x, value_y)
			local epsilon = 1e-06
			local floor_x = math.floor(value_x + epsilon)
			local floor_y = value_y and math.floor(value_y)

			on_voice_value_updated(floor_x, floor_y)
		end,
	}

	local voice_matrix = voice_template[1]
	local matrix_options = voice_settings.matrix
	local option_x = matrix_options[1]

	voice_matrix.min_value_x = option_x.range.min
	voice_matrix.max_value_x = option_x.range.max
	voice_matrix.text_x = option_x.display_name

	local option_y = matrix_options[2]

	voice_matrix.min_value_y = option_y.range.min
	voice_matrix.max_value_y = option_y.range.max
	voice_matrix.text_y = option_y.display_name

	return voice_template
end

CharacterAppearanceView._get_crime_options = function (self)
	local crimes = self._character_create:crime_options()
	local crime_options = {}

	for id, option in pairs(crimes) do
		crime_options[#crime_options + 1] = {
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function (widget, pressed_options)
				self._character_create:set_crime(id)

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return crime_options
end

local DX = {
	default = 1.2,
	ogryn = 1.7,
}
local MINDWIPE_DX = {
	cryptic = 1.2,
	default = 0.85,
	ogryn = 1.5,
}

CharacterAppearanceView._pan_camera = function (self, revert)
	local world_spawner = self._world_spawners[self._active_world]
	local dx = 0
	local profile = self._character_create:profile()
	local archetype = profile.archetype
	local archetype_name = archetype.name

	if not revert then
		local wanted_dx = self._is_barber_mindwipe and MINDWIPE_DX or DX

		dx = wanted_dx[archetype_name] or wanted_dx.default
	end

	local time = 1.5
	local func_ptr = math.easeOutCubic

	world_spawner:set_target_camera_offset_for_axis("dx", dx, time, func_ptr)
end

CharacterAppearanceView._rotate_camera = function (self, target_rotation, instant)
	local world_spawner = self._world_spawners[self._active_world]
	local rotation_time = instant and 0 or 0.5
	local camera_rotation = world_spawner:camera_rotation()
	local epsilon = 0.001
	local more_than_90_deg = Quaternion.angle(camera_rotation, target_rotation) > math.pi * 0.5 + epsilon
	local func_ptr = math.ease_in_out_sine

	if more_than_90_deg then
		func_ptr = math.ease_in_out_cubic
	end

	world_spawner:set_target_camera_rotation(target_rotation, rotation_time, func_ptr)
end

CharacterAppearanceView._reset_camera = function (self)
	local world_spawner = self._world_spawners[self._active_world]

	if world_spawner then
		world_spawner:reset_target_camera_rotation(0)
	end
end

CharacterAppearanceView._generate_final_page_widgets = function (self, grid_index, grid_data, is_companion)
	local grid_start_name = "grid_" .. grid_index .. "_"
	local grid_scenegraph = grid_start_name .. "pivot"
	local grid_area_scenegraph = grid_start_name .. "area"
	local grid_content_scenegraph = grid_start_name .. "content"
	local templates = {}
	local background_size = {
		660,
		0,
	}
	local grid_margin = 30
	local grid_size = {
		background_size[1] - grid_margin * 2,
		0,
	}
	local spacing = {
		10,
		0,
	}
	local text_style = CharacterAppearanceViewFontStyle.randomize_button_text_style
	local randomize_text = Utf8.upper(Localize("loc_randomize"))
	local text_width, _ = Text.text_size(self._ui_renderer, randomize_text, text_style, {
		math.huge,
		500,
	})
	local randomize_size = {
		text_width + 100,
		60,
	}
	local input_width = grid_size[1] - randomize_size[1] - spacing[1]
	local input_name_template, input_template

	if not is_companion then
		input_name_template = {
			size = {
				grid_size[1],
				30,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "text",
					value_id = "text",
					value = Localize("loc_character_create_title_name"),
					style = CharacterAppearanceViewFontStyle.header_final_title_style,
				},
				{
					pass_type = "rect",
					style_id = "baseline",
					style = {
						vertical_alignment = "bottom",
						color = Color.terminal_corner(255, true),
						size = {
							nil,
							2,
						},
					},
				},
			},
		}

		local template_type = "name_input"
		local template = CharacterAppearanceViewContentBlueprints[template_type]
		local character_name = self._character_create:name()

		if character_name == "" or character_name == nil then
			if self._original_name then
				self._character_create:set_name(self._original_name)
			else
				self:_randomize_character_name()
			end
		end

		character_name = self._character_create:name()

		local profile = self._character_create:profile()
		local archetype = profile.archetype
		local name_input_settings = archetype.name_input
		local name_max_length = name_input_settings.max_length
		local error_message_loc_key = name_input_settings.error_loc_key
		local error_message_loc_variables = name_input_settings.error_loc_variables

		input_template = {
			support_widget_name = "name_input",
			size = {
				input_width,
				60,
			},
			pass_template = template.pass_template,
			init = function (parent, widget, element)
				template.init(parent, widget, element)
				parent:_update_character_name(widget, element.initial_name, true)
			end,
			element = {
				initial_name = character_name,
				template = template_type,
				max_length = name_max_length,
				error_message = Localize(error_message_loc_key, not not error_message_loc_variables, error_message_loc_variables),
				on_update_function = function (parent, widget)
					local name = type(widget.content.input_text) == "string" and widget.content.input_text ~= "" and widget.content.input_text or widget.content.selected_text or ""

					if self._character_create:name() ~= name then
						parent:_update_character_custom_name(widget, name)
					end
				end,
			},
		}
	else
		input_name_template = {
			size = {
				grid_size[1],
				30,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "text",
					value_id = "text",
					value = Localize("loc_character_creator_mastiff_name"),
					style = CharacterAppearanceViewFontStyle.header_final_title_style,
				},
				{
					pass_type = "rect",
					style_id = "baseline",
					style = {
						vertical_alignment = "bottom",
						color = Color.terminal_corner(255, true),
						size = {
							nil,
							2,
						},
					},
				},
			},
		}

		local template_type = "name_input"
		local template = CharacterAppearanceViewContentBlueprints[template_type]
		local companion_character_name = self._character_create:companion_name()

		if companion_character_name == "" or companion_character_name == nil then
			if self._original_companion_name then
				self._character_create:set_companion_name(self._original_companion_name)
			else
				self:_randomize_companion_name()
			end
		end

		companion_character_name = self._character_create:companion_name()

		local profile = self._character_create:profile()
		local archetype = profile.archetype
		local companion_name_input_settings = archetype.companion_name_input
		local name_max_length = companion_name_input_settings.max_length
		local error_message_loc_key = companion_name_input_settings.error_loc_key
		local error_message_loc_variables = companion_name_input_settings.error_loc_variables

		input_template = {
			support_widget_name = "companion_name_input",
			size = {
				input_width,
				60,
			},
			pass_template = template.pass_template,
			init = function (parent, widget, element)
				template.init(parent, widget, element)
				parent:_update_companion_name(widget, element.initial_name, true)
			end,
			element = {
				initial_name = companion_character_name,
				template = template_type,
				max_length = name_max_length,
				error_message = Localize(error_message_loc_key, not not error_message_loc_variables, error_message_loc_variables),
				on_update_function = function (parent, widget)
					local name = type(widget.content.input_text) == "string" and widget.content.input_text ~= "" and widget.content.input_text or widget.content.selected_text or ""

					if self._character_create:companion_name() ~= name then
						parent:_update_companion_custom_name(widget, name)
					end
				end,
			},
		}
	end

	local function randomize_button_template()
		return {
			size = randomize_size,
			pass_template = {
				{
					content_id = "hotspot",
					pass_type = "hotspot",
					content = {
						on_released_sound = nil,
						on_hover_sound = UISoundEvents.default_mouse_hover,
						on_pressed_sound = UISoundEvents.default_click,
					},
				},
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/base/ui_default_base",
					value_id = "icon",
					style = {
						vertical_alignment = "center",
						hover_color = Color.terminal_frame_selected(255, true),
						default_color = Color.terminal_text_body(255, true),
						color = Color.terminal_text_body(255, true),
						size = {
							30,
							30,
						},
						material_values = {
							texture_map = "content/ui/textures/icons/generic/randomize",
						},
						offset = {
							20,
							0,
							2,
						},
					},
					change_function = function (content, style, _, dt)
						local default_color = style.default_color
						local hover_color = style.hover_color
						local color = style.color
						local hotspot = content.hotspot
						local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

						Colors.color_lerp(default_color, hover_color, progress, color)

						style.hdr = progress == 1
					end,
					visibility_function = function (content, style)
						return self._using_cursor_navigation
					end,
				},
				{
					pass_type = "texture",
					style_id = "background_gradient",
					value = "content/ui/materials/masks/gradient_horizontal_sides_dynamic_02",
					style = {
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							3,
						},
						size_addition = {
							-10,
							0,
						},
						default_color = Color.terminal_frame(nil, true),
						hover_color = Color.terminal_frame_selected(nil, true),
						color = Color.terminal_text_body(255, true),
					},
					change_function = function (content, style, _, dt)
						local default_color = style.default_color
						local hover_color = style.hover_color
						local color = style.color
						local hotspot = content.hotspot
						local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

						Colors.color_lerp(default_color, hover_color, progress, color)

						style.hdr = progress == 1
					end,
					visibility_function = function (content, style)
						return content.hotspot.is_focused or content.hotspot.is_hover
					end,
				},
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					style = {
						horizontal_alignment = "center",
						scale_to_material = true,
						vertical_alignment = "center",
						size_addition = {
							-10,
							0,
						},
						default_color = Color.terminal_frame(nil, true),
						hover_color = Color.terminal_frame_selected(nil, true),
						color = Color.terminal_text_body(255, true),
						offset = {
							0,
							0,
							4,
						},
					},
					change_function = function (content, style, _, dt)
						local default_color = style.default_color
						local hover_color = style.hover_color
						local color = style.color
						local hotspot = content.hotspot
						local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

						Colors.color_lerp(default_color, hover_color, progress, color)

						style.hdr = progress == 1
					end,
				},
				{
					pass_type = "texture",
					style_id = "corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						horizontal_alignment = "center",
						scale_to_material = true,
						vertical_alignment = "center",
						size_addition = {
							-10,
							0,
						},
						default_color = Color.terminal_corner(nil, true),
						hover_color = Color.terminal_corner_selected(nil, true),
						color = Color.terminal_text_body(255, true),
						offset = {
							0,
							0,
							5,
						},
					},
					change_function = function (content, style, _, dt)
						local default_color = style.default_color
						local hover_color = style.hover_color
						local color = style.color
						local hotspot = content.hotspot
						local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

						Colors.color_lerp(default_color, hover_color, progress, color)

						style.hdr = progress == 1
					end,
				},
				{
					pass_type = "text",
					style_id = "text",
					value = "",
					value_id = "text",
					style = CharacterAppearanceViewFontStyle.randomize_button_text_style,
					change_function = function (content, style)
						ButtonPassTemplates.default_button_text_change_function(content, style)

						local original_offset = CharacterAppearanceViewFontStyle.randomize_button_text_style.offset[1]

						style.offset[1] = self._using_cursor_navigation and original_offset or 24
					end,
				},
			},
			init = function (parent, widget, element)
				widget.content.ignore_navigation = true

				widget.content.hotspot.pressed_callback = function ()
					if not self._using_cursor_navigation then
						self:_play_sound(UISoundEvents.character_appearence_option_pressed)
					end

					local input_widget = parent._page_grids and parent._page_grids[1] and parent._page_grids[1].support_widgets_by_name

					if is_companion then
						input_widget = input_widget and input_widget.companion_name_input

						self:_randomize_companion_name(input_widget)
					else
						input_widget = input_widget and input_widget.name_input

						self:_randomize_character_name(input_widget)
					end
				end
			end,
			content = {
				gamepad_action = "hotkey_menu_special_2",
				original_text = randomize_text,
			},
		}
	end

	local backstory_text = self:_generate_final_backstory_text()
	local backstory_font_style = CharacterAppearanceViewFontStyle.description_style
	local _, backstory_text_height = Text.text_size(self._ui_renderer, backstory_text, backstory_font_style, {
		grid_size[1],
		0,
	})
	local backstory_size = {
		grid_size[1],
		backstory_text_height + 10,
	}
	local backstory_text_template = {
		size = backstory_size,
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value_id = "text",
				value = backstory_text,
				style = backstory_font_style,
			},
		},
	}

	templates[#templates + 1] = input_name_template
	templates[#templates + 1] = {
		size = {
			grid_size[1],
			15,
		},
	}
	templates[#templates + 1] = input_template
	templates[#templates + 1] = randomize_button_template()
	templates[#templates + 1] = {
		size = {
			grid_size[1],
			20,
		},
	}

	if not is_companion then
		templates[#templates + 1] = backstory_text_template
	end

	local widgets = {}
	local support_widgets = {}
	local alignment_list = {}
	local total_height = 0
	local accumulated_width = 0
	local accumulated_height = 0

	for ii = 1, #templates do
		local template = templates[ii]
		local widget
		local size = template.size

		accumulated_width = accumulated_width + size[1]
		accumulated_height = math.max(accumulated_height, size[2])

		local next_width = templates[ii + 1] and templates[ii + 1].size[1] or 0

		if accumulated_width + next_width > grid_size[1] then
			total_height = total_height + accumulated_height
			accumulated_height = 0
			accumulated_width = 0
		end

		if template.pass_template then
			local template_content = template.content
			local definition = UIWidget.create_definition(template.pass_template, grid_scenegraph, template_content, size)

			widget = self:_create_widget(grid_start_name .. "widget_" .. ii, definition)

			if template.init then
				template.init(self, widget, template.element)
			end
		end

		if widget then
			widgets[#widgets + 1] = widget
			alignment_list[#alignment_list + 1] = widget

			local support_widget_name = template.support_widget_name

			if support_widget_name then
				support_widgets[support_widget_name] = widget
				widget.content.is_grid_widget = true
			end
		else
			widgets[#widgets + 1] = nil
			alignment_list[#alignment_list + 1] = {
				size = size,
			}
		end
	end

	if accumulated_width > 0 then
		total_height = total_height + accumulated_height
	end

	background_size[2] = total_height + grid_margin * 2
	grid_size[2] = total_height

	local support_widget_definitions = {
		grid_background = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "top_frame",
				value = "content/ui/materials/dividers/horizontal_frame_big_upper",
				value_id = "top_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						-18,
						1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/terminal_basic",
				value_id = "background",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					color = Color.terminal_grid_background(nil, true),
					size_addition = {
						20,
						30,
					},
					offset = {
						0,
						-15,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "bottom_frame",
				value = "content/ui/materials/dividers/horizontal_frame_big_lower",
				value_id = "bottom_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						18,
						1,
					},
				},
			},
		}, grid_scenegraph, nil, background_size),
		mask = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						5,
					},
					size_addition = {
						20,
						20,
					},
				},
			},
		}, grid_area_scenegraph, nil, background_size),
	}

	for name, definition in pairs(support_widget_definitions) do
		local widget = self:_create_widget(grid_start_name .. "support_widget_" .. name, definition)

		if name == "grid_background" then
			widget.offset = {
				widget.offset[1] - grid_margin,
				widget.offset[2] - grid_margin,
				widget.offset[3] + 4,
			}
		end

		widget.offset = {
			widget.offset[1],
			widget.offset[2],
			widget.offset[3] + 4,
		}
		support_widgets[name] = widget
	end

	local grid_position = {
		self._ui_scenegraph.canvas.size[1] - background_size[1] + grid_margin,
		50 + grid_margin,
	}
	local return_grid_data = {
		grid_size = background_size,
		grid_position = grid_position,
		grid_scenegraph = grid_scenegraph,
		grid_area_scenegraph = grid_area_scenegraph,
		grid_content_scenegraph = grid_content_scenegraph,
		grid_spacing = spacing,
	}

	return widgets, alignment_list, support_widgets, return_grid_data
end

CharacterAppearanceView._generate_final_backstory_text = function (self)
	local planet_snippet = self._character_create:planet().story_snippet
	local childhood_snippet = self._character_create:childhood().story_snippet
	local growing_up_snippet = self._character_create:growing_up().story_snippet
	local formative_event_snippet = self._character_create:formative_event().story_snippet
	local crime_snippet = self._character_create:crime().story_snippet
	local end_snippet = Localize("loc_character_backstory_snippet")
	local profile = self._character_create:profile()
	local archetype = profile.archetype

	if archetype.backstory_snippet then
		end_snippet = Localize(archetype.backstory_snippet)
	end

	if self._is_barber_mindwipe then
		end_snippet = Localize("loc_character_backstory_snippet_mindwipe")
	end

	local backstory_text = string.format("%s %s %s %s%s\n\n%s", Localize(planet_snippet), Localize(childhood_snippet), Localize(growing_up_snippet), formative_event_snippet and Localize(formative_event_snippet) or "", crime_snippet and string.format("\n\n%s", Localize(crime_snippet)) or "", end_snippet)

	return backstory_text
end

CharacterAppearanceView._randomize_character_name = function (self, input_widget)
	local name = self._character_create:randomize_name()

	self._character_create:set_name(name)

	self._character_name_status.custom = false

	if input_widget then
		self:_stop_name_input(input_widget)

		input_widget.content.input_text = name
	end

	self:_check_input_errors(name)
end

CharacterAppearanceView._randomize_companion_name = function (self, input_widget)
	local name = self._character_create:randomize_companion_name()

	self._character_create:set_companion_name(name)

	self._companion_name_status.custom = false

	if input_widget then
		self:_stop_name_input(input_widget)

		input_widget.content.input_text = name
	end

	self:_check_input_errors(name)
end

CharacterAppearanceView._set_camera = function (self, camera_focus_name, no_height_compensation, duration)
	duration = duration or 1
	self._disable_zoom = false

	local focus_camera_unit = self._camera_by_focus_name[camera_focus_name]

	self._focus_camera_unit = focus_camera_unit

	local world_spawner = self._world_spawners[self._active_world]
	local func_ptr = math.easeOutCubic
	local is_camera_zoomed = self:_is_camera_zoomed(camera_focus_name)
	local camera_zoom_changed = self._camera_zoomed ~= is_camera_zoomed
	local focus_slot_changed = self._camera_focus_name ~= camera_focus_name
	local profile = self._character_create:profile()
	local archetype_settings = profile.archetype
	local archetype_name = archetype_settings.name
	local breed_name = archetype_settings.breed

	if camera_zoom_changed or focus_slot_changed then
		local active_page_name = self._active_page_name
		local animations_per_archetype = CharacterAppearanceViewSettings.animations_per_archetype
		local archetype_animations_settings = animations_per_archetype[archetype_name]
		local animations_per_page = archetype_animations_settings.animations_per_page
		local animation_settings = animations_per_page[active_page_name] or animations_per_page.default
		local is_barber = self._is_barber
		local zoom_events = is_barber and animation_settings.barber_zoom_events or animation_settings.zoom_events
		local default_event = is_barber and animation_settings.barber_default_event or animation_settings.default_event
		local animation_event = is_camera_zoomed and zoom_events[camera_focus_name] or default_event
		local previous_animation_event = self._camera_zoomed and zoom_events[self._camera_focus_name] or default_event
		local animation_changed = animation_event ~= previous_animation_event

		if animation_changed and not self:_is_in_barber_chair() then
			self._profile_spawner:assign_animation_event(animation_event)
		end

		self._camera_zoomed = is_camera_zoomed
		self._camera_focus_name = camera_focus_name
	end

	local boxed_camera_start_position = world_spawner:boxed_camera_start_position()
	local default_camera_world_position = Vector3.from_array(boxed_camera_start_position)
	local boxed_camera_start_rotation = world_spawner:boxed_camera_start_rotation()
	local default_camera_world_rotation = boxed_camera_start_rotation:unbox()
	local target_world_position = focus_camera_unit and Unit.world_position(focus_camera_unit, 1) or default_camera_world_position
	local target_world_rotation = focus_camera_unit and Unit.world_rotation(focus_camera_unit, 1) or default_camera_world_rotation
	local x, y, z = target_world_position.x, target_world_position.y, target_world_position.z

	if no_height_compensation then
		local breed_height_difference = breed_name == "ogryn" and -0.2 or 0

		z = z + breed_height_difference
	else
		local height = self:_is_in_barber_chair() and 1 or self._character_create:height()

		z = z * height
	end

	local active_page = self._pages[self._active_page_number]
	local camera_position_offset = active_page.camera_position_offset

	if camera_position_offset then
		x = x + camera_position_offset[1]
		y = y + camera_position_offset[2]
		z = z + camera_position_offset[3]
	end

	world_spawner:set_target_camera_position(x, y, z, duration, func_ptr)
	world_spawner:set_target_camera_rotation(target_world_rotation, duration, func_ptr)
end

CharacterAppearanceView._zoom_camera = function (self)
	local slot_name

	if self._camera_zoomed then
		slot_name = nil
	else
		local grids = self._pages[self._active_page_number].grids

		for ii = #grids, 1, -1 do
			local grid = grids[ii]
			local option = grid.options()[grid.selected_option()]

			if option and option.camera_focus then
				slot_name = option.camera_focus

				break
			end
		end
	end

	self:_set_camera(slot_name, nil, nil)
end

CharacterAppearanceView._check_widget_choice_detail_visibility = function (self, grid_index, widget_index)
	local page_grid = self._page_grids[grid_index]
	local widget = page_grid and page_grid.widgets[widget_index]
	local presentation_data = widget and widget.content and widget.content.choice_data

	if not presentation_data then
		self._widgets_by_name.choice_detail.content.visible = false

		return
	end

	local available = presentation_data.available
	local reason = presentation_data.reason
	local reason_display_name = presentation_data.reason_display_name and Localize(presentation_data.reason_display_name)
	local choice_info = self:_archetype_page_data()[reason] or RESTRICTION_DATAS[reason]

	if reason then
		self._widgets_by_name.choice_detail.content.visible = true
		self._widgets_by_name.choice_detail.content.available = available
	else
		self._widgets_by_name.choice_detail.content.visible = false
	end

	if choice_info then
		self._widgets_by_name.choice_detail.content.use_choice_icon = true
		self._widgets_by_name.choice_detail.style.choice_icon.material_values = {
			texture_map = choice_info.icon_texture,
		}

		if choice_info.disabling_reason then
			self._widgets_by_name.choice_detail.content.text = Localize("loc_character_create_disabled_reason", true, {
				reason = reason_display_name,
			})
		elseif choice_info.unique_reason then
			self._widgets_by_name.choice_detail.content.text = Localize("loc_character_create_unique_reason", true, {
				reason = reason_display_name,
			})
		elseif choice_info.uses_source then
			local item = widget.content.option.value

			if item and item.item_group then
				for key, value in pairs(item) do
					if string.find(key, "slot_") then
						item = value

						break
					end
				end
			end

			local title, description = Items.obtained_display_name(item)

			self._widgets_by_name.choice_detail.content.text = Localize("loc_character_create_choice_reason", true, {
				description = description or "",
				choice = title,
			})
		elseif reason_display_name then
			self._widgets_by_name.choice_detail.content.text = Localize("loc_character_create_choice_reason", true, {
				description = Localize(choice_info.title),
				choice = reason_display_name,
			})
		else
			self._widgets_by_name.choice_detail.content.text = ""
		end

		local first_grid = self._page_grids[1]
		local first_grid_position = first_grid.position
		local first_grid_size = first_grid.size

		self:_set_scenegraph_position("choice_detail", first_grid_position[1], first_grid_position[2] + first_grid_size[2] + 10)
	else
		self._widgets_by_name.choice_detail.content.use_choice_icon = false
		self._widgets_by_name.choice_detail.content.text = ""
	end
end

CharacterAppearanceView._set_camera_height_option = function (self, duration)
	self:_set_camera(nil, nil, duration)

	self._disable_zoom = true
end

CharacterAppearanceView._fetch_suggested_names = function (self)
	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype.name
	local selected_gender = self._character_create:gender()

	if self._character_name_status.archetype ~= selected_archetype or self._character_name_status.gender ~= selected_gender then
		self._character_name_status.archetype = selected_archetype
		self._character_name_status.gender = selected_gender

		return self._character_create:fetch_suggested_names_by_profile():next(function ()
			if not self._character_name_status.custom and not self._is_barber_mindwipe then
				local random_name = self._character_create:randomize_name()

				self._character_create:set_name(random_name)
			end

			if not self._companion_name_status.custom then
				local random_name = self._character_create:randomize_companion_name()

				self._character_create:set_companion_name(random_name)
			end

			return true
		end):catch(function ()
			if not self._character_name_status.custom and not self._is_barber_mindwipe then
				local random_name = self._character_create:randomize_name()

				self._character_create:set_name(random_name)
			end

			if not self._companion_name_status.custom then
				local random_name = self._character_create:randomize_companion_name()

				self._character_create:set_companion_name(random_name)
			end

			return true
		end)
	else
		return Promise.resolved(true)
	end
end

CharacterAppearanceView._check_input_errors = function (self, name, optional_error_message)
	local string_empty = not name or name and #name < 3

	self:_update_continue_button("input_error", string_empty, optional_error_message)
end

CharacterAppearanceView._update_character_custom_name = function (self, widget, name)
	self._character_name_status.custom = true

	self:_update_character_name(widget, name)
end

CharacterAppearanceView._update_character_name = function (self, widget, name, is_initial_setup)
	local error_message = widget.content.error_message

	self:_check_input_errors(name, error_message)
	self._character_create:set_name(name)

	if self._is_barber_mindwipe and not is_initial_setup then
		self:_check_mindwipe_changes({
			"name",
		})
	end
end

CharacterAppearanceView._update_companion_custom_name = function (self, widget, name)
	self._companion_name_status.custom = true

	self:_update_companion_name(widget, name)
end

CharacterAppearanceView._update_companion_name = function (self, widget, name, is_initial_setup)
	local error_message = widget.content.error_message

	self:_check_input_errors(name, error_message)
	self._character_create:set_companion_name(name)

	if self._is_barber_mindwipe and not is_initial_setup then
		self:_check_mindwipe_changes({
			"companion_name",
		})
	end
end

local ALL_CHANGES = {
	"loadout",
	"voice",
	"backstory",
	"height",
	"name",
	"companion_name",
	"voice_effects",
}

CharacterAppearanceView._check_mindwipe_changes = function (self, change_list)
	local player = Managers.player:local_player(1)
	local real_profile = player:profile()
	local has_modifications

	if change_list then
		has_modifications = self._character_create:has_modifications(real_profile, change_list)
	else
		has_modifications = self._character_create:has_modifications(real_profile, ALL_CHANGES)
	end

	self:_update_continue_button("mindwipe_no_changes", not has_modifications)
end

CharacterAppearanceView._stop_name_input = function (self, input_widget)
	if input_widget then
		local content = input_widget.content

		content.selected_text = nil
		content._selection_start = nil
		content._selection_end = nil
		content.is_writing = false
	end
end

CharacterAppearanceView._show_loading_awaiting_validation = function (self, is_active)
	self._loading_overlay_visible = is_active

	if is_active then
		self._widgets_by_name.loading_overlay.content.text = Localize("loc_character_create_await_validation")
	end

	self._widgets_by_name.loading_overlay.content.visible = is_active
end

CharacterAppearanceView._handle_input = function (self, input_service)
	if input_service:get("navigate_up_continuous") then
		self:_grid_navigation("up")
	elseif input_service:get("navigate_down_continuous") then
		self:_grid_navigation("down")
	elseif input_service:get("navigate_left_continuous") then
		self:_grid_navigation("left")
	elseif input_service:get("navigate_right_continuous") then
		self:_grid_navigation("right")
	elseif not self._using_cursor_navigation then
		local used_input = false
		local continue_widget = self._widgets_by_name.continue_button

		if continue_widget then
			local action_input = continue_widget.content.gamepad_action

			if input_service:get(action_input) and not continue_widget.content.hotspot.disabled then
				continue_widget.content.hotspot:pressed_callback()

				used_input = true
			end
		end

		local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name

		if not used_input then
			local name_input_widget = support_widgets and support_widgets.name_input

			if name_input_widget and input_service:get("hotkey_menu_special_2") then
				self:_randomize_character_name(name_input_widget)
			end
		end

		if not used_input then
			local companion_name_input_widget = support_widgets and support_widgets.companion_name_input

			if companion_name_input_widget and input_service:get("hotkey_menu_special_2") then
				self:_randomize_companion_name(companion_name_input_widget)
			end
		end
	end
end

CharacterAppearanceView._grid_navigation = function (self, direction)
	local widgets_data = {}
	local current_grid_index = self._navigation.grid
	local current_widget_index = self._navigation.index
	local current_widget_data

	for ii = 1, #self._page_grids do
		local grid_widgets = self._page_grids[ii].widgets
		local grid_position = self._page_grids[ii].position

		if grid_widgets then
			for jj = 1, #grid_widgets do
				local grid_widget = grid_widgets[jj]
				local hotspot = grid_widget.content.hotspot

				if hotspot then
					local size = grid_widget.content.size
					local offset = grid_widget.offset
					local index = #widgets_data + 1
					local widget_data = {
						index = index,
						grid_index = ii,
						widget_index = jj,
						position = {
							grid_position[1] + offset[1] + size[1] * 0.5,
							grid_position[2] + offset[2] + size[2] * 0.5,
						},
						size = size,
					}

					if ii == current_grid_index and jj == current_widget_index then
						current_widget_data = widget_data
					end

					widgets_data[index] = widget_data
				end
			end
		end
	end

	current_widget_data = current_widget_data or widgets_data[1]

	local selected_widget_data
	local current_x_position = current_widget_data.position[1]
	local current_y_position = current_widget_data.position[2]
	local current_x_size = current_widget_data.size[1]

	if direction == "left" then
		table.sort(widgets_data, function (a, b)
			return a.position[1] > b.position[1]
		end)

		for ii = 1, #widgets_data do
			local widget_data = widgets_data[ii]

			if widget_data.index == current_widget_data.index then
				local closest_x_distance, closest_y_distance

				for jj = ii + 1, #widgets_data do
					local next_widget_data = widgets_data[jj]
					local next_x_position = next_widget_data.position[1]
					local next_y_position = next_widget_data.position[2]
					local x_distance = math.abs(current_x_position - next_x_position)
					local not_selected_vertically = x_distance > current_x_size * 0.5

					if not_selected_vertically and (not closest_x_distance or x_distance < closest_x_distance) then
						closest_x_distance = x_distance
					end

					if closest_x_distance == x_distance then
						local y_distance = math.abs(current_y_position - next_y_position)

						if not closest_y_distance or y_distance < closest_y_distance then
							closest_y_distance = y_distance
							selected_widget_data = next_widget_data
						end
					end
				end

				break
			end
		end
	elseif direction == "right" then
		table.sort(widgets_data, function (a, b)
			return a.position[1] < b.position[1]
		end)

		for ii = 1, #widgets_data do
			local widget_data = widgets_data[ii]

			if widget_data.index == current_widget_data.index then
				local closest_x_distance, closest_y_distance

				for jj = ii + 1, #widgets_data do
					local next_widget_data = widgets_data[jj]
					local next_x_position = next_widget_data.position[1]
					local next_y_position = next_widget_data.position[2]
					local x_distance = math.abs(current_x_position - next_x_position)
					local not_selected_vertically = x_distance > current_x_size * 0.5

					if not_selected_vertically and (not closest_x_distance or x_distance < closest_x_distance) then
						closest_x_distance = x_distance
					end

					if closest_x_distance == x_distance then
						local y_distance = math.abs(current_y_position - next_y_position)

						if not closest_y_distance or y_distance < closest_y_distance then
							closest_y_distance = y_distance
							selected_widget_data = next_widget_data
						end
					end
				end

				break
			end
		end
	elseif direction == "up" then
		table.sort(widgets_data, function (a, b)
			return a.position[2] > b.position[2]
		end)

		for ii = 1, #widgets_data do
			local widget_data = widgets_data[ii]

			if widget_data.index == current_widget_data.index then
				local closest_x_distance, closest_y_distance

				for jj = ii + 1, #widgets_data do
					local next_widget_data = widgets_data[jj]
					local next_x_position = next_widget_data.position[1]
					local next_y_position = next_widget_data.position[2]
					local next_y_size = current_widget_data.size[2]
					local x_distance = math.abs(current_x_position - next_x_position)
					local y_distance = current_y_position - (next_y_position + next_y_size * 0.5)
					local widget_grid_index = current_widget_data.grid_index
					local next_grid_index = next_widget_data.grid_index
					local is_same_grid = widget_grid_index == next_grid_index

					if y_distance > 0 and is_same_grid and (not closest_x_distance or x_distance <= closest_x_distance) then
						if not closest_x_distance or x_distance < closest_x_distance then
							closest_y_distance = nil
						end

						if not closest_y_distance or y_distance < closest_y_distance then
							closest_y_distance = y_distance
							closest_x_distance = x_distance
							selected_widget_data = next_widget_data
						end
					end
				end

				break
			end
		end
	elseif direction == "down" then
		table.sort(widgets_data, function (a, b)
			return a.position[2] < b.position[2]
		end)

		for ii = 1, #widgets_data do
			local widget_data = widgets_data[ii]

			if widget_data.index == current_widget_data.index then
				local closest_x_distance, closest_y_distance

				for jj = ii + 1, #widgets_data do
					local next_widget_data = widgets_data[jj]
					local next_x_position = next_widget_data.position[1]
					local next_y_position = next_widget_data.position[2]
					local next_y_size = current_widget_data.size[2]
					local x_distance = math.abs(current_x_position - next_x_position)
					local y_distance = next_y_position - next_y_size * 0.5 - current_y_position
					local widget_grid_index = current_widget_data.grid_index
					local next_grid_index = next_widget_data.grid_index
					local is_same_grid = widget_grid_index == next_grid_index

					if y_distance > 0 and is_same_grid and (not closest_x_distance or x_distance <= closest_x_distance) then
						if not closest_x_distance or x_distance < closest_x_distance then
							closest_y_distance = nil
						end

						if not closest_y_distance or y_distance < closest_y_distance then
							closest_y_distance = y_distance
							closest_x_distance = x_distance
							selected_widget_data = next_widget_data
						end
					end
				end

				break
			end
		end
	end

	if selected_widget_data then
		local grid_index = selected_widget_data.grid_index
		local widget_index = selected_widget_data.widget_index
		local is_moving_back_to_first_grid = (self._active_page_name == "appearance" or self._active_page_name == "companion_appearance") and grid_index == 1 and self._navigation.grid and self._navigation.grid > 1

		if is_moving_back_to_first_grid then
			widget_index = self._apperance_option_selected_index
		end

		local page_grid = self._page_grids[grid_index]
		local widget = page_grid.widgets[widget_index]

		if not widget.content.ignore_navigation then
			if widget.content.hotspot.pressed_callback and not widget.content.ignore_pressed_on_navigation then
				widget.content.hotspot.pressed_callback({
					from_navigation = true,
				})
			elseif widget.content.ignore_pressed_on_navigation then
				self:_update_navigation(grid_index, widget_index)
			end
		end
	end
end

CharacterAppearanceView._update_navigation = function (self, grid_index, widget_index, apply_focus)
	local changed_grid = grid_index ~= self._navigation.grid

	self._navigation.previous_grid = self._navigation.grid
	self._navigation.previous_index = self._navigation.index
	self._navigation.grid = grid_index
	self._navigation.index = widget_index

	if changed_grid then
		self:_revert_all_gamepad_focused_loadout()
	end

	if apply_focus then
		local page_grid = self._page_grids[grid_index]

		if page_grid and page_grid.focused_on_gamepad_navigation then
			local scrollbar_animation_progress = page_grid.grid:get_scrollbar_percentage_by_index(widget_index)

			page_grid.grid:focus_grid_index(widget_index, scrollbar_animation_progress, true)
		end
	end
end

CharacterAppearanceView._on_navigation_input_changed = function (self)
	CharacterAppearanceView.super._on_navigation_input_changed(self)
	self:_revert_all_gamepad_focused_loadout()

	if self._using_cursor_navigation then
		self:_remove_all_focus()
	else
		local grid_index = self._navigation.grid
		local widget_index = self._navigation.index

		if grid_index and widget_index and self._page_grids[grid_index] then
			self._page_grids[grid_index].grid:focus_grid_index(widget_index)
		end
	end
end

CharacterAppearanceView._revert_all_gamepad_focused_loadout = function (self)
	if self._gamepad_focused_loadout then
		for slot, _ in pairs(self._gamepad_focused_loadout) do
			_remove_gamepad_focused_slots(self, slot, true)
		end
	end

	for ii = 1, #self._page_grids do
		local page_grid = self._page_grids[ii]
		local selected_widget_index = page_grid.grid and page_grid.grid:selected_grid_index()

		if selected_widget_index then
			self:_check_widget_choice_detail_visibility(ii, selected_widget_index)
		end
	end
end

CharacterAppearanceView._remove_all_focus = function (self)
	for ii = 1, #self._page_grids do
		local page_grid = self._page_grids[ii]

		if page_grid.grid then
			page_grid.grid:focus_grid_index(nil)
		end
	end
end

CharacterAppearanceView.dialogue_system = function (self)
	if self._is_barber then
		return self._parent:dialogue_system()
	else
		return nil
	end
end

CharacterAppearanceView._set_active_world = function (self, page_name, spawn_character_changed)
	local level_names = self:_level_names()

	if not level_names[page_name] then
		page_name = "default"
	end

	self._active_world = page_name

	if not self._should_render_world then
		self:_destroy_background()

		return
	end

	local has_spawn_unit_before = self._spawn_point_unit

	if not self._world_spawners[page_name] then
		if not table.is_empty(self._world_spawners) then
			self:_destroy_background()
		end

		if self._fade_animation_id then
			self:_stop_animation(self._fade_animation_id)
		end

		self._fade_animation_id = self:_start_animation("on_level_switch")
		self._spawn_point_unit = nil

		self:_setup_background_world(page_name)
	end

	local has_spawn_unit_after = self._spawn_point_unit
	local active_state_machine = self._active_state_machine
	local state_machines = self:_state_machines()[page_name]
	local wanted_state_machine_or_nil = state_machines and state_machines[self._character_create:breed()] or nil

	self._active_state_machine = wanted_state_machine_or_nil
	spawn_character_changed = spawn_character_changed or wanted_state_machine_or_nil ~= active_state_machine

	if has_spawn_unit_after ~= has_spawn_unit_before or spawn_character_changed then
		self:_spawn_profile(self._spawn_point_unit, self._is_barber and wanted_state_machine_or_nil, self._is_barber and wanted_state_machine_or_nil and "idle")
	end

	for other_page_name, world_spawner in pairs(self._world_spawners) do
		if other_page_name ~= page_name then
			world_spawner:set_world_disabled(true, true)
		end
	end

	self._world_spawners[page_name]:set_world_disabled(false, true)
end

CharacterAppearanceView._world_spawner_by_world = function (self, world)
	for _, world_spawner in pairs(self._world_spawners) do
		if world_spawner:world() == world then
			return world_spawner
		end
	end
end

function _continue_validation_item_slots(self, slots)
	for ii = 1, #slots do
		local slot = slots[ii]
		local selected_option = self._gamepad_focused_loadout and self._gamepad_focused_loadout[slot] and self._gamepad_focused_loadout[slot].original_value or self._character_create:slot_item(slot)
		local option = {
			value = selected_option,
		}
		local available = self._character_create:is_option_available(option)

		if not available then
			return false
		end
	end

	return true
end

local _temp_slots = {}
local _temp_options = {}

function _add_gamepad_focused_slots(self, slot_array, option_map, optional_revert_function, optional_callback_function, peek_shelf)
	self._gamepad_focused_loadout = self._gamepad_focused_loadout or {}

	if type(slot_array) ~= "table" then
		_temp_slots[1] = slot_array
		slot_array = _temp_slots

		table.clear(_temp_options)

		_temp_options[slot_array[1]] = option_map
		option_map = _temp_options
	end

	for ii = 1, #slot_array do
		local slot = slot_array[ii]
		local option = option_map[slot]
		local stored_option = self._character_create:slot_item(slot)

		self._gamepad_focused_loadout[slot] = self._gamepad_focused_loadout[slot] or {
			original_value = stored_option,
			revert_func = optional_revert_function or function ()
				local original_option = self._gamepad_focused_loadout[slot].original_value

				if original_option and original_option.item_group then
					for slot_id, item in pairs(original_option) do
						if slot_id ~= "item_group" then
							self._character_create:set_item_per_slot(slot_id, item)
						end
					end
				else
					self._character_create:set_item_per_slot(slot, original_option)
				end
			end,
			callback_function = optional_callback_function,
		}

		if not option and peek_shelf then
			option = self._character_create:shelved_item(slot)
		end

		self._character_create:set_item_per_slot(slot, option)
	end
end

function _remove_gamepad_focused_slots(self, slots, revert)
	if type(slots) ~= "table" then
		_temp_slots[1] = slots
		slots = _temp_slots
	end

	for ii = 1, #slots do
		local slot = slots[ii]

		if self._gamepad_focused_loadout and self._gamepad_focused_loadout[slot] then
			local original_value = self._gamepad_focused_loadout[slot].original_value

			if revert and self._gamepad_focused_loadout[slot].revert_func then
				self._gamepad_focused_loadout[slot].revert_func()
			end

			local callback_function = self._gamepad_focused_loadout[slot].callback_function

			self._gamepad_focused_loadout[slot] = nil

			if callback_function then
				callback_function(original_value)
			end
		end
	end
end

function _get_eye_type_index_by_option(option)
	local material_override_items = option.material_override_items

	if material_override_items then
		for ii = 1, #material_override_items do
			local override_item = MasterItems.get_cached()[material_override_items[ii]]
			local scalar_material_overrides = override_item and override_item.scalar_material_overrides

			if scalar_material_overrides then
				for eye_type_i = 1, #EYE_TYPES do
					local eye_type = EYE_TYPES[eye_type_i]
					local search_params = eye_type.search_params

					if search_params then
						local found = true

						for name, value in pairs(search_params) do
							for override_i = 1, #scalar_material_overrides do
								local override_data = scalar_material_overrides[override_i]

								if override_data.property_name == name then
									local override_value = override_data.value

									if override_value and value ~= override_value then
										found = false

										break
									end
								end
							end
						end

						if found then
							return eye_type_i
						end
					end
				end
			end
		end
	end

	return 1
end

function _set_voice_character_create_values(character_create, value_x, value_y, value_slider)
	if value_x and value_y then
		character_create:set_voice_effect(RTPC_EFFECT_X, value_x)
		character_create:set_voice_effect(RTPC_EFFECT_Y, value_y)
	end

	if value_slider then
		character_create:set_voice_effect(RTPC_EFFECT_SLIDER, value_slider)
	end
end

function _set_voice_wwise_values(voice_sample_source, value_x, value_y, value_slider)
	local world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(world)

	if value_x and value_y then
		WwiseWorld.set_source_parameter(wwise_world, voice_sample_source, RTPC_EFFECT_X, value_x)
		WwiseWorld.set_source_parameter(wwise_world, voice_sample_source, RTPC_EFFECT_Y, value_y)
	end

	if value_slider then
		WwiseWorld.set_source_parameter(wwise_world, voice_sample_source, RTPC_EFFECT_SLIDER, value_slider)
	end
end

function _set_initial_voice_screen_component_values(voice_screen_component, value_x, value_y, value_slider)
	if voice_screen_component then
		voice_screen_component:init_texts(value_x, value_y, value_slider)
	end
end

function _set_voice_screen_component_values(voice_screen_component, value_x, value_y, value_slider)
	if voice_screen_component then
		if value_x and value_y then
			voice_screen_component:set_matrix_x_value(value_x)
			voice_screen_component:set_matrix_y_value(value_y)
		end

		if value_slider then
			voice_screen_component:set_slider_x_value(value_slider)
		end
	end
end

return CharacterAppearanceView
