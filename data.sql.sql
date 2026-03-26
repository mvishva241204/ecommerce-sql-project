INSERT INTO Customers VALUES
(1,'Arun','2023-01-01'),
(2,'Priya','2023-02-10'),
(3,'Rahul','2023-03-15'),
(4,'Sneha','2023-04-01');

INSERT INTO Products VALUES
(101,'Laptop','Electronics',50000),
(102,'Phone','Electronics',20000),
(103,'Shoes','Fashion',3000),
(104,'Watch','Fashion',5000);

INSERT INTO Orders VALUES
(1,1,'2023-06-01'),
(2,1,'2023-07-01'),
(3,2,'2023-07-10'),
(4,3,'2023-08-05');

INSERT INTO Order_Items VALUES
(1,1,101,1,50000),
(2,1,103,2,3000),
(3,2,102,1,20000),
(4,3,104,1,5000),
(5,4,103,1,3000);