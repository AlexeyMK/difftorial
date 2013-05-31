Meteor.Router.add(
  '/dummy': ->
    Session.set('next', '#')
    Session.set('previous', '#')
    Session.set('message', 'created dummy for geoff')
    Session.set('diff', [{'filename': 'geoff.js', patch: """
      + Development Seed
      +// Github.js 0.8.0
      +// (c) 2013 Michael Aufreiter, Development Seed
      + // Github.js is freely distributable under the MIT license.
      +    // For all details and documentation:
      +       // http://substance.io/michael/github
    """}])
    return 'tutorial'

  '/tutorial/:owner/:repo/:sha': (owner, repo, sha) ->
    base = ""
    console.log sha
    $.ajax
      url: "https://api.github.com/repos/#{owner}/#{repo}/commits?per_page=100"
      success: (commits) ->
        for commit, index in commits
          if commit.sha == sha
            Session.set('next', commits[index-1]?.sha)
            Session.set('previous', commits[index+1]?.sha)
            Session.set('message', commit.commit.message)

        $.ajax
          url: "https://api.github.com/repos/#{owner}/#{repo}/commits/#{sha}",
          success: (result) ->
            diff = ({filename: file.filename, patch: file.patch} for file in result.files)
            Session.set('diff', diff)
    return 'tutorial'
  '*': '404'
)
