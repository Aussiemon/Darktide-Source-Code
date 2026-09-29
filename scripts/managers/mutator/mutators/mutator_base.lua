-- chunkname: @scripts/managers/mutator/mutators/mutator_base.lua

local Breed = require("scripts/utilities/breed")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PackageScope = require("scripts/foundation/managers/package/utilities/package_scope")
local MutatorBase = class("MutatorBase")

MutatorBase.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = false
	self._buffs = {}
	self._template = mutator_template
	self._nav_world = nav_world
	self._world = world
	self._physics_world = World.physics_world(world)
	self._seed = level_seed
	self._required_packages = {}
	self._is_loaded = false
	self._package_scope = PackageScope:new(self.__class_name)

	self:_load_all_asset_packages()
end

MutatorBase.destroy = function (self)
	local is_server = self._is_server

	if is_server then
		self:_remove_buffs()
	end

	table.clear(self._required_packages)

	self._is_loaded = false

	self._package_scope:delete()
end

MutatorBase.hot_join_sync = function (self, sender, channel)
	return
end

MutatorBase.on_gameplay_post_init = function (self, level, themes)
	return
end

MutatorBase.on_spawn_points_generated = function (self, level, themes)
	return
end

MutatorBase.update = function (self, dt, t)
	return
end

MutatorBase.is_active = function (self)
	return self._is_active
end

MutatorBase.is_loading_done = function (self)
	return self._is_loaded
end

MutatorBase.is_loading = function (self)
	if self._is_loaded then
		return false
	end

	local package_manager = Managers.package

	for i = 1, #self._required_packages do
		if not package_manager:has_loaded(self._required_packages[i]) then
			return true
		end
	end

	if not self._is_loaded and self._template.activate_on_load then
		self:activate()
	end

	self._is_loaded = true

	return false
end

MutatorBase._load_all_asset_packages = function (self)
	local root_package = self._template.asset_package
	local required_packages = {}
	local package_collector = {
		add_package = function (_, package_name)
			required_packages[#required_packages + 1] = package_name
		end,
	}

	if root_package then
		package_collector:add_package(root_package)
	end

	self:_load_subnode_packages(package_collector)

	self._required_packages = required_packages
	self._is_loaded = #self._required_packages == 0

	if root_package then
		self._package_scope:add_package(root_package, callback(self, "_load_subnode_packages", self._package_scope))
	else
		self:_load_subnode_packages(self._package_scope)
	end
end

MutatorBase._load_subnode_packages = function (self, package_scope)
	return
end

MutatorBase.activate = function (self)
	if self._is_active then
		Log.warning("[" .. self.__class_name .. "]", "attempting to activate an active mutator")

		return
	end

	self._is_active = true

	self:_register_event_listeners()

	if self._is_server then
		local template = self._template

		if template.buff_templates then
			self:_add_buffs(template.buff_templates)
		end
	end
end

MutatorBase._add_buffs = function (self, buff_template_names)
	local buff_system = Managers.state.extension:system("buff_system")
	local buff_extensions = buff_system:unit_to_extension_map()

	for unit, _ in pairs(buff_extensions) do
		self:_add_buffs_on_unit(buff_template_names, unit)
	end
end

MutatorBase._add_buffs_on_unit = function (self, buff_template_names, unit, optional_ignored_keyword, optional_internally_controlled)
	if self:_is_breed_excluded(unit) then
		return
	end

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

MutatorBase._is_breed_excluded = function (self, unit)
	local excluded_breed_tags = self._template.excluded_breed_tags
	local excluded_breeds = self._template.excluded_breeds

	if excluded_breed_tags == nil and excluded_breeds == nil then
		return false
	end

	local breed = Breed.unit_breed_or_nil(unit)

	if not breed then
		return false
	end

	if excluded_breeds and table.contains(excluded_breeds, breed.name) then
		return true
	end

	if excluded_breed_tags then
		local tags = breed.tags

		for i = 1, #excluded_breed_tags do
			if tags[excluded_breed_tags[i]] then
				return true
			end
		end
	end

	return false
end

MutatorBase.deactivate = function (self)
	if not self._is_active then
		return
	end

	self:_remove_event_listeners()

	if self._is_server then
		self:_remove_buffs()
	end

	self._is_active = false
end

MutatorBase.reset = function (self)
	return
end

MutatorBase._remove_buffs = function (self)
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

MutatorBase._on_player_unit_spawned = function (self, player)
	local template = self._template
	local is_server = self._is_server
	local buff_template_names = template.buff_templates

	if is_server and buff_template_names then
		local player_unit = player.player_unit
		local internally_controlled = template.internally_controlled_buffs

		self:_add_buffs_on_unit(buff_template_names, player_unit, nil, internally_controlled)
	end
end

MutatorBase._on_player_unit_despawned = function (self, player)
	return
end

MutatorBase._on_minion_unit_spawned = function (self, unit)
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

		if type(breed_chance) == "table" then
			breed_chance = Managers.state.difficulty:get_table_entry_by_resistance(breed_chance)
		end

		if breed_chance and breed_chance > math.random() then
			self:_add_buffs_on_unit(buffs, unit, random_spawn_buff_templates.ignored_buff_keyword)
			self:_on_random_spawn_buff_triggered(unit)
		end
	end
end

MutatorBase._on_random_spawn_buff_triggered = function (self, unit)
	return
end

MutatorBase._register_event_listeners = function (self)
	if not self._is_server then
		return
	end

	local event_listeners = self._template.trigger_on_events

	if not event_listeners then
		return
	end

	for event_trigger, event_settings in pairs(event_listeners) do
		Managers.event:register_with_parameters(self, event_trigger, "_on_" .. event_trigger, event_settings or {})
	end
end

MutatorBase._remove_event_listeners = function (self)
	if not self._is_server then
		return
	end

	local event_listeners = self._template.trigger_on_events

	if not event_listeners then
		return
	end

	for event_trigger, _ in pairs(event_listeners) do
		Managers.event:unregister(self, event_trigger)
	end
end

return MutatorBase
