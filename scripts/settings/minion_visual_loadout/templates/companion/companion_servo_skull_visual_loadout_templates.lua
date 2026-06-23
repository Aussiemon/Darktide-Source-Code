-- chunkname: @scripts/settings/minion_visual_loadout/templates/companion/companion_servo_skull_visual_loadout_templates.lua

local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSettings.special_rules
local templates = {
	companion_servo_skull = {},
}

local function _is_variant(wanted_special_rule)
	return function (owner_unit, special_rule)
		return wanted_special_rule == special_rule
	end
end

local hacking = {
	availability_func = _is_variant(special_rules.cryptic_servo_skull_hack),
	slots = {
		slot_weapon = {
			is_weapon = true,
			use_outline = false,
			items = {
				"content/items/characters/companion/companion_servo_skull/attachments/laspistol_functional",
			},
		},
	},
}
local medical = {
	availability_func = _is_variant(special_rules.cryptic_servo_skull_inject_ally),
	slots = {
		slot_full = {
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/characters/companion/companion_servo_skull/gear_full/cryptic_servo_skull_medicae_var_01",
			},
		},
	},
}
local flamethrower = {
	availability_func = _is_variant(special_rules.cryptic_servo_skull_flamethrower),
	slots = {
		slot_full = {
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/characters/companion/companion_servo_skull/gear_full/cryptic_servo_skull_flamethrower_var_01",
			},
		},
	},
}

templates.companion_servo_skull.default = {
	hacking,
	medical,
	flamethrower,
}

return templates
