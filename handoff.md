# Handoff

Context for continuing this work — whether that's a future model session, a
teammate, or future-you after the hardware arrives. Read `devlog.md` for the
full chronological change list; this file is "what to do next" and "what to
watch out for."

## Situation this session was done under

No physical hardware (STM32 or Raspberry Pi 5) was available. All changes
are source-level, verified with a standalone host-side C++ logic harness
that reproduces the edited control flow **without Qt** (no `moc`, no
QtSerialPort available in the dev environment). This proves the *logic* is
correct; it does **not** prove the project builds under the real Qt6 /
arm-none-eabi-gcc toolchains. Treat every change here as "logically
verified, build-unverified" until step 1 below is done.

## First things to do once you have hardware / a full toolchain

1. **Build both sides before anything else.**
   - STM32: rebuild `main.c` under STM32CubeIDE (or whatever toolchain this
     project normally uses). The duplicate-definition fix in `devlog.md`
     §2 was a hard compile blocker — the firmware would not have built at
     all before this session. Also confirm `PWR=%d` (not `%.1f`) — if you
     ever revert to a float print, you need `-u _printf_float` on the
     linker command line or the field silently disappears.
   - Pi: `cmake --build` this repo with Qt6 (`Quick SerialPort Multimedia
     Network NetworkAuth` components, per `CMakeLists.txt`). Watch for moc
     errors on the new `STMDataSimulator` slots
     (`onBatteryPercentReceived`, `onMotorPowerReceived`) and the new
     `TelemetryParser` constructor signature (now takes an optional
     `STMDataSimulator*` second argument) — `main.cpp` was already updated
     to pass `&stmSimulator`, but if anything else constructs
     `TelemetryParser` it needs the same treatment.

2. **Flash the STM32, connect UART, launch the Pi app, and immediately tap
   the simulation toggle to OFF** (Telemetry page → "RUNNING" tile). The
   app boots with `simulationActive = true` by default, so **you will see
   simulated data, not hardware data, until you flip that toggle** — this
   is the single most likely "why isn't my hardware showing up" moment
   tomorrow. Confirm `/dev/ttyACM0` is the STM32's actual device name
   (`ls /dev/ttyACM*` on the Pi) — `SerialManager` now auto-retries every
   2s, but it retries the *same* path passed to `connectPort()` in
   `main.cpp`; a mismatched name will retry forever and never connect.

3. **Watch the debug/comms page for `communicationFault` and
   `framesReceived`/`invalidFrames`.** Both were previously dead
   (`communicationFault` could never trip because liveness was never
   stamped; the frame counters never moved). They should now behave
   correctly in both toggle states — if `invalidFrames` climbs quickly,
   the UART framing/format has drifted from what `TelemetryParser` expects
   (`SPD=..,RPM=..,BAT=..,RNG=..,MT=..,BT=..,PWR=..,MODE=..,GEAR=..\r\n`).

4. **Sanity-check `SPD` on the dashboard reads as throttle %, not real
   km/h** — it will visually look like a speed gauge but is currently
   pedal position (0–99). This was known and intentionally left alone
   (see decision log below).

## Architecture, in one paragraph

