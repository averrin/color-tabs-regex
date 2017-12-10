# Sorry, this plugin not supported anymore.
# But you can try some alternative: [here](https://github.com/averrin/color-tabs-regex/issues/18)

# color-tabs-regex package

Use color-tabs package with regex.

This package use [color-tabs](https://github.com/paulpflug/color-tabs) services, and [String.match](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/match) or [minimatch](https://github.com/isaacs/minimatch) for tabs coloring.

Just edit ~/.atom/color-tabs-regex.cson (you can open it by "Color Tabs Regex: Edit Rules" command) like

```
"regex": "#color"
"prefix":
  "regex": "#anothercolor"
```

When using prefixes, the prefix and the regex are concatenated (e.g. if the prefix is `"foo/"` and the regex is `"bar"`, it will check for matches with `"foo/bar"`)

## Settings

* On settings page you can toggle "Break on first match" behavior.
* Select regex engine: String.match or [minimatch](https://github.com/isaacs/minimatch) (default)

## Screenshots

![settings](https://cloud.githubusercontent.com/assets/426007/8528492/f276ad2c-241b-11e5-8a72-7102cadef775.png)
![tabs](https://cloud.githubusercontent.com/assets/426007/8528501/f45f3a50-241b-11e5-8a93-9ebf27e33429.png)

## Example

```cson
"color-tabs":
  "-regex/":
    ".*": "rgb(75, 99, 0)"
  "/lib" : "rgb(142, 65, 23)"
"opened-files/":
  ".*?\\.coffee": "rgb(134, 90, 16)"

".*\\.py": "rgb(81, 201, 38)"
".json": "rgb(196, 189, 91)"
".cson": "rgb(196, 189, 91)"
".xml": "rgb(196, 189, 91)"
```
