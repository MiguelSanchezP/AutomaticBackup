import telegram
import os
import os.path
import sys

bot = telegram.Bot('token')
usernames = [['user1', 'user1id', 'user2id', ], ['user2', 'user2id', ], ]
if sys.argv[1] == 'backup':
	for username in usernames:
		if os.path.isfile('/home/'+username[0]+'/.Logs/.backup-successful'):
			for i in range(1, len(username)):
				bot.send_message(chat_id=username[i], text='Backup success on username '+username[0])
			os.remove('/home/'+username[0]+'/.Logs/.backup-successful')
		else:
			for i in range(1, len(username)):
				bot.send_message(chat_id=username[i], text='Backup failure on username '+username[0])
