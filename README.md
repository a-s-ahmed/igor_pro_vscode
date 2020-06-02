# IgorPro8-VSCode

Currently a work in progress, igor.tmLanguage is based on https://github.com/byte-physics/language-igor and is being re-packaged for vscode default themes, both dark and light. Im testing with Light (Visual Studio), Light+ (defualt light), Dark (Visual Studio), Dark+ (defualt dark) but I also tried creating a custom theme pack.

After a couple of days of working on that as I realized I can avoid making the user download a second add-on and instead code with the default theme packs in mind. Will update when most features are added, and then focus on fixing bugs.

comments: done, considered invalid scope for the bright red color

strings: done, considered within the comment scope for the green color

keywords: like "if, else.." have been fixed and show up blue. are within keyword scope.

APMath and MatrixOP: Done, same as igor functions.

igor functions: placed within string.regexp scope for that muted red color

Igor operations: under constant.numeric scope for that light green/blue.

		*AppendImage not being highlighted for some reason despite being in the list when on line 280 etc? but works when on its own line?
        further research suggests I might need to modify the regular expression to ensure we don't skip over a line just bc we've found one thing on that line.

Need to look into documentation for igor to find everything that must be highlighted
*also missing #pragma being highlighted, alongside all similar things.
