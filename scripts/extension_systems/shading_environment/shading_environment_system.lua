-- chunkname: @scripts/extension_systems/shading_environment/shading_environment_system.lua

require("scripts/extension_systems/shading_environment/shading_environment_extension")

local ShadingEnvironmentSystem = class("ShadingEnvironmentSystem", "ExtensionSystemBase")

ShadingEnvironmentSystem.init = function (self, ...)
	ShadingEnvironmentSystem.super.init(self, ...)

	self._theme_shading_environment_slots = {}
end

ShadingEnvironmentSystem.on_gameplay_post_init = function (self, level, themes)
	self:on_theme_changed(themes)
end

ShadingEnvironmentSystem.on_theme_changed = function (self, themes, force_reset)
	table.clear(self._theme_shading_environment_slots)

	if themes then
		self:_fetch_theme_shading_environments(themes)
	end

	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		extension:setup_theme(self, force_reset)
	end
end

ShadingEnvironmentSystem._fetch_theme_shading_environments = function (self, themes)
	for _, theme in ipairs(themes) do
		local slots_info = Theme.shading_environment_slots(theme)

		if slots_info and table.size(slots_info) > 0 then
			local shading_environments = self._theme_shading_environment_slots

			for _, slot_info in ipairs(slots_info) do
				shading_environments[slot_info.slot_id] = slot_info.shading_environment_name
			end

			break
		end
	end
end

ShadingEnvironmentSystem.theme_environment_from_slot = function (self, slot_id)
	return self._theme_shading_environment_slots[slot_id]
end

return ShadingEnvironmentSystem
