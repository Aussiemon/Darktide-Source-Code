-- chunkname: @scripts/ui/view_elements/view_element_server_migration/view_element_server_migration.lua

local definition_path = "scripts/ui/view_elements/view_element_server_migration/view_element_server_migration_definitions"
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WalletSettings = require("scripts/settings/wallet_settings")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ViewElemenServerMigration = class("ViewElemenServerMigration", "ViewElementBase")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local TextUtils = require("scripts/utilities/ui/text")
local WorldRenderUtils = require("scripts/utilities/world_render")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local currency_order = {
	"credits",
	"marks",
	"plasteel",
	"diamantine",
	"aquilas"
}
local widget_passes = {
	title = {
		size = {
			nil,
			30
		},
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value_id = "text",
				style_id = "text",
				pass_type = "text",
				value = "",
				style = {
					font_size = 30,
					text_color = Color.terminal_text_header_selected(255, true)
				}
			}
		},
		init = function (widget, data)
			local content = widget.content

			content.text = data.display_name
		end
	},
	small_title = {
		size = {
			nil,
			24
		},
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value_id = "text",
				style_id = "text",
				pass_type = "text",
				value = "",
				style = {
					font_size = 24,
					text_color = Color.terminal_text_header(255, true)
				}
			}
		},
		init = function (widget, data)
			local content = widget.content

			content.text = data.display_name
		end
	},
	currency_text = {
		size = {
			nil,
			28
		},
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value_id = "currency",
				style_id = "currency",
				pass_type = "text",
				value = "",
				style = {
					font_size = 18,
					text_vertical_alignment = "center",
					text_color = Color.terminal_text_body(255, true)
				}
			},
			{
				value_id = "icon",
				pass_type = "texture",
				style_id = "icon",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					size = {
						40,
						28
					}
				},
				visibilty_function = function (parent, content)
					return not not content.icon
				end
			},
			{
				value_id = "value",
				style_id = "value",
				pass_type = "text",
				value = "",
				style = {
					font_size = 18,
					text_vertical_alignment = "center",
					text_horizontal_alignment = "right",
					text_color = Color.terminal_text_body(255, true),
					offset = {
						-50,
						0,
						0
					}
				}
			}
		},
		init = function (widget, data)
			local content = widget.content
			local wallet_data = WalletSettings[data.currency_type]

			content.currency = Localize(wallet_data.display_name)
			content.icon = wallet_data.icon_texture_small
			content.value = data.value
		end
	},
	large_spacing = {
		size = {
			nil,
			20
		}
	},
	spacing = {
		size = {
			nil,
			10
		}
	},
	image = {
		size = {
			nil,
			300
		},
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value_id = "texture",
				style_id = "texture",
				pass_type = "texture",
				value = "content/ui/materials/base/ui_default_base",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center"
				},
				visibilty_function = function (parent, content)
					return not not content.value_id
				end
			}
		},
		init = function (widget, data)
			widget.style.texture.material_values = {
				texture_map = data.texture
			}
		end
	},
	description = {
		size = {
			nil,
			70
		},
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				value_id = "description",
				style_id = "description",
				pass_type = "text",
				value = "",
				style = {
					font_size = 18,
					text_vertical_alignment = "top",
					text_color = Color.terminal_text_body(255, true)
				}
			}
		},
		init = function (widget, data)
			widget.content.description = data.text
		end
	}
}

ViewElemenServerMigration.init = function (self, parent, draw_layer, start_scale, context)
	local definitions = require(definition_path)

	ViewElemenServerMigration.super.init(self, parent, draw_layer, start_scale, definitions)

	self._context = context

	self:_create_offscreen_renderer()
	self:_create_default_gui()
	self:_create_background_gui()
	ButtonPassTemplates.terminal_button_hold_small.init(self, self._widgets_by_name.close_button, self._ui_default_renderer, {
		text = Localize("loc_popup_button_close"),
		complete_function = callback(self, "_close_button_pressed", self._widgets_by_name.close_button)
	})

	self._widgets_by_name.next_button.content.original_text = Localize("loc_next")
	self._widgets_by_name.next_button.content.visible = false
	self._widgets_by_name.close_button.content.visible = false
end

ViewElemenServerMigration._create_offscreen_renderer = function (self)
	local view_name = self.view_name
	local world_layer = 123
	local world_name = self.__class_name .. "_ui_server_migraton_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil, view_name)
	local viewport_name = "server_migraton_viewport"
	local viewport_type = "overlay_offscreen_3"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "server_migraton_renderer"

	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name
	}
