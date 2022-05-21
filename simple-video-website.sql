/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2022/5/22 0:45:20                            */
/*==============================================================*/


drop table if exists follow;

drop table if exists related_video;

drop table if exists section;

drop table if exists user_add2fav_video;

drop table if exists user_like_video;

drop table if exists user_publish_video;

drop table if exists user_watch_video;

drop table if exists video;

drop table if exists video_comment;

drop table if exists website_user;

/*==============================================================*/
/* Table: follow                                                */
/*==============================================================*/
create table follow
(
   followed_id          bigint not null,
   followerr_id         bigint not null,
   follow_time          timestamp not null,
   primary key (followed_id, followerr_id)
);

/*==============================================================*/
/* Table: related_video                                         */
/*==============================================================*/
create table related_video
(
   main_video_id        varchar(20) not null,
   related_video_id     varchar(20) not null,
   primary key (main_video_id, related_video_id)
);

/*==============================================================*/
/* Table: section                                               */
/*==============================================================*/
create table section
(
   section_name         varchar(20) not null,
   administrator_id     bigint not null,
   primary key (section_name)
);

/*==============================================================*/
/* Table: user_add2fav_video                                    */
/*==============================================================*/
create table user_add2fav_video
(
   user_id              bigint not null,
   video_id             varchar(20) not null,
   primary key (user_id, video_id)
);

/*==============================================================*/
/* Table: user_like_video                                       */
/*==============================================================*/
create table user_like_video
(
   user_id              bigint not null,
   video_id             varchar(20) not null,
   primary key (user_id, video_id)
);

/*==============================================================*/
/* Table: user_publish_video                                    */
/*==============================================================*/
create table user_publish_video
(
   user_id              bigint not null,
   video_id             varchar(20) not null,
   primary key (user_id, video_id)
);

/*==============================================================*/
/* Table: user_watch_video                                      */
/*==============================================================*/
create table user_watch_video
(
   video_id             varchar(20) not null,
   user_id              bigint not null,
   watch_time           timestamp not null,
   primary key (video_id, user_id)
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
   primary key (video_id)
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
   primary key (video_id, comment_seqnum)
);

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

alter table follow add constraint FK_followed foreign key (followed_id)
      references website_user (user_id) on delete restrict on update restrict;

alter table follow add constraint FK_follower foreign key (followerr_id)
      references website_user (user_id) on delete restrict on update restrict;

alter table related_video add constraint FK_main foreign key (main_video_id)
      references video (video_id) on delete restrict on update restrict;

alter table related_video add constraint FK_related foreign key (related_video_id)
      references video (video_id) on delete restrict on update restrict;

alter table section add constraint FK_administer foreign key (administrator_id)
      references website_user (user_id) on delete restrict on update restrict;

alter table user_add2fav_video add constraint FK_user_add2fav_video foreign key (user_id)
      references website_user (user_id) on delete restrict on update restrict;

alter table user_add2fav_video add constraint FK_user_add2fav_video2 foreign key (video_id)
      references video (video_id) on delete restrict on update restrict;

alter table user_like_video add constraint FK_user_like_video foreign key (user_id)
      references website_user (user_id) on delete restrict on update restrict;

alter table user_like_video add constraint FK_user_like_video2 foreign key (video_id)
      references video (video_id) on delete restrict on update restrict;

alter table user_publish_video add constraint FK_user_publish_video foreign key (user_id)
      references website_user (user_id) on delete restrict on update restrict;

alter table user_publish_video add constraint FK_user_publish_video2 foreign key (video_id)
      references video (video_id) on delete restrict on update restrict;

alter table user_watch_video add constraint FK_user_watch_video foreign key (video_id)
      references video (video_id) on delete restrict on update restrict;

alter table user_watch_video add constraint FK_user_watch_video2 foreign key (user_id)
      references website_user (user_id) on delete restrict on update restrict;

alter table video add constraint FK_video_in_section foreign key (section_name)
      references section (section_name) on delete restrict on update restrict;

alter table video_comment add constraint FK_comment_below_video foreign key (video_id)
      references video (video_id) on delete restrict on update restrict;

alter table video_comment add constraint FK_user_make_comment foreign key (user_id)
      references website_user (user_id) on delete restrict on update restrict;

