-- chunkname: @scripts/extension_systems/weapon/weapon_system.lua

require("scripts/extension_systems/weapon/player_unit_weapon_extension")
require("scripts/extension_systems/weapon/projectile_unit_weapon_extension")

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Block = require("scripts/utilities/attack/block")
local Breed = require("scripts/utilities/breed")
local Health = require("scripts/utilities/health")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDeath = require("scripts/utilities/minion_death")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local attack_results = AttackSettings.attack_results
local WeaponSystem = class("WeaponSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_player_blocked_attack"
}

WeaponSystem.init = function (self, ...)
	WeaponSystem.super.init(self, ...)

	self._actor_proximity_shape_updates = {}
	self._units_to_destroy = {}

	self._network_event_delegate:register_session_events(self, unpack(RPCS))

	self.player = nil
	self._give_ammo_carryover_percentages = {}

	if self._is_server then
		self._queued_explosion_request_index = 1
		self._queued_explosions = {
			[0] = 1
		}

		self:_preallocate_queued_explosions(1, 1028)

		self._perils_of_the_warp_elite_kills_achievement = {}
	end
end

WeaponSystem.delete_units = function (self)
	local unit_spawner_manager = Managers.state.unit_spawner
	local units_to_destroy = self._units_to_destroy

	for unit, _ in pairs(units_to_destroy) do
		unit_spawner_manager:mark_for_deletion(unit)

		units_to_destroy[unit] = nil
	end
end

WeaponSystem.destroy = function (self, ...)
	self._network_event_delegate:unregister_events(unpack(RPCS))
	WeaponSystem.super.destroy(self, ...)
end

WeaponSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = WeaponSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	extension.use_proximity_shape_update = extension_init_data.use_proximity_shape_update

	return extension
end

WeaponSystem.register_extension_update = function (self, unit, extension_name, extension)
	WeaponSystem.super.register_extension_update(self, unit, extension_name, extension)

	if extension.use_proximity_shape_update then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local first_person_component = unit_data_extension:read_component("first_person")

		self._actor_proximity_shape_updates[unit] = first_person_component
	end
end

WeaponSystem.on_remove_extension = function (self, unit, extension_name)
	self._actor_proximity_shape_updates[unit] = nil

	WeaponSystem.super.on_remove_extension(self, unit, extension_name)
end

WeaponSystem.pre_update = function (self, context, dt, t)
	WeaponSystem.super.pre_update(self, context, dt, t)

	if self._is_server then
		self:_update_queued_explosions(dt, t)
		self:_update_perils_of_the_warp_elite_kills_achievement()
	end
end

WeaponSystem.update = function (self, context, dt, t)
	WeaponSystem.super.update(self, context, dt, t)
	self:_update_actor_proximity_shapes()
	self:_update_units_to_destroy(t)
end

WeaponSystem.destroy_unit_after_time = function (self, unit, time_to_destroy)
	local gameplay_time = Managers.time:time("gameplay")

	self._units_to_destroy[unit] = gameplay_time + time_to_destroy
end

WeaponSystem.prepare_queued_explosion = function (self)
	local queue_index = self._queued_explosion_request_index

	self._queued_explosion_request_index = queue_index + 1

	local data = self._queued_explosions[queue_index]

	if not data then
		local handle = Application.query_performance_counter()

		data = self:_preallocate_queued_explosions(queue_index, 128)

		local duration = Application.time_since_query(handle)

		Log.info("WeaponSystem", "preallocate took %.3fms", duration)
	end

	return queue_index, data
end

WeaponSystem.explosion_result = function (self, queue_index)
	local queued_explosions = self._queued_explosions

	if queue_index >= queued_explosions[0] then
		return false
	end

	return true, queued_explosions[queue_index]
end

