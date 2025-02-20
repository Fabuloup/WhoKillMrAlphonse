DROP TABLE IF EXISTS deaths;
DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS testimonies;
DROP TABLE IF EXISTS places;
DROP TABLE IF EXISTS persons;

CREATE TABLE persons (
    id INTEGER PRIMARY KEY,
    name TEXT,
    age INTEGER);

CREATE TABLE places (
    id INTEGER PRIMARY KEY,
    name TEXT,
    owner_id INTEGER,
    FOREIGN KEY (owner_id) REFERENCES persons(id)
    );

CREATE TABLE deaths (
    id INTEGER PRIMARY KEY,
    person_id INTEGER,
    place_id INTEGER,
    death_time DATETIME,
    cause TEXT,
    FOREIGN KEY (person_id) REFERENCES persons(id),
    FOREIGN KEY (place_id) REFERENCES places(id)
);

CREATE TABLE visits (
    id INTEGER PRIMARY KEY,
    person_id INTEGER,
    place_id INTEGER,
    visit_time DATETIME,
    FOREIGN KEY (person_id) REFERENCES persons(id),
    FOREIGN KEY (place_id) REFERENCES places(id)
);

CREATE TABLE testimonies (
    id INTEGER PRIMARY KEY,
    person_id INTEGER,
    statement TEXT,
    FOREIGN KEY (person_id) REFERENCES persons(id)
);

INSERT INTO persons (name, age) VALUES
    ('Creator', 0),
    ('Alphonse', 42),
    ('Belle', 23),
    ('Bob', 30),
    ('Brigitte', 72),
    ('Moe', 62),
    ('Gordon', 58),
    ('Charlie', 35),
    ('Alice', 28),
    ('John', 34),
    ('Eve', 45),
    ('Frank', 50),
    ('Grace', 29),
    ('Heidi', 31),
    ('Ivan', 40),
    ('Judy', 36),
    ('Mallory', 38),
    ('Oscar', 27),
    ('Peggy', 33),
    ('Sybil', 41),
    ('Trent', 39),
    ('Victor', 32),
    ('Walter', 37),
    ('Xavier', 44),
    ('Yvonne', 26),
    ('Zara', 25),
    ('Quinn', 35),
    ('Rita', 30);

INSERT INTO places (name, owner_id) VALUES
    ('Bakery', (SELECT id FROM persons WHERE name = 'Yvonne')),
    ('Butcher', (SELECT id FROM persons WHERE name = 'Ivan')),
    ('Bar', (SELECT id FROM persons WHERE name = 'Moe')),
    ('HairLey Davidson', (SELECT id FROM persons WHERE name = 'Oscar')),
    ('Fresh Prince of Belle Hair', (SELECT id FROM persons WHERE name = 'Belle')),
    ('La fine bouche', (SELECT id FROM persons WHERE name = 'Gordon')),
    ('Church', (SELECT id FROM persons WHERE name = 'Creator')),
    ('Temple', (SELECT id FROM persons WHERE name = 'Creator')),
    ('Mosque', (SELECT id FROM persons WHERE name = 'Creator')),
    ('Supermarket', (SELECT id FROM persons WHERE name = 'Creator')),
    ('Library', (SELECT id FROM persons WHERE name = 'Alice')),
    ('Police Station', (SELECT id FROM persons WHERE name = 'Creator')),
    ('Fire Station', (SELECT id FROM persons WHERE name = 'Creator')),
    ('Hospital', (SELECT id FROM persons WHERE name = 'Creator')),
    ('School', (SELECT id FROM persons WHERE name = 'Creator')),
    ('Park', (SELECT id FROM persons WHERE name = 'Creator')),
    ('Museum', (SELECT id FROM persons WHERE name = 'Creator')),
    ('Cinema', (SELECT id FROM persons WHERE name = 'Creator')),
    ('Gym', (SELECT id FROM persons WHERE name = 'Victor')),
    ('Candlestick maker', (SELECT id FROM persons WHERE name = 'Judy'));

-- House of each person
INSERT INTO places (name, owner_id)
SELECT 'House of ' || name, persons.id
FROM persons
WHERE name != 'Creator';

-- People at home
INSERT INTO visits (person_id, place_id, visit_time) VALUES 
    ((SELECT id FROM persons WHERE name = 'Xavier'), (SELECT id FROM places WHERE name = 'Bakery'), '1998-09-04 18:30:00'),
    ((SELECT id FROM persons WHERE name = 'Zara'), (SELECT id FROM places WHERE name = 'Butcher'), '1998-09-04 16:00:00');

