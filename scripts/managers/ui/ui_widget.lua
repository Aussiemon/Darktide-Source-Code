-- chunkname: @scripts/managers/ui/ui_widget.lua

local UIPasses = require("scripts/managers/ui/ui_passes")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local DefaultPassValues = require("scripts/ui/default_pass_values")
local DefaultPassStyles = require("scripts/ui/default_pass_styles")
local UIAnimation = require("scripts/managers/ui/ui_animation")
local InputDevice = require("scripts/managers/input/input_device")
local UIWidget = {}
local GuiMaterialFlag = GuiMaterialFlag
local bit_or = bit.bor

local function initialize_pass_definitions(pass_definitions, content, style, widget_name)
	local passes = {}

	for i, pass in ipairs(pass_definitions) do
		local pass_type = pass.pass_type
		local ui_pass = UIPasses[pass_type]
		local data = ui_pass.init(pass, content, style) or {}
		local pass_instance = table.clone(pass)

		pass_instance.data = data
		data._parent_name = widget_name
		passes[i] = pass_instance
	end

	return passes
end

UIWidget.init = function (name, widget_definition)
	local content = table.clone(widget_definition.content)
	local style = widget_definition.style and table.clone(widget_definition.style) or {}
	local offset = widget_definition.offset and table.clone(widget_definition.offset) or {
		0,
		0,
		0,
	}
	local size = widget_definition.size and table.clone(widget_definition.size) or nil

	content.size = size
	content.size_table = {}

	return {
		visible = true,
		name = name,
		passes = initialize_pass_definitions(widget_definition.passes, content, style, name),
		content = content,
		style = style,
		scenegraph_id = widget_definition.scenegraph_id,
		offset = offset,
		animations = {},
	}
end

UIWidget.destroy = function (ui_renderer, widget)
	local passes = widget.passes

	for i, pass in ipairs(passes) do
		local pass_type = pass.pass_type
		local ui_pass = UIPasses[pass_type]

		if ui_pass.destroy then
			ui_pass.destroy(pass, ui_renderer)
		end
	end
end

UIWidget.animate = function (widget, animation)
	widget.animations[animation] = true
end

UIWidget.stop_animations = function (widget)
	table.clear(widget.animations)
end

UIWidget.create_definition = function (pass_definitions, scenegraph_id, content_overrides, optional_size, style_overrides)
	local definition = {}

	for i = 1, #pass_definitions do
		local pass_info = pass_definitions[i]
		local is_clone = false

		if content_overrides then
			local content_id = pass_info.content_id or pass_info.value_id

			if content_id and content_overrides[content_id] then
				pass_info = table.clone(pass_info)
				is_clone = true
			end
		end

		if style_overrides and not is_clone then
			local style_id = pass_info.style_id

			if style_id and style_overrides[style_id] then
				pass_info = table.clone(pass_info)
			end
		end

		UIWidget.add_definition_pass(definition, pass_info)
	end

	definition.scenegraph_id = scenegraph_id
	definition.size = optional_size

	if content_overrides then
		local content = definition.content

		table.merge_recursive(content, content_overrides)
	end

	if style_overrides then
		local style = definition.style

		table.merge_recursive(style, style_overrides)
	end

	return definition
end

local PASS_INTERFACE = table.set({
	"pass_type",
	"content",
	"content_id",
	"style",
	"style_id",
	"value",
	"value_id",
	"change_function",
	"visibility_function",
	"scenegraph_id",
	"retained_mode",
})

UIWidget.add_definition_pass = function (destination, pass_info)
	local passes = destination.passes

	if not passes then
		passes = {}
		destination.passes = passes
	end

	local pass_index = #passes + 1
	local content = destination.content

	if not content then
		content = {}
		destination.content = content
	end

	local style = destination.style

	if not style then
		style = {}
		destination.style = style
	end

	local pass_type = pass_info.pass_type
	local pass_content = pass_info.content
	local content_id = pass_info.content_id

	if pass_content then
		content_id = content_id or "content_id_" .. pass_index
	elseif content_id then
		pass_content = content[content_id] or {}
	end

	if content_id then
		content[content_id] = pass_content
	end

	local pass_style
	local style_id = pass_info.style_id
	local default_style = DefaultPassStyles[pass_type]

	if default_style then
		style_id = style_id or "style_id_" .. pass_index
		pass_style = pass_info.style

		if not pass_style then
			local existing_style = style[style_id]

			pass_style = existing_style or table.clone(default_style)
		else
			local existing_style = style[style_id]

			pass_style = table.merge(existing_style or table.clone(default_style), pass_style)
		end
	end

	if style_id then
		style[style_id] = pass_style
	end

	local default_value = DefaultPassValues[pass_type]
	local value_id

	if default_value then
		value_id = pass_info.value_id or "value_id_" .. pass_index

		local value_content_table = pass_content or content
		local value

		if pass_info.value then
			if type(pass_info.value) == "table" then
				value = table.clone(pass_info.value)
			else
				value = pass_info.value
			end
		else
			value = value_content_table[value_id]
		end

		value = value or type(default_value) == "table" and table.clone(default_value) or default_value
		value_content_table[value_id] = value
	end

	local new_pass_info = {
		pass_type = pass_type,
		value_id = value_id,
		style_id = style_id,
		content_id = content_id,
		change_function = pass_info.change_function,
		visibility_function = pass_info.visibility_function,
		scenegraph_id = pass_info.scenegraph_id,
		retained_mode = pass_info.retained_mode,
	}

	passes[pass_index] = new_pass_info
