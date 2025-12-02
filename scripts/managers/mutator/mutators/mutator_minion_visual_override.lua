-- chunkname: @scripts/managers/mutator/mutators/mutator_minion_visual_override.lua

local BreedResourceDependencies = require("scripts/utilities/breed_resource_dependencies")
local Breed = require("scripts/utilities/breed")
local MasterItems = require("scripts/backend/master_items")
local FixedFrame = require("scripts/utilities/fixed_frame")
local MutatorMinionVisualOverrideSettings = require("scripts/settings/mutator/mutator_mininion_visual_overrides_settings")
local MutatorMinionVisualOverride = class("MutatorMinionVisualOverride")
local LOAD_STATES = table.enum("none", "packages_load", "done")

MutatorMinionVisualOverride.init = function (self, is_server, network_event_delegate, mutator_template)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = false
	self._buffs = {}
	self._template = mutator_template
	self._packages_to_load = {}
	self._package_ids = {}
	self._load_state = LOAD_STATES.none
	self._override_template = MutatorMinionVisualOverrideSettings[self._template.template_name]

	local asset_package = {
		items = {},
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
	local breeds_to_load = BreedResourceDependencies.generate(asset_package, item_definitions)

	if table.is_empty(breeds_to_load) then
		self._load_state = LOAD_STATES.done

		return
	end

	local packages_to_load = self._packages_to_load
	local new_package_added = false

	for package_name, _ in pairs(breeds_to_load) do
		if not packages_to_load[package_name] then
			packages_to_load[package_name] = false
			new_package_added = true
		end
	end

	if not new_package_added then
		self._load_state = LOAD_STATES.done

		return
	end

	self._load_state = LOAD_STATES.packages_load

	local callback = callback(self, "_load_done_callback")
	local package_manager = Managers.package

	for package_name, loaded in pairs(packages_to_load) do
		if not loaded then
			local id = package_manager:load(package_name, "BreedLoader", callback)

			self._package_ids[id] = package_name
		end
	end
end

MutatorMinionVisualOverride._load_done_callback = function (self, id)
	local package_name = self._package_ids[id]
	local packages_to_load = self._packages_to_load

	packages_to_load[package_name] = true

	local all_packages_finished_loading = true

	for _, loaded in pairs(packages_to_load) do
		if loaded == false then
			all_packages_finished_loading = false

			break
		end
	end

	if all_packages_finished_loading then
		self._load_state = LOAD_STATES.done
	end
end

MutatorMinionVisualOverride.is_loading_done = function (self)
	return self._load_state == LOAD_STATES.done
end

MutatorMinionVisualOverride.is_loading = function (self)
	return not self:is_loading_done()
end

MutatorMinionVisualOverride.cleanup = function (self)
	return
end

MutatorMinionVisualOverride.reset = function (self)
	return
end

MutatorMinionVisualOverride._cleanup = function (self)
	local package_manager = Managers.package
	local packages = self._package_ids

	for id, package_name in pairs(packages) do
		package_manager:release(id)

		packages[id] = nil
	end

	self._load_state = LOAD_STATES.none

	table.clear(self._packages_to_load)
end

MutatorMinionVisualOverride.destroy = function (self)
	local is_server = self._is_server

	if is_server then
		self:_remove_buffs()
	end

	self:_cleanup()
end

MutatorMinionVisualOverride.hot_join_sync = function (self, sender, channel)
	return
end

MutatorMinionVisualOverride.on_gameplay_post_init = function (self, level, themes)
	return
end

MutatorMinionVisualOverride.on_spawn_points_generated = function (self, level, themes)
	return
end

MutatorMinionVisualOverride.update = function (self, dt, t)
	return
end

MutatorMinionVisualOverride.activate = function (self)
	self._is_active = true

	if self._is_server then
		local template = self._template

		if template.buff_templates then
			self:_add_buffs(template.buff_templates)
		end
	end
end

MutatorMinionVisualOverride._add_buffs = function (self, buff_template_names)
	local buff_system = Managers.state.extension:system("buff_system")
	local buff_extensions = buff_system:unit_to_extension_map()

	for unit, _ in pairs(buff_extensions) do
		self:_add_buffs_on_unit(buff_template_names, unit)
	end
end

MutatorMinionVisualOverride._add_buffs_on_unit = function (self, buff_template_names, unit, optional_ignored_keyword, optional_internally_controlled)
	local buff_extension = ScriptUnit.extension(unit, "buff_system")

	if optional_ignored_keyword and buff_extension:has_keyword(optional_ignored_keyword) then
		return
	end

	local buffs = self._buffs

	buffs[unit] = buffs[unit] or {}

	local buff_ids = buffs[unit]
	local current_time = FixedFrame.get_latest_fixed_time()

	for i = 1, #buff_template_names do
		local buff_template_name = buff_template_names[i]
		local is_valid_target = buff_extension:is_valid_target(buff_template_name)

		if is_valid_target then
			if optional_internally_controlled then
				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff(buff_template_name, t)
			else
				local _, local_index, component_index = buff_extension:add_externally_controlled_buff(buff_template_name, current_time)

				buff_ids[#buff_ids + 1] = {
					local_index = local_index,
					component_index = component_index,
				}
			end

			buff_extension:_update_stat_buffs_and_keywords(current_time)
		end
	end
end

MutatorMinionVisualOverride.is_active = function (self)
	return self._is_active
end

MutatorMinionVisualOverride.deactivate = function (self)
	if self._is_server then
		self:_remove_buffs()
	end

	self._is_active = false
end

MutatorMinionVisualOverride._remove_buffs = function (self)
	local buffs = self._buffs
	local ALIVE = ALIVE

	for unit, buff_ids in pairs(buffs) do
		if ALIVE[unit] then
			local buff_extension = ScriptUnit.extension(unit, "buff_system")

			for _, buff_indices in ipairs(buff_ids) do
				local local_index = buff_indices.local_index
				local component_index = buff_indices.component_index

				buff_extension:remove_externally_controlled_buff(local_index, component_index)
			end
		else
			buffs[unit] = nil
		end
	end
end

MutatorMinionVisualOverride._on_player_unit_spawned = function (self, player)
	local template = self._template
	local is_server = self._is_server
	local buff_template_names = template.buff_templates

	if is_server and buff_template_names then
		local player_unit = player.player_unit
		local internally_controlled = template.internally_controlled_buffs

		self:_add_buffs_on_unit(buff_template_names, player_unit, nil, internally_controlled)
	end
end

MutatorMinionVisualOverride._on_player_unit_despawned = function (self, player)
	return
end

MutatorMinionVisualOverride._on_minion_unit_spawned = function (self, unit)
	local template = self._template
	local is_server = self._is_server
	local buff_template_names = template.buff_templates

	if is_server and buff_template_names then
		self:_add_buffs_on_unit(buff_template_names, unit)
	end

	local random_spawn_buff_templates = template.random_spawn_buff_templates

	if is_server and random_spawn_buff_templates then
		local buffs = random_spawn_buff_templates.buffs
		local breed = Breed.unit_breed_or_nil(unit)
		local breed_name = breed.name
		local breed_chances = random_spawn_buff_templates.breed_chances
		local breed_chance = breed_chances[breed_name]

		if breed_chance and breed_chance > math.random() then
			self:_change_visual_loadout_equipment(unit)
			self:_add_buffs_on_unit(buffs, unit, random_spawn_buff_templates.ignored_buff_keyword)
		end
	end
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
