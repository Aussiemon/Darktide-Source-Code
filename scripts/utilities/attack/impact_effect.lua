local Armor = require("scripts/utilities/attack/armor")
local AttackingUnitResolver = require("scripts/utilities/attack/attacking_unit_resolver")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffectSettings = require("scripts/settings/damage/impact_effect_settings")
local MaterialQuery = require("scripts/utilities/material_query")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local Weakspot = require("scripts/utilities/attack/weakspot")
local attack_results = AttackSettings.attack_results
local damage_efficiencies = AttackSettings.damage_efficiencies
local hit_zone_names = HitZone.hit_zone_names
local impact_fx_anim = ImpactEffectSettings.impact_anim
local impact_fx_lookup = ImpactEffectSettings.impact_fx_lookup
local surface_hit_types = SurfaceMaterialSettings.hit_types
local PI = math.pi
local EMPTY_TABLE = {}
local MATERIAL_QUERY_DISTANCE = 0.1
local _can_play, _impact_effect_anim_from_direction, _impact_effect_anim_from_direction_with_hit_zones, _impact_fx, _surface_impact_fx = nil
local ImpactEffect = {}
local DEFAULT_HIT_REACTS_MIN_DAMAGE = 0

ImpactEffect.play = function (attacked_unit, hit_actor_or_nil, damage, damage_type, hit_zone_name, attack_result, hit_position, hit_normal, attack_direction, attacking_unit, impact_fx_data_or_nil, attack_was_stopped, attack_type, damage_efficiency, damage_profile)
	impact_fx_data_or_nil = impact_fx_data_or_nil or EMPTY_TABLE
	local unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
	local breed_or_nil = unit_data_extension and unit_data_extension:breed()

	if not _can_play(damage_type, breed_or_nil, hit_position, attack_direction, attacking_unit) then
		return
	end

	local is_server = Managers.state.game_session:is_server()
	local will_be_predicted = not not impact_fx_data_or_nil.will_be_predicted
	local local_only = not not impact_fx_data_or_nil.local_only
	local armor = Armor.armor_type(attacked_unit, breed_or_nil, hit_zone_name, attack_type)
	local attacker_buff_extension = ScriptUnit.has_extension(attacking_unit, "buff_system")
	local hit_weakspot = Weakspot.hit_weakspot(breed_or_nil, hit_zone_name, attack_type, attacker_buff_extension)
	local did_damage = damage > 0
	local target_alive = HEALTH_ALIVE[attacked_unit]
	local impact_fx = _impact_fx(damage_type, breed_or_nil, did_damage, hit_weakspot, armor, attack_was_stopped, attack_result, damage_efficiency, target_alive, hit_zone_name)

	if impact_fx then
		local source_parameters = impact_fx_data_or_nil.source_parameters or EMPTY_TABLE
		local fx_system = Managers.state.extension:system("fx_system")
		local node_index = hit_actor_or_nil and Actor.node(hit_actor_or_nil)
		local attacking_unit_owner_unit = AttackingUnitResolver.resolve(attacking_unit)

		fx_system:play_impact_fx(impact_fx, hit_position, attack_direction, source_parameters, attacking_unit_owner_unit, attacked_unit, node_index, hit_normal, will_be_predicted, local_only)
	end

	local should_play_offset_animation = target_alive and Unit.has_animation_state_machine(attacked_unit) and not breed_or_nil.ignore_hit_reacts and damage_profile and not damage_profile.ignore_hit_reacts
	should_play_offset_animation = should_play_offset_animation and (breed_or_nil.hit_reacts_min_damage or DEFAULT_HIT_REACTS_MIN_DAMAGE) <= damage

	if should_play_offset_animation then
		local attacked_unit_dir = Quaternion.forward(Unit.local_rotation(attacked_unit, 1))
		local angle_difference = Vector3.flat_angle(attacked_unit_dir, attack_direction)
		local direction = nil

		if angle_difference < -PI * 0.75 or angle_difference > PI * 0.75 then
			direction = "bwd"
		elseif angle_difference < -PI * 0.25 then
			direction = "right"
		elseif angle_difference < PI * 0.25 then
			direction = "fwd"
		else
			direction = "left"
		end

		local anim = nil

		if breed_or_nil and breed_or_nil.hit_zone_hit_reactions then
			anim = _impact_effect_anim_from_direction_with_hit_zones(attacking_unit, attacked_unit, attacked_unit_dir, breed_or_nil, hit_position, hit_zone_name)
		else
			anim = _impact_effect_anim_from_direction(direction, breed_or_nil, attack_result, hit_zone_name)
		end

		if anim and Unit.has_animation_event(attacked_unit, anim) then
			if is_server then
				local except = nil

				if will_be_predicted then
					local player_unit_spawn_manager = Managers.state.player_unit_spawn
					local attacking_player = player_unit_spawn_manager:owner(attacking_unit)

					if attacking_player:is_human_controlled() then
						except = attacking_player:channel_id()
					end
				end

				local anim_extension = ScriptUnit.extension(attacked_unit, "animation_system")

				anim_extension:anim_event(anim, except)
			else
				Unit.animation_event(attacked_unit, anim)
			end
		end
	end
