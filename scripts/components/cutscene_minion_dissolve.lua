-- chunkname: @scripts/components/cutscene_minion_dissolve.lua

local CutsceneMinionDissolve = component("CutsceneMinionDissolve")
local POSITION_KEY = "wound_position_01"
local MIN_DISSOLVE_RADIUS = 0.01
local HEIGHT_MARGIN = 1.1
local RADIUS_SCALE = 11.25
local DEFAULT_OUT_DURATION = 1
local DEFAULT_IN_DURATION = 1
local DEFAULT_HEIGHT = 2
local MIN_DURATION = 0.01
local DEFAULT_HIDE_ONLY_THRESHOLD = 0.6
local _material_key_ids, _engine_set_wound_position_for_item, _engine_set_wound_material_paramters
local _wound_param_settings = {}
local _resolve_node, _get_shape_scale, _ensure_engine_bindings, _collect_hide_only_units, _parse_item_numbers

CutsceneMinionDissolve.init = function (self, unit)
	if DEDICATED_SERVER then
		return false
	end

	_ensure_engine_bindings()

	self._unit = unit
	self._node = _resolve_node(unit, self:get_data(unit, "node"))
	self._dissolve_hsv = self:get_data(unit, "dissolve_hsv")
	self._shape_mask_uv_offset = self:get_data(unit, "shape_mask_uv_offset")
	self._dissolve_height = math.max(self:get_data(unit, "dissolve_height") or DEFAULT_HEIGHT, 0.01) * HEIGHT_MARGIN
	self._out_duration = math.max(self:get_data(unit, "out_duration") or DEFAULT_OUT_DURATION, MIN_DURATION)
	self._in_duration = math.max(self:get_data(unit, "in_duration") or DEFAULT_IN_DURATION, MIN_DURATION)
	self._hide_only_threshold = math.clamp01(self:get_data(unit, "hide_only_threshold") or DEFAULT_HIDE_ONLY_THRESHOLD)
	self._hide_only_item_paths = _parse_item_numbers(self:get_data(unit, "hide_only_item_numbers"))
	self._hide_only_units = nil
	self._wound = {
		radii = Vector3Box(),
		shape_scales = Vector3Box(),
		shape_mask_uv_offset = Vector3Box(),
		color_brightness_value = Vector3Box(),
		color_time_duration = Vector3Box(),
	}
	self._dissolve_data = nil
	self._pending_direction = nil
	self._direction = nil
	self._playing = false
	self._have_wounds_permutation_set = false

	if self:get_data(unit, "start_hidden") then
		Unit.set_unit_visibility(unit, false, true)
	end

	return true
end

CutsceneMinionDissolve.editor_validate = function (self, unit)
	return true, ""
end

CutsceneMinionDissolve.enable = function (self, unit)
	return
end

CutsceneMinionDissolve.disable = function (self, unit)
	return
end

CutsceneMinionDissolve.destroy = function (self, unit)
	if DEDICATED_SERVER then
		return
	end

	self:restore_solid()
end

CutsceneMinionDissolve.start_dematerialize = function (self)
	if DEDICATED_SERVER then
		return false
	end

	self:_ensure_have_wounds_permutation()
	self:_ensure_hide_only_units()

	self._pending_direction = "out"

	return true
end

CutsceneMinionDissolve.start_materialize = function (self)
	if DEDICATED_SERVER then
		return false
	end

	self:_ensure_have_wounds_permutation()
	self:_ensure_hide_only_units()

	self._pending_direction = "in"

	return true
end

CutsceneMinionDissolve.restore_solid = function (self)
	if DEDICATED_SERVER then
		return false
	end

	self._pending_direction = nil
	self._direction = nil
	self._playing = false

	local unit = self._unit

	if not unit or not Unit.alive(unit) then
		self._dissolve_data = nil

		return true
	end

	if self._dissolve_data then
		local wound = self._wound

		wound.radii[1] = MIN_DISSOLVE_RADIUS
		wound.shape_scales[1] = _get_shape_scale(MIN_DISSOLVE_RADIUS)

		self:_apply_wound_materials(unit)

		self._dissolve_data = nil
	end

	Unit.set_unit_visibility(unit, true, true)

	local hide_only_units = self._hide_only_units

	if hide_only_units then
		for i = 1, #hide_only_units do
			local hide_only_unit = hide_only_units[i]

			if Unit.alive(hide_only_unit) then
				Unit.set_unit_visibility(hide_only_unit, true, true)
			end
		end
	end

	return true
end

