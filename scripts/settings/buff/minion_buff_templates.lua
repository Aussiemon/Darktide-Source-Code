-- chunkname: @scripts/settings/buff/minion_buff_templates.lua

local Attack = require("scripts/utilities/attack/attack")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local PLAYER_BREED_TYPE = BreedSettings.types.player
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.cultist_flamer_hit_by_flame = {
	interval = 0.5,
	duration = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 1,
	class_name = "interval_buff",
	keywords = {
		buff_keywords.burning
	},
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.grenadier_liquid_fire_burning
			local power_level_table = MinionDifficultySettings.power_level.cultist_flamer_on_hit_fire
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table)
			local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)
		end
	end,
	minion_effects = minion_burning_buff_effects.chemfire
}
templates.hit_by_common_enemy_flame = {
	interval = 0.5,
	duration = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 1,
	class_name = "interval_buff",
	keywords = {
		buff_keywords.burning
	},
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.horde_flame_impact
			local power_level_table = MinionDifficultySettings.power_level.chaos_engulfed_enemy_fire_attack
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table)
			local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)
		end
	end,
	minion_effects = minion_burning_buff_effects.chemfire
}
templates.hit_by_poxburster_bile = {
	duration = 10,
	predicted = false,
	class_name = "buff",
	is_negative = true,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = -0.3
	},
	keywords = {
		buff_keywords.puked_on
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_bon_vomit_loop",
		looping_wwise_stop_event = "wwise/events/player/play_player_vomit_exit",
		looping_wwise_start_event = "wwise/events/player/play_player_vomit_enter",
		stop_type = "stop",
		wwise_state = {
			group = "swamped",
			on_state = "on",
			off_state = "none"
		}
	}
}
templates.cultist_flamer_liquid_immunity = {
	unique_buff_id = "cultist_flamer_liquid_immunity",
	unique_buff_priority = 1,
	predicted = false,
	class_name = "buff",
	keywords = {
		buff_keywords.cultist_flamer_liquid_immunity
	}
}
templates.renegade_flamer_hit_by_flame = {
	interval = 0.5,
	duration = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 1,
	class_name = "interval_buff",
	keywords = {
		buff_keywords.burning
	},
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.grenadier_liquid_fire_burning
			local power_level_table = MinionDifficultySettings.power_level.renegade_flamer_on_hit_fire
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table)
			local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)
		end
	end,
	minion_effects = minion_burning_buff_effects.fire
}
templates.renegade_flamer_liquid_immunity = {
	unique_buff_id = "renegade_flamer_liquid_immunity",
	unique_buff_priority = 1,
	predicted = false,
	class_name = "buff",
	keywords = {
		buff_keywords.renegade_flamer_liquid_immunity
	}
}
templates.renegade_grenadier_liquid_immunity = {
	unique_buff_id = "renegade_grenadier_liquid_immunity",
	unique_buff_priority = 1,
	predicted = false,
	class_name = "buff",
	keywords = {
		buff_keywords.renegade_grenadier_liquid_immunity
	}
}
templates.beast_of_nurgle_liquid_immunity = {
	unique_buff_id = "beast_of_nurgle_liquid_immunity",
	unique_buff_priority = 1,
	predicted = false,
	class_name = "buff",
	keywords = {
		buff_keywords.beast_of_nurgle_liquid_immunity
	}
}

local RELATION = "enemy"
local DAEMONHOST_CORRUPTION_AURA_RESULTS = {}
local CORRUPTION_AURA_DAMAGE_TYPE = "corruption"
local CORRUPTION_AURA_RADIUS = 7
local CORRUPTION_AURA_PERMANENT_PERCENT = {
	0.2,
	0.25,
	0.45,
	0.45,
	0.45
}

