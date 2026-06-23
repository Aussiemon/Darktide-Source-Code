-- chunkname: @scripts/utilities/spawn_companions_from_talent.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local special_rules = SpecialRulesSettings.special_rules
local SpawnCompanionsFromTalent = {}

SpawnCompanionsFromTalent.cryptic_spawn_companions_from_talent = function (unit)
	local talent_extension = ScriptUnit.extension(unit, "talent_system")
	local companion_spawner_extension = ScriptUnit.extension(unit, "companion_spawner_system")
	local flying_companion_movement_extension, spawned_unit
	local special_rule_hacking = special_rules.cryptic_servo_skull_hack

	if talent_extension:has_special_rule(special_rule_hacking) then
		local add_companion_tag_extension = true

		spawned_unit = companion_spawner_extension:spawn_companion_unit(nil, nil, special_rule_hacking, add_companion_tag_extension)
		flying_companion_movement_extension = ScriptUnit.extension(spawned_unit, "flying_companion_movement_system")

		flying_companion_movement_extension:allow_fx_template(true)

		local blackboard = BLACKBOARDS[spawned_unit]
		local behavior_component = Blackboard.write_component(blackboard, "behavior")

		behavior_component.can_shoot = true

		if talent_extension:has_special_rule(special_rules.cryptic_servo_skull_improved) then
			local companion_buff_extension = ScriptUnit.has_extension(spawned_unit, "buff_system")

			if not companion_buff_extension then
				return
			end

			local fixed_t = FixedFrame.get_latest_fixed_time()
			local buff_name = CompanionServoSkullSettings.buffs.permanent_ability_buff_name

			companion_buff_extension:add_externally_controlled_buff(buff_name, fixed_t, "owner_unit", unit)
		end
	end

	local special_rule_medical = special_rules.cryptic_servo_skull_inject_ally

	if talent_extension:has_special_rule(special_rule_medical) then
		spawned_unit = companion_spawner_extension:spawn_companion_unit(nil, nil, special_rule_medical)

		local blackboard = BLACKBOARDS[spawned_unit]
		local behavior_component = Blackboard.write_component(blackboard, "behavior")

		behavior_component.can_shoot = false
	end

	local special_rule_burninating = special_rules.cryptic_servo_skull_flamethrower

	if talent_extension:has_special_rule(special_rule_burninating) then
		spawned_unit = companion_spawner_extension:spawn_companion_unit(nil, nil, special_rule_burninating)

		local blackboard = BLACKBOARDS[spawned_unit]
		local behavior_component = Blackboard.write_component(blackboard, "behavior")

		behavior_component.can_shoot = false
	end
end

return SpawnCompanionsFromTalent
