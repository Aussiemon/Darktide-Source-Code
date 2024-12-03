-- chunkname: @scripts/settings/buff/mutator_buff_templates.lua

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local buff_proc_events = BuffSettings.proc_events
local buff_targets = BuffSettings.targets
local buff_stat_buffs = BuffSettings.stat_buffs
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local templates = {}

table.make_unique(templates)

nurgle_parasite_settings = {
	specific_head_gib_settings = {
		random_radius = 2,
		hit_zones = {
			"head",
		},
		damage_profile = DamageProfileTemplates.havoc_self_gib,
	},
	head_parasite_item_overrides = {
		human = {
			{
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02",
				},
			},
			{
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_02",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_03",
				},
			},
		},
		ogryn = {
			{
				items = {
					[1] = "content/items/characters/minions/chaos_ogryn/attachments_base/head_a",
					[2] = "content/items/characters/minions/chaos_ogryn/attachments_base/head_b",
				},
			},
			{
				items = {
					[1] = "content/items/characters/minions/chaos_ogryn/attachments_base/tentacle_head_01",
					[2] = "content/items/characters/minions/chaos_ogryn/attachments_base/tentacle_head_02",
				},
			},
		},
		poxwalker = {
			{
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_02",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_03",
				},
			},
		},
	},
	override_slots = {
		human = {
			[1] = "slot_head",
			[2] = "slot_face",
		},
		ogryn = {
			[1] = "slot_head_attachment",
			[2] = "slot_head",
		},
		poxwalker = {
			[1] = "slot_head",
		},
	},
}

local function _parasite_head_stop_function(template_data, template_context)
	local unit = template_context.unit
	local position = POSITION_LOOKUP[unit]
	local world, physics_world, impact_normal, charge_level, attack_type = template_context.world, template_context.physics_world, Vector3.up(), 1
	local explosion_template = ExplosionTemplates.nurgle_head_parasite

	Explosion.create_explosion(world, physics_world, position, impact_normal, unit, explosion_template, DEFAULT_POWER_LEVEL, charge_level, attack_type)

	local visual_loadout_extension = template_data.visual_loadout_extension

	Attack.execute(unit, DamageProfileTemplates.default, "power_level", 2000, "attack_direction", Vector3.up(), "instakill", true)

	local unit_tags = template_context.breed.tags

	if not unit_tags.monster then
		local gib_settings = nurgle_parasite_settings.specific_head_gib_settings
		local damage_profile = gib_settings.damage_profile
		local random_radius = gib_settings.random_radius
		local hit_zones = gib_settings.hit_zones

		for i = 1, #hit_zones do
			local x = math.random() * 2 - 1
			local y = math.random() * 2 - 1
			local random_offset = Vector3(x * random_radius, y * random_radius, 1)
			local direction = Vector3.normalize(random_offset)
			local gib_hit_zone = hit_zones[i]

			if visual_loadout_extension:can_gib(gib_hit_zone) then
				visual_loadout_extension:gib(gib_hit_zone, direction, damage_profile)
			end
		end
	end
end

