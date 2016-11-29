# Changelog

## master (unreleased)

## 0.3.0 (2016-11-29)

This release requires the [cogy-bundle](https://github.com/skroutz/cogy/issues/25)
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
