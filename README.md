# IgorPro8-VSCode

igor.tmLanguage is based on https://github.com/byte-physics/language-igor and is being re-packaged for vscode default themes, both dark and light. Im testing with Light (Visual Studio), Light+ (defualt light), Dark (Visual Studio), Dark+ (defualt dark) but I also tried creating a custom theme pack.

After a couple of days of working on that custom theme pack I realized I can avoid making the user download a second add-on and instead code with the default theme packs in mind. 

After spending some time learning TypeScript and how to create syntax highlighting add-ons I found the easiest way was to find the vscode default themepack code and dig through it to find which scope corresponds to the colours we want from igor. From there I was able to modify the github linguist code to work for vscode. 

comments: done, considered invalid scope for the bright red color

strings: done, considered within the comment scope for the green color

keywords: like "if, else.." have been fixed and show up blue. are within keyword scope.

igor functions: placed within string.regexp scope for that muted red color

APMath and MatrixOP: Done, same as igor functions.

Igor operations: under constant.numeric scope for that light green/blue.

User-defined functions: falls under constant.regexp for the purple color, includes #pragmas. 

**Note: User defined functions are optionally highlighted in igorpro, I found it helpful to keep them highlighted here.
