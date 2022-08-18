Components = Components or {}
local destroyed_mt = {
	__index = function (t, k)
		ferror("Tried accessing %s on destroyed component of type %s", tostring(k), t.__component_name)
	end
}
local special_functions = {
	__index = true,
	name = true,
	super = true,
	__component_name = true,
	new = true,
	__interfaces = true,
	delete = true
}

local function _component_data_default_value(component_data, unit, guid, ...)
	if not component_data then
		return nil
	end

	local num_args = select("#", ...)
	local data = component_data

	for i = 1, num_args, 1 do
		local key = select(i, ...)
		data = data[key]

		if not data then
			return nil
		end

		if num_args == i then
			if data.value ~= nil then
				return data.value
			end

			Log.error("Component", "[_component_data_default_value][Unit: %s][Component: %s] Missing default value for variable(%s)", Unit.id_string(unit), guid, key)
		end
	end

	return nil
end

local function _component_data_default_array_values(component_data, unit, guid, data_type, ...)
	if not component_data then
		return nil
	end

	local num_args = select("#", ...)
	local data = component_data

	for i = 1, num_args, 1 do
		local key = select(i, ...)
		data = data[key]

		if not data then
			return nil
		end

		if num_args == i then
			if data.value then
				return data.value
			elseif data.values then
				return data.values
			elseif data.size then
				if string.lower(data_type) == "text_box_array" then
					local result = {}

					for j = 1, data.size, 1 do
						table.insert(result, "")
					end

					return result
				elseif string.lower(data_type) == "check_box_array" then
					local result = {}

					for j = 1, data.size, 1 do
						table.insert(result, false)
					end

					return result
				elseif string.lower(data_type) == "number_array" then
					local result = {}

					for j = 1, data.size, 1 do
						table.insert(result, 0)
					end

					return result
				elseif string.lower(data_type) == "resource_array" then
					local result = {}

					for j = 1, data.size, 1 do
						table.insert(result, "")
					end

					return result
				end
			elseif data.is_optional then
				return nil
			end

			Log.error("Component", "[_component_data_default_array_values][Unit: %s][Component: %s] Missing default values for array(%s)", Unit.id_string(unit), guid, key)
		end
	end

	return nil
end

local function _component_data_type(component_data, ...)
	if not component_data then
		return nil
	end

	local num_args = select("#", ...)
	local data = component_data

	for i = 1, num_args, 1 do
		local key = select(i, ...)
		data = data[key]

		if not data then
			return nil
		end

		if num_args == i then
			return data.ui_type, data.definition
		end
	end
end

local function _is_vector3(type_name)
	return string.lower(type_name) == "vector"
end

local function _is_struct_array(type_name)
	return string.lower(type_name) == "struct_array"
end

local function _is_color(type_name)
	return string.lower(type_name) == "color"
end

local function _is_resource(type_name)
	return string.lower(type_name) == "resource"
end

local function _is_array(type_name)
	return string.lower(type_name) == "text_box_array" or string.lower(type_name) == "check_box_array" or string.lower(type_name) == "combo_box_array" or string.lower(type_name) == "number_array" or string.lower(type_name) == "resource_array"
end