end

ImpactEffect.save_surface_effect = function (effects_data, unit_index, hit_index, fire_position, attacked_unit, hit_actor_or_nil, hit_position, hit_normal)
	local data = effects_data[unit_index]
	local hit_data = data.hits[hit_index]

	if not hit_data then
		return
	end

	data.attacked_unit = attacked_unit
	data.fire_position = fire_position
	hit_data.hit_actor_or_nil = hit_actor_or_nil
	hit_data.hit_position = hit_position
	hit_data.hit_normal = hit_normal
end

ImpactEffect.play_surface_effect = function (physics_world, attacking_unit, hit_position, hit_normal, hit_direction, damage_type, hit_type, impact_fx_data)
	local will_be_predicted = not not impact_fx_data.will_be_predicted
	local source_parameters = impact_fx_data.source_parameters or EMPTY_TABLE
	local fx_system = Managers.state.extension:system("fx_system")

	fx_system:play_surface_impact_fx(hit_position, hit_direction, source_parameters, attacking_unit, hit_normal, damage_type, hit_type, will_be_predicted)
end

local temp_hit_positions = {}
local temp_hit_normals = {}

ImpactEffect.play_shotshell_surface_effect = function (physics_world, attacking_unit, unit_to_index_lookup, num_hits_per_unit, impact_data, damage_type, hit_type, impact_fx_data)
	local will_be_predicted = not not impact_fx_data.will_be_predicted
	local source_parameters = impact_fx_data.source_parameters or EMPTY_TABLE
	local fx_system = Managers.state.extension:system("fx_system")

	for hit_unit, unit_index in pairs(unit_to_index_lookup) do
		table.clear(temp_hit_positions)
		table.clear(temp_hit_normals)

		local num_hits = num_hits_per_unit[hit_unit]
		local effect_data = impact_data[unit_index]
		local hit_data = effect_data.hits
		local fire_position = effect_data.fire_position

		for ii = 1, num_hits do
			local data = hit_data[ii]
			local hit_position = data.hit_position
			local hit_normal = data.hit_normal
			temp_hit_positions[ii] = hit_position
			temp_hit_normals[ii] = hit_normal
		end

		fx_system:play_shotshell_surface_impact_fx(fire_position, temp_hit_positions, temp_hit_normals, source_parameters, attacking_unit, damage_type, hit_type, will_be_predicted)
	end
end

