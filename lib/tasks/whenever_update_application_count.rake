desc 'Whenever rake update application count in database task'
task update_application_count: :environment do
  update_application_sql =<<-SQL 
    UPDATE applications 
    JOIN (SELECT chats.application_id as app_id,count(chats.id) as chat_cnt FROM chats  
    group by chats.application_id) as w on w.app_id=applications.id set applications.chats_count=w.chat_cnt
  SQL
  update_chat_sql =<<-SQL 
    UPDATE chats  
    JOIN (SELECT messages.chat_id as chat_id,count(messages.id) as message_cnt FROM messages 
     group by messages.chat_id) as w on w.chat_id=chats.id set chats.messages_count=w.message_cnt
  SQL
  ActiveRecord::Base.connection.exec_query("SET SQL_SAFE_UPDATES=0;")
  ActiveRecord::Base.connection.execute(Arel.sql(update_application_sql))
  ActiveRecord::Base.connection.execute(Arel.sql(update_chat_sql))
end