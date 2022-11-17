require("scripts/extension_systems/buff/buffs/buff")

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Health = require("scripts/utilities/health")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local attack_types = AttackSettings.attack_types
local GrimoireBuff = class("GrimoireBuff", "Buff")

GrimoireBuff.init = function (self, context, template, start_time, instance_id, ...)
	GrimoireBuff.super.init(self, context, template, start_time, instance_id, ...)

	self._num_grims = 0
	self._tick_timer = math.huge
	self._is_server = context.is_server
end

GrimoireBuff.update = function (self, dt, t, portable_random)
	GrimoireBuff.super.update(self, dt, t, portable_random)

	if not self._is_server then
		return
	end

	local num_grims = 0
	local players = Managers.player:players()

	for _, player in pairs(players) do
		local has_grim = self:_player_has_grimoire_equipped(player)

		if has_grim then
			num_grims = num_grims + 1
		end
	end

	local previous_num_grims = self._num_grims

	if num_grims < previous_num_grims then
		local diff = previous_num_grims - num_grims

		for i = 1, diff do
			local heal_type = DamageSettings.heal_types.blessing_grim
			local health_added = Health.add(self._unit, 30, heal_type)

			if health_added > 0 then
				Health.play_fx(self._unit)
			end
		end
	end

	if num_grims > 0 then
		local tick_timer, power_level = self:_calculate_tick_time_and_power_level(num_grims)

		if tick_timer <= self._tick_timer then
			self:_damage_player(power_level)

			self._tick_timer = 0
		else
			self._tick_timer = self._tick_timer + dt
		end
	end

	self._num_grims = num_grims
end

GrimoireBuff._player_has_grimoire_equipped = function (self, player)
	local player_unit = player.player_unit

	if not ALIVE[player_unit] then
		return false
	end

	local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
	local has_grim = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(visual_loadout_extension, "slot_pocketable", "grimoire")

	return has_grim
end

GrimoireBuff._calculate_tick_time_and_power_level = function (self, num_grims)
	local health_extension = ScriptUnit.extension(self._unit, "health_system")
	local permanent_damage_taken = health_extension:permanent_damage_taken()
	local grimoire_chunk = num_grims * 40

	if permanent_damage_taken < grimoire_chunk then
		local diff = grimoire_chunk - permanent_damage_taken
		local scalar = 1 - diff / grimoire_chunk

		return math.lerp(0.4, 1.6, scalar), math.lerp(500, 300, scalar)
	end

	return 10, 60
end

GrimoireBuff._damage_player = function (self, power_level)
	local unit = self._unit
	local damage_profile = DamageProfileTemplates.grimoire_tick
	local target_index = 0
	local is_critical_strike = false

	Attack.execute(unit, damage_profile, "target_index", target_index, "power_level", power_level, "is_critical_strike", is_critical_strike, "attack_type", attack_types.buff, "damage_type", DamageSettings.damage_types.grimoire)
end

return GrimoireBuff
