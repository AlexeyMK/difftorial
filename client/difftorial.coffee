owner = 'michael'
repo = 'github'
head = 'a1fec86587fc58fe56774b3a428c3b57a95a326e'
base = 'da95507f75fa500396a835320200171ffd4b7501'

Meteor.startup ->
  $.ajax
    url: "https://api.github.com/repos/#{owner}/#{repo}/compare/#{base}...#{head}",
    success: (result) ->
      console.log result
      debugger;
