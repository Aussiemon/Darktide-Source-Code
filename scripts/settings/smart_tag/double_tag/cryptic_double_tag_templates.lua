-- chunkname: @scripts/settings/smart_tag/double_tag/cryptic_double_tag_templates.lua

local CompanionServoSkullAbility = require("scripts/utilities/companion/companion_servo_skull_ability")
local FixedFrame = require("scripts/utilities/fixed_frame")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Vo = require("scripts/utilities/vo")
local VoQueryConstants = require("scripts/settings/dialogue/vo_query_constants")
local special_rules = SpecialRulesSettings.special_rules
local vo_concepts = VoQueryConstants.concepts
local templates = {
	hacking_over_here_companion = {
		can_override = true,
		group = "hacking",
		is_cancelable = false,
		lifetime = 10,
		override_ui_interaction_type = "hacking_companion",
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		start = function (tag, tagger_unit)
			if not tag._is_server then
				return
			end

			local companion_spawner_extension = ScriptUnit.extension(tagger_unit, "companion_spawner_system")
			local ability_extension = ScriptUnit.extension(tagger_unit, "ability_system")
			local target_unit = tag:target_unit()
			local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_hack)

			if CompanionServoSkullAbility.validate_target_func_hacking_ability(target_unit, ability_extension, companion_unit) then
				CompanionServoSkullAbility.start_hacking_ability(companion_unit, target_unit, ability_extension)

				tag.started_hacking = true
			else
				tag.started_hacking = false
			end
		end,
		update = function (tag)
			if not tag._is_server then
				return
			end

			if not tag.started_hacking then
				local tagger_unit = tag:tagger_unit()
				local companion_spawner_extension = ScriptUnit.has_extension(tagger_unit, "companion_spawner_system")
				local companion_unit = companion_spawner_extension and companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_hack)

				if not ALIVE[companion_unit] then
					return
				end

				local ability_extension = ScriptUnit.extension(tagger_unit, "ability_system")
				local target_unit = tag:target_unit()

				if CompanionServoSkullAbility.validate_target_func_hacking_ability(target_unit, ability_extension, companion_unit) then
					CompanionServoSkullAbility.start_hacking_ability(companion_unit, target_unit, ability_extension)

					tag.started_hacking = true
				end
			end
		end,
		stop = function (tag)
			if not tag._is_server then
				return
			end
		end,
	},
	servo_skull_enemy_companion_target = {
		can_override = true,
		display_name = "loc_smart_tag_type_threat",
		group = "double_tag",
		lifetime = 25,
		marker_type = "unit_threat_companion",
		target_unit_outline = "adamant_smart_tag",
		voice_tag_concept = vo_concepts.on_demand_vo_tag_enemy,
		sound_enter_tagger = UISoundEvents.smart_tag_location_threat_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_threat_enter_others,
		start = function (tag, tagger_unit)
			if not tag._is_server then
				return
			end

			local t = FixedFrame.get_latest_fixed_time()

			tag.start_time = t

			local vo_tag = "ability_targeting_a"
			local currently_playing = Vo.is_currently_playing_dialogue(tagger_unit)

			if currently_playing then
				Vo.set_unit_vo_memory(tagger_unit, "user_memory", "command_triggered", "timeset")
			else
				Vo.play_combat_ability_event(tagger_unit, vo_tag)
			end

			local companion_spawner_extension = ScriptUnit.extension(tagger_unit, "companion_spawner_system")
			local ability_extension = ScriptUnit.extension(tagger_unit, "ability_system")
			local target_unit = tag:target_unit()
			local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_hack)
			local can_shoot, prevent_shooting_activation_on_fail = CompanionServoSkullAbility.validate_target_func_shooting_ability(target_unit, ability_extension, companion_unit)

			if can_shoot then
				CompanionServoSkullAbility.start_shooting_ability(companion_unit, target_unit, ability_extension)

				tag.started_shooting = true
			elseif prevent_shooting_activation_on_fail then
				tag.started_shooting = true
			else
				tag.started_shooting = false
			end
		end,
		update = function (tag)
			if not tag._is_server then
				return
			end

			if not tag.started_shooting then
				local tagger_unit = tag:tagger_unit()
				local companion_spawner_extension = ScriptUnit.has_extension(tagger_unit, "companion_spawner_system")
				local companion_unit = companion_spawner_extension and companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_hack)

				if not ALIVE[companion_unit] then
					return
				end

				local ability_extension = ScriptUnit.extension(tagger_unit, "ability_system")
				local target_unit = tag:target_unit()

				if CompanionServoSkullAbility.validate_target_func_shooting_ability(target_unit, ability_extension, companion_unit) then
					CompanionServoSkullAbility.start_shooting_ability(companion_unit, target_unit, ability_extension)

					tag.started_shooting = true
				end
			end
		end,
		stop = function (tag)
			if not tag._is_server then
				return
			end
		end,
	},
}

return templates
