assert(DialogueLookup[DialogueLookup_n + 1] == nil)
assert(DialogueLookup[DialogueLookup_n + 2] == nil)

DialogueLookup[DialogueLookup_n + 1] = "event_survive_almost_done"
DialogueLookup[DialogueLookup_n + 2] = "event_survive_keep_coming_a"
DialogueLookup_n = DialogueLookup_n + 2
