{CompositeDisposable} = require 'atom'
CSON = require 'season'
colorFile = atom.getConfigDirPath()+"/color-tabs-regex.cson"
colors = {}

module.exports = ColorTabsRegex =
  colorTabsRegexView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    console.log '[color-tabs-regex] activate'
    unless @disposables?
      @disposables = new CompositeDisposable
      @disposables.add atom.workspace.onDidAddTextEditor =>
        setTimeout @processAllTabs, 10
      @disposables.add atom.workspace.onDidDestroyPaneItem =>
        setTimeout @processAllTabs, 10
      @disposables.add atom.commands.add 'atom-workspace', 'color-tabs-regex:reload': => @reloadConfig()
    @reloadConfig()

  reloadConfig: () ->
    console.log "[color-tabs-regex] read #{colorFile}"
    CSON.readFile colorFile, (err, content) =>
      unless err
        colors = content
        @processed = @processAllTabs()

  deactivate: ->
    @subscriptions.dispose()

  consumeChangeColor: (changeColor) =>
    @changeColor = changeColor

  processAllTabs: () =>
    paneItems = atom.workspace.getPaneItems()
    for paneItem in paneItems
      if paneItem.getPath?
        path = paneItem.getPath()
        for re of colors
          if path.match re
            color = colors[re]
            console.log "[color-tabs-regex] #{path} -> #{color} matched by '#{re}'"
            @changeColor path, color
