-- chunkname: @scripts/managers/ui/ui_passes.lua

local UIResolution = require("scripts/managers/ui/ui_resolution")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIPassesTestify = GameParameters.testify and require("scripts/managers/ui/ui_passes_testify")
local InputDevice = require("scripts/managers/input/input_device")
local UIPasses = {}
local NilCursor = {
	0,
	0,
	0,
}

local function use_retained_mode(pass, render_settings)
	if render_settings and render_settings.force_retained_mode then
		return true
	end

	return pass.retained_mode
end

local function apply_material_values(gui_material, material_values)
	for key, value in pairs(material_values) do
		if type(value) == "table" then
			local num_values = #value

			if num_values == 1 then
				Material.set_scalar(gui_material, key, value[1])
			elseif num_values == 2 then
				local v_value = Vector2(value[1], value[2])

				Material.set_vector2(gui_material, key, v_value)
			elseif num_values == 3 then
				local v_value = Vector3.from_array(value)

				Material.set_vector3(gui_material, key, v_value)
			elseif num_values == 4 then
				Material.set_vector4(gui_material, key, Quaternion.from_elements(value[1], value[2], value[3], value[4]))
			end
		elseif type(value) == "number" then
			Material.set_scalar(gui_material, key, value)
		elseif type(value) == "string" then
			if value == "" then
				Material.set_texture(gui_material, key, nil)
			else
				Material.set_texture(gui_material, key, value)
			end
		elseif type(value) == "userdata" then
			Material.set_resource(gui_material, key, value)
		end
	end
end

local function get_pass_material(ui_renderer, value, pass_data, retained_mode)
	local material = pass_data.material

	if pass_data.material_value ~= value then
		if pass_data.material then
			UIRenderer.destroy_material(ui_renderer, material, retained_mode)
		end

		material = UIRenderer.create_material(ui_renderer, value, retained_mode)
		pass_data.material = material
		pass_data.material_value = value
	end

	return material
end

