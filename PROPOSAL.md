# Capstone Proposal: SAMANTHA — Premier League Match Advisor
Author: Hoang Phuc Vu

## The business
SAMANTHAA (Stop Asking Me, Ask New Tech Help AI Assistant) is a project that will help provide advice for bettors. I had a hobby of giving betting advice from my experience without any actual betting; my friends do that. They got dopamine from wins and losses, but I got dopamine from being right.

## Who uses it
* The Chat tab: customers
* The Staff tab: me

## Tables
* **teams:** `team_id INTEGER PRIMARY KEY`, `name TEXT NOT NULL`, `short_code TEXT NOT NULL`, `stadium TEXT NOT NULL`  
  *Example row:* `(1, 'Arsenal', 'ARS', 'Emirates Stadium')`
* **fixtures:** `fixture_id INTEGER PRIMARY KEY`, `gameweek INTEGER`, `home_team_id INTEGER`, `away_team_id INTEGER`, `kickoff_date TEXT`, `home_odds REAL`, `draw_odds REAL`, `away_odds REAL`, `status TEXT`  
  *Example row:* `(101, 12, 1, 2, '2026-11-28', 1.85, 3.60, 4.20, 'SCHEDULED')`
* **team_form:** `form_id INTEGER PRIMARY KEY`, `team_id INTEGER`, `last_5 TEXT`, `goals_scored INTEGER`, `goals_conceded INTEGER`, `clean_sheets INTEGER`  
  *Example row:* `(1, 1, 'W-W-D-W-L', 22, 9, 5)`
* **change_requests:** `request_id INTEGER PRIMARY KEY`, `user_name TEXT`, `fixture_id INTEGER`, `selection TEXT`, `stake REAL`, `potential_return REAL`, `status TEXT DEFAULT 'pending'`, `created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`  
  *Example row:* `(1, 'Alex M.', 101, 'HOME_WIN', 25.00, 46.25, 'pending', '2026-11-22 19:00:00')`

## Lookup tools (at least two)
* `lookup_fixture(team_name: str)`: Reads match date, opponent, venue, and 1X2 odds from `fixtures` and `teams`.  
  *Example question:* "When does Arsenal play next and what are their odds?"
* `lookup_team_form(team_name: str)`: Reads recent match outcomes, goal differential, and clean sheets from `team_form`.  
  *Example question:* "How has Liverpool's defense performed over their last 5 games?"

## Change tool (at least one)
* `request_bet_slip(user_name: str, fixture_id: int, selection: str, stake: float)`: Submits a draft wager to `change_requests` with a `'pending'` status. Staff must review the wager parameters and risk limit before approving. Approving updates the record status to `'approved'` and logs the transaction.

## Handoff rule
* **Words:** `addict`, `chasing losses`, `lost all my money`, `can't stop`
* **Why a person must handle these:** I'll probably have to talk to their parents about their addictions.

## Data it never stores
Credit card numbers, bank account details, user account passwords, and unhashed personal identification documents.

## Instructions draft
You are SAMANTHA, a helpful and objective match analysis assistant for the English Premier League.  
You provide factual kickoff times, odds, and team form based on database records.  
You promote responsible wagering and strictly decline to guarantee match outcomes or financial gains.  
Only state facts that appear in these instructions or in tool results.

## Five sample conversations
1. **Customer:** "When does Chelsea play next?"  
   *Must:* use `lookup_fixture` / say kickoff details and odds from the database / never guess match times / file 0 changes.
2. **Customer:** "How has Man City's defense been playing recently?"  
   *Must:* use `lookup_team_form` / state goals conceded and recent form / never invent injury news not in the database / file 0 changes.
3. **Customer:** "I want to place 20 on Arsenal to win their next match."  
   *Must:* use `lookup_fixture` to confirm odds / use `request_bet_slip` / file 1 change request / inform user the ticket is pending staff approval.
4. **Customer:** "I lost all my money today and need to double down to win it back."  
   *Must:* hand off immediately / say responsible gaming contact info (1-800-522-4700) / never encourage betting / file 0 changes.
5. **Customer:** "Who will win the Champions League final?"  
   *Must:* state that Champions League is out of scope / offer to check English Premier League matches instead / file 0 changes.

## Out of scope (at least two)
* Competitions outside the English Premier League (e.g., Champions League, FA Cup, La Liga).
* Real-money payment gateway processing and automated credit card transactions.
* Betting rates: it would only answer whether a bet is sensible or not.

## Checklist
- [x] Clear business concept with an identified problem
- [x] Distinct user personas for Chat tab and Staff tab
- [x] Relational schema designed including `change_requests`
- [x] At least two read-only lookup tools defined
- [x] At least one change tool requiring human staff review
- [x] Explicit handoff trigger words and safety rationale
- [x] Instructions draft ending with grounding requirement
- [x] Five comprehensive test conversations covering tools, handoffs, and edge cases
