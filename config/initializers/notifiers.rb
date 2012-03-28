Notifiers = Hash.new
email_notifier = EmailNotifier.new
Notifiers[email_notifier.type] = email_notifier
