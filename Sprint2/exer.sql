#1	Llistat dels països que estan generant vendes.
select c.country
from company c
join transaction t
on c.id=t.company_id
group by 1;

#Des de quants països es generen les vendes.
Select count(distinct(country))
from company c
join transaction t
on c.id=t.company_id
where t.amount>0 and t.amount is not null;

#identifica la companyia amb la mitjana més gran de vendes.
select c.company_name, format(avg(t.amount),2) as mitjana
from company c
join transaction t
on c.id=t.company_id
where t.declined=0
group by 1
order by avg(t.amount) desc
limit 1;

#Exercici 3
#Utilitzant només subconsultes (sense utilitzar JOIN):
#Mostra totes les transaccions realitzades per empreses d'Alemanya.
select *
from transaction t
where t.declined=0 and  t.company_id in (select company.id from company where country='Germany');

#Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
select c.company_name
from company c
where id in ( 
		select company_id
        from (
			select t2.company_id, count(t2.id) as NumTrans
			from transaction t2
			group by t2.company_id) as Tot
        where NumTrans > (
				select avg(NumTrans)
                from(
					select t3.company_id, count(t3.id) as NumTrans
			from transaction t3
			group by t3.company_id) as total2
            )
);
  
#Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
select company.company_name
from company
where not exists  (
		select transaction.company_id
		from transaction
		where transaction.company_id=company.id
);

#Nivell 2
#Exercici 1
#Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data 
#de cada transacció juntament amb el total de les vendes.
select date(t.timestamp) as Dia,sum(t.amount) as Total
from transaction t
where t.declined=0
group by 1
order by Total desc
limit 5;

#Exercici 2
#Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
select company.country,T.A
from(
	select  company_id,avg(amount) as A
from transaction t1
where t1.declined=0
group by 1 ) as T
join company
on company.id=T.company_id
order by 2 desc;

#Exercici 3
#En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute".
#Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.
#Mostra el llistat aplicant JOIN i subconsultes
select *
from transaction t
join company c
on t.company_id=c.id
where t.declined=0 and c.country = (
	select c2.country
	from	company c2
	where c2.company_name='Non Institute'
    );

# EX3:Mostra el llistat aplicant solament subconsultes
select*
from	transaction t
where t.declined=0 
	and t.company_id in (
	select c1.id
	from company c1
    where c1.country= (
         select c2.country
	     from company c2
         where c2.company_name= 'Non Institute'
     )
);

/*
Nivell 3
#Exercici 1
#Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 350 i 400 euros
#i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.
*/

select c.company_name,c.phone,c.country,t.timestamp,t.amount
from company c
join transaction t
on c.id=t.company_id
where t.amount between 350 and 400 and t.declined=0
and date(t.timestamp) in ('2024-03-13','2018-07-20','2015-04-29')
order by t.amount desc;
   
#Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació 
#sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses 
#on especifiquis si tenen més de 400 transaccions o menys.   
select c.company_name,count(t.id) as Total_trans,case when count(t.id)> 400 then 'més de 400' else 'menys de 400' end as Grup_Trans
from company c
join transaction t
on c.id=t.company_id
group by 1;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
