/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2022/5/22 21:58:50                           */
/*==============================================================*/


drop trigger liked_increase_exp;

drop trigger watch_increase_exp;

drop procedure if exists follow;

drop procedure if exists watch;

drop view if exists view_follower_count;

drop view if exists view_section_video_count;

drop view if exists view_video_data;

drop index follower_idx on follow_record;

drop index followed_idx on follow_record;

drop table if exists follow_record;

drop index related_idx on related_video;

drop index main_idx on related_video;

drop table if exists related_video;

drop index section_idx on section;

drop table if exists section;

drop index fav_video_idx on user_add2fav_video;

drop index fav_user_idx on user_add2fav_video;

drop table if exists user_add2fav_video;

drop index like_video_idx on user_like_video;

drop index like_user_idx on user_like_video;

drop table if exists user_like_video;

drop index publish_video_idx on user_publish_video;

drop index publish_user_idx on user_publish_video;

drop table if exists user_publish_video;

drop index watch_video_idx on user_watch_video;

drop index watch_user_idx on user_watch_video;

drop table if exists user_watch_video;

drop index video_section_idx on video;

drop index video_idx on video;

drop table if exists video;

drop index comment_user_idx on video_comment;

drop index comment_video_idx on video_comment;

drop table if exists video_comment;

drop index user_idx on website_user;

drop table if exists website_user;

/*==============================================================*/
/* Table: website_user                                          */
/*==============================================================*/
create table website_user
(
   user_id              bigint not null,
   user_name            varchar(25) not null,
   user_exp             int not null,
   user_vip             bool not null,
   primary key (user_id)
);

/*==============================================================*/
/* Table: follow_record                                         */
/*==============================================================*/
create table follow_record
(
   followed_id          bigint not null,
   follower_id          bigint not null,
   follow_time          timestamp not null,
   primary key (followed_id, follower_id),
   constraint FK_followed foreign key (followed_id)
      references website_user (user_id) on delete restrict on update restrict,
   constraint FK_follower foreign key (follower_id)
      references website_user (user_id) on delete restrict on update restrict
);

/*==============================================================*/
/* Index: followed_idx                                          */
/*==============================================================*/
create index followed_idx on follow_record
(
   followed_id
);

/*==============================================================*/
/* Index: follower_idx                                          */
/*==============================================================*/
create index follower_idx on follow_record
(
   follower_id
);

/*==============================================================*/
/* Table: section                                               */
/*==============================================================*/
create table section
(
   section_name         varchar(20) not null,
   administrator_id     bigint not null,
   primary key (section_name),
   constraint FK_administer foreign key (administrator_id)
      references website_user (user_id) on delete restrict on update restrict
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
   video_iframe_url     varchar(256),
   primary key (video_id),
   constraint FK_video_in_section foreign key (section_name)
      references section (section_name) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: related_video                                         */
/*==============================================================*/
create table related_video
(
   main_video_id        varchar(20) not null,
   related_video_id     varchar(20) not null,
   primary key (main_video_id, related_video_id),
   constraint FK_main foreign key (main_video_id)
      references video (video_id) on delete restrict on update restrict,
   constraint FK_related foreign key (related_video_id)
      references video (video_id) on delete restrict on update restrict
);

/*==============================================================*/
/* Index: main_idx                                              */
/*==============================================================*/
create index main_idx on related_video
(
   main_video_id
);

/*==============================================================*/
/* Index: related_idx                                           */
/*==============================================================*/
create index related_idx on related_video
(
   related_video_id
);

/*==============================================================*/
/* Index: section_idx                                           */
/*==============================================================*/
create index section_idx on section
(
   section_name
);

/*==============================================================*/
/* Table: user_add2fav_video                                    */
/*==============================================================*/
create table user_add2fav_video
(
   user_id              bigint not null,
   video_id             varchar(20) not null,
   primary key (user_id, video_id),
   constraint FK_user_add2fav_video foreign key (user_id)
      references website_user (user_id) on delete restrict on update restrict,
   constraint FK_user_add2fav_video2 foreign key (video_id)
      references video (video_id) on delete restrict on update restrict
);

/*==============================================================*/
/* Index: fav_user_idx                                          */
/*==============================================================*/
create index fav_user_idx on user_add2fav_video
(
   user_id
);

/*==============================================================*/
/* Index: fav_video_idx                                         */
/*==============================================================*/
create index fav_video_idx on user_add2fav_video
(
   video_id
);

/*==============================================================*/
/* Table: user_like_video                                       */
/*==============================================================*/
create table user_like_video
(
   user_id              bigint not null,
   video_id             varchar(20) not null,
   primary key (user_id, video_id),
   constraint FK_user_like_video foreign key (user_id)
      references website_user (user_id) on delete restrict on update restrict,
   constraint FK_user_like_video2 foreign key (video_id)
      references video (video_id) on delete restrict on update restrict
);

/*==============================================================*/
/* Index: like_user_idx                                         */
/*==============================================================*/
create index like_user_idx on user_like_video
(
   user_id
);

/*==============================================================*/
/* Index: like_video_idx                                        */
/*==============================================================*/
create index like_video_idx on user_like_video
(
   video_id
);

/*==============================================================*/
/* Table: user_publish_video                                    */
/*==============================================================*/
create table user_publish_video
(
   user_id              bigint not null,
   video_id             varchar(20) not null,
   primary key (user_id, video_id),
   constraint FK_user_publish_video foreign key (user_id)
      references website_user (user_id) on delete restrict on update restrict,
   constraint FK_user_publish_video2 foreign key (video_id)
      references video (video_id) on delete restrict on update restrict
);

/*==============================================================*/
/* Index: publish_user_idx                                      */
/*==============================================================*/
create index publish_user_idx on user_publish_video
(
   user_id
);

/*==============================================================*/
/* Index: publish_video_idx                                     */
/*==============================================================*/
create index publish_video_idx on user_publish_video
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
   watch_time           timestamp not null,
   primary key (video_id, user_id),
   constraint FK_user_watch_video foreign key (video_id)
      references video (video_id) on delete restrict on update restrict,
   constraint FK_user_watch_video2 foreign key (user_id)
      references website_user (user_id) on delete restrict on update restrict
);

/*==============================================================*/
/* Index: watch_user_idx                                        */
/*==============================================================*/
create index watch_user_idx on user_watch_video
(
   user_id
);

/*==============================================================*/
/* Index: watch_video_idx                                       */
/*==============================================================*/
create index watch_video_idx on user_watch_video
(
   video_id
);

/*==============================================================*/
/* Index: video_idx                                             */
/*==============================================================*/
create unique index video_idx on video
(
   video_id
);

/*==============================================================*/
/* Index: video_section_idx                                     */
/*==============================================================*/
create index video_section_idx on video
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
   comment_text         varchar(256) not null,
   primary key (video_id, comment_seqnum),
   constraint FK_comment_below_video foreign key (video_id)
      references video (video_id) on delete restrict on update restrict,
   constraint FK_user_make_comment foreign key (user_id)
      references website_user (user_id) on delete restrict on update restrict
);

/*==============================================================*/
/* Index: comment_video_idx                                     */
/*==============================================================*/
create index comment_video_idx on video_comment
(
   video_id
);

/*==============================================================*/
/* Index: comment_user_idx                                      */
/*==============================================================*/
create index comment_user_idx on video_comment
(
   user_id
);

/*==============================================================*/
/* Index: user_idx                                              */
/*==============================================================*/
create unique index user_idx on website_user
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

