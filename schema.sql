PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE COLLATE NOCASE,
  role TEXT NOT NULL CHECK (role IN ('SUPER_ADMIN','ADMIN','DRIVER','TEAM_MEMBER')),
  department TEXT,
  driving_licence_number TEXT,
  licence_expiry TEXT,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS vehicles (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  registration_number TEXT NOT NULL UNIQUE COLLATE NOCASE,
  make_model TEXT,
  operational_status TEXT NOT NULL DEFAULT 'AVAILABLE',
  current_odometer REAL NOT NULL DEFAULT 0,
  last_known_location TEXT,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS bookings (
  id TEXT PRIMARY KEY,
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
  driver_user_id TEXT NOT NULL REFERENCES users(id),
  planned_start TEXT NOT NULL,
  expected_return TEXT NOT NULL,
  destination TEXT NOT NULL,
  trip_purpose TEXT,
  status TEXT NOT NULL DEFAULT 'PENDING_APPROVAL',
  booked_by TEXT NOT NULL REFERENCES users(id),
  approval_reason TEXT,
  cancellation_reason TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  CHECK (planned_start < expected_return)
);

CREATE TABLE IF NOT EXISTS trips (
  id TEXT PRIMARY KEY,
  booking_id TEXT NOT NULL UNIQUE REFERENCES bookings(id),
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
  driver_user_id TEXT NOT NULL REFERENCES users(id),
  checkout_at TEXT NOT NULL,
  starting_odometer REAL NOT NULL,
  return_at TEXT,
  ending_odometer REAL,
  total_distance REAL,
  destination TEXT,
  status TEXT NOT NULL DEFAULT 'ACTIVE',
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  CHECK (ending_odometer IS NULL OR ending_odometer >= starting_odometer)
);

CREATE TABLE IF NOT EXISTS inspections (
  id TEXT PRIMARY KEY,
  trip_id TEXT NOT NULL REFERENCES trips(id),
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
  status TEXT NOT NULL DEFAULT 'PENDING',
  notes TEXT,
  inspected_by TEXT REFERENCES users(id),
  inspected_at TEXT,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS damages (
  id TEXT PRIMARY KEY,
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
  trip_id TEXT REFERENCES trips(id),
  description TEXT NOT NULL,
  severity TEXT,
  resolution_status TEXT NOT NULL DEFAULT 'REPORTED',
  created_by TEXT NOT NULL REFERENCES users(id),
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS maintenance (
  id TEXT PRIMARY KEY,
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
  maintenance_type TEXT,
  status TEXT NOT NULL DEFAULT 'PLANNED',
  blocking INTEGER NOT NULL DEFAULT 1,
  expected_completion_date TEXT,
  notes TEXT,
  created_by TEXT NOT NULL REFERENCES users(id),
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS insurance_claims (
  id TEXT PRIMARY KEY,
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
  claim_status TEXT NOT NULL DEFAULT 'DRAFT',
  description TEXT,
  created_by TEXT NOT NULL REFERENCES users(id),
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS washing_log (
  id TEXT PRIMARY KEY,
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
  wash_date TEXT NOT NULL,
  wash_type TEXT NOT NULL DEFAULT 'ROUTINE',
  washed_by TEXT,
  odometer REAL,
  location TEXT,
  notes TEXT,
  created_by TEXT NOT NULL REFERENCES users(id),
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS audit_log (
  id TEXT PRIMARY KEY,
  actor_user_id TEXT REFERENCES users(id),
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT,
  previous_json TEXT,
  next_json TEXT,
  reason TEXT,
  created_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_bookings_vehicle_dates ON bookings(vehicle_id, planned_start, expected_return);
CREATE INDEX IF NOT EXISTS idx_trips_active_vehicle ON trips(vehicle_id, status);
CREATE INDEX IF NOT EXISTS idx_washing_vehicle_date ON washing_log(vehicle_id, wash_date DESC);
CREATE INDEX IF NOT EXISTS idx_audit_entity ON audit_log(entity_type, entity_id, created_at DESC);
