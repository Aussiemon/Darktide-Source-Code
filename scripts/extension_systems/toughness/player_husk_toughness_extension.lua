local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local PlayerHuskToughnessExtension = class("PlayerHuskToughnessExtension")
local _max_toughness_and_toughness_damage = nil

PlayerHuskToughnessExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id, owner_id)
	self._unit = unit
	self._game_session = game_session
	self._game_object_id = game_object_id
	self._world = extension_init_context.world
	self._wwise_world = Wwise.wwise_world(self._world)
	self._fx_extension = ScriptUnit.extension(unit, "fx_system")
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local toughness_template = extension_init_data.toughness_template
	self._toughness_template = toughness_template
	local is_local_unit = extension_init_data.is_local_unit
	self._is_local_unit = is_local_unit

	if is_local_unit then
		local component_name = PlayerUnitData.looping_sound_component_name("toughness_loop")
		self._looping_sound_component = unit_data_extension:read_component(component_name)
	end
end

PlayerHuskToughnessExtension.toughness_templates = function (self)
	return self._toughness_template, nil
end

PlayerHuskToughnessExtension.toughness_damage = function (self)
	local _, toughness_damage = _max_toughness_and_toughness_damage(self._game_session, self._game_object_id)

	return toughness_damage
end

PlayerHuskToughnessExtension.current_toughness_percent_visual = function (self)
	local max_toughness_visual = self:max_toughness_visual()
	local max_toughness = self:max_toughness()
	local bonus_toughness = max_toughness - max_toughness_visual
	local toughness_damage = self:toughness_damage()
	toughness_damage = math.clamp(toughness_damage - bonus_toughness, 0, toughness_damage)

	return 1 - toughness_damage / self:max_toughness_visual()
end

PlayerHuskToughnessExtension.max_toughness_visual = function (self)
	local buff_extension = ScriptUnit.has_extension(self._unit, "buff_system")
	local buffs = buff_extension and buff_extension:stat_buffs()
	local bonus = buffs and buffs.toughness_bonus_flat or 0
	local max_toughness = self:max_toughness()
	local max_toughness_visual = max_toughness - bonus

	return max_toughness_visual
end

PlayerHuskToughnessExtension.max_toughness = function (self)
	local max_toughness, _ = _max_toughness_and_toughness_damage(self._game_session, self._game_object_id)

	return max_toughness
end

PlayerHuskToughnessExtension.current_toughness_percent = function (self)
	local max_toughness, toughness_damage = _max_toughness_and_toughness_damage(self._game_session, self._game_object_id)

	return 1 - toughness_damage / max_toughness
end

PlayerHuskToughnessExtension.recover_toughness = function (self)
	return
end

PlayerHuskToughnessExtension.recover_percentage_toughness = function (self)
	return
end

PlayerHuskToughnessExtension.recover_max_toughness = function (self)
	return
end

function _max_toughness_and_toughness_damage(game_session, game_object_id)
	local max_toughness = GameSession.game_object_field(game_session, game_object_id, "toughness")
	local toughness_damage = GameSession.game_object_field(game_session, game_object_id, "toughness_damage")

	return max_toughness, toughness_damage
end

return PlayerHuskToughnessExtension
