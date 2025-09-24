-- chunkname: @scripts/settings/havoc/havoc_modifier_config.lua

local havoc_modifier_config = {
	{
		reduce_health_and_wounds = 1,
	},
	{
		reduce_toughness = 1,
		reduce_toughness_regen = 1,
	},
	{
		ammo_pickup_modifier = 1,
		havoc_vent_speed_reduction = 1,
	},
	{
		terror_event_point_increase = 1,
	},
	{
		buff_elites = 1,
		buff_specials = 1,
		more_alive_specials = 1,
	},
	{
		buff_monsters = 1,
	},
	{
		buff_horde = 1,
	},
	{
		melee_minion_attack_speed = 1,
		ranged_minion_attack_speed = 1,
	},
	{
		melee_minion_permanent_damage = 1,
		melee_minion_power_level_buff = 1,
	},
	{
		horde_spawn_rate_increase = 1,
		more_elites = 1,
		more_ogryns = 1,
	},
	{
		reduce_health_and_wounds = 2,
	},
	{
		reduce_toughness = 2,
	},
	{
		reduce_toughness_regen = 2,
	},
	{
		ammo_pickup_modifier = 2,
		havoc_vent_speed_reduction = 2,
		melee_minion_power_level_buff = 2,
	},
	{
		horde_spawn_rate_increase = 2,
		more_alive_specials = 2,
		terror_event_point_increase = 2,
	},
	{
		buff_monsters = 2,
		melee_minion_power_level_buff = 3,
		reduce_toughness_regen = 3,
	},
	{
		buff_horde = 2,
		melee_minion_attack_speed = 2,
		ranged_minion_attack_speed = 2,
	},
	{
		buff_elites = 2,
		melee_minion_permanent_damage = 2,
	},
	{
		buff_specials = 2,
		reduce_toughness = 3,
		terror_event_point_increase = 3,
	},
	{
		buff_horde = 3,
		horde_spawn_rate_increase = 3,
		more_elites = 3,
		more_ogryns = 3,
	},
	{
		ammo_pickup_modifier = 3,
		havoc_vent_speed_reduction = 3,
		reduce_health_and_wounds = 3,
	},
	{
		melee_minion_attack_speed = 3,
		melee_minion_permanent_damage = 3,
		ranged_minion_attack_speed = 3,
	},
	{
		buff_elites = 3,
		buff_monsters = 3,
		reduce_health_and_wounds = 4,
	},
	{
		ammo_pickup_modifier = 4,
		havoc_vent_speed_reduction = 4,
		more_alive_specials = 3,
		reduce_toughness = 4,
	},
	{
		buff_horde = 4,
		buff_specials = 3,
		horde_spawn_rate_increase = 4,
		melee_minion_permanent_damage = 4,
		reduce_toughness_regen = 4,
	},
	{
		buff_specials = 4,
		more_alive_specials = 4,
		reduce_health_and_wounds = 5,
		terror_event_point_increase = 4,
	},
	{
		buff_monsters = 4,
		melee_minion_attack_speed = 4,
		ranged_minion_attack_speed = 4,
	},
	{
		melee_minion_power_level_buff = 4,
		more_ogryns = 4,
	},
	{
		buff_elites = 4,
		more_elites = 4,
	},
	{
		ammo_pickup_modifier = 5,
		havoc_vent_speed_reduction = 5,
		horde_spawn_rate_increase = 5,
	},
	{
		more_elites = 5,
		more_ogryns = 5,
	},
	{
		melee_minion_attack_speed = 5,
		melee_minion_power_level_buff = 5,
		ranged_minion_attack_speed = 5,
	},
	{
		melee_minion_permanent_damage = 5,
		reduce_toughness = 5,
	},
	{
		reduce_toughness_regen = 5,
		terror_event_point_increase = 5,
	},
	{
		buff_horde = 5,
		horde_spawn_rate_increase = 6,
	},
	{
		more_alive_specials = 5,
	},
	{
		buff_monsters = 5,
	},
	{
		buff_specials = 5,
	},
	{
		buff_elites = 5,
	},
	{
		horde_spawn_rate_increase = 7,
	},
}
local previous_table

for _, modifer_table in ipairs(havoc_modifier_config) do
	if previous_table ~= nil then
		for name, tier in pairs(previous_table) do
			if not modifer_table[name] then
				modifer_table[name] = tier
			end
		end
	end

	previous_table = modifer_table
end

return settings("HavocModiferConfig", havoc_modifier_config)
