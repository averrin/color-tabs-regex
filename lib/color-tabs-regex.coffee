{CompositeDisposable} = require 'atom'
CSON = require 'season'
colorFile = atom.getConfigDirPath()+"/color-tabs-regex.cson"
colors = {}

module.exports = ColorTabsRegex =
  colorTabsRegexView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    console.log 'activate color-tabs-regex'
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'color-tabs-regex:toggle': => @processAllTabs()
    unless @disposables?
      @disposables = new CompositeDisposable
      @disposables.add atom.workspace.onDidAddTextEditor =>
        setTimeout @processAllTabs, 10
      @disposables.add atom.workspace.onDidDestroyPaneItem =>
        setTimeout @processAllTabs, 10
    CSON.readFile colorFile, (err, content) =>
      unless err
        colors = content
        @processed = @processAllTabs()
    console.log colors

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @colorTabsRegexView.destroy()

  serialize: ->
    colorTabsRegexViewState: @colorTabsRegexView.serialize()

  consumeChangeColor: (changeColor) =>
    @changeColor = changeColor

  processAllTabs: ()=>
    paneItems = atom.workspace.getPaneItems()
    for paneItem in paneItems
      if paneItem.getPath?
        path = paneItem.getPath()
        for re of colors
          if path.match re
            color = colors[re]
            console.log "#{path} -> #{color}"
            @changeColor path, color

  # toggle: ->
  #   console.log 'ColorTabsRegex was toggled!'
  #   @processAllTabs()
