# color-tabs-regex package

Use color-tabs package with regex.

This package use [color-tabs](https://github.com/paulpflug/color-tabs) services, and [String.match](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/match) or (minimatch)[https://github.com/isaacs/minimatch] for tabs coloring.

Just edit ~/.atom/color-tabs-regex.cson (you can open it by "Color Tabs Regex: Edit Rules" command) like

`
"regex": "#color"
`

# Settings

* On settings page you can toggle "Break on first match" behavior.
* Select regex engine: String.match (default) or (minimatch)[https://github.com/isaacs/minimatch]