WeaponSystem._preallocate_queued_explosions = function (self, queue_index, num_to_allocate)
	local handle = Application.query_performance_counter()
	local queued_explosions = self._queued_explosions
	local expected_max_units = 128
	local expected_max_units_times_two = expected_max_units * 2
	local result_stride = 2
	local result_table_size = expected_max_units * result_stride

	for i = queue_index, queue_index + num_to_allocate do
		local qp = Script.new_map(expected_max_units_times_two, 32)

		qp[0] = 1
		qp.num_hit_units = 0
		qp.result = Script.new_array(result_table_size)
		qp.result_stride = result_stride
		queued_explosions[i] = qp
	end

	local duration = Application.time_since_query(handle)

	Log.info("WeaponSystem", "allocating took %.3fms (%i allocated)", duration, num_to_allocate)

	return queued_explosions[queue_index]
end

WeaponSystem._update_actor_proximity_shapes = function (self)
	local physics_world = self._physics_world
	local Quaternion_forward = Quaternion.forward
	local PhysicsWorld_commit_actor_proximity_shape = PhysicsWorld.commit_actor_proximity_shape
	local radius_sq = 36
	local actor_proxmity_shape_updates = self._actor_proximity_shape_updates

	for unit, first_person_component in pairs(actor_proxmity_shape_updates) do
		local position = first_person_component.position
		local direction = Quaternion_forward(first_person_component.rotation)
		local angle

		PhysicsWorld_commit_actor_proximity_shape(physics_world, position, direction, radius_sq, angle, true)
	end
end

WeaponSystem._update_units_to_destroy = function (self, t)
	local unit_spawner_manager = Managers.state.unit_spawner
	local units_to_destroy = self._units_to_destroy

	for unit, t_to_destroy in pairs(units_to_destroy) do
		if t_to_destroy <= t then
			unit_spawner_manager:mark_for_deletion(unit)

			units_to_destroy[unit] = nil
		end
	end
end

local MAX_UNIT_DEATHS_PROCESSED_PER_FRAME = 8
local MAX_UNITS_PROCESSED_PER_FRAME = 30
local HIT_DISTANCE_EPSILON = 0.001

