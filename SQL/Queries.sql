-- Sample Data
INSERT INTO Flights (FlightNumber, Origin, Destination, DepartureTime, ArrivalTime) 
VALUES ('AI101', 'Delhi', 'Chennai', '2025-07-15 08:00:00', '2025-07-15 10:00:00'),
('AI102', 'Mumbai', 'Bangalore', '2025-07-16 09:00:00', '2025-07-16 11:30:00'),
('AI103', 'Kolkata', 'Hyderabad', '2025-07-17 13:00:00', '2025-07-17 15:45:00'),
('AI204', 'Delhi', 'Mumbai', '2025-08-01 06:00:00', '2025-08-01 08:00:00'),
('AI205', 'Mumbai', 'Chennai', '2025-08-01 10:00:00', '2025-08-01 12:30:00'),
('AI206', 'Bangalore', 'Hyderabad', '2025-08-01 14:00:00', '2025-08-01 15:00:00'),
('AI207', 'Kolkata', 'Delhi', '2025-08-01 16:00:00', '2025-08-01 18:45:00'),
('AI208', 'Chennai', 'Pune', '2025-08-02 07:00:00', '2025-08-02 09:00:00'),
('AI209', 'Hyderabad', 'Kolkata', '2025-08-02 11:00:00', '2025-08-02 13:30:00'),
('AI2010', 'Pune', 'Bangalore', '2025-08-02 15:00:00', '2025-08-02 17:00:00');

SELECT * FROM Flights;

INSERT INTO Customers (Name, Email, Phone) 
VALUES ('Amit Singh', 'amit@gmail.com', '9876543210'),
('Neha Sharma', 'neha@gmail.com', '9988776655'),
('Rahul Roy', 'rahul@gmail.com', '9876512345'),
('Ravi Kumar', 'ravi@example.com', '9123456780'),
('Sneha Das', 'sneha@example.com', '9123456781'),
('Vikram Mehra', 'vikram@example.com', '9123456782'),
('Pooja Rani', 'pooja@example.com', '9123456783'),
('Nikhil Rao', 'nikhil@example.com', '9123456784'),
('Anjali Jain', 'anjali@example.com', '9123456785'),
('Karan Verma', 'karan@example.com', '9123456786');

SELECT * FROM Customers;

-- Seats for Flight 1 (AI201)
INSERT INTO Seats (FlightID, SeatNumber, Class) 
VALUES 
    (1, '1A', 'Economy'),
    (1, '1B', 'Economy');

-- Seats for Flight 2 (AI202)
INSERT INTO Seats (FlightID, SeatNumber, Class) 
VALUES 
    (2, '2A', 'Economy'),
    (2, '2B', 'Economy');

-- Seats for Flight 3 (AI203)
INSERT INTO Seats (FlightID, SeatNumber, Class) 
VALUES 
    (3, '3A', 'Economy'),
    (3, '3B', 'Economy');

-- Seats for Flight 4 (AI204)
INSERT INTO Seats (FlightID, SeatNumber, Class) 
VALUES 
    (4, '4A', 'Economy'),
    (4, '4B', 'Economy');

-- Seats for Flight 5 (AI205)
INSERT INTO Seats (FlightID, SeatNumber, Class) 
VALUES 
    (5, '5A', 'Business'),
    (5, '5B', 'Business');

-- Seats for Flight 6 (AI206)
INSERT INTO Seats (FlightID, SeatNumber, Class) 
VALUES 
    (6, '6A', 'Business'),
    (6, '6B', 'Business');

-- Seats for Flight 7 (AI207)
INSERT INTO Seats (FlightID, SeatNumber, Class) 
VALUES 
    (7, '7A', 'Economy'),
    (7, '7B', 'Economy');

-- Seats for Flight 8 (AI208)
INSERT INTO Seats (FlightID, SeatNumber, Class) 
VALUES 
    (8, '8A', 'Economy'),
    (8, '8B', 'Economy');

-- Seats for Flight 9 (AI209)
INSERT INTO Seats (FlightID, SeatNumber, Class) 
VALUES 
    (9, '9A', 'Economy'),
    (9, '9B', 'Economy');

-- Seats for Flight 10 (AI210)
INSERT INTO Seats (FlightID, SeatNumber, Class) 
VALUES 
    (10, '10A', 'Business'),
    (10, '10B', 'Business');

SELECT * FROM Seats;


-- Book Seat: Ravi Kumar books seat 1A on Flight 1
CALL BookSeat(1, 1, 1);

-- Book Seat: Sneha Das books seat 2B on Flight 2
CALL BookSeat(2, 2, 4);

-- Book Seat: Vikram Mehra books seat 3A on Flight 3
CALL BookSeat(3, 3, 5);

-- Book Seat: Pooja Rani books seat 4B on Flight 4
CALL BookSeat(4, 4, 8);

-- Book Seat: Nikhil Rao books seat 5A on Flight 5
CALL BookSeat(5, 5, 9);

-- Book Seat: Anjali Jain books seat 6B on Flight 6
CALL BookSeat(6, 6, 12);

-- Book Seat: Karan Verma books seat 7A on Flight 7
CALL BookSeat(7, 7, 13);

-- Book Seat: Ayesha Sheikh books seat 8B on Flight 8
CALL BookSeat(8, 8, 16);

-- Book Seat: Mohan Das books seat 9A on Flight 9
CALL BookSeat(9, 9, 17);

-- Book Seat: Priya Nair books seat 10B on Flight 10
CALL BookSeat(10, 10, 20);

