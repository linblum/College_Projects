#drop all the tables in opposite order of dependencies
drop table if exists projVolunteers;
drop table if exists interestedIn;
drop table if exists timeslot;
drop table if exists hosts;
drop table if exists projectCat;
drop table if exists Category;
drop table if exists Volunteer;
drop table if exists Project;
drop table if exists Organization;
#create all the tables
create table Organization
(
  OrgNo int not null,
  name varchar(40) not null unique,
  email varchar(100) not null,
  phoneNo varchar(12),
  street varchar(100) ,
  city varchar(100) ,
  state char(2),
  zipcode int(5),
  nProjects int default 0,
  constraint pk_organization primary key (OrgNo)
);

create table Project
(
  projID int not null,
  description varchar(100) unique,
  startingDate date,
  endDate date,
  location varchar(200),
  nVolNeeded int not null,
  status enum ("pending","open","fulfilled","past","cancelled"),
  constraint pk_project primary key (projID)
);

create table Volunteer
(
  VolID int not null,
  name varchar(100) not null,
  Address varchar(200),
  preferredLocation varchar(200),
  preferredOrg int not null,
  constraint pk_volunteer primary key (VolID),
  constraint fk_vol_organization foreign key (preferredOrg) references Organization(OrgNo)
);

create table Category
(
  catID int not null,
  name varchar(100) not null,
  Description varchar(500),
  constraint pk_category primary key (catID)
);

create table hosts
(
  OrgNo int not null,
  projID int not null,
  constraint pk_hosts primary key (OrgNo, projID),
  constraint fk_hosts_organization foreign key (OrgNo) references Organization(OrgNo),
  constraint fk_hosts_project foreign key (projID) references Project(projID)
);

create table ProjectCat
(
  ranking int not null,
  projID int not null,
  catID int not null,
  constraint pk_projectcat primary key (projID, catID),
  constraint fk_projectcat_proj foreign key (projID) references Project(projID),
  constraint fk_projectcat_cat foreign key(catID) references Category(catID)
);

create table InterestedIn
(
  VolID int not null,
  catID int not null,
  constraint pk_interestedin primary key(VolID, catID),
  constraint fk_interestedin_vol foreign key (VolID) references Volunteer(VolID),
  constraint fk_interestedin_cat foreign key (catID) references Category(catID)
);

create table TimeSlot
(
  Day date not null,
  startingTime time not null,
  nVolneeded int not null,
  duration int,
  projID int not null,
  constraint pk_timeslot primary key (Day, startingTime, projID),
  constraint fk_timeslot_project foreign key (projID) references Project(projID)
);

create table ProjVolunteers
(
  VolID int not null,
  projID int not null,
  Day date not null,
  startingTime time not null,
  constraint pk_projVolunteers primary key (VolID, projID, Day, startingTime),
  constraint fk_projVolunteers_vol foreign key (VolID) references Volunteer(VolID),
  constraint fk_projVolunteers_timeslot foreign key (projID, Day, startingTime) references TimeSlot(projID, Day, startingTime)
);

insert into category values 
(121, "fundraiser", "Projects that aim to raise money for a cause. Examples could be: dinners, races, sales of any sort"),
(122, "service", "Projects that provide services to those who need them" );

insert into organization values 
(10001, "Grove City College", "info@gcc.edu", "724-458-2000", "100 campus drive", "Grove City", "PA", 16127,0),
(10002, "Beverly's Birthdays", "getinvolved@beverlysbirthdays.org", "724-590-5106", "9799 Laurel Avenue","North Huntingdon", "PA", 15642,0);

insert into project values 
(2211, "Girls who code at GCC Shower", "2022-02-09", "2022-02-09", "Grove City College - STEM building", 10,"open"),
(2212, "Beverly's Birthday Baby Shower", "2021-10-24", "2021-10-24", "Genesis of Pittsburgh", 4,"past"),
(2213, "Beverly's Birthday", "2021-10-24", "2021-10-24", "Genesis of Pittsburgh", 1,"open");

insert into projectcat values 
(1,2211,122),(1,2212,122), (2,2212,121),(1,2213,122);


insert into hosts values (10001, 2211), (10002, 2212), (10001, 2212), (10002,2213);

insert into timeslot values 
("2022-02-09", "10:00:00", 6, 4, 2211),
("2022-02-09", "14:00:00", 4, 4, 2211),
("2021-10-24", "10:00:00", 4, 3, 2212),
("2021-09-06", "12:00:00", 1, 10, 2213);


insert into volunteer values 
(5678, "Judy Workshard", "100 Walnut Street, Pittsburgh PA", null, 10002),
(5688, "Frank Stevens", "100 main Street, Grove City PA", "GCC Campus", 10001),
(5689, "Christine Stone", "100 main Street, Grove City PA", "GCC Campus", 10001);

insert into interestedin values
(5678, 122), (5688, 121);

insert into projvolunteers values
(5678, 2211,"2022-02-09", "14:00:00"),
(5678, 2212,"2021-10-24", "10:00:00"),
(5688, 2213,"2021-09-06", "12:00:00");