WeaponSystem._update_queued_explosions = function (self, dt, t)
	local queued_explosions = self._queued_explosions
	local physics_world = self._physics_world
	local num_units_processed_this_frame = 0
	local num_unit_deaths_processed_this_frame = 0
	local queued_explosion_request_index = self._queued_explosion_request_index
	local queued_explosions_end = queued_explosion_request_index - 1

	for explosion_i = queued_explosions[0], queued_explosions_end do
		local data = queued_explosions[explosion_i]
		local source_position = Vector3(data.source_position_x, data.source_position_y, data.source_position_z)
		local radius = data.radius
		local close_radius = data.close_radius
		local explosion_template = data.explosion_template
		local ignore_cover = data.ignore_cover
		local power_level = data.power_level
		local charge_level = data.charge_level
		local attack_type = data.attack_type
		local attacking_unit = data.attacking_unit
		local attacking_unit_owner_unit = data.attacking_unit_owner_unit
		local is_critical_strike = data.is_critical_strike
		local item_or_nil = data.item_or_nil
		local result = data.result
		local sticking_to_unit = data.sticking_to_unit
		local optional_attacking_unit_owner_unit = data.optional_attacking_unit_owner_unit
		local optional_apply_owner_buffs = data.optional_apply_owner_buffs
		local target_number = 1
		local num_hit_units = data.num_hit_units

		for hit_units_i = data[0], num_hit_units do
			local strided_i = (hit_units_i - 1) * 2
			local hit_unit = data[strided_i + 1]
			local hit_actor = data[strided_i + 2]

			if ALIVE[hit_unit] then
				do
					local hit_position = Unit.world_position(hit_unit, Actor.node(hit_actor))
					local direction = Vector3.normalize(hit_position - source_position)
					local has_health = ScriptUnit.has_extension(hit_unit, "health_system")
					local hit_distance = Vector3.distance(source_position, hit_position)
					local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
					local breed_or_nil = unit_data_extension and unit_data_extension:breed()

					if breed_or_nil and breed_or_nil.explosion_radius then
						hit_distance = math.max(hit_distance - breed_or_nil.explosion_radius, 0)
					end

					local is_sticking_to_unit = hit_unit == sticking_to_unit
					local close_hit = is_sticking_to_unit or close_radius > 0 and hit_distance < close_radius
					local hit_zone_or_nil = HitZone.get(hit_unit, hit_actor)
					local hit_zone_name_or_nil = hit_zone_or_nil and hit_zone_or_nil.name

					if Health.is_ragdolled(hit_unit) then
						if close_hit then
							MinionDeath.attack_ragdoll(hit_unit, direction, explosion_template.close_damage_profile, nil, hit_zone_name_or_nil, nil, nil)
						else
							MinionDeath.attack_ragdoll(hit_unit, direction, explosion_template.damage_profile, nil, hit_zone_name_or_nil, nil, nil)
						end
					elseif has_health then
						local is_prop = breed_or_nil == nil or Breed.is_prop(breed_or_nil)
						local intervening_cover, cover_actor, _ = false
						local do_cover_check = not ignore_cover and not is_sticking_to_unit and not is_prop

						if do_cover_check and hit_distance > HIT_DISTANCE_EPSILON then
							intervening_cover, _, _, _, cover_actor = PhysicsWorld.raycast(physics_world, hit_position, -direction, 0.95 * hit_distance, "closest", "types", "statics", "collision_filter", "filter_explosion_cover")
						end

						if intervening_cover and cover_actor then
							local cover_unit = Actor.unit(cover_actor)
							local cover_has_health = ScriptUnit.has_extension(cover_unit, "health_system")

							intervening_cover = not cover_has_health
						end

						local valid_target = true

						if valid_target and not intervening_cover then
							local damage_profile, damage_type

							if close_hit then
								damage_profile = explosion_template.close_damage_profile
								damage_type = explosion_template.close_damage_type
							else
								damage_profile = explosion_template.damage_profile
								damage_type = explosion_template.damage_type
							end

							local dropoff_scalar = false

							if not close_hit and explosion_template.damage_falloff then
								dropoff_scalar = (hit_distance - close_radius) / (radius - close_radius)
								dropoff_scalar = math.clamp(dropoff_scalar * dropoff_scalar, 0, 1)
							end

							local attack_power_level = power_level

							if explosion_template.boss_power_level_modifier and breed_or_nil and breed_or_nil.is_boss then
								attack_power_level = attack_power_level * explosion_template.boss_power_level_modifier
							end

							local _, attack_result = Attack.execute(hit_unit, damage_profile, "power_level", attack_power_level, "charge_level", charge_level, "attack_direction", direction, "dropoff_scalar", dropoff_scalar, "hit_zone_name", hit_zone_name_or_nil, "hit_actor", hit_actor, "attack_type", attack_type, "attacking_unit", attacking_unit, "damage_type", damage_type, "is_critical_strike", is_critical_strike, "item", item_or_nil, "hit_world_position", source_position, "attacking_unit_owner_unit", optional_attacking_unit_owner_unit, "apply_owner_buffs", optional_apply_owner_buffs, "close_explosion_hit", close_hit, "target_number", target_number)

							target_number = target_number + 1

							local on_hit_buff_template_name = explosion_template.on_hit_buff_template_name

							if on_hit_buff_template_name and HEALTH_ALIVE[hit_unit] and ALIVE[attacking_unit_owner_unit] then
								local enemy_buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

								if enemy_buff_extension then
									enemy_buff_extension:add_internally_controlled_buff(on_hit_buff_template_name, t, "owner_unit", attacking_unit_owner_unit, "source_item", item_or_nil)
								end
							end

							if attack_result == attack_results.died then
								num_unit_deaths_processed_this_frame = num_unit_deaths_processed_this_frame + 1
							end

							local result_stride_i = (hit_units_i - 1) * data.result_stride

							result[result_stride_i + 1] = attack_result
							result[result_stride_i + 2] = breed_or_nil
						end
					end
				end

				num_units_processed_this_frame = num_units_processed_this_frame + 1

				if num_units_processed_this_frame >= MAX_UNITS_PROCESSED_PER_FRAME or num_unit_deaths_processed_this_frame > MAX_UNIT_DEATHS_PROCESSED_PER_FRAME then
					queued_explosions[0] = explosion_i
					data[0] = hit_units_i + 1

					return
				end
			end
		end

		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(optional_attacking_unit_owner_unit)

		player = player or player_unit_spawn_manager:owner(attacking_unit_owner_unit)

		if player then
			Managers.stats:record_private("hook_explosion", player, explosion_template, data)
		end

		Managers.stats:record_team("hook_team_explosion", explosion_template, data)
	end

	queued_explosions[0] = queued_explosion_request_index
