module Prpr
  module Action
    module MentionComment
      class Mention < Base
        REGEXP = /@[a-zA-Z0-9_-]+/

        def call
          Publisher::Adapter::Base.broadcast message
        end

        private

        def message
          Prpr::Publisher::Message.new(body: body, from: from, room: room)
        end

        def body
          <<-END
[Commnet on ##{issue_number} #{issue_title}](#{comment.html_url})
#{comment_body}
> #{repository_name}
          END
        end

        def issue
          event.issue || event.pull_request
        end

        def issue_title
          issue.title || ''
        end

        def issue_number
          issue.number || event.commit_id
        end

        def comment_body
          comment.body.gsub(REGEXP) { |old|
            user = members[old] || old
            "<#{user}>"
          }
        end

        def comment
          event.comment
        end

        def from
          event.sender
        end

        def room
          env[:mention_comment_room]
        end

        def members
          @members ||= config.read(name).lines.map { |line|
            if line =~ /\s*\*\s*(\S+):\s*(\S+)/
              [$1, $2]
            end
          }.to_h
        rescue
          @members ||= {}
        end

        def config
          @config ||= Config::Github.new(repository_name, branch: default_branch_name)
        end

        def env
          Config::Env.default
        end

        def name
          env[:mention_comment_members] || 'MEMBERS.md'
        end

        def repository_name
          event.repository.full_name
        end

        def default_branch_name
          event.repository.default_branch
        end
      end
    end
  end
end
