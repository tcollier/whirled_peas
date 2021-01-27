# Changelog

## v0.7.0 - 2021-01-27

BREAKING: the settings for the template now fills the full screen and disallows margin.

- [b7c12c2](https://github.com/tcollier/whirled_peas/tree/b7c12c2c34d7077b9c2496d05ddd0c6d1eb90699): Update template to fill full screen with border sizing
- [963b819](https://github.com/tcollier/whirled_peas/tree/963b8196f0d046ba03c893f07e5578bf8c88b7a3): Implement vertical alignment
- [4bddd54](https://github.com/tcollier/whirled_peas/tree/4bddd54bec5c8f93d145c285379c1816f313f35e): Add `between`, `around`, and `evenly` alignments

## v0.6.0 - 2021-01-25

- [73df2af](https://github.com/tcollier/whirled_peas/tree/73df2af1f1eac37fe94f720dce16da1ed568dade): Add support for scroll bars along both axes
- [f4f44e1](https://github.com/tcollier/whirled_peas/tree/f4f44e1ff6c75ed03cd682e3fa9921401dcd2d00): Implement remaining 3 flow directions for grids
- [c01d083](https://github.com/tcollier/whirled_peas/tree/c01d083e10bf70983109a8def836bb181099f59c): Implement reverse flow directions for grids

## v0.5.0 - 2021-01-25

BREAKING: there was a significant amount of structural refactoring in this release. While that aspect did not add or remove any features, it fixed several layout bugs (some known and some unknown), so most template with moderate complexity will now be laid out slightly differently.

- [3ddfede](https://github.com/tcollier/whirled_peas/tree/3ddfedee4ab2fadeecbe82c7c9caf25c2988f095): Allow relative positioning of containers
- [507e77c](https://github.com/tcollier/whirled_peas/tree/507e77c551bcb9cc832d5c24e2f24eb1afe4eddc): Add height attribute for container settings
- [af8ef19](https://github.com/tcollier/whirled_peas/tree/af8ef1950edebcd23a57a04982b22a56296ee09b): Add automated screen testing

## v0.4.1 - 2021-01-22

- [0f7aa6c](https://github.com/tcollier/whirled_peas/tree/0f7aa6ccc07323230dd602cb43e0341de5a69ad8): Allow relative path for config files

## v0.4.0 - 2021-01-22

- [7fd6712](https://github.com/tcollier/whirled_peas/tree/7fd6712818c94cdbfd81828277ca67c705e01793): BREAKING: replace `WhirledPeas.start` with command line executable
- [2535342](https://github.com/tcollier/whirled_peas/tree/25353424f1ab4af4880f44eb7ddd28afefbbb9b2): Add support for loading screen
- [7388fc2](https://github.com/tcollier/whirled_peas/tree/7388fc2eacdc8045b725311c11d650d6b8654be8): Add support for title fonts
- [b345155](https://github.com/tcollier/whirled_peas/tree/b345155b1c212cabe73f9a2562ac8dbbedbbb6df): Add command to list title fonts to executable
- [d3a8324](https://github.com/tcollier/whirled_peas/tree/d3a832496c36985993217ff11b6d83dd4697c4ed): Add commands for debugging application to executable

## v0.3.0 - 2021-01-21

- [617f802](https://github.com/tcollier/whirled_peas/tree/617f8027d6688a2ec81a3e594e529c94485cee85): BREAKING: send frames directly to EventLoop (`Producer#send` renamed to `Producer#send_frame`)

## v0.2.0 - 2021-01-20

- [73eb326](https://github.com/tcollier/whirled_peas/tree/73eb326426f9814e91e3bc7a60dfd87be3d69f7e): Convert "primitive" data types to strings
- [f28b69d](https://github.com/tcollier/whirled_peas/tree/f28b69df8b6cfc973da2ebc0b8da29b278f23433): Give elements names
- [1ae1c929](https://github.com/tcollier/whirled_peas/tree/1ae1c929429c2f8520054d33a064c2b6d71955fe): Consistently format exceptions in logs
- [4c2114f](https://github.com/tcollier/whirled_peas/tree/4c2114fd360fd98c65e6e32f905a377f09b919ee): Fix bug with negative sleep times
- [627bf12](https://github.com/tcollier/whirled_peas/tree/627bf126dd7f9c845f65105e0826d14a35a0a953): Don't reraise pipe error

## v0.1.1 - 2021-01-20

- [3852c8c](https://github.com/tcollier/whirled_peas/tree/3852c8c700c2e8fb92e65bbca1c99be74304c6d0): Improve error handling

## v0.1.0 - 2021-01-20

- [f343434](https://github.com/tcollier/whirled_peas/tree/f34343458097da04d5846ab13533e8226ba04d75): Inaugural release
