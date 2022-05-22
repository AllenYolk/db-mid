/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2022/5/22 16:10:32                           */
/*==============================================================*/


drop trigger liked_increase_exp;

drop trigger watch_increase_exp;

drop procedure if exists follow;

drop procedure if exists watch;

drop view if exists view_follower_count;

drop view if exists view_section_video_count;

drop view if exists view_video_data;

drop index follower_FK on follow_record;

drop index followed_FK on follow_record;

drop table if exists follow_record;

drop index related_FK on related_video;

drop index main_FK on related_video;

drop table if exists related_video;

drop index section_PK on section;

drop table if exists section;

drop index user_add2fav_video2_FK on user_add2fav_video;

drop index user_add2fav_video_FK on user_add2fav_video;

drop table if exists user_add2fav_video;

drop index user_like_video2_FK on user_like_video;

drop index user_like_video_FK on user_like_video;

drop table if exists user_like_video;

drop index user_publish_video2_FK on user_publish_video;

drop index user_publish_video_FK on user_publish_video;

drop table if exists user_publish_video;

drop index user_watch_video2_FK on user_watch_video;

drop index user_watch_video_FK on user_watch_video;

drop table if exists user_watch_video;

drop index video_in_section_FK on video;

drop index video_PK on video;

drop table if exists video;

drop index user_make_comment_FK on video_comment;

drop index comment_below_video_FK on video_comment;

drop table if exists video_comment;

drop index user_PK on website_user;

drop table if exists website_user;

/*==============================================================*/
/* Table: follow_record                                         */
/*==============================================================*/
create table follow_record
(
   followed_id          bigint not null,
   follower_id          bigint not null,
   follow_time          timestamp not null
);

/*==============================================================*/
/* Index: followed_FK                                           */
/*==============================================================*/
create index followed_FK on follow_record
(
   followed_id
);

/*==============================================================*/
/* Index: follower_FK                                           */
/*==============================================================*/
create index follower_FK on follow_record
(
   follower_id
);

/*==============================================================*/
/* Table: related_video                                         */
/*==============================================================*/
create table related_video
(
   main_video_id        varchar(20) not null,
   related_video_id     varchar(20) not null
);

/*==============================================================*/
/* Index: main_FK                                               */
/*==============================================================*/
create index main_FK on related_video
(
   main_video_id
);

/*==============================================================*/
/* Index: related_FK                                            */
/*==============================================================*/
create index related_FK on related_video
(
   related_video_id
);

/*==============================================================*/
/* Table: section                                               */
/*==============================================================*/
create table section
(
   section_name         varchar(20) not null,
   administrator_id     bigint not null
);

/*==============================================================*/
/* Index: section_PK                                            */
/*==============================================================*/
create unique index section_PK on section
(
   section_name
);

/*==============================================================*/
/* Table: user_add2fav_video                                    */
/*==============================================================*/
create table user_add2fav_video
(
   user_id              bigint not null,
   video_id             varchar(20) not null
);

/*==============================================================*/
/* Index: user_add2fav_video_FK                                 */
/*==============================================================*/
create index user_add2fav_video_FK on user_add2fav_video
(
   user_id
);

/*==============================================================*/
/* Index: user_add2fav_video2_FK                                */
/*==============================================================*/
create index user_add2fav_video2_FK on user_add2fav_video
(
   video_id
);

/*==============================================================*/
/* Table: user_like_video                                       */
/*==============================================================*/
create table user_like_video
(
   user_id              bigint not null,
   video_id             varchar(20) not null
);

/*==============================================================*/
/* Index: user_like_video_FK                                    */
/*==============================================================*/
create index user_like_video_FK on user_like_video
(
   user_id
);

/*==============================================================*/
/* Index: user_like_video2_FK                                   */
/*==============================================================*/
create index user_like_video2_FK on user_like_video
(
   video_id
);

/*==============================================================*/
/* Table: user_publish_video                                    */
/*==============================================================*/
create table user_publish_video
(
   user_id              bigint not null,
   video_id             varchar(20) not null
);

/*==============================================================*/
/* Index: user_publish_video_FK                                 */
/*==============================================================*/
create index user_publish_video_FK on user_publish_video
(
   user_id
);

