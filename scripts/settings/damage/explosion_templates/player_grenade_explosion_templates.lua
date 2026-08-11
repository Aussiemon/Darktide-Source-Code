-- chunkname: @scripts/settings/damage/explosion_templates/player_grenade_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local arc_grenade_talent_settings = TalentSettings.cryptic.arc_grenade
local damage_types = DamageSettings.damage_types
local TARGETED_TEMPLATE_EFFECT_FINAL_TARGETS = Script.new_array(4)
local TARGETED_TEMPLATE_EFFECT_SECONDARY = Script.new_array(4)
local TARGETED_TEMPLATE_EFFECT_BACKUP = Script.new_array(4)
local _arc_grenade_targeted_template_effect_data = {
	no_player_unit = false,
	num_backup_targets = 0,
	num_final_targets = 0,
	num_secondary_targets = 0,
	stop_sorting = false,
	max_targets = arc_grenade_talent_settings.base_num_arcs,
}
local _arc_grenade_targeted_template_effect_results = {
	final_targets = TARGETED_TEMPLATE_EFFECT_FINAL_TARGETS,
	secondary_targets = TARGETED_TEMPLATE_EFFECT_SECONDARY,
	backup_targets = TARGETED_TEMPLATE_EFFECT_BACKUP,
}
local explosion_templates = {
	frag_grenade = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 10,
		radius = 10,
		scalable_radius = true,
		static_power_level = 500,
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
		scalable_vfx = {
			{
				min_radius = 5,
				radius_variable_name = "radius",
				effects = {
					"content/fx/particles/explosions/frag_grenade_01",
				},
			},
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	shock_grenade = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 4,
		on_hit_buff_template_name = "shock_grenade_interval",
		radius = 8,
		scalable_radius = true,
		static_power_level = 100,
		close_damage_profile = DamageProfileTemplates.shock_grenade,
		close_damage_type = damage_types.electrocution,
		damage_profile = DamageProfileTemplates.shock_grenade,
		damage_type = damage_types.electrocution,
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
			"explosion_radius_modifier_shock",
		},
		vfx = {
			"content/fx/particles/weapons/grenades/stumm_grenade/stumm_grenade",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_shock",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	fire_grenade = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_radius = 0.25,
		radius = 1,
		static_power_level = 600,
		damage_profile = DamageProfileTemplates.default_grenade,
		damage_type = damage_types.laser,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 10,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 12,
		},
		vfx = {
			"content/fx/particles/weapons/grenades/fire_grenade/fire_grenade_player_initial_blast",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_flame",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	broker_flash_grenade = {
		close_radius = 2.25,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2.25,
		min_radius = 3.5,
		radius = 3.5,
		scalable_radius = true,
		static_power_level = 200,
		close_damage_profile = DamageProfileTemplates.broker_flash_grenade_close,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.broker_flash_grenade,
		damage_type = damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 12,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 30,
		},
		vfx = {
			"content/fx/particles/weapons/grenades/broker_flash_grenade/broker_flash_grenade",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_flash_player",
		},
	},
	broker_tox_grenade = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_radius = 0.25,
		radius = 4,
		static_power_level = 600,
		damage_profile = DamageProfileTemplates.broker_tox_grenade,
		damage_type = damage_types.laser,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 10,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 4,
		},
		vfx = {
			"content/fx/particles/weapons/grenades/chem_grenade/chem_grenade_player_initial_blast",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_chem_grenade_player",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	broker_missile_launcher = {
		close_radius = 4,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 4,
		radius = 7,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.broker_missile_launcher_explosion_close,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.broker_missile_launcher_explosion,
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
	krak_grenade = {
		boss_power_level_modifier = 0.8,
		close_radius = 1.5,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 1.5,
		min_radius = 1.5,
		radius = 5,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.close_krak_grenade,
		close_damage_type = damage_types.plasma,
		damage_profile = DamageProfileTemplates.krak_grenade,
		damage_type = damage_types.plasma,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 6,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 8,
		},
		vfx = {
			"content/fx/particles/weapons/grenades/krak_grenade/krak_grenade_explosion",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_krak",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	smoke_grenade = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 5,
		override_friendly_fire = false,
		radius = 10,
		scalable_radius = true,
		static_power_level = 100,
		close_damage_profile = DamageProfileTemplates.smoke_grenade,
		close_damage_type = damage_types.physical,
		damage_profile = DamageProfileTemplates.smoke_grenade,
		damage_type = damage_types.physical,
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
		vfx = {
			"content/fx/particles/weapons/grenades/smoke_grenade/smoke_grenade_initial_blast",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_smoke",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	ogryn_grenade_frag = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 16,
		radius = 16,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.close_ogryn_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.ogryn_grenade,
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
			"wwise/events/weapon/play_explosion_grenade_frag_ogryn",
			"wwise/events/weapon/play_explosion_refl_huge",
		},
	},
	ogryn_box_cluster_frag = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 5,
		radius = 8,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.ogryn_box_cluster_close_frag_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.ogryn_box_cluster_frag_grenade,
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
		scalable_vfx = {
			{
				min_radius = 5,
				radius_variable_name = "radius",
				effects = {
					"content/fx/particles/explosions/box_grenade_ogryn",
				},
			},
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	adamant_grenade = {
		close_radius = 2.5,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2.5,
		min_radius = 10,
		radius = 10,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.close_adamant_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.adamant_grenade,
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
		scalable_vfx = {
			{
				min_radius = 5,
				radius_variable_name = "radius",
				effects = {
					"content/fx/particles/explosions/frag_grenade_01",
				},
			},
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	adamant_whistle_explosion = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 4,
		radius = 4,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.close_whistle_explosion,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.whistle_explosion,
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
		scalable_vfx = {
			{
				min_radius = 5,
				radius_variable_name = "radius",
				effects = {
					"content/fx/particles/explosions/frag_grenade_01",
				},
			},
		},
		sfx = {
			"wwise/events/player/play_player_ability_adamant_dog_explosion",
		},
	},
	shock_mine_self_destruct = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_radius = 0.5,
		radius = 2,
		scalable_radius = true,
		static_power_level = 500,
		damage_profile = DamageProfileTemplates.shock_mine_self_destruct,
		damage_type = damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 5,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 5,
		},
		vfx = {
			"content/fx/particles/weapons/grenades/shock_mine/shock_mine_self_destruct_01",
		},
	},
	arc_grenade = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		on_hit_buff_template_name = "arc_grenade_spread_target",
		scalable_radius = true,
		static_power_level = 500,
		radius = arc_grenade_talent_settings.radius,
		min_radius = arc_grenade_talent_settings.radius,
		damage_profile = DamageProfileTemplates.arc_grenade,
		damage_type = damage_types.electrocution,
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
		targeted_template_effect = {
			template_effect_name = "arc_grenade_chain_lightning_source",
			explosion_start_function = function (owner_unit)
				_arc_grenade_targeted_template_effect_data.no_player_unit = false
				_arc_grenade_targeted_template_effect_data.stop_sorting = false
				_arc_grenade_targeted_template_effect_data.num_final_targets = 0
				_arc_grenade_targeted_template_effect_data.num_secondary_targets = 0
				_arc_grenade_targeted_template_effect_data.num_backup_targets = 0

				local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")
				local stat_buffs = buff_extension and buff_extension:stat_buffs()
				local num_extra_arcs = stat_buffs and stat_buffs.arc_grenade_extra_arcs or 0

				_arc_grenade_targeted_template_effect_data.max_targets = arc_grenade_talent_settings.base_num_arcs + num_extra_arcs

				table.clear(TARGETED_TEMPLATE_EFFECT_FINAL_TARGETS)
				table.clear(TARGETED_TEMPLATE_EFFECT_SECONDARY)
				table.clear(TARGETED_TEMPLATE_EFFECT_BACKUP)

				local is_player_unit = Managers.state.player_unit_spawn:is_player_unit(owner_unit)

				if not is_player_unit then
					_arc_grenade_targeted_template_effect_data.stop_sorting = true
					_arc_grenade_targeted_template_effect_data.no_player_unit = true
				end
			end,
			on_target_hit_function = function (hit_unit, breed)
				local targeting_data = _arc_grenade_targeted_template_effect_data
				local target_results = _arc_grenade_targeted_template_effect_results

				if targeting_data.no_player_unit then
					return
				end

				local breed_name = breed.name
				local breed_tags = breed.breed_tags

				if breed_name == "chaos_ogryn_executor" or breed_name == "chaos_armored_hound" or breed_name == "renegade_berzerker" or breed_name == "renegade_executor" then
					table.insert(target_results.final_targets, hit_unit)

					targeting_data.num_final_targets = targeting_data.num_final_targets + 1
				elseif targeting_data.num_secondary_targets < targeting_data.max_targets and breed_tags and breed_tags.elite then
					table.insert(target_results.secondary_targets, hit_unit)

					targeting_data.num_secondary_targets = targeting_data.num_secondary_targets + 1
				elseif targeting_data.num_backup_targets < targeting_data.max_targets then
					table.insert(target_results.backup_targets, hit_unit)

					targeting_data.num_backup_targets = targeting_data.num_backup_targets + 1
				end

				if targeting_data.num_final_targets >= targeting_data.max_targets then
					targeting_data.stop_sorting = true
				end
			end,
			can_stop_sorting = function ()
				return _arc_grenade_targeted_template_effect_data.stop_sorting
			end,
			get_template_effect_targets = function ()
				local targeting_data = _arc_grenade_targeted_template_effect_data
				local target_results = _arc_grenade_targeted_template_effect_results
				local max_targets = targeting_data.max_targets
				local final_targets = target_results.final_targets

				for i = #final_targets, 1, -1 do
					local target_unit = final_targets[i]

					if not HEALTH_ALIVE[target_unit] or not ALIVE[target_unit] then
						table.remove(final_targets, i)

						targeting_data.num_final_targets = targeting_data.num_final_targets - 1
					end
				end

				for _, target_unit in ipairs(target_results.secondary_targets) do
					if HEALTH_ALIVE[target_unit] and ALIVE[target_unit] then
						table.insert(final_targets, target_unit)

						targeting_data.num_final_targets = targeting_data.num_final_targets + 1

						if max_targets <= targeting_data.num_final_targets then
							return final_targets
						end
					end
				end

				for _, target_unit in ipairs(target_results.backup_targets) do
					if HEALTH_ALIVE[target_unit] and ALIVE[target_unit] then
						table.insert(final_targets, target_unit)

						targeting_data.num_final_targets = targeting_data.num_final_targets + 1

						if max_targets <= targeting_data.num_final_targets then
							return final_targets
						end
					end
				end

				return final_targets
			end,
		},
		vfx = {
			"content/fx/particles/weapons/grenades/arc_grenade/arc_grenade_01",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_arc_grenade",
		},
	},
}

return explosion_templates
