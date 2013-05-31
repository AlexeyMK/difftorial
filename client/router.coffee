Meteor.Router.add(
  '/:owner/:repo/:sha?': (owner, repo, sha) ->
    $.ajax
      url: "https://api.github.com/repos/#{owner}/#{repo}/commits?per_page=100"
      success: (commits) ->
        if sha?
          for commit, index in commits
            if commit.sha == sha
              Session.set('next', commits[index-1]?.sha)
              Session.set('previous', commits[index+1]?.sha)
              Session.set('message', commit.commit.message)
        else
          commit = commits[commits.length - 1]
          sha = commit.sha
          Session.set('next', commits[commits.length - 2].sha)
          Session.set('previous', '')
          Session.set('message', commit.commit.message)

        $.ajax
          url: "https://api.github.com/repos/#{owner}/#{repo}/commits/#{sha}",
          success: (result) ->
            diff = ({filename: file.filename, patch: file.patch} for file in result.files)
            Session.set('diff', diff)
    return 'tutorial'
  '*': '404'
)
