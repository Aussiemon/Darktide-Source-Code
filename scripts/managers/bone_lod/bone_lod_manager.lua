local ScriptViewport = require("scripts/foundation/utilities/script_viewport")
local BoneLodManager = class("BoneLodManager")

BoneLodManager.init = function (self, world, is_dedicated_server, is_server)
	self._world = world
	self._bone_lod_viewport = nil
	local update_mode = nil

	if is_dedicated_server then
		update_mode = BoneLod.USE_HIGHEST_NON_ROOT_BONE_LOD
	elseif is_server then
		update_mode = BoneLod.USE_ALL_EXCEPT_ROOT_BONE_LOD
	else
		update_mode = BoneLod.USE_ALL_BONE_LOD
	end

	local lod_in_distance = GameParameters.bone_lod_in_distance
	local lod_out_distance = GameParameters.bone_lod_out_distance

	BoneLod.init(lod_in_distance, lod_out_distance, update_mode)
end

BoneLodManager.destroy = function (self, ...)
	BoneLod.destroy()
end

BoneLodManager.pre_update = function (self)
	self:_update_animation_bone_lod()
end

BoneLodManager.register_unit = function (self, unit, radius, impact_animation_on_children)
	local result = BoneLod.register_unit(unit, radius, impact_animation_on_children)

	return result
end

BoneLodManager.unregister_unit = function (self, registration_id)
	BoneLod.unregister_unit(registration_id)
end

BoneLodManager.register_bone_lod_viewport = function (self, viewport)
	fassert(self._bone_lod_viewport == nil, "[BoneLodManager] A viewport has already been registered.")

	self._bone_lod_viewport = viewport
end

BoneLodManager.unregister_bone_lod_viewport = function (self, viewport)
	fassert(self._bone_lod_viewport, "[BoneLodManager] No viewport has been registered.")
	fassert(self._bone_lod_viewport == viewport, "[BoneLodManager] Trying to unregister a different viewport.")

	self._bone_lod_viewport = nil
end

BoneLodManager._update_animation_bone_lod = function (self)
	local viewport = self._bone_lod_viewport

	if viewport then
		local camera = ScriptViewport.camera(viewport)

		BoneLod.update(camera)
	end
end

return BoneLodManager
