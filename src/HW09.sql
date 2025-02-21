create database HW_09_Q1;
drop table if exists student, teacher, term, course, enrolment;


create table student
(
    id   int,
    name varchar(50) not null,
    primary key (id)
);

create table teacher
(
    id   int,
    name varchar(50) not null ,
    primary key (id)
);

create table term
(
    id         int,
    begin_date date not null,
    end_date   date not null,
    primary key (id)
);

create table course
(
    id         int,
    name       varchar(50) not null,
    term_id    int         not null,
    teacher_id int         not null,
    capacity   int         not null,
    primary key (id),
    foreign key (term_id) references term (id),
    foreign key (teacher_id) references teacher (id)

);

create table enrolment
(
    id         int,
    course_id  int not null,
    student_id int not null,
    grade      float,
    unique (course_id, student_id),
    primary key (id),
    foreign key (course_id) references course (id),
    foreign key (student_id) references student (id)
);

---1
select s.id, s.name
from student s
         left join enrolment e on s.id = e.student_id
where e.student_id is null;

---2-1
select *
from student s
where not exists (
    select 1
    from enrolment e
    where e.student_id = s.id
      and e.grade is not null
)
  and exists (
    select 1
    from enrolment e
    where e.student_id = s.id
);

---2-2
select s.*
from student s
         join enrolment e on s.id = e.student_id
group by s.id
having count(e.grade) = 0 and count(e.id) > 0;


---3
select s.id, s.name
from student s
         join enrolment e on s.id = e.student_id
group by s.id, s.name
having min(e.grade) >= 12
   and max(e.grade) <= 18;


---4
select s.id, s.name
from student s
         join enrolment e on s.id = e.student_id
group by s.id, s.name
having min(e.grade) >= 15;

---5
select t.id, t.name
from teacher t
         left join course c on t.id = c.teacher_id
         left join enrolment e on c.id = e.course_id
where e.student_id is null;

---6
select t.id, t.name
from teacher t
         left join course c on t.id = c.teacher_id
         left join enrolment e on c.id = e.course_id
where e.grade is null
group by t.id,t.name;

---7
select t.id, t.name
from teacher t
         left join course c on t.id = c.teacher_id
         left join enrolment e on c.id = e.course_id
group by t.id, t.name
having sum(case when e.grade < 10 then 1 else 0 end) = 0;

---8
select t.id, t.name, avg(e.grade) as avg_grade
from teacher t
         join course c on t.id = c.teacher_id
         join enrolment e on c.id = e.course_id
group by t.id, t.name
order by avg_grade desc
    limit 1;

---9
select t.id, t.begin_date, t.end_date, avg(e.grade) as avg_grade
from term t
         join course c on t.id = c.term_id
         join enrolment e on c.id = e.course_id
where c.id = 1
group by t.id, t.begin_date, t.end_date
order by avg_grade desc
    limit 1;

---10
select student_id, max(grade) as highset_grade
from enrolment
where grade is not null
group by student_id;
---11
select s.id, s.name, e.grade
from student s
         join enrolment e on s.id = e.student_id
where s.name ilike 'a%' and e.grade is not null
group by s.id, s.name, e.grade
order by e.grade desc
    limit 5;

---12
select s.id, s.name, avg(e.grade) as avg_grade, t.id as term_id
from student s
         join enrolment e on s.id = e.student_id
         join course c on e.course_id = c.id
         join term t on c.term_id = t.id
group by s.id, s.name, t.id
having t.id = (select max(t2.id)
               from term t2
                        join course c2 on t2.id = c2.term_id
               where c2.id in (select course_id from enrolment where student_id = s.id))
   and avg(e.grade) > 15;

---13
select distinct s.id, s.name
from student s
         join enrolment e on s.id = e.student_id
         join course c on e.course_id = c.id
where e.grade = (select max(e2.grade)
                 from enrolment e2
                 where e2.course_id = c.id);

---14
select t.id, t.name
from teacher t
         join course c on t.id = c.teacher_id
group by t.id, t.name
having count(c.id) > 3;

---15
select t.id, t.name
from teacher t
         join course c on t.id = c.teacher_id
group by t.id, t.name
having count(distinct c.term_id) > 3;

---16
select t.id, t.name
from teacher t
         join course c on t.id = c.teacher_id
group by t.id, t.name
having count(distinct c.term_id) = count(c.id);

---17
select t.id, t.begin_date, t.end_date
from term t
         join course c on t.id = c.term_id
         left join enrolment e on c.id = e.course_id
group by t.id, t.begin_date, t.end_date
having count(distinct e.student_id) = sum(c.capacity);

---18
select distinct t.id, t.name
from teacher t
         join course c on t.id = c.teacher_id
         join term te on c.term_id = te.id
where te.end_date > '1403/07/01'
  and c.id not in (select course_id
                   from enrolment e
                   where e.grade is not null);

create database HW_09_Q2;

create table project
(
    project_id int,
    name       varchar not null,
    start_year int     not null,
    primary key (project_id)
);