local function _component_data_get_array(self, unit, data_type, ...)
	local unit_array_size = Unit.data_table_size(unit, "components", self.guid, "component_data", ...) or 0

	if unit_array_size <= 0 then
		return nil
	end

	local array = Script.new_array(unit_array_size)

	if string.lower(data_type) == "resource_array" then
		for ii = 1, unit_array_size, 1 do
			local resource_data = Unit.get_data(unit, "components", self.guid, "component_data", ..., ii, "resource")

			if resource_data ~= nil then
				array[#array + 1] = resource_data
			else
				local data = Unit.get_data(unit, "components", self.guid, "component_data", ..., ii)

				if data ~= nil then
					array[#array + 1] = data
				end
			end
		end
	else
		for ii = 1, unit_array_size, 1 do
			local data = Unit.get_data(unit, "components", self.guid, "component_data", ..., ii)

			if data ~= nil then
				array[#array + 1] = data
			end
		end
	end

	if #array == 0 then
		return nil
	end

	return array
end

local function _component_data_get_vector3(self, unit, guid, ...)
	local vector = Vector3(0, 0, 0)
	local default_boxed_vector = _component_data_default_value(self.component_data, unit, guid, ...)

	if default_boxed_vector then
		vector = default_boxed_vector:unbox()
	end

	for i = 1, 3, 1 do
		local data = Unit.get_data(unit, "components", guid, "component_data", ..., i)

		if data then
			vector[i] = data
		end
	end

	return Vector3Box(Vector3(vector[1], vector[2], vector[3]))
end

local function _component_data_get_color(self, unit, guid, ...)
	local elements = {
		255,
		255,
		255,
		255
	}
	local default_boxed_color = _component_data_default_value(self.component_data, unit, guid, ...)

	if default_boxed_color then
		local _, r, g, b = Quaternion.to_elements(default_boxed_color:unbox())
		elements = {
			255,
			r * 255,
			g * 255,
			b * 255
		}
	end

	for i = 1, 4, 1 do
		local data = Unit.get_data(unit, "components", guid, "component_data", ..., i)

		if data then
			elements[i] = data * 255
		end
	end

	return QuaternionBox(Color(elements[1], elements[2], elements[3], elements[4]))
end

local function _component_data_get_resource(component_data, unit, guid, ...)
	return Unit.get_data(unit, "components", guid, "component_data", ..., "resource") or Unit.get_data(unit, "components", guid, "component_data", ...)
end

local function _component_data_get_struct_array(self, definition, unit, guid, ...)
	local result_array = {}
	local array_entry_index = 1
	local child_info_exists = Unit.has_data(unit, "components", guid, "component_data", ..., array_entry_index)

	while child_info_exists do
		local new_entry = {}

		for member_name, member_data in pairs(definition) do
			local member_type_name = member_data.ui_type

			if _is_resource(member_type_name) then
				local value = Unit.get_data(unit, "components", guid, "component_data", ..., array_entry_index, member_name, "resource")

				if value == nil then
					value = member_data.value
				end

				new_entry[member_name] = value
			elseif _is_vector3(member_type_name) then
				local vector = Vector3(0, 0, 0)
				local default_boxed_vector = member_data.value

				if default_boxed_vector then
					vector = default_boxed_vector:unbox()
				end

				for i = 1, 3, 1 do
					local data = Unit.get_data(unit, "components", guid, "component_data", ..., array_entry_index, member_name, i)

					if data then
						vector[i] = data
					end
				end

				new_entry[member_name] = Vector3Box(Vector3(vector[1], vector[2], vector[3]))
			elseif _is_color(member_type_name) then
				local color_elements = {
					255,
					255,
					255,
					255
				}
				local default_boxed_color = member_data.value

				if default_boxed_color then
					local x, y, z, _ = Quaternion.to_elements(default_boxed_color:unbox())
					color_elements = {
						x * 255,
						y * 255,
						z * 255,
						255
					}
				end

				for i = 1, 4, 1 do
					local data = Unit.get_data(unit, "components", guid, "component_data", ..., array_entry_index, member_name, i)

					if data then
						color_elements[i] = data * 255
					end
				end

				new_entry[member_name] = QuaternionBox(Color(color_elements[1], color_elements[2], color_elements[3], color_elements[4]))
			else
				local value = Unit.get_data(unit, "components", guid, "component_data", ..., array_entry_index, member_name)

				if value == nil then
					value = member_data.value
				end

				new_entry[member_name] = value
			end
		end

		table.insert(result_array, new_entry)

		array_entry_index = array_entry_index + 1
		child_info_exists = Unit.has_data(unit, "components", guid, "component_data", ..., array_entry_index)
	end

	return result_array
end

function component(component_name, super_name, ...)
	fassert(type(component_name) == "string", "Didn't pass in component_name %q as a string", tostring(component_name))

	local component_table = Components[component_name]
	local super = nil

	if super_name then
		super = Components[super_name]

		fassert(super, "Component %q trying to inherit from nonexistant %q", component_name, super_name)
	end

	if not component_table then
		component_table = {
			super = super,
			__component_name = component_name,
			__index = component_table,
			__interfaces = {},
			events = {},
			new = function (self, guid, network_index, unit, is_server, ...)
				local object = {}

				setmetatable(object, component_table)

				object.guid = guid
				object.network_index = network_index
				object.unit = unit
				object.is_server = is_server
				local run_update = nil

				if (EDITOR and object.editor_init) or (rawget(_G, "EditorApi") and object.editor_init) then
					run_update = object:editor_init(unit, is_server, ...)
				elseif object.init then
					run_update = object:init(unit, is_server, ...)
				end

				object.run_update_on_enable = run_update

				return object, run_update
			end,
			delete = function (self, ...)
				self:destroy(...)
				setmetatable(self, destroyed_mt)
			end,
			get_data = function (self, unit, ...)
				local data_type, array_struct_definition = _component_data_type(self.component_data, ...)

				if data_type ~= nil and _is_vector3(data_type) then
					return _component_data_get_vector3(self, unit, self.guid, ...)
				end

				if data_type ~= nil and _is_struct_array(data_type) then
					return _component_data_get_struct_array(self, array_struct_definition, unit, self.guid, ...)
				end

				if data_type ~= nil and _is_color(data_type) then
					return _component_data_get_color(self, unit, self.guid, ...)
				end

				if data_type ~= nil and _is_array(data_type) then
					return _component_data_get_array(self, unit, data_type, ...) or _component_data_default_array_values(self.component_data, unit, self.guid, data_type, ...)
				end

				if data_type ~= nil and _is_resource(data_type) then
					return _component_data_get_resource(self.component_data, unit, self.guid, ...) or _component_data_default_value(self.component_data, unit, self.guid, ...)
				end

				local value = Unit.get_data(unit, "components", self.guid, "component_data", ...)

				if value == nil then
					value = _component_data_default_value(self.component_data, unit, self.guid, ...)
				end

				return value
			end,
			name = function (self)
				return self.__component_name
			end
		}
		Components[component_name] = component_table
	end

	if super then
		for k, v in pairs(super) do
			if not special_functions[k] then
				component_table[k] = v
			end
		end
	end

	return component_table
end

local function _require_component(component_path)
	local in_game = not rawget(_G, "EditorApi")

	if in_game then
		require(component_path)
	else
		local index = #package.load_order + 1
		local valid, err = pcall(require, component_path)

		Utils.component_print_info(valid, component_path, err)

		if not valid then
			while index <= #package.load_order do
				local pack = package.load_order[#package.load_order]
				package.loaded[pack] = nil

				table.remove(package.load_order, #package.load_order)

				local name = Utils.path_to_class_name(pack)
				Components[name] = nil
			end
		end
	end
end

local Component = require("scripts/utilities/component")

_require_component("scripts/components/ammo_display")
_require_component("scripts/components/annotation")
_require_component("scripts/components/baked_physics")
_require_component("scripts/components/beast_of_nurgle")
_require_component("scripts/components/bot_jump_assist")
_require_component("scripts/components/broadphase")
_require_component("scripts/components/chain_sword_spin")
_require_component("scripts/components/chain_sword_blur")
_require_component("scripts/components/chest")
_require_component("scripts/components/cinematic_player_spawner")
_require_component("scripts/components/cinematic_scene")
_require_component("scripts/components/corruptor_arm")
_require_component("scripts/components/corruptor")
_require_component("scripts/components/cover")
_require_component("scripts/components/cutscene_camera")
_require_component("scripts/components/cutscene_character")
_require_component("scripts/components/decoder_device")
_require_component("scripts/components/decoder_synchronizer")
_require_component("scripts/components/demolition_synchronizer")
_require_component("scripts/components/destructible")
_require_component("scripts/components/dialogue")
_require_component("scripts/components/door_control_panel")
_require_component("scripts/components/door")
_require_component("scripts/components/driven_keys")
_require_component("scripts/components/emissive_light")
_require_component("scripts/components/explosive")
_require_component("scripts/components/foot_ik")
_require_component("scripts/components/hazard_prop")
_require_component("scripts/components/health_station")
_require_component("scripts/components/interactable")
_require_component("scripts/components/interpolate_animation_variable")
_require_component("scripts/components/kill_synchronizer")
_require_component("scripts/components/ladder")
_require_component("scripts/components/level_prop_customization")
_require_component("scripts/components/level_scriptdata_tester_component")
_require_component("scripts/components/light_controller")
_require_component("scripts/components/luggable_socket")
_require_component("scripts/components/luggable_synchronizer")
_require_component("scripts/components/magazine_ammo")
_require_component("scripts/components/minigame")
_require_component("scripts/components/minion_customization")
_require_component("scripts/components/minion_multi_teleporter")
_require_component("scripts/components/minion_spawner")
_require_component("scripts/components/mission_board_interactable")
_require_component("scripts/components/mission_board")
_require_component("scripts/components/mission_luggable_spawner")
_require_component("scripts/components/mission_objective_target")
_require_component("scripts/components/mission_objective_zone_scannable")
_require_component("scripts/components/mission_objective_zone_synchronizer")
_require_component("scripts/components/mission_objective_zone")
_require_component("scripts/components/monster_spawner")
_require_component("scripts/components/moveable_platform")
_require_component("scripts/components/nav_block")
_require_component("scripts/components/nav_graph")
_require_component("scripts/components/networked_timer")
_require_component("scripts/components/networked_unique_randomize")
_require_component("scripts/components/npc_animation")
_require_component("scripts/components/overheat_display")
_require_component("scripts/components/particle_effect")
_require_component("scripts/components/perlin_light")
_require_component("scripts/components/pickup_spawner")
_require_component("scripts/components/player_customization")
_require_component("scripts/components/player_spawner")
_require_component("scripts/components/point_of_interest")
_require_component("scripts/components/prop_animation")
_require_component("scripts/components/prop_health")
_require_component("scripts/components/prop_outline")
_require_component("scripts/components/prop_shield")
_require_component("scripts/components/prop_unit_data")
_require_component("scripts/components/respawn_beacon")
_require_component("scripts/components/safe_volume")
_require_component("scripts/components/scanner_display")
_require_component("scripts/components/scanner_light")
_require_component("scripts/components/servo_skull_activator")
_require_component("scripts/components/servo_skull")
_require_component("scripts/components/shading_environment_volume")
_require_component("scripts/components/side_mission_pickup_synchronizer")
_require_component("scripts/components/smart_tag_target")
_require_component("scripts/components/sound_reflection")
_require_component("scripts/components/spline_follower")
_require_component("scripts/components/spline_group")
_require_component("scripts/components/sweep_trail")
_require_component("scripts/components/timed_explosive")
_require_component("scripts/components/trigger")
_require_component("scripts/components/valkyrie_customization")
_require_component("scripts/components/vector_field_effect")
_require_component("scripts/components/volumetric_fog")
_require_component("scripts/components/weather_volume")
_require_component("scripts/components/weapon_customization")
_require_component("scripts/components/weapon_flashlight")
_require_component("scripts/components/weapon_material_variables")
_require_component("scripts/components/wwise_emitter_occlusion")
_require_component("scripts/components/wwise_portal_volume")
_require_component("scripts/components/wwise_room_volume")
Component.parse_components(Components)

return Components
