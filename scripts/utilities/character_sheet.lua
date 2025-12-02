-- chunkname: @scripts/utilities/character_sheet.lua

local NodeLayout = require("scripts/ui/views/node_builder_view_base/utilities/node_layout")
local PlayerTalents = require("scripts/utilities/player_talents/player_talents")
local CharacterSheet = {}
local BASE_TALENT_STEP_COUNT = -1
local _fill_combat_ability_or_grenade_ability_or_coherency, _add_modifier
local talent_layouts = {
	"talent_layout_file_path",
}

table.insert(talent_layouts, "specialization_talent_layout_file_path")

local ALLOWED_MULTIPLE_OF = table.set({
	"stat",
	"default",
	"broker_stimm",
})

local function _nodes_by_talents(out_nodes, archetype)
	for layout_i = 1, #talent_layouts do
		local talent_layout_file_path = archetype[talent_layouts[layout_i]]

		if talent_layout_file_path then
			local talent_layout = require(talent_layout_file_path)
			local nodes = talent_layout.nodes

			for node_i = 1, #nodes do
				local node = nodes[node_i]
				local talent = node.talent

				if talent then
					local node_group_data = out_nodes[talent] or {
						node_type = nil,
					}

					out_nodes[talent] = node_group_data

					local node_type = node.type

					node_group_data.node_type = node_type
					node_group_data.icon = node.icon
				end
			end
		end
	end
end

local function _filter_non_base_talents(selected_talents, base_talents, out_selected_talents)
	local i = 0

	for talent_name, tier in pairs(selected_talents) do
		if not base_talents[talent_name] then
			i = i + 1
			out_selected_talents[i] = talent_name
		end
	end

	table.sort(out_selected_talents)

	return i
end

local function _handle_buff_tier(buff_tiers, selected_talents, talent_name, buff_template_name, handled_node_groups)
	if not handled_node_groups[talent_name] then
		handled_node_groups[talent_name] = true

		local talent_tier = selected_talents[talent_name]

		buff_tiers[buff_template_name] = (buff_tiers[buff_template_name] or 0) + talent_tier
	end
end

local function _by_furthest_from_start(previous_talent, talent_name, value, archetype)
	local previous_step_count = previous_talent and previous_talent.step_count or BASE_TALENT_STEP_COUNT
	local found, step_count, is_unique

	for layout_i = 1, #talent_layouts do
		local talent_layout_file_path = archetype[talent_layouts[layout_i]]

		if talent_layout_file_path then
			local talent_layout = require(talent_layout_file_path)

			found, step_count, is_unique = NodeLayout.num_steps_to_start_recursive(talent_layout, talent_name)

			if found then
				break
			end
		end
	end

	if not found then
		step_count = BASE_TALENT_STEP_COUNT + 1
	end

	if previous_step_count ~= BASE_TALENT_STEP_COUNT and step_count < previous_step_count then
		Log.info("CharacterSheet", "Selecting talent (%s) over (%s) due to higher prio. (%s > %s)", previous_talent.talent_name, talent_name, previous_step_count, step_count)

		return previous_talent
	elseif previous_talent then
		if step_count == previous_step_count and previous_talent.value ~= value then
			local pick_previous = talent_name > previous_talent.talent_name

			Log.error("CharacterSheet", "Found two selected talents using the same identifier with same distance from start (%s, %s). No way of deciding one over the other. Picked by name sorting: %s", talent_name, previous_talent.talent_name, pick_previous and previous_talent.talent_name or talent_name)

			if pick_previous then
				return previous_talent
			end
		else
			Log.info("CharacterSheet", "Selecting talent (%s) over (%s) due to higher prio. (%s > %s)", talent_name, previous_talent.talent_name, step_count, previous_step_count)
		end
	end

	return {
		is_base = false,
		talent_name = talent_name,
		value = value,
		step_count = step_count,
		is_unique = is_unique,
	}
end

local TEMP_TABLE_INDEX = 1
local _temp_table_pool = {}

local function _temp_table()
	local tbl = _temp_table_pool[TEMP_TABLE_INDEX] or {}

	_temp_table_pool[TEMP_TABLE_INDEX] = tbl
	TEMP_TABLE_INDEX = TEMP_TABLE_INDEX + 1

	table.clear(tbl)

	return tbl
end

local TRASH_TABLE = {}
local PASSIVE_IDENTIFIERS_FOUND = {}
local COHERENCY_IDENTIFIERS_FOUND = {}
local SPECIAL_RULE_IDENTIFIERS_FOUND = {}
local ABILITIES_FOUND = {}
local HANDLED_NODE_GROUPS = {}
local NODES_BY_TALENT = {}
local NON_BASE_TALENTS = {}

