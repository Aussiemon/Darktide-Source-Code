-- chunkname: @scripts/foundation/utilities/script_unit.lua

local unit_alive = Unit.alive

ScriptUnit = ScriptUnit or {}

local Entities = rawget(_G, "G_Entities")

if not Entities then
	Entities = {}

	rawset(_G, "G_Entities", Entities)
end

local function _set_extension_script(unit, system_name, extension)
	local unit_extensions = Entities[unit]

	if not unit_extensions then
		unit_extensions = {}
		Entities[unit] = unit_extensions
	end

	unit_extensions[system_name] = extension
end

local function _unit_in_runtime_loaded_level(unit)
	local level = Unit.level(unit)
	local result = false

	if level ~= nil then
		result = Level.get_data(level, "runtime_loaded_level") == true
	end

	return result
end

local function _local_extension(unit, system_name)
	local unit_extensions = Entities[unit]

	return unit_extensions and unit_extensions[system_name]
end

ScriptUnit.extension_input = function (unit, system_name)
	local extension = _local_extension(unit, system_name, false)

	return extension.input
end

ScriptUnit.extension = function (unit, system_name)
	local unit_extensions = Entities[unit]
	local extension = unit_extensions and unit_extensions[system_name]

	return extension
end

ScriptUnit.extensions = function (unit)
	return Entities[unit]
end

ScriptUnit.unit_in_runtime_loaded_level = _unit_in_runtime_loaded_level
ScriptUnit.has_extension = _local_extension

ScriptUnit.set_extension = function (unit, system_name, extension)
	_set_extension_script(unit, system_name, extension)
end

ScriptUnit.add_extension = function (extension_init_context, unit, extension_name, system_name, extension_init_data, ...)
	local extension_class = CLASSES[extension_name]
	local extension = extension_class:new(extension_init_context, unit, extension_init_data, ...)

	_set_extension_script(unit, system_name, extension)

	return extension
end

ScriptUnit.remove_extension = function (unit, system_name)
	local extension = ScriptUnit.extension(unit, system_name)
	local delete_func = extension.delete

	if delete_func then
		delete_func(extension, unit)
	end

	local unit_extensions = Entities[unit]

	unit_extensions[system_name] = nil
end

ScriptUnit.remove_unit = function (unit)
	Entities[unit] = nil
end

ScriptUnit.extension_definitions = function (unit)
	local extensions = {}
	local i = 1

	while Unit.has_data(unit, "extensions", i) do
		local class_name = Unit.get_data(unit, "extensions", i)

		extensions[i] = class_name
		i = i + 1
	end

	return extensions
end

ScriptUnit.move_extensions = function (unit, new_unit)
	Entities[new_unit] = Entities[unit]
	Entities[unit] = nil
end

ScriptUnit.optimize = function (unit)
	if unit_alive(unit) then
		local disable_shadows = Unit.get_data(unit, "disable_shadows")

		if disable_shadows then
			local num_meshes = Unit.num_meshes(unit)

			for i = 1, num_meshes do
				Unit.set_mesh_visibility(unit, i, false, VisibilityContexts.SHADOW_CASTER_CONTEXT)
			end
		end

		local disable_physics = Unit.get_data(unit, "disable_physics")

		if disable_physics then
			local num_actors = Unit.num_actors(unit)

			for i = 1, num_actors do
				Unit.destroy_actor(unit, i)
			end
		end
	end
end

ScriptUnit.fetch_component_extension = function (unit, system_name)
	local extension = ScriptUnit.has_extension(unit, system_name)

	return extension
end

return ScriptUnit
