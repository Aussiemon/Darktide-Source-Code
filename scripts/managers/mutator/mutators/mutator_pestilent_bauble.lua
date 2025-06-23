-- chunkname: @scripts/managers/mutator/mutators/mutator_pestilent_bauble.lua

require("scripts/managers/mutator/mutators/mutator_base")

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local MasterItems = require("scripts/backend/master_items")
local MutatorPestilentBauble = class("MutatorPestilentBauble", "MutatorBase")
local throw_config = {
	item = "content/items/weapons/minions/ranged/twin_grenade",
	projectile_template = ProjectileTemplates.mutator_pestilent_bauble_projectile
}
local allowed_spawns = 0
local DELAY = 5

MutatorPestilentBauble.init = function (self, is_server, network_event_delegate, mutator_template)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = true
	self._buffs = {}
	self._template = mutator_template
end

MutatorPestilentBauble.update = function (self, dt, t)
	if not self._is_server then
		return
	end

	self:_add_allowed_spawns(dt, t)

	if allowed_spawns == 0 then
		return
	end

	local update_allowed = self:_check_allowance(t)

	if update_allowed then
		self:_spawn()
	end
end

MutatorPestilentBauble._add_allowed_spawns = function (self, dt, t)
	if not self._delay_for_new then
		self._delay_for_new = t + DELAY
	end

	if t < self._delay_for_new then
		return
	end

	allowed_spawns = allowed_spawns + 1
	self._delay_for_new = t + DELAY
end

MutatorPestilentBauble._check_allowance = function (self, t)
	if not self._waited then
		self._waited = t + 3
	end

	if t < self._waited then
		return false
	end

	local in_safe_zone = Managers.state.pacing:get_in_safe_zone()

	if in_safe_zone then
		return false
	end

	if Managers.state.terror_event:num_active_events() > 0 then
		return false
	end

	return true
end

MutatorPestilentBauble._spawn = function (self)
	allowed_spawns = allowed_spawns - 1

	local players = Managers.player:players()
	local player_position

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			player_position = POSITION_LOOKUP[player_unit]
		end
	end

	local target_position = player_position
	local item_name = throw_config.item
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local projectile_template = throw_config.projectile_template
	local locomotion_template = projectile_template.locomotion_template
	local trajectory_parameters = locomotion_template.trajectory_parameters.drop
	local grenade_unit_name, locomotion_state = item.base_unit, trajectory_parameters.locomotion_state
	local speed = trajectory_parameters.speed_initial or trajectory_parameters.speed
	local is_critical_strike, origin_item_slot, charge_level, target_unit, weapon_item_or_nil, fuse_override_time_or_nil
	local owner_side = "villains"
	local angular_velocity = Vector3.zero()

	player_position[3] = player_position[3] + 6

	local unit_template_name = projectile_template.unit_template_name or "item_projectile"
	local unit, game_object_id = Managers.state.unit_spawner:spawn_network_unit(grenade_unit_name, unit_template_name, target_position, nil, nil, item, projectile_template, locomotion_state, target_position, speed, angular_velocity, nil, is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item_or_nil, fuse_override_time_or_nil, owner_side)
end

return MutatorPestilentBauble
