Redmine::Plugin.register :mail_intergration do
  name 'Redmine mail intergration plugin'
  author 'Yusuke Kokubo'
  description 'more mail intergration than redmine receive email.'
  version '0.0.3'
  requires_redmine :version_or_higher => '6.0'
end

# init.rb is loaded in a to_prepare block, so the patch is reapplied on reload
unless MailHandler.included_modules.include?(MailIntergration::MailHandlerPatch)
  MailHandler.prepend(MailIntergration::MailHandlerPatch)
end
