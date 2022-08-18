local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local GuiMaterialFlag = GuiMaterialFlag
local UIRenderer = {}
local dummy_text_options = {}
local slug_render_params = {}
local gui_args = {}

for i = 1, 20, 1 do
	gui_args[i] = true
end

local SNAP_PIXEL_POSITIONS = false
local STRING_IDENTIFIER = "string"
UIRenderer.TARGET_TYPES = table.enum("WorldViewport", "LDR", "HDR", "LDRHDR")

local function _snap_to_position(position, scale)
	if scale >= 1 then
		position[1] = math.round(position[1])
		position[2] = math.round(position[2])
	end

	return position
end

local function _get_material_flag(render_settings, material_flags, render_pass_flag)
	if render_settings then
		if render_settings.mask then
			material_flags = (material_flags and material_flags + GuiMaterialFlag.GUI_MASK_LAYER) or GuiMaterialFlag.GUI_MASK_LAYER
		end

		if render_settings.mask_alpha then
			material_flags = (material_flags and material_flags + GuiMaterialFlag.WRITE_ALPHA) or GuiMaterialFlag.WRITE_ALPHA
		end

		if render_settings.mask_red then
			material_flags = (material_flags and material_flags + GuiMaterialFlag.WRITE_RED) or GuiMaterialFlag.WRITE_RED
		end

		if render_settings.mask_blue then
			material_flags = (material_flags and material_flags + GuiMaterialFlag.WRITE_BLUE) or GuiMaterialFlag.WRITE_BLUE
		end

		if render_settings.mask_green then
			material_flags = (material_flags and material_flags + GuiMaterialFlag.WRITE_GREEN) or GuiMaterialFlag.WRITE_GREEN
		end

		if render_settings.hdr then
			material_flags = (material_flags and material_flags + GuiMaterialFlag.GUI_HDR_LAYER) or GuiMaterialFlag.GUI_HDR_LAYER
		end
	end

	if render_pass_flag then
		material_flags = (material_flags and material_flags + GuiMaterialFlag.GUI_RENDER_PASS_LAYER) or GuiMaterialFlag.GUI_RENDER_PASS_LAYER
	end

	return material_flags
end

UIRenderer.add_resource_generator = function (ui_renderer, sort_key, name, ...)
	local gui = ui_renderer.gui

	Gui.resource_generator(gui, sort_key, name, ...)

	if not ui_renderer.retained_resource_generators[name] then
		local gui_retained = ui_renderer.gui_retained

		Gui.resource_generator(gui_retained, sort_key, name, ...)

		ui_renderer.retained_resource_generators[name] = {
			sort_key = sort_key,
			render_targets = {
				...
			}
		}
	end
end

UIRenderer.add_render_pass = function (ui_renderer, sort_key, name, clear, ...)
	local gui = ui_renderer.gui

	Gui.render_pass(gui, sort_key, name, clear, ...)

	if not ui_renderer.retained_render_passes[name] then
		local gui_retained = ui_renderer.gui_retained

		Gui.render_pass(gui_retained, sort_key, name, clear, ...)

		ui_renderer.retained_render_passes[name] = {
			sort_key = sort_key,
			render_targets = {
				...
			},
			clear = clear
		}
	end
end

UIRenderer.create_viewport_renderer = function (world, ...)
	local gui_retained = World.create_screen_gui(world, ...)
	local gui = World.create_screen_gui(world, "immediate", ...)

	return UIRenderer.create_ui_renderer(world, gui, gui_retained)
end

UIRenderer.create_resource_renderer = function (world, gui, gui_retained, reference_name, material_name, ...)
	local render_target = Renderer.create_resource("render_target", "R8G8B8A8", "back_buffer", 1, 1, reference_name)
	local render_target_material = Gui.create_material(gui, material_name, GuiMaterialFlag.GUI_RENDER_PASS_LAYER)

	Material.set_resource(render_target_material, "source", render_target)

	return UIRenderer.create_ui_renderer(world, gui, gui_retained, reference_name, render_target, render_target_material)
end

UIRenderer.create_ui_renderer = function (world, gui, gui_retained, name, render_target, render_target_material)
	return table.make_strict_nil_exceptions({
		alpha_multiplier = 1,
		dt = 0,
		gui = gui,
		gui_retained = gui_retained,
		ui_scenegraph = StrictNil,
		ui_scenegraph_queue = {},
		input_service = StrictNil,
		scale = StrictNil,
		inverse_scale = StrictNil,
		video_players = {},
		world = world,
		wwise_world = Managers.world:wwise_world(world),
		name = name,
		render_pass_flag = (render_target and "render_pass") or StrictNil,
		base_render_pass = (render_target and name) or StrictNil,
		render_target = render_target or StrictNil,
		render_target_material = render_target_material,
		current_clipping_rect = StrictNil,
		debug_startpoint_direction = StrictNil,
		debug_startpoint = StrictNil,
		render_settings = StrictNil,
		retained_render_passes = {},
		retained_resource_generators = {}
	})
end

UIRenderer.destroy = function (self, world)
	local video_players = self.video_players

	for reference_name, video_player in pairs(video_players) do
		World.destroy_video_player(world or self.world, video_player)

		video_players[reference_name] = nil
	end

	if self.gui == self.gui_retained then
		self.gui_retained = nil
	end

	if self.render_target then
		Renderer.destroy_resource(self.render_target)
	else
		World.destroy_gui(world or self.world, self.gui)

		if self.gui_retained then
			World.destroy_gui(world or self.world, self.gui_retained)
		end
	end
end

UIRenderer.create_material = function (self, material_name, retained_mode)
	local gui = (retained_mode and self.gui_retained) or self.gui
	local render_settings = self.render_settings
	local material_flags = _get_material_flag(render_settings, nil, self.render_pass_flag)
	local material = nil

	if material_flags then
		material = Gui.create_material(gui, material_name, material_flags)
	else
		material = Gui.create_material(gui, material_name)
	end

	return material
end

UIRenderer.destroy_material = function (self, material, retained_mode)
	local gui = (retained_mode and self.gui_retained) or self.gui

	Gui.destroy_material(gui, material)
end

UIRenderer.material = function (self, material_name, retained_mode)
	local gui = (retained_mode and self.gui_retained) or self.gui
	local render_settings = self.render_settings
	local material_flags = _get_material_flag(render_settings, nil, self.render_pass_flag)

	if material_flags then
		return Gui.material(gui, material_name, material_flags)
	else
		return Gui.material(gui, material_name)
	end
