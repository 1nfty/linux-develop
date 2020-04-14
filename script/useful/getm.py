#!/usr/bin/env python3
# encoding: utf-8

import csv
import datetime
import socks
from telethon.sync import TelegramClient
from telethon.tl import types
from telethon.tl.functions.messages import GetDialogsRequest

api_id = 1174422
api_hash = 'a59381f36d729c332e7b6e93193a96e0'
phone = '+12342182279'
client = TelegramClient(phone, api_id, api_hash, proxy=(socks.SOCKS5, 'localhost', 1080))

# 登录并获得授权
client.connect()
if not client.is_user_authorized():
    client.send_code_request(phone)
    client.sign_in(phone, input('Enter the code: '))

# 获取群和频道列表
chats = []
result = client(GetDialogsRequest(
    offset_date=None,
    offset_id=0,
    offset_peer=types.InputPeerEmpty(),
    limit=200,
    hash=0
))
chats.extend(result.chats)

groups = []
for chat in chats:
    try:
        if chat.megagroup:
            groups.append(chat)
    except:
        continue

me = client.get_entity('me')
print("My entity: {}, {}".format(me.id, me.status))

print('Choose a group to scrape members from:')
i = 0
for g in groups:
    print(str(i) + '- ' + g.title)
    i += 1

g_index = input("Enter a Number: ")
target_group = groups[int(g_index)]

print('Fetching Members...')
all_participants = []
all_participants = client.get_participants(target_group, aggressive=False)
print('chat member size:', len(all_participants))


def checkEmptyValue(value):
    if value:
        return value
    else:
        return ""


class UserStatusProcess:
    dist = {'0': '在线', '1': '近期有上线', '7': '近一周有上线', '30': '近一月有上线', '365': '超过一月未上线'}

    def __init__(self, client):
        self.client = client

    def getUserStatus(self, user_id, name):
        entity = self.client.get_entity(user_id)
        for k, v in self.dist.items():
            if self._last_seen_delta(entity.status) <= datetime.timedelta(days=int(k)):
                # print("{} | {} | {} | {}".format(name, v, k, entity.status))
                return v
        return ""

    def _last_seen_delta(self, status):
        if isinstance(status, types.UserStatusOffline):
            return datetime.datetime.now(tz=datetime.timezone.utc) - status.was_online
        elif isinstance(status, types.UserStatusOnline):
            return datetime.timedelta(days=0)
        elif isinstance(status, types.UserStatusRecently):
            return datetime.timedelta(days=1)
        elif isinstance(status, types.UserStatusLastWeek):
            return datetime.timedelta(days=7)
        elif isinstance(status, types.UserStatusLastMonth):
            return datetime.timedelta(days=30)
        else:
            return datetime.timedelta(days=365)


statusProcess = UserStatusProcess(client)
print('Saving In file...')
with open("members.csv", "w", encoding='UTF-8') as f:
    writer = csv.writer(f, delimiter=",", lineterminator="\n")
    # writer.writerow(['username', 'user id', 'access hash', 'name', 'status', 'group', 'group id'])
    writer.writerow(['username', 'user id', 'name', 'status', 'group', 'group id'])
    for user in all_participants:
        username = checkEmptyValue(user.username)
        first_name = checkEmptyValue(user.first_name)
        last_name = checkEmptyValue(user.last_name)
        name = (first_name + ' ' + last_name).strip()
        status = statusProcess.getUserStatus(user.id, name)

        # writer.writerow([username, user.id, user.access_hash, name, status, target_group.title, target_group.id])
        writer.writerow([username, user.id, name, status, target_group.title, target_group.id])
print('Members scraped successfully.')
client.disconnect()
