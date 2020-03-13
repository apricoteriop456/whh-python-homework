-- Movie_theatres
-- 4.1 Select the title of all movies.
select title from movies;
-- 4.2 Show all the distinct ratings in the database.
select distinct rating from movies;
-- 4.3  Show all unrated movies.
select * from movies where rating is null;
-- 4.4 Select all movie theaters that are not currently showing a movie.
select * from movietheaters where movie is null;
-- 4.5 Select all data from all movie theaters and, additionally, the data from the movie that is being shown in the theater (if one is being shown).
select * from movietheaters left join movies on movies.code=movietheaters.movie;
-- 4.6 Select all data from all movies and, if that movie is being shown in a theater, show the data from the theater.
select * from movies left join movietheaters on movies.code=movietheaters.movie order by movies.code;
-- 4.7 Show the titles of movies not currently being shown in any theaters.
select * from movies where code not in (select movie from movietheaters where movie is not NULL);
-- 4.8 Add the unrated movie "One, Two, Three".
insert into movies values(9,'one',null);
insert into movies values(10,'two',null);
insert into movies values(11,'three',null);
-- 4.9 Set the rating of all unrated movies to "G".
update movies set rating='G' WHERE RATING IS NULL;
-- 4.10 Remove movie theaters projecting movies rated "NC-17".
DELETE FROM movietheaters WHERE movie = (select code from movies where rating = 'NC-17');