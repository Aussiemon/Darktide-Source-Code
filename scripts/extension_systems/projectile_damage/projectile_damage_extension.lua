-- chunkname: @scripts/extension_systems/projectile_damage/projectile_damage_extension.lua

local Armor = require("scripts/utilities/attack/armor")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local Explosion = require("scripts/utilities/attack/explosion")
local HazardProp = require("scripts/utilities/level_props/hazard_prop")
local Health = require("scripts/utilities/health")
local HitMass = require("scripts/utilities/attack/hit_mass")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LagCompensation = require("scripts/utilities/lag_compensation")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local MasterItems = require("scripts/backend/master_items")
local MinionDeath = require("scripts/utilities/minion_death")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local ProjectileSettings = require("scripts/settings/projectile/projectile_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local Weakspot = require("scripts/utilities/attack/weakspot")
local armor_types = ArmorSettings.types
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local buff_proc_events = BuffSettings.proc_events
local locomotion_states = ProjectileLocomotionSettings.states
local projectile_impact_results = ProjectileLocomotionSettings.impact_results
local projectile_types = ProjectileSettings.projectile_types
local surface_hit_types = SurfaceMaterialSettings.hit_types
local ProjectileDamageExtension = class("ProjectileDamageExtension")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local IMPACT_FX_DATA = {
	will_be_predicted = false,
	source_parameters = {},
}
local IMPACT_CONFIG = {
	destroy_on_impact = false,
}

ProjectileDamageExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._projectile_template = extension_init_data.projectile_template
	self._owner_unit = extension_init_data.owner_unit
	self._projectile_unit = unit
	self._life_time = 0
	self._charge_level = extension_init_data.charge_level
	self._is_critical_strike = extension_init_data.is_critical_strike
	self._origin_item_slot = extension_init_data.origin_item_slot
	self._weapon_item_or_nil = extension_init_data.weapon_item_or_nil
	self._owner_side_or_nil = extension_init_data.owner_side_or_nil
	self._fuse_override_time_or_nil = extension_init_data.fuse_override_time_or_nil
	self._initial_direction_boxed = extension_init_data.initial_direction and Vector3Box(extension_init_data.initial_direction)

	local world = extension_init_context.world

	self._world = world
	self._physics_world = World.physics_world(world)
	self._nav_world = extension_init_context.nav_world
	self._is_server = extension_init_context.is_server
	self._hit_units = {}
	self._suppressed_units = {}
	self._marked_for_deletion = false
	self._has_impacted = false
	self._reset_time = false
	self._impact_hit = false
	self._impact_hit_weakspot = 0
	self._num_impact_hit_kill = 0
	self._num_impact_hit_elite = 0
	self._num_impact_hit_special = 0
	self._num_impact_hit_minion = 0

	local projectile_template = self._projectile_template
	local damage_settings = projectile_template.damage
	local fuse_damage_settings = damage_settings and damage_settings.fuse

	self._fuse_started = fuse_damage_settings and not fuse_damage_settings.impact_triggered and not fuse_damage_settings.proximity_triggered

	if projectile_template.event_settings then
		self._event_settings = table.clone_instance(projectile_template.event_settings)
	end

	local hit_mass_budget_attack, hit_mass_budget_impact = self:_calculate_hit_mass()

	self._hit_mass_budget_attack = hit_mass_budget_attack
	self._hit_mass_budget_impact = hit_mass_budget_impact
	self._weapon_system = Managers.state.extension:system("weapon_system")
	self._wait_for_explosion_queue_index = {}
	self._marked_for_deletion_done = false
end

ProjectileDamageExtension._calculate_hit_mass = function (self)
	local owner_unit = self._owner_unit
	local charge_level = self._charge_level or 1
	local is_critical_strike = self._is_critical_strike
	local projectile_template = self._projectile_template
	local damage_settings = projectile_template.damage
	local impact_damage_settings = damage_settings and damage_settings.impact
	local attack_type = attack_types.ranged

	if impact_damage_settings and impact_damage_settings.delete_on_hit_mass then
		local impact_damage_profile = impact_damage_settings.damage_profile
		local damage_profile_lerp_values = DamageProfile.lerp_values(impact_damage_profile, owner_unit)
		local hit_mass_budget_attack, hit_mass_budget_impact = DamageProfile.max_hit_mass(impact_damage_profile, DEFAULT_POWER_LEVEL, charge_level, damage_profile_lerp_values, is_critical_strike, owner_unit, attack_type)

		return hit_mass_budget_attack, hit_mass_budget_impact
	end

	return nil, nil
end

ProjectileDamageExtension._reset_suppressed_units = function (self)
	self._suppressed_units = {}
end

ProjectileDamageExtension.extensions_ready = function (self)
	local projectile_unit = self._projectile_unit

	self._locomotion_extension = ScriptUnit.extension(projectile_unit, "locomotion_system")
	self._fx_extension = ScriptUnit.extension(projectile_unit, "fx_system")
end

local _explosion_hit_units_table = {}
local BROADPHASE_RESULTS = {}

ProjectileDamageExtension.fixed_update = function (self, unit, dt, t)
	if self._marked_for_deletion_done then
		return
	end

	local projectile_template = self._projectile_template
	local locomotion_extension = self._locomotion_extension
	local current_locomotion_state = locomotion_extension:current_state()

	if projectile_template.deployable and current_locomotion_state == locomotion_states.deployed then
		return
	end

	if self._marked_for_deletion and not self._marked_for_deletion_done then
		local is_done = true
		local weapon_system = self._weapon_system
		local queue = self._wait_for_explosion_queue_index

		for ii = 1, #queue do
			local queue_index = queue[ii]
			local is_explosion_done = weapon_system:explosion_result(queue_index)

			if not is_explosion_done then
				is_done = false

				break
			end
		end

		if is_done then
			locomotion_extension:mark_for_deletion()

			self._marked_for_deletion_done = true
		end

		return
	end

	local world = self._world
	local physics_world = self._physics_world
	local owner_unit = self._owner_unit
	local projectile_unit = self._projectile_unit
	local life_time = self._life_time
	local is_critical_strike = self._is_critical_strike
	local weapon_item_or_nil = self._weapon_item_or_nil
	local origin_slot_or_nil = self._origin_item_slot
	local charge_level = self._charge_level or 1
	local damage_settings = projectile_template.damage
	local fuse_damage_settings = damage_settings and damage_settings.fuse
	local _, position = locomotion_extension:previous_and_current_positions()

	if self._reset_time and not fuse_damage_settings.skip_fuse_reset then
		life_time = 0
		self._reset_time = false
	end

	local mark_for_deletion = false
	local new_life_time = life_time + dt
	local explosion_queue_index
	local event_settings = self._event_settings

	if event_settings then
		for _, settings in ipairs(event_settings) do
			local event_time = settings.event_time

			if not settings.event_triggered and event_time and event_time < new_life_time then
				local event_name = settings.event_name
				local direction = self._initial_direction_boxed and self._initial_direction_boxed:unbox()

				settings.event_triggered = true

				Managers.event:trigger(event_name, unit, position, direction)
			end
		end
	end

	local impact_triggered = fuse_damage_settings and fuse_damage_settings.impact_triggered
	local proximity_triggered = fuse_damage_settings and fuse_damage_settings.proximity_triggered
	local min_lifetime = fuse_damage_settings.min_lifetime
	local sticking_to_unit, sticking_to_actor_index = locomotion_extension:sticking_to_unit()
	local fuse_time = self._fuse_override_time_or_nil or sticking_to_unit and fuse_damage_settings.sticky_fuse_time or self._has_impacted and impact_triggered and fuse_damage_settings.impact_fuse_time or fuse_damage_settings.fuse_time
	local max_lifetime = fuse_damage_settings.max_lifetime or fuse_time * 2
	local kill_at_lifetime = fuse_damage_settings.kill_at_lifetime

	if kill_at_lifetime and kill_at_lifetime < new_life_time then
		mark_for_deletion = true
	end

	local fuse_started = self._fuse_started

	if min_lifetime then
		if min_lifetime < new_life_time then
			fuse_started = true
		end
	elseif impact_triggered then
		if not self._has_impacted then
			if max_lifetime < new_life_time then
				fuse_started = true

				if not self._fuse_started then
					new_life_time = 0
				end
			else
				fuse_started = false
			end
		elseif self._has_impacted then
			fuse_started = true

			if not self._fuse_started then
				new_life_time = 0
			end
		end
	elseif proximity_triggered then
		if self._proximity_check_started and not self._proximity_check_done and t >= self._arm_time then
			table.clear(BROADPHASE_RESULTS)

			local broadphase_system = Managers.state.extension:system("broadphase_system")
			local broadphase = broadphase_system.broadphase
			local proximity_radius = fuse_damage_settings.proximity_radius
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system:get_side_from_name(self._owner_side_or_nil)
			local enemy_side_names = side:relation_side_names("enemy")
			local num_hits = broadphase.query(broadphase, position, proximity_radius, BROADPHASE_RESULTS, enemy_side_names)

			if num_hits > 0 then
				fuse_started = true
				self._proximity_check_done = true
				self._reset_time = true
				new_life_time = 0

				Managers.stats:record_team("hook_mission_twins_mine_triggered")

				if fuse_damage_settings.aoe_threat_size then
					local enemy_sides = side:relation_sides("enemy")
					local group_system = Managers.state.extension:system("group_system")
					local bot_groups = group_system:bot_groups_from_sides(enemy_sides)
					local num_bot_groups = #bot_groups

					for i = 1, num_bot_groups do
						local bot_group = bot_groups[i]

						bot_group:aoe_threat_created(position, "sphere", fuse_damage_settings.aoe_threat_size, Quaternion.identity(), fuse_damage_settings.aoe_threat_duration)
					end
				end
			end
		elseif self._has_impacted and not self._proximity_check_started then
			self._proximity_check_started = true
			self._arm_time = t + fuse_damage_settings.arm_time
		end
	elseif fuse_time < new_life_time then
		fuse_started = true
	end

	if fuse_started and fuse_damage_settings then
		if not self._fuse_started then
			self._fuse_started = true

			self._fx_extension:on_fuse_started()
		end

		local player = Managers.state.player_unit_spawn:owner(owner_unit)
		local rewind_ms = 0

		if player then
			local is_local_unit = not player.remote

			rewind_ms = LagCompensation.rewind_ms(self._is_server, is_local_unit, player) / 1000
		end

		fuse_time = fuse_time + rewind_ms

		if fuse_time < new_life_time then
			local fuse_explosion_template = fuse_damage_settings.explosion_template
			local fuse_liquid_area_template = fuse_damage_settings.liquid_area_template
			local default_explosion_normal = fuse_damage_settings.default_explosion_normal

			if fuse_explosion_template then
				local explosion_normal

				if sticking_to_unit then
					explosion_normal = self:_get_sticking_explosion_normal(sticking_to_unit, sticking_to_actor_index)
				elseif default_explosion_normal then
					explosion_normal = default_explosion_normal:unbox()
				end

				local explosion_z_offset = fuse_damage_settings.explosion_z_offset

				if explosion_z_offset then
					position = position + Vector3(0, 0, explosion_z_offset)
				end

				table.clear(_explosion_hit_units_table)

				explosion_queue_index = Explosion.create_explosion(world, physics_world, position, explosion_normal, projectile_unit, fuse_explosion_template, DEFAULT_POWER_LEVEL, charge_level, AttackSettings.attack_types.explosion, is_critical_strike, false, weapon_item_or_nil, origin_slot_or_nil, _explosion_hit_units_table)
			end

			local critical_strike_fuse_settings = is_critical_strike and damage_settings.critical_strike and damage_settings.critical_strike.fuse
			local cluster_settings = critical_strike_fuse_settings and critical_strike_fuse_settings.cluster or fuse_damage_settings.cluster

			if cluster_settings then
				local direction = Vector3.up()

				self:_spawn_cluster(cluster_settings, direction)
			end

			local spawn_unit_settings = fuse_damage_settings.spawn_unit

			if spawn_unit_settings then
				self:_spawn_unit(spawn_unit_settings)
			end

			if player then
				self:_handle_buff_system_explosion_proc_events(self._owner_unit, self._projectile_template, false)
				self:_handle_explosion_achivements(player, _explosion_hit_units_table)
			end

			if fuse_liquid_area_template then
				LiquidArea.try_create(position, Vector3.down(), self._nav_world, fuse_liquid_area_template, owner_unit, nil, nil, weapon_item_or_nil, self._owner_side_or_nil)
			end

			self._fx_extension:on_build_up_stop()

			mark_for_deletion = true
		end
	end

	if explosion_queue_index then
		local queue = self._wait_for_explosion_queue_index

		queue[#queue + 1] = explosion_queue_index
	end

	if mark_for_deletion and not self._marked_for_deletion then
		self:_record_impact_concluded_stats()
		self._locomotion_extension:switch_to_sleep()

		self._marked_for_deletion = true
	end

	self._life_time = new_life_time
end

ProjectileDamageExtension.post_update = function (self, unit, dt, t, context)
	if not self._on_player_projectile_finished and self._locomotion_extension:is_marked_for_deletion() then
		local owner_unit = self._owner_unit
		local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")
		local param_table = buff_extension and buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = self._player
			param_table.impact_hit = self._impact_hit
			param_table.num_impact_hit_weakspot = self._impact_hit_weakspot
			param_table.num_impact_hit_kill = self._num_impact_hit_kill
			param_table.num_impact_hit_elite = self._num_impact_hit_elite
			param_table.num_impact_hit_special = self._num_impact_hit_special
			param_table.num_impact_hit_minion = self._num_impact_hit_minion
			param_table.projectile_name = self._projectile_template.name

			buff_extension:add_proc_event(buff_proc_events.on_player_projectile_finished, param_table)
		end

		self._on_player_projectile_finished = true
	end
end

ProjectileDamageExtension.on_impact = function (self, hit_position, hit_unit, hit_actor, hit_direction, hit_normal, current_speed, force_delete, is_target_unit)
	local owner_unit = self._owner_unit
	local projectile_unit = self._projectile_unit
	local projectile_template = self._projectile_template
	local damage_settings = projectile_template.damage
	local impact_damage_settings = damage_settings and damage_settings.impact
	local sticks_to_armor_types = projectile_template.sticks_to_armor_types
	local sticks_to_breeds = projectile_template.sticks_to_breeds
	local sticks_to_tags = projectile_template.sticks_to_tags
	local sticks_to_func = projectile_template.sticks_to_func
	local weapon_item_or_nil = self._weapon_item_or_nil
	local origin_slot_or_nil = self._origin_item_slot
	local locomotion_extension = self._locomotion_extension
	local rotation, direction = locomotion_extension:current_rotation_and_direction()
	local is_critical_strike = self._is_critical_strike
	local mark_for_deletion = false
	local impact_result, explosion_queue_index

	if impact_damage_settings then
		local non_target_overrides = impact_damage_settings.non_target_overrides
		local impact_damage_profile = impact_damage_settings.damage_profile
		local impact_damage_type = impact_damage_settings.damage_type
		local impact_explosion_template = impact_damage_settings.explosion_template
		local impact_liquid_area_template = impact_damage_settings.liquid_area_template
		local impact_suppression_settings = impact_damage_settings.suppression_settings

		if non_target_overrides and not is_target_unit then
			impact_damage_profile = non_target_overrides.damage_profile or impact_damage_profile
			impact_damage_type = non_target_overrides.damage_type or impact_damage_type
		end

		local hit_units = self._hit_units
		local have_unit_been_hit = hit_units[hit_unit]
		local is_not_self = hit_unit ~= owner_unit
		local hit_mass_stop = false
		local do_impact_explosion = not not impact_explosion_template
		local charge_level = self._charge_level or 1
		local is_damagable = Health.is_damagable(hit_unit)
		local is_ragdolled = Health.is_ragdolled(hit_unit)
		local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
		local target_breed_or_nil = unit_data_extension and unit_data_extension:breed()
		local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
		local target_is_hazard_prop, hazard_prop_is_active = HazardProp.status(hit_unit)
		local is_breed_with_hit_zone = target_breed_or_nil and hit_zone_name_or_nil
		local is_damagable_hazard_prop = target_is_hazard_prop and hazard_prop_is_active
		local should_deal_damage = target_is_hazard_prop and hazard_prop_is_active or not target_is_hazard_prop and is_breed_with_hit_zone or not target_breed_or_nil

		if not have_unit_been_hit and is_not_self then
			local hit_zone_name = HitZone.get_name(hit_unit, hit_actor)
			local hit_hard_target = false
			local attack_type = attack_types.ranged

			hit_units[hit_unit] = true

			if is_ragdolled then
				MinionDeath.attack_ragdoll(hit_unit, direction, impact_damage_profile, impact_damage_type, hit_zone_name, hit_position, owner_unit, hit_actor, nil)

				impact_result = "continue_straight"
			elseif impact_damage_profile and is_damagable then
				local impact_charge_level = charge_level
				local speed_to_charge_settings = impact_damage_settings.speed_to_charge_settings

				if speed_to_charge_settings then
					local max_speed = speed_to_charge_settings.max_speed
					local charge_min = speed_to_charge_settings.charge_min or 0
					local charge_max = speed_to_charge_settings.charge_max or 1
					local charge_speed_lerp = math.clamp01(current_speed / max_speed)

					impact_charge_level = charge_level * math.lerp(charge_min, charge_max, charge_speed_lerp)
				end

				if impact_damage_settings.delete_on_hit_mass then
					local calculate_hit_mass = true

					if non_target_overrides and non_target_overrides.ignore_hit_mass and not is_target_unit then
						calculate_hit_mass = false
					end

					if calculate_hit_mass then
						local hit_weakspot = Weakspot.hit_weakspot(target_breed_or_nil, hit_zone_name, owner_unit)
						local hit_mass_override = impact_damage_profile.hit_mass_override
						local hit_mass_budget_attack, hit_mass_budget_impact = HitMass.consume_hit_mass(owner_unit, hit_unit, self._hit_mass_budget_attack, self._hit_mass_budget_impact, hit_weakspot, is_critical_strike, attack_type, hit_mass_override)

						hit_mass_stop = HitMass.stopped_attack(hit_unit, hit_zone_name, hit_mass_budget_attack, hit_mass_budget_impact, IMPACT_CONFIG)
						self._hit_mass_budget_attack = hit_mass_budget_attack
						self._hit_mass_budget_impact = hit_mass_budget_impact
					end

					do_impact_explosion = false
					impact_result = "continue_straight"
				end

				local dropoff_scalar = false
				local owner_weapon_extension = ScriptUnit.has_extension(owner_unit, "weapon_system")

				if owner_weapon_extension then
					local distance = Vector3.distance(hit_position, Unit.world_position(owner_unit, 1))
					local damage_profile_lerp_values = owner_weapon_extension:damage_profile_lerp_values(impact_damage_profile)

					dropoff_scalar = DamageProfile.dropoff_scalar(distance, impact_damage_profile, damage_profile_lerp_values)
				end

				local damage_dealt, attack_result, damage_efficiency, stagger_result, hit_weakspot

				if should_deal_damage then
					damage_dealt, attack_result, damage_efficiency, stagger_result, hit_weakspot = Attack.execute(hit_unit, impact_damage_profile, "attack_direction", hit_direction, "power_level", DEFAULT_POWER_LEVEL, "hit_zone_name", hit_zone_name, "target_index", 1, "target_number", 1, "charge_level", impact_charge_level, "is_critical_strike", is_critical_strike, "dropoff_scalar", dropoff_scalar, "hit_actor", hit_actor, "hit_world_position", hit_position, "attack_type", attack_type, "damage_type", impact_damage_type, "attacking_unit", projectile_unit, "item", weapon_item_or_nil)
				end

				self._impact_hit = true
				self._impact_hit_weakspot = self._impact_hit_weakspot + (hit_weakspot and 1 or 0)
				self._num_impact_hit_kill = self._num_impact_hit_kill + (attack_result == attack_results.died and 1 or 0)
				self._num_impact_hit_elite = self._num_impact_hit_elite + (target_breed_or_nil and target_breed_or_nil.tags.elite and 1 or 0)
				self._num_impact_hit_special = self._num_impact_hit_special + (target_breed_or_nil and target_breed_or_nil.tags.special and 1 or 0)
				self._num_impact_hit_minion = self._num_impact_hit_minion + (target_breed_or_nil and target_breed_or_nil.tags.minion and 1 or 0)

				if impact_damage_type then
					if not target_is_hazard_prop and target_breed_or_nil and hit_zone_name_or_nil or is_damagable_hazard_prop then
						ImpactEffect.play(hit_unit, hit_actor, damage_dealt, impact_damage_type, hit_zone_name_or_nil, attack_result, hit_position, hit_normal, direction, owner_unit or projectile_unit, IMPACT_FX_DATA, false, nil, damage_efficiency, impact_damage_profile)
					else
						ImpactEffect.play_surface_effect(self._physics_world, owner_unit or projectile_unit, hit_position, hit_normal, direction, impact_damage_type, surface_hit_types.stop, IMPACT_FX_DATA)
					end
				end

				if impact_suppression_settings then
					Suppression.apply_area_minion_suppression(owner_unit, impact_suppression_settings, hit_position)
				end

				if not impact_result and stagger_result == "stagger" then
					impact_result = projectile_impact_results.stagger
				end
			else
				hit_hard_target = true
			end

			local fuse_damage_settings = damage_settings and damage_settings.fuse
			local sticking_to_unit, _ = locomotion_extension:sticking_to_unit()
			local sticks_to_func_ok = not sticks_to_func or sticks_to_func(projectile_unit, hit_unit, hit_zone_name)
			local can_projectile_stick = not sticking_to_unit and (sticks_to_armor_types or sticks_to_breeds or sticks_to_tags) and sticks_to_func_ok

			if can_projectile_stick and HEALTH_ALIVE[hit_unit] and unit_data_extension then
				local armor_type = Armor.armor_type(hit_unit, target_breed_or_nil, hit_zone_name)
				local sticks_to_armor = sticks_to_armor_types and sticks_to_armor_types[armor_type]
				local sticks_to_breed = sticks_to_breeds and sticks_to_breeds[target_breed_or_nil.name]
				local sticks_to_tag = false

				if sticks_to_tags and target_breed_or_nil.tags then
					for tag, _ in pairs(target_breed_or_nil.tags) do
						if sticks_to_tags[tag] then
							sticks_to_tag = true

							break
						end
					end
				end

				if sticks_to_armor or sticks_to_breed or sticks_to_tag then
					locomotion_extension:switch_to_sticky(hit_unit, hit_actor, hit_position, rotation, hit_normal, hit_direction)

					self._life_time = 0

					self._fx_extension:on_stick()

					local play_build_up = not fuse_damage_settings.impact_triggered and not fuse_damage_settings.proximity_triggered or not self._fuse_started

					if play_build_up then
						self._fx_extension:on_build_up_start()
					end

					impact_result = projectile_impact_results.stick
				end
			end

			hit_mass_stop = impact_damage_settings.delete_on_hit_mass and hit_mass_stop

			if hit_hard_target and impact_damage_settings.delete_on_impact or hit_mass_stop then
				mark_for_deletion = true
				do_impact_explosion = not not impact_explosion_template
			end

			if fuse_damage_settings then
				local min_lifetime = fuse_damage_settings.min_lifetime

				if min_lifetime then
					local life_time = self._life_time

					if life_time < min_lifetime then
						do_impact_explosion = false
					end
				end
			end

			if impact_damage_settings.first_impact_activated and not self._has_impacted then
				do_impact_explosion = false
			end

			if do_impact_explosion then
				table.clear(_explosion_hit_units_table)

				explosion_queue_index = Explosion.create_explosion(self._world, self._physics_world, hit_position, nil, projectile_unit, impact_explosion_template, DEFAULT_POWER_LEVEL, charge_level, AttackSettings.attack_types.explosion, is_critical_strike, false, weapon_item_or_nil, origin_slot_or_nil, _explosion_hit_units_table)
				mark_for_deletion = true

				local player = Managers.state.player_unit_spawn:owner(owner_unit)

				if player then
					self:_handle_buff_system_explosion_proc_events(self._owner_unit, self._projectile_template, true)
					self:_handle_explosion_achivements(player, _explosion_hit_units_table)
				end
			else
				self._reset_time = true
			end

			local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

			if buff_extension and buff_extension:has_keyword(buff_keywords.cluster_explode_on_super_armored) then
				local hit_zone_is_shield = hit_zone_name == "shield"
				local hitzone_armor_override = target_breed_or_nil and target_breed_or_nil.hitzone_armor_override and target_breed_or_nil.hitzone_armor_override[hit_zone_name]
				local is_super_armored_hit = target_breed_or_nil and target_breed_or_nil.armor_type and (target_breed_or_nil.armor_type == armor_types.super_armor or target_breed_or_nil.armor_type == armor_types.armored or target_breed_or_nil.armor_type == armor_types.resistant) or hitzone_armor_override == armor_types.super_armor or hitzone_armor_override == armor_types.armored or hitzone_armor_override == armor_types.resistant
				local super_armored_settings = (is_super_armored_hit or hit_zone_is_shield) and damage_settings.super_armored and damage_settings.super_armored.impact.cluster

				if super_armored_settings and not self.has_cluster_impacted then
					local cluster_direction = hit_hard_target and hit_normal or Vector3.lerp(hit_normal, Vector3.up(), 0.5)

					self:_spawn_cluster(super_armored_settings, cluster_direction)

					self.has_cluster_impacted = true
					mark_for_deletion = super_armored_settings.mark_for_deletion
				end
			end

			local cluster_settings = impact_damage_settings.cluster

			if cluster_settings then
				local cluster_direction = hit_hard_target and hit_normal or Vector3.lerp(hit_normal, Vector3.up(), 0.5)

				self:_spawn_cluster(cluster_settings, cluster_direction)
			else
				local has_conditional_cluster_keyword = buff_extension and buff_extension:has_keyword(buff_keywords.ogryn_basic_box_spawns_cluster)
				local conditional_cluster_settings = impact_damage_settings.conditional_cluster

				if has_conditional_cluster_keyword and conditional_cluster_settings then
					local cluster_direction = hit_hard_target and hit_normal or Vector3.lerp(hit_normal, Vector3.up(), 0.5)

					self:_spawn_cluster(conditional_cluster_settings, cluster_direction)
				end
			end

			if impact_liquid_area_template then
				LiquidArea.try_create(hit_position, hit_direction, self._nav_world, impact_liquid_area_template, owner_unit, nil, nil, weapon_item_or_nil, self._owner_side_or_nil)

				mark_for_deletion = true
			end

			if not is_damagable and impact_damage_type then
				ImpactEffect.play_surface_effect(self._physics_world, projectile_unit, hit_position, hit_normal, hit_direction, impact_damage_type, surface_hit_types.stop, IMPACT_FX_DATA)
			end
		elseif have_unit_been_hit and (is_damagable or is_ragdolled) then
			impact_result = "continue_straight"
		end
	end

	if explosion_queue_index then
		local queue = self._wait_for_explosion_queue_index

		queue[#queue + 1] = explosion_queue_index
	end

	if (mark_for_deletion or force_delete) and not self._marked_for_deletion then
		self:_record_impact_concluded_stats()
		self._locomotion_extension:switch_to_sleep()

		self._marked_for_deletion = true
		impact_result = projectile_impact_results.removed
		self._life_time = 0

		self:_reset_suppressed_units()
	end

	self._has_impacted = true

	return impact_result
end

ProjectileDamageExtension._spawn_cluster = function (self, cluster_settings, direction)
	local owner_unit = self._owner_unit
	local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")
	local locomotion_extension = self._locomotion_extension
	local _, position = locomotion_extension:previous_and_current_positions()
	local rotation, _ = locomotion_extension:current_rotation_and_direction()
	local material
	local item_name = cluster_settings.item
	local projectile_template = cluster_settings.projectile_template
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local starting_state = locomotion_states.manual_physics
	local start_speed = cluster_settings.start_speed
	local speed = math.lerp(start_speed.min, start_speed.max, math.random())
	local max = cluster_settings.randomized_angular_velocity or math.pi / 20
	local angular_velocity = Vector3(math.random() * max, math.random() * max, math.random() * max)
	local is_critical_strike = false
	local origin_item_slot = self._origin_item_slot
	local weapon_item_or_nil = self._weapon_item_or_nil
	local number_of_clusters = cluster_settings.number

	if cluster_settings.stat_buff then
		local stat_buffs = buff_extension and buff_extension:stat_buffs()
		local increase = stat_buffs and stat_buffs[cluster_settings.stat_buff] or 0

		number_of_clusters = number_of_clusters + increase
	end

	local randomized_list
	local randomized_settings = cluster_settings.randomized_settings

	if randomized_settings then
		local random_buff_keyword = randomized_settings.buff_keyword
		local has_random_keyword = not random_buff_keyword or buff_extension and buff_extension:has_keyword(random_buff_keyword)
		local chance_value = has_random_keyword and randomized_settings.chance or 0

		if chance_value > 0 and chance_value > math.random() then
			randomized_list = randomized_settings.list
		end
	end

	local check_vector = Vector3.dot(direction, Vector3.right()) < 1 and Vector3.right() or Vector3.forward()
	local start_axis = Vector3.cross(direction, check_vector)
	local angle_distrbution = math.pi * 2 / number_of_clusters
	local random_start_rotation = math.pi * 2 * math.random()

	for ii = 1, number_of_clusters do
		if randomized_list then
			local available_items = #randomized_list
			local target_index = (ii - 1) % available_items + 1
			local selected_entry = randomized_list[target_index]

			item_name = selected_entry.projectile_template.item_name
			projectile_template = selected_entry.projectile_template
			item = item_definitions[item_name]
		end

		local angle = angle_distrbution * ii + random_start_rotation + math.lerp(-angle_distrbution * 0.5, angle_distrbution * 0.5, math.random())
		local random_rotation = Quaternion.axis_angle(direction, angle)
		local flat_direction = Quaternion.rotate(random_rotation, start_axis)
		local random_lerp = math.lerp(0, 0.7, math.random())
		local current_direction = Vector3.lerp(flat_direction, direction, random_lerp)
		local start_fuse_time = cluster_settings.start_fuse_time
		local times_steps = cluster_settings.fuse_time_steps
		local fuse_override_time = start_fuse_time + math.lerp(times_steps.min * ii, times_steps.max * ii, math.random())
		local unit_template_name = projectile_template.unit_template_name or "item_projectile"
		local projectile_unit, _ = Managers.state.unit_spawner:spawn_network_unit(nil, unit_template_name, position, random_rotation, material, item, projectile_template, starting_state, current_direction, speed, angular_velocity, owner_unit, is_critical_strike, origin_item_slot, nil, nil, nil, weapon_item_or_nil, fuse_override_time, self._owner_side_or_nil)
	end

	self._fx_extension:on_cluster()
end

ProjectileDamageExtension._spawn_unit = function (self, spawn_unit_settings)
	local locomotion_extension = self._locomotion_extension
	local _, position = locomotion_extension:previous_and_current_positions()
	local rotation, _ = Quaternion.identity()
	local owner_unit = self._owner_unit
	local unit_name = spawn_unit_settings.unit_name
	local husk_unit_name = spawn_unit_settings.unit_husk_name or unit_name
	local unit_template = spawn_unit_settings.unit_template
	local material, placed_on_unit
	local unit_template_parameters = spawn_unit_settings.unit_template_parameters
	local unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template, position, rotation, material, husk_unit_name, placed_on_unit, owner_unit, unit_template_parameters)
end

ProjectileDamageExtension.use_suppression = function (self)
	local projectile_template = self._projectile_template
	local damage_settings = projectile_template.damage
	local use_suppression = damage_settings.use_suppression

	return use_suppression
end

ProjectileDamageExtension.on_suppression = function (self, hit_unit, hit_position)
	local owner_unit = self._owner_unit
	local projectile_template = self._projectile_template
	local damage_settings = projectile_template.damage
	local impact_damage_settings = damage_settings and damage_settings.impact

	if not impact_damage_settings then
		return
	end

	local suppressed_units = self._suppressed_units
	local has_been_suppressed = suppressed_units[hit_unit]

	if has_been_suppressed then
		return
	end

	if Health.is_ragdolled(hit_unit) then
		return
	end

	if not ScriptUnit.has_extension(hit_unit, "health_system") then
		return
	end

	suppressed_units[hit_unit] = true

	local impact_damage_profile = impact_damage_settings.damage_profile

	Suppression.apply_suppression(hit_unit, owner_unit, impact_damage_profile, hit_position)
end

ProjectileDamageExtension.origin_item_slot = function (self)
	return self._origin_item_slot
end

ProjectileDamageExtension.hit_units = function (self)
	return self._hit_units
end

ProjectileDamageExtension._get_sticking_explosion_normal = function (self, sticking_to_unit, sticking_to_actor_index)
	local projectile_unit = self._projectile_unit
	local projectile_world_position = Unit.world_position(projectile_unit, 1)
	local sticking_to_world_position = Unit.world_position(sticking_to_unit, sticking_to_actor_index)
	local delta = sticking_to_world_position - projectile_world_position
	local explostion_direction = Vector3.normalize(delta)

	return explostion_direction
end

ProjectileDamageExtension._handle_buff_system_explosion_proc_events = function (self, owner_unit, projectile_template, triggered_on_impact)
	local projectile_type = projectile_template.projectile_type or projectile_types.default

	if projectile_type == projectile_types.player_grenade or projectile_type == projectile_types.ogryn_grenade then
		local item_name = projectile_template.item_name or "content/items/weapons/player/grenade_frag"
		local locomotion_extension = self._locomotion_extension
		local _, position = locomotion_extension:previous_and_current_positions()
		local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

		if buff_extension then
			local param_table = buff_extension:request_proc_event_param_table()

			if param_table then
				param_table.owner_unit = owner_unit
				param_table.item_name = item_name
				param_table.projectile_template = projectile_template
				param_table.position = Vector3Box(position)
				param_table.triggered_on_impact = triggered_on_impact

				buff_extension:add_proc_event(buff_proc_events.on_player_grenade_exploded, param_table)
			end
		end
	end
end

ProjectileDamageExtension._handle_explosion_achivements = function (self, player, explosion_hit_units_table)
	local archetype_name = player:archetype_name()

	if archetype_name == "veteran" and not self._has_impacted then
		local count = 0

		for hit_unit, _ in pairs(explosion_hit_units_table) do
			count = count + 1
		end

		if count >= 5 then
			Managers.achievements:unlock_achievement(player, "veteran_2_unbounced_grenade_kills")
		end
	end
end

ProjectileDamageExtension._record_impact_concluded_stats = function (self)
	local player = Managers.state.player_unit_spawn:owner(self._owner_unit)

	if player then
		local impact_hit = self._impact_hit
		local num_impact_hit_weakspot = self._impact_hit_weakspot
		local num_impact_hit_kill = self._num_impact_hit_kill
		local num_impact_hit_elite = self._num_impact_hit_elite
		local num_impact_hit_special = self._num_impact_hit_special
		local num_impact_hit_minion = self._num_impact_hit_minion
		local projectile_template = self._projectile_template
		local projectile_name = projectile_template and projectile_template.name or "none"
		local hit_count = 0

		for hit_unit, _ in pairs(_explosion_hit_units_table) do
			hit_count = hit_count + 1
		end

		Managers.stats:record_private("hook_projectile_hit", player, impact_hit, num_impact_hit_weakspot, num_impact_hit_kill, num_impact_hit_elite, num_impact_hit_special, projectile_name, hit_count, num_impact_hit_minion)
	end
end

return ProjectileDamageExtension
