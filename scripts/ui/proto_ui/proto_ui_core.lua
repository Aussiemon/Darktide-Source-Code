local ProtoUI = require("scripts/ui/proto_ui/proto_ui")
local V2 = Vector2
local V3 = Vector3

ProtoUI.begin_frame = function (gui, dt, t, input_service)
	Profiler.start("ProtoUI.frame")

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
	ProtoUI.mouse_cursor = input_service:get("cursor")
	ProtoUI.keystrokes = Keyboard.keystrokes(ProtoUI.keystrokes)
	ProtoUI.dt = dt
	ProtoUI.t = t
	ProtoUI.input_service = input_service
end

ProtoUI.end_frame = function ()
	ProtoUI.gui = nil
	ProtoUI.input_service = nil

	assert(ProtoUI.data_node == ProtoUI.DATA_ROOT, "Mismatched begin/end group calls")
	Profiler.stop("ProtoUI.frame")
end

ProtoUI.play_sound = function (event_name)
	return Managers.ui:play_2d_sound(event_name)
end

local math_floor = math.floor

local function TRANSFORM_pos(pos)
	local offset = ProtoUI.offset
	local scale = ProtoUI.scale

	return V3(math_floor(pos[1] * scale + offset[1]), math_floor(pos[2] * scale + offset[2]), pos[3] + offset[3])
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
	return Gui_rect(ProtoUI.gui, TRANSFORM_pos(pos), TRANSFORM_size(size), color)
end

ProtoUI.draw_bitmap = function (material, pos, size, color)
	return Gui_bitmap(ProtoUI.gui, material, TRANSFORM_pos(pos), TRANSFORM_size(size), color)
end

ProtoUI.draw_bitmap_uv = function (material, uv00, uv11, pos, size, color)
	return Gui_bitmap_uv(ProtoUI.gui, material, uv00, uv11, TRANSFORM_pos(pos), TRANSFORM_size(size), color)
end

ProtoUI.draw_text = function (text, font, font_size, pos, size, color, ...)
	return Gui_slug_text(ProtoUI.gui, text, font, TRANSFORM_font(font_size), TRANSFORM_pos(pos), TRANSFORM_size(size), color, ...)
end

return ProtoUI
