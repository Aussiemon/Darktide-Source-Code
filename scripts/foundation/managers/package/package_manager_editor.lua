local PackageManager = require("scripts/foundation/managers/package/package_manager")
local PackageManagerEditor = class("PackageManagerEditor")
PackageManagerEditor.FIRST_ITEM = 1

PackageManagerEditor.init = function (self)
	self._current_item = PackageManagerEditor.FIRST_ITEM
	self._callback_queue = {}
end

PackageManagerEditor.load = function (self, package_name, reference_name, callback, prioritize)
	local id = self._current_item

	if callback then
		local item = {
			id = id,
			callback = callback
		}
		self._callback_queue[#self._callback_queue + 1] = item
	end

	self._current_item = self._current_item + 1

	return id
end

PackageManagerEditor.release = function (self, id)
	return
end

PackageManagerEditor.can_unload = function (self, package_name)
	return true
end

PackageManagerEditor.shutdown_has_started = function (self)
	return
end

PackageManagerEditor.destroy = function (self)
	return
end

PackageManagerEditor.is_anything_loading_now = function (self)
	return false
end

PackageManagerEditor.is_loading_now = function (self, package)
	return false
end

PackageManagerEditor.is_loading = function (self, package)
	return false
end

PackageManagerEditor.has_loaded = function (self, package_name)
	return true
end

PackageManagerEditor.has_loaded_id = function (self, id)
	return true
end

PackageManagerEditor.package_loaded = function (self, package_name)
	return true
end

PackageManagerEditor.temp_hack_id_from_name_and_reference = function (self, package_name, reference_name)
	return 0
end

PackageManagerEditor.reference_count = function (self, package, reference_name)
	return 0
end

PackageManagerEditor.all_reference_count = function (self, reference_name)
	return 0
end

PackageManagerEditor.package_is_known = function (self, package)
	return true
end

PackageManagerEditor.update = function (self)
	local callback_queue = table.clone(self._callback_queue)

	table.clear(self._callback_queue)

	for i = 1, #callback_queue do
		local item = callback_queue[i]

		item.callback(item.id)
	end

	return true
end

PackageManagerEditor.dump_reference_counter = function (self, reference_name)
	return
end

PackageManagerEditor.dump_all = function (self)
	return
end

PackageManagerEditor.references = function (self)
	return
end

local interface = {}
local i = 1

for name, value in pairs(PackageManager) do
	if type(value) == "function" and string.sub(name, 1, 1) ~= "_" then
		interface[i] = name
		i = i + 1
	end
end

implements(PackageManagerEditor, interface)

return PackageManagerEditor