end

local temp_render_settings = {}

local function _draw_widget_passes(widget, position, ui_renderer, visible)
	local ui_scenegraph = ui_renderer.ui_scenegraph
	local scale = ui_renderer.scale
	local widget_optional_scale = widget.scale and scale * widget.scale
	local passes = widget.passes
	local style = widget.style
	local animations = widget.animations
	local content = widget.content
	local size = content.size
	local widget_offset = widget.offset

	if not size then
		local scenegraph_id = widget.scenegraph_id

		size = content.size_table

		local w, h = UIScenegraph.get_size(ui_scenegraph, scenegraph_id, scale)

		if widget_optional_scale then
			w = w * widget_optional_scale
			h = h * widget_optional_scale
		end

		size[1], size[2] = w, h
	end

	local dt = ui_renderer.dt
	local render_settings = ui_renderer.render_settings or temp_render_settings
	local previous_render_settings_alpha_multiplier = render_settings.alpha_multiplier
	local alpha_multiplier = (render_settings.alpha_multiplier or 1) * (ui_renderer.alpha_multiplier or 1)
	local color_intensity_multiplier = (render_settings.color_intensity_multiplier or 1) * (ui_renderer.color_intensity_multiplier or 1)

	render_settings.color_intensity_multiplier = color_intensity_multiplier
	render_settings.alpha_multiplier = alpha_multiplier

	local render_settings_material_flags = render_settings.material_flags or 0
	local material_flags = render_settings_material_flags

	if content.mask then
		material_flags = bit_or(material_flags, GuiMaterialFlag.GUI_MASK_LAYER)
	end

	if content.mask_alpha then
		material_flags = bit_or(material_flags, GuiMaterialFlag.WRITE_ALPHA)
	end

	if content.mask_red then
		material_flags = bit_or(material_flags, GuiMaterialFlag.WRITE_RED)
	end

	if content.mask_blue then
		material_flags = bit_or(material_flags, GuiMaterialFlag.WRITE_BLUE)
	end

	if content.mask_green then
		material_flags = bit_or(material_flags, GuiMaterialFlag.WRITE_GREEN)
	end

	render_settings.material_flags = material_flags

	local material_flags_w_hdr = bit_or(material_flags, GuiMaterialFlag.GUI_HDR_LAYER)
	local render_settings_world_target_position = render_settings.world_target_position

	if style.world_target_position then
		render_settings.world_target_position = style.world_target_position
	end

	local pos_x, pos_y, pos_z

	if type(position) == "table" then
		pos_x, pos_y, pos_z = position[1], position[2], position[3]
	else
		pos_x, pos_y, pos_z = Vector3.to_elements(position)
	end

	local size_x, size_y = size[1], size[2]

	for i = 1, #passes do
		repeat
			local pass_visibility = visible
			local pass_info = passes[i]
			local pass_type = pass_info.pass_type
			local ui_pass = UIPasses[pass_type]
			local content_id = pass_info.content_id
			local pass_content = content_id and content[content_id] or content

			if content_id and not pass_content.parent then
				pass_content.parent = content
			end

			local style_id = pass_info.style_id
			local style_data = style_id and style[style_id] or style

			if style_id and not style_data.parent then
				style_data.parent = style
			end

			if pass_visibility and content then
				if content.visible == false then
					pass_visibility = false
				elseif content_id and pass_content and pass_content.visible == false then
					pass_visibility = false
				end
			end

			if pass_visibility and style_data.visible == false then
				pass_visibility = false
			end

			if pass_visibility then
				local visibility_function = pass_info.visibility_function

				if visibility_function then
					pass_visibility = visibility_function(pass_content, style_data)
				end
			end

			if pass_visibility then
				local change_function = pass_info.change_function

				if change_function then
					change_function(pass_content, style_data, animations, dt)
				end
			end

			local update = ui_pass.update

			if update then
				update(pass_info, ui_renderer, style_data, pass_content, pass_visibility)
			end

			local pass_data = pass_info.data

			if pass_data.retained_id or pass_data.retained_ids then
				local visible_previous = pass_data.visible

				pass_data.visible = pass_visibility

				if visible_previous and not pass_visibility then
					ui_pass.destroy(pass_info, ui_renderer)

					break
				elseif not visible_previous and pass_visibility then
					pass_data.dirty = true
				end

				if not widget.dirty and not pass_data.dirty then
					break
				end
			end

			if not pass_visibility then
				break
			end

			if ui_pass.draw then
				local pass_pos_x, pass_pos_y, pass_pos_z = pos_x, pos_y, pos_z
				local pass_size_x, pass_size_y = size_x, size_y
				local pass_scenegraph_id = style_data.scenegraph_id or pass_info.scenegraph_id

				if pass_scenegraph_id then
					pass_size_x, pass_size_y = UIScenegraph.get_size(ui_scenegraph, pass_scenegraph_id, scale)

					if widget_optional_scale then
						pass_size_x = pass_size_x * widget_optional_scale
						pass_size_y = pass_size_y * widget_optional_scale
					end

					local world_pos = UIScenegraph.world_position(ui_scenegraph, pass_scenegraph_id)

					if type(world_pos) == "table" then
						pass_pos_x, pass_pos_y, pass_pos_z = world_pos[1], world_pos[2], world_pos[3]
					else
						pass_pos_x, pass_pos_y, pass_pos_z = Vector3.to_elements(world_pos)
					end

					pass_pos_x = pass_pos_x + widget_offset[1]
					pass_pos_y = pass_pos_y + widget_offset[2]
					pass_pos_z = pass_pos_z + widget_offset[3]
				end

				local style_data_size_addition = style_data.size_addition
				local style_data_size = style_data.size

				if style_data_size or style_data_size_addition then
					local width = style_data_size and style_data_size[1] or pass_size_x
					local height = style_data_size and style_data_size[2] or pass_size_y

					if style_data_size_addition then
						width = style_data_size_addition[1] and width + style_data_size_addition[1] or width
						height = style_data_size_addition[2] and height + style_data_size_addition[2] or height
					end

					local horizontal_alignment = style_data.horizontal_alignment

					if horizontal_alignment == "right" then
						pass_pos_x = pass_pos_x + pass_size_x - width
					elseif horizontal_alignment == "center" then
						pass_pos_x = pass_pos_x + (pass_size_x - width) / 2
					end

					local vertical_alignment = style_data.vertical_alignment

					if vertical_alignment == "center" then
						pass_pos_y = pass_pos_y + (pass_size_y - height) / 2
					elseif vertical_alignment == "bottom" then
						pass_pos_y = pass_pos_y + pass_size_y - height
					end

					pass_size_x = width
					pass_size_y = height
				end

				local style_offset = style_data.offset

				if style_offset then
					pass_pos_x = pass_pos_x + style_offset[1]
					pass_pos_y = pass_pos_y + style_offset[2]
					pass_pos_z = pass_pos_z + (style_offset[3] or 0)
				end

				if widget_optional_scale then
					pass_size_x = pass_size_x * widget_optional_scale
					pass_size_y = pass_size_y * widget_optional_scale
					pass_pos_x = pass_pos_x * widget_optional_scale
					pass_pos_y = pass_pos_y * widget_optional_scale
				end

				render_settings.alpha_multiplier = alpha_multiplier * (widget.alpha_multiplier or 1)
				render_settings.color_intensity_multiplier = color_intensity_multiplier * (widget.color_intensity_multiplier or 1)

				ui_pass.draw(pass_info, ui_renderer, style_data, pass_content, Vector3(pass_pos_x, pass_pos_y, pass_pos_z), Vector2(pass_size_x, pass_size_y))

				render_settings.alpha_multiplier = previous_render_settings_alpha_multiplier
			end
		until true
	end

	render_settings.alpha_multiplier = alpha_multiplier
	render_settings.color_intensity_multiplier = color_intensity_multiplier
	render_settings.material_flags = render_settings_material_flags
	render_settings.world_target_position = render_settings_world_target_position or false