end

ViewElemenServerMigration._create_default_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 122
	local world_name = class_name .. "_ui_default_world"
	local view_name = self.view_name

	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	self._world_name = world_name
	self._world_draw_layer = world_layer
	self._world_default_layer = world_layer

	local viewport_name = class_name .. "_ui_default_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_default_renderer = ui_manager:create_renderer(class_name .. "_ui_default_renderer", self._world)
end

ViewElemenServerMigration._create_background_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 121
	local world_name = class_name .. "_ui_background_world"
	local view_name = self.view_name

	self._background_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	self._background_world_name = world_name
	self._background_world_draw_layer = world_layer
	self._background_world_default_layer = world_layer

	local shading_environment = "content/shading_environments/ui/ui_popup_background"
	local shading_callback = callback(self, "cb_shading_callback")
	local viewport_name = class_name .. "_ui_background_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._background_viewport = ui_manager:create_viewport(self._background_world, viewport_name, viewport_type, viewport_layer, shading_environment, shading_callback)
	self._background_viewport_name = viewport_name
	self._ui_background_renderer = ui_manager:create_renderer(class_name .. "_ui_background_renderer", self._background_world)

	local max_value = 0.75

	WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, max_value)
end

ViewElemenServerMigration.cb_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
	local gamma = Application.user_setting("gamma") or 0

	ShadingEnvironment.set_scalar(shading_env, "exposure_compensation", ShadingEnvironment.scalar(shading_env, "exposure_compensation") + gamma)

	local blur_value = World.get_data(world, "fullscreen_blur") or 0

	if blur_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_amount", math.clamp(blur_value, 0, 1))
	else
		World.set_data(world, "fullscreen_blur", nil)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 0)
	end

	local greyscale_value = World.get_data(world, "greyscale") or 0

	if greyscale_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_amount", math.clamp(greyscale_value, 0, 1))
		ShadingEnvironment.set_vector3(shading_env, "grey_scale_weights", Vector3(0.33, 0.33, 0.33))
	else
		World.set_data(world, "greyscale", nil)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 0)
	end
end