CutsceneMinionDissolve.update = function (self, unit, dt, t)
	local pending_direction = self._pending_direction

	if pending_direction then
		self._pending_direction = nil

		local reverted = pending_direction == "in"
		local duration = reverted and self._in_duration or self._out_duration

		if reverted then
			Unit.set_unit_visibility(unit, true, true)
		end

		self._dissolve_data = self:_start_dissolve(unit, t, reverted, duration)
		self._direction = pending_direction
		self._playing = true
	end

	if not self._playing then
		return true
	end

	local is_done = self:_update_dissolve(unit, t)

	if not is_done then
		return true
	end

	self._playing = false

	if self._direction == "out" then
		Unit.set_unit_visibility(unit, false, true)
	end

	self._direction = nil

	return true
end

CutsceneMinionDissolve._ensure_have_wounds_permutation = function (self)
	if self._have_wounds_permutation_set then
		return
	end

	self._have_wounds_permutation_set = true

	Unit.set_permutation_for_materials(self._unit, "HAVE_WOUNDS", true, true)
end

CutsceneMinionDissolve._ensure_hide_only_units = function (self)
	if self._hide_only_units then
		return self._hide_only_units
	end

	local hide_only_units = {}

	_collect_hide_only_units(self._unit, hide_only_units, self._hide_only_item_paths, nil, false)

	self._hide_only_units = hide_only_units

	return hide_only_units
end

CutsceneMinionDissolve._start_dissolve = function (self, unit, t, reverted, duration)
	local dissolve_height = self._dissolve_height
	local max_dissolve_radius = dissolve_height * RADIUS_SCALE
	local start_radius = reverted and max_dissolve_radius or MIN_DISSOLVE_RADIUS
	local wound = self._wound

	wound.radii[1] = start_radius
	wound.shape_scales[1] = _get_shape_scale(start_radius)

	local uv_offset = self._shape_mask_uv_offset:unbox()

	wound.shape_mask_uv_offset:store(Vector2(uv_offset.x, uv_offset.y))
	wound.color_brightness_value:store(self._dissolve_hsv:unbox())
	wound.color_time_duration:store(Vector2(t, math.huge))
	self:_apply_wound_materials(unit)

	return {
		reverted = reverted,
		max_dissolve_radius = max_dissolve_radius,
		start_t = t,
		duration = duration,
		done_t = t + duration,
	}
end

CutsceneMinionDissolve._update_dissolve = function (self, unit, t)
	local dissolve_data = self._dissolve_data

	if not dissolve_data then
		return true
	end

	local reverted = dissolve_data.reverted
	local max_dissolve_radius = dissolve_data.max_dissolve_radius
	local from_radius = reverted and max_dissolve_radius or MIN_DISSOLVE_RADIUS
	local to_radius = reverted and MIN_DISSOLVE_RADIUS or max_dissolve_radius
	local lerp_t = math.clamp01((t - dissolve_data.start_t) / dissolve_data.duration)
	local radius = math.lerp(from_radius, to_radius, lerp_t)
	local wound = self._wound

	wound.radii[1] = radius
	wound.shape_scales[1] = _get_shape_scale(radius)

	self:_apply_wound_materials(unit)

	local node_pos = Unit.local_position(unit, self._node)

	Unit.set_vector3_for_materials(unit, POSITION_KEY, node_pos, true)
	_engine_set_wound_position_for_item(unit, _material_key_ids.position, node_pos)
	self:_apply_hide_only_visibility(reverted, lerp_t)

	return t > dissolve_data.done_t
end

CutsceneMinionDissolve._apply_hide_only_visibility = function (self, reverted, lerp_t)
	local units = self._hide_only_units

	if not units or #units == 0 then
		return
	end

	local threshold = reverted and 1 - self._hide_only_threshold or self._hide_only_threshold
	local visible

	if reverted then
		visible = threshold <= lerp_t
	else
		visible = lerp_t < threshold
	end

	for i = 1, #units do
		local hide_only_unit = units[i]

		if Unit.alive(hide_only_unit) then
			Unit.set_unit_visibility(hide_only_unit, visible, true)
		end
	end
end

CutsceneMinionDissolve._apply_wound_materials = function (self, unit)
	local wound = self._wound
	local params = _wound_param_settings

	params[3] = wound.shape_mask_uv_offset
	params[6] = wound.color_brightness_value
	params[9] = wound.color_time_duration
	params[12] = wound.radii
	params[15] = wound.shape_scales

	_engine_set_wound_material_paramters(unit, params, true)
end

