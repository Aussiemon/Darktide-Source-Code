require("scripts/extension_systems/cover/cover_extension")
require("scripts/extension_systems/cover/cover_user_extension")

local CoverSystem = class("CoverSystem", "ExtensionSystemBase")
local BROADPHASE_CELL_RADIUS = 50
local MAX_EXPECTED_ENTITIES = 256
local BROADPHASE_CATEGORIES = {
	"cover"
}

CoverSystem.init = function (self, extension_system_creation_context, ...)
	CoverSystem.super.init(self, extension_system_creation_context, ...)

	local nav_world = extension_system_creation_context.nav_world
	local extension_init_context = self._extension_init_context
	extension_init_context.nav_world = nav_world
	self._cover_unit_extension_data = {}
	self._cover_user_unit_extension_data = {}
	self._broadphase = Broadphase(BROADPHASE_CELL_RADIUS, MAX_EXPECTED_ENTITIES, BROADPHASE_CATEGORIES)
	self._cover_slot_broadphase_lookup = {}
	self._cover_unit_broadphase_ids = {}
	self._current_update_unit = nil
	self._current_update_extension = nil
	local is_server = extension_system_creation_context.is_server
	self._is_server = is_server
end

CoverSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = CoverSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	if extension_name == "CoverExtension" then
		self._cover_unit_extension_data[unit] = extension
		local cover_unit_broadphase_ids = self._cover_unit_broadphase_ids
		cover_unit_broadphase_ids[unit] = {}
	end

	return extension
end

CoverSystem.register_extension_update = function (self, unit, extension_name, extension)
	CoverSystem.super.register_extension_update(self, unit, extension_name, extension)

	if extension_name == "CoverUserExtension" then
		self._cover_user_unit_extension_data[unit] = extension
	end
end

CoverSystem.on_remove_extension = function (self, unit, extension_name)
	if extension_name == "CoverExtension" then
		self._cover_unit_extension_data[unit] = nil
		local cover_unit_broadphase_ids = self._cover_unit_broadphase_ids[unit]
		local cover_slot_broadphase_lookup = self._cover_slot_broadphase_lookup
		local broadphase = self._broadphase

		for i = 1, #cover_unit_broadphase_ids do
			local broadphase_id = cover_unit_broadphase_ids[i]

			Broadphase.remove(broadphase, broadphase_id)

			cover_slot_broadphase_lookup[broadphase_id] = nil
		end

		cover_unit_broadphase_ids[unit] = nil
	elseif extension_name == "CoverUserExtension" then
		local current_update_unit = self._current_update_unit
		local cover_user_unit_extension_data = self._cover_user_unit_extension_data

		if current_update_unit == unit then
			self._current_update_unit, self._current_update_extension = next(cover_user_unit_extension_data, current_update_unit)
		end

		local cover_user_extension = cover_user_unit_extension_data[unit]

		cover_user_extension:release_cover_slot()

		cover_user_unit_extension_data[unit] = nil
	end

	CoverSystem.super.on_remove_extension(self, unit, extension_name)
end

CoverSystem.destroy = function (self)
	self._broadphase = nil
end

CoverSystem.update = function (self, context, dt, t, ...)
	self:_update_cover_users(dt, t)
end

CoverSystem._update_cover_users = function (self, dt, t)
	local cover_user_unit_extension_data = self._cover_user_unit_extension_data
	local current_update_unit = self._current_update_unit
	local current_update_extension = self._current_update_extension

	if current_update_unit then
		current_update_extension:update(current_update_unit, dt, t)
	end

	current_update_unit, current_update_extension = next(cover_user_unit_extension_data, current_update_unit)
	self._current_update_unit = current_update_unit
	self._current_update_extension = current_update_extension
end

local BROADPHASE_COVER_RADIUS = 1

CoverSystem.add_cover_slot_to_broadphase = function (self, cover_unit, cover_slot)
	local boxed_position = cover_slot.position
	local broadphase_id = Broadphase.add(self._broadphase, nil, boxed_position:unbox(), BROADPHASE_COVER_RADIUS, BROADPHASE_CATEGORIES)
	local cover_slot_broadphase_lookup = self._cover_slot_broadphase_lookup
	cover_slot_broadphase_lookup[broadphase_id] = cover_slot
	local cover_unit_broadphase_ids = self._cover_unit_broadphase_ids[cover_unit]
	cover_unit_broadphase_ids[#cover_unit_broadphase_ids + 1] = broadphase_id
end

local broadphase_results = {}
local cover_slot_results = {}

CoverSystem.find_cover_slots = function (self, search_position, radius)
	table.clear_array(cover_slot_results, #cover_slot_results)

	local broadphase = self._broadphase
	local num_results = broadphase:query(search_position, radius, broadphase_results, BROADPHASE_CATEGORIES)
	local cover_slot_broadphase_lookup = self._cover_slot_broadphase_lookup

	for i = 1, num_results do
		local id = broadphase_results[i]
		local cover_slot = cover_slot_broadphase_lookup[id]
		cover_slot_results[i] = cover_slot
	end

	return cover_slot_results
end

return CoverSystem
