{CompositeDisposable} = require 'atom'
CSON = require 'season'
sep = require("path").sep
colorFile = atom.getConfigDirPath()+"#{sep}color-tabs-regex.cson"
colors = {}
processPath = null

minimatch = require 'minimatch'

# you can add your matchers
matchers =
  minimatch: (path, regex) ->
    return minimatch path, regex
  'String.match': (path, regex) ->
    return path.match regex

module.exports = ColorTabsRegex =

  config:
    breakAfterFirstMatch:
      type: 'boolean'
      default: false
    regexEngine:
      title: "Regex engine"
      type: "string"
      default: "minimatch"
      enum: Object.keys matchers

  activate: (state) ->
    console.log "[color-tabs-regex] activate."
    unless @disposables?
      @disposables = new CompositeDisposable
      @disposables.add atom.workspace.onDidAddTextEditor =>
        setTimeout @processAllTabs, 10
      @disposables.add atom.workspace.onDidDestroyPaneItem =>
        setTimeout @processAllTabs, 10
      @disposables.add atom.commands.add 'atom-workspace', 'color-tabs-regex:edit-rules': => @editRules()
      @disposables.add atom.config.observe "color-tabs-regex.breakAfterFirstMatch", @processAllTabs
      @disposables.add atom.config.observe "color-tabs-regex.regexEngine", @processAllTabs
      cb = @processAllTabs
      atom.workspace.observeTextEditors (editor) =>
        if editor.getPath() == colorFile
          @addSaveCb(editor, cb)
    @processAllTabs()

  addSaveCb: (editor, cb) ->
    @disposables.add editor.onDidSave =>
      setTimeout cb, 10

  editRules: () ->
    atom.open pathsToOpen: colorFile
    atom.workspace.observeTextEditors (editor) =>
      if editor.getPath() == colorFile
        @addSaveCb(editor, @processAllTabs)

  deactivate: ->
    @disposables.dispose()

  consumeChangeColor: (changeColor) ->
    processPath = changeColor

  processAllTabs: () ->
    breaks = atom.config.get "color-tabs-regex.breakAfterFirstMatch"
    matcher = atom.config.get "color-tabs-regex.regexEngine"
    colored = []
    CSON.readFile colorFile, (err, content) =>
      unless err
        count = Object.keys(content).length
        if Object.keys(colors).length != count
          console.log "[color-tabs-regex] defined rules: #{count}"
        colors = content
        paneItems = atom.workspace.getPaneItems()
        for paneItem in paneItems
          if paneItem.getPath?
            path = paneItem.getPath()
            if path
              for re of colors
                try
                  if matchers[matcher] path, re
                    color = colors[re]
                    if breaks
                      if colored.indexOf(path) == -1
                        colored.push path
                      else
                        continue
                    console.log "[color-tabs-regex] #{path} -> #{color} matched by '#{re}'"
                    processPath path, color, false

                catch error
                  console.error "[color-tabs-regex] #{error}"
