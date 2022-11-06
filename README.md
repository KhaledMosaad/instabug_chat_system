# Chat System

The callenge is chat system that has multiple Application identified by token, each Application has many chats identified by a number ( number should start from 1) , each Chat has many messages identified by a number ( number should start from 1) the endpoints should be RESTful

* Using MySQL as datastore
* Using ElasticSearch for searching through messages of a specific chat
* Using Docker to contatinerize the application
* Using RabbitMQ
* Using Redis 

# System Design 

![ChatSystemDesign](https://user-images.githubusercontent.com/48384324/200163818-91db8747-14bf-410b-a023-5d17983c1e68.PNG)


# Endpoints

| Controller | Verb | URI | body | Description |
| ---------- | ---  | --- | ---- | ----------- |
| Application | get | /applications/:app_token | no body | get spacific application by token |
| Application | post | /applications | { "name": "name of the application "} | create new application |
| Application | patch | /applications/:app_token | { "name": "updated name of the application "} | update application name |
| Application | get | /applications/:app_token/chats | no body | get application chats | 
| Chat | get | /chats/:number | no body | get spacifice chat by number |
| Chat | post | /chats | { "name": "name of the chat ","app_token": "application token "} | create new chat with application token |
| chat | patch | /chats/:number | { "name": "updated name of the chat " ,"app_token": "application token "} | update chat name |
| chat | get | /chats/:app_token/:number/messages | no body | get chat messages |
| chat | get | /chats/:app_token/:number/search/:q | no body | search on messges bodies on spacific chat on spacific application |
| message | get | /messages/:app_token/:chat_number/:number | no body | get message by application token and chat number and message number |
| message | post | /messages / {"body":"first_message","chat_number":"1","app_token":"application token"} | create new message |
| message | patch | /messages/:number / {"body":"first_message","chat_number":"1","app_token":"application token"} | update body of message |

[Postman collection Url] (https://warped-satellite-695943.postman.co/workspace/My-Workspace~fe8b6a88-9876-44d1-870e-67d72c4de080/collection/13141054-3d841185-8a1f-4791-932d-75225d8fa941?action=share&creator=13141054)


# My Approach 
- on this challenge first i create the schema of the database and try to add services one by one 
* create all database schema
* create endpoints
* try to add and fetch directly to database to test my schema and endpoints
* add redis service to get chat numbers and message numbers from it as a centralized service
* add rebbitMQ service to asyncly push created messages and chats to it and add two workers to consume from queues 
 - i make the qeueu message acknowledgment to be consistant as possible 
 - make the queue durabe and publish messages as persistent to save it on the disk 
 - consume it by workers with prefetch 1 to consume message one by one due to overload on the workers
 - make sneakers log object log on the same file with Rails file
 - make worker log on sneakers.log file to track issues and problems
 - in this phase i had some issues:
    1) i had to decide which i will requeue the failure message or reject it and push it to retry queue 
      - i decide to push it to reject it just for not going into infinite loop 
    2) i had to decide also how many number of worker will work 
      - for now i make the number of workers 2 for each queue because it depend on ROR-application


# Used Gems 

- whenever: this gem allow me to create cron job to update messages_count and chats_count column on chats and applications tables every 45 minutes
- bunny: with bunny i can push to RabbitMQ queue 
- sneakers: worker can't consume without this greate gem so i use it to create two workers one for chats creation and other for message creation
- elasticsearch-model: to connect and search on elasticsearch and create index without any issue 