create table employee
(
    employee_ID         serial,
    first_name          varchar        not null,
    last_name           varchar        not null,
    salary              decimal(10, 2) not null,
    daily_working_hours int            not null,
    last_month_hours    int            not null,
    project_id          int            not null,
    primary key (employee_ID),
    foreign key (project_id) references project (project_id)
);

insert into employee(first_name, last_name, salary, daily_working_hours, last_month_hours, project_id)
values ('Taha', 'Badri', 30000000, 8, 240, 1),
       ('Saeed', 'Bagheri', 10000000, 8, 240, 2),
       ('Mahsa', 'Abolghasemi', 40000000, 8, 240, 3),
       ('Elahe', 'Khosrokiani', 25000000, 8, 240, 1),
       ('Farshid', 'vosoghi', 35000000, 8, 240, 2);

insert into project
values (1, 'X', 2021),
       (2, 'Bank', 2015),
       (3, 'Restaurant', 2024);

---1
select *
from employee
where salary > (select avg(salary) from employee);
---2
select *
from employee
where ((salary / 30) / 8) > 20000;
---3
select e.*
from employee e
         join project p on p.project_id = e.project_id
where p.name = 'X';
---4
select p.name as project_name, count(e.employee_ID) as employee_count
from project p
         left join employee e on p.project_id = e.project_id
group by p.project_id, p.name;

create database hw_09_q3;

create table branch
(
    id  serial primary key,
    name       varchar(255) not null,
    city       varchar(100) not null,
    manager_id int unique
);

create table manager
(
    id serial primary key,
    name       varchar(255) not null,
    branch_id  int unique   references branch (id) on delete set null
);

create table supplier
(
    id  serial primary key,
    name         varchar(255) not null,
    contact_info varchar
);

create table delivery
(
    id   serial primary key,
    supplier_id   int references supplier (id) on delete cascade,
    branch_id     int references branch (id) on delete cascade,
    delivery_date date not null
);

create table employee
(
    id serial primary key,
    name        varchar(255)   not null,
    role        varchar(50) check (role in ('chef', 'waiter', 'worker', 'driver')),
    branch_id   int references branch (id) on delete cascade,
    salary      decimal(10, 2) not null,
    work_hours  int            not null
);

create table food
(
    id serial primary key,
    name    varchar(255)   not null,
    price   decimal(10, 2) not null
);

create table foodingredient
(
    food_id    int references food (id) on delete cascade,
    ingredient varchar(255) not null,
    quantity   varchar(50)  not null,
    primary key (food_id, ingredient)
);

create table customer
(
    id serial primary key,
    name        varchar(255) not null,
    type        varchar(50) check (type in ('regular', 'corporate'))
);

create table contract
(
    id   serial primary key,
    customer_id   int references customer (id) on delete cascade,
    branch_id     int references branch (id) on delete cascade,
    food_id       int references food (id) on delete cascade,
    delivery_date date not null
);

create table ordertable
(
    id    serial primary key,
    customer_id int references customer (id) on delete set null,
    branch_id   int references branch (id) on delete cascade,
    order_date  timestamp default current_timestamp
);

create table orderdetail
(
    order_id int references ordertable (id) on delete cascade,
    food_id  int references food (id) on delete cascade,
    quantity int not null check (quantity > 0),
    primary key (order_id, food_id)
);

create table complaint
(
    id   serial primary key,
    customer_id    int  references customer (id) on delete set null,
    branch_id      int references branch (id) on delete cascade,
    description    text not null,
    complaint_date timestamp default current_timestamp
);

create table rating
(
    id   serial primary key,
    customer_id int references customer (id) on delete set null,
    branch_id   int references branch (id) on delete cascade,
    food_id     int references food (id) on delete cascade,
    score       int check (score between 0 and 90),
    rating_date timestamp default current_timestamp
);

select *
from branch;
--------------------
select *
from manager;
--------------------
select *
from supplier;
--------------------
select *
from delivery;
--------------------
select *
from employee;
--------------------
select *
from food;
--------------------
select *
from foodingredient;
--------------------
select *
from customer;
--------------------
select *
from contract;
--------------------
select *
from ordertable;
--------------------
select *
from orderdetail;
--------------------
select *
from complaint;
--------------------

select *
from rating;

create database hw_09_q4;

create table city
(
    id   serial primary key,
    name varchar(100) not null
);

create table league
(
    id   serial primary key,
    name varchar(100) not null
);

create table stadium
(
    id       serial primary key,
    name     varchar(100) not null ,
    capacity int                 not null,
    city_id  int references city (id) on delete cascade
);

create table team
(
    id      serial primary key,
    name    varchar(100)not null ,
    city_id int references city (id) on delete cascade
);

create table coach
(
    id   serial primary key,
    name varchar(100) not null
);

create table coach_contract
(
    id          serial primary key,
    coach_id    int references coach (id) on delete cascade,
    team_id     int references team (id) on delete cascade,
    season_year int            not null,
    salary      numeric(12, 1) not null
);

create table player
(
    id          serial primary key,
    name        varchar(100) not null,
    position    varchar(50)  not null,
    skill_level int          not null
);

