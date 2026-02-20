-- Drop database Library_management1;
create database Library_management1;
use Library_management1;

-- Table: tbl_publisher 
CREATE TABLE tbl_publisher ( 
    publisher_PublisherName VARCHAR(255) PRIMARY KEY, 
    publisher_PublisherAddress TEXT, 
    publisher_PublisherPhone VARCHAR(15) 
);
select*from tbl_publisher;

 -- Table: tbl_book 
CREATE TABLE tbl_book ( 
    book_BookID INT PRIMARY KEY, 
    book_Title VARCHAR(255), 
    book_PublisherName VARCHAR(255), 
    FOREIGN KEY (book_PublisherName) REFERENCES 
tbl_publisher(publisher_PublisherName) 
); 
select*from tbl_book;

 -- Table: tbl_book_authors 
CREATE TABLE tbl_book_authors ( 
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT, 
    book_authors_BookID INT, 
    book_authors_AuthorName VARCHAR(255), 
 
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID) 
); 

select*from tbl_book_authors;
truncate tbl_book_authors;
select*from tbl_book_authors;

 -- Table: tbl_library_branch 
CREATE TABLE tbl_library_branch ( 
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT, 
    library_branch_BranchName VARCHAR(255), 
    library_branch_BranchAddress TEXT 
);
select*from tbl_library_branch;


 -- Table: tbl_book_copies 
CREATE TABLE tbl_book_copies ( 
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT, 
    book_copies_BookID INT, 
    book_copies_BranchID INT, 
    book_copies_No_Of_Copies INT, 
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID), 
    FOREIGN KEY (book_copies_BranchID) REFERENCES 
tbl_library_branch(library_branch_BranchID) 
); 
select * from tbl_book_copies;

 -- Table: tbl_borrower 
CREATE TABLE tbl_borrower ( 
    borrower_CardNo INT PRIMARY KEY, 
    borrower_BorrowerName VARCHAR(255), 
    borrower_BorrowerAddress TEXT, 
    borrower_BorrowerPhone VARCHAR(15) 
);
select*from tbl_borrower;
 -- Table: tbl_book_loans 
CREATE TABLE tbl_book_loans ( 
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT, 
    book_loans_BookID INT, 
    book_loans_BranchID INT, 
    book_loans_CardNo INT, 
    book_loans_DateOut DATE, 
    book_loans_DueDate DATE, 
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID), 
    FOREIGN KEY (book_loans_BranchID) REFERENCES 
tbl_library_branch(library_branch_BranchID), 
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo) 
); 
select*from tbl_book_loans;


-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Picador USA"?
SELECT bc.book_copies_No_Of_Copies
FROM tbl_book_copies AS bc
JOIN tbl_book AS b ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch AS lb ON lb.library_branch_BranchID=bc.book_copies_BranchID
WHERE b.book_Title = 'The Lost Tribe'
AND lb.library_branch_BranchName = 'Sharpstown';


-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT lb.library_branch_BranchName, bc.book_copies_No_of_Copies
FROM tbl_book AS b
JOIN tbl_book_copies AS bc ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch AS lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = "The Lost Tribe";

-- 3. Retrieve the names of all borrowers who do not have any books checked out.
SELECT br.borrower_BorrowerName
FROM tbl_borrower br
LEFT JOIN tbl_book_loans bl ON br.borrower_CardNo = bl.book_loans_CardNo
WHERE bl.book_loans_LoansID IS NULL;

-- 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.
select b.book_title,br.borrower_BorrowerName,br.borrower_BorrowerAddress
from tbl_book_loans bl
inner join tbl_book b
on bl.book_loans_BookID = b.book_BookID
inner join tbl_library_branch lb
on bl.book_loans_BranchID = lb.library_branch_BranchID
inner join tbl_borrower br
on bl.book_loans_CardNo=br.borrower_CardNo
where lb.library_branch_BranchName = "Sharpstown"
and bl.book_loans_DueDate = '2/3/18';

-- 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT lb.library_branch_BranchName, COUNT(*) AS total_loans
FROM tbl_book_loans bl
JOIN tbl_library_branch lb ON bl.book_loans_BranchID = lb.library_branch_BranchID
GROUP BY lb.library_branch_BranchName;

-- 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT br.borrower_BorrowerName, br.borrower_BorrowerAddress, COUNT(*) AS books_checked_out
FROM tbl_borrower br
JOIN tbl_book_loans bl ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY br.borrower_CardNo, br.borrower_BorrowerName, br.borrower_BorrowerAddress
HAVING COUNT(*) > 5;

-- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT b.book_Title, bc.book_copies_No_Of_Copies AS total_copies
FROM tbl_book b
JOIN tbl_book_authors ba ON b.book_BookID = ba.book_authors_BookID
JOIN tbl_book_copies bc ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE ba.book_authors_AuthorName = 'Stephen King'
  AND lb.library_branch_BranchName = 'Central';