templates.headshot_parasite_enemies = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_minion_damage_taken] = 1,
	},
	keywords = {
		buff_keywords.infested_head_armor_override,
		buff_keywords.has_nurgle_parasite,
	},
	start_func = function (template_data, template_context)
		local buff_settings = nurgle_parasite_settings
		local breed_tags = template_context.breed.tags
		local time_variation = 2
		local unit = template_context.unit
		local override_slot = buff_settings.override_slots.human
		local item_overrides = buff_settings.head_parasite_item_overrides.human

		template_data.parasite_interval_time = time_variation
		template_data.health_extension = ScriptUnit.extension(template_context.unit, "health_system")

		if breed_tags.ogryn then
			item_overrides = buff_settings.head_parasite_item_overrides.ogryn
			override_slot = buff_settings.override_slots.ogryn
		elseif breed_tags.poxwalker then
			override_slot = buff_settings.override_slots.poxwalker
			item_overrides = buff_settings.head_parasite_item_overrides.poxwalker
		end

		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		for i = 1, #override_slot do
			if template_context.is_server then
				local override = override_slot[1]
				local can_unequip = template_data.visual_loadout_extension:can_unequip_slot(override)

				if can_unequip then
					template_data.visual_loadout_extension:unequip_slot(override)
				end
			end
		end

		for i = 1, #item_overrides do
			if not template_context.is_server then
				local item_slot_data = item_overrides[i]
				local swapped_slot = override_slot[i]
				local inventory_slots = template_data.visual_loadout_extension:inventory_slots()

				if inventory_slots[swapped_slot] then
					inventory_slots[swapped_slot].use_outline = false
				end

				template_data.visual_loadout_extension:create_slot_entry(unit, item_slot_data)
			end
		end

		if not template_context.is_server then
			return
		end

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local hit_mass = breed.hit_mass

		if type(hit_mass) == "table" then
			hit_mass = Managers.state.difficulty:get_table_entry_by_challenge(hit_mass)
		end

		template_data.old_hit_mass = hit_mass

		local new_hit_mass = hit_mass * 1.5
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(new_hit_mass)

		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1.25)
		end

		local suppression_extension = ScriptUnit.has_extension(unit, "suppression_system")

		if suppression_extension then
			suppression_extension:add_suppression_immunity_duration(999)
		end

		local attack_intensity_extension = ScriptUnit.has_extension(unit, "attack_intensity_system")

		if attack_intensity_extension then
			attack_intensity_extension:set_allow_all_attacks_duration(999)
		end
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local attack_type = params.attack_type

		if attack_type ~= "ranged" then
			return
		end

		local hit_zone = params.hit_zone_name_or_nil

		if hit_zone == "head" then
			local unit = template_context.unit
			local health_extension = ScriptUnit.extension(unit, "health_system")
			local current_health_percent = health_extension:current_health_percent()

			if current_health_percent <= 0.3 then
				_parasite_head_stop_function(template_data, template_context)
			end
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_head",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_taunted_1p",
					stop_type = "stop",
					material_variables = {
						{
							material_name = "outline",
							variable_name = "Color1",
							value = {
								0,
								10.75,
								0.005,
							},
						},
					},
				},
			},
		},
	},
}
templates.mutator_minion_nurgle_blessing_tougher = {
	class_name = "buff",
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.empowered,
	},
	stat_buffs = {
		[buff_stat_buffs.unarmored_damage] = -0.35,
		[buff_stat_buffs.resistant_damage] = -0.35,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.35,
		[buff_stat_buffs.berserker_damage] = -0.35,
		[buff_stat_buffs.armored_damage] = -0.35,
		[buff_stat_buffs.super_armor_damage] = -0.35,
		[buff_stat_buffs.consumed_hit_mass_modifier] = 10,
		[buff_stat_buffs.impact_modifier] = -1,
		[buff_stat_buffs.ranged_attack_speed] = 0.2,
		[buff_stat_buffs.minion_num_shots_modifier] = 2,
		[buff_stat_buffs.movement_speed] = 0.25,
	},
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_nurgle_blessing",
					stop_type = "stop",
				},
			},
		},
		material_vector = {
			name = "stimmed_color",
			value = {
				0.358,
				0.786,
				0.22,
			},
		},
	},
}

local CORRUPTION_DAMAGE_TYPE = "corruption"
local CORRUPTION_PERMANENT_POWER_LEVEL = {
	2,
	2,
	2,
	2,
	2,
}

templates.mutator_corruption_over_time = {
	class_name = "interval_buff",
	interval = 7,
	target = buff_targets.player_only,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if template_context.is_server and HEALTH_ALIVE[unit] then
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(CORRUPTION_PERMANENT_POWER_LEVEL)
			local damage_profile = DamageProfileTemplates.mutator_corruption

			Attack.execute(unit, damage_profile, "power_level", power_level, "damage_type", CORRUPTION_DAMAGE_TYPE, "attack_type", attack_types.buff)
		end
	end,
}

local CORRUPTION_PERMANENT_POWER_LEVEL_2 = {
	5,
	8,
	10,
	12,
	15,
}

templates.mutator_corruption_over_time_2 = {
	class_name = "interval_buff",
	interval = 7,
	target = buff_targets.player_only,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if template_context.is_server and HEALTH_ALIVE[unit] then
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(CORRUPTION_PERMANENT_POWER_LEVEL_2)
			local damage_profile = DamageProfileTemplates.mutator_corruption

			Attack.execute(unit, damage_profile, "power_level", power_level, "damage_type", CORRUPTION_DAMAGE_TYPE, "attack_type", attack_types.buff)
		end
	end,
}
templates.mutator_player_cooldown_reduction = {
	class_name = "buff",
	target = buff_targets.player_only,
	stat_buffs = {
		[buff_stat_buffs.ability_cooldown_modifier] = -0.2,
	},
}
templates.mutator_movement_speed_on_spawn = {
	class_name = "buff",
	duration = 30,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_sprint_buff_hud",
	target = buff_targets.player_only,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 1,
	},
	hud_priority = math.huge,
}
templates.mutator_player_enhanced_grenade_abilities = {
	class_name = "buff",
	target = buff_targets.player_only,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local template = template_context.template
		local stat_buffs = template.stat_buffs.extra_max_amount_of_grenades
		local extra_grenades = stat_buffs
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")

		template_context.initial_num_charges = grenade_ability_component.num_charges
		grenade_ability_component.num_charges = grenade_ability_component.num_charges + extra_grenades
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")
		local initial_num_charges = template_context.initial_num_charges

		grenade_ability_component.num_charges = math.min(grenade_ability_component.num_charges, initial_num_charges)
	end,
	stat_buffs = {
		[buff_stat_buffs.extra_max_amount_of_grenades] = 2,
		[buff_stat_buffs.warp_charge_amount_smite] = 0.5,
	},
}

