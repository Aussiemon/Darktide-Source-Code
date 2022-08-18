local function tests(SimpleSlotReserver)
	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)
	local _, total = reserver:allocation_state()

	assert(total == slots)

	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)
	local allocations, _ = reserver:allocation_state()

	assert(allocations == 0)

	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})

	local allocations, _ = reserver:allocation_state()

	assert(allocations == 3)

	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slot("1", "1")
	reserver:reserve_slot("2", "2")
	reserver:reserve_slot("3", "3")

	local allocations, _ = reserver:allocation_state()

	assert(allocations == 3)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	assert(reserver:reserve_slot("1", "1"))
	assert(reserver:reserve_slot("2", "2"))
	assert(reserver:reserve_slot("3", "3"))

	reserver = SimpleSlotReserver:new(slots)

	assert(reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	}))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	assert(not reserver:reserve_slot("4", "4"))
	assert(not reserver:reserve_slots("4", {
		"4",
		"5"
	}))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	assert(reserver:is_slot_reserved("1"))
	assert(reserver:is_slot_reserved("2"))
	assert(reserver:is_slot_reserved("3"))
	assert(not reserver:is_slot_reserved("4"))

	reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slot("1", "1")
	reserver:reserve_slot("2", "2")
	reserver:reserve_slot("3", "3")
	assert(reserver:is_slot_reserved("1"))
	assert(reserver:is_slot_reserved("2"))
	assert(reserver:is_slot_reserved("3"))
	assert(not reserver:is_slot_reserved("4"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	assert(reserver:reserve_slot("1", "1"))
	assert(reserver:is_slot_reserved("1"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	assert(reserver:reserve_slot("1", "1"))
	assert(reserver:is_slot_reserved("1"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	assert(reserver:reserve_slots("1", {
		"1",
		"2"
	}))
	assert(reserver:reserve_slots("2", {
		"2",
		"3"
	}))
	assert(reserver:is_slot_reserved("1"))
	assert(reserver:is_slot_reserved("2"))
	assert(reserver:is_slot_reserved("3"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	assert(reserver:reserve_slots("1", {
		"1",
		"2"
	}))
	assert(reserver:reserve_slots("2", {
		"2",
		"3"
	}))

	local allocations, _ = reserver:allocation_state()

	assert(allocations == 3)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2"
	})
	reserver:free_slots({
		"1",
		"2"
	})

	local allocations, _ = reserver:allocation_state()

	assert(allocations == 0)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2"
	})
	reserver:free_slot("2", 2)

	local allocations, _ = reserver:allocation_state()

	assert(allocations == 1)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	reserver:free_slots({
		"2",
		"3"
	})
	assert(reserver:is_slot_reserved("1"))
	assert(not reserver:is_slot_reserved("2"))
	assert(not reserver:is_slot_reserved("3"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	reserver:free_slot("2", 2)
	assert(reserver:is_slot_reserved("1"))
	assert(not reserver:is_slot_reserved("2"))
	assert(reserver:is_slot_reserved("3"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:free_slot("1", 1)

	local allocations, _ = reserver:allocation_state()

	assert(allocations == 0)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:claim_slot("1", 1)

	local allocations, _ = reserver:allocation_state()

	assert(allocations == 1)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:claim_slot("1", 1)
	assert(reserver:is_slot_claimed("1"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slot("1", "1")
	assert(not reserver:is_slot_claimed("1"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:claim_slot("1", 1)
	assert(reserver:is_slot_reserved("1"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	assert(reserver:claim_slot("1", 1))
	assert(reserver:claim_slot("2", 2))
	assert(reserver:claim_slot("3", 3))
	assert(not reserver:claim_slot("4", 4))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:claim_slot("1", 1)
	reserver:claim_slot("2", 2)
	reserver:claim_slot("3", 3)
	reserver:free_slots({
		"1",
		"2"
	})
	assert(not reserver:is_slot_claimed("1"))
	assert(not reserver:is_slot_claimed("2"))
	assert(reserver:is_slot_claimed("3"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:claim_slot("1", 1)
	reserver:claim_slot("2", 2)
	reserver:claim_slot("3", 3)
	reserver:free_slot("1", 1)
	assert(not reserver:is_slot_claimed("1"))
	assert(reserver:is_slot_claimed("2"))
	assert(reserver:is_slot_claimed("3"))

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)
	local claimed, reserved = reserver:claim_slot("1", 1)

	assert(claimed)
	assert(reserved)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slot("1", "1", 1)

	local claimed, reserved = reserver:claim_slot("1", 1)

	assert(claimed)
	assert(reserved)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	assert(reserver:claim_slot("1", 1))

	local claimed, reserved = reserver:claim_slot("1", 2)

	assert(not claimed)
	assert(reserved)

	local slots = 3
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})

	local claimed, reserved = reserver:claim_slot("4", 4)

	assert(not claimed)
	assert(not reserved)

	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	reserver:reserve_slots("4", {
		"4"
	})
	reserver:free_slot("1", 1)
	assert(not reserver:is_slot_reserved("1"))
	assert(not reserver:is_slot_reserved("2"))
	assert(not reserver:is_slot_reserved("3"))
	assert(reserver:is_slot_reserved("4"))

	local allocations, _ = reserver:allocation_state()

	assert(allocations == 1)

	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2"
	})
	reserver:reserve_slots("1", {
		"3"
	})
	reserver:reserve_slots("4", {
		"4"
	})
	reserver:free_slot("1", 1)
	assert(not reserver:is_slot_reserved("1"))
	assert(not reserver:is_slot_reserved("2"))
	assert(not reserver:is_slot_reserved("3"))
	assert(reserver:is_slot_reserved("4"))

	local allocations, _ = reserver:allocation_state()

	assert(allocations == 1)

	local slots = 4
	local reserver = SimpleSlotReserver:new(slots)

	reserver:reserve_slots("1", {
		"1",
		"2",
		"3"
	})
	reserver:reserve_slots("4", {
		"4"
	})
	reserver:claim_slot("2", 2)
	reserver:free_slot("1", 1)
	assert(not reserver:is_slot_reserved("1"))
	assert(reserver:is_slot_reserved("2"))
	assert(not reserver:is_slot_reserved("3"))
	assert(reserver:is_slot_reserved("4"))
	assert(not reserver:is_slot_claimed("1"))
	assert(reserver:is_slot_claimed("2"))
	assert(not reserver:is_slot_claimed("3"))
	assert(not reserver:is_slot_claimed("4"))

	local allocations, _ = reserver:allocation_state()

	assert(allocations == 2)
end

return tests