Three components share ownership of `VehicleData` (the single Qt property
bag the QML UI binds to): `TelemetryParser` (parses real UART frames),
`STMDataSimulator` (bridge + liveness tracker — the *only* thing that calls
`markLive()`, and now the *only* thing with write authority over "Real"
fields when the toggle is OFF), and `VirtualVehicle` (10 Hz physics-model
simulator, the *only* thing with write authority over "Real" fields when the
toggle is ON or the STM is stale, and unconditional owner of "fully
simulated" + "derived" fields). Full protocol/architecture background
predating this session is in `docs/communicationprotocol.md` and
`docs/architecture.md` — read those first if this paragraph isn't enough.

## The three-bucket data model (confirmed with the user this session)

| Bucket | Rule | Fields |
|---|---|---|
| **Real** | Toggle OFF + STM live → hardware value. Toggle ON, or STM stale >500ms → simulated. | `speed`\*, `rpm`, `batteryPercent`, `motorTemp`, `motorPower`, `driveMode`, `gearState` |
| **Fully simulated** | Always simulated (STM never sends these). | `batteryTemp`, `controllerTemp`, `handBrake`, indicators, lights, odometer/trips, charging\*\*, cooling, `regenLevel` |
| **Derived** | Always simulated, by explicit decision — even in real mode. | `rangeKm`, `batteryVoltage`, (`batteryCurrent`, `chargeTimeRemaining` display fields — see open issue below, currently hardcoded not derived) |

\* mislabeled — carries throttle %, see open issues.
\*\* `chgstat`/`pwr`/`chgtime` on the Telemetry page are currently hardcoded
strings, not wired to the real `charging`/`chargingPower`/
`chargeTimeRemaining` properties at all — see open issues.

The mechanism (for anyone extending this to a new field): a Real field needs
(a) an entry in the `StmField` enum in `STMDataSimulator.h`, (b) an
`onXReceived()` intake slot that calls `markLive()` unconditionally and
writes to `VehicleData` only behind `hardwareOwnsOutput()`, (c) a parser
branch in `TelemetryParser::parsePacket()` that calls the new slot, and (d)
a `simPublishes(StmField::X)`-gated write in `VirtualVehicle::publish()`.
Skipping any one of the four re-creates the "simulator overwrites hardware"
bug this session fixed.

## Open issues — not fixed, need a decision or more info

1. **`simulationActive` default is `true`.** Boots into simulation. Fine for
   a bench with no hardware attached; means a hardware demo needs a manual
   toggle tap. Flip the default in `VehicleData.h` if you'd rather it boot
   into real mode automatically.
2. **`TelemetryPage.qml::resolveValue()` hardcodes several fields**
   (`vbat`→`"72.4"`, `ibat`→`"18.2"`, `chgstat`→`"OFF"`, `pwr`→`"0.0"`,
   `chgtime`→`"0"`, `odo`→`"00124.8"`, `trip`→`"12.6"`) instead of reading
   `vehicleData.batteryVoltage`, `vehicleData.charging`, etc. These rows
   will never move regardless of the toggle or real hardware. Low-risk QML
   fix, not attempted this session — ask before touching if the recipient
   wants a specific look preserved.
3. **`SPD` semantics.** STM sends `throttle_percent` (0–99 pedal position)
   labeled as `SPD`. A real speed would need to be derived from
   `motor_rpm` (the wheel-sensor reading) via wheel circumference and any
   gear ratio, which weren't available/specified this session.
4. **Speed-sensor pull-up.** `main.c` configures PC0 with `GPIO_PULLUP`,
   but the header comment above it says the internal pull-up should be
   *disabled* because there's an external 10 kΩ pull-up on the LM393
   sensor. Left as `PULLUP` intentionally (safe either way — works whether
   or not the external resistor is actually populated) but worth 30
   seconds with a multimeter on the real board to confirm which is
   correct for calibration accuracy.
5. **`config/api_keys.json` contains a live RapidAPI key.** It's
   git-ignored (won't get committed), but it **is sitting on disk in this
   folder**, and this folder is about to be zipped for handoff. Confirm the
   recipient is trusted before including it, or delete/redact the file
   from the zip first.

## Files touched this session

STM32 (lives at the repo root, one level above this folder, in normal
development; a copy is included at `STM/main.c` / `STM/main.h` in this
handoff package for self-containedness — sync any further edits back to the
canonical repo-root copy, don't fork the two):
- `main.c`

Raspberry Pi HMI (this folder):
- `backend/STMDataSimulator.h`, `backend/STMDataSimulator.cpp`
- `backend/TelemetryParser.h`, `backend/TelemetryParser.cpp`
- `backend/SerialManager.h`, `backend/SerialManager.cpp`
- `backend/VirtualVehicle.cpp`
- `main.cpp`

Nothing in `qml/` was modified this session (issue #2 above describes a
gap that was found but intentionally left untouched).
