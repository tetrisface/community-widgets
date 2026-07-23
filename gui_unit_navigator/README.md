===== UNIT NAVIGATOR =====

Unit Navigator is an experimental RmlUi selection overlay for navigating recent command-backed unit groups. Hold CapsLock to open the QWE / ASD grid, hover or press a grid key to preview a group, and release CapsLock to commit. A second grid key commits a semantic subgroup. Left-click commits immediately; Escape, right-click, or leaving the configured guard cancels and restores the previous camera.

The activation and traversal keys are remappable in the built-in settings panel. CapsLock is only the initial default because operating systems and keyboard layouts do not all expose its toggle behavior in the same way.

If an activation binding becomes unusable, restart the widget five times within 20 seconds. Unit Navigator clears only the activation binding and reopens onboarding; choose a new activation key in settings. The rapid-restart history is consumed when recovery triggers, so it cannot repeatedly clear the replacement key.

--- GROUPING ---

- Recent cards contain authoritative command recipients. Units in the issued selection that did not receive the command are exposed as a selectable Skipped subgroup and are not selected by the card root.
- Formation recipients reported in one dispatch stay grouped even when each unit has a distinct position.
- Pure construction queues compare as unordered multisets of normalized building type, x/z position, facing, and duplicate count.
- Other queues preserve command order. Runtime command tags and timestamps are not part of equivalence.
- Pinned slots are stable. Unpinned cards use strict MRU ordering around those slots.

Pins are match-local. Their population definition can be a manual set, exact unit types, or All army. All army means owned, mobile, combat-capable units. Automatic populations accept include/exclude selections. Split strategy can be semantic queue, strict unit type, or unit type followed by semantic queue.

--- COMMAND EVENT IOC ---

The composition root combines ordinary `CommandNotify`, BAR's optional `UnitCommandNotify(unitID, cmdID, params, opts)`, and authoritative `UnitCommand`. It snapshots queues two frames after a dispatch. It has no dependency on formation or custom-command widgets.

Producers that already have a high-level dispatch boundary may optionally call:

```
WG.UnitNavigator.RecordBatch({
  batchID = "optional-stable-id",
  semanticKind = "formation",
  selectedUnitIDs = {...},
  recipientUnitIDs = {...},
  commandID = CMD.MOVE,
  paramsByUnit = {[unitID] = {x, y, z}},
})
```

Only currently owned recipient units are admitted. Producers remain optional; this API enriches grouping but is not needed for fallback observation.

--- CURRENT VERTICAL-SLICE LIMIT ---

Each card uses the live minimap texture, current/other-unit markers, queued destination rings, and approximate build-footprint squares as its tactical signal. RmlUi does not provide six independent world cameras, so true cropped perspective renders and precise footprint geometry are deliberately behind the future renderer seam. Camera preview itself is live and centers on the current group.