ImpactEffect.surface_impact_fx = function (physics_world, attacking_unit, hit_position, hit_normal, hit_direction, damage_type, hit_type)
	local hit, material, _, _, hit_unit, hit_actor = MaterialQuery.query_material(physics_world, hit_position - hit_direction * MATERIAL_QUERY_DISTANCE, hit_position + hit_direction * MATERIAL_QUERY_DISTANCE, "projectile_impact")
	local surface_impact_fx = _surface_impact_fx(damage_type, material, hit_type)

	return surface_impact_fx
end

local NUM_FX_MULTIPLIER = 0.4
local MAX_FX_PER_UNIT = 8
local temp_surface_impact_fxs = {}
local temp_shotshell_materials = {}

ImpactEffect.shotshell_surface_impact_fx = function (physics_world, fire_position, attacking_unit, hit_positions, hit_normals, damage_type, hit_type)
	table.clear(temp_surface_impact_fxs)
	table.clear(temp_shotshell_materials)

	local seed = math.random_seed()

	table.shuffle(hit_positions, seed)
	table.shuffle(hit_normals, seed)

	local num_hits = #hit_positions
	local modulo = math.min(math.ceil(num_hits / (math.ceil(num_hits * NUM_FX_MULTIPLIER) + 1)), MAX_FX_PER_UNIT)
	local hit, hit_material, hit_unit, hit_actor, _, surface_impact_fx = nil
	local index = 0

	for ii = 1, num_hits do
		local hit_position = hit_positions[ii]
		local hit_direction = Vector3.normalize(hit_position - fire_position)
		local hit_normal = Vector3.normalize(hit_normals[ii])
		hit, hit_material, _, _, hit_unit, hit_actor = MaterialQuery.query_material(physics_world, hit_position - hit_direction * MATERIAL_QUERY_DISTANCE, hit_position + hit_direction * MATERIAL_QUERY_DISTANCE, "projectile_impact")
		surface_impact_fx = _surface_impact_fx(damage_type, hit_material, hit_type)

		if surface_impact_fx then
			local decal_only = ii % modulo ~= 0
			temp_surface_impact_fxs[index + 1] = surface_impact_fx
			temp_surface_impact_fxs[index + 2] = hit_position
			temp_surface_impact_fxs[index + 3] = hit_normal
			temp_surface_impact_fxs[index + 4] = hit_direction
			temp_surface_impact_fxs[index + 5] = hit_unit
			temp_surface_impact_fxs[index + 6] = hit_actor
			temp_surface_impact_fxs[index + 7] = decal_only
			index = index + 7
		end
	end

	return temp_surface_impact_fxs
end

function _can_play(damage_type, breed, hit_position, attack_direction, attacking_unit)
	if not damage_type then
		return false
	end

	if not breed then
		return false
	end

	if not hit_position then
		return false
	end

	if not attack_direction then
		return false
	end

	if not attacking_unit then
		return false
	end

	return true
end