end

UIWidget.draw = function (widget, ui_renderer)
	local name = widget.name
	local visible = widget.visible
	local style = widget.style
	local content = widget.content
	local animations = widget.animations
	local offset = widget.offset
	local scenegraph_id = widget.scenegraph_id

	if animations then
		for ui_animation, _ in pairs(animations) do
			UIAnimation.update(ui_animation, ui_renderer.dt)

			if UIAnimation.completed(ui_animation) then
				animations[ui_animation] = nil
			end
		end
	end

	local ui_scenegraph = ui_renderer.ui_scenegraph
	local position = Vector3.from_array(UIScenegraph.world_position(ui_scenegraph, scenegraph_id))

	if offset then
		position = position + Vector3.from_array(offset)
	end

	local gamepad_active = InputDevice.gamepad_active

	content.is_gamepad_active = gamepad_active

	if content.disable_with_gamepad then
		visible = not gamepad_active
	end

	_draw_widget_passes(widget, position, ui_renderer, visible)

	widget.dirty = nil
end

UIWidget.set_visible = function (widget, ui_renderer, visible)
	local passes = widget.passes

	for i = 1, #passes do
		local pass_info = passes[i]
		local pass_data = pass_info.data

		if pass_info.retained_mode or pass_data.material then
			local visible_previous = pass_data.visible

			pass_data.visible = visible

			if not visible or pass_data.material then
				local pass_type = pass_info.pass_type
				local ui_pass = UIPasses[pass_type]
				local destroy_function = ui_pass.destroy

				if destroy_function then
					destroy_function(pass_info, ui_renderer)
				end
			elseif visible then
				pass_data.dirty = true
			end
		end
	end
end

return UIWidget
