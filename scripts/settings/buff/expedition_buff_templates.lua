-- chunkname: @scripts/settings/buff/expedition_buff_templates.lua

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Stamina = require("scripts/utilities/attack/stamina")
local Breeds = require("scripts/settings/breed/breeds")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local proc_events = BuffSettings.proc_events
local attack_types = AttackSettings.attack_types
local stat_buffs = BuffSettings.stat_buffs
local keywords = BuffSettings.keywords
local damage_types = DamageSettings.damage_types
local templates = {}

table.make_unique(templates)

templates.expedition_effective_sprinting_buff = {
	class_name = "buff",
	duration = 900,
	hud_icon = "content/ui/textures/icons/buffs/hud/syringe_speed_buff_hud",
	predicted = false,
	stat_buffs = {
		[stat_buffs.stamina_cost_multiplier] = 0.7,
	},
	keywords = {},
	start_func = function (template_data, template_context)
		Stamina.add_stamina_percent(template_context.unit, 1)
	end,
}
templates.expedition_max_toughness_buff = {
	class_name = "buff",
	duration = 900,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_grace_time_hud",
	max_stacks = 2,
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_bonus] = 0.25,
	},
	keywords = {},
	start_func = function (template_data, template_context)
		return
	end,
}

local FLIES_BASE_DURATION = 15
local NURGLE_FLIES_ON_SCREEN_EFFECT = "content/fx/particles/screenspace/player_nurgle_flies_debuff"
local NURGLE_FLIES_VFX_SPEED_VAR = "fly_speed"

templates.expedition_nurgle_flies = {
	class_name = "proc_buff",
	duration = 15,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_grace_time_hud",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = true,
	stat_buffs = {
		[stat_buffs.movement_speed] = -0.5,
	},
	keywords = {
		keywords.nurgle_flies,
	},
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	player_effects = {
		looping_wwise_start_event = "wwise/events/minions/play_nurgle_flies_swarm_enter",
		looping_wwise_stop_event = "wwise/events/minions/play_nurgle_flies_swarm_exit",
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local world = template_context.world

		if template_context.is_server then
			local buff_ext = ScriptUnit.has_extension(unit, "buff_system")
			local t = FixedFrame.get_latest_fixed_time()
			local _, buff_index = buff_ext:add_externally_controlled_buff("expedition_nurgle_flies_dot", t)

			template_data.start_t = t
			template_data.duration = FLIES_BASE_DURATION
			template_data.buff_index = buff_index
			template_data.buff_ext = buff_ext
		end

		template_data.on_screen_effect_id = World.create_particles(world, NURGLE_FLIES_ON_SCREEN_EFFECT, Vector3(0, 0, 1))
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.reset_speed_t and t > template_data.reset_speed_t then
			local world = template_context.world
			local velocity = Vector3(0.5, 1, 0.5)
			local length_variable_index = World.find_particles_variable(world, NURGLE_FLIES_ON_SCREEN_EFFECT, NURGLE_FLIES_VFX_SPEED_VAR)

			template_data.reset_speed_t = nil

			World.set_particles_variable(world, template_data.on_screen_effect_id, length_variable_index, velocity)
		end
	end,
	specific_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context)
			local world = template_context.world
			local velocity = Vector3(5, 1, 5)
			local length_variable_index = World.find_particles_variable(world, NURGLE_FLIES_ON_SCREEN_EFFECT, NURGLE_FLIES_VFX_SPEED_VAR)

			World.set_particles_variable(world, template_data.on_screen_effect_id, length_variable_index, velocity)

			template_data.reset_speed_t = FixedFrame.get_latest_fixed_time() + 0.5

			if template_context.is_server then
				template_data.duration = template_data.duration - template_data.duration * 0.1
			end
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context)
			return
		end,
	},
	conditional_exit_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		if template_context.is_server and t > template_data.start_t + template_data.duration then
			return true
		end

		return false
	end,
	stop_func = function (template_data, template_context, extension_destroyed)
		if template_data.buff_ext and template_context.is_server then
			template_data.buff_ext:mark_buff_finished(template_data.buff_index)
		end

		local world = template_context.world
		local on_screen_effect_id = template_data.on_screen_effect_id

		World.destroy_particles(world, on_screen_effect_id)
	end,
}
templates.expedition_nurgle_flies_dot = {
	class_name = "interval_buff",
	interval = 0.35,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	ragdoll_push_force = {
		50,
		150,
	},
	start_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		template_data.start_t = t
		template_data.duration = FLIES_BASE_DURATION
	end,
	interval_func = function (template_data, template_context, template)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.toxin_variant_3
			local power_level = 10
			local owner_unit = template_context.is_server and template_context.owner_unit

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.toxin, "attacking_unit", owner_unit, "attack_type", attack_types.buff)
		end
	end,
}

