/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2012                    */
/* Created on:     2017/2/14 12:03:44                           */
/*==============================================================*/


if exists (select 1
          from sysobjects
          where id = object_id('tri_Topic_Add')
          and type = 'TR')
   drop trigger tri_Topic_Add
go

if exists (select 1
          from sysobjects
          where  id = object_id('proc_Topic_Query')
          and type in ('P','PC'))
   drop procedure proc_Topic_Query
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Topic') and o.name = 'FK_TOPIC_REFERENCE_TEACHER')
alter table Topic
   drop constraint FK_TOPIC_REFERENCE_TEACHER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Topic') and o.name = 'FK_TOPIC_TOPICBELO_TOPIC_TY')
alter table Topic
   drop constraint FK_TOPIC_TOPICBELO_TOPIC_TY
go

if exists (select 1
            from  sysobjects
           where  id = object_id('V_TeacherTopic')
            and   type = 'V')
   drop view V_TeacherTopic
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Teacher')
            and   type = 'U')
   drop table Teacher
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Topic')
            and   type = 'U')
   drop table Topic
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Topic_Type')
            and   type = 'U')
   drop table Topic_Type
go

/*==============================================================*/
/* Table: Teacher                                               */
/*==============================================================*/
create table Teacher (
   teacher_User_Name    nvarchar(5)          not null,
   teacher_Name         nvarchar(5)          null,
   teacher_Degree       nvarchar(10)         null,
   teacher_Position     nvarchar(10)         null,
   teacher_Phone        nvarchar(11)         null,
   constraint PK_TEACHER primary key (teacher_User_Name)
)
go

if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Teacher') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Teacher' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   '教师表', 
   'user', @CurrentUser, 'table', 'Teacher'
go

/*==============================================================*/
/* Table: Topic                                                 */
/*==============================================================*/
create table Topic (
   topic_ID             int                  not null,
   topic_Type_ID        int                  null,
   teacher_User_Name    nvarchar(5)          null,
   topic_Name           nvarchar(50)         null,
   topic_Description    nvarchar(2000)       null,
   grade                char                 null,
   constraint PK_TOPIC primary key (topic_ID)
)
go

if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Topic') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Topic' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   '课题表', 
   'user', @CurrentUser, 'table', 'Topic'
go

/*==============================================================*/
/* Table: Topic_Type                                            */
/*==============================================================*/
create table Topic_Type (
   topic_Type_ID        int                  not null,
   topic_Type_Name      nvarchar(20)         null,
   profession_Type      nchar(2)             null,
   term                 char                 null,
   constraint PK_TOPIC_TYPE primary key (topic_Type_ID)
)
go

if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Topic_Type') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Topic_Type' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   '课题类别表', 
   'user', @CurrentUser, 'table', 'Topic_Type'
go

/*==============================================================*/
/* View: V_TeacherTopic                                         */
/*==============================================================*/
create view V_TeacherTopic as
select
   Topic.topic_ID,
   Topic_Type.topic_Type_ID,
   Topic_Type.topic_Type_Name,
   Topic_Type.profession_Type,
   Topic_Type.term,
   Teacher.teacher_User_Name,
   Teacher.teacher_Name,
   Teacher.teacher_Degree,
   Teacher.teacher_Position,
   Teacher.teacher_Phone,
   Topic.topic_Name,
   Topic.topic_Description,
   Topic.grade
from
   Topic,
   Topic_Type,
   Teacher
where
   Topic.topic_Type_ID = Topic_Type.topic_Type_ID
   and Topic.teacher_User_Name = Teacher.teacher_User_Name
go

if exists (select 1 from  sys.extended_properties
           where major_id = object_id('V_TeacherTopic') and minor_id = 0)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'view', 'V_TeacherTopic'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '教师指导课题信息视图，为教师表、课题类别表和课题表的联合查询',
   'user', @CurrentUser, 'view', 'V_TeacherTopic'
go

alter table Topic
   add constraint FK_TOPIC_REFERENCE_TEACHER foreign key (teacher_User_Name)
      references Teacher (teacher_User_Name)
go

alter table Topic
   add constraint FK_TOPIC_TOPICBELO_TOPIC_TY foreign key (topic_Type_ID)
      references Topic_Type (topic_Type_ID)
go


create procedure proc_Topic_Query <@arg> <type> as
declare <@var> <type>
begin

end
go


create trigger tri_Topic_Add on Topic for insert as
begin
    declare
       @maxcard  int,
       @numrows  int,
       @numnull  int,
       @errno    int,
       @errmsg   varchar(255)

    select  @numrows = @@rowcount
    if @numrows = 0
       return


    return

/*  Errors handling  */
error:
    raiserror @errno @errmsg
    rollback  transaction
end
go

