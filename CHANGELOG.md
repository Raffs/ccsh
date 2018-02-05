# CCSH Changelog

All notables changes to the CCSH project will be documented in this file

## [1.0.0] - Unreleased

### [0.0.5] - Unreleased

#### Added

- (Issue: [#18]) - Investigate why the sudo command it's taking to long to execute.
- (Issue: [#21]) - Added validation code to empty targets and filters.
- (Issue: [#19]) - Improve the CI Process (tag, PR's, branches and travis deployments).
- (Issue: [#16]) - Add a enable_sudo, sudo_user and sudo_password options.

#### Fixes

- (Issue: [#17]) - Add a validation code to quit the system when there's no group or servers matched.

### [0.0.4] - Jan 19, 2018

#### Added

- (Issue: [#8])  - Handle ruby errors with better and understandable messages
- (Issue: [#4])  - Implement the max_threads options
- (Issue: [#12]) - Add --show-hosts option.
- (Issue: [#10]) - Handle more then one group or host filter.
- (Issue: [#7])  - Added the output to file option.

#### Fixes

- (Issue: [#13]) - Fix the verbose command not showing the target messages.
- (Issue: [#9]) - Fix special characters on the gem authors name.

### [0.0.3] - Dec 29, 2017

#### Fixes

- (Issue: [#6]) - Fix the default option that points to user's home directory.

### [0.0.2] - Dec 27, 2017

#### Added

- (Issue: [#3]) - Use ssh_options for parsing ruby SSH extended options.
- (Issue: [#2]) - Enable the Usage of private_key instead of only password.
- (Issue: [#1]) - Use threads to execute the ssh connections.

# That's all folks

[0.0.2]: https://github.com/raffs/ccsh/compare/v0.0.1...v0.0.2
[0.0.3]: https://github.com/raffs/ccsh/compare/v0.0.2...v0.0.3
[0.0.4]: https://github.com/raffs/ccsh/compare/v0.0.4...v0.0.3
[0.0.5]: https://github.com/raffs/ccsh/compare/v0.0.5...v0.0.4
[#1]: https://github.com/raffs/ccsh/issues/1
[#2]: https://github.com/raffs/ccsh/issues/2
[#3]: https://github.com/raffs/ccsh/issues/3
[#4]: https://github.com/raffs/ccsh/issues/4
[#6]: https://github.com/raffs/ccsh/issues/6
[#7]: https://github.com/raffs/ccsh/issues/7
[#8]: https://github.com/raffs/ccsh/issues/8
[#9]: https://github.com/raffs/ccsh/issues/9
[#10]: https://github.com/raffs/ccsh/issues/10
[#12]: https://github.com/raffs/ccsh/issues/12
[#13]: https://github.com/raffs/ccsh/issues/13
[#16]: https://github.com/raffs/ccsh/issues/16
[#17]: https://github.com/raffs/ccsh/issues/17
[#18]: https://github.com/raffs/ccsh/issues/18
[#19]: https://github.com/raffs/ccsh/issues/19
[#21]: https://github.com/raffs/ccsh/issues/21
