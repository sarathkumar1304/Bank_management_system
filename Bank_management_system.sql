-- write pl/sql blocks to develop following modules for bank     appl.
/*
i. Open a New Account

ii. Deposit Amount

iii. Withdraw Amount

iv. Amount Trans. using Accnos

v. Check Balance ( by using Accno / Mobileno )

vi. Mini statement

vii. Account Statement

viii. View Account Details  ( by using Accno / Mobileno )

ix. Update Account Details 

x. Delete Account Details ( by using Accno / Mobileno )


** Table Creations **
*/

Create Table Bank_Mas
( Accno Varchar2(10),
  Cname Varchar2(15),
  Mobileno Number(10),
  Odate Date,
  Acc_type Varchar2(1),
  Balance Number(8,2)
);

Create Table Bank_Trans
( Tno Number(4),
  Saccno Varchar2(10),
  Daccno Varchar2(10),
  Tdate Date,
  Ttype Varchar2(2),
  Tamount Number(8,2)
);

-- ** Sequences for to generate Account Numbers **

-- Sequence for to generate Account Numbers

Create Sequence accno_Seq
Start with 1
Increment by 1;

-- Sequence for to generate Transaction Numbers

Create Sequence tno_seq
start with 1
increment by 1;

-- procedure dopl:
---------------
create or replace procedure dopl
  ( text varchar2 )
        is
begin
 dbms_output.put_line( text );
end;
/

-- i. Open a New Account :
-----------------------
/*
-- validations :
-------------

   -> Account No. should be generate automatically

            ex: sbi1, sbi2,.....

   -> Customer name is capital letters

   -> Mobileno should be accepts 10 digits only and it should       be unique.

   -> Opening date is system date

   -> Account type should be accepts 's', 'c'

   -> if account type is 'S' then Mini.Opening balance rs.500

   -> if account type is 'c' then mini. opening balance

ii. Deposit Amount :
--------------------

   -> Deposit amount should be updated in Bank_Master table

iii. Withdraw Amount :
----------------------

   -> Withdraw amount should be updated in Bank_Master table

iv. Amount Trans. using Accnos:
-------------------------------

     -> Trans. amount should be updated in Source Accno and           Destination Account No.

v. Check Balance ( by using Accno / Mobileno ) :
------------------------------------------------

   -> to Check your account balance by using ACCNO / MOBILENO

vi. Mini statement :
--------------------

   -> to display last 5 latest transactions

vii. Account Statement :
------------------------

  -> to generate account statment from two given dates.

viii. View Account Details  ( by using Accno / Mobileno ) :
-----------------------------------------------------------

   -> To view account details by using Accno / Mobileno

ix. Update Account Details :
----------------------------

   -> to update given account Master data

x. Delete Account Details:
--------------------------

  -> to delete account details by using Accno / Mobileno 

*/
--	******* PACKAGE SPECIFICATION *******

Create or replace package Bank_pack
                 is
 -- Procedure spec. for to open a new account
 Procedure New_Acc
 ( p_cname bank_mas.cname%type,
   p_mobileno bank_mas.mobileno%type,
   p_acc_type bank_mas.acc_type%type,
   p_balance bank_mas.balance%type 
 );

  -- Procedure spec. for to deposit amount
  Procedure Credit( p_accno bank_mas.accno%type,
		    p_tAmount Bank_trans.Tamount%type);

  -- Procedure spec. for to Withdraw amount
  Procedure Debit( p_accno bank_mas.accno%type,
		   p_tAmount Bank_trans.Tamount%type);

    -- Procedure spec. for to Transfer amount
  Procedure Trans_Amt( p_Saccno bank_trans.saccno%type,
		    p_Daccno bank_trans.Daccno%type,
		    p_tAmount Bank_trans.Tamount%type);

  -- function for to check account Balance by using accno
  Function chk_bal(p_Accno Bank_mas.Accno%type) 
					return Number;
  
  -- function for to check account Balance by using Mobileno
  Function chk_bal(p_Mobileno Bank_mas.Mobileno%type) 
					return Number;

  -- Procedure spec to generate Mini statement
  Procedure mini_stat( p_Saccno Bank_Trans.Saccno%type);
 
  -- Procedure spec to generate Account statement
  Procedure acc_stat( p_Saccno Bank_Trans.Saccno%type,
		       Sdate date,
		       Edate Date);

  -- procedure Spec for to view account details using Accno
  Procedure view_acc( p_Accno bank_mas.Accno%type);

  --procedure Spec for to view account details using Mobileno
  Procedure view_acc( p_Mobileno bank_mas.Mobileno%type);
 
  -- procedure Spec for to Update account details using Accno
   Procedure upd_acc( p_Accno bank_mas.Accno%type,
		      p_New_mobileNo bank_mas.Mobileno%type);

  -- Procedure spec. for to delete account by using ACCNO.
   Procedure del_acc( p_accno bank_mas.accno%type);
		      
  -- Procedure spec. for to delete account by using mobileno
   Procedure del_acc( p_Mobileno bank_mas.Mobileno%type);