end

local Color = Color
local Vector2 = Vector2
local Vector3 = Vector3
local Gui_slug_text = Gui.slug_text
local Gui_update_slug_text = Gui.update_slug_text
local Gui_slug_text_3d = Gui.slug_text_3d
local Gui_update_slug_text_3d = Gui.update_slug_text_3d
local Gui_slug_icon = Gui.slug_icon
local Gui_update_slug_icon = Gui.update_slug_icon
local Gui_slug_icon_3d = Gui.slug_icon_3d
local Gui_update_slug_icon_3d = Gui.update_slug_icon_3d
local Gui_slug_picture = Gui.slug_picture
local Gui_update_slug_picture = Gui.update_slug_picture
local Gui_rect = Gui.rect
local Gui_update_rect = Gui.update_rect
local Gui_triangle = Gui.triangle
local Gui_update_triangle = Gui.update_triangle
local Gui_bitmap = Gui.bitmap
local Gui_update_bitmap = Gui.update_bitmap
local Gui_bitmap_uv = Gui.bitmap_uv
local Gui_update_bitmap_uv = Gui.update_bitmap_uv
local Gui_bitmap_3d = Gui.bitmap_3d
local Gui_update_bitmap_3d = Gui.update_bitmap_3d
local Gui_bitmap_3d_uv = Gui.bitmap_3d_uv
local Gui_update_bitmap_3d_uv = Gui.update_bitmap_3d_uv

UIRenderer.script_draw_bitmap = function (self, material, gui_position, gui_size, color, retained_id)
	local render_settings = self.render_settings
	local retained_mode = not not retained_id

	if retained_id == true then
		retained_id = nil
	end

	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = color and Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	local snap_pixel_positions = render_settings and render_settings.snap_pixel_positions

	if snap_pixel_positions == nil then
		snap_pixel_positions = SNAP_PIXEL_POSITIONS
	end

	if snap_pixel_positions then
		local scale = self.scale
		gui_position = _snap_to_position(gui_position, scale)
	end

	if render_settings then
		gui_position[3] = (render_settings.start_layer or 0) + gui_position[3]
	end

	local material_flags = type(material) == STRING_IDENTIFIER and _get_material_flag(render_settings, nil, self.render_pass_flag)
	local render_pass = self.base_render_pass

	if render_pass and render_settings.hdr then
		render_pass = render_pass .. "_hdr"
	end

	local gui = (retained_mode and self.gui_retained) or self.gui
	local gui_func = (retained_id and Gui_update_bitmap) or Gui_bitmap

	table.clear_array(gui_args, 20)

	gui_args[9] = color
	gui_args[8] = gui_size
	gui_args[7] = gui_position
	gui_args[6] = render_pass
	gui_args[5] = self.render_pass_flag
	gui_args[4] = material_flags
	gui_args[3] = material
	gui_args[2] = retained_id
	gui_args[1] = gui

	table.compact_array(gui_args)

	local id = gui_func(unpack(gui_args))

	return (retained_mode and id) or nil
end

UIRenderer.script_draw_bitmap_uv = function (self, material, uvs, gui_position, gui_size, color, retained_id)
	local render_settings = self.render_settings
	local retained_mode = not not retained_id

	if retained_id == true then
		retained_id = nil
	end

	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = color and Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	local snap_pixel_positions = render_settings and render_settings.snap_pixel_positions

	if snap_pixel_positions == nil then
		snap_pixel_positions = SNAP_PIXEL_POSITIONS
	end

	if snap_pixel_positions then
		local scale = self.scale
		gui_position = _snap_to_position(gui_position, scale)
	end

	if render_settings then
		gui_position[3] = (render_settings.start_layer or 0) + gui_position[3]
	end

	local material_flags = type(material) == STRING_IDENTIFIER and _get_material_flag(render_settings, nil, self.render_pass_flag)
	local uv00 = uvs[1]
	local uv11 = uvs[2]
	local render_pass = self.base_render_pass

	if render_pass and render_settings.hdr then
		render_pass = render_pass .. "_hdr"
	end

	local gui = (retained_mode and self.gui_retained) or self.gui
	local gui_func = (retained_id and Gui_update_bitmap_uv) or Gui_bitmap_uv

	table.clear_array(gui_args, 20)

	gui_args[11] = color
	gui_args[10] = gui_size
	gui_args[9] = gui_position
	gui_args[8] = render_pass
	gui_args[7] = self.render_pass_flag
	gui_args[6] = Vector2(uv11[1], uv11[2])
	gui_args[5] = Vector2(uv00[1], uv00[2])
	gui_args[4] = material_flags
	gui_args[3] = material
	gui_args[2] = retained_id
	gui_args[1] = gui

	table.compact_array(gui_args)

	local id = gui_func(unpack(gui_args))

	return (retained_mode and id) or nil
end

UIRenderer.script_draw_bitmap_3d = function (self, material, tm, gui_position, gui_layer, gui_size, color, optional_uvs, retained_id)
	local render_settings = self.render_settings
	local retained_mode = not not retained_id

	if retained_id == true then
		retained_id = nil
	end

	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = color and Color(color[1] * alpha_multiplier, color[2], color[3], color[4])

	if render_settings then
		gui_layer = (render_settings.start_layer or 0) + gui_layer
	end

	local snap_pixel_positions = render_settings and render_settings.snap_pixel_positions

	if snap_pixel_positions == nil then
		snap_pixel_positions = SNAP_PIXEL_POSITIONS
	end

	if snap_pixel_positions then
		local scale = self.scale
		local translation = Matrix4x4.translation(tm)
		translation = _snap_to_position(translation, scale)

		Matrix4x4.set_translation(tm, translation)
	end

	local material_flags = type(material) == STRING_IDENTIFIER and _get_material_flag(render_settings, nil, self.render_pass_flag)
	gui_position = gui_position or Vector3.zero()
	local uv00, uv11, gui_func = nil

	if optional_uvs then
		local new_uvs1 = optional_uvs[1]
		local new_uvs2 = optional_uvs[2]
		uv00 = Vector2(new_uvs1[1], new_uvs1[2])
		uv11 = Vector2(new_uvs2[1], new_uvs2[2])
		gui_func = (retained_id and Gui_update_bitmap_3d_uv) or Gui_bitmap_3d_uv
	else
		gui_func = (retained_id and Gui_update_bitmap_3d) or Gui_bitmap_3d
	end

	local render_pass = self.base_render_pass

	if render_pass and render_settings.hdr then
		render_pass = render_pass .. "_hdr"
	end

	local gui = (retained_mode and self.gui_retained) or self.gui

	table.clear_array(gui_args, 20)

	gui_args[13] = color
	gui_args[12] = gui_size
	gui_args[11] = gui_layer
	gui_args[10] = gui_position
	gui_args[9] = tm
	gui_args[8] = render_pass
	gui_args[7] = self.render_pass_flag
	gui_args[6] = optional_uvs and Vector2(uv11[1], uv11[2])
	gui_args[5] = (optional_uvs and Vector2(uv00[1], uv00[2])) or nil
	gui_args[4] = material_flags
	gui_args[3] = material
	gui_args[2] = retained_id
	gui_args[1] = gui

	table.compact_array(gui_args)

	local id = gui_func(unpack(gui_args))

	return (retained_mode and id) or nil
