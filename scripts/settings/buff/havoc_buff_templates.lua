-- chunkname: @scripts/settings/buff/havoc_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HavocMutatorLocalSettings = require("scripts/settings/havoc/havoc_mutator_local_settings")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local mutator_havoc_enemies_corrupted_config_settings = HavocMutatorLocalSettings.mutator_havoc_enemies_corrupted.buff_settings
local rotten_armor_config_settings = HavocMutatorLocalSettings.mutator_havoc_rotten_armor.buff_settings
local bolstering_minions_01_config_settings = HavocMutatorLocalSettings.bolstering_minions_01.buff_settings
local mutator_encroaching_garden_config_settings = HavocMutatorLocalSettings.mutator_encroaching_garden.buff_settings
local mutator_havoc_enraged_config_settings = HavocMutatorLocalSettings.mutator_havoc_enraged.buff_settings
local mutator_stimmed_minions_config_settings = HavocMutatorLocalSettings.mutator_stimmed_minions.buff_settings
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local stat_buff_types = BuffSettings.stat_buff_types
local buff_targets = BuffSettings.targets
local minion_effects_priorities = BuffSettings.minion_effects_priorities
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local proc_events = BuffSettings.proc_events

local function _position(unit)
	local position = POSITION_LOOKUP[unit]

	return position
end

local templates = {}

table.make_unique(templates)

local BOLSTERING_COLOR = {
	0.98,
	0.27,
	0,
}
local BOLSTER_1_COLOR = {
	BOLSTERING_COLOR[1] * 0.25,
	BOLSTERING_COLOR[2] * 0.25,
	BOLSTERING_COLOR[3] * 0.25,
}
local BOLSTER_2_COLOR = {
	BOLSTERING_COLOR[1] * 0.35,
	BOLSTERING_COLOR[2] * 0.35,
	BOLSTERING_COLOR[3] * 0.35,
}
local BOLSTER_3_COLOR = {
	BOLSTERING_COLOR[1] * 0.65,
	BOLSTERING_COLOR[2] * 0.65,
	BOLSTERING_COLOR[3] * 0.65,
}
local BOLSTER_4_COLOR = {
	BOLSTERING_COLOR[1] * 0.85,
	BOLSTERING_COLOR[2] * 0.85,
	BOLSTERING_COLOR[3] * 0.85,
}
local BOLSTERING_MINION_EFFECTS = {
	node_effects = {
		{
			node_name = "j_lefteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = BOLSTERING_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = BOLSTERING_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = BOLSTER_1_COLOR,
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
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = BOLSTERING_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = BOLSTERING_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = BOLSTERING_COLOR,
					},
				},
			},
		},
	},
	material_vector = {
		name = "stimmed_color",
		value = BOLSTERING_COLOR,
		priority = minion_effects_priorities.mutators,
	},
}
local LOW_BOLSTERING_MINION_EFFECTS = {
	material_vector = {
		name = "stimmed_color",
		value = BOLSTERING_COLOR,
		priority = minion_effects_priorities.mutators,
	},
}
local BOLSTERING_1_MINION_EFFECTS = table.clone(LOW_BOLSTERING_MINION_EFFECTS)

BOLSTERING_1_MINION_EFFECTS.material_vector.value = BOLSTER_1_COLOR

local BOLSTERING_2_MINION_EFFECTS = table.clone(LOW_BOLSTERING_MINION_EFFECTS)

BOLSTERING_2_MINION_EFFECTS.material_vector.value = BOLSTER_2_COLOR

local BOLSTERING_3_MINION_EFFECTS = table.clone(LOW_BOLSTERING_MINION_EFFECTS)

BOLSTERING_3_MINION_EFFECTS.material_vector.value = BOLSTER_3_COLOR

local BOLSTERING_4_MINION_EFFECTS = table.clone(LOW_BOLSTERING_MINION_EFFECTS)

BOLSTERING_4_MINION_EFFECTS.material_vector.value = BOLSTER_4_COLOR

local BOLSTERING_RADIUS = 4
local DPLUS_RESULTS_1 = {}

local function _bolstering_stop_function(template_context, template_data)
	if not template_context.is_server then
		return
	end

	local unit = template_context.unit
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name("villains")
	local target_side_names = side:relation_side_names("allied")

	table.clear(DPLUS_RESULTS_1)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local buff_template_name = "havoc_bolstering"
	local broadphase = broadphase_system.broadphase
	local position = POSITION_LOOKUP[unit]
	local num_results = broadphase.query(broadphase, position, BOLSTERING_RADIUS, DPLUS_RESULTS_1, target_side_names)
	local current_time = FixedFrame.get_latest_fixed_time()
	local bolstered = false
	local t = Managers.time:time("gameplay")

	for i = 1, num_results do
		local nearby_ally = DPLUS_RESULTS_1[i]

		if nearby_ally == unit then
			return
		end

		if HEALTH_ALIVE[nearby_ally] then
			local buff_extension = ScriptUnit.extension(nearby_ally, "buff_system")

			buff_extension:add_internally_controlled_buff(buff_template_name, t)
			buff_extension:_update_stat_buffs_and_keywords(current_time)

			bolstered = true
		end
	end

	if bolstered then
		local vfx_name = "content/fx/particles/enemies/bolstering_shockwave"
		local node_position = position + Vector3(0, 0, 0.25)
		local fx_system = Managers.state.extension:system("fx_system")
		local rotation = Unit.local_rotation(unit, 1)

		fx_system:trigger_vfx(vfx_name, node_position, rotation)
	end
end

local BOLSTERING_MULTIPLIER = bolstering_minions_01_config_settings.bolstering_multiplier
local BOLSTERING_STAT_BUFFS = bolstering_minions_01_config_settings.bolstering_stat_buffs

local function _get_breed_bolstering_multiplier(template_data, template_context)
	local multiplier
	local breed = template_context.breed
	local tags = breed.tags
	local captain_tag = tags.captain or tags.cultist_captain

	if captain_tag then
		multiplier = BOLSTERING_MULTIPLIER.captain

		return multiplier
	end

	local elite = tags.elite

	if elite then
		multiplier = BOLSTERING_MULTIPLIER.elite

		return multiplier
	end

	local special = tags.special

	if special then
		multiplier = BOLSTERING_MULTIPLIER.special

		return multiplier
	end

	local monster = tags.monster

	if monster then
		multiplier = BOLSTERING_MULTIPLIER.monster

		return multiplier
	end

	multiplier = BOLSTERING_MULTIPLIER.default

	return multiplier
