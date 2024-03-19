create database library_project ;
use library_project;

create table tbl_publisher(publisher_PublisherName varchar(255)primary key,publisher_PublisherAddress varchar(255),publisher_PublisherPhone varchar(20));
select * from tbl_publisher;
-- 
create table tbl_borrower(borrower_CardNo int primary key ,borrower_BorrowerName varchar(255),borrower_BorrowerAddress varchar(255),borrower_BorrowerPhone varchar(255));
select * from tbl_borrower;

--       
create table tbl_library_branch(library_branch_BranchID int auto_increment primary key,library_branch_BranchName varchar(255),library_branch_BranchAddress varchar(255));

select * from tbl_library_branch;

--       


create table tbl_book(book_BookID int primary key ,book_Title varchar(255),book_PublisherName varchar(255),
foreign key(book_PublisherName)references tbl_publisher(publisher_PublisherName) 
on update cascade on delete cascade);

select* from tbl_book;

create table tbl_book_authers(book_authers_AutherID int auto_increment primary key,book_authors_AuthorName varchar(255),
book_authors_BookID int,foreign key(book_authors_BookID)references tbl_book(book_BookID)on update cascade on delete cascade
);

select * from tbl_book_authers;

create table tbl_book_copies(book_copies_CopiesID int auto_increment primary key,book_copies_BookID int,
foreign key(book_copies_BookID)references tbl_book(book_BookID)on update cascade on delete cascade ,
book_copies_BranchID int,foreign key(book_copies_BranchID)references tbl_library_branch(library_branch_BranchID)
on update cascade on delete cascade ,book_copies_No_of_Copies int);

select * from tbl_book_copies;

create table tbl_book_loans(book_loans_LoanID int auto_increment primary key,book_loans_BookID int,
foreign key(book_loans_BookID)references tbl_book(book_BookID)on update cascade on delete cascade,
book_loans_BranchID int,foreign key(book_loans_BranchID)references tbl_library_branch(library_branch_BranchID)
on update cascade on delete cascade,book_loans_CardNo int,foreign key(book_loans_CardNo) references tbl_borrower(borrower_CardNo)
on update cascade on delete cascade,book_loans_DateOut varchar(255),book_loans_DueDate varchar(255)
);
select * from tbl_book_loans;

set sql_safe_updates=0;

UPDATE tbl_book_loans
SET book_loans_DateOut = STR_TO_DATE(book_loans_DateOut, '%m/%d/%y');

UPDATE tbl_book_loans
SET book_loans_DueDate = STR_TO_DATE(book_loans_DueDate, '%m/%d/%y');

select * from tbl_book;
select * from tbl_publisher;
select * from tbl_borrower;
select * from tbl_library_branch;
select * from tbl_book_authers;
select * from tbl_book_copies;
select * from tbl_book_loans;

-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?                
                
select * from tbl_library_branch join tbl_book_copies on book_copies_BranchID=library_branch_BranchID
right join tbl_book on book_copies_BookID=book_BookID
where book_Title="The Lost Tribe" and library_branch_BranchName="Sharpstown";


-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select sum(book_copies_No_of_Copies)as sumn , book_Title from tbl_library_branch join tbl_book_copies on book_copies_BranchID=library_branch_BranchID
right join tbl_book on book_copies_BookID=book_BookID
where book_Title="The Lost Tribe";

-- 3.Retrieve the names of all borrowers who do not have any books checked out.

select * from tbl_borrower left join tbl_book_loans on borrower_CardNo= book_loans_CardNo
where book_loans_CardNo is null ;

-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title,the borrower's name, and the borrower's address.

select book_Title,borrower_BorrowerName,borrower_BorrowerAddress
from tbl_book_loans join tbl_library_branch on book_loans_BranchID=library_branch_BranchID join tbl_book on book_loans_BookID=
book_BookID join tbl_borrower on borrower_CardNo=book_loans_CardNo
 where library_branch_BranchName="Sharpstown" and book_loans_DueDate="2018-02-03";

-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select library_branch_BranchName,count(book_loans_BookID) from tbl_library_branch join tbl_book_loans on 
book_loans_BranchID=library_branch_BranchID group by library_branch_BranchName;
 
-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out. 

select borrower_BorrowerName,borrower_BorrowerAddress,count(book_loans_BookID)as cnb from tbl_borrower join tbl_book_loans on borrower_CardNo=book_loans_CardNO
group by borrower_BorrowerName,borrower_BorrowerAddress having cnb>5;

-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select book_Title ,book_copies_No_of_Copies from tbl_book_authers join tbl_book_copies on book_copies_BookID=book_authors_BookID
join tbl_book on book_BookID=book_authors_BookID join tbl_library_branch on library_branch_BranchID=book_copies_BranchID
where book_authors_AuthorName="Stephen King" and library_branch_BranchName="Central";
 
 
