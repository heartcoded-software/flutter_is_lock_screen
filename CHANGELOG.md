## [4.0.1] - 2026-07-15

* iOS: replaced the `UIScreen.main.brightness == 0.0` heuristic. Brightness is
  the screen setting, not a lock indicator (anymore?). Locked devices usually still
  report the user's brightness, producing false "unlocked" answers from
  background execution contexts. `isLockScreen` now checks, in order:
  app active in the foreground → unlocked; device passcode set (via
  `LAContext.canEvaluatePolicy`) → lock state derived from
  `isProtectedDataAvailable`, which works from background contexts and
  detects the device being in use while another app is in front, no
  passcode → locked (conservative, no distinguishing signal exists, and a
  false "locked" is recoverable for callers while a false "unlocked" is
  not). In the passcode path, `brightness == 0.0` is kept as an additional
  locked-hint to narrow the "Require passcode after X minutes" window where
  the display is off but protected data is still available — as a weak
  signal it may only push the answer toward "locked", never toward
  "unlocked". Android is unchanged.

## [3.0.0] - 2025-01-17

* Re-created plugin from scratch and moved code from old is_lock_screen to here

## [2.0.0] - 2021-04-08

* Support null safety

* Clean up unused code and debug prints in iOS native part

* Update and and clean up example code

## [1.0.0] - 2020-07-16

* Initial release
