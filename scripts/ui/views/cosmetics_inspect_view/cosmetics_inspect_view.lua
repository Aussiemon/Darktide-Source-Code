-- chunkname: @scripts/ui/views/cosmetics_inspect_view/cosmetics_inspect_view.lua

local Definitions = require("scripts/ui/views/cosmetics_inspect_view/cosmetics_inspect_view_definitions")
local CosmeticsInspectViewSettings = require("scripts/ui/views/cosmetics_inspect_view/cosmetics_inspect_view_settings")
local Items = require("scripts/utilities/items")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MasterItems = require("scripts/backend/master_items")
local Personalities = require("scripts/settings/character/personalities")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local VoiceFxPresetSettings = require("scripts/settings/dialogue/voice_fx_preset_settings")
local CosmeticsInspectView = class("CosmeticsInspectView", "BaseView")
local ANIMATION_SLOTS_MAP = {
	slot_animation_emote_1 = true,
	slot_animation_emote_2 = true,
	slot_animation_emote_3 = true,
	slot_animation_emote_4 = true,
	slot_animation_emote_5 = true,
	slot_animation_end_of_round = true,
}

CosmeticsInspectView.init = function (self, settings, context)
	self._context = context
	self._preview_player = context.preview_player or self:_player()

	local is_in_debug = context.debug
	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	if context.bundle then
		self._bundle_data = {
			image = context.bundle.image,
			title = context.bundle.title,
			description = context.bundle.description,
			type = context.bundle.type,
		}
	end

	self._zoom_level = 1
	self._zoom_speed = 0

	if not is_in_debug then
		local item = context.preview_item

		if item then
			if item.gear then
				item = MasterItems.create_preview_item_instance(item)
			else
				item = table.clone_instance(item)
			end
		end

		self._preview_item = item

		local use_store_appearance = context.use_store_appearance

		if use_store_appearance then
			self:_apply_store_appearance()
		else
			self:_apply_default_appearance()
		end

		self._disable_zoom = true

		if self._preview_item then
			self._initial_rotation = context.initial_rotation
			self._disable_rotation_input = context.disable_rotation_input
			self._animation_event_name_suffix = context.animation_event_name_suffix
			self._animation_event_variable_data = context.animation_event_variable_data
			self._companion_animation_event_name_suffix = context.companion_animation_event_name_suffix
			self._companion_animation_event_variable_data = context.companion_animation_event_variable_data
			self._disable_zoom = context.disable_zoom

			local profile = context.profile
			local gender_name = profile.gender
			local archetype = profile.archetype
			local archetype_name = archetype and archetype.name
			local breed_name = profile.archetype.breed
			local real_item = item.items and item.items[1] or item

			self._mannequin_profile = Items.create_mannequin_profile_by_item(real_item, gender_name, archetype_name, breed_name)

			local slots = self._preview_item and self._preview_item.slots
			local slot_name = context.slot_name or slots and slots[1]

			self._selected_slot = slot_name and ItemSlotSettings[slot_name]

			if not self._initial_rotation and slot_name == "slot_gear_extra_cosmetic" then
				self._initial_rotation = math.pi
			end

			local preview_with_gear = context.preview_with_gear
			local allow_preview = preview_with_gear and profile

			if allow_preview then
				self._preview_profile = profile

				local gear_profile = table.clone_instance(profile)

				gear_profile.character_id = "cosmetics_view_preview_character"
				self._gear_profile = gear_profile
			end

			local items = item.items
			local sub_item_count = items and #items or 0

			for i = 1, sub_item_count do
				local sub_item = items[i]
				local sub_slot_name = sub_item.slots[1]

				if sub_slot_name then
					self._mannequin_profile.loadout[sub_slot_name] = sub_item

					if allow_preview then
						self._gear_profile.loadout[sub_slot_name] = sub_item
					end
				end
			end

			if slot_name then
				self._mannequin_profile.loadout[slot_name] = item

				if allow_preview then
					self._gear_profile.loadout[slot_name] = item
				end
			end

			self._previewed_with_gear = false
			self._presentation_profile = self._mannequin_profile

			if item and item.item_type == "SET" then
				self._camera_focus_slot_name = "slot_gear_upperbody"
				self._zoom_level = 0
			end
		end
	end

	CosmeticsInspectView.super.init(self, Definitions, settings, context)

	self._pass_input = false
	self._pass_draw = false
	self._parent = context and context.parent
