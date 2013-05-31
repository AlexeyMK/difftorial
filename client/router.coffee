Meteor.Router.add(
  '/': 'hello'
  '/tutorial/:owner/:repo/:base/:head': (owner, repo, base, head) ->
    $.ajax
      url: "https://api.github.com/repos/#{owner}/#{repo}/compare/#{base}...#{head}",
      success: (result) ->
        diff = ({filename: file.filename, patch: file.patch} for file in result.files)
        Session.set('diff', diff)
    'tutorial'
  '*': '404'
)