end

UIRenderer.script_draw_text = function (self, text, font_size, font_type, gui_position, gui_size, color, options, retained_id)
	local render_settings = self.render_settings
	local retained_mode = not not retained_id

	if retained_id == true then
		retained_id = nil
	end

	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = color and Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	local snap_pixel_positions = render_settings and render_settings.snap_pixel_positions

	if snap_pixel_positions == nil then
		snap_pixel_positions = SNAP_PIXEL_POSITIONS
	end

	if snap_pixel_positions then
		local scale = self.scale
		gui_position = _snap_to_position(gui_position, scale)
	end

	if render_settings then
		gui_position[3] = (render_settings.start_layer or 0) + gui_position[3]
	end

	local font_data = UIFonts.data_by_type(font_type)
	local font = font_data.path
	local flags = font_data.render_flags or 0

	if self.render_pass_flag then
		flags = flags + Gui.RenderPass
	end

	table.clear(slug_render_params)

	local material_flags = _get_material_flag(render_settings, nil, self.render_pass_flag)

	if material_flags then
		slug_render_params[#slug_render_params + 1] = "material_flags"
		slug_render_params[#slug_render_params + 1] = material_flags
	end

	slug_render_params = table.append(slug_render_params, options or dummy_text_options)
	local gui = (retained_mode and self.gui_retained) or self.gui
	local gui_func = (retained_id and Gui_update_slug_text) or Gui_slug_text

	fassert(#slug_render_params < 10, "[UIRenderer] - To many slug params: %d, can currently only handle 9", #slug_render_params)
	table.clear_array(gui_args, 21)

	gui_args[13], gui_args[14], gui_args[15], gui_args[16], gui_args[17], gui_args[18], gui_args[19], gui_args[20], gui_args[21] = unpack(slug_render_params)
	gui_args[12] = flags
	gui_args[11] = "flags"
	gui_args[10] = color
	gui_args[9] = gui_size
	gui_args[8] = gui_position
	gui_args[7] = self.base_render_pass
	gui_args[6] = self.render_pass_flag
	gui_args[5] = font_size
	gui_args[4] = font
	gui_args[3] = text
	gui_args[2] = retained_id
	gui_args[1] = gui

	table.compact_array(gui_args)

	local id = gui_func(unpack(gui_args))

	return (retained_mode and id) or nil
end

UIRenderer.script_draw_text_3d = function (self, text, font_size, font_type, tm, gui_position, gui_layer, gui_size, color, options, retained_id)
	local render_settings = self.render_settings
	local retained_mode = not not retained_id

	if retained_id == true then
		retained_id = nil
	end

	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = color and Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	local snap_pixel_positions = render_settings and render_settings.snap_pixel_positions

	if snap_pixel_positions == nil then
		snap_pixel_positions = SNAP_PIXEL_POSITIONS
	end

	if snap_pixel_positions then
		local scale = self.scale
		gui_position = _snap_to_position(gui_position, scale)
	end

	if render_settings then
		gui_layer = (render_settings.start_layer or 0) + gui_layer
	end

	local font_data = UIFonts.data_by_type(font_type)
	local font = font_data.path
	local flags = font_data.render_flags or 0

	if self.render_pass_flag then
		flags = flags + Gui.RenderPass
	end

	table.clear(slug_render_params)

	local material_flags = _get_material_flag(render_settings, nil, self.render_pass_flag)

	if material_flags then
		slug_render_params[#slug_render_params + 1] = "material_flags"
		slug_render_params[#slug_render_params + 1] = material_flags
	end

	slug_render_params = table.append(slug_render_params, options or dummy_text_options)
	gui_position = gui_position or Vector3.zero()
	local gui = (retained_mode and self.gui_retained) or self.gui
	local gui_func = (retained_id and Gui_update_slug_text_3d) or Gui_slug_text_3d

	fassert(#slug_render_params < 10, "[UIRenderer] - To many slug params: %d, can currently only handle 9", #slug_render_params)
	table.clear_array(gui_args, 20)

	gui_args[13], gui_args[14], gui_args[15], gui_args[16], gui_args[17], gui_args[18], gui_args[19], gui_args[20] = unpack(slug_render_params)
	gui_args[12] = flags
	gui_args[11] = "flags"
	gui_args[10] = color
	gui_args[9] = gui_size
	gui_args[8] = gui_layer
	gui_args[7] = gui_position
	gui_args[6] = tm
	gui_args[5] = font_size
	gui_args[4] = font
	gui_args[3] = text
	gui_args[2] = retained_id
	gui_args[1] = gui

	table.compact_array(gui_args)

	local id = gui_func(unpack(gui_args))

	return (retained_mode and id) or nil
end

UIRenderer.create_video_player = function (self, reference_name, world, resource, set_loop)
	local video_players = self.video_players

	assert(not video_players[reference_name])

	local video_world = world or self.world
	local video_player = video_world:create_video_player(resource, set_loop)
	video_players[reference_name] = video_player

	if set_loop == false then
		VideoPlayer.set_loop(video_player, false)
	end
end

UIRenderer.destroy_video_player = function (self, reference_name, world)
	local video_players = self.video_players
	local video_player = video_players[reference_name]

	fassert(video_player, "[UIRenderer] - Could not find a video player to destroy with name: %s", reference_name)
	World.destroy_video_player(world or self.world, video_player)

	video_players[reference_name] = nil
end

UIRenderer.clear_scenegraph_queue = function (self)
	self.ui_scenegraph = nil

	table.clear(self.ui_scenegraph_queue)

	self.current_clipping_rect = nil
end

UIRenderer.begin_pass = function (self, ui_scenegraph, input_service, dt, render_settings)
	if self.ui_scenegraph then
		UIRenderer.clear_scenegraph_queue(self)
	end

	if self.render_target then
		self.base_render_pass = self.name
	end

	self.scale = render_settings.scale or RESOLUTION_LOOKUP.scale
	self.inverse_scale = render_settings.inverse_scale or RESOLUTION_LOOKUP.inverse_scale
	self.render_settings = render_settings
	self.ui_scenegraph = ui_scenegraph
	self.input_service = input_service
	self.dt = dt
end

UIRenderer.end_pass = function (self)
	self.render_settings = nil
	self.scale = nil
	self.inverse_scale = nil
	local ui_scenegraph_queue = self.ui_scenegraph_queue
	local num_scenegraph_queues = #ui_scenegraph_queue

	if num_scenegraph_queues > 0 then
		self.ui_scenegraph = ui_scenegraph_queue[num_scenegraph_queues]
		ui_scenegraph_queue[num_scenegraph_queues] = nil
	else
		self.ui_scenegraph = nil
	end
end

UIRenderer.draw_slug_icon = function (self, resource, index, position, size, color, optional_material, material_flags, retained_id)
	local render_settings = self.render_settings
	local retained_mode = not not retained_id

	if retained_id == true then
		retained_id = nil
	end

	local scale = self.scale
	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	position = UIResolution.scale_vector(position, scale)
	size = UIResolution.scale_vector(size, scale)

	if render_settings then
		position[3] = (render_settings.start_layer or 0) + position[3]
	end

	local snap_pixel_positions = render_settings and render_settings.snap_pixel_positions

	if snap_pixel_positions == nil then
		snap_pixel_positions = SNAP_PIXEL_POSITIONS
	end

	if snap_pixel_positions then
		position = _snap_to_position(position, scale)
	end

	table.clear(slug_render_params)

	if optional_material then
		slug_render_params[#slug_render_params + 1] = "material"
		slug_render_params[#slug_render_params + 1] = optional_material
	end

	material_flags = _get_material_flag(render_settings, material_flags, self.render_pass_flag)

	if material_flags then
		slug_render_params[#slug_render_params + 1] = "material_flags"
		slug_render_params[#slug_render_params + 1] = material_flags
	end

	local gui = (retained_mode and self.gui_retained) or self.gui
	local gui_func = (retained_id and Gui_update_slug_icon) or Gui_slug_icon
	local render_pass = self.base_render_pass

	if render_pass and render_settings.hdr then
		render_pass = render_pass .. "_hdr"
	end

	fassert(#slug_render_params < 10, "[UIRenderer] - To many slug params: %d, can currently only handle 9", #slug_render_params)
	table.clear_array(gui_args, 20)

	gui_args[10], gui_args[11], gui_args[12], gui_args[13], gui_args[14], gui_args[15], gui_args[16], gui_args[17], gui_args[18] = unpack(slug_render_params)
	gui_args[9] = color
	gui_args[8] = size
	gui_args[7] = position
	gui_args[6] = render_pass
	gui_args[5] = self.render_pass_flag
	gui_args[4] = index
	gui_args[3] = resource
	gui_args[2] = retained_id
	gui_args[1] = gui

	table.compact_array(gui_args)

	local id = gui_func(unpack(gui_args))

	return (retained_mode and id) or nil
end

UIRenderer.draw_slug_multi_icon = function (self, resource, index, position, size, color, axis, spacing, direction, draw_count, optional_material, retained_ids)
	axis = axis or 1
	direction = direction or 1
	local render_settings = self.render_settings
	local retained_mode = not not retained_ids

	if retained_ids == true then
		retained_ids = nil
	end

	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = color and Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	local scale = self.scale
	local gui_position = UIResolution.scale_vector(position, scale)
	local gui_size = UIResolution.scale_vector(size, scale)
	local start_axis_position = gui_position[axis]
	local size_axis_length = gui_size[axis]
	spacing = (spacing or 0) * table.clear(slug_render_params)

	if optional_material then
		slug_render_params[#slug_render_params + 1] = "material"
		slug_render_params[#slug_render_params + 1] = optional_material
	end

	local material_flags = _get_material_flag(render_settings, nil, self.render_pass_flag)

	if material_flags then
		slug_render_params[#slug_render_params + 1] = "material_flags"
		slug_render_params[#slug_render_params + 1] = material_flags
	end

	local is_resource_array = type(resource) == "table"
	local gui = (retained_mode and self.gui_retained) or self.gui
	local gui_func = (retained_ids and Gui_slug_update_icon) or Gui_slug_icon
	local new_retained_ids = {}
	local render_pass = self.base_render_pass

	if render_pass and render_settings.hdr then
		render_pass = render_pass .. "_hdr"
	end

	for i = 1, draw_count, 1 do
		gui_position[axis] = start_axis_position + (size_axis_length + spacing) * (i - 1) * direction
		local draw_resource = (is_resource_array and resource[i]) or resource
		local retained_id = (retained_ids and retained_ids[i]) or nil

		fassert(#slug_render_params < 10, "[UIRenderer] - To many slug params: %d, can currently only handle 9", #slug_render_params)
		table.clear_array(gui_args, 20)

		gui_args[10], gui_args[11], gui_args[12], gui_args[13], gui_args[14], gui_args[15], gui_args[16], gui_args[17], gui_args[18] = unpack(slug_render_params)
		gui_args[9] = color
		gui_args[8] = size
		gui_args[7] = position
		gui_args[6] = render_pass
		gui_args[5] = self.render_pass_flag
		gui_args[4] = index
		gui_args[3] = draw_resource
		gui_args[2] = retained_id
		gui_args[1] = gui

		table.compact_array(gui_args)

		new_retained_ids[i] = gui_func(unpack(gui_args))
	end

	return (retained_mode and new_retained_ids) or nil
end

UIRenderer.draw_slug_icon_rotated = function (self, resource, index, size, position, angle, pivot, color, optional_material, retained_id)
	local render_settings = self.render_settings
	local retained_mode = not not retained_id

	if retained_id == true then
		retained_id = nil
	end

	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = color and Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	local scale = self.scale
	size = UIResolution.scale_vector(size, scale)
	local scaled_pivot = UIResolution.scale_vector(pivot, scale)
	local tm = Rotation2D(Vector3.zero(), angle, Vector2(scaled_pivot[1], scaled_pivot[2]))
	local translation = Matrix4x4.translation(tm)
	local scaled_position = UIResolution.scale_vector(position, scale)
	translation.x = translation.x + scaled_position.x
	translation.z = translation.z + scaled_position.y
	local snap_pixel_positions = render_settings and render_settings.snap_pixel_positions

	if snap_pixel_positions == nil then
		snap_pixel_positions = SNAP_PIXEL_POSITIONS
	end

	if snap_pixel_positions then
		translation = _snap_to_position(translation, scale)
	end

	Matrix4x4.set_translation(tm, translation)
	table.clear(slug_render_params)

	if optional_material then
		slug_render_params[#slug_render_params + 1] = "material"
		slug_render_params[#slug_render_params + 1] = optional_material
	end

	local material_flags = _get_material_flag(render_settings, nil, self.render_pass_flag)

	if material_flags then
		slug_render_params[#slug_render_params + 1] = "material_flags"
		slug_render_params[#slug_render_params + 1] = material_flags
	end

	local layer = (render_settings.start_layer or 0) + math.max(position[3], 1)
	local gui = (retained_mode and self.gui_retained) or self.gui
	local gui_func = (retained_id and Gui_update_slug_icon_3d) or Gui_slug_icon_3d

	fassert(#slug_render_params < 10, "[UIRenderer] - To many slug params: %d, can currently only handle 9", #slug_render_params)
	table.clear_array(gui_args, 20)

	gui_args[10], gui_args[11], gui_args[12], gui_args[13], gui_args[14], gui_args[15], gui_args[16], gui_args[17], gui_args[18] = unpack(slug_render_params)
	gui_args[9] = color
	gui_args[8] = size
	gui_args[7] = layer
	gui_args[6] = Vector3.zero()
	gui_args[5] = tm
	gui_args[4] = index
	gui_args[3] = resource
	gui_args[2] = retained_id
	gui_args[1] = gui

	table.compact_array(gui_args)

	local id = gui_func(unpack(gui_args))

	return (retained_mode and id) or nil
end

UIRenderer.draw_slug_picture = function (self, resource, position, size, color, optional_material, retained_id)
	local render_settings = self.render_settings
	local retained_mode = not not retained_id

	if retained_id == true then
		retained_id = nil
	end

	local scale = self.scale
	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	position = UIResolution.scale_vector(position, scale)
	size = UIResolution.scale_vector(size, scale)
	local snap_pixel_positions = render_settings and render_settings.snap_pixel_positions

	if snap_pixel_positions == nil then
		snap_pixel_positions = SNAP_PIXEL_POSITIONS
	end

	if snap_pixel_positions then
		position = _snap_to_position(position, scale)
	end

	if render_settings then
		position[3] = (render_settings.start_layer or 0) + position[3]
	end

	table.clear(slug_render_params)

	if optional_material then
		slug_render_params[#slug_render_params + 1] = "material"
		slug_render_params[#slug_render_params + 1] = optional_material
	end

	local material_flags = _get_material_flag(render_settings, nil, self.render_pass_flag)

	if material_flags then
		slug_render_params[#slug_render_params + 1] = "material_flags"
		slug_render_params[#slug_render_params + 1] = material_flags
	end

	local render_pass = self.base_render_pass

	if render_pass and render_settings.hdr then
		render_pass = render_pass .. "_hdr"
	end

	local gui = (retained_mode and self.gui_retained) or self.gui
	local gui_func = (retained_id and Gui_update_slug_picture) or Gui_slug_picture

	fassert(#slug_render_params < 10, "[UIRenderer] - To many slug params: %d, can currently only handle 9", #slug_render_params)
	table.clear_array(gui_args, 20)

	gui_args[10], gui_args[11], gui_args[12], gui_args[13], gui_args[14], gui_args[15], gui_args[16], gui_args[17], gui_args[18] = unpack(slug_render_params)
	gui_args[9] = color
	gui_args[8] = size
	gui_args[7] = position
	gui_args[6] = render_pass
	gui_args[5] = self.render_pass_flag
	gui_args[4] = 1
	gui_args[3] = resource
	gui_args[2] = retained_id
	gui_args[1] = gui

	table.compact_array(gui_args)

	local id = gui_func(unpack(gui_args))

	return (retained_mode and id) or nil
end

UIRenderer.draw_rect = function (self, position, size, color, retained_id)
	local render_settings = self.render_settings
	local retained_mode = not not retained_id

	if retained_id == true then
		retained_id = nil
	end

	local scale = self.scale
	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	position = UIResolution.scale_vector(position, scale)
	size = UIResolution.scale_vector(size, scale)
	local snap_pixel_positions = render_settings and render_settings.snap_pixel_positions

	if snap_pixel_positions == nil then
		snap_pixel_positions = SNAP_PIXEL_POSITIONS
	end

	if snap_pixel_positions then
		position = _snap_to_position(position, scale)
	end

	if render_settings then
		position[3] = (render_settings.start_layer or 0) + position[3]
	end

	local render_pass = self.base_render_pass

	if render_pass and render_settings.hdr then
		render_pass = render_pass .. "_hdr"
	end

	local gui = (retained_mode and self.gui_retained) or self.gui
	local gui_func = (retained_id and Gui_update_rect) or Gui_rect

	table.clear_array(gui_args, 20)

	gui_args[7] = color
	gui_args[6] = size
	gui_args[5] = position
	gui_args[4] = render_pass
	gui_args[3] = self.render_pass_flag
	gui_args[2] = retained_id
	gui_args[1] = gui

	table.compact_array(gui_args)

	local id = gui_func(unpack(gui_args))

	return (retained_mode and id) or nil
end

UIRenderer.draw_triangle = function (self, position, size, ui_style, retained_id)
	local render_settings = self.render_settings
	local retained_mode = not not retained_id

	if retained_id == true then
		retained_id = nil
	end

	local scale = self.scale
	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	local style_color = ui_style.color or {
		255,
		255,
		0,
		255
	}
	local color = Color(style_color[1] * alpha_multiplier, style_color[2], style_color[3], style_color[4])
	local layer = position[3]
	local base_pos = Vector3(position[1], 0, position[2])
	local pos1, pos2, pos3 = nil
	local corners_from_style = ui_style.triangle_corners

	if corners_from_style and #corners_from_style == 3 then
		pos1 = base_pos + Vector3(corners_from_style[1][1], 0, corners_from_style[1][2])
		pos2 = base_pos + Vector3(corners_from_style[2][1], 0, corners_from_style[2][2])
		pos3 = base_pos + Vector3(corners_from_style[3][1], 0, corners_from_style[3][2])
	elseif ui_style.triangle_alignment == "top_left" then
		pos1 = base_pos
		pos2 = base_pos + Vector3(0, 0, size[2])
		pos3 = base_pos + Vector3(size[1], 0, size[2])
	elseif ui_style.triangle_alignment == "top_right" then
		pos1 = base_pos + Vector3(0, 0, size[2])
		pos2 = base_pos + Vector3(size[1], 0, size[2])
		pos3 = base_pos + Vector3(size[1], 0, 0)
	elseif ui_style.triangle_alignment == "bottom_left" then
		pos1 = base_pos
		pos2 = base_pos + Vector3(size[1], 0, 0)
		pos3 = base_pos + Vector3(0, 0, size[2])
	else
		pos1 = base_pos
		pos2 = base_pos + Vector3(size[1], 0, 0)
		pos3 = base_pos + Vector3(size[1], 0, size[2])
	end

	if render_settings then
		layer = (render_settings.start_layer or 0) + layer
	end

	local render_pass = self.base_render_pass

	if render_pass and render_settings.hdr then
		render_pass = render_pass .. "_hdr"
	end

	local gui = (retained_mode and self.gui_retained) or self.gui
	local gui_func = (retained_id and Gui_update_triangle) or Gui_triangle

	table.clear_array(gui_args, 20)

	gui_args[9] = color
	gui_args[8] = layer
	gui_args[7] = UIResolution.scale_vector(pos3, scale, nil, true)
	gui_args[6] = UIResolution.scale_vector(pos2, scale, nil, true)
	gui_args[5] = UIResolution.scale_vector(pos1, scale, nil, true)
	gui_args[4] = render_pass
	gui_args[3] = self.render_pass_flag
	gui_args[2] = retained_id
	gui_args[1] = gui

	table.compact_array(gui_args)

	local id = gui_func(unpack(gui_args))

	return (retained_mode and id) or nil
end

UIRenderer.draw_rect_rotated = function (self, size, position, angle, pivot, color)
	local scale = self.scale
	size = UIResolution.scale_vector(size, scale)
	local scaled_pivot = UIResolution.scale_vector(pivot, scale)
	local tm = Rotation2D(Vector3.zero(), angle, Vector2(scaled_pivot[1], scaled_pivot[2]))
	local translation = Matrix4x4.translation(tm)
	local scaled_position = UIResolution.scale_vector(position, scale)
	local render_settings = self.render_settings
	local snap_pixel_positions = render_settings and render_settings.snap_pixel_positions

	if snap_pixel_positions == nil then
		snap_pixel_positions = SNAP_PIXEL_POSITIONS
	end

	if snap_pixel_positions then
		scaled_position = _snap_to_position(scaled_position, scale)
	end

	translation.x = translation.x + scaled_position.x
	translation.z = translation.z + scaled_position.y

	Matrix4x4.set_translation(tm, translation)

	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	local layer = position[3]

	if render_settings then
		layer = (render_settings.start_layer or 0) + layer
	end

	Gui.rect_3d(self.gui, tm, Vector3.zero(), layer, size, color)
end

UIRenderer.draw_texture = function (self, material, position, size, color, retained_id)
	local scale = self.scale
	local gui_position = Vector3(position[1] * scale, position[2] * scale, position[3] or 0)
	local gui_size = Vector3(size[1] * scale, size[2] * scale, size[3] or 0)

	return UIRenderer.script_draw_bitmap(self, material, gui_position, gui_size, color, retained_id)
end

UIRenderer.draw_multi_texture = function (self, material, position, size, color, axis, spacing, direction, draw_count, retained_ids)
	axis = axis or 1
	direction = direction or 1
	local retained_mode = not not retained_ids

	if retained_ids == true then
		retained_ids = nil
	end

	local scale = self.scale
	local gui_position = UIResolution.scale_vector(position, scale)
	local gui_size = UIResolution.scale_vector(size, scale)
	local start_axis_position = gui_position[axis]
	local size_axis_length = gui_size[axis]
	spacing = (spacing or 0) * scale
	local is_material_array = type(material) == "table"
	local new_retained_ids = {}

	for i = 1, draw_count, 1 do
		gui_position[3] = position[3]
		gui_position[axis] = start_axis_position + (size_axis_length + spacing) * (i - 1) * direction
		local draw_material = (is_material_array and material[i]) or material
		local retained_id = (retained_ids and retained_ids[i]) or nil
		new_retained_ids[i] = UIRenderer.script_draw_bitmap(self, draw_material, gui_position, gui_size, color, retained_id)
	end

	return (retained_mode and new_retained_ids) or nil
end

UIRenderer.draw_texture_uv = function (self, material, position, size, uvs, color, retained_id)
	local scale = self.scale
	local gui_position = Vector3(position[1] * scale, position[2] * scale, position[3] or 0)
	local gui_size = Vector3(size[1] * scale, size[2] * scale, size[3] or 0)

	return UIRenderer.script_draw_bitmap_uv(self, material, uvs, gui_position, gui_size, color, retained_id)
end

UIRenderer.draw_texture_rotated = function (self, material, size, position, angle, pivot, color, optional_uvs, retained_id)
	local scale = self.scale
	size = UIResolution.scale_vector(size, scale)
	local tm = Rotation2D(Vector3.zero(), angle, Vector2(UIResolution.scale_lua_vector2(pivot, scale)))
	local translation = Matrix4x4.translation(tm)
	local translation_x, translation_y, translation_z = Vector3.to_elements(translation)
	local scaled_position_x, scaled_position_y = Vector3.to_elements(UIResolution.scale_vector(position, scale))

	Vector3.set_xyz(translation, translation_x + scaled_position_x, translation_y, translation_z + scaled_position_y)
	Matrix4x4.set_translation(tm, translation)

	local layer = math.max(position[3], 1)

	return UIRenderer.script_draw_bitmap_3d(self, material, tm, nil, layer, size, color, optional_uvs, retained_id)
end

UIRenderer.draw_text = function (self, text, font_size, font_type, position, size, color, options, retained_id)
	Profiler.start("UIRenderer.draw_text")

	local scale = self.scale
	position = UIResolution.scale_vector(position, scale)
	size = size and UIResolution.scale_vector(size, scale)
	local return_value = UIRenderer.script_draw_text(self, text, font_size, font_type, position, size, color, options, retained_id)

	Profiler.stop("UIRenderer.draw_text")

	return return_value
end

UIRenderer.word_wrap = function (self, text, font_type, font_size, width)
	Profiler.start("UIRenderer.word_wrap")

	local whitespace = " \u3002\uff0c"
	local soft_dividers = " -+&/*"
	local return_dividers = "\n"
	local reuse_global_table = true
	local scale = self.scale or 1
	local font_data = UIFonts.data_by_type(font_type)
	local font = font_data.path
	local flags = font_data.render_flags or 0
	local rows, return_indices = Gui.slug_word_wrap(self.gui, text, font, font_size, width * scale, return_dividers, soft_dividers, reuse_global_table, flags)

	Profiler.stop("UIRenderer.word_wrap")

	return rows, return_indices
end

UIRenderer.text_width = function (self, text, font_type, font_size, optional_size, options)
	return
end

UIRenderer.text_height = function (self, text, font_type, font_size, optional_size, options)
	Profiler.start("UIRenderer.text_height")

	local font_data = UIFonts.data_by_type(font_type)
	local font = font_data.path
	local flags = font_data.render_flags or 0
	optional_size = optional_size and Vector2(optional_size[1], optional_size[2])
	local min, max, _ = Gui.slug_text_max_extents(self.gui, text, font, font_size, optional_size, "flags", flags, unpack(options or dummy_text_options))
	local height = max.y - min.y

	Profiler.stop("UIRenderer.text_height")

	return height
end

UIRenderer.text_size = function (self, text, font_type, font_size, optional_size, options)
	Profiler.start("UIRenderer.text_size")

	local font_data = UIFonts.data_by_type(font_type)
	local font = font_data.path
	local flags = font_data.render_flags or 0
	optional_size = optional_size and Vector2(optional_size[1], optional_size[2])
	local min, max, caret = Gui.slug_text_extents(self.gui, text, font, font_size, optional_size, "flags", flags, unpack(options or dummy_text_options))
	local width = max.x - min.x
	local height = max.y - min.y

	Profiler.stop("UIRenderer.text_size")

	return width, height, min, caret
end

UIRenderer.draw_video = function (self, material_name, position, size, color, video_player_reference, y_slot_name, uv_slot_name, optional_video_player)
	local gui = self.gui
	local video_player = optional_video_player or self.video_players[video_player_reference]
	local pixel_snap = true
	local render_settings = self.render_settings
	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = color and Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	local scale = self.scale
	position = UIResolution.scale_vector(position, scale)

	if render_settings then
		position[3] = (render_settings.start_layer or 0) + position[3]
	end

	Gui.video(gui, material_name, video_player, y_slot_name, uv_slot_name, position, UIResolution.scale_vector(size, scale, pixel_snap), color)

	local is_complete = VideoPlayer.current_frame(video_player) == VideoPlayer.number_of_frames(video_player)

	return is_complete
end

local circleVerts = {}
local CIRCLE_VERTS = 32

for i = 1, CIRCLE_VERTS, 1 do
	local a = i / CIRCLE_VERTS * math.pi * 2
	circleVerts[i * 2 - 1] = math.cos(a)
	circleVerts[i * 2] = math.sin(a)
end

UIRenderer.draw_circle = function (self, position, radius, size, color)
	local gui = self.gui
	local scale = self.scale
	local radius_x = (size and size[1] / 2) or radius
	local radius_y = (size and size[2] / 2) or radius
	local render_settings = self.render_settings
	local alpha_multiplier = (render_settings and render_settings.alpha_multiplier) or 1
	color = color and Color(color[1] * alpha_multiplier, color[2], color[3], color[4])
	local layer = position[3]

	if render_settings then
		layer = (render_settings.start_layer or 0) + layer
	end

	local p1 = position
	p1.z = p1.y
	local x = p1.x
	local y = p1.y
	local p2 = Vector3(x + circleVerts[1] * radius, 0, y + circleVerts[2] * radius)

	for i = 2, CIRCLE_VERTS, 1 do
		local p3 = Vector3(x + circleVerts[i * 2 - 1] * radius_x, 0, y + circleVerts[i * 2] * radius_y)

		Gui_triangle(self.gui, UIResolution.scale_vector(p1, scale, nil, true), UIResolution.scale_vector(p2, scale, nil, true), UIResolution.scale_vector(p3, scale, nil, true), layer, color)

		p2 = p3
	end

	local p3 = Vector3(x + circleVerts[1] * radius_x, 0, y + circleVerts[2] * radius_y)

	Gui_triangle(self.gui, UIResolution.scale_vector(p1, scale, nil, true), UIResolution.scale_vector(p2, scale, nil, true), UIResolution.scale_vector(p3, scale, nil, true), layer, color)
end

UIRenderer.is_clipped = function (self, position, size)
	local x0, y0, x1, y1 = unpack(self.current_clipping_rect)

	return position.y <= y1 and y0 <= position.y + size.y and position.x <= x1 and x0 <= position.x + size.x
end

UIRenderer.clip_is_enclosing = function (self, position, size)
	local x0, y0, x1, y1 = unpack(self.current_clipping_rect)

	return y0 <= position.y and y1 >= position.y + size.y and x0 <= position.x and x1 >= position.x + size.x
end

local crop_suffix = "..."

UIRenderer.crop_text = function (text, max_chars)
	local text_length = Utf8.string_length(text)

	if max_chars < text_length then
		local cropped_text = Utf8.sub_string(text, 1, max_chars) .. crop_suffix

		return cropped_text
	end

	return text
end

UIRenderer.crop_text_width = function (self, text, font_type, font_size, max_width, crop_from_left)
	local scale = self.scale or 1
	local scaled_font_size = UIFonts.scaled_size(font_size, scale)
	local text_width, _1, _2, caret = UIRenderer.text_size(self, text, font_type, scaled_font_size)
	local crop_suffix_width, _1, _2, suffix_caret = UIRenderer.text_size(self, crop_suffix, font_type, scaled_font_size)

	if max_width < text_width then
		repeat
			local width_percent = 1 - (1 - (max_width - crop_suffix_width) / text_width) * 0.5
			local num_char = Utf8.string_length(text)
			local number_of_characters_to_show = math.floor(num_char * width_percent)
			local start_index = 1
			local last_index = number_of_characters_to_show

			if crop_from_left then
				start_index = num_char - number_of_characters_to_show + 1
				last_index = num_char
			end

			text = Utf8.sub_string(text, start_index, last_index)

			if num_char <= 0 then
				return text, caret[1]
			end

			text_width, _1, _2, caret = UIRenderer.text_size(self, text, font_type, scaled_font_size)
			text_width = math.floor(text_width)
		until text_width <= max_width

		if crop_from_left then
			local crop_prefix = crop_suffix
			text = crop_prefix .. text
			caret[1] = caret[1] + suffix_caret[1]
		else
			text = text .. crop_suffix
		end
	end

	return text, caret[1]
end

UIRenderer.scaled_font_size_by_width = function (self, text, font_type, font_size, max_width)
	local scale = self.scale
	local min_font_size = 1
	local scaled_font_size = UIFonts.scaled_size(font_size, scale)
	local text_width = UIRenderer.text_size(self, text, font_type, scaled_font_size)

	if max_width < text_width then
		repeat
			if font_size <= min_font_size then
				break
			end

			font_size = math.max(font_size - 1, min_font_size)
			scaled_font_size = UIFonts.scaled_size(font_size, scale)
			text_width = math.floor(UIRenderer.text_size(self, text, font_type, scaled_font_size))
		until text_width <= max_width

		local num_char = Utf8.string_length(text)
		text = Utf8.sub_string(text, 1, num_char) .. "..."
	end

	return font_size
end

UIRenderer.destroy_bitmap = function (self, retained_id)
	Gui.destroy_bitmap(self.gui_retained, retained_id)
end

UIRenderer.destroy_text = function (self, retained_id)
	Gui.destroy_text(self.gui_retained, retained_id)
end

UIRenderer.destroy_slug_icon = function (self, retained_id)
	Gui.destroy_slug_icon(self.gui_retained, retained_id)
end

UIRenderer.destroy_slug_picture = function (self, retained_id)
	Gui.destroy_slug_picture(self.gui_retained, retained_id)
end

local function debug_render_scenegraph(ui_renderer, scenegraph, n_scenegraph)
	local default_size = {
		5,
		5
	}
	local draw_color = Color.maroon(64, true)
	local draw_text_color = Color.white(255, true)
	local font_size = 10
	local font_type = "arial"

	for i = 1, n_scenegraph, 1 do
		local draw = true
		local scenegraph_object = scenegraph[i]
		local size = table.clone(scenegraph_object.size) or table.clone(default_size)
		local scenegraph_object_scale = scenegraph_object.scale
		local scenegraph_object_parent = scenegraph_object.parent

		if (not scenegraph_object_parent and not scenegraph_object_scale) or scenegraph_object_scale == "fit" then
			local inverse_scale = ui_renderer.inverse_scale
			local w = RESOLUTION_LOOKUP.width
			local h = RESOLUTION_LOOKUP.height
			size[1] = w * inverse_scale
			size[2] = h * inverse_scale
			draw = false
		end

		local color = draw_color

		if scenegraph_object.debug_mark then
			color = Color.green(64, true)
		end

		if draw then
			UIRenderer.draw_rect(ui_renderer, Vector3(unpack(scenegraph_object.world_position)), size, color)
		end

		local position = Vector3(scenegraph_object.world_position[1], scenegraph_object.world_position[2], scenegraph_object.world_position[3] + 1)

		if draw then
			UIRenderer.draw_text(ui_renderer, scenegraph_object.name, font_size, font_type, position, draw_text_color)
		end

		local children = scenegraph_object.children

		if children then
			debug_render_scenegraph(ui_renderer, children, #children)
		end
	end
end

UIRenderer.debug_render_scenegraph = function (ui_renderer, scenegraph)
	debug_render_scenegraph(ui_renderer, scenegraph.hierarchical_scenegraph, scenegraph.n_hierarchical_scenegraph)
end

UIRenderer.debug_pixel_distance = function (self)
	local input_manager = Managers.input
	local debug_input_service = input_manager:get_input_service("Debug")
	local debug_pixeldistance_value = debug_input_service:get("pixeldistance")

	if debug_pixeldistance_value then
		local cursor = debug_input_service:get("cursor")

		if not self.debug_startpoint then
			self.debug_startpoint = Vector3.to_array(cursor)
			self.debug_startpoint[3] = 999
		end

		local debug_startpoint = self.debug_startpoint
		local cursor_distance = Vector3.distance(Vector3.from_array(debug_startpoint), cursor)
		local font_type = "arial"
		local font_data = UIFonts.data_by_type(font_type)
		local font = font_data.path
		local font_size = 14

		if cursor_distance > 0 then
			if math.abs(cursor.y - debug_startpoint[2]) < math.abs(cursor.x - debug_startpoint[1]) then
				Gui.rect(self.gui, Vector3.from_array(debug_startpoint), Vector2(cursor.x - debug_startpoint[1], 20), Color(128, 255, 255, 255))

				local text = string.format("%d pixels.", cursor.x - debug_startpoint[1])

				Gui.slug_text(self.gui, text, font, font_size, Vector3.from_array(debug_startpoint), nil, Color(255, 255, 255, 255))
			else
				Gui.rect(self.gui, Vector3.from_array(debug_startpoint), Vector2(20, cursor.y - debug_startpoint[2]), Color(128, 255, 255, 255))

				local text = string.format("%d pixels.", cursor.y - debug_startpoint[2])

				Gui.slug_text(self.gui, text, font, font_size, Vector3.from_array(debug_startpoint), nil, Color(255, 255, 255, 255))
			end
		end
	elseif self.debug_startpoint then
		self.debug_startpoint_direction = nil
		self.debug_startpoint = nil
	end
end

return UIRenderer