end

CosmeticsInspectView._setup_offscreen_gui = function (self)
	local ui_manager = Managers.ui
	local timer_name = "ui"
	local parent = self
	local view_name = parent.view_name
	local world_layer = 103
	local world_name = self._unique_id .. "_ui_offscreen_world"

	self._description_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = self._unique_id .. "_ui_offscreen_world_viewport"
	local viewport_type = "overlay_offscreen_2"
	local viewport_layer = 1

	self._description_viewport = ui_manager:create_viewport(self._description_world, viewport_name, viewport_type, viewport_layer)
	self._description_viewport_name = viewport_name
	self._ui_offscreen_renderer = ui_manager:create_renderer(self._unique_id .. "_ui_offscreen_renderer", self._description_world)
end

CosmeticsInspectView._destroy_offscreen_gui = function (self)
	if self._ui_offscreen_renderer then
		self._ui_offscreen_renderer = nil

		Managers.ui:destroy_renderer(self._unique_id .. "_ui_offscreen_renderer")

		local world = self._description_world
		local viewport_name = self._description_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._description_viewport_name = nil
		self._description_world = nil
	end
end

CosmeticsInspectView._apply_default_appearance = function (self)
	local scenegraph_definition = Definitions.scenegraph_definition

	scenegraph_definition.corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			180,
			310,
		},
		position = {
			0,
			0,
			62,
		},
	}
	scenegraph_definition.corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			180,
			310,
		},
		position = {
			0,
			0,
			62,
		},
	}
	scenegraph_definition.corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			180,
			120,
		},
		position = {
			0,
			0,
			62,
		},
	}
	scenegraph_definition.corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			180,
			120,
		},
		position = {
			0,
			0,
			62,
		},
	}
	scenegraph_definition.description_scrollbar = {
		horizontal_alignment = "right",
		parent = "description_grid",
		vertical_alignment = "top",
		size = {
			10,
			CosmeticsInspectViewSettings.grid_height - 40,
		},
		position = {
			30,
			-20,
			2,
		},
	}

	local widget_definitions = Definitions.widget_definitions

	widget_definitions.corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/metal_01_upper",
		},
	}, "corner_top_left")
	widget_definitions.corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/metal_01_upper",
			style = {
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
	}, "corner_top_right")
	widget_definitions.corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/metal_01_lower",
		},
	}, "corner_bottom_left")
	widget_definitions.corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/metal_01_lower",
			style = {
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
	}, "corner_bottom_right")
	widget_definitions.description_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.terminal_frame(255, true),
				size_addition = {
					20,
					30,
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
			value = "content/ui/materials/dividers/horizontal_frame_big_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				offset = {
					0,
					-18,
					3,
				},
				size = {
					nil,
					36,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				offset = {
					0,
					18,
					3,
				},
				size = {
					nil,
					36,
				},
			},
		},
	}, "left_side", {
		visible = false,
	})
end

CosmeticsInspectView._apply_store_appearance = function (self)
	local scenegraph_definition = Definitions.scenegraph_definition

	scenegraph_definition.corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			62,
		},
	}
	scenegraph_definition.corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			62,
		},
	}
	scenegraph_definition.corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			62,
		},
	}
	scenegraph_definition.corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			84,
			224,
		},
		position = {
			0,
			0,
			62,
		},
	}
	scenegraph_definition.description_scrollbar = {
		horizontal_alignment = "right",
		parent = "description_grid",
		vertical_alignment = "top",
		size = {
			10,
			CosmeticsInspectViewSettings.grid_height - 80,
		},
		position = {
			30,
			-20,
			2,
		},
	}

	local widget_definitions = Definitions.widget_definitions

	widget_definitions.corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_upper_left",
		},
	}, "corner_top_left")
	widget_definitions.corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/premium_upper_left",
			style = {
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
	}, "corner_top_right")
	widget_definitions.corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_lower_left",
		},
	}, "corner_bottom_left")
	widget_definitions.corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/premium_lower_right",
		},
	}, "corner_bottom_right")
	widget_definitions.description_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.terminal_frame(255, true),
				size_addition = {
					20,
					30,
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
			value = "content/ui/materials/frames/premium_store/details_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size_addition = {
					52,
					0,
				},
				offset = {
					0,
					-60,
					3,
				},
				size = {
					nil,
					80,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/premium_store/details_lower_basic",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size_addition = {
					52,
					0,
				},
				offset = {
					0,
					34,
					3,
				},
				size = {
					nil,
					108,
				},
			},
		},
	}, "left_side", {
		visible = false,
	})
