# 2026-11-04: Save pearl's Omarchy settings

pearl (Dell XPS 14 DA14250, Omarchy 4.0.6) is being retired. Its settings were
compared with Omarchy's shipped defaults in `/usr/share/omarchy/config`, and only
the real changes were added, applied only on Omarchy machines:

- Hyprland: natural touchpad scrolling.
- Omarchy bar: Tailscale indicator. Default agent: codex.
- Voxtype dictation config and its user service.
- Chromium flags with `WebRtcPipeWireCamera`.
- Package script for the apps added on top of Omarchy.

Not carried over: Omarchy's own defaults (Tokyo Night, web apps, its LazyVim
setup; the repo's nvim config replaces it), pearl's mise list (adds claude,
codex and gh via mise; the shared config stays on node LTS), and the
DA14250-only camera work (custom kernel and libcamera builds). That work is
reported upstream in omacom/omarchy#17604 and backed up off-machine.
