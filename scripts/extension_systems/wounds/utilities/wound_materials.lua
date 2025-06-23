-- chunkname: @scripts/extension_systems/wounds/utilities/wound_materials.lua

local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local _engine_optimized_set_wound_position_for_item = EngineOptimized.set_wound_position_for_unit
local _engine_optimized_set_wound_material_paramters = EngineOptimized.set_wound_material_paramters
local SHAPE_MASKS = WoundsSettings.masks
local SHAPE_INVERSIONS = WoundsSettings.shape_inversions
local NUM_MAX_WOUNDS = 3
local NUM_RADIUS_ENTRIES = 3
local NUM_RADIUS_KEYS = NUM_MAX_WOUNDS / NUM_RADIUS_ENTRIES
local RADIUS_KEY = "wound_radius_0%d"
local RADIUS_KEYS = Script.new_array(NUM_RADIUS_KEYS)
local RADIUS_KEY_IDS = Script.new_array(NUM_RADIUS_KEYS)

for i = 1, NUM_RADIUS_KEYS do
	local radius_key = string.format(RADIUS_KEY, i)

	RADIUS_KEYS[i] = radius_key
	RADIUS_KEY_IDS[i] = Script.id_string_32(radius_key)
end

local NUM_SHAPE_SCALE_ENTRIES = 3
local NUM_SHAPE_SCALE_KEYS = NUM_MAX_WOUNDS / NUM_SHAPE_SCALE_ENTRIES
local SHAPE_SCALE_KEY = "wound_shape_scaling_0%d"
local SHAPE_SCALE_KEYS = Script.new_array(NUM_SHAPE_SCALE_KEYS)
local SHAPE_SCALE_KEY_IDS = Script.new_array(NUM_SHAPE_SCALE_KEYS)

for i = 1, NUM_SHAPE_SCALE_KEYS do
	local shape_scale_key = string.format(SHAPE_SCALE_KEY, i)

	SHAPE_SCALE_KEYS[i] = shape_scale_key
	SHAPE_SCALE_KEY_IDS[i] = Script.id_string_32(shape_scale_key)
end

local POSITION_KEY = "wound_position_0%d"
local POSITION_KEYS = Script.new_array(NUM_MAX_WOUNDS)
local POSITION_KEY_IDS = Script.new_map(NUM_MAX_WOUNDS)
local SHAPE_KEY = "wound_0%d_shape"
local SHAPE_KEYS = Script.new_array(NUM_MAX_WOUNDS)
local SHAPE_KEY_IDS = Script.new_array(NUM_MAX_WOUNDS)
local COLOR_BRIGHTNESS_KEY = "wound_color_brightness_0%d"
local COLOR_BRIGHTNESS_KEYS = Script.new_array(NUM_MAX_WOUNDS)
local COLOR_BRIGHTNESS_KEY_IDS = Script.new_array(NUM_MAX_WOUNDS)
local COLOR_TIME_DURATION_KEY = "wound_color_time_duration_0%d"
local COLOR_TIME_DURATION_KEYS = Script.new_array(NUM_MAX_WOUNDS)
local COLOR_TIME_DURATION_KEY_IDS = Script.new_array(NUM_MAX_WOUNDS)

for i = 1, NUM_MAX_WOUNDS do
	local position_key = string.format(POSITION_KEY, i)

	POSITION_KEYS[i] = position_key
	POSITION_KEY_IDS[i] = Script.id_string_32(position_key)

	local shape_key = string.format(SHAPE_KEY, i)

	SHAPE_KEYS[i] = shape_key
	SHAPE_KEY_IDS[i] = Script.id_string_32(shape_key)

	local color_brightness_key = string.format(COLOR_BRIGHTNESS_KEY, i)

	COLOR_BRIGHTNESS_KEYS[i] = color_brightness_key
	COLOR_BRIGHTNESS_KEY_IDS[i] = Script.id_string_32(color_brightness_key)

	local color_time_duration_key = string.format(COLOR_TIME_DURATION_KEY, i)

	COLOR_TIME_DURATION_KEYS[i] = color_time_duration_key
	COLOR_TIME_DURATION_KEY_IDS[i] = Script.id_string_32(color_time_duration_key)
