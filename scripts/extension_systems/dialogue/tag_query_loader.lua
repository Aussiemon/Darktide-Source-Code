local TagQuery = require("scripts/extension_systems/dialogue/tag_query")
local OP = nil

if rawget(_G, "RuleDatabase") then
	RuleDatabase.initialize_static_values()

	local operator_string_lookup = {
		GT = "GT",
		LT = "LT",
		NEQ = "NEQ",
		SET_INTERSECTS = "SET_INTERSECTS",
		LTEQ = "LTEQ",
		GTEQ = "GTEQ",
		SET_NOT_INTERSECTS = "SET_NOT_INTERSECTS",
		TIMEDIFF = "TIMEDIFF",
		EQ = "EQ",
		NOT = "NOT",
		SET_INCLUDES = "SET_INCLUDES",
		TIMESET = TagQuery.OP.TIMESET,
		ADD = TagQuery.OP.ADD,
		SUB = TagQuery.OP.SUB,
		NUMSET = TagQuery.OP.NUMSET
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
	self.loaded_files = {}
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
				on_pre_rule_execution = rule_definition.on_pre_rule_execution
			}
			dialogue_templates_destination_table[rule_definition.name] = dialogue_template
		end
	}
	self.unload_file_environment = {
		OP = OP,
		define_rule = function (rule_definition)
			tagquery_database:remove_rule(rule_definition.name)
		end
	}
	self.tagquery_database = tagquery_database
end

TagQueryLoader.load_file = function (self, filename)
	local file_function = require(filename)

	setfenv(file_function, self.file_environment)

	local num_rules_before = self.tagquery_database:num_rules()

	file_function()

	local rules_read = self.tagquery_database:num_rules() - num_rules_before

	Log.info("DialogueSystemDebug", "Loaded file %q. Read %d rules.", filename, rules_read)
end

TagQueryLoader.unload_file = function (self, filename)
	if package.loaded[filename] then
		local load_order = package.load_order
		local n_load_order = #load_order
		local found_file = nil

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
	end
end

TagQueryLoader.unload_files = function (self)
	for _, filename in ipairs(self.loaded_files) do
		self:unload_file(filename)
	end

	self.file_environment = nil
	self.loaded_files = nil
	self.tagquery_database = nil
end

return TagQueryLoader
