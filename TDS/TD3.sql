create function majData()
	returns trigger as
$$
begin
	new.st := upper(new.st);
	new.state_name := upper(new.state_name);
	return new;
end;
$$
language plpgsql;

create trigger majData
before insert or update
on demo_states
for each row 
execute procedure majData();


--drop trigger majData on demo_states;

--insert into demo_states values('mddg','madagascar');

create table clibanque(
	idCli INT,
	nomCli VARCHAR(50),
	idConjoint INT,
	constraint cliPK primary key(idCli),
	constraint cliFK foreign key(idConjoint) references clibanque(idCli)
);


-- exercice 2

create or replace function majBanque()
returns trigger as
$$ 
declare 
nom clibanque.nomcli%type;

begin
	-- recupère ancien client
	select nomCli into nom from clibanque where idCli = new.idConjoint;
	
	if new.nomCli <> nom then
		raise exception 'erreur nom conjoint pas pareil';
	end if;
	return new;
end;
$$language plpgsql;

create trigger majBanque
before insert or update 
on clibanque
for each row 
execute procedure majBanque();


--insert into clibanque values(3,'RMTT',2);
--insert into clibanque values(2,'RMTT',1);

-- exercice 3
create or replace function statEmp()
returns trigger as
$$ 
begin
	if (TG_OP = 'DELETE') then
		update stats set timestampModif = current_timestamp, nbMaj = (nbMaj + 1) where typeMaj = 'DELETE';   	
	elseif (TG_OP = 'UPDATE') then  
		update stats set timestampModif = current_timestamp, nbMaj = (nbMaj + 1) where typeMaj = 'UPDATE';   	
	elseif (TG_OP = 'INSERT') then 
		update stats set timestampModif = current_timestamp, nbMaj = (nbMaj + 1) where typeMaj = 'INSERT';   
	end if;
	return null;
end;
$$language plpgsql;


create trigger statEmp
after insert or update or delete  
on emp
for each row 
execute procedure statEmp();


insert into emp values();
update emp set where empno = '';
delete * from emp where ename ='';

-- exeercice 4 
create table custnames as 
select customer_id, cust_first_name,cust_last_name from demo_customers


create or replace function deplacement_data()
returns trigger 
as $$ 	
begin 	
	if TG_OP in 'UPDATE','DELETE','INSERT' then
		insert into custnames select old.*;	
		delete * from emp where empno = old.empno;
	end if;
	return null;
end;
$$ language plpsql;

create trigger deplace_data
after insert or update or delete 
on emp 
for each row 
execute procedure deplacement_data();



