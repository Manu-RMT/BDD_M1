create or replace function schema (nomTable varchar)
returns setof varchar as 
$$
declare
rowbd VARCHAR;
begin 
	for rowbd in select column_name from information_schema.columns where table_name = nomTable loop 
		return next rowbd;
	end loop;
end;
$$ language plpgsql;


select schema('parts');



create type concatenation_value as (tablename varchar, nbligneTable integer);


create or replace function catPlus() returns setof concatenation_value as $$
declare 
	name_table VARCHAR;
	res concatenation_value;
begin 
	
FOR name_table IN SELECT tablename FROM pg_tables where tableowner = 'l312' loop
	res.tablename := name_table;
	execute 'select count(*) from ' || name_table into res.nbligneTable;
	return next  res;
END LOOP;
return;
end;
$$ language plpgsql;


select catPlus();


create type value_deuxAttr as (col1 varchar, col2 varchar);

create or replace function deuxAtt (nomTable varchar)
returns setof value_deuxAttr as 
$$
declare

colonne_name value_deuxAttr;
cursExp cursor for select column_name from information_schema.columns where table_name = nomTable;
dynCursor REFCURSOR;
res_function value_deuxAttr;

begin 
	
open cursExp;
fetch cursExp into colonne_name.col1;
fetch cursExp into colonne_name.col2;
close cursExp;

open dynCursor for execute 'SELECT ' || colonne_name.col1 || ' , ' || colonne_name.col2 || ' FROM ' || nomTable;

fetch dynCursor into res_function;
while found loop
	return next res_function;
	fetch dynCursor into  res_function;
end loop;
close dynCursor;
	return;
end;
$$ language plpgsql;

select deuxAtt('emp');

