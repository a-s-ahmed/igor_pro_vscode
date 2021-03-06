# Igor Pro Syntax Highlighting in Visual Studio Code (400+ installs, 5-star rating)

This is the code for my extension: https://marketplace.visualstudio.com/items?itemName=qmsc.ipf 

Tested with Igor Pro 8 and all basic theme packs, should work with all versions and theme packs.

## For best results on every theme pack:
If you notice your results aren't perfect and you're using a relatively unknown theme pack consider following these steps.

1. Hit Ctrl+Shift+P
2. Search for "user settings" and click "Preferences: Open User Settings"
3. On the left click "Workbench", and then "Appearance".
4. You should see "Edit in settings.json" Under Color Customizations, click it.
5. before the last } paste the code at the end of this file. you may be prompted to add a , at the end of the line before the inserted code.
6. Enjoy!


## Some Dev notes
igor.tmLanguage is based on https://github.com/byte-physics/language-igor .

comments:  considered invalid scope for the bright red color

strings: considered within the comment scope for the green color

keywords: "if, else.." have been fixed and show up blue. are within keyword scope.

igor functions: placed within string.regexp scope for that muted red color

APMath and MatrixOP: same as igor functions.

Igor operations: under constant.numeric scope for that light green/blue.

User-defined functions: falls under constant.regexp for the purple color, includes #pragmas. 


**Note: User defined functions are optionally highlighted in igorpro, I found it helpful to keep them highlighted here.



## settings.json optional addition

    "editor.tokenColorCustomizations": {
        "textMateRules": [
            {
                "scope": "invalid.comment.igor",
                "settings": {
                    "foreground": "#FF0000",
                }
            },
            {
                "scope": "comment.string.tag.igor",
                "settings": {
                    "foreground": "#009C00",
                }
            },
            {
                "scope": "keyword.constant.igor",
                "settings": {
                    "foreground": "#0000FF",
                }
            },
            {
                "scope": "constant.numeric.operations.igor",
                "settings": {
                    "foreground": "#007575",
                }
            },
            {
                "scope": "string.regexp.variable.igor",
                "settings": {
                    "foreground": "#C34E00",
                }
            },
            {
                "scope": "constant.regexp.function.igor",
                "settings": {
                    "foreground": "#9C00FD",
                }
            },
            
        ]
    },
