module Prpr
  module Action
    module MentionComment
      class Mention < Base
        REGEXP = /@[a-zA-Z0-9_-]+/

        def call
          if mention?
            Publisher::Adapter::Base.broadcast message
          end
        end

        private

        def message
          puts members
          mentioned_names.each do |mentioned_name|
            puts members
            channel = to_dm? ? members[mentioned_name] || mentioned_name : room
            puts channel
            Prpr::Publisher::Message.new(body: body, from: from, room: channel)
          end
        end

        def mention?
          comment.body =~ REGEXP
        end

        def body
          <<-END
#{comment_body}

#{comment.html_url}
          END
        end

        def comment_body
          comment.body.gsub(REGEXP) { |old|
            members[old] || old
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

        def mentioned_names
          comment.body.scan(REGEXP)
        end

        def members
          @members ||= config.read(name).lines.map { |line|
            if line =~ / \* (\S+):\s*(\S+)/
              [$1, $2]
            end
          }.to_h
        rescue
          @members ||= {}
        end

        def config
          @config ||= Config::Github.new(repository_name)
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

        def to_dm?
          env[:mention_comment_to_dm] == 'true'
        end
      end
    end
  end
end