templates.daemonhost_corruption_aura = {
	interval = 1,
	max_stacks = 1,
	refresh_duration_on_stack = true,
	predicted = false,
	class_name = "interval_buff",
	duration = math.huge,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system.side_by_unit[unit]
			local target_side_names = side:relation_side_names(RELATION)

			table.clear(DAEMONHOST_CORRUPTION_AURA_RESULTS)

			local broadphase_system = Managers.state.extension:system("broadphase_system")
			local broadphase = broadphase_system.broadphase
			local position = POSITION_LOOKUP[unit]
			local num_results = broadphase.query(broadphase, position, CORRUPTION_AURA_RADIUS, DAEMONHOST_CORRUPTION_AURA_RESULTS, target_side_names, PLAYER_BREED_TYPE)
			local damage_profile = DamageProfileTemplates.daemonhost_corruption_aura
			local power_level_table = MinionDifficultySettings.power_level.daemonhost_corruption_aura
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table)

			for i = 1, num_results do
				local nearby_enemy = DAEMONHOST_CORRUPTION_AURA_RESULTS[i]

				if HEALTH_ALIVE[nearby_enemy] then
					local hit_unit_data_extension = ScriptUnit.extension(nearby_enemy, "unit_data_system")
					local disabled_character_state_component = hit_unit_data_extension:read_component("disabled_character_state")
					local is_warp_grabbed = PlayerUnitStatus.is_warp_grabbed(disabled_character_state_component)

					if not is_warp_grabbed then
						local health_extension = ScriptUnit.extension(nearby_enemy, "health_system")
						local permanent_damage_taken_percent = health_extension:permanent_damage_taken_percent()
						local allowed_permanent_percent = Managers.state.difficulty:get_table_entry_by_challenge(CORRUPTION_AURA_PERMANENT_PERCENT)

						if permanent_damage_taken_percent < allowed_permanent_percent then
							local attack_direction = Vector3.normalize(POSITION_LOOKUP[nearby_enemy] - position)

							Attack.execute(nearby_enemy, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_direction", attack_direction, "hit_zone_name", "torso", "damage_type", CORRUPTION_AURA_DAMAGE_TYPE)
						end
					end
				end
			end
		end
	end
}
templates.chaos_beast_of_nurgle_hit_by_vomit = {
	refresh_duration_on_stack = true,
	duration = 10,
	predicted = false,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_nurgle_vomit_buff_hud",
	max_stacks = 3,
	class_name = "buff",
	is_negative = true,
	keywords = {
		buff_keywords.beast_of_nurgle_vomit
	},
	forbidden_keywords = {
		buff_keywords.beast_of_nurgle_liquid_immunity
	},
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = -0.15000000000000002,
		[buff_stat_buffs.dodge_speed_multiplier] = 0.9
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_bon_vomit_loop",
		looping_wwise_stop_event = "wwise/events/player/play_player_vomit_exit",
		looping_wwise_start_event = "wwise/events/player/play_player_vomit_enter",
		stop_type = "stop",
		wwise_state = {
			group = "swamped",
			on_state = "on",
			off_state = "none"
		}
	}
}
templates.chaos_beast_of_nurgle_being_eaten = {
	interval = 1,
	predicted = false,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_nurgle_eaten_buff_hud",
	max_stacks = 1,
	class_name = "interval_buff",
	is_negative = true,
	keywords = {
		buff_keywords.beast_of_nurgle_vomit,
		buff_keywords.beast_of_nurgle_liquid_immunity
	},
	damage_template = DamageProfileTemplates.beast_of_nurgle_slime_liquid,
	damage_type = damage_types.minion_vomit,
	start_func = function (template_data, template_context)
		local t = Managers.time:time("gameplay")

		template_data.start_t = t
	end,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local t = Managers.time:time("gameplay")
			local scale_duration = 30
			local duration_scale = math.abs(template_data.start_t - t) / scale_duration
			local max_scale = 2
			local scale_amount = math.min(duration_scale * max_scale, max_scale)
			local health_extension = ScriptUnit.extension(unit, "health_system")
			local max_health = health_extension:max_health()
			local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil
			local damage_template = DamageProfileTemplates.beast_of_nurgle_slime_liquid
			local power_level_table = MinionDifficultySettings.power_level.chaos_beast_of_nurgle_being_eaten
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table) * max_health * (1 + scale_amount)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)
		end
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_bon_vomit_hit",
		looping_wwise_start_event = "wwise/events/minions/play_beast_of_nurgle_stomach_loop",
		looping_wwise_stop_event = "wwise/events/minions/stop_beast_of_nurgle_stomach_loop"
	}
}

