TagQuery = TagQuery or {}
TagQuery.__index = TagQuery

TagQuery.add = function (self, ...)
	local n_args = select("#", ...)

	fassert(n_args == math.floor(n_args / 2) * 2, "Uneven amount of args, number of arguments: %d", n_args)

	local query_context = self.query_context

	for i = 1, n_args, 2 do
		local key, value = select(i, ...)
		query_context[key] = value
	end

	fassert(not self.finalized, "Tried to add query after finalized.")
end

TagQuery.get_result = function (self)
	return self.completed, self.result
end

TagQuery.finalize = function (self)
	self.tagquery_database:add_query(self)

	self.finalized = true
end

TagQuery.OP = TagQuery.OP or {
	EQ = setmetatable({}, {
		__tostring = function ()
			return "EQ"
		end
	}),
	LT = setmetatable({}, {
		__tostring = function ()
			return "LT"
		end
	}),
	GT = setmetatable({}, {
		__tostring = function ()
			return "GT"
		end
	}),
	LTEQ = setmetatable({}, {
		__tostring = function ()
			return "LTEQ"
		end
	}),
	GTEQ = setmetatable({}, {
		__tostring = function ()
			return "GTEQ"
		end
	}),
	SUB = setmetatable({}, {
		__tostring = function ()
			return "SUB"
		end
	}),
	ADD = setmetatable({}, {
		__tostring = function ()
			return "ADD"
		end
	}),
	NEQ = setmetatable({}, {
		__tostring = function ()
			return "NEQ"
		end
	}),
	NOT = setmetatable({}, {
		__tostring = function ()
			return "NOT"
		end
	}),
	RAND = setmetatable({}, {
		__tostring = function ()
			return "RAND"
		end
	}),
	TIMEDIFF = setmetatable({}, {
		__tostring = function ()
			return "TIMEDIFF"
		end
	}),
	TIMESET = setmetatable({}, {
		__tostring = function ()
			return "TIMESET"
		end
	}),
	NUMSET = setmetatable({}, {
		__tostring = function ()
			return "NUMSET"
		end
	}),
	SET_INCLUDES = setmetatable({}, {
		__tostring = function ()
			return "SET_INCLUDES"
		end
	}),
	SET_INTERSECTS = setmetatable({}, {
		__tostring = function ()
			return "SET_INTERSECTS"
		end
	})
}

return TagQuery
