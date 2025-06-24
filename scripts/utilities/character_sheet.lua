-- chunkname: @scripts/utilities/character_sheet.lua

local NodeLayout = require("scripts/ui/views/node_builder_view_base/utilities/node_layout")
local CharacterSheet = {}
local _fill_ability_blitz_or_aura, _add_modifier
local TRASH_TABLE = {}
local PASSIVES_BEST_IDENTIFIER = {}
local COHERENCY_BEST_IDENTIFIER = {}
local SPECIAL_RULE_BEST_IDENTIFIER = {}

CharacterSheet.class_loadout = function (profile, destination, force_base_talents, optional_selected_nodes)
	local ability, blitz, aura = destination.ability or TRASH_TABLE, destination.blitz or TRASH_TABLE, destination.aura or TRASH_TABLE
	local passives, coherency_buffs, special_rules, buff_template_tiers, iconics, modifiers = destination.passives, destination.coherency, destination.special_rules, destination.buff_template_tiers, destination.iconics, destination.modifiers

	table.clear(ability)
	table.clear(blitz)
	table.clear(aura)
	table.clear(PASSIVES_BEST_IDENTIFIER)
	table.clear(COHERENCY_BEST_IDENTIFIER)
	table.clear(SPECIAL_RULE_BEST_IDENTIFIER)

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

	local archetype = profile.archetype
	local archetype_talents = archetype.talents
	local talent_layout_file_path = archetype.talent_layout_file_path
	local talent_layout = require(talent_layout_file_path)
	local nodes = talent_layout.nodes
	local selected_nodes = optional_selected_nodes or profile.selected_nodes
	local combat_ability, grenade_ability
	local found_base_ability, found_base_blitz, found_base_aura = false, false, false
	local base_talents = archetype.base_talents

	for talent_name, selected_points in pairs(base_talents) do
		local talent = archetype_talents[talent_name]

		do
			local player_ability = talent.player_ability

			if player_ability and player_ability.ability_type == "combat_ability" then
				if found_base_ability then
					Log.error("CharacterSheet", "Found multiple combat abilities in base_talents, one will be chosen at random.")
				else
					found_base_ability = true

					_fill_ability_blitz_or_aura(ability, talent, talent.large_icon)

					combat_ability = player_ability.ability
				end
			elseif player_ability and player_ability.ability_type == "grenade_ability" then
				if found_base_blitz then
					Log.error("CharacterSheet", "Found multiple grenade abilities in base_talents, one will be chosen at random.")
				else
					found_base_blitz = true

					_fill_ability_blitz_or_aura(blitz, talent, talent.icon)

					grenade_ability = player_ability.ability
				end
			elseif talent.coherency then
				if found_base_aura then
					Log.error("CharacterSheet", "Found multiple talents with coherency in base_talents, one will be chosen as aura at random.")
				else
					found_base_aura = true

					_fill_ability_blitz_or_aura(aura, talent, talent.icon)
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

						if PASSIVES_BEST_IDENTIFIER[sub_identifier] then
							Log.error("CharacterSheet", "Multiple passives with the same identifier(%q) in base_talents for archetype(%q). Will choose one at random.", identifier, archetype.name)
						else
							PASSIVES_BEST_IDENTIFIER[sub_identifier] = -1

							local buff_template_name = buff_template_names[jj]

							passives[sub_identifier] = buff_template_name
							buff_template_tiers[buff_template_name] = selected_points
						end
					end
				elseif PASSIVES_BEST_IDENTIFIER[identifier] then
					Log.error("CharacterSheet", "Multiple passives with the same identifier(%q) in base_talents for archetype(%q). Will choose one at random.", identifier, archetype.name)
				else
					PASSIVES_BEST_IDENTIFIER[identifier] = -1

					local buff_template_name = passive.buff_template_name

					passives[identifier] = buff_template_name
					buff_template_tiers[buff_template_name] = selected_points
				end
			end
		end

		if coherency_buffs then
			local coherency = talent.coherency

			if coherency then
				local identifier = coherency.identifier

				if COHERENCY_BEST_IDENTIFIER[identifier] then
					Log.error("CharacterSheet", "Multiple coherency with the same identifier(%q) in base_talents for archetype(%q). Will choose one at random.", identifier, archetype.name)
				else
					COHERENCY_BEST_IDENTIFIER[identifier] = -1

					local buff_template_name = coherency.buff_template_name

					coherency_buffs[identifier] = buff_template_name
					buff_template_tiers[buff_template_name] = selected_points
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
						local sub_identifier = identifier[jj]
						local sub_special_rule_name = special_rule_name[jj]

						if SPECIAL_RULE_BEST_IDENTIFIER[sub_identifier] then
							Log.error("CharacterSheet", "Multiple special_rule with the same identifier(%q) in base_talents for archetype(%q). Will choose one at random.", sub_identifier, archetype.name)
						else
							SPECIAL_RULE_BEST_IDENTIFIER[sub_identifier] = -1
							special_rules[sub_identifier] = sub_special_rule_name
						end
					end
				elseif SPECIAL_RULE_BEST_IDENTIFIER[identifier] then
					Log.error("CharacterSheet", "Multiple special_rule with the same identifier(%q) in base_talents for archetype(%q). Will choose one at random.", identifier, archetype.name)
				else
					SPECIAL_RULE_BEST_IDENTIFIER[identifier] = -1
					special_rules[identifier] = special_rule_name
				end
			end
		end
	end

	if not force_base_talents then
		local combat_ability_step_count = -1
		local grenade_ability_step_count = -1
		local found_ability, found_blitz, found_aura = false, false, false
		local num_nodes = #nodes

		for ii = 1, num_nodes do
			local points_in_node = selected_nodes[tostring(ii)]

			if points_in_node then
				local node = nodes[ii]
				local node_type = node.type

				if node_type ~= "start" then
					local talent_name = node.talent
					local talent = archetype_talents[talent_name]
					local found, step_count = NodeLayout.num_steps_to_start_recursive(talent_layout, node)

					if node_type == "ability" then
						if found_ability then
							Log.error("CharacterSheet", "Found multiple selected combat abilities in selected_nodes.")
						else
							found_ability = true

							_fill_ability_blitz_or_aura(ability, talent, node.icon)
						end
					elseif node_type == "tactical" then
						if found_blitz then
							Log.error("CharacterSheet", "Found multiple selected blitz in selected_nodes.")
						else
							found_blitz = true

							_fill_ability_blitz_or_aura(blitz, talent, node.icon)
						end
					elseif node_type == "aura" then
						if found_aura then
							Log.error("CharacterSheet", "Found multiple selected auras in selected_nodes.")
						else
							found_aura = true

							_fill_ability_blitz_or_aura(aura, talent, node.icon)
						end
					end

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
										local prev_best_identifier = PASSIVES_BEST_IDENTIFIER[identifier]

										if not prev_best_identifier or prev_best_identifier < step_count then
											PASSIVES_BEST_IDENTIFIER[sub_identifier] = step_count
											passives[sub_identifier] = buff_template_name
											buff_template_tiers[buff_template_name] = points_in_node
										else
											Log.error("CharacterSheet", "skipping %q prev(%i) node(%i)", sub_identifier, prev_best_identifier, step_count)
										end
									end
								else
									local buff_template_name = passive.buff_template_name
									local prev_best_identifier = PASSIVES_BEST_IDENTIFIER[identifier]

									if not prev_best_identifier or prev_best_identifier < step_count then
										PASSIVES_BEST_IDENTIFIER[identifier] = step_count
										passives[identifier] = buff_template_name
										buff_template_tiers[buff_template_name] = points_in_node
									else
										Log.error("CharacterSheet", "skipping %q prev(%i) node(%i)", identifier, prev_best_identifier, step_count)
									end
								end
							end
						end

						if coherency_buffs then
							local coherency = talent.coherency

							if coherency then
								local identifier = coherency.identifier
								local prev_best_identifier = COHERENCY_BEST_IDENTIFIER[identifier]

								if not prev_best_identifier or prev_best_identifier < step_count then
									COHERENCY_BEST_IDENTIFIER[identifier] = step_count

									local buff_template_name = coherency.buff_template_name

									if buff_template_name then
										coherency_buffs[identifier] = buff_template_name
										buff_template_tiers[buff_template_name] = points_in_node
									end
								else
									Log.error("CharacterSheet", "skipping %q prev(%i) node(%i)", identifier, prev_best_identifier, step_count)
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
										local sub_identifier = identifier[jj]
										local prev_best_identifier = SPECIAL_RULE_BEST_IDENTIFIER[sub_identifier]

										if not prev_best_identifier or prev_best_identifier < step_count then
											SPECIAL_RULE_BEST_IDENTIFIER[sub_identifier] = step_count
											special_rules[sub_identifier] = special_rule_name[jj]
										else
											Log.error("CharacterSheet", "skipping %q prev(%i) node(%i)", sub_identifier, prev_best_identifier, step_count)
										end
									end
								else
									local prev_best_identifier = SPECIAL_RULE_BEST_IDENTIFIER[identifier]

									if not prev_best_identifier or prev_best_identifier < step_count then
										SPECIAL_RULE_BEST_IDENTIFIER[identifier] = step_count
										special_rules[identifier] = special_rule_name
									else
										Log.error("CharacterSheet", "skipping %q prev(%i) node(%i)", identifier, prev_best_identifier, step_count)
									end
								end
							end
						end

						local player_ability = talent.player_ability

						if player_ability then
							if player_ability.ability_type == "combat_ability" then
								if combat_ability_step_count < step_count then
									combat_ability_step_count = step_count
									combat_ability = player_ability.ability

									_add_modifier(modifiers, "ability", talent)
								else
									Log.error("CharacterSheet", "skipping combat ability(%q) for (%q). prev_step_count(%i) step_count(%i)", player_ability.ability.name, combat_ability.name, combat_ability_step_count, step_count)
								end
							elseif player_ability.ability_type == "grenade_ability" then
								if grenade_ability_step_count < step_count then
									grenade_ability_step_count = step_count
									grenade_ability = player_ability.ability

									_add_modifier(modifiers, "blitz", talent)
								else
									Log.error("CharacterSheet", "skipping combat ability(%q) for (%q). prev_step_count(%i) step_count(%i)", player_ability.ability.name, grenade_ability.name, grenade_ability_step_count, step_count)
								end
							else
								Log.error("CharacterSheet", "ability_type(%q) can't handle it.", player_ability.ability_type)
							end
						end
					end
				end
			end
		end
	end

	destination.combat_ability = combat_ability
	destination.grenade_ability = grenade_ability

	if modifiers then
		for talent_type, talents_data in pairs(modifiers) do
			local table_looped = false
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

CharacterSheet.convert_talents_to_node_layout = function (profile, selected_talents)
	if not profile or not selected_talents then
		return nil
	end

	local archetype = profile.archetype
	local talent_layout_file_path = archetype.talent_layout_file_path
	local talent_layout = require(talent_layout_file_path)
	local nodes = talent_layout.nodes
	local found_overrides = false
	local selected_nodes = {}
	local num_nodes = #nodes

	for ii = 1, num_nodes do
		local node = nodes[ii]
		local talent_name = node.talent
		local points_in_talent = selected_talents[talent_name]

		if points_in_talent then
			selected_nodes[tostring(ii)] = points_in_talent
			found_overrides = true
		end
	end

	return found_overrides and selected_nodes
end

function _fill_ability_blitz_or_aura(dest, talent, icon)
	dest.talent = talent
	dest.icon = icon
end

function _add_modifier(dest, name, talent)
	if dest then
		dest[name] = dest[name] or {}

		table.insert(dest[name], talent)
	end
end

return CharacterSheet