local RENEAGDE_FLAMER_VFX_STAGES = {
	first_stage = {
		{
			node_name = "ap_5h",
			vfx = {
				orphaned_policy = "destroy",
				particle_effect = "content/fx/particles/enemies/renegade_flamer/renegade_flamer_fuse_loop",
				stop_type = "stop"
			}
		}
	},
	second_stage = {
		{
			node_name = "ap_4h",
			vfx = {
				orphaned_policy = "destroy",
				particle_effect = "content/fx/particles/enemies/renegade_flamer/renegade_flamer_fuse_loop",
				stop_type = "stop"
			}
		}
	},
	third_stage = {
		{
			node_name = "ap_5h",
			vfx = {
				orphaned_policy = "destroy",
				particle_effect = "content/fx/particles/enemies/renegade_flamer/renegade_flamer_backpack_ignited",
				stop_type = "stop"
			}
		},
		{
			node_name = "ap_5h",
			sfx = {
				looping_wwise_stop_event = "wwise/events/weapon/stop_flamer_explosion_fuse_flame",
				looping_wwise_start_event = "wwise/events/weapon/play_flamer_explosion_fuse_flame"
			}
		}
	}
}
local CULTIST_FLAMER_VFX_STAGES = {
	first_stage = {
		{
			node_name = "ap_5h",
			vfx = {
				orphaned_policy = "destroy",
				particle_effect = "content/fx/particles/enemies/cultist_flamer/cultist_flamer_fuse_loop",
				stop_type = "stop"
			}
		}
	},
	second_stage = {
		{
			node_name = "ap_4h",
			vfx = {
				orphaned_policy = "destroy",
				particle_effect = "content/fx/particles/enemies/cultist_flamer/cultist_flamer_fuse_loop",
				stop_type = "stop"
			}
		}
	},
	third_stage = {
		{
			node_name = "ap_5h",
			vfx = {
				orphaned_policy = "destroy",
				particle_effect = "content/fx/particles/enemies/cultist_flamer/cultist_flamer_backpack_ignited",
				stop_type = "stop"
			}
		},
		{
			node_name = "ap_5h",
			sfx = {
				looping_wwise_stop_event = "wwise/events/weapon/stop_flamer_explosion_fuse_flame",
				looping_wwise_start_event = "wwise/events/weapon/play_flamer_explosion_fuse_flame"
			}
		}
	}
}
local FLINCH_ANIMS = {
	{
		duration = 0.8,
		name = "suppressed_loop_01"
	},
	{
		duration = 0.8,
		name = "suppressed_loop_02"
	},
	{
		duration = 0.8,
		name = "suppressed_loop_03"
	}
}
local HEALTH_STEPS = {
	{
		health_step = 1,
		health_threshold = 0.95
	},
	{
		health_step = 2,
		health_threshold = 0.9
	},
	{
		health_step = 3,
		health_threshold = 0.75
	},
	{
		health_step = 4,
		health_threshold = 0.5
	}
}

local function _flamer_explode(unit, template_context)
	local damage_template = DamageProfileTemplates.flamer_implosion
	local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil

	Attack.execute(unit, damage_template, "power_level", 400, "damage_type", "burning", "attacking_unit", optional_owner_unit)
end

