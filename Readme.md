# ✈️ Flight Booking Management System

## 📌 Project Overview
This SQL-based Flight Booking Management System allows customers to book and cancel flight seats with real-time seat availability management. It ensures data integrity through foreign key constraints, triggers, and stored procedures.

## 🛠️ Technologies Used
- **Database:** SQL
- **Tool:** MySQL Workbench

## 📁 Database Structure

### 1. Flights Table
Stores flight details such as origin, destination, and timings.

### 2. Customers Table
Holds customer information such as name, email, and phone.

### 3. Seats Table
Contains individual seat records per flight along with booking status.

### 4. Bookings Table
Captures booking transactions and links customers, flights, and seats.

## ⚙️ Core Features

- ✅ Seat booking with availability check
- ✅ Seat cancellation with status update
- ✅ Triggers to automatically mark seats as booked or available
- ✅ Normalize Scheme and Define Constraints
- ✅ Select available seats and flight search
- ✅ Triggers for booking updates and cancellations
- ✅ Comprehensive Summary
- ✅ Comprehensive report of all bookings

## 🔐 Database Constraints

- `FOREIGN KEY` relationships between Flights, Customers, Seats, and Bookings
- `UNIQUE` constraints on seat numbers per flight
- `ON DELETE CASCADE` to maintain data consistency

## ⚡ Triggers

- `MarkSeatBooked` – Marks seat as booked after successful booking
- `MarkSeatAvailable` – Frees up seat on booking cancellation

## 🧠 Stored Procedures

- `BookSeat(customerID, flightID, seatID)` – Books a seat only if it is available
- `CancelBooking(bookingID)` – Cancels a booking only if it’s not already cancelled

## 📊 Booking Summary Report (Query)
```bash
SELECT 
    b.BookingID, 
    c.Name AS CustomerName, 
    f.FlightNumber, 
    s.SeatNumber, 
    b.BookingDate,   
    b.Status         
FROM Bookings b   
JOIN Customers c ON b.CustomerID = c.CustomerID  
JOIN Flights f ON b.FlightID = f.FlightID        
JOIN Seats s ON b.SeatID = s.SeatID;
```

## 🧪 Sample Data Included

- 10 Flights
- 10 Customers
- 20 Seats
- 10 Bookings

## 📤 How to Use

1. Run the SQL file (`Project.sql`) in MySQL Workbench.
2. Execute triggers and stored procedures.
3. Use `CALL BookSeat(...)` and `CALL CancelBooking(...)` as needed.
4. Run the booking report query to see current booking data.

# 📦 Deliverables 
## 1.  📐 Schema Design
### Flight Table
```bash
DROP DATABASE IF EXISTS Flight_Booking;
CREATE DATABASE Flight_Booking;
USE Flight_Booking;

-- Flights Table
CREATE TABLE Flights (
    FlightID INT AUTO_INCREMENT PRIMARY KEY,
    FlightNumber VARCHAR(10) NOT NULL UNIQUE,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL
);
SELECT * FROM Flights;
```
### Customers Table
```bash
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL
);
SELECT * FROM Customers;
```
### Seats Table
```bash
CREATE TABLE Seats (
    SeatID INT AUTO_INCREMENT PRIMARY KEY,
    FlightID INT NOT NULL,
    SeatNumber VARCHAR(10) NOT NULL,
    Class VARCHAR(10) NOT NULL,
    IsBooked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID) ON DELETE CASCADE,
    UNIQUE (FlightID, SeatNumber)
);
SELECT * FROM Seats;
```
### Bookings Table
```bash
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    FlightID INT NOT NULL,
    SeatID INT NOT NULL,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'Booked',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID) ON DELETE CASCADE,
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID) ON DELETE CASCADE,
    UNIQUE (SeatID)
);
SELECT * FROM Bookings;
```

