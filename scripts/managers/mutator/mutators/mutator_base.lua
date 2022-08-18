local MutatorBase = class("MutatorBase")

MutatorBase.init = function (self, is_server, network_event_delegate, mutator_template)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = false
	self._buffs = {}
	self._template = mutator_template
end

MutatorBase.destroy = function (self)
	local is_server = self._is_server

	if is_server then
		self:_remove_buffs()
	end
end

MutatorBase.hot_join_sync = function (self, sender, channel)
	return
end

MutatorBase.on_gameplay_post_init = function (self, level, themes)
	return
end

MutatorBase.update = function (self, dt, t)
	return
end

MutatorBase.is_active = function (self)
	return self._is_active
end

MutatorBase.activate = function (self)
	self._is_active = true

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

MutatorBase._add_buffs_on_unit = function (self, buff_template_names, unit)
	local buffs = self._buffs
	buffs[unit] = buffs[unit] or {}
	local buff_ids = buffs[unit]
	local current_time = Managers.time:time("gameplay")
	local buff_extension = ScriptUnit.extension(unit, "buff_system")

	for _, buff_template_name in ipairs(buff_template_names) do
		local _, local_index, component_index = buff_extension:add_externally_controlled_buff(buff_template_name, current_time)
		buff_ids[#buff_ids + 1] = {
			local_index = local_index,
			component_index = component_index
		}
	end
end

MutatorBase.deactivate = function (self)
	if self._is_server then
		self:_remove_buffs()
	end

	self._is_active = false
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
	fassert(player:unit_is_alive(), "[MutatorBase][_on_assign_player_unit_ownership] Player is expected to have a unit alive here.")

	local template = self._template
	local is_server = self._is_server
	local buff_template_names = template.buff_templates

	if is_server and buff_template_names then
		local player_unit = player.player_unit

		self:_add_buffs_on_unit(buff_template_names, player_unit)
	end
end

MutatorBase._on_player_unit_despawned = function (self, player)
	return
end

MutatorBase._on_minion_unit_spawned = function (self, unit)
	fassert(ALIVE[unit], "[MutatorBase][_on_minion_unit_spawned] Minion Unit is expected to be alive.")

	local template = self._template
	local is_server = self._is_server
	local buff_template_names = template.buff_templates

	if is_server and buff_template_names then
		self:_add_buffs_on_unit(buff_template_names, unit)
	end
end

return MutatorBase