end

local wound_param_settings = {
	SHAPE_KEY_IDS[1],
	1,
	"shape_mask_uv_offset",
	COLOR_BRIGHTNESS_KEY_IDS[1],
	1,
	"color_brightness_value",
	COLOR_TIME_DURATION_KEY_IDS[1],
	1,
	"color_time_duration",
	RADIUS_KEY_IDS[1],
	2,
	"radii",
	SHAPE_SCALE_KEY_IDS[1],
	2,
	"shape_scales"
}
local WoundMaterials = {}

WoundMaterials.create_data = function ()
	local radii = Script.new_array(NUM_RADIUS_KEYS)

	for i = 1, NUM_RADIUS_KEYS do
		local key = RADIUS_KEYS[i]

		radii[key] = Vector3Box()
	end

	local shape_scales = Script.new_array(NUM_SHAPE_SCALE_KEYS)

	for i = 1, NUM_SHAPE_SCALE_KEYS do
		local key = SHAPE_SCALE_KEYS[i]

		shape_scales[key] = Vector3Box()
	end

	local wounds_data = Script.new_array(NUM_MAX_WOUNDS)

	for wound_index = 1, NUM_MAX_WOUNDS do
		local radius_key_index = math.ceil(wound_index / NUM_RADIUS_ENTRIES)
		local radius_material_key = RADIUS_KEYS[radius_key_index]
		local radius_index = (wound_index - 1) % NUM_RADIUS_ENTRIES + 1
		local shape_scale_key_index = math.ceil(wound_index / NUM_SHAPE_SCALE_ENTRIES)
		local shape_scale_material_key = SHAPE_SCALE_KEYS[shape_scale_key_index]
		local shape_scale_index = (wound_index - 1) % NUM_SHAPE_SCALE_ENTRIES + 1
		local shape_mask_material_key_id = SHAPE_KEY_IDS[wound_index]
		local color_time_duration_material_key = COLOR_TIME_DURATION_KEY_IDS[wound_index]
		local color_brightness_material_key_id = COLOR_BRIGHTNESS_KEY_IDS[wound_index]

		wounds_data[wound_index] = {
			hit_shader_vector = Vector3Box(),
			radii = radii[radius_material_key],
			radius_index = radius_index,
			radius_material_key = radius_material_key,
			radius_material_key_id = RADIUS_KEY_IDS[radius_key_index],
			shape_mask_material_key_id = shape_mask_material_key_id,
			color_time_duration_material_key_id = color_time_duration_material_key,
			color_brightness_material_key_id = color_brightness_material_key_id,
			shape_scales = shape_scales[shape_scale_material_key],
			shape_scale_index = shape_scale_index,
			shape_scale_material_key = shape_scale_material_key,
			shape_scale_material_key_id = SHAPE_SCALE_KEY_IDS[shape_scale_key_index],
			shape_mask_uv_offset = Vector3Box(),
			color_brightness_value = Vector3Box(),
			color_time_duration = Vector3Box()
		}
	end

	wounds_data.last_write_index = 0
	wounds_data.num_wounds = 0

	return wounds_data, NUM_MAX_WOUNDS
end

