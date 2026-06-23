-- chunkname: @scripts/components/cryptic_character_create_voice_screen.lua

local CrypticCharacterCreateVoiceScreen = component("CrypticCharacterCreateVoiceScreen")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local MATRIX_X = 1
local MATRIX_Y = 2
local SLIDER_X = 3
local _format_value

CrypticCharacterCreateVoiceScreen.init = function (self, unit)
	self._active = false
	self._unit = unit
	self._mesh_name = "g_screen_big"
	self._material_slot_name = "cogitator_voice_screen_01"

	local world_name = "voice_screen_ui_world"
	local parameters = {
		layer = 20,
		timer_name = "ui",
	}
	local flags = {
		Application.DISABLE_PHYSICS,
	}
	local world_manager = Managers.world
	local world = world_manager:create_world(world_name, parameters, unpack(flags))

	self._ui_world = world

	local gui = World.create_gui(world, {
		height = 512,
		immediate = true,
		use_custom_dimension = true,
		width = 512,
	})

	self._gui = gui

	local ignore_back_buffer = true
	local width = 512
	local height = 512
	local reference_name = "voice_screen_render_target_" .. string.gsub(tostring(self), "table: ", "")
	local render_target = Renderer.create_resource("render_target", "R8G8B8A8", not ignore_back_buffer and "back_buffer" or nil, width, height, reference_name)

	self._render_target = render_target
	self._render_target_name = reference_name

	local viewport_type = "overlay"
	local viewport_layer = 1
	local viewport_name = "voice_screen_viewport"
	local shading_environment_name = GameParameters.default_ui_shading_environment
	local viewport = ScriptWorld.create_viewport(world, viewport_name, viewport_type, viewport_layer, nil, nil, nil, nil, shading_environment_name, nil, nil, render_target)
	local screen_mesh = Unit.mesh(self._unit, self._mesh_name)
	local material_instance = screen_mesh and Mesh.material(screen_mesh, self._material_slot_name)

	Material.set_resource(material_instance, "source", render_target)

	local font_type = "mono_tide_regular"
	local font_data = UIFonts.data_by_type(font_type)
	local font = font_data.path
	local font_flags = font_data.render_flags or 0

	self._font = font
	self._font_flags = font_flags + Gui.RenderPass
	self._vox_effect_index_lookup = {}
	self._output_texts = {}
	self._font_sizes = {}
	self._text_buffers = {}
	self._time = 0
	self._interval = 0.05
	self._text_buffer_index = 1
	self._text_offsets = {}
	self._caret_time = 0
	self._caret_interval = 0.5
	self._caret_state = true
	self._caret_flashing_active = false
	self._mod_anim_time = 0
	self._mod_anim_duration = self._interval * 20
	self._mod_anim_state = false

	return true
end

CrypticCharacterCreateVoiceScreen.init_texts = function (self, matrix_x, matrix_y, slider_x)
	if #self._text_buffers > 0 then
		return
	end

	self:_init_texts(matrix_x, matrix_y, slider_x)
end

local HEADER_FONT_SIZE = 28
local VALUE_FONT_SIZE = 26
local FONT_SIZE = 22

CrypticCharacterCreateVoiceScreen._init_texts = function (self, matrix_x, matrix_y, slider_x)
	self:_add_text_to_buffer("VOX UNIT MODULATION", HEADER_FONT_SIZE, {
		5,
		15,
	})

	self._start_anim_index = self:_add_text_to_buffer("BINHARIC ATTUNEMENT:", FONT_SIZE, {
		5,
		235,
	})
	self._vox_effect_index_lookup[MATRIX_X] = self:_add_text_to_buffer(_format_value(MATRIX_X, matrix_x), VALUE_FONT_SIZE, {
		5,
		265,
	})

	self:_add_text_to_buffer("ARRAY DEPTH:", FONT_SIZE, {
		5,
		305,
	})

	self._vox_effect_index_lookup[MATRIX_Y] = self:_add_text_to_buffer(_format_value(MATRIX_Y, matrix_y), VALUE_FONT_SIZE, {
		5,
		335,
	})

	self:_add_text_to_buffer("DECRYPTION COMPLEXITY:", FONT_SIZE, {
		5,
		375,
	})

	self._vox_effect_index_lookup[SLIDER_X] = self:_add_text_to_buffer(_format_value(SLIDER_X, slider_x), VALUE_FONT_SIZE, {
		5,
		405,
	})
end

CrypticCharacterCreateVoiceScreen.set_matrix_x_value = function (self, value)
	self:_set_value_text(MATRIX_X, value)
end

CrypticCharacterCreateVoiceScreen.set_matrix_y_value = function (self, value)
	self:_set_value_text(MATRIX_Y, value)
end

CrypticCharacterCreateVoiceScreen.set_slider_x_value = function (self, value)
	self:_set_value_text(SLIDER_X, value)
end

CrypticCharacterCreateVoiceScreen._set_value_text = function (self, index, value)
	local index_lookup = self._vox_effect_index_lookup[index]

	self._output_texts[index_lookup] = _format_value(index, value)
end