ViewElemenServerMigration.change_page_presentation = function (self, index)
	local presentation_data = self._presentation_data

	self._use_offscreen = {}

	if self._grids then
		for i = 1, #self._grids do
			-- Nothing
		end

		self._grids = {}
		self._focused_grid = nil
	end

	if self._grid_widgets then
		for i = 1, #self._grid_widgets do
			local widget = self._grid_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._grid_widgets = {}
	end

	for i = 1, #presentation_data do
		for j = 1, #presentation_data[i] do
			local scrollbar_widget = presentation_data[i][j].scrollbar_widget

			scrollbar_widget.content.visible = false
		end
	end

	local widgets = {}
	local grids = {}
	local height_by_grid = {}

	for j = 1, #presentation_data[index] do
		local grid_data = presentation_data[index][j]
		local grid_direction = grid_data.grid_direction
		local grid_scenegraph_id = grid_data.grid_scenegraph_id
		local interaction_scenegraph_id = grid_data.interaction_scenegraph_id
		local scrollbar_widget = grid_data.scrollbar_widget
		local grid_content_scenegraph_id = grid_data.grid_content_scenegraph_id
		local grid_widgets = {}
		local grid_alignments = {}
		local grid_size = self._ui_scenegraph[grid_scenegraph_id].size
		local total_height = 0

		for i = 1, #grid_data.widgets do
			local widget_data = grid_data.widgets[i]
			local passes_data = widget_passes[widget_data.pass_template]
			local size = widget_data.data and widget_data.data.size or passes_data.size

			size[1] = size[1] or grid_size[1]
			size[2] = size[2] or grid_size[2]

			if not passes_data.passes then
				widgets[#widgets + 1] = nil
				grid_alignments[#grid_alignments + 1] = {
					size = {
						grid_size[1],
						size[2]
					}
				}
				total_height = total_height + size[2]
			else
				local passes = passes_data.passes
				local content_overrides = widget_data.data and widget_data.data.content_overrides or widget_data.content_overrides
				local style_overrides = widget_data.data and widget_data.data.style_overrides or widget_data.style_overrides
				local widget_definition = UIWidget.create_definition(passes, grid_content_scenegraph_id, content_overrides, size, style_overrides)
				local widget = self:_create_widget("migration_server_element_widget_" .. j .. "_" .. i, widget_definition)

				if passes_data.init then
					passes_data.init(widget, widget_data.data)
				end

				widget.content.grid_id = j
				widgets[#widgets + 1] = widget
				grid_widgets[#grid_widgets + 1] = widget
				grid_alignments[#grid_alignments + 1] = {
					horizontal_alignment = "center",
					name = "migration_server_element_widget_" .. j .. "_" .. i,
					size = {
						grid_size[1],
						size[2]
					}
				}
				total_height = total_height + size[2]
			end
		end

		local grid = UIWidgetGrid:new(grid_widgets, grid_alignments, self._ui_scenegraph, grid_scenegraph_id, grid_direction, {
			0,
			0
		})

		grid:assign_scrollbar(scrollbar_widget, grid_content_scenegraph_id, interaction_scenegraph_id)

		scrollbar_widget.content.visible = true

		grid:set_scrollbar_progress(0)

		local grid_max_size = 600
		local grid_size = math.min(total_height, grid_max_size)

		if grid_max_size < total_height then
			self._use_offscreen[j] = true
			grid_data.mask_widget.content.visible = true

			if not self._focused_grid then
				self._focused_grid = grid
			end
		else
			grid_data.mask_widget.content.visible = false
		end

		grids[#grids + 1] = grid
		height_by_grid[j] = grid_size

		self:_generate_slider_widget(index)
	end

	self._grid_widgets = widgets
	self._grids = grids

	if self._focused_grid then
		self._focused_grid:select_grid_index(1, 0, true)
	end

	self._widgets_by_name.title.content.title = presentation_data[index].display_name and Localize(presentation_data[index].display_name) or ""

	local added_height = 220
	local total_grid_height = 0
	local total_spacing_height = 0
	local spacing_by_row = {}
	local grid_placement = presentation_data[index].grid_placement
	local grid_spacing = presentation_data[index].grid_spacing
	local start_offset = -50
	local position_by_grid = {}

	if grid_placement then
		local grid_row_height = {}

		for i = 1, #grid_placement do
			local row = grid_placement[i]

			grid_row_height[i] = 0
			spacing_by_row[i] = 0

			for k = 1, #row do
				local id = row[k]
				local current_spacing = grid_spacing and grid_spacing[id] and grid_spacing[id][2] or 0

				grid_row_height[i] = math.max(grid_row_height[i], height_by_grid[id])
				spacing_by_row[i] = math.max(spacing_by_row[i], current_spacing)
			end
		end

		for i = 1, #grid_row_height do
			total_grid_height = total_grid_height + grid_row_height[i]
		end

		for i = 1, #grid_placement do
			local row = grid_placement[i]

			for k = 1, #row do
				local id = row[k]
				local grid_data = presentation_data[index][id]
				local grid_scenegraph_id = grid_data.grid_scenegraph_id
				local y_position = (grid_row_height[i - 1] or 0) + start_offset

				position_by_grid[id] = y_position
			end
		end
	else
		for i = 1, #height_by_grid do
			total_grid_height = total_grid_height + height_by_grid[i]
		end
	end

	for i = 1, #presentation_data[index] do
		local grid_data = presentation_data[index][i]
		local grid_scenegraph_id = grid_data.grid_scenegraph_id

		self:_set_scenegraph_size(grid_scenegraph_id, nil, height_by_grid[i])

		local spacing_value = grid_spacing and grid_spacing[i] and grid_spacing[i][2] or 0

		if grid_placement and grid_spacing then
			local row_id

			for j = 1, #grid_placement do
				local row = grid_placement[j]

				for k = 1, #row do
					local id = row[k]

					if id == i then
						row_id = j

						break
					end
				end

				if row_id then
					break
				end
			end

			if row_id then
				for j = 1, row_id - 1 do
					spacing_value = spacing_value + spacing_by_row[j]
				end
			end
		end

		local position = (position_by_grid[i] or 0) - total_grid_height * 0.5 + height_by_grid[i] * 0.5

		position = position + spacing_value

		self:_set_scenegraph_position(grid_scenegraph_id, nil, position)
	end

	for i = 1, #spacing_by_row do
		local spacing = spacing_by_row[i]

		total_spacing_height = total_spacing_height + spacing
	end

	local total_height = added_height + total_grid_height + total_spacing_height

	self._grid_height = total_height

	local button_size = self._ui_scenegraph.button_pivot.size
	local slider_margin = 10
	local height_edge_margin = 20
	local button_height_position = total_height * 0.5 - button_size[2] * 0.5 - height_edge_margin
	local slider_height_position = button_height_position - button_size[2] - slider_margin

	self:_set_scenegraph_position("slider_pivot", nil, slider_height_position)
	self:_set_scenegraph_position("button_pivot", nil, button_height_position)

	local title_size = self._ui_scenegraph.title_pivot.size

	self:_set_scenegraph_position("title_pivot", nil, -total_height * 0.5 + title_size[2] * 0.5 + height_edge_margin)
	self:_setup_presentation()
end

ViewElemenServerMigration._generate_slider_widget = function (self, current_index)
	local slide_selector = self._definitions.slide_selector

	if self._selection_widgets then
		for i = 1, #self._selection_widgets do
			local widget = self._selection_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._selection_widgets = {}
	end

	local total_offset_size = (slide_selector.size[1] + slide_selector.margin) * #self._presentation_data - slide_selector.margin * 2
	local widgets = {}

	for i = 1, #self._presentation_data do
		local widget_passes = slide_selector.pass_template_function(i, slide_selector)
		local widget_definition = UIWidget.create_definition(widget_passes, "slider_pivot", nil, slide_selector.size)
		local widget = self:_create_widget("selection_" .. i, widget_definition)

		slide_selector.init(self, widget, i)

		widget.content.hotspot.pressed_callback = function ()
			if current_index ~= i then
				self:change_page_presentation(i)
			end
		end

		local offset = (slide_selector.size[1] + slide_selector.margin) * (i - 1)

		widget.offset = {
			offset - total_offset_size * 0.5,
			0,
			200
		}
		widget.content.hotspot.is_selected = current_index == i
		widgets[#widgets + 1] = widget
	end

	if current_index < #self._presentation_data then
		self._widgets_by_name.next_button.content.hotspot.pressed_callback = function ()
			self:change_page_presentation(current_index + 1)
		end

		self._widgets_by_name.next_button.content.visible = true
		self._widgets_by_name.close_button.content.visible = false
	else
		self._widgets_by_name.next_button.content.visible = false
		self._widgets_by_name.close_button.content.visible = true
	end

	self:_on_navigation_input_changed()

	self._selection_widgets = widgets
end

ViewElemenServerMigration.present = function (self, migration_data)
	Managers.data_service.profiles:fetch_all_profiles():next(function (profile_data)
		local wallet_currencies = {}
		local wallet_by_order = {}
		local migration_by_character_id = {}
		local profiles = profile_data.profiles

		for i = 1, #profiles do
			local character_profile = profiles[i]
			local character_id = character_profile.character_id

			migration_by_character_id[character_id] = {
				character_profile.name
			}
		end

		for currency_type, data in pairs(WalletSettings) do
			if currency_type ~= "aquilas" then
				wallet_currencies[currency_type] = {
					[1] = 0
				}

				local order_id = table.find(currency_order, currency_type)

				if order_id ~= nil then
					wallet_by_order[order_id] = wallet_currencies[currency_type]
				end

				for character_id, _ in pairs(migration_by_character_id) do
					wallet_currencies[currency_type][character_id] = 0
					migration_by_character_id[character_id][currency_type] = 0
				end
			end
		end

		for i = 1, #migration_data.wallets do
			local wallet_data = migration_data.wallets[i]
			local currency_type = wallet_data.type
			local character_id = wallet_data.fromCharacterId
			local amount = wallet_data.amount

			if wallet_currencies[currency_type] and migration_by_character_id[character_id] then
				wallet_currencies[currency_type][1] = (wallet_currencies[currency_type][1] or 0) + amount
				wallet_currencies[currency_type][character_id] = (wallet_currencies[currency_type][character_id] or 0) + amount
				migration_by_character_id[character_id][currency_type] = (migration_by_character_id[character_id][currency_type] or 0) + amount
			end
		end

		local presentation_data = {
			{
				{
					grid_scenegraph_id = "change_info_grid",
					interaction_scenegraph_id = "change_info_grid_interaction",
					grid_content_scenegraph_id = "change_info_grid_content_pivot",
					grid_direction = "down",
					scrollbar_widget = self._widgets_by_name.change_info_grid_scrollbar,
					mask_widget = self._widgets_by_name.change_info_grid_mask,
					widgets = {
						{
							pass_template = "image",
							data = {
								texture = "content/ui/textures/images/wallet_merge",
								size = {
									300,
									300
								}
							}
						},
						{
							pass_template = "large_spacing"
						},
						{
							pass_template = "description",
							data = {
								text = Localize("loc_wallet_merge_desc"),
								size = {
									nil,
									100
								},
								style_overrides = {
									description = {
										text_horizontal_alignment = "center"
									}
								}
							}
						}
					}
				},
				display_name = "loc_wallet_merge_title"
			},
			{
				grid_placement = {
					{
						1,
						2
					},
					{
						3
					}
				},
				grid_spacing = {
					{
						0,
						20
					},
					{
						0,
						20
					},
					{
						0,
						20
					}
				},
				{
					grid_scenegraph_id = "wallet_grid_1",
					type = "total",
					interaction_scenegraph_id = "wallet_grid_1_interaction",
					grid_content_scenegraph_id = "wallet_grid_1_content_pivot",
					grid_direction = "down",
					scrollbar_widget = self._widgets_by_name.wallet_grid_1_scrollbar,
					mask_widget = self._widgets_by_name.wallet_grid_1_mask,
					widgets = {
						{
							pass_template = "title",
							data = {
								display_name = Localize("loc_wallet_merge_account_wallets")
							}
						}
					}
				},
				{
					grid_scenegraph_id = "wallet_grid_2",
					type = "character_id",
					interaction_scenegraph_id = "wallet_grid_2_interaction",
					grid_content_scenegraph_id = "wallet_grid_2_content_pivot",
					grid_direction = "down",
					scrollbar_widget = self._widgets_by_name.wallet_grid_2_scrollbar,
					mask_widget = self._widgets_by_name.wallet_grid_2_mask,
					widgets = {
						{
							pass_template = "title",
							data = {
								display_name = Localize("loc_wallet_merge_character_wallets")
							}
						}
					}
				},
				{
					grid_scenegraph_id = "wallet_grid_3",
					interaction_scenegraph_id = "wallet_grid_3_interaction",
					grid_content_scenegraph_id = "wallet_grid_3_content_pivot",
					grid_direction = "down",
					scrollbar_widget = self._widgets_by_name.wallet_grid_3_scrollbar,
					mask_widget = self._widgets_by_name.wallet_grid_3_mask,
					widgets = {
						{
							pass_template = "description",
							data = {
								text = Localize("loc_wallet_merge_receipt_desc"),
								style_overrides = {
									description = {
										text_horizontal_alignment = "center"
									}
								}
							}
						}
					}
				},
				display_name = "loc_wallet_merge_receipt_title"
			}
		}

		for i = 1, #presentation_data[2] do
			local data = presentation_data[2][i]
			local widgets = data.widgets

			if data.type == "total" then
				widgets[#widgets + 1] = {
					pass_template = "large_spacing"
				}
				widgets[#widgets + 1] = {
					pass_template = "small_title",
					data = {
						display_name = Localize("loc_wallet_merge_total")
					}
				}
				widgets[#widgets + 1] = {
					pass_template = "spacing"
				}

				for i = 1, #wallet_by_order do
					local currency_type = currency_order[i]
					local currency_data = wallet_by_order[i]

					widgets[#widgets + 1] = {
						pass_template = "currency_text",
						data = {
							currency_type = currency_type,
							value = TextUtils.format_currency(currency_data[1])
						}
					}
				end
			elseif data.type == "character_id" then
				for character_id, character_data in pairs(migration_by_character_id) do
					widgets[#widgets + 1] = {
						pass_template = "large_spacing"
					}
					widgets[#widgets + 1] = {
						pass_template = "small_title",
						data = {
							display_name = character_data[1]
						}
					}
					widgets[#widgets + 1] = {
						pass_template = "spacing"
					}

					for i = 1, #wallet_by_order do
						local currency_type = currency_order[i]
						local currency_data = wallet_by_order[i]

						widgets[#widgets + 1] = {
							pass_template = "currency_text",
							data = {
								currency_type = currency_type,
								value = TextUtils.format_currency(currency_data[character_id])
							}
						}
					end
				end
			end
		end

		self._presentation_data = presentation_data

		self:change_page_presentation(1)
	end)
end

ViewElemenServerMigration.update = function (self, dt, t, input_service)
	if self._on_enter_anim_id and self:_is_animation_completed(self._on_enter_anim_id) then
		self._on_enter_anim_id = nil
	end

	local grids = self._grids

	if grids then
		for i = 1, #grids do
			local grid = grids[i]

			grid:update(dt, t, input_service)
		end
	end

	if self._on_exit_anim_id and self:_is_animation_completed(self._on_exit_anim_id) then
		self._on_exit_anim_id = nil

		if self._context and self._context.on_destroy_callback then
			self._context.on_destroy_callback()
		end
	end

	self:_handle_input(input_service, dt, t)

	if self._widgets_by_name.close_button and self._ui_default_renderer then
		ButtonPassTemplates.terminal_button_hold_small.update(self, self._widgets_by_name.close_button, {
			input_service = input_service
		}, dt)
	end

	return ViewElemenServerMigration.super.update(self, dt, t, input_service)
end

ViewElemenServerMigration._handle_input = function (self, input_service, dt, t)
	if not Managers.ui:using_cursor_navigation() and self._widgets_by_name.next_button.content.visible == true and input_service:get("confirm_pressed") then
		self._widgets_by_name.next_button.content.hotspot.pressed_callback()
	end
end

ViewElemenServerMigration.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	local ui_renderer = self._ui_default_renderer
	local ui_scenegraph = self._ui_scenegraph
	local previous_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self._animated_alpha_multiplier or 1

	ViewElemenServerMigration.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	local widgets = self._selection_widgets

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local widgets = self._grid_widgets

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]

			if not self._use_offscreen[widget.content.grid_id] then
				UIWidget.draw(widget, ui_renderer)
			end
		end
	end

	UIRenderer.end_pass(ui_renderer)

	render_settings.alpha_multiplier = previous_alpha_multiplier

	if self._offscreen_renderer then
		UIRenderer.begin_pass(self._offscreen_renderer, ui_scenegraph, input_service, dt, render_settings)

		local widgets = self._grid_widgets

		if widgets then
			for i = 1, #widgets do
				local widget = widgets[i]

				if self._use_offscreen[widget.content.grid_id] then
					UIWidget.draw(widget, self._offscreen_renderer)
				end
			end
		end

		UIRenderer.end_pass(self._offscreen_renderer)
	end
end

ViewElemenServerMigration._setup_presentation = function (self)
	local height = self._grid_height
	local on_enter_animation_callback
	local additional_widgets = {
		unpack(self._grid_widgets),
		unpack(self._selection_widgets)
	}
	local params = {
		popup_height = height,
		additional_widgets = additional_widgets
	}

	self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, params, on_enter_animation_callback)

	local enter_popup_sound = UISoundEvents.system_popup_enter

	self:_play_sound(enter_popup_sound)
end

ViewElemenServerMigration._cleanup_presentation = function (self)
	if self._on_enter_anim_id then
		self:_stop_animation(self._on_enter_anim_id)

		self._on_enter_anim_id = nil
	end

	local height = self._grid_height
	local additional_widgets = {
		unpack(self._grid_widgets),
		unpack(self._selection_widgets)
	}
	local params = {
		popup_height = height,
		additional_widgets = additional_widgets
	}

	self._on_exit_anim_id = self:_start_animation("on_exit", self._widgets_by_name, params)

	self:_play_sound(UISoundEvents.system_popup_exit)
end

ViewElemenServerMigration._destroy_offscreen_renderer = function (self)
	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		world_data = nil
	end
end

ViewElemenServerMigration._destroy_background = function (self)
	if self._ui_background_renderer then
		self._ui_background_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_background_renderer")

		local world = self._background_world
		local viewport_name = self._background_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._background_viewport_name = nil
		self._background_world = nil
	end
end

ViewElemenServerMigration._destroy_default_gui = function (self)
	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_default_renderer")

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._viewport_name = nil
		self._world = nil
	end
end

ViewElemenServerMigration._on_navigation_input_changed = function (self)
	self._widgets_by_name.next_button.content.hotspot.is_selected = false
	self._widgets_by_name.close_button.content.hotspot.is_selected = false

	if not Managers.ui:using_cursor_navigation() then
		self._widgets_by_name.next_button.content.hotspot.is_selected = self._widgets_by_name.next_button.content.visible
		self._widgets_by_name.close_button.content.hotspot.is_selected = self._widgets_by_name.close_button.content.visible
	end
end

ViewElemenServerMigration._close_button_pressed = function (self)
	self:_cleanup_presentation()
end

ViewElemenServerMigration.destroy = function (self, ui_renderer)
	if self._offscreen_renderer then
		self:_destroy_offscreen_renderer()

		self._offscreen_renderer = nil
	end

	self:_destroy_background()
	ViewElemenServerMigration.super.destroy(self, self._ui_default_renderer)
	self:_destroy_default_gui()
end

return ViewElemenServerMigration
