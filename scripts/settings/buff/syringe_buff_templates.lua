local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Health = require("scripts/utilities/health")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Stamina = require("scripts/utilities/attack/stamina")
local stat_buffs = BuffSettings.stat_buffs
local keywords = BuffSettings.keywords
local templates = {}

table.make_unique(templates)

local function _calulcate_coruption_buff_healing(template_data, heal_settings, health_extension)
	local max_health = health_extension:max_health()
	local total_healing = 0
	local number_of_health_segments = heal_settings.number_of_health_segments

	if number_of_health_segments then
		local max_wounds = health_extension.max_wounds and health_extension:max_wounds() or 1
		local health_per_segment = max_health / max_wounds
		total_healing = health_per_segment * number_of_health_segments
	end

	local percentage_of_heal = heal_settings.percentage_of_heal

	if percentage_of_heal then
		total_healing = max_health * percentage_of_heal
	end

	local min_healing = 0
	local min_percentage_of_heal = heal_settings.min_percentage_of_heal

	if min_percentage_of_heal then
		min_healing = max_health * min_percentage_of_heal
	end

	total_healing = math.max(min_healing, total_healing)
	template_data.healing_remaining = total_healing
	local heal_duration = heal_settings.heal_duration
	local healing_per_second = heal_duration ~= 0 and total_healing / heal_duration
	template_data.healing_per_second = healing_per_second
end

templates.syringe_heal_corruption_buff = {
	hud_icon = "content/ui/textures/icons/buffs/hud/syringe_corruption_buff_hud",
	predicted = false,
	duration = 3,
	class_name = "buff",
	heal_settings = {
		number_of_health_segments = 1,
		heal_duration = 0,
		min_percentage_of_heal = 0.25,
		heal_type_permanent = DamageSettings.heal_types.blessing_syringe,
		heal_type_normal = DamageSettings.heal_types.syringe
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
		local health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.health_extension = health_extension

		Health.play_fx(unit)

		local fx_extension = ScriptUnit.extension(unit, "fx_system")
		local particle_name = "content/fx/particles/pocketables/syringe_heal_3p"

		fx_extension:spawn_unit_particles(particle_name, "hips", true, "destroy", nil, nil, nil, true)

		template_data.health_before = health_extension:current_health()
		template_data.permanent_damage_before = health_extension:permanent_damage_taken()
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local character_state_component = template_data.character_state_component

		if character_state_component and PlayerUnitStatus.is_knocked_down(character_state_component) then
			return
		end

		local health_extension = template_data.health_extension

		if not template_data.calculated_healing then
			local template = template_context.template
			local heal_settings = template.heal_settings

			_calulcate_coruption_buff_healing(template_data, heal_settings, health_extension)

			template_data.calculated_healing = true
		end

		local heal_settings = template_context.template.heal_settings
		local healing_per_second = template_data.healing_per_second
		local healing_remaining = template_data.healing_remaining
		local heal_amount = healing_per_second and math.min(healing_per_second * dt, healing_remaining) or healing_remaining
		local health_added_permanent = 0

		if heal_settings.heal_type_permanent then
			health_added_permanent = health_extension:add_heal(heal_amount, heal_settings.heal_type_permanent)
		end

		local health_added_normal = 0
		local used_to_heal_knocked_down_player = template_data.used_to_heal_knocked_down_player

		if heal_settings.heal_type_normal and not used_to_heal_knocked_down_player then
			local normal_health_added = heal_amount
			health_added_normal = health_extension:add_heal(normal_health_added, heal_settings.heal_type_normal)
		end

		local health_added = math.max(health_added_permanent, health_added_normal)
		healing_remaining = healing_remaining - health_added
		template_data.healing_remaining = healing_remaining
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local alive = HEALTH_ALIVE[template_context.unit]

		if not alive or not template_data.health_extension then
			local player_unit_spawn_manager = Managers.state.player_unit_spawn
			local player = player_unit_spawn_manager:owner(template_context.unit)

			if player then
				local data = {
					healed_amount = 0,
					corruption_healed_amount = 0
				}

				Managers.telemetry_events:player_stimm_heal(player, data)
			end

			return
		end

		local health_after = template_data.health_extension:current_health()
		local permanent_damage_after = template_data.health_extension:permanent_damage_taken()
		local heal = health_after - template_data.health_before
		local corruption_heal = template_data.permanent_damage_before - permanent_damage_after
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(template_context.unit)

		if player then
			local data = {
				healed_amount = heal,
				corruption_healed_amount = corruption_heal
			}

			Managers.telemetry_events:player_stimm_heal(player, data)
		end
	end
}
templates.syringe_ability_boost_buff = {
	unique_buff_id = "syringe_stimm",
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/syringe_ability_buff_hud",
	unique_buff_priority = 1,
	duration = 15,
	class_name = "buff",
	keywords = {
		keywords.syringe_ability
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.ability_extension = ability_extension
		local fx_extension = ScriptUnit.extension(unit, "fx_system")
		local particle_name = "content/fx/particles/pocketables/syringe_ability_3p"

		fx_extension:spawn_unit_particles(particle_name, "hips", true, "destroy", nil, nil, nil, true)
	end,
	update_func = function (template_data, template_context, dt, t)
		local ability_extension = template_data.ability_extension
		local ability_type = "combat_ability"
		local missing_ability_charges = ability_extension:missing_ability_charges(ability_type)

		if missing_ability_charges > 0 then
			local effect = 3
			local reduce_time = dt * effect

			ability_extension:reduce_ability_cooldown_time(ability_type, reduce_time)
		end
	end
}
templates.syringe_power_boost_buff = {
	unique_buff_id = "syringe_stimm",
	duration = 15,
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/syringe_power_buff_hud",
	unique_buff_priority = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.25,
		[stat_buffs.rending_multiplier] = 0.25,
		[stat_buffs.fov_multiplier] = 0.985,
		[stat_buffs.warp_charge_amount] = 0.66
	},
	keywords = {
		keywords.syringe_power
	},
	start_func = function (template_data, template_context)
		local fx_extension = ScriptUnit.extension(template_context.unit, "fx_system")
		local particle_name = "content/fx/particles/pocketables/syringe_power_3p"

		fx_extension:spawn_unit_particles(particle_name, "hips", true, "destroy", nil, nil, nil, true)
	end
}
templates.syringe_speed_boost_buff = {
	unique_buff_id = "syringe_stimm",
	duration = 15,
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/syringe_speed_buff_hud",
	unique_buff_priority = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.fov_multiplier] = 1.035,
		[stat_buffs.reload_speed] = 0.15,
		[stat_buffs.charge_up_time] = -0.25,
		[stat_buffs.stamina_cost_multiplier] = 0.75,
		[stat_buffs.sprinting_cost_multiplier] = 0.5,
		[stat_buffs.attack_speed] = 0.2,
		[stat_buffs.chain_lightning_jump_time_multiplier] = 0.75,
		[stat_buffs.psyker_throwing_knife_speed_modifier] = 0.25,
		[stat_buffs.smite_attack_speed] = 0.25,
		[stat_buffs.vent_warp_charge_multiplier] = 1.25
	},
	keywords = {
		keywords.syringe_speed
	},
	start_func = function (template_data, template_context)
		Stamina.add_stamina_percent(template_context.unit, 1)

		local fx_extension = ScriptUnit.extension(template_context.unit, "fx_system")
		local particle_name = "content/fx/particles/pocketables/syringe_speed_3p"

		fx_extension:spawn_unit_particles(particle_name, "hips", true, "destroy", nil, nil, nil, true)
	end
}

return templates
