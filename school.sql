--c1: List all students have registered both subjects X, Y
select * from students where students.id in
	(
		select student_id from registers where class_id in
			(
			select classes.id from classes, subjects where  subject_id = subjects.id and subjects.name = 'X' 
			)
	)
	and students.id in
	(
		select student_id from registers where class_id in
			(
			select classes.id from classes, subjects where  subject_id = subjects.id and subjects.name = 'y' 
			)
	)
--using join
select distinct student_id from
	--danh sach sinh vien hoc mon x
	(select distinct student_id from  registers 
	inner join classes on registers.class_id = classes.id  
	inner join subjects on subject_id = subjects.id
	where subjects.name = 'X'
	) as students_X	
inner join 
	--danh sach sinh vien hoc mon y
	(select distinct students_id from  registers 
	inner join classes on registers.class_id = classes.id  
	inner join subjects on subject_id = subjects.id 
	where subjects.name = 'Y'
	) as students_Y
on students_X.student_id = students_Y.student_id

--c2: List the teachers teach more than five class
select id, name from teachers, teachings
where teachers.id = teachings.teacher_id
group by id,name
having count(class_id) >=5;
--using join
select id, name from teachers inner join teachings on teachers.id = teachings.teacher_id
group by id, name
having count(class_id) >=5;
--c3: List the teachers teach a class that have at least 30 student return up
select id, name from teachers, teachings
where teachers.id = teachings.teacher_id and class_id in
	(
		select class_id from registers
		group by class_id
		having count(student_id) >=30
	)
--using join
select teacher_id from teachings inner join 
(
	select class_id from registers inner join classes on class_id = id
	group by class_id
	having count(student_id) >= 30
) as thirty_classes
on teachings.class_id = thirty_classes.class_id
group by teacher_id
having count(*) > 0

--c4: List all subjects of teacher G that have registered by student A
select distinct subject_id from classes,
	(
	select class_id from  registers where student_id = A_id and
	class_id in
		(
			select class_id from teachings where teacher_id = G_id
		)
	) as G_A_class
where classes.id = class_id

--using join

select distinct subjects.id, subjects.name from  registers 
	inner join classes on registers.class_id = classes.id
	inner join teachings on classes.id = teachings.class_id
	inner join subjects on class.subject_id = subjects.id
	where student_id = A_id and teachings.teacher_id = G_id