WoundMaterials.calculate = function (unit, wounds_config_or_nil, wounds_data, wound_index, wound_settings, wound_shape, hit_actor_node_index, hit_actor_bind_pose, hit_world_position, start_time)
	local wound_data = wounds_data[wound_index]
	local unit_world_pose = Unit.world_pose(unit, hit_actor_node_index)
	local hit_local_position = Matrix4x4.transform(Matrix4x4.inverse(unit_world_pose), hit_world_position)
	local hit_shader_vector = Matrix4x4.transform(hit_actor_bind_pose, hit_local_position)

	wound_data.hit_shader_vector:store(hit_shader_vector)

	local unit_position = Unit.world_position(unit, 1)
	local direction = Vector3.normalize(hit_world_position - unit_position)
	local rotation = Unit.world_rotation(unit, 1)
	local forward = Quaternion.forward(rotation)
	local dot = Vector3.dot(forward, direction)
	local is_behind = dot < 0

	if is_behind and SHAPE_INVERSIONS[wound_shape] then
		wound_shape = SHAPE_INVERSIONS[wound_shape]
	end

	local wound_radius = wound_settings.radius

	if type(wound_radius) == "table" then
		wound_radius = math.random_range(wound_radius[1], wound_radius[2])
	end

	if wounds_config_or_nil and wounds_config_or_nil.radius_multiplier then
		wound_radius = wound_radius * wounds_config_or_nil.radius_multiplier
	end

	local radii, radius_index = wound_data.radii, wound_data.radius_index

	radii[radius_index] = wound_radius

	local mask = SHAPE_MASKS[wound_shape]
	local shape_mask_uv_offset = Vector2(mask[1], mask[2])

	wound_data.shape_mask_uv_offset:store(shape_mask_uv_offset)

	local shape_scaling = wound_settings.shape_scaling
	local shape_scales, shape_scale_index = wound_data.shape_scales, wound_data.shape_scale_index

	if shape_scaling then
		shape_scales[shape_scale_index] = 1
	else
		shape_scales[shape_scale_index] = 0
	end

	local color_brightness_values = wound_settings.color_brightness
	local color_brightness_value = Vector2(color_brightness_values[1], color_brightness_values[2])

	wound_data.color_brightness_value:store(color_brightness_value)

	local duration = wound_settings.duration

	if type(duration) == "table" then
		duration = math.random_range(duration[1], duration[2])
	end

	local color_time_duration = Vector2(start_time, duration)

	wound_data.color_time_duration:store(color_time_duration)
end

local EMPTY_TABLE, INCLUDE_CHILDREN, DO_NOT_INCLUDE_CHILDREN = {}, true, false

WoundMaterials.apply = function (unit, wounds_data, optional_index, optional_slot_items, optional_inverse_root_node_bind_pose)
	local slot_items = optional_slot_items or EMPTY_TABLE
	local start_index = optional_index or 1
	local start_index, end_index = start_index, optional_index or wounds_data.num_wounds

	for wound_index = start_index, end_index do
		local wound_data = wounds_data[wound_index]
		local position_material_key, hit_shader_vector = POSITION_KEYS[wound_index], wound_data.hit_shader_vector:unbox()

		if optional_inverse_root_node_bind_pose then
			hit_shader_vector = Matrix4x4.transform(optional_inverse_root_node_bind_pose, hit_shader_vector)
		end

		Unit.set_vector3_for_materials(unit, position_material_key, hit_shader_vector, DO_NOT_INCLUDE_CHILDREN)

		local material_key_id = POSITION_KEY_IDS[wound_index]

		_engine_optimized_set_wound_position_for_item(unit, material_key_id, hit_shader_vector)

		for slot_name, slot_data in pairs(slot_items) do
			if slot_data.state ~= "unequipped" then
				_engine_optimized_set_wound_position_for_item(slot_data.unit, material_key_id, hit_shader_vector)

				local attachments = slot_data.attachments

				if attachments then
					for i = 1, #attachments do
						_engine_optimized_set_wound_position_for_item(attachments[i], material_key_id, hit_shader_vector)
					end
				end
			end
		end

		wound_param_settings[3] = wound_data.shape_mask_uv_offset
		wound_param_settings[1] = wound_data.shape_mask_material_key_id
		wound_param_settings[6] = wound_data.color_brightness_value
		wound_param_settings[4] = wound_data.color_brightness_material_key_id
		wound_param_settings[9] = wound_data.color_time_duration
		wound_param_settings[7] = wound_data.color_time_duration_material_key_id
		wound_param_settings[12] = wound_data.radii
		wound_param_settings[10] = wound_data.radius_material_key_id
		wound_param_settings[15] = wound_data.shape_scales
		wound_param_settings[13] = wound_data.shape_scale_material_key_id

		_engine_optimized_set_wound_material_paramters(unit, wound_param_settings, INCLUDE_CHILDREN)
	end
end

return WoundMaterials