local YELLOW_STIM_COLOR = {
	0.358,
	0.786,
	0.22,
}
local RED_STIM_COLOR = {
	0.9,
	0,
	0.005,
}

templates.empowered_poxwalker = {
	class_name = "buff",
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.empowered,
		buff_keywords.in_toxic_gas,
	},
	stat_buffs = {
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.unarmored_damage] = -0.2,
		[buff_stat_buffs.resistant_damage] = -0.2,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.berserker_damage] = -0.2,
		[buff_stat_buffs.armored_damage] = -0.2,
		[buff_stat_buffs.super_armor_damage] = -0.2,
		[buff_stat_buffs.movement_speed] = 0.30000000000000004,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local hit_mass = breed.hit_mass

		if type(hit_mass) == "table" then
			hit_mass = Managers.state.difficulty:get_table_entry_by_challenge(hit_mass)
		end

		template_data.old_hit_mass = hit_mass

		local new_hit_mass = hit_mass * 2.5
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(new_hit_mass)

		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1.25)
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(template_data.old_hit_mass)

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_lefteyesocket",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.empowered_poxwalker_with_duration = {
	class_name = "buff",
	duration = 6,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.empowered,
		buff_keywords.in_toxic_gas,
	},
	stat_buffs = {
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.unarmored_damage] = -0.2,
		[buff_stat_buffs.resistant_damage] = -0.2,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.berserker_damage] = -0.2,
		[buff_stat_buffs.armored_damage] = -0.2,
		[buff_stat_buffs.super_armor_damage] = -0.2,
		[buff_stat_buffs.movement_speed] = 0.30000000000000004,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local hit_mass = breed.hit_mass

		if type(hit_mass) == "table" then
			hit_mass = Managers.state.difficulty:get_table_entry_by_challenge(hit_mass)
		end

		template_data.old_hit_mass = hit_mass

		local new_hit_mass = hit_mass * 2.5
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(new_hit_mass)

		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1.25)
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(template_data.old_hit_mass)

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/glowing_eyes_no_flash",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_lefteyesocket",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/glowing_eyes_no_flash",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/glowing_eyes_no_flash",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.empowered_by_pox_gas = {
	class_name = "buff",
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.empowered,
		buff_keywords.in_toxic_gas,
	},
	stat_buffs = {
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.unarmored_damage] = -0.2,
		[buff_stat_buffs.resistant_damage] = -0.2,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.berserker_damage] = -0.2,
		[buff_stat_buffs.armored_damage] = -0.2,
		[buff_stat_buffs.super_armor_damage] = -0.2,
		[buff_stat_buffs.movement_speed] = 0.30000000000000004,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local hit_mass = breed.hit_mass

		if type(hit_mass) == "table" then
			hit_mass = Managers.state.difficulty:get_table_entry_by_challenge(hit_mass)
		end

		template_data.old_hit_mass = hit_mass

		local new_hit_mass = hit_mass * 2.5
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(new_hit_mass)

		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1.25)
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(template_data.old_hit_mass)

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1)
		end

		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff("empowered_poxwalker_with_duration", t)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_lefteyesocket",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.empowered_twin = {
	class_name = "buff",
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.empowered,
	},
	stat_buffs = {
		[buff_stat_buffs.weakspot_damage_taken] = 1,
		[buff_stat_buffs.unarmored_damage] = -0.3,
		[buff_stat_buffs.resistant_damage] = -0.5,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.5,
		[buff_stat_buffs.berserker_damage] = -0.5,
		[buff_stat_buffs.armored_damage] = -0.5,
		[buff_stat_buffs.super_armor_damage] = -0.5,
		[buff_stat_buffs.impact_modifier] = -3,
		[buff_stat_buffs.ranged_attack_speed] = 0.5,
		[buff_stat_buffs.melee_attack_speed] = 0.5,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local hit_mass = breed.hit_mass

		if type(hit_mass) == "table" then
			hit_mass = Managers.state.difficulty:get_table_entry_by_challenge(hit_mass)
		end

		template_data.old_hit_mass = hit_mass

		local new_hit_mass = hit_mass * 3
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(new_hit_mass)
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(template_data.old_hit_mass)
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_head",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/enrage_head_outline",
					stop_type = "destroy",
				},
			},
		},
	},
}
templates.mutant_mutator = {
	class_name = "buff",
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 0.10000000000000009,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1.25)
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}

return templates
