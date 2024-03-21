# Tsunami's Nix Config

Originally forked from: [EmergentMind](https://github.com/EmergentMind/nix-config) after I saw his great videos on [youtube](https://www.youtube.com/watch?v=YHm7e3f87iY) detailing how he thought to structure his flake. It (mostly) jived with my intentions, so here we are.

See [Docs](./docs/Readme.md)

## Purpose

The purpose of this repository is to unify, finally, all of the IT stuff that I have to do in my personal life into a single configuration and architecture

## Long-term Objectives

- [x] Remove all secrets and make this repo public
  - [x] Checked with gitleaks. Known keys released with risk analysis completed
  - [x] All secrets are in a private sops-nix repo
- [ ] Have all Bedford and Lafayette hosts on NixOS or nix-darwin
- [ ] Automatic host key and secrets provisioning
- [ ] Pre-flight VM testing
- [ ] Convert a majority of user configuration into a module
- [ ] Move to numtide/devshell
- [ ] Remove the old reference material