end

local function _bolstering_start_function(template_context, template_data)
	local stack = template_data.stack
	local unit = template_context.unit
	local scale = 1 + stack * 0.02

	Unit.set_local_scale(unit, 1, Vector3(1, 1, 1) * scale)

	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local value = template_data.multiplier * stack

	for i = 1, #BOLSTERING_STAT_BUFFS do
		local stat_buff = BOLSTERING_STAT_BUFFS[i]
		local stat_buff_type = stat_buff_types[stat_buff]
		local base_value = 1

		if stat_buff_type == "multiplicative_multiplier" then
			stat_buffs[stat_buff] = base_value * value
		elseif stat_buff_type == "max_value" then
			stat_buffs[stat_buff] = math.max(base_value, value)
		else
			stat_buffs[stat_buff] = base_value + value
		end
	end
end

templates.havoc_bolstering = {
	class_name = "buff",
	max_stacks = 5,
	predicted = false,
	keywords = {
		"bolstered",
	},
	start_func = function (template_data, template_context)
		template_data.stack = 1
		template_data.multiplier = _get_breed_bolstering_multiplier(template_data, template_context)

		_bolstering_start_function(template_context, template_data)
	end,
	on_stack_added_func = function (template_data, template_context, new_stack_count)
		if new_stack_count < 5 then
			template_data.stack = new_stack_count

			_bolstering_start_function(template_context, template_data)
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		_bolstering_stop_function(template_context, template_data)
	end,
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators,
		stack_material_vectors = {
			BOLSTERING_1_MINION_EFFECTS.material_vector,
			BOLSTERING_2_MINION_EFFECTS.material_vector,
			BOLSTERING_3_MINION_EFFECTS.material_vector,
			BOLSTERING_4_MINION_EFFECTS.material_vector,
			BOLSTERING_MINION_EFFECTS.material_vector,
		},
		stack_node_effects = {
			[5] = BOLSTERING_MINION_EFFECTS.node_effects,
		},
		material_vector = BOLSTERING_1_MINION_EFFECTS.material_vector,
	},
}

local CORRUPTED_COLOR = mutator_havoc_enemies_corrupted_config_settings.corruption_color
local CORRUPTION_RADIUS = mutator_havoc_enemies_corrupted_config_settings.corruption_radius
local CORRUPTED_RANK_MULTIPLIE = mutator_havoc_enemies_corrupted_config_settings.rank_multipler
local DPLUS_RESULTS_2 = {}

local function _corruption_stop_function(template_context, template_data)
	local unit = template_context.unit
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name("villains")
	local target_side_names = side:relation_side_names("allied")
	local nav_world = template_data.nav_world

	table.clear(DPLUS_RESULTS_2)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local buff_template_name = mutator_havoc_enemies_corrupted_config_settings.buff_template_name
	local broadphase = broadphase_system.broadphase
	local position = _position(unit)
	local num_results = broadphase.query(broadphase, position, CORRUPTION_RADIUS, DPLUS_RESULTS_2, target_side_names)
	local current_time = FixedFrame.get_latest_fixed_time()
	local rank = Managers.state.game_mode:game_mode():extension("havoc"):get_current_rank()
	local threshold = rank * CORRUPTED_RANK_MULTIPLIE
	local t = Managers.time:time("gameplay")

	for i = 1, num_results do
		local nearby_ally = DPLUS_RESULTS_2[i]

		if HEALTH_ALIVE[nearby_ally] then
			local chance = math.random(0, 1)

			if threshold <= chance then
				local buff_extension = ScriptUnit.extension(nearby_ally, "buff_system")

				if not buff_extension:has_keyword("corrupted") then
					buff_extension:add_internally_controlled_buff(buff_template_name, t)
					buff_extension:_update_stat_buffs_and_keywords(current_time)
				end
			end
		end
	end

	local vfx_name = mutator_havoc_enemies_corrupted_config_settings.vfx_name
	local node_offset = mutator_havoc_enemies_corrupted_config_settings.node_offset
	local node_position = position + Vector3(0, 0, node_offset)
	local fx_system = Managers.state.extension:system("fx_system")
	local rotation = Unit.local_rotation(unit, 1)

	fx_system:trigger_vfx(vfx_name, node_position, rotation)

	local liquid_area_template_name = mutator_havoc_enemies_corrupted_config_settings.liquid_area_template_name

	LiquidArea.try_create(position, Vector3.down(), nav_world, LiquidAreaTemplates[liquid_area_template_name], nil, nil, true)
end

