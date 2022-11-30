local Armor = require("scripts/utilities/attack/armor")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Breed = require("scripts/utilities/breed")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local Explosion = require("scripts/utilities/attack/explosion")
local Health = require("scripts/utilities/health")
local HitMass = require("scripts/utilities/attack/hit_mass")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MasterItems = require("scripts/backend/master_items")
local MinionDeath = require("scripts/utilities/minion_death")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LagCompensation = require("scripts/utilities/lag_compensation")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local Suppression = require("scripts/utilities/attack/suppression")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local armor_types = ArmorSettings.types
local attack_results = AttackSettings.attack_results
local buff_keywords = BuffSettings.keywords
local surface_hit_types = SurfaceMaterialSettings.hit_types
local projectile_impact_results = ProjectileLocomotionSettings.impact_results
local ProjectileDamageExtension = class("ProjectileDamageExtension")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local IMPACT_FX_DATA = {
	will_be_predicted = false,
	source_parameters = {}
}
local IMPACT_CONFIG = {
	destroy_on_impact = false
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
	self._fuse_override_time = extension_init_data.fuse_override_time
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
	local projectile_template = self._projectile_template
	local damage_settings = projectile_template.damage
	local fuse_damage_settings = damage_settings and damage_settings.fuse
	self._fuse_started = not fuse_damage_settings.impact_triggered
	local hit_mass_budget_attack, hit_mass_budget_impact = self:_calculate_hit_mass()
	self._hit_mass_budget_attack = hit_mass_budget_attack
	self._hit_mass_budget_impact = hit_mass_budget_impact
end

ProjectileDamageExtension._calculate_hit_mass = function (self)
	local owner_unit = self._owner_unit
	local charge_level = self._charge_level or 1
	local is_critical_strike = self._is_critical_strike
	local projectile_template = self._projectile_template
	local damage_settings = projectile_template.damage
	local impact_damage_settings = damage_settings and damage_settings.impact

	if impact_damage_settings and impact_damage_settings.delete_on_hit_mass then
		local impact_damage_profile = impact_damage_settings.damage_profile
		local damage_profile_lerp_values = DamageProfile.lerp_values(impact_damage_profile, owner_unit)
		local hit_mass_budget_attack, hit_mass_budget_impact = DamageProfile.max_hit_mass(impact_damage_profile, DEFAULT_POWER_LEVEL, charge_level, damage_profile_lerp_values, is_critical_strike)

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

local _explosion_attack_result_table = {}

ProjectileDamageExtension.fixed_update = function (self, unit, dt, t)
	if self._marked_for_deletion then
		return
	end

	local locomotion_extension = self._locomotion_extension
	local world = self._world
	local physics_world = self._physics_world
	local owner_unit = self._owner_unit
	local projectile_unit = self._projectile_unit
	local projectile_template = self._projectile_template
	local life_time = self._life_time
	local is_critical_strike = self._is_critical_strike
	local weapon_item_or_nil = self._weapon_item_or_nil
	local origin_slot_or_nil = self._origin_item_slot
	local charge_level = self._charge_level or 1
	local damage_settings = projectile_template.damage
	local fuse_damage_settings = damage_settings and damage_settings.fuse
	local _, position = locomotion_extension:previous_and_current_positions()

	if self._reset_time and not fuse_damage_settings.skipp_reset then
		life_time = 0
		self._reset_time = false
	end

	local fx_system = Managers.state.extension:system("fx_system")
	local effects = projectile_template.effects
	local sfx = effects and effects.sfx
	local mark_for_deletion = false
	local new_life_time = life_time + dt
	local impact_triggered = fuse_damage_settings and fuse_damage_settings.impact_triggered
	local min_lifetime = fuse_damage_settings.min_lifetime
	local fuse_started = self._fuse_started
	local sticking_to_unit, sticking_to_actor_index = locomotion_extension:sticking_to_unit()
	local fuse_time = self._fuse_override_time or sticking_to_unit and fuse_damage_settings.sticky_fuse_time or fuse_damage_settings.fuse_time

	if min_lifetime then
		if min_lifetime < new_life_time then
			fuse_started = true
		end
	elseif impact_triggered then
		if impact_triggered and not self._has_impacted then
			if new_life_time > fuse_time * 2 then
				fuse_started = true
			else
				fuse_started = false
			end
		elseif impact_triggered and self._has_impacted then
			fuse_started = true
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

		if new_life_time > fuse_time then
			local fuse_explosion_template = fuse_damage_settings.explosion_template
			local fuse_liquid_area_template = fuse_damage_settings.liquid_area_template
			local default_explosion_normal = fuse_damage_settings.default_explosion_normal

			if fuse_explosion_template then
				local explosion_normal = nil

				if sticking_to_unit then
					explosion_normal = self:_get_sticking_explosion_normal(sticking_to_unit, sticking_to_actor_index)
				elseif default_explosion_normal then
					explosion_normal = default_explosion_normal:unbox()
				end

				table.clear(_explosion_attack_result_table)
				Explosion.create_explosion(world, physics_world, position, explosion_normal, projectile_unit, fuse_explosion_template, DEFAULT_POWER_LEVEL, charge_level, AttackSettings.attack_types.explosion, is_critical_strike, false, weapon_item_or_nil, origin_slot_or_nil, _explosion_attack_result_table)
			end

			local critical_strike_fuse_settings = is_critical_strike and damage_settings.critical_strike and damage_settings.critical_strike.fuse
			local cluster_settings = critical_strike_fuse_settings and critical_strike_fuse_settings.cluster or fuse_damage_settings.cluster

			if cluster_settings then
				local direction = Vector3.up()

				self:_spawn_cluster(cluster_settings, direction)
			end

			if player then
				self:_handle_explosion_achivements(player, _explosion_attack_result_table)
			end

			if fuse_liquid_area_template then
				LiquidArea.try_create(position, Vector3.down(), self._nav_world, fuse_liquid_area_template, owner_unit, nil, nil, weapon_item_or_nil)
			end

			self._fx_extension:on_build_up_stop()

			mark_for_deletion = true
		end
	end

	if mark_for_deletion and not self._marked_for_deletion and not self._locomotion_extension:has_been_marked_for_deletion() then
		Managers.state.unit_spawner:mark_for_deletion(projectile_unit)

		self._marked_for_deletion = true
	end

	self._life_time = new_life_time
end

ProjectileDamageExtension.on_impact = function (self, hit_position, hit_actor, hit_direction, hit_normal, current_speed, force_delete)
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
	local impact_result = nil

	if impact_damage_settings then
		local impact_damage_profile = impact_damage_settings.damage_profile
		local impact_damage_type = impact_damage_settings.damage_type
		local impact_explosion_template = impact_damage_settings.explosion_template
		local impact_liquid_area_template = impact_damage_settings.liquid_area_template
		local impact_suppression_settings = impact_damage_settings.suppression_settings
		local hit_unit = Actor.unit(hit_actor)
		local hit_units = self._hit_units
		local have_unit_been_hit = hit_units[hit_unit]
		local is_not_self = hit_unit ~= owner_unit
		local hit_mass_stop = false
		local do_impact_explosion = not not impact_explosion_template
		local charge_level = self._charge_level or 1
		local health_extension = ScriptUnit.has_extension(hit_unit, "health_system")
		local is_ragdolled = Health.is_ragdolled(hit_unit)
		local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
		local breed_or_nil = unit_data_extension and unit_data_extension:breed()

		if not have_unit_been_hit and is_not_self then
			local hit_zone_name = HitZone.get_name(hit_unit, hit_actor)
			local hit_hard_target = false
			hit_units[hit_unit] = true

			if is_ragdolled then
				MinionDeath.attack_ragdoll(hit_unit, direction, impact_damage_profile, impact_damage_type, hit_zone_name, hit_position, owner_unit, hit_actor, nil)

				impact_result = "continue_straight"
			elseif impact_damage_profile and health_extension then
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
					local hit_mass_budget_attack, hit_mass_budget_impact = HitMass.consume_hit_mass(owner_unit, hit_unit, self._hit_mass_budget_attack, self._hit_mass_budget_impact, false)
					hit_mass_stop = HitMass.stopped_attack(hit_unit, hit_zone_name, hit_mass_budget_attack, hit_mass_budget_impact, IMPACT_CONFIG)
					self._hit_mass_budget_attack = hit_mass_budget_attack
					self._hit_mass_budget_impact = hit_mass_budget_impact
					do_impact_explosion = false
					impact_result = "continue_straight"
				end

				local damage_dealt, attack_result, damage_efficiency, stagger_result = Attack.execute(hit_unit, impact_damage_profile, "attack_direction", hit_direction, "power_level", DEFAULT_POWER_LEVEL, "hit_zone_name", hit_zone_name, "target_index", 1, "charge_level", impact_charge_level, "is_critical_strike", is_critical_strike, "hit_actor", hit_actor, "hit_world_position", hit_position, "attack_type", AttackSettings.attack_types.ranged, "damage_type", impact_damage_type, "attacking_unit", projectile_unit, "item", weapon_item_or_nil)

				if impact_damage_type then
					ImpactEffect.play(hit_unit, hit_actor, damage_dealt, impact_damage_type, hit_zone_name, attack_result, hit_position, hit_normal, hit_direction, projectile_unit, IMPACT_FX_DATA, false, AttackSettings.attack_types.ranged, damage_efficiency, impact_damage_profile)
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

			local sticking_to_unit, _ = locomotion_extension:sticking_to_unit()
			local stick_to_func_ok = not sticks_to_func or sticks_to_func(projectile_unit, hit_unit, hit_zone_name)
			local can_projectile_stick = not sticking_to_unit and (sticks_to_armor_types or sticks_to_breeds or sticks_to_tags) and stick_to_func_ok

			if can_projectile_stick and HEALTH_ALIVE[hit_unit] and unit_data_extension then
				local armor_type = Armor.armor_type(hit_unit, breed_or_nil, hit_zone_name)
				local stick_to_armor = sticks_to_armor_types and sticks_to_armor_types[armor_type]
				local stick_to_breed = sticks_to_breeds and sticks_to_breeds[breed_or_nil.name]
				local stick_to_tag = false

				if sticks_to_tags and breed_or_nil.tags then
					for tag, _ in pairs(breed_or_nil.tags) do
						if sticks_to_tags[tag] then
							stick_to_tag = true

							break
						end
					end
				end

				if stick_to_armor or stick_to_breed or stick_to_tag then
					local hit_actor_index = Actor.node(hit_actor)

					locomotion_extension:switch_to_sticky(hit_unit, hit_actor_index, hit_position, rotation)

					self._life_time = 0

					self._fx_extension:on_stick()
					self._fx_extension:on_build_up_start()

					impact_result = projectile_impact_results.stick
				end
			end

			hit_mass_stop = impact_damage_settings.delete_on_hit_mass and hit_mass_stop

			if hit_hard_target and impact_damage_settings.delete_on_impact or hit_mass_stop then
				mark_for_deletion = true
				do_impact_explosion = not not impact_explosion_template
			end

			local physics_world = self._physics_world
			local fuse_damage_settings = damage_settings and damage_settings.fuse

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
				table.clear(_explosion_attack_result_table)
				Explosion.create_explosion(self._world, physics_world, hit_position, nil, projectile_unit, impact_explosion_template, DEFAULT_POWER_LEVEL, charge_level, AttackSettings.attack_types.explosion, is_critical_strike, false, weapon_item_or_nil, origin_slot_or_nil, _explosion_attack_result_table)

				mark_for_deletion = true
				local player = Managers.state.player_unit_spawn:owner(owner_unit)

				if player then
					self:_handle_explosion_achivements(player, _explosion_attack_result_table)
				end
			else
				self._reset_time = true
			end

			local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

			if buff_extension and buff_extension:has_keyword(buff_keywords.cluster_explode_on_super_armored) then
				local hit_zone_is_shield = hit_zone_name == "shield"
				local hitzone_armor_override = breed_or_nil and breed_or_nil.hitzone_armor_override and breed_or_nil.hitzone_armor_override[hit_zone_name]
				local is_super_armored_hit = breed_or_nil and breed_or_nil.armor_type and (breed_or_nil.armor_type == armor_types.super_armor or breed_or_nil.armor_type == armor_types.armored or breed_or_nil.armor_type == armor_types.resistant) or hitzone_armor_override == armor_types.super_armor or hitzone_armor_override == armor_types.armored or hitzone_armor_override == armor_types.resistant
				local super_armored_settings = (is_super_armored_hit or hit_zone_is_shield) and damage_settings.super_armored and damage_settings.super_armored.impact.cluster

				if super_armored_settings and not self.has_cluster_impacted then
					local cluster_direction = hit_hard_target and hit_normal or Vector3.lerp(hit_normal, Vector3.up(), 0.5)

					self:_spawn_cluster(super_armored_settings, cluster_direction)

					self.has_cluster_impacted = true
					mark_for_deletion = super_armored_settings.mark_for_deletion
				end
			end

			if impact_liquid_area_template then
				LiquidArea.try_create(hit_position, hit_direction, self._nav_world, impact_liquid_area_template, owner_unit, nil, nil, weapon_item_or_nil)

				mark_for_deletion = true
			end

			if not health_extension and impact_damage_type then
				ImpactEffect.play_surface_effect(physics_world, projectile_unit, hit_position, hit_normal, hit_direction, impact_damage_type, surface_hit_types.stop, IMPACT_FX_DATA)
			end
		elseif have_unit_been_hit and (health_extension or is_ragdolled) then
			impact_result = "continue_straight"
		end
	end

	if (mark_for_deletion or force_delete) and not self._marked_for_deletion and not self._locomotion_extension:has_been_marked_for_deletion() then
		Managers.state.unit_spawner:mark_for_deletion(projectile_unit)

		self._marked_for_deletion = true
		impact_result = projectile_impact_results.removed
		self._life_time = 0

		self:_reset_suppressed_units()
	end

	self._has_impacted = true

	return impact_result
end

ProjectileDamageExtension._spawn_cluster = function (self, cluster_settings, direction)
	local locomotion_extension = self._locomotion_extension
	local _, position = locomotion_extension:previous_and_current_positions()
	local rotation, _ = locomotion_extension:current_rotation_and_direction()
	local material = nil
	local item_name = cluster_settings.item
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local projectile_template = cluster_settings.projectile_template
	local starting_state = "manual_physics"
	local start_speed = cluster_settings.start_speed
	local speed = math.lerp(start_speed.min, start_speed.max, math.random())
	local max = cluster_settings.randomized_angular_velocity or math.pi / 20
	local angular_velocity = Vector3(math.random() * max, math.random() * max, math.random() * max)
	local owner_unit = self._owner_unit
	local is_critical_strike = false
	local origin_item_slot = self._origin_item_slot
	local weapon_item_or_nil = self._weapon_item_or_nil
	local number_of_clusters = cluster_settings.number
	local check_vector = Vector3.dot(direction, Vector3.right()) < 1 and Vector3.right() or Vector3.forward()
	local start_axis = Vector3.cross(direction, check_vector)
	local angle_distrbution = math.pi * 2 / number_of_clusters
	local random_start_rotation = math.pi * 2 * math.random()

	for i = 1, number_of_clusters do
		local angle = angle_distrbution * i + random_start_rotation + math.lerp(-angle_distrbution * 0.5, angle_distrbution * 0.5, math.random())
		local random_rotation = Quaternion.axis_angle(direction, angle)
		local flat_direction = Quaternion.rotate(random_rotation, start_axis)
		local random_lerp = math.lerp(0, 0.7, math.random())
		local current_direction = Vector3.lerp(flat_direction, direction, random_lerp)
		local start_fuse_time = cluster_settings.start_fuse_time
		local times_steps = cluster_settings.fuse_time_steps
		local fuse_override_time = start_fuse_time + math.lerp(times_steps.min * i, times_steps.max * i, math.random())
		local projectile_unit, _ = Managers.state.unit_spawner:spawn_network_unit(nil, "item_projectile", position, random_rotation, material, item, projectile_template, starting_state, current_direction, speed, angular_velocity, owner_unit, is_critical_strike, origin_item_slot, nil, nil, nil, weapon_item_or_nil, fuse_override_time)
	end

	self._fx_extension:on_cluster()
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

ProjectileDamageExtension.get_origin_item_slot = function (self)
	return self._origin_item_slot
end

ProjectileDamageExtension._get_sticking_explosion_normal = function (self, sticking_to_unit, sticking_to_actor_index)
	local projectile_unit = self._projectile_unit
	local projectile_world_position = Unit.world_position(projectile_unit, 1)
	local sticking_to_world_position = Unit.world_position(sticking_to_unit, sticking_to_actor_index)
	local delta = sticking_to_world_position - projectile_world_position
	local explostion_direction = Vector3.normalize(delta)

	return explostion_direction
end

ProjectileDamageExtension._handle_explosion_achivements = function (self, player, explosion_attack_result_table)
	local profile = player:profile()
	local specializtion_name = profile.specialization

	if specializtion_name == "veteran_2" and not self._has_impacted then
		local count = 0

		for _, attack_result in pairs(explosion_attack_result_table) do
			count = count + 1
		end

		if count >= 5 then
			Managers.achievements:trigger_event(player:account_id(), player:character_id(), "veteran_2_unbounced_grenade_hits_event")
		end
	end
end

return ProjectileDamageExtension
