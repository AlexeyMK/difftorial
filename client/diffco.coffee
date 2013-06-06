document = (filename, code) ->
  sections = parse filename, code
  format filename, sections
  sections

parse = (filename, code) ->
  lines = code.split '\n'
  sections = []
  lang = getLanguage filename
  hasCode = docsText = codeText = ''
  save = ->
    sections.push {docsText, codeText}
    hasCode = docsText = codeText = ''

  for line in lines
    if line.match(lang.commentMatcher) and not line.match(lang.commentFilter)
      save() if hasCode
      docsText += (line = line.replace(lang.commentMatcher, '')) + '\n'
      save() if /^(---+|===+)$/.test line
    else
      hasCode = true
      codeText += line + '\n'
  save()

  sections

format = (filename, sections) ->
  language = getLanguage filename
  for section in sections
    code = section.codeText.replace(/\s+$/, '')
    section.codeHtml = "<div class='highlight'><pre>#{esc code}</pre></div>"
    section.docsHtml = section.docsText


languages =
  ".coffee":
    name: "coffeescript"
    symbol: "#"
  ".rb":
    name: "ruby"
    symbol: "#"
  ".py":
    name: "python"
    symbol: "#"
  ".tex":
    name: "tex"
    symbol: "%"
  ".latex":
    name: "tex"
    symbol: "%"
  ".js":
    name: "javascript"
    symbol: "//"
  ".java":
    name: "java"
    symbol: "//"
  ".scss":
    name: "scss"
    symbol: "//"
  ".cpp":
    name: "cpp"
    symbol: "//"
  ".php":
    name: "php"
    symbol: "//"
  ".hs":
    name: "haskell"
    symbol: "--"
  ".md":
    name: "markdown"
    symbol: ""
  ".markdown":
    name: "markdown"
    symbol: ""
  ".less":
    name: "scss"
    symbol: "//"
  ".h":
    name: "objectivec"
    symbol: "//"
  ".scala":
    name: "scala"
    symbol: "//"
  ".sh":
    name: "bash"
    symbol: "#"
  ".go":
    name: "go"
    symbol: "//"
  ".lisp":
    name: "lisp"
    symbol: ";"
  ".lua":
    name: "lua"
    symbol: "--"
  ".r":
    name: "r"
    symbol: "#"

for ext, l of languages
  l.commentMatcher = ///^(\+|-)\s*#{l.symbol}\s?///
  l.commentFilter = /(^(\+|-)#![/]|^\s*#\{)/


getLanguage = (filename) ->
  dot = filename.lastIndexOf '.'
  ext = if dot isnt -1 then filename.substr(filename.lastIndexOf '.') else filename
  languages[ext] or {name: "html", symbol: "//"}

esc = (string) ->
  escape =
    "&": "&amp;"
    "<": "&lt;"
    ">": "&gt;"
    '"': "&quot;"
    "'": "&#x27;"
    "`": "&#x60;"
  badChars = /[&<>"'`]/g
  escapeChar = (chr) -> escape[chr] or "&amp;"
  return string.replace(badChars, escapeChar).toString()

@Diffco = {parse, format, document}
