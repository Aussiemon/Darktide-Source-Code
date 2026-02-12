-- chunkname: @scripts/managers/decal/decal_manager.lua

local DecalSettings = require("scripts/settings/decal/decal_settings")
local DecalManager = class("DecalManager")

DecalManager.init = function (self, world)
	self._decal_system = EngineOptimizedManagers.decal_manager_init(nil, world)

	local lifetime = Application.user_setting("performance_settings", "decal_lifetime") or GameParameters.default_decal_lifetime
	local impact_pool_size = Application.user_setting("performance_settings", "max_impact_decals") or GameParameters.default_max_impact_decals
	local blood_pool_size = Application.user_setting("performance_settings", "max_blood_decals") or GameParameters.default_max_blood_decals
	local footstep_pool_size = Application.user_setting("performance_settings", "max_footstep_decals") or GameParameters.default_max_footstep_decals

	self:init_settings(lifetime, impact_pool_size, blood_pool_size, footstep_pool_size)

	self._lifetime = lifetime
	self._impact_pool_size = impact_pool_size
	self._blood_pool_size = blood_pool_size
	self._footstep_pool_size = footstep_pool_size
	self._decal_unit_id_reference_counts = {}
	self._pinned_packages = {}
end

DecalManager.init_settings = function (self, lifetime, impact_pool_size, blood_pool_size, footstep_pool_size)
	local decal_system = self._decal_system

	for pool_name, setting in pairs(DecalSettings) do
		local pool_size

		if pool_name == "impact" then
			pool_size = impact_pool_size
		elseif pool_name == "blood" then
			pool_size = blood_pool_size
		elseif pool_name == "footstep" then
			pool_size = footstep_pool_size
		end

		EngineOptimizedManagers.decal_manager_add_setting(decal_system, pool_name, lifetime, pool_size, setting.sort_order_base, unpack(setting.units))
	end
end

DecalManager.destroy = function (self)
	EngineOptimizedManagers.decal_manager_destroy(self._decal_system)

	self._decal_system = nil

	for _, package_handle in pairs(self._pinned_packages) do
		Managers.package:release(package_handle)
	end

	self._pinned_packages = nil
end

local _delete_units_scratch = {}

DecalManager.delete_units = function (self)
	local decal_unit_id_reference_counts = self._decal_unit_id_reference_counts

	if table.is_empty(decal_unit_id_reference_counts) then
		return
	end

	table.keys(decal_unit_id_reference_counts, _delete_units_scratch)
	self:_destroy_and_release_units(_delete_units_scratch)
	table.clear(decal_unit_id_reference_counts)
	table.clear(_delete_units_scratch)
end

DecalManager.update = function (self, dt, t)
	self:_check_new_user_settings()
	EngineOptimizedManagers.decal_manager_update(self._decal_system, t)
end

DecalManager.add_projection_decal = function (self, decal_unit_name, decal_position, decal_rotation, decal_normal, decal_extents, hit_actor, hit_unit, t)
	local has_package = Application.can_get_resource("package", decal_unit_name)

	if not has_package then
		Crashify.print_exception("DecalManager", string.format("Decal %s is missing a package with the same name. Unable to pin its resource.", decal_unit_name))
	end

	local decal_unit = EngineOptimizedManagers.decal_manager_add_decal(self._decal_system, decal_unit_name, decal_position, decal_rotation, decal_normal, decal_extents, hit_actor, hit_unit, t)

	if has_package then
		self._pinned_packages[decal_unit] = self._pinned_packages[decal_unit] or Managers.package:load(decal_unit_name, "DecalManager")
	end

	Unit.flow_event(decal_unit, "spawned")
end

DecalManager.clear_all_of_type = function (self, pool_name)
	EngineOptimizedManagers.decal_manager_clear_all_of_type(self._decal_system, pool_name)
end

DecalManager.remove_linked_decals = function (self, parent_unit)
	EngineOptimizedManagers.decal_manager_return_linked_decals_to_pool(self._decal_system, parent_unit)
end

DecalManager.register_decal_unit_ids = function (self, unit_ids)
	for i = 1, #unit_ids do
		local unit_id = unit_ids[i]

		self._decal_unit_id_reference_counts[unit_id] = (self._decal_unit_id_reference_counts[unit_id] or 0) + 1
	end
end

local _unregister_decal_unit_ids_scratch = {}

DecalManager.unregister_decal_unit_ids = function (self, unit_ids)
	for i = 1, #unit_ids do
		local unit_id = unit_ids[i]
		local reference_count = self._decal_unit_id_reference_counts[unit_id]
		local new_reference_count = reference_count - 1

		if new_reference_count == 0 then
			self._decal_unit_id_reference_counts[unit_id] = nil
			_unregister_decal_unit_ids_scratch[#_unregister_decal_unit_ids_scratch + 1] = unit_id
		else
			self._decal_unit_id_reference_counts[unit_id] = new_reference_count
		end
	end

	if not table.is_empty(_unregister_decal_unit_ids_scratch) then
		self:_destroy_and_release_units(_unregister_decal_unit_ids_scratch)
	end

	table.clear(_unregister_decal_unit_ids_scratch)
end

DecalManager._destroy_and_release_units = function (self, units)
	local pinned_packages = self._pinned_packages
	local n_destroyed_units, destroyed_units = EngineOptimizedManagers.decal_manager_destroy_decal_ids(self._decal_system, units)

	for i = 1, n_destroyed_units do
		local destroyed_unit = destroyed_units[i]
		local pinned_package = pinned_packages[destroyed_unit]

		pinned_packages[destroyed_unit] = nil

		Managers.package:release(pinned_package)
	end
end

DecalManager._check_new_user_settings = function (self)
	local new_lifetime = Application.user_setting("performance_settings", "decal_lifetime") or GameParameters.default_decal_lifetime
	local new_impact_pool_size = Application.user_setting("performance_settings", "max_impact_decals") or GameParameters.default_max_impact_decals
	local new_blood_pool_size = Application.user_setting("performance_settings", "max_blood_decals") or GameParameters.default_max_blood_decals
	local new_footstep_pool_size = Application.user_setting("performance_settings", "max_footstep_decals") or GameParameters.default_max_footstep_decals
	local update_settings = self._lifetime ~= new_lifetime or self._impact_pool_size ~= new_impact_pool_size or self._blood_pool_size ~= new_blood_pool_size or self._footstep_pool_size ~= new_footstep_pool_size

	if update_settings then
		self:init_settings(new_lifetime, new_impact_pool_size, new_blood_pool_size, new_footstep_pool_size)

		self._lifetime = new_lifetime
		self._impact_pool_size = new_impact_pool_size
		self._blood_pool_size = new_blood_pool_size
		self._footstep_pool_size = new_footstep_pool_size

		Log.info("DecalManager", "Updating engine decal manager settings")
	end
end

return DecalManager
