# Changelog

## master (unreleased)

## 0.6.0 (2017-05-31)

This is a backwards-compatible release.

### Added

- Support for Rails 5. ([#63](https://github.com/skroutz/cogy/pull/63))

## 0.5.2 (2017-01-25)

This is a bug fix release due to Cog 1.0.0.beta2. It is backwards-compatible
with previous Cog versions, but you'll get proper error reporting in Capistrano
if you upgrade to Cog 1.0.0.beta2.

### Fixed

- capistrano: Fix error handling with Cog 1.0.0.beta2 ([98bc5a5](https://github.com/skroutz/cogy/commit/98bc5a5))

## 0.5.1 (2017-01-25)

This release fixes a regression introduced in 0.5.0

### Fixed

- Revert back to the old behavior in Capistrano tasks: we still have
  to provide `:cogy_endpoint` in them. ([9f5bfb4](https://github.com/skroutz/cogy/commit/9f5bfb47aa5dc82390472693fab5822e3dbcb7fb))

## 0.5.0 (2017-01-25)

### Changed

- The `COGY_BACKEND` env. variable is now shipped from Cogy, so you don't have
  to set it in the Relays anymore ([#37](https://github.com/skroutz/cogy/issues/37)).
  This has the side-effect of `Cogy.cogy_endpoint` configuration being *required*
  if you use the Capistrano tasks, since they use it instead of the old,
  Capistrano-specific setting.

## 0.4.0 (2016-12-05)

This release requires the [cogy-bundle](https://github.com/skroutz/cogy-bundle)
to be at version 0.4.0 or later.

### Changed

- The 'user' parameter no longer exists in the incoming request path ([#60](https://github.com/skroutz/cogy/issues/60))

## 0.3.0 (2016-11-29)

This release requires the [cogy-bundle](https://github.com/skroutz/cogy-bundle)
to be at version 0.3.0 or later.

### Changed

- The incoming request from the Relay is now a POST ([#25](https://github.com/skroutz/cogy/issues/25))
- The complete Relay environment is now available as-is using the `env` helper
  inside commands ([#26](https://github.com/skroutz/cogy/issues/26))

## 0.2.1 (2016-11-28)

### Changed

- Capistrano 2 task is no longer hooked automatically ([65353](https://github.com/skroutz/cogy/commit/653532b1d673c64344f4e652044273224a2b005f))

## 0.2.0 (2016-11-28)

### Added

- Add Capistrano 2 & 3 integration ([#13](https://github.com/skroutz/cogy/issues/13))
- Add support for defining Cog Templates ([#3](https://github.com/skroutz/cogy/issues/3))
- Add support for returning JSON to Cog ([#3](https://github.com/skroutz/cogy/issues/3))
- Arguments can also be accessed by their names ([#53](https://github.com/skroutz/cogy/issues/53))

### Changed

- Bundle-related configuration is now grouped together ([#41](https://github.com/skroutz/cogy/issues/41))

### Fixed

- Cog arguments are now ordered properly ([8a550](https://github.com/skroutz/cogy/commit/8a55004ef80822a816a7c0e3fdd6202d968f8926))

## 0.1.1 (2016-11-25)

### Changed

- Everything in the Rails 4.2 series is now supported ([#47](https://github.com/skroutz/cogy/issues/47))
- Command options are now validated when initializing a command ([#48](https://github.com/skroutz/cogy/issues/48))