templates.havoc_corrupted_enemies = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	keywords = {
		"corrupted",
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local color = Vector3(CORRUPTED_COLOR[1], CORRUPTED_COLOR[2], CORRUPTED_COLOR[3])

		Unit.set_vector3_for_materials(unit, "stimmed_color", color, true)

		if not template_context.is_server then
			return
		end

		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		template_data.nav_world = navigation_extension:nav_world()

		local blackboard = BLACKBOARDS[unit]
		local has_gib_override = Blackboard.has_component(blackboard, "gib_override")

		if has_gib_override then
			local gib_override = Blackboard.write_component(blackboard, "gib_override")

			gib_override.should_override = true
			gib_override.target_template = "havoc_self_gib"
			gib_override.override_hit_zone_name = "center_mass"
		end
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit

		Unit.set_vector3_for_materials(unit, "stimmed_color", Vector3(0, 0, 0), true)

		if not template_context.is_server then
			return
		end

		_corruption_stop_function(template_context, template_data)
	end,
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = true,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_nurgle_blessing",
					stop_type = "stop",
				},
			},
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_nurgle_blessing_flies",
					stop_type = "stop",
				},
			},
			{
				node_name = "j_spine1",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/flies_1m",
					stop_type = "stop",
				},
			},
		},
	},
}
templates.common_minion_on_fire = {
	class_name = "interval_buff",
	interval = 0.5,
	max_stacks = 1,
	predicted = false,
	keywords = {
		buff_keywords.burning,
	},
	interval_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local broadphase_results = {}
		local unit_position = POSITION_LOOKUP[template_context.unit]
		local radius = 1
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[template_context.unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local t = FixedFrame.get_latest_fixed_time()
		local broadphase = broadphase_system.broadphase
		local num_results = broadphase.query(broadphase, unit_position, radius, broadphase_results, enemy_side_names)

		for i = 1, num_results do
			local enemy_unit = broadphase_results[i]
			local buff_extension = ScriptUnit.extension(enemy_unit, "buff_system")

			if not buff_extension:has_keyword("stimmed") then
				buff_extension:add_internally_controlled_buff("hit_by_common_enemy_flame", t)
			end
		end
	end,
	minion_effects = minion_burning_buff_effects.fire,
}

local function _get_damage_reduction_value()
	local rank = Managers.state.game_mode:game_mode():extension("havoc"):get_current_rank()
	local reduction_rate = 0.1 + 0.01 * rank

	return reduction_rate
end

local TOUGHNED_SKIN_COLOR = {
	0.8274509803921568,
	0.9882352941176471,
	0.011764705882352941,
}

templates.havoc_toughened_skin = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local color = Vector3(TOUGHNED_SKIN_COLOR[1], TOUGHNED_SKIN_COLOR[2], TOUGHNED_SKIN_COLOR[3])

		Unit.set_vector3_for_materials(unit, "stimmed_color", color, true)

		if not template_context.is_server then
			return
		end

		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local stat_buffs = buff_extension:stat_buffs()
		local value = _get_damage_reduction_value()

		stat_buffs.ranged_damage_taken_multiplier = value
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit

		Unit.set_vector3_for_materials(unit, "stimmed_color", Vector3(0, 0, 0), true)

		if not template_context.is_server then
			return
		end
	end,
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = true,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_pus_slime",
					stop_type = "stop",
				},
			},
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_pus_slow",
					stop_type = "stop",
				},
			},
			{
				node_name = "j_spine1",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/flies_1m",
					stop_type = "stop",
				},
			},
		},
	},
}

local TEMP_BROADPHASE_RESULTS = {}
local RADIUS = 5

local function _apply_poxburster_bile(template_data, template_context)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local enemy_side_names = template_data.side:relation_side_names("enemy")
	local unit_position = POSITION_LOOKUP[template_context.unit]
	local t = FixedFrame.get_latest_fixed_time()
	local hit_or_not = false
	local players_hit_not_affected = {}
	local broadphase = broadphase_system.broadphase
	local num_results = broadphase.query(broadphase, unit_position, RADIUS, TEMP_BROADPHASE_RESULTS, enemy_side_names)

	for i = 1, num_results do
		local enemy_unit = TEMP_BROADPHASE_RESULTS[i]
		local buff_extension = ScriptUnit.extension(enemy_unit, "buff_system")

		if not buff_extension:has_keyword("puked_on") then
			buff_extension:add_internally_controlled_buff("hit_by_poxburster_bile", t)

			hit_or_not = true
			players_hit_not_affected[i] = enemy_unit
		end
	end

	table.clear(TEMP_BROADPHASE_RESULTS)

	return hit_or_not, players_hit_not_affected
end

templates.havoc_sticky_poxburster = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")

		template_data.side = side_system.side_by_unit[unit]
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local result, num_players_hit = _apply_poxburster_bile(template_data, template_context)
		local mutator_manager = Managers.state.mutator
		local nurgle_warp_mutator = mutator_manager:mutator("mutator_havoc_sticky_poxburster")

		if result then
			for i = 1, #num_players_hit do
				nurgle_warp_mutator:spawn_random_from_template(num_players_hit[i])
			end
		end
	end,
}

local rotten_armor_data = rotten_armor_config_settings

local function _on_rotten_armor_death(template_data, template_context)
	local unit = template_context.unit
	local nav_world = template_data.nav_world
	local position = _position(unit)

	if not position then
		return
	end

	local node_position = position + Vector3(0, 0, 0.25)
	local fx_system = Managers.state.extension:system("fx_system")
	local rotation = Unit.local_rotation(unit, 1)

	fx_system:trigger_vfx(rotten_armor_data.vfx_name, node_position, rotation)
	fx_system:trigger_wwise_event(rotten_armor_data.sfx_death_name, position)
	LiquidArea.try_create(position, Vector3.down(), nav_world, LiquidAreaTemplates.rotten_armor, nil, nil, true)
end

local function _rotten_armor_stat_reduction(unit, template_data, optional_first_start)
	local index = template_data.index
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if not health_extension then
		return
	end

	local current_health_percent = health_extension:current_health_percent()
	local damage_thresholds = rotten_armor_data.damage_thresholds
	local target_index = index

	for i = #damage_thresholds, 1, -1 do
		local damage_threshold = damage_thresholds[i]

		if current_health_percent <= damage_threshold then
			target_index = i

			break
		end
	end

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if optional_first_start or index < target_index then
		local t = Managers.time:time("gameplay")
		local damage_reduction_template_names = rotten_armor_data.damage_reduction_template_names
		local current_index = index
		local current_buff_template_name = damage_reduction_template_names[current_index]

		if current_buff_template_name and template_data.buff_index then
			buff_extension:remove_externally_controlled_buff(template_data.buff_index)

			template_data.buff_index = nil
		end

		local new_buff_template_name = damage_reduction_template_names[target_index]

		if new_buff_template_name and not buff_extension:has_buff_using_buff_template(current_buff_template_name) then
			local _, buff_index = buff_extension:add_externally_controlled_buff(new_buff_template_name, t)

			template_data.buff_index = buff_index
		end
	end
end

