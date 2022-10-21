local UIResolution = require("scripts/managers/ui/ui_resolution")
local ProtoUI = require("scripts/ui/proto_ui/proto_ui")
local Gui = Gui
local V2 = Vector2
local V3 = Vector3

ProtoUI.begin_frame = function (gui, dt, t, input_service)
	ProtoUI.gui = gui
	local w, h = Gui.resolution()
	ProtoUI.resolution = V2(w, h)
	local canvas = V2(1920, 1080)
	ProtoUI.canvas_size = canvas
	local scale = math.min(w / canvas[1], h / canvas[2])
	local inv_scale = 1 / scale
	ProtoUI.scale = scale
	ProtoUI.inverse_scale = inv_scale
	ProtoUI.offset = V3(0.5 * (w - canvas[1] * scale), 0.5 * (h - canvas[2] * scale), 0)
	ProtoUI.screen_size = V2(w * inv_scale, h * inv_scale)
	ProtoUI.screen_pos = -ProtoUI.offset * ProtoUI.inverse_scale
	ProtoUI.screen_cursor = input_service:get("cursor")
	ProtoUI.software_screen_cursor = UIResolution.scale_vector(ProtoUI.screen_cursor, scale)
	ProtoUI.canvas_cursor = ProtoUI.screen_cursor * inv_scale + ProtoUI.screen_pos
	ProtoUI.keystrokes = Keyboard.keystrokes(ProtoUI.keystrokes)
	ProtoUI.dt = dt
	ProtoUI.t = t
	ProtoUI.input_service = input_service

	Gui.render_pass(gui, 10, "to_screen", false)

	ProtoUI.render_pass = "to_screen"
end

ProtoUI.end_frame = function ()
	ProtoUI.gui = nil
	ProtoUI.input_service = nil
end

ProtoUI.play_sound = function (event_name)
	return Managers.ui:play_2d_sound(event_name)
end

local function TRANSFORM_pos(pos)
	local offset = ProtoUI.offset
	local scale = ProtoUI.scale

	return V3(pos[1] * scale + offset[1], pos[2] * scale + offset[2], pos[3] + offset[3])
end

local function TRANSFORM_size(size)
	return ProtoUI.scale * size
end

local function TRANSFORM_font(font_size)
	return math.max(4, ProtoUI.scale * font_size)
end

ProtoUI.transform_position = TRANSFORM_pos
local Gui_rect = Gui.rect
local Gui_slug_text = Gui.slug_text
local Gui_bitmap = Gui.bitmap
local Gui_bitmap_uv = Gui.bitmap_uv

ProtoUI.draw_rect = function (pos, size, color)
	return Gui_rect(ProtoUI.gui, "render_pass", ProtoUI.render_pass, TRANSFORM_pos(pos), TRANSFORM_size(size), color)
end

ProtoUI.draw_bitmap = function (material, pos, size, color)
	return Gui_bitmap(ProtoUI.gui, material, GuiMaterialFlag.GUI_RENDER_PASS_LAYER, "render_pass", ProtoUI.render_pass, TRANSFORM_pos(pos), TRANSFORM_size(size), color)
end

ProtoUI.draw_bitmap_uv = function (material, uv00, uv11, pos, size, color)
	return Gui_bitmap_uv(ProtoUI.gui, material, GuiMaterialFlag.GUI_RENDER_PASS_LAYER, uv00, uv11, "render_pass", ProtoUI.render_pass, TRANSFORM_pos(pos), TRANSFORM_size(size), color)
end

ProtoUI.draw_text = function (text, font, font_size, pos, size, color, ...)
	return Gui_slug_text(ProtoUI.gui, text, font, TRANSFORM_font(font_size), "render_pass", ProtoUI.render_pass, TRANSFORM_pos(pos), TRANSFORM_size(size), color, "flags", Gui.RenderPass, "material_flags", GuiMaterialFlag.GUI_RENDER_PASS_LAYER, ...)
end

ProtoUI.make_render_pass = function (order, name, clear, render_target)
	Gui.render_pass(ProtoUI.gui, order, name, clear, render_target)
end

ProtoUI.set_render_pass = function (name)
	local old = ProtoUI.render_pass
	ProtoUI.render_pass = name

	return old
end

ProtoUI.fonts = {
	proxima_nova_bold = {
		"content/ui/fonts/proxima_nova_bold",
		"content/ui/fonts/darktide_custom_regular"
	},
	proxima_nova_medium = {
		"content/ui/fonts/proxima_nova_medium",
		"content/ui/fonts/darktide_custom_regular"
	},
	itc_novarese_bold = {
		"content/ui/fonts/itc_novarese_bold",
		"content/ui/fonts/darktide_custom_regular"
	}
}

return ProtoUI
