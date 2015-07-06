{CompositeDisposable} = require 'atom'
CSON = require 'season'
colorFile = atom.getConfigDirPath()+"/color-tabs-regex.cson"
colors = {}
processPath = null

module.exports = ColorTabsRegex =

  config:
    breakAfterFirstMatch:
      type: 'boolean'
      default: true

  activate: (state) ->
    console.log '[color-tabs-regex] activate'
    unless @disposables?
      @disposables = new CompositeDisposable
      @disposables.add atom.workspace.onDidAddTextEditor =>
        setTimeout @processAllTabs, 10
      @disposables.add atom.workspace.onDidDestroyPaneItem =>
        setTimeout @processAllTabs, 10
      @disposables.add atom.commands.add 'atom-workspace', 'color-tabs-regex:edit-rules': => @editRules()
      @disposables.add atom.config.observe "color-tabs-regex.breakAfterFirstMatch", @processAllTabs
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
    colored = []
    CSON.readFile colorFile, (err, content) =>
      unless err
        colors = content
        paneItems = atom.workspace.getPaneItems()
        for paneItem in paneItems
          if paneItem.getPath?
            path = paneItem.getPath()
            if path
              for re of colors
                try
                  if path.match re
                    color = colors[re]
                    if breaks
                      console.log path, colored.indexOf(path) == -1
                      if colored.indexOf(path) == -1
                        colored.push path
                      else
                        continue
                    console.log "[color-tabs-regex] #{path} -> #{color} matched by '#{re}'"
                    processPath path, color

                catch error
                  console.log "[color-tabs-regex] #{error}"
