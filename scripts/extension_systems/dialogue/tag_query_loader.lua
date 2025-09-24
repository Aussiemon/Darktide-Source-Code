-- chunkname: @scripts/extension_systems/dialogue/tag_query_loader.lua

local TagQuery = require("scripts/extension_systems/dialogue/tag_query")
local OP

if rawget(_G, "RuleDatabase") then
	RuleDatabase.initialize_static_values()

	local operator_string_lookup = {
		EQ = "EQ",
		GT = "GT",
		GTEQ = "GTEQ",
		LT = "LT",
		LTEQ = "LTEQ",
		NEQ = "NEQ",
		NOT = "NOT",
		SET_INCLUDES = "SET_INCLUDES",
		SET_INTERSECTS = "SET_INTERSECTS",
		SET_NOT_INCLUDES = "SET_NOT_INCLUDES",
		SET_NOT_INTERSECTS = "SET_NOT_INTERSECTS",
		TIMEDIFF = "TIMEDIFF",
		TIMESET = TagQuery.OP.TIMESET,
		ADD = TagQuery.OP.ADD,
		SUB = TagQuery.OP.SUB,
		NUMSET = TagQuery.OP.NUMSET,
	}

	OP = operator_string_lookup
else
	OP = TagQuery.OP
end

local function tprint(format, ...)
	Log.info("[TagQueryLoader] ", "string %s", format)
end

local TagQueryLoader = class("TagQueryLoader")

TagQueryLoader.init = function (self, tagquery_database, dialogue_templates_destination_table)
	self.file_environment = {
		OP = OP,
		define_rule = function (rule_definition)
			tagquery_database:define_rule(rule_definition)

			local dialogue_template = {
				category = rule_definition.category,
				database = rule_definition.database,
				wwise_route = rule_definition.wwise_route,
				heard_speak_routing = rule_definition.heard_speak_routing,
				on_post_rule_execution = rule_definition.on_post_rule_execution,
				on_pre_rule_execution = rule_definition.on_pre_rule_execution,
			}

			dialogue_templates_destination_table[rule_definition.name] = dialogue_template
		end,
	}
	self.unload_file_environment = {
		OP = OP,
		define_rule = function (rule_definition)
			tagquery_database:remove_rule(rule_definition.name, rule_definition.database)
		end,
	}
	self.tagquery_database = tagquery_database
end

TagQueryLoader.invalid_rules_from_group = function (self, rule_group_name)
	local tagquery_database = self.tagquery_database
	local patterns_to_remove = tagquery_database:forbidden_rule_patterns(rule_group_name)
	local voices_to_validate = tagquery_database:voices_to_validate(rule_group_name)

	if not patterns_to_remove and not voices_to_validate then
		return
	end

	local rule_group_ids = tagquery_database:ids_by_rule_group(rule_group_name)

	if not rule_group_ids then
		return
	end

	local rule_id_mapping = tagquery_database:rule_id_mapping()
	local num_rule_group_ids = #rule_group_ids
	local invalid_rules = {}
	local string_find = string.find
	local string_sub = string.sub

	for i = 1, num_rule_group_ids do
		repeat
			local rule_id = rule_group_ids[i]
			local rule = rule_id_mapping[rule_id]

			if not rule then
				break
			end

			local rule_name = rule.name

			if patterns_to_remove then
				local match = false

				for j = #patterns_to_remove, 1, -1 do
					local pattern = patterns_to_remove[j]

					if string_find(rule_name, pattern) then
						invalid_rules[#invalid_rules + 1] = rule_name
						match = true

						break
					end
				end

				if match then
					break
				end
			end

			if voices_to_validate then
				local is_valid = tagquery_database:validate_rule_voice_requirement(rule, voices_to_validate)

				if not is_valid then
					invalid_rules[#invalid_rules + 1] = rule_name

					local rule_suffix_length = -3
					local rule_pattern = string_sub(rule_name, 1, rule_suffix_length)

					if patterns_to_remove then
						patterns_to_remove[#patterns_to_remove + 1] = rule_pattern

						break
					end

					patterns_to_remove = {
						rule_pattern,
					}
				end
			end
		until true
	end

	return invalid_rules
end

TagQueryLoader.try_remove_invalid_rules_from_group = function (self, rule_group_name)
	local invalid_rules = self:invalid_rules_from_group(rule_group_name)

	if not invalid_rules then
		return
	end

	local num_invalid_rules = #invalid_rules
	local tagquery_database = self.tagquery_database

	for i = 1, num_invalid_rules do
		local rule_name = invalid_rules[i]

		if DevParameters.dialogue_enable_loading_logs then
			Log.info("DialogueSystemDebug", "%q is removing rule %q", rule_group_name, rule_name)
		end

		tagquery_database:remove_rule(rule_name, rule_group_name)
	end
end

TagQueryLoader.load_file = function (self, filename, rule_group_name)
	local file_function = require(filename)

	setfenv(file_function, self.file_environment)

	local num_rules_before = self.tagquery_database:num_rules()

	self.tagquery_database:set_rule_group_conditions(rule_group_name)
	file_function()
	self.tagquery_database:set_rule_group_conditions(nil)

	if DevParameters.dialogue_enable_loading_logs then
		local rules_read = self.tagquery_database:num_rules() - num_rules_before

		Log.info("DialogueSystemDebug", "Loaded file %q. Read %d rules.", filename, rules_read)
	end
end

TagQueryLoader.unload_file = function (self, filename, rule_group_name)
	if package.loaded[filename] then
		local num_rules_before = self.tagquery_database:num_rules()
		local load_order = package.load_order
		local n_load_order = #load_order
		local found_file

		for i = n_load_order, 1, -1 do
			if load_order[i] == filename then
				found_file = true
				package.loaded[filename] = nil

				table.remove(load_order, i)

				break
			end
		end

		local file_function = require(filename)

		setfenv(file_function, self.unload_file_environment)
		file_function()

		if DevParameters.dialogue_enable_loading_logs then
			local rules_read = num_rules_before - self.tagquery_database:num_rules()

			Log.info("DialogueSystemDebug", "Unloaded file %q. Removed %d rules.", filename, rules_read)
		end
	end
end

TagQueryLoader.destroy = function (self)
	self.file_environment = nil
	self.tagquery_database = nil
end

return TagQueryLoader