end

CosmeticsInspectView.on_enter = function (self)
	CosmeticsInspectView.super.on_enter(self)
	self:_stop_previewing()
	self:_setup_input_legend()
	self:_setup_offscreen_gui()
	self:_setup_background_world()
	self:_start_preview_item()

	local context = self._context

	self._spawn_player = self._preview_item and not not context and not context.debug
end

CosmeticsInspectView._setup_input_legend = function (self)
	local context = self._context
	local use_store_appearance = context.use_store_appearance

	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 50)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local valid = true

		if legend_input.store_appearance_option and not use_store_appearance then
			valid = false
		end

		if valid then
			local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

			self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
		end
	end
end

CosmeticsInspectView._can_preview = function (self)
	local context = self._context

	return context and context.preview_with_gear
end

CosmeticsInspectView._stop_previewing = function (self)
	if self._weapon_preview then
		self._weapon_preview:stop_presenting()
	end

	if self._weapon_stats then
		self._weapon_stats:stop_presenting()
	end

	local visible = false

	self:_set_preview_widgets_visibility(visible)

	if self._context.prop_item then
		local item_slot = self._context.prop_item.slots[1]
		local presentation_profile = self._presentation_profile
		local presentation_loadout = presentation_profile.loadout

		presentation_loadout[item_slot] = nil
	end
end

CosmeticsInspectView._spawn_profile = function (self, profile, initial_rotation, disable_rotation_input)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()

	self._profile_spawner = UIProfileSpawner:new("CosmeticsInspectView", world, camera, unit_spawner)

	if disable_rotation_input then
		self._profile_spawner:disable_rotation_input()
	end

	local camera_position = ScriptCamera.position(camera)
	local spawn_position = Unit.world_position(self._spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(self._spawn_point_unit, 1)

	if initial_rotation then
		local character_initial_rotation = Quaternion.axis_angle(Vector3(0, 0, 1), initial_rotation)

		spawn_rotation = Quaternion.multiply(character_initial_rotation, spawn_rotation)
	end

	camera_position.z = 0

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation)

	self._spawned_profile = profile

	local selected_slot = self._selected_slot
	local selected_slot_name = selected_slot and selected_slot.name

	if selected_slot_name == "slot_companion_gear_full" then
		self._profile_spawner:toggle_character(false)
	elseif ANIMATION_SLOTS_MAP[selected_slot_name] then
		local companion_state_machine = self._context
		local item = self._preview_item
		local toggle_companion = item and item.companion_state_machine ~= nil and item.companion_state_machine ~= ""

		self._profile_spawner:toggle_companion(toggle_companion)
	else
		self._profile_spawner:toggle_companion(false)
	end
end

