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
      cb = @processAllTabs.bind(this)
      @disposables.add atom.workspace.onDidAddTextEditor =>
        setTimeout cb, 10
      @disposables.add atom.workspace.onDidDestroyPaneItem =>
        setTimeout cb, 10
      @disposables.add atom.commands.add 'atom-workspace', 'color-tabs-regex:edit-rules': => @editRules(cb)
      @disposables.add atom.config.observe "color-tabs-regex.breakAfterFirstMatch", cb
      @disposables.add atom.config.observe "color-tabs-regex.regexEngine", cb
      atom.workspace.observeTextEditors (editor) =>
        if editor.getPath() == colorFile
          @addSaveCb(editor, cb)
    @processAllTabs()

  addSaveCb: (editor, cb) ->
    @disposables.add editor.onDidSave =>
      setTimeout cb, 10

  editRules: (cb) ->
    atom.open pathsToOpen: colorFile
    atom.workspace.observeTextEditors (editor) =>
      if editor.getPath() == colorFile
        @addSaveCb(editor, cb)

  deactivate: ->
    @disposables.dispose()

  consumeChangeColor: (changeColor) ->
    processPath = changeColor

  expandRules: (rules, prefix, output) ->
    output = output || []
    prefix = prefix || ""
    for rule of rules
      if typeof rules[rule] is "string"
        output[prefix + rule] = rules[rule]
      else
        output = @expandRules(rules[rule], rule, output)
    output

  processAllTabs: () ->
    breaks = atom.config.get "color-tabs-regex.breakAfterFirstMatch"
    matcher = atom.config.get "color-tabs-regex.regexEngine"
    processRules = @expandRules.bind(this)
    colored = []
    CSON.readFile colorFile, (err, content) =>
      unless err
        rules = processRules content
        count = Object.keys(rules).length
        if Object.keys(colors).length != count
          console.log "[color-tabs-regex] defined rules: #{count}"
        colors = rules
        paneItems = atom.workspace.getPaneItems()
        for paneItem in paneItems
          if paneItem.getPath?
            path = paneItem.getPath()
            processPath path, false, false
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
