-- chunkname: @scripts/settings/damage/explosion_templates/expedition_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local ExpeditionEventSettings = require("scripts/settings/expeditions/expedition_event_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Breed = require("scripts/utilities/breed")
local damage_types = DamageSettings.damage_types
local lightning_strikes_event_settings = ExpeditionEventSettings.lightning_strikes
local PLAZA_SIZE = 30
local STREET_SIZE = 18
local CORRIDOR_SIZE = 10
local AIRSTRIKE_RADIUS = STREET_SIZE / 2
local ARTILLERY_STRIKE_RADIUS = STREET_SIZE / 2
local BIG_GRENADE_RADIUS = STREET_SIZE
local PROXIMITY_TRAP_RADIUS = CORRIDOR_SIZE / 2
local ATTACK_VALKYRIE_MISSILE_RADIUS = STREET_SIZE / 2

local function _expedition_airstrike_nuke_target_validation_func(hit_unit, target_breed)
	if not target_breed then
		return false
	elseif Breed.is_player(target_breed) then
		return false
	end

	return true
end

local explosion_templates = {
	lightning_strike_impact = {
		charge_wwise_parameter_name = "charge_level",
		close_damage_type = nil,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = false,
		damage_type = nil,
		min_close_radius = 0,
		scalable_radius = true,
		static_power_level = 500,
		radius = lightning_strikes_event_settings.impact_radius,
		min_radius = lightning_strikes_event_settings.impact_radius * 0.5,
		close_radius = lightning_strikes_event_settings.impact_radius * 0.5,
		close_damage_profile = DamageProfileTemplates.expeditions_lightning_strike_explosion_close,
		damage_profile = DamageProfileTemplates.expeditions_lightning_strike_explosion,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		scalable_vfx = {},
		sfx = {},
		target_validation_func = function (unit)
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system.side_by_unit[unit]
			local is_player_unit = side.player_units[unit]

			if is_player_unit then
				return true
			end

			local has_perception_extension = ScriptUnit.has_extension(unit, "perception_system")

			if has_perception_extension then
				local valid_enemy_player_units = side.valid_enemy_player_units
				local perception_extension = ScriptUnit.extension(unit, "perception_system")
				local num_enemies = #valid_enemy_player_units

				for i = 1, num_enemies do
					local target_unit = valid_enemy_player_units[i]
					local has_line_of_sight = perception_extension:has_line_of_sight(target_unit)

					if has_line_of_sight then
						return true
					end
				end

				return false
			end
		end,
	},
	expedition_airstrike_nuke = {
		always_disorient = true,
		close_damage_type = nil,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = false,
		damage_type = nil,
		player_disorientation_type = "friendly_explosion_heavy",
		scalable_radius = true,
		static_power_level = 1000,
		radius = AIRSTRIKE_RADIUS,
		min_radius = AIRSTRIKE_RADIUS / 2,
		close_radius = AIRSTRIKE_RADIUS / 2,
		min_close_radius = AIRSTRIKE_RADIUS / 3,
		close_damage_profile = DamageProfileTemplates.expedition_airstrike_nuke_close,
		damage_profile = DamageProfileTemplates.expedition_airstrike_nuke,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		target_validation_func = _expedition_airstrike_nuke_target_validation_func,
		vfx = {
			"content/fx/particles/explosions/expeditions_call_in_barrels_explosion",
		},
		sfx = {
			"wwise/events/weapon/play_airdrop_bomb_explosion",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	expeditions_artillery_strike = {
		charge_wwise_parameter_name = "charge_level",
		collision_filter = "filter_player_character_explosion",
		damage_falloff = false,
		player_disorientation_type = "friendly_explosion_medium",
		scalable_radius = true,
		static_power_level = 1000,
		radius = ARTILLERY_STRIKE_RADIUS,
		min_radius = ARTILLERY_STRIKE_RADIUS * 0.75,
		close_radius = ARTILLERY_STRIKE_RADIUS * 0.75,
		min_close_radius = ARTILLERY_STRIKE_RADIUS * 0.5,
		close_damage_profile = DamageProfileTemplates.expedition_artillery_strike_close,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.expedition_artillery_strike,
		damage_type = damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		vfx = {
			"content/fx/particles/weapons/grenades/expeditions/artillery_strike_explosion",
		},
	},
	expeditions_big_grenade = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		player_disorientation_type = "friendly_explosion_medium",
		scalable_radius = true,
		static_power_level = 1000,
		radius = BIG_GRENADE_RADIUS,
		min_radius = BIG_GRENADE_RADIUS * 0.5,
		close_radius = BIG_GRENADE_RADIUS * 0.15,
		min_close_radius = BIG_GRENADE_RADIUS * 0.15,
		close_damage_profile = DamageProfileTemplates.expeditions_big_grenade_close,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.expeditions_big_grenade,
		damage_type = damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 25,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 25,
		},
		scalable_vfx = {
			{
				min_radius = 10,
				radius_variable_name = "radius",
				effects = {
					"content/fx/particles/explosions/frag_grenade_ogryn",
				},
			},
			{
				min_radius = 31,
				radius_variable_name = "radius",
				effects = {
					"content/fx/particles/player_buffs/buff_ogryn_biggest_boom_grenade",
				},
			},
		},
		sfx = {
			"wwise/events/weapon/play_explosion_expedition_big_grenade",
			"wwise/events/weapon/play_explosion_refl_huge",
		},
	},
	expedition_trap_explosive = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = false,
		player_disorientation_type = "friendly_explosion_medium",
		scalable_radius = true,
		static_power_level = 1000,
		radius = PROXIMITY_TRAP_RADIUS,
		min_radius = PROXIMITY_TRAP_RADIUS / 2,
		close_radius = PROXIMITY_TRAP_RADIUS / 2,
		min_close_radius = PROXIMITY_TRAP_RADIUS / 3,
		close_damage_profile = DamageProfileTemplates.expedition_trap_explosive_close,
		close_damage_type = DamageSettings.damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.expedition_trap_explosive,
		damage_type = DamageSettings.damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		vfx = {
			"content/fx/particles/explosions/expeditions_explosion_trap",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_explosive_mine",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	expedition_trap_explosive_cluster = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		player_disorientation_type = "friendly_explosion_light",
		scalable_radius = true,
		static_power_level = 500,
		radius = PROXIMITY_TRAP_RADIUS / 2,
		min_radius = PROXIMITY_TRAP_RADIUS / 4,
		close_radius = PROXIMITY_TRAP_RADIUS / 4,
		min_close_radius = PROXIMITY_TRAP_RADIUS / 6,
		close_damage_profile = DamageProfileTemplates.close_frag_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.frag_grenade,
		damage_type = damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 15,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 20,
		},
		radius_stat_buffs = {
			"explosion_radius_modifier_frag",
		},
		vfx = {
			"content/fx/particles/explosions/frag_grenade_01",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	expedition_trap_fire = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = false,
		player_disorientation_type = "friendly_explosion_light",
		scalable_radius = true,
		static_power_level = 100,
		radius = PROXIMITY_TRAP_RADIUS,
		min_radius = PROXIMITY_TRAP_RADIUS / 2,
		damage_profile = DamageProfileTemplates.expedition_trap_fire,
		damage_type = DamageSettings.damage_types.grenade_fire,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		vfx = {
			"content/fx/particles/explosions/expeditions_fire_trap",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_flame_mine",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	expedition_trap_shock = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = false,
		player_disorientation_type = "friendly_explosion_light",
		scalable_radius = true,
		static_power_level = 500,
		radius = PROXIMITY_TRAP_RADIUS,
		min_radius = PROXIMITY_TRAP_RADIUS / 2,
		damage_profile = DamageProfileTemplates.expedition_trap_shock,
		damage_type = DamageSettings.damage_types.electrocution,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		vfx = {
			"content/fx/particles/weapons/grenades/expeditions_shocking_trap",
		},
		sfx = {
			"wwise/events/player/play_explosion_shock_mine",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	expeditions_explosive_barrel = {
		close_damage_type = nil,
		close_radius = 3,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = false,
		damage_type = nil,
		min_close_radius = 0.5,
		min_radius = 3,
		player_disorientation_type = "friendly_explosion_medium",
		radius = 6,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.promethium_barrel_explosion_close,
		damage_profile = DamageProfileTemplates.promethium_barrel_explosion,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		vfx = {
			"content/fx/particles/destructibles/explosive_barrel_explosion",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_barrel_explosion",
			"wwise/events/weapon/play_explosion_barrel_flame",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	attack_valkyrie_missile = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		scalable_radius = true,
		static_power_level = 500,
		radius = ATTACK_VALKYRIE_MISSILE_RADIUS,
		min_radius = ATTACK_VALKYRIE_MISSILE_RADIUS * 0.75,
		close_radius = ATTACK_VALKYRIE_MISSILE_RADIUS * 0.75,
		min_close_radius = ATTACK_VALKYRIE_MISSILE_RADIUS * 0.5,
		close_damage_profile = DamageProfileTemplates.attack_valkyrie_missile_explosion_close,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.attack_valkyrie_missile_explosion,
		damage_type = damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 25,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 25,
		},
		scalable_vfx = {
			{
				min_radius = 2.5,
				radius_variable_name = "radius",
				effects = {
					"content/fx/particles/weapons/grenades/broker_boom_bringer_impact_explosion",
				},
			},
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
}

return explosion_templates
