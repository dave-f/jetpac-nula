# jetpac-nula

A VideoNuLA version of the classic BBC Micro game.  Features reworked graphics for:

* Player
* Fuel pod
* Platforms
* Items
* Aliens

The rockets are left alone because I felt these were so iconic to the game.

# Tools required

To build and apply the patch you'll need these tools:

* [beebasm](https://github.com/stardot/beebasm)
* [png2bbc](https://github.com/dave-f/png2bbc)
* [snap](https://github.com/dave-f/snap)
* [emacs](https://www.gnu.org/software/emacs)

Emacs Lisp is used as a scripting language to post-process some of the graphics, make tables etc. mainly because I use Emacs heavily so this was at my fingertips already.  The `repack.el` file drives all this, and requires 2 other packages to be installed (see comments in the file).

# Building

Edit the `makefile` to point at the tools detailed above and running `make gfx` followed by `make` should build `jetpac-nula.ssd` which can then be loaded into a BBC Micro emulator, preferably one that supports the VideoNuLA, eg [b2](https://github.com/tom-seddon/b2)

# Thanks

Many thanks to Chris Hogg for the artwork, and Tom Seddon for the NuLA detection code.