# EV_HMI — Handoff Package

This is the `HMI-codebase` folder (Raspberry Pi 5 side of an EV dashboard
project) plus the companion STM32 firmware, packaged after a review + fix
session that focused on the STM32 ↔ Raspberry Pi telemetry pipeline.

**For the full product README** (screenshots, feature tour, build
instructions, project structure) see [`docs/README.md`](docs/README.md).
This file is just the entry point for whoever received this zip.

## Start here

1. Read [`devlog.md`](devlog.md) — every change made this session, in
   order, with file references.
2. Read [`handoff.md`](handoff.md) — current state, what to verify first
   once you have the real hardware, open issues/decisions still needed.
3. `docs/communicationprotocol.md` and `docs/architecture.md` — background
   on the STM32↔Pi telemetry design that predates this session.

## What this session was about

The project is split into two hardware targets:

- **STM32** (`STM/main.c` / `STM/main.h` in this package — normally lives
  one level above `HMI-codebase/` in the working repo, copied in here for
  this handoff) — vehicle controller: reads throttle/brake/current/
  temperature sensors, runs a gear-state FSM, drives the motor via PWM, and
  transmits telemetry over UART at 10 Hz.
- **Raspberry Pi 5** (this folder) — the HMI: a Qt6/QML dashboard that
  receives that UART telemetry, blends it with a built-in physics simulator
  (for fields the STM32 doesn't measure, or for bench testing without
  hardware), and renders the cockpit UI.

Neither piece of hardware was available during this session (see
`handoff.md` for what that means for verification). The work was: an
end-to-end review of the telemetry pipeline, then fixes for a firmware
compile blocker and a data-pipeline bug where the Pi's simulator was
silently overwriting real STM32 telemetry, then wiring up the dashboard's
simulation on/off toggle (previously cosmetic) to actually govern which
values are real vs. simulated.

## Before you zip/forward this further

`config/api_keys.json` contains a live API key sitting on disk in this
folder (it's git-ignored, so it was never committed, but it's still
present here). Check `handoff.md`'s open-issues section before sending this
package anywhere it might be indexed, cached, or seen by someone who
shouldn't have that key.
