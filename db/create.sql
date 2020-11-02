drop table if exists experiments;
create table experiments (
 id               int           not null auto_increment,
 goal             text          not null,
 protocole        text          not null,
 result           text          not null,
 conclusion       text          not null,
 summary          text          not null,
 title            varchar(255)  not null,
 typexp_id        int,
 last_update      date          not null,
 date_exp         date          not null,
 parent_id        int,
 project_id       int           not null,             
 primary key (id),
 constraint fk_experiment_typexp          foreign key (typexp_id) references typexps(id),
 constraint fk_experiment_project         foreign key (project_id) references projects(id)
 );
 
drop table if exists docs;
create table docs (
 id                             int                 not null auto_increment,
 title                          varchar(255)  not null,
 legend                      text,
 avatar_file_name      varchar(255),
 avatar_content_type  varchar(255),
 avatar_file_size         int,
 avatar_updated_at    datetime,
 avatar_width             int,
 avatar_height            int,
 avatar_dpih               int,
 avatar_dpiw               int,
 protref_id                  int,
 primary key (id)
 );


drop table if exists documentations;
create table documentations (
 id                   int           not null auto_increment,
 title                varchar(255)  not null,
 author               varchar(500)  not null,
 year                 date          not null,
 source               varchar(255)  not null,
 last_update          date          not null,
 note                 text          not null,
 project_id           int           not null,
 constraint fk_documentation_project         foreign key (project_id) references projects(id),
 primary key (id)
 ); 

drop table if exists linkdocumentationdocs;
create table linkdocumentationdocs (
 id                   int           not null auto_increment,
 doc_id               int           not null,
 documentation_id     int           not null,
 primary key (id),
 constraint fk_linkdocumentationdoc_doc           foreign key (doc_id) references docs(id),
 constraint fk_linkducumentationdoc_documentation foreign key (documentation_id) references documentations(id)
);
 
create table linkprotrefdocs (
 id                   int           not null auto_increment,
 doc_id               int           not null,
 protref_id     int           not null,
 primary key (id),
 constraint fk_linkprotrefdoc_doc           foreign key (doc_id) references docs(id),
 constraint fk_linkprotrefdoc_protref foreign key (protref_id) references protrefs(id)
);

drop table if exists linkexpdocs;
create table linkexpdocs (
 id               int           not null auto_increment,
 doc_id           int           not null,
 experiment_id    int           not null,
 primary key (id),
 constraint fk_linkexpdoc_doc           foreign key (doc_id) references docs(id),
 constraint fk_linkexpdoc_experiment    foreign key (experiment_id) references experiments(id)
);

drop table if exists typexps;
create table typexps (
 id                   int           not null auto_increment,
 name                 varchar(255)  not null,
 primary key (id)
 );
 
drop TABLE if exists sessions;
create table sessions (
  id                  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  sessid              CHAR(32),
  data                LONGTEXT,
  PRIMARY KEY(id),
  INDEX(sessid)
);
 
drop table if exists projects;
create table projects (
 id                   int           unsigned not null auto_increment,
 name                 varchar(40)   not null,
 parent_id            int           unsigned,
 user_id              int           unsigned not null,
 other_content        varchar(255),
 primary key (id)
);

drop table if exists protrefs;
create table protrefs (
 id               int           not null auto_increment,
 title            varchar(255)  not null,
 protocole        text          not null,
 user_id          int           not null,
 primary key (id),
 constraint fk_protref_user_id  foreign key (user_id) references users(id) 
 );
 
 drop table if exists linkexpprotrefs;
create table linkexpprotrefs (
 id                   int           not null auto_increment,
 experiment_id        int           not null,
 protref_id     int           not null,
 primary key (id),
 constraint fk_linkexpprotref_experiment           foreign key (experiment_id) references experiments(id),
 constraint fk_linkexpprotref_protref              foreign key (protref_id) references protrefs(id)
);

 drop table if exists users;
create table users (
 id                   int           not null auto_increment,
 name                 varchar(100)  not null,
 hashed_password      char(40)      null,
 email                varchar(255)  not null,
 primary key (id)
);