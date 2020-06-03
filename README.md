# IgorPro8-VSCode

## For best results on every theme pack:
Follow these steps if you're not using Dark (Visual Studio), Dark+ (defualt dark) and you want the syntax highlighting to still match IgorPro's exactly. Light (Visual Studio), Light+ (defualt light) still work well but user-defined functions and igor functions appear very similarly.

1. Hit Ctrl+Shift+P
2. Search for "user settings" and click "Preferences: Open User Settings"
3. On the left click "Workbench", and then "Appearance".
4. You should see "Edit in settings.json" Under Color Customizations, click it.
5. before the last } paste the contents of Theme_overide.json. you may be prompted to add a , at the end of the line before the inserted code.
6. Enjoy!


igor.tmLanguage is based on https://github.com/byte-physics/language-igor and is being re-packaged for vscode default themes, both dark and light. Im testing with Light (Visual Studio), Light+ (defualt light), Dark (Visual Studio), Dark+ (defualt dark) but I also tried creating a custom theme pack.

After a couple of days of working on that custom theme pack I realized I can avoid making the user download a second add-on and instead code with the default theme packs in mind. 

After spending some time learning TypeScript and how to create syntax highlighting add-ons I found the easiest way was to find the vscode default themepack code and dig through it to find which scope corresponding to the colours we want from igorPro. From there I was able to modify the github linguist code to work for vscode. 

comments:  considered invalid scope for the bright red color

strings: considered within the comment scope for the green color

keywords: "if, else.." have been fixed and show up blue. are within keyword scope.

igor functions: placed within string.regexp scope for that muted red color

APMath and MatrixOP: same as igor functions.

Igor operations: under constant.numeric scope for that light green/blue.

User-defined functions: falls under constant.regexp for the purple color, includes #pragmas. 

**Note: User defined functions are optionally highlighted in igorpro, I found it helpful to keep them highlighted here.





