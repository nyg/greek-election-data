-- data check
select count(*) from district;                 -- 56

select count(*) from municipality;             -- 325
select count(distinct municipality) from unit; -- 325

select count(*) from unit;                     -- 1,035
select count(distinct unit_id) from result;    -- 1,035

select sum(votes) from result;                 -- 5,365,517 (*)
select sum(stations) from municipality;        -- 19,128
select sum(stations) from unit;                -- 19,128 (1)
select sum(stations) from district;            -- 19,513 (2)
-- (*) excludes votes from "ετεροδημότες"
-- (2) > (1) because polling stations for ετεροδημότες are not
-- included at the municipal level. Therefor, all vote counts
-- below exclude ετεροδημότες votes.

-- vote count per district
select d.id, d.name, sum(r.votes)
  from result r, unit u, municipality m, district d
 where r.unit_id = u.id
   and u.municipality = m.id
   and m.district = d.id
 group by d.name;

-- vote count per unit
select u.id, u.name, sum(r.votes)
  from result r, unit u
 where r.unit_id = u.id
 group by u.name;

-- percent of votes for given party per unit
select r.unit_id,
       u.name unit_name,
       p.name party_name,
       r.votes party_votes,
       r.votes / (select sum(rr.votes) from result rr where rr.unit_id = r.unit_id) * 100 percentage
  from result r,
       unit u,
       party p
 where r.unit_id = u.id
   and r.party_id = p.id
--   and r.party_id = 1 -- party id
 group by r.party_id, r.unit_id
 order by percentage desc;

-- percent of votes for given party per municipality
select m.id municipality_id,
       m.name municipality_name,
       p.name party_name,
       sum(r.votes) party_votes,
       sum(r.votes) / (select sum(rr.votes) from result rr, unit uu, municipality mm where rr.unit_id = uu.id and uu.municipality = mm.id and mm.id = m.id) * 100 percentage
  from result r,
       unit u,
       municipality m,
       party p
 where r.unit_id = u.id
   and u.municipality = m.id
   and r.party_id = p.id
--   and r.party_id = 1 -- party id
 group by m.id, p.id
 order by percentage desc;

-- polling stations numbers
select d.id, d.name, d.stations, count(m.id), sum(m.stations), d.stations - sum(m.stations)
  from municipality m, district d
 where m.district = d.id
 group by d.id
 order by d.name;

select d.name, d.stations, m.name, m.stations -- , count(m.id), sum(m.stations), d.stations - sum(m.stations)
  from municipality m, district d
 where m.district = d.id
   and d.id = 49
 order by d.name;

-- overall
select p.name, sum(r.votes)
  from result r, party p
 where r.party_id = p.id
 group by p.id
 order by sum(r.votes) desc;
