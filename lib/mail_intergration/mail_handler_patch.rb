module MailIntergration
  module MailHandlerPatch
    def dispatch
      issue_id = false
      if email.subject.to_s.tr('＃０-９', '#0-9') =~ /#(\d+)/
        issue_id = $1.to_i
      else
        msg = false
        if email.in_reply_to
          msg = MailMessage.find_by(:message_id => email.in_reply_to, :username => mail_intergration_username)
        end
        if email.references
          msg ||= MailMessage.find_by(:message_id => email.references, :username => mail_intergration_username)
        end
        if msg
          issue_id = msg.issue_id
        end
      end

      if issue_id
        journal = receive_issue_reply(issue_id)
        issue = journal.issue
      else
        journal_or_issue = super
        if journal_or_issue.respond_to? :issue
          journal = journal_or_issue
          issue = journal_or_issue.issue
        else
          journal = false
          issue = journal_or_issue
        end
      end

      if issue
        begin
          msg = MailMessage.find_by(:message_id => email.message_id, :username => mail_intergration_username) || MailMessage.new
          msg.message_id = email.message_id
          msg.issue_id = issue.id
          msg.username = mail_intergration_username
          msg.save!
        rescue => e
          # The issue is already saved, so do not make the whole receive fail
          logger&.error "MailIntergration: failed to record message #{email.message_id}: #{e.message}"
        end
      end

      if journal
        journal
      else
        issue
      end
    end

    private

    # ENV['username'] is set by rake redmine:email:receive_* (username=...).
    # It is nil when emails are posted by rdm-mailhandler.rb, and existing
    # records are stored with a NULL username in that case.
    def mail_intergration_username
      ENV['username']
    end
  end
end