UIPasses.logic = {
	init = function (pass)
		return
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local value_id = pass.value_id
		local value = ui_content[value_id]

		value(pass, ui_renderer, ui_style, ui_content, position, size)
	end,
}
UIPasses.texture = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data
		local retained_mode = pass_data.retained_id ~= nil

		if pass_data.retained_id then
			UIRenderer.destroy_bitmap(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end

		local gui_material = pass_data.material

		if gui_material then
			UIRenderer.destroy_material(ui_renderer, gui_material, retained_mode)

			pass_data.material_value = nil
			pass_data.material = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size, clip_modified_uvs)
		local pass_data = pass.data
		local value_id = pass.value_id
		local value = ui_content[value_id]
		local color = ui_style.color
		local retained_mode = use_retained_mode(pass, ui_renderer.render_settings)
		local material_values = ui_style.material_values
		local scale_to_material = ui_style.scale_to_material
		local strict_lifetime = ui_style.strict_lifetime
		local gui_material = (material_values or scale_to_material or strict_lifetime) and get_pass_material(ui_renderer, value, pass_data, retained_mode)

		value = gui_material or value

		if material_values then
			apply_material_values(gui_material, material_values)
		end

		local scale = ui_renderer.scale

		if scale_to_material then
			Material.set_scalar(gui_material, "ui_scale", scale)
		end

		local gui_position = Gui.scale_vector3(position, scale)
		local gui_size = Gui.scale_vector3(size, scale)

		if retained_mode then
			local retained_id = pass_data.retained_id or true

			if clip_modified_uvs then
				retained_id = UIRenderer.script_draw_bitmap_uv(ui_renderer, value, gui_position, gui_size, clip_modified_uvs, color, retained_id)
			else
				retained_id = UIRenderer.script_draw_bitmap(ui_renderer, value, gui_position, gui_size, color, retained_id)
			end

			pass_data.retained_id = retained_id or pass_data.retained_id
			pass_data.dirty = false
		elseif clip_modified_uvs then
			UIRenderer.script_draw_bitmap_uv(ui_renderer, value, gui_position, gui_size, clip_modified_uvs, color)
		else
			UIRenderer.script_draw_bitmap(ui_renderer, value, gui_position, gui_size, color)
		end
	end,
}
UIPasses.texture_uv = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data
		local retained_mode = pass_data.retained_id ~= nil

		if pass_data.retained_id then
			UIRenderer.destroy_bitmap(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end

		local gui_material = pass_data.material

		if gui_material then
			UIRenderer.destroy_material(ui_renderer, gui_material, retained_mode)

			pass_data.material_value = nil
			pass_data.material = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size, clip_modified_uvs)
		local pass_data = pass.data
		local value = ui_content[pass.value_id]
		local color = ui_style.color
		local uvs = clip_modified_uvs or ui_style.uvs
		local retained_mode = use_retained_mode(pass, ui_renderer.render_settings)
		local material_values = ui_style.material_values
		local scale_to_material = ui_style.scale_to_material
		local strict_lifetime = ui_style.strict_lifetime
		local gui_material = (material_values or scale_to_material or strict_lifetime) and get_pass_material(ui_renderer, value, pass_data, retained_mode)

		value = gui_material or value

		if material_values then
			apply_material_values(gui_material, material_values)
		end

		local scale = ui_renderer.scale

		if scale_to_material then
			Material.set_scalar(gui_material, "ui_scale", scale)
		end

		local gui_position = Gui.scale_vector3(position, scale)
		local gui_size = Gui.scale_vector3(size, scale)

		if retained_mode then
			local retained_id = pass_data.retained_id or true

			retained_id = UIRenderer.script_draw_bitmap_uv(ui_renderer, value, gui_position, gui_size, uvs, color, retained_id)
			pass_data.retained_id = retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.script_draw_bitmap_uv(ui_renderer, value, gui_position, gui_size, uvs, color)
		end
	end,
}
UIPasses.multi_texture = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data

		if pass_data.retained_id then
			UIRenderer.destroy_bitmap(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local pass_data = pass.data
		local value_id = pass.value_id
		local value = ui_content[value_id]
		local color = ui_style.color
		local axis = ui_style.axis
		local direction = ui_style.direction
		local amount = ui_style.amount
		local spacing = ui_style.spacing
		local retained_mode = use_retained_mode(pass, ui_renderer.render_settings)
		local material_values = ui_style.material_values

		if material_values then
			local is_material_array = type(value) == "table"

			if is_material_array then
				for i = 1, #value do
					local gui_material = get_pass_material(ui_renderer, value[i], pass_data, retained_mode)

					apply_material_values(gui_material, material_values)
					UIRenderer.draw_multi_texture(ui_renderer, gui_material, position, size, color, axis, spacing, direction, amount)
				end
			else
				local gui_material = get_pass_material(ui_renderer, value, pass_data, retained_mode)

				apply_material_values(gui_material, material_values)
				UIRenderer.draw_multi_texture(ui_renderer, gui_material, position, size, color, axis, spacing, direction, amount)
			end
		elseif retained_mode then
			local retained_id = use_retained_mode(pass, ui_renderer.render_settings) and (pass_data.retained_id and pass_data.retained_id or true)

			retained_id = UIRenderer.draw_texture(ui_renderer, value, position, size, color, axis, spacing, direction, amount, retained_id)
			pass_data.retained_id = retained_id and retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.draw_multi_texture(ui_renderer, value, position, size, color, axis, spacing, direction, amount)
		end
	end,
}
UIPasses.slug_icon = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data

		if pass_data.retained_id then
			UIRenderer.destroy_slug_icon(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local pass_data = pass.data
		local value_id = pass.value_id
		local value = ui_content[value_id]
		local draw_index = ui_style.draw_index
		local color = ui_style.color
		local material = ui_style.material

		if use_retained_mode(pass, ui_renderer.render_settings) then
			local retained_id = use_retained_mode(pass, ui_renderer.render_settings) and (pass_data.retained_id and pass_data.retained_id or true)

			retained_id = UIRenderer.draw_slug_icon(ui_renderer, value, draw_index, position, size, color, material, retained_id)
			pass_data.retained_id = retained_id and retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.draw_slug_icon(ui_renderer, value, draw_index, position, size, color, material)
		end
	end,
}
UIPasses.slug_picture = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data

		if pass_data.retained_id then
			UIRenderer.destroy_slug_icon(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local pass_data = pass.data
		local value_id = pass.value_id
		local value = ui_content[value_id]
		local color = ui_style.color
		local material = ui_style.material

		if use_retained_mode(pass, ui_renderer.render_settings) then
			local retained_id = use_retained_mode(pass, ui_renderer.render_settings) and (pass_data.retained_id and pass_data.retained_id or true)

			retained_id = UIRenderer.draw_slug_picture(ui_renderer, value, position, size, color, material, retained_id)
			pass_data.retained_id = retained_id and retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.draw_slug_picture(ui_renderer, value, position, size, color, material)
		end
	end,
}
UIPasses.multi_slug_icon = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data

		if pass_data.retained_id then
			UIRenderer.destroy_slug_icon(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local pass_data = pass.data
		local value_id = pass.value_id
		local value = ui_content[value_id]
		local draw_index = ui_style.draw_index
		local color = ui_style.color
		local material = ui_style.material
		local axis = ui_style.axis
		local direction = ui_style.direction
		local amount = ui_style.amount
		local spacing = ui_style.spacing

		if use_retained_mode(pass, ui_renderer.render_settings) then
			local retained_id = use_retained_mode(pass, ui_renderer.render_settings) and (pass_data.retained_id and pass_data.retained_id or true)

			retained_id = UIRenderer.draw_slug_multi_icon(ui_renderer, value, draw_index, position, size, color, axis, spacing, direction, amount, material, retained_id)
			pass_data.retained_id = retained_id and retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.draw_slug_multi_icon(ui_renderer, value, draw_index, position, size, color, axis, spacing, direction, amount, material)
		end
	end,
}
UIPasses.shader_tiled_texture = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data

		if pass_data.retained_id then
			UIRenderer.destroy_bitmap(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local pass_data = pass.data
		local color
		local value_id = pass.value_id or "value_id"
		local value = ui_content[value_id]

		if ui_style then
			local tile_size = ui_style.tile_size
			local tiles = Vector2(size[1] / tile_size[1], size[2] / tile_size[2])
			local material = Gui.material(ui_renderer.gui, ui_content[value_id])

			Material.set_vector2(material, "tile_multiplier", tiles)

			local material_values = ui_style.material_values

			if material_values then
				apply_material_values(material, material_values)
			end

			local tile_offset = Vector2(0, 0)

			if ui_style.tile_offset[1] then
				tile_offset[1] = position[1] / tile_size[1]
			end

			if ui_style.tile_offset[2] then
				tile_offset[2] = position[2] / tile_size[2]
			end

			Material.set_vector2(material, "tile_offset", tile_offset)

			color = ui_style.color
		end

		if use_retained_mode(pass, ui_renderer.render_settings) then
			local retained_id = use_retained_mode(pass, ui_renderer.render_settings) and (pass_data.retained_id and pass_data.retained_id or true)

			retained_id = UIRenderer.draw_texture(ui_renderer, value, position, size, color, retained_id)
			pass_data.retained_id = retained_id and retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.draw_texture(ui_renderer, value, position, size, color)
		end
	end,
}
UIPasses.rotated_slug_icon = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data

		if pass_data.retained_id then
			UIRenderer.destroy_bitmap(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local pass_data = pass.data
		local value_id = pass.value_id or "value_id"
		local value = ui_content[value_id]
		local angle = ui_style.angle
		local pivot = ui_style.pivot

		if not pivot[1] then
			pivot[1] = size[1] / 2
		end

		if not pivot[2] then
			pivot[2] = size[2] / 2
		end

		local color = ui_style.color
		local material = ui_style.material
		local draw_index = ui_style.draw_index

		if use_retained_mode(pass, ui_renderer.render_settings) then
			local retained_id = use_retained_mode(pass, ui_renderer.render_settings) and (pass_data.retained_id and pass_data.retained_id or true)

			retained_id = UIRenderer.draw_slug_icon_rotated(ui_renderer, value, draw_index, size, position, angle, pivot, color, material, retained_id)
			pass_data.retained_id = retained_id and retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.draw_slug_icon_rotated(ui_renderer, value, draw_index, size, position, angle, pivot, color, material)
		end
	end,
}
UIPasses.rotated_texture = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data
		local retained_mode = pass_data.retained_id ~= nil

		if pass_data.retained_id then
			UIRenderer.destroy_bitmap(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end

		local gui_material = pass_data.material

		if gui_material then
			UIRenderer.destroy_material(ui_renderer, gui_material, retained_mode)

			pass_data.material_value = nil
			pass_data.material = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size, clip_modified_uvs)
		local pass_data = pass.data
		local value_id = pass.value_id or "value_id"
		local value = ui_content[value_id]
		local angle = ui_style.angle
		local pivot = ui_style.pivot

		if not pivot[1] then
			pivot[1] = size[1] / 2
		end

		if not pivot[2] then
			pivot[2] = size[2] / 2
		end

		local color = ui_style.color
		local uvs = clip_modified_uvs or ui_style.uvs
		local retained_mode = use_retained_mode(pass, ui_renderer.render_settings)
		local material_values = ui_style.material_values
		local scale_to_material = ui_style.scale_to_material
		local strict_lifetime = ui_style.strict_lifetime
		local gui_material = (material_values or scale_to_material or strict_lifetime) and get_pass_material(ui_renderer, value, pass_data, retained_mode)

		value = gui_material or value

		if material_values then
			apply_material_values(gui_material, material_values)
		end

		if scale_to_material then
			local scale = ui_renderer.scale

			Material.set_scalar(gui_material, "ui_scale", scale)
		end

		if retained_mode then
			local retained_id = pass_data.retained_id or true

			retained_id = UIRenderer.draw_texture_rotated(ui_renderer, value, size, position, angle, pivot, color, uvs, retained_id)
			pass_data.retained_id = retained_id and retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.draw_texture_rotated(ui_renderer, value, size, position, angle, pivot, color, uvs)
		end
	end,
}
UIPasses.rect = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data

		if pass_data.retained_id then
			UIRenderer.destroy_bitmap(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local color = ui_style.color

		if use_retained_mode(pass, ui_renderer.render_settings) then
			local pass_data = pass.data
			local retained_id = pass_data.retained_id or true

			retained_id = UIRenderer.draw_rect(ui_renderer, position, size, color, retained_id)
			pass_data.retained_id = retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.draw_rect(ui_renderer, position, size, color)
		end
	end,
}
UIPasses.rotated_rect = {
	init = function (pass)
		return nil
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local angle = ui_style.angle
		local pivot = ui_style.pivot
		local color = ui_style.color

		if not pivot[1] then
			pivot[1] = size[1] / 2
		end

		if not pivot[2] then
			pivot[2] = size[2] / 2
		end

		return UIRenderer.draw_rect_rotated(ui_renderer, size, position, angle, pivot, color)
	end,
}
UIPasses.triangle = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data

		if pass_data.retained_id then
			UIRenderer.destroy_bitmap(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local pass_data = pass.data

		if use_retained_mode(pass, ui_renderer.render_settings) then
			local retained_id = use_retained_mode(pass, ui_renderer.render_settings) and (pass_data.retained_id and pass_data.retained_id or true)

			retained_id = UIRenderer.draw_triangle(ui_renderer, position, size, ui_style, retained_id)
			pass_data.retained_id = retained_id and retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.draw_triangle(ui_renderer, position, size, ui_style)
		end
	end,
}
UIPasses.circle = {
	init = function (pass)
		return {
			dirty = true,
			retained_id = nil,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data

		if pass_data.retained_id then
			UIRenderer.destroy_bitmap(ui_renderer, pass_data.retained_id)

			pass_data.retained_id = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local pass_data = pass.data
		local circle_horizontal_alignment = ui_style.circle_horizontal_alignment or "left"
		local circle_vertical_alignment = ui_style.circle_vertical_alignment or "top"
		local half_size_x = size[1] / 2
		local half_size_y = size[2] / 2
		local pos_center = Vector3(position[1], position[2], position[3])

		if circle_horizontal_alignment == "left" then
			pos_center[1] = pos_center[1] + half_size_x
		elseif circle_horizontal_alignment == "right" then
			pos_center[1] = pos_center[1] - half_size_x
		end

		if circle_vertical_alignment == "top" then
			pos_center[2] = pos_center[2] + half_size_y
		elseif circle_vertical_alignment == "bottom" then
			pos_center[2] = pos_center[2] - half_size_y
		end

		local color = ui_style.color
		local radius = (half_size_x + half_size_y) / 2

		if use_retained_mode(pass, ui_renderer.render_settings) then
			local retained_id = use_retained_mode(pass, ui_renderer.render_settings) and (pass_data.retained_id and pass_data.retained_id or true)

			retained_id = UIRenderer.draw_circle(ui_renderer, pos_center, radius, size, color, retained_id)
			pass_data.retained_id = retained_id and retained_id or pass_data.retained_id
			pass_data.dirty = false
		else
			UIRenderer.draw_circle(ui_renderer, pos_center, radius, size, color)
		end
	end,
}
UIPasses.video = {
	init = function (pass)
		return nil
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local value_id = pass.value_id
		local value = ui_content[value_id]
		local color = ui_style.color
		local video_player_reference = ui_content.video_player_reference
		local y_slot_name = ui_style.y_slot_name
		local uv_slot_name = ui_style.uv_slot_name
		local is_complete

		if video_player_reference and value then
			is_complete = UIRenderer.draw_video(ui_renderer, value, position, size, color, video_player_reference, y_slot_name, uv_slot_name)
		end

		ui_content.video_completed = is_complete
	end,
}

local temp_text_options = Script.new_map(32)

UIPasses.text = {
	init = function (pass)
		return {
			dirty = true,
			retained_ids = nil,
			value_id = pass.value_id,
		}
	end,
	destroy = function (pass, ui_renderer)
		local pass_data = pass.data
		local retained_ids = pass_data.retained_ids
		local retained_mode = retained_ids ~= nil

		if retained_ids then
			for i = 1, #retained_ids do
				UIRenderer.destroy_text(ui_renderer, retained_ids[i])
			end

			pass_data.retained_ids = nil
		end

		local gui_material = pass_data.material

		if gui_material then
			UIRenderer.destroy_material(ui_renderer, gui_material, retained_mode)

			pass_data.material_value = nil
			pass_data.material = nil
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local pass_data = pass.data
		local retained_ids

		table.clear(temp_text_options)
		UIFonts.get_font_options_by_style(ui_style, temp_text_options)

		local retained_mode = use_retained_mode(pass, ui_renderer.render_settings)

		if retained_mode then
			retained_ids = pass_data.retained_ids and pass_data.retained_ids or true
		end

		local new_retained_ids

		if retained_ids == true then
			new_retained_ids = {}
		end

		local value_id = pass_data.value_id
		local text = ui_content[value_id]
		local optional_material = ui_style.material

		if optional_material then
			local material_values = ui_style.material_values
			local scale_to_material = ui_style.scale_to_material
			local strict_lifetime = ui_style.strict_lifetime
			local gui_material = (material_values or scale_to_material or strict_lifetime) and get_pass_material(ui_renderer, optional_material, pass_data, retained_mode)

			if material_values then
				apply_material_values(gui_material, material_values)
			end

			temp_text_options.material_resource = gui_material
			temp_text_options.material = optional_material
		end

		local font_type = ui_style.font_type
		local font_size = ui_style.font_size
		local ui_scale = ui_renderer.scale

		font_size = math.max(font_size * ui_scale, 1)

		local text_color = ui_style.text_color
		local retained_id = retained_ids and (new_retained_ids and true or retained_ids[1])
		local gui_position = Gui.scale_vector3(position, ui_scale)
		local gui_size

		if size then
			gui_size = Gui.scale_vector3(size, ui_scale)
		end

		retained_id = UIRenderer.script_draw_text(ui_renderer, text, font_size, font_type, gui_position, gui_size, text_color, temp_text_options, retained_id)

		if new_retained_ids then
			new_retained_ids[1] = retained_id
		end

		if retained_mode then
			pass_data.retained_ids = new_retained_ids or pass_data.retained_ids
			pass_data.dirty = false
		end

		local box_color = ui_style.box_color

		if box_color or ui_style.debug_draw_box then
			gui_position[3] = math.max(gui_position[3] - 1, 1)

			local text_box_color = box_color or Color.magenta(50, true)

			UIRenderer.draw_rect(ui_renderer, gui_position, gui_size, text_box_color)
		end
	end,
}
UIPasses.hover = {
	init = function (pass)
		return nil
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local was_hover = ui_content.is_hover
		local is_hover
		local input_service = ui_renderer.input_service
		local cursor = input_service and input_service:get("cursor") or NilCursor
		local scale = ui_renderer.scale
		local inverse_scale = ui_renderer.inverse_scale

		if ui_content.hover_type == "circle" then
			local half_size = ui_renderer:get_scaling() * size / 2
			local pos_center = Vector3.flat(UIResolution.scale_vector(position, scale)) + half_size
			local square_distance = Vector3.distance_squared(Vector3.from_array(cursor), pos_center)

			is_hover = square_distance <= half_size.x * half_size.y
		else
			local pixel_pos = position
			local pixel_size = size
			local gamepad_active = InputDevice.gamepad_active
			local cursor_position = cursor

			if not gamepad_active then
				cursor_position = UIResolution.inverse_scale_vector(cursor, inverse_scale)
			end

			is_hover = math.point_is_inside_2d_box(cursor_position, pixel_pos, pixel_size)
		end

		if is_hover and not was_hover then
			ui_content.is_hover = not UIPasses.is_dragging_item
			ui_content.internal_is_hover = true
		end

		if was_hover and not is_hover then
			ui_content.is_hover = false
			ui_content.internal_is_hover = false
		end

		if not is_hover and ui_content.internal_is_hover then
			ui_content.internal_is_hover = false
		end
	end,
}

local function calculate_outer_box(anchor_position, vertices)
	local smallest_x = math.huge
	local largest_x = -1
	local smallest_y = math.huge
	local largest_y = -1

	for i = 1, #vertices do
		if smallest_x > vertices[i][1] then
			smallest_x = vertices[i][1]
		end

		if largest_x < vertices[i][1] then
			largest_x = vertices[i][1]
		end

		if smallest_y > vertices[i][2] then
			smallest_y = vertices[i][2]
		end

		if largest_y < vertices[i][2] then
			largest_y = vertices[i][2]
		end
	end

	return {
		position = {
			anchor_position[1] + smallest_x,
			anchor_position[2] + smallest_y,
		},
		size = {
			largest_x - smallest_x,
			largest_y - smallest_y,
		},
	}
end

local double_click_threshold = UISettings.double_click_threshold
local cursor_value_type_name = "Vector3"

UIPasses.hotspot = {
	init = function (pass, content)
		return
	end,
	update = function (pass, ui_renderer, ui_style, ui_content, pass_visibility)
		if not pass_visibility then
			local was_hover = ui_content.is_hover

			if was_hover then
				ui_content.on_hover_exit = false
				ui_content.on_hover_enter = false
				ui_content.force_hover = false
				ui_content.internal_is_hover = false
				ui_content.is_hover = false
				ui_content._input_pressed = false
				ui_content.is_held = false
			end
		end
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local dt = ui_renderer.dt
		local pass_data = pass.data
		local gamepad_active = InputDevice.gamepad_active

		if GameParameters.testify then
			local pass_testify_data = {
				widget_name = pass_data._parent_name,
				ui_content = ui_content,
				position = position,
				size = size,
			}

			Testify:poll_requests_through_handler(UIPassesTestify, pass_testify_data)
		end

		local was_hover = ui_content.is_hover
		local is_hover
		local cursor_name = "cursor"
		local input_service = ui_renderer.input_service
		local cursor = input_service and input_service:get(cursor_name)

		if not cursor or Script.type_name(cursor) ~= cursor_value_type_name then
			cursor = NilCursor
		end

		local inverse_scale = ui_renderer.inverse_scale
		local scale = ui_renderer.scale
		local cursor_position

		if PLATFORM == "xbs" and not gamepad_active then
			cursor_position = Vector3(cursor[1], cursor[2], cursor[3])
		else
			cursor_position = UIResolution.inverse_scale_vector(cursor, inverse_scale)
		end

		local hover_type = ui_content.hover_type
		local pixel_pos = position
		local pixel_size = size
		local render_settings = ui_renderer.render_settings
		local debug_hover_layer = 999 - (render_settings and render_settings.start_layer or 0)

		if hover_type == "circle" then
			local half_size_x = pixel_size[1] / 2
			local half_size_y = pixel_size[2] / 2
			local pos_center = Vector3(pixel_pos[1] + half_size_x, pixel_pos[2] + half_size_y, 0)
			local square_distance = Vector3.distance_squared(cursor_position, pos_center)

			is_hover = square_distance <= half_size_x * half_size_y or false
		elseif hover_type == "triangle" then
			local vertices = ui_style.triangle_corners
			local outer_box = ui_content._outer_box

			if not outer_box or outer_box.scale ~= scale then
				outer_box = calculate_outer_box(pixel_pos, vertices)
				outer_box.scale = scale
				ui_content._outer_box = outer_box
			end

			is_hover = math.point_is_inside_2d_box(cursor_position, outer_box.position, outer_box.size)

			local is_inside_outer_box = is_hover

			if is_inside_outer_box == true then
				local p1 = Vector3(vertices[1][1], vertices[1][2], 0) + pixel_pos
				local p2 = Vector3(vertices[2][1], vertices[2][2], 0) + pixel_pos
				local p3 = Vector3(vertices[3][1], vertices[3][2], 0) + pixel_pos

				is_hover = math.point_is_inside_2d_triangle(cursor_position, p1, p2, p3)
			end
		else
			is_hover = math.point_is_inside_2d_box(cursor_position, pixel_pos, pixel_size)
		end

		ui_content.cursor_hover = is_hover

		local force_hover = ui_content.force_hover

		if force_hover then
			is_hover = true
		end

		local disabled = ui_content.disabled

		if disabled then
			is_hover = false
		end

		local force_disabled = ui_content.force_disabled

		if force_disabled then
			disabled = true
			is_hover = false
		end

		ui_content.gamepad_active = gamepad_active

		if ui_content.on_hover_enter then
			ui_content.on_hover_enter = false
		end

		if ui_content.on_hover_exit then
			ui_content.on_hover_exit = false
		end

		if is_hover and not was_hover then
			ui_content.on_hover_enter = not UIPasses.is_dragging_item
			ui_content.is_hover = not UIPasses.is_dragging_item
			ui_content.internal_is_hover = true
		end

		if was_hover and not is_hover then
			ui_content.is_hover = false
			ui_content.on_hover_exit = true
			ui_content.internal_is_hover = false
		end

		if ui_content.on_pressed then
			ui_content.on_pressed = false
		end

		if is_hover and UIPasses.is_dragging_item then
			is_hover = false
		elseif not is_hover and ui_content.internal_is_hover then
			ui_content.internal_is_hover = false
		end

		local use_is_focused = ui_content.use_is_focused
		local is_selected = use_is_focused and ui_content.is_focused or not use_is_focused and ui_content.is_selected
		local force_input_pressed = ui_content.force_input_pressed
		local pressed_last_frame = ui_content._input_pressed
		local selected_last_frame = ui_content._is_selected
		local focused_last_frame = ui_content._is_focused

		if not gamepad_active and is_hover and not was_hover or gamepad_active and ui_content.is_focused and not focused_last_frame or gamepad_active and is_selected and not selected_last_frame then
			local on_hover_sound = ui_style.on_hover_sound or ui_content.on_hover_sound

			if on_hover_sound then
				local ui_manager = Managers.ui

				if ui_manager then
					ui_manager:play_2d_sound(on_hover_sound)
				end
			end
		end

		local input_pressed, input_released, input_hold = false, false, false

		if force_input_pressed then
			input_pressed = true
			input_hold = pressed_last_frame
			ui_content.force_input_pressed = false
		elseif is_hover then
			input_pressed = input_service and input_service:get("left_pressed")
			input_released = input_service and input_service:get("left_released")
			input_hold = input_service and input_service:get("left_hold")
		elseif is_selected then
			input_pressed = input_service and input_service:get("confirm_pressed")
			input_released = input_service and input_service:get("confirm_released")
			input_hold = input_service and input_service:get("confirm_hold")
		end

		local right_input_pressed = input_service and input_service:get("right_pressed")
		local is_held = false
		local on_pressed = false
		local on_released = false
		local on_right_pressed = false
		local on_double_click = false
		local double_click_timer = ui_content.double_click_timer or 0

		if double_click_timer > 0 then
			double_click_timer = math.max(double_click_timer - dt, 0) or 0
		end

		if (is_hover or gamepad_active and is_selected or force_input_pressed) and not disabled then
			if pressed_last_frame then
				is_held = input_hold

				if input_released then
					on_released = true

					local released_callback = ui_content.released_callback

					if released_callback then
						released_callback()
					end
				end
			elseif input_pressed then
				if double_click_timer > 0 then
					on_double_click = true
					double_click_timer = 0

					local double_click_callback = ui_content.double_click_callback

					if double_click_callback then
						double_click_callback()
					end
				else
					on_pressed = true
					double_click_timer = double_click_threshold

					local pressed_callback = ui_content.pressed_callback

					if pressed_callback then
						pressed_callback()
					end
				end
			elseif right_input_pressed then
				on_pressed = true
				on_right_pressed = true

				local right_pressed_callback = ui_content.right_pressed_callback

				if right_pressed_callback then
					right_pressed_callback()
				end
			end
		end

		if on_pressed and not pressed_last_frame then
			local on_pressed_sound = ui_style.on_pressed_sound or ui_content.on_pressed_sound

			if on_pressed_sound then
				local ui_manager = Managers.ui

				if ui_manager then
					ui_manager:play_2d_sound(on_pressed_sound)
				end
			end
		end

		if on_released and not pressed_last_frame then
			local on_released_sound = ui_style.on_released_sound or ui_content.on_released_sound

			if on_released_sound then
				local ui_manager = Managers.ui

				if ui_manager then
					ui_manager:play_2d_sound(on_released_sound)
				end
			end
		end

		if is_selected and not selected_last_frame then
			local on_select_sound = ui_style.on_select_sound or ui_content.on_select_sound

			if on_select_sound then
				local ui_manager = Managers.ui

				if ui_manager then
					ui_manager:play_2d_sound(on_select_sound)
				end
			end
		end

		ui_content._input_pressed = (is_hover or not not is_selected) and (not not input_pressed or not not input_hold)
		ui_content._is_focused = not not ui_content.is_focused
		ui_content._is_selected = is_selected
		ui_content.is_held = is_held
		ui_content.double_click_timer = double_click_timer
		ui_content.on_released = on_released
		ui_content.on_pressed = on_pressed
		ui_content.on_right_pressed = on_right_pressed
		ui_content.on_double_click = on_double_click

		local anim_hover_speed = ui_style and ui_style.anim_hover_speed

		if anim_hover_speed then
			local anim_hover_progress = ui_content.anim_hover_progress or 0

			if is_hover then
				anim_hover_progress = math.min(anim_hover_progress + dt * anim_hover_speed, 1)
			else
				anim_hover_progress = math.max(anim_hover_progress - dt * anim_hover_speed, 0)
			end

			ui_content.anim_hover_progress = anim_hover_progress
		end

		local anim_input_speed = ui_style and ui_style.anim_input_speed

		if anim_input_speed then
			local anim_input_progress = ui_content.anim_input_progress or 0

			if ui_content._input_pressed then
				anim_input_progress = math.min(anim_input_progress + dt * anim_input_speed, 1)
			else
				anim_input_progress = math.max(anim_input_progress - dt * anim_input_speed, 0)
			end

			ui_content.anim_input_progress = anim_input_progress
		end

		local anim_focus_speed = ui_style and ui_style.anim_focus_speed

		if anim_focus_speed then
			local anim_focus_progress = ui_content.anim_focus_progress or 0
			local parent_content = ui_content.parent or ui_content

			if parent_content.focused or ui_content.is_focused then
				anim_focus_progress = math.min(anim_focus_progress + dt * anim_focus_speed, 1)
			else
				anim_focus_progress = math.max(anim_focus_progress - dt * anim_focus_speed, 0)
			end

			ui_content.anim_focus_progress = anim_focus_progress
		end

		local anim_select_speed = ui_style and ui_style.anim_select_speed

		if anim_select_speed then
			local anim_select_progress = ui_content.anim_select_progress or 0

			if ui_content.is_selected then
				anim_select_progress = math.min(anim_select_progress + dt * anim_select_speed, 1)
			else
				anim_select_progress = math.max(anim_select_progress - dt * anim_select_speed, 0)
			end

			ui_content.anim_select_progress = anim_select_progress
		end
	end,
}
UIPasses.debug_cursor = {
	init = function (pass)
		return nil
	end,
	draw = function (pass, ui_renderer, ui_style, ui_content, position, size)
		local color = ui_content.is_hover and Color.green(255, true) or Color.red(255, true)

		if (ui_content.is_clicked or 10) < 0.5 then
			color = Color.blue(255, true)
		end

		UIRenderer.draw_rect(ui_renderer, position, size, color)
	end,
}

return UIPasses
