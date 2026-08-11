-- chunkname: @scripts/settings/breed/breed_shield_templates/chaos/renegade_vanguard_shield_template.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local attack_types = AttackSettings.attack_types
local shield_templates = {
	renegade_vanguard = {
		allow_push_stagger_override = true,
		always_override_stagger_type = "shield_block",
		destroyed_vfx = "content/fx/particles/enemies/rotten_armor_death",
		is_invulnerable = false,
		open_up_threshold = 45,
		open_up_vfx_slot_name = "slot_shield",
		push_combo_window = 2,
		push_open_up_count = 2,
		regen_hit_strength_rate = 5,
		skip_open_up_vfx = true,
		health = {
			200,
			400,
			500,
			600,
			700,
		},
		blocking_angle = math.degrees_to_radians(50),
		attack_type_min_stagger_strength = {
			[attack_types.ranged] = 3,
			[attack_types.melee] = 10,
		},
		shield_sound_events = {
			foley_drastic_short = "foley_drastic_short_shield",
			run_foley = "run_foley_shield",
		},
		destroyed_settings = {
			sfx_event = "wwise/events/weapon/play_hit_indicator_vanguard_shield_break",
			stagger_duration = 2,
			stagger_strength_multiplier = 10,
			stagger_type = StaggerSettings.stagger_types.shield_broken,
		},
		max_damage_percentage = {
			0.5,
			0.5,
			0.5,
			0.5,
			0.5,
		},
		visability_groups = {
			{
				amount = 75,
			},
			{
				amount = 50,
			},
			{
				amount = 0,
			},
		},
	},
}

return shield_templates
