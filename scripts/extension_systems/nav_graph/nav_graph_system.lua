local SmartObject = require("scripts/extension_systems/nav_graph/utilities/smart_object")

require("scripts/extension_systems/nav_graph/nav_graph_extension")

local NavGraphSystem = class("NavGraphSystem", "ExtensionSystemBase")

NavGraphSystem.init = function (self, ...)
	NavGraphSystem.super.init(self, ...)

	self._smart_object_id_to_extension = {}
end

NavGraphSystem.on_remove_extension = function (self, unit, extension_name)
	Profiler.start("NavGraphSystem_on_remove_extension")

	local extension = self._unit_to_extension_map[unit]
	local smart_object_id_to_extension = self._smart_object_id_to_extension

	for smart_object_id, extension_to_remove in pairs(smart_object_id_to_extension) do
		if extension_to_remove == extension then
			smart_object_id_to_extension[smart_object_id] = nil
		end
	end

	NavGraphSystem.super.on_remove_extension(self, unit, extension_name)
	Profiler.stop("NavGraphSystem_on_remove_extension")
end

NavGraphSystem.destroy = function (self)
	SmartObject.reset_last_smart_object_id()
	NavGraphSystem.super.destroy(self)
end

NavGraphSystem.register_smart_object_id_to_extension = function (self, smart_object_id, extension)
	local smart_object_id_to_extension = self._smart_object_id_to_extension

	fassert(smart_object_id_to_extension[smart_object_id] == nil, "[NavGraphSystem] Tried to register smart object id (%d) that was already registered.", smart_object_id)

	smart_object_id_to_extension[smart_object_id] = extension
end

NavGraphSystem.register_smart_object_ids_to_extension = function (self, smart_object_ids, extension)
	local smart_object_id_to_extension = self._smart_object_id_to_extension

	for i = 1, #smart_object_ids do
		local smart_object_id = smart_object_ids[i]

		fassert(smart_object_id_to_extension[smart_object_id] == nil, "[NavGraphSystem] Tried to register smart object id (%d) that was already registered.", smart_object_id)

		smart_object_id_to_extension[smart_object_id] = extension
	end
end

NavGraphSystem.unregister_smart_object_id_from_extension = function (self, smart_object_id, extension)
	local smart_object_id_to_extension = self._smart_object_id_to_extension

	fassert(smart_object_id_to_extension[smart_object_id] == extension, "[NavGraphSystem] Tried to unregister smart object id (%d) from non-owning extension.", smart_object_id)

	smart_object_id_to_extension[smart_object_id] = nil
end

NavGraphSystem.smart_object_layer_type = function (self, smart_object_id)
	fassert(self._is_server, "[NavGraphSystem] Smart objects are only supported on server.")

	local extension = self._smart_object_id_to_extension[smart_object_id]

	if extension then
		local smart_object = extension:smart_object_from_id(smart_object_id)
		local layer_type = smart_object:layer_type()

		return layer_type
	end

	return nil
end

NavGraphSystem.smart_object_data = function (self, smart_object_id)
	fassert(self._is_server, "[NavGraphSystem] Smart objects are only supported on server.")

	local extension = self._smart_object_id_to_extension[smart_object_id]

	if extension then
		local smart_object = extension:smart_object_from_id(smart_object_id)

		return smart_object:data()
	end

	return nil
end

NavGraphSystem.unit_from_smart_object_id = function (self, smart_object_id)
	fassert(self._is_server, "[NavGraphSystem] Smart objects are only supported on server.")

	local extension = self._smart_object_id_to_extension[smart_object_id]

	if extension then
		local unit = extension:unit()

		return unit
	end

	return nil
end

return NavGraphSystem
