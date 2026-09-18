# JokerDisplay Basic Buttons

A small compatibility mod for Android/desktop Balatro.

It requires:
- Basic Buttons 0.1.4+
- JokerDisplay 2.0.1+

When a Joker has JokerDisplay initialized, a **JokerDisplay — HIDE/SHOW** button is added to the normal Joker buttons.

This first version intentionally uses JokerDisplay's own:
`Card:joker_display_toggle()`

It does not replace or patch JokerDisplay's hide/show system.

## Install

Put the folder `JokerDisplayBasicButtons` inside your Balatro `Mods` folder.

The folder should contain:
- `JokerDisplayBasicButtons.json`
- `JokerDisplayBasicButtons.lua`

## Important

If the button does not appear, check the Steamodded log for:
- `basic_buttons`
- `JokerDisplay`
- `JokerDisplayBasicButtons`

The next possible version can experiment with double-tap/touch input instead of a visible button.