templates.mutator_rotten_armor = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_minion_damage_taken] = 1,
	},
	keywords = {
		buff_keywords.rotten_armor,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		template_data.nav_world = navigation_extension:nav_world()

		local breed = unit_data_extension:breed()
		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 0.85)
		end

		local start_index = 1

		template_data.index = start_index

		_rotten_armor_stat_reduction(unit, template_data, true)

		local fx_system = Managers.state.extension:system("fx_system")
		local effect_template = EffectTemplates.mutator_rotten_armor_stages

		fx_system:start_template_effect(effect_template, unit)

		local blackboard = BLACKBOARDS[unit]
		local has_gib_override = Blackboard.has_component(blackboard, "gib_override")

		if has_gib_override then
			local gib_override = Blackboard.write_component(blackboard, "gib_override")

			gib_override.should_override = true
			gib_override.target_template = "havoc_self_gib"
			gib_override.override_hit_zone_name = "center_mass"
		end
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.update_stat_reduction = true
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if template_data.update_stat_reduction and HEALTH_ALIVE[unit] then
			_rotten_armor_stat_reduction(unit, template_data)

			template_data.update_stat_reduction = false
		end
	end,
	stop_func = function (template_data, template_context)
		if template_context.is_server then
			_on_rotten_armor_death(template_data, template_context)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_head",
				sfx = {
					looping_wwise_start_event = "wwise/events/minions/play_fly_swarm_plague_loop_mutator",
					looping_wwise_stop_event = "wwise/events/minions/stop_fly_swarm_plague_loop_mutator",
				},
			},
		},
	},
}

local ENCROACHING_GARDEN_RADIUS = mutator_encroaching_garden_config_settings.healing_radius
local ENCROACHING_GARDEN_COLOR = mutator_encroaching_garden_config_settings.havoc_encroaching_garden_color
local ENCROACHING_GARDEN_HEALING_AMOUNT = mutator_encroaching_garden_config_settings.healing_amount_by_armor_type
local GARDEN_HAVOC_RESULTS_ENEMIES = {}

local function _healed_by_the_garden(template_data, template_context)
	if not template_context.is_server then
		return
	end

	table.clear(GARDEN_HAVOC_RESULTS_ENEMIES)

	local unit = template_context.unit
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name("villains")
	local target_side_names = side:relation_side_names("allied")
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local buff_template_name = "blessed_by_the_garden"
	local broadphase = broadphase_system.broadphase
	local position = POSITION_LOOKUP[unit]
	local allied_sied_num_results = broadphase.query(broadphase, position, ENCROACHING_GARDEN_RADIUS, GARDEN_HAVOC_RESULTS_ENEMIES, target_side_names)
	local current_time = FixedFrame.get_latest_fixed_time()
	local t = Managers.time:time("gameplay")

	for i = 1, allied_sied_num_results do
		local nearby_unit = GARDEN_HAVOC_RESULTS_ENEMIES[i]

		if HEALTH_ALIVE[nearby_unit] then
			local buff_extension = ScriptUnit.extension(nearby_unit, "buff_system")

			if not buff_extension:has_keyword("havoc_gardens_embrace") then
				buff_extension:add_internally_controlled_buff(buff_template_name, t)
				buff_extension:_update_stat_buffs_and_keywords(current_time)
			end
		end
	end
end

templates.blessed_by_the_garden_immunity = {
	class_name = "buff",
	predicted = false,
	keywords = {
		buff_keywords.havoc_gardens_embrace,
	},
}
templates.havoc_encroaching_garden = {
	class_name = "buff",
	predicted = false,
	keywords = {
		buff_keywords.havoc_gardens_embrace,
	},
	stat_buffs = {
		[buff_stat_buffs.max_health_modifier] = mutator_encroaching_garden_config_settings.stat_buff_settings.max_health_modifier,
		[buff_stat_buffs.impact_modifier] = mutator_encroaching_garden_config_settings.stat_buff_settings.impact_modifier,
		[buff_stat_buffs.suppressor_decay_multiplier] = mutator_encroaching_garden_config_settings.stat_buff_settings.suppressor_decay_multiplier,
	},
	start_func = function (template_data, template_context)
		local time_variation = mutator_encroaching_garden_config_settings.healing_frequency

		template_data.parasite_interval_time = time_variation
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local next_check_time = template_data.next_check_time

		if not next_check_time then
			template_data.next_check_time = t + template_data.parasite_interval_time

			return
		end

		if next_check_time < t then
			_healed_by_the_garden(template_data, template_context)

			template_data.next_check_time = t + template_data.parasite_interval_time
		end
	end,
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators + 1,
		node_effects = {
			{
				node_name = "j_head",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_gardens_embrace_head",
					stop_type = "stop",
				},
			},
		},
	},
}
templates.blessed_by_the_garden = {
	class_name = "interval_buff",
	duration = 2,
	interval = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		if unit_data_extension then
			local breed = unit_data_extension:breed()

			template_data.breed_armor_type = breed.armor_type
		end
	end,
	interval_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")
		local healing_amount = ENCROACHING_GARDEN_HEALING_AMOUNT[template_data.breed_armor_type]

		health_extension:add_heal(healing_amount)
	end,
	stop_func = function (template_data, template_context)
		return
	end,
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators,
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
							value = ENCROACHING_GARDEN_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = ENCROACHING_GARDEN_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = ENCROACHING_GARDEN_COLOR,
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
							value = ENCROACHING_GARDEN_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = ENCROACHING_GARDEN_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = ENCROACHING_GARDEN_COLOR,
						},
					},
				},
			},
		},
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_gardens_embrace",
	},
}
templates.live_heal_test = table.clone(templates.blessed_by_the_garden)
templates.live_heal_test.duration = math.huge

local BUFF_RADIUS = 5
local HAVOC_RESULT_1 = {}

local function _close_allies_nurgle_blessed(template_data, template_context)
	local unit = template_context.unit
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name("villains")
	local target_side_names = side:relation_side_names("allied")

	table.clear(HAVOC_RESULT_1)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local buff_template_name = "blessed_by_nurgle_parasite"
	local broadphase = broadphase_system.broadphase
	local position = POSITION_LOOKUP[unit]
	local num_results = broadphase.query(broadphase, position, BUFF_RADIUS, HAVOC_RESULT_1, target_side_names)
	local current_time = FixedFrame.get_latest_fixed_time()
	local t = Managers.time:time("gameplay")

	for i = 1, num_results do
		local nearby_ally = HAVOC_RESULT_1[i]

		if HEALTH_ALIVE[nearby_ally] then
			local buff_extension = ScriptUnit.extension(nearby_ally, "buff_system")

			if not buff_extension:has_keyword("has_nurgle_parasite") then
				buff_extension:add_internally_controlled_buff(buff_template_name, t)
				buff_extension:_update_stat_buffs_and_keywords(current_time)
			end
		end
	end
