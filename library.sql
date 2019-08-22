--Have following relations: Books, Authors, Readers, Borrows
--a. List the books have been borrowed more than 10 times in 2011
select books.id, books.name from books inner join borrows on books.id = borrows.book_id
where YEAR(borrows.start_date) = 2011
group id,name
having count(*) >=10
--using subquery
select id,name from books
where books.id in
	(
		select borrows.book_id from borrows where YEAR(borrows.start_date) = 2011
		group by borrows.book_id
		having count(*) >= 10
	)
--b. List the readers has borrowed at least 10 different books
select readers.id, readers.name from readers 
inner join borrows on readers.id = borrows.reader_id
group by readers.id, readers.name
having count(distinct book_id) >= 10
--using subquery
select readers.id, readers.name from readers
where readers.id in
	(
	select reader_id from borrows
	group by reader_id
	having count(distinct book_id) >= 10
	)
--c. List the books are being borrowed by a reader in the preceding sentence (b)
select books.id, books.name from books 
inner join borrows on books.id = borrows.book_id
inner join (
	--có thể dùng view 
	select borrows.reader_id from borrows
	group by borrows.reader_id
	having count(distinct book_id) >= 10
	) as top_readers
	on borrows.reader_id = top_readers.reader_id
where borrows.end_time IS NULL
--using subquery
select books.id, books.name from books
where books.id in
	(select distinct book_id from borrows 
	where borrows.reader_id in 
		(
		select borrows.reader_id from borrows
		group by borrows.reader_id
		having count(distinct book_id) >= 10
		)
	)
--d. List of Stephen King books present no one is borrowing
select distinct books.id, books.name from books
inner join authors on books.author_id = authors.id
inner join borrows on books.id = borrows.book_id
where authors.name like '%Stephen King%' and borrows.end_time IS NULL
--using subquery
select SK_books.id, SK_books.name from 
	(
	select books.id, books.name from books 
	where author_id = (select id from authors where authors.name like '%Stephen King%')
	) as SK_books
where SK_books.id  not in ( select distinct book_id from borrows where borrows.end_time IS NULL)
	
