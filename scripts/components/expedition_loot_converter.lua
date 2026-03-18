-- chunkname: @scripts/components/expedition_loot_converter.lua

local ExpeditionLootConverter = component("ExpeditionLootConverter")

ExpeditionLootConverter.init = function (self, unit, is_server)
	self._unit = unit

	Unit.set_scalar_for_materials(self._unit, "increase_color", -0.95)

	local expedition_loot_converter_extension = ScriptUnit.extension(unit, "expedition_loot_converter_system")

	if expedition_loot_converter_extension then
		expedition_loot_converter_extension:setup_from_component()
	end
end

ExpeditionLootConverter.enable = function (self, unit)
	return
end

ExpeditionLootConverter.disable = function (self, unit)
	return
end

ExpeditionLootConverter.destroy = function (self, unit)
	return
end

ExpeditionLootConverter.component_data = {
	inputs = {
		interactable_enable = {
			accessibility = "public",
			type = "event",
		},
		interactable_disable = {
			accessibility = "public",
			type = "event",
		},
		interactable_set_used = {
			accessibility = "public",
			type = "event",
		},
		interactable_clear_block = {
			accessibility = "public",
			type = "event",
		},
		interactable_missing_players = {
			accessibility = "public",
			type = "event",
		},
		disable_display_start_event = {
			accessibility = "public",
			type = "event",
		},
	},
}

return ExpeditionLootConverter
