-- chunkname: @scripts/settings/ability/player_abilities/abilities/broker_abilities.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local talent_settings = TalentSettings.broker
local abilities = {
	broker_ability_focus = {
		ability_group = "broker_focus_stance",
		ability_template = "broker_focus",
		ability_type = "combat_ability",
		hud_icon = "content/ui/textures/icons/abilities/hud/broker/broker_ability_focus",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		required_weapon_type = "ranged",
		ability_template_tweak_data = {
			buff_to_add = "broker_focus_stance",
		},
		cooldown = talent_settings.combat_ability.focus.cooldown,
		max_charges = talent_settings.combat_ability.focus.max_charges,
		archetypes = {
			"broker",
		},
		pause_cooldown_settings = {
			duration_tracking_buff = "broker_focus_stance",
			pause_fulfilled_func = function (context)
				local buff_extension = context.buff_extension

				if buff_extension:has_buff_using_buff_template("broker_focus_stance") then
					return false
				end

				return true
			end,
		},
	},
	broker_ability_focus_improved = {
		ability_group = "broker_focus_stance",
		ability_template = "broker_focus",
		ability_type = "combat_ability",
		hud_icon = "content/ui/textures/icons/abilities/hud/broker/broker_ability_focus_improved",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		required_weapon_type = "ranged",
		ability_template_tweak_data = {
			buff_to_add = "broker_focus_stance_improved",
		},
		cooldown = talent_settings.combat_ability.focus.cooldown,
		max_charges = talent_settings.combat_ability.focus.max_charges,
		archetypes = {
			"broker",
		},
		pause_cooldown_settings = {
			duration_tracking_buff = "broker_focus_stance_improved",
			pause_fulfilled_func = function (context)
				local buff_extension = context.buff_extension

				if buff_extension:has_buff_using_buff_template("broker_focus_stance_improved") then
					return false
				end

				return true
			end,
		},
	},
	broker_ability_punk_rage = {
		ability_group = "broker_punk_rage_stance",
		ability_template = "broker_punk_rage",
		ability_type = "combat_ability",
		hud_icon = "content/ui/textures/icons/abilities/hud/broker/broker_ability_punk_rage",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		required_weapon_type = "melee",
		ability_template_tweak_data = {
			anim = "ability_buff",
			buff_to_add = "broker_punk_rage_stance",
		},
		cooldown = talent_settings.combat_ability.punk_rage.cooldown,
		max_charges = talent_settings.combat_ability.punk_rage.max_charges,
		archetypes = {
			"broker",
		},
		pause_cooldown_settings = {
			duration_tracking_buff = "broker_punk_rage_stance",
			pause_fulfilled_func = function (context)
				local buff_extension = context.buff_extension

				if buff_extension:has_buff_using_buff_template("broker_punk_rage_stance") then
					return false
				end

				return true
			end,
		},
	},
	broker_ability_stimm_field = {
		ability_group = "broker_stimm_field",
		ability_type = "combat_ability",
		can_be_previously_wielded_to = false,
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/broker/broker_ability_stimm_field",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/broker_stimm_field_crate",
		max_charges = talent_settings.combat_ability.stimm_field.max_charges,
		cooldown = talent_settings.combat_ability.stimm_field.cooldown,
		archetypes = {
			"broker",
		},
		pause_cooldown_settings = {
			manual_pause = true,
			pause_fulfilled_func = function (context, component)
				if not context.is_server then
					return not component.cooldown_paused
				end

				local proximity_system = Managers.state.extension:system("proximity_system")
				local proximity_units = proximity_system:proximity_units_by_owner(context.unit)

				if proximity_units then
					for i = 1, #proximity_units do
						local proximity_extension = ScriptUnit.extension(proximity_units[i], "proximity_system")
						local has_job, job_instance = proximity_extension:has_job()

						if has_job and job_instance.__class_name == "ProximityBrokerStimmField" then
							return false
						end
					end
				end

				return true
			end,
		},
	},
	broker_ability_syringe = {
		ability_group = "broker_syringe",
		ability_type = "pocketable_ability",
		can_be_previously_wielded_to = false,
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/psyker/psyker_ability_warp_barrier",
		icon = "content/ui/materials/icons/abilities/ultimate/default",
		inventory_item_name = "content/items/pocketable/syringe_broker_pocketable",
		max_charges = 1,
		stat_buff = "ability_extra_charges",
		cooldown = {
			max = 75,
			min = 15,
		},
		cooldown_lerp_func = function (profile, min, max, override_viscosity)
			local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
			local used_points, max_points = TalentLayoutParser.profile_specialization_node_points_spent(profile)

			if used_points <= 1 then
				override_viscosity = nil

				if used_points <= 0 then
					min = 0
				end
			end

			local viscosity = override_viscosity

			viscosity = viscosity or math.clamp01((used_points - 1) / (max_points - 1))

			return math.ceil(math.lerp(min, max, viscosity))
		end,
		archetypes = {
			"broker",
		},
		pause_cooldown_settings = {
			pause_fulfilled_func = function (context)
				local buff_extension = context.buff_extension

				if buff_extension:has_buff_using_buff_template("syringe_broker_buff") then
					return false
				end

				return true
			end,
		},
	},
	broker_flash_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_quick_flash",
		stat_buff = "extra_max_amount_of_grenades",
		max_charges = talent_settings.blitz.flash_grenade.max_charges_default,
		archetypes = {
			"broker",
		},
	},
	broker_flash_grenade_improved = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_quick_flash",
		stat_buff = "extra_max_amount_of_grenades",
		max_charges = talent_settings.blitz.flash_grenade.max_charges_improved,
		archetypes = {
			"broker",
		},
	},
	broker_tox_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_tox",
		stat_buff = "extra_max_amount_of_grenades",
		max_charges = talent_settings.blitz.tox_grenade.max_charges,
		archetypes = {
			"broker",
		},
	},
	broker_missile_launcher = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/ranged/missile_launcher",
		stat_buff = "extra_max_amount_of_grenades",
		max_charges = talent_settings.blitz.missile_launcher.max_charges,
		archetypes = {
			"broker",
		},
	},
}

return abilities
