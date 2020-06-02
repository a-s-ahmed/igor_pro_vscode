# igortest1 README

Currently a work in progress, igor.tmLanguage is based on https://github.com/byte-physics/language-igor and is being re-packaged for vscode default themes, both dark and light. Im testing with Light (Visual Studio), Light+ (defualt light), Dark (Visual Studio), Dark+ (defualt dark) but I also tried creating a custom theme pack.

After a couple of days of working on that as I realized I can avoid making the user download a second add-on and instead code with the default theme packs in mind. Will update when most features are added, and then focus on fixing bugs.

comments: done, considered invalid. for the bright red color
strings: done, considered comment. for the green color
    **Things like sprintf and Execute are same color, should be slightly diff ...
replaced constant.igor w/ keyword. in front for blue
igor functions: added string.regexp for that sorta red color

Need to look into documentation for igor to find everything that must be highlighted
*also missing #pragma being highlighted, alongside all similar things.
