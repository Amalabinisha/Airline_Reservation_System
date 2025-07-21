-- Report Query (View Bookings Report)
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
