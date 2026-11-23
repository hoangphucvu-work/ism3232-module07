-- schema.sql
-- Database Schema & Starter Seed Data for SAMANTHA (Premier League Match Advisor)
-- Run with: sqlite3 football_advisor.db < schema.sql

PRAGMA foreign_keys = ON;

-- -----------------------------------------------------------------------------
-- 1. Clean Up Existing Tables (Drop in reverse dependency order)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS change_requests;
DROP TABLE IF EXISTS team_form;
DROP TABLE IF EXISTS fixtures;
DROP TABLE IF EXISTS teams;

-- -----------------------------------------------------------------------------
-- 2. Table Definitions
-- -----------------------------------------------------------------------------

-- Teams participating in the league
CREATE TABLE teams (
    team_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    short_code TEXT NOT NULL UNIQUE,
    stadium TEXT NOT NULL
);

-- Scheduled and completed matches with betting odds
CREATE TABLE fixtures (
    fixture_id INTEGER PRIMARY KEY AUTOINCREMENT,
    gameweek INTEGER NOT NULL,
    home_team_id INTEGER NOT NULL,
    away_team_id INTEGER NOT NULL,
    kickoff_date TEXT NOT NULL,          -- Format: 'YYYY-MM-DD HH:MM'
    home_odds REAL NOT NULL CHECK(home_odds >= 1.0),
    draw_odds REAL NOT NULL CHECK(draw_odds >= 1.0),
    away_odds REAL NOT NULL CHECK(away_odds >= 1.0),
    status TEXT NOT NULL DEFAULT 'SCHEDULED' CHECK(status IN ('SCHEDULED', 'IN_PLAY', 'FINISHED', 'POSTPONED')),
    FOREIGN KEY (home_team_id) REFERENCES teams (team_id),
    FOREIGN KEY (away_team_id) REFERENCES teams (team_id)
);

-- Team form metrics and defensive/offensive stats
CREATE TABLE team_form (
    form_id INTEGER PRIMARY KEY AUTOINCREMENT,
    team_id INTEGER NOT NULL UNIQUE,
    last_5 TEXT NOT NULL,                -- e.g., 'W-W-D-W-L'
    goals_scored INTEGER NOT NULL DEFAULT 0 CHECK(goals_scored >= 0),
    goals_conceded INTEGER NOT NULL DEFAULT 0 CHECK(goals_conceded >= 0),
    clean_sheets INTEGER NOT NULL DEFAULT 0 CHECK(clean_sheets >= 0),
    FOREIGN KEY (team_id) REFERENCES teams (team_id)
);

-- The Single Checked Door: Wagers staged by SAMANTHA awaiting staff approval
CREATE TABLE change_requests (
    request_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_name TEXT NOT NULL,
    fixture_id INTEGER NOT NULL,
    selection TEXT NOT NULL CHECK(selection IN ('HOME_WIN', 'DRAW', 'AWAY_WIN')),
    stake REAL NOT NULL CHECK(stake > 0),
    potential_return REAL NOT NULL CHECK(potential_return > 0),
    status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending', 'approved', 'rejected')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fixture_id) REFERENCES fixtures (fixture_id)
);

-- -----------------------------------------------------------------------------
-- 3. Starter Seed Data
-- -----------------------------------------------------------------------------

-- Insert Teams
INSERT INTO teams (team_id, name, short_code, stadium) VALUES
    (1, 'Arsenal', 'ARS', 'Emirates Stadium'),
    (2, 'Chelsea', 'CHE', 'Stamford Bridge'),
    (3, 'Liverpool', 'LIV', 'Anfield'),
    (4, 'Manchester City', 'MCI', 'Etihad Stadium'),
    (5, 'Tottenham Hotspur', 'TOT', 'Tottenham Hotspur Stadium');

-- Insert Team Form
INSERT INTO team_form (team_id, last_5, goals_scored, goals_conceded, clean_sheets) VALUES
    (1, 'W-W-D-W-L', 24, 9, 5),   -- Arsenal
    (2, 'W-D-W-L-D', 18, 14, 3),  -- Chelsea
    (3, 'W-W-W-W-D', 27, 8, 6),   -- Liverpool
    (4, 'L-L-W-W-L', 22, 16, 2),  -- Manchester City
    (5, 'L-W-L-W-D', 19, 15, 3);  -- Tottenham

-- Insert Upcoming Fixtures
INSERT INTO fixtures (fixture_id, gameweek, home_team_id, away_team_id, kickoff_date, home_odds, draw_odds, away_odds, status) VALUES
    (101, 13, 1, 2, '2026-11-28 17:30', 1.85, 3.60, 4.20, 'SCHEDULED'), -- Arsenal vs Chelsea
    (102, 13, 3, 4, '2026-11-29 16:30', 2.10, 3.50, 3.30, 'SCHEDULED'), -- Liverpool vs Man City
    (103, 13, 5, 1, '2026-12-05 12:30', 3.40, 3.50, 2.05, 'SCHEDULED'); -- Tottenham vs Arsenal

-- Insert Initial Seed Change Request (for testing Week 15 Staff review tab)
INSERT INTO change_requests (request_id, user_name, fixture_id, selection, stake, potential_return, status) VALUES
    (1, 'Alex Miller', 101, 'HOME_WIN', 25.00, 46.25, 'pending');