/*==============================================================*/
/* Index: user_publish_video2_FK                                */
/*==============================================================*/
create index user_publish_video2_FK on user_publish_video
(
   video_id
);

/*==============================================================*/
/* Table: user_watch_video                                      */
/*==============================================================*/
create table user_watch_video
(
   video_id             varchar(20) not null,
   user_id              bigint not null,
   watch_time           timestamp not null
);

/*==============================================================*/
/* Index: user_watch_video_FK                                   */
/*==============================================================*/
create index user_watch_video_FK on user_watch_video
(
   video_id
);

/*==============================================================*/
/* Index: user_watch_video2_FK                                  */
/*==============================================================*/
create index user_watch_video2_FK on user_watch_video
(
   user_id
);

/*==============================================================*/
/* Table: video                                                 */
/*==============================================================*/
create table video
(
   video_id             varchar(20) not null,
   section_name         varchar(20) not null,
   video_title          varchar(50) not null,
   video_length         int not null,
   video_publish_time   timestamp not null,
   video_require_vip    bool not null,
   video_iframe_url     varchar(256)
);

/*==============================================================*/
/* Index: video_PK                                              */
/*==============================================================*/
create unique index video_PK on video
(
   video_id
);

/*==============================================================*/
/* Index: video_in_section_FK                                   */
/*==============================================================*/
create index video_in_section_FK on video
(
   section_name
);

/*==============================================================*/
/* Table: video_comment                                         */
/*==============================================================*/
create table video_comment
(
   video_id             varchar(20) not null,
   comment_seqnum       int not null,
   user_id              bigint not null,
   comment_time         timestamp not null,
   comment_text         varchar(256) not null
);

/*==============================================================*/
/* Index: comment_below_video_FK                                */
/*==============================================================*/
create index comment_below_video_FK on video_comment
(
   video_id
);

/*==============================================================*/
/* Index: user_make_comment_FK                                  */
/*==============================================================*/
create index user_make_comment_FK on video_comment
(
   user_id
);

/*==============================================================*/
/* Table: website_user                                          */
/*==============================================================*/
create table website_user
(
   user_id              bigint not null,
   user_name            varchar(25) not null,
   user_exp             int not null,
   user_vip             bool not null
);

/*==============================================================*/
/* Index: user_PK                                               */
/*==============================================================*/
create unique index user_PK on website_user
(
   user_id
);

/*==============================================================*/
/* View: view_follower_count                                    */
/*==============================================================*/
create view  view_follower_count as
select followed_id, count(distinct follower_id) as follower_count
from follow_record
group by followed_id;

/*==============================================================*/
/* View: view_section_video_count                               */
/*==============================================================*/
create view  view_section_video_count as
select section_name, count(distinct video_id) as video_count
from video
group by section_name;

/*==============================================================*/
/* View: view_video_data                                        */
/*==============================================================*/
create view  view_video_data as
select video_id, watched_count, liked_count, faved_count, comment_count
from
(
    select video_id, count(*) as watched_count
    from user_watch_video
    group by video_id
) 
natural full outer join
(
    select video_id, count(*) as liked_count
    from user_like_video
    group by video_id
)
natural full outer join
(
    select video_id, count(*) as faved_count
    from user_add2fav_video
    group by video_id
)
natural full outer join
(
    select video_id, count(*) as comment_count
    from video_comment
    group by video_id
);


create procedure follow (IN uidfollower bigint, IN uidfollowed bigint)
begin
    insert into follow_record
    values (uidfollowed, uidfollower, current_timestamp());
end;


create procedure watch (IN vid varchar(20), IN uid bigint)
begin
    insert into user_watch_video
    values (vid, uid, current_timestamp());
end;


create trigger liked_increase_exp after insert on user_like_video 
referencing new row as nrow
for each row
when (nrow.user_id in (select user_id from website_user)
    and nrow.video_id in (select video_id from video)
)
begin atomic
    update website_user
    set user_exp = user_exp+1
    where website_user.user_id in (
        select user_id as pid
        from user_publish_video
        where user_publish_video.video_id = nrow.video_id
    );
end;


create trigger watch_increase_exp after insert on user_watch_video
referencing new row as nrow
for each row
when (nrow.user_id in (
    select user_id from website_user
))
begin atomic
    update website_user
    set user_exp = user_exp + 1
    where nrow.user_id = website_user.user_id;
end;