end

WeaponSystem._update_perils_of_the_warp_elite_kills_achievement = function (self)
	local perils_of_the_warp_elite_kills_achievement = self._perils_of_the_warp_elite_kills_achievement

	for account_id, achievement_data in pairs(perils_of_the_warp_elite_kills_achievement) do
		local explosion_done, explosion_data = self:explosion_result(achievement_data.explosion_queue_index)

		if explosion_done then
			local num_killed = 0
			local num_hit_units, result, stride = explosion_data.num_hit_units, explosion_data.result, explosion_data.result_stride

			for ii = 1, num_hit_units do
				local strided_i = (ii - 1) * stride
				local attack_result = result[strided_i + 1]

				if attack_result == attack_results.died then
					local breed = result[strided_i + 2]

					if breed and breed.tags and breed.tags.elite then
						num_killed = num_killed + 1
					end
				end
			end

			local player = achievement_data.player

			if num_killed >= 1 then
				Managers.achievements:unlock_achievement(player, "psyker_2_perils_of_the_warp_elite_kills")
			end

			perils_of_the_warp_elite_kills_achievement[account_id] = nil
		end
	end
end

WeaponSystem.rpc_player_blocked_attack = function (self, channel_id, unit_id, attacking_unit_id, hit_world_position, block_broken, weapon_template_id, attack_type_id)
	local player_unit = Managers.state.unit_spawner:unit(unit_id)
	local attacking_unit = Managers.state.unit_spawner:unit(attacking_unit_id)
	local weapon_template_name = NetworkLookup.weapon_templates[weapon_template_id]
	local weapon_template = WeaponTemplates[weapon_template_name]
	local attack_type = NetworkLookup.attack_types[attack_type_id]

	Block.player_blocked_attack(player_unit, attacking_unit, hit_world_position, block_broken, weapon_template, attack_type)
end

WeaponSystem.give_ammo_carryover_percentages = function (self, unit, weapon_slot_configuration)
	local give_ammo_carryover_percentages = self._give_ammo_carryover_percentages

	if not give_ammo_carryover_percentages[unit] then
		local percentages = {}

		for slot_name, _ in pairs(weapon_slot_configuration) do
			percentages[slot_name] = 0
		end

		give_ammo_carryover_percentages[unit] = percentages
	end

	return give_ammo_carryover_percentages[unit]
end

WeaponSystem.queue_perils_of_the_warp_elite_kills_achievement = function (self, player, explosion_queue_index)
	local danger_settings = Managers.state.difficulty:get_danger_settings()
	local difficulty = danger_settings and danger_settings.difficulty or 0

	if difficulty < 3 then
		return
	end

	local account_id = player:account_id()

	if self._perils_of_the_warp_elite_kills_achievement[account_id] then
		Log.error("WeaponSystem", "Queued multiple perils_of_the_warp_elite_kills achievements, will only track one.")
	end

	self._perils_of_the_warp_elite_kills_achievement[account_id] = {
		account_id = account_id,
		character_id = player:character_id(),
		player = player,
		explosion_queue_index = explosion_queue_index
	}
end

return WeaponSystem
