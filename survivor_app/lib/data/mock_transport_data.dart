import '../models/route.dart';

// DEMO DATA ONLY.
// Routes, departure times and fares below are illustrative placeholders.
// They are NOT official IETT or Sabanci University timetable/fare information.
const List<TransportRoute> mockTransportRoutes = [
  // CAMPUS SHUTTLE — Sabanci University <-> Kadikoy
  TransportRoute(id: 'cs-wd-out', name: 'Campus Shuttle', origin: 'Sabanci University', destination: 'Kadikoy', dayType: 'Weekday', departureTimes: ['07:30', '08:30', '09:30', '12:00', '16:30', '19:00'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'cs-wd-back', name: 'Campus Shuttle', origin: 'Kadikoy', destination: 'Sabanci University', dayType: 'Weekday', departureTimes: ['08:30', '10:00', '13:00', '17:30', '20:00'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'cs-we-out', name: 'Campus Shuttle', origin: 'Sabanci University', destination: 'Kadikoy', dayType: 'Weekend', departureTimes: ['10:00', '13:00', '16:00', '19:00'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'cs-we-back', name: 'Campus Shuttle', origin: 'Kadikoy', destination: 'Sabanci University', dayType: 'Weekend', departureTimes: ['11:00', '14:00', '17:00', '20:00'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),

  // KURTKOY SHUTTLE — Sabanci University <-> Kurtkoy
  TransportRoute(id: 'ks-wd-out', name: 'Kurtkoy Shuttle', origin: 'Sabanci University', destination: 'Kurtkoy', dayType: 'Weekday', departureTimes: ['07:45', '09:15', '11:15', '14:30', '17:00', '20:00'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'ks-wd-back', name: 'Kurtkoy Shuttle', origin: 'Kurtkoy', destination: 'Sabanci University', dayType: 'Weekday', departureTimes: ['08:15', '10:00', '12:00', '15:15', '18:00', '21:00'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'ks-we-out', name: 'Kurtkoy Shuttle', origin: 'Sabanci University', destination: 'Kurtkoy', dayType: 'Weekend', departureTimes: ['09:00', '12:00', '15:00', '18:00'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'ks-we-back', name: 'Kurtkoy Shuttle', origin: 'Kurtkoy', destination: 'Sabanci University', dayType: 'Weekend', departureTimes: ['09:45', '12:45', '15:45', '18:45'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),

  // PENDIK CONNECTION SHUTTLE — Sabanci University <-> Pendik
  TransportRoute(id: 'ps-wd-out', name: 'Pendik Connection', origin: 'Sabanci University', destination: 'Pendik', dayType: 'Weekday', departureTimes: ['08:00', '10:30', '13:30', '16:00', '18:30'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'ps-wd-back', name: 'Pendik Connection', origin: 'Pendik', destination: 'Sabanci University', dayType: 'Weekday', departureTimes: ['08:45', '11:15', '14:15', '16:45', '19:15'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'ps-we-out', name: 'Pendik Connection', origin: 'Sabanci University', destination: 'Pendik', dayType: 'Weekend', departureTimes: ['10:00', '13:00', '16:00', '19:00'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'ps-we-back', name: 'Pendik Connection', origin: 'Pendik', destination: 'Sabanci University', dayType: 'Weekend', departureTimes: ['10:45', '13:45', '16:45', '19:45'], transportType: 'Shuttle', studentFare: 45.0, fullFare: 60.0),

  // KM18 — Sabanci University <-> Kartal
  TransportRoute(id: 'km-wd-out', name: 'KM18', origin: 'Sabanci University', destination: 'Kartal', dayType: 'Weekday', departureTimes: ['06:45', '07:45', '08:45', '09:45', '11:45', '14:15', '16:15', '18:15', '20:15'], transportType: 'Bus', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'km-wd-back', name: 'KM18', origin: 'Kartal', destination: 'Sabanci University', dayType: 'Weekday', departureTimes: ['07:15', '08:15', '09:15', '10:15', '12:15', '14:45', '17:00', '19:00', '21:00'], transportType: 'Bus', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'km-we-out', name: 'KM18', origin: 'Sabanci University', destination: 'Kartal', dayType: 'Weekend', departureTimes: ['08:00', '10:00', '12:00', '15:00', '18:00'], transportType: 'Bus', studentFare: 45.0, fullFare: 60.0),
  TransportRoute(id: 'km-we-back', name: 'KM18', origin: 'Kartal', destination: 'Sabanci University', dayType: 'Weekend', departureTimes: ['08:30', '10:30', '12:30', '15:30', '18:30'], transportType: 'Bus', studentFare: 45.0, fullFare: 60.0),
];
