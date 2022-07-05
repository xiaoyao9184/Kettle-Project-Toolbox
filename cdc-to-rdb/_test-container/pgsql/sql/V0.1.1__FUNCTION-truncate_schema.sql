CREATE OR REPLACE FUNCTION public.truncate_schema(_schema character varying)
  RETURNS void AS
$BODY$
declare
    selectrow record;
begin
for selectrow in
select 'TRUNCATE TABLE ' || quote_ident(_schema) || '.' ||quote_ident(t.table_name) || ' CASCADE;' as qry 
from (
     SELECT table_name 
     FROM information_schema.tables
     WHERE table_type = 'BASE TABLE' AND table_schema = _schema
     )t
loop
execute selectrow.qry;
end loop;
end;
$BODY$
  LANGUAGE plpgsql
;