End Bank_Pack;
/

 
--	************** PACKAGE BODY ***************

Create or replace Package body Bank_Pack
		is
-- Procedure Body for to open a new account
 Procedure New_Acc
 ( p_cname bank_mas.cname%type,      -- king
   p_mobileno bank_mas.mobileno%type, -- 9000994005
   p_acc_type bank_mas.acc_type%type,  -- S
   p_balance bank_mas.balance%type     -- 400
 )		
		is
  v_accno bank_mas.accno%type;
  cnt number;
 Begin
  if length(p_mobileno)!=10 then
     raise_application_error(-20101,'Invalid MobileNo!!!!!');
  end if;
  select count(*) into cnt from bank_mas 
			where mobileno = p_mobileno;
  if cnt=1 then
     raise_application_error(-20102, 
			'Mobileno Already Registred.');
  end if;
  if upper(p_acc_type)=upper('s') then
     if p_balance <500 then
         raise_application_error(-20103,
		'Min. Savings A/c.Balance Rs.500/-');
     end if;
  elsif upper(p_acc_type)=upper('c')then
     if p_balance <1000 then    
         raise_application_error(-20104, 
	   'Mini. Current A/c. Opening Balance Rs.1000/-.');
     end if;
  else
    raise_application_error(-20105,'Invalid Account type!!'); 
  end if;
  v_accno := 'sbi'||(accno_Seq.nextval);  
  insert into bank_mas values 
   (v_accno,upper(p_cname),p_mobileno,sysdate,
		upper(p_acc_type),p_balance);
   dopl( 'Account Created.');
  End New_Acc;
    
   -- Procedure Body for to deposit amount
  Procedure Credit( p_accno bank_mas.accno%type,  -- sbi1
  	            p_tAmount Bank_trans.Tamount%type) -- 100
			is
  Begin  
    Update Bank_mas set Balance = Balance + p_Tamount
		where Accno = p_accno;
   dopl('Amount Credited.');
  End Credit;
 
  -- Procedure Body for to Deposit amount
  Procedure Debit( p_accno bank_mas.accno%type,
		   p_tAmount Bank_trans.Tamount%type)
			is
  Begin
    Update bank_mas set Balance = Balance - p_Tamount
		where Accno = p_Accno;
    dopl('Amount Debited.');
  End Debit;

 -- Procedure spec. for to Transfer amount
  Procedure Trans_Amt( p_Saccno bank_trans.saccno%type,
		    p_Daccno bank_trans.Daccno%type,
		    p_tAmount Bank_trans.Tamount%type)
			is
  Begin
    debit( p_saccno, p_Tamount);
    credit( p_daccno, p_tamount);
    dopl('Amount transfer');
  End trans_amt;

  --function for to check account Balance by using Accno

  Function chk_bal(p_Accno Bank_mas.Accno%type) 
					return Number
			is
   V_BAL bank_mas.Accno%type;
  Begin
   Select Balance into v_bal from Bank_mas
			where Accno = p_Accno;
   return( v_bal );
  End chk_bal;

    --function for to check account Balance by using Mobileno

  Function chk_bal(p_Mobileno Bank_mas.Mobileno%type) 
					return Number
			is
   V_BAL bank_mas.balance%type;
  Begin
   Select Balance into v_bal from Bank_mas
			where Mobileno = p_mobileno;
   return( v_bal );
  End chk_bal;

