CREATE OR REPLACE FUNCTION rest_schema_counters(_schema character varying)
  RETURNS void AS
$BODY$
declare
    selectrow record;
begin
for selectrow in
select 'SELECT pg_stat_reset_single_table_counters(' || t.relid || ');' as qry 
from (
     SELECT relid 
     FROM pg_stat_user_tables
     WHERE schemaname = _schema
     )t
loop
execute selectrow.qry;
end loop;
end;
$BODY$
  LANGUAGE plpgsql