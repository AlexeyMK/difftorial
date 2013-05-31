Meteor.Router.add(
  '': 'index'
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

  '/:owner/:repo/:sha?': (owner, repo, sha) ->
    Session.set("owner", owner)
    Session.set("repo", repo)
    $.ajax(
      url: "https://api.github.com/repos/#{owner}/#{repo}/commits?per_page=100"
    ).done (commits) ->
      if sha?
        for commit, index in commits
          if commit.sha == sha
            Session.set('next', commits[index-1]?.sha or '')
            Session.set('previous', commits[index+1]?.sha or '')
            Session.set('message', commit.commit.message)
      else
        commit = commits[commits.length - 1]
        sha = commit.sha
        Session.set('next', commits[commits.length - 2].sha)
        Session.set('previous', '')
        Session.set('message', commit.commit.message)

      $.ajax(
        url: "https://api.github.com/repos/#{owner}/#{repo}/commits/#{sha}",
      ).done (result) ->
        diff = ({filename: file.filename, patch: file.patch} for file in result.files)
        Session.set('diff', diff)
    return 'tutorial'
  '*': '404'
)