local SAND_ON_SCREEN_EFFECT = "content/fx/particles/screenspace/player_screen_sand_tornado"
local SHADER_VAR = "opacity_lerp"
local CLOUD_NAMES = {
	"sand_clouds_screen",
	"vignette_sand",
}

local function _set_sand_screenspace_intensity(template_data, template_context)
	local owner_unit = template_context.owner_unit
	local unit = template_context.unit

	if not owner_unit or not ALIVE[owner_unit] or not template_context.unit or not ALIVE[unit] then
		return
	end

	local disabled_character_state_component = template_data.unit_data_extension:read_component("disabled_character_state")
	local vortex_grabbed = PlayerUnitStatus.is_vortex_grabbed(disabled_character_state_component)
	local on_screen_effect_id = template_data.on_screen_effect_id
	local intensity = 0

	if not vortex_grabbed then
		local vortex_template = template_data.vortex_template
		local debuff_radius = vortex_template.movement_speed_debuff_radius
		local unit_pos = POSITION_LOOKUP[template_context.unit]
		local vortex_pos = template_data.vortex_extension:get_position()
		local distance_flat = Vector3.distance(Vector3.flat(unit_pos), Vector3.flat(vortex_pos))

		intensity = 1 - math.clamp01(math.ilerp(0, debuff_radius, distance_flat))
	end

	for i = 1, #CLOUD_NAMES do
		World.set_particles_material_scalar(template_context.world, on_screen_effect_id, CLOUD_NAMES[i], SHADER_VAR, intensity)
	end
end

templates.expedition_sand_vortex_move_speed = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/states_grace_time_hud",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = true,
	stat_buffs = {
		[stat_buffs.movement_speed] = -0.3,
	},
	keywords = {},
	start_func = function (template_data, template_context)
		local owner_unit = template_context.owner_unit

		if owner_unit and ALIVE[owner_unit] then
			local owner_data_extension = ScriptUnit.has_extension(owner_unit, "unit_data_system")
			local vortex_extension = ScriptUnit.extension(owner_unit, "minion_vortex_system")
			local owner_breed = owner_data_extension:breed()

			template_data.vortex_template = owner_breed.vortex_template

			local world = template_context.world

			template_data.on_screen_effect_id = World.create_particles(world, SAND_ON_SCREEN_EFFECT, Vector3(0, 0, 1))
			template_data.unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
			template_data.vortex_extension = vortex_extension

			_set_sand_screenspace_intensity(template_data, template_context)
		end
	end,
	update_func = function (template_data, template_context, dt, t)
		_set_sand_screenspace_intensity(template_data, template_context)
	end,
	stop_func = function (template_data, template_context, extension_destroyed)
		local world = template_context.world
		local on_screen_effect_id = template_data.on_screen_effect_id

		World.destroy_particles(world, on_screen_effect_id)
	end,
	conditional_exit_func = function (template_data, template_context)
		local vortex_unit = template_context.owner_unit
		local unit = template_context.unit
		local units_alive = vortex_unit and ALIVE[vortex_unit] and template_context.unit and ALIVE[unit]

		if not units_alive then
			return true
		end

		local locomotion_extension = ScriptUnit.has_extension(unit, "locomotion_system")

		if not locomotion_extension then
			return true
		end

		local vortex_template = template_data.vortex_template
		local unit_pos = POSITION_LOOKUP[unit]
		local vortex_pos = POSITION_LOOKUP[vortex_unit]
		local distance_flat = Vector3.distance(Vector3.flat(unit_pos), Vector3.flat(vortex_pos))
		local debuff_radius = vortex_template.movement_speed_debuff_radius

		if debuff_radius < distance_flat then
			return true
		end

		return false
	end,
}
templates.vortex_grabbed = {
	class_name = "buff",
	duration = 25,
	max_stacks = 3,
	max_stacks_cap = 3,
	predicted = false,
	keywords = {},
}
templates.expeditions_death_imminent = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	stat_buffs = {},
	keywords = {
		keywords.expeditions_death_imminent,
	},
}

return templates