end

templates.havoc_nurgle_elite_moral_improve = {
	class_name = "buff",
	predicted = false,
	keywords = {
		buff_keywords.infested_head_armor_override,
		buff_keywords.has_nurgle_parasite,
	},
	start_func = function (template_data, template_context)
		local time_variation = 2

		template_data.parasite_interval_time = time_variation
	end,
	update_func = function (template_data, template_context, dt, t)
		local next_check_time = template_data.next_check_time

		if not next_check_time then
			template_data.next_check_time = t + template_data.parasite_interval_time

			return
		end

		if next_check_time < t then
			_close_allies_nurgle_blessed(template_data, template_context)

			template_data.next_check_time = t + template_data.parasite_interval_time
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

local NURGLE_MORALE_IMPROVED_BUFF = {
	0.7529411764705882,
	0.39215686274509803,
	0.5764705882352941,
}

templates.blessed_by_nurgle_parasite = {
	class_name = "buff",
	duration = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[buff_stat_buffs.impact_modifier] = -3,
		[buff_stat_buffs.suppressor_decay_multiplier] = -3,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

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
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		if not template_context.is_server then
			return
		end

		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(template_data.old_hit_mass)
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
							value = NURGLE_MORALE_IMPROVED_BUFF,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = NURGLE_MORALE_IMPROVED_BUFF,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = NURGLE_MORALE_IMPROVED_BUFF,
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
							value = NURGLE_MORALE_IMPROVED_BUFF,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = NURGLE_MORALE_IMPROVED_BUFF,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = NURGLE_MORALE_IMPROVED_BUFF,
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
							value = NURGLE_MORALE_IMPROVED_BUFF,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = NURGLE_MORALE_IMPROVED_BUFF,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = NURGLE_MORALE_IMPROVED_BUFF,
						},
					},
				},
			},
		},
	},
}

local MUTATOR_ENRAGED_DEFAULT_DAMAGE_REQUIRED = mutator_havoc_enraged_config_settings.damage_required_to_trigger
local MUTATOR_ENRAGED_TEMPLATE_NAME = mutator_havoc_enraged_config_settings.enraged_buff_template_name
local MUTATOR_ENRAGED_COLOR = mutator_havoc_enraged_config_settings.enraged_color

templates.havoc_enraged_enemies_trigger = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_minion_damage_taken] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")
		local current_health_percent = health_extension:current_health_percent()
		local is_under_threshold = current_health_percent < MUTATOR_ENRAGED_DEFAULT_DAMAGE_REQUIRED

		if is_under_threshold and HEALTH_ALIVE[unit] and not template_data.triggered then
			template_data.triggered = true

			local current_time = FixedFrame.get_latest_fixed_time()
			local t = Managers.time:time("gameplay")
			local buff_extension = ScriptUnit.extension(unit, "buff_system")

			buff_extension:add_internally_controlled_buff(MUTATOR_ENRAGED_TEMPLATE_NAME, t)
			buff_extension:_update_stat_buffs_and_keywords(current_time)
		end
	end,
}
templates.havoc_enraged_enemies = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = mutator_havoc_enraged_config_settings.stat_buff_settings.melee_attack_speed,
		[buff_stat_buffs.stagger_duration_multiplier] = mutator_havoc_enraged_config_settings.stat_buff_settings.stagger_duration_multiplier,
	},
	keywords = {
		"no_stagger",
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local color = Vector3(MUTATOR_ENRAGED_COLOR[1], MUTATOR_ENRAGED_COLOR[2], MUTATOR_ENRAGED_COLOR[3])

		Unit.set_vector3_for_materials(unit, "stimmed_color", color, true)

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

		local new_hit_mass = hit_mass * mutator_havoc_enraged_config_settings.hit_mass_multiplier
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(new_hit_mass)

		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, mutator_havoc_enraged_config_settings.move_variable_override)
		end

		local suppression_extension = ScriptUnit.has_extension(unit, "suppression_system")

		if suppression_extension then
			local blackboard = BLACKBOARDS[unit]
			local suppression_component = Blackboard.write_component(blackboard, "suppression")

			suppression_component.suppress_value = 0

			suppression_extension:add_suppression_immunity_duration(999)
		end

		local attack_intensity_extension = ScriptUnit.has_extension(unit, "attack_intensity_system")

		if attack_intensity_extension then
			attack_intensity_extension:set_allow_all_attacks_duration(999)
		end

		local tags = breed.tags
		local scale

		if tags.ogryn then
			scale = mutator_havoc_enraged_config_settings.scale.ogryn
		else
			scale = mutator_havoc_enraged_config_settings.scale.human
		end

		Unit.set_local_scale(unit, 1, Vector3(1, 1, 1) * scale)

		local position = POSITION_LOOKUP[unit]
		local fx_system = Managers.state.extension:system("fx_system")
		local sfx_shout = mutator_havoc_enraged_config_settings.sfx_shout

		fx_system:trigger_wwise_event(sfx_shout, position)
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit

		Unit.set_vector3_for_materials(unit, "stimmed_color", Vector3(0, 0, 0), true)
	end,
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators + 1,
		node_effects = {
			{
				node_name = "j_head",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/enraged_elites_rage",
					stop_type = "stop",
				},
			},
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
							value = MUTATOR_ENRAGED_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = MUTATOR_ENRAGED_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = MUTATOR_ENRAGED_COLOR,
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
							value = MUTATOR_ENRAGED_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = MUTATOR_ENRAGED_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = MUTATOR_ENRAGED_COLOR,
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
							value = MUTATOR_ENRAGED_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = MUTATOR_ENRAGED_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = MUTATOR_ENRAGED_COLOR,
						},
					},
				},
			},
		},
	},
}

