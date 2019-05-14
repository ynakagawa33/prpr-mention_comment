module Prpr
  module Action
    module MentionComment
      class Mention < Base
        REGEXP = /@[a-zA-Z0-9_-]+/

        def call
          if mention?
            messages.each do |message|
              Publisher::Adapter::Base.broadcast message
            end
          end
        end

        private

        def messages
          mentioned_names.map do |mentioned_name|
            channel = to_dm? ? members[mentioned_name] || room : room
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
          comment.body.scan(REGEXP).uniq
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
          @config ||= Config::Github.new(repository_name, 'develop')
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
