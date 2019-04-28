# Prpr::MentionComment
[Prpr](https://github.com/mzp/prpr) plugin to notify mention comment to chat service.

## Install

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem 'prpr-mention_comment'
```

## Usage
When some comment containing mention is posted, the comment request is post to chat service, too.

![mention comment](https://raw.githubusercontent.com/mzp/prpr-mention_comment/master/mention.png)

To add chat service, use publisher adapter (e.g. [prpr-slack](https://github.com/mzp/prpr-slack)).

## Env
```
MENTION_COMMENT_ROOM - room name to post mention comment.
MENTION_COMMENT_MEMBERS - a file name to map github username to chat service one. (Default: MEMBERS.md)
MEMTION_COMMNET_TO_DM - notify Direct Message instead of MENTION_COMMENT_ROOM. (Default: false)
```

## Configuration
Write MEMBERS.md like following to map github username to chat service one.

```
 * @alice_at_github: @alice_at_chat
 * @bob_at_github: @bob_at_chat
```