local GREEN_STIM_COLOR = {
	0,
	0.75,
	0.005,
}
local BLUE_STIM_COLOR = {
	0,
	0.75,
	0.75,
}
local RED_STIM_COLOR = {
	0.9,
	0,
	0.005,
}
local YELLOW_STIM_COLOR = {
	0.7843137254901961,
	0.8745098039215686,
	0.0784313725490196,
}
local green_stimm_settings = mutator_stimmed_minions_config_settings.green_stimm_settings
local blue_stimm_settings = mutator_stimmed_minions_config_settings.blue_stimm_settings
local yellow_stimm_settings = mutator_stimmed_minions_config_settings.yellow_stimm_settings
local red_stimm_settings = mutator_stimmed_minions_config_settings.red_stimm_settings

templates.mutator_stimmed_minion_blue = {
	class_name = "buff",
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.super_armor_override,
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

		local new_hit_mass = hit_mass * blue_stimm_settings.hit_mass_multiplier
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
	stat_buffs = {
		[buff_stat_buffs.unarmored_damage] = blue_stimm_settings.stat_buff_settings.unarmored_damage,
		[buff_stat_buffs.resistant_damage] = -blue_stimm_settings.stat_buff_settings.resistant_damage,
		[buff_stat_buffs.disgustingly_resilient_damage] = blue_stimm_settings.stat_buff_settings.disgustingly_resilient_damage,
		[buff_stat_buffs.berserker_damage] = blue_stimm_settings.stat_buff_settings.berserker_damage,
		[buff_stat_buffs.armored_damage] = blue_stimm_settings.stat_buff_settings.armored_damage,
		[buff_stat_buffs.super_armor_damage] = blue_stimm_settings.stat_buff_settings.super_armor_damage,
	},
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators + 3,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/buff_stimmed_speed",
					stop_type = "destroy",
				},
			},
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = BLUE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = BLUE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = BLUE_STIM_COLOR,
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
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = BLUE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = BLUE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = BLUE_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.mutator_stimmed_minion_green = {
	class_name = "proc_buff",
	duration = 100,
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
	},
	stat_buffs = {
		[buff_stat_buffs.damage_taken_from_burning] = green_stimm_settings.stat_buff_settings.damage_taken_from_burning,
		[buff_stat_buffs.damage_taken_from_bleeding] = green_stimm_settings.stat_buff_settings.damage_taken_from_bleeding,
		[buff_stat_buffs.damage_taken_from_electrocution] = green_stimm_settings.stat_buff_settings.damage_taken_from_electrocution,
		[buff_stat_buffs.warp_damage] = green_stimm_settings.stat_buff_settings.warp_damage,
		[buff_stat_buffs.impact_modifier] = green_stimm_settings.stat_buff_settings.impact_modifier,
	},
	proc_events = {
		[proc_events.on_minion_damage_taken] = 1,
	},
	start_func = function (template_data, template_context)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		if not Managers.state.difficulty then
			return
		end

		local heal_multipliers = green_stimm_settings.heal_multipliers
		local heal_multiplier_scaled_by_challange = Managers.state.difficulty:get_table_entry_by_challenge(heal_multipliers)
		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")
		local max_health = health_extension:max_health()

		template_data.health_pool = max_health * heal_multiplier_scaled_by_challange
	end,
	proc_func = function (params, template_data, template_context)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		if HEALTH_ALIVE[template_context.unit] then
			local unit = template_context.unit
			local health_pool = template_data.health_pool
			local damage_amount = params.damage_amount

			if health_pool > 0 then
				local heal_amount = math.min(health_pool, damage_amount)
				local health_extension = ScriptUnit.extension(unit, "health_system")

				health_extension:add_heal(heal_amount)

				template_data.health_pool = template_data.health_pool - heal_amount
			end
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		if template_data.health_pool == 0 then
			return true
		else
			return false
		end
	end,
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators + 3,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/buff_stimmed_heal",
					stop_type = "destroy",
				},
			},
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = GREEN_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = GREEN_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = GREEN_STIM_COLOR,
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
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = GREEN_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = GREEN_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = GREEN_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.mutator_stimmed_minion_red = {
	class_name = "buff",
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
	},
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = red_stimm_settings.stat_buff_settings.melee_attack_speed,
		[buff_stat_buffs.stagger_duration_multiplier] = red_stimm_settings.stat_buff_settings.stagger_duration_multiplier,
		[buff_stat_buffs.impact_modifier] = red_stimm_settings.stat_buff_settings.impact_modifier,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local attack_intensity_extension = ScriptUnit.has_extension(unit, "attack_intensity_system")

		if attack_intensity_extension then
			attack_intensity_extension:set_allow_all_attacks_duration(999)
		end
	end,
	stop_func = function (template_data, template_context)
		return
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators + 3,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/buff_stimmed_power",
					stop_type = "destroy",
				},
			},
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = RED_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = RED_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = RED_STIM_COLOR,
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
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = RED_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = RED_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = RED_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.mutator_stimmed_minion_yellow = {
	class_name = "buff",
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
	},
	stat_buffs = {
		[buff_stat_buffs.weakspot_damage_taken] = yellow_stimm_settings.stat_buff_settings.weakspot_damage_taken,
		[buff_stat_buffs.unarmored_damage] = yellow_stimm_settings.stat_buff_settings.unarmored_damage,
		[buff_stat_buffs.resistant_damage] = yellow_stimm_settings.stat_buff_settings.disgustingly_resilient_damage,
		[buff_stat_buffs.disgustingly_resilient_damage] = yellow_stimm_settings.stat_buff_settings.berserker_damage,
		[buff_stat_buffs.berserker_damage] = yellow_stimm_settings.stat_buff_settings.armored_damage,
		[buff_stat_buffs.armored_damage] = yellow_stimm_settings.stat_buff_settings.super_armor_damage,
		[buff_stat_buffs.super_armor_damage] = yellow_stimm_settings.stat_buff_settings.impact_modifier,
		[buff_stat_buffs.impact_modifier] = yellow_stimm_settings.stat_buff_settings.ranged_attack_speed,
		[buff_stat_buffs.ranged_attack_speed] = yellow_stimm_settings.stat_buff_settings.ranged_attack_speed,
		[buff_stat_buffs.minion_num_shots_modifier] = yellow_stimm_settings.stat_buff_settings.minion_num_shots_modifier,
		[buff_stat_buffs.melee_attack_speed] = yellow_stimm_settings.stat_buff_settings.melee_attack_speed,
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

		local new_hit_mass = hit_mass * yellow_stimm_settings.hit_mass_multiplier
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
		node_effects_priotity = minion_effects_priorities.mutators + 3,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/buff_stimmed_ability",
					stop_type = "destroy",
				},
			},
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
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
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.ogryn_mutator_stimmed_minion_red = table.clone(templates.mutator_stimmed_minion_red)
templates.ogryn_mutator_stimmed_minion_red.minion_effects = {
	node_effects_priotity = minion_effects_priorities.mutators + 3,
	node_effects = {
		{
			node_name = "j_spine",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/buff_stimmed_ogryn_power",
				stop_type = "destroy",
			},
		},
		{
			node_name = "j_lefteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = RED_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = RED_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = RED_STIM_COLOR,
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
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = RED_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = RED_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = RED_STIM_COLOR,
					},
				},
			},
		},
	},
}
templates.ogryn_mutator_stimmed_minion_green = table.clone(templates.mutator_stimmed_minion_green)
templates.ogryn_mutator_stimmed_minion_green.minion_effects = {
	node_effects_priotity = minion_effects_priorities.mutators + 3,
	node_effects = {
		{
			node_name = "j_spine",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/buff_stimmed_ogryn_heal",
				stop_type = "destroy",
			},
		},
		{
			node_name = "j_lefteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = GREEN_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = GREEN_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = GREEN_STIM_COLOR,
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
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = GREEN_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = GREEN_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = GREEN_STIM_COLOR,
					},
				},
			},
		},
	},
}
templates.ogryn_mutator_stimmed_minion_blue = table.clone(templates.mutator_stimmed_minion_blue)
templates.ogryn_mutator_stimmed_minion_blue.minion_effects = {
	node_effects_priotity = minion_effects_priorities.mutators + 3,
	node_effects = {
		{
			node_name = "j_spine",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/buff_stimmed_ogryn_speed",
				stop_type = "destroy",
			},
		},
		{
			node_name = "j_lefteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = BLUE_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = BLUE_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = BLUE_STIM_COLOR,
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
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = BLUE_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = BLUE_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = BLUE_STIM_COLOR,
					},
				},
			},
		},
	},
}
templates.ogryn_mutator_stimmed_minion_yellow = table.clone(templates.mutator_stimmed_minion_yellow)
templates.ogryn_mutator_stimmed_minion_yellow.minion_effects = {
	node_effects_priotity = minion_effects_priorities.mutators + 3,
	node_effects = {
		{
			node_name = "j_spine",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/buff_stimmed_ogryn_ability",
				stop_type = "destroy",
			},
		},
		{
			node_name = "j_lefteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = YELLOW_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = YELLOW_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
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
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = YELLOW_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = YELLOW_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = YELLOW_STIM_COLOR,
					},
				},
			},
		},
	},
}
templates.havoc_no_stagger = {
	class_name = "buff",
	predicted = false,
	keywords = {
		"no_stagger",
	},
}
templates.havoc_rotten_armor_dr_01 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_damage_taken_multiplier] = 0.25,
		[buff_stat_buffs.melee_damage_taken_multiplier] = 0.25,
	},
}
templates.havoc_rotten_armor_dr_02 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_damage_taken_multiplier] = 0.5,
		[buff_stat_buffs.melee_damage_taken_multiplier] = 0.5,
	},
}
templates.havoc_rotten_armor_dr_03 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_damage_taken_multiplier] = 0.75,
		[buff_stat_buffs.melee_damage_taken_multiplier] = 0.75,
	},
}
templates.havoc_rotten_armor_dr_04 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_damage_taken_multiplier] = 1,
		[buff_stat_buffs.melee_damage_taken_multiplier] = 1,
	},
}
templates.havoc_rotten_armor_dr_05 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_damage_taken_multiplier] = 1.25,
		[buff_stat_buffs.melee_damage_taken_multiplier] = 1.25,
	},
}
templates.havoc_toughness_modifier_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness] = -10,
	},
}
templates.havoc_toughness_modifier_2 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness] = -15,
	},
}
templates.havoc_toughness_modifier_3 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness] = -30,
	},
}
templates.havoc_toughness_modifier_4 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness] = -40,
	},
}
templates.havoc_toughness_modifier_5 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness] = -45,
	},
}
templates.havoc_increased_cd_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ability_cooldown_modifier] = 5,
	},
}
templates.havoc_vent_speed_reduction_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.vent_warp_charge_speed] = 1.15,
	},
}
templates.havoc_vent_speed_reduction_2 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.vent_warp_charge_speed] = 1.35,
	},
}
templates.havoc_vent_speed_reduction_3 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.vent_warp_charge_speed] = 1.5,
	},
}
templates.havoc_vent_speed_reduction_4 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.vent_warp_charge_speed] = 1.75,
	},
}
templates.havoc_vent_speed_reduction_5 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.vent_warp_charge_speed] = 1.85,
	},
}
templates.havoc_toughness_regen_modifier_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_modifier] = -0.15,
	},
}
templates.havoc_toughness_regen_modifier_2 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_modifier] = -0.2,
	},
}
templates.havoc_toughness_regen_modifier_3 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_modifier] = -0.3,
	},
}
templates.havoc_toughness_regen_modifier_4 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_modifier] = -0.4,
	},
}
templates.havoc_toughness_regen_modifier_5 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_modifier] = -0.5,
	},
}
templates.havoc_knocked_down_health_modifier_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.knocked_down_health_modifier] = 0.2,
	},
}
templates.havoc_knocked_down_health_modifier_2 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.knocked_down_health_modifier] = 0.4,
	},
}
templates.havoc_knocked_down_health_modifier_3 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.knocked_down_health_modifier] = 0.6,
	},
}
templates.havoc_knocked_down_health_modifier_4 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.knocked_down_health_modifier] = 0.8,
	},
}
templates.havoc_knocked_down_health_modifier_5 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.knocked_down_health_modifier] = 1,
	},
}
templates.havoc_health_modifier_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.max_health_modifier] = -0.15,
	},
}
templates.havoc_health_modifier_2 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.max_health_modifier] = -0.2,
	},
}
templates.havoc_health_modifier_3 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.max_health_modifier] = -0.25,
	},
}
templates.havoc_health_modifier_4 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.max_health_modifier] = -0.3,
	},
}
templates.havoc_health_modifier_5 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.max_health_modifier] = -0.35,
	},
}
templates.havoc_melee_permanent_damage_01 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.permanent_damage_ratio] = 0.1,
	},
}
templates.havoc_melee_permanent_damage_02 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.permanent_damage_ratio] = 0.15,
	},
}
templates.havoc_melee_permanent_damage_03 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.permanent_damage_ratio] = 0.2,
	},
}
templates.havoc_melee_permanent_damage_04 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.permanent_damage_ratio] = 0.25,
	},
}
templates.havoc_melee_permanent_damage_05 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.permanent_damage_ratio] = 0.3,
	},
}
templates.havoc_positive_grenade_buff_1 = {
	class_name = "buff",
	predicted = false,
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
		[buff_stat_buffs.extra_max_amount_of_grenades] = 1,
		[buff_stat_buffs.warp_charge_amount_smite] = 0.2,
	},
}
templates.havoc_positive_grenade_buff_2 = {
	class_name = "buff",
	predicted = false,
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
		[buff_stat_buffs.extra_max_amount_of_grenades] = 1,
		[buff_stat_buffs.warp_charge_amount_smite] = 0.3,
	},
}
templates.havoc_positive_grenade_buff_3 = {
	class_name = "buff",
	predicted = false,
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
		[buff_stat_buffs.warp_charge_amount_smite] = 0.4,
	},
}
templates.havoc_positive_grenade_buff_4 = {
	class_name = "buff",
	predicted = false,
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
templates.havoc_positive_grenade_buff_5 = {
	class_name = "buff",
	predicted = false,
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
		[buff_stat_buffs.extra_max_amount_of_grenades] = 3,
		[buff_stat_buffs.warp_charge_amount_smite] = 0.6,
	},
}
templates.havoc_melee_attack_speed_01 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 0.2,
	},
}
templates.havoc_melee_attack_speed_02 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 0.35,
	},
}
templates.havoc_melee_attack_speed_03 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 0.5,
	},
}
templates.havoc_melee_attack_speed_04 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 0.75,
	},
}
templates.havoc_melee_attack_speed_05 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 1,
	},
}
templates.havoc_ranged_attack_speed_01 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_attack_speed] = 0.1,
		[buff_stat_buffs.minion_num_shots_modifier] = 1.25,
	},
}
templates.havoc_ranged_attack_speed_02 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_attack_speed] = 0.15,
		[buff_stat_buffs.minion_num_shots_modifier] = 1.5,
	},
}
templates.havoc_ranged_attack_speed_03 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_attack_speed] = 0.2,
		[buff_stat_buffs.minion_num_shots_modifier] = 1.75,
	},
}
templates.havoc_ranged_attack_speed_04 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_attack_speed] = 0.25,
		[buff_stat_buffs.minion_num_shots_modifier] = 2,
	},
}
templates.havoc_ranged_attack_speed_05 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_attack_speed] = 0.3,
		[buff_stat_buffs.minion_num_shots_modifier] = 2.25,
	},
}
templates.havoc_positive_weakspot_01 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.weakspot_damage] = 0.1,
	},
}
templates.havoc_positive_weakspot_02 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.weakspot_damage] = 0.2,
	},
}
templates.havoc_positive_weakspot_03 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.weakspot_damage] = 0.3,
	},
}
templates.havoc_positive_weakspot_04 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.weakspot_damage] = 0.4,
	},
}
templates.havoc_positive_weakspot_05 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.weakspot_damage] = 0.5,
	},
}
templates.havoc_positive_stamina_01 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.stamina_modifier] = 1,
	},
}
templates.havoc_positive_stamina_02 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.stamina_modifier] = 2,
	},
}
templates.havoc_positive_stamina_03 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.stamina_modifier] = 3,
	},
}
templates.havoc_positive_stamina_04 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.stamina_modifier] = 4,
	},
}
templates.havoc_positive_stamina_05 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.stamina_modifier] = 5,
	},
}
templates.havoc_positive_reload_speed_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.reload_speed] = 0.05,
	},
}
templates.havoc_positive_reload_speed_2 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.reload_speed] = 0.1,
	},
}
templates.havoc_positive_reload_speed_3 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.reload_speed] = 0.15,
	},
}
templates.havoc_positive_reload_speed_4 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.reload_speed] = 0.2,
	},
}
templates.havoc_positive_reload_speed_5 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.reload_speed] = 0.25,
	},
}
templates.havoc_positive_critical_chance_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.critical_strike_chance] = 0.04,
	},
}
templates.havoc_positive_critical_chance_2 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.critical_strike_chance] = 0.08,
	},
}
templates.havoc_positive_critical_chance_3 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.critical_strike_chance] = 0.12,
	},
}
templates.havoc_positive_critical_chance_4 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.critical_strike_chance] = 0.16,
	},
}
templates.havoc_positive_critical_chance_5 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.critical_strike_chance] = 0.2,
	},
}
templates.havoc_positive_movement_speed_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 0.030000000000000027,
	},
}
templates.havoc_positive_movement_speed_2 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 0.06000000000000005,
	},
}
templates.havoc_positive_movement_speed_3 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 0.09000000000000008,
	},
}
templates.havoc_positive_movement_speed_4 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 0.1200000000000001,
	},
}
templates.havoc_positive_movement_speed_5 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 0.1499999999999999,
	},
}
templates.havoc_positive_attack_speed_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 0.03,
		[buff_stat_buffs.ranged_attack_speed] = 0.03,
	},
}
templates.havoc_positive_attack_speed_2 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 0.06,
		[buff_stat_buffs.ranged_attack_speed] = 0.06,
	},
}
templates.havoc_positive_attack_speed_3 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 0.09,
		[buff_stat_buffs.ranged_attack_speed] = 0.09,
	},
}
templates.havoc_positive_attack_speed_4 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 0.12,
		[buff_stat_buffs.ranged_attack_speed] = 0.12,
	},
}
templates.havoc_positive_attack_speed_5 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 0.15,
		[buff_stat_buffs.ranged_attack_speed] = 0.15,
	},
}

return templates
