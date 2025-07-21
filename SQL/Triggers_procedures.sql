-- Trigger to mark seat as booked after booking
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

SHOW CREATE TRIGGER MarkSeatBooked;

-- Trigger to mark seat as available after cancellation
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

SHOW CREATE TRIGGER MarkSeatAvailable;

-- Stored Procedure to safely book a seat
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

SHOW CREATE PROCEDURE BookSeat;

-- Stored Procedure to cancel a booking
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

SHOW CREATE PROCEDURE CancelBooking;