-- Shops open from 9:00 to 19:00
INSERT INTO visits (person_id, place_id, visit_time) VALUES 
    ((SELECT id FROM persons WHERE name = 'Yvonne'), (SELECT id FROM places WHERE name = 'Bakery'), '1998-09-04 09:30:00'),
    ((SELECT id FROM persons WHERE name = 'Ivan'), (SELECT id FROM places WHERE name = 'Butcher'), '1998-09-04 10:00:00'),
    ((SELECT id FROM persons WHERE name = 'Belle'), (SELECT id FROM places WHERE name = 'Fresh Prince of Belle Hair'), '1998-09-04 10:30:00'),
    ((SELECT id FROM persons WHERE name = 'Oscar'), (SELECT id FROM places WHERE name = 'HairLey Davidson'), '1998-09-04 10:00:00'),
    ((SELECT id FROM persons WHERE name = 'Alice'), (SELECT id FROM places WHERE name = 'Library'), '1998-09-04 09:00:00'),
    ((SELECT id FROM persons WHERE name = 'Victor'), (SELECT id FROM places WHERE name = 'Gym'), '1998-09-04 07:00:00'),
    ((SELECT id FROM persons WHERE name = 'Judy'), (SELECT id FROM places WHERE name = 'Candlestick maker'), '1998-09-04 10:30:00');

-- La Fine Bouche lunch hours (11:00-16:00)
INSERT INTO visits (person_id, place_id, visit_time) VALUES
    ((SELECT id FROM persons WHERE name = 'Gordon'), (SELECT id FROM places WHERE name = 'La fine bouche'), '1998-09-04 09:00:00'),
    ((SELECT id FROM persons WHERE name = 'Frank'), (SELECT id FROM places WHERE name = 'La fine bouche'), '1998-09-04 12:30:00'),
    ((SELECT id FROM persons WHERE name = 'Eve'), (SELECT id FROM places WHERE name = 'La fine bouche'), '1998-09-04 13:00:00');

-- Shops closing but restaurants and bars still open
INSERT INTO visits (person_id, place_id, visit_time) VALUES
    ((SELECT id FROM persons WHERE name = 'Mallory'), (SELECT id FROM places WHERE name = 'Supermarket'), '1998-09-04 18:30:00');

-- La Fine Bouche dinner hours (18:00-22:00)
INSERT INTO visits (person_id, place_id, visit_time) VALUES
    ((SELECT id FROM persons WHERE name = 'Gordon'), (SELECT id FROM places WHERE name = 'La fine bouche'), '1998-09-04 17:00:00'),
    ((SELECT id FROM persons WHERE name = 'John'), (SELECT id FROM places WHERE name = 'La fine bouche'), '1998-09-04 19:00:00'),
    ((SELECT id FROM persons WHERE name = 'Victor'), (SELECT id FROM places WHERE name = 'La fine bouche'), '1998-09-04 20:00:00'),
    ((SELECT id FROM persons WHERE name = 'Peggy'), (SELECT id FROM places WHERE name = 'La fine bouche'), '1998-09-04 19:45:00'),
    ((SELECT id FROM persons WHERE name = 'Heidi'), (SELECT id FROM places WHERE name = 'La fine bouche'), '1998-09-04 20:00:00');

-- Bar open from 14:00 to 00:00
INSERT INTO visits (person_id, place_id, visit_time) VALUES
    ((SELECT id FROM persons WHERE name = 'Moe'), (SELECT id FROM places WHERE name = 'Bar'), '1998-09-04 13:55:00'), -- Moe prepare the opening
    ((SELECT id FROM persons WHERE name = 'Bob'), (SELECT id FROM places WHERE name = 'Bar'), '1998-09-04 21:30:00'),
    ((SELECT id FROM persons WHERE name = 'Walter'), (SELECT id FROM places WHERE name = 'Bar'), '1998-09-04 16:00:00'),
    ((SELECT id FROM persons WHERE name = 'Judy'), (SELECT id FROM places WHERE name = 'Bar'), '1998-09-04 18:00:00'),
    ((SELECT id FROM persons WHERE name = 'Trent'), (SELECT id FROM places WHERE name = 'Bar'), '1998-09-04 20:00:00'),
    ((SELECT id FROM persons WHERE name = 'Victor'), (SELECT id FROM places WHERE name = 'Bar'), '1998-09-04 21:00:00'),
    ((SELECT id FROM persons WHERE name = 'Rita'), (SELECT id FROM places WHERE name = 'Bar'), '1998-09-04 20:00:00'),
    ((SELECT id FROM persons WHERE name = 'Sybil'), (SELECT id FROM places WHERE name = 'Bar'), '1998-09-04 22:00:00');

-- Murder related visits

-- Alphonse drinking at Moe's Bar before dinner
INSERT INTO visits (person_id, place_id, visit_time) VALUES 
    ((SELECT id FROM persons WHERE name = 'Alphonse'), (SELECT id FROM places WHERE name = 'Bar'), '1998-09-04 17:30:00');

-- Belle arriving at La Fine Bouche (she had dinner with Alphonse)
INSERT INTO visits (person_id, place_id, visit_time) VALUES 
    ((SELECT id FROM persons WHERE name = 'Belle'), (SELECT id FROM places WHERE name = 'La fine bouche'), '1998-09-04 19:45:00');

