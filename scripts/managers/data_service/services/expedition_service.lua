-- chunkname: @scripts/managers/data_service/services/expedition_service.lua

local Promise = require("scripts/foundation/utilities/promise")
local Danger = require("scripts/utilities/danger")
local QLExpressionParser = require("scripts/utilities/ql_expression_parser")
local Circumstances = require("scripts/settings/circumstance/circumstance_templates")
local Mutators = require("scripts/settings/mutator/mutator_templates")
local MinorModifiers = require("scripts/settings/expeditions/expedition_mission_flags")
local ExpeditionNames = require("scripts/settings/expeditions/expedition_names")
local ExpeditionService = class("ExpeditionService")

ExpeditionService.UNLOCK_TYPE = table.enum("unlocked_by_default", "personal_best_loot", "personal_total_loot", "personal_count", "personal_best_loot_difficulty", "personal_total_loot_difficulty", "personal_count_difficulty", "personal_total_loot_mapwide", "personal_best_loot_mapwide", "global_stat_node", "global_stat_mapwide", "global_timer")
ExpeditionService.UNLOCK_STATUS = table.enum("locked", "unlockable", "unlocked")

ExpeditionService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._cached_data = {}
	self._missions_refresh_at = math.huge
end

local function _get_stat_unlock_type(key, guard_type, has_node)
	if key then
		if string.find(key, "best_loot_") then
			return ExpeditionService.UNLOCK_TYPE.personal_best_loot_difficulty
		elseif string.find(key, "total_loot_") then
			return ExpeditionService.UNLOCK_TYPE.personal_total_loot_difficulty
		elseif string.find(key, "count_") then
			return ExpeditionService.UNLOCK_TYPE.personal_count_difficulty
		elseif key == "server_time" and guard_type == "global" then
			return ExpeditionService.UNLOCK_TYPE.global_timer
		elseif key == "stat" and guard_type == "global" then
			return ExpeditionService.UNLOCK_TYPE.global_stat_mapwide
		elseif key == "count" then
			return ExpeditionService.UNLOCK_TYPE.personal_total_loot
		elseif key == "best_loot" then
			if has_node then
				return ExpeditionService.UNLOCK_TYPE.personal_best_loot
			else
				return ExpeditionService.UNLOCK_TYPE.personal_best_loot_mapwide
			end
		elseif key == "total_loot" then
			if has_node then
				return ExpeditionService.UNLOCK_TYPE.personal_total_loot
			else
				return ExpeditionService.UNLOCK_TYPE.personal_total_loot_mapwide
			end
		elseif key == "default" then
			return ExpeditionService.UNLOCK_TYPE.unlocked_by_default
		end
	end
end

local _ast_to_ui_table, _process_ui_table, _stats_from_token

function _ast_to_ui_table(ast_node)
	if not ast_node or table.is_empty(ast_node) then
		return {}
	end

	if ast_node.type == "condition" then
		return {
			{
				{
					node = ast_node.node,
					operator = ast_node.operator,
					value = ast_node.value,
				},
			},
		}
	end

	local left_table = _ast_to_ui_table(ast_node.left)
	local right_table = _ast_to_ui_table(ast_node.right)

	if ast_node.op == "OR" then
		local result = {}

		for _, scenario in ipairs(left_table) do
			table.insert(result, scenario)
		end

		for _, scenario in ipairs(right_table) do
			table.insert(result, scenario)
		end

		return result
	end

	if ast_node.op == "AND" then
		local result = {}

		for _, left_scenario in ipairs(left_table) do
			for _, right_scenario in ipairs(right_table) do
				local combined = table.clone(left_scenario)

				for _, condition in ipairs(right_scenario) do
					table.insert(combined, condition)
				end

				table.insert(result, combined)
			end
		end

		return result
	end
end

function _stats_from_token(token, node_personal_guards, node_global_guards)
	local guards = {}
	local token_type = token.token_type

	if token_type and token_type == QLExpressionParser.TOKEN_TYPE.IDENT then
		local value = token.value
		local first_char = value and string.sub(value, 1, 1)

		if first_char == "g" or first_char == "p" then
			local wanted_index_string = string.sub(value, 2)
			local wanted_index = wanted_index_string and tonumber(wanted_index_string) + 1
			local stat_ref = first_char == "g" and node_global_guards or node_personal_guards
			local stat = stat_ref and stat_ref[wanted_index]

			if stat then
				guards = stat
				guards.guard_type = first_char == "g" and "global" or "personal"
			else
				Log.error("ExpeditionService", "no guard corresponds to given index in " .. value)

				return guards
			end
		else
			Log.error("ExpeditionService", "no guard corresponds to given index in " .. value)

			return guards
		end
	elseif token_type and token_type == QLExpressionParser.TOKEN_TYPE.PSUM then
		local ref_key = ""
		local total = 0

		if node_personal_guards then
			for index, guard in pairs(node_personal_guards) do
				if ref_key == "invalid" then
					break
				end

				local stat = guard
				local key = stat.key
				local progress = stat.progress

				stat.guard_type = "personal"
				ref_key = ref_key and key

				if ref_key == key then
					total = total + progress
				else
					ref_key = "invalid"
				end
			end
		else
			ref_key = "invalid"
		end

		if ref_key == "invalid" then
			Log.error("ExpeditionService", "using a sum where all personal guards don't have matching values")

			return guards
		else
			guards = {
				guard_type = "personal",
				key = ref_key,
				progress = total,
			}
		end
	end

	return guards
