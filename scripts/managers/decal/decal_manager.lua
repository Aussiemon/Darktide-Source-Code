local DecalSettings = require("scripts/settings/decal/decal_settings")
local DecalManager = class("DecalManager")

DecalManager.init = function (self, world)
	self._decal_system = EngineOptimizedManagers.decal_manager_init(nil, world)
	local lifetime = Application.user_setting("performance_settings", "decal_lifetime") or GameParameters.default_decal_lifetime
	local impact_pool_size = Application.user_setting("performance_settings", "max_impact_decals") or GameParameters.default_max_impact_decals
	local blood_pool_size = Application.user_setting("performance_settings", "max_blood_decals") or GameParameters.default_max_blood_decals

	self:init_settings(lifetime, impact_pool_size, blood_pool_size)

	self._lifetime = lifetime
	self._impact_pool_size = impact_pool_size
	self._blood_pool_size = blood_pool_size
	self._decal_unit_id_reference_counts = {}
end

DecalManager.init_settings = function (self, lifetime, impact_pool_size, blood_pool_size)
	local decal_system = self._decal_system

	for pool_name, setting in pairs(DecalSettings) do
		local pool_size = nil

		if pool_name == "impact" then
			pool_size = impact_pool_size
		elseif pool_name == "blood" then
			pool_size = blood_pool_size
		end

		EngineOptimizedManagers.decal_manager_add_setting(decal_system, pool_name, lifetime, pool_size, unpack(setting.units))
	end
end

DecalManager.delete_units = function (self)
	EngineOptimizedManagers.decal_manager_destroy(self._decal_system)
end

DecalManager.update = function (self, dt, t)
	self:_check_new_user_settings()
	EngineOptimizedManagers.decal_manager_update(self._decal_system, t)
end

DecalManager.add_projection_decal = function (self, decal_unit_name, decal_position, decal_rotation, decal_normal, decal_extents, hit_actor, hit_unit, t)
	local decal_unit = EngineOptimizedManagers.decal_manager_add_decal(self._decal_system, decal_unit_name, decal_position, decal_rotation, decal_normal, decal_extents, hit_actor, hit_unit, t)

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

local decal_unit_ids = {}

DecalManager.unregister_decal_unit_ids = function (self, unit_ids)
	table.clear(decal_unit_ids)

	for i = 1, #unit_ids do
		local unit_id = unit_ids[i]
		local reference_count = self._decal_unit_id_reference_counts[unit_id]

		fassert(reference_count, "Tring to unregister a decal unit id that has not been registered")

		local new_reference_count = reference_count - 1

		if new_reference_count == 0 then
			self._decal_unit_id_reference_counts[unit_id] = nil
			decal_unit_ids[#decal_unit_ids + 1] = unit_id
		else
			self._decal_unit_id_reference_counts[unit_id] = new_reference_count
		end
	end

	if next(decal_unit_ids) then
		EngineOptimizedManagers.decal_manager_destroy_decal_ids(self._decal_system, unpack(decal_unit_ids))
	end
end

DecalManager._check_new_user_settings = function (self)
	local new_lifetime = Application.user_setting("performance_settings", "decal_lifetime") or GameParameters.default_decal_lifetime
	local new_impact_pool_size = Application.user_setting("performance_settings", "max_impact_decals") or GameParameters.default_max_impact_decals
	local new_blood_pool_size = Application.user_setting("performance_settings", "max_blood_decals") or GameParameters.default_max_blood_decals
	local update_settings = self._lifetime ~= new_lifetime or self._impact_pool_size ~= new_impact_pool_size or self._blood_pool_size ~= new_blood_pool_size

	if update_settings then
		self:init_settings(new_lifetime, new_impact_pool_size, new_blood_pool_size)

		self._lifetime = new_lifetime
		self._impact_pool_size = new_impact_pool_size
		self._blood_pool_size = new_blood_pool_size

		Log.info("DecalManager", "Updating engine decal manager settings")
	end
end

return DecalManager