create table player_contract
(
    id          serial primary key,
    player_id   int references player (id) on delete cascade,
    team_id     int references team (id) on delete cascade,
    season_year int            not null,
    salary      numeric(12, 2) not null
);

create table match
(
    id           serial primary key,
    home_team_id int references team (id) on delete cascade,
    away_team_id int references team (id) on delete cascade,
    stadium_id   int references stadium (id) on delete cascade,
    date         date not null,
    season_year  int  not null
);

create table match_result
(
    match_id int references match (id) on delete cascade,
    team_id  int references team (id) on delete cascade,
    goals    int not null,
    points   int check (points in (0, 1, 3)),
    primary key (match_id, team_id)
);

create table goal_scorer
(
    id        serial primary key,
    match_id  int references match (id) on delete cascade,
    player_id int references player (id) on delete cascade,
    goals     int not null
);

INSERT INTO city (name) VALUES
                            ('Tehran'),
                            ('Shiraz');
INSERT INTO league (name) VALUES
                              ('Premier League'),
                              ('Second Division');
INSERT INTO stadium (name, capacity, city_id) VALUES
                                                  ('Azadi Stadium', 78000, 1),
                                                  ('Fooladshahr Stadium', 25000, 2);
INSERT INTO team (name, city_id) VALUES
                                     ('Persepolis', 1),
                                     ('Esteghlal', 1),
                                     ('Foolad', 2);
INSERT INTO coach (name) VALUES
                             ('Branko Ivankovic'),
                             ('Andrea Stramaccioni'),
                             ('Javad Nekounam');
INSERT INTO coach_contract (coach_id, team_id, season_year, salary) VALUES
                                                                        (1, 1, 2023, 500000.00),
                                                                        (2, 2, 2023, 400000.00),
                                                                        (3, 3, 2023, 300000.00);
INSERT INTO player (name, position, skill_level) VALUES
                                                     ('Ali Karimi', 'Midfielder', 5),
                                                     ('Mehdi Taremi', 'Forward', 5),
                                                     ('Sardar Azmoun', 'Forward', 5),
                                                     ('Omid Ebrahimi', 'Midfielder', 3),
                                                     ('Mohammad Reza Khanzadeh', 'Defender', 4),
                                                     ('Mohammad Noori', 'Midfielder', 3);
INSERT INTO player_contract (player_id, team_id, season_year, salary) VALUES
                                                                          (1, 1, 2023, 200000.00),
                                                                          (2, 1, 2023, 300000.00),
                                                                          (3, 2, 2023, 350000.00),
                                                                          (4, 2, 2023, 200000.00),
                                                                          (5, 3, 2023, 150000.00),
                                                                          (6, 3, 2023, 100000.00);
INSERT INTO match (home_team_id, away_team_id, stadium_id, date, season_year) VALUES
                                                                                  (1, 2, 1, '2023-02-20', 2023),
                                                                                  (2, 3, 2, '2023-02-21', 2023),
                                                                                  (1, 3, 1, '2023-02-22', 2023);
INSERT INTO match_result (match_id, team_id, goals, points) VALUES
                                                                (1, 1, 2, 3),
                                                                (1, 2, 1, 0),
                                                                (2, 2, 3, 3),
                                                                (2, 3, 0, 0),
                                                                (3, 1, 1, 1),
                                                                (3, 3, 1, 1);
INSERT INTO goal_scorer (match_id, player_id, goals) VALUES
                                                         (1, 2, 1),  -- Mehdi Taremi scored 1 goal in match 1
                                                         (1, 3, 1),  -- Sardar Azmoun scored 1 goal in match 1
                                                         (2, 1, 1),  -- Ali Karimi scored 1 goal in match 2
                                                         (2, 2, 2),  -- Mehdi Taremi scored 2 goals in match 2
                                                         (3, 5, 1);  -- Mohammad Reza Khanzadeh scored 1 goal in match 3



---1
select c.name, max(cc.salary) as max_salary
from coach_contract cc
         join coach c on cc.coach_id = c.id
group by c.name
order by max_salary desc
    limit 1;

---2
select player.name, MAX(player_contract.salary)
from player
         join player_contract on player.id = player_contract.player_id
group by player.name;
---3
select c.name as city_name, count(t.id) as team_count
from city c
         left join team t on c.id = t.city_id
group by c.name
order by team_count desc;

---4
select team.name, sum(match_result.points) as total_points
from team
         join match_result on team.id = match_result.team_id
         join match on match_result.match_id = match.id
where match.season_year = 2023
group by team.name
order by total_points desc;

---5
select team.name, sum(match_result.points) as total_points
from team
         join match_result on team.id = match_result.team_id
         join match on match_result.match_id = match.id
where match.season_year = 2023
group by team.name
order by total_points desc
    limit 1;
---6
select t1.name as team_1, t2.name as team_2, max(match_result.goals) as total_goals
from match
         join team t1 on match.home_team_id = t1.id
         join team t2 on match.away_team_id = t2.id
         join match_result on match.id = match_result.match_id
where t1.city_id = t2.city_id and match.season_year = 2023
group by t1.name, t2.name
order by total_goals desc
    limit 1;





