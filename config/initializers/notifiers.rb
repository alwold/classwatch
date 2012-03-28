Notifiers = Hash.new
email_notifier = EmailNotifier.new
Notifiers[email_notifier.type] = email_notifier
sms_notifier = SmsNotifier.new
Notifiers[sms_notifier.type] = sms_notifier
