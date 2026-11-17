import '../models/route.dart';

// DEMO DATA ONLY: these times, destinations and fares are not verified timetables.
const List<TransportRoute> mockTransportRoutes = [
  TransportRoute(id: 'sh-wd-out', name: 'Campus Shuttle', origin: 'Sabanci University', destination: 'Kadikoy', dayType: 'Weekday', departureTimes: ['08:00', '09:30', '12:00', '16:30', '19:00'], transportType: 'Shuttle'),
  TransportRoute(id: 'sh-wd-back', name: 'Campus Shuttle', origin: 'Kadikoy', destination: 'Sabanci University', dayType: 'Weekday', departureTimes: ['07:30', '10:00', '13:00', '17:30', '21:00'], transportType: 'Shuttle'),
  TransportRoute(id: 'sh-we-out', name: 'Campus Shuttle', origin: 'Sabanci University', destination: 'Kadikoy', dayType: 'Weekend', departureTimes: ['10:00', '14:00', '18:00'], transportType: 'Shuttle'),
  TransportRoute(id: 'sh-we-back', name: 'Campus Shuttle', origin: 'Kadikoy', destination: 'Sabanci University', dayType: 'Weekend', departureTimes: ['11:00', '15:00', '20:00'], transportType: 'Shuttle'),
  TransportRoute(id: 'km-wd-out', name: 'KM18', origin: 'Sabanci University', destination: 'Kartal', dayType: 'Weekday', departureTimes: ['07:45', '09:15', '11:45', '16:15', '20:15'], transportType: 'Bus'),
  TransportRoute(id: 'km-wd-back', name: 'KM18', origin: 'Kartal', destination: 'Sabanci University', dayType: 'Weekday', departureTimes: ['07:00', '10:00', '13:00', '17:00', '21:00'], transportType: 'Bus'),
  TransportRoute(id: 'km-we-out', name: 'KM18', origin: 'Sabanci University', destination: 'Kartal', dayType: 'Weekend', departureTimes: ['09:00', '12:00', '17:00'], transportType: 'Bus'),
  TransportRoute(id: 'km-we-back', name: 'KM18', origin: 'Kartal', destination: 'Sabanci University', dayType: 'Weekend', departureTimes: ['10:00', '14:00', '19:00'], transportType: 'Bus'),
];