-- Procedure Body to generate Mini statement
  Procedure mini_stat( p_Saccno Bank_Trans.Saccno%type)
			is
   cursor mini_cur is 
   select * from bank_trans where rownum<=
    ( select count(*) from bank_trans
           where Saccno=p_Saccno)
      and Saccno=p_Saccno
          minus
  select * from bank_trans where rownum<=
    ( select count(*)-5 from bank_trans
          where Saccno=p_Saccno)
      and Saccno=p_Saccno;
    i mini_cur%rowtype;
 Begin
  open mini_cur;
  loop
   fetch mini_cur into i;
   exit when mini_cur%notfound;
   dopl( mini_cur%rowcount||' '|| i.Saccno||' '||i.Tdate
        ||' '||i.ttype||' '||i.Tamount);
  End Loop;
  Close mini_cur;
 End mini_stat; 
 
  -- Procedure spec to generate Account statement
  Procedure acc_stat( p_Saccno Bank_Trans.Saccno%type,
		       Sdate date,
		       Edate Date)
			is
  Cursor acc_cur is select bm.Accno, bm.Cname, bm.Mobileno,
    bt.Tdate, bt.Ttype, bt.Tamount 
		from bank_mas bm, bank_trans bt
             		where bm.Accno = bt.Saccno
			      and
			bt.saccno = p_Saccno
			      and
	  Trunc(Tdate) between trunc(sdate) and trunc(edate);
  i acc_cur%rowtype;
 Begin
   Open acc_cur;
   Fetch acc_cur into i;
   dopl('***************************************');
   dopl( i.Accno||' '||i.Cname||' '||i.Mobileno);
   dopl('***************************************');
   While(acc_cur%found)
   Loop
    dopl(i.Tdate||' '||i.Ttype||' '||i.Tamount);
    Fetch acc_cur into i;
   End Loop;
   Close acc_cur;
 End acc_Stat;

-- procedure Body for to view account details using Accno
  Procedure view_acc( p_Accno bank_mas.Accno%type)
			is
   bm bank_mas%rowtype;
  Begin
     select * Into Bm from Bank_mas
				where accno = p_accno;
   dopl('******************************************');
   dopl(bm.accno);
   dopl(bm.Cname);
   dopl(bm.mobileno);
   dopl(bm.odate);
   dopl(bm.acc_type);
   dopl(bm.balance);
   dopl('******************************************');
  end view_acc;

  --procedure Body for to view account details using Mobileno
  Procedure view_acc( p_Mobileno bank_mas.Mobileno%type)
			is
   bm bank_mas%rowtype;
  Begin
     select * Into Bm from Bank_mas
				where Mobileno = p_Mobileno;
   dopl('******************************************');
   dopl(bm.accno);
   dopl(bm.Cname);
   dopl(bm.mobileno);
   dopl(bm.odate);
   dopl(bm.acc_type);
   dopl(bm.balance);
   dopl('******************************************');
  end view_acc;
		
  -- procedure Spec for to Update account details using Accno
   Procedure upd_acc( p_Accno bank_mas.Accno%type,
		      p_New_mobileNo bank_mas.Mobileno%type)
				is
    cnt number;
   Begin
   select count(*) into cnt from bank_mas 
			where Mobileno = p_new_mobileno;
   if cnt=1 then
     raise_application_error(-20102, 
			'Mobileno Already Registred.');
  end if;
     Update bank_mas set Mobileno = p_new_mobileno
			where Accno = p_accno;
     if sql%found then
         dopl('record updated.');
     elsif sql%notfound then
         dopl('Invalid Account No.');
     end if;
   end Upd_acc;