function _resolve_node(unit, node_data)
	local node_index = tonumber(node_data)

	if node_index then
		return node_index
	end

	if node_data and node_data ~= "" and Unit.has_node(unit, node_data) then
		return Unit.node(unit, node_data)
	end

	return 1
end

function _get_shape_scale(radius)
	return 1 / (0.1 * radius) * 0.99
end

function _collect_hide_only_units(unit, out, hide_only_paths, current_path, inherited_hide_only)
	local i = 1
	local found = 0
	local total = Unit.data_table_size(unit, "attached_items") or 0

	while found < total do
		local attached_unit = Unit.get_data(unit, "attached_items", i)

		if attached_unit then
			found = found + 1

			if Unit.alive(attached_unit) then
				local path = current_path and current_path .. "." .. i or tostring(i)
				local is_hide_only = inherited_hide_only or hide_only_paths[path] == true

				if is_hide_only then
					out[#out + 1] = attached_unit
				end

				_collect_hide_only_units(attached_unit, out, hide_only_paths, path, is_hide_only)
			end
		end

		i = i + 1
	end
end

function _parse_item_numbers(item_paths_text)
	local paths = {}

	if not item_paths_text or item_paths_text == "" then
		return paths
	end

	for chunk in item_paths_text:gmatch("[^,]+") do
		paths[chunk:match("^%s*(.-)%s*$")] = true
	end

	return paths
end

function _ensure_engine_bindings()
	if _material_key_ids then
		return
	end

	_material_key_ids = {
		shape = Script.id_string_32("wound_01_shape"),
		color_brightness = Script.id_string_32("wound_color_brightness_01"),
		color_time_duration = Script.id_string_32("wound_color_time_duration_01"),
		radius = Script.id_string_32("wound_radius_01"),
		shape_scale = Script.id_string_32("wound_shape_scaling_01"),
		position = Script.id_string_32(POSITION_KEY),
	}
	_engine_set_wound_position_for_item = EngineOptimized.set_wound_position_for_unit
	_engine_set_wound_material_paramters = EngineOptimized.set_wound_material_paramters
	_wound_param_settings[1] = _material_key_ids.shape
	_wound_param_settings[2] = 1
	_wound_param_settings[4] = _material_key_ids.color_brightness
	_wound_param_settings[5] = 1
	_wound_param_settings[7] = _material_key_ids.color_time_duration
	_wound_param_settings[8] = 1
	_wound_param_settings[10] = _material_key_ids.radius
	_wound_param_settings[11] = 2
	_wound_param_settings[13] = _material_key_ids.shape_scale
	_wound_param_settings[14] = 2
end

CutsceneMinionDissolve.component_data = {
	node = {
		ui_name = "Node",
		ui_type = "text_box",
		value = "1",
	},
	start_hidden = {
		ui_name = "Start Hidden",
		ui_type = "check_box",
		value = false,
	},
	dissolve_height = {
		category = "Dissolve",
		decimals = 2,
		max = 10,
		min = 0.1,
		ui_name = "Dissolve Height",
		ui_type = "number",
		value = 2,
	},
	out_duration = {
		category = "Dissolve",
		decimals = 2,
		max = 10,
		min = 0.01,
		ui_name = "Dematerialize Duration",
		ui_type = "number",
		value = 1,
	},
	in_duration = {
		category = "Dissolve",
		decimals = 2,
		max = 10,
		min = 0.01,
		ui_name = "Materialize Duration",
		ui_type = "number",
		value = 1,
	},
	dissolve_hsv = {
		category = "Dissolve",
		step = 0.01,
		ui_name = "Dissolve Tint HSV",
		ui_type = "vector",
		value = Vector3Box(0.5, 0.5, 0.5),
	},
	shape_mask_uv_offset = {
		category = "Dissolve",
		step = 0.01,
		ui_name = "Shape Mask UV Offset",
		ui_type = "vector",
		value = Vector3Box(0.5, 0.75, 0),
	},
	hide_only_item_numbers = {
		category = "Dissolve",
		ui_name = "Hide-Only Item Numbers",
		ui_type = "text_box",
		value = "",
	},
	hide_only_threshold = {
		category = "Dissolve",
		decimals = 2,
		max = 1,
		min = 0,
		ui_name = "Hide-Only Threshold",
		ui_type = "number",
		value = 0.6,
	},
	inputs = {
		start_dematerialize = {
			accessibility = "public",
			type = "event",
		},
		start_materialize = {
			accessibility = "public",
			type = "event",
		},
		restore_solid = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {},
}

return CutsceneMinionDissolve
