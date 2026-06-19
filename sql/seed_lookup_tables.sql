PRAGMA foreign_keys = ON;

INSERT OR IGNORE INTO statuses (status_name) VALUES
('Completed'),
('Currently Reading'),
('DNF');

INSERT OR IGNORE INTO formats (format_name) VALUES
('Ebook'),
('Physical Book'),
('Audiobook');

INSERT OR IGNORE INTO sources (source_name) VALUES
('Libby App'),
('Physical Library'),
('Personally Owned'),
('Amazon Prime Reading'),
('Kindle Unlimited'),
('Purchased Ebook'),
('Borrowed'),
('Other');

INSERT OR IGNORE INTO moods (mood_name) VALUES
('Emotional Damage'),
('Bittersweet'),
('Funny'),
('Comfort Read'),
('Uplifting'),
('Fast Paced'),
('Slow Burn'),
('Atmospheric'),
('Character Driven'),
('Plot Driven'),
('Easy Read'),
('Deep/Complex'),
('Dark'),
('Whimsical'),
('Cozy'),
('Reflective'),
('Thought Provoking'),
('Inspirational'),
('Intense'),
('Adventure'),
('Small Town'),
('Found Family'),
('Nostalgic'),
('Escapist'),
('Practical');

INSERT OR IGNORE INTO genres (genre_name) VALUES
('Historical Fiction'),
('Contemporary Fiction'),
('Literary Fiction'),
('Middle Grade'),
('Young Adult'),
('Memoir'),
('Biography'),
('History'),
('Other Nonfiction'),
('Parenting'),
('Politics & Society'),
('Dystopian Fiction'),
('Classics'),
('Fantasy'),
('Science Fiction'),
('Mystery'),
('Thriller'),
('Romance');