# Devlog

Chronological record of every change made during this session, across both
halves of the project: the STM32 firmware (`main.c` / `main.h`, at the repo
root **outside** `HMI-codebase/`) and the Raspberry Pi HMI (this folder).

Session context: hardware (STM32 + Raspberry Pi 5) was not available to the
developer during this session. All work is source-level review + fixes,
verified with a standalone host-side C++ logic harness (no Qt) that
reproduces the exact edited control flow. **Nothing has been build-tested
against real Qt6/STM32 toolchains yet** — see `handoff.md` for what to run
first once hardware is in hand.

---

## 1. End-to-end review (no code changes)

Read the full pipeline: STM32 ADC sampling → UART transmit (`main.c`) →
`SerialManager` → `TelemetryParser` → `VehicleData` → QML, cross-referenced
against `VirtualVehicle` (simulator) and `STMDataSimulator` (liveness/bridge
layer). Findings:

- **Blocker** — `main.c` had `last_vcu_tick` / `VCU_LOOP_MS` defined twice at
  file scope → hard compile error.
- **Blocker** — `TelemetryParser` wrote parsed STM values straight into
  `VehicleData`, bypassing `STMDataSimulator::markLive()`. Since liveness was
  never stamped, `VirtualVehicle` (running at 10 Hz) unconditionally
  republished simulated values over real ones on every tick — real hardware
  telemetry would never have been visibly shown.
- `PWR` field used `%.1f` (float `printf`), which newlib-nano omits by
  default (`-u _printf_float` required) — risk of the field silently
  vanishing on the wire.
- `hadc1` used `ScanConvMode=ENABLE` + `ContinuousConvMode=ENABLE` with two
  ranks read by sequential polling — classic setup for the throttle/NTC-temp
  ranks to desync/swap.
- `SPD` telemetry field actually carries `throttle_percent` (0–99 pedal %),
  not a real speed derived from the wheel sensor.
- `BAT`, `RNG`, `PWR` were unconditionally simulation-owned in
  `VirtualVehicle::publish()` — no `StmField` enum entries existed for them,
  so even after fixing the liveness bug they could never win.
- `SerialManager` opened the port once at startup with no retry — boot-order
  dependent (STM32 enumerating after the Pi app starts would permanently
  fail the link).
- Diagnostic counters (`framesReceived`, `invalidFrames`, etc.) existed on
  `VehicleData` but nothing ever incremented them.

## 2. STM32 firmware fixes (`main.c`)

- **Removed duplicate `last_vcu_tick` / `VCU_LOOP_MS` definitions** (second
  occurrence, originally around line 196). Firmware would not compile
  otherwise.
- **`PWR` now sent as integer watts** (`PWR=%d` instead of `PWR=%.1f`) —
  removes the float-`printf` linker dependency. Pi-side now divides by 1000
  to get kW for display.
- **`hadc1.Init.ContinuousConvMode` set to `DISABLE`** — with scan mode +
  polled reads + a `Start`/`Stop` each 10 ms VCU loop, this keeps rank 1
  (throttle) and rank 2 (NTC temp) from swapping.
- Added inline comments documenting: why PWR is integer, and that
  `RNG`/`BT` are fixed placeholders the Pi is expected to ignore (no range
  estimator / no battery-temp sensor on the bench rig).

## 3. Raspberry Pi HMI — real-data pipeline fix (Blocker 2)

**`backend/STMDataSimulator.h` / `.cpp`**
- Added two new `StmField` enum members: `BatteryPercent`, `MotorPower`
  (placed before the existing `Count` sentinel).
- Added intake slots `onBatteryPercentReceived(int)` and
  `onMotorPowerReceived(float)`, following the existing
  `onXReceived()` pattern (forward to `VehicleData`, then `markLive()`).

**`backend/TelemetryParser.h` / `.cpp`** — rewritten:
- Constructor now takes an optional `STMDataSimulator*`. When provided,
  every parsed field is routed through the simulator's `onXReceived()`
  slots instead of writing `VehicleData` directly — this is what makes
  `markLive()` actually fire, which is what makes hardware data win.
- Numeric fields (`SPD`, `RPM`, `BAT`, `MT`, `PWR`) are now validated with
  `toInt(&ok)`; a non-numeric or empty value is skipped rather than
  defaulting to `0`, so a truncated/corrupted UART frame can't push a
  garbage zero onto a gauge.
- `PWR` is converted from the STM's watts to kW (`/1000.0f`) before being
  forwarded — matches the unit the whole QML UI displays (`motorPower` is
  shown as kW everywhere: `AppShell.qml`, `DiagnosticsPage.qml`,
  `PowertrainPage.qml`, `OverviewPage.qml`).
- `RNG` and `BT` are explicitly parsed-and-discarded (STM only sends fixed
  placeholders `180` / `35` for these — no range estimator, no battery-temp
  sensor) so the simulator keeps owning them.
- `VehicleData::framesReceived` / `invalidFrames` are now actually
  incremented — a frame with at least one valid `key=value` pair counts as
  received; a frame with none counts as invalid.

**`backend/VirtualVehicle.cpp` (`publish()`)**
- Extended the field-authority gate to cover `BatteryPercent` and
  `MotorPower` (previously always simulation-owned).
- Removed the old unconditional second `setMotorPower()` call further down
  in `publish()` that would have clobbered the newly-gated write.

**`main.cpp`**
- `TelemetryParser parser(&vehicleData);` → `TelemetryParser parser(&vehicleData, &stmSimulator);`
- Replaced the stale comment block (which described this exact bug as a
  known TODO) with a comment describing the fix as implemented.