CharacterSheet.class_loadout = function (profile, destination, force_base_talents, optional_selected_talents)
	local ability, blitz, aura = destination.ability or TRASH_TABLE, destination.blitz or TRASH_TABLE, destination.aura or TRASH_TABLE
	local pocketable = destination.pocketable or TRASH_TABLE
	local passives, coherency_buffs, special_rules, buff_template_tiers, iconics, modifiers = destination.passives, destination.coherency, destination.special_rules, destination.buff_template_tiers, destination.iconics, destination.modifiers

	table.clear(ability)
	table.clear(blitz)
	table.clear(pocketable)
	table.clear(aura)
	table.clear(PASSIVE_IDENTIFIERS_FOUND)
	table.clear(COHERENCY_IDENTIFIERS_FOUND)
	table.clear(SPECIAL_RULE_IDENTIFIERS_FOUND)
	table.clear(ABILITIES_FOUND)
	table.clear(HANDLED_NODE_GROUPS)
	table.clear(NODES_BY_TALENT)
	table.clear(NON_BASE_TALENTS)

	TEMP_TABLE_INDEX = 1

	if not passives and coherency_buffs then
		-- Nothing
	end

	if passives then
		table.clear(passives)
	end

	if coherency_buffs then
		table.clear(coherency_buffs)
	end

	if special_rules then
		table.clear(special_rules)
	end

	if buff_template_tiers then
		table.clear(buff_template_tiers)
	end

	if iconics then
		table.clear(iconics)
	end

	if modifiers then
		table.clear(modifiers)
	end

	local combat_ability, grenade_ability, pocketable_ability
	local found_base_combat_ability, found_base_grenade_ability, found_base_coherency_talent = false, false, false
	local found_base_pocketable_ability = false
	local archetype = profile.archetype
	local archetype_talents = archetype.talents
	local base_talents = PlayerTalents.base_talents(archetype, not force_base_talents and optional_selected_talents)
	local base_talent_names = table.keys(base_talents)

	table.sort(base_talent_names)

	for i = 1, #base_talent_names do
		local talent_name = base_talent_names[i]
		local talent = archetype_talents[talent_name]

		do
			local player_ability = talent.player_ability

			if player_ability and player_ability.ability_type == "combat_ability" then
				if found_base_combat_ability then
					Log.error("CharacterSheet", "Found multiple combat abilities in base_talents, one will be chosen at random.")
				else
					found_base_combat_ability = true

					_fill_combat_ability_or_grenade_ability_or_coherency(ability, talent, talent.large_icon or talent.icon)

					combat_ability = player_ability.ability
				end
			elseif player_ability and player_ability.ability_type == "grenade_ability" then
				if found_base_grenade_ability then
					Log.error("CharacterSheet", "Found multiple grenade abilities in base_talents, one will be chosen at random.")
				else
					found_base_grenade_ability = true

					_fill_combat_ability_or_grenade_ability_or_coherency(blitz, talent, talent.icon)

					grenade_ability = player_ability.ability
				end
			elseif player_ability and player_ability.ability_type == "pocketable_ability" then
				if found_base_pocketable_ability then
					Log.error("CharacterSheet", "Found multiple pocketable abilities in base_talents, one will be chosen at random.")
				else
					found_base_pocketable_ability = true

					_fill_combat_ability_or_grenade_ability_or_coherency(pocketable, talent, talent.icon)

					pocketable_ability = player_ability.ability
				end
			elseif talent.coherency then
				if found_base_coherency_talent then
					Log.error("CharacterSheet", "Found multiple talents with coherency in base_talents, one will be chosen as aura at random.")
				else
					found_base_coherency_talent = true

					_fill_combat_ability_or_grenade_ability_or_coherency(aura, talent, talent.icon)
				end
			elseif iconics then
				iconics[#iconics + 1] = talent
			end
		end

		if passives then
			local passive = talent.passive

			if passive then
				local identifier = passive.identifier

				if type(identifier) == "table" then
					local buff_template_names = passive.buff_template_name

					for jj = 1, #identifier do
						local sub_identifier = identifier[jj]

						PASSIVE_IDENTIFIERS_FOUND[sub_identifier] = {
							is_base = true,
							talent_name = talent_name,
							value = buff_template_names[jj],
							step_count = BASE_TALENT_STEP_COUNT,
						}
					end
				else
					local buff_template_name = passive.buff_template_name

					PASSIVE_IDENTIFIERS_FOUND[identifier] = {
						is_base = true,
						talent_name = talent_name,
						value = buff_template_name,
						step_count = BASE_TALENT_STEP_COUNT,
					}
				end
			end
		end

		if coherency_buffs then
			local coherency = talent.coherency

			if coherency then
				local identifier = coherency.identifier
				local buff_template_name = coherency.buff_template_name

				COHERENCY_IDENTIFIERS_FOUND[identifier] = {
					is_base = true,
					talent_name = talent_name,
					value = buff_template_name,
					step_count = BASE_TALENT_STEP_COUNT,
				}
			end
		end

		if special_rules then
			local special_rule = talent.special_rule

			if special_rule then
				local identifier = special_rule.identifier
				local special_rule_name = special_rule.special_rule_name

				if type(identifier) == "table" then
					for jj = 1, #identifier do
						local sub_identifier = identifier[jj]
						local sub_special_rule_name = special_rule_name[jj]

						SPECIAL_RULE_IDENTIFIERS_FOUND[sub_identifier] = {
							is_base = true,
							talent_name = talent_name,
							value = sub_special_rule_name,
							step_count = BASE_TALENT_STEP_COUNT,
						}
					end
				else
					SPECIAL_RULE_IDENTIFIERS_FOUND[identifier] = {
						is_base = true,
						talent_name = talent_name,
						value = special_rule_name,
						step_count = BASE_TALENT_STEP_COUNT,
					}
				end
			end
		end
	end

	if optional_selected_talents and not force_base_talents then
		_nodes_by_talents(NODES_BY_TALENT, archetype)

		local found_combat_ability, found_grenade_ability, found_coherency_talent = false, false, false
		local found_pocketable_ability = false
		local num_talents = _filter_non_base_talents(optional_selected_talents, base_talents, NON_BASE_TALENTS)

		for i = 1, num_talents do
			local talent_name = NON_BASE_TALENTS[i]
			local talent = archetype_talents[talent_name]

			if talent then
				if passives then
					local passive = talent.passive

					if passive then
						local identifier = passive.identifier

						if type(identifier) == "table" then
							local buff_template_names = passive.buff_template_name

							for jj = 1, #identifier do
								local buff_template_name = buff_template_names[jj]
								local sub_identifier = identifier[jj]
								local prev_best_identifier = PASSIVE_IDENTIFIERS_FOUND[identifier]

								PASSIVE_IDENTIFIERS_FOUND[sub_identifier] = _by_furthest_from_start(prev_best_identifier, talent_name, buff_template_name, archetype)
							end
						else
							local buff_template_name = passive.buff_template_name
							local prev_best_identifier = PASSIVE_IDENTIFIERS_FOUND[identifier]

							PASSIVE_IDENTIFIERS_FOUND[identifier] = _by_furthest_from_start(prev_best_identifier, talent_name, buff_template_name, archetype)
						end
					end
				end

				if coherency_buffs then
					local coherency = talent.coherency

					if coherency then
						local buff_template_name = coherency.buff_template_name

						if buff_template_name then
							local identifier = coherency.identifier
							local prev_best_identifier = COHERENCY_IDENTIFIERS_FOUND[identifier]

							COHERENCY_IDENTIFIERS_FOUND[identifier] = _by_furthest_from_start(prev_best_identifier, talent_name, buff_template_name, archetype)
						end
					end
				end

				if special_rules then
					local special_rule = talent.special_rule

					if special_rule then
						local identifier = special_rule.identifier
						local special_rule_name = special_rule.special_rule_name

						if type(identifier) == "table" then
							for jj = 1, #identifier do
								local sub_special_rule_name = special_rule_name[jj]
								local sub_identifier = identifier[jj]
								local prev_best_identifier = SPECIAL_RULE_IDENTIFIERS_FOUND[sub_identifier]

								SPECIAL_RULE_IDENTIFIERS_FOUND[sub_identifier] = _by_furthest_from_start(prev_best_identifier, talent_name, sub_special_rule_name, archetype)
							end
						else
							local prev_best_identifier = SPECIAL_RULE_IDENTIFIERS_FOUND[identifier]

							SPECIAL_RULE_IDENTIFIERS_FOUND[identifier] = _by_furthest_from_start(prev_best_identifier, talent_name, special_rule_name, archetype)
						end
					end
				end

				local player_ability = talent.player_ability

				if player_ability then
					if player_ability.ability_type == "combat_ability" then
						local previous_ability = ABILITIES_FOUND.ability
						local chosen_ability = _by_furthest_from_start(previous_ability, talent_name, talent, archetype)

						ABILITIES_FOUND.ability = chosen_ability
						combat_ability = chosen_ability.value.player_ability.ability

						_add_modifier(modifiers, "ability", chosen_ability.value)
					elseif player_ability.ability_type == "grenade_ability" then
						local previous_ability = ABILITIES_FOUND.blitz
						local chosen_ability = _by_furthest_from_start(previous_ability, talent_name, talent, archetype)

						ABILITIES_FOUND.blitz = chosen_ability
						grenade_ability = chosen_ability.value.player_ability.ability

						_add_modifier(modifiers, "blitz", chosen_ability.value)
					elseif player_ability.ability_type == "pocketable_ability" then
						local previous_ability = ABILITIES_FOUND.pocketable
						local chosen_ability = _by_furthest_from_start(previous_ability, talent_name, talent, archetype)

						ABILITIES_FOUND.pocketable = chosen_ability
						pocketable_ability = chosen_ability.value.player_ability.ability

						_add_modifier(modifiers, "pocketable", chosen_ability.value)
					else
						Log.error("CharacterSheet", "ability_type(%q) can't handle it.", player_ability.ability_type)
					end
				elseif talent.coherency then
					ABILITIES_FOUND.aura = _by_furthest_from_start(ABILITIES_FOUND.aura, talent_name, talent, archetype)
				end
			end
		end
	end

	for _, data in pairs(PASSIVE_IDENTIFIERS_FOUND) do
		local buff_template_name = data.value

		if buff_template_name then
			local talent_name = data.talent_name

			passives[talent_name] = passives[talent_name] or _temp_table()

			table.insert(passives[talent_name], buff_template_name)
			_handle_buff_tier(buff_template_tiers, data.is_base and base_talents or optional_selected_talents, talent_name, buff_template_name, HANDLED_NODE_GROUPS)
		end
	end

	for _, data in pairs(COHERENCY_IDENTIFIERS_FOUND) do
		local buff_template_name = data.value

		if buff_template_name then
			local talent_name = data.talent_name

			coherency_buffs[talent_name] = coherency_buffs[talent_name] or _temp_table()

			table.insert(coherency_buffs[talent_name], buff_template_name)
			_handle_buff_tier(buff_template_tiers, data.is_base and base_talents or optional_selected_talents, talent_name, buff_template_name, HANDLED_NODE_GROUPS)
		end
	end

	for identifier, data in pairs(SPECIAL_RULE_IDENTIFIERS_FOUND) do
		local special_rule_name = data.value

		special_rules[identifier] = special_rule_name
	end

	local write_out_abilities = {
		ability = ability,
		blitz = blitz,
		aura = aura,
	}

	write_out_abilities.pocketable = pocketable

	for ability_type, write_out_data in pairs(write_out_abilities) do
		local ability_data = ABILITIES_FOUND[ability_type]

		if ability_data then
			local talent = ability_data.value
			local talent_name = ability_data.talent_name
			local node_data = NODES_BY_TALENT[talent_name]

			_fill_combat_ability_or_grenade_ability_or_coherency(write_out_data, talent, node_data.icon or talent.icon)
		end
	end

	destination.combat_ability = combat_ability
	destination.grenade_ability = grenade_ability
	destination.pocketable_ability = pocketable_ability

	if modifiers then
		for talent_type, talents_data in pairs(modifiers) do
			local current_index = 1

			while current_index <= #talents_data do
				local talent_data = talents_data[current_index]

				for f = current_index + 1, #talents_data do
					local checked_talent_data = talents_data[f]

					if talent_data.display_name == checked_talent_data then
						table.remove(talents_data, f)
					end
				end

				if talent_data.display_name == destination[talent_type].talent.display_name then
					table.remove(talents_data, current_index)
				end

				current_index = current_index + 1
			end
		end
	end
end

CharacterSheet.convert_selected_nodes_to_selected_talents = function (archetype, selected_nodes)
	local out_talents = {}

	for layout_i = 1, #talent_layouts do
		local talent_layout_file_path = archetype[talent_layouts[layout_i]]

		if talent_layout_file_path then
			local talent_layout = require(talent_layout_file_path)
			local nodes = talent_layout.nodes

			for node_i = 1, #nodes do
				local node = nodes[node_i]
				local widget_name = node.widget_name

				if selected_nodes[widget_name] and node.talent then
					out_talents[node.talent] = (out_talents[node.talent] or 0) + selected_nodes[widget_name]
				end
			end
		end
	end

	return out_talents
end

function _fill_combat_ability_or_grenade_ability_or_coherency(dest, talent, icon)
	dest.talent = talent
	dest.icon = icon or NodeLayout.fallback_icon()
end

function _add_modifier(dest, name, talent)
	if dest then
		dest[name] = dest[name] or {}

		table.insert(dest[name], talent)
	end
end

return CharacterSheet
