# 1er.creo BD
create database Vendes_BD;

#creo la taula companies
create table if not exists companies (
	company_id varchar (100) not null primary key,
    company_name varchar (150),
    phone varchar (50),
    email  VARCHAR(150),
    country VARCHAR(150),
    website VARCHAR(150)
 );
 show tables;
 
# taula european_users	
CREATE TABLE IF NOT EXISTS european_user (
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
# taula american_users
create TABLE IF NOT EXISTS american_user (
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
# crear taula credit_card
create table credit_card (
	id char (8) not null primary key,
    iban varchar (100) default null,
    pan varchar(25) default null,
    pin int  default null,
    cvv int  default null,
    track1 varchar (350) default null,
    track2 varchar (350) default null,
    expiring_date char(10) default null
); 
#crear taula de products
create table products (
	id int not null primary key,
    product_name varchar (250) not null,
    price decimal (10,2) not null,
    colour varchar (50),
    weight decimal (5,1),
    warehouse_id varchar (15)
);    
# crear taula transaction

create table if not exists transactions(
	id	varchar (255) primary key,
    card_id varchar (25),
    business_id varchar (20),
    timestamp timestamp,
    amount decimal(10,2),
    declined tinyint ,
    product_ids varchar (25),
    user_id int,
    lat decimal (10,2),
    longitude decimal (10,2)
);    
show tables;


#cargo dades a la taula companies
LOAD DATA LOCAL INFILE 'C:/companies.csv'
INTO TABLE companies
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ESCAPED BY '/'
IGNORE 1 ROWS
(company_id, company_name, phone, email, country, website);
#cargo dades a la taula products (1er amb errors)
load data local infile 'C:/products.csv'
into table products
character set utf8mb4
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(id,product_name,price,colour,weight,warehouse_id);

select*
from products;

#em surten error: o columna price: MySQL ha intentat inserir valors com '$161.11' en una columna DECIMAL.
#Això ha generat warnings (Error 1366), però les files s’han inserit igualment.
# tornem a borrar i posarem + detalls data types 
#afeguim set per canviar:price = REPLACE(@price, '$', '') + 0:elimina símbol $ i converteix el valor a decimal abans d’inserir.
#ULL: els@ on van
#importacio dades tbla products
load data local infile 'C:/products.csv'
into table products
character set utf8mb4
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(id,product_name,@price,colour,weight,warehouse_id)
SET
id = id,
product_name = product_name,
price = REPLACE(@price, '$', '') + 0,
colour = colour,
weight = weight,
warehouse_id = warehouse_id;

#importa dades american_users
load data local infile 'C:/american_users.csv'
into table american_user
character set utf8mb4
FIELDS TERMINATED BY ','
enclosed by '"'
IGNORE 1 ROWS
(id,name,surname,@phone,email,@birth_date,country,city,postal_code,@address)
SET
id = id,
name=name,
surname = surname,
phone= replace(replace(replace(replace(replace(@phone,'(',''),')',''),'-',''),'+',''),' ',''),
email= email,
birth_date= replace(@birth_date,'""',''),
country=country,
city=city,
postal_code=postal_code,
address= replace(@address,'#',' ')
;
#importa dades european_users
load data local infile 'C:/european_user.csv'
into table european_user
character set utf8mb4
FIELDS TERMINATED BY ','
enclosed by '"'
IGNORE 1 ROWS
(id,name,surname,@phone,email,@birth_date,country,city,postal_code,@address)
SET
id = id,
name=name,
surname = surname,
phone= replace(replace(replace(replace(replace(@phone,'(',''),')',''),'-',''),'+',''),' ',''),
email= email,
birth_date= replace(@birth_date,'""',''),
country=country,
city=city,
postal_code=postal_code,
address= replace(@address,'#',' ')
;
### creo la columna a credit_card
ALTER TABLE credit_card
ADD COLUMN user_id INT
AFTER id;
#importa dades credit_cards
load data local infile 'C:/credit_cards.csv'
into table credit_card
character set utf8mb4
FIELDS TERMINATED BY ','
enclosed by '"'
IGNORE 1 ROWS
(id,user_id,iban,pan,pin,cvv,track1,track2,expiring_date)
SET
id = id,
user_id=user_id,
iban = iban,
pan=pan, 
pin=pin,
cvv= cvv,
track1=track1,
track2=track2,
expiring_date=expiring_date
;
### cargo les dades de transactions
load data local infile 'C:/transactions.csv'
into table transactions
character set utf8mb4
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS
(id,card_id,business_id,@timestamp,amount,declined,product_ids,user_id,lat,longitude)
SET
timestamp = STR_TO_DATE(@timestamp, '%Y-%m-%d %H:%i:%s')
;
### hem dona problemes el format decimal que tinc en les taules lat i longitude; per tant, modifico aquestes taules
### faig que siguin varchar
ALTER TABLE transactions
MODIFY lat VARCHAR(20),
MODIFY longitude VARCHAR(20);

### torno a cargo les dades de transactions
load data local infile 'C:/transactions.csv'
into table transactions
character set utf8mb4
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS
(id,card_id,business_id,@timestamp,amount,declined,product_ids,user_id,lat,longitude)
SET
timestamp = STR_TO_DATE(@timestamp, '%Y-%m-%d %H:%i:%s')
;
### comprobo que no hi hagin taules amb columnes null:
SELECT *
FROM companies
WHERE company_id IS NULL OR company_name IS NULL 
OR phone IS NULL OR email IS NULL OR country IS NULL OR website IS NULL;

#importa dades credit_cards
load data local infile 'C:/credit_cards.csv'
into table credit_card
character set utf8mb4
FIELDS TERMINATED BY ','
enclosed by '"'
IGNORE 1 ROWS
(id,user_id,iban,pan,pin,cvv,track1,track2,expiring_date)
SET
id = id,
user_id=user_id,
iban = iban,
pan=pan, 
pin=pin,
cvv= cvv,
track1=track1,
track2=track2,
expiring_date=expiring_date
;
### cargo les dades de transactions
load data local infile 'C:/transactions.csv'
into table transactions
character set utf8mb4
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS
(id,card_id,business_id,@timestamp,amount,declined,product_ids,user_id,lat,longitude)
SET
timestamp = STR_TO_DATE(@timestamp, '%Y-%m-%d %H:%i:%s')
;
### hem dona problemes el format decimal que tinc en les taules lat i longitude; per tant, modifico aquestes taules
### faig que siguin varchar
ALTER TABLE transactions
MODIFY lat VARCHAR(20),
MODIFY longitude VARCHAR(20);

### torno a cargo les dades de transactions
load data local infile 'C:/transactions.csv'
into table transactions
character set utf8mb4
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS
(id,card_id,business_id,@timestamp,amount,declined,product_ids,user_id,lat,longitude)
SET
timestamp = STR_TO_DATE(@timestamp, '%Y-%m-%d %H:%i:%s')
;
### comprobo que no hi hagin taules amb columnes null:
SELECT *
FROM companies
WHERE company_id IS NULL OR company_name IS NULL 
OR phone IS NULL OR email IS NULL OR country IS NULL OR website IS NULL;

### hi han 2 taules de User, per ser més eficients les ajuntarem
# taula american_users
create TABLE IF NOT EXISTS Total_user (
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
### afegieixo columna continent
alter table total_user
add continent varchar (50) not null;
### importo dades de american_user:
insert into total_user (id, name, surname, phone, email, birth_date, country, city, postal_code, address, continent)
select id, name, surname, phone, email, birth_date, country, city, postal_code, address,'american'
from american_user;
### importo dades de european_user:
insert into total_user (id, name, surname, phone, email, birth_date, country, city, postal_code, address, continent)
select id, name, surname, phone, email, birth_date, country, city, postal_code, address,'european'
from european_user;

## canvio el nom en credit_card per posar el mateix nom a taules dimensions i types
alter table total_user
change id user_id int;
### comprovació
select*
from total_user;
### determino fk en transactions vs Total_user
alter table transactions
add constraint fk_transactions_user_id
foreign key (user_id)
references total_user (user_id)
on update cascade
on delete cascade;

#### Eliminem taules sobrants:
drop table american_user;
drop table european_user;
### comprovacio
show tables;


###Exercici 1
###Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.
select*
from total_user
join ( select t.user_id, count(t.id) as Num_trans
from transactions t
group by t.user_id) as sub_tabla
on sub_tabla.user_id=total_user.user_id
where sub_tabla.Num_trans > 80;


###Exercici 2
###Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
###miro que existeic l'empresa.
select*
from companies
where companies.company_name='Donec Ltd';

###Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
select cc.iban, avg(t.amount) as Mitj_iban
from credit_card cc
join transactions t
on cc.card_id=t.card_id
join companies c
on t.company_id=c.company_id
where c.company_name='Donec Ltd'
group by cc.iban;


###Nivell 2
###Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions han estat declinades
###aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:

###Creem la taula
CREATE TABLE estat_targeta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  card_id VARCHAR(25),
  tt VARCHAR(10),
  FOREIGN KEY (card_id) REFERENCES credit_card(card_id)
);
###creo la CTE -per tenir cada targeta si ha estat declined o amb una sequencia entera
###assignar un nom a un conj.de resultats temporals
with targeta as (
 select 
		transactions.card_id,
        transactions.declined,
        row_number ()over( partition by transactions.card_id order by transactions.timestamp desc) as ttt
 from transactions
 )
select *
from targeta; 

###insertem dintre taula
INSERT INTO estat_targeta (card_id, tt)
WITH targeta AS (
  SELECT 
    transactions.card_id,
    transactions.declined,
    transactions.id,
    ROW_NUMBER() OVER (
      PARTITION BY transactions.card_id 
      ORDER BY transactions.timestamp DESC
    ) AS ttt 
  FROM transactions
)
SELECT 
  card_id,
  CASE
    WHEN SUM(CASE WHEN declined = 1 THEN 1 ELSE 0 END) = 3 
         AND COUNT(ttt) = 3
    THEN 'inactiva'
    ELSE 'activa'
  END AS tt
FROM targeta
WHERE ttt <= 3
GROUP BY card_id;


###Exercici 1
###Quantes targetes estan actives?

SELECT COUNT(*) AS targetes_actives
FROM estat_targeta
WHERE tt = 'activa';


###Nivell 3
###Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, tenint en compte que des de
###transaction tens product_ids. Genera la següent consulta:

### abans de crear la relació amb products, "desnormalitzem" la colum. product_ids (Json_table)
### ull: tenim dades entre ; i, Per convertir-la en un array JSON, cal envoltar-la amb corxets i separar amb cometes i coma
#CONCAT('[', REPLACE(product_ids, ',', '","'), ']')
### no ho farem directament a la taula transaction per no "tocar"la original i despres farem que s'actualitzi auto.
create table taula_products as
select
tr.id,
tr.card_id,
tr.company_id,
tr.timestamp,
tr.amount,
tr.declined,
jtable.products_ids,
tr.user_id,
tr.lat,
tr.longitude
from transactions tr, 
json_table(
	concat('[',replace (tr.product_ids,';','","'),']'),
    '$[*]'columns(
     products_ids varchar(10) path '$'
    )
) as jtable;
### creo PK de taula_products
alter table taula_products
add primary key (id,products_ids);
### FK taula transaction
alter table taula_products
add constraint fk_transaction
foreign key (id)
references transactions(id)
on update cascade
on delete cascade;
###canviar el tipus de products_ids a INT
ALTER TABLE taula_products
MODIFY COLUMN products_ids INT;
### FK taula products
alter table taula_products
add constraint fk_products_ids
foreign key (products_ids)
references products(id)
on update cascade
on delete cascade;

#### eliminar  columnas de taula_prodicts sobrants a Json_table
alter table taula_products
drop card_id,
drop company_id,
drop timestamp,
drop amount,
drop declined,
drop user_id,
drop lat,
drop longitude;

select*
from taula_products;

#Exercici 1
#Necessitem conèixer el nombre de vegades que s'ha venut cada producte. declined=0

select tp.products_ids, p.product_name, count(tp.products_ids) as num_vend
from taula_products tp
join products p
on tp.products_ids=p.id
join transactions t
on tp.id=t.id
where t.declined = 0
group by  tp.products_ids,p.product_name
order by num_vend desc;
