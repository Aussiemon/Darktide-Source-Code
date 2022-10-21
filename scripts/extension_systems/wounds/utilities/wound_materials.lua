local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local _set_wound_position_for_item = nil
local SHAPE_MASKS = WoundsSettings.masks
local SHAPE_INVERSIONS = WoundsSettings.shape_inversions
local NUM_MAX_WOUNDS = 3
local NUM_RADIUS_ENTRIES = 3
local NUM_RADIUS_KEYS = NUM_MAX_WOUNDS / NUM_RADIUS_ENTRIES
local RADIUS_KEY = "wound_radius_0%d"
local RADIUS_KEYS = Script.new_array(NUM_RADIUS_KEYS)

for i = 1, NUM_RADIUS_KEYS do
	local radius_key = string.format(RADIUS_KEY, i)
	RADIUS_KEYS[i] = radius_key
end

local NUM_SHAPE_SCALE_ENTRIES = 3
local NUM_SHAPE_SCALE_KEYS = NUM_MAX_WOUNDS / NUM_SHAPE_SCALE_ENTRIES
local SHAPE_SCALE_KEY = "wound_shape_scaling_0%d"
local SHAPE_SCALE_KEYS = Script.new_array(NUM_SHAPE_SCALE_KEYS)

for i = 1, NUM_SHAPE_SCALE_KEYS do
	local shape_scale_key = string.format(SHAPE_SCALE_KEY, i)
	SHAPE_SCALE_KEYS[i] = shape_scale_key
end

local POSITION_KEY = "wound_position_0%d"
local POSITION_KEYS = Script.new_array(NUM_MAX_WOUNDS)
local SHAPE_KEY = "wound_0%d_shape"
local SHAPE_KEYS = Script.new_array(NUM_MAX_WOUNDS)
local COLOR_BRIGHTNESS_KEY = "wound_color_brightness_0%d"
local COLOR_BRIGHTNESS_KEYS = Script.new_array(NUM_MAX_WOUNDS)
local COLOR_TIME_DURATION_KEY = "wound_color_time_duration_0%d"
local COLOR_TIME_DURATION_KEYS = Script.new_array(NUM_MAX_WOUNDS)

for i = 1, NUM_MAX_WOUNDS do
	local position_key = string.format(POSITION_KEY, i)
	POSITION_KEYS[i] = position_key
	local shape_key = string.format(SHAPE_KEY, i)
	SHAPE_KEYS[i] = shape_key
	local color_brightness_key = string.format(COLOR_BRIGHTNESS_KEY, i)
	COLOR_BRIGHTNESS_KEYS[i] = color_brightness_key
	local color_time_duration_key = string.format(COLOR_TIME_DURATION_KEY, i)
	COLOR_TIME_DURATION_KEYS[i] = color_time_duration_key
end

local WoundMaterials = {
	create_data = function ()
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
			wounds_data[wound_index] = {
				hit_shader_vector = Vector3Box(),
				radii = radii[radius_material_key],
				radius_index = radius_index,
				radius_material_key = radius_material_key,
				shape_scales = shape_scales[shape_scale_material_key],
				shape_scale_index = shape_scale_index,
				shape_scale_material_key = shape_scale_material_key,
				shape_mask_uv_offset = Vector3Box(),
				color_brightness_value = Vector3Box(),
				color_time_duration = Vector3Box()
			}
		end

		wounds_data.last_write_index = 0
		wounds_data.num_wounds = 0

		return wounds_data, NUM_MAX_WOUNDS
	end
}

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

	local radii = wound_data.radii
	local radius_index = wound_data.radius_index
	radii[radius_index] = wound_radius
	local mask = SHAPE_MASKS[wound_shape]
	local shape_mask_uv_offset = Vector2(mask[1], mask[2])

	wound_data.shape_mask_uv_offset:store(shape_mask_uv_offset)

	local shape_scaling = wound_settings.shape_scaling

	if shape_scaling then
		local shape_scales = wound_data.shape_scales
		local shape_scale_index = wound_data.shape_scale_index
		shape_scales[shape_scale_index] = 1
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

local EMPTY_TABLE = {}
local INCLUDE_CHILDREN = true
local DO_NOT_INCLUDE_CHILDREN = false

WoundMaterials.apply = function (unit, wounds_data, optional_index, optional_slot_items, optional_inverse_root_node_bind_pose)
	local slot_items = optional_slot_items or EMPTY_TABLE
	local start_index = optional_index or 1
	local end_index = optional_index or wounds_data.num_wounds

	for wound_index = start_index, end_index do
		local wound_data = wounds_data[wound_index]
		local position_material_key = POSITION_KEYS[wound_index]
		local hit_shader_vector = wound_data.hit_shader_vector:unbox()

		if optional_inverse_root_node_bind_pose then
			hit_shader_vector = Matrix4x4.transform(optional_inverse_root_node_bind_pose, hit_shader_vector)
		end

		Unit.set_vector3_for_materials(unit, position_material_key, hit_shader_vector, DO_NOT_INCLUDE_CHILDREN)

		for slot_name, slot_data in pairs(slot_items) do
			local slot_state = slot_data.state

			if slot_state ~= "unequipped" then
				_set_wound_position_for_item(slot_data.unit, position_material_key, hit_shader_vector)

				local attachments = slot_data.attachments

				if attachments then
					for i = 1, #attachments do
						_set_wound_position_for_item(attachments[i], position_material_key, hit_shader_vector)
					end
				end
			end
		end

		local radius_material_key = wound_data.radius_material_key
		local radii = wound_data.radii:unbox()

		Unit.set_vector3_for_materials(unit, radius_material_key, radii, INCLUDE_CHILDREN)

		local shape_material_key = SHAPE_KEYS[wound_index]
		local shape_mask_uv_offset = wound_data.shape_mask_uv_offset:unbox()

		Unit.set_vector2_for_materials(unit, shape_material_key, shape_mask_uv_offset, INCLUDE_CHILDREN)

		local shape_scale_material_key = wound_data.shape_scale_material_key
		local shape_scales = wound_data.shape_scales:unbox()

		Unit.set_vector3_for_materials(unit, shape_scale_material_key, shape_scales, INCLUDE_CHILDREN)

		local color_brightness_material_key = COLOR_BRIGHTNESS_KEYS[wound_index]
		local color_brightness_value = wound_data.color_brightness_value:unbox()

		Unit.set_vector2_for_materials(unit, color_brightness_material_key, color_brightness_value, INCLUDE_CHILDREN)

		local color_time_duration_key = COLOR_TIME_DURATION_KEYS[wound_index]
		local color_time_duration = wound_data.color_time_duration:unbox()

		Unit.set_vector2_for_materials(unit, color_time_duration_key, color_time_duration, INCLUDE_CHILDREN)
	end
end

function _set_wound_position_for_item(item_unit, position_material_key, hit_shader_vector)
	for mesh_index = 1, Unit.num_meshes(item_unit) do
		local mesh = Unit.mesh(item_unit, mesh_index)
		local mesh_node_index = Mesh.node(mesh)
		local mesh_node_position = Unit.local_position(item_unit, mesh_node_index)
		local mesh_hit_shader_vector = hit_shader_vector - mesh_node_position

		for material_index = 1, Mesh.num_materials(mesh) do
			local material = Mesh.material(mesh, material_index)

			Material.set_vector3(material, position_material_key, mesh_hit_shader_vector)
		end
	end
end

return WoundMaterials
