-- chunkname: @scripts/managers/havoc/havoc_manager.lua

local Havoc = require("scripts/utilities/havoc")
local HavocSettings = require("scripts/settings/havoc_settings")
local HavocManager = class("HavocManager")

HavocManager.init = function (self, is_server, world, nav_world, level_name, level_seed, pacing_control)
	self._is_server = is_server

	local event_manager = Managers.event

	event_manager:register(self, "minion_unit_spawned", "_on_minion_unit_spawned")
	event_manager:register(self, "player_unit_spawned", "_on_player_unit_spawned")

	local havoc_data = Managers.state.difficulty:get_parsed_havoc_data()

	if havoc_data then
		self:_initialize_modifiers(havoc_data)

		self._current_rank = havoc_data.havoc_rank
	end

	self._havoc_data = havoc_data
end

HavocManager.destroy = function (self)
	local event_manager = Managers.event

	event_manager:unregister(self, "minion_unit_spawned")
	event_manager:unregister(self, "player_unit_spawned")
end

HavocManager._initialize_modifiers = function (self, havoc_data)
	local havoc_modifiers = havoc_data.modifiers

	if not havoc_modifiers then
		Log.info("HavocManager", "No modifiers found")

		return
	end

	local modifiers = {}
	local player_buffs = {}
	local modifier_templates = HavocSettings.modifier_templates
	local positive_modifier_templates = HavocSettings.positive_modifier_templates
	local num_modifiers = 0

	for i = 1, #havoc_modifiers do
		local backend_modifier = havoc_modifiers[i]
		local name = backend_modifier.name
		local level = backend_modifier.level
		local modifier_template = modifier_templates[name] and modifier_templates[name][level] or positive_modifier_templates[name][level]

		for template_name, template_value in pairs(modifier_template) do
			if template_name == "add_player_buff" then
				player_buffs[#player_buffs + 1] = template_value
			else
				modifiers[template_name] = template_value
			end

			num_modifiers = num_modifiers + 1

			Log.info("HavocManager", "Initialized %s modifier", template_name)
		end
	end

	self._modifiers = modifiers
	self._player_buffs = player_buffs
	self._num_modifiers = num_modifiers

	if not self._is_server then
		return
	end

	local tag_bonus = {}
	local more_elites = self:get_modifier_value("add_more_elites")

	if more_elites then
		tag_bonus.elite = more_elites
	end

	local more_ogryns = self:get_modifier_value("add_more_ogryns")

	if more_ogryns then
		tag_bonus.ogryn = more_ogryns

		if not tag_bonus.elite then
			tag_bonus.elite = more_ogryns
		end
	end

	local ammo_pickup_modifier = self:get_modifier_value("ammo_pickup_modifier")

	if ammo_pickup_modifier then
		Managers.state.difficulty:set_ammo_modifier(ammo_pickup_modifier)
	end

	local horde_spawn_rate_modifier = self:get_modifier_value("horde_spawn_rate_modifier")

	if horde_spawn_rate_modifier then
		Managers.state.pacing:set_horde_rate_modifier(1 + horde_spawn_rate_modifier)
	end

	local terror_event_point_modifier = self:get_modifier_value("terror_event_point_modifier")

	if terror_event_point_modifier then
		Managers.state.terror_event:set_terror_event_point_modifier(terror_event_point_modifier)
	end

	Managers.state.pacing:set_roamer_tag_limit_bonus(tag_bonus)
end

HavocManager.minion_health_modifier = function (self, breed)
	if not self._modifiers or self._num_modifiers == 0 then
		return
	end

	local modifier = 0
	local tags = breed.tags
	local elite = tags.elite

	if elite then
		local elite_health_modifier = self:get_modifier_value("modify_elite_health") or 0

		modifier = modifier + elite_health_modifier
	end

	local special = tags.special

	if special then
		local special_health_modifier = self:get_modifier_value("modify_special_health") or 0

		modifier = modifier + special_health_modifier
	end

	local monster = tags.monster

	if monster then
		local monster_health_modifier = self:get_modifier_value("modify_monster_health") or 0

		modifier = modifier + monster_health_modifier
	end

	local horde = tags.horde

	if horde then
		local modify_horde_health = self:get_modifier_value("modify_horde_health") or 0

		modifier = modifier + modify_horde_health
	end

	return modifier
end

HavocManager._on_minion_unit_spawned = function (self, unit)
	if not self._modifiers or self._num_modifiers == 0 then
		return
	end

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()
	local tags = breed.tags
	local horde = tags.horde

	if horde then
		local modify_horde_hit_mass = self:get_modifier_value("modify_horde_hit_mass") or 0

		if modify_horde_hit_mass > 0 then
			local modifier = 1 + modify_horde_hit_mass
			local health_extension = ScriptUnit.extension(unit, "health_system")
			local current_hit_mass = health_extension:hit_mass()

			health_extension:set_hit_mass(current_hit_mass * modifier)
		end
	end

	local melee = tags.melee

	if melee then
		local melee_minion_attack_speed_buff = self:get_modifier_value("melee_minion_attack_speed_buff")

		if melee_minion_attack_speed_buff then
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff(melee_minion_attack_speed_buff, t)
		end

		local melee_minion_permanent_damage_buff = self:get_modifier_value("melee_minion_permanent_damage_buff")

		if melee_minion_permanent_damage_buff then
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff(melee_minion_permanent_damage_buff, t)
		end
	end

	local ranged = tags.far or tags.close

	if ranged then
		local ranged_minion_attack_speed_buff = self:get_modifier_value("ranged_minion_attack_speed_buff")

		if ranged_minion_attack_speed_buff then
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff(ranged_minion_attack_speed_buff, t)
		end
	end

	if self._horde_buff_table then
		local allowed_breeds = self._horde_buff_table.horde_buffed_config.breed_allowed
		local buff_to_add = self._horde_buff_table.horde_buffed_config.buff_name
		local blackboard = BLACKBOARDS[unit]
		local perception_component = blackboard.perception
		local aggro_state = perception_component.aggro_state

		if aggro_state == "aggroed" and allowed_breeds[breed.name] then
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end
	end
end

HavocManager._on_player_unit_spawned = function (self, player)
	local player_unit = player.player_unit
	local player_buffs = self._player_buffs

	if not player_buffs then
		return
	end

	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local t = Managers.time:time("gameplay")

	for i = 1, #player_buffs do
		local buff = player_buffs[i]

		buff_extension:add_internally_controlled_buff(buff, t)
	end
end

HavocManager.get_power_level_modifier = function (self, attack_type)
	local power_level_modifier = 1

	if attack_type == "melee" then
		local modifier = self:get_modifier_value("melee_minion_power_level_modifier")

		if modifier then
			power_level_modifier = power_level_modifier + modifier
		end
	end

	return power_level_modifier
end

HavocManager.get_modifier_value = function (self, name)
	local modifiers = self._modifiers

	if not modifiers then
		return
	end

	return modifiers[name]
end

HavocManager.get_modifiers = function (self)
	return self._modifiers
end

HavocManager.get_current_rank = function (self)
	return self._current_rank
end

HavocManager.is_havoc = function (self)
	if self._havoc_data then
		return true
	else
		return false
	end
end

HavocManager.init_horde_buff = function (self, horde_buff_table)
	self._horde_buff_table = horde_buff_table
end

return HavocManager
