-- exo 1
create or replace function nbParts()
returns  integer 
as
$$
declare 
	n integer;
begin
	select count(*) into n from parts;
	
	if n > 15 then
		raise exception 'NB erreur car sup à %',n;
	end if;

	return  n ;
end;
$$ LANGUAGE plpgsql;


select nbParts();



--exo 2
create or replace function propMgr() returns real as $$
declare 
	nb_uplet INTEGER;
	mana nb_uplet%TYPE;
	nbelem nb_uplet%TYPE;
	nbmana nb_uplet%TYPE;
	res real;
begin 
	delete from emp;
	
	select count(*) into nb_uplet from emp;
	nbelem := nb_uplet;
	
	if nbelem = 0 then
		return null;
	end if; 
	

	select count(job) into mana from emp where job like '%MANAGER%';
	nbmana := mana;

	res := (nbmana * 100) / nbelem;
	return res ::REAL;
	
end;
$$ language plpgsql;



select propMgr();


-- 3
create or replace function cat() returns setof VARCHAR as $$
declare 
	nuplet pg_tables%ROWTYPE;
	res VARCHAR;
begin 
	
FOR nuplet IN SELECT * FROM pg_tables where tableowner = 'l312' LOOP
res := nuplet.tablename;

return next res;
END LOOP;

	
end;
$$ language plpgsql;


select cat();

--4

--- 1
create or replace function aug1000(num_dep INTEGER) returns void as $$
declare 
	nuplet emp%ROWTYPE;
	som INTEGER default 0;
	salaire_max integer;
begin 
	
	select max(sal) into salaire_max from emp;
	
	
	FOR nuplet IN select * from emp where sal > 1500 and deptno = num_dep LOOP
		som := nuplet.sal + 1000;
		if som >= salaire_max then 
			raise exception 'Salaire plus elevé (si on rajoute mille) que le salaire plus haut de l"enttreprise pour %',nuplet.ename;
		end if; 
		update emp set sal = som  where empno = nuplet.empno;
	END LOOP;
end;
$$ language plpgsql;

select aug1000(30);









