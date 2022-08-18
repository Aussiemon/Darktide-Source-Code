local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local NO_WEAPON_MODIFIERS = {}

local function _weapon_modifier_from_template(weapon_modifiers_or_nil, value)
	local weapon_modifiers = weapon_modifiers_or_nil or NO_WEAPON_MODIFIERS
	local new_list = {}

	for modifier_name, _ in pairs(weapon_modifiers) do
		local new_entry = {
			name = modifier_name
		}

		if value then
			new_entry.value = value
		end

		table.insert(new_list, new_entry)
	end

	return new_list
end

local function _weapon_trait_from_template(weapon_modifiers_or_nil, value)
	local weapon_modifiers = weapon_modifiers_or_nil or NO_WEAPON_MODIFIERS
	local new_list = {}

	for _, modifier_name in pairs(weapon_modifiers) do
		local new_entry = {
			rarity = 1,
			name = modifier_name
		}

		table.insert(new_list, new_entry)
	end

	return new_list
end

local function _apply_all_weapon_modifiers(local_player, weapon_template)
	local new_modifiers = {
		base_stats = _weapon_modifier_from_template(weapon_template.base_stats, 0.5),
		perks = _weapon_modifier_from_template(weapon_template.perks),
		traits = _weapon_trait_from_template(weapon_template.traits),
		overclocks = _weapon_modifier_from_template(weapon_template.overclocks)
	}
	local weapon_system = Managers.state.extension:system("weapon_system")

	weapon_system:debug_set_weapon_override(local_player, new_modifiers)
end

local PlayerManagerFixedTestify = {
	apply_weapon_progression_to_current_weapon_template = function (data, _, t)
		local player = data.player
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

		_apply_all_weapon_modifiers(player, weapon_template)
	end,
	remove_weapon_progression_from_current_weapon_template = function (data, _, t)
		local player = data.player
		local weapon_system = Managers.state.extension:system("weapon_system")
		local new_modifiers = {}

		weapon_system:debug_set_weapon_override(player, new_modifiers)
	end,
	reset_grenade_charges = function (data, _, t)
		local player = data.player
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local components = unit_data_extension._components
		local grenade_ability = components.grenade_ability

		for i = 1, #grenade_ability, 1 do
			grenade_ability[i].num_charges = 2
		end
	end,
	reset_magazine_ammo = function (data, _, t)
		local player = data.player
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local components = unit_data_extension._components
		local slot_secondary = components.slot_secondary

		for i = 1, #slot_secondary, 1 do
			if slot_secondary[i].max_ammunition_clip ~= 1 then
				slot_secondary[i].current_ammunition_clip = slot_secondary[i].max_ammunition_clip - 1
			end
		end
	end,
	trigger_animation_event = function (player_unit, animation_event)
		local animation_extension = ScriptUnit.extension(player_unit, "animation_system")

		animation_extension:anim_event(animation_event)
	end,
	wait_for_action_completed = function (data, _, t)
		local player = data.player
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		local queue = weapon_action_component.__data
		local queue_is_empty = true

		for i = 1, #queue, 1 do
			if queue[i].current_action_name ~= "none" then
				queue_is_empty = false
			end
		end

		if not queue_is_empty then
			return Testify.RETRY
		end
	end,
	wield_slot = function (data, _, t)
		local player_unit = data.player.player_unit
		local slot = data.slot
		local inventory_component = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot ~= slot then
			local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")

			PlayerUnitVisualLoadout.wield_slot(slot, player_unit, t)
		end
	end
}

return PlayerManagerFixedTestify