**`backend/SerialManager.h` / `.cpp`** — rewritten for resilience:
- Added a 2-second reconnect `QTimer`. `connectPort()` now arms it on
  failure instead of just logging and giving up.
- Added `errorOccurred` handling: `ResourceError` / `PermissionError` /
  `DeviceNotFoundError` close the port, emit `connectionLost()`, and
  re-arm the reconnect timer — recovers automatically from a cable pull or
  an STM32 reset without restarting the Pi app.
- Clears the read buffer on a fresh successful open, so a stale partial
  frame from a previous connection can't get concatenated with the first
  bytes of a new one.

**Verification** — wrote a standalone host-side C++ harness
(`datapath_test.cpp`, kept outside this repo in the scratch dir, not
checked in) that reproduces the STM `snprintf` format, the new parser
logic, `STMDataSimulator` liveness stamping, and `VirtualVehicle::publish()`
gating without needing Qt. Compiled with `g++ -std=c++17` and run — all
checks passed:
- STM packet format round-trips correctly.
- Real values (`SPD`, `RPM`, `BAT`, `MT`, `PWR`→kW, `MODE`, `GEAR`) reach
  `VehicleData` and survive a simulator tick while the link is live.
- `RNG` (and `BT`) stay simulator-owned.
- After 500 ms of no new frames, the simulator reclaims every gated field
  (liveness timeout works).
- A corrupted frame (`SPD=,RPM=xx`) does not overwrite existing values and
  increments `invalidFrames`.

Static sweeps confirmed: no duplicate STM32 definitions remain, `PWR` format
is `%d`, `hadc1` continuous mode is off, the parser is constructed with the
simulator pointer, and there is exactly one gated `setMotorPower` /
`setBatteryPercent` call site each.

## 4. Simulation toggle — wiring `simulationActive` to the data path

Discovered that `VehicleData::simulationActive` (bound to a toggle on the
Telemetry page, `TelemetryPage.qml`) was **cosmetic only** — it changed
"RUNNING"/"STOPPED" text labels but was not read anywhere in
`VirtualVehicle` or `STMDataSimulator`. Data source selection was purely
liveness-based (from fix #3 above), with no manual override.

Clarified the intended model with the user: three variable categories —
**Real** (STM-measured, should honor the toggle), **Fully simulated** (STM
never sends these, always simulated), **Derived** (computed from other
values, e.g. range/voltage/current/charge-time). Two decisions confirmed:
- Toggle **OFF** = real values, with **live fallback** to simulation if the
  STM link goes stale (so gauges never freeze on a dead link).
- **Derived** variables stay simulator-computed regardless of toggle state
  (the STM doesn't supply the raw ingredients they'd need in real mode for
  most of them, e.g. range needs a proper energy model, not just SoC).

**`backend/VirtualVehicle.cpp` (`publish()`)**
- Replaced the `stmOwns(field)` gate (`isLive(field)`) with
  `simPublishes(field)` = `vehicleData->simulationActive() ||
  !isLive(field)`. A Real field is now published by the simulator when the
  toggle is ON, OR when the STM isn't currently supplying it (live
  fallback). Fields the STM never sends have permanently-false `isLive()`,
  so they still publish unconditionally — "fully simulated" behavior falls
  out of the same rule for free.

**`backend/STMDataSimulator.h` / `.cpp`**
- Added a private `hardwareOwnsOutput()` helper = `!simulationActive()`.
- Every `onXReceived()` intake slot now: always calls `markLive()`
  (liveness/`communicationFault` tracking must stay accurate regardless of
  toggle state), but only writes the value into `VehicleData` when
  `hardwareOwnsOutput()` is true. This stops the parser and the simulator
  from fighting over the same field at 10 Hz when the toggle is ON and the
  STM is still physically transmitting.

**Verification** — extended the host-side test harness with the toggle
dimension. All scenarios pass:
- Toggle OFF + STM live → real hardware values shown.
- Toggle OFF + STM live → simulator tick does not overwrite them.
- Toggle OFF + STM goes stale (>500 ms) → simulator reclaims the fields.
- Toggle ON + STM still streaming real frames → simulated values are shown,
  hardware writes are suppressed at intake (no fight), and liveness is
  still stamped so comm-fault detection keeps working.
- Corrupted frame still rejected in either toggle state.

## 5. Known issues flagged but not fixed (see `handoff.md`)

- `simulationActive` defaults to `true` (`VehicleData.h`) — app boots into
  simulation; one tap on the Telemetry page toggle is needed to see real
  hardware data.
- Several `TelemetryPage.qml` `resolveValue()` entries are hardcoded
  strings (`vbat`, `ibat`, `chgstat`, `pwr`, `chgtime`, `odo`, `trip`) and
  are not bound to `VehicleData` at all — toggling simulation has no visible
  effect on those rows.
- `SPD` telemetry is throttle pedal %, not a calibrated vehicle speed
  derived from the wheel sensor — left as-is pending a decision on
  wheel-circumference/gear-ratio constants.
- Speed-sensor GPIO pull-up (`GPIO_PULLUP` on PC0) contradicts the header
  comment claiming the internal pull-up should be disabled in favor of an
  external 10 kΩ resistor — left as the safer default (works with or
  without the external resistor actually populated).
- `config/api_keys.json` contains a live RapidAPI key on disk (it is
  git-ignored, so not committed, but it **is** present in a folder that is
  about to be zipped for handoff) — see `handoff.md` before sending.
