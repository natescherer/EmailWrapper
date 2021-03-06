# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.1] - 2021-05-05
### Fixed
- ExternalModuleDependencies field in module manifest

## [2.0.0] - 2021-04-30
### Changed
- Message encoding now defaults to UTF-8
- Send-HtmlMailMessage now uses Mailozaurr module (which uses MailKit) to send email as Send-MailMessage is being deprecated

### Removed
- UseSsl parameter on Send-HtmlMailMessage, as Mailozaurr/MailKit automatically negotiates encryption
- LastLine parameter from Send-HtmlMailMessage, as it was superfluous with the Footer parameter
- Invoke-CommandWithEmailWrapper, as it was not cross-platform friendly

## [1.1.0] - 2019-02-21
### Added
- Unstyled table/th/td tags included in Send-HtmlMailMessage are now formatted

### Changed
- LastLine property on Send-HtmlMailMessage no longer set by default

### Fixed
- Version numbers now match between GitHub and PowerShell Gallery releases

## [1.0.0] - 2018-11-07
### Added
 - Send-HtmlMailMessage cmdlet
 - Invoke-CommandWithEmailWrapper cmdlet

[Unreleased]: https://github.com/natescherer/PoshEmail/compare/v2.0.1..HEAD
[2.0.1]: https://github.com/natescherer/PoshEmail/compare/v2.0.0..v2.0.1
[2.0.0]: https://github.com/natescherer/PoshEmail/compare/v1.1.0..v2.0.0
[1.1.0]: https://github.com/natescherer/PoshEmail/compare/v1.0.0..v1.1.0
[1.0.0]: https://github.com/natescherer/PoshEmail/tree/v1.0.0