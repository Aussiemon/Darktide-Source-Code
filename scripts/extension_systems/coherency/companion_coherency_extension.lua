-- chunkname: @scripts/extension_systems/coherency/companion_coherency_extension.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSettings.special_rules
local STAT_REPORT_TIME = 1
local CompanionCoherencyExtension = class("CompanionCoherencyExtension")

CompanionCoherencyExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._owner_player = extension_init_data.owner_player
	self._owner_player_unit = self._owner_player.player_unit
	self._unit = unit
	self._in_coherence_units = {}
	self._num_units_in_coherence = 0
	self._free_external_buff_indexes = {}
	self._external_buff_template_names = {}
	self._valid_buff_owners = {}
	self.side = ScriptUnit.extension(unit, "side_system").side
	self._buff_extension = ScriptUnit.has_extension(self._owner_player_unit, "buff_system")
	self._coherency_settings = extension_init_data.coherency_settings
	self._stat_record_timer = 0

	local talent_extension = ScriptUnit.has_extension(self._owner_player_unit, "talent_system")

	self._talent_extension = talent_extension

	local has_special_rule = talent_extension and talent_extension:has_special_rule(special_rules.adamant_dog_counts_towards_coherency)

	self.disabled = not has_special_rule
end

CompanionCoherencyExtension.destroy = function (self)
	self._in_coherence_units = {}
	self._num_units_in_coherence = 0
	self._coherency_buff_indexes = {}
	self._buff_extension = nil
end

CompanionCoherencyExtension.update = function (self, unit, dt, t)
	return
end

CompanionCoherencyExtension.fixed_update = function (self, unit, dt, t)
	return
end

CompanionCoherencyExtension.in_coherence_units = function (self)
	return self._in_coherence_units
end

CompanionCoherencyExtension.num_units_in_coherency = function (self)
	return self._num_units_in_coherence
end

CompanionCoherencyExtension._get_valid_buff_owners = function (self, buff_id)
	table.clear(self._valid_buff_owners)

	for coherency_unit, _ in pairs(self._in_coherence_units) do
		local talent_extension = ScriptUnit.extension(coherency_unit, "talent_system")
		local player_current_talents = talent_extension:talents()

		if player_current_talents[buff_id] then
			local player = Managers.state.player_unit_spawn:owner(coherency_unit)

			table.insert(self._valid_buff_owners, player)
		end
	end

	return self._valid_buff_owners
end

CompanionCoherencyExtension.add_external_buff = function (self, buff_name)
	local free_external_buff_indexes = self._free_external_buff_indexes
	local index
	local num_free_external_buff_indexes = #free_external_buff_indexes

	if num_free_external_buff_indexes == 0 then
		index = 1
	else
		for i = 1, num_free_external_buff_indexes do
			local is_free = free_external_buff_indexes[i]

			if is_free == true then
				index = i

				break
			end
		end
	end

	index = index or num_free_external_buff_indexes + 1
	self._free_external_buff_indexes[index] = false
	self._external_buff_template_names[index] = buff_name

	return index
end

CompanionCoherencyExtension.remove_external_buff = function (self, index)
	self._free_external_buff_indexes[index] = true
	self._external_buff_template_names[index] = nil
end

CompanionCoherencyExtension.coherency_data = function (self)
	return self._coherency_data
end

CompanionCoherencyExtension.coherency_settings = function (self)
	local radius, limit = self:current_radius()
	local stickiness_time = self:current_stickiness_time()

	return radius, limit, stickiness_time
end

CompanionCoherencyExtension.buff_template_names = function (self)
	return self._coherency_settings.buff_template_names
end

CompanionCoherencyExtension.external_buff_template_names = function (self)
	return self._external_buff_template_names
end

CompanionCoherencyExtension.base_radius = function (self)
	return self._coherency_settings.radius, self._coherency_settings.stickiness_limit
end

CompanionCoherencyExtension.current_radius = function (self)
	local modifier = 1

	if HEALTH_ALIVE[self._owner_player_unit] and self._buff_extension then
		local buffs = self._buff_extension:stat_buffs()
		local buff_modifier = buffs.coherency_radius_modifier or 1
		local buff_multiplier = buffs.coherency_radius_multiplier or 1

		modifier = buff_modifier * buff_multiplier
	end

	local radius, stickiness_limit = self:base_radius()

	radius = radius * modifier

	if HEALTH_ALIVE[self._owner_player_unit] and self._buff_extension then
		local no_stickiness_limit = self._buff_extension:has_keyword(buff_keywords.no_coherency_stickiness_limit)

		if no_stickiness_limit then
			stickiness_limit = nil
		end
	end

	stickiness_limit = stickiness_limit and stickiness_limit * modifier or nil

	return radius, stickiness_limit
end

CompanionCoherencyExtension.current_stickiness_time = function (self)
	local stickiness_time = self._coherency_settings.stickiness_time

	if HEALTH_ALIVE[self._owner_player_unit] and self._buff_extension then
		local buffs = self._buff_extension:stat_buffs()
		local stickiness_time_value = buffs.coherency_stickiness_time_value or 0

		stickiness_time = stickiness_time + stickiness_time_value
	end

	return stickiness_time
end

CompanionCoherencyExtension.hot_join_sync = function (self, unit, sender, channel_id)
	return
end

CompanionCoherencyExtension.on_coherency_enter = function (self, coherency_unit, coherency_extension, t)
	self._in_coherence_units[coherency_unit] = coherency_extension

	local prev_num_units_in_coherency = self._num_units_in_coherence

	self._num_units_in_coherence = prev_num_units_in_coherency + 1
end

CompanionCoherencyExtension.on_coherency_exit = function (self, coherency_unit, coherency_extension, t)
	self._num_units_in_coherence = self._num_units_in_coherence - 1
	self._in_coherence_units[coherency_unit] = nil
end

CompanionCoherencyExtension.update_buffs_for_unit = function (self, unit, extension)
	return
end

CompanionCoherencyExtension._send_rpc = function (self, rpc_name, other_unit)
	local my_game_object_id = Managers.state.unit_spawner:game_object_id(self._unit)
	local other_game_object_id = Managers.state.unit_spawner:game_object_id(other_unit)

	Managers.state.game_session:send_rpc_clients(rpc_name, my_game_object_id, other_game_object_id)
end

return CompanionCoherencyExtension
