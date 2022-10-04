create type tNuplet as (texte text, nombre real);
	

create or replace function listeProd() returns setof tnuplet as $$
declare
	nuplet demo_product_info%rowtype;
	enregProduit tNuplet;
	cursExp cursor for select * from demo_product_info;
begin 
	
open cursExp;
	fetch cursExp into nuplet;
	while found loop
		enregProduit.texte := nuplet.product_name;
		enregProduit.nombre := nuplet.list_price;
		return next enregProduit;
		fetch cursExp into nuplet;
	end loop;
	return;
close cursExp;

end;
$$ language plpgsql;

select listeProd();






create or replace function top5() returns setof tnuplet as $$
declare
	nuplet demo_product_info%rowtype;
	cursExp cursor for select * from demo_product_info order by list_price desc;
	enregProduit tNuplet;
	compteur integer default 0;
begin 
	
open cursExp;
	fetch cursExp into nuplet;
	while compteur < 5 and found loop
		compteur := compteur + 1;
		enregProduit.texte := nuplet.product_name;
		enregProduit.nombre := nuplet.list_price;
		return next enregProduit;
		fetch cursExp into nuplet;
	end loop;
	return;
close cursExp;

end;
$$ language plpgsql;


select top5();


create or replace function correlation() returns integer as $$
declare
	nuplet ord%rowtype;
	cursorExp cursor for select * from ord where qty is not null;
	cursoNBData cursor for select count(*) from ord  where qty is not null;
	curr integer default -1;
	somme integer default 0;
	compteur integer :=0;
begin 

open cursorNBData;
	fetch cursorNBData into nuplet;
	if nuplet <= 10 then
		raise exception "Data iniférieur à 2";
	end if;
close cursorNBData;
	
	
open cursorExp;
	fetch cursorExp into nuplet;
	while found loop	
		if curr <> -1 then 
			somme := somme + abs(curr - nuplet.qty);
			compteur := compteur + 1;
		end if;
		curr := nuplet.qty;
		fetch cursorExp into nuplet;
	end loop;	
	return somme/compteur;
close cursorExp;	
		
end;
$$ language plpgsql;

select correlation();




