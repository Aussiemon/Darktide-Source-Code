-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_legendary_buff_templates/hordes_legendary_adamant_buff_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local HordesBuffsUtilities = require("scripts/settings/buff/hordes_buffs/hordes_buffs_utilities")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local buff_categories = BuffSettings.buff_categories
local buff_keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local SFX_NAMES = HordesBuffsUtilities.SFX_NAMES
local VFX_NAMES = HordesBuffsUtilities.VFX_NAMES
local BROADPHASE_RESULTS = {}
local templates = {}

table.make_unique(templates)

templates.hordes_buff_adamant_stance_immunity = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_keywords = {
		buff_keywords.invulnerable,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	conditional_keywords_func = function (template_data, template_context)
		return template_data.buff_extension:has_unique_buff_id("adamant_hunt_stance")
	end,
}
templates.hordes_buff_adamant_mine_explosion = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.adamant_mine_explode_on_finish,
	},
}
templates.hordes_buff_adamant_drone_stun = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.adamant_drone_shocks_enemies_in_range,
	},
}

local adamant_target_num_enemies_killed_from_grenade = HordesBuffsData.hordes_buff_adamant_grenade_multi.buff_stats.amount.value

templates.hordes_buff_adamant_grenade_multi = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.last_grenade_kill_t = 0
		template_data.num_enemies_killed_in_cluster = 0
		template_data.cluster_reached_minimum = false
		template_data.ability_extension = ScriptUnit.has_extension(template_context.unit, "ability_system")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local is_grenade_kill = params.damage_profile.name == "close_adamant_grenade" or params.damage_profile.name == "adamant_grenade"

		return template_context.is_server and is_grenade_kill
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		if t - template_data.last_grenade_kill_t > 0.25 then
			template_data.num_enemies_killed_in_cluster = 0
			template_data.cluster_reached_minimum = false
		end

		template_data.last_grenade_kill_t = t
		template_data.num_enemies_killed_in_cluster = template_data.num_enemies_killed_in_cluster + 1

		if not template_data.cluster_reached_minimum and template_data.num_enemies_killed_in_cluster >= adamant_target_num_enemies_killed_from_grenade then
			local player_unit = template_context.unit
			local ability_extension = template_data.ability_extension

			if ability_extension and ability_extension:has_ability_type("grenade_ability") then
				ability_extension:restore_ability_charge("grenade_ability", 1)

				local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

				if player_fx_extension then
					player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, player_unit)
				end
			end

			template_data.cluster_reached_minimum = true
		end
	end,
}

local adamant_auto_detonate_cooldown = HordesBuffsData.hordes_buff_adamant_auto_detonate.buff_stats.time.value

templates.hordes_buff_adamant_auto_detonate = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	cooldown_duration = adamant_auto_detonate_cooldown,
	proc_events = {
		[proc_events.on_player_companion_pounce] = 1,
		[proc_events.on_player_companion_knock_away] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.fx_extension = ScriptUnit.has_extension(template_context.unit, "fx_system")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local pounced_enemy_breed = Breeds[params.target_unit_breed_name]
		local pounced_enemy_breed_tags = pounced_enemy_breed.tags
		local is_valid_target = pounced_enemy_breed_tags.monster or pounced_enemy_breed_tags.special or pounced_enemy_breed_tags.elite

		return template_context.is_server and is_valid_target
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local radius = 5
		local shout_target_template_name = "adamant_shout"
		local player_unit = template_context.unit
		local companion_unit = params.companion_unit
		local companion_position = POSITION_LOOKUP[companion_unit]
		local rotation = Quaternion.identity()
		local dog_forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))

		ShoutAbilityImplementation.execute(radius, shout_target_template_name, player_unit, t, nil, dog_forward, companion_position, rotation)

		local vfx = "content/fx/particles/abilities/adamant/adamant_shout"
		local vfx_pos = companion_position + Vector3.up()

		template_data.fx_extension:spawn_particles(vfx, vfx_pos, nil, nil, nil, nil, true)

		local explosion_template = ExplosionTemplates.adamant_whistle_explosion

		Explosion.create_explosion(template_context.world, template_context.physics_world, companion_position, Vector3.up(), player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
	end,
}

local adamant_bash_random_ailment_effects = {
	{
		buff_to_add = "flamer_assault",
		sfx = SFX_NAMES.burning_proc,
	},
	{
		buff_to_add = "warp_fire",
		sfx = SFX_NAMES.burning_proc,
	},
	{
		buff_to_add = "bleed",
	},
}

templates.hordes_buff_adamant_random_bash = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.hit_units = {}
		template_data.hit_units_wipe_t = nil
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local is_adamant_charge_hit = params.damage_profile.name == "adamant_charge_impact"

		return template_context.is_server and is_adamant_charge_hit
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		if template_data.hit_units_wipe_t and t >= template_data.hit_units_wipe_t then
			table.clear(template_data.hit_units)

			template_data.hit_units_wipe_t = nil
		end

		local player_unit = template_context.unit
		local hit_unit = params.attacked_unit
		local hit_units = template_data.hit_units

		if HEALTH_ALIVE[hit_unit] and not hit_units[hit_unit] then
			local random_ailment_index = math.random(1, #adamant_bash_random_ailment_effects)
			local random_ailment = adamant_bash_random_ailment_effects[random_ailment_index]
			local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

			if buff_extension then
				hit_units[hit_unit] = true
				template_data.hit_units_wipe_t = t + 1

				buff_extension:add_internally_controlled_buff_with_stacks(random_ailment.buff_to_add, 5, t, "owner_unit", player_unit)

				if random_ailment.sfx then
					local fx_system = Managers.state.extension:system("fx_system")
					local enemy_position = POSITION_LOOKUP[hit_unit]

					fx_system:trigger_wwise_event(random_ailment.sfx, enemy_position)
				end
			end
		end
	end,
}

return templates
