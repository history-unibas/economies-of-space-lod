
-- list available extensions
select *
from pg_available_extensions;

SELECT * FROM pg_stat_activity;


SELECT pid, usename, state, query, query_start
FROM pg_stat_activity
WHERE state = 'active';




SELECT pg_terminate_backend(3525067);


--kill all actives queries
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE state = 'active'
  AND pid <> pg_backend_pid();

-- only owner can do this
vacuum full;