-- Ammunation Job SQL Setup
-- Run this SQL file to set up the ammunation job in your database

-- Add the ammunation job
INSERT INTO `jobs` (name, label) VALUES
('ammu', 'Ammunation')
ON DUPLICATE KEY UPDATE label = 'Ammunation';

-- Add job grades
INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
('ammu', 0, 'trainee', 'Trainee', 200, '{}', '{}'),
('ammu', 1, 'employee', 'Employee', 400, '{}', '{}'),
('ammu', 2, 'experienced', 'Experienced', 600, '{}', '{}'),
('ammu', 3, 'manager', 'Manager', 800, '{}', '{}'),
('ammu', 4, 'boss', 'Boss', 1000, '{}', '{}')
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    label = VALUES(label),
    salary = VALUES(salary);

-- Add society account
INSERT INTO `addon_account` (name, label, shared) VALUES
('society_ammu', 'Ammunation', 1)
ON DUPLICATE KEY UPDATE label = 'Ammunation', shared = 1;

-- Add items for weapon parts
INSERT INTO `items` (name, label, weight, rare, can_remove) VALUES
('pistol_parts', 'Pistol Parts', 1, 0, 1),
('smg_parts', 'SMG Parts', 1, 0, 1),
('rifle_parts', 'Rifle Parts', 1, 0, 1),
('shotgun_parts', 'Shotgun Parts', 1, 0, 1),
('weapon_attachments', 'Weapon Attachments', 1, 0, 1)
ON DUPLICATE KEY UPDATE
    label = VALUES(label),
    weight = VALUES(weight);

-- Add ammunition items
INSERT INTO `items` (name, label, weight, rare, can_remove) VALUES
('ammo-9', 'Pistol Ammo (9mm)', 0, 0, 1),
('ammo-rifle', 'Rifle Ammo (5.56mm)', 0, 0, 1),
('ammo-shotgun', 'Shotgun Shells (12 Gauge)', 0, 0, 1),
('ammo-45', 'SMG Ammo (.45 ACP)', 0, 0, 1),
('ammo-rifle2', 'Heavy Rifle Ammo (7.62mm)', 0, 0, 1)
ON DUPLICATE KEY UPDATE
    label = VALUES(label),
    weight = VALUES(weight);