local function _play_flinch_anim(data, context)
	local unit = context.unit
	local flinch_anim
	local random_anim_event = math.random(1, #FLINCH_ANIMS)

	flinch_anim = FLINCH_ANIMS[random_anim_event].name

	if Unit.has_animation_event(unit, flinch_anim) then
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(flinch_anim)
	end

	return FLINCH_ANIMS[random_anim_event].duration
end

templates.flamer_backpack_counter = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_minion_damage_taken] = 1
	},
	start_func = function (template_data, template_context)
		template_data.blackboard = BLACKBOARDS[template_context.unit]
		template_data.current_step = 1

		local breed_name = template_context.breed.name

		template_data.buff_name = breed_name .. "_backpack_damaged"
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		if params.hit_zone_name_or_nil == "backpack" and params.attack_type ~= "melee" then
			local unit = template_context.unit
			local t = FixedFrame.get_latest_fixed_time()
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local health_extension = ScriptUnit.extension(template_context.unit, "health_system")
			local buff_name = template_data.buff_name
			local current_health_percent = health_extension:current_health_percent()
			local health_step_value = 0

			for i = 1, #HEALTH_STEPS do
				local health_step_data = HEALTH_STEPS[i]

				if current_health_percent <= health_step_data.health_threshold then
					health_step_value = health_step_data.health_step
				else
					break
				end
			end

			local current_stacks_or_nil = buff_extension:current_stacks(buff_name)
			local times_to_apply_stack = health_step_value - current_stacks_or_nil

			for i = 1, times_to_apply_stack do
				local statistics_component = Blackboard.write_component(template_data.blackboard, "statistics")

				statistics_component.flamer_backpack_impacts = statistics_component.flamer_backpack_impacts + 1

				buff_extension:add_internally_controlled_buff(buff_name, t)
				buff_extension:_update_stat_buffs_and_keywords(t)
			end
		end
	end
}
templates.renegade_flamer_backpack_damaged = {
	predicted = false,
	max_stacks = 4,
	class_name = "buff",
	start_func = function (template_data, template_context)
		template_data.is_triggered = false
		template_data.fuse_timer = nil
		template_data.duration = 1
		template_data.blackboard = BLACKBOARDS[template_context.unit]
	end,
	update_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local t = FixedFrame.get_latest_fixed_time()
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local buff_name = template_context.template.name
		local current_stacks = buff_extension:current_stacks(buff_name)

		if current_stacks >= 4 then
			if not template_data.is_triggered then
				template_data.fuse_timer = t + 5
				template_data.is_triggered = true
			end

			if t >= template_data.fuse_timer and HEALTH_ALIVE[unit] then
				_flamer_explode(unit, template_context)
			end

			local blackboard = template_data.blackboard
			local disable_component = blackboard and blackboard.disable

			if disable_component and disable_component.is_disabled then
				return
			end

			if t >= template_data.duration then
				template_data.duration = _play_flinch_anim(template_data, template_context)
				template_data.duration = template_data.duration + t
			end
		end
	end,
	minion_effects = {
		stack_node_effects = {
			[2] = RENEAGDE_FLAMER_VFX_STAGES.first_stage,
			[3] = RENEAGDE_FLAMER_VFX_STAGES.second_stage,
			[4] = RENEAGDE_FLAMER_VFX_STAGES.third_stage
		},
		node_effects = {
			{
				node_name = "ap_3h",
				sfx = {
					looping_wwise_stop_event = "wwise/events/weapon/stop_flamer_explosion_fuse",
					looping_wwise_start_event = "wwise/events/weapon/play_flamer_explosion_fuse"
				}
			},
			{
				node_name = "ap_3h",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/renegade_flamer/renegade_flamer_fuse_loop",
					stop_type = "stop"
				}
			}
		}
	}
}
templates.cultist_flamer_backpack_damaged = table.clone(templates.renegade_flamer_backpack_damaged)
templates.cultist_flamer_backpack_damaged.minion_effects.stack_node_effects = {
	[2] = CULTIST_FLAMER_VFX_STAGES.first_stage,
	[3] = CULTIST_FLAMER_VFX_STAGES.second_stage,
	[4] = CULTIST_FLAMER_VFX_STAGES.third_stage
}
templates.cultist_flamer_backpack_damaged.minion_effects.node_effects[2].vfx.particle_effect = "content/fx/particles/enemies/cultist_flamer/cultist_flamer_fuse_loop"

return templates
