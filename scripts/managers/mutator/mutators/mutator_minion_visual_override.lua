-- chunkname: @scripts/managers/mutator/mutators/mutator_minion_visual_override.lua

require("scripts/managers/mutator/mutators/mutator_base")

local Breed = require("scripts/utilities/breed")
local BreedResourceDependencies = require("scripts/utilities/breed_resource_dependencies")
local MasterItems = require("scripts/backend/master_items")
local MutatorMinionVisualOverrideSettings = require("scripts/settings/mutator/mutator_minion_visual_overrides_settings")
local MutatorMinionVisualOverride = class("MutatorMinionVisualOverride", "MutatorBase")

MutatorMinionVisualOverride.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	self._override_template = MutatorMinionVisualOverrideSettings[mutator_template.template_name]

	MutatorMinionVisualOverride.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
end

MutatorMinionVisualOverride._load_subnode_packages = function (self, package_collector)
	local packages = self._required_visual_packages

	if not packages then
		local asset_package = {
			items = {}
		}

		for _, override_entry in pairs(self._override_template) do
			if override_entry.item_slot_data then
				for name, item_data in pairs(override_entry.item_slot_data) do
					for i = 1, #item_data.items do
						local item = item_data.items[i]

						if not asset_package.items[item] then
							asset_package.items[#asset_package.items + 1] = item
						end
					end
				end
			end

			if override_entry.has_gib_override then
				for name, item_data in pairs(override_entry.has_gib_override) do
					asset_package.items[#asset_package.items + 1] = item_data
				end
			end
		end

		local item_definitions = MasterItems.get_cached()

		packages = BreedResourceDependencies.generate(asset_package, item_definitions)
		self._required_visual_packages = packages
	end

	for package_name, _ in pairs(packages) do
		package_collector:add_package(package_name)
	end
end

MutatorMinionVisualOverride._on_random_spawn_buff_triggered = function (self, unit)
	self:_change_visual_loadout_equipment(unit)
end

MutatorMinionVisualOverride._change_visual_loadout_equipment = function (self, unit)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local breed = Breed.unit_breed_or_nil(unit)
	local breed_name = breed.name
	local override_template = self._override_template
	local template

	if override_template[breed_name] then
		template = override_template[breed_name]
	end

	if template == nil then
		for tag, _ in pairs(breed.tags) do
			if override_template[tag] then
				template = override_template[tag]

				break
			end
		end
	end

	if template == nil then
		template = override_template.default
	end

	visual_loadout_extension:override_slot(self._template.template_name, template)
end

return MutatorMinionVisualOverride