-- Procedure spec. for to delete account by using ACCNO.

   Procedure del_acc( p_accno bank_mas.accno%type)
			is
    Begin
      Delete from bank_mas where Accno = p_Accno;
      if sql%rowcount!=0 then
         dopl('Record Deleted.');
      elsif sql%rowcount=0 then
           dopl('Record Not Found.');
      end if;
    end del_acc;
		      
  -- Procedure spec. for to delete account by using Mobileno.
   Procedure del_acc( p_Mobileno bank_mas.mobileno%type)
			is
    Begin
      Delete from bank_mas where Mobileno = p_Mobileno;
      if sql%rowcount!=0 then
         dopl('Record Deleted.');
      elsif sql%rowcount=0 then
           dopl('Record Not Found.');
      end if;
    end del_acc;            
End bank_pack;
/


--sql> Exec bank_pack.new_acc('king', 9000994005, 's', 700 );
--sql> Exec bank_pack.new_acc('scott', 9000994006, 'c',1400 );

--Trigger on BANK_TRANS table :
------------------------------
/*
Validations:
------------

  -> Tno generate automatically

  -> Saccno is mandatory 

  -> if tran. type is 'at' then Daccno is Mandatory

  -> if tran. type  is 'w','d','at' Then Saccno should be          available in Bank_master table.
  
  -> if tran.type is 'at' then Daccno should be available in      bank_mas table.

  -> minimum trans. amount rs.100/-

  -> trans. date is system date

  -> if trans. type is 'd' then no validations and balance      should be updated.

  -> if trans. type is 'w' or 'at' then first check available      balance.

  -> if customer contains sufficient balance then to allow         the transaction and balance should be updated.

  -> Trans.type accepts only 'd','w','at' only.
*/

-- Trigger :
---------
Create or replace trigger bank_trans_trig
Before Insert on bank_Trans
for each row
declare
 cnt number;
begin
 :new.tno := tno_seq.nextval;
 if :new.Saccno is null then
   raise_application_error(-20601, 'Saccno is Mandatory!!!');
 end if;
 if :new.ttype = 'at' Then
   if :new.Daccno is null then
         raise_application_error(-20602, 
			'Daccno is Mandatory!!!');
   end if;
 end if;
 if :new.ttype in( 'd','w','at') then
    select count(*) into cnt from bank_mas
			where accno = :new.Saccno;
    if cnt=0 then
       raise_application_error(-20603,'Invalid Saccno!!!');
    end if;
 end if;
 if :new.ttype = 'at' then
    select count(*) into cnt from bank_mas
			where accno = :new.Daccno;
    if cnt=0 then
       raise_application_error(-20604,'Invalid Daccno!!!');
    end if;
  end if;
  if :new.tamount <100 then
     raise_application_error(-20605,
		 'Min. Trans.Amount Rs.100/-');
 end if;
 :new.tdate := sysdate;
 if :new.ttype='d' then
     bank_pack.credit(:new.saccno, :new.tamount);
 elsif :new.ttype='w' then
  if (bank_pack.chk_bal(:new.Saccno) - :new.tamount) > 0 then
     bank_pack.debit(:new.Saccno, :new.Tamount);
  else   
   raise_application_error(-20606, 'Insufficient Balance!!');
  end if;
 elsif :new.ttype='at' then
 if (bank_pack.chk_bal(:new.Saccno) - :new.tamount) > 0 then
  bank_pack.Trans_Amt(:new.Saccno,:new.Daccno, :new.Tamount);
  else   
   raise_application_error(-20607, 'Insufficient Balance!!');
  end if;
 else
  raise_application_error(-20608,'Invalid Trans.Type!!!!');
 end if;
end;
/

--testing :
---------
 
