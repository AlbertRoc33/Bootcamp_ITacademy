# Nivell 1
#Exercici 1
create table credit_card (
	id char (8) not null primary key,
    iban varchar (100) not null,
    pan varchar(25) not null,
    pin int not null,
    cvv int not null,
    expiring_date char(10) not null
);    
# Afeguim una FK a la Taula Transaction. Relacio PK (Credit_card.id) amb FK (transaction.Credit_card.id)
alter table transaction
add constraint fk_transaction_credit_card_id
foreign key (credit_card_id)
references credit_card (id);

#Exercici 2
#El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938.
#La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.
# Eliminar FK 
alter table transaction
drop foreign key fk_transaction_credit_card_id;

#fem el cas de nou amb noves options (condicionat):
alter table transaction
add constraint fk_transaction_credit_card_id
foreign key (credit_card_id)
references credit_card (id)
on update cascade # Si canvies l’id de la targeta, s’actualitza a transaction
on delete cascade; #Si elimines la targeta, s’elimina la transacció associada


### Primer forma:
update credit_card
set iban='TR323456312213576817699999'
where id ='CcU-2938';
### comprovacio
select*
from credit_card
where id = 'CcU-2938';



#Segona forma :insertar els canvis# ON DUPLICATE KEY UPDATE permet actualitzar registre  ja existen en nou valors
insert into credit_card (id, iban, pan, pin, cvv, expiring_date)
values ('CcU-2938', 'TR323456312213576817699999', '5424465566813633', 3257, 984, '10/30/22')
on duplicate key  update 
iban= values(iban),
pan= values(pan),
pin= values(pin),
cvv= values(cvv),
expiring_date= values(expiring_date);
# comprovem que hi han els canvis demanats.
select*
from credit_card
where credit_card.id='CcU-2938'; 

#Exercici 3
#En la taula "transaction" ingressa un nou usuari amb la següent informació
### Insertem el nou client a 'company'
insert into company ( `id`)
values ('b-9999');
###comprovació: 
select*
from company
where id= 'b-9999';
###modificar les dades de tbla company per poder fer transaccions
alter table `credit_card`
modify`iban` varchar(100) default null,
modify`pan` varchar(25) default null,
modify`pin` int default null,
modify`cvv` int default null,
modify`expiring_date` char(10) default null;
###creo la nova targeta:
INSERT INTO `credit_card` (`id`)
VALUES ('CcU-9999');
###ingressa un nou usuari amb la següent informació
insert into `transaction` (`id`,`credit_card_id`,`company_id`,`user_id`,`lat`,`longitude`,`amount`,`declined`)
values ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999',9999,829.999,-117.999,111.11,0);
###comprovació:
select*
from transaction
where credit_card_id='CcU-9999';

#Exercici 4
###Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.
alter table credit_card
drop column pan;

#Nivell 2
#Exercici 1
###Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.
delete from transaction
where id='000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

select*
from transaction
where id ='000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

#Exercici 2
###La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives.
###S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. Serà 
###necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia.
###Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. Presenta la vista creada, 
###ordenant les dades de major a menor mitjana de compra.
select c.company_name,c.phone,c.country,avg(t.amount) as mitjana
from transaction t
join company c
on t.company_id=c.id
group by c.company_name,c.phone,c.country
order by mitjana desc;

create view VistaMarketing as
select  c.company_name,c.phone,c.country,avg(t.amount) as mitjana
from transaction t
join company c
on t.company_id=c.id
group by c.company_name,c.phone,c.country;

#Exercici 3
###Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"
select*
from VistaMarketing
where country ='Germany'
order by mitjana desc;

#Nivell 3
#Exercici 1
###La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar 
###modificacions en la base de dades, però no recorda com les va realitzar. Et demana que l'ajudis a deixar els 
###comandos executats per a obtenir el següent diagrama:
###creem la nova taula sergons arxiu que tenim
CREATE TABLE IF NOT EXISTS user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);
###renombrem la taula
rename table user to data_user;
show tables;

###modifiquem tipus de dades
alter table data_user modify `ID`int;

###carguem les dades a data_user, pero en nom arxiu de dades es user, per tant, fem canvis:
###renombrem com a user:
RENAME TABLE data_user TO user;

###carguem dades, per Server...
###comprovem les dades
select*
from user;

###renombrem com a data_user:
RENAME TABLE user TO data_user;

### vaig afeguir les dades que falten a data_user
insert into data_user ( `id`)
values ('9999');

### afegir un constraint de fk en la taula transaction x rel. amb data_user
alter table transaction
add constraint fk_transaction_user_id
foreign key (user_id)
references data_user (id);

### canvis de tipus en la taula credit_card.
###pero q com q tbla credit_card esta relacionada amb transactions no m'ho permetra fer per tant:
### anulem fk
ALTER TABLE transaction
DROP FOREIGN KEY fk_transaction_credit_card_id;
# fem els canvis de types:
Alter table `credit_card`
modify`id` varchar(20),
modify`iban` varchar(50),
modify`pin` varchar(4) ,
modify`cvv` int,
modify`expiring_date` varchar (20);
# tornem afegir la FK
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card_id
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);
#agregem columna
alter table credit_card
add fecha_actual date;

### eliminar columna website de tbla company
alter table company
drop  column website;

###canviar el nom de data_user de columna email per peronal_email
alter table data_user
change email personal_email varchar(150);

###canvi de tipus en la taula transaction// estava varchar 15 o poso a 20
Alter table `transaction`
modify`credit_card_id` varchar (25);

#Exercici 2
###L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:
###Comprovació:
###ID de la transacció
###Nom de l'usuari/ària
###Cognom de l'usuari/ària
###IBAN de la targeta de crèdit usada.
###Nom de la companyia de la transacció realitzada.
###Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de
###nom columnes segons calgui.
select t.id as ID_transaccio,du.name as Nom_usuari,du.surname as Cognom_usuari,cc.iban as IBAN_targeta,c.company_name as Companyia_trans,t.amount as Import
from transaction t
join credit_card cc
on t.credit_card_id=cc.id
join data_user du
on t.user_id=du.ID
join company c
on t.company_id=c.id
where t.declined = 0;


create view informetecnico as
select t.id as ID_transaccio,du.name as Nom_usuari,du.surname as Cognom_usuari,cc.iban as IBAN_targeta,c.company_name as Companyia_trans,t.amount as Import
from transaction t
join credit_card cc
on t.credit_card_id=cc.id
join data_user du
on t.user_id=du.ID
join company c
on t.company_id=c.id
where t.declined = 0;


SELECT * 
FROM informetecnico
ORDER BY ID_transaccio DESC;





