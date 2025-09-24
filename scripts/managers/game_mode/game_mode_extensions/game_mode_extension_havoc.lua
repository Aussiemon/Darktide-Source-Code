-- chunkname: @scripts/managers/game_mode/game_mode_extensions/game_mode_extension_havoc.lua

local HavocSettings = require("scripts/settings/havoc_settings")
local GameModeExtensionBase = require("scripts/managers/game_mode/game_mode_extensions/game_mode_extension_base")
local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local GameModeExtensionHavoc = class("GameModeExtensionHavoc", "GameModeExtensionBase")

GameModeExtensionHavoc.init = function (self, is_server)
	GameModeExtensionHavoc.super.init(self, is_server)
end

GameModeExtensionHavoc.on_gameplay_init = function (self)
	GameModeExtensionHavoc.super.on_gameplay_init(self)

	local event_manager = Managers.event

	event_manager:register(self, "minion_unit_spawned", "_on_minion_unit_spawned")
	event_manager:register(self, "player_unit_spawned", "_on_player_unit_spawned")

	local havoc_data = Managers.state.difficulty:get_parsed_havoc_data()

	if havoc_data then
		self:_initialize_modifiers(havoc_data.modifiers)

		self._current_rank = havoc_data.havoc_rank

		if self._is_server then
			self:_initialize_server_modifiers()

			self._join_personal_mission_queue = {}
			self._join_personal_mission_queue_locked = false
		end
	end

	self._havoc_data = havoc_data
end

GameModeExtensionHavoc.destroy = function (self)
	local event_manager = Managers.event

	event_manager:unregister(self, "minion_unit_spawned")
	event_manager:unregister(self, "player_unit_spawned")
	GameModeExtensionHavoc.super.destroy(self)
end

GameModeExtensionHavoc._initialize_modifiers = function (self, havoc_modifiers)
	if not havoc_modifiers then
		Log.info("GameModeExtensionHavoc", "No modifiers found")

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

			Log.info("GameModeExtensionHavoc", "Initialized %s modifier", template_name)
		end
	end

	self._modifiers = modifiers
	self._player_buffs = player_buffs
	self._num_modifiers = num_modifiers
end

GameModeExtensionHavoc._initialize_server_modifiers = function (self)
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

GameModeExtensionHavoc.server_update = function (self, dt, t)
	if not table.is_empty(self._join_personal_mission_queue) then
		self:_update_join_personal_mission_queue()
	end
end

GameModeExtensionHavoc._update_join_personal_mission_queue = function (self)
	if self._join_personal_mission_queue_locked == true then
		return
	end

	self._join_personal_mission_queue_locked = true

	local args = table.remove(self._join_personal_mission_queue)

	Managers.backend.interfaces.orders:join_personal_mission(args.order_owner_id, args.mission_id, args.order_joiner_id):next(function ()
		self._join_personal_mission_queue_locked = false
	end)
end

GameModeExtensionHavoc.hot_join_sync = function (self, sender, channel)
	GameModeExtensionHavoc.super.hot_join_sync(self, sender, channel)

	local sender_player = Managers.player:player(sender, 1)
	local sender_account_id = sender_player and sender_player:account_id()

	if not sender_account_id then
		Log.exception("GameModeExtensionHavoc", "Unable to retrieve account id of peer %s", sender)

		return
	end

	local mission_id = Managers.mechanism:backend_mission_id()

	if not mission_id then
		return
	end

	Managers.data_service.mission_board:fetch_mission(mission_id):next(function (data)
		local order_owner_id
		local flags = data.mission and data.mission.flags

		for key, _ in pairs(flags) do
			if string.find(key, "order%-owner%-") then
				order_owner_id = string.gsub(key, "order%-owner%-", "")

				break
			end
		end

		if order_owner_id then
			local new_entry = {
				order_owner_id = order_owner_id,
				mission_id = mission_id,
				order_joiner_id = sender_account_id,
			}

			table.insert(self._join_personal_mission_queue, new_entry)
		end
	end)
end

GameModeExtensionHavoc.get_minion_health_modifier = function (self, breed)
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

GameModeExtensionHavoc._on_minion_unit_spawned = function (self, unit)
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
	local exclude_for_havoc_speed_buff = tags.exclude_for_havoc_speed_buff

	if ranged and not exclude_for_havoc_speed_buff then
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

GameModeExtensionHavoc._on_player_unit_spawned = function (self, player)
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

GameModeExtensionHavoc.get_power_level_modifier = function (self)
	local power_level_modifier = 1
	local modifier = self:get_modifier_value("melee_minion_power_level_modifier")

	if modifier then
		power_level_modifier = power_level_modifier + modifier
	end

	return power_level_modifier
end

GameModeExtensionHavoc.get_modifier_value = function (self, name)
	local modifiers = self._modifiers

	if not modifiers then
		return
	end

	return modifiers[name]
end

GameModeExtensionHavoc.get_current_rank = function (self)
	return self._current_rank
end

GameModeExtensionHavoc.get_havoc_pickup_overrides = function (self)
	return MissionOverrides.havoc_pickups and MissionOverrides.havoc_pickups.pickup_settings
end

GameModeExtensionHavoc.init_horde_buff = function (self, horde_buff_table)
	self._horde_buff_table = horde_buff_table
end

return GameModeExtensionHavoc