CosmeticsInspectView._setup_item_description = function (self, description_text, restriction_text, property_text)
	local widgets_by_name = self._widgets_by_name
	local description_background = widgets_by_name.description_background

	description_background.content.visible = false

	self:_destroy_description_grid()

	local any_text = description_text or restriction_text or property_text

	if not any_text then
		return
	end

	local widgets = {}
	local alignment_widgets = {}
	local scenegraph_id = "description_content_pivot"
	local max_width = self._ui_scenegraph.description_grid.size[1]

	local function _add_text_widget(pass_template, text)
		local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id, nil, {
			max_width,
			0,
		})
		local widget = self:_create_widget(string.format("description_grid_widget_%d", #widgets), widget_definition)

		widget.content.text = text

		local widget_text_style = widget.style.text
		local text_options = UIFonts.get_font_options_by_style(widget.style.text)
		local _, text_height = self:_text_size(text, widget_text_style.font_type, widget_text_style.font_size, {
			max_width,
			math.huge,
		}, text_options)

		widget.content.size[2] = text_height
		widgets[#widgets + 1] = widget
		alignment_widgets[#alignment_widgets + 1] = widget
	end

	local function _add_spacing(height)
		widgets[#widgets + 1] = nil
		alignment_widgets[#alignment_widgets + 1] = {
			size = {
				max_width,
				height,
			},
		}
	end

	local desired_spacing = 50

	if description_text then
		if #widgets > 0 then
			_add_spacing(desired_spacing)
		end

		_add_text_widget(Definitions.text_description_pass_template, description_text)

		desired_spacing = 80
	end

	if property_text then
		if #widgets > 0 then
			_add_spacing(desired_spacing)
		end

		_add_text_widget(Definitions.item_sub_title_pass, Utf8.upper(Localize("loc_item_property_header")))
		_add_spacing(10)
		_add_text_widget(Definitions.item_text_pass, property_text)

		desired_spacing = 50
	end

	if restriction_text then
		if #widgets > 0 then
			_add_spacing(desired_spacing)
		end

		_add_text_widget(Definitions.item_sub_title_pass, Utf8.upper(Localize("loc_item_equippable_on_header")))
		_add_spacing(10)
		_add_text_widget(Definitions.item_text_pass, restriction_text)
	end

	if #widgets > 0 then
		_add_spacing(10)
	end

	self._description_grid_widgets = widgets
	self._description_grid_alignment_widgets = alignment_widgets

	local grid_scenegraph_id = "description_grid"
	local grid_pivot_scenegraph_id = "description_content_pivot"
	local grid_spacing = {
		0,
		0,
	}
	local grid_direction = "down"
	local use_is_focused_for_navigation = true
	local grid = UIWidgetGrid:new(self._description_grid_widgets, self._description_grid_alignment_widgets, self._ui_scenegraph, grid_scenegraph_id, grid_direction, grid_spacing, nil, use_is_focused_for_navigation)

	self._description_grid = grid

	local scrollbar_widget = widgets_by_name.description_scrollbar

	grid:assign_scrollbar(scrollbar_widget, grid_pivot_scenegraph_id, grid_scenegraph_id)
	grid:set_scrollbar_progress(0)
	grid:set_scroll_step_length(100)

	description_background.content.visible = true
end

CosmeticsInspectView._destroy_description_grid = function (self)
	if self._description_grid then
		for i = 1, #self._description_grid_widgets do
			local widget = self._description_grid_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._description_grid = nil
		self._description_grid_widgets = nil
		self._description_grid_alignment_widgets = nil
	end
end

CosmeticsInspectView._start_preview_item = function (self)
	local item = self._preview_item

	self:_stop_previewing()

	if item then
		local item_display_name = item.display_name

		if string.match(item_display_name, "unarmed") then
			return
		end

		local item_name = item.name
		local selected_slot = self._selected_slot
		local selected_slot_name = selected_slot and selected_slot.name
		local presentation_profile = self._presentation_profile
		local presentation_loadout = presentation_profile.loadout

		if selected_slot_name then
			presentation_loadout[selected_slot_name] = item
		end

		local animation_slot = ANIMATION_SLOTS_MAP[selected_slot_name]

		if animation_slot then
			local context = self._context
			local state_machine = item.state_machine
			local item_animation_event = item.animation_event
			local item_face_animation_event = item.face_animation_event
			local animation_event_name_suffix = self._animation_event_name_suffix
			local companion_animation_event_name_suffix = self._companion_animation_event_name_suffix
			local companion_state_machine = item.companion_state_machine
			local companion_item_animation_event = item.companion_animation_event

			self._disable_zoom = true
			context.state_machine = context.state_machine or state_machine
			context.animation_event = context.animation_event or item_animation_event
			context.face_animation_event = self._previewed_with_gear and (context.face_animation_event or item_face_animation_event) or nil
			context.companion_state_machine = context.companion_state_machine or companion_state_machine
			context.companion_animation_event = context.companion_animation_event or item_animation_event

			local animation_event = item_animation_event

			if animation_event_name_suffix then
				animation_event = animation_event .. animation_event_name_suffix
			end

			local companion_animation_event = companion_item_animation_event

			if companion_animation_event_name_suffix then
				companion_animation_event = companion_animation_event .. companion_animation_event_name_suffix
			end

			if self._profile_spawner then
				self._profile_spawner:assign_state_machine(context.state_machine, context.item_animation_event, context.item_face_animation_event)

				if companion_state_machine and companion_state_machine ~= "" then
					self._profile_spawner:assign_companion_state_machine(context.companion_state_machine, context.companion_animation_event)
				end
			end

			local animation_event_variable_data = self._animation_event_variable_data

			if animation_event_variable_data and self._profile_spawner then
				local index = animation_event_variable_data.index
				local value = animation_event_variable_data.value

				if self._profile_spawner then
					self._profile_spawner:assign_animation_variable(index, value)
				end
			end

			local companion_animation_event_variable_data = self._companion_animation_event_variable_data

			if companion_animation_event_variable_data and self._profile_spawner then
				local index = companion_animation_event_variable_data.index
				local value = companion_animation_event_variable_data.value

				if self._profile_spawner then
					self._profile_spawner:assign_companion_animation_variable(index, value)
				end
			end

			local prop_item_key = item.prop_item
			local prop_item = prop_item_key and prop_item_key ~= "" and MasterItems.get_item(prop_item_key)

			context.prop_item = context.prop_item or prop_item

			if context.prop_item then
				local prop_item_slot = context.prop_item.slots[1]

				presentation_loadout[prop_item_slot] = context.prop_item

				if self._profile_spawner then
					self._profile_spawner:wield_slot(prop_item_slot)
				end
			end
		elseif selected_slot_name == "slot_companion_gear_full" then
			self._disable_zoom = true
		end

		self:_set_preview_widgets_visibility(true)

		local property_text = Items.item_property_text(item, true)
		local restriction_text, present_restriction_text = Items.restriction_text(item)

		if not present_restriction_text then
			restriction_text = nil
		end

		local description = item.description and Localize(item.description)

		self:_setup_title(item)
		self:_setup_item_description(description, restriction_text, property_text)
	elseif self._bundle_data then
		local description = self._bundle_data.description or ""

		self:_setup_item_description(description)

		local texture_data = self._bundle_data.image

		if texture_data then
			local url = texture_data.url

			self._image_url = url

			Managers.url_loader:load_texture(url)

			self._widgets_by_name.bundle_background.style.bundle.material_values.texture_map = texture_data.texture
		end

		local title_item_data = {
			item_type = Localize(UISettings.item_type_localization_lookup[Utf8.upper(self._bundle_data.type)]),
			display_name = self._bundle_data.title,
		}

		self:_setup_title(title_item_data, true)
		self:_set_preview_widgets_visibility(true)
	end
end

CosmeticsInspectView._set_preview_widgets_visibility = function (self, visible)
	return
end

CosmeticsInspectView._setup_title = function (self, item, ignore_localization)
	self._widgets_by_name.title.content.text = ignore_localization and item.display_name or Localize(item.display_name) or ""

	local item_type = ignore_localization and item.item_type or Items.type_display_name(item)
	local sub_text = item_type

	if item.rarity then
		local rarity_color, rarity_color_dark = Items.rarity_color(item)
		local rarity_display_name = Items.rarity_display_name(item)

		sub_text = string.format("{#color(%d, %d, %d)}%s{#reset()} • %s", rarity_color[2], rarity_color[3], rarity_color[4], rarity_display_name, item_type)
	end

	self._widgets_by_name.title.content.sub_text = sub_text

	local title_style = self._widgets_by_name.title.style.text
	local sub_title_style = self._widgets_by_name.title.style.sub_text
	local title_options = UIFonts.get_font_options_by_style(title_style)
	local sub_title_options = UIFonts.get_font_options_by_style(sub_title_style)
	local max_width = self._ui_scenegraph.title.size[1]

	if self._context.use_store_appearance then
		title_style.material = "content/ui/materials/font_gradients/slug_font_gradient_gold"
	else
		title_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
	end

	local title_width, title_height = self:_text_size(self._widgets_by_name.title.content.text, title_style.font_type, title_style.font_size, {
		max_width,
		math.huge,
	}, title_options)
	local sub_title_width, sub_title_height = self:_text_size(self._widgets_by_name.title.content.sub_text, sub_title_style.font_type, sub_title_style.font_size, {
		max_width,
		math.huge,
	}, sub_title_options)
	local sub_title_margin = 10

	sub_title_style.offset[2] = sub_title_margin + title_height

	local title_total_size = sub_title_style.offset[2] + sub_title_height + self._widgets_by_name.title.style.divider.size[2] + sub_title_margin
	local title_scenegraph_position = self._ui_scenegraph.title.position
	local margin = 15
	local max_height = self._ui_scenegraph.left_side.size[2] - 40
	local grid_height = max_height - (title_scenegraph_position[2] + title_total_size + margin)

	self:_set_scenegraph_size("title", nil, title_total_size)

	grid_height = grid_height - margin

	local mask_oversize = 10
	local start_description_position = title_scenegraph_position[2] + title_total_size + margin

	self:_set_scenegraph_position("description_grid", nil, start_description_position)
	self:_set_scenegraph_size("description_grid", nil, grid_height)
	self:_set_scenegraph_size("description_mask", nil, grid_height + mask_oversize)
	self:_set_scenegraph_size("description_scrollbar", nil, grid_height)
end

CosmeticsInspectView.cb_on_weapon_swap_pressed = function (self)
	local wield_slot = self._wielded_slot

	wield_slot = wield_slot == "slot_primary" and "slot_secondary" or "slot_primary"

	self:_play_sound(UISoundEvents.weapons_swap)

	self._wielded_slot = wield_slot

	self:_update_presentation_wield_item()
end

CosmeticsInspectView._has_wielded_slot = function (self)
	return self._wielded_slot ~= nil
end

CosmeticsInspectView._can_swap_weapon = function (self)
	return false
end

CosmeticsInspectView._update_presentation_wield_item = function (self)
	if not self._profile_spawner then
		return
	end

	local wield_slot = self._wielded_slot
	local presentation_profile = self._presentation_profile
	local loadout = presentation_profile.loadout
	local slot_item = loadout[wield_slot]

	self._profile_spawner:wield_slot(wield_slot)

	local item_inventory_animation_event = slot_item and slot_item.inventory_animation_event or "inventory_idle_default"

	if item_inventory_animation_event then
		self._profile_spawner:assign_animation_event(item_inventory_animation_event)
	end
end

CosmeticsInspectView.cb_on_preview_with_gear_toggled = function (self, id, input_pressed, instant)
	self._previewed_with_gear = not self._previewed_with_gear
	self._presentation_profile = self._previewed_with_gear and self._gear_profile or self._mannequin_profile
	self._spawn_player = true

	self:_play_sound(UISoundEvents.cosmetics_vendor_show_with_gear)
end

CosmeticsInspectView._stop_current_voice = function (self)
	local ui_world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(ui_world)

	if not wwise_world then
		return
	end

	local current_event = self._sound_event_id

	if not current_event then
		return
	end

	if not WwiseWorld.is_playing(wwise_world, current_event) then
		return
	end

	WwiseWorld.stop_event(wwise_world, current_event)

	self._sound_event_id = nil
end

CosmeticsInspectView.cb_preview_voice = function (self)
	local voice_fx_preset_key = table.nested_get(self, "_preview_item", "voice_fx_preset")
	local voice_fx_preset_rtcp = VoiceFxPresetSettings[voice_fx_preset_key]

	if not voice_fx_preset_key then
		return
	end

	local personality_key = table.nested_get(self, "_preview_profile", "lore", "backstory", "personality")
	local personality_settings = Personalities[personality_key]
	local sound_event = personality_settings and personality_settings.preview_sound_event

	if not sound_event then
		return
	end

	local ui_world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(ui_world)

	if not wwise_world then
		return
	end

	self:_stop_current_voice()

	local source = WwiseWorld.make_auto_source(wwise_world, Vector3.zero())

	WwiseWorld.set_source_parameter(wwise_world, source, "voice_fx_preset", voice_fx_preset_rtcp)

	self._sound_event_id = WwiseWorld.trigger_resource_event(wwise_world, sound_event, source)
end

CosmeticsInspectView._can_preview_voice = function (self)
	local has_profile = self._preview_profile and self._previewed_with_gear
	local has_voice_fx = self._preview_item and self._preview_item.voice_fx_preset ~= nil and self._preview_item.voice_fx_preset ~= "voice_fx_rtpc_none"

	return has_profile and has_voice_fx
end

CosmeticsInspectView._trigger_zoom_logic = function (self, optional_slot_name, optional_time)
	local selected_slot = self._selected_slot
	local selected_slot_name = optional_slot_name or selected_slot and selected_slot.name
	local func_ptr = math.easeCubic

	self:_set_camera_item_slot_focus(selected_slot_name, optional_time or 0, func_ptr, self._zoom_level)
end

CosmeticsInspectView.on_exit = function (self)
	self:_stop_current_voice()

	if self._world_spawner then
		self._world_spawner:set_camera_blur(0, 0)
	end

	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	self:_destroy_offscreen_gui()

	local image_url = self._image_url

	if image_url then
		Managers.url_loader:unload_texture(image_url)
	end

	CosmeticsInspectView.super.on_exit(self)
end

CosmeticsInspectView._handle_back_pressed = function (self)
	local view_name = "cosmetics_inspect_view"

	Managers.ui:close_view(view_name)
end

CosmeticsInspectView.cb_on_close_pressed = function (self)
	self:_handle_back_pressed()
end

CosmeticsInspectView._update_zoom_logic = function (self, dt, input_service)
	if self._disable_zoom then
		return
	end

	local scroll_axis = input_service:get("scroll_axis")
	local scroll_delta = scroll_axis and scroll_axis[2] or 0
	local scroll_content = self._widgets_by_name.description_scrollbar.content

	if scroll_content.in_scroll_area then
		scroll_delta = 0
	end

	local zoom_speed, zoom_level = self._zoom_speed, self._zoom_level

	zoom_speed = scroll_delta * zoom_speed < 0 and 0 or zoom_speed + scroll_delta / 20

	if math.abs(zoom_speed) < 0.01 then
		zoom_speed = 0
	end

	zoom_level = math.clamp(zoom_level + zoom_speed * 18 * dt, 0, 1)
	zoom_speed = zoom_speed * math.pow(0.006, dt)

	if zoom_level == 0 or zoom_level == 1 then
		zoom_speed = 0
	end

	local has_changed = zoom_level ~= self._zoom_level

	self._zoom_level, self._zoom_speed = zoom_level, zoom_speed

	if has_changed then
		self:_trigger_zoom_logic()
	end
end

CosmeticsInspectView.update = function (self, dt, t, input_service)
	if self._spawn_player and self._spawn_point_unit and self._default_camera_unit then
		local context = self._context
		local profile = self._presentation_profile
		local initial_rotation = self._initial_rotation
		local disable_rotation_input = self._disable_rotation_input

		self:_spawn_profile(profile, initial_rotation, disable_rotation_input)

		self._spawn_player = false

		local wield_slot = context.prop_item and context.prop_item.slots and context.prop_item.slots[1] or context.wield_slot

		if wield_slot then
			self._wielded_slot = wield_slot

			if context.prop_item then
				profile.loadout[wield_slot] = context.prop_item
			end

			self._profile_spawner:wield_slot(wield_slot)
		end

		local state_machine = context.state_machine

		if state_machine then
			local animation_event = context.animation_event
			local face_animation_event = context.face_animation_event

			self._profile_spawner:assign_state_machine(state_machine, animation_event, face_animation_event)
		end

		local companion_state_machine = context.companion_state_machine

		if companion_state_machine and companion_state_machine ~= "" then
			local companion_animation_event = context.companion_animation_event

			self._profile_spawner:assign_companion_state_machine(companion_state_machine, companion_animation_event)
		end

		local animation_event_variable_data = self._animation_event_variable_data

		if animation_event_variable_data and self._profile_spawner then
			local index = animation_event_variable_data.index
			local value = animation_event_variable_data.value

			self._profile_spawner:assign_animation_variable(index, value)
		end

		self:_trigger_zoom_logic()
	end

	self:_update_zoom_logic(dt, input_service)

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t, input_service)
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	return CosmeticsInspectView.super.update(self, dt, t, input_service)
end

CosmeticsInspectView._draw_description_grid = function (self, dt, t, input_service)
	local description_grid = self._description_grid

	if not description_grid then
		return
	end

	local widgets = self._description_grid_widgets
	local render_settings = self._render_settings
	local ui_renderer = self._ui_offscreen_renderer
	local ui_scenegraph = self._ui_scenegraph

	self._description_grid:update(dt, t, input_service)
	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for i = 1, #widgets do
		local widget = widgets[i]

		if description_grid:is_widget_visible(widget) then
			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

CosmeticsInspectView.draw = function (self, dt, t, input_service, layer)
	self:_draw_description_grid(dt, t, input_service)
	CosmeticsInspectView.super.draw(self, dt, t, input_service, layer)
end

CosmeticsInspectView._get_weapon_spawn_position_normalized = function (self)
	self:_force_update_scenegraph()

	local scale
	local pivot_world_position = self:_scenegraph_world_position("weapon_pivot", scale)
	local parent_world_position = self:_scenegraph_world_position("weapon_viewport", scale)
	local viewport_width, viewport_height = self:_scenegraph_size("weapon_viewport", scale)
	local scale_x = (pivot_world_position[1] - parent_world_position[1]) / viewport_width
	local scale_y = 1 - (pivot_world_position[2] - parent_world_position[2]) / viewport_height

	return scale_x, scale_y
end

CosmeticsInspectView.on_resolution_modified = function (self, scale)
	CosmeticsInspectView.super.on_resolution_modified(self, scale)
end

CosmeticsInspectView._setup_background_world = function (self)
	local profile = self._preview_profile or self._mannequin_profile
	local archetype = profile and profile.archetype
	local breed_name = profile and archetype.breed or "human"
	local default_camera_event_id = "event_register_cosmetics_preview_default_camera_" .. breed_name

	self[default_camera_event_id] = function (instance, camera_unit)
		if instance._context then
			instance._context.camera_unit = camera_unit
		end

		instance._default_camera_unit = camera_unit

		local viewport_name = CosmeticsInspectViewSettings.viewport_name
		local viewport_type = CosmeticsInspectViewSettings.viewport_type
		local viewport_layer = CosmeticsInspectViewSettings.viewport_layer
		local shading_environment = CosmeticsInspectViewSettings.shading_environment

		instance._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
		instance:_unregister_event(default_camera_event_id)
	end

	self:_register_event(default_camera_event_id)

	self._item_camera_by_slot_id = {}

	for slot_name, slot in pairs(ItemSlotSettings) do
		if slot.slot_type == "gear" then
			local item_camera_event_id = "event_register_cosmetics_preview_item_camera_" .. breed_name .. "_" .. slot_name

			self[item_camera_event_id] = function (instance, camera_unit)
				instance._item_camera_by_slot_id[slot_name] = camera_unit

				instance:_unregister_event(item_camera_event_id)
			end

			self:_register_event(item_camera_event_id)
		end
	end

	self:_register_event("event_register_cosmetics_preview_character_spawn_point")

	local world_name = CosmeticsInspectViewSettings.world_name
	local world_layer = CosmeticsInspectViewSettings.world_layer
	local world_timer_name = CosmeticsInspectViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	local level_name = CosmeticsInspectViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

CosmeticsInspectView.world_spawner = function (self)
	return self._world_spawner
end

CosmeticsInspectView.spawn_point_unit = function (self)
	return self._spawn_point_unit
end

CosmeticsInspectView.cb_on_camera_zoom_toggled = function (self)
	self._zoom_level = self._zoom_level > 0.5 and 0 or 1
	self._zoom_speed = 0

	self:_trigger_zoom_logic(nil, 0.5)
end

CosmeticsInspectView.event_register_cosmetics_preview_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_cosmetics_preview_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	if self._context then
		self._context.spawn_point_unit = spawn_point_unit
	end
end

CosmeticsInspectView._set_camera_item_slot_focus = function (self, slot_name, time, func_ptr, zoom_percentage)
	local world_spawner = self._world_spawner
	local slot_camera = self._item_camera_by_slot_id[slot_name] or self._default_camera_unit

	world_spawner:interpolate_to_camera(slot_camera, zoom_percentage, time, func_ptr)
end

return CosmeticsInspectView