![20250720_214015](https://github.com/user-attachments/assets/d7003647-29a7-479e-a5d9-e735a71abfad)

## 2.🔁 Triggers
### Trigger – MarkSeatBooked
```bash
DELIMITER //
CREATE TRIGGER MarkSeatBooked 
AFTER INSERT ON Bookings 
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Booked' THEN
        UPDATE Seats 
        SET IsBooked = TRUE 
        WHERE SeatID = NEW.SeatID;
    END IF;
END;
//
DELIMITER ;
```
```bash
SHOW CREATE TRIGGER MarkSeatBooked;
```

### Trigger – MarkSeatAvailable
```bash
DELIMITER //
CREATE TRIGGER MarkSeatAvailable 
AFTER UPDATE ON Bookings 
FOR EACH ROW
BEGIN
    IF OLD.Status != 'Cancelled' AND NEW.Status = 'Cancelled' THEN
        UPDATE Seats 
        SET IsBooked = FALSE 
        WHERE SeatID = NEW.SeatID;
    END IF;
END;
//
DELIMITER ;
```
```bash
SHOW CREATE TRIGGER MarkSeatAvailable;
```
### Procedure – BookSeat
```bash
DELIMITER //
CREATE PROCEDURE BookSeat(
    IN inCustomerID INT,
    IN inFlightID INT,
    IN inSeatID INT
)
BEGIN
    DECLARE seatBooked BOOLEAN;

    -- Check if seat is already booked
    SELECT IsBooked INTO seatBooked 
    FROM Seats 
    WHERE SeatID = inSeatID AND FlightID = inFlightID;

    IF seatBooked = FALSE THEN
        -- Insert booking only if seat is free
        INSERT INTO Bookings (CustomerID, FlightID, SeatID)
        VALUES (inCustomerID, inFlightID, inSeatID);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This seat is already booked.';
    END IF;
END;
//
DELIMITER ;
```
```bash
SHOW CREATE PROCEDURE BookSeat;
```
### Procedure – CancelBooking
```bash
DELIMITER //
CREATE PROCEDURE CancelBooking(
    IN inBookingID INT
)
BEGIN
    DECLARE currentStatus VARCHAR(20);

    -- Get current status of booking
    SELECT Status INTO currentStatus
    FROM Bookings
    WHERE BookingID = inBookingID;

    -- Cancel only if it's not already cancelled
    IF currentStatus != 'Cancelled' THEN
        UPDATE Bookings
        SET Status = 'Cancelled'
        WHERE BookingID = inBookingID;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Booking is already cancelled.';
    END IF;
END;
//
DELIMITER ;
```
```bash
SHOW CREATE PROCEDURE CancelBooking;
```
![tiggers pic](https://github.com/user-attachments/assets/be6faa34-3b49-4267-a4bd-82d62c31606c)

## 3.🧾Queries
```bash
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
```
```bash
SELECT * FROM Flights;
```
<img width="859" height="709" alt="Screenshot 2025-07-20 212008" src="https://github.com/user-attachments/assets/f59ac6bb-58ae-4c6b-a162-08c68e525435" />

```bash
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
```
```bash
SELECT * FROM Customers;
```
<img width="693" height="661" alt="Screenshot 2025-07-20 212047" src="https://github.com/user-attachments/assets/85eac5ac-0537-49b7-8f5e-8d4e1d0264af" />

```bash
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
```
```bash
SELECT * FROM Seats;
```
<img width="694" height="741" alt="Screenshot 2025-07-20 212140" src="https://github.com/user-attachments/assets/fb590cfa-d320-48dc-9c6c-b21c5dfeb885" />

```bash
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

```

## 4. 📊  Flight Availability views
```bash
SELECT 
    b.BookingID, 
    c.Name AS CustomerName, 
    f.FlightNumber, 
    s.SeatNumber, 
    b.BookingDate,   
    b.Status         
FROM Bookings b   
JOIN Customers c ON b.CustomerID = c.CustomerID  
JOIN Flights f ON b.FlightID = f.FlightID        
JOIN Seats s ON b.SeatID = s.SeatID;       
```
<img width="691" height="721" alt="Screenshot 2025-07-20 212337" src="https://github.com/user-attachments/assets/e69736ff-9fb8-4f4f-8ecc-f6d563153edd" />

