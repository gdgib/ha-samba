# Changelog

## 10.0.1

Create a root share which contains all the other shares.  This way you
can mount all of the exported directories under a single drive letter if
desired. 

## 10.0.0

BREAKING CHANGE: Don't mangle filenames

By default, Samba mangles filenames with special characters to ensure
compatibility with really old versions of Windows which have a very limited
charset for filenames. The add-on no longer does this as modern operating
systems do not have these restrictions.

- Don't mangle filenames (fixes #2541)
- Upgrade Alpine Linux to 3.16

## 9.7.0

- Upgrade Alpine Linux to 3.15
- Sign add-on with Codenotary Community Attestation Service (CAS)

## 9.6.1

- Remove lo from interface list
- Exit with error if there are no supported interfaces to run Samba on

## 9.6.0

- Run on all supported interfaces

## 9.5.1

- Add `hassio_api` to add-on configuration

## 9.5.0

- Remove interface options in favor of network

## 9.4.0

- Upgrade Alpine Linux to 3.13
- Rewrite configuration generation code

## 9.3.1

- Update options schema for passwords

## 9.3.0

- Support new media folder
- Update Samba to 4.12.6
- Upgrade Alpine Linux to 3.12

## 9.2.0

- Pin base image version
- Rewrite add-on onto S6 Overlay
- Use default configuration location
- Add support for running in compatibility mode (SMB1/NT1)
- Add dummy files to reduce number of errors/warnings in log output

## 9.1.0

- Allow IPv6 link-local hosts by default, consistent with IPv4

## 9.0.0

- New option `veto_files` to limit writing of specified files to the share

## 8.3.0

- Fixes a bug in warning log message, causing start failure
- Minor code cleanups

## 8.2.0

- Update from bash to bashio

## 8.1.0

- Update Samba to version 4.8.8

## 8.0.0

- Fix access to /backup