end

function _process_ui_table(expression_table, node_personal_guards, node_global_guards)
	local token_1 = expression_table.node
	local token_2 = expression_table.value
	local comparison_token = expression_table.operator
	local value_1, value_2
	local stat_data = _stats_from_token(token_1, node_personal_guards, node_global_guards)

	value_1 = stat_data and stat_data.progress or 0
	value_2 = token_2.value and tonumber(token_2.value) or 0
	stat_data.limit = value_2

	local is_completed
	local comparison_token_type = comparison_token.token_type

	if comparison_token_type == QLExpressionParser.TOKEN_TYPE.GREATER_THAN_OR_EQUAL then
		is_completed = value_2 <= value_1
	elseif comparison_token_type == QLExpressionParser.TOKEN_TYPE.GREATER_THAN then
		is_completed = value_2 < value_1
	elseif comparison_token_type == QLExpressionParser.TOKEN_TYPE.LESS_THAN_OR_EQUAL then
		is_completed = value_1 <= value_2
	elseif comparison_token_type == QLExpressionParser.TOKEN_TYPE.LESS_THAN then
		is_completed = value_1 < value_2
	end

	return {
		stat_data = stat_data,
		is_completed = is_completed,
	}
end

ExpeditionService._prepare_guards_data = function (self, node_expression_string, node_name, global_stats, personal_stats)
	local to_unlock = {}
	local node_claimable = false

	local function add_unlock(stat_data, guard_type, is_completed)
		return {
			gathered_amount = stat_data.progress or 0,
			goal_amount = stat_data.limit,
			node = stat_data.node,
			type = _get_stat_unlock_type(stat_data.key, guard_type, not not stat_data.node),
			requirements_met = is_completed,
		}
	end

	local node_global_stats = global_stats[node_name]
	local node_personal_stats = personal_stats[node_name]

	if (not node_global_stats or table.is_empty(node_global_stats)) and (not node_personal_stats or table.is_empty(node_personal_stats)) then
		to_unlock[1] = to_unlock[1] or {}
		to_unlock[1][1] = {
			type = ExpeditionService.UNLOCK_TYPE.unlocked_by_default,
		}
		node_claimable = true
	elseif not node_expression_string or node_expression_string == "" then
		local all_completed = true

		if node_global_stats then
			for i = 1, #node_global_stats do
				local guard = node_global_stats[i]
				local limit = tonumber(guard.limit)
				local progress = tonumber(guard.progress) or 0
				local is_completed = limit <= progress

				if all_completed and is_completed == false then
					all_completed = false
				end

				to_unlock[1] = to_unlock[1] or {}
				to_unlock[1][#to_unlock[1] + 1] = add_unlock(guard, "global", is_completed)
			end
		end

		if node_personal_stats then
			for i = 1, #node_personal_stats do
				local guard = node_personal_stats[i]
				local limit = guard.limit
				local progress = guard.progress
				local is_completed = limit <= progress

				if all_completed and is_completed == false then
					all_completed = false
				end

				to_unlock[1] = to_unlock[1] or {}
				to_unlock[1][#to_unlock[1] + 1] = add_unlock(guard, "personal", is_completed)
			end
		end

		if all_completed and not table.is_empty(to_unlock) and not table.is_empty(to_unlock[1]) then
			node_claimable = all_completed
		end
	else
		local single_expressions = QLExpressionParser.parse(node_expression_string)
		local ui_table = _ast_to_ui_table(single_expressions)

		for i = 1, #ui_table do
			local expressions = ui_table[i]

			to_unlock[i] = {}

			local all_completed = true

			for ii = 1, #expressions do
				local expression = expressions[ii]
				local single_unlock = _process_ui_table(expression, node_personal_stats, node_global_stats)
				local is_completed = single_unlock.is_completed

				if all_completed and is_completed == false then
					all_completed = false
				end

				local unlock = add_unlock(single_unlock.stat_data, single_unlock.stat_data.guard_type, is_completed)

				to_unlock[i][ii] = unlock
			end

			if all_completed and not table.is_empty(expressions) then
				node_claimable = true
			end
		end
	end

	return to_unlock, node_claimable
end

ExpeditionService.fetch_personal_guards = function (self, nodes_by_id)
	local personal_stats_promises = {}
	local paths_count = {}

	if nodes_by_id then
		self._cached_data.personal_guards_paths_by_node_id = {}

		for node_id, node in pairs(nodes_by_id) do
			local guards = node.guards
			local personal_guards = guards.personal

			if personal_guards then
				local personal_guards_size = #personal_guards

				for ii = 1, personal_guards_size do
					local personal_stat = personal_guards[ii]

					self._cached_data.personal_guards_paths_by_node_id[node_id] = self._cached_data.personal_guards_paths_by_node_id[node_id] or {}
					self._cached_data.personal_guards_paths_by_node_id[node_id][ii] = table.concat(personal_stat.name, "|")

					local path = ""
					local start_path = ""
					local names_size = #personal_stat.name

					for iii = 1, #personal_stat.name do
						local name = personal_stat.name[iii]

						if iii == 1 then
							start_path = name
							paths_count[start_path] = paths_count[start_path] or {}
						end

						paths_count[start_path][iii] = paths_count[start_path][iii] or {}
						paths_count[start_path][iii][name] = paths_count[start_path][iii][name] or {
							count = 0,
							nodes = {},
						}
						paths_count[start_path][iii][name].nodes[node_id] = paths_count[start_path][iii][name].nodes[node_id] or {}
						paths_count[start_path][iii][name].nodes[node_id][ii] = personal_stat
						paths_count[start_path][iii][name].count = paths_count[start_path][iii][name].count + 1
					end
				end
			end
		end
	end

	for start_path, paths in pairs(paths_count) do
		local path_name = ""
		local max_count = paths_count[start_path][1][start_path].count
		local max_path
		local affected_nodes = {}
		local previous_path_data

		for index, paths_per_index in pairs(paths) do
			if #paths_per_index > 1 then
				max_path = path_name

				for path, path_data in pairs(paths_per_index) do
					table.merge(affected_nodes, path_data.nodes)
				end

				break
			end

			for path, path_data in pairs(paths_per_index) do
				local count = path_data.count

				if count < max_count then
					max_path = path_name

					table.merge(affected_nodes, previous_path_data.nodes)

					break
				else
					path_name = string.format("%s%s%s", path_name, path_name ~= "" and "|" or "", path)
					previous_path_data = path_data

					for node_name, node_guards in pairs(path_data.nodes) do
						for i = 1, #node_guards do
							local node_guard = node_guards[i]
							local names = node_guard.name
							local last_name = names[#names]

							if last_name == path then
								max_path = path_name
							end
						end
					end

					if max_path then
						table.merge(affected_nodes, path_data.nodes)

						break
					end
				end
			end

			if max_path then
				break
			end
		end

		if max_path then
			local stat_path = max_path

			personal_stats_promises[#personal_stats_promises + 1] = self._backend_interface.account:get_statistics(stat_path):next(function (data)
				local path_table = string.split(stat_path, "|")

				return Promise.resolved({
					data = data,
					path = path_table,
					nodes = affected_nodes,
				})
			end)
			max_path = nil
		end
	end

	return Promise.all(unpack(personal_stats_promises)):next(function (personal_stats)
		local personal_stats_progress = {}

		local function get_stat_unlock_type_by_type_path(key)
			if key == "best" then
				return "best_loot"
			elseif key == "total" then
				return "total_loot"
			end
		end

		for i = 1, #personal_stats do
			local personal_stat = personal_stats[i]
			local stats_progress = personal_stat.data
			local stats_progress_path = personal_stat.path
			local last_path_index = #stats_progress_path

			for node_name, personal_guards in pairs(personal_stat.nodes) do
				personal_stats_progress[node_name] = personal_stats_progress[node_name] or {}

				for ii, personal_guard in pairs(personal_guards) do
					local stats = personal_guard.stats
					local limit, key

					for stat_name, stat_value in pairs(stats) do
						limit = stat_value
						key = stat_name

						break
					end

					local stat_path_names = personal_guard.name
					local valid_guard = true

					for iii = 1, last_path_index do
						if stats_progress_path[iii] ~= stat_path_names[iii] then
							valid_guard = false

							break
						end
					end

					if valid_guard then
						local progress_value = 0
						local from_node
						local last_path = stat_path_names[#stat_path_names]
						local is_node_stat = string.find(last_path, "node_")

						if is_node_stat then
							from_node = last_path
						end

						if stats_progress and not table.is_empty(stats_progress) then
							for iii = 1, #stats_progress do
								local stat_progress = stats_progress[iii]
								local paths = stat_progress.typePath
								local found_path = false

								if paths then
									found_path = true

									for iiii = 1, #stat_path_names do
										local path = paths[iiii]
										local stat_path_name = stat_path_names[iiii]

										if path ~= stat_path_name then
											found_path = false

											break
										end
									end
								end

								if found_path then
									local values = stat_progress.value
									local stat_type = get_stat_unlock_type_by_type_path(last_path)

									for value_name, value in pairs(values) do
										if value_name == key then
											progress_value = value
											from_node = is_node_stat and last_path or nil

											break
										elseif stat_type == key then
											progress_value = value
											from_node = is_node_stat and last_path or nil

											break
										end
									end

									break
								end
							end
						end

						personal_stats_progress[node_name][ii] = {
							limit = limit,
							progress = progress_value,
							key = key,
							node = from_node,
						}
					end
				end
			end
		end

		return Promise.resolved(personal_stats_progress)
	end):catch(function (error)
		return Promise.resolved({})
	end)
end

ExpeditionService.fetch_global_guards = function (self, nodes_by_id)
	local global_stats_promises = {}
	local nodes_by_global_category = {}
	local unique_time_category_name = math.uuid()

	if nodes_by_id then
		for node_id, node in pairs(nodes_by_id) do
			local guards = node.guards
			local global_guards = guards.global

			if global_guards then
				for ii = 1, #global_guards do
					local global_stat = global_guards[ii]
					local type = global_stat.type

					if type == "time" then
						if not nodes_by_global_category[unique_time_category_name] then
							nodes_by_global_category[unique_time_category_name] = {}
						end

						nodes_by_global_category[unique_time_category_name][node_id] = nodes_by_global_category[unique_time_category_name][node_id] or {}
						nodes_by_global_category[unique_time_category_name][node_id][ii] = {
							name = "server_time",
							limit = global_stat.date,
						}
					elseif type == "stat" then
						local category = global_stat.category

						if not nodes_by_global_category[category] then
							nodes_by_global_category[category] = {}
						end

						nodes_by_global_category[category][node_id] = nodes_by_global_category[category][node_id] or {}
						nodes_by_global_category[category][node_id][ii] = {
							name = global_stat.name,
							limit = global_stat.limit,
						}
					end
				end
			end
		end
	end

	for category_name, nodes in pairs(nodes_by_global_category) do
		if category_name == unique_time_category_name then
			local t = Managers.time:time("main")
			local server_time = Managers.backend:get_server_time(t)

			global_stats_promises[#global_stats_promises + 1] = Promise.resolved({
				stats = {
					server_time = server_time,
				},
				nodes = nodes,
			})
		else
			global_stats_promises[#global_stats_promises + 1] = self._backend_interface.global_stats:get_category(category_name):next(function (data)
				return Promise.resolved({
					stats = data.stats,
					nodes = nodes,
				})
			end)
		end
	end

	return Promise.all(unpack(global_stats_promises)):next(function (global_stats)
		local global_stats_progress = {}

		for i = 1, #global_stats do
			local global_stat = global_stats[i]
			local nodes = global_stat.nodes

			for node_name, node_data in pairs(nodes) do
				global_stats_progress[node_name] = global_stats_progress[node_name] or {}

				for index, stat_data in pairs(node_data) do
					global_stats_progress[node_name][index] = {
						key = "stat",
						limit = stat_data.limit,
						progress = global_stat.stats[stat_data.name],
					}
				end
			end
		end

		return Promise.resolved(global_stats_progress)
	end):catch(function (error)
		return Promise.resolved({})
	end)
end

ExpeditionService._update_cache_result_missions = function (self)
	if self._cached_data.result then
		for node_id, node_data in pairs(self._cached_data.result) do
			local node = self._cached_data.nodes[node_id]
			local missions = self._cached_data.missions
			local node_missions = self:_prepare_node_missions_data(node, missions)

			node_data.missions = node_missions
		end
	end
end

ExpeditionService._update_cache_result_guards = function (self)
	for node_id, result_data in pairs(self._cached_data.result) do
		local node = self._cached_data.nodes[node_id]
		local global_stats = self._cached_data.global_stats
		local personal_stats = self._cached_data.personal_stats
		local track_state = self._cached_data.track_state
		local to_unlock, unlock_status = self:_prepare_node_guards_data(node, global_stats, personal_stats, track_state)

		result_data.unlock_status = unlock_status
		result_data.to_unlock = to_unlock
	end
end

ExpeditionService.update_node_personal_progress = function (self, node_id_played, all_updated_progress)
	return self:fetch_nodes():next(function ()
		local personal_guards_progress = {}
		local personal_stats = self._cached_data.personal_stats

		for i = 1, #all_updated_progress do
			local updated_progress = all_updated_progress[i]
			local path_string = updated_progress.path and table.concat(updated_progress.path, "|")
			local last_path = updated_progress.path and updated_progress.path[#updated_progress.path]
			local progress_node_id = last_path and string.find(last_path, "node_") and last_path

			for node_id, personal_guard_indexes in pairs(self._cached_data.personal_guards_paths_by_node_id) do
				for personal_guard_index, personal_path_string in pairs(personal_guard_indexes) do
					if personal_path_string == path_string then
						local personal_stat = personal_stats[node_id] and personal_stats[node_id][personal_guard_index]
						local personal_stat_key = personal_stat and personal_stat.key
						local updated_progress_in_key = personal_stat_key and updated_progress.stats[personal_stat_key]

						if updated_progress_in_key then
							local limit = personal_stat.limit
							local progress_value = updated_progress_in_key.toValue or 0
							local previous_progress_value = updated_progress_in_key.fromValue or 0
							local end_progress = math.min(progress_value, limit)

							if end_progress > personal_stat.progress and limit > personal_stat.progress then
								personal_guards_progress[#personal_guards_progress + 1] = {
									limit = limit,
									progress = end_progress,
									previous_progress = previous_progress_value,
									progress_node = progress_node_id,
									progress_node_name = progress_node_id and self._cached_data.result[progress_node_id].ui.display_name or "",
									affected_node = node_id,
									affected_node_name = self._cached_data.result[node_id].ui.display_name or "",
									key = personal_stat_key,
									type = _get_stat_unlock_type(personal_stat_key, "personal", not not progress_node_id),
								}
								personal_stat.progress = progress_value
							end
						end
					end
				end
			end

			if last_path and string.find(last_path, "node_") and not table.is_empty(updated_progress.stats) then
				self._cached_data.stats[last_path] = self._cached_data.stats[last_path] or {}

				if self._cached_data.result and self._cached_data.result[last_path] then
					self._cached_data.result[last_path].stats = self._cached_data.result[last_path].stats or {}
				end

				for key, stat in pairs(updated_progress.stats) do
					self._cached_data.stats[last_path][key] = stat.toValue

					if self._cached_data.result[last_path] then
						self._cached_data.result[last_path].stats[key] = stat.toValue
					end
				end
			end

			if updated_progress.path and updated_progress.path[#updated_progress.path - 1] == "rotation" and not table.is_empty(updated_progress.stats) then
				if not self._cached_data.stats or not self._cached_data.stats.personal then
					self._cached_data.stats = self._cached_data.stats or {}
					self._cached_data.stats.personal = {}
				end

				for key, stat in pairs(updated_progress.stats) do
					self._cached_data.stats.personal[key] = stat.toValue
				end
			end
		end

		self:_update_cache_result_guards()

		local node_name_played = self._cached_data.result[node_id_played].ui.display_name

		return Promise.resolved({
			node_name_played = node_name_played,
			all_unlock_progress = personal_guards_progress,
		})
	end)
end

ExpeditionService.check_missions_expired = function (self)
	local t = Managers.time:time("main")

	return t >= self._missions_refresh_at
end

ExpeditionService.fetch_expedition_missions = function (self)
	local filtered_missions = {}
	local refresh_at = math.huge

	return Managers.data_service.mission_board:fetch(nil, 1):next(function (missions_data)
		local missions = missions_data.missions
		local t = Managers.time:time("main")
		local server_time = Managers.backend:get_server_time(t)

		for _, mission in ipairs(missions) do
			if mission.category == "expedition" then
				filtered_missions[#filtered_missions + 1] = mission

				local expiry_time = mission.expiry_game_time or (tonumber(mission.expiry) - server_time) / 1000 + t

				refresh_at = math.min(refresh_at, expiry_time)

				local modifiers = {}

				if Circumstances[mission.circumstance] then
					modifiers[#modifiers + 1] = mission.circumstance

					local mutators = Circumstances[mission.circumstance].mutators

					if mutators then
						for i = 1, #mutators do
							local mutator = mutators[i]

							modifiers[#modifiers + 1] = mutator
						end
					end
				end

				for flag in pairs(mission.flags) do
					local start_index, end_index = string.find(flag, "exped-mods-", nil, true)

					if start_index == 1 then
						local exp_flags_string = string.sub(flag, end_index + 1)
						local exp_flags = string.split(exp_flags_string, ";")

						for i = 1, #exp_flags do
							local exp_flag = exp_flags[i]

							if MinorModifiers[exp_flag] then
								modifiers[#modifiers + 1] = exp_flag
							end
						end
					end
				end

				mission.modifiers = modifiers
			end
		end

		self._missions_refresh_at = refresh_at

		if self._cached_data.missions then
			self._cached_data.missions = filtered_missions

			self:_update_cache_result_missions()
		end

		return filtered_missions
	end):catch(function (error)
		self._missions_refresh_at = refresh_at

		return filtered_missions
	end)
end

ExpeditionService._get_expeditions_tracks = function (self)
	return self._backend_interface.tracks:get_expeditions_tracks():next(function (tracks)
		local track = tracks and tracks[1]
		local path = track and track.data

		if path then
			self._cached_data.personal_stats_path = string.format("expedition|campaign|%s|rotation|%s", path.campaignId, path.rotationId)
		end

		return Promise.resolved(track)
	end)
end

ExpeditionService.get_node_name_by_id = function (self, node_id)
	return self:fetch_nodes():next(function ()
		local node_name = self._cached_data.result[node_id] and self._cached_data.result[node_id].ui.display_name or ""

		return node_name
	end)
end

ExpeditionService.fetch_nodes = function (self)
	if not table.is_empty(self._cached_data) then
		local t = Managers.time:time("main")

		if not self._cached_data.nodes or self._expeditions_track_timer and t >= self._expeditions_track_timer then
			table.clear(self._cached_data)

			return self:fetch_nodes()
		end

		local mission_promise

		if self._cached_data.missions and self:check_missions_expired() then
			mission_promise = self:fetch_expedition_missions()
		else
			mission_promise = Promise.resolved()
		end

		return mission_promise:next(function ()
			return self:fetch_global_guards(self._cached_data.nodes):next(function (global_guards)
				self._cached_data.global_stats = global_guards

				self:_update_cache_result_guards()

				local nodes_by_id, nodes_by_index = self:_result_to_nodes_data(self._cached_data.result)

				return {
					nodes_by_id = nodes_by_id,
					nodes_by_index = nodes_by_index,
					personal_stats = self._cached_data.stats.personal,
				}
			end)
		end)
	end

	local promises = {}

	return self:_get_expeditions_tracks():next(function (track)
		if not track then
			return Promise.resolved({})
		end

		local nodes = track.nodes
		local nodes_by_id

		if nodes then
			nodes_by_id = {}

			for i = 1, #nodes do
				local node = nodes[i]
				local id = node.nodeId

				nodes_by_id[id] = node
			end
		end

		self._expeditions_track_id = track.id
		self._expeditions_track_timer = nil

		if track.validTo then
			local t = Managers.time:time("main")
			local server_time = Managers.backend:get_server_time(t)

			self._expeditions_track_timer = (tonumber(track.validTo) - server_time) / 1000 + t
		end

		local promises = {}

		promises[#promises + 1] = self:fetch_expedition_missions()
		promises[#promises + 1] = Promise.resolved(nodes_by_id)
		promises[#promises + 1] = self:fetch_global_guards(nodes_by_id)
		promises[#promises + 1] = self:fetch_personal_guards(nodes_by_id)
		promises[#promises + 1] = self._backend_interface.tracks:get_track_state(self._expeditions_track_id):catch(function (error)
			return Promise.resolved()
		end)
		promises[#promises + 1] = self._backend_interface.tracks:get_graph_track_layout(self._expeditions_track_id):catch(function (error)
			return Promise.resolved()
		end)
		promises[#promises + 1] = self._backend_interface.account:get_statistics(self._cached_data.personal_stats_path)

		return Promise.all(unpack(promises))
	end):next(function (data)
		local missions, nodes, global_stats, personal_stats, track_state, track_layout, stats = unpack(data)

		self._cached_data.missions = missions
		self._cached_data.nodes = nodes
		self._cached_data.global_stats = global_stats
		self._cached_data.personal_stats = personal_stats
		self._cached_data.track_state = track_state and track_state.state
		self._cached_data.track_layout = track_layout
		self._cached_data.stats = {}

		if stats then
			for i = 1, #stats do
				local stat = stats[i]
				local path = stat.typePath
				local last_path = path and path[#path]

				if last_path and string.find(last_path, "node_") then
					self._cached_data.stats[last_path] = stat.value

					if self._cached_data.result and self._cached_data.result[last_path] then
						self._cached_data.result[last_path].stats = stat.value
					end
				elseif path and path[#path - 1] == "rotation" then
					self._cached_data.stats.personal = stat.value
				end
			end
		end

		return self:_prepare_result_data()
	end)
end

ExpeditionService._prepare_node_guards_data = function (self, node, global_stats, personal_stats, track_state)
	local id = node.nodeId
	local guards = node.guards
	local node_expression_guard = guards.expression
	local unlock_status = ExpeditionService.UNLOCK_STATUS.locked
	local rewarded_nodes = track_state and track_state.rewardedNodes

	if rewarded_nodes then
		for ii = 1, #rewarded_nodes do
			local rewarded_node = rewarded_nodes[ii]

			if rewarded_node == id then
				unlock_status = ExpeditionService.UNLOCK_STATUS.unlocked

				break
			end
		end
	end

	local to_unlock, is_claimable = ExpeditionService:_prepare_guards_data(node_expression_guard, id, global_stats, personal_stats)

	if is_claimable == true and unlock_status == ExpeditionService.UNLOCK_STATUS.locked then
		unlock_status = ExpeditionService.UNLOCK_STATUS.unlockable
	end

	return to_unlock, unlock_status
end

ExpeditionService._prepare_node_missions_data = function (self, node, missions)
	local id = node.nodeId
	local node_flag = string.format("exped-node-%s", id)
	local node_misisons = {}

	for ii = 1, #missions do
		local mission = missions[ii]
		local flags = mission.flags

		if flags[node_flag] then
			node_misisons[#node_misisons + 1] = mission
		end
	end

	local function sort_func(a, b)
		local a_danger_level = Danger.calculate_danger(a.challenge, a.resistance)
		local b_danger_level = Danger.calculate_danger(b.challenge, b.resistance)

		return a_danger_level < b_danger_level
	end

	table.sort(node_misisons, sort_func)

	return node_misisons
end

ExpeditionService._prepare_node_layout_data = function (self, node, track_layout)
	local id = node.nodeId
	local node_layout

	if track_layout and track_layout.nodes then
		for ii = 1, #track_layout.nodes do
			local track_node_layout = track_layout.nodes[ii]
			local layout_node_id = track_node_layout.nodeId

			if layout_node_id == id then
				node_layout = track_node_layout

				break
			end
		end
	end

	local x_normalized = node_layout and track_layout and track_layout.presentation and (node_layout.position[1] - track_layout.presentation.offset[1]) / track_layout.presentation.size[1] or 0
	local y_normalized = node_layout and track_layout and track_layout.presentation and (node_layout.position[2] - track_layout.presentation.offset[2]) / track_layout.presentation.size[2] or 0
	local position = {
		x = x_normalized,
		y = y_normalized,
	}
	local next_node_ids = {}
	local previous_node_ids = {}

	if node_layout and node_layout.parents then
		for ii = 1, #node_layout.parents do
			local previous_node_id = node_layout.parents[ii]

			previous_node_ids[ii] = previous_node_id
		end
	end

	if node_layout and node_layout.children then
		for ii = 1, #node_layout.children do
			local next_node_id = node_layout.children[ii]

			next_node_ids[ii] = next_node_id
		end
	end

	table.sort(previous_node_ids)
	table.sort(next_node_ids)

	return position, previous_node_ids, next_node_ids
end

ExpeditionService._prepare_result_data = function (self)
	local result = {}
	local missions = self._cached_data.missions
	local nodes = self._cached_data.nodes
	local global_stats = self._cached_data.global_stats
	local personal_stats = self._cached_data.personal_stats
	local track_state = self._cached_data.track_state
	local track_layout = self._cached_data.track_layout
	local stats = self._cached_data.stats

	if nodes then
		for id, node in pairs(nodes) do
			local name = node.name
			local to_unlock, unlock_status = self:_prepare_node_guards_data(node, global_stats, personal_stats, track_state)
			local position, previous_node_ids, next_node_ids = self:_prepare_node_layout_data(node, track_layout)
			local node_missions = self:_prepare_node_missions_data(node, missions)

			result[id] = {
				name = name,
				id = id,
				unlock_status = unlock_status,
				to_unlock = to_unlock or {},
				ui = position,
				previous = previous_node_ids,
				next = next_node_ids,
				missions = node_missions,
				stats = stats and stats[id] or {},
			}
		end
	end

	local expedition_names_size = #ExpeditionNames

	local function traverse(children, current_index, visited_nodes, mode)
		local next_nodes = {}

		for i = 1, #children do
			local node_id = children[i]

			if not visited_nodes[node_id] then
				if mode == "count" then
					current_index = current_index + 1
					visited_nodes[node_id] = true

					local node = result[node_id]

					if node.next then
						next_nodes[#next_nodes + 1] = node
					end
				else
					current_index = current_index + 1
					visited_nodes[node_id] = true

					local node = result[node_id]

					node.index = current_index

					local wrapped_index = math.index_wrapper(current_index, expedition_names_size)
					local node_display_data = ExpeditionNames[wrapped_index]

					node.ui.display_name = node_display_data.display_name
					node.ui.display_name_atlas_index = node_display_data.material_atlas_index

					if node.next then
						next_nodes[#next_nodes + 1] = node
					end
				end
			end
		end

		for i = 1, #next_nodes do
			local node = next_nodes[i]

			current_index = traverse(node.next, current_index, visited_nodes, mode)
		end

		return current_index
	end

	local nodes_order = {}

	for _, node in pairs(result) do
		local count = 0
		local visited_nodes = {}

		if table.is_empty(node.previous) then
			count = traverse({
				node.id,
			}, count, visited_nodes, "count")
			nodes_order[#nodes_order + 1] = {
				count = count,
				start_node_id = node.id,
				is_default = node.to_unlock[1][1].type == ExpeditionService.UNLOCK_TYPE.unlocked_by_default,
			}
		end
	end

	if table.size(nodes_order) > 1 then
		local function node_order_sort_func(a, b)
			if a.is_default ~= b.is_default then
				return a.is_default
			elseif a.count ~= b.count then
				return a.count > b.count
			else
				return a.start_node_id < b.start_node_id
			end
		end

		table.sort(nodes_order, node_order_sort_func)
	end

	local visited_nodes = {}
	local index = 0

	for i = 1, #nodes_order do
		local node_order = nodes_order[i]
		local node = result[node_order.start_node_id]

		index = traverse({
			node.id,
		}, index, visited_nodes)
	end

	local nodes_by_id, nodes_by_index = self:_result_to_nodes_data(result)

	self._cached_data.result = result

	return {
		nodes_by_id = nodes_by_id,
		nodes_by_index = nodes_by_index,
		personal_stats = self._cached_data.stats.personal,
	}
end

ExpeditionService._result_to_nodes_data = function (self, result)
	local nodes_by_id = table.clone(result)
	local nodes_by_index = {}

	for node_id, node in pairs(nodes_by_id) do
		for i = 1, #node.previous do
			local parent_id = node.previous[i]

			node.previous[i] = nodes_by_id[parent_id]
		end

		for i = 1, #node.next do
			local child_id = node.next[i]

			node.next[i] = nodes_by_id[child_id]
		end

		if node.index then
			nodes_by_index[node.index] = node
		end
	end

	return nodes_by_id, nodes_by_index
end

ExpeditionService.claim_track_node = function (self, node_id)
	return self:fetch_nodes():next(function ()
		local track_id = self._expeditions_track_id

		return self._backend_interface.tracks:claim_track_node(track_id, node_id):next(function (data)
			local rewarded_nodes = self._cached_data.track_state and self._cached_data.track_state.rewardedNodes

			if rewarded_nodes then
				rewarded_nodes[#rewarded_nodes + 1] = node_id

				self:_prepare_result_data()
			else
				return self._backend_interface.tracks:get_track_state(self._expeditions_track_id):next(function (track_state)
					self._cached_data.track_state = track_state and track_state.state

					self:_prepare_result_data()
				end)
			end
		end)
	end)
end

ExpeditionService.claim_track_node_reward = function (self, node_id, reward_id)
	local track_id = self._expeditions_track_id

	return self._backend_interface.tracks:claim_track_node_reward(track_id, node_id, reward_id)
end

ExpeditionService.get_expedition_settings_by_template = function (self, template_name, node_id, version)
	return Managers.backend.interfaces.expedition:settings_by_template(template_name, node_id, version)
end

ExpeditionService.get_character_mission_board_save_data = function (self)
	local player = Managers.player:local_player(1)
	local character_id = player:character_id()
	local character_save_data = Managers.save:character_data(character_id)

	return character_save_data.mission_board
end

ExpeditionService.fetch_player_journey_data = function (self, account_id, character_id, force_refresh)
	return Managers.data_service.mission_board:fetch_player_journey_data(account_id, character_id, force_refresh)
end

ExpeditionService.has_cached_progression_data = function (self)
	return Managers.data_service.mission_board:has_cached_progression_data()
end

ExpeditionService.get_filtered_missions_data = function (self)
	return Managers.data_service.mission_board:get_filtered_missions_data()
end

ExpeditionService.get_difficulty_progression_data = function (self)
	return Managers.data_service.mission_board:get_difficulty_progression_data()
end

ExpeditionService.get_game_modes_progression_data = function (self)
	return Managers.data_service.mission_board:get_game_modes_progression_data()
end

ExpeditionService.get_quickplay_bonus = function (self)
	return Managers.data_service.mission_board:get_rewards():next(function (bonus_data)
		local filtered_bonus_data = {}

		for mission_type, values in pairs(bonus_data) do
			for type, value in pairs(values) do
				local percentile_value = math.floor(value * 100 - 100)

				if percentile_value > 0 then
					filtered_bonus_data[mission_type] = filtered_bonus_data[mission_type] or {}
					filtered_bonus_data[mission_type][type] = percentile_value
				end
			end
		end

		local quickplay_bonus_data = filtered_bonus_data.quickplay

		if not quickplay_bonus_data then
			return nil, nil
		end

		local lo, hi

		for _, percentile_value in pairs(quickplay_bonus_data) do
			lo = (lo == nil or percentile_value < lo) and percentile_value or lo
			hi = (hi == nil or hi < percentile_value) and percentile_value or hi
		end

		return {
			lo,
			hi,
		}
	end)
end

return ExpeditionService