function _impact_fx(damage_type, breed, did_damage, hit_weakspot, armor_type, attack_was_stopped, attack_result, damage_efficiency, target_alive, hit_zone_name)
	local breed_impact_fx_overrides = breed.impact_fx_override or EMPTY_TABLE
	local breed_impact_fx_override = breed_impact_fx_overrides[damage_type]
	local impact_fxs = nil
	local hitzone_armor_override = breed.hitzone_armor_override

	if hitzone_armor_override and hitzone_armor_override[hit_zone_name] then
		armor_type = hitzone_armor_override[hit_zone_name]
	end

	if breed_impact_fx_override then
		impact_fxs = breed_impact_fx_override
	else
		local default_damage_type_impact_fx = impact_fx_lookup[damage_type]
		local armor_fx = default_damage_type_impact_fx and default_damage_type_impact_fx.armor
		impact_fxs = armor_fx and armor_fx[armor_type]
	end

	if not impact_fxs then
		return nil
	end

	local impact_fx = nil
	local died = attack_result == attack_results.died

	if not target_alive and not died then
		impact_fx = impact_fxs.dead

		return impact_fx
	end

	local damaged = attack_result == attack_results.damaged
	local shield_blocked = attack_result == attack_results.shield_blocked
	local blocked = attack_result == attack_results.blocked
	local toughness_absorbed = attack_result == attack_results.toughness_absorbed
	local fiendly_fire = attack_result == attack_results.friendly_fire

	if shield_blocked or fiendly_fire then
		impact_fx = impact_fxs.shield_blocked or impact_fxs.damage_negated
	elseif blocked then
		impact_fx = impact_fxs.blocked or impact_fxs.damage_negated
	elseif toughness_absorbed then
		impact_fx = impact_fxs.toughness_absorbed or impact_fxs.damage_negated
	elseif damaged and damage_efficiency == damage_efficiencies.push then
		impact_fx = impact_fxs.shove
	elseif damage_efficiency == damage_efficiencies.negated then
		impact_fx = impact_fxs.damage_negated
	end

	if impact_fx then
		return impact_fx
	end

	if attack_was_stopped and impact_fxs.stopped then
		impact_fx = impact_fxs.stopped
	elseif died and impact_fxs.died then
		local weakspot_died_impact_fx = impact_fxs.weakspot_died

		if hit_weakspot and weakspot_died_impact_fx then
			impact_fx = weakspot_died_impact_fx
		else
			impact_fx = impact_fxs.died
		end
	else
		local weakspot_damage_impact_fx = impact_fxs.weakspot_damage

		if hit_weakspot and weakspot_damage_impact_fx then
			impact_fx = weakspot_damage_impact_fx
		else
			local damage_reduced_impact_fx = impact_fxs.damage_reduced

			if damage_efficiency == damage_efficiencies.reduced and damage_reduced_impact_fx then
				impact_fx = damage_reduced_impact_fx
			else
				impact_fx = impact_fxs.damage
			end
		end
	end

	return impact_fx
end

function _impact_effect_anim_from_direction(direction, breed, attack_result, hit_zone_name)
	local attack_result_impact_anim_override = breed.impact_anim_override or EMPTY_TABLE
	local impact_anim_override = nil

	if hit_zone_name == hit_zone_names.shield then
		impact_anim_override = attack_result_impact_anim_override.shield_blocked
	else
		impact_anim_override = attack_result_impact_anim_override[attack_result]
	end

	impact_anim_override = impact_anim_override or attack_result_impact_anim_override.default or EMPTY_TABLE
	local impact_anim = impact_anim_override[direction] or impact_fx_anim[direction]

	return impact_anim
end

function _impact_effect_anim_from_direction_with_hit_zones(attacking_unit, attacked_unit, unit_fwd, breed, hit_position, hit_zone_name)
	local hit_zone_hit_reactions = breed.hit_zone_hit_reactions
	local hit_zone_hit_reaction = hit_zone_hit_reactions[hit_zone_name]

	if not hit_zone_hit_reaction then
		return
	end

	if type(hit_zone_hit_reaction) == "table" then
		local to_hit_position = Vector3.normalize(hit_position - POSITION_LOOKUP[attacking_unit])
		local is_to_the_left = Vector3.cross(unit_fwd, to_hit_position).z > 0
		hit_zone_hit_reaction = is_to_the_left and hit_zone_hit_reaction.left or hit_zone_hit_reaction.right
	end

	return hit_zone_hit_reaction
end

function _surface_impact_fx(damage_type, material_type, hit_type)
	local default_damage_type_impact_fx = impact_fx_lookup[damage_type]

	if not default_damage_type_impact_fx then
		return nil
	end

	local materials_fxs = default_damage_type_impact_fx.material

	if not materials_fxs then
		return nil
	end

	local impact_fxs = materials_fxs[material_type]

	if not impact_fxs then
		return nil
	end

	local impact_fx = impact_fxs[hit_type] or impact_fxs[surface_hit_types.stop]

	return impact_fx
end

return ImpactEffect