-- Alphonse arriving at La Fine Bouche for dinner
INSERT INTO visits (person_id, place_id, visit_time) VALUES 
    ((SELECT id FROM persons WHERE name = 'Alphonse'), (SELECT id FROM places WHERE name = 'La fine bouche'), '1998-09-04 20:15:00');

INSERT INTO deaths (person_id, place_id, death_time, cause) VALUES 
    ((SELECT id FROM persons WHERE name = 'Alphonse'), 
     (SELECT id FROM places WHERE name = 'La fine bouche'), 
     '1998-09-04 21:15:00', 
     'Cyanide poisoning');

INSERT INTO testimonies (person_id, statement) VALUES 
    ((SELECT id FROM persons WHERE name = 'Gordon'), 
     'I saw Belle arguing with Alphonse just before dinner.'),

    ((SELECT id FROM persons WHERE name = 'John'), 
    'Alphonse told me that he was at the bar before the dinner and and it pissed Belle off because he was late.'),

    ((SELECT id FROM persons WHERE name = 'Belle'), 
     'Yes, I argued with Alphonse, but I love him ! I wish he was still there.'),

    ((SELECT id FROM persons WHERE name = 'Bob'), 
     'I saw Moe give Alphonse a drink that night, and he looked nervous.'),

    ((SELECT id FROM persons WHERE name = 'Brigitte'), 
     'I was walking past La Fine Bouche around 9 PM and saw someone in a dark coat sneaking into the kitchen.'),

    ((SELECT id FROM persons WHERE name = 'Moe'), 
     'Alphonse was drinking whiskey at my bar earlier, but he seemed completely fine when he left!'),

    ((SELECT id FROM persons WHERE name = 'Gordon'), 
     'Alphonse didn’t order his usual dish that night. He chose something different. Weird, right?'),

    ((SELECT id FROM persons WHERE name = 'Charlie'), 
     'Belle left the restaurant for a few minutes during dinner. She seemed upset.'),

    ((SELECT id FROM persons WHERE name = 'Alice'), 
     'I saw Victor leaving the restaurant around the time of Alphonse’s death.'),

    ((SELECT id FROM persons WHERE name = 'Eve'), 
     'Alphonse had some debt problems, I heard. Maybe someone wanted revenge?'),

    ((SELECT id FROM persons WHERE name = 'Frank'), 
     'Moe and Alphonse had a heated conversation at the bar before he left. Moe seemed really angry!'),

    ((SELECT id FROM persons WHERE name = 'Grace'), 
     'Brigitte said she saw someone sneaking into the kitchen, but I didn’t see anything when I was outside.'),

    ((SELECT id FROM persons WHERE name = 'Heidi'), 
     'I saw Peggy hiding something in her purse at the restaurant.'),

    ((SELECT id FROM persons WHERE name = 'Ivan'), 
     'I was in the back alley of the restaurant for a smoke, and I swear I heard two people whispering.'),

    ((SELECT id FROM persons WHERE name = 'Judy'), 
     'Walter was acting very strange that evening. He kept looking around nervously.'),

    ((SELECT id FROM persons WHERE name = 'Mallory'), 
     'I heard Alphonse mention something about an “old mistake” coming back to haunt him.'),

    ((SELECT id FROM persons WHERE name = 'Oscar'), 
     'Moe left the bar for 15 minutes during the afternoon. He never does that.'),

    ((SELECT id FROM persons WHERE name = 'Peggy'), 
     'I was in the bathroom at the restaurant when I overheard someone muttering, “It’s too late now.”'),

    ((SELECT id FROM persons WHERE name = 'Sybil'), 
     'I saw someone drop a small vial outside the Bar that night, but I couldn’t see their face.'),

    ((SELECT id FROM persons WHERE name = 'Trent'), 
     'Victor and Bob were whispering in a corner of the bar earlier that evening. Looked suspicious.'),

    ((SELECT id FROM persons WHERE name = 'Victor'), 
     'I left the restaurant before anything happened. I had nothing to do with it!'),

    ((SELECT id FROM persons WHERE name = 'Walter'), 
     'Alphonse asked me for some money a few days ago. Maybe he got into trouble?'),

    ((SELECT id FROM persons WHERE name = 'Xavier'), 
     'I was at home all evening. I didn’t see anything.'),

    ((SELECT id FROM persons WHERE name = 'Yvonne'), 
     'I saw a man in a leather jacket watching the restaurant from across the street. He wasn’t from around here.'),

    ((SELECT id FROM persons WHERE name = 'Zara'), 
     'I finished my work sonner and was at home all evening. I didn’t see anything.'),

    ((SELECT id FROM persons WHERE name = 'Quinn'), 
     'I found an empty pill bottle near the bar entrance that night, but I didn’t think much of it.'),

    ((SELECT id FROM persons WHERE name = 'Rita'), 
     'Moe’s bar ran out of whiskey that night.')