--  ** DEPOSIT AMOUNT ***
/*
SQL> select * from bank_mas;

ACCNO      CNAME             MOBILENO ODATE     A    BALAN
---------- --------------- ---------- --------- - --------
sbi1       KING            9000994005 24-NOV-19 S        7
sbi2       SCOTT           9000994006 24-NOV-19 C       14

SQL>  insert into bank_trans( Saccno, ttype, tamount)
                  values ( 'sbi1','d',1000);
Amount Credited.

1 row created.

SQL> select * from bank_trans;

       TNO SACCNO     DACCNO     TDATE     TT    TAMOUNT
---------- ---------- ---------- --------- -- ----------
         1 sbi1                  24-NOV-19 d        1000

SQL> select * from bank_mas;

ACCNO      CNAME             MOBILENO ODATE     A    BALAN
---------- --------------- ---------- --------- - --------
sbi1       KING            9000994005 24-NOV-19 S       17
sbi2       SCOTT           9000994006 24-NOV-19 C       14

*** WITHDRAW AMOUNT ***

SQL>  insert into bank_trans( Saccno, ttype, tamount)
                 values ( 'sbi1','w',200);
Amount Debited.

1 row created.

SQL> select * from bank_trans;

       TNO SACCNO     DACCNO     TDATE     TT    TAMOUNT
---------- ---------- ---------- --------- -- ----------
         1 sbi1                  24-NOV-19 d        1000
         2 sbi1                  24-NOV-19 w         200

SQL> select * from bank_mas;

ACCNO      CNAME             MOBILENO ODATE     A    BALAN
---------- --------------- ---------- --------- - --------
sbi1       KING            9000994005 24-NOV-19 S       15
sbi2       SCOTT           9000994006 24-NOV-19 C       14

*** Amount Transfer ***

SQL> insert into bank_trans( Saccno, Daccno, ttype, tamoun
  2                   values ( 'sbi1','sbi2','at',500);
Amount Debited.
Amount Credited.
Amount transfer

1 row created.

SQL> select * from bank_trans;

       TNO SACCNO     DACCNO     TDATE     TT    TAMOUNT
---------- ---------- ---------- --------- -- ----------
         1 sbi1                  24-NOV-19 d        1000
         2 sbi1                  24-NOV-19 w         200
         3 sbi1       sbi2       24-NOV-19 at        500

SQL> select *from bank_mas;

ACCNO      CNAME             MOBILENO ODATE     A    BALAN
---------- --------------- ---------- --------- - --------
sbi1       KING            9000994005 24-NOV-19 S       10
sbi2       SCOTT           9000994006 24-NOV-19 C       19

*** invalid data ***

SQL> insert into bank_trans( Saccno, ttype, tamount)
                   values ( 'sbi1','d',50);
insert into bank_trans( Saccno, ttype, tamount)
            *
ERROR at line 1:
ORA-20605: Min. Trans.Amount Rs.100/-
ORA-06512: at "BANK_DB.BANK_TRANS_TRIG", line 29
ORA-04088: error during execution of trigger 'BANK_DB.BANK


SQL> insert into bank_trans( Saccno, ttype, tamount)
                   values ( 'sbi1','w',1200);
insert into bank_trans( Saccno, ttype, tamount)
            *
ERROR at line 1:
ORA-20606: Insufficient Balance!!
ORA-06512: at "BANK_DB.BANK_TRANS_TRIG", line 39
ORA-04088: error during execution of trigger 'BANK_DB.BANK


SQL> insert into bank_trans( Saccno, ttype, tamount)
                    values ( 'sbi1','at',1200);
insert into bank_trans( Saccno, ttype, tamount)
            *
ERROR at line 1:
ORA-20602: Daccno is Mandatory!!!
ORA-06512: at "BANK_DB.BANK_TRANS_TRIG", line 10
ORA-04088: error during execution of trigger 'BANK_DB.BANK

*/

SQL> insert into bank_trans( Saccno, ttype, tamount)
                  values ( 'sbi1','x',1200);
insert into bank_trans( Saccno, ttype, tamount)
            *
ERROR at line 1:
ORA-20608: Invalid Trans.Type!!!!
ORA-06512: at "BANK_DB.BANK_TRANS_TRIG", line 48
ORA-04088: error during execution of trigger 'BANK_DB.BANK