CrypticCharacterCreateVoiceScreen._add_text_to_buffer = function (self, text, font_size, offset)
	self._font_sizes[#self._font_sizes + 1] = font_size
	self._text_offsets[#self._text_offsets + 1] = offset

	local input_text = text:reverse()
	local text_length = string.len(input_text)
	local text_buffer = {}

	for ii = 1, text_length do
		text_buffer[ii] = string.sub(input_text, ii, ii)
	end

	self._text_buffers[#self._text_buffers + 1] = text_buffer

	return #self._text_buffers
end

CrypticCharacterCreateVoiceScreen.editor_init = function (self, unit)
	return
end

CrypticCharacterCreateVoiceScreen.enable = function (self, unit)
	return
end

CrypticCharacterCreateVoiceScreen.disable = function (self, unit)
	return
end

CrypticCharacterCreateVoiceScreen.destroy = function (self, unit)
	if self._render_target then
		Renderer.destroy_resource(self._render_target)

		self._render_target = nil
	end

	if self._ui_world then
		if self._gui then
			World.destroy_gui(self._ui_world, self._gui)
		end

		ScriptWorld.destroy_viewport(self._ui_world, "voice_screen_viewport")
		Managers.world:destroy_world(self._ui_world)
	end
end

CrypticCharacterCreateVoiceScreen.editor_validate = function (self, unit)
	return true, ""
end

CrypticCharacterCreateVoiceScreen.update = function (self, unit, dt, t)
	local gui = self._gui
	local render_target = self._render_target
	local render_target_name = self._render_target_name

	if not render_target then
		return true
	end

	if not self._active then
		return true
	end

	Gui.render_pass(gui, 0, render_target_name, true, render_target)

	local font = self._font
	local font_options = {
		snap_pixel_positions = true,
		render_pass = render_target_name,
		color = Color(255, 0, 255, 76.5),
		flags = self._font_flags,
	}

	self._time = self._time + dt

	local buffer_index = self._text_buffer_index

	if self._time >= self._interval and buffer_index <= #self._text_buffers then
		self._time = 0

		local text_buffer = self._text_buffers[buffer_index]
		local text = text_buffer[#text_buffer]

		if self._output_texts[buffer_index] == nil then
			self._output_texts[buffer_index] = ""
		end

		self._output_texts[buffer_index] = self._output_texts[buffer_index] .. text
		text_buffer[#text_buffer] = nil

		if #text_buffer == 0 then
			self._text_buffer_index = self._text_buffer_index + 1
		end
	end

	if buffer_index > #self._text_buffers then
		self._caret_flashing_active = true
	end

	for ii = 1, #self._output_texts do
		local text = self._output_texts[ii]
		local font_size = self._font_sizes[ii]
		local offset = self._text_offsets[ii]

		if text ~= nil then
			Gui2.slug_text(gui, text, font, font_size, Vector3(25 + offset[1], 35 + offset[2], 2), Vector2(512, 512), font_options)
		end
	end

	if self._caret_flashing_active then
		self._caret_time = self._caret_time + dt

		if self._caret_time >= self._caret_interval then
			self._caret_time = 0
			self._caret_state = not self._caret_state
		end
	end

	if self._caret_state then
		local text = self._output_texts[#self._output_texts]
		local font_size = self._font_sizes[#self._output_texts]
		local offset = self._text_offsets[#self._output_texts]
		local optional_args = {}

		if text then
			local _, _, caret = Gui2.slug_text_extents(gui, text, font, font_size, optional_args)

			Gui2.slug_text(gui, "|", self._font, font_size, Vector3(offset[1] + caret.x + 25, 35 + offset[2], 2), Vector2(512, 512), font_options)
		end
	end

	if self._mod_anim_state then
		local progress = self._mod_anim_time / self._mod_anim_duration

		Unit.set_scalar_for_materials(unit, "mods_visibility", progress)

		self._mod_anim_time = self._mod_anim_time + dt

		if self._mod_anim_time > self._mod_anim_duration then
			self._mod_anim_state = false
		end
	end

	if self._start_anim_index == buffer_index then
		self._mod_anim_state = true
	end

	return true
end

CrypticCharacterCreateVoiceScreen.editor_update = function (self, unit, dt, t)
	return
end

CrypticCharacterCreateVoiceScreen.start = function (self)
	self._active = true
end

CrypticCharacterCreateVoiceScreen.stop = function (self)
	self._active = false
end

CrypticCharacterCreateVoiceScreen.reset = function (self)
	self._active = false

	table.clear(self._output_texts)
	table.clear(self._text_buffers)

	self._text_buffer_index = 1

	self:_init_texts(0, 0, 0)

	self._mod_anim_time = 0
	self._mod_anim_state = false

	Unit.set_scalar_for_materials(self._unit, "mods_visibility", 0)
end

local FORMAT_STRINGS = {
	[MATRIX_X] = "%.2f index",
	[MATRIX_Y] = "%.1f mm",
	[SLIDER_X] = "%d%%",
}
local VALUE_TRANSFORM_FUNCS = {
	[MATRIX_X] = function (value)
		return value
	end,
	[MATRIX_Y] = function (value)
		return math.lerp(0, 10, value)
	end,
	[SLIDER_X] = function (value)
		local epsilon = 1e-06

		return (value + epsilon) * 100
	end,
}

function _format_value(index, value)
	return string.format(FORMAT_STRINGS[index], VALUE_TRANSFORM_FUNCS[index](value / 100))
end

CrypticCharacterCreateVoiceScreen.component_data = {
	inputs = {
		start = {
			accessibility = "public",
			type = "event",
		},
		stop = {
			accessibility = "public",
			type = "event",
		},
		reset = {
			accessibility = "public",
			type = "event",
		},
	},
}

return CrypticCharacterCreateVoiceScreen
