# color-tabs-regex package

Use color-tabs package with regex.

This package use [color-tabs](https://github.com/paulpflug/color-tabs) services, and [String.match](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/match) or [minimatch](https://github.com/isaacs/minimatch) for tabs coloring.

Just edit ~/.atom/color-tabs-regex.cson (you can open it by "Color Tabs Regex: Edit Rules" command) like

`
"regex": "#color"
`

## Settings

* On settings page you can toggle "Break on first match" behavior.
* Select regex engine: String.match (default) or [minimatch](https://github.com/isaacs/minimatch)

## Screenshots

![settings](https://cloud.githubusercontent.com/assets/426007/8528492/f276ad2c-241b-11e5-8a72-7102cadef775.png)
![tabs](https://cloud.githubusercontent.com/assets/426007/8528501/f45f3a50-241b-11e5-8a93-9ebf27e33